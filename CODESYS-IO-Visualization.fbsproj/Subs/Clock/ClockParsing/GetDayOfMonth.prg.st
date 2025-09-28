__METADATA__
{
  "v3Meta": {
    "objectGuid": "9eaf0b4d-d4ad-4d82-8673-047a857cc441",
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
PROGRAM GetDayOfMonth

VAR_INPUT
	Clock: DATE;
END_VAR

VAR_OUTPUT
	value: INT;
END_VAR

VAR
	leap: BOOL;
	MonthDays : ARRAY[1..12] OF INT :=[ 0,31,59,90,120,151,181,212,243,273,304,334 ];
END_VAR
__IMPLEMENTATION__
GetDayOfYear(Clock := Clock, value => value);
GetDateLeapYear(Clock := Clock, value => leap);
value := value - BOOL_TO_INT(leap);

IF value > MonthDays[9] THEN
	IF value > MonthDays[11] THEN
		IF value > MonthDays[12] THEN
			value := value - MonthDays[12];
		ELSE
			value := value - MonthDays[11];
		END_IF;
	ELSE
		IF value > MonthDays[10] THEN
			value := value - MonthDays[10];
		ELSE
			value := value - MonthDays[9];
		END_IF;
	END_IF;
ELSIF value > MonthDays[5] THEN
	IF value > MonthDays[7] THEN
		IF value > MonthDays[8] THEN
			value := value - MonthDays[8];
		ELSE
			value := value - MonthDays[7];
		END_IF;
	ELSE
		IF value > MonthDays[6] THEN
			value := value - MonthDays[6];
		ELSE
			value := value - MonthDays[5];
		END_IF;
	END_IF;
ELSIF value > MonthDays[3] THEN
	IF value > MonthDays[4] THEN
		value := value - MonthDays[4];
	ELSE
		value := value - MonthDays[3];
	END_IF;
ELSE
	value := value + BOOL_TO_INT(leap);
	IF value > MonthDays[2] THEN 
		value := value - MonthDays[2];
	END_IF;
END_IF;
