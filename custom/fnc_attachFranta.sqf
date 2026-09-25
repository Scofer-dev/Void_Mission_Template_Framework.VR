/*
Function:
    VMF_fnc_attachFranta

Description:
    Attaches a Franta Can to player unit with passed UID
    Automatically hides/reveals can if player enters/exits vehicle, and deletes can if player is dead or disconnects
    Only works in Multiplayer

Execution:
	- Client: No
	- Server: Yes
	- Global: No

Parameters:
    0: Player UID <String/Number>

Examples:
	["76561198008368304"] spawn VMF_fnc_attachFranta;

    [76561198008368304] spawn VMF_fnc_attachFranta;

Returns:
    Nothing

Author:
    Scofer & Solskii
---------------------------------------------------------------------------- */
if !(isMultiplayer) exitWith {};
if !(isServer) exitWith {};

params [
    ["_playerUID","",["",-1]]
];

if (typeName _playerUID isEqualTo "NUMBER") then {
    _playerUID = str(_playerUID);
};

if (_playerUID isEqualTo "") exitWith {
    ["No Player UID passed to VMF_fnc_attachFranta"] call BIS_fnc_error;
};

if (missionNamespace getVariable ["VMF_frantaMonitorRunning",false]) exitWith {};
missionNamespace setVariable ["VMF_frantaMonitorRunning",true];

private _franta = objNull;

while {missionNamespace getVariable ["VMF_frantaMonitorRunning",false]} do {
    private _target = objNull;
    {
        if (alive _x && {getPlayerUID _x isEqualTo _playerUID}) exitWith {
            _target = _x;
        };
    } forEach allPlayers;

    if (isNull _target && {!isNull _franta}) then {
        deleteVehicle _franta;
    } else {
        if !(isNull _target) then {
            if (isNull _franta) then {
                _franta = createVehicle ["Land_Can_V2_F", [0,0,10000]];
                _franta allowDamage false;
                _franta attachTo [_target, [-0.118, 0.136, 0.025], "pelvis"];
                _franta setVectorDirAndUp [[0,1,0], [0,0,1]];
                {
                    _x removeCuratorEditableObjects [[_franta]];
                } forEach allCurators;
            };

            switch true do {
                case (isNull objectParent _target && {isObjectHidden _franta}): {
                    _franta hideObjectGlobal false;
                };
                case (!isNull objectParent _target && {!isObjectHidden _franta}): {
                    _franta hideObjectGlobal true;
                };
            };
        };
    };    

    sleep 2;
};
