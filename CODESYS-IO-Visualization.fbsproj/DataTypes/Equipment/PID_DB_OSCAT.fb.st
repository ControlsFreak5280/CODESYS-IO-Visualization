__METADATA__
{
  "v3Meta": {
    "objectGuid": "a8cbbf34-3cb2-4c56-9757-88cbc0a0ccc1",
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
// PID Function Block using the OSCAT PID for control

FUNCTION_BLOCK PID_DB_OSCAT

VAR_INPUT
	irInput: REAL;					// Process Variable Input
	irSetpoint: REAL;				// Process Control Setpoint
	iPIDSettings: PIDSettings_UDT;
	ibTrack: BOOL;					// Disable PID - Output will track Reset Input
	irReset: REAL;					// Sets Output to this value when track is ON
	irLoLimit: REAL;				// The Lo Limit to clamp the output
	irHiLimit: REAL;				// The Hi Limit to clamp the output
	irLoLimitSP: REAL := 0.0;		// The Lo Limit to clamp the Setpoint value
	irHiLimitSP: REAL := 1000000.0;	// The Hi Limit to clamp the Setpoint value
END_VAR

VAR_OUTPUT
	orOutput: REAL;					// The controlling output
	orDeviation: REAL;				// Difference between setpoint and process variable
	obDeadbandActive: BOOL;			// ON when deadband is active
	obLimitActive: BOOL;			// ON when the output is at the Lo or Hi Limits
	obTrackActive: BOOL;			// ON when track is active
END_VAR

VAR
	lvrDB: REAL;
END_VAR

VAR
	FB_PID: OSCAT_BASIC.CTRL_PID;;
END_VAR
__IMPLEMENTATION__
IF (iPIDSettings.DB_Enable) THEN
	lvrDB := iPIDSettings.DB;
ELSE
	lvrDB := 0.0;
END_IF

FB_PID(
	ACT:=irInput,
	SET:=irSetpoint,
	SUP:=lvrDB,
	OFS:=0.0,
	KP:=iPIDSettings.P / 1000.0,
	TN:=iPIDSettings.I,
	TV:=iPIDSettings.D,
	M_I:=irReset,
	MAN:=ibTrack,
	LL:=irLoLimit,
	LH:=irHiLimit
);

orOutput := FB_PID.Y;
orDeviation := FB_PID.DIFF;
obTrackActive := ibTrack;
obLimitActive := (orOutput >= irHiLimit) OR (orOutput <= irLoLimit);
obDeadbandActive := (NOT ibTrack) AND (ABS(FB_PID.DIFF) <= lvrDB);
