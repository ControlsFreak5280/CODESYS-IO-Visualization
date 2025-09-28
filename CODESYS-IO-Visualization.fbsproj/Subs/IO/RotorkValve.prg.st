__METADATA__
{
  "v3Meta": {
    "objectGuid": "3cf2eb34-64fd-4d18-8835-7d23a579eaf8",
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
PROGRAM RotorkValve

VAR_IN_OUT
	Data: RotorkValve_UDT;
	InputData: RotorkValve_MBIO_InputData_UDT;
	OutputData: RotorkValve_MBIO_OutputData_UDT;
END_VAR

__IMPLEMENTATION__
// Assign Input Data from either the Modbus Device or the Simulator
IF (Simulation.SimulationEnable AND Data.SimulationEnable) THEN
	RotorkValve_Simulator(Data := Data.Simulator);
	Data.InputData := Data.Simulator.InputData;
ELSE
	Data.InputData := InputData;
END_IF;

IF (NOT Data.CI) THEN
	// Output Data
	Data.OutputData.Reg05 := INT_TO_WORD(Data.Actuator_Control);
	Data.OutputData.Reg06 := REAL_TO_WORD(Data.Actuator_Position_Command * 10.0);
	Data.OutputData.Reg07 := INT_TO_WORD(Data.SignalLossAction);
	Data.OutputData.Reg13 := INT_TO_WORD(Data.SignalLossPosition);

	// Input Data
	Data.InputReg00 := Data.InputData.Reg00;
	Data.Actuator_Moving := Data.InputData.Reg00.0;
	Data.Valve_Closed := Data.InputData.Reg00.1;
	Data.Valve_Opened := Data.InputData.Reg00.2;
	Data.Running_Closed := Data.InputData.Reg00.3;
	Data.Running_Open := Data.InputData.Reg00.4;
	Data.Remote_Selected := Data.InputData.Reg00.5;
	Data.Local_Stop_Selected_Offline := Data.InputData.Reg00.6;
	Data.Local_Stop_Selected := Data.InputData.Reg00.7;
	Data.Thermostat_Tripped := Data.InputData.Reg00.8;
	Data.Monitor_Relay := Data.InputData.Reg00.9;
	Data.Valve_Obstructed := Data.InputData.Reg00.10;
	Data.Valve_Jammed := Data.InputData.Reg00.11;
	Data.Valve_Moving_By_Hand := Data.InputData.Reg00.12;
	Data.Moving_Inhibited_by_MIT := Data.InputData.Reg00.13;
	Data.Position_Control_Enabled := Data.InputData.Reg00.14;
	Data.EEPROM_Checksum_Failure := Data.InputData.Reg00.15;
	
	Data.InputReg01 := Data.InputData.Reg01;
	Data.Battery_Low := Data.InputData.Reg01.0;
	Data.Open_Interlock_Active := Data.InputData.Reg01.1;
	Data.Close_Interlock_Active := Data.InputData.Reg01.2;
	Data.DI_1 := Data.InputData.Reg01.3;
	Data.DI_2 := Data.InputData.Reg01.4;
	Data.DI_3 := Data.InputData.Reg01.5;
	Data.DI_4 := Data.InputData.Reg01.6;
	Data.Reserved_7 := Data.InputData.Reg01.7;
	Data.Reserved_8 := Data.InputData.Reg01.8;
	Data.Reserved_9 := Data.InputData.Reg01.9;
	Data.Control_Contention := Data.InputData.Reg01.10;
	Data.Partial_Stroke_Test_in_Progress := Data.InputData.Reg01.11;
	Data.Partial_Stroke_Test_Error := Data.InputData.Reg01.12;
	Data.General_Alarm := Data.InputData.Reg01.13;
	Data.Reserved_14 := Data.InputData.Reg01.14;
	Data.Reserved_15 := Data.InputData.Reg01.15;

	Data.Actuator_Torque := WORD_TO_REAL(Data.InputData.Reg02);
	Data.Valve_Position := WORD_TO_REAL(Data.InputData.Reg03) / 10.0;
	Data.Analog_Input := WORD_TO_REAL(Data.InputData.Reg04) / 10.0;

	// Modbus Slave Data
	Data.SlaveState := Data.InputData.State;
	Data.SlaveError := Data.InputData.Error;
	Data.SlaveErrorCode := Data.InputData.ErrorCode;
	
	IF (Data.SlaveState = 2) THEN
		Data.Status := INT_TO_DINT(Data.SlaveErrorCode);
	ELSE
		Data.Status := UINT_TO_DINT(Data.SlaveState) + 1000;
	END_IF;
ELSE
	Data.Status := DINT#-1;
END_IF


// Output Data
IF (Simulation.SimulationEnable AND Data.SimulationEnable) THEN
	Data.Simulator.OutputData := Data.OutputData;
ELSE
	OutputData := Data.OutputData;
END_IF;
