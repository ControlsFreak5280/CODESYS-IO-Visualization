__METADATA__
{
  "v3Meta": {
    "objectGuid": "9bf32a35-beda-441b-b88d-1dc5feee87fb",
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
PROGRAM InstA_SecondaryValue

VAR_INPUT
	Value: REAL;
END_VAR

VAR_IN_OUT
	Data: InstA_Value_Settings2_UDT; 
END_VAR
__IMPLEMENTATION__
CASE Data.Mode OF
	1: // (m * x) + b
		Data.Value := (Value * Data.Multiplier) + Data.Offset;

	2: // (m * x) + b
		Data.Value := (Value + Data.Offset) * Data.Multiplier;
END_CASE;
