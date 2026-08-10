//
// Function: VMF_fnc_medicalNotification
// Author: Scofer
// Description: Adds CBA eventHandler to players, which tells other players if they're treating them
// Intended Locality: Player
//
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