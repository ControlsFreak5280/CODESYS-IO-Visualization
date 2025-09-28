__METADATA__
{
  "v3Meta": {
    "objectGuid": "d5227b15-17e9-401d-a9a1-e4cf3edd4c96",
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
PROGRAM Process_SetModbusEquipStatus

VAR_IN_OUT
	equip: Equip_UDT;
END_VAR
__IMPLEMENTATION__
// Set the Equipment Status Code
IF equip.PLC.REAL0[40] < 0 THEN
	equip.StatusCode := -1;
	equip.GlobalStatusCode := -1;
	equip.GlobalStatusString := "Control Inhibited";
ELSE
	equip.StatusCode := 0;
	equip.GlobalStatusCode := 0;
	equip.GlobalStatusString := "Device OK";
	
	IF (equip.PLC.SWITCH0[40] <> 2) THEN
		equip.StatusCode := equip.StatusCode + equip.PLC.SWITCH0[40] + 1000;
		equip.GlobalStatusCode := equip.StatusCode + equip.PLC.SWITCH0[40] + 1000;
		equip.GlobalStatusString := GetModbusCommStateString(State := equip.PLC.SWITCH0[40]);
	ELSE
		IF equip.PLC.BOOL0[40] THEN
			equip.StatusCode := 1;
			equip.GlobalStatusCode := 1;
			equip.GlobalStatusString := "Modbus Device Error";
		END_IF;
		IF (equip.PLC.SWITCH0[41] <> 0) THEN
			equip.StatusCode := equip.StatusCode + INT_TO_DINT(equip.PLC.SWITCH0[41]) + 1000;
			equip.GlobalStatusCode := equip.StatusCode + INT_TO_DINT(equip.PLC.SWITCH0[41]) + 1000;
			equip.GlobalStatusString := GetModbusDeviceStatusString(ErrorCode := equip.PLC.SWITCH0[41]);
		END_IF;
	END_IF;
END_IF;

