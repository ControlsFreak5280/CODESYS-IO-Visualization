__METADATA__
{
  "v3Meta": {
    "objectGuid": "4db9fbb5-e5b1-4811-84ad-121e8a53c83f",
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
PROGRAM InstD

VAR_IN_OUT
	Data: InstD_UDT;
END_VAR

VAR
END_VAR
__IMPLEMENTATION__
// Enable Persist Storage
IF (Data.PersistSize = 0) THEN
	Data.PersistSize := SIZEOF(InstD_UDT);
END_IF;

// Handle Manual
CASE Data.Mode OF
	0:	// Online Mode
		Data.TempVal := Data.RawVal;
		Data.ManualValue := Data.RawVal;
		Data.StatusCode := Data.RawValStatusCode;
ELSE	// Manual Mode
	Data.TempVal := Data.ManualValue;
	Data.StatusCode := 253;
END_CASE;

// Set the output value
IF (Data.DeviceFail.Active) THEN
	CASE Data.FailAction OF
		0: Data.CurVal := Data.FailValue;
		1: Data.CurVal := Data.CurVal;
	ELSE
		Data.CurVal := Data.TempVal;
	END_CASE;	
ELSE
	Data.CurVal := Data.TempVal;
END_IF;

// Set GlobalStatusCode and String
CASE Data.StatusCode OF
	128: Data.GlobalStatusString := "OK";
	253: Data.GlobalStatusString := "Manual Mode";
ELSE
	IF (Data.StatusCode < 128) OR ((Data.StatusCode > 128) AND (Data.StatusCode < 256)) THEN
		Data.GlobalStatusString := "Warning";
	END_IF;
	
	IF (Data.StatusCode > 255) THEN
		Data.GlobalStatusString := "Failed";
	END_IF;
END_CASE;

Data.GlobalStatusCode := Data.StatusCode + 65536;

// Set OOS Inputs
AlarmDigital(alarm := Data.OOS);
Data.DeviceFail.OOS := Data.OOS.Active;
Data.DeviceWarning.OOS := Data.OOS.Active;
Data.Process.OOS := Data.OOS.Active;

// Set the Alarm Display Names
Data.DeviceFail.DisplayName := "Fail";
Data.DeviceWarning.DisplayName := "Warning";
Data.Process.DisplayName := "Process";

// Run the Alarms
Data.DeviceFail.Value := (Data.StatusCode > 255);
Data.DeviceWarning.Value := (Data.StatusCode > 128);
Data.Process.Value := Data.CurVal;

AlarmDigital(alarm := Data.DeviceFail);
AlarmDigital(alarm := Data.DeviceWarning);
AlarmDigital(alarm := Data.Process);

Data.MaxSeverity := MAX(Data.DeviceFail.Severity, MAX(Data.DeviceWarning.Severity, Data.Process.Severity));

IF (Data.DeviceFail.AlarmLevel + Data.DeviceWarning.AlarmLevel + Data.Process.AlarmLevel) > 0 THEN
	Data.AlarmLevel := 6;
	
	IF (Data.DeviceFail.AlarmLevel > 0) AND (Data.DeviceFail.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.DeviceFail.AlarmLevel;
	END_IF;
	
	IF (Data.DeviceWarning.AlarmLevel > 0) AND (Data.DeviceWarning.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.DeviceWarning.AlarmLevel;
	END_IF;
	

	IF (Data.Process.AlarmLevel > 0) AND (Data.Process.AlarmLevel < Data.AlarmLevel) THEN
		Data.AlarmLevel := Data.Process.AlarmLevel;
	END_IF;
ELSE
	Data.AlarmLevel := 0;
END_IF;

