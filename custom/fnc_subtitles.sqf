/* ----------------------------------------------------------------------------
Function: VMF_fnc_subtitles

Description:
	Modified version of BIS_fnc_EXP_camp_playSubtitles to use custom subtitle display

Execution:
	- Local: Yes
	- Server: No
	- Global: Yes

Parameters:
	0: Subtitle Details <Array>

	[subtitleDetail1,subtitleDetail2, etc]

	subtitleDetailN parameters:
		0: Speaker <String>
		1: Text <String>
		2: Timing <Number>

Example:
	[
		["ION HQ", "Knight Flight, clear for take-off",0],
		["Knight 1-1", "Howdy folks. Welcome to Knight Flight. Please keep your hands and feet inside the aircraft and remain seated at all times. We hope you have a pleasant flight today.",6],
		["Knight 1-1", "The local military has already got the enemy boxed in, but they're poorly trained. You better do this right and secure those hostages before the bloodbath starts.",25],
		["Knight 1-1", "30 seconds to touchdown",45],
		["Knight 1-1", "10 seconds",65],
		["Knight 1-1", "Touchdown. Thank you for flying ION Airlines. We'll stick around until you're all out and have moved away from the choppers.",75]
	] spawn VMF_fnc_subtitles;

	[
		[
			["ION HQ", "Knight Flight, clear for take-off",0],
			["Knight 1-1", "Howdy folks. Welcome to Knight Flight. Please keep your hands and feet inside the aircraft and remain seated at all times. We hope you have a pleasant flight today.",6],
			["Knight 1-1", "The local military has already got the enemy boxed in, but they're poorly trained. You better do this right and secure those hostages before the bloodbath starts.",25],
			["Knight 1-1", "30 seconds to touchdown",45],
			["Knight 1-1", "10 seconds",65],
			["Knight 1-1", "Touchdown. Thank you for flying ION Airlines. We'll stick around until you're all out and have moved away from the choppers.",75]
		]
	] remoteExec ["VMF_fnc_subtitles",[0,-2] select isDedicated];

Returns:
    Nothing

Author:
	Thomas Ryan, modified by Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

private _startTime = time;

private _timeStamp = (_this select 0) select 2;

waitUntil {sleep 0.1; time >= (_startTime + _timeStamp)};

{
	_x params [
		["_title","",[""]],
		["_text","",[""]],
		["_timeStamp",0,[0]]
	];

	if (_forEachIndex != 0) then {
		waitUntil {sleep 0.1; time >= (_startTime + _timeStamp)};
	};

	[_title,_text] call VMF_fnc_showSubtitle;
} forEach _this;