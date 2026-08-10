/* ----------------------------------------------------------------------------
Function: VMF_fnc_addEvent

Description:
    Adds a new event to the list of possible events to call

Execution:
    - Client: No
    - Server: Yes
    - Global: No

Parameters:
    0: Event Name (String)
	1: Event Tooltip (String)
	2: Event Code (Code)
	3: Single Use Event (Bool)

Example:
    [
		"Event One",
		"The first event to call",
		{["First Event Called"] remoteExec ["hint",0]},
		true
	] call VMF_fnc_addEvent;

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

params [
	["_eventName","",[""]],
	["_eventTooltip","",[""]],
	["_eventCode",{},[{}]],
	["_singleUse",true,[true]]
];

if (_eventName == "") exitWith {
	["No event name given to event added by VMF_fnc_addEvent"] call BIS_fnc_error;
};

if (_eventCode isEqualTo {}) exitWith {
	["No event code given to event added by VMF_fnc_addEvent: %1",_eventName] call BIS_fnc_error;
};


private _eventSystemArray = missionNamespace getVariable ["VMF_eventSystemArray",[]];

if (_eventSystemArray findIf {_x select 0 == _eventName} != -1) exitWith {
	["Duplicate event name detected by VMF_fnc_addEvent: %1", _eventName] call BIS_fnc_error;
};

_eventSystemArray append [[_eventName,_eventTooltip,_eventCode,_singleUse]];

missionNamespace setVariable ["VMF_eventSystemArray",_eventSystemArray,true];