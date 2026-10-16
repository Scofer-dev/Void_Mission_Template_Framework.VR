/* ----------------------------------------------------------------------------
Function: RGS_fnc_spawnVehicleDialog

Description:
	Creates dialog for Spawn Vehicle Zeus module using ZEN framework.

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
	0: Module Position <Array>

Example:
	[
        [1000,1000,0]
    ] call RGS_fnc_spawnVehicleDialog;
	
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

if (isNull (getAssignedCuratorLogic player)) exitWith {};

params [
    "_spawnPos"
];

if (_spawnPos isEqualTo []) exitWith {
    ["No spawn position passed to RGS_fnc_spawnVehicleDialog"] call BIS_fnc_error;
};

private _actualValues = [];
private _prettyValues = [];

if (RGS_vehiclePoolArray isEqualTo []) exitWith {
    [objNull, "No vehicles have been defined"] call BIS_fnc_showCuratorFeedbackMessage;
};

{
    _actualValues pushBack (_x select 0);
    _prettyValues append [[(_x select 0) + " (" + str(_x select 1) + " Defined)"]];
} forEach RGS_vehiclePoolArray;


[
    "Spawn Vehicle",
    [
        [
            "COMBO",
            "Spawn Pool",
            [
                _actualValues,
                _prettyValues,
                0
            ]
        ],
        [
            "COMBO",
            ["Vehicle Side","Side the vehicle will spawn as"],
            [
                ["WEST","EAST","INDEPENDENT","CIV"],
                [
                    [
                        "BLUFOR",
                        "Vehicle will spawn as BLUFOR",
                        "\a3\3den\data\displays\display3den\panelright\side_west_ca.paa"
                    ],
                    [
                        "OPFOR",
                        "Vehicle will spawn as OPFOR",
                        "\a3\3den\data\displays\display3den\panelright\side_east_ca.paa"
                    ],
                    [
                        "INDFOR",
                        "Vehicle will spawn as INDFOR",
                        "\a3\3den\data\displays\display3den\panelright\side_guer_ca.paa"
                    ],
                    [
                        "Civilian",
                        "Vehicle will spawn as Civilian",
                        "\a3\3den\data\displays\display3den\panelright\side_civ_ca.paa"
                    ]
                ]
            ],
            false
        ],
        [
            "CHECKBOX",
            ["Separate Passengers","Seperate passengers into their own group"],
            true
        ]
    ],
    {
        _this select 0 params [
            "_poolName",
            "_side",
            "_separatePassengers"
        ];

        switch _side do {
            case "WEST": {_side = WEST};
            case "EAST": {_side = EAST};
            case "INDEPENDENT": {_side = INDEPENDENT};
            case "CIV": {_side = CIVILIAN};
        };

        private _spawnPos = (_this select 1) select 0;
        
        [_poolName,_side,_separatePassengers,_spawnPos] call RGS_fnc_spawnVehicle;
    },
    {},
    [_spawnPos]
] call zen_dialog_fnc_create;