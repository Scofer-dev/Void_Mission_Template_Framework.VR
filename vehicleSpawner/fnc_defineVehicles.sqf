/*
Function:
	VMF_fnc_defineVehicles

Description:
	Define vehicles that can be used by the spawn vehicle UI

How to use: 
Synchronise vehicles you want to define to an object of your choice. I recommend the logic entity. Ensure the object has a variable name.
The following values for each vehicle are saved:
	- Appearance
	- Equipment Storage
	- Pylons
	- ACE Wheel and Track Cargo
	- ACE Rearm Cargo
	- ACE Fuel Cargo Volume
	- ACE Is Repair Vehicle
	- ACE Is Medical Vehicle

Each vehicle can also have an individual init applied on spawn by setting the following variable in its init field
	this setVariable ["VMF_vehicleInit",{CODE HERE}];

Execution:
	- Client: No
	- Server: Yes
	- Global: No

Parameters:
	0: Vehicle Sync Object <Object>		Default: objNull
	1: Vehicle Pool Name <String>		Default: "Vehicles"
	2: Disable NVGs <Bool>				Default: false
	3: Disable Thermals <Bool>			Default: false
	4: Vehicle Init <Code>				Default: {}
	5: Delete Vehicles <Bool>			Default: true

Examples:
	Define vehicles synchronised to object playerVehicles with minimum parameters
	[playerVehicles] call VMF_fnc_defineVehicles

	Define vehicles synchronised to object playerVehicles with custom parameterss
	[
		playerVehicles,
		"damagedPlayerTanks",
		false,
		true,
		{_this setDamage 0.5},
		false
	] call VMF_fnc_defineVehiclesne 
    
Returns:
    Vehicle Data <Array>

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

params [
	["_syncObject",objNull,[objNull]],
	["_poolName","Vehicles",[""]],
	["_disableNVG",false,[false]],
	["_disableThermals",false,[false]],
	["_defineInit",{},[{}]],
	["_deleteVehicles",true,[true]]
];


if (isNull _syncObject) exitWith {
	["No object synchronised to vehicles passed to VMF_fnc_defineVehicles"] call BIS_fnc_error;
};

private _vehicleSync = synchronizedObjects _syncObject;
if (_vehicleSync isEqualTo []) exitWith {
	["No vehicles synchronised to object passed to VMF_fnc_defineVehicles"] call BIS_fnc_error;
};

private _poolName = "VMF_vehiclePool_" + _poolName;

private _vehicleArray = missionNamespace getVariable [_poolName,[]];
{
	private _vehicle = _x;
	private _vehicleClass = typeOf _x;

	private _simulation = toLower getText (configFile >> "CfgVehicles" >> _vehicleClass >> "simulation");
	if !(_simulation in ["car","carx","tank","tankx","helicopter","helicopterx","helicopterrtd","airplane","airplanex","ship","shipx","submarinex"]) exitwith {
		["Invalid object: %1 passed to VMF_fnc_defineVehicles",_x] call BIS_fnc_error;
	};

	private _vehicleName = _vehicle getVariable ["VMF_vehicleName",getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName")];
	
	private _vehicleSeats = [
		[format ["Driver Seats: %1",count (fullCrew [_vehicle,"driver",true])],"a3\ui_f\data\igui\cfg\commandbar\imagedriver_ca.paa"],
		[format ["Commander Seats: %1",count (fullCrew [_vehicle,"commander",true])],"a3\ui_f\data\igui\cfg\commandbar\imagecommander_ca.paa"],
		[format ["Gunner Seats: %1",count (fullCrew [_vehicle,"gunner",true])],"a3\ui_f\data\igui\cfg\commandbar\imagegunner_ca.paa"],
		[format ["FFV Seats: %1",count (fullCrew [_vehicle,"turret",true])],"a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_manualfire_ca.paa"],
		[format ["Cargo Seats: %1",count (fullCrew [_vehicle,"cargo",true])],"a3\ui_f\data\igui\cfg\commandbar\imagecargo_ca.paa"]
	];

	private _components = [_vehicle] call BIS_fnc_getVehicleCustomization;
	private _camoSelection = [_components select 0 select 0] + (_vehicle getVariable ["VMF_camoSelection",[_components select 0 select 0]]);
	_camoSelection = _camoSelection arrayIntersect _camoSelection;
	private _pylons = getPylonMagazines _vehicle;
	
	private _repairParams = ["Repair Vehicle",_vehicle call ace_repair_fnc_isRepairVehicle];


	private _isRearm = false;
	private _rearmSupply = -1;
	if (isNil {_vehicle getVariable "ace_rearm_issupplyvehicle"}) then {
		if (isNumber (configOf _vehicle >> "ace_rearm_defaultSupply")) then {
			_isRearm = true;
			_rearmSupply = getNumber (configOf _vehicle >> "ace_rearm_defaultSupply");
		};
	} else {
		if (_vehicle getVariable "ace_rearm_currentSupply" != -1) then {
			_isRearm = true;
			_rearmSupply = _vehicle getVariable "ace_rearm_currentsupply";
		};
	};
	private _rearmParams = ["Rearm Vehicle",_isRearm,_rearmSupply];


	private _isRefuel = false;
	private _fuelCapacity = _vehicle call ace_refuel_fnc_getCapacity;
	if (_fuelCapacity > -1 || {_fuelCapacity == -10}) then {
		_isRefuel = true;
	};
	private _refuelParams = ["Refuel Vehicle",_isRefuel,_fuelCapacity];


	private _isMedical = false;
	if (isNil {_vehicle getVariable "ace_medical_isMedicalVehicle"}) then {
		if (getNumber (configOf _vehicle >> "attendant") == 1) then {
			_isMedical = true
		};
	} else {
		_isMedical = _vehicle getVariable "ace_medical_isMedicalVehicle";
	};
	private _medicalParams = ["Medical Vehicle",_isMedical];
	

	private _aceParams = [
		_repairParams,
		_rearmParams,
		_refuelParams,
		_medicalParams
	];

	private _loadedWheels = _vehicle getVariable ["ace_repair_editorLoadedWheels",-1];
	if (_loadedWheels isEqualTo -1) then {
		_loadedWheels = parseNumber (_vehicle isKindOf "Car");
	};

	private _loadedTracks = _vehicle getVariable ["ace_repair_editorLoadedTracks",-1];
	if (_loadedTracks isEqualTo -1) then {
		_loadedTracks = parseNumber (_vehicle isKindOf "Tank");
	};
	
	private _aceCargo = [
		_loadedWheels,
		_loadedTracks,
		_vehicle getVariable "ace_cargo_space"
	];
	

	private _vehicleCargo = []; 
	{ 
		private _item = _x;

		private _arrayIndex = _vehicleCargo findIf {_x select 0 == _item}; 

		if (_arrayIndex == -1) then {
			private _itemName = "";
			private _itemImage = "";

			{
				private _configPath = (configFile >> _x >> _item);
				if (isClass (_configPath)) exitWith {
					_itemName = getText (_configPath >> "displayName");
					_itemImage = getText (_configPath >> "picture");
				};
			} forEach ["CfgWeapons","CfgMagazines","CfgVehicles"];

			_vehicleCargo pushBackUnique [_item,1,_itemName,_itemImage]; 
		} else { 
			private _itemAmount = (_vehicleCargo select _arrayIndex) select 1; 
			_itemAmount = _itemAmount + 1; 
			[_vehicleCargo,[_arrayIndex,1],_itemAmount] call BIS_fnc_setNestedElement; 
		}; 
	} forEach (weaponCargo _vehicle + magazineCargo _vehicle + itemCargo _vehicle + backpackCargo _vehicle); 


	private _vehicleInit = [
		_defineInit,
		_vehicle getVariable ["VMF_vehicleInit",{}]
	];


	_vehicleArray pushBack [
		_vehicleClass,
		_vehicleName,
		_vehicleSeats,
		_components,
		_pylons,
		_disableNVG,
		_disableThermals,
		_aceParams,
		_aceCargo,
		_vehicleCargo,
		_vehicleInit,
		_camoSelection
	];

	if (_deleteVehicles) then {
		deleteVehicle _x;
	};
} forEach _vehicleSync;

missionNamespace setVariable [_poolName,_vehicleArray,true];

_vehicleArray
