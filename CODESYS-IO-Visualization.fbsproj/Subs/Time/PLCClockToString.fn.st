__METADATA__
{
  "v3Meta": {
    "objectGuid": "2c2237b6-abec-4d4a-8cb3-ba7c5d7a31ba",
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
FUNCTION PLCClockToString : STRING
VAR_INPUT
	Clock: PLCClock_UDT;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
PLCClockToString := CONCAT(TO_STRING(Clock.Year),'-');
IF(Clock.Month < 10) THEN
	PLCClockToString := CONCAT(PLCClockToString,'0');
END_IF;
PLCClockToString := CONCAT(PLCClockToString,TO_STRING(Clock.Month));
PLCClockToString := CONCAT(PLCClockToString,'-');
IF(Clock.Day < 10) THEN
	PLCClockToString := CONCAT(PLCClockToString,'0');
END_IF;
PLCClockToString := CONCAT(PLCClockToString,TO_STRING(Clock.Day));
PLCClockToString := CONCAT(PLCClockToString,' ');
IF(Clock.Hour < 10) THEN
	PLCClockToString := CONCAT(PLCClockToString,'0');
END_IF;
PLCClockToString := CONCAT(PLCClockToString,TO_STRING(Clock.Hour));
PLCClockToString := CONCAT(PLCClockToString,':');
IF(Clock.Minute < 10) THEN
	PLCClockToString := CONCAT(PLCClockToString,'0');
END_IF;
PLCClockToString := CONCAT(PLCClockToString,TO_STRING(Clock.Minute));
PLCClockToString := CONCAT(PLCClockToString,':');
IF(Clock.Second < 10) THEN
	PLCClockToString := CONCAT(PLCClockToString,'0');
END_IF;
PLCClockToString := CONCAT(PLCClockToString,TO_STRING(Clock.Second));
