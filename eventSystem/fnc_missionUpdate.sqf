params [
	"_messageType"
];

if (playerSide == sideLogic) then {
	["Event Activated",format ["Event: %1",_messageType],5] remoteExec ["VMF_fnc_zeusHint",[0,-2] select isDedicated];
};

switch (_messageType) do {
	case 0: {//Respawn Wave
		if (hasInterface) then {
			[] spawn {	//Player respawn
				setPlayerRespawnTime 0;

				sleep 5;

				setPlayerRespawnTime 999999;
			};
		};
	};
	case 1: {//Mission Live
		if (hasInterface) then {
			//Code to execute on each client
			[] spawn {
				
			};
		};
		
		if (isServer) then {
			//Code to execute on the server
			[] spawn {	//Disables Safe Start
				["Mission is Live"] call VMF_fnc_missionStart;
			};
		};
	};
	case 8: {
		if (hasInterface) then {
			//Code to execute on each client
			[] spawn {
				
			};
		};
		
		if (isServer) then {
			//Code to execute on the server
			[] spawn {	//Mission Success
				["Mission Failure"] call VMF_fnc_removeEvent;	//Removes the Mission Failure event
				["Victory",true,true,false] remoteExec ["BIS_fnc_endMission",0,true]; 
			};
		};
	};
	case 9: {
		if (hasInterface) then {
			//Code to execute on each client
			[] spawn {
				
			};
		};
		
		if (isServer) then {
			//Code to execute on the server
			[] spawn {	//Mission Failure
				["Mission Success"] call VMF_fnc_removeEvent;	//Removes the Mission Success event
				["Defeat",true,true,false] remoteExec ["BIS_fnc_endMission",0,true]; 
			};
		};
	};
};