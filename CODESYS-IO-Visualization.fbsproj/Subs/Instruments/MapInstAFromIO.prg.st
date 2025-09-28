__METADATA__
{
  "v3Meta": {
    "objectGuid": "46d7eb04-71ed-4368-9308-a698a56e53fd",
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
PROGRAM MapInstAFromIO

VAR_IN_OUT
	Data: InstA_UDT;
	IO: Channel_UDT;
END_VAR
__IMPLEMENTATION__
Data.RawVal := IO.ValueEu;
Data.RawValStatusCode := IO.StatusCode + 128;

// Map Simulation Settings to IO
IO.SimulationEnable := (NOT Data.Sim.SimDisable);
IO.Simulator.irChangeRate := Data.Sim.ChangeRate;
IO.Simulator.irNoisePct := Data.Sim.NoisePct;
IO.Simulator.irHighLimit := Data.CurVal.HighRange;
IO.Simulator.irLowLimit := Data.CurVal.LowRange;
IO.Simulator.odiStatusCode := Data.Sim.StatusCode;

IF (Data.CurVal.HighRange - Data.CurVal.LowRange) > 0 THEN
	IO.Simulator.irPercent := (Data.Sim.RawVal / (Data.CurVal.HighRange - Data.CurVal.LowRange)) * 100.0;
ELSE
	IO.Simulator.irPercent := Data.Sim.RawVal;
END_IF;
