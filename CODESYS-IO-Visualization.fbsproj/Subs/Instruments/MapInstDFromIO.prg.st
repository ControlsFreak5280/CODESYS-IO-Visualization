__METADATA__
{
  "v3Meta": {
    "objectGuid": "162d6ded-2974-40a7-8bd8-4342274ba273",
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
PROGRAM MapInstDFromIO
VAR_IN_OUT
	Data: InstD_UDT;
	IO: Channel_UDT;
END_VAR
__IMPLEMENTATION__
Data.RawVal := IO.ValueDig;
Data.RawValStatusCode := IO.StatusCode + 128;

// Map Simulation Settings to IO
IO.SimulationEnable := (NOT Data.Sim.SimDisable);
IO.Simulator.ibValue := Data.Sim.RawVal;
IO.Simulator.odiStatusCode := Data.Sim.StatusCode;
