__METADATA__
{
  "v3Meta": {
    "objectGuid": "9a40e059-6a47-4c2e-bc1d-6b0e4137b0ca",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">False</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
PROGRAM SetPLCClock

VAR_INPUT
	TZ: STRING := 'MT';  			// Supports: ET, CT, MT, PT
	DisableDST: BOOL := FALSE;		// Disable Daylight savings
	SetClock: BOOL;					// Set Clock to Set Clock Value
	SetClockValue: DWORD;			// The value used to set the clock
	TZOffsetOverride: INT := 0;		// Time zone offset in minutes (from UTC) override.  Any non-zero number will override the TZ Variable
END_VAR

VAR
	PLCTimeStandard: DT;
	standardMonth: INT;
	standardDay: INT;
	standardHour: INT;
	standardDow: INT;
	TZOffsetStandard: INT;
	DST: BOOL;
	tmp: INT;
	Result: RTS_IEC_Result;
	SetResult : RTS_IEC_RESULT;
END_VAR
__IMPLEMENTATION__
IF (SetClock) THEN
 	SetResult := SysTimeRTCSet(ulTimestamp := SetClockValue);
END_IF;

IF (TZOffsetOverride = 0) THEN
	IF (TZ = 'ET') THEN
		TZOffsetStandard := -300;
	END_IF;
	
	IF (TZ = 'CT') THEN
		TZOffsetStandard := -360;
	END_IF;
	
	IF (TZ = 'MT') THEN
		TZOffsetStandard := -420;
	END_IF;
	
	IF (TZ = 'PT') THEN
		TZOffsetStandard := -480;
	END_IF;
ELSE
	TZOffsetStandard := TZOffsetOverride;
END_IF;

// UTC Time
Lib_GVL.ClockUTC.PLCTime := DWORD_TO_DT(SysTimeRTCGet(Result));
Lib_GVL.ClockUTC.PLCTimeULINT := DT_TO_ULINT(Lib_GVL.ClockUTC.PLCTime);

GetDateYear(Clock := DT_TO_DATE(Lib_GVL.ClockUTC.PLCTime), value => Lib_GVL.ClockUTC.Year);
GetDateMonth(Clock := DT_TO_DATE(Lib_GVL.ClockUTC.PLCTime), value => Lib_GVL.ClockUTC.Month);
GetDayOfMonth(Clock := DT_TO_DATE(Lib_GVL.ClockUTC.PLCTime), value => Lib_GVL.ClockUTC.Day);
GetDTHour(Clock := Lib_GVL.ClockUTC.PLCTime, value => Lib_GVL.ClockUTC.Hour);
GetDTMinute(Clock := Lib_GVL.ClockUTC.PLCTime, value => Lib_GVL.ClockUTC.Minute);
GetDTSecond(Clock := Lib_GVL.ClockUTC.PLCTime, value => Lib_GVL.ClockUTC.Second);
GetDayOfWeek(Clock := DT_TO_DATE(Lib_GVL.ClockUTC.PLCTime), value => Lib_GVL.ClockUTC.DayOfWeek);
Lib_GVL.ClockUTC.SecondsSinceMidnight := (Lib_GVL.ClockUTC.Hour * 3600) + (Lib_GVL.ClockUTC.Minute * 60) + Lib_GVL.ClockUTC.Second;
GetDayOfYear(Clock := DT_TO_DATE(Lib_GVL.ClockUTC.PLCTime), value => Lib_GVL.ClockUTC.DayOfYear);
	
Lib_GVL.ClockUTC.PLCTimeRTS.wYear := INT_TO_UINT(Lib_GVL.ClockUTC.Year);
Lib_GVL.ClockUTC.PLCTimeRTS.wMonth := INT_TO_UINT(Lib_GVL.ClockUTC.Month);
Lib_GVL.ClockUTC.PLCTimeRTS.wDay := INT_TO_UINT(Lib_GVL.ClockUTC.Day);
Lib_GVL.ClockUTC.PLCTimeRTS.wHour := INT_TO_UINT(Lib_GVL.ClockUTC.Hour);
Lib_GVL.ClockUTC.PLCTimeRTS.wMinute := INT_TO_UINT(Lib_GVL.ClockUTC.Minute);
Lib_GVL.ClockUTC.PLCTimeRTS.wSecond := INT_TO_UINT(Lib_GVL.ClockUTC.Second);
Lib_GVL.ClockUTC.PLCTimeRTS.wDayOfWeek := INT_TO_UINT(Lib_GVL.ClockUTC.DayOfWeek);

ClockToString(Clock := Lib_GVL.ClockUTC, ClockString => Lib_GVL.ClockUTC.PLCTimeString);

//Local Time
tmp := TZOffsetStandard * 60;
IF tmp < 0 THEN
	tmp := ABS(tmp);
	PLCTimeStandard := DWORD_TO_DT(DT_TO_DWORD(Lib_GVL.ClockUTC.PLCTime) -  INT_TO_DWORD(tmp));
ELSE
	PLCTimeStandard := DWORD_TO_DT(DT_TO_DWORD(Lib_GVL.ClockUTC.PLCTime) +  INT_TO_DWORD(tmp));
END_IF;

GetDTIsDST(Clock := PLCTimeStandard, IsDST => DST);

IF (DST AND (NOT DisableDST)) THEN
	Lib_GVL.ClockLocal.PLCTime := DWORD_TO_DT(DT_TO_DWORD(PLCTimeStandard) +  INT_TO_DWORD(3600));
ELSE
	Lib_GVL.ClockLocal.PLCTime := PLCTimeStandard;
END_IF;

Lib_GVL.ClockLocal.PLCTimeULINT := DT_TO_ULINT(Lib_GVL.ClockLocal.PLCTime);

GetDateYear(Clock := DT_TO_DATE(Lib_GVL.ClockLocal.PLCTime), value => Lib_GVL.ClockLocal.Year);
GetDateMonth(Clock := DT_TO_DATE(Lib_GVL.ClockLocal.PLCTime), value => Lib_GVL.ClockLocal.Month);
GetDayOfMonth(Clock := DT_TO_DATE(Lib_GVL.ClockLocal.PLCTime), value => Lib_GVL.ClockLocal.Day);
GetDTHour(Clock := Lib_GVL.ClockLocal.PLCTime, value => Lib_GVL.ClockLocal.Hour);
GetDTMinute(Clock := Lib_GVL.ClockLocal.PLCTime, value => Lib_GVL.ClockLocal.Minute);
GetDTSecond(Clock := Lib_GVL.ClockLocal.PLCTime, value => Lib_GVL.ClockLocal.Second);
GetDayOfWeek(Clock := DT_TO_DATE(Lib_GVL.ClockLocal.PLCTime), value => Lib_GVL.ClockLocal.DayOfWeek);
Lib_GVL.ClockLocal.SecondsSinceMidnight := (Lib_GVL.ClockLocal.Hour * 3600) + (Lib_GVL.ClockLocal.Minute * 60) + Lib_GVL.ClockLocal.Second;
GetDayOfYear(Clock := DT_TO_DATE(Lib_GVL.ClockLocal.PLCTime), value => Lib_GVL.ClockLocal.DayOfYear);
	
Lib_GVL.ClockLocal.PLCTimeRTS.wYear := INT_TO_UINT(Lib_GVL.ClockLocal.Year);
Lib_GVL.ClockLocal.PLCTimeRTS.wMonth := INT_TO_UINT(Lib_GVL.ClockLocal.Month);
Lib_GVL.ClockLocal.PLCTimeRTS.wDay := INT_TO_UINT(Lib_GVL.ClockLocal.Day);
Lib_GVL.ClockLocal.PLCTimeRTS.wHour := INT_TO_UINT(Lib_GVL.ClockLocal.Hour);
Lib_GVL.ClockLocal.PLCTimeRTS.wMinute := INT_TO_UINT(Lib_GVL.ClockLocal.Minute);
Lib_GVL.ClockLocal.PLCTimeRTS.wSecond := INT_TO_UINT(Lib_GVL.ClockLocal.Second);
Lib_GVL.ClockLocal.PLCTimeRTS.wDayOfWeek := INT_TO_UINT(Lib_GVL.ClockLocal.DayOfWeek);

ClockToString(Clock := Lib_GVL.ClockLocal, ClockString => Lib_GVL.ClockLocal.PLCTimeString);
