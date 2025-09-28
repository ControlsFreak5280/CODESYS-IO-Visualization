__METADATA__
{
  "v3Meta": {
    "objectGuid": "d09e4645-0129-44fb-b7a9-b5c01bfa5e9c",
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
PROGRAM GetDayOfWeek

VAR_INPUT
	Clock: DATE;
END_VAR

VAR_OUTPUT
	value: INT;
END_VAR

// Monday = 1 ... Sunday = 7
__IMPLEMENTATION__
value := DWORD_TO_INT((DATE_TO_DWORD(Clock) / 86400 + 3) MOD 7) + 1;
