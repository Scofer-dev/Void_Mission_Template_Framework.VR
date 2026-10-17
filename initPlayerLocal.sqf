// RESPAWN WITH KIT PLAYERS STARTED WITH
player setVariable ["VMF_LoadoutStart", getUnitLoadout player];
player addEventHandler ["Respawn", {
	player setUnitLoadout (player getVariable ["VMF_LoadoutStart", []]);	
}];

call VMF_fnc_medicalNotification;

[3] spawn VMF_fnc_teamMarkers;

[
    3,    //Update Delay in seconds
    100,  //Max distance between group leader and a unit for its position to be counted for the position centroid
    true //Add group markers for friendly sides
] spawn VMF_fnc_groupMarkers;

_arsenalArray = call compile preprocessFileLineNumbers "arsenalArrays.sqf";
[_arsenalArray] spawn VMF_fnc_addArsenal;

[
	true,	//Enable firefight sounds
	true,	//Enable explosion sounds
	false	//Enable aircraft sounds
] spawn VMF_fnc_battlefieldSounds;
