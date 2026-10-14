/*
Author:
    Solskii

Description:
    Resolves a player role from an explicit unit override, then slot description, then fallback.

Execution:
    Any machine; call.

Parameters:
    0: Unit <Object>, default objNull.

Configuration:
    Set VMF_invSwapRole on the playable unit to override automatic matching.
    Reads mappings from invSwap/fnc_invSwapConfig.sqf; comparisons use lowercase descriptions.

Examples:
    [playerUnit] call VMF_fnc_invSwapRole;
    // Eden unit Init: this setVariable ["VMF_invSwapRole", "plt_medic", true];

Returns:
    Role key <String>.

---------------------------------------------------------------------------- */
params [["_unit", objNull, [objNull]]];
private _roles = missionNamespace getVariable ["VMF_invSwapRoles", []];
private _defaultRole = missionNamespace getVariable ["VMF_invSwapDefaultRole", "rifleman"];
private _override = _unit getVariable ["VMF_invSwapRole", ""];
if (_override != "") exitWith {_override};
private _description = toLower ((roleDescription _unit splitString "@") param [0, ""]);
private _index = _roles findIf {(_x select 0) == _description};
if (_index < 0) exitWith {_defaultRole};
(_roles select _index) select 1
