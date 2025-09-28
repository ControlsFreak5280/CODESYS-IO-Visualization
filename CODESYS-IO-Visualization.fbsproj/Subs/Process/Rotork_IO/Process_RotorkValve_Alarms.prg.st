__METADATA__
{
  "v3Meta": {
    "objectGuid": "4d1ac4df-53b7-4d22-9554-511a0f8ee346",
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
PROGRAM Process_RotorkValve_Alarms

VAR_IN_OUT
	valve: Equip_UDT;
END_VAR
__IMPLEMENTATION__
// Not Ready Alarms
// Not in Auto
valve.NotReady[0].Value := valve.Remote;


// Failure Alarms
// Vavle Failed
valve.Failure[0].Value := valve.PLC.BOOL0[8] OR valve.PLC.BOOL0[15];

// Vavle Overload
valve.Failure[1].Value := valve.PLC.BOOL0[10] OR valve.PLC.BOOL0[11];

// Valve Communications Failed
valve.Failure[2].Value := valve.PLC.BOOL0[42] OR valve.StatusCode > 0;


// Interlock Alarms
// Valve Interlocked
valve.Interlock[0].Value := valve.PLC.BOOL0[21] OR valve.PLC.BOOL0[22];


// Warning Alarms
// Valve Interlocked
valve.Warning[0].Value := valve.PLC.BOOL0[20] OR valve.PLC.BOOL0[32] OR valve.PLC.BOOL0[33];
