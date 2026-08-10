params [
	["_unit",objNull,[objNull]],
	["_parachute","B_Parachute",[""]]
];
if (isNull _unit) exitWith {};

_unit allowDamage false;

_unit setVariable ["VMF_backpackData",[backpack _unit,backpackItems _unit]];

removeBackpack _unit;
_unit addBackpack _parachute;

//unassignVehicle _unit;
[_unit] remoteExec ["unassignVehicle",0];
moveOut _unit;

sleep 2;

_unit action ["OpenParachute"];

waitUntil {sleep 3; isNull objectParent _unit && isTouchingGround _unit};

removeBackpack _unit;

_unit getVariable ["VMF_backpackData",["",[]]] params [
	["_backpack","",[""]],
	["_backpackItems",[],[[]]]
];

_unit addBackpack _backpack;
{
	(unitBackpack _unit) addItemCargoGlobal [_x,1];
} forEach _backpackItems;

_unit allowDamage true;