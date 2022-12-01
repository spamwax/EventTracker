--[[ =================================================================
    Description:
        All strings (English) used by EventTracker.
    ================================================================= --]]

-- Frame Strings
    ET_PURGE_BUTTON = "Purge";
    ET_CLOSE_BUTTON = "Close";
    ET_STATE_ON = "On";
    ET_STATE_OFF = "Off";
    ET_TRACKING = "Tracking is "..C_YELLOW.."%s"..C_CLOSE;
    ET_STATE_ONOFF = ET_STATE_ON.." / "..ET_STATE_OFF;
    ET_EVENT_COUNT = "Events/Functions:  "..C_BLUE.."%d"..C_CLOSE;
    ET_EVENTS_TRACKED = "Events/Functions tracked:  "..C_BLUE.."%d"..C_CLOSE;
    ET_MEMORY = "Memory:  "..C_BLUE.."%.2f KB"..C_CLOSE;
    ET_ARGUMENTS_TEXT = "Arguments";
    ET_REGISTERED_TEXT = "Registered by";
    ET_CALLSTACK_TEXT = "Call Stack";
    ET_UNNAMED_FRAME = "< "..C_RED.."Unnamed frame"..C_CLOSE.." >";
    ET_REMOVED = "Event "..C_YELLOW.."%s"..C_CLOSE.." has been removed"
    ET_SHOW_DETAILS = "Show details >>";
    ET_HIDE_DETAILS = "Hide details <<";
    ET_TIME_CURRENT = "Time (current) : "..C_BLUE.."%.2f ms"..C_CLOSE;
    ET_TIME_TOTAL = "Time (total) : "..C_BLUE.."%.2f ms"..C_CLOSE;

-- Binding strings
    BINDING_HEADER_ET = "EventTracker Bindings";
    BINDING_NAME_TOGGLEET = "Toggle EventTracker";

    -- Help information
    ET_HELP = { "EventTracker commands:",
                "    /et : open/close EventTracker dialog",
                "    /et { help | ? }: Show this list of commands",
                "    /et |cFF8EA1E7add|r <event>: Add event to be tracked",
                "    /et |cFF8EA1E7remove|r <event>: Remove event from tracking",
                "    /et |cFF8EA1E7registerall|r : Register all events regardless of your settings in |cff11ee11ET_TRACKED_EVENTS|r and |cffff22ffET_IGNORED_EVENTS|r (# of events not known)",
                "    /et |cFF8EA1E7unregisterall|r : Unregister all events to be tracked (except for VARIABLES_LOADED)",
                "    /et |cFF8EA1E7resetpos|r : Reset position of the main EventTracker frame",
                "    /et |cFF8EA1E7filter|r <substring>: Adds a filter to showed events (substring search, no regexp) - Requires registerall to be active",
                "    /et |cFF8EA1E7removefilter|r: Remove filter",
              };