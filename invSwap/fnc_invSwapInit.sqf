/*
Author:
    Solskii

Description:
    Installs swapped-kit respawn persistence and the ZEN Swap Player Loadout module. Guards against duplicate initialization.

Execution:
    Each player client; dispatched by VMF_fnc_invSwapCapture on the server.
    Waits for the local player and mission startup before installing handlers.

Parameters:
    None.

Configuration:
    Respawn carries the applied kit and mission role override separately.

Examples:
    // Enabled automatically by the capture call in initServer.sqf.
    // No initPlayerLocal.sqf call is required.

Returns:
    Nothing (no supported return value).

---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {};
if (isRemoteExecuted && {remoteExecutedOwner isNotEqualTo 2}) exitWith {};
if (missionNamespace getVariable ["VMF_invSwapInitialized", false]) exitWith {};

//Set the guard before scheduling, so repeated calls cannot install duplicate handlers.
missionNamespace setVariable ["VMF_invSwapInitialized", true];

[] spawn {
    //Wait for mission startup so the respawn handler is loaded first.
    waitUntil {
        sleep 0.1;
        !isNull player && {local player && {time > 0}}
    };

    player addEventHandler ["Respawn", {
        params ["_unit", "_oldUnit"];

        private _role = _oldUnit getVariable ["VMF_invSwapRole", ""];
        private _loadout = _oldUnit getVariable ["VMF_invSwapLoadout", []];

        _unit setVariable ["VMF_invSwapRole", _role, true];

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
};
