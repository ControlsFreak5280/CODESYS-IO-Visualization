__METADATA__
{
  "v3Meta": {
    "objectGuid": "7f8e227c-1cde-4014-8844-d130ac9424c5",
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
PROGRAM Main_Equipment
VAR
END_VAR
__IMPLEMENTATION__
// ********** Base Equipment Code **********

// Pump 1 Inlet Valve: Site.Plant.Pump1.InletValve
Equip(Data := Site.Plant.Pump1.InletValve);

// Pump 1 Outlet Valve: Site.Plant.Pump1.OutletValve
Equip(Data := Site.Plant.Pump1.OutletValve);

// Pump 1 VFD: Site.Plant.Pump1.VFD
Equip(Data := Site.Plant.Pump1.VFD);
