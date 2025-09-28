__METADATA__
{
  "v3Meta": {
    "objectGuid": "ac6a8131-c4c6-4e28-ac6c-b30390678bef",
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
PROGRAM ValveSimulator

VAR_IN_OUT
	Data: ValveSimulator_UDT;
END_VAR

VAR
END_VAR
__IMPLEMENTATION__
Data.RandomNumber := OSCAT_BASIC.RDM(Data.RandomNumber);

IF (NOT Data.obClosed) AND (NOT Data.obOpened) THEN
	Data.Noise := Data.RandomNumber * Data.irNoisePct;
ELSE
	Data.Noise := 0.0;
END_IF;

Data.CoastTimer(
	IN := (NOT Data.ibOpenCmd) AND (NOT Data.ibCloseCmd),
	PT := REAL_TO_TIME(Data.irCoastTime * 1000.0)
);

IF (Data.ibAuto AND (NOT Data.ibDisableCommands)) THEN
	IF (Data.ibUsePosCmd) THEN
		Data.PosCmd := Data.irPosCmd;
	ELSE
		IF (Data.ibOpenCmd) AND (NOT Data.ibCloseCmd) THEN
			Data.PosCmd := 100.0;
		END_IF;
		
		IF (Data.ibCloseCmd) AND (NOT Data.ibOpenCmd) THEN
			Data.PosCmd := 0.0;
		END_IF;
		
		IF Data.CoastTimer.Q THEN
			Data.PosCmd := Data.orPosition;
		END_IF;
	END_IF;
END_IF;

Data.ChangeRamp(
	X := Data.PosCmd,
	A_UP := Data.irChangeRate,
	A_DN := Data.irChangeRate * -1,
	VU_MAX := Data.irChangeRate,
	VD_MAX := Data.irChangeRate * -1,
	LIMIT_LOW := 0.0,
	LIMIT_HIGH := 100.0
); 

Data.orPosition := Data.Noise + Data.ChangeRamp.Y;

Data.obClosed := (Data.orPosition < Data.irClosedPct);
Data.obOpened := (Data.orPosition > Data.irOpenedPct);
Data.obRemote := Data.ibAuto;
Data.obFailed := Data.ibFault;
Data.obAlarm := Data.ibAlarm;
