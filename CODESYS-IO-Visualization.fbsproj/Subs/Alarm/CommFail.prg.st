__METADATA__
{
  "v3Meta": {
    "objectGuid": "06f848a0-00f8-4452-893f-ed150e95a100",
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
PROGRAM CommFail
VAR_IN_OUT
	Data: CommFail_UDT;
END_VAR

VAR
	AlarmIn: BOOL;
END_VAR
__IMPLEMENTATION__
AlarmIn := (Data.MonitorValue = Data.LastValue);

Data.Alarm.Value := AlarmIn;
Data.Alarm.OnTimer.PT := Data.Delay;
AlarmDigital(alarm := Data.Alarm);

Data.LastValue := Data.MonitorValue;
