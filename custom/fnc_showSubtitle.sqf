/* ----------------------------------------------------------------------------
Function: VMF_fnc_showSubtitle

Description:
	Modified version of BIS_fnc_showSubtitle to use custom subtitle display, cutting out bits superfluous to the custom display

Execution:
	- Local: Yes
	- Server: No
	- Global: Yes

Parameters:
	0: Speaker <String>
	1: Text <String>

Example:
	[
		"ION HQ",
		"Knight Flight, clear for take-off"
	] spawn VMF_fnc_showSubtitle;

	[
		"ION HQ",
		"Knight Flight, clear for take-off"
	] remoteExec ["VMF_fnc_showSubtitle",[0,-2] select isDedicated];

Returns:
    Nothing

Author:
	Thomas Ryan, updated by Karel Moricky, modified by Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_title","",[""]],
	["_text","",[""]]
];

if !(isNil {VMF_fnc_showSubtitle_script}) then {
	terminate VMF_fnc_showSubtitle_script;
};

VMF_fnc_showSubtitle_script = [_title,_text] spawn {
	params [
		["_title","",[""]],
		["_text","",[""]]
	];

	"VMF_subtitles" cutRsc ["VMF_subtitles","PLAIN",1,true,true];

	private _hudDisplay = uiNamespace getVariable ["VMF_subtitles",displayNull];
	if (isNull _hudDisplay) exitWith {};

	private _titleCtrl = _hudDisplay displayCtrl 1412241;
	private _textCtrl = _hudDisplay displayCtrl 1412242;

	_titleCtrl ctrlSetText _title;
	_textCtrl ctrlSetText _text;


	sleep 8;

	"VMF_subtitles" cutFadeOut 3;
};