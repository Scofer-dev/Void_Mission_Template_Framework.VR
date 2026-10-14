/* ----------------------------------------------------------------------------
Function: VMF_fnc_playerParadropLocal

Description:
	Automatically makes the player paradrop from their current vehicle with a parachute

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
	0: Parachute Backpack Class (String)	Default: "B_Parachute"

Example:
	[
		"B_Parachute"
	] call VMF_fnc_playerParadropLocal;

	[ 
		"B_Parachute"
	] remoteExec ["VMF_fnc_playerParadropLocal",_paradroppingUnit];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_parachute","B_Parachute",[""]]
];

if (_parachute isEqualTo "") then {
	_parachute = "B_Parachute";
}:

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