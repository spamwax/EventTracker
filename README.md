## Continuation of EventTracker from [CurseForge](https://www.curseforge.com/wow/addons/eventtracker)

Event Tracker allows you to view detailed information such as argument information of tracked events/functions as well as what frames are monitoring specific event.
For functions tracked it will also provide information on the time spent on execution functions (on a call per call base as well as the total execution time).

To tell Event Tracker which standard WoW events to track for now you need to update the file `EventTracker_events.lua` yourself:

```lua
-- Events to be tracked
    ET_TRACKED_EVENTS = {
        "CHAT_MSG_GUILD",
        "PLAYERREAGENTBANKSLOTS_CHANGED",
    };

-- Events to be ignored (applied when using /registerall)
    ET_IGNORED_EVENTS = {
        "BAG_UPDATE_COOLDOWN",
        "ACTIONBAR_UPDATE_COOLDOWN",
        "SPELL_UPDATE_COOLDOWN",
        "CURSOR_UPDATE",
        "CRITERIA_UPDATE",
        "UPDATE_MOUSEOVER_UNIT",
    };
```