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