/*
	Deletes a vehicle and all its crew

	Must pass the group leader to the function.

	Can be done in waypoints with [this] call VMF_fnc_deleteVehicle;

*/
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
