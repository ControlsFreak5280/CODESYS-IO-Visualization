__METADATA__
{
  "v3Meta": {
    "objectGuid": "8f53b51d-0289-406e-b73f-10076db1d598",
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
PROGRAM Main_Process

VAR
	Init: BOOL := TRUE;
END_VAR
__IMPLEMENTATION__
IF Init THEN
	Site.Plant.Pump1.InletValve.HMI.SWITCH0[1] := 1;
	Site.Plant.Pump1.OutletValve.HMI.SWITCH0[1] := 1;
	Site.Plant.Pump1.InletValve.HMI.REAL0[20] := 100.0;
	Site.Plant.Pump1.OutletValve.HMI.REAL0[20] := 50.0;
	
	Site.Plant.Pump1.VFD.Remote := TRUE;
	
	Init := FALSE;
END_IF;

Process_RotorkValve_Auto(valve := Site.Plant.Pump1.InletValve);
Process_RotorkValve_Auto(valve := Site.Plant.Pump1.OutletValve);
Process_PumpVFD(equip := Site.Plant.Pump1.VFD);
