__METADATA__
{
  "v3Meta": {
    "objectGuid": "415ad30a-78fb-4fcd-9821-40f21d9d7c4d",
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
FUNCTION DateTimeStampToString : WSTRING

VAR_INPUT
	DateTimeStamp: DateTimeStamp_UDT;
END_VAR

VAR
	tempString: STRING(30);
END_VAR
__IMPLEMENTATION__
tempString := CONCAT(TO_STRING(DateTimeStamp.Year),'-');
IF(DateTimeStamp.Month < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(DateTimeStamp.Month));
tempString := CONCAT(tempString,'-');
IF(DateTimeStamp.Day < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(DateTimeStamp.Day));
tempString := CONCAT(tempString,' ');
IF(DateTimeStamp.Hour < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(DateTimeStamp.Hour));
tempString := CONCAT(tempString,':');
IF(DateTimeStamp.Minute < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(DateTimeStamp.Minute));
tempString := CONCAT(tempString,':');
IF(DateTimeStamp.Second < 10) THEN
	tempString := CONCAT(tempString,'0');
END_IF;
tempString := CONCAT(tempString,TO_STRING(DateTimeStamp.Second));

DateTimeStampToString := TO_WSTRING(tempString);
