__METADATA__
{
  "v3Meta": {
    "objectGuid": "1c79d1bc-79b1-4a8f-bf54-6509333e8e7c",
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
PROGRAM IOA_Output

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
	IF (ModuleStatus  > 0) THEN
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
	IF (Data.SpanEu <> 0.0) THEN
		Data.ValueRawAnalogOut := Data.ZeroRaw + (((Data.ValueEu - Data.ZeroEu) / Data.SpanEu) * Data.SpanRaw);
	ELSE
		Data.ValueRawAnalogOut := 0.0;
	END_IF;
	
	IF (Data.ValueRawAnalogOut > (Data.ZeroRaw + (Data.SpanRaw * 1.04))) THEN
		Data.ValueRawAnalogOut := Data.ZeroRaw + Data.SpanRaw;
	END_IF;
	
	IF (Data.ValueRawAnalogOut < (Data.ZeroRaw - (Data.SpanRaw * 0.04))) THEN
		Data.ValueRawAnalogOut := Data.ZeroRaw;
	END_IF;
END_IF;

IF (Data.SpanEu <> 0.0) THEN
	Data.ValuePct := ((Data.ValueEu - Data.ZeroEu) / Data.SpanEu) * 100.0;
	IF (Data.ValuePct > 100.0) THEN
		Data.ValuePct := 100.0;
	END_IF;
	IF (Data.ValuePct < 0.0) THEN
		Data.ValuePct := 0.0;
	END_IF;
ELSE
	Data.ValuePct := 0.0;
END_IF;
