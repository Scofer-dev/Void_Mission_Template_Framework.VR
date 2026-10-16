/* ----------------------------------------------------------------------------
Function: RGS_fnc_loadoutRandomiser

Description:
	Randomises the passed loadout using passed equipment data

Execution:
	- Client: No
	- Server: Yes
	- Global: No

Parameters:
	0: Loadout Data <Array>
	1: Equipment Data <Array>

Example:
	[
		getUnitLoadout _unit,
		[
			["H_Bandanna_blu","H_Beret_CSAT_01_F"],
			["G_Balaclava_Skull1","G_Tactical_Clear"],
			["U_C_Commoner1_2","U_C_Driver_1_red"],
			["V_BandollierB_khk","V_EOD_olive_F"],
			["B_AssaultPack_dgtl","B_FieldPack_oli"]
		]
	] call RGS_fnc_loadoutRandomiser;
	
Returns:
    0: Loadout Data <Array>

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

params [
	"_loadout",
	"_equipmentData"
];

_equipmentData params [
	["_helmetArray",[],[[]]],
	["_facewearArray",[],[[]]],
	["_uniformArray",[],[[]]],
	["_vestArray",[],[[]]],
	["_backPackArray",[],[[]]]
];

if (_helmetArray isNotEqualTo 0) then {
	_loadout set [6,selectRandom _helmetArray];
};
if (_facewearArray isNotEqualTo 0) then {
	_loadout set [7,selectRandom _facewearArray];
};
if (_uniformArray isNotEqualTo 0) then {
	[_loadout,[3,0],selectRandom _uniformArray] call BIS_fnc_setNestedElement;
};
if (_vestArray isNotEqualTo 0) then {
	[_loadout,[4,0],selectRandom _vestArray] call BIS_fnc_setNestedElement;
};
if (_backpackArray isNotEqualTo 0) then {
	[_loadout,[5,0],selectRandom _backpackArray] call BIS_fnc_setNestedElement;
};

_loadout