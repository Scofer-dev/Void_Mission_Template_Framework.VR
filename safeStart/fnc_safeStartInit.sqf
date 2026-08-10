//
// Function: VMF_fnc_safeStartInit
// Author: Scofer
// Description: Activates safeStart for the local client. If JIP checks if safeStart is disabled on the server
// Locality: Player
//
if !(hasInterface) exitWith {};

params [
	["_playerUnit",objNull,[objNull]]
];

if (isNull _playerUnit) exitWith {};

_playerUnit allowDamage false;

//Find out the current status of ACE Advanced Throwing so it can be restored to that state when Safe Start ends
private _aceThrowing = ace_advanced_throwing_enabled;
//Disable throwing
ace_advanced_throwing_enabled = false;

//Make player immune to WBK melee damage
_playerUnit setVariable ['IMS_IsUnitInvicibleScripted',1,true];

//Prevents firing of weapons. Removed weapon dry sfx as it was annoying. In future may try making the sound only play for the player that clicked, rather than using a 3D sound
private _fireAction = [
	_playerUnit,
	"DefaultAction",
	"true",
	{
		hintSilent "Safe Start is Active!";
	}
] call ace_common_fnc_addActionEventHandler;

//Extra check that deletes projectiles if weapon is fired
private _firedEH = _playerUnit addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	deleteVehicle _projectile;

	//If player throws a grenade delete the grenade projectile, and give player the grenade back
	if (_weapon == "Throw") then {
		_unit addMagazine _magazine;
	};
}];

_playerUnit setVariable ["VMF_safeStart_params",[_aceThrowing,_fireAction,_firedEH]];

//Displays the Safe Start Active box
[
	{
		if (missionNamespace getVariable ["VMF_safeStartEnabled",false]) then {
			"VMF_safeStart_layer" cutRsc ["VMF_safeStart_enabled","PLAIN",0];
		} else { //Once Safe Start is disabled enable everything
			_this params [
				"_playerUnit",
				"_handle"
			];

			//private _handle = _this select 1;
			_playerUnit getVariable "VMF_safeStart_params" params [
				"_aceThrowing",
				"_fireAction",
				"_firedEH"
			];

			if (playerSide != sideLogic) then {
				_playerUnit allowDamage true;
			};

			ace_advanced_throwing_enabled = _aceThrowing;

			//Remove player WBK melee immunity
			_playerUnit setVariable ['IMS_IsUnitInvicibleScripted',nil,true];

			[_playerUnit,"DefaultAction",_fireAction] call ace_common_fnc_removeActionEventHandler;

			_playerUnit removeEventHandler ["Fired",_firedEH];

			[_handle] call CBA_fnc_removePerFrameHandler;
			
			//Shows the Safe Start disabled box, which fades after a few seconds
			"VMF_safeStart_layer" cutRsc ["VMF_safeStart_disabled","PLAIN"];
		};
	},
	0.5,
	_playerUnit
] call CBA_fnc_addPerFrameHandler;