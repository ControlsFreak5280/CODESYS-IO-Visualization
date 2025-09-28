__METADATA__
{
  "v3Meta": {
    "objectGuid": "b9232d02-9d76-46e6-973f-c4dcf3e09d28",
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
PROGRAM ValueRamp

VAR_IN_OUT
	value: ValueRamp_UDT;
END_VAR

VAR
	DBMin: REAL;
	DBMax: REAL;
	DoRamp: BOOL;
END_VAR
__IMPLEMENTATION__
CycleTime(value := value.CT);

IF (value.CT.mSec = 0) THEN
	RETURN;
END_IF;

DBMin := value.In - value.DB;
DBMax := value.In + value.DB;

DoRamp := TRUE;

IF (value.Track) THEN
	DoRamp := FALSE;
END_IF;

IF (value.Out > DBMin) AND (value.Out < DBMax) THEN
	DoRamp := FALSE;
END_IF;

IF (NOT value.Disable) THEN
	IF (DoRamp) THEN
		IF (value.Out < value.In) THEN
			value.Out := value.Out + (ABS(value.Rate) * value.CT.Sec);
		ELSE
			value.Out := value.Out - (ABS(value.Rate) * value.CT.Sec);
		END_IF;	
	ELSE
		value.Out := value.In;
	END_IF;
END_IF;

value.Err := value.Out - value.In;

IF (value.Err > 0.0) THEN
	value.Status := ValueRampStatus_ENUM.OutHigh;
ELSIF (value.Err < 0.0) THEN
	value.Status := ValueRampStatus_ENUM.OutLow;
ELSE
	value.Status := ValueRampStatus_ENUM.Matched;
END_IF;
