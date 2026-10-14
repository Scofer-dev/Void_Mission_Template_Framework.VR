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
    Missing/unlinked kits log RPT messages; live lookup remains a fallback.

Examples:
    [invSwapLogic] call VMF_fnc_invSwapCapture; // initServer.sqf
    [invSwapLogic, false] call VMF_fnc_invSwapCapture; // Keep templates

Returns:
    Capture pass accepted/already completed <Boolean>; false on rejection/missing logic.
    True does not imply that every configured kit was captured; inspect RPT for missing kits.

---------------------------------------------------------------------------- */
if (!isServer) exitWith {false};
if (isRemoteExecuted && {remoteExecutedOwner != 2}) exitWith {false};
params [["_logic", objNull, [objNull]], ["_deleteTemplates", true, [true]]];
if (missionNamespace getVariable ["VMF_invSwapCaptured", false]) exitWith {true};
if (isNull _logic) exitWith {
    diag_log "[VMF invSwap] invSwapLogic is missing; using existing live template lookup.";
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
        if (!isNull _template && {_template in _synced} && {_template isKindOf "CAManBase"}) then {
            if (isPlayer _template || {_template in playableUnits} || {_template in switchableUnits}) then {
                diag_log format ["[VMF invSwap] Skipped playable template %1; turn off Player/Playable in Eden.", _source];
            } else {
                _loadout = getUnitLoadout _template;
            };
        };
    };
    if (count _loadout == 10) then {
        _cache set [_role, _loadout];
        if (!isNull _template) then {_remove pushBackUnique _template};
    } else {
        diag_log format ["[VMF invSwap] Kit %1 not captured; check template name, synchronization and inventory.", _role];
    };
} forEach (missionNamespace getVariable ["VMF_invSwapKits", []]);
// Commit every inventory before deleting any unit; no live unit references in cache.
missionNamespace setVariable ["VMF_invSwapCache", _cache];
missionNamespace setVariable ["VMF_invSwapCaptured", true];
if (_deleteTemplates) then {
    {deleteVehicle _x} forEach _remove;
};
diag_log format ["[VMF invSwap] Cached %1 kits; removed %2 template units.", count _cache, if (_deleteTemplates) then {count _remove} else {0}];
true
