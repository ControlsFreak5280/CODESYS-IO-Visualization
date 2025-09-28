__METADATA__
{
  "v3Meta": {
    "objectGuid": "c50cda6a-0cff-48c1-88e5-38b3012eee62",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
Pump_Inlet_Valve_MB.SignalLossAction := 5;
Pump_Inlet_Valve_MB.Actuator_Control := 5;

Pump_Outlet_Valve_MB.SignalLossAction := 5;
Pump_Outlet_Valve_MB.Actuator_Control := 5;

SetRackIO();

Init := FALSE;
