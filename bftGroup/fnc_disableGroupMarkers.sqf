/* ----------------------------------------------------------------------------
Function: VMF_fnc_disableGroupMarkers

Description:
    Disables Group BFT; deleting markers and cleaning up event handlers

Execution:
	- Local: Yes
	- Server: No
	- Global: Yes

Parameters:
   	N/A

Example:
	Disable Group BFT for the local player
	[] call VMF_fnc_disableGroupMarkers;

	Disable Group BFT for all players
	[] remoteExec ["VMF_fnc_disableGroupMarkers",[0,-2] select isDedicated,true];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

missionNamespace setVariable ["VMF_groupBFT_active",false];
missionNamespace setVariable ["VMF_groupBFT_activeLoop",false];

{
	private _group = _x;
	private _marker = _group getVariable ["VMF_bftGroupMarker",""];

	if (_marker isNotEqualTo "") then {
		deleteMarkerLocal _marker;
	};

	_group setVariable ["VMF_bftGroupMarker",""];
} forEach allGroups;