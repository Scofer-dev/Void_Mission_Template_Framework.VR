/* ----------------------------------------------------------------------------
Function: VMF_fnc_safeStartInit

Description:
    Activates Safe Start for each client if it's enabled, and the mission hasn't gone live

Execution:
	- Local: Yes
	- Server: No
	- Global: No

Parameters:
    0: Player Unit <Object>

Example:
	[_playerUnit] remoteExec ["VMF_fnc_safeStartInit",_playerUnit];

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

waitUntil {!isNull player};

player allowDamage false;

//Find out the current status of ACE Advanced Throwing so it can be restored to that state when Safe Start ends
private _aceThrowing = ace_advanced_throwing_enabled;
//Disable throwing
ace_advanced_throwing_enabled = false;

//Make player immune to WBK melee damage
player setVariable ['IMS_IsUnitInvicibleScripted',1,true];

//Prevents firing of weapons. Removed weapon dry sfx as it was annoying. In future may try making the sound only play for the player that clicked, rather than using a 3D sound
private _fireAction = [
	player,
	"DefaultAction",
	"true",
	{
		hintSilent "Safe Start is Active!";
	}
] call ace_common_fnc_addActionEventHandler;

//Extra check that deletes projectiles if weapon is fired
private _firedEH = player addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	deleteVehicle _projectile;

	//If player throws a grenade delete the grenade projectile, and give player the grenade back
	if (_weapon == "Throw") then {
		_unit addMagazine _magazine;
	};
}];

player setVariable ["VMF_safeStart_params",[_aceThrowing,_fireAction,_firedEH]];

//Displays the Safe Start Active box
[
	{
		if (missionNamespace getVariable ["VMF_safeStartEnabled",false]) then {
			"VMF_safeStart_layer" cutRsc ["VMF_safeStart_enabled","PLAIN",0];
		} else { //Once Safe Start is disabled enable everything
			private _handle = _this select 1;
			
			//private _handle = _this select 1;
			player getVariable "VMF_safeStart_params" params [
				"_aceThrowing",
				"_fireAction",
				"_firedEH"
			];

			if (playerSide != sideLogic) then {
				player allowDamage true;
			};

			ace_advanced_throwing_enabled = _aceThrowing;

			//Remove player WBK melee immunity
			player setVariable ['IMS_IsUnitInvicibleScripted',nil,true];

			[player,"DefaultAction",_fireAction] call ace_common_fnc_removeActionEventHandler;

			player removeEventHandler ["Fired",_firedEH];

			[_handle] call CBA_fnc_removePerFrameHandler;
			
			//Shows the Safe Start disabled box, which fades after a few seconds
			"VMF_safeStart_layer" cutRsc ["VMF_safeStart_disabled","PLAIN"];
		};
	},
	0.5
] call CBA_fnc_addPerFrameHandler;