//
// Function: VMF_fnc_addArsenal
// Author: Scofer
// Description: Adds ACE custom arsenal to each player, giving them access to all equipment they start with, and any additional gear as a parameter
// Intended Locality: Player
//
if !(hasInterface) exitWith {};
if (playerSide == sideLogic) exitWith {};

params [
	["_gearArray",[""]]
];

//These can all be done as a single line, but this is neater
private _playerGear = [headGear player] + [goggles player] + [uniform player] + [vest player] + [backpack player];
private _playerInventory = assignedItems player + uniformItems player + vestItems player + backpackItems player;
private _playerWeapons = weapons player + magazines player + primaryWeaponItems player + primaryWeaponMagazine player + handgunItems player + handgunMagazine player + secondaryWeaponItems player + secondaryWeaponMagazine player;
_gearArray = _gearArray + _playerInventory + _playerWeapons + _gearArray;


_gearArray = _gearArray select {count _x > 0};
_gearArray = _gearArray arrayIntersect _gearArray;

[player,_gearArray] call ace_arsenal_fnc_addVirtualItems;

private _openArsenal = [
	"Open Arsenal",
	"Arsenal",
	"",
	{
		[player,player] call ace_arsenal_fnc_openBox;
	},
	{!(missionNamespace getVariable ["VMF_disableArsenal",false])}
] call ace_interact_menu_fnc_createAction;

[
	player,
	1,
	["ACE_SelfActions"],
	_openArsenal
] call ace_interact_menu_fnc_addActionToObject;


["ace_arsenal_displayOpened",{
	params ["_display"];

	private _deleteButton = _display displayCtrl 40;
	private _loadoutButton = _display displayCtrl 1003;
	private _exportButton = _display displayCtrl 1004;
	private _importButton = _display displayCtrl 1005;

	{
		_x ctrlRemoveAllEventHandlers "ButtonClick";
	} forEach [_deleteButton,_loadoutButton,_exportButton,_importButton];
}] call CBA_fnc_addEventHandler;

["ace_arsenal_leftPanelFilled",{
	params ["_display","_leftPanelIDC","_rightPanelIDC"];

	if !(_leftPanelIDC in [2008,2016]) then {
		private _leftPanel = _display displayCtrl 13;

		private _item = _leftPanel lbData 0;

		//I'm pretty sure it's always blank, but better to check
		if (_item == "") then {
			_leftPanel lbDelete 0;
		};
	};

	private _deleteButton = _display displayCtrl 40;
	private _loadoutButton = _display displayCtrl 1003;
	private _exportButton = _display displayCtrl 1004;
	private _importButton = _display displayCtrl 1005;

	{
		_x ctrlShow false;
	} forEach [_deleteButton,_loadoutButton,_exportButton,_importButton];
}] call CBA_fnc_addEventHandler;

["ace_arsenal_rightPanelFilled",{
	params ["_display","_leftPanelIDC","_rightPanelIDC"];

	private _deleteButton = _display displayCtrl 40;
	ctrlDelete _deleteButton;
}] call CBA_fnc_addEventHandler;