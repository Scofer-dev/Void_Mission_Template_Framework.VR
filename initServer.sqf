[
	"Respawn Wave",	//Event Name
	"Respawns players",	//Event Description
	{[0] remoteExec ["VMF_fnc_missionUpdate",0]},	//Code to execute
	false	//Single use
] call VMF_fnc_addEvent;

[
	"Mission Live",	//Event Name
	"Disables Safe Start",	//Event Description
	{[1] remoteExec ["VMF_fnc_missionUpdate",0]},	//Code to execute
	true	//Single use
] call VMF_fnc_addEvent;

[
	"Mission Success",	//Event Name
	"Begins mission complete end sequence",	//Event Description
	{[2] remoteExec ["VMF_fnc_missionUpdate",0]},	//Code to execute
	true	//Single use
] call VMF_fnc_addEvent;

[
	"Mission Failure",	//Event Name
	"Begins mission failure end sequence",	//Event Description
	{[3] remoteExec ["VMF_fnc_missionUpdate",0]},	//Code to execute
	true	//Single use
] call VMF_fnc_addEvent;

[
	"Mutually Exclusive Event 1",	//Event Name
	"Triggers this event and removes Mutually Exclusive Event 2 from the list",	//Event Description
	{[4] remoteExec ["VMF_fnc_missionUpdate",0]},	//Code to execute
	true	//Single use
] call VMF_fnc_addEvent;

[
	"Mutually Exclusive Event 2",	//Event Name
	"Triggers this event and removes Mutually Exclusive Event 1 from the list",	//Event Description
	{[5] remoteExec ["VMF_fnc_missionUpdate",0]},	//Code to execute
	true	//Single use
] call VMF_fnc_addEvent;