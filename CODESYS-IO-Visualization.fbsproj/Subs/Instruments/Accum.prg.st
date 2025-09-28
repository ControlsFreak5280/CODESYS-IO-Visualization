__METADATA__
{
  "v3Meta": {
    "objectGuid": "8afc9f51-cd67-4457-aa4e-1e1c37a8f5b2",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
PROGRAM Accum

VAR_IN_OUT
	Data: Accum_UDT;
END_VAR

VAR
END_VAR
__IMPLEMENTATION__
CycleTime(value := Data.CT);
Data.SampleSeconds := Data.SampleSeconds + Data.CT.Sec;

IF (NOT Data.Enable) THEN
	Data.LastEnable := FALSE;
	RETURN;
END_IF;

IF (Data.ValueIn_Realtime < Data.ZeroLimit) THEN
	Data.ValueIn_Realtime := 0.0;
END_IF;

// Set Min / Max Values
IF (Data.ValueIn_Realtime < Data.Value[0].ValueMin) THEN
	Data.Value[0].ValueMin := Data.ValueIn_Realtime;
END_IF;

IF (Data.ValueIn_Realtime > Data.Value[0].ValueMax) THEN
	Data.Value[0].ValueMax := Data.ValueIn_Realtime;
END_IF;

// Check to see if it's time to reset the Total
CASE Data.Period OF
	0: // Manual Reset
		Data.ResetInProcess := Data.Reset OR Data.ResetInternal;
	1: // Hourly
		Data.ResetInProcess := (((Lib_GVL.ClockLocal.Minute = Data.RollMinute) AND (Lib_GVL.ClockLocal.Second < 5)) OR Data.Reset);
	2: // Daily
		Data.ResetInProcess := (((Lib_GVL.ClockLocal.Hour = Data.RollHour) AND (Lib_GVL.ClockLocal.Minute = Data.RollMinute) AND (Lib_GVL.ClockLocal.Second < 5)) OR Data.Reset);
	3: // Monthly
		Data.ResetInProcess := (((Lib_GVL.ClockLocal.Day = Data.RollDay) AND (Lib_GVL.ClockLocal.Hour = Data.RollHour) AND (Lib_GVL.ClockLocal.Minute = Data.RollMinute) AND (Lib_GVL.ClockLocal.Second < 5)) OR Data.Reset);
	4: // Yearly
		Data.ResetInProcess := (((Lib_GVL.ClockLocal.Month = Data.RollMonth) AND (Lib_GVL.ClockLocal.Day = Data.RollDay) AND (Lib_GVL.ClockLocal.Hour = Data.RollHour) AND (Lib_GVL.ClockLocal.Minute = Data.RollMinute) AND (Lib_GVL.ClockLocal.Second < 5)) OR Data.Reset);
END_CASE;

Data.ResetAccumulator := Data.ResetInProcess;

IF (Data.ResetInProcess) THEN	// Always Accum if we are about to reset.
	Data.DoAccum := (Data.SampleSeconds > 0.0);
ELSE  // Only totalize so oftem to limit math errors.  If time change is too big, don't accum this likely means the system clock was updated, just skip it.
	IF (Data.SampleSeconds > (Data.TotalizeInterval * 5)) THEN
		Data.SampleSeconds := 0.0;
	END_IF;
	Data.DoAccum := (Data.SampleSeconds > 0.0) AND (Data.SampleSeconds >= Data.TotalizeInterval) AND (Data.SampleSeconds < (Data.TotalizeInterval * 5));
END_IF;

// Do the Accumulation
IF (Data.DoAccum) THEN
	IF (Data.PauseInternal OR Data.Pause) THEN
		Data.TempAccum := 0.0;
	ELSE
		CASE Data.Mode OF
			0:  // Realtime Value
				Data.TempAccum := Data.ValueIn_Realtime * Data.Gain * (Data.SampleSeconds / Data.Timebase);
			1:  // Reading totalized value that does not reset
				Data.TempAccum := (Data.ValueIn_Total - Data.PrevTotal) * Data.Gain;
			2:  // Reading totalized value that is reset at the device
				Data.TempAccum := Data.ValueIn_Total * Data.Gain;
		ELSE 
			Data.TempAccum := 0.0;
		END_CASE;
	END_IF;
	
	Data.PrevTotal := Data.Value[0].Total;
	Data.SampleSeconds := 0.0;
	Data.Value[0].EndTime := Lib_GVL.ClockLocal;

	CASE Data.Mode OF
		0, 1:  // Realtime Value or Totalized value that does not reset
			IF (ABS(Data.TempAccum) < Data.MaxTotalChange) THEN
				Data.Value[0].Total := Data.Value[0].Total + Data.TempAccum;
			END_IF;
		2:  // Reading totalized value that is reset at the device
			Data.Value[0].Total := Data.TempAccum;
	END_CASE;
END_IF;

// Target Met
Data.TargetMet := (Data.Value[0].Total >= Data.Target);

// Reset the Accumulator
IF (Data.ResetInProcess AND (NOT Data.ResetComplete)) THEN
	FOR Data.i := 8 TO 0 BY -1 DO
		Data.Value[Data.i + 1] := Data.Value[Data.i];
	END_FOR;
	
	Data.Value[0].ValueMin := Data.ValueIn_Realtime;
	Data.Value[0].ValueMax := Data.ValueIn_Realtime;
	Data.Value[0].Total := 0.0;
	Data.Value[0].EndTime := Lib_GVL.ClockLocal;
	
	Data.ResetTime := Lib_GVL.ClockLocal.PLCTimeString;
	Data.ResetComplete := TRUE;
	Data.Reset := FALSE;
END_IF;

IF (NOT Data.ResetInProcess) THEN
	Data.ResetComplete := FALSE;
END_IF
