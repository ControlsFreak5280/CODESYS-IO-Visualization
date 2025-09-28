__METADATA__
{
  "v3Meta": {
    "objectGuid": "33f70fc6-eeed-4b16-b42b-ada420e1be16",
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
PROGRAM IOA_Input

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
	IF (Data.SimulationEnable AND Simulation.SimulationEnable) THEN
		ModuleStatus := 0;
		Data.ValueStatus := 0;
		Data.StatusCode := Data.Simulator.odiStatusCode;
		Data.StatusString := Data.Simulator.osStatusCode;
	ELSE
		IF (ModuleStatus > 0) THEN
			Data.StatusCode := ModuleStatus;
			Data.StatusString := "Module Failed, check Module Status";
		ELSE
			Data.StatusCode := WORD_TO_DINT(Data.ValueStatus);
			IO_StatusCodeToString(Data := Data);
		END_IF;
	END_IF;
END_IF;

Data.Invalid.Value := (Data.StatusCode > 0);
AlarmDigital(alarm := Data.Invalid);

IF (NOT FPU.IsRealNaN(Data.ValueRawAnalog)) THEN
	IF (Data.ValueRawAnalog > (Data.ZeroRaw + (Data.SpanRaw * 1.04))) THEN
		Data.ValueRawAnalog := Data.ZeroRaw + Data.SpanRaw;
	END_IF;
	
	IF (Data.ValueRawAnalog < (Data.ZeroRaw - (Data.SpanRaw * 0.04))) THEN
		Data.ValueRawAnalog := Data.ZeroRaw;
	END_IF;
END_IF;

IF (NOT Data.CI) AND (NOT ModuleCI) THEN
	IF (Data.SimulationEnable AND Simulation.SimulationEnable) THEN
		IO_Simulator(Data := Data.Simulator);
		Data.ValueEu := Data.Simulator.orValue;		
	ELSE
		IF (NOT FPU.IsRealNaN(Data.ValueRawAnalog)) THEN
			IF (Data.SpanRaw <> 0.0) THEN
				Data.ValueEu := Data.ZeroEu + (((Data.ValueRawAnalog - Data.ZeroRaw) / Data.SpanRaw) * Data.SpanEu);
			ELSE
				Data.ValueEu := 0.0;
			END_IF;
		ELSE
			Data.ValueEu := 0.0;
		END_IF;
	END_IF;
END_IF;

IF (NOT FPU.IsRealNaN(Data.ValueRawAnalog)) THEN
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
ELSE
	Data.ValuePct := 0.0;
END_IF;
