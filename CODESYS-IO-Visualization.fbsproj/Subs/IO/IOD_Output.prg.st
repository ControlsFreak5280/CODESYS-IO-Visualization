__METADATA__
{
  "v3Meta": {
    "objectGuid": "51f2d523-6294-4100-b96b-d6c28c7c4765",
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
PROGRAM IOD_Output

VAR_IN_OUT
	Data: Channel_UDT;
END_VAR

VAR_INPUT
	ModuleStatus: DINT;
	ModuleCI: BOOL;
END_VAR
__IMPLEMENTATION__
IF (Data.CI OR ModuleCI) THEN
	Data.StatusString := "Control Inhibited";
	Data.StatusCode := -1;
ELSE
	IF (ModuleStatus > 0) THEN
		Data.StatusCode := ModuleStatus;
		Data.StatusString := "Module Failed, check Module Status";
	ELSE
		Data.StatusCode := WORD_TO_DINT(Data.ValueStatus);
		IO_StatusCodeToString(Data := Data);
	END_IF;
END_IF;

Data.Invalid.Value := (Data.StatusCode > 0);
AlarmDigital(alarm := Data.Invalid);

IF (NOT Data.CI) AND (NOT ModuleCI) THEN
	IF (Data.InvertValue) THEN
		Data.ValueRawDigitalOut := (NOT Data.ValueDig);
	ELSE
		Data.ValueRawDigitalOut := Data.ValueDig;
	END_IF;
END_IF;
