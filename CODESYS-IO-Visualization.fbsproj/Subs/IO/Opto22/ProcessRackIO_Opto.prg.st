__METADATA__
{
  "v3Meta": {
    "objectGuid": "e802cdff-57f2-44a0-8e51-efc433fdbc53",
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
PROGRAM ProcessRackIO_Opto

VAR_IN_OUT
	Rack: Rack_Opto_RIO_UDT;
END_VAR

VAR
	i: INT;
END_VAR
__IMPLEMENTATION__
FOR i := 0 TO Lib_GVL.MaxModuleCount DO
	ProcessModuleIO_Opto(Rack := Rack, Module := Rack.Modules[i]);
END_FOR;
