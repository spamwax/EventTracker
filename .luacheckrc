std = "lua51"
max_line_length = false
exclude_files = {
    "**/libs/**/*.lua",
    "locals",
    ".luacheckrc",
}
ignore = {
    "11./SLASH_.*", -- Setting an undefined (Slash handler) global variable
    "11./BINDING_.*", -- Setting an undefined (Keybinding header) global variable
    "212", -- Unused argument
    "432", -- Shadowing an upvalue argument
    -- "211", -- Unused local variable
    -- "211/L", -- Unused local variable "L"
    -- "211/CL", -- Unused local variable "CL"
    -- "43.", -- Shadowing an upvalue, an upvalue argument, an upvalue loop variable.
    -- "431", -- shadowing upvalue
    -- "542", -- An empty if branch
}
globals = {
    "std",
    "max_line_length",
    "exclude_files",
    "ignore",
    "globals",
    -- Lua
    "bit.band",
    "bit",
    "ceil",
    "date",
    "string.split",
    "table.wipe",
    "table.foreach",
    "time",
    "wipe",
    "pack",

    -- Utility functions
    "geterrorhandler",
    "fastrandom",
    "format",
    "strjoin",
    "strtrim",
    "strsplit",
    "strmatch",
    "strupper",
    "strlower",
    "strlen",
    "strsub",
    "tContains",
    "tDeleteItem",
    "tIndexOf",
    "tinsert",
    "tostringall",
    "tremove",
    "gsub",
    "DevTools_Dump",
    "GetAddOnMetadata",
    "GetAddOnMemoryUsage",
    "debugprofilestop",
    "debugstack",

    -- WoW
    "C_Timer",
    "C_AddOns",
    "ALL",
    "ACCEPT",
    "ALWAYS",
    "UNKNOWN",
    "BNET_CLIENT_WOW",
    "BOSS",
    "BOSSES_KILLED",
    "SKILL_RANK_UP",
    "MELEE_ATTACK",
    "CANCEL",
    "CHALLENGE_MODE",
    "DEFAULT_CHAT_FRAME",
    "CLOSE",
    "COMBATLOG_OBJECT_AFFILIATION_MINE",
    "COMBATLOG_FILTER_HOSTILE_PLAYERS",
    "COMBATLOG_FILTER_HOSTILE_UNITS",
    "COMBATLOG_FILTER_MY_PET",
    "COMBATLOG_FILTER_MINE",
    "COMBATLOG_OBJECT_NONE",
    "CombatLog_Object_IsA",
    "Blizzard_CombatLog_Filters",
    "CombatLogGetCurrentEventInfo",
    "SetPortraitTexture",
    "REFLECT",
    "SPELL_SCHOOL0_CAP",
    "SPELL_SCHOOL1_CAP",
    "SPELL_SCHOOL2_CAP",
    "SPELL_SCHOOL3_CAP",
    "SPELL_SCHOOL3_CAP",
    "SPELL_SCHOOL4_CAP",
    "SPELL_SCHOOL5_CAP",
    "SPELL_SCHOOL6_CAP",
    "ALTERNATE_RESOURCE_TEXT",
    "MAELSTROM_POWER",
    "CHI_POWER",
    "ARCANE_CHARGES_POWER",
    "INSANITY_POWER",
    "HOLY_POWER",
    "RUNIC_POWER",
    "LUNAR_POWER",
    "SHARDS",
    "FURY",
    "PAIN",
    "MANA",
    "RAGE",
    "FOCUS",
    "COMBO_POINTS",
    "RUNES",
    "ENERGY",
    "Enum",
    "HONOR",
    "XP",
    "CombatLog_OnEvent",
    "IsShiftKeyDown",
    "IsControlKeyDown",

    "BackdropTemplateMixin",
    "SelectionBehaviorMixin",
    "SelectionBehaviorFlags",
    "UIParent",
    "GetTime",
    "GetLocale",
    "UnitName",
    "UnitXP",
    "UnitXPMax",
    "UnitLevel",
    "InCombatLockdown",
    "PlaySound",
    "CreateFrame",
    "ChatFontNormal",
    "GameFontHighlightNormal",
    "ChatEdit_ActivateChat",
    "ChatEdit_ChooseBoxForSend",
    "AceGUIMultiLineEditBoxInsertLink",
    "GetSpellInfo",
    "IsSpellKnown",
    "GetCurrentCombatTextEventInfo",
    "IsAddOnLoaded",
    "hooksecurefunc",
    "SlashCmdList",

    -- Ace3
    "LibStub",
    -- EavesDrop
    "EavesDrop",
    "EavesDropFrame",
    "EavesDropFrameDownButton",
    "EavesDropFrameUpButton",
    "EavesDropHistoryFrame",
    "EavesDropHistoryButton",
    "EavesDropFramePlayerText",
    "EavesDropFrameTargetText",
    "EavesDropStatsDB",
    "EavesDropTab",
    "EavesDropTopBar",
    "EavesDropBottomBar",
    "EavesDropFontNormal",
    "EavesDropFontNormalSmall",
    "EavesDropHistoryTopBar",
    "EavesDropHistoryBottomBar",
    "EavesDropHistoryFrameOutgoingHit",
    "EavesDropHistoryFrameOutgoingHeal",
    "EavesDropHistoryFrameIncomingHit",
    "EavesDropHistoryFrameIncomingHeal",
    "EavesDropHistoryFrameSkillText",
    "EavesDropHistoryFrameAmountCritText",
    "EavesDropHistoryFrameAmountNormalText",
    "EavesDropHistoryFrameResetText",
    "FauxScrollFrame_Update",
    "FauxScrollFrame_SetOffset",
    "EavesDropHistoryScrollBar",
    "FauxScrollFrame_GetOffset",
    "InterfaceOptionsFrame_OpenToCategory",
    "EventTracker_Message",
    "EventTracker",
    "EventTracker_OnLoad",
    "C_GREEN",
    "C_BLUE",
    "C_YELLOW",
    "C_RED",
    "C_CLOSE",
    "ET_NAME",
    "ET_VERSION",
    "ET_NAME_VERSION",
    "ET_STARTUP_MESSAGE",
    "ET_NIL",
    "ET_UNKNOWN",
    "ET_HELP",
    "ET_TRACKED_EVENTS",
    "ET_IGNORED_EVENTS",
    "EventTrackerFrame",
    "EventDetailFrame",
    "ExpandCollapseButton",
    "ET_SHOW_DETAILS",
    "ET_HIDE_DETAILS",
    "EventTracker_TrackProc",
    "EventTracker_Init",
    "EventTracker_ShowHelp",
    "EventTracker_Details",
    "EventTracker_GetStrings",
    "EventTracker_Arguments",
    "EventTracker_Frames",
    "EventCallStack",
    "EventTracker_SlashHandler",
    "EventTracker_RegisterEvents",
    "EventTracker_RemoveIgnoredEvents",
    "EventTracker_Toggle_Main",
    "EventTracker_Toggle_Details",
    "EventTracker_UpdateUI",
    "EventTracker_PurgeEvent",
    "EventTracker_Scroll_Details",
    "EventTracker_Scroll_Arguments",
    "EventTracker_Scroll_Frames",
    "EventTrackerFrame_EventsScrollFrame",
    "Event_Frame_Frame",
    "Event_Argument_Frame",
    "EventTracker_Purge",
    "EventTracker_OnEvent",
    "EventTracker_WheelScroll",
    "ET_STATE_OFF",
    "EventTracker_Toggle",
    "EventTracker_EventOnClick",
    "GetFramesRegisteredForEvent",
    "Event_Frame_FrameHeading",
    "ET_PURGE_BUTTON",
    "ET_CLOSE_BUTTON",
    "ET_STATE_ONOFF",
    "ET_ARGUMENTS_TEXT",

    "EventDetails_ScrollableListItemMixin",
    "EventArguments_ScrollableListItemMixin",
    "EventFrames_ScrollableListItemMixin",
    "EventArguments_ScrollableListMixin",
    "EventTracker_ScrollableListMixin",
    "EventCallStack",
    "EventArguments_FrameMixin",
    "ListItemTemplateMixin",
    "CreateDataProvider",
    "CreateScrollBoxListLinearView",
    "CreateAnchor",
    "ScrollUtil",
    "ScrollBoxConstants",

    "ET_UNNAMED_FRAME",
    "ET_EVENT_COUNT",
    "ET_EVENTS_TRACKED",
    "ET_TRACKING",
    "ET_MEMORY",
    "ET_TIME_CURRENT",
    "ET_TIME_TOTAL",
    "ET_STATE_ON",
    "ET_REMOVED",
    "ET_REGISTERED_TEXT",
    "ET_CALLSTACK_TEXT",

    -- Data arrays
    "ET_Events",
    "ET_EventDetail",
    "ET_FrameInfo",
    "ET_ArgumentInfo",
    "ET_CurrentEvent",
    "ET_ProcList",
    "ET_Data",
    "ET_Static",

    -- Scroll frame
    "ET_DETAILS",
    "ET_ARGUMENTS",
    "ET_FRAMES",

    -- Misc
    "ViragPrint",
    "ViragDevTool",
}
