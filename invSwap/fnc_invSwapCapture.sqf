/*
Author:
	Solskii

Description:
    Snapshots configured template inventories synchronized to a logic; optionally deletes saved templates.

Execution:
    Server startup; call once after Eden object initialization.

Parameters:
    0: Synchronization logic <Object>, default objNull.
    1: Delete captured templates <Boolean>, default true.

Configuration:
    Name the logic invSwapLogic; synchronize named equipped AI templates to it.
    Disable Player/Playable on templates. Only valid, configured, synchronized AI templates are deleted.
    Commits VMF_invSwapCache before deletion.
    Missing/unlinked kits report BIS_fnc_error; live lookup remains a fallback.
    Enables client initialization, including clients joining later.

Examples:
    [invSwapLogic] call VMF_fnc_invSwapCapture; // initServer.sqf
    [invSwapLogic, false] call VMF_fnc_invSwapCapture; // Keep templates

Returns:
    Capture pass accepted/already completed <Boolean>; false on rejection/missing logic.
    True does not imply that every configured kit was captured; inspect reported errors for missing kits.

---------------------------------------------------------------------------- */
if (!isServer) exitWith {false};
if (isRemoteExecuted && {remoteExecutedOwner isNotEqualTo 2}) exitWith {false};

params [
    ["_logic", objNull, [objNull]],
    ["_deleteTemplates", true, [true]]
];

if (missionNamespace getVariable ["VMF_invSwapCaptured", false]) exitWith {true};

[] remoteExec ["VMF_fnc_invSwapInit", [0, -2] select isDedicated, "VMF_invSwapInit"];

if (isNull _logic) exitWith {
    ["[VMF invSwap] invSwapLogic is missing. Name the logic and pass it to VMF_fnc_invSwapCapture."] call BIS_fnc_error;
    false
};

private _kits = missionNamespace getVariable ["VMF_invSwapKits", []];

if (_kits isEqualTo []) exitWith {
    ["[VMF invSwap] No kits are configured in fnc_invSwapConfig.sqf."] call BIS_fnc_error;
    false
};

private _synced = synchronizedObjects _logic;
private _cache = createHashMap;
private _remove = [];

{
    _x params ["_role", "_source"];

    private _loadout = [];
    private _template = objNull;

    if (_source isEqualType []) then {
        _loadout = +_source;
    } else {
        _template = missionNamespace getVariable [_source, objNull];

        if (!isNull _template && {_template in _synced && {_template isKindOf "CAManBase"}}) then {
            //Playable slots must never be deleted
            if (isPlayer _template || {_template in playableUnits || {_template in switchableUnits}}) then {
                ["[VMF invSwap] Skipped playable template %1; turn off Player/Playable in Eden.", _source] call BIS_fnc_error;
            } else {
                _loadout = getUnitLoadout _template;
            };
        };
    };

    if (count _loadout isEqualTo 10) then {
        _cache set [_role, _loadout];

        if (!isNull _template) then {
            _remove pushBackUnique _template;
        };
    } else {
        ["[VMF invSwap] Kit %1 was not captured. Check its template name, synchronization and inventory.", _role] call BIS_fnc_error;
    };
} forEach _kits;

//Save every inventory before deleting any unit
missionNamespace setVariable ["VMF_invSwapCache", _cache];
missionNamespace setVariable ["VMF_invSwapCaptured", true];

if (_deleteTemplates) then {
    {
        deleteVehicle _x;
    } forEach _remove;
};

diag_log format ["[VMF invSwap] Cached %1 kits; removed %2 template units.", count _cache, if (_deleteTemplates) then {count _remove} else {0}];

true
