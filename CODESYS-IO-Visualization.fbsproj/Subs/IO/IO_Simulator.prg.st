__METADATA__
{
  "v3Meta": {
    "objectGuid": "030a1301-75cd-4f4e-867e-5d1ddb7f8ba8",
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
PROGRAM IO_Simulator
VAR_IN_OUT
	Data: IO_Simulator_UDT;
END_VAR
__IMPLEMENTATION__
Data.RandomNumber := OSCAT_BASIC.RDM(Data.RandomNumber);
Data.Noise := Data.RandomNumber * Data.irNoisePct;

Data.ChangeRamp(
	X := Data.irPercent,
	A_UP := Data.irChangeRate,
	A_DN := Data.irChangeRate * -1,
	VU_MAX := Data.irChangeRate,
	VD_MAX := Data.irChangeRate * -1,
	LIMIT_LOW := 0.0,
	LIMIT_HIGH := 100.0
); 

IF (NOT Data.ibDisableOutput) THEN
	Data.orPercent := Data.Noise + Data.ChangeRamp.Y;
	Data.obValue := Data.ibValue;
END_IF;

Data.orValue := Data.irLowLimit + ((Data.orPercent / 100.0) * (Data.irHighLimit - Data.irLowLimit));
