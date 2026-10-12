/* ----------------------------------------------------------------------------
Function: VMF_fnc_teamMarkerColour

Description:
    Checks what colour a units team BFT marker should be based on their assigned team colour
	Typically called by VMF_fnc_teamMarkers

Execution:
	- Local: Yes
	- Server: No
	- Global: No

Parameters:
    0: Unit <Object>

Example:
	[playerOne] call VMF_fnc_teamMarkerColour;

Returns:
    Marker colour name string

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_unit",objNull,[objNull]]
];

if (isNull _unit) exitWith {};

private _team = "MAIN"; //Sets a default value to prevent error if unit deleted
_team = assignedTeam _unit;
private _markerColour = "";

switch (_team) do {
	case "MAIN": {
		_markerColour = "ColorWhite";
	};
	case "RED": {
		_markerColour = "ColorRed";
	};
	case "GREEN": {
		_markerColour = "ColorGreen";
	};
	case "BLUE": {
		_markerColour = "ColorBlue";
	};
	case "YELLOW": {
		_markerColour = "ColorYellow";
	};
};

_markerColour