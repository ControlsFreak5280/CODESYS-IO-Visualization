__METADATA__
{
  "v3Meta": {
    "objectGuid": "4a373547-e831-47ff-81a7-e6579859da52",
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
PROGRAM GetClockLocal

VAR_INPUT
	TZ: STRING := 'MT';  (* Supports: ET, CT, MT, ET *);
	DisableDST: BOOL := FALSE;
END_VAR
__IMPLEMENTATION__

