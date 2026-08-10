enableEnvironment [false, true];
enableSentences false;
player setSpeaker "NoVoice";

// JIP-able Briefing and Platoon Roster
if (!isDedicated) then {
      waitUntil {!isNull player}; // waitUntil the player variable exists

      // Briefing	  
      [] execVM "briefing.sqf";
                                          
      // Platoon Roster Creater
      [0,false,false,"ColorWEST","'#0066CC'"] execVM "roster.sqf";
};

[3] spawn VMF_fnc_teamMarkers_loop;

[
      3,    //Update Delay in seconds
      100,  //Max distance between group leader and a unit for its position to be counted for the position centroid
      true //Add group markers for friendly sides
] spawn VMF_fnc_groupMarkers_loop;
