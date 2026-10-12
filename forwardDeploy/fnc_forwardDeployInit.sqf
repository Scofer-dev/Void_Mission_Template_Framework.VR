/* ----------------------------------------------------------------------------
Function: VMF_fnc_forwardDeployInit

Description:
    Allows players to forward deploy to passed areas

Execution:
	- Local: No
	- Server: Yes
	- Global: No

Parameters:
   	0: Deployment Areas <Array of markers/triggers>
	1: Paradrop Deployment <Bool>		Default: false

Example:
	[
		["deployAreaMarker_1",deployAreaTrigger_1],
		true
	] call VMF_fnc_forwardDeployInit;

	[
		["deployAreaMarker_1",deployAreaTrigger_1],
		true
	] remoteExec ["VMF_fnc_forwardDeployInit"],2];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

params [
	["_deploymentAreas",[],[[],"",objNull]],
	["_paradrop",false,[false]]
];

if (typeName _deploymentAreas in ["STRING","OBJECT"]) then {
	_deploymentAreas = [_deploymentAreas];
};

if (_deploymentAreas isEqualTo []) exitWith {
	["No deployment areas passed to VMF_fnc_forwardDeployInit"] call BIS_fnc_error;
};

private _areas = [];
{
	switch (typeName _x) do {
		case "STRING": {
			if !((_markerShape _x) in ["","ICON"]) then {
				private _markerSize = markerSize _x;
				if ((_markerSize select 0) > 0 && {((_markerSize select 1) > 0)}) then {
					_areas pushBack _x;
				};
			} else {
				["Invalid marker passed to VMF_fnc_forwardDeployInit"] call BIS_fnc_error;
			};
		};
		case "OBJECT": {
			if !(typeOf _x in ["EmptyDetector","EmptyDetectorArea10x10","EmptyDetectorAreaR50","EmptyDetectorAreaR250"]) then {
				private _triggerSize = triggerArea _x;
				if ((_triggerSize select 0) > 0 && {(_triggerSize select 1) > 0}) then {
					_areas pushBack _x;
				};
			};
		};
	};
} forEach _deploymentAreas;

if (_areas isEqualTo []) exitWith {
	["No valid areas passed to VMF_fnc_forwardDeployInit"] call BIS_fnc_error;
};

[_areas,_paradrop] remoteExec ["VMF_fnc_forwardDeployAction",[0,-2] select isDedicated];
