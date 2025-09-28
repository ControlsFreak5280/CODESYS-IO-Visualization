__METADATA__
{
  "v3Meta": {
    "objectGuid": "b490260e-2a0c-45af-a2b5-6f4a2e5dadb3",
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
PROGRAM MapEquip_Simple

VAR_IN_OUT
	Equip: Equip_UDT;
END_VAR

VAR_INPUT
	Remote: BOOL;
	Running: BOOL;
	Failed: BOOL;
END_VAR

VAR_OUTPUT
	RunCmd: BOOL;
	FailureActive: BOOL;
END_VAR
__IMPLEMENTATION__
// Map Inputs
Equip.Raw.BOOL0[0] := Remote;
Equip.Raw.BOOL0[1] := Running;
Equip.Raw.BOOL0[2] := Failed;

// Map Outputs
RunCmd := Equip.RunCmd OR Equip.OpenCmd;
FailureActive := Equip.FailureActive;
