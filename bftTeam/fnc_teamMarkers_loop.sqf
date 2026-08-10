//
// Function: VMF_fnc_teamMarkers_loop
// Author: Scofer
// Description: Creates local markers for team members and theirs their positions and colours every _updateTimer seconds
// Intended Locality: Server & Player
//
missionNamespace setVariable ["VMF_teamBFT_active",true];

if !(hasInterface) exitWith {};

if (playerSide == sideLogic) exitWith {};

params [
	"_updateTimer"
];

//Prevents possibility of multiple updateLoops running simultaneously
if !(missionNamespace getVariable ["VMF_teamBFT_activeLoop",false]) then {
	missionNamespace setVariable ["VMF_teamBFT_activeLoop",true];

	while {missionNamespace getVariable ["VMF_teamBFT_active",true]} do {
		private _group = group player;

		private _groupEventId = _group getVariable ["VMF_teamBFT_groupEventID",-1];

		if (_groupEventId == -1) then {
			private _unitLeftEH = _group addEventHandler ["UnitLeft",{
				params ["_group","_oldUnit"];

				if (missionNamespace getVariable ["VMF_teamBFT_active",true]) then {
					if (player == _oldUnit) then {
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

		sleep _updateTimer;
	};
};