__METADATA__
{
  "v3Meta": {
    "objectGuid": "5f7f85fb-a7bf-448e-9943-c735f91937e1",
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
PROGRAM BitCount

VAR_INPUT
	value: DWORD;
END_VAR

VAR_OUTPUT
	Count: INT;
END_VAR
__IMPLEMENTATION__
WHILE value > 0 DO
	IF (value.0) THEN
		Count := Count + 1;
	END_IF;
	value := SHR(value,1);
END_WHILE;
