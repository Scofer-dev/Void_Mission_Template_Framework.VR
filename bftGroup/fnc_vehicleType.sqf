//
// Function: VMF_fnc_vehicleType
// Author: Scofer
// Description: Checks what kind of vehicle the passed vehicle argument is and returns the corresponding marker type
// Intended Locality: Server
//
if !(hasInterface) exitWith {};

params [
	"_vehicle"
];

private _return = "b_inf";
private _vehicleKinds = [(configFile >> "CfgVehicles" >> typeOf _vehicle),true] call BIS_fnc_returnParents;

switch (true) do {
	case ("APC_Tracked_01_base_F" in _vehicleKinds): {
		_return = "b_mech_inf";
	};
	case ("APC_Tracked_02_base_F" in _vehicleKinds): {
		_return = "b_mech_inf";
	};
	case ("Wheeled_APC_F" in _vehicleKinds): {
		_return = "b_mech_inf";
	};
	case ("Tank" in _vehicleKinds): {
		_return = "b_armor";
	};
	case ("Plane" in _vehicleKinds): {
		_return = "b_plane";
	};
	case ("Helicopter" in _vehicleKinds): {
		_return = "b_air";
	};
	case ("Car" in _vehicleKinds): {
		_return = "b_motor_inf";
	};
	case ("Ship" in _vehicleKinds): {
		_return = "b_naval";
	};
};

_return