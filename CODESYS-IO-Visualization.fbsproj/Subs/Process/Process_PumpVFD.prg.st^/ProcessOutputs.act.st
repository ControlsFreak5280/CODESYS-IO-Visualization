__METADATA__
{
  "v3Meta": {
    "objectGuid": "4fe0158d-6711-494e-9de8-adf997f19897",
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
	equip.Raw.REAL0[20] := equip.PLC.REAL0[20];	//VFD Speed Cmd
END_IF;
