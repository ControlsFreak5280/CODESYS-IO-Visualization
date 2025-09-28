__METADATA__
{
  "v3Meta": {
    "objectGuid": "3be2537b-3a38-49da-944c-8cf5eee6bc93",
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
PROGRAM IO_StatusCodeToString

VAR_IN_OUT
	Data: Channel_UDT;
END_VAR
__IMPLEMENTATION__
Data.StatusCode := WORD_TO_DINT(Data.ValueStatus);

IF (Data.ValueStatus = 0) THEN
	Data.StatusString := "";
	RETURN;
END_IF;

IF (Data.ValueStatus.0) THEN
	Data.StatusString := "Out of Range";
ELSE
	Data.StatusString := "Failed";
END_IF;
