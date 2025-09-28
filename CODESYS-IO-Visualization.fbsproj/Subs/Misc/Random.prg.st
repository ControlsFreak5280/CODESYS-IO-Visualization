__METADATA__
{
  "v3Meta": {
    "objectGuid": "6b75697c-d6a5-4d62-830e-f2c71570b9dd",
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
PROGRAM Random

VAR_IN_OUT
	value: REAL;
END_VAR

VAR
	last: REAL;
	time_ms: DWORD;
	time_ms2: DWORD;
	timeBitsOn: INT;
	timeBitsOn2: INT;
END_VAR
__IMPLEMENTATION__
last := value;
time_ms := TIME_TO_DWORD(TIME());

BitCount(value := time_ms, Count => timeBitsOn);

time_ms.31 := time_ms.2;
time_ms.30 := time_ms.5;
time_ms.29 := time_ms.4;
time_ms.27 := time_ms.0;
time_ms.26 := time_ms.7;
time_ms.25 := time_ms.6;
time_ms.24 := time_ms.3;

BitCount(value := time_ms, Count => timeBitsOn2);

time_ms := ROL(time_ms,timeBitsOn2) OR 16#80000001;
time_ms := time_ms MOD 71474513 + INT_TO_DWORD(timeBitsOn + 77);
value := DWORD_TO_REAL(time_ms) / 10000000.0 * (2.71828182845904523536028747135266249 - LIMIT(0.0,last,1.0));
value := ABS(value - DINT_TO_REAL(REAL_TO_DINT(value)));
