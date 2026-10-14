/*
Author:
    Solskii

Description:
    Generic VMF inventory swap configuration. Equip named template units with
    any desired equipment, or replace their source names with full loadout arrays.

Execution:
    Every machine; CfgFunctions preInit = 1.

Configuration:
    Kits: [role key, template unit variable name OR getUnitLoadout array, display name].
    Roles: [lowercase player slot description, role key]. @group suffixes are ignored.
    Keep default role mapped to a configured kit. Edit examples for your mission.
---------------------------------------------------------------------------- */
missionNamespace setVariable ["VMF_invSwapKits",[
    ["rifleman", "kit_rifleman", "Rifleman"],
    ["team_leader", "kit_team_leader", "Team Leader"],
    ["squad_leader", "kit_squad_leader", "Squad Leader"],
    ["medic", "kit_medic", "Medic"],
    ["autorifleman", "kit_autorifleman", "Autorifleman"],
    ["assistant", "kit_assistant", "Assistant Autorifleman"],
    ["antitank", "kit_antitank", "AT Rifleman"],
    ["radioman", "kit_radioman", "Radio Operator"]
]];

missionNamespace setVariable ["VMF_invSwapRoles",[
    ["rifleman", "rifleman"],
    ["team leader", "team_leader"], ["ftl", "team_leader"],
    ["squad leader", "squad_leader"], ["sl", "squad_leader"],
    ["medic", "medic"],
    ["autorifleman", "autorifleman"], ["ar", "autorifleman"],
    ["assistant autorifleman", "assistant"], ["aar", "assistant"],
    ["at rifleman", "antitank"],
    ["radio operator", "radioman"], ["radioman", "radioman"]
]];

missionNamespace setVariable ["VMF_invSwapDefaultRole","rifleman"];
