__METADATA__
{
  "v3Meta": {
    "objectGuid": "45046a4f-a6db-40c6-adee-b8be2d926399",
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
PROGRAM GetDateYear

VAR_INPUT
	Clock: DATE;
END_VAR

VAR_OUTPUT
	value: INT;
END_VAR
__IMPLEMENTATION__
value := DWORD_TO_INT((DATE_TO_DWORD(Clock) + 43200) / 31557600 + 1970);
