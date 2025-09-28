__METADATA__
{
  "v3Meta": {
    "objectGuid": "fdcb4fa2-d58f-4bcf-ad54-8db7124a02fb",
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
PROGRAM GetDateMonth

VAR_INPUT
	Clock: DATE;
END_VAR

VAR_OUTPUT
	value: INT;
END_VAR

VAR
	leap: BOOL;
END_VAR
__IMPLEMENTATION__
GetDayOfYear(Clock := Clock, value => value);

GetDateLeapYear(Clock := Clock, value => leap);

IF value < 32 THEN
	value := 1;
ELSIF leap THEN
	value := (value * 53 + 1668) / 1623;
ELSE
	value := (value * 53 + 1700) / 1620;
END_IF;
