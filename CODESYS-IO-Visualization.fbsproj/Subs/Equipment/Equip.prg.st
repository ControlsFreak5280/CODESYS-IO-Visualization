__METADATA__
{
  "v3Meta": {
    "objectGuid": "bc728d1a-77b5-44f4-ad4d-4b1530a1873f",
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
PROGRAM Equip

VAR_IN_OUT
	Data: Equip_UDT;
END_VAR

VAR
	i: INT;
END_VAR
__IMPLEMENTATION__
// Enable Persist Storage
IF (Data.PersistSize = 0) THEN
	Data.PersistSize := SIZEOF(Equip_UDT);
END_IF;

// Clear Common Alarm Flags
Data.NotReadyActive := FALSE;
Data.InterlockActive := FALSE;
Data.FailureActive := FALSE;
Data.WarningActive := FALSE;
Data.TimerActive := FALSE;

//Alarms
AlarmDigital(alarm := Data.OOS);

Data.MaxSeverity := 0;
Data.AlarmLevel := 0;

FOR i := 0 TO 9 DO
	Data.Failure[i].Reset := Data.HMI.Reset;
	Data.Failure[i].OOS := Data.OOS.Active;
	AlarmDigital(alarm := Data.Failure[i]);
	IF (Data.Failure[i].Active) THEN
		Data.FailureActive := TRUE;
	END_IF;
	
	IF (Data.Failure[i].Severity > Data.MaxSeverity) THEN
		Data.MaxSeverity := Data.Failure[i].Severity;
	END_IF;
	
	IF (Data.Failure[i].AlarmLevel > 0) THEN
		IF (Data.AlarmLevel = 0) OR (Data.Failure[i].AlarmLevel < Data.AlarmLevel) THEN
			Data.AlarmLevel := Data.Failure[i].AlarmLevel;
		END_IF;
	END_IF;
	
	
	Data.Interlock[i].Reset := Data.HMI.Reset;
	Data.Interlock[i].OOS := Data.OOS.Active;
	AlarmDigital(alarm := Data.Interlock[i]);
	IF (Data.Interlock[i].Active) THEN
		Data.InterlockActive := TRUE;
	END_IF;
	
	IF (Data.Interlock[i].Severity > Data.MaxSeverity) THEN
		Data.MaxSeverity := Data.Interlock[i].Severity;
	END_IF;
	
	IF (Data.Interlock[i].AlarmLevel > 0) THEN
		IF (Data.AlarmLevel = 0) OR (Data.Interlock[i].AlarmLevel < Data.AlarmLevel) THEN
			Data.AlarmLevel := Data.Interlock[i].AlarmLevel;
		END_IF;
	END_IF;
	

	Data.NotReady[i].Reset := Data.HMI.Reset;
	Data.NotReady[i].OOS := Data.OOS.Active;
	AlarmDigital(alarm := Data.NotReady[i]);
	IF (Data.NotReady[i].Active) THEN
		Data.NotReadyActive := TRUE;
	END_IF;

	IF (Data.NotReady[i].Severity > Data.MaxSeverity) THEN
		Data.MaxSeverity := Data.NotReady[i].Severity;
	END_IF;
	
	IF (Data.NotReady[i].AlarmLevel > 0) THEN
		IF (Data.AlarmLevel = 0) OR (Data.NotReady[i].AlarmLevel < Data.AlarmLevel) THEN
			Data.AlarmLevel := Data.NotReady[i].AlarmLevel;
		END_IF;
	END_IF;
	

	Data.Warning[i].Reset := Data.HMI.Reset;
	Data.Warning[i].OOS := Data.OOS.Active;
	AlarmDigital(alarm := Data.Warning[i]);
	IF (Data.Warning[i].Active) THEN
		Data.WarningActive := TRUE;
	END_IF;
	
	IF (Data.Warning[i].Severity > Data.MaxSeverity) THEN
		Data.MaxSeverity := Data.Warning[i].Severity;
	END_IF;
	
	IF (Data.Warning[i].AlarmLevel > 0) THEN
		IF (Data.AlarmLevel = 0) OR (Data.Warning[i].AlarmLevel < Data.AlarmLevel) THEN
			Data.AlarmLevel := Data.Warning[i].AlarmLevel;
		END_IF;
	END_IF;
	

	IF (Data.Timer0[i].On) THEN
		Data.TimerActive := TRUE;
	END_IF;
END_FOR;

Data.ResetTimer.In := Data.HMI.Reset OR Data.PLC.Reset;
Timer(TimerData := Data.ResetTimer);

IF (Data.ResetTimer.Q) THEN
	Data.HMI.Reset := FALSE;
	Data.PLC.Reset := FALSE;
END_IF;

//Set Equipment Stats
Data.Stats.StatInput := Data.Running OR Data.Opened OR (NOT Data.Closed);
Data.Stats.OOSInput := Data.OOS.Active;
Data.Stats.AvailalbeInput := (NOT Data.NotReadyActive) AND (NOT Data.FailureActive) AND (NOT Data.InterlockActive) AND (NOT Data.OOS.Active);

Equip_Statistics(Data := Data.Stats);
