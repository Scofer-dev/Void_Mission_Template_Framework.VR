_this params [
	["_titleText","",[""]]
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

sleep 8;

"VMF_widescreen" cutFadeOut 3;