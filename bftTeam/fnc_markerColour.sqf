//
// Function: VMF_fnc_markerColour
// Author: Scofer
// Description: Checks what colour a units team BFT marker should be
// Intended Locality: Player
//
params [
	"_unit"
];

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