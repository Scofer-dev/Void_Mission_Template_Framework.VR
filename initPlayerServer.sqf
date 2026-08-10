params [
	"_playerUnit",
	"_didJIP"
];

if (missionNamespace getVariable ["VMF_safeStartEnabled",true]) then {
	[_playerUnit] remoteExec ["VMF_fnc_safeStartInit",_playerUnit];
};

{
	if (!isnull (getassignedcuratorunit _x)) then {
		_unit = getassignedcuratorunit _x;
		if (isnull (getassignedcuratorlogic _unit)) then {
			unassignCurator _x;
			sleep 1;
			_unit assignCurator _x;
		};
	};
} foreach allcurators;