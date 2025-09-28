__METADATA__
{
  "v3Meta": {
    "objectGuid": "22512b0b-a2ab-4455-87b1-7b9c336e6a69",
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
PROGRAM CodeSysCPU

VAR_IN_OUT
	cpu: CodeSysCPU_UDT;
END_VAR

__IMPLEMENTATION__
IF (cpu.PersistSize = 0) THEN
	cpu.PersistSize := SIZEOF(CodeSysCPU_UDT);
END_IF;

IF (cpu.Init OR cpu.AppResult <> 0) THEN
	cpu.App := AppGetCurrent(pResult := ADR(cpu.AppResult));
	IF (cpu.App <> 0) AND(cpu.AppResult = 0) THEN
		cpu.AppInfo := AppGetApplicationInfo(pApp := cpu.App, pResult := ADR(cpu.AppInfoResult));
		IF (cpu.AppInfo <> 0) AND (cpu.AppInfoResult = 0) THEN
 			cpu.AppProjectName := TO_WSTRING(cpu.AppInfo^.pstProjectName^);
 			cpu.AppAuthor := TO_WSTRING(cpu.AppInfo^.pstAuthor^);
 			cpu.AppVersion := TO_WSTRING(cpu.AppInfo^.pstVersion^);
 			cpu.AppDescription := TO_WSTRING(cpu.AppInfo^.pstDescription^);
 			cpu.AppProfile := TO_WSTRING(cpu.AppInfo^.pstProfile^);
			
			GetDateYear(Clock := DT_TO_DATE(cpu.AppInfo^.dtLastChanges), value => cpu.AppLastChange.Year);
			GetDateMonth(Clock := DT_TO_DATE(cpu.AppInfo^.dtLastChanges), value => cpu.AppLastChange.Month);
			GetDayOfMonth(Clock := DT_TO_DATE(cpu.AppInfo^.dtLastChanges), value => cpu.AppLastChange.Day);
			GetDTHour(Clock := cpu.AppInfo^.dtLastChanges, value => cpu.AppLastChange.Hour);
			GetDTMinute(Clock := cpu.AppInfo^.dtLastChanges, value => cpu.AppLastChange.Minute);
			GetDTSecond(Clock := cpu.AppInfo^.dtLastChanges, value => cpu.AppLastChange.Second);
			cpu.AppLastChange.DateTimeString := DateTimeStampToString(DateTimeStamp := cpu.AppLastChange);
		END_IF;
	END_IF;
	cpu.Init := FALSE;
END_IF;

CycleTime(value := cpu.CT);
cpu.SampleSeconds := cpu.SampleSeconds + cpu.CT.Sec;

// only read memory and cpu data every 10 seconds
IF (cpu.SampleSeconds < 10.0) THEN
	RETURN;
END_IF;

cpu.SampleSeconds := 0.0;

// Get CPU Info - Raspberry Pi ONLY - requires Shell Access enabled in /etc/codesyscontrol/CODESYSControl_User.cfg file
// Add
//	[SysProcess]
//  Command=AllowAll
ReadCPUDetails();

cpu.CpuUsage := ReadCPUDetails.cpuUsage;
cpu.Temperature := ReadCPUDetails.cpuTemp;
cpu.MemFree := ReadCPUDetails.memFree;
cpu.MemFree_MB := ReadCPUDetails.memFree_MB;
cpu.memTotal := ReadCPUDetails.memTotal;
cpu.memTotal_MB := ReadCPUDetails.memTotal_MB;
cpu.memUsed := ReadCPUDetails.memUsed;
cpu.memUsed_MB := ReadCPUDetails.memUsed_MB;
