/*
Author:
    Solskii

Description:
    Opens a Zeus dropdown of configured kits for the targeted player, defaulting to their mapped role.

Execution:
    Zeus client with ZEN; call.

Parameters:
    0: Connected living player unit <Object>, default objNull.

Configuration:
    Kit entries may have a third display-name field. Old two-field entries show the role key.
    Forces the current role default on each opening. Confirm requests a server swap; cancel does nothing.

Examples:
    [playerUnit] call VMF_fnc_invSwapDialog;
    // Normally opened by placing Swap Player Loadout on a player in Zeus.

Returns:
    Dialog-created <Boolean> from ZEN; Nothing if validation rejects opening.

---------------------------------------------------------------------------- */
if (!hasInterface || {isNil "zen_dialog_fnc_create"}) exitWith {};

params [["_unit", objNull, [objNull]]];

if !(!isNull _unit && {isPlayer _unit && {alive _unit && {_unit isKindOf "CAManBase"}}}) exitWith {
    [objNull, "Place this module on a living player."] call BIS_fnc_showCuratorFeedbackMessage;
};

private _kits = missionNamespace getVariable ["VMF_invSwapKits", []];
private _defaultRole = missionNamespace getVariable ["VMF_invSwapDefaultRole", "rifleman"];

if (_kits isEqualTo []) exitWith {
    ["[VMF invSwap] No kits are configured in fnc_invSwapConfig.sqf."] call BIS_fnc_error;
    [objNull, "No swap loadouts are configured."] call BIS_fnc_showCuratorFeedbackMessage;
};

//Start with the player's mapped role, then fall back to the configured default kit.
private _roles = _kits apply {_x select 0};
private _labels = _kits apply {_x param [2, _x select 0]};
private _default = _roles find ([_unit] call VMF_fnc_invSwapRole);

if (_default < 0) then {
    _default = (_roles find _defaultRole) max 0;
};

[
    format ["Swap Loadout: %1", name _unit],
    [["COMBO", ["Loadout", "Choose the equipment to apply to this player."], [_roles, _labels, _default], true]],
    {
        params ["_values", "_arguments"];
        _values params ["_role"];
        _arguments params ["_unit"];

        // A player may disconnect or die while the dialog is open.
        if !(!isNull _unit && {isPlayer _unit && {alive _unit}}) exitWith {
            [objNull, "The selected player is no longer available."] call BIS_fnc_showCuratorFeedbackMessage;
        };

        [_unit, _role] remoteExecCall ["VMF_fnc_invSwap", 2];
    },
    {},
    [_unit]
] call zen_dialog_fnc_create;
