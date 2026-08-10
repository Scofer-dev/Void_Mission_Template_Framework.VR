/* ----------------------------------------------------------------------------
Function: VMF_fnc_addRadio

Description:
    Adds the given radio to the players inventory.

Execution:
	- Client: Yes
	- Server: No
	- Global: Yes

Parameters:
    0: Radio Classname <String>             Default: "ACRE_PRC343"
    1: Unit Type Array <Array of Strings>   Default: []

Examples:
    Add PRC-343 radio to player that called function.
    ["ACRE_PRC343"] call VMF_fnc_addRadio;

    Add PRC-148 radio to player that called function if they have the unit type B_officer_F or B_Soldier_SL_F
    ["ACRE_PRC148",["B_officer_F","B_Soldier_SL_F"]] call VMF_fnc_addRadio;

    Add PRC-343 radio to all players
    ["ACRE_PRC343"] remoteExec ["VMF_fnc_addRadio",0];
    
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

if (playerSide == sideLogic) exitWith {
    systemChat "Logic entities can't have this";
};

params [
    ["_radioType","ACRE_PRC343",[""]],
    ["_unitTypes",[],[[]]]
];

private _spawnedRadios = missionNamespace getVariable ["VMF_spawnedRadios",[]];
if (_radioType in _spawnedRadios) exitWith {
    systemChat format ["You already spawned a %1 radio this life.",_radioType];
};

if !(_radioType in [
    "ACRE_PRC343","ACRE_PRC148","ACRE_PRC152","ACRE_PRC77",
    "ACRE_PRC117F","ACRE_SEM52SL","ACRE_SEM70","ACRE_BF888S"
]) exitWith {["Invalid radio classname passed to VMF_fnc_addRadio: %1",_radioType] call BIS_fnc_error};

private _playerUnit = typeOf player;
if (_unitTypes isEqualTo []) then {
    _unitTypes = [_playerUnit];
};

if !(_playerUnit in _unitTypes) exitWith {
    systemChat format ["You are not permitted to have a %1 radio",_radioType];
};

private _loadout = getUnitLoadout player;

private _uniformItems = (_loadout select 3) select 1;

private _stringLength = count _radioType;
private _radioCheck = _uniformItems findIf {(_x select 0) select [0,_stringLength] == _radioType};

if (_radioCheck != -1) exitWith {
    systemChat format ["You already have a %1 radio",_radioType];
};

_uniformItems append [[
    _radioType,
    1
]];

player setUnitLoadout _loadout;

private _radioName = "";
switch _radioType do {
    case "ACRE_PRC343": {
        _radioName = "AN/PRC-343";
    };
    case "ACRE_PRC148": {
        _radioName = "AN/PRC-148";
    };
    case "ACRE_PRC152": {
        _radioName = "AN/PRC-152";
    };
    case "ACRE_PRC77": {
        _radioName = "AN/PRC-77";
    };
    case "ACRE_PRC117F": {
        _radioName = "AN/PRC-117F";
    };
    case "ACRE_SEM52SL": {
        _radioName = "SEM 52 SL";
    };
    case "ACRE_SEM70": {
        _radioName = "SEM 70";
    };
    case "ACRE_BF888S": {
        _radioName = "BF-888S";
    };
};

systemChat format ["%1 radio added to inventory",_radioName];

_spawnedRadios pushBackUnique _radioType;
missionNamespace setVariable ["VMF_spawnedRadios",_spawnedRadios];

player addEventHandler ["Killed", {
    missionNamespace setVariable ["VMF_spawnedRadios",[]];
}];