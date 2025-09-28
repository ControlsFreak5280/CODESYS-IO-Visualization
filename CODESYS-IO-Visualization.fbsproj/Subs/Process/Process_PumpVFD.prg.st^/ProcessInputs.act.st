__METADATA__
{
  "v3Meta": {
    "objectGuid": "cd397d70-2550-4f16-97f0-c44ce3d03b69",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IF (NOT equip.DiagnosticMode) THEN
	equip.PLC.BOOL0[0] := equip.Raw.BOOL0[0];	//Running
	equip.PLC.BOOL0[1] := equip.Raw.BOOL0[1];	//VFD Fault
	equip.PLC.REAL0[0] := equip.Raw.REAL0[0];	//VFD Speed
END_IF;

equip.Speed := equip.PLC.REAL0[0];
equip.Running := equip.PLC.BOOL0[0];
