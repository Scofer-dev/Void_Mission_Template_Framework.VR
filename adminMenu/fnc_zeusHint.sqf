/* ----------------------------------------------------------------------------
Function: VMF_fnc_zeusHint

Description:
    Displays a hint only to logic entity players, likely Zeus'

Execution:
	- Client: Yes
	- Server: No
	- Global: Yes

Parameters:
    0: Title <String>       Default: ""
    1: Text <String>        Default: ""
    2: Duration <Number>    Default: 5

Examples:
    ["Task Update","Objective Task Completed",5] remoteExec ["VMF_fnc_zeusHint",0];
    
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
    ["_title","",[""]],
    ["_text","",[""]],
    ["_duration",5,[0]]
];

private _zeusOpen = !isNull (findDisplay 312);

if (playerSide == sideLogic || !isMultiplayer ) then {
    if (_zeusOpen) then {
        [_title, _text, _duration] call BIS_fnc_curatorHint;
    } else {
        hintSilent _text;
    };    
};