__METADATA__
{
  "v3Meta": {
    "objectGuid": "125ba064-3116-446f-831e-1f7e6100be29",
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
PROGRAM Process_RotorkValve_Outputs

VAR_IN_OUT
	valve: Equip_UDT;
END_VAR
__IMPLEMENTATION__
IF (NOT valve.DiagnosticMode) THEN
	valve.PositionCmd := valve.Raw.REAL0[20];
	valve.Raw.SWITCH0[50] := valve.HMI.SWITCH0[50];  // SignalLossAction 0 = Nothing, 1 = Open, 3 = Close, 5 = Stop, 7 = Positioon
	valve.Raw.SWITCH0[51] := valve.HMI.SWITCH0[51];  // SignalLossPosition 0-100
END_IF;
