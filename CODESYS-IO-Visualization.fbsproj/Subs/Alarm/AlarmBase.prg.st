__METADATA__
{
  "v3Meta": {
    "objectGuid": "444836e5-2b9d-407e-a84f-55214fca9e70",
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
PROGRAM AlarmBase

VAR_IN_OUT
	alarm: AlarmBase_UDT;
END_VAR
__IMPLEMENTATION__
IF (alarm.Enable AND (NOT alarm.InUse)) THEN
	alarm.InUse := TRUE;
END_IF;

IF (alarm.ResetCount) THEN
	alarm.Count := UDINT#0;
	alarm.InCount := UDINT#0;
	alarm.ResetCount := FALSE;
END_IF;

alarm.Restart := FALSE;

IF (alarm.OnTiming AND (NOT alarm.OnTimer.In) AND alarm.Enable AND (NOT alarm.Active) AND (NOT alarm.OOS)) THEN
	alarm.InCount := alarm.InCount + UDINT#1;
END_IF;

alarm.OnTimer.In := alarm.OnTiming;
Timer(TimerData := alarm.OnTimer);

IF (alarm.OnTimer.Q AND (NOT alarm.Active) AND alarm.Enable AND (NOT alarm.OOS)) THEN
	alarm.ActiveTime := Lib_GVL.ClockLocal.PLCTimeString;
	alarm.Count := alarm.Count + UDINT#1;
	alarm.OnTiming := FALSE;
	alarm.Active := TRUE;
END_IF;

alarm.OffTimer.In := alarm.OffTiming;
Timer(TimerData := alarm.OffTimer);

IF (alarm.EnableLatch) THEN
	IF (alarm.Reset AND alarm.OffTiming AND alarm.Active) THEN
		alarm.OffTiming := FALSE;
		alarm.Active := FALSE;
		alarm.Reset := FALSE;
	END_IF;
ELSE
	IF (alarm.OffTimer.Q AND alarm.Active) THEN
		alarm.OffTiming := FALSE;
		alarm.Active := FALSE;
	END_IF;

	IF (alarm.Reset) THEN
		alarm.Reset := FALSE;
	END_IF;
END_IF;

IF (alarm.Reset AND (NOT alarm.Active)) THEN
	alarm.Reset := FALSE;
END_IF;

alarm.Alarm := (alarm.Active AND alarm.EnableAlarm);

// Set Alarm Level based on severity
IF alarm.Alarm THEN
	CASE alarm.Severity OF
		Lib_GVL.Alarm_Level1_Min...Lib_GVL.Alarm_Level1_Max:
			alarm.AlarmLevel := 1;
		Lib_GVL.Alarm_Level2_Min...Lib_GVL.Alarm_Level2_Max:
			alarm.AlarmLevel := 2;
		Lib_GVL.Alarm_Level3_Min...Lib_GVL.Alarm_Level3_Max:
			alarm.AlarmLevel := 3;
		Lib_GVL.Alarm_Level4_Min...Lib_GVL.Alarm_Level4_Max:
			alarm.AlarmLevel := 4;
		Lib_GVL.Alarm_Level5_Min...Lib_GVL.Alarm_Level5_Max:
			alarm.AlarmLevel := 5;
		Lib_GVL.Alarm_Level6_Min...Lib_GVL.Alarm_Level6_Max:
			alarm.AlarmLevel := 6;
	ELSE
		alarm.AlarmLevel := 0;
	END_CASE;
ELSE
	alarm.AlarmLevel := 0;
END_IF;
