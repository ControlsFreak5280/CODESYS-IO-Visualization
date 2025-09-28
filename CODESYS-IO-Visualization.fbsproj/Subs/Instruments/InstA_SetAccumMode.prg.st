__METADATA__
{
  "v3Meta": {
    "objectGuid": "9a527a28-1a18-464b-a284-816dc079dabd",
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
PROGRAM InstA_SetAccumMode

VAR_IN_OUT
	Data: InstA_UDT;	// The InstA_UDT to Modify
END_VAR

VAR_INPUT
	Mode: INT;	// 0 = Realtime Totalizer, 1 = Read Meter Total (No Reset), 2 = Read Meter Total (with Reset)
END_VAR

VAR
	i: INT;
END_VAR
__IMPLEMENTATION__
// Set Accumulator Mode
// 0 = Realtime Totalizer, 1 = Read Meter Total (No Reset), 2 = Read Meter Total (with Reset)

IF (Mode < 0) THEN
	Mode := 0;
END_IF;

IF (Mode > 2) THEN
	Mode := 2;
END_IF;

FOR i := 0 TO 4 DO
	Data.Accum[i].Mode := Mode;
END_FOR;
