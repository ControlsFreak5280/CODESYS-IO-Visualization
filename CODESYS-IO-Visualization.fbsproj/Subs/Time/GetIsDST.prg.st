__METADATA__
{
  "v3Meta": {
    "objectGuid": "ceb8fcd9-e605-4f54-a685-d791c48e6695",
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
PROGRAM GetIsDST

VAR_INPUT
	month: INT; (* the current month *)
	day: INT;   (* the current day *)
	hour: INT;  (* the current hour (0 - 23), using Local Standard Time *)
	dow: INT;   (* the day of the week (1 = Monday, 7 = Sunday) using Local Standard Time *)
END_VAR

VAR
	prevSunday: INT;
END_VAR

VAR_OUTPUT
	IsDST: BOOL;
END_VAR
__IMPLEMENTATION__
(* DST ON, second Sunday in March, it must be between 3/8 and 3/14 inclusive *)
(* DST OFF, first Sunday in November, it must be between 11/1 and 11/7 inclusive *)

IF (month < 3 OR month > 11) THEN
	IsDST := FALSE;
	RETURN;
END_IF;

IF (month > 3 AND month < 11) THEN
	IsDST := TRUE;
	RETURN;
END_IF;

IF ((month = 11 AND day > 7) OR (month = 3 AND day < 8)) THEN
	IsDST := FALSE;
	RETURN;
END_IF;

IF (month = 3 AND day > 14) THEN
	IsDST := TRUE;
	RETURN;
END_IF;

(* If we get to here, it is either March 8 - 14 or November 1 - 7 *)
prevSunday := day - dow;

IF (month = 3) THEN
	IF (dow = 7) THEN
		IsDST := (hour > 1);
		RETURN;
	END_IF;
	
	IsDST := (prevSunday > 7 AND prevSunday < 15);
	RETURN;
END_IF;

(* If we get here, it is November 1 - 7 *)
IF (dow = 7) THEN
	IsDST := (hour < 2);
	RETURN;
END_IF;

IsDST := prevSunday < 1;
