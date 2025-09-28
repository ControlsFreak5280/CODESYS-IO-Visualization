__METADATA__
{
  "v3Meta": {
    "objectGuid": "d8b41bd3-88e2-44f2-84c6-ea2c649aa8a3",
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
PROGRAM MapEquip_Valve

VAR_IN_OUT
	Equip: Equip_UDT;
END_VAR

VAR_INPUT
	Remote: BOOL;
	GCPRemote: BOOL;
	Opened: BOOL;
	Closed: BOOL;
	Failed: BOOL;
	Alarm: BOOL;
	CommFail: BOOL;
	Position: REAL;
	OpenHS: BOOL;
	CloseHS: BOOL;
	Interlock1: BOOL;
	Interlock2: BOOL;
END_VAR

VAR_OUTPUT
	OpenCmd: BOOL;
	CloseCmd: BOOL;
END_VAR
__IMPLEMENTATION__
// Map Inputs
MapEquip_Valve.Equip.Raw.BOOL0[0] := Remote;
MapEquip_Valve.Equip.Raw.BOOL0[6] := GCPRemote;
MapEquip_Valve.Equip.Raw.BOOL0[1] := Closed;
MapEquip_Valve.Equip.Raw.BOOL0[2] := Opened;
MapEquip_Valve.Equip.Raw.BOOL0[3] := Alarm;
MapEquip_Valve.Equip.Raw.BOOL0[4] := Failed;
MapEquip_Valve.Equip.Raw.BOOL0[7] := OpenHS;
MapEquip_Valve.Equip.Raw.BOOL0[8] := CloseHS;
MapEquip_Valve.Equip.Raw.REAL0[0] := Position;
MapEquip_Valve.Equip.Raw.BOOL0[5] := CommFail;
MapEquip_Valve.Equip.Raw.BOOL0[12] := Interlock1;
MapEquip_Valve.Equip.Raw.BOOL0[17] := Interlock2;

// Map Outputs
OpenCmd := MapEquip_Valve.Equip.OpenCmd;
CloseCmd := MapEquip_Valve.Equip.CloseCmd;
