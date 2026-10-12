/* ----------------------------------------------------------------------------
Function: VMF_fnc_disableTeamMarkers

Description:
	Periodically updates the local markers for the players team members
	Typically called by VMF_fnc_teamMarkersInit

Execution:
	- Local: Yes
	- Server: No
	- Global: Yes

Parameters:
    N/A

Example:
	[] call VMF_fnc_disableTeamMarkers;

	[] remoteExec ["VMF_fnc_disableTeamMarkers",-2,true];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

missionNamespace setVariable ["VMF_teamBFT_active",false];
missionNamespace setVariable ["VMF_teamBFT_activeLoop",false];

{
	private _unit = _x;
	private _marker = _unit getVariable ["VMF_teamBFTMarker",""];

	if (_marker isNotEqualTo "") then {
		deleteMarkerLocal _marker;
		_unit setVariable ["VMF_teamBFTMarker",""];
	};
} forEach (units (group player));