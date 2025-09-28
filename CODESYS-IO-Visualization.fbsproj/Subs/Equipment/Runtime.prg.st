__METADATA__
{
  "v3Meta": {
    "objectGuid": "5b6f2f84-1ff6-4507-a988-0d8912d82a3e",
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
PROGRAM Runtime

VAR_IN_OUT
	Data: Runtime_UDT;
END_VAR

__IMPLEMENTATION__
Data.ValueIn_Realtime := 1.0;
Data.Gain := 1.0;
Data.Timebase := 3600.0;
Data.Mode := 0;

Accum(Data := Data);


