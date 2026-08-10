//
// Function: VMF_fnc_disableTeamMarkers
// Author: Scofer
// Description: Disables local team marker update loop and deletes existing markers
// Intended Locality: Player
//
if !(hasInterface) exitWith {
	missionNamespace setVariable ["VMF_localBFT_active",false];
};

missionNamespace setVariable ["VMF_localBFT_active",false];
missionNamespace setVariable ["VMF_localBFT_activeLoop",false];

{
	private _unit = _x;
	private _marker = _unit getVariable ["VMF_localBFTMarker",""];

	if (_marker != "") then {
		deleteMarkerLocal _marker;
		_unit setVariable ["VMF_localBFTMarker",""];
	};
} forEach (units (group player));