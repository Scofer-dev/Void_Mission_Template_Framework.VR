/*
Author:
    Solskii

Description:
    Applies an inventory onto the unit. Saves the swapped inventory for VMF respawn.

Execution:
    Owning machine; call. Remote calls must originate from the server.

Parameters:
    0: Living local unit <Object>, default objNull.
    1: Complete getUnitLoadout inventory <Array>, default [].
    2: Applied role key <String>, default "".

Configuration:
    Updates VMF_invSwapLoadout, VMF_LoadoutStart and VMF_invSwapAppliedRole.
    Preserves VMF_invSwapRole, so selecting another kit does not change the slot role.

Examples:
    // Server dispatch to the owner:
    [playerUnit, _loadout, "medic"] remoteExecCall ["VMF_fnc_invSwapLocal", playerUnit];

Returns:
    Success <Boolean>; false for rejected calls, non-local/dead units or invalid inventory.

---------------------------------------------------------------------------- */
if (isRemoteExecuted && {remoteExecutedOwner != 2}) exitWith {false};
params [["_unit", objNull, [objNull]], ["_loadout", [], [[]]], ["_role", "", [""]]];
if (isNull _unit || {!local _unit} || {!alive _unit} || {count _loadout != 10}) exitWith {false};
_unit setUnitLoadout [_loadout, true];
private _applied = getUnitLoadout _unit;
_unit setVariable ["VMF_invSwapLoadout", _applied];
_unit setVariable ["VMF_LoadoutStart", _applied];
// Remember the applied kit separately; slot/mission role remains the dialog default.
if (_role != "") then {_unit setVariable ["VMF_invSwapAppliedRole", _role]};
true
