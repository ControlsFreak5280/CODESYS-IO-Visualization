__METADATA__
{
  "v3Meta": {
    "objectGuid": "f1cd8d06-cfad-45d3-80ad-069bf2705969",
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
FUNCTION GetModbusDeviceStatusString : WSTRING(256)

VAR_INPUT
	ErrorCode: INT;
END_VAR

VAR
	ErrorString: WSTRING(256);
END_VAR
__IMPLEMENTATION__
CASE ErrorCode OF
	0: ErrorString := "OK";
	1: ErrorString := "Illegal Function";
	2: ErrorString := "Illegal Data Address";
	3: ErrorString := "Illegal Data Value";
	4: ErrorString := "Slave Device Failure";
	5: ErrorString := "Acknowledge";
	6: ErrorString := "Slave Device Busy";
	7: ErrorString := "Memory Parity Error";
	8: ErrorString := "Gateway Path Unavailable";
	9: ErrorString := "Gateway Device Failed To Respond";
	10: ErrorString := "Response Timeout";
	11: ErrorString := "Response CRC Fail";
	12: ErrorString := "Response Wrong Slave";
	13: ErrorString := "Response Wrong Function Code";
	14: ErrorString := "TCP Communication Error";
	15: ErrorString := "Response Invalid Data";
	16: ErrorString := "Response Invalid Protocol";
	17: ErrorString := "Response Invalid Header";
	18: ErrorString := "Undefined";
ELSE
	ErrorString := "Error: Unknown";
END_CASE;

GetModbusDeviceStatusString := ErrorString;
