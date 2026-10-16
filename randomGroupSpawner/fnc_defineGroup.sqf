/* ----------------------------------------------------------------------------
Function: RGS_fnc_defineGroup

Description:
	Creates passed Group Pools and adds passed groups to them
	These groups can be spawned by the Zeus Group Spawner module

Execution:
	- Client: No
	- Server: Yes
	- Global: No

Parameters:
	0: Logic (Object)
	1: Pool Names (String or Array of Strings)	Default: []
	2: Delete Groups (Bool)						Default: true
	3: Unit Init (Code)							Default: {}
	4: Helmets (Array of strings)				Default: []
	5: Facewear (Array of strings)				Default: []
	6: Uniforms (Array of strings)				Default: []
	7: Vests (Array of strings)					Default: []
	8: Backpacks (Array of strings)				Default: []

	The following unit data is also taken:
	* Loadout - Some mods change their units loadouts when they spawn, to avoid this use vanilla units
	* Rank
	* Face - See above comment on loadout
	* Skill - Gets subskills rather than just general https://community.bistudio.com/wiki/Arma_3:_AI_Skill

Example:
	[
		logicObject,
		["poolOne","poolTwo"],
		true,
		{_unit setDamage 0.25},
		["H_Bandanna_blu","H_Beret_CSAT_01_F"],
		["G_Balaclava_Skull1","G_Tactical_Clear"],
		["U_C_Commoner1_2","U_C_Driver_1_red"],
		["V_BandollierB_khk","V_EOD_olive_F"],
		["B_AssaultPack_dgtl","B_FieldPack_oli"]
	] call RGS_fnc_defineGroup;
	
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

params [
	["_logic",objNull,[objNull]],
	["_poolNames",[],[[],""]],
	["_deleteGroups",true,[true]],
	["_unitInit",{},[{}]],
	["_helmets",[],[[]]],
	["_facewear",[],[[]]],
	["_uniforms",[],[[]]],
	["_vests",[],[[]]],
	["_backpacks",[],[[]]]
];

if (isNull _logic) exitWith {};

if (_poolNames isEqualType "") then {
	_poolNames = [_poolNames];
};

if (_poolNames isEqualTo [] || _poolNames isEqualTo [""]) exitWith {
	["No pool names passed to RGS_fnc_defineGroup"] call BIS_fnc_error;
};

private _units = synchronizedObjects _logic;
private _groupArray = [];
{
	_groupArray pushBackUnique group _x;
} forEach _units;

if (_groupArray isEqualTo []) exitWith {
	["No groups passed to RGS_fnc_defineGroups"] call BIS_fnc_error;
};

{
	private _poolName = _x;

	if (RGS_groupPoolArray findIf {_x select 0 isEqualTo _poolName} isEqualTo -1) then {
		RGS_groupPoolArray append [[_poolName,0]];
		missionNamespace setVariable ["RGS_groupPool_" + _poolName,[]];
		missionNamespace setVariable ["RGS_groupEquipmentPool_" + _poolName,[[],[],[],[],[]]];
	};
} forEach _poolNames;


private _groupData = [];
{
	private _group = _x;
	private _unitClasses = [];
	private _unitData = [];

	{
		private _unit = _x;
		private _skills = [];

		private _class = typeOf _unit;
		private _loadout = getUnitLoadout _unit;
		private _rank = rank _unit;
		private _face = face _unit;

		{
			_skills pushBack (_unit skill _x);
		} forEach VMF_skillNameArray;

		_unitClasses pushBack _class;
		_unitData pushBack [_loadout,_rank,_skills,_face];
	} forEach units _group;

	_groupData pushBack [_unitClasses,_unitData,_unitInit];
} forEach _groupArray;


if (_deleteGroups) then {
	{
		{
			deleteVehicle _x;
		} forEach units _x;

		deleteGroup _x;
	} forEach _groupArray;
};


{
	private _poolName = _x;
	private _poolData = missionNamespace getVariable ("RGS_groupPool_" + _poolName);

	_poolData append _groupData;

	private _equipmentArray = missionNamespace getVariable ("RGS_groupEquipmentPool_" + _poolName);

	_equipmentArray params [
		"_helmetArray",
		"_facewearArray",
		"_uniformArray",
		"_vestArray",
		"_backPackArray"
	];

	_helmetArray append _helmets;
	_facewearArray append _faceWear;
	_uniformArray append _uniforms;
	_vestArray append _vests;
	_backPackArray append _backpacks;

	private _arrayIndex = RGS_groupPoolArray findIf {_x select 0 isEqualTo _poolName};
	private _arrayCount = (RGS_groupPoolArray select _arrayIndex) select 1;
	_arrayCount = _arrayCount + count _groupArray;

	[RGS_groupPoolArray,[_arrayIndex,1],_arrayCount] call BIS_fnc_setNestedElement;
} forEach _poolNames;

publicVariable "RGS_groupPoolArray";

deleteVehicle _logic;