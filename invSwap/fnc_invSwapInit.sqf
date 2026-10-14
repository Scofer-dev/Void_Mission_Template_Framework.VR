/*
Author:
    Solskii

Description:
    Installs swapped-kit respawn persistence and the ZEN Swap Player Loadout module. Guards against duplicate initialization.

Execution:
    Each player client; call once after normal VMF respawn setup.

Parameters:
    None.

Configuration:
    Respawn carries the applied kit and mission role override separately.

Examples:
    call VMF_fnc_invSwapInit; // initPlayerLocal.sqf, after normal respawn handler

Returns:
    Nothing (no supported return value).

---------------------------------------------------------------------------- */
if (!hasInterface || {missionNamespace getVariable ["VMF_invSwapInitialized", false]}) exitWith {};
missionNamespace setVariable ["VMF_invSwapInitialized", true];
player addEventHandler ["Respawn", {
    params ["_unit", "_oldUnit"];
    private _role = _oldUnit getVariable ["VMF_invSwapRole", ""];
    _unit setVariable ["VMF_invSwapRole", _role, true];
    private _loadout = _oldUnit getVariable ["VMF_invSwapLoadout", []];
    if !(_loadout isEqualTo []) then {
        private _appliedRole = _oldUnit getVariable ["VMF_invSwapAppliedRole", _role];
        [_unit, _loadout, _appliedRole] call VMF_fnc_invSwapLocal;
    };
}];
if (isNil "zen_custom_modules_fnc_register") exitWith {};
[
    "Void Mission Framework", "Swap Player Loadout",
    {
        params ["_position", "_unit"];
        [_unit] call VMF_fnc_invSwapDialog;
    }
] call zen_custom_modules_fnc_register;
