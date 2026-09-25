/*
Function:
    VMF_fnc_vehicleSpawner

Description:
    Adds the Vehicle Spawner action to the passed object

Execution:
	- Client: No
	- Server: Yes
	- Global: No

Parameters:
    0: Spawner Object <Object or Array of Objects>
    1: Vehicle Pool <String>                    Default: "Vehicles"
    2: Spawn Position <Object>                  Default: objNull    - If null players can choose where to spawn the vehicle
    3: Action Condition <Bool/Code/String>      Default: true

Examples:
	Let player choose a vehicle from the predefined VehiclePool, and vehicle will spawn on vehicleSpawnPos
	["VehiclePool",vehicleSpawnPos] call VMF_fnc_spawnVehicleDialog

	Let player choose a vehicle from the predefined VehiclePool, and player can choose where to spawn it
	["VehiclePool"] call VMF_fnc_spawnVehicleDialog 
    
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {
    ["Function VMF_fnc_vehicleSpawner should only be called on the server"] call BIS_fnc_error;
};

params [
    ["_spawnerObject",objNull,[objNull]],
    ["_poolName","Vehicles",[""]],
    ["_spawnPosObject",objNull,[objNull]],
    ["_condition",true,[true,{},""]]
];

if (isNull _spawnerObject) exitWith {
    format ["VMF_fnc_vehicleSpawner: Parameter 0 - Spawner Object is invalid: %1",_spawnerObject] call BIS_fnc_error;
};

if (_poolName isEqualTo "") exitWith {
    ["VMF_fnc_vehicleSpawner: Parameter 1 - Pool Name is empty"] call BIS_fnc_error;
};

private _poolDefined = waitUntil [
    {!isNil {missionNamespace getVariable ["VMF_vehiclePool_" + _poolName,[]]}},
    5,
    0.1 
];

if (isNil "_poolDefined") exitWith {
    format ["VMF_fnc_vehicleSpawner: Parameter 1: Pool Name is an undefined pool: %1",_poolName] call BIS_fnc_error;
};

private _vehicleData = missionNamespace getVariable ["VMF_vehiclePool_" + _poolName,[]];

if (typeName _condition isNotEqualTo "STRING") then {
    _condition = str(_condition);
};

_condition = "_this distance _target < 5 && {isNull (uiNamespace getVariable ['VMF_spawnVehicle_display',displayNull])} && " + _condition;


[
    _spawnerObject,
    [
        "Vehicle Spawner",
        {
            params ["_target","_caller","_actionId","_arguments"];

            _arguments params [
                "_spawnPosObject",
                "_vehicleData"
            ];

        
            uiNamespace setVariable ["VMF_spawnVehicle_vehicleData",_vehicleData];

            private _missionDisplay = findDisplay 46;
            private _display = _missionDisplay createDisplay "vmf_vehicleSpawner";

            [_display,_spawnPosObject,_vehicleData] call VMF_fnc_initSpawnerDisplay;
        },
        [
            _spawnPosObject,
            _vehicleData
        ],
        1,
        true,
        true,
        "",
        _condition
    ]
] remoteExec ["addAction",[0,-2] select isDedicated,true];
