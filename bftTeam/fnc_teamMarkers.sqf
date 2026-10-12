/* ----------------------------------------------------------------------------
Function: VMF_fnc_teamMarkers

Description:
    Initialises the markers for the players team members

Execution:
	- Local: Yes
	- Server: No
	- Global: Yes

Parameters:
    0: Update Delay <Number>			Default: 3

Example:
	Enable Team BFT for the local player with default parameters
	[] call VMF_fnc_teamMarkers;

	Enable Team BFT for all players with custom parameters
	[5] remoteExec ["VMF_fnc_teamMarkers",[0,-2] select isDedicated,true];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

if (playerSide == sideLogic) exitWith {};

if !(canSuspend) exitWith {_this spawn VMF_fnc_teamMarkers};

//Prevents it being run multiple times
if (missionNamespace getVariable ["VMF_teamBFT_active",false]) exitWith {};
missionNamespace setVariable ["VMF_teamBFT_active",true];

params [
	["_updateDelay",3,[-1]]
];

//Prevents possibility of multiple updateLoops running simultaneously
if !(missionNamespace getVariable ["VMF_teamBFT_activeLoop",false]) then {
	missionNamespace setVariable ["VMF_teamBFT_activeLoop",true];

	while {missionNamespace getVariable ["VMF_teamBFT_active",true]} do {
		private _group = group player;

		private _groupEventId = _group getVariable ["VMF_teamBFT_groupEventID",-1];
		if (_groupEventId isEqualTo -1) then {
			private _unitLeftEH = _group addEventHandler ["UnitLeft",{
				params ["_group","_oldUnit"];

				if (missionNamespace getVariable ["VMF_teamBFT_active",true]) then {
					if (player isEqualTo _oldUnit) then {
						{
							private _unit = _x;
							private _marker = _unit getVariable ["VMF_teamBFTMarker",""];

							if (_marker != "") then {
								deleteMarkerLocal _marker;
								_unit setVariable ["VMF_teamBFTMarker",""];
							};
						} forEach (units _group);
					} else {
						private _marker = _oldUnit getVariable ["VMF_teamBFTMarker",""];

						if (_marker != "") then {
							deleteMarkerLocal _marker;
							_oldUnit setVariable ["VMF_teamBFTMarker",""];
						};
						
					};
				} else {
					_group removeEventHandler ["UnitLeft",_thisEventHandler];
				};
			}];
		};

		{
			private _unit = _x;
			private _marker = _unit getVariable ["VMF_teamBFTMarker",""];

			if (_marker == "") then {
				_marker = createMarkerLocal [str(_unit),position _unit];

				_marker setMarkerShapeLocal "ICON";
				_marker setMarkerTypeLocal "mil_triangle";
				_marker setMarkerSizeLocal [0.5,0.75];

				_unit setVariable ["VMF_teamBFTMarker",_marker];
			};

			_marker setMarkerColorLocal ([_unit] call VMF_fnc_markerColour);
			_marker setMarkerPosLocal position _unit;
			_marker setMarkerDirLocal getDir _unit;
		} forEach (units _group);

		sleep _updateDelay;
	};
};