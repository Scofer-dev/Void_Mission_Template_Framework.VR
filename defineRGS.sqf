[
	"Random Group Spawner",
	"Spawn Group",
	{
		[_this select 0] call RGS_fnc_spawnGroupDialog;
	},
	"\a3\3den\data\displays\display3den\panelright\modeobjects_ca.paa"
] remoteExec ["zen_custom_modules_fnc_register",[0,-2] select isDedicated,true];

[
	"Random Group Spawner",
	"Spawn Vehicle",
	{
		[_this select 0] call RGS_fnc_spawnVehicleDialog;
	},
	"\a3\soft_f\mrap_01\data\ui\mrap_01_base_ca.paa"
] remoteExec ["zen_custom_modules_fnc_register",[0,-2] select isDedicated,true];

VMF_skillNameArray = ["aimingAccuracy","aimingShake","aimingSpeed","endurance","spotDistance","spotTime","courage","reloadSpeed","commanding","general"];
publicVariable "VMF_skillNameArray";

RGS_groupPoolArray = [];
RGS_vehiclePoolArray = [];

private _helmetArray = [
	"H_Bandanna_camo",
	"H_Booniehat_khk",
	"H_Hat_grey"
];

private _goggleArray = [
	"G_Balaclava_Halloween_01",
	"G_Bandanna_RedFlame1",
	"G_Sport_BlackWhite"
];

private _uniformArray = [
	"U_C_Journalist",
	"U_Rangemaster",
	"U_I_G_Story_Protagonist_F"
];

private _vestArray = [
	"V_HarnessOGL_brn",
	"V_TacVest_brn",
	"V_PlateCarrier1_blk"
];

private _backpackArray = [
	"B_TacticalPack_mcamo",
	"B_FieldPack_ocamo",
	"B_AssaultPack_dgtl"
];


[
	opforSquad,["OPFOR Infantry Squad"],
	true,{},_helmetArray,_goggleArray,_uniformArray,_vestArray,_backpackArray
] call RGS_fnc_defineGroup;

[
	opforTeam,["OPFOR Infantry Team"],
	true,
	{_unit setDamage 0.5},
	_helmetArray,_goggleArray,_uniformArray,_vestArray,_backpackArray
] call RGS_fnc_defineGroup;


[
	opforTransport,["OPFOR Transport"],
	true,{},{},_helmetArray,_goggleArray,_uniformArray,_vestArray,_backpackArray
] call RGS_fnc_defineVehicle;

[
	opforTechnical,["OPFOR Technical"],
	true,
	{_unit setDamage 0.5},
	{_vehicle setFuel 0.5},
	_helmetArray,_goggleArray,_uniformArray,_vestArray,_backpackArray
] call RGS_fnc_defineVehicle;
