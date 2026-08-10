//
// Function: VMF_fnc_missionStart
// Author: Scofer
// Description: Sets the mission to live by flipping several variables, and displays a hint to all players
// Intended Locality: Server
//
params [
	"_hintMessage"
];

//If the mission has already been set to live, don't send the global hint
//This is more of a just-in-case measure, if this function needs to be ran multiple times, for example if a JIP player hasn't synced properly
if !(missionNamespace getVariable ["VMF_missionLive",false]) then {
	[_hintMessage] remoteExec ["hint",[0,-2] select isDedicated];
};

missionNamespace setVariable ["VMF_missionLive",true,true];
missionNamespace setVariable ["VMF_safeStartEnabled",false,true];
missionNamespace setVariable ["VMF_disableArsenal",true,true];
