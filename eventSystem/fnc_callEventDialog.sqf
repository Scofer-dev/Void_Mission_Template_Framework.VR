/* ----------------------------------------------------------------------------
Function: VMF_fnc_callEventDialog

Description:
    Opens the dialog for selecting which event to execute for the local player

Execution:
    - Client: Yes
    - Server: No
    - Global: No

Parameters:
    N/A

Example:
    call VMF_fnc_callEventDialog;

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

private _actualValues = [];
private _prettyValues = [];

private _eventSystemArray = missionNamespace getVariable ["VMF_eventSystemArray",[]];

if (count _eventSystemArray == 0) exitWith {
	[objNull, "No events have been defined"] call BIS_fnc_showCuratorFeedbackMessage;
};

{
	_actualValues append [[_x select 0,_forEachIndex]];
	_prettyValues append [[_x select 0,_x select 1]];
} forEach _eventSystemArray;

[
	"Call Event",
	[
		[
			"COMBO",
			"Event Name",
			[
				_actualValues,
				_prettyValues,
				0
			]
		]
	],
	{	
		(_this select 0) select 0 params [
			"_eventName",
			"_eventIndex"
		];

		[objNull, format ["Confirmation required to call event '%1'", _eventName]] call BIS_fnc_showCuratorFeedbackMessage;

		[
			"Confirm Event Call",
			[
				[
					"CHECKBOX",
					"Confirmation",
					false,
					true
				]
			],
			{
				private _confirmation = (_this select 0) select 0;
				_this select 1 params [
					"_eventName",
					"_eventIndex"
				];

				if (_confirmation) then {

					private _eventSystemArray = missionNamespace getVariable ["VMF_eventSystemArray",[]];

					_eventSystemArray select _eventIndex params [
						"_eventName",
						"_eventTooltip",
						"_eventCode",
						"_singleUse"
					];

					if (_singleUse) then {
						_eventSystemArray deleteAt _eventIndex;
						missionNamespace setVariable ["VMF_eventSystemArray",_eventSystemArray,true];
					};

					[] call _eventCode;

					[objNull, format ["Event '%1' called", _eventName]] call BIS_fnc_showCuratorFeedbackMessage;
				} else {
					[objNull, format ["Event '%1' did not receive confirmation.", _eventName]] call BIS_fnc_showCuratorFeedbackMessage;
				};

			},
			{
				private _confirmation = (_this select 0) select 0;
				_this select 1 params [
					"_eventName",
					"_eventIndex"
				];

				[objNull, format ["Event '%1' did not receive confirmation.", _eventName]] call BIS_fnc_showCuratorFeedbackMessage;
			},
			[
				_eventName,
				_eventIndex
			]
		] call zen_dialog_fnc_create;
	},
	{},
	[]
] call zen_dialog_fnc_create;