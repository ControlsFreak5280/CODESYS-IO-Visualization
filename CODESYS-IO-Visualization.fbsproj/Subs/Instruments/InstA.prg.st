__METADATA__
{
  "v3Meta": {
    "objectGuid": "4f928ad3-0941-4bfa-9235-d6fbda1404ae",
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
PROGRAM InstA

VAR_IN_OUT
	Data: InstA_UDT;
END_VAR

VAR
END_VAR
__IMPLEMENTATION__
// Enable Persist Storage
IF (Data.PersistSize = 0) THEN
	Data.PersistSize := SIZEOF(InstA_UDT);
END_IF;

// Run Value Timer to record 1 second data into a buffer
Data.ValueTimer.In := (NOT Data.ValueTimer.Q);
Timer(TimerData := Data.ValueTimer);

// Handle Manual
CASE Data.Mode OF
	0:	// Online Mode
		Data.TempVal := Data.RawVal;
		Data.CurVal.ClampActive := FALSE;

		IF (Data.CurVal.ClampLowEnable AND (Data.RawVal <= Data.CurVal.ClampLow)) THEN
			Data.TempVal := Data.CurVal.LowRange;
			Data.CurVal.ClampActive := TRUE;
		END_IF;
		
		IF (Data.CurVal.ClampHighEnable AND (Data.RawVal >= Data.CurVal.ClampHigh)) THEN
			Data.TempVal := Data.CurVal.HighRange;
			Data.CurVal.ClampActive := TRUE;
		END_IF;

		Data.ManualValue := Data.RawVal;
		
		Data.StatusCode := Data.RawValStatusCode;

		IF (Data.CurVal.ClampActive) THEN
			Data.StatusCode := 129;
		END_IF;
		
ELSE	// Manual Mode
	Data.TempVal := Data.ManualValue;
	Data.StatusCode := 253;
END_CASE;

// Record the 1 second data into the Value Buffer
IF (Data.ValueCount < 0) THEN
	Data.ValueCount := 0;
END_IF;

IF (Data.ValueTimer.Q) THEN
	Data.ValueCount := Data.ValueCount + 1;
	IF (Data.ValueCount >= 60) THEN
		Data.ValueCount := 60;
	END_IF;
	
	IF (Data.ValueCount > 1) THEN
		FOR Data.i := (Data.ValueCount - 2) TO 0 BY -1 DO
			Data.ValueBuffer[Data.i + 1] := Data.ValueBuffer[Data.i];
		END_FOR;
		Data.ValueBuffer[0] := Data.TempVal;
	ELSE
		Data.ValueBuffer[0] := Data.TempVal;
	END_IF;
END_IF;

// Set the Avg Value
IF (Data.ValueCount > 1) THEN
	IF (Data.TempVal < Data.CurVal.ValueMin) THEN
		Data.CurVal.ValueMin := Data.TempVal;
	END_IF;
	
	IF (Data.TempVal > Data.CurVal.ValueMax) THEN
		Data.CurVal.ValueMax := Data.TempVal;
	END_IF;

	Data.ValueSum := 0.0;
	FOR Data.i := 0 TO (Data.ValueCount - 1) DO
		Data.ValueSum := Data.ValueSum + Data.ValueBuffer[Data.i];
	END_FOR;
	
	// Set the ValueStatus - 0 = Stale, 1 = Decreasing, 2 = Increasing
	Data.CurVal.ValueStatusDly.In := NOT Data.CurVal.ValueStatusDly.Q;
	Timer(TimerData := Data.CurVal.ValueStatusDly);
	
	IF (Data.CurVal.ValueStatusDly.Q) THEN
		Data.CurVal.ValueAvgPrev := Data.CurVal.ValueAvg;
		IF (Data.ValueBuffer[0] > Data.ValueBuffer[Data.ValueCount - 1]) THEN
			Data.CurVal.ValueStatus := 2;
		END_IF;
		IF (Data.ValueBuffer[0] < Data.ValueBuffer[Data.ValueCount - 1]) THEN
			Data.CurVal.ValueStatus := 1;
		END_IF;
	END_IF;

	// Set the current Average Value
	Data.CurVal.ValueAvg := Data.ValueSum / Data.ValueCount;

// 	IF (Data.CurVal.ValueAvg > Data.CurVal.ValueAvgPrev) THEN
// 		Data.CurVal.ValueStatus := 2;
// 	END_IF;
// 	IF (Data.CurVal.ValueAvg < Data.CurVal.ValueAvgPrev) THEN
// 		Data.CurVal.ValueStatus := 1;
// 	END_IF;
ELSE
	Data.CurVal.ValueAvg := Data.TempVal;
	Data.CurVal.ValueAvgPrev := Data.TempVal;
	Data.CurVal.ValueStatus := 0;
END_IF;

// Set the Percent Value
IF (Data.CurVal.HighRange - Data.CurVal.LowRange) > 0.0 THEN
	Data.CurVal.ValuePct := (Data.CurVal.Value - Data.CurVal.ClampLow) / (Data.CurVal.HighRange - Data.CurVal.LowRange);
ELSE
	Data.CurVal.ValuePct := 0.0;
END_IF

// Reset the Min and Max Values
IF (Data.CurVal.Reset) THEN
	Data.CurVal.ValueMin := Data.TempVal;
	Data.CurVal.ValueMax := Data.TempVal;
	Data.CurVal.Reset := FALSE;
END_IF;

// Set the output values with scaling
IF (Data.DeviceFail.Active) THEN
	CASE Data.FailAction OF
		0: Data.CurVal.Value := Data.FailValue;
		1: Data.CurVal.Value := Data.CurVal.Value;
	ELSE
		Data.CurVal.Value := Data.TempVal;
	END_CASE;	
ELSE
	Data.CurVal.Value := Data.TempVal;
END_IF;

// CurVal2 Calculation
InstA_SecondaryValue(Value := Data.CurVal.Value, Data := Data.CurVal2);

// CurVal3 Calculation
InstA_SecondaryValue(Value := Data.CurVal.Value, Data := Data.CurVal3);

// Stale Value
IF (Data.Stale.Enable) THEN
	Data.Stale.StaleTimer.In := (Data.CurVal.Value = Data.Stale.PrevValue);
	Timer(TimerData := Data.Stale.StaleTimer);
	Data.Stale.Detected := Data.Stale.StaleTimer.Q;
	Data.Stale.PrevValue := Data.CurVal.Value;	
ELSE
	Data.Stale.Detected := FALSE;
END_IF;

IF (Data.Stale.Detected) THEN
	Data.CurVal.ValueStatus := 0;
	Data.StatusCode := 130;
END_IF;

// Set GlobalStatusCode and String
CASE Data.StatusCode OF
	128: Data.GlobalStatusString := "OK";
	129: Data.GlobalStatusString := "Clamp Active";
	130: Data.GlobalStatusString := "Stale Value";
	253: Data.GlobalStatusString := "Manual Mode";
ELSE
	IF (Data.StatusCode < 128) OR ((Data.StatusCode > 128) AND (Data.StatusCode < 256)) THEN
		Data.GlobalStatusString := "Warning";
	END_IF;
	
	IF (Data.StatusCode > 255) THEN
		Data.GlobalStatusString := "Failed";
	END_IF;
END_CASE;

Data.GlobalStatusCode := Data.StatusCode + 65536;

AlarmDigital(alarm := Data.OOS);

// Set the input to the Alarms
Data.HiHi.Value := Data.CurVal.Value;
Data.HiHi.OOS := data.OOS.Active;

Data.Hi.Value := Data.CurVal.Value;
Data.Hi.OOS := data.OOS.Active;

Data.Mid2.Value := Data.CurVal.Value;
Data.Mid2.OOS := data.OOS.Active;

Data.Mid1.Value := Data.CurVal.Value;
Data.Mid1.OOS := data.OOS.Active;

Data.Lo.Value := Data.CurVal.Value;
Data.Lo.OOS := data.OOS.Active;

Data.LoLo.Value := Data.CurVal.Value;
Data.LoLo.OOS := data.OOS.Active;

Data.SpDeviation.Value := ABS(Data.HMISP - Data.CurVal.Value);
Data.SpDeviation.OOS := data.OOS.Active;

Data.DeviceFail.OOS := Data.OOS.Active;

Data.DeviceWarning.OOS := Data.OOS.Active;

// Set the Alarm Display Names
Data.DeviceFail.DisplayName := "Fail";
Data.DeviceWarning.DisplayName := "Warning";
Data.HiHi.DisplayName := "HiHi";
Data.Hi.DisplayName := "Hi";
Data.Mid2.DisplayName := "Mid2";
Data.Mid1.DisplayName := "Mid1";
Data.Lo.DisplayName := "Lo";
Data.LoLo.DisplayName := "LoLo";
Data.SpDeviation.DisplayName := "SPDev";

// Run the Alarms
Data.DeviceFail.Value := (Data.StatusCode > 255);
Data.DeviceWarning.Value := (Data.StatusCode > 129);

AlarmDigital(alarm := Data.DeviceFail);
AlarmDigital(alarm := Data.DeviceWarning);

AlarmAnalog(alarm := Data.HiHi);
AlarmAnalog(alarm := Data.Hi);
AlarmAnalog(alarm := Data.Mid2);
AlarmAnalog(alarm := Data.Mid1);
AlarmAnalog(alarm := Data.Lo);
AlarmAnalog(alarm := Data.LoLo);
AlarmAnalog(alarm := Data.SpDeviation);

// Set MaxSeverity and AlarmLevel
Data.MaxSeverity := MAX(Data.DeviceFail.Severity, MAX(Data.DeviceWarning.Severity, MAX(Data.HiHi.Severity, MAX(Data.Hi.Severity, MAX(Data.Mid2.Severity, MAX(Data.Mid1.Severity, MAX(Data.Lo.Severity, MAX(Data.LoLo.Severity, Data.SpDeviation.Severity))))))));

IF (Data.DeviceFail.AlarmLevel + Data.DeviceWarning.AlarmLevel + Data.HiHi.AlarmLevel + Data.Hi.AlarmLevel + Data.Mid2.AlarmLevel + Data.Mid1.AlarmLevel + Data.Lo.AlarmLevel + Data.LoLo.AlarmLevel + Data.SpDeviation.AlarmLevel) > 0 THEN
	Data.AlarmLevel := 6;
	
	IF (Data.DeviceFail.AlarmLevel > 0) AND (Data.DeviceFail.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.DeviceFail.AlarmLevel;
	END_IF;
	
	IF (Data.DeviceWarning.AlarmLevel > 0) AND (Data.DeviceWarning.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.DeviceWarning.AlarmLevel;
	END_IF;
	

	IF (Data.HiHi.AlarmLevel > 0) AND (Data.HiHi.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.HiHi.AlarmLevel;
	END_IF;
	
	IF (Data.Hi.AlarmLevel > 0) AND (Data.Hi.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.Hi.AlarmLevel;
	END_IF;
	
	IF (Data.Mid2.AlarmLevel > 0) AND (Data.Mid2.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.Mid2.AlarmLevel;
	END_IF;
	
	IF (Data.Mid1.AlarmLevel > 0) AND (Data.Mid1.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.Mid1.AlarmLevel;
	END_IF;
	
	IF (Data.Lo.AlarmLevel > 0) AND (Data.Lo.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.Lo.AlarmLevel;
	END_IF;
	
	IF (Data.LoLo.AlarmLevel > 0) AND (Data.LoLo.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.LoLo.AlarmLevel;
	END_IF;
	

	IF (Data.SpDeviation.AlarmLevel > 0) AND (Data.SpDeviation.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.SpDeviation.AlarmLevel;
	END_IF;
ELSE
	Data.AlarmLevel := 0;
END_IF;

// Accumulators
Data.Accum_InUse := FALSE;
FOR Data.i := 0 TO 4 DO
	Data.Accum[Data.i].ValueIn_Realtime := Data.CurVal.Value;
	Data.Accum[Data.i].EU_Realtime := Data.CurVal.EU;
	Data.Accum[Data.i].ValueIn_Total := Data.RawVal_Total;
	Data.Accum[Data.i].PauseInternal := (Data.DeviceFail.Active);
	Accum(Data := Data.Accum[Data.i]);
	
	IF (Data.Accum[Data.i].Enable) THEN
		Data.Accum_InUse := TRUE;
	END_IF;
END_FOR;
