__METADATA__
{
  "v3Meta": {
    "objectGuid": "adc42c45-734f-46fa-8373-455e1e817112",
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
PROGRAM Timer

VAR_IN_OUT
	TimerData: Timer_UDT;
END_VAR

VAR
	TimerIn: BOOL;
	TimerPT: TIME;
END_VAR
__IMPLEMENTATION__
IF (TimerData.Cancel) THEN
	TimerPT := T#1MS;
	TimerData.Cancel := FALSE;
ELSE
	TimerPT := REAL_TO_TIME(TimerData.PT * 1000.0);
END_IF;

IF (TimerData.Reset) THEN
	TimerIn := FALSE;
	TimerData.Reset := FALSE;
ELSE
	TimerIn := TimerData.In;
END_IF

TimerData.Timer(IN := TimerIn, PT := TimerPT);
TimerData.Q := TimerData.Timer.Q;
TimerData.On := (TimerData.In AND (NOT TimerData.Q));
TimerData.ET := TIME_TO_REAL(TimerData.Timer.ET) / 1000.0;
TimerData.RT := TimerData.PT - TimerData.ET;
