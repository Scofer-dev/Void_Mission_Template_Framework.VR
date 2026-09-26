/*
Function:
    VMF_fnc_spawnVehicle

Description:
    Spawn the passed vehicle on the passed vehicle position and direction
    Should be called by VMF_fnc_spawnVehicleDialog

Execution:
	- Client: No
	- Server: Yes
	- Global: No

Parameters:
    0: Spawn Position <Array>       Default: [0,0,0];
    1: Spawn Direction <Number>     Default: 0
    2: Vehicle Data <Array>         Default []

Examples:
	[[1000,1000,0],250,[YOUR DATA HERE]] call VMF_fnc_spawnVehicle;

    [[1000,1000,0],250,[YOUR DATA HERE]] remoteExec ["VMF_fnc_spawnVehicle",2];
    
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

params [
    ["_spawnPos",[0,0,0],[[]]],
    ["_spawnDir",0,[-1]],
    ["_vehicleData",[],[[]]]
];

if (count _spawnPos != 3) exitWith {
    format ["Invalid Spawn Position passed to VMF_fnc_spawnVehicle: %1",_spawnPos] call BIS_fnc_error;
};

if (_vehicleData isEqualTo []) exitWith {
    ["No Vehicle Data passed to VMF_fnc_spawnVehicle"] call BIS_fnc_error;
};

_vehicleData params [
    ["_vehicleClass","",[""]],
    ["_vehicleName","",[""]],
    ["_vehicleSeats",[0,0,0,0,0],[[]]],
    ["_components",[[],[]],[[]]],
    ["_pylons",[],[[]]],
    ["_disableNVG",false,[false]],
    ["_disableThermals",false,[false]],
    ["_aceParams",[],[[]]],
    ["_aceCargo",[],[[]]],
    ["_vehicleCargo",[],[[]]],
    ["_vehicleInit",[{},{}],[[]]]
];

private _vehicle = createVehicle [_vehicleClass,[0,0,1000],[],0,"NONE"];
_vehicle allowDamage false;
_vehicle enableSimulation false;

_components params [
    "_vehicleTextures",
    "_vehicleAnimations"
];

[_vehicle,_vehicleTextures,_vehicleAnimations] call BIS_fnc_initVehicle;

_vehicle setPos _spawnPos;
_vehicle setDir _spawnDir;
_vehicle setVectorUp (surfaceNormal _spawnPos);

_vehicle disableNVGEquipment _disableNVG;
_vehicle disableTIEquipment _disableThermals;

{
    _x params [
        "_index",
        "_name",
        "_turret",
        "_magazine"
    ];

    _vehicle setPylonLoadout [_name,_magazine,true,_turret];
} forEach _pylons;


_aceParams params [
    "_repairParams",
    "_rearmParams",
    "_refuelParams",
    "_medicalParams"
];

if (_repairParams select 1) then {
    _vehicle setVariable ["ACE_isRepairVehicle",1,true];
};

if (_rearmParams select 1) then {
    [_vehicle,_rearmParams select 2,true] call ace_rearm_fnc_makeSource;
};

if (_refuelParams select 1) then {
    [_vehicle,_refuelParams select 2] remoteExec ["ace_refuel_fnc_makeSource",2];
};

if (_medicalParams select 1) then {
    _vehicle setVariable ["ace_medical_isMedicalVehicle",true,true];
};

_aceCargo params [
    ["_cargoWheels",0,[0]],
    ["_cargoTracks",0,[0]],
    ["_cargoSpace",0,[-1]]
];

if (_cargoSpace > -1) then {
    [_vehicle,_cargoSpace] call ace_cargo_fnc_setSpace;
};

private _loadedCargo = [];
if (_cargoWheels > 0) then {
    for "_i" from 1 to _cargoWheels do {
        _loadedCargo pushBack "ACE_Wheel";
        //["ACE_Wheel",_vehicle] call ace_cargo_fnc_loadItem;
    };
};
if (_cargoTracks > 0) then {
    for "_i" from 1 to _cargoTracks do {
        _loadedCargo pushBack "ACE_Track";
        //["ACE_Track",_vehicle] call ace_cargo_fnc_loadItem;
    };
};
_vehicle setVariable ["ace_cargo_loaded",_loadedCargo];


clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;

{
    _x params [
        "_item",
        "_amount"
    ];

    if (isClass (configFile >> "CfgVehicles" >> _item)) then {
        _vehicle addBackPackCargoGlobal [_item,_amount];
    } else {
        _vehicle addItemCargoGlobal [_item,_amount];
    };
} forEach _vehicleCargo;


{
    _vehicle call _x;
} forEach _vehicleInit;

{
    _x addCuratorEditableObjects [[_vehicle],true];
} forEach allCurators;

//Mitigates server-client desync where vehicle rubberbands into the air, still happens on occasion
sleep 0.5;

_vehicle allowDamage true;
_vehicle enableSimulation true;
