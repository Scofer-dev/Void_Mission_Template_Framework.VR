/* ----------------------------------------------------------------------------
Function: RGS_fnc_spawnVehicle

Description:
	Spawns a vehicle from a pre-defined RGS Vehicle Pool

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
	0: Pool Name <String>
    1: Spawn Side <Side>
	2: Separate Passengers <Bool>
    3: Spawn Position <Array>

Example:
	[
        "transportIFV",
        INDEPENDENT,
		true,
        [1000,1000,0]
    ] call RGS_fnc_spawnVehicle;
	
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
params [
    ["_poolName","",[""]],
    ["_side",WEST,[WEST]],
	["_separatePassengers",true,[true]],
    ["_spawnPos",[],[[]]]
];

_spawnPos set [2,0];

private _poolArray = [missionNamespace,("RGS_vehiclePool_" + _poolName),[]] call BIS_fnc_getServerVariable;
private _equipmentData = [missionNamespace,("RGS_vehicleEquipmentPool_" + _poolName),[[],[],[],[],[]]] call BIS_fnc_getServerVariable;

private _vehicleData = selectRandom _poolArray;

_vehicleData params [
	["_vehicleClass","",[""]],
	["_crewClasses",[],[[]]],
	["_crewData",[],[[]]],
	["_vehicleComponents",[],[[]]],
	["_pylonData",[],[[]]],
	["_defineInit",[{},{}],[[]]]
];

_vehicleComponents params [
	"_vehicleTexture",
	"_vehicleAnimations"
];

_defineInit params [
	"_unitInit",
	"_vehicleInit"
];

private [
	"_vehicle",
	"_group"
];


private _cargoUnits = [];
if (_crewClasses isEqualTo []) then {
	private _spawnedVehicle = [_spawnPos,0,_vehicleClass,_side] call BIS_fnc_spawnVehicle;

	_vehicle = _spawnedVehicle select 0;
	private _crew = _spawnedVehicle  select 1;
	_group = _spawnedVehicle select 2;

	[_vehicle,_vehicleTexture,_vehicleAnimations] call BIS_fnc_initVehicle;

	{
		_x params [
			"_index",
			"_name",
			"_turret",
			"_magazine"
		];

		[_vehicle,[_name,_magazine,true,_turret]] remoteExec ["setPylonLoadout",_vehicle];
	} forEach _pylonData;

	_vehicle call _vehicleInit;

	_group deleteGroupWhenEmpty true;

	{
		private _unit = _x;

		private _loadout = getUnitLoadout _unit;
		_loadout = [_loadout,_equipmentData] call VMF_fnc_loadoutRandomiser;

		_unit call _unitInit;
	} forEach _crew;
} else {
	_vehicle = _vehicleClass createVehicle _spawnPos;
	[_vehicle,_vehicleTexture,_vehicleAnimations] call BIS_fnc_initVehicle;

	{
		_x params [
			"_index",
			"_name",
			"_turret",
			"_magazine"
		];

		[_vehicle,[_name,_magazine,true,_turret]] remoteExec ["setPylonLoadout",_vehicle];
	} forEach _pylonData;

	_vehicle call _vehicleInit;

	_group = [_spawnPos,_side,_crewClasses] call BIS_fnc_spawnGroup;
	_group deleteGroupWhenEmpty true;
	private _units = units _group;

	{
		private _unit = _x;

		_crewData select _forEachIndex params [
			"_loadout",
			"_rank",
			"_skills",
			"_face",
			"_role",
			"_cargoIndex",
			"_turretPath"
		];

		_loadout = [_loadout,_equipmentData] call RGS_fnc_loadoutRandomiser;
		_unit setUnitLoadout _loadout;

		_unit setRank _rank;
		_unit setFace _face;

		{
			private _skillValue = _skills select _forEachIndex;
			_unit setSkill [_x,_skillValue];
		} forEach VMF_skillNameArray;

		switch (_role) do {
			case "cargo": {
				_unit assignAsCargo _vehicle;
				_unit moveInCargo [_vehicle,_cargoIndex];
				_cargoUnits pushBack _unit; //Part of Transport Vehicle functionality
			};
			case "turret": {
				_unit assignAsTurret [_vehicle,_turretPath];
				_unit moveInTurret [_vehicle,_turretPath];
			};
			case "driver": {
				_unit assignAsDriver _vehicle;
				_unit moveInDriver _vehicle;
			};
			case "commander": {
				_unit assignAsCommander _vehicle;
				_unit moveInCommander _vehicle;
			};
			case "gunner": {
				_unit assignAsGunner _vehicle;
				_unit moveInGunner _vehicle;
			};
		};

		if (isNull objectParent _unit) then {
			_unit moveInAny _vehicle;

			assignedVehicleRole _unit params [
				["_role","cargo"],
				["_turretPath",-1]
			];

			if (_role isEqualTo "cargo") then {
				_cargoUnits pushBack _unit;  //Part of Transport Vehicle functionality
			};
		};

		_unit call _unitInit;
	} forEach _units;

	_group selectLeader (effectiveCommander _vehicle);
};

{
	_x addCuratorEditableObjects [(units _group) + [_vehicle],true];
} forEach allCurators;

if (_separatePassengers && {_cargoUnits isNotEqualTo []}) then {
	private _transportGroup = createGroup [_side,true];

	_cargoUnits joinSilent _transportGroup;
};
