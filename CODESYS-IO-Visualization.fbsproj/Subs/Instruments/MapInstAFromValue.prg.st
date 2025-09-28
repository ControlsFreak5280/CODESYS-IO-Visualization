__METADATA__
{
  "v3Meta": {
    "objectGuid": "522a99de-e70b-4df1-8092-f6ff34d39439",
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
PROGRAM MapInstAFromValue
VAR_IN_OUT
	Data: InstA_UDT;
END_VAR

VAR_INPUT
	Value: REAL;
	Status: DINT;
	Total: REAL := 0.0;
END_VAR

VAR
	i: INT;
END_VAR
__IMPLEMENTATION__
Data.RawVal := Value;

IF Status < 0 THEN
	Data.RawValStatusCode := -1;
ELSE
	Data.RawVal := Value;
	Data.RawValStatusCode := Status;
END_IF;

// Accumulators
FOR i := 0 TO 4 DO
	Data.Accum[i].ValueIn_Total := Total;
END_FOR;
