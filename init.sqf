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
