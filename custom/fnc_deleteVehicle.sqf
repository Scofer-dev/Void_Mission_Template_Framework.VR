/* ----------------------------------------------------------------------------
Function: VMF_fnc_deleteVehicle

Description:
	Deletes a vehicle and all its crew

Execution:
	- Local: Yes
	- Server: Yes
	- Global: No

Parameters:
	0: Group Leader <Object>

Example:
	[tankCommander] call VMF_fnc_deleteVehicle;

	[vehicleLeader] remoteExec ["VMF_fnc_deleteVehicle",vehicleLeader];

	Waypoint:
	[this] call VMF_fnc_deleteVehicle

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
params [
	["_groupLeader",objNull,[objNull]]
];
if (isNull _groupLeader) exitWith {};

private _vehicle = vehicle leader _groupLeader;
private _group = group _groupLeader;

{
	deleteVehicle _x;
} forEach crew _vehicle + [_vehicle];

if (count (units _group) == 0) then {
	deleteGroup _group;
};
