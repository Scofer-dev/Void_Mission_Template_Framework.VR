/*
Author:
    Solskii

Description:
    Resolves a kit snapshot from the server cache, exported array, or live named template. Does not apply equipment.

Execution:
    Server for captured/template inventories; call.

Parameters:
    0: Player unit <Object>, default objNull.
    1: Role key <String>, default "" (automatic matching).

Configuration:
    Reads VMF_invSwapKits and VMF_invSwapCache. Named templates must exist for live fallback.
    Missing or malformed inventories return an empty loadout and write an RPT message.

Examples:
    private _resolved = [playerUnit] call VMF_fnc_invSwapLoadout;
    _resolved params ["_loadout", "_role"];

Returns:
    [loadout array, role key] <Array>; loadout is [] on failure.

---------------------------------------------------------------------------- */
params [["_unit", objNull, [objNull]], ["_role", "", [""]]];
if (_role == "") then {_role = [_unit] call VMF_fnc_invSwapRole};
private _cache = missionNamespace getVariable ["VMF_invSwapCache", createHashMap];
private _loadout = +(_cache getOrDefault [_role, []]);
if (count _loadout == 10) exitWith {[_loadout, _role]};
private _kits = missionNamespace getVariable ["VMF_invSwapKits", []];
private _index = _kits findIf {(_x select 0) == _role};
if (_index >= 0) then {
    private _source = (_kits select _index) select 1;
    if (_source isEqualType []) then {
        _loadout = +_source;
    } else {
        private _template = missionNamespace getVariable [_source, objNull];
        if (!isNull _template && {_template isKindOf "CAManBase"}) then {
            _loadout = getUnitLoadout _template;
        };
    };
};
if (count _loadout != 10) then {
    _loadout = [];
    diag_log format ["[VMF invSwap] Missing/invalid kit for %1 (%2); retaining equipment.", name _unit, _role];
};
[_loadout, _role]
