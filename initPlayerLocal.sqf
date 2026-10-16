// RESPAWN WITH KIT PLAYERS STARTED WITH
player setVariable ["VMF_LoadoutStart", getUnitLoadout player];
player addEventHandler ["Respawn", {
	player setUnitLoadout (player getVariable ["VMF_LoadoutStart", []]);	
}];

call VMF_fnc_medicalNotification;
call VMF_fnc_invSwapInit;

[3] spawn VMF_fnc_teamMarkers;

[
    3,    //Update Delay in seconds
    100,  //Max distance between group leader and a unit for its position to be counted for the position centroid
    true //Add group markers for friendly sides
] spawn VMF_fnc_groupMarkers;

[
	"Void Mission Framework",
	"Mission Start",
	{
		call VMF_fnc_missionStartDialog;
	}
] call zen_custom_modules_fnc_register;

[
	"Void Mission Framework",
	"Call Custom Event",
	{
		call VMF_fnc_callEventDialog;
	}
] call zen_custom_modules_fnc_register;

[
	"Random Group Spawner",
	"Spawn Group",
	{
		[_this select 0] call RGS_fnc_spawnGroupDialog;
	},
	"\a3\3den\data\displays\display3den\panelright\modeobjects_ca.paa"
] call zen_custom_modules_fnc_register;

[
	"Random Group Spawner",
	"Spawn Vehicle",
	{
		[_this select 0] call RGS_fnc_spawnVehicleDialog;
	},
	"\a3\soft_f\mrap_01\data\ui\mrap_01_base_ca.paa"
] call zen_custom_modules_fnc_register;

_arsenalArray = call compile preprocessFileLineNumbers "arsenalArrays.sqf";
[_arsenalArray] spawn VMF_fnc_addArsenal;

[
	true,	//Enable firefight sounds
	true,	//Enable explosion sounds
	false	//Enable aircraft sounds
] spawn VMF_fnc_battlefieldSounds;
