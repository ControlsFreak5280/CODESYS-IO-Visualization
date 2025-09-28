__METADATA__
{
  "v3Meta": {
    "objectGuid": "4f0de4af-1b13-4e35-8ffc-9ced9bcde3d0",
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
{attribute "analysis" := "-90"}PROGRAM Rack_Opto_RIO

VAR_IN_OUT
	Rack: Rack_Opto_RIO_UDT;
END_VAR

VAR
	TempStat: DWORD;
	i: INT;
END_VAR
__IMPLEMENTATION__
IF (Rack.CI OR (NOT Rack.InUse)) THEN
	Rack.Status := -1;
	Rack.StatusString := "Control Inhibit or Disabled";
	ProcessModules();
	RETURN;
END_IF;

IF (Rack.Rack_IO = 0) THEN
	Rack.Status := 255;
	Rack.StatusString := "Invalid Pointer for IO Rack";
	ProcessModules();
	RETURN;	
END_IF;

Rack.Deactivated := FALSE;
Rack.ConfigFinished := TRUE;
Rack.ConfigStepError := FALSE;
Rack.Error := FALSE;
Rack.IpAddr := "Unknown";
Rack.DiagString := "";

TempStat := 0;
TempStat.0 := Rack.Deactivated;
TempStat.1 := Rack.Error;
TempStat.2 := Rack.ConfigStepError;
TempStat.3 := NOT Rack.ConfigFinished;

Rack.Status := DWORD_TO_DINT(TempStat);
Rack.StatusString := Rack.DiagString;

ProcessModules();

