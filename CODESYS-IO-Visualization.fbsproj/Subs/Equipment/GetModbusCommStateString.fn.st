__METADATA__
{
  "v3Meta": {
    "objectGuid": "12ca507b-0145-48e1-91d8-0b33a916c2c9",
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
FUNCTION GetModbusCommStateString : WSTRING(256)

VAR_INPUT
	State: INT;
END_VAR

VAR
	StateString: WSTRING(256);
END_VAR
__IMPLEMENTATION__
CASE State OF
	0: StateString := "OFF";
	1: StateString := "Connecting";
	2: StateString := "Connected";
	3: StateString := "Disconnecting";
	4: StateString := "Socket Error";
ELSE
	StateString := "Unknown";
END_CASE;

GetModbusCommStateString := StateString;
