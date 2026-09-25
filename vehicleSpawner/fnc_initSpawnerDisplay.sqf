/*
Function:
	VMF_fnc_initSpawnerDisplay

Description:
	Adds necessary event handlers to the open Vehicle Spawner Display passed by VMF_fnc_vehicleSpawner

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
	0: Spawner Display <Display>		Default: displayNull
	1: Spawn Position Object <Object>	Default: objNull
	2: Vehicle Data <Array>				Default: []

Examples:
	[_display] call VMF_fnc_initSpawnerDisplay;

Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
params [
	["_display",displayNull,[displayNull]],
	["_spawnPos",objNull,[objNull]],
	["_vehicleData",[],[[]]]
];

if (isNull _display) exitWith {};
if (_vehicleData isEqualTo []) exitWith {};

uiNamespace setVariable ["VMF_spawnVehicle_display",_display];

if (isNull _spawnPos) then {
	uiNamespace setVariable ["VMF_spawnVehicle_spawnPos",objNull];
} else {
	uiNamespace setVariable ["VMF_spawnVehicle_spawnPos",_spawnPos];
	private _currentVehicleCtrl = uiNamespace getVariable ['VMF_spawnVehicle_currentVehicle',controlNull];

	private _eachFrameEH = addMissionEventHandler ["EachFrame",{
		if (isNull (uiNamespace getVariable ["VMF_spawnVehicle_display",displayNull])) exitWith {
			removeMissionEventHandler ["EachFrame",_thisEventHandler];
		};

		_thisArgs params [
			"_spawnPos",
			"_currentVehicleCtrl"
		];

		private _nearVehicle = nearestObjects [_spawnPos,["LandVehicle","Air","Ship"],12] select 0;

		if (isNil "_nearVehicle") then {
			_currentVehicleCtrl ctrlSetText "No vehicle in spawn zone";
			uiNamespace setVariable ["VMF_spawnVehicle_nearVehicle",objNull];
		} else {
			uiNamespace setVariable ["VMF_spawnVehicle_nearVehicle",_nearVehicle];
			private _vehicleName = getText (configOf _nearVehicle >> "displayName");
			_currentVehicleCtrl ctrlSetStructuredText parseText format ["Vehicle <t color='#FF0000'>%1</t> in spawn area",_vehicleName];

			private _spawnButton = uiNamespace getVariable ["VMF_spawnVehicle_spawnButton",controlNull];
			_spawnButton ctrlSetTooltip format ["%1 will be deleted!",_vehicleName];
		};
	},
	[
		_spawnPos,
		_currentVehicleCtrl
	]];
};
 
_display displayAddEventHandler ["Unload",{
	params ["_display", "_exitCode"];

	[_exitCode] call VMF_fnc_deInitSpawner;
}];



private _vehicleList = uiNamespace getVariable ["VMF_spawnVehicle_vehicleList",controlNull];
{
	private _listIndex = _vehicleList lbAdd (_x select 1);
	//Add icons to the list, find a base type with isKindOf, "Car", "Tank", "Heli", etc
} forEach _vehicleData;
	

private _lbSelChangedEH = _vehicleList ctrlAddEventHandler ["lbSelChanged",{
	params ["_control", "_lbCurSel"];

    private _lbLastSel = uiNamespace getVariable ["VMF_spawnVehicle_lbLastSel",-1];
	if (_lbCurSel == _lbLastSel) exitWith {};
	uiNamespace setVariable ["VMF_spawnVehicle_lbLastSel",_lbCurSel];

	private _vehicleData = (uiNamespace getVariable "VMF_spawnVehicle_vehicleData") select _lbCurSel;

	_vehicleData params [
		["_vehicleClass","",[""]],
		["_vehicleName","",[""]],
		["_vehicleSeats",[0,0,0,0,0],[[]]],
		["_components",[[],[]],[[]]],
		["_pylons",[],[[]]],
		["_disableNVG",false,[false]],
		["_disableThermals",false,[false]],
		["_aceParams",[],[[]]],
		["_aceCargo",[],[[]]],
		["_vehicleCargo",[],[[]]],
		["_vehicleInit",[{},{}],[[]]],
		["_camoSelection",[],[[]]]
	];

	private _vehicleNameBox = uiNamespace getVariable ["VMF_spawnVehicle_vehicleName",controlNull];
	_vehicleNameBox ctrlSetText _vehicleName;

	private _vehicleImageBox = uiNamespace getVariable ["VMF_spawnVehicle_vehicleImage",controlNull];
	private _vehicleImage = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "editorPreview");
	_vehicleImageBox ctrlSetText _vehicleImage;



	private _camoList = uiNamespace getVariable ["VMF_spawnVehicle_camoList",controlNull];
	lbClear _camoList;

	if (_camoSelection isEqualTo []) then {
		_camoList ctrlShow false;
	} else {
		_camoList ctrlShow true;
	};

	{
		private _camoClass = _x;
		private _camoName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "TextureSources" >> _camoClass >> "displayName");
		
		if (_camoName isEqualTo "") then { continue };

		private _comboIndex = _camoList lbAdd _camoName;
		_camoList lbSetData [_comboIndex,_camoClass];
	} forEach _camoSelection;
	_camoList lbSetCurSel 0;


	private _specTreeLeft = uiNamespace getVariable ["VMF_spawnVehicle_specTreeLeft",controlNull];
    tvClear _specTreeLeft;
	{
		_x params [
			["_text","",[""]],
			["_image","",[""]]
		];
		private _itemIndex = _specTreeLeft tvAdd [[],_text];
		_specTreeLeft tvSetPicture [[_itemIndex],_image];
	} forEach _vehicleSeats;

	private _specTreeRight = uiNamespace getVariable ["VMF_spawnVehicle_specTreeRight",controlNull];
	tvClear _specTreeRight;
	{
		_x params [
			["_text","",[""]],
			["_state",false,[false]]
		];

		private _itemIndex = _specTreeRight tvAdd [[],_text];
		if (_state) then {
			_specTreeRight tvSetPicture [[_itemIndex],"#(rgb,8,8,3)color(0.2,0.4,0.2,1)"];
		} else {
			_specTreeRight tvSetPicture [[_itemIndex],"#(rgb,8,8,3)color(0.902,0.302,0.302,1)"];
		};
	} forEach _aceParams;

	_aceCargo params [
		["_cargoWheels",0,[-1]],
		["_cargoTracks",0,[-1]]
	];

	if (_cargoWheels > 0) then {
		private _itemIndex = _specTreeRight tvAdd [[],format ["%1x Wheels",_cargoWheels]];
	};
	if (_cargoTracks > 0) then {
		private _itemIndex = _specTreeRight tvAdd [[],format ["%1x Tracks",_cargoTracks]];
	};


	private _inventoryList = uiNamespace getVariable ["VMF_spawnVehicle_inventoryList",controlNull];
	lbClear _inventoryList;

	{
		_x params [
			["_item","",[""]],
			["_amount",0,[-1]],
			["_name","",[""]],
			["_image","",[""]]
		];

		private _itemIndex = _inventoryList lbAdd format ["%1x %2",_amount,_name];
		_inventoryList lbSetPicture [_itemIndex,_image];
	} forEach _vehicleCargo;
}];



private _spawnButton = uiNamespace getVariable ["VMF_spawnVehicle_spawnButton",controlNull];
private _spawnButtonEH = _spawnButton ctrlAddEventHandler ["buttonClick",{
	private _vehicleList = uiNamespace getVariable ["VMF_spawnVehicle_vehicleList",controlNull];
	private _listSelection = lbCurSel _vehicleList;
	private _vehicleData = (uiNamespace getVariable "VMF_spawnVehicle_vehicleData") select _listSelection;

	uiNamespace setVariable ["VMF_spawnVehicle_selectedVehicle",_vehicleData];

	_vehicleData params [
		["_vehicleClass","",[""]],
		["_vehicleName","",[""]],
		["_vehicleSeats",[0,0,0,0,0],[[]]],
		["_components",[[],[]],[[]]],
		["_pylons",[],[[]]],
		["_disableNVG",false,[false]],
		["_disableThermals",false,[false]],
		["_aceParams",[],[[]]],
		["_aceCargo",[],[[]]],
		["_vehicleCargo",[],[[]]],
		["_vehicleInit",[{},{}],[[]]],
		["_camoSelection",[],[[]]]
	];

	_components params [
		"_vehicleTextures",
		"_vehicleAnimations"
	];

	_vehicleInit params [
		"_defineInit",
		"_vehicleInit"
	];

	private _camoList = uiNamespace getVariable ["VMF_spawnVehicle_camoList",controlNull];
	private _selectedCamo = _camoList lbData (lbCurSel _camoList);
	_vehicleTextures set [0,_selectedCamo];
	[_vehicleData,[3,0,0],_selectedCamo] call BIS_fnc_setNestedElement;

	private _spawnPos = uiNamespace getVariable ["VMF_spawnVehicle_spawnPos",objNull];

	if (isNull _spawnPos) then {
		private _displayVehicle = createVehicleLocal [_vehicleClass,[0,0,1000],[],0,"NONE"];
		uiNamespace setVariable ["VMF_spawnVehicle_displayVehicle",_displayVehicle];
		_displayVehicle enableSimulation false;
		_displayVehicle allowDamage false;
		_displayVehicle lock true;
		_displayVehicle lockInventory true;
		_displayVehicle disableCollisionWith player;
		_displayVehicle hideObject true;
		_displayVehicle setPhysicsCollisionFlag false;

		[_displayVehicle,_vehicleTextures,_vehicleAnimations] call BIS_fnc_initVehicle;

		{
			_x params [
				"_index",
				"_name",
				"_turret",
				"_magazine"
			];

			_vehicle setPylonLoadout [_name,_magazine,true,_turret];
		} forEach _pylons;

		_displayVehicle call _defineInit;
		_displayVehicle call _vehicleInit;

		private _vehicleBoundaries = [_displayVehicle] call VMF_fnc_getVehicleBounds;

		//#include "\a3\ui_f\hpp\definedikcodes.inc"
		private _keydownEH = findDisplay 46 displayAddEventHandler ["KeyDown",{
			params ["_display","_key","_shift","_ctrl","_alt"];
			_return = false;

			if (_key isEqualTo 16) then {	//DIK_Q
				uiNamespace setVariable ["VMF_spawnVehicle_keyQ",true];
				_return = true;
			};

			if (_key isEqualTo 18) then {	//DIK_E
				uiNamespace setVariable ["VMF_spawnVehicle_keyE",true];
				_return = true;
			};

			if (_shift) then {
				uiNamespace setVariable ["VMF_spawnVehicle_keyShift",true];
			} else {
				uiNamespace setVariable ["VMF_spawnVehicle_keyShift",false];
			};

			if (_key in [28,57]) then {	//[DIK_RETURN,DIK_SPACE]
				if !(uiNamespace getVariable ["VMF_spawnVehicle_canSpawn",false]) exitWith {};

				private _displayVehicle = uiNamespace getVariable ["VMF_spawnVehicle_displayVehicle",objNull];
				
				private _spawnPos = getPos _displayVehicle;
				private _spawnDir = getDir _displayVehicle;
								
				[3] call VMF_fnc_deInitSpawner;

				private _vehicleData = uiNamespace getVariable "VMF_spawnVehicle_selectedVehicle";

				[
					_spawnPos,
					_spawnDir,
					_vehicleData
				] remoteExec ["VMF_fnc_spawnVehicle",2];			
				
				_return = true;
			};

			if (_key isEqualTo 1) then {	//DIK_ESCAPE
				[3] call VMF_fnc_deInitSpawner;
				_return = true;
			};

			_return
		}];
		uiNamespace setVariable ["VMF_spawnVehicle_keyDownEH",_keydownEH];

		private _keyUpEH = findDisplay 46 displayAddEventHandler ["KeyUp",{
			params ["_display","_key","_shift","_ctrl","_alt"];

			if (_key isEqualTo 16) then {	//DIK_Q
				uiNamespace setVariable ["VMF_spawnVehicle_keyQ",false];
			};

			if (_key isEqualTo 18) then {	//DIK_E
				uiNamespace setVariable ["VMF_spawnVehicle_keyE",false];
			};
		}];
		uiNamespace setVariable ["VMF_spawnVehicle_keyUpEH",_keyUpEH];


		private _fireActionEH = [
			player,
			"DefaultAction",
			"true",
			{}
		] call ace_common_fnc_addActionEventHandler;
		uiNamespace setVariable ["VMF_spawnVehicle_fireActionEH",_fireActionEH];


		private _eachFrameEH = addMissionEventHandler ["EachFrame",{
			_thisArgs params [
				"_displayVehicle",
				"_vehicleBoundaries"
			];

			private _messageType = uiNamespace getVariable ["VMF_spawnVehicle_messageType","valid"];
			private _updateVehicle = false;

			private _curPos = screenToWorld [0.5,0.5];

			//Vehicle has a tendency to blow up if not raised a little
			private _zPos = _curPos select 2;
			_zPos = _zPos + 0.3;
			_curPos set [2,_zPos];

			if (_curPos distance (getPos _displayVehicle) > 0.1) then {
				_updateVehicle = true;
			};

			private _vehicleDir = getDir _displayVehicle;
			if (uiNamespace getVariable ["VMF_spawnVehicle_keyQ",false]) then {
				if (uiNamespace getVariable ["VMF_spawnVehicle_keyShift",false]) then {
					_vehicleDir = _vehicleDir - 5;
				} else {
					_vehicleDir = _vehicleDir - 1;
				};
				_updateVehicle = true;
			};

			if (uiNamespace getVariable ["VMF_spawnVehicle_keyE",false]) then {
				if (uiNamespace getVariable ["VMF_spawnVehicle_keyShift",false]) then {
					_vehicleDir = _vehicleDir + 5;
				} else {
					_vehicleDir = _vehicleDir + 1;
				};
				_updateVehicle = true;
			};

			if (_updateVehicle) then {
				_displayVehicle setPos _curPos;
				_displayVehicle setDir _vehicleDir;
				_displayVehicle setVectorUp (surfaceNormal _curPos);
			};

			if (_updateVehicle) then {
				if (_curPos distance player > 50) exitWith {
					_displayVehicle hideObject true;
					_messageType = "tooFar";
					uiNamespace setVariable ["VMF_spawnVehicle_canSpawn",false];
				};

				private _collision = false;

				_displayVehicle getVariable "VMF_spawnVehicle_areaAxis" params [
					"_xAxis",
					"_yAxis"
				];

				private _nearUnits = [_displayVehicle modelToWorldVisualWorld [0,0,0],_xAxis,_yAxis,_vehicleDir,true] nearEntities [["CAManBase"],false,false];
				if (_nearUnits isNotEqualTo []) then {
					_collision = true;
					_displayVehicle hideObject true;
					_messageType = "collisionUnit";
					uiNamespace setVariable ["VMF_spawnVehicle_canSpawn",false];
				};

				if !(_collision) then {
					{
						_x params [
							"_startPos",
							"_endPos"
						];

						if (lineIntersects [
							_displayVehicle modelToWorldVisualWorld _startPos,
							_displayVehicle modelToWorldVisualWorld _endPos,
							_displayVehicle
						]) exitWith {
							_collision = true;
						};
					} forEach _vehicleBoundaries;

					if (_collision) then {
						_displayVehicle hideObject true;
						_messageType = "collisionObject";
						uiNamespace setVariable ["VMF_spawnVehicle_canSpawn",false];
					} else {
						_displayVehicle hideObject false;
						_messageType = "valid";
						uiNamespace setVariable ["VMF_spawnVehicle_canSpawn",true];
					};
				};
			};

			private _text = "";
			switch _messageType do {
				case "valid": {
					_text = "<t size='.5'>Rotate: Q/E (Shift to speed up)<br/>Spawn: Space/Enter<br/>Quit: Esc</t>";
				};
				case "collisionObject": {
					_text = "<t size='.5'>Rotate: Q/E (Shift to speed up)</t><br/><t color='#FF0000' size='.5'>Object Collision</t><br/><t size='.5'>Quit: Esc</t>";
				};
				case "collisionUnit": {
					_text = "<t size='.5'>Rotate: Q/E (Shift to speed up)</t><br/><t color='#FF0000' size='.5'>Unit Collision</t><br/><t size='.5'>Quit: Esc</t>";
				};
				case "tooFar": {
					_text = "<t size='.5'>Rotate: Q/E (Shift to speed up)</t><br/><t color='#FF0000' size='.5'>Too far away</t><br/><t size='.5'>Quit: Esc</t>";
				};
			};

			private _dynamicText = [_text,0,0.75,1,0,0,090926] spawn BIS_fnc_dynamicText;
			uiNamespace setVariable ["VMF_spawnVehicle_dynamicText",_dynamicText];
			uiNamespace setVariable ["VMF_spawnVehicle_messageType",_messageType];

			{
				if (_forEachIndex < 12) then {
					_x params [
						"_startPos",
						"_endPos"
					];
					drawLine3D [_displayVehicle modelToWorldVisual _startPos,_displayVehicle modelToWorldVisual _endPos,[1,0,0,1]];
				};
			} forEach _vehicleBoundaries;
		},
		[
			_displayVehicle,
			_vehicleBoundaries
		]];
		uiNamespace setVariable ["VMF_spawnVehicle_eachFrameEH",_eachFrameEH];
	} else {
		private _currentVehicle = uiNamespace getVariable ["VMF_spawnVehicle_nearVehicle",objNull];

		if !(isNull _currentVehicle) then {
			deleteVehicle _currentVehicle;
		};

		private _spawnDir = getDir _spawnPos;
		_spawnPos = getPos _spawnPos;
		

		private _vehicleData = uiNamespace getVariable "VMF_spawnVehicle_selectedVehicle";
		[
			_spawnPos,
			_spawnDir,
			_vehicleData
		] remoteExec ["VMF_fnc_spawnVehicle",2];
	};

	private _display = uiNamespace getVariable ["VMF_spawnVehicle_display",displayNull];
    _display closeDisplay 1;
}];

private _closeButton = uiNamespace getVariable ["VMF_spawnVehicle_closeButton",controlNull];
private _closeButtonEH = _closeButton ctrlAddEventHandler ["buttonClick",{
    private _display = uiNamespace getVariable ["VMF_spawnVehicle_display",displayNull];
    _display closeDisplay 2;
}];

_vehicleList lbSetCurSel 0;
