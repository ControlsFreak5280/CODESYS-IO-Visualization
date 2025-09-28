__METADATA__
{
  "v3Meta": {
    "objectGuid": "85dcdd0c-91b0-41d7-9ed7-8ed80cfde7fb",
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
PROGRAM Process_PumpVFD

VAR_IN_OUT
	equip: Equip_UDT;
END_VAR
__IMPLEMENTATION__
ProcessInputs();
ProcessAlarms();

equip.PLC.REAL0[20] := equip.Speed;

ProcessOutputs();
