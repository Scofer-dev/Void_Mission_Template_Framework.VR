/* ----------------------------------------------------------------------------
Function: RGS_fnc_defineVehicle

Description:
	Creates passed Vehicle Pools and adds passed vehicle to them
	These vehicles can be spawned by the Zeus Vehicle Spawner module

Execution:
	- Client: No
	- Server: Yes
	- Global: No

Parameters:
	0: Logic (Object)
	1: Pool Names (String or Array of Strings)	Default: []
	2: Delete Groups (Bool)						Default: true
	3: Unit Init (Code)							Default: {}
	4: Vehicle Init (Code)						Default: {}
	5: Helmets (Array of strings)				Default: []
	6: Facewear (Array of strings)				Default: []
	7: Uniforms (Array of strings)				Default: []
	8: Vests (Array of strings)					Default: []
	9: Backpacks (Array of strings)				Default: []

	The following vehicle data is also taken:
	* Textures
	* Components
	* Crew & Passengers

	If the vehicle is empty it will spawn with its default crew.
	If the vehicle has AI placed in it then it will spawn with those units.	

	The following unit data is taken:
	* Class - Some mods execute code that change their units when they init, recommend using vanilla units with edited loadouts
	* Loadout - See above comment on class
	* Rank
	* Face - See above comment on class
	* Skill - Gets subskills rather than just general https://community.bistudio.com/wiki/Arma_3:_AI_Skill
	* Vehicle Seat

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
	["_poolNames",["Vehicle"]],
	["_deleteVehicles",true],
	["_unitInit",{}],
	["_vehicleInit",{}],
	["_helmets",[]],
	["_facewear",[]],
	["_uniforms",[]],
	["_vests",[]],
	["_backpacks",[]]
];

if (isNull _logic) exitWith {};

if (_poolNames isEqualType "") then {
	_poolNames = [_poolNames];
};

if (_poolNames isEqualTo [] || _poolNames isEqualTo [""]) exitWith {
	["No pool names passed to RGS_fnc_defineVehicle"] call BIS_fnc_error;
};

private _vehicleArray = synchronizedObjects _logic;
{
	private _object = _x;
	private _objectCategory = _object call BIS_fnc_objectType select 0;

	if !(_objectCategory in ["Vehicle","VehicleAutonomous"]) then {
		if (_objectCategory == "Soldier") then {
			private _objectParent = objectParent _object;

			if (isNull _objectParent) then {
				["Unit on foot passed to RGS_defineVehicles: %1. Check that passed unit is in a vehicle, or better yet pass the vehicle itself",_object] call BIS_fnc_error;
				_vehicleArray deleteAt _forEachIndex;
			} else {
				_vehicleArray set [_forEachIndex,_objectParent];
			};
		} else {
			["Non-vehicle detected in RGS_defineVehicles: %1. Only vehicles or units inside of vehicles should be passed.",_object] call BIS_fnc_error;
			_vehicleArray deleteAt _forEachIndex;
		};
	};
} forEachReversed _vehicleArray;

if (_vehicleArray isEqualTo []) exitWith {
	["No vehicles passed to RGS_defineVehicles. Check if a non-vehicle object was passed instead"] call BIS_fnc_error;
};

{
	private _poolName = _x;

	if (RGS_vehiclePoolArray findIf {_x select 0 isEqualTo _poolName} isEqualTo -1) then {
		RGS_vehiclePoolArray append [[_poolName,0]];
		missionNamespace setVariable ["RGS_vehiclePool_" + _poolName,[]];
		missionNamespace setVariable ["RGS_vehicleEquipmentPool_" + _poolName,[[],[],[],[],[]]];
	};
} forEach _poolNames;

private _defineInit = [_unitInit,_vehicleInit];


private _vehicleData = [];
private _groupArray = [];
{
	private _vehicle = _x;
	private _crewClasses = [];
	private _crewData = [];

	private _vehicleClass = typeOf _vehicle;
	private _vehicleComponents = [_vehicle] call BIS_fnc_getVehicleCustomization;
	private _pylonData = getAllPylonsInfo _vehicle;

	if (crew _vehicle isNotEqualTo [] && {(_vehicle call BIS_fnc_objectType select 0) isNotEqualTo "VehicleAutonomous"}) then {
		private _group = group _vehicle;
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

			assignedVehicleRole _unit params [
				["_role","cargo"],
				["_turretPath",-1]
			];

			private _cargoIndex = _vehicle getCargoIndex _unit;

			_crewClasses pushBack _class;
			_crewData pushBack [_loadout,_rank,_skills,_face,_role,_cargoIndex,_turretPath];
		} forEach units _group;

		_groupArray pushBackUnique _group;
	};

	_vehicleData pushBack [_vehicleClass,_crewClasses,_crewData,_vehicleComponents,_pylonData,_defineInit];
} forEach _vehicleArray;


if (_deleteVehicles) then {
	{
		{
			deleteVehicle _x;
		} forEach (units _x);
		deleteGroup _x;
	} forEach _groupArray;

	{
		deleteVehicleCrew _x;
		deleteVehicle _x;
	} forEach _vehicleArray;
};

{
	private _poolName = _x;
	private _poolArray = missionNamespace getVariable ("RGS_vehiclePool_" + _poolName);

	_poolArray append _vehicleData;

	private _equipmentArray = missionNamespace getVariable ("RGS_vehicleEquipmentPool_" + _poolName);

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

	private _arrayIndex = RGS_vehiclePoolArray findIf {_x select 0 isEqualTo _poolName};
	private _arrayCount = (RGS_vehiclePoolArray select _arrayIndex) select 1;
	_arrayCount = _arrayCount + count _vehicleArray;

	[RGS_vehiclePoolArray,[_arrayIndex,1],_arrayCount] call BIS_fnc_setNestedElement;
} forEach _poolNames;

publicVariable "RGS_vehiclePoolArray";

deleteVehicle _logic;