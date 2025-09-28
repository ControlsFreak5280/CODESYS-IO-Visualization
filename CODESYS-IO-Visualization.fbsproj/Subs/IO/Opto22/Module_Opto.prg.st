__METADATA__
{
  "v3Meta": {
    "objectGuid": "9f748447-171f-49b8-8c65-b2758c119fcc",
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
PROGRAM Module_Opto

VAR_IN_OUT
	Rack: Rack_Opto_RIO_UDT;
	Module: Module_Opto_UDT;
END_VAR

VAR
	TempStat: DWORD;
	i: INT;
END_VAR
__IMPLEMENTATION__
IF (Module.CI OR (NOT Module.InUse) OR Rack.CI OR (NOT Rack.InUse)) THEN
	Module.Status := -1;
	Module.StatusString := "Control Inhibit or Disabled";
ELSE
	IF (Module.Module_IO <> 0) THEN
		Module.IsRIO := FALSE;

		IF (Module.SimulationEnable AND Simulation.SimulationEnable) THEN
			Module.Status := Module.Simulator.odiStatusCode;
			Module.StatusString := Module.Simulator.osStatusCode;
		ELSE
			Module.ModuleTypeId := Module.Module_IO^._pModType;
			Module.ModuleConfigFailed := Module.Module_IO^._bConfigureModuleFailed;
			Module.ModuleConfigFound := Module.Module_IO^._bConfigureModuleFound;
			Module.ModuleMissing := Module.Module_IO^._bMissingModule;
			Module.Deactivated := Module.Module_IO^._bDeactivated;
			Module.NumberOfChannels := Module.Module_IO^._udiNumChannels;
		END_IF;
	ELSIF (Module.RIO_IO <> 0) THEN
		Module.IsRIO := TRUE;

		IF (Module.SimulationEnable AND Simulation.SimulationEnable) THEN
			Module.Status := Module.Simulator.odiStatusCode;
			Module.StatusString := Module.Simulator.osStatusCode;
		ELSE
			Module.ModuleTypeId := 0;
			Module.ModuleConfigFailed := NOT Module.RIO_IO^.xConfigFinished;
			Module.ModuleConfigFound := Module.RIO_IO^.xConfigFinished;
			Module.ModuleMissing := Module.RIO_IO^.xError;
			Module.Deactivated := FALSE;
			Module.NumberOfChannels := 10;
		END_IF;
	ELSE
		Module.Status := 255;
		Module.StatusString := "Invalid Pointer for IO Module";
	END_IF;
	
	IF (Module.Module_IO = 0 AND Module.RIO_IO = 0) THEN
		Module.Status := 255;
		Module.StatusString := "Invalid Pointer for IO Module";
	ELSE
		TempStat := 0;
		TempStat.0 := Module.Deactivated;
		TempStat.1 := Module.ModuleConfigFailed;
		TempStat.2 := Module.ModuleMissing;
		TempStat.3 := Module.ModuleMissing;
		
		Module.Status := DWORD_TO_DINT(TempStat);

		CASE TempStat OF
			0: 
				Module.StatusString := "";
			1: 
				Module.StatusString := "Module Deactivated";
			2..3: 
				Module.StatusString := "Module Configuration Failure";
			4..7: 
				Module.StatusString := "Module Not Found";
			8..15: 
				Module.StatusString := "Module Missing";
		ELSE
				Module.StatusString := "Module Failed";
		END_CASE;
	END_IF;
END_IF;

Module.Failed.Enable := Module.InUse AND Rack.InUse AND (NOT Module.CI) AND (NOT Rack.CI);
Module.Failed.Value := (Module.Status > 0);
AlarmDigital(alarm := Module.Failed);
 
