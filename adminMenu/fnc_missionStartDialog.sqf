/* ----------------------------------------------------------------------------
Function: VMF_fnc_missionStartDialog

Description:
	Displays ZEN dynamic dialog to Zeus, allowing them to set the mission to live with a custom hint

Execution:
	- Local: Yes
	- Server: No
	- Global: No

Parameters:
    N/A

Example:
	call VMF_fnc_missionStartDialog;

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

[
	"Start Mission",
	[	//Control content
		[
			"EDIT",
			["Message","Hint message displayed to all players"],
			[
				"Mission is Live"
			]
		]
	], 
	{	//On Confirm
		_this select 0 params [
			"_hintMessage"
		];

		[_hintMessage] remoteExec ["VMF_fnc_missionStart",2];

		[objNull, "Mission live!"] call BIS_fnc_showCuratorFeedbackMessage;
	}
] call zen_dialog_fnc_create