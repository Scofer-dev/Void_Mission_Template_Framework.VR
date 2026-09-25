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
	{[8] remoteExec ["VMF_fnc_missionUpdate",0]},	//Code to execute
	true	//Single use
] call VMF_fnc_addEvent;

[
	"Mission Failure",	//Event Name
	"Begins mission failure end sequence",	//Event Description
	{[9] remoteExec ["VMF_fnc_missionUpdate",0]},	//Code to execute
	true	//Single use
] call VMF_fnc_addEvent;


//Optional Vehicle Spawner - Delete or leave commented if not needed
//[playerVehicles,"playerVehicles",false,false,{},true] call VMF_fnc_defineVehicles;

//Vehicles will spawn on spawnArea object
//[vehicleSpawner,"playerVehicles",spawnArea,true] call VMF_fnc_vehicleSpawner;

//Players can choose where vehicles will spawn
//[vehicleSpawner,"playerVehicles",objNull,true] call VMF_fnc_vehicleSpawner;


// Optional attach Franta cosmetic
//["76561198008368304"] spawn VMF_fnc_attachFranta;
