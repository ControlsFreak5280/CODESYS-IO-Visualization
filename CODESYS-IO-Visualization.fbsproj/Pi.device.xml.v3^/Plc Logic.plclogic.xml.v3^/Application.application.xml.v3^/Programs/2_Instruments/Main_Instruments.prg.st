__METADATA__
{
  "v3Meta": {
    "objectGuid": "d20c7ea5-359a-461b-bed5-a7f1e481a8ef",
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
PROGRAM Main_Instruments
VAR
END_VAR
__IMPLEMENTATION__
// Ambient Temperature: Site.Plant.AmbientTemp
InstA(Data := Site.Plant.AmbientTemp);

// Pump 1 Flow: Site.Plant.Pump1.Flow
InstA(Data := Site.Plant.Pump1.Flow);

// Pump 1 Temperature: Site.Plant.Pump1.Temp
InstA(Data := Site.Plant.Pump1.Temp);

