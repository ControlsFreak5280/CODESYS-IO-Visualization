__METADATA__
{
  "v3Meta": {
    "objectGuid": "4b0d15b5-6636-4eff-a57d-2b2c1cc921cc",
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
PROGRAM Process_RotorkValve_Inputs

VAR_IN_OUT
	valve: Equip_UDT;
END_VAR
__IMPLEMENTATION__
IF (NOT valve.DiagnosticMode) THEN
	valve.PLC.BOOL0[0] := valve.Raw.BOOL0[0];  // Actuator_Moving
	valve.PLC.BOOL0[1] := valve.Raw.BOOL0[1];  // Valve_Closed
	valve.PLC.BOOL0[2] := valve.Raw.BOOL0[2];  // Valve_Opened
	valve.PLC.BOOL0[3] := valve.Raw.BOOL0[3];  // Running_Closed
	valve.PLC.BOOL0[4] := valve.Raw.BOOL0[4];  // Running_Open
	valve.PLC.BOOL0[5] := valve.Raw.BOOL0[5];  // Remote_Selected
	valve.PLC.BOOL0[6] := valve.Raw.BOOL0[6];  // Local_Stop_Selected_Offline
	valve.PLC.BOOL0[7] := valve.Raw.BOOL0[7];  // Local_Stop_Selected
	valve.PLC.BOOL0[8] := valve.Raw.BOOL0[8];  // Thermostat_Tripped
	valve.PLC.BOOL0[9] := valve.Raw.BOOL0[9];  // Monitor_Relay
	valve.PLC.BOOL0[10] := valve.Raw.BOOL0[10];  // Valve_Obstructed
	valve.PLC.BOOL0[11] := valve.Raw.BOOL0[11];  // Valve_Jammed
	valve.PLC.BOOL0[12] := valve.Raw.BOOL0[12];  // Valve_Moving_By_Hand
	valve.PLC.BOOL0[13] := valve.Raw.BOOL0[13];  // Moving_Inhibited_by_MIT
	valve.PLC.BOOL0[14] := valve.Raw.BOOL0[14];  // Postion_Control_Enabled
	valve.PLC.BOOL0[15] := valve.Raw.BOOL0[15];  // EEPROM_Checksum_Failure

	valve.PLC.BOOL0[20] := valve.Raw.BOOL0[20];  // Battery_Low
	valve.PLC.BOOL0[21] := valve.Raw.BOOL0[21];  // Open_Interlock_Active
	valve.PLC.BOOL0[22] := valve.Raw.BOOL0[22];  // Close_Interlock_Active
	valve.PLC.BOOL0[23] := valve.Raw.BOOL0[23];  // DI_1
	valve.PLC.BOOL0[24] := valve.Raw.BOOL0[24];  // DI_2
	valve.PLC.BOOL0[25] := valve.Raw.BOOL0[25];  // DI_3
	valve.PLC.BOOL0[26] := valve.Raw.BOOL0[26];  // DI_4
	valve.PLC.BOOL0[27] := valve.Raw.BOOL0[27];  // Reserved_7
	valve.PLC.BOOL0[28] := valve.Raw.BOOL0[28];  // Reserved_8
	valve.PLC.BOOL0[29] := valve.Raw.BOOL0[29];  // Reserved_9
	valve.PLC.BOOL0[30] := valve.Raw.BOOL0[30];  // Control_Contention
	valve.PLC.BOOL0[31] := valve.Raw.BOOL0[31];  // Partial_Stroke_Test_in_Progress
	valve.PLC.BOOL0[32] := valve.Raw.BOOL0[32];  // Partial_Stroke_Test_Error
	valve.PLC.BOOL0[33] := valve.Raw.BOOL0[33];  // General_Alarm
	valve.PLC.BOOL0[34] := valve.Raw.BOOL0[34];  // Reserved_14
	valve.PLC.BOOL0[35] := valve.Raw.BOOL0[35];  // Reserved_15
	
	valve.PLC.BOOL0[40] := valve.Raw.BOOL0[40];  // SlaveError
	valve.PLC.BOOL0[41] := valve.Raw.BOOL0[41];  // ControlInhibit
	valve.PLC.BOOL0[42] := valve.Raw.BOOL0[42];  // ModbusSlaveCommFail

	valve.PLC.SWITCH0[0] := valve.Raw.SWITCH0[0];  // InputReg00
	valve.PLC.SWITCH0[1] := valve.Raw.SWITCH0[1];  // InputReg01
	valve.PLC.SWITCH0[40] := valve.Raw.SWITCH0[40];  // SlaveState
	valve.PLC.SWITCH0[41] := valve.Raw.SWITCH0[41];  // SlaveErrorCode
	
	valve.PLC.REAL0[0] := valve.Raw.REAL0[0];  // Valve_Position
	valve.PLC.REAL0[1] := valve.Raw.REAL0[1];  // Actuator_Torque
	valve.PLC.REAL0[2] := valve.Raw.REAL0[2];  // Analog_Input
	valve.PLC.REAL0[40] := valve.Raw.REAL0[40];  // ModbusStatus

	valve.PLC.STRING0[0] := valve.Raw.STRING0[0]; // Slave Device Error
	valve.PLC.STRING0[1] := valve.Raw.STRING0[1]; // Slave Device Comm State
END_IF;

valve.Closed := valve.PLC.BOOL0[1];
valve.Opened := valve.PLC.BOOL0[2];
valve.Remote := valve.PLC.BOOL0[5];
valve.Position := valve.PLC.REAL0[0];

valve.Traveling := (NOT valve.Closed) AND (NOT valve.Opened);


// Set the Valve Status Code
Process_SetModbusEquipStatus(equip := valve);
