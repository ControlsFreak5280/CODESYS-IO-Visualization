__METADATA__
{
  "v3Meta": {
    "objectGuid": "347d7615-1746-404a-b595-1cc33142b250",
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
PROGRAM GetDayOfYear

VAR_INPUT
	Clock: DATE;
END_VAR

VAR_OUTPUT
	value: INT;
END_VAR
__IMPLEMENTATION__
value := UDINT_TO_INT((DATE_TO_UDINT(Clock) / UDINT#86400) MOD UDINT#1461);
IF value > 729 THEN
	IF value > 1095 THEN 
		value := value - 1095;
	ELSE 
		value := value - 729;
	END_IF;
ELSIF value > 364 THEN
	value := value - 364;
ELSE
	value := value + 1;
END_IF;
