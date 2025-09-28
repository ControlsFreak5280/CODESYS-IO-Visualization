__METADATA__
{
  "v3Meta": {
    "objectGuid": "8ebd46fb-dc28-49dd-a9ea-09e71f42c176",
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
PROGRAM Process_RotorkValve_Auto

VAR_IN_OUT
	valve: Equip_UDT;
END_VAR
__IMPLEMENTATION__
Process_RotorkValve_Inputs(valve := valve);

Process_RotorkValve_Alarms(valve := valve);

IF (valve.HMI.REAL0[1] <= 0.0) THEN
	valve.HMI.REAL0[1] := 100.0;
END_IF;

IF (valve.HMI.REAL0[1] <= valve.HMI.REAL0[0]) THEN
	valve.HMI.REAL0[1] := (valve.HMI.REAL0[0] + 1.0);
END_IF

IF (valve.HMI.REAL0[1] > 100.0) THEN
	valve.HMI.REAL0[1] := 100.0;
END_IF;

IF (valve.HMI.REAL0[0] >= valve.HMI.REAL0[1]) THEN
	valve.HMI.REAL0[0] := (valve.HMI.REAL0[1] - 1.0);
END_IF;

IF (valve.HMI.REAL0[0] < 0.0) THEN
	valve.HMI.REAL0[0] := 0.0;
END_IF;

IF (valve.Timer0[0].PT <= 0.01) THEN
	valve.Timer0[0].PT := 60.0;
END_IF;

// Time delay open or close - uses Timer[0] defaulted to 1 minute
valve.Timer0[0].In := valve.PLC.BOOL0[51] OR valve.PLC.BOOL0[52];
Timer(TimerData := valve.Timer0[0]);

IF (valve.Timer0[0].Q) THEN
	IF (valve.PLC.BOOL0[51]) THEN
		valve.PLC.BOOL0[50] := TRUE;
	END_IF;	

	IF (valve.PLC.BOOL0[52]) THEN
		valve.PLC.BOOL0[50] := FALSE;
	END_IF;	

	valve.PLC.BOOL0[51] := FALSE;
	valve.PLC.BOOL0[52] := FALSE;
END_IF;

(* *********** Valve Control Mode *********** *) 
// Check the Valve Control Mode to be valid
IF (valve.HMI.SWITCH0[1] < 0) THEN
	valve.HMI.SWITCH0[1] := 0;
END_IF;

IF (valve.HMI.SWITCH0[1] > 2) THEN
	valve.HMI.SWITCH0[1] := 2;
END_IF;

valve.PLC.BOOL0[49] := (valve.Remote AND (valve.HMI.SWITCH0[1] = 2));

IF (valve.Remote) THEN
	CASE valve.HMI.SWITCH0[1] OF
		0: // OFF
			valve.Raw.REAL0[20] := 0.0;

		1: // Manual Control
			IF (valve.OpenCmd) THEN
				valve.OpenCmd := FALSE;
				valve.HMI.REAL0[20] := valve.HMI.REAL0[1];
			END_IF;
			
			IF (valve.CloseCmd) THEN
				valve.CloseCmd := FALSE;
				valve.HMI.REAL0[20] := valve.HMI.REAL0[0];
			END_IF;
			valve.Raw.REAL0[20] := valve.HMI.REAL0[20];
	
		2: // Auto Control
			CASE valve.PLC.SWITCH0[2] OF
				1: valve.HMI.REAL0[20] := valve.HMI.REAL0[2];
				2: valve.HMI.REAL0[20] := valve.HMI.REAL0[3];
				3: valve.HMI.REAL0[20] := valve.HMI.REAL0[4];
			ELSE
				IF (valve.PLC.BOOL0[50]) THEN
					valve.HMI.REAL0[20] := valve.HMI.REAL0[1];
				ELSE
					valve.HMI.REAL0[20] := valve.HMI.REAL0[0];
				END_IF;
			END_CASE

			valve.Raw.REAL0[20] := valve.HMI.REAL0[20];
	END_CASE;
ELSE
	valve.Raw.REAL0[20] := 0.0;
END_IF;

Process_RotorkValve_Outputs(valve := valve);
