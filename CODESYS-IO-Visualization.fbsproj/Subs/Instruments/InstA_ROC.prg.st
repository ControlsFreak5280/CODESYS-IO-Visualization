__METADATA__
{
  "v3Meta": {
    "objectGuid": "2af53a53-9071-48a4-89d2-d18fff954f4d",
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
PROGRAM InstA_ROC

VAR_IN_OUT
	Data: InstA_ROC_UDT;
END_VAR
__IMPLEMENTATION__
// Enable Persist Storage
IF (Data.PersistSize = 0) THEN
	Data.PersistSize := SIZEOF(InstA_ROC_UDT);
END_IF;

InstA(Data := Data);

(* Rate Of Change Calculations *)
IF (Data.ROCSampleNum < 1) THEN
	Data.ROCSampleNum := 1;
END_IF;

IF (Data.ROCSampleNum > 60) THEN
	Data.ROCSampleNum := 60;
END_IF;

IF (Data.ROCCount < 0) THEN
	Data.ROCCount := 0;
END_IF;

IF (Data.ROCCount > 60) THEN
	Data.ROCCount := 60;
END_IF;

(* Reset the rate of change - Value count > 1 means this block as been running for at least 2 seconds and should have good data *)
IF (Data.ValueCount > 1) THEN
	IF (Data.ROCReset) THEN
		Data.ROCReset := FALSE;
		FOR Data.j := 1 TO 60 BY 1 DO
			Data.ROCBuffer[Data.j] := Data.CurVal.Value;
		END_FOR;
	END_IF;
END_IF;

(* Run ROC Timer *)
Data.ROCTimer.PT := Data.ROCSampleTime;
Data.ROCTimer.In := (NOT Data.ROCTimer.Q);
Timer(TimerData := Data.ROCTimer);

IF (Data.ROCTimer.Q) THEN
	Data.ROCCount := Data.ROCCount + 1;
	IF (Data.ROCCount >= 60) THEN
		Data.ROCCount := 60;
	END_IF;
	
	IF (Data.ROCCount > 2) THEN
		Data.k := Data.ROCCount - 1;
		WHILE Data.k >= 1 DO
			Data.l := Data.k + 1;
			Data.ROCBuffer[Data.l] := Data.ROCBuffer[Data.k];
			Data.k := Data.k - 1;
		END_WHILE;
		Data.ROCBuffer[1] := Data.CurVal.Value;
	ELSE
		Data.ROCBuffer[1] := Data.CurVal.Value;
	END_IF;
END_IF;

IF (Data.ValueCount > 1) AND (NOT Data.OOS.Active) THEN
	Data.CurValROC := Data.CurVal.Value - Data.ROCBuffer[Data.ROCSampleNum - 1];
ELSE
	Data.CurValROC := 0.0;
END_IF;

CASE Data.CurValROC2_Mode OF
	1: // (m * x) + b
		Data.CurValROC2 := (Data.CurValROC * Data.CurValROC2_Mult) + Data.CurValROC2_Offset;

	2: // (m * x) + b
		Data.CurValROC2 := (Data.CurValROC + Data.CurValROC2_Offset) * Data.CurValROC2_Mult;
END_CASE;

Data.ROCHi.Value := Data.CurValROC;
Data.ROCLo.Value := Data.CurValROC;

AlarmAnalog(alarm := Data.ROCHi);
AlarmAnalog(alarm := Data.ROCLo);
