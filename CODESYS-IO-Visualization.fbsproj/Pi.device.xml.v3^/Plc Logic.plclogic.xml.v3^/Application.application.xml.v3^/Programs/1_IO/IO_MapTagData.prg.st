__METADATA__
{
  "v3Meta": {
    "objectGuid": "3c85f7c3-fafd-432e-9db3-c2bdc0ce464c",
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
PROGRAM IO_MapTagData
VAR
END_VAR
__IMPLEMENTATION__
// ********** Tag Mapping to IO **********


// Ambient Temperature: Site.Plant.AmbientTemp -> Slot 0, Channel 0
MapInstAFromIO(Data := Site.Plant.AmbientTemp, IO := IO.Rack_01.Modules[0].Channels[0]);

// Pump 1 Temperature: Site.Plant.Pump1.Temp -> Slot 0, Channel 1
MapInstAFromIO(Data := Site.Plant.Pump1.Temp, IO := IO.Rack_01.Modules[0].Channels[1]);

// Pump 1 Flow: Site.Plant.Pump1.Flow -> Slot 0, Channel 3
MapInstAFromIO(Data := Site.Plant.Pump1.Flow, IO := IO.Rack_01.Modules[0].Channels[3]);

// Pump 1 Inlet Valve: Site.Plant.Pump1.InletValve -> Pump_Inlet_Valve: 192.168.160.39
MapValveEquipFromRotork(Valve := Site.Plant.Pump1.InletValve, MB := Pump_Inlet_Valve_MB);

// Pump 1 Outlet Valve: Site.Plant.Pump1.OutletValve -> Pump_Outlet_Valve: 192.168.160.39
MapValveEquipFromRotork(Valve := Site.Plant.Pump1.OutletValve, MB := Pump_Outlet_Valve_MB);

// Pump 1 VFD: Site.Plant.Pump1.VFD
Site.Plant.Pump1.VFD.Raw.BOOL0[0] := IO.Rack_01.Modules[0].Channels[4].ValueDig;	// Running
Site.Plant.Pump1.VFD.Raw.BOOL0[1] := IO.Rack_01.Modules[0].Channels[5].ValueDig;	// VFD Fault
Site.Plant.Pump1.VFD.Raw.REAL0[0] := IO.Rack_01.Modules[0].Channels[2].ValueEu;	// VFD Speed
IO.Rack_01.Modules[0].Channels[6].ValueEu := Site.Plant.Pump1.VFD.Raw.REAL0[20];	// VFD Speed Cmd

IO.Rack_01.Modules[0].Channels[7].ValueEu := Site.Plant.Pump1.Flow.CurVal.Value;	// VFD Flow Output
IO.Rack_01.Modules[0].Channels[8].ValueDig := Site.Plant.Pump1.VFD.Running;	// VFD Running
IO.Rack_01.Modules[0].Channels[9].ValueDig := Site.Plant.Pump1.VFD.Failure[0].Active;	// VFD Failed

