/* ----------------------------------------------------------------------------
Function: VMF_fnc_widescreen

Description:
	Displays a temporary widescreen effect with optional title text

Execution:
	- Local: Yes
	- Server: No
	- Global: Yes

Parameters:
	0: Title Text <String>		Default: ""
	1: Duration <Number>		Default: 8

Example:
	["Red Dawn"] call VMF_fnc_widescreen;

	["",30] remoteExec ["VMF_fnc_widescreen",[0,-2] select isDedicated];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_titleText","",[""]],
	["_duration",8,[-1]]
];

"VMF_widescreen" cutRsc ["VMF_widescreen","PLAIN",2,true,true];

private _widescreenDisplay = uiNamespace getVariable ["VMF_widescreen",displayNull];
if (isNull _widescreenDisplay) exitWith {};

private _titleBox = _widescreenDisplay displayCtrl 16120251;

_titleBox ctrlSetFade 1;
_titleBox ctrlCommit 0;

_titleBox ctrlSetText _titleText;

sleep 2;

_titleBox ctrlSetFade 0;
_titleBox ctrlCommit 2;

sleep _duration;

"VMF_widescreen" cutFadeOut 3;