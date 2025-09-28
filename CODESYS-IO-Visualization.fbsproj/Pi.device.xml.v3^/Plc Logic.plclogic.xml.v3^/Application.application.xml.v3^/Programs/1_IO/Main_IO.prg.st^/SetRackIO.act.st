__METADATA__
{
  "v3Meta": {
    "objectGuid": "0e2e5b7b-005d-4629-bb8d-f0662f6dfdfa",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
Rack_01.Rack_IO := ADR(Rack_01);

Rack_01.Modules[0].Module_IO := 0;
Rack_01.Modules[0].RIO_IO := ADR(RIO_01);
