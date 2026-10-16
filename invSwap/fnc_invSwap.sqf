/*
Author:
    Solskii

Description:
    Swaps inventory of connected player by unit object or quoted Steam UID.

Execution:
    Server; call. Assigned Zeus can remoteExecCall to server target 2.

Parameters:
    0: Connected living player <Object/String UID>, default objNull.
    1: Configured role key <String>, default "" (automatic matching).

Configuration:
    Requires kit configuration and optionally startup capture. UIDs must be quoted strings.
    Remote requests are restricted to the server/assigned curators. Does not wait for future logins.
    Missing kits retain current equipment.

Examples:
    ["PLAYER_STEAM_UID"] call VMF_fnc_invSwap;
    [playerUnit, "medic"] call VMF_fnc_invSwap;
    // Zeus client: [playerUnit, "medic"] remoteExecCall ["VMF_fnc_invSwap", 2];

Returns:
    Dispatch accepted <Boolean>; true is not an owner-client completion acknowledgement.

---------------------------------------------------------------------------- */
if (!isServer) exitWith {false};

if (isRemoteExecuted && {remoteExecutedOwner isNotEqualTo 2 && {
    (allCurators findIf {
        private _zeus = getAssignedCuratorUnit _x;

        !isNull _zeus && {owner _zeus isEqualTo remoteExecutedOwner}
    }) < 0
}}) exitWith {false};

params [
    ["_target", objNull, [objNull, ""]],
    ["_role", "", [""]]
];

private _unit = _target;

//Get UID from its assigned player.
if (_target isEqualType "") then {
    _unit = objNull;

    {
        if (getPlayerUID _x isEqualTo _target && {alive _x}) exitWith {
            _unit = _x;
        };
    } forEach allPlayers;
};

if !(!isNull _unit && {isPlayer _unit && {alive _unit && {_unit isKindOf "CAManBase"}}}) exitWith {
    diag_log "[VMF invSwap] Target must be a connected, living player.";
    false
};

private _resolved = [_unit, _role] call VMF_fnc_invSwapLoadout;
_resolved params ["_loadout", "_resolvedRole"];

if (_loadout isEqualTo []) exitWith {
    if (isRemoteExecuted) then {
        [format ["No configured loadout for role '%1'. Check invSwap configuration and template units.", _resolvedRole]] remoteExecCall ["hint", remoteExecutedOwner];
    };

    false
};

//Inventory changes must run locally for the player.
[_unit, _loadout, _resolvedRole] remoteExecCall ["VMF_fnc_invSwapLocal", _unit];

true
