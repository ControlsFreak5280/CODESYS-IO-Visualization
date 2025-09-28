__METADATA__
{
  "v3Meta": {
    "objectGuid": "fc5da12f-96b8-4456-83d4-05504284cd5f",
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
PROGRAM Main_IO

VAR_INPUT
	Init: BOOL := TRUE;
END_VAR
__IMPLEMENTATION__
// ****************** Hardware IO Processing ******************
CodeSysCPU(cpu := CPU);

// Assign Pointers for Rack and Modules
IF (Init) THEN
	Initialize();
END_IF;

SetRackIO();

// Set Rack and Module Status from hardware
Rack_Opto_RIO(Rack := Rack_01);

// Process all IO for Rack
ProcessRackIO_Opto(Rack := Rack_01);		// Process I/O to set values / status codes


// ****************** Fieldbus Device Processing ******************

// Valve 1 - 192.168.160.39 Port 502
Pump_Inlet_Valve_In.State := Pump_Inlet_Valve_Slave.ComState;
Pump_Inlet_Valve_In.Error := Pump_Inlet_Valve_Slave.xError;
Pump_Inlet_Valve_In.ErrorCode := Pump_Inlet_Valve_Slave.byModbusError;

RotorkValve(
	Data := Pump_Inlet_Valve_MB,
	InputData := Pump_Inlet_Valve_In,
	OutputData := Pump_Inlet_Valve_Out
);

// Valve 2 - 192.168.160.39 Port 503
Pump_Outlet_Valve_In.State := Pump_Outlet_Valve_Slave.ComState;
Pump_Outlet_Valve_In.Error := Pump_Outlet_Valve_Slave.xError;
Pump_Outlet_Valve_In.ErrorCode := Pump_Outlet_Valve_Slave.byModbusError;

RotorkValve(
	Data := Pump_Outlet_Valve_MB,
	InputData := Pump_Outlet_Valve_In,
	OutputData := Pump_Outlet_Valve_Out
);


// Map IO Points to Equipment and Instruments
IO_MapTagData();
