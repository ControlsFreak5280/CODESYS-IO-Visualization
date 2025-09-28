__METADATA__
{
  "v3Meta": {
    "objectGuid": "afb1cf0d-a30e-4089-a4ac-73b2312fed52",
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
PROGRAM ClockToString

VAR_INPUT
	Clock: PLCClock_UDT;
END_VAR

VAR_OUTPUT
	ClockString: WSTRING(30);
END_VAR

VAR
	tempString: STRING(30);
END_VAR
__IMPLEMENTATION__
tempString := CONCAT(TO_STRING(Clock.Year),'-');
IF(Clock.Month < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(Clock.Month));
tempString := CONCAT(tempString,'-');
IF(Clock.Day < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(Clock.Day));
tempString := CONCAT(tempString,' ');
IF(Clock.Hour < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(Clock.Hour));
tempString := CONCAT(tempString,':');
IF(Clock.Minute < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(Clock.Minute));
tempString := CONCAT(tempString,':');
IF(Clock.Second < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(Clock.Second));
ClockString := TO_WSTRING(tempString);
