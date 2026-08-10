/* ----------------------------------------------------------------------------
Function: VMF_fnc_removeEvent

Description:
    Removes an existing event from the list of possible events to call

Execution:
    - Client: No
    - Server: Yes
    - Global: No

Parameters:
    0: Event Name (String)

Example:
    ["Event One"] call VMF_fnc_removeEvent;

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

params [
	["_eventName","",[""]]
];

if (_eventName == "") exitWith {
	["No event name given to VMF_fnc_removeEvent"] call BIS_fnc_error;
};

private _eventSystemArray = missionNamespace getVariable ["VMF_eventSystemArray",[]];

private _eventIndex = _eventSystemArray findIf {_x select 0 == _eventName};

if (_eventIndex == -1) then {
    format ["Invalid event name given to VMF_fnc_removeEvent: %1",_eventName] call BIS_fnc_error;
} else {
    _eventSystemArray deleteAt _eventIndex;
};

missionNamespace setVariable ["VMF_eventSystemArray",_eventSystemArray,true];