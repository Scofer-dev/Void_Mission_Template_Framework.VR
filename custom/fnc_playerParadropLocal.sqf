/* ----------------------------------------------------------------------------
Function: VMF_fnc_playerParadropLocal

Description:
	Automatically makes the player paradrop from their current vehicle with a parachute

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
    0: Aircraft Classname (String)
	1: Drop Position (Array) - Z-pos is the drop height. Planes complete waypoints from further away, position may need to be about ~200 further on
	2: Direction (Number)
	3: Side (Side)							Default: west
	4: Players (Array)
	5: Parachute Backpack Class (String)	Default: "B_Parachute_02_F"

Example:
	[ 
		"LIB_C47_Skytrain",
		[1500,3050,300], 
		90, 
		civilian, 
		[playerOne,playerTwo,playerThree],
		"B_Parachute"
	] call VMF_fnc_playerParadrop;

	[ 
		"LIB_C47_Skytrain",
		[1500,3050,300], 
		90, 
		civilian, 
		[playerOne,playerTwo,playerThree],
		"B_Parachute"
	] remoteExec ["VMF_fnc_playerParadrop",2];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_parachute","B_Parachute",[""]]
];

player allowDamage false;

player setVariable ["VMF_backpackData",[backpack player,backpackItems player]];

removeBackpack player;
player addBackpack _parachute;

//unassignVehicle _unit;
[player] remoteExec ["unassignVehicle",0];
moveOut player;

sleep 2;

player action ["OpenParachute"];

waitUntil {sleep 3; isNull objectParent player && isTouchingGround player};

removeBackpack player;

player getVariable ["VMF_backpackData",["",[]]] params [
	["_backpack","",[""]],
	["_backpackItems",[],[[]]]
];

player addBackpack _backpack;
{
	(unitBackpack player) addItemCargoGlobal [_x,1];
} forEach _backpackItems;

player allowDamage true;