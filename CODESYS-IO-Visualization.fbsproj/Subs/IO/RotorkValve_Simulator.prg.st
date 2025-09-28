__METADATA__
{
  "v3Meta": {
    "objectGuid": "d318f260-a02f-4777-a2e5-58e77f2d79f4",
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
PROGRAM RotorkValve_Simulator

VAR_IN_OUT
	Data: RotorkValve_Simulator_UDT;
END_VAR
__IMPLEMENTATION__
// Set Valve Data from ModbusIO
Data.ibUsePosCmd := TRUE;

// Check for Comm Fail and set the valve position based on SignalLoss settings
IF (Data.InputData.Error OR (Data.InputData.State <> 2) OR (Data.InputData.ErrorCode <> 0)) THEN
	CASE Data.OutputData.Reg07 OF
		1: Data.irPosCmd := 100.0;
		3: Data.irPosCmd := 0.0;
		5: Data.irPosCmd := Data.orPosition;
		7: Data.irPosCmd := WORD_TO_REAL(Data.OutputData.Reg13);
	END_CASE;
ELSE
	Data.irPosCmd := WORD_TO_REAL(Data.OutputData.Reg06) / 10.0;
END_IF;

Data.ibAlarm := Data.Battery_Low OR Data.Open_Interlock_Active OR Data.Close_Interlock_Active OR Data.General_Alarm;
Data.ibFault := Data.Thermostat_Tripped OR Data.Valve_Obstructed OR Data.Valve_Jammed OR Data.Moving_Inhibited_by_MIT OR Data.EEPROM_Checksum_Failure;

// Call Simulator
ValveSimulator(Data := Data);

// Set Valve Output information from simulator
Data.InputData.Reg02 := 55;
Data.InputData.Reg03 := REAL_TO_WORD(Data.orPosition * 10.0);
Data.InputData.Reg04 := REAL_TO_WORD(Data.Analog_Input * 10.0);

Data.InputData.Reg00.0 := (Data.PosCmd > (Data.ChangeRamp.Y + 0.05)) OR (Data.PosCmd < (Data.ChangeRamp.Y - 0.05)) ;
Data.InputData.Reg00.1 := Data.obClosed;
Data.InputData.Reg00.2 := Data.obOpened;
Data.InputData.Reg00.3 := Data.InputData.Reg00.0 AND (Data.PosCmd < (Data.ChangeRamp.Y - 0.05));
Data.InputData.Reg00.4 := Data.InputData.Reg00.0 AND (Data.PosCmd > (Data.ChangeRamp.Y + 0.05));
Data.InputData.Reg00.5 := Data.obRemote;
Data.InputData.Reg00.6 := (NOT Data.obRemote) AND (NOT Data.InputData.Reg00.0);
Data.InputData.Reg00.7 := (NOT Data.obRemote) AND (NOT Data.InputData.Reg00.0);
Data.InputData.Reg00.8 := Data.Thermostat_Tripped;
Data.InputData.Reg00.9 := Data.Monitor_Relay;
Data.InputData.Reg00.10 := Data.Valve_Obstructed;
Data.InputData.Reg00.11 := Data.Valve_Jammed;
Data.InputData.Reg00.12 := Data.Valve_Moving_By_Hand;
Data.InputData.Reg00.13 := Data.Moving_Inhibited_by_MIT;
Data.InputData.Reg00.14 := Data.Postion_Control_Enabled;
Data.InputData.Reg00.15 := Data.EEPROM_Checksum_Failure;

Data.InputData.Reg01.0 := Data.Battery_Low;
Data.InputData.Reg01.1 := Data.Open_Interlock_Active;
Data.InputData.Reg01.2 := Data.Close_Interlock_Active;
Data.InputData.Reg01.3 := Data.DI_1;
Data.InputData.Reg01.4 := Data.DI_2;
Data.InputData.Reg01.5 := Data.DI_3;
Data.InputData.Reg01.6 := Data.DI_4;
Data.InputData.Reg01.7 := Data.Reserved_7;
Data.InputData.Reg01.8 := Data.Reserved_8;
Data.InputData.Reg01.9 := Data.Reserved_9;
Data.InputData.Reg01.10 := Data.Control_Contention;
Data.InputData.Reg01.11 := Data.Partial_Stroke_Test_in_Progress;
Data.InputData.Reg01.12 := Data.Partial_Stroke_Test_Error;
Data.InputData.Reg01.13 := Data.General_Alarm;
Data.InputData.Reg01.14 := Data.Reserved_14;
Data.InputData.Reg01.15 := Data.Reserved_15;
