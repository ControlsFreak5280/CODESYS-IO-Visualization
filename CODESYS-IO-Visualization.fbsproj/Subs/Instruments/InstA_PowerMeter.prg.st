__METADATA__
{
  "v3Meta": {
    "objectGuid": "006128e0-cb54-43a0-a9d4-0cf07b99a0be",
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
PROGRAM InstA_PowerMeter

VAR_IN_OUT
	Data: InstPowerMeter_UDT;
END_VAR
__IMPLEMENTATION__
InstA(Data := Data);

InstA(Data := Data.Vab);
InstA(Data := Data.Vbc);
InstA(Data := Data.Vca);
InstA(Data := Data.Vll);
InstA(Data := Data.Van);
InstA(Data := Data.Vbn);
InstA(Data := Data.Vcn);
InstA(Data := Data.Vln);

InstA(Data := Data.Ia);
InstA(Data := Data.Ib);
InstA(Data := Data.Ic);

InstA(Data := Data.kWa);
InstA(Data := Data.kWb);
InstA(Data := Data.kWc);
InstA(Data := Data.kW);

InstA(Data := Data.kVAa);
InstA(Data := Data.kVAb);
InstA(Data := Data.kVAc);
InstA(Data := Data.kVA);

InstA(Data := Data.kVARa);
InstA(Data := Data.kVARb);
InstA(Data := Data.kVARc);
InstA(Data := Data.kVAR);

InstA(Data := Data.PFa);
InstA(Data := Data.PFb);
InstA(Data := Data.PFc);
