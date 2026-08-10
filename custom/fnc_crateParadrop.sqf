/* ----------------------------------------------------------------------------
Function: VMF_fnc_crateParadrop

Description:
    Initiates a supply box paradrop

Execution:
	- Client: No
	- Server: Yes
	- Global: No

Parameters:
    0: Aircraft Classname (String)
	1: Crate variable name (Object)
	2: Drop Position (Array) - Z-pos is the drop height. Planes complete waypoints from further away, position may need to be about ~200 further on
	3: Direction (Number)
	4: Side (Side)							Default: west
	5: Parachute Backpack Class (String)	Default: "B_Parachute_02_F"
	6: Parachute Attach Offset (Array)		Default: [0,0,2]

Example:
	[ 
		"LIB_C47_Skytrain",
		supplyBox_1,
		[1082,1829,100],
		180, 
		civilian, 
		"B_Parachute_02_F",
		[0,0,2]
	] call VMF_fnc_crateParadrop;

	[ 
		"LIB_C47_Skytrain",
		supplyBox_1,
		[1082,1829,100],
		180, 
		civilian, 
		"B_Parachute_02_F",
		[0,0,2]
	] remoteExec ["VMF_fnc_crateParadrop",2];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

params [
	["_aircraftClass","",[""]],
	["_supplyCrate",objNull,[objNull]],
	["_dropPos",[0,0,0],[[]]],
	["_direction",-1,[0]],
	["_side",west,[west]],
	["_parachute","B_Parachute_02_F",[""]],
	["_parachuteOffset",[0,0,2],[[]]]
];

if (_aircraftClass == "") exitWith {};
if (isNull _supplyCrate) exitWith {};
if (_dropPos isEqualTo [0,0,0]) exitWith {};
if (_direction == -1) exitWith {};

private _dropHeight = _dropPos select 2;

_dropPos params [
	"_dropPosX",
	"_dropPosY",
	"_dropPosZ"
];

private _startPosX = (3000 * (sin(_direction - 180))) + _dropPosX;
private _startPosY = (3000 * (cos(_direction - 180))) + _dropPosY;

private _runUpStartPos = [
	_startPosX,
	_startPosY,
	_dropHeight
];

private _runExitPos = [
	(3000 * (sin(_direction))) + _dropPosX,
	(3000 * (cos(_direction))) + _dropPosY,
	_dropHeight
];

private _runDistance = _runUpStartPos distance _runExitPos;

private _positionArray = [];
for "_i" from 0 to _runDistance step 1000 do {
	private _xPos = (_i * (sin _direction)) + _startPosX;
	private _yPos = (_i * (cos _direction)) + _startPosY;

	_positionArray pushBack [_xPos,_yPos,_dropHeight];
};

[_runUpStartPos,_direction,_aircraftClass,_side] call BIS_fnc_spawnVehicle params [
	"_plane",
	"_crew",
	"_group"
];

_plane enableSimulationGlobal false;
_plane allowDamage false;
_plane disableAI "TARGET";
_plane disableAI "AUTOTARGET";

_plane flyInHeightASL [_dropHeight, _dropHeight, _dropHeight];
_plane lock true;
_plane setVariable ["VMF_paradropParams",[_supplyCrate,_parachute,_parachuteOffset],true];

_group allowFleeing 0;
_group setBehaviour "CARELESS";
_group setSpeedMode "LIMITED";
_group setCombatMode "WHITE";

_supplyCrate allowDamage false;
_plane disableCollisionWith _supplyCrate;

{
	private _waypoint = _group addWaypoint [_x,-1];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointForceBehaviour true;
	
	switch (_forEachIndex) do {
		case 3: {//Drop point
			_waypoint setWaypointStatements [
				"true",
				toString {
					if (isServer) then {
						private _plane = vehicle leader this;

						[_plane] spawn {
							_this params [
								"_plane"
							];

							_plane getVariable ["VMF_paradropParams",[objNull,"B_Parachute_02_F",[0,0,2]]] params [
								["_supplyCrate",objNull,[objNull]],
								["_parachute","B_Parachute_02_F",[""]],
								["_parachuteOffset",[0,0,2],[[]]]
							];

							private _parachute = _parachute createVehicle [0,0,0];
							_parachute setPosATL (getPosATL _plane);

							_supplyCrate attachTo [_parachute,[0,0,0]];

							private _smoke = "SmokeShellOrange" createVehicle [0,0,0];
							_smoke attachTo [_supplyCrate,[0,0,0]];
						};
					};
				}
			];
		};
		case 6: {//End point
			_waypoint setWaypointStatements [
				"true",
				toString {
					if (isServer) then {
						[this] call VMF_fnc_deleteVehicle;
					};
				}
			];
			_waypoint setWaypointCompletionRadius 500;
		};
	};
} forEach _positionArray;

_plane engineOn true;
_plane enableSimulationGlobal true;
_plane setVelocityModelSpace [0,100,0];