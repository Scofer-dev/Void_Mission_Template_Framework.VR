/* ----------------------------------------------------------------------------
Function: RGS_fnc_spawnGroupDialog

Description:
	Creates dialog for Spawn Group Zeus module using ZEN framework.

Execution:
	- Client: Yes
	- Server: No
	- Global: No

Parameters:
	0: Module Position <Array>

Example:
	[
        [1000,1000,0]
    ] call RGS_fnc_spawnGroupDialog;
	
Returns:
    Nothing

Author:
    Scofer
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

if (isNull (getAssignedCuratorLogic player)) exitWith {};

params [
    ["_spawnPos",[],[[]]]
];

if (_spawnPos isEqualTo []) exitWith {
    ["No spawn position passed to RGS_fnc_spawnGroupDialog"] call BIS_fnc_error;
};

private _actualValues = [];
private _prettyValues = [];

if (RGS_groupPoolArray isEqualTo []) exitWith {
    [objNull, "No groups have been defined"] call BIS_fnc_showCuratorFeedbackMessage;
};

{
    _actualValues pushBack (_x select 0);
    _prettyValues append [[(_x select 0) + " (" + str(_x select 1) + " Defined)"]];
} forEach RGS_groupPoolArray;

[
    "Spawn Group",
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
            ["Group Side","Side the group will spawn as"],
            [
                ["WEST","EAST","INDEPENDENT","CIV"],
                [
                    [
                        "BLUFOR",
                        "Group will spawn as BLUFOR",
                        "\a3\3den\data\displays\display3den\panelright\side_west_ca.paa"
                    ],
                    [
                        "OPFOR",
                        "Group will spawn as OPFOR",
                        "\a3\3den\data\displays\display3den\panelright\side_east_ca.paa"
                    ],
                    [
                        "INDFOR",
                        "Group will spawn as INDFOR",
                        "\a3\3den\data\displays\display3den\panelright\side_guer_ca.paa"
                    ],
                    [
                        "Civilian",
                        "Group will spawn as Civilian",
                        "\a3\3den\data\displays\display3den\panelright\side_civ_ca.paa"
                    ]
                ]
            ],
            false
        ]
    ],
    {
        _this select 0 params [
            "_poolName",
            "_side"
        ];

        switch _side do {
            case "WEST": {_side = WEST};
            case "EAST": {_side = EAST};
            case "INDEPENDENT": {_side = INDEPENDENT};
            case "CIV": {_side = CIVILIAN};
        };

        private _spawnPos = (_this select 1) select 0;

        [_poolName,_side,_spawnPos] call RGS_fnc_spawnGroup;
    },
    {},
    [_spawnPos]
] call zen_dialog_fnc_create;