//Attach Franta to a player.
if (!isServer) exitWith {};
if (missionNamespace getVariable ["VMF_frantaMonitorRunning", false]) exitWith {};
missionNamespace setVariable ["VMF_frantaMonitorRunning", true];

// Set false to disable the cosmetic; change the UID here to target someone else.
private _enabled = false;
private _targetUID = "76561198008368304";
if (!_enabled) exitWith {
    missionNamespace setVariable ["VMF_frantaMonitorRunning", false];
};

private _attachedUnit = objNull;
private _franta = objNull;

while {true} do {
    private _target = objNull;
    {
        if (isPlayer _x && {alive _x} && {getPlayerUID _x isEqualTo _targetUID}) exitWith {
            _target = _x;
        };
    } forEach allPlayers;

    // Remove the previous can on death, disconnect, or replacement of the unit.
    if (!(_target isEqualTo _attachedUnit) || {isNull _target}) then {
        if (!isNull _franta) then {deleteVehicle _franta;};
        _franta = objNull;
        _attachedUnit = _target;
    };

    if (!isNull _target && {isNull _franta}) then {
        _franta = createVehicle ["Land_Can_V2_F", getPosATL _target, [], 0, "CAN_COLLIDE"];
        _franta allowDamage false;
        _franta attachTo [_target, [-0.118, 0.136, 0.025], "pelvis"];
        _franta setVectorDirAndUp [[0, 1, 0], [0, 0, 1]];
    };

    sleep 2;
};
