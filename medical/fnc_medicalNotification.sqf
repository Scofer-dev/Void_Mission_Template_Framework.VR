/* ----------------------------------------------------------------------------
Function: VMF_fnc_medicalNotification

Description:
	Adds CBA eventHandler to players, which displays notification to player when ACE medical is used on them, and by who

Execution:
	- Local: Yes
	- Server: No
	- Global: Yes

Parameters:
    N/A

Example:
	call VMF_fnc_medicalNotification;

	[] remoteExec ["VMF_fnc_medicalNotification",[0,-2] select isDedicated];
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if (hasInterface) then {	//This event fires locally to the player doing the treating
	["ace_treatmentStarted",{
		params [
			"_caller",
			"_target",
			"_selectionName",
			"_className",
			"_itemUser",
			"_usedItem"
		];

		//Stops message appearing if you treat yourself
		if (_caller == _target) exitWith {};
		
		//Stops message appearing if treating an AI that's local to another player
		if !(isPlayer _target) exitWith {};

		private _playerName = profileName;

		if (alive _target) then {	//If treating a live target
			[[format ["<t color='#FFFFFF' size = '2'>%1 is helping you!</t>",_playerName], "PLAIN DOWN", 1, true, true]] remoteExec ["titleText",_target];
		};
	}] call CBA_fnc_addEventHandler;
};