// RESPAWN WITH KIT PLAYERS STARTED WITH
player setVariable ["VMF_LoadoutStart", getUnitLoadout player];
player addEventHandler ["Respawn", {
	player setUnitLoadout (player getVariable ["VMF_LoadoutStart", []]);	
}];

call VMF_fnc_medicalNotification;

[
	"Void Mission Framework",
	"Mission Start",
	{
		call VMF_fnc_missionStartDialog;
	}
] call zen_custom_modules_fnc_register;

[
	"Void Mission Framework",
	"Call Custom Event",
	{
		call VMF_fnc_callEventDialog;
	}
] call zen_custom_modules_fnc_register;

_arsenalArray = call compile preprocessFileLineNumbers "arsenalArrays.sqf";
[_arsenalArray] spawn VMF_fnc_addArsenal;

[
	true,	//Enable firefight sounds
	true,	//Enable explosion sounds
	false	//Enable aircraft sounds
] spawn VMF_fnc_battlefieldSounds;