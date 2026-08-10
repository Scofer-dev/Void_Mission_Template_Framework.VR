//
// Function: VMF_fnc_disableGroupMarkers
// Author: Scofer
// Description: Disables global group markers
// Intended Locality: Global
//
missionNamespace setVariable ["VMF_groupBFT_active",false,true];

if !(hasInterface) exitWith {};

missionNamespace setVariable ["VMF_groupBFT_activeLoop",false,true];

{
	private _group = _x;
	private _marker = _group getVariable ["VMF_bftGlobalMarker",""];

	if (_marker != "") then {
		deleteMarkerLocal _marker;
	};

	_group setVariable ["VMF_bftGlobalMarker",""];
} forEach allGroups;