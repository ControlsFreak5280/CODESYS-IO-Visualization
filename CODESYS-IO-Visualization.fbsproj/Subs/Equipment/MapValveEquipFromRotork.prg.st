__METADATA__
{
  "v3Meta": {
    "objectGuid": "9e743796-e325-44dd-9b20-a2345e681ba8",
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
PROGRAM MapValveEquipFromRotork

VAR_IN_OUT
	Valve: Equip_UDT;
	MB: RotorkValve_UDT;
END_VAR
__IMPLEMENTATION__
Valve.Raw.SWITCH0[0] := WORD_TO_INT(MB.InputReg00);
Valve.Raw.BOOL0[0] := MB.Actuator_Moving;
Valve.Raw.BOOL0[1] := MB.Valve_Closed;
Valve.Raw.BOOL0[2] := MB.Valve_Opened;
Valve.Raw.BOOL0[3] := MB.Running_Closed;
Valve.Raw.BOOL0[4] := MB.Running_Open;
Valve.Raw.BOOL0[5] := MB.Remote_Selected;
Valve.Raw.BOOL0[6] := MB.Local_Stop_Selected_Offline;
Valve.Raw.BOOL0[7] := MB.Local_Stop_Selected;
Valve.Raw.BOOL0[8] := MB.Thermostat_Tripped;
Valve.Raw.BOOL0[9] := MB.Monitor_Relay;
Valve.Raw.BOOL0[10] := MB.Valve_Obstructed;
Valve.Raw.BOOL0[11] := MB.Valve_Jammed;
Valve.Raw.BOOL0[12] := MB.Valve_Moving_By_Hand;
Valve.Raw.BOOL0[13] := MB.Moving_Inhibited_by_MIT;
Valve.Raw.BOOL0[14] := MB.Position_Control_Enabled;
Valve.Raw.BOOL0[15] := MB.EEPROM_Checksum_Failure;

Valve.Raw.SWITCH0[1] := WORD_TO_INT(MB.InputReg01);
Valve.Raw.BOOL0[20] := MB.Battery_Low;
Valve.Raw.BOOL0[21] := MB.Open_Interlock_Active;
Valve.Raw.BOOL0[22] := MB.Close_Interlock_Active;
Valve.Raw.BOOL0[23] := MB.DI_1;
Valve.Raw.BOOL0[24] := MB.DI_2;
Valve.Raw.BOOL0[25] := MB.DI_3;
Valve.Raw.BOOL0[26] := MB.DI_4;
Valve.Raw.BOOL0[27] := MB.Reserved_7;
Valve.Raw.BOOL0[28] := MB.Reserved_8;
Valve.Raw.BOOL0[29] := MB.Reserved_9;
Valve.Raw.BOOL0[30] := MB.Control_Contention;
Valve.Raw.BOOL0[31] := MB.Partial_Stroke_Test_in_Progress;
Valve.Raw.BOOL0[32] := MB.Partial_Stroke_Test_Error;
Valve.Raw.BOOL0[33] := MB.General_Alarm;
Valve.Raw.BOOL0[34] := MB.Reserved_14;
Valve.Raw.BOOL0[35] := MB.Reserved_15;

Valve.Raw.REAL0[0] := MB.Valve_Position;
Valve.Raw.REAL0[1] := MB.Actuator_Torque;
Valve.Raw.REAL0[2] := MB.Analog_Input;

MB.Actuator_Position_Command := Valve.PositionCmd;

MB.Actuator_Control := 0;
IF (Valve.OpenCmd) THEN
	MB.Actuator_Control := 2;
END_IF;
IF (Valve.CloseCmd) THEN
	MB.Actuator_Control := 1;
END_IF;

MB.SignalLossAction := Valve.Raw.SWITCH0[50];
MB.SignalLossPosition := Valve.Raw.SWITCH0[51];

Valve.Raw.REAL0[40] := DINT_TO_REAL(MB.Status);
Valve.Raw.SWITCH0[40] := UINT_TO_INT(MB.SlaveState);
Valve.Raw.SWITCH0[41] := MB.SlaveErrorCode;
Valve.Raw.BOOL0[40] := MB.SlaveError;
Valve.Raw.BOOL0[41] := MB.CI;
Valve.Raw.BOOL0[42] := (MB.SlaveState <> 2) OR MB.SlaveError OR (MB.SlaveErrorCode <> 0); // Slave Comm as failed
Valve.Raw.STRING0[0] := GetModbusDeviceStatusString(ErrorCode := MB.SlaveErrorCode);
Valve.Raw.STRING0[1] := GetModbusCommStateString(State := UINT_TO_INT(MB.SlaveState));

// Set Simulator Data from HMI Data in Equipment_Valve
MB.Simulator.Thermostat_Tripped := Valve.HMI.BOOL0[75];
MB.Simulator.Monitor_Relay := Valve.HMI.BOOL0[76];
MB.Simulator.Valve_Obstructed := Valve.HMI.BOOL0[77];
MB.Simulator.Valve_Jammed := Valve.HMI.BOOL0[78];
MB.Simulator.Valve_Moving_By_Hand := Valve.HMI.BOOL0[79];
MB.Simulator.Moving_Inhibited_by_MIT := Valve.HMI.BOOL0[80];
MB.Simulator.Postion_Control_Enabled := Valve.HMI.BOOL0[81];
MB.Simulator.EEPROM_Checksum_Failure := Valve.HMI.BOOL0[82];
MB.Simulator.Battery_Low := Valve.HMI.BOOL0[83];
MB.Simulator.Open_Interlock_Active := Valve.HMI.BOOL0[84];
MB.Simulator.Close_Interlock_Active := Valve.HMI.BOOL0[85];
MB.Simulator.DI_1 := Valve.HMI.BOOL0[86];
MB.Simulator.DI_2 := Valve.HMI.BOOL0[87];
MB.Simulator.DI_3 := Valve.HMI.BOOL0[88];
MB.Simulator.DI_4 := Valve.HMI.BOOL0[89];
MB.Simulator.Reserved_7 := Valve.HMI.BOOL0[90];
MB.Simulator.Reserved_8 := Valve.HMI.BOOL0[91];
MB.Simulator.Reserved_9 := Valve.HMI.BOOL0[92];
MB.Simulator.Control_Contention := Valve.HMI.BOOL0[93];
MB.Simulator.Partial_Stroke_Test_in_Progress := Valve.HMI.BOOL0[94];
MB.Simulator.Partial_Stroke_Test_Error := Valve.HMI.BOOL0[95];
MB.Simulator.General_Alarm := Valve.HMI.BOOL0[96];
MB.Simulator.Reserved_14 := Valve.HMI.BOOL0[97];
MB.Simulator.Reserved_15 := Valve.HMI.BOOL0[98];
MB.Simulator.ibAuto := Valve.HMI.BOOL0[99];
MB.SimulationEnable := NOT Valve.HMI.BOOL0[100];

MB.Simulator.Analog_Input := Valve.HMI.REAL0[21];

MB.Simulator.InputData.Error := Valve.HMI.BOOL0[40];
MB.Simulator.InputData.State := INT_TO_UINT(Valve.HMI.SWITCH0[40]);
MB.Simulator.InputData.ErrorCode := DINT_TO_INT(Valve.HMI.SWITCH0[41]);
