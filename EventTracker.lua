--[[ =================================================================
    Description:
        EventTracker is a simple AddOn that informs, by means of a
        chat message, when specific events are triggered within the
        game.

        The main purpose is to determine which events get triggered
        at what stage, to ultimately get a better understanding about
        the internals of the game, and hopefully help out in identifying
        why certain things happen or things might be failing all together.

        Update the file EventTracker_events.lua to specify which events
        need to be tracked.

    Dependencies:
        None

    Credits:
        A big 'Thank You' to all the people at Blizzard Entertainment
        for making World of Warcraft.
    ================================================================= --]]

-- local variables
    local ET_FILTER = nil;

-- Local table functions
    local tinsert, wipe = table.insert, table.wipe;
    local lower, upper, substr = string.lower, string.upper, string.sub;

-- Function to create array of return values
    function pack(...)
        return arg;
    end

-- Send message to the default chat frame
    function EventTracker_Message( msg, prefix )
        -- Initialize
        local prefixText = "";

        -- Add application prefix
        if ( prefix and true ) then
            prefixText = C_GREEN..ET_NAME..": "..C_CLOSE;
        end;

        -- Send message to chatframe
        DEFAULT_CHAT_FRAME:AddMessage( prefixText..( msg or "" ) );
    end;

-- Handle EventTracker initialization
    function EventTracker_Init()
        -- Initiliaze all parts of the saved variable
        if ( not ET_Data ) then ET_Data = {}; end;
        if ( not ET_Data["active"] ) then ET_Data["active"] = true; end;
        if ( not ET_Data["events"] ) then ET_Data["events"] = {}; end;

        -- Register slash commands
        SlashCmdList["EVENTTRACKER"] = EventTracker_SlashHandler;
        SLASH_EVENTTRACKER1 = "/et";
        SLASH_EVENTTRACKER2 = "/eventtracker";
    end;

-- Register events
    function EventTracker_RegisterEvents( self )
        -- Always track VARIABLES_LOADED
        self:RegisterEvent( "VARIABLES_LOADED" );

        -- Track other events
        for _, value in pairs( ET_TRACKED_EVENTS ) do
            self:RegisterEvent( strtrim( upper( value ) ) );
        end;
    end;

-- Remove the events listed to be ignored
    function EventTracker_RemoveIgnoredEvents()
        -- Track other events
        for _, value in pairs( ET_IGNORED_EVENTS ) do
            EventTracker:UnregisterEvent( strtrim( upper( value ) ) );
        end;
    end;

-- Handle startup of the addon
    function EventTracker_OnLoad( self )
        -- Show startup message
        EventTracker_Message( ET_STARTUP_MESSAGE, false );

        -- Register events to be monitored
        EventTracker_RegisterEvents( self );
    end;

-- Show or hide the Main dialog
    function EventTracker_Toggle_Main()
        if(  EventTrackerFrame:IsVisible() ) then
            EventTrackerFrame:Hide();
        else
            -- Show the frame
            EventTrackerFrame:Show();
            EventTrackerFrame:SetBackdropColor( 0, 0, 0, 1 );

            -- Update the UI
            EventTracker_UpdateUI();
        end;
    end;

-- Show or hide the event detail dialog
    function EventTracker_Toggle_Details()
        if( EventDetailFrame:IsVisible() ) then
            EventDetailFrame:Hide();
            ExpandCollapseButton:SetText( ET_SHOW_DETAILS );
        else
            -- Show the frame
            EventDetailFrame:Show();
            EventDetailFrame:SetBackdropColor( 0, 0, 0, 1 );
            ExpandCollapseButton:SetText( ET_HIDE_DETAILS );
        end;
    end;

    -- local kbDEBUG = true
    -- local function ViragPrint(strName, tData, x)
    --     local f = select(2, IsAddOnLoaded("ViragDevTool"))
    --     print("IsAddOnLoaded", f)
    --     if ViragDevTool.AddData and kbDEBUG then
    --       ViragDevTool:AddData(tData, strName)
    --     end
    -- end
-- Mixin for frames list items
    EventFrames_ScrollableListItemMixin = {}
    function EventFrames_ScrollableListItemMixin:Init(elementData)
        self.FrameName:SetText(elementData.frameName)
    end

-- Mixin for event's arguments items
    EventArguments_ScrollableListItemMixin = {}
    function EventArguments_ScrollableListItemMixin:Init(elementData)
        --DevTools_Dump(elementData)
        self.Argument:SetText(elementData.argName)
        self.ArgumentValue:SetText(elementData.argData)
    end


-- Mixin for scrollable list frame
    EventTracker_ScrollableListMixin = {}
    function EventTracker_ScrollableListMixin:OnLoad()
        self.DataProvider = CreateDataProvider();
        local elementExtent = 16;
        self.ScrollView = CreateScrollBoxListLinearView();
        self.ScrollView:SetDataProvider(self.DataProvider);
        self.ScrollView:SetElementExtent(elementExtent);

        -- DevTools_Dump(self.itemTemplate)
        local listItem = self.itemTemplate
        if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then
            self.ScrollView:SetElementInitializer(listItem, function(frame, elementData)
                frame:Init(elementData)
            end);
        else
            self.ScrollView:SetElementInitializer("Frame", listItem, function(frame, elementData)
                frame:Init(elementData)
            end);
        end

        local padding = 5
        local paddingT = padding+5;
        local paddingB = padding+5;
        local paddingL = padding;
        local paddingR = padding;
        local spacing = 1;

        -- The below call is required to hook everything up automatically.
        ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
        self.ScrollBox:SetPadding(paddingT, paddingB, paddingL, paddingR, spacing);

        self.ScrollBox:SetClipsChildren(true)

        local anchorsWithBar = {
            CreateAnchor("TOPLEFT", self, "TOPLEFT", 4, -4),
            CreateAnchor("BOTTOMRIGHT", self.ScrollBar, "BOTTOMLEFT", 0, 4),
        };

        local anchorsWithoutBar = {
            CreateAnchor("TOPLEFT", self, "TOPLEFT", 4, -4),
            CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 4),
        };
        ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, anchorsWithBar, anchorsWithoutBar);
    end

    function EventTracker_ScrollableListMixin:AppendListItem(elementData)
        self.DataProvider:Insert(elementData)
        self.ScrollBox:ScrollToBegin(ScrollBoxConstants.NoScrollInterpolation);
    end

    function EventTracker_ScrollableListMixin:Clear()
        self.DataProvider:Flush()
    end

-- Purge data for specific event
    function EventTracker_PurgeEvent( purgeEvent )
        -- Purge highlevel event info
        ET_Events[purgeEvent].count = 0;

        -- Purge event details
        local length = #ET_EventDetail;

        -- Redraw items
        for index = length, 1, -1 do
            --local event, timestamp, data, realevent, time_usage, call_stack = unpack( ET_EventDetail[index] );
            local event = unpack( ET_EventDetail[index] );
            if ( event == purgeEvent ) then
                tremove( ET_EventDetail, index );
            end;
        end;

        -- Update UI elements
        EventCallStack:SetText( "" );
        EventTracker_Scroll_Details();
        -- Hide the detail window if already showing
        if ( EventDetailFrame:IsVisible() ) then
            EventTracker_Toggle_Details();
        end;
        EventTracker_Scroll_Frames();
        EventTracker_UpdateUI();
    end;

-- Purge event data
    function EventTracker_Purge()
        -- Clear out old data
        wipe( ET_Events );
        wipe( ET_EventDetail );
        wipe( ET_ArgumentInfo );
        wipe( ET_FrameInfo );
        ET_CurrentEvent = nil;

        -- Update UI elements
        EventCallStack:SetText( "" );
        EventTracker_Scroll_Details();
        -- Hide the detail window if already showing
        if ( EventDetailFrame:IsVisible() ) then
            EventTracker_Toggle_Details();
        end;
        EventTracker_Scroll_Frames();
        EventTracker_UpdateUI();
    end;

-- Add data to the tracking stack (for internal usage)
    local function EventTracker_AddInfo( event, data, realevent, time_usage, call_stack )
        -- Track details
        if (not ET_Events[event] ) then
            ET_Events[event] = {};
        end;
        ET_Events[event].count = ( ET_Events[event].count or 0 ) + 1;
        if ( time_usage ) then
            ET_Events[event].time = ( ET_Events[event].time or 0 ) + time_usage;
        end;

        if (event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "COMBAT_LOG_EVENT") then
            data = { CombatLogGetCurrentEventInfo() }
            --@debug@
            --DevTools_Dump(data)
            --@end-debug@
        end

        tinsert( ET_EventDetail, { event, time(), data, realevent, time_usage, call_stack } );

        -- Update frame
        if(  EventTrackerFrame:IsVisible() ) then
            EventTracker_Scroll_Details();
            EventTracker_UpdateUI();
        end;
    end;

-- Add data to the tracking stack (for external usage)
    function EventTracker_TrackProc( procname, arginfo )
        -- Store original function
        ET_ProcList[procname] = _G[procname];

        -- Add argument information if provided
        if ( arginfo ) then
            ET_Static[procname] = arginfo;
        end;

        -- Define replacement function (includes timing information)
        _G[procname] = function( ... )
            local start = debugprofilestop();
            local retval = { ET_ProcList[procname]( ... ) };
            local usage = debugprofilestop() - start;
            local call_stack = debugstack( 2 );
            EventTracker_AddInfo( procname, { ... }, false, usage, call_stack );
            if ( retval ) then return unpack( retval ); end;
        end;
    end;

-- Handle events sent to the addon
    function EventTracker_OnEvent( self, event, ... )
        local logEvent = true;

        if ( event == "VARIABLES_LOADED" ) then
            EventTracker_Init();
        end;

        -- Store event data
        if ( ET_Data["active"] ) then
            if ET_FILTER then
                -- Prevent event from being logged when it does not match the filter
                if not event:find( ET_FILTER, 1, true ) then
                    logEvent = false;
                end;

                -- But be sure to include it when it appears within ET_TRACKED_EVENTS
                if tContains( ET_TRACKED_EVENTS, event ) then
                    logEvent = true;
                end;
            end;

            if ( logEvent ) then
                EventTracker_AddInfo( event, { ... }, true );
            end;
        end;
     end;

-- Build strings for argument names and data (incl proper colors and nil handling)
    function EventTracker_GetStrings( event, index, value )
        local argName, argData;

        if ( ET_Static[event] ) then
            argName = ( ET_Static[event][index] or ET_UNKNOWN );
        else
            argName = index;
        end;

        argData = tostring( value == nil and ET_NIL or tostring(value) );

        return C_BLUE..argName..C_CLOSE, C_YELLOW..argData..C_CLOSE;
    end;

-- Scrool callback for mouse wheel
    function EventTracker_WheelScroll(frame, delta)
        local scrolller = _G["EventTracker_Details"]
        local n = scrolller:GetVerticalScroll() - (delta*15) -- Change multiplication factor to change scroll speed
        if n < 0 then
            n = 0
        elseif n > scrolller:GetVerticalScrollRange() then
            n = scrolller:GetVerticalScrollRange()
        end
        scrolller:SetVerticalScroll(n)
        n = math.floor((n / 30) + 0.5)
        FauxScrollFrame_SetOffset(EventTracker_Details, n)
        EventTracker_Scroll_Details()
    end

-- Scroll function for event details
    function EventTracker_Scroll_Details()
        local length = #ET_EventDetail;
        local index, button, argInfo;
        local offset
        local argName, argData;

        offset = FauxScrollFrame_GetOffset( EventTracker_Details );
        -- Update scrollbars
        FauxScrollFrame_Update( EventTracker_Details, length+1, ET_DETAILS, 30 );

        -- Redraw items
        for line = 1, ET_DETAILS, 1 do
            index = offset + line;
            button = _G["EventItem"..line];
            button:SetID( line );
            button:SetAttribute( "index", index );
            if index <= length then
                local event, timestamp, data, _, _, _ = unpack( ET_EventDetail[index] );
                _G["EventItem"..line.."InfoEvent"]:SetText( event );
                _G["EventItem"..line.."InfoTimestamp"]:SetText( date( "%Y-%m-%d %H:%M:%S", timestamp ) );
                argInfo = "";

                local coloredString
                if not ET_EventDetail[index].coloredString then
                    for key, value in pairs( data ) do
                        argName, argData = EventTracker_GetStrings( event, key, value );
                        argInfo = argInfo..","..argName.."="..argData;
                    end;
                    coloredString = substr(argInfo, 2)
                    ET_EventDetail[index].coloredString = coloredString
                else
                    coloredString = ET_EventDetail[index].coloredString
                end
                _G["EventItem"..line.."InfoData"]:SetText(coloredString);
                button:Show();
                button:Enable();
            else
                button:Hide();
            end;
        end;
    end;

-- Scroll function for event arguments
    function EventTracker_Scroll_Arguments()
        local argName, argData;

        local maxIdx = 0
        for k, _ in pairs(ET_ArgumentInfo) do
            if k > maxIdx then maxIdx = k end
        end
        --for index, v in pairs(ET_ArgumentInfo) do
        for index = 1, maxIdx, 1 do
            argName, argData = EventTracker_GetStrings(ET_CurrentEvent, index, ET_ArgumentInfo[index])
            _G["Event_Argument_Frame"].EventArgumentsListFrame:AppendListItem({argName=argName, argData=argData})
        end
    end;

    function EventTracker_Scroll_Frames()
        for _, v in pairs(ET_FrameInfo) do
            _G["Event_Frame_Frame"].EventFramesListFrame:AppendListItem({frameName = v:GetName() or ET_UNNAMED_FRAME})
        end
    end

-- Update the UI
    function EventTracker_UpdateUI( currenttime )
        -- Number of events caught
        _G["EventCount"]:SetText( ET_EVENT_COUNT:format( #ET_EventDetail ) );

        -- Number of events that are being tracked
        _G["EventsTracked"]:SetText( ET_EVENTS_TRACKED:format( #ET_TRACKED_EVENTS ) );

        -- Memory usage
        _G["EventMemory"]:SetText( ET_MEMORY:format( GetAddOnMemoryUsage( "EventTracker" ) ) );

        -- Update tracking state
        _G["TrackingState"]:SetText( ET_TRACKING:format( lower( gsub( gsub( tostring( ET_Data["active"] ), "true", ET_STATE_ON ), "false", ET_STATE_OFF ) ) ) );

        -- Update current event for details
        if ( ET_CurrentEvent ) then
            _G["CurrentEventName"]:SetText( ET_CurrentEvent.." ["..ET_Events[ET_CurrentEvent].count.."]" );
            _G["EventTimeCurrent"]:SetText( ET_TIME_CURRENT:format( currenttime or 0 ) );
            _G["EventTimeTotal"]:SetText( ET_TIME_TOTAL:format( ET_Events[ET_CurrentEvent].time or 0 ) );
        else
            _G["CurrentEventName"]:SetText( ET_UNKNOWN );
            _G["EventTimeCurrent"]:SetText( ET_TIME_CURRENT:format( 0 ) );
            _G["EventTimeTotal"]:SetText( ET_TIME_TOTAL:format( 0 ) );
        end;
    end;

-- Toggle tracking
    function EventTracker_Toggle()
        ET_Data["active"] = not ET_Data["active"];
        EventTracker_UpdateUI();
    end;

-- Handle click on event item
    function EventTracker_EventOnClick( self, button, down )
        local event, _, data, realevent, time_usage, call_stack = unpack( ET_EventDetail[ FauxScrollFrame_GetOffset( EventTracker_Details ) + self:GetID() ] );

        if ( IsShiftKeyDown() ) then
            EventTracker:UnregisterEvent( event );
            EventTracker_PurgeEvent( event );
            DEFAULT_CHAT_FRAME:AddMessage( ET_REMOVED:format(event) );
        else
            if ( button == "LeftButton" ) then
                if ( realevent ) then
                    ET_FrameInfo = { GetFramesRegisteredForEvent( event ) };
                    Event_Frame_FrameHeading:SetText( ET_REGISTERED_TEXT );
                    EventCallStack:SetText( "" );
                else
                    wipe( ET_FrameInfo );
                    Event_Frame_FrameHeading:SetText( ET_CALLSTACK_TEXT );
                    EventCallStack:SetText( call_stack );
                end;
                _G["Event_Argument_Frame"].EventArgumentsListFrame:Clear()
                _G["Event_Frame_Frame"].EventFramesListFrame:Clear()
                ET_ArgumentInfo = data;
                ET_CurrentEvent = event;
                EventTracker_Scroll_Arguments();
                EventTracker_Scroll_Frames();
                EventTracker_UpdateUI( time_usage );

                -- Show the detail window if not already showing
                if ( not EventDetailFrame:IsVisible() ) then
                    EventTracker_Toggle_Details();
                end;
            end;
        end;
    end;

-- Show help message
    function EventTracker_ShowHelp()
        for _, value in pairs( ET_HELP ) do
            EventTracker_Message( value );
        end;
    end;

-- Handle slash commands
    function EventTracker_SlashHandler( msg, editbox )
        -- arguments should be handled case-insensitve
        local command, event = strsplit( " ", msg );

        command = strlower( command or "" );
        event = strtrim( strupper( event or "" ) );

        -- Handle each individual argument
        if ( command == "" ) then
            -- Show main dialog
            EventTracker_Toggle_Main();

        elseif ( command == "resetpos" ) then
            EventTrackerFrame:ClearAllPoints();
            EventTrackerFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);

        elseif ( command == "add" ) then
            -- Add event to be tracked
            EventTracker:RegisterEvent( event );

        elseif ( command == "remove" ) then
            -- Remove event to be tracked
            EventTracker:UnregisterEvent( event );

        elseif ( command == "registerall" ) then
            -- Track all events
            EventTracker:RegisterAllEvents();
            EventTracker_RemoveIgnoredEvents();

        elseif ( command == "unregisterall" ) then
            -- Track all events
            EventTracker:UnregisterAllEvents();
            EventTracker:RegisterEvent( "VARIABLES_LOADED" );

        elseif ( command == "filter" ) then
            -- Set filter to be applied to registerall events
            ET_FILTER = event;

        elseif ( command == "removefilter" ) then
            -- Remove the filter
            ET_FILTER = nil;

        elseif ( msg == "help" ) or ( msg == "?" ) then
            -- Show help info
            EventTracker_ShowHelp();
        end;
    end;