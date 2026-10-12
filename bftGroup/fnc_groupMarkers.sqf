/* ----------------------------------------------------------------------------
Function: VMF_fnc_groupMarkers

Description:
    Initialises the markers for groups containing players

Execution:
	- Local: Yes
	- Server: No
	- Global: Yes

Parameters:
    0: Update Delay <Number>			Default: 3
	1: Max Unit Distance <Number>		Default: 100
	2: Friendly Side Markers <Bool>		Default: false

Example:
	Enable Group BFT for the local player with default parameters
	[] call VMF_fnc_groupMarkers;

	Enable Group BFT for all players with custom parameters
	[5,50,false] remoteExec ["VMF_fnc_groupMarkers",[0,-2] select isDedicated,true];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

if (playerSide == sideLogic) exitWith {};

if !(canSuspend) exitWith {_this spawn VMF_fnc_groupMarkers};

//Prevents it being run multiple times
if (missionNamespace getVariable ["VMF_groupBFT_active",false]) exitWith {};
missionNamespace setVariable ["VMF_groupBFT_active",true];

addMissionEventHandler ["GroupDeleted",{
	if (missionNamespace setVariable ["VMF_groupBFT_active",true]) then {
		params ["_group"];

		private _marker = _group getVariable ["VMF_bftGroupMarker",""];

		if (_marker isNotEqualTo "") then {
			deleteMarker _marker;
			_group setVariable ["VMF_bftGroupMarker",""];
		};
	} else {
		removeMissionEventHandler ["GroupDeleted",_thisEventHandler];
	};	
}];

params [
	["_updateTimer",3,[-1]],
	["_maxDistance",100,[-1]],
	["_friendSideMarkers",false,[false]]
];


if !(missionNamespace getVariable ["VMF_groupBFT_activeLoop",false]) then {
	missionNamespace setVariable ["VMF_groupBFT_activeLoop",true];

	while {missionNamespace getVariable ["VMF_groupBFT_active",true]} do {
		{
			private _group = _x;

			//if (_addFriendSideMarkers && (side player getFriend side _group < 0.6)) exitWith {};

			//(side player getFriend blufor > 0.6 || (_addFriendMarkers && blufor getFriend blufor > 0.6))
			if (side player isEqualTo side _group || {_friendSideMarkers && {side player getFriend side _group > 0.6}}) then {
				private _units = units _group;

				if (_units findIf {_x in ([switchableUnits,playableUnits] select isMultiplayer)} isNotEqualTo -1) then {
					private _marker = _group getVariable ["VMF_bftGroupMarker",""];

					if (_marker isEqualTo "") then {
						_marker = createMarkerLocal [str(_group) + "_" + str(time),position (leader _group)];
						_marker setMarkerShapeLocal "ICON";
						_marker setMarkerTypeLocal "b_inf";
						_marker setMarkerTextLocal (groupId _group);
						_marker setMarkerColorLocal ("color" + str(side _group));

						_group setVariable ["VMF_bftGroupMarker",_marker];

						_group addEventHandler ["GroupIdChanged",{
							params ["_group","_newGroupId"];
							if (missionNamespace getVariable ["VMF_groupBFT_active",true]) then {
								private _marker = _group getVariable ["VMF_bftGroupMarker",""];
								if (_marker isNotEqualTo "") then {
									_marker setMarkerTextLocal _newGroupId;
								};
							} else {
								_group removeEventHandler ["GroupIdChanged",_thisEventHandler];
							};
						}];

						_group addEventHandler ["Empty",{
							params ["_group"];
							if (missionNamespace getVariable ["VMF_groupBFT_active",true]) then {
								private _marker = _group getVariable ["VMF_bftGroupMarker",""];

								if (_marker isNotEqualTo "") then {
									deleteMarkerLocal _marker;
								};

								_group setVariable ["VMF_bftGlobalMarker",""];
							} else {
								_group removeEventHandler ["Empty",_thisEventHandler];
							};
						}];
					};

					private _playerVehicle = objectParent (leader _group);
					if !(isNull _playerVehicle) then {
						//If group leader is in a vehicle find out what kind of vehicle it is
						private _markerType = _playerVehicle call VMF_fnc_vehicleType;

						_marker setMarkerTypeLocal _markerType;
					} else {
						//If the group leader isn't in a vehicle default to infantry
						_marker setMarkerTypeLocal "b_inf";
					};

					private _unitPositions = [];
					{
						if (leader _x distance _x <= _maxDistance) then {
							private _unitPos = getPos _x;
							_unitPos deleteAt 2;
							_unitPositions pushBackUnique _unitPos;
						};
					} forEach _units;

					//Mitigates issues where player groups aren't reinitilised properly when leaving and rejoining
					if (_unitPositions isEqualTo []) exitWith {};

					private _vector = [0,0];
					{
						_vector = _vector vectorAdd _x;
					} forEach _unitPositions;


					private _centroid = _vector vectorMultiply (1 / (count _unitPositions));

					_marker setMarkerPosLocal _centroid;
				};
			};
		} forEach allGroups;

		sleep _updateTimer;
	};
};