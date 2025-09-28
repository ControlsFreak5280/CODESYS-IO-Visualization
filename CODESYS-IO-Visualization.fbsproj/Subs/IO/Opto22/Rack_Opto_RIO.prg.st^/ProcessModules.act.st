__METADATA__
{
  "v3Meta": {
    "objectGuid": "0a9dcf96-2d9a-45c6-b8bc-12d3642e5e7a",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
FOR i := 0 TO Lib_GVL.MaxModuleCount DO
	Module_Opto(Rack := Rack, Module := Rack.Modules[i]);
END_FOR;
