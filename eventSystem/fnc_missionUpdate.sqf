params [
	"_messageType"
];

switch (_messageType) do {
	case 0: {//Respawn Wave
		if (hasInterface) then {
			[] spawn {	//Player respawn
				setPlayerRespawnTime 0;

				sleep 30;

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
	case 2: {
		if (hasInterface) then {
			//Code to execute on each client
			[] spawn {
				
			};
		};
		
		if (isServer) then {
			//Code to execute on the server
			[] spawn {	//Mission Success
				["Victory",true,true,false] remoteExec ["BIS_fnc_endMission",0,true]; 
			};
		};
	};
	case 3: {
		if (hasInterface) then {
			//Code to execute on each client
			[] spawn {
				
			};
		};
		
		if (isServer) then {
			//Code to execute on the server
			[] spawn {	//Mission Failure
				["Defeat",true,true,false] remoteExec ["BIS_fnc_endMission",0,true]; 
			};
		};
	};
	case 4: {
		if (hasInterface) then {
			//Code to execute on each client
			[] spawn {
				
			};
		};
		
		if (isServer) then {
			//Code to execute on the server
			[] spawn {	//Mission Failure
				["Mutually Exclusive Event 2"] call VMF_fnc_removeEvent;
			};
		};
	};
	case 5: {
		if (hasInterface) then {
			//Code to execute on each client
			[] spawn {
				
			};
		};
		
		if (isServer) then {
			//Code to execute on the server
			[] spawn {	//Mission Failure
				["Mutually Exclusive Event 1"] call VMF_fnc_removeEvent;
			};
		};
	};
};