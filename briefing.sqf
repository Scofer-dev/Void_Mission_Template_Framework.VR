/* ===============================================
    GENERAL BRIEFING NOTES
     - Uses HTML style syntax. All supported tags can be found here - https://community.bistudio.com/wiki/createDiaryRecord
     - For images use <img image='FILE'></img> (for those familiar with HTML note it is image rather than src).
     - Note that using the " character inside the briefing block is forbidden use ' instead of ".
*/

/* ===============================================
    SITUATION
     - Outline of what is going on, where we are and what has happened before the mission has started? This needs to contain any relevant background information.
     - Draw attention to friendly and enemy forces in the area. The commander will make important decisions based off this information.
     - Outline present weather conditions, players will typically assume that it is daylight with sunny weather.

    Marker Colour Classes
    https://community.bistudio.com/wiki/Arma_3:_CfgMarkerColors
    Use HTML code
*/


private _situation = ["diary", ["Situation","
*** Insert general information per the above description.***
<br/><br/>

<font size='18'>WEATHER</font>
*** Some details of weather conditions, can be removed if unwanted
<br/><br/>

<font size='18' color='#004C99'>FRIENDLY FORCES</font>
<br/>
*** Detail friendly forces that are external to the playable force. ***
<br/><br/>

<font size='18' color='#800000'>ENEMY FORCES</font>
<br/>
*** Provide information on enemy forces.***
"]];

/* ===============================================
    MISSION
     - Describe any objectives that the team is expected to complete.
     - Summarize(!) the overall task. This MUST be short and clear.
	 - For objectives linked to a marker location use: <marker name='MARKERNAME'>TEXT</marker>
*/

private _mission = ["diary", ["Mission","
*** Provide a short summary of the mission objectives here. ***
<br/><br/>
<font size='18'>PRIMARY OBJECTIVES</font>
<br/>
- Primary Objective #1<br/>
- Primary Objective #2
<br/><br/>

<font size='18'>SECONDARY OBJECTIVES</font>
<br/>
- N/A
"]];

/* ===============================================
    EXECUTION
     - Provide an outline as to what the commander of the player's command might give.
*/

private _execution = ["diary", ["Execution","
<font size='18'>COMMANDER'S INTENT</font>
<br/>
*** Insert very short summary of plan here. ***
<br/><br/>

<font size='18'>MOVEMENT PLAN</font>
<br/>
*** Insert movement instructions here. ***
<br/><br/>

<font size='18'>FIRE SUPPORT PLAN</font>
<br/>
*** Provide details on any available fire support. ***
<br/><br/>

<font size='18'>SPECIAL TASKS</font>
<br/>
*** Insert instructions for specific units here. ***
"]];

/* ===============================================
    ADMINISTRATION
     - Outline of logistics: available resources (equipment/vehicles) and ideally a summary of their capabilities.
     - Outline of how to use any mission specific features/scripts.
     - Seating capacities of each vehicle available for use.
*/

private _administration = ["diary", ["Administration","
<font size='18'>RESPAWN</font><br/>
Respawn may be available by admin discretion, however it is not to be expected.
<br/><br/>

<font size='18'>RESUPPLY</font><br/>
*** Insert resupply details here ***
<br/><br/>

<font size='18'>RADIOS</font><br/>
*** Insert radio details here ***
<br/><br/>
Add <execute expression='" + toString{["ACRE_PRC343"] call VMF_fnc_addRadio} + "'>PRC 343</execute> radio to inventory.
<br/>
Add <execute expression='" + toString{["ACRE_PRC148",["B_officer_F","B_Soldier_SL_F"]] call VMF_fnc_addRadio} + "'>PRC 148</execute> radio to inventory.
<br/><br/>

<font size='18'>VEHICLES</font><br/>
*** Insert player vehicle details here ***
<br/><br/>

<font size='18'>AREA OF OPERATIONS</font><br/>
*** Insert AO details here ***
<br/><br/>

<font size='18'>MUSIC - REMOVE IF NOT NEEDED</font><br/>
Background music will play at certain parts of the mission. If you wish to hear it ensure your music volume is set to a sensible level so you can still hear player communications.
"]];

/* ===============================================
	NOTES
	 - Any notes for administrators or session hosts.
	 - Items for all players in regards to specific tool or script function.
*/

private _notes = ["diary", ["Admin Notes","
*** Insert any additional notes for session zeus' or admin. ***
"]];

if (playerSide == sideLogic || {!isMultiplayer || (call BIS_fnc_admin) > 0}) then {
    player createDiaryRecord _notes;
};

player createDiaryRecord _administration;
player createDiaryRecord _execution;
player createDiaryRecord _mission;
player createDiaryRecord _situation;
