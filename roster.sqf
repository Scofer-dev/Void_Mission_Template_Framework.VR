/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Author 		: Skippy (Modified for The Void by Nillers)
//
//
//
//
//
/*
*****************************************************************************************************************************************
*/

if(isDedicated) exitWith {};

#ifndef Skpp_Roster_Include_AI
#define Skpp_Roster_Include_AI 0
#endif

#ifndef Skpp_Roster_Role
#define Skpp_Roster_Role true
#endif


private["_strRole","_strGrp","_strColorGrp","_strFinal","_oldGrp","_newGrp","_unitsArr"];


_strRole 		= ""; //will contain unit's role
_strGrp 		= ""; //will contain unit's group name
_strColorGrp 	= ""; //will contain unit's group color
_strFinal 		= ""; //will contain final string to be displayed
_oldGrp 		= grpNull; //group of last checked unit
_newGrp 		= grpNull; //group of current unit
_unitsArr 		= []; //will contain all units that have to be processed


switch(Skpp_Roster_Include_AI) do {
	case 0:{//only players
		{
			if(isPlayer _x) then {
				_unitsArr = _unitsArr + [_x];
			};
		}forEach allUnits;
	};
	default{
		_unitsArr = allUnits;
	};
};

{//forEach
	if(side _x == side player) then {
		_newGrp = group _x;
		_strGrp = "";

		if(Skpp_Roster_Role) then {
			_strRole = " - " + (roleDescription _x);
		};

		if(_newGrp != _oldGrp) then {
			_strGrp = "<br/>" + (groupID(group _x)) + "<br/>";
		
			switch (side _x) do {
				case EAST:{
					_strColorGrp = "'#990000'";
				};
				case WEST:{
					_strColorGrp = "'#0066CC'";
				};
				case RESISTANCE:{
					_strColorGrp = "'#339900'";
				};
				case CIVILIAN:{
					_strColorGrp = "'#990099'";
				};
			};

			if(((group _x) getVariable "color") != "") then {
				_strColorGrp = (group _x) getVariable "color";
			};
		};

		_strFinal =  _strFinal + "<font color="+_strColorGrp+">"+_strGrp+"</font>" + name _x + _strRole + "<br/>";

		_oldGrp = group _x;
	};
}forEach _unitsArr;

player createDiarySubject ["roster","Platoon Roster"];
player createDiaryRecord ["roster",["Roster",_strFinal]];


