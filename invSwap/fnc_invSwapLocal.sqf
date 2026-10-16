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
if (isRemoteExecuted && {remoteExecutedOwner isNotEqualTo 2}) exitWith {false};

params [
    ["_unit", objNull, [objNull]],
    ["_loadout", [], [[]]],
    ["_role", "", [""]]
];

if !(!isNull _unit && {local _unit && {alive _unit}}) exitWith {false};

if (count _loadout isNotEqualTo 10) exitWith {
    ["[VMF invSwap] Invalid inventory passed to VMF_fnc_invSwapLocal for role '%1'. Expected a complete getUnitLoadout array.", _role] call BIS_fnc_error;
    false
};

_unit setUnitLoadout [_loadout, true];

//Save the applied inventory for both invSwap and respawn handler.
private _applied = getUnitLoadout _unit;

_unit setVariable ["VMF_invSwapLoadout", _applied];
_unit setVariable ["VMF_LoadoutStart", _applied];

//Remember the applied kit separately (the slot/mission role remains the dialog default).
if (_role isNotEqualTo "") then {
    _unit setVariable ["VMF_invSwapAppliedRole", _role];
};

true
