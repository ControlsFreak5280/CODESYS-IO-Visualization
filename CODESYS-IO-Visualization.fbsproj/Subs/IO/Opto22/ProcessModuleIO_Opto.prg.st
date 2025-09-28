__METADATA__
{
  "v3Meta": {
    "objectGuid": "d079fbae-866c-4219-a973-fa38c2124e87",
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
PROGRAM ProcessModuleIO_Opto

VAR_IN_OUT
	Rack: Rack_Opto_RIO_UDT;
	Module: Module_Opto_UDT;
END_VAR

VAR
	i: INT;
END_VAR
__IMPLEMENTATION__
FOR i := 0 TO Lib_GVL.MaxPointCount DO
	CASE Module.Channels[i].ChannelType OF
		IOChannelType.ctAO:
			IOA_Output(Data := Module.Channels[i], ModuleStatus := Module.Status, ModuleCI := Module.CI);
		
		IOChannelType.ctDO:
			IOD_Output(Data := Module.Channels[i], ModuleStatus := Module.Status, ModuleCI := Module.CI);
	END_CASE;

	CASE Module.Channels[i].ChannelType OF
		IOChannelType.ctAI:
			Module.Channels[i].ValueRawAnalog := Module.IO[i].Ana;
			Module.Channels[i].ValueStatus.0 := FPU.IsRealNaN(Module.IO[i].Ana) OR 
				(Module.Channels[i].ValueRawAnalog > Module.Channels[i].ZeroRaw + (Module.Channels[i].SpanRaw * 1.04)) OR 
				(Module.Channels[i].ValueRawAnalog < Module.Channels[i].ZeroRaw - (Module.Channels[i].SpanRaw * 0.04));
		
		IOChannelType.ctAO:
			Module.IO[i].Ana := Module.Channels[i].ValueRawAnalogOut;
			Module.Channels[i].ValueRawAnalog := Module.IO[i].Ana;
			Module.Channels[i].ValueStatus.0 := 
				(Module.Channels[i].ValueRawAnalog > Module.Channels[i].ZeroRaw + (Module.Channels[i].SpanRaw * 1.04)) OR 
				(Module.Channels[i].ValueRawAnalog < Module.Channels[i].ZeroRaw - (Module.Channels[i].SpanRaw * 0.04));
			
		IOChannelType.ctDI:
			Module.Channels[i].ValueRawDigital := Module.IO[i].Dig;
			Module.Channels[i].ValueStatus := 0;

		IOChanneltype.ctDO:
			Module.IO[i].Dig := Module.Channels[i].ValueRawDigitalOut;
			Module.Channels[i].ValueRawDigital := Module.IO[i].Dig;
			Module.Channels[i].ValueStatus := 0;
	END_CASE;

	CASE Module.Channels[i].ChannelType OF
		IOChannelType.ctAI:
			IOA_Input(Data := Module.Channels[i], ModuleStatus := Module.Status, ModuleCI := Module.CI);
			
		IOChanneltype.ctDI:
			IOD_Input(Data := Module.Channels[i], ModuleStatus := Module.Status, ModuleCI := Module.CI);
	END_CASE;
END_FOR;
