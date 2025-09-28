__METADATA__
{
  "v3Meta": {
    "objectGuid": "495a1e19-8a31-498c-be8e-cd8b0a0e71cf",
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
PROGRAM CycleTime

VAR_IN_OUT
	value: CycleTime_UDT;
END_VAR
__IMPLEMENTATION__
value.Now := TIME_TO_DWORD(TIME());

IF (NOT value.init) THEN
	value.init := TRUE;
	value.mSec := 0;
ELSE
	value.mSec := value.Now - value.Last;
END_IF;
value.Last := value.Now;

value.Sec := DWORD_TO_REAL(value.mSec) / 1000.0;

