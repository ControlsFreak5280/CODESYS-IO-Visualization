__METADATA__
{
  "v3Meta": {
    "objectGuid": "516ffb09-792b-4833-8835-26cc44435aef",
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
PROGRAM Main_ClockSync
VAR
	SetClockTrigger: R_TRIG;
	Init: BOOL := TRUE;
END_VAR
__IMPLEMENTATION__
// Set Clock Logic
SetClockTrigger(CLK := Lib_GVL.SetClock);
SetPLCClock(TZ := 'MT', DisableDST := FALSE, SetClock := SetClockTrigger.Q, SetClockValue := Lib_GVL.SetClockValue);

IF (Lib_GVL.SetClock) THEN
	Lib_GVL.SetClock := FALSE;
END_IF

//Set Globals from Library
Controller.ClockLocal := Lib_GVL.ClockLocal;
Controller.ClockUTC := Lib_GVL.ClockUTC;

