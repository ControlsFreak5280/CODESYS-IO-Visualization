__METADATA__
{
  "v3Meta": {
    "objectGuid": "65d220dc-b41d-411e-856d-8f0e132a1397",
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
PROGRAM Equip_Statistics

VAR_IN_OUT
	Data: Equip_Statistics_UDT;
END_VAR
__IMPLEMENTATION__
// Process Runtime
Data.RuntimeCumulative.Enable := Data.StatInput;
Runtime(Data := Data.RuntimeCumulative);

Data.RuntimeDaily.Enable := Data.StatInput;
Runtime(Data := Data.RuntimeDaily);

Data.RuntimeMonthly.Enable := Data.StatInput;
Runtime(Data := Data.RuntimeMonthly);

// Process Available Time
Data.AvailableTime.Enable := Data.AvailalbeInput;
Runtime(Data := Data.AvailableTime);

Data.AvailableTimeDaily.Enable := Data.AvailalbeInput;
Runtime(Data := Data.AvailableTimeDaily);

Data.AvailableTimeMonthly.Enable := Data.AvailalbeInput;
Runtime(Data := Data.AvailableTimeMonthly);

// Process Out of Service Time
Data.OOSTime.Enable := Data.OOSInput;
Runtime(Data := Data.OOSTime);

Data.OOSTimeDaily.Enable := Data.OOSInput;
Runtime(Data := Data.OOSTimeDaily);

Data.OOSTimeMonthly.Enable := Data.OOSInput;
Runtime(Data := Data.OOSTimeMonthly);

// Process Starts
IF ((NOT Data.LastStat) AND Data.StatInput) THEN
	Data.StartsCumulative := Data.StartsCumulative + 1;
	Data.StartsToday := Data.StartsToday + 1;
	Data.StartsMonth := Data.StartsMonth + 1;
	Data.ActualStartsThisHour := Data.ActualStartsThisHour + 1;
END_IF;
Data.LastStat := Data.StatInput;

// Daily Stats
IF (Data.RuntimeDaily.ResetAccumulator AND (NOT Data.DailyResetDone)) THEN
	Data.StartsYesterday := Data.StartsToday;
	Data.StartsToday := 0;
	Data.DailyResetDone := TRUE;
END_IF;

IF (NOT Data.RuntimeDaily.ResetAccumulator) THEN
	Data.DailyResetDone := FALSE;
END_IF;

//Monthly Stats
IF (Data.RuntimeMonthly.ResetAccumulator AND (NOT Data.MonthlyResetDone)) THEN
	Data.StartsLastMonth := Data.StartsMonth;
	Data.StartsMonth := 0;
	Data.MonthlyResetDone := TRUE;
END_IF;

IF (NOT Data.RuntimeMonthly.ResetAccumulator) THEN
	Data.MonthlyResetDone := FALSE;
END_IF;

//Hour Stats
IF ((Lib_GVL.ClockLocal.Minute = 0) AND (Lib_GVL.ClockLocal.Second < 5)) THEN
	Data.ActualStartsThisHour := 0;
END_IF;

Data.ExcessiveStartsPerHour := (Data.ActualStartsThisHour > Data.StartsPerHourLimit); 

