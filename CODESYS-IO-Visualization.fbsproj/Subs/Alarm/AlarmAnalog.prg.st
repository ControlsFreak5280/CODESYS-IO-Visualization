__METADATA__
{
  "v3Meta": {
    "objectGuid": "fa117091-b950-4ead-bb5d-e143e63cb533",
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
PROGRAM AlarmAnalog

VAR_IN_OUT
	alarm: AlarmAnalog_UDT;
END_VAR
__IMPLEMENTATION__
IF (alarm.Restart AND alarm.Active) THEN
	alarm.OnTiming := FALSE;
	alarm.OffTiming := FALSE;
	alarm.Active := FALSE;
	alarm.Alarm := FALSE;
ELSE
	IF (NOT alarm.Enable) OR alarm.OOS THEN
		alarm.OnTiming := FALSE;
		alarm.OffTiming := FALSE;
		IF (alarm.Active) THEN
			alarm.Active := FALSE;
		END_IF;
		IF (alarm.Alarm) THEN
			alarm.Alarm := FALSE;
		END_IF;
	ELSE
		IF (alarm.Rising) THEN
			IF (alarm.Active) THEN
				alarm.OffTiming := (alarm.Value < (alarm.Setpoint - alarm.Deadband));
				alarm.OnTiming := FALSE;
			ELSE
				alarm.OnTiming := (alarm.Value > alarm.Setpoint);
				alarm.OffTiming := FALSE;
			END_IF;
		ELSE
			IF (alarm.Active) THEN
				alarm.OffTiming := (alarm.Value > (alarm.Setpoint + alarm.Deadband));
				alarm.OnTiming := FALSE;
			ELSE
				alarm.OnTiming := (alarm.Value < alarm.Setpoint);
				alarm.OffTiming := FALSE;
			END_IF;
		END_IF;
	END_IF;
END_IF;

AlarmBase(alarm := alarm);

