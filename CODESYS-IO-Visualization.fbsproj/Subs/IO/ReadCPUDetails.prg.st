__METADATA__
{
  "v3Meta": {
    "objectGuid": "8f8cb705-8d22-4513-9781-0859eb245eaa",
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
PROGRAM ReadCPUDetails
VAR
	getTempCmd : STRING := 'vcgencmd measure_temp | sed $"s/temp=//; s/$'C//$"';
 	getCPUUsageCmd : STRING := 'top -bn1 | awk $'/^%Cpu/ {printf $"%.1f\n$", $$2}$'';
 	getMemoryTotalCmd : STRING := 'free | grep -E $"Mem$" | awk $'{print $$2}$'';
 	getMemoryUsedCmd : STRING := 'free | grep -E $"Mem$" | awk $'{print $$3}$'';
 	getMemoryFreeCmd : STRING := 'free | grep -E $"Mem$" | awk $'{print $$4}$'';

	command1 : STRING;
	commandToRun: INT;	// 0 = Temp, 1 = CPU, 2 = Memory Total, 3 = Memory Used, 4 = Memory Free
	
	stdout : STRING(1000) := '';	
	Result : RTS_IEC_RESULT;
	xExecuteSysP: BOOL;
	xshowCPUInfo: BOOL;
	done: BOOL;
	
	dlyTimer: Timer_UDT := (PT := 0.25);
END_VAR

VAR_OUTPUT
	cpuTemp: REAL;
	cpuUsage: REAL;
	memTotal: DINT;
	memTotal_MB: REAL;
	memUsed: DINT;
	memUsed_MB: REAL;
	memFree: DINT;
	memFree_MB: REAL;
END_VAR
__IMPLEMENTATION__
//Attention: allow shell commands in CODESYSControl.cfg

CASE commandToRun OF 
	0: command1 := getTempCmd;
	1: command1 := getCPUUsageCmd;
	2: command1 := getMemoryTotalCmd;
	3: command1 := getMemoryUsedCmd;
	4: command1 := getMemoryFreeCmd;
END_CASE;

dlyTimer.In := (NOT done);

Timer(TimerData := dlyTimer);

IF (dlyTimer.Q) THEN
	SysProcess.SysProcessExecuteCommand2(pszCommand:=command1, pszStdOut:=stdout, udiStdOutLen:= SIZEOF(stdout),pResult := ADR(Result));
	done := TRUE;
END_IF;

IF (done AND Result = CmpErrors.Errors.ERR_OK) THEN
	IF (LEN(stdout) > 0) THEN
		CASE commandToRun OF
			0: cpuTemp := STRING_TO_REAL(stdout);
			1: cpuUsage := STRING_TO_REAL(stdout);
			2: memTotal := STRING_TO_DINT(stdout);
			   memTotal_MB := DINT_TO_REAL(memTotal) / 1024.0;
			3: memUsed := STRING_TO_DINT(stdout);
			   memUsed_MB := DINT_TO_REAL(memUsed) / 1024.0;
			4: memFree := STRING_TO_DINT(stdout);
			   memFree_MB := DINT_TO_REAL(memFree) / 1024.0;
		END_CASE;
	END_IF;
	
	commandToRun := commandToRun + 1;
	IF (commandToRun > 4) THEN
		commandToRun := 0;
	END_IF;
	
	done := FALSE;
END_IF;
