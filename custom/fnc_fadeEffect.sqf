/*
	Slightly customised version of BIS_fnc_fadeEffect 

	[0,"BLACK",5,1,"bloodOnTheRisers"] spawn BIS_fnc_fadeEffect; = [true,"BLACK",5,true,"bloodOnTheRisers"] spawn VMF_fnc_fadeEffect;

	[1,"BLACK",5] spawn BIS_fnc_fadeEffect; = [false,"BLACK",5] spawn VMF_fnc_fadeEffect;
*/

params [
	["_fadeIn",true,[true]],
	["_fadeColour","BLACK",[""]],
	["_fadeDuration",0,[0]],
	["_blur",false,[true]],
	["_music","",[""]]
];

if (_fadeIn) then {
	missionNamespace setVariable ["VMF_fadeSoundVolume",soundVolume];
	missionNamespace setVariable ["VMF_fadeSpeechVolume",speechVolume];
	
	private _musicVolume = musicVolume;
	missionNamespace setVariable ["VMF_fadeMusicVolume",_musicVolume];

	private _blurEffect = ppEffectEnabled "DynamicBlur";
	missionNamespace setVariable ["VMF_fadeBlur", _blurEffect];

	if (_blur) then {
		sleep 0.5;
		"DynamicBlur" ppEffectEnable true;
		"DynamicBlur" ppEffectAdjust [0];
		"DynamicBlur" ppEffectCommit 0;
	};

	_fadeDuration fadeSound 0;
	_fadeDuration fadeMusic 0;
	_fadeDuration fadeSpeech 0;
	
	if (_music != "") then {
		0 fadeMusic _musicVolume;
		playMusic _music;
	};

	if (toLowerANSI _fadeColour in ["black","white"]) then {
		_fadeColour = _fadeColour + " OUT";

		99 cutText ["",_fadeColour,_fadeDuration,true,false,true];
	} else {
		["Invalid fade colour: %1 in VMF_fnc_fadeEffect. Only 'black' or 'white' are accepted.",_fadeColour] call BIS_fnc_error;
	};

	if (_blur) then {
		"DynamicBlur" ppEffectEnable _blurEffect;
	};

} else {
	private _soundVolume = missionNamespace getVariable ["VMF_fadeSoundVolume", soundVolume];
	private _speechVolume = missionNamespace getVariable ["VMF_fadeSpeechVolume", speechVolume];
	private _musicVolume = missionNamespace getVariable ["VMF_fadeMusicVolume", musicVolume];
	private _blurEffect = missionNamespace getVariable ["VMF_fadeBlur", ppEffectEnabled "DynamicBlur"];

	if (_blur) then {
		"DynamicBlur" ppEffectEnable true;
		"DynamicBlur" ppEffectAdjust [5];
		"DynamicBlur" ppEffectCommit 0;
	};

	0 fadeSound 0; 	
	0 fadeSpeech 0;
	0 fadeMusic 0;

	if (_music != "") then {
		0 fadeMusic _musicVolume;
		playMusic _music;
	};

	if (toLowerANSI _fadeColour in ["black","white"]) then {
		_fadeColour = _fadeColour + " IN";

		99 cutText ["",_fadeColour,_fadeDuration,true,false,true];
	} else {
		["Invalid fade colour: %1 in VMF_fnc_fadeEffect. Only 'black' or 'white' are accepted.",_fadeColour] call BIS_fnc_error;
	};

	_fadeDuration fadeSound _soundVolume;
	_fadeDuration fadeSpeech _speechVolume;
	_fadeDuration fadeMusic _musicVolume;
	
	if (_blur) then {
		"DynamicBlur" ppEffectAdjust [0];
		"DynamicBlur" ppEffectCommit _fadeDuration;
	};

	sleep _fadeDuration;

	if (_blur) then {
		"DynamicBlur" ppEffectEnable _blurEffect
	};
};