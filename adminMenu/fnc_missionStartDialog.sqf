//
// Function: VMF_fnc_missionStartDialog
// Author: Scofer
// Description: Displays ZEN dynamic dialog to Zeus, allowing them to set mission to live with a custom hint
// Intended Locality: Player
//
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