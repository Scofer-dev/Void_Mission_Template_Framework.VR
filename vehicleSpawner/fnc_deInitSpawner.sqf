/*
Function:
	VMF_fnc_deInitSpawner

Description:
	Cleans up anything used for Vehicle Spawner that can't self-terminate or be left as is

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
	0: Exit Code <Number>		Default: -1

Examples:
	call VMF_fnc_deInitSpawner;

    
Returns:
    Nothing
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_exitCode",-1,[-1]]
];

//1: Spawn Vehicle Button Pressed
//2: Exit button / Escape
//3: Free-place vehicle spawned/cancelled

uiNamespace setVariable ["VMF_spawnVehicle_lbLastSel",nil];

if (_exitCode isEqualTo 3) then {
	removeMissionEventHandler ["EachFrame",uiNamespace getVariable ["VMF_spawnVehicle_eachFrameEH",-1]];
	findDisplay 46 displayRemoveEventHandler ["KeyDown",uiNamespace getVariable ["VMF_spawnVehicle_keyDownEH",-1]];
	findDisplay 46 displayRemoveEventHandler ["KeyUp",uiNamespace getVariable ["VMF_spawnVehicle_keyUpEH",-1]];

	[player,"DefaultAction",uiNamespace getVariable ["VMF_spawnVehicle_fireActionEH",-1]] call ace_common_fnc_removeActionEventHandler;

	deleteVehicle (uiNamespace getVariable ["VMF_spawnVehicle_displayVehicle",objNull]);

	terminate (uiNamespace getVariable ["VMF_spawnVehicle_dynamicText",scriptNull]);

	uiNamespace setVariable ["VMF_spawnVehicle_keyQ",nil];
	uiNamespace setVariable ["VMF_spawnVehicle_keyE",nil];
	uiNamespace setVariable ["VMF_spawnVehicle_keyShift",nil];
};
