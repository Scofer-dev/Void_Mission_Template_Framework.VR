private _startTime = time;

private _timeStamp = (_this select 0) select 2;

waitUntil {sleep 0.1; time >= (_startTime + _timeStamp)};

{
	_x params [
		["_title","",[""]],
		["_text","",[""]],
		["_timeStamp",0,[0]]
	];

	if (_forEachIndex != 0) then {
		waitUntil {sleep 0.1; time >= (_startTime + _timeStamp)};
	};

	[_title,_text] call VMF_fnc_showSubtitle;
} forEach _this;