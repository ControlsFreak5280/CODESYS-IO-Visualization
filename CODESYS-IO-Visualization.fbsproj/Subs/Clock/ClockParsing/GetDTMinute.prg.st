__METADATA__
{
  "v3Meta": {
    "objectGuid": "a6433b2d-02e8-4dfa-b573-4a8d0c8ac64b",
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
PROGRAM GetDTMinute

VAR_INPUT
	Clock: DT;
END_VAR

VAR_OUTPUT
	value: INT;
END_VAR
__IMPLEMENTATION__
value := DWORD_TO_INT(DT_TO_DWORD(Clock) MOD 3600) / 60;
