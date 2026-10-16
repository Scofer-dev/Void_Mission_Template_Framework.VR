/* ----------------------------------------------------------------------------
Function: RGS_fnc_spawnGroup

Description:
	Spawns a group from a pre-defined RGS Group Pool

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
	0: Pool Name <String>
    1: Spawn Side <Side>
    2: Spawn Position <Array>

Example:
	[
        "Infantry",
        EAST,
        [1000,1000,0]
    ] call RGS_fnc_spawnGroup;
	
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
params [
    ["_poolName",""],
    ["_side",WEST],
    ["_spawnPos",[]]
];

_spawnPos set [2,0];

private _poolArray = [missionNamespace,("RGS_groupPool_" + _poolName),[]] call BIS_fnc_getServerVariable;
private _equipmentData = [missionNamespace,("RGS_groupEquipmentPool_" + _poolName),[[],[],[],[],[]]] call BIS_fnc_getServerVariable;

private _groupData = selectRandom _poolArray;

_groupData params [
	["_unitClasses",[],[[]]],
	["_unitData",[],[[]]],
	["_defineInit",{},[{}]]
];

private _group = [_spawnPos,_side,_unitClasses] call BIS_fnc_spawnGroup;
_group deleteGroupWhenEmpty true;
private _units = units _group;

{
	_x addCuratorEditableObjects [
		_units,true
	]
} forEach allCurators;


{
	private _unit = _x;

	_unitData select _forEachIndex params [
		"_loadout",
		"_rank",
		"_skills",
		"_face"
	];

	_loadout = [_loadout,_equipmentData] call RGS_fnc_loadoutRandomiser;
	_unit setUnitLoadout _loadout;

	_unit setRank _rank;
	_unit setFace _face;

	{
		private _skillValue = _skills select _forEachIndex;
		_unit setSkill [_x,_skillValue];
	} forEach VMF_skillNameArray;

	_unit call _defineInit;
} forEach _units;
