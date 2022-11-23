## Event Tracker

Using this addon you can view detailed information about the **events** that are triggered by the game.

Detailed information such as arguments of the event's payload for the tracked events/functions are displayed. You can also see which frames are monitoring specific events.

You can also track function calls to see time spent during the execution of the function (on a call per call base as well as the total execution time).


You have two options to track  standard WoW events

1. Update the file `EventTracker_events.lua` yourself. The following is an example of how the contents of the file may look like.

```lua
-- Events to be tracked
    ET_TRACKED_EVENTS = {
        "PLAYER_LEVEL_UP",
        "PLAYER_XP_UPDATE",
        "PLAYER_TARGET_CHANGED",
        "UNIT_HEALTH",
    };

-- Events to be ignored (applied when using /et registerall)
    ET_IGNORED_EVENTS = {
        "BAG_UPDATE_COOLDOWN",
        "ACTIONBAR_UPDATE_COOLDOWN",
        "UNIT_POWER_FREQUENT",
    }
```

2. Add an even using the in-game slash command `/et add <event>`. Events added this way will not persist between log-in sessions.


#### Be careful to specify only valid events.

Event Tracker uses the function `GetFramesRegisteredForEvent()`, which will cause WoW to hard crash when it is being called with a non-existing event.

### Slash commands

The following slash commands are available:

| Command                   | Description                                                                                       |
| ------------------------- | ------------------------------------------------------------------------------------------------- |
| `/et open` or `/et close` | Show/hide EventTracker window                                                                     |
| `/et ?` or `/et help`     | Show this list of commands                                                                        |
| `/et add <event>`         | Add event to be tracked                                                                           |
| `/et remove <event>`      | Remove event to be tracked                                                                        |
| `/et registerall`         | Register all events to be tracked (# of events not known)                                         |
| `/et unregisterall`       | Unregister all events to be tracked (except for VARIABLES_LOADED)                                 |
| `/et resetpos`            | Reset position of the main EventTracker frame                                                     |
| `/et filter`              | Adds a filter to showed events (sub-string search, no regexp) - Requires registerall to be active |
| `/et removefilter`        | Remove filter                                                                                     |

### Notice

This project was abandoned since 2016 and I just took over it. My goal is to keep it working under `retail` version.

If you have issues with under clients (such as WOTLK), please submit a PR on [github issues](https://github.com/spamwax/EventTracker).