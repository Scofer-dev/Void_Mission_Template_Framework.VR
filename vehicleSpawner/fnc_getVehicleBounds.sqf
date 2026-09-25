/*
Function:
    VMF_fnc_getVehicleBounds

Description:
    Gets the approximate collision boundary of the passed vehicle

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
	0: Vehicle <Object>


Examples:
	[CarOne] call VMF_fnc_getVehicleBounds
    
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
params [
    ["_vehicle",objNull,[objNull]]
];

if (isNull _vehicle) exitWith {
    ["Null vehicle passed to VMF_fnc_getVehicleBounds"] call BIS_fnc_error;

};

private _vehicleBB = 0 boundingBoxReal _vehicle;

_vehicleBB params ["_point1","_point2"];

_point1 params ["_left","_back","_top"];
_point2 params ["_right","_front","_bottom"];

private _xAxis = ([_left,0,0] vectorDiff [_right,0,0] select 0)/1.5;
private _yAxis = ([_front,0,0] vectorDiff [_back,0,0] select 0)/1.5;

_vehicle setVariable ["VMF_spawnVehicle_areaAxis",[_xAxis,_yAxis]];

[
    //Corners
    [[_left,_front,_bottom],[_left,_front,_top]],
    [[_left,_back,_bottom],[_left,_back,_top]],
    [[_right,_front,_bottom],[_right,_front,_top]],
    [[_right,_back,_bottom],[_right,_back,_top]],
    //Front horizontal
    [[_left,_front,_bottom],[_right,_front,_bottom]],
    [[_left,_front,_top],[_right,_front,_top]],
    //Back horizontal
    [[_left,_back,_bottom],[_right,_back,_bottom]],
    [[_left,_back,_top],[_right,_back,_top]],
    //Left horizontal
    [[_left,_front,_bottom],[_left,_back,_bottom]],
    [[_left,_front,_top],[_left,_back,_top]],
    //Right horizontal
    [[_right,_front,_bottom],[_right,_back,_bottom]],
    [[_right,_front,_top],[_right,_back,_top]],
    //Front cross - bottom left to top right, bottom right to top left
    [[_left,_front,_bottom],[_right,_front,_top]],
    [[_right,_front,_bottom],[_left,_front,_top]],
    //Back cross - bottom left to top right, bottom right to top left
    [[_left,_back,_bottom],[_right,_back,_top]],
    [[_right,_back,_bottom],[_left,_back,_top]],
    //Left cross - front bottom to back top, front top to back bottom
    [[_left,_front,_bottom],[_left,_back,_top]],
    [[_left,_front,_top],[_left,_back,_bottom]],
    //Right cross - front bottom to back top, front top to back bottom
    [[_right,_front,_bottom],[_right,_back,_top]],
    [[_right,_front,_top],[_right,_back,_bottom]],
    //Top cross - front left to back right, front right to back left
    [[_left,_front,_top],[_right,_back,_top]],
    [[_right,_front,_top],[_left,_back,_top]],
    //Bottom cross - front left to back right, front right to back left
    [[_left,_front,_bottom],[_right,_back,_bottom]],
    [[_right,_front,_bottom],[_left,_back,_bottom]],
    //Internal diagonal crosses
    [[_left,_front,_bottom],[_right,_back,_top]],
    [[_left,_front,_top],[_right,_back,_bottom]],
    [[_left,_back,_bottom],[_right,_front,_top]],
    [[_left,_back,_top],[_right,_front,_bottom]],
    //Central cross sections
    [[0,_front,_bottom],[0,_back,_top]],
    [[0,_front,_top],[0,_back,_bottom]],
    [[_left,_front,0],[_right,_back,0]],
    [[_left,_back,0],[_right,_front,0]],
    //Center checks
    [[_left,0,0],[_right,0,0]],
    [[0,_back,0],[0,_front,0]],
    [[0,0,_bottom],[0,0,_top]]
];
