--[[ =================================================================
    Description:
        Use this file to specify which events need to be tracked.
    ================================================================= --]]

-- Events to be tracked
ET_TRACKED_EVENTS = {
    "PLAYER_STARTED_MOVING",
    "PLAYER_XP_UPDATE",
    -- "UPDATE_MOUSEOVER_UNIT",
    -- "CHAT_MSG_GUILD",
    -- "PLAYERREAGENTBANKSLOTS_CHANGED",
    --@debug@
    "COMBAT_LOG_EVENT_UNFILTERED",
    "CHAT_MSG_COMBAT_XP_GAIN",
    "UNIT_COMBAT",
    --@end-debug@
}

-- Events to be ignored (applied when using /registerall)
ET_IGNORED_EVENTS = {
    "BAG_UPDATE_COOLDOWN",
    "ACTIONBAR_UPDATE_COOLDOWN",
    "SPELL_UPDATE_COOLDOWN",
    "CRITERIA_UPDATE",
    --@debug@
    "UPDATE_MOUSEOVER_UNIT",
    "WORLD_CURSOR_TOOLTIP_UPDATE",
    "CURSOR_CHANGED",
    "PLAYER_STARTED_TURNING",
    "PLAYER_STOPPED_TURNING",
    "MODIFIER_STATE_CHANGED",
    "SPELL_ACTIVATION_OVERLAY_HIDE",
    "SPELL_UPDATE_USABLE",
    "GLOBAL_MOUSE_DOWN",
    "GLOBAL_MOUSE_UP",
    "UNIT_POWER_UPDATE",
    "UNIT_POWER_FREQUENT",
    --@end-debug@
}
