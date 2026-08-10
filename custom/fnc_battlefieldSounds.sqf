params [
	["_enableFirefightSounds",true,[true]],
	["_enableExplosionSounds",true,[true]],
	["_enableAircraftSounds",true,[true]]
];

private _firefightSounds = [""];
private _explosionSounds = [""];
private _aircraftSounds = [""];

if (_enableFirefightSounds) then {
	_firefightSounds = [
		"BattlefieldFirefight1_3D",
		"BattlefieldFirefight2_3D",
		"BattlefieldFirefight3_3D",
		"BattlefieldFirefight4_3D",
		"",
		""
	];
};

if (_enableExplosionSounds) then {
	_explosionSounds = [
		"BattlefieldExplosions1_3D",
		"BattlefieldExplosions2_3D",
		"BattlefieldExplosions3_3D",
		"BattlefieldExplosions4_3D",
		"BattlefieldExplosions5_3D",
		"",
		"",
		"",
		"",
		""
	];
};

if (_enableAircraftSounds) then {
	_aircraftSounds = [
		"BattlefieldHeli1_3D",
		"BattlefieldHeli2_3D",
		"BattlefieldHeli3_3D",
		"BattlefieldJet1_3D",
		"BattlefieldJet2_3D",
		"BattlefieldJet3_3D",
		"",
		"",
		"",
		"",
		"",
		""
	];
};

while {true} do {
	private _fireFightSound = selectRandom _firefightSounds;
	private _explosionSound = selectRandom _explosionSounds;
	private _aircraftSound = selectRandom _aircraftSounds;

	if (_fireFightSound != "") then {
		playSound _fireFightSound;
	};
	sleep 1;

	if (_explosionSound != "") then {
		playSound _explosionSound;
	};
	sleep 1;

	if (_aircraftSound != "") then {
		playSound _aircraftSound;
	};
	sleep 5;

	sleep (random 10);
};