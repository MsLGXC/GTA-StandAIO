-- Scaleforms Lua Lib
-- created by Jackz
-- Requires natives file to be loaded before required
-- Supposedly finds an existing instance and returns its handle

-- If you wish to view example lua scripts for my libs:
-- https://jackz.me/stand/get-lib-zip

local Scaleform = {
    LIB_VERSION = "1.0.0",

    displayTickThreadActive = false,
    displayedInstances = {},
    phone = {}
}
Scaleform.__index = Scaleform

function Scaleform.libVersion()
    return Scaleform.LIB_VERSION
end

-- Shows a loading indicator on the bottom right with whatever text
-- text is required, type is optional
function Scaleform.ShowLoadingIndicator(text, type)
    HUD.BEGIN_TEXT_COMMAND_BUSYSPINNER_ON("STRING")
    HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(text)
    HUD.END_TEXT_COMMAND_BUSYSPINNER_ON(type or 2)
end

-- Stops loading indicator
function Scaleform.EndLoadingIndicator()
    HUD.BUSYSPINNER_OFF()
end

-- I don't actually know if this finds existing ones, or technically creates a new one. But it works the same as :create(). shrug.
function Scaleform:findInstance(sfName)
    if not sfName then
        return error("Scaleform name is required")
    end
    sfName = string.upper(sfName)
    local handle = GRAPHICS.REQUEST_SCALEFORM_MOVIE_INSTANCE(sfName)
    local this = {}
    this.handle = handle
    this.name = sfName
    setmetatable(this, Scaleform)
    return this
end

-- Creates a new scaleform, waits for it to load and returns its instance
function Scaleform:create(sfName)
    if not sfName then
        return error("Scaleform name is required")
    end
    sfName = string.upper(sfName)
    local handle = GRAPHICS.REQUEST_SCALEFORM_MOVIE(sfName)
    while not GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(handle) do
        util.yield()
    end
    local this = {}
    this.handle = handle
    this.name = sfName
    setmetatable(this, Scaleform)
    return this
end

-- Creates a new scaleform for the front end, waits for it to load and returns its instance
function Scaleform:createFrontend(sfName)
    if not sfName then
        return error("Scaleform name is required")
    end
    sfName = string.upper(sfName)
    local handle = GRAPHICS.REQUEST_SCALEFORM_MOVIE_ON_FRONTEND(sfName)
    while not GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(handle) do
        util.yield()
    end
    local this = {}
    this.handle = handle
    this.name = sfName
    setmetatable(this, Scaleform)
    return this
end

-- Creates a new scaleform for the front end header, waits for it to load and returns its instance
function Scaleform:createFrontendHeader(sfName)
    if not sfName then
        return error("Scaleform name is required")
    end
    local handle = GRAPHICS.REQUEST_SCALEFORM_MOVIE_ON_FRONTEND_HEADER(sfName)
    while not GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(handle) do
        util.yield()
    end
    local this = {}
    this.handle = handle
    this.name = sfName
    setmetatable(this, Scaleform)
    return this
end

-- Will cleanup scaleform, needs to be called manually
function Scaleform:destroy()
    self:deactivate()
    GRAPHICS.SET_SCALEFORM_MOVIE_AS_NO_LONGER_NEEDED(self.handle)
    self = nil
end

-- Shortcut to Scaleform.createMethod(), Scaleform.addXXX(), Scaleform.endMethod(). Will automatically parse the correct data types.
-- Example: Scaleform:run("SET_TEXT", title, desc) -- Used in BREAKING_NEWS
function Scaleform:run(methodName, ...)
    Scaleform.startMethod(self, methodName)
    for i, param in ipairs({...}) do
        if type(param) == "string" then
            Scaleform.addString(param)
        elseif type(param) == "boolean" then
            Scaleform.addBool(param)
        elseif type(param) == "number" then
            Scaleform.addInt(param)
        else
            Scaleform.endMethod()
            return error("Invalid parameter type (" .. type(param) .. ") for arg #" .. i + 2)
        end
    end
    Scaleform.endMethod()
end

function Scaleform:displayFullscreen()
    GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(self.handle, 255, 255, 255, 255)
end
function Scaleform:display(x, y, width, height, color)
    GRAPHICS.DRAW_SCALEFORM_MOVIE(self.handle, x, y, width ,height, color.r, color.g, color.b, color.a)
end

function Scaleform:display3D(pos, rot, scale, sharpness)
    if not scale then
        scale = {x = 1.0, y = 1.0, z = 1.0}
    end
    GRAPHICS.DRAW_SCALEFORM_MOVIE_3D(self.handle, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 0.0, sharpness or 1.0, 0.0, scale.x, scale.y, scale.z, 0)
end
function Scaleform:display3DSolid(pos, rot, scale, sharpness)
    if not scale then
        scale = {x = 1.0, y = 1.0, z = 1.0}
    end
    GRAPHICS.DRAW_SCALEFORM_MOVIE_3D_SOLID(self.handle, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 0.0, sharpness or 1.0, 0.0, scale.x, scale.y, scale.z, 0)
end

-- scaleformMask: The scaleform to mask on top of this
function Scaleform:displayFullscreenMasked(scaleformMask, r, g, b, a)
    GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(self.handle, scaleformMask.handle, r or 0, g or 0, b or 0, a or 255)
end

-- Starts the running of a new method input, shared with all other scaleforms. You MUST call Scaleform.endMethod before you can use this again
function Scaleform.startMethod(sf, methodName)
    if Scaleform.activeMethod then error("Call Scaleform.endMethod before starting new method") end
    Scaleform.activeMethod = {
        type = methodName,
        handle = sf.handle
    }
    GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(sf.handle, Scaleform.activeMethod.type)
end

function Scaleform.addString(str)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_PLAYER_NAME_STRING(str)
end
function Scaleform.addBool(bool)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(bool)
end
function Scaleform.addInt(int)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(int)
end
function Scaleform.addFloat(float)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(float)
end
-- Ends the method building and fires the method
function Scaleform.endMethod()
    Scaleform.activeMethod = nil
    GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end
local function _get_return()
    activeMethod = nil
    local returnHandle = GRAPHICS.END_SCALEFORM_MOVIE_METHOD_RETURN_VALUE()
    while not GRAPHICS.IS_SCALEFORM_MOVIE_METHOD_RETURN_VALUE_READY(returnHandle) do
        util.yield()
    end
    return returnHandle
end
-- Same as endMethod but gets the return value if its an int
function Scaleform.endMethodGetInt()
    return GRAPHICS.GET_SCALEFORM_MOVIE_METHOD_RETURN_VALUE_INT(_get_return())
end
-- Same as endMethod but gets the return value if its an bool
function Scaleform.endMethodGetBool()
    return GRAPHICS.END_SCALEFORM_MOVIE_METHOD_RETURN_VALUE_BOOL(_get_return())
end
-- Same as endMethod but gets the return value if its an string
function Scaleform.endMethodGetString()
    return GRAPHICS.END_SCALEFORM_MOVIE_METHOD_RETURN_VALUE_STRING(_get_return())
end

-- Will display automatically for upto given amount of time. 
-- If ms is nil, will run until :deactivate() or Scaleform.clearAllDisplayed() is called
function Scaleform:activate(ms)
    self.duration = ms or -1
    self.active = true
    table.insert(Scaleform.displayedInstances, self)
    -- create new tick handler if not already created
    if not Scaleform.displayTickThreadActive then
        Scaleform.displayTickThreadActive = true
        util.create_tick_handler(function(_)
            local len = 0
            for i, sfInstance in ipairs(Scaleform.displayedInstances) do
                sfInstance:displayFullscreen()
                len = len + 1
                if sfInstance.duration ~= -1 then
                    sfInstance.duration = sfInstance.duration - 10
                    -- util.draw_debug_text(sfInstance.name .. ": " .. sfInstance.duration)
                    if sfInstance.duration <= 0 then
                        sfInstance.active = false
                        table.remove(Scaleform.displayedInstances, i)
                    end
                end
            end
            -- If no more left to display, end this tick handler
            if len == 0 then
                Scaleform.displayTickThreadActive = false
            end
            return Scaleform.displayTickThreadActive
        end)
    end
end

-- Is the scaleform being rendered (automatically)
function Scaleform:isActive()
    return self.isActive
end

-- Stops automatically rendering the scaleform
function Scaleform:deactivate()
    self.isActive = false
    for i, sfInstance in ipairs(Scaleform.displayedInstances) do
        if sfInstance == self then
            table.remove(Scaleform.displayedInstances, i)
            break
        end
    end
end

-- Clears all actively automtically rendered scaleforms
function Scaleform.clearAllDisplayed()
    Scaleform.displayedInstances = {}
    Scaleform.displayTickThreadActive = false -- Kill tick handler
end

-- CALL SECTIONS
-- I have no clue what's the purpose of CALL_ natives as they don't seem to work - use startMethod or runMethod

-- Calls a scaleform function with no arguments
function call_method(--[[ scaleformHandle --]] scaleform, methodName)
    GRAPHICS.CALL_SCALEFORM_MOVIE_METHOD(scaleform, methodName)
end
-- Calls a scaleform function with any given length of numbers
function call_method_with_numbers(--[[ scaleformHandle --]] scaleform, methodName, ...)
    local args = { ... }
    table.insert(args, -1.0)
    native_invoker.begin_call()
    native_invoker.push_arg_int(scaleform)
    for _, num in ipairs({ ... }) do
        native_invoker.push_arg_float(num)
    end
    native_invoker.push_arg_float(-1.0)
    native_invoker.end_call("D0837058AE2E4BEE")
end
-- Calls a scaleform function with strings and numbers. 
-- numbers & strings must be a TABLE ARRAY
function call_method_with_mixed(--[[ scaleformHandle --]] scaleform, methodName, numbers, strings)
    native_invoker.begin_call()
    native_invoker.push_arg_int(scaleform)
    native_invoker.push_arg_string(methodName)
    for _, num in ipairs(numbers) do
        native_invoker.push_arg_float(num)
    end
    native_invoker.push_arg_float(-1.0)
    for _, str in ipairs(strings) do
        native_invoker.push_arg_string(str)
    end
    native_invoker.push_arg_int(0)
    native_invoker.end_call("EF662D8D57E290B1")
end

-- Calls a scaleform function with any given length of strings
function call_method_with_strings(--[[ scaleformHandle --]] scaleform, methodName, ...)
    native_invoker.begin_call()
    native_invoker.push_arg_int(scaleform)
    native_invoker.push_arg_string(methodName)
    for _, str in ipairs({ ... }) do
        native_invoker.push_arg_string(str)
    end
    native_invoker.push_arg_int(0)
    native_invoker.end_call("51BC1ED3CC44E8F7")
end

-- Specific scaleforms (borrowed & modified from https://github.com/unknowndeira/es_extended/blob/master/client/modules/scaleform.lua)

-- Shows a freemode banner on top of screen (ex: Business Battles / Yacht Defense)
-- ms: Amount of milliseconds to display or nil for forever (call Deactivate(returnValue) to stop)
function Scaleform.showFreemodeMessageTop(title, msg, ms)
    local sf = Scaleform:create('MP_BIG_MESSAGE_FREEMODE')
    sf:run("RESET_MOVIE")
    sf:run('SHOW_SHARD_CENTERED_TOP_MP_MESSAGE', title, msg)
    sf:activate(ms)
    return sf
end

-- Shows a freemode banner in middle of screen (ex: WASTED)
-- ms: Amount of milliseconds to display or nil for forever (call Deactivate(returnValue) to stop)
function Scaleform.showFreemodeCenterMessage(title, msg, ms)
    local sf = Scaleform:create('MP_BIG_MESSAGE_FREEMODE')
    sf:run('SHOW_SHARD_WASTED_MP_MESSAGE', title, msg)

    sf:activate(ms)
    return sf
end

-- Shows a weazel news breaking news banner
-- ms: Amount of milliseconds to display or nil for forever (call Deactivate(returnValue) to stop)
function Scaleform.showBreakingNews(title, msg, bottom, ms)
    local sf = Scaleform:create('BREAKING_NEWS')
    sf:run('SET_TEXT', msg, bottom)
    sf:run('SET_SCROLL_TEXT', 0, 0, title)
    sf:run('DISPLAY_SCROLL_TEXT', 0, 0)

    sf:activate(ms)
    return sf
end

-- Creates a breaking news text that can scroll between lines
-- ms: Amount of milliseconds to display or nil for forever (call Deactivate(returnValue) to stop)
-- scrollSpeedMs(optional): How many seconds per switching to the next line
function Scaleform.showBreakingNewsScrolling(title, topLines, bottomLines, ms, scrollSpeedMs)
    local sf = Scaleform:create('BREAKING_NEWS')
    sf:run('SET_TEXT', title, "")
    for i, line in ipairs(topLines) do
        sf:run('SET_SCROLL_TEXT', 0, i-1, line)
    end
    for i, line in ipairs(bottomLines) do
        sf:run('SET_SCROLL_TEXT', 1, i-1, line)
    end
    sf:run('DISPLAY_SCROLL_TEXT', 0, 0)
    sf:run('DISPLAY_SCROLL_TEXT', 1, 0)
    if scrollSpeedMs then
        local topIndex = 0
        local btmIndex = 0
        local topMax = #topLines
        local btmMax = #bottomLines
        util.create_tick_handler(function()
            util.yield(scrollSpeedMs)
            topIndex = topIndex + 1
            btmIndex = btmIndex + 1
            if topIndex == topMax then
                topIndex = 0
            end
            if btmIndex == btmMax then
                btmIndex = 0
            end
            sf:run('DISPLAY_SCROLL_TEXT', 0, topIndex)
            sf:run('DISPLAY_SCROLL_TEXT', 1, btmIndex)
            return sf:isActive()
        end)
    end

    sf:activate(ms)
    return sf
end

-- Shows a hacking message (lester hack screen)
-- ms: Amount of milliseconds to display or nil for forever (call Deactivate(returnValue) to stop)
-- r,g,b: 0-255 RGB value, optional, defaults to 255
function Scaleform.showHackingMessage(title, msg, ms, r, g, b)
    local sf = Scaleform:create('HACKING_MESSAGE')
    sf:run("SET_DISPLAY", 3, title, msg, r or 255, g or 255, b or 255, true)

    sf:activate(ms)
    return sf
end
local function _disable_fallthrough(key)
    PAD.DISABLE_CONTROL_ACTION(2, key)
    util.yield()
    PAD.ENABLE_CONTROL_ACTION(2, key)
end
local CONTROLS={[44]="q",[32]="w",[206]="e",[45]="r",[47]="g",[72]="s",[48]="z",[49]="f",[59]="d",[73]="x",[79]="c",[101]="h",[182]="l",[245]="t",[249]="n",[301]="m",[311]="k",[305]="b",[320]="v",[338]="a"}

local function _get_input()
    if PAD.IS_CONTROL_PRESSED(2, 191) then return -2 -- ENTER key
    elseif PAD.IS_CONTROL_PRESSED(2, 322) then return -3
    elseif PAD.IS_CONTROL_PRESSED(2, 22) then return " " end
    local isShiftPressed = PAD.IS_CONTROL_PRESSED(2, 61)
    -- TODO: Prevent key presses from activating game controls
    for key, char in pairs(CONTROLS) do
        if PAD.IS_DISABLED_CONTROL_JUST_PRESSED(2, key) then
            _disable_fallthrough(key)
            if isShiftPressed then return char:upper()
            else return char end
        end
    end
    return -1
end

-- Shows a textbox, and will return text the player inputs.
-- Warning: Shitty, 'J' doesn't work, expects default keybinds, and will activate anything else that the key does
-- Returns: string (the text they entered), bool (true if input timed out)
-- String will be nil if text box was cancelled
function Scaleform.showTextPrompt(prompt, prefill, multiline, ms)
    local sf = Scaleform:create('TEXT_INPUT_BOX')
    sf:run("CLEANUP")
    sf:run("SET_MULTI_LINE", multiline or false)
    sf:run("SET_TEXT_BOX", 0, prompt, prefill or "")

    local text = ""
    local pointer = 0

    sf:activate(ms)

    while sf:isActive() do
        local char = _get_input()
        if char == -3 then -- ESC was pressed, return nil
            sf:deactivate()
            return nil, false
        elseif char == -2 then -- Enter was pressed, send text
            sf:deactivate()
            return text, false
        elseif char ~= -1 then
            text = text .. char
            pointer = pointer + 1
            sf:run("UPDATE_INPUT", text, pointer)
        end
        util.yield()
    end
    return text, true
end

-- Shows a popup warning
-- ms: Amount of milliseconds to display or nil for forever (call Deactivate(returnValue) to stop)
function Scaleform.showPopupWarning(title, msg, bottom, ms, altText, hideBg)
    local sf = Scaleform:create('POPUP_WARNING')
    sf:run("SHOW_POPUP_WARNING", ms, title, msg, bottom, not hideBg, 0, altText)

    sf:activate(ms)
    return sf
end

function Scaleform.showFullscreenPopup(title, msg, bottom, ms, altText, hideBg)
    local sf = Scaleform:create('POPUP_WARNING')
    sf:run("SHOW_POPUP_WARNING", ms, title, msg, bottom, not hideBg, 1, altText)

    sf:activate(ms)
    return sf
end

function Scaleform.clearAlerts()
    local sf = Scaleform:findInstance("CELLPHONE_ALERT_POPUP")
    sf:run("CLEAR_ALL")
end

-- Shows an message with an icon
-- x,y: position of icon, no clue what units, ~200 seems max. Default to 0 if nil
-- Icons: Email=1, Clock=3, @=4, Empty=5, AddFriend=11, Checkbox=12, Phone=26, EmailSwap=31, Poop=32, Radar=55, RadarFlash=60, PhoneWifi=53, PhoneReply=52
function Scaleform.showAlert(type, content, ms, x, y)
    local sf = Scaleform:create("CELLPHONE_ALERT_POPUP")
    sf:run("CREATE_ALERT", type, x or 0, y or 0, content)
    sf:activate(ms)
    return sf
end

-- Shows the los santos traffic UI from singleplayer
-- ms: Amount of milliseconds to display or nil for forever (call Deactivate(returnValue) to stop)
function Scaleform.showTrafficMovie(ms)
    local sf = Scaleform:create('TRAFFIC_CAM')
    sf:run("PLAY_CAM_MOVIE")
    sf:activate(ms)
    return sf
end

-- Shows a countdown indicator used in racing, stating directions
-- Symbols:
-- 1=Forward, 2=Left, 3=Right, 4=U-Turn, 5=Up, 6=Down, 7=Stop
function Scaleform.showDirection(direction, r, g, b, ms)
    local sf = Scaleform:create("COUNTDOWN")
    sf:run("SET_DIRECTION", direction, r, g, b)
    sf:activate(ms)
end

function Scaleform.showFiveSecondCountdown()
    local sf = Scaleform:create("COUNTDOWN")
    sf:activate(5000)
    -- runMethod(sc, "OVERRIDE_FADE_DURATION", 0)
    for x = 5, 0, -1 do
        sf:run("SET_COUNTDOWN_LIGHTS", x)
        util.yield(1000)
    end
    sf:run("SET_MESSAGE", "STOP!", 255, 0, 255, true)
end

-- Built in methods to change a user's phone. These methods should be called every *mostly* frame, or a user's phone will update and wipe them
Scaleform.phone = {
    instance = Scaleform:findInstance("CELLPHONE_IFRUIT"),
    -- Sets the header bar under the time's text (shows current selected app)
    setHeaderText = function(text)
        Scaleform.phone.instance:run("SET_HEADER", text)
    end,
    -- Sets the color theme of the phone.
    -- 1=Blue, 2=Dark Green, 3=Red, 4=Orange, 5=Dark Gray, 6=Purple, 7=Pink, 8=Pink
    setTheme = function(themeIndex)
        Scaleform.phone.instance:run("SET_THEME", themeIndex)
    end,
    -- Toggles sleep mode off the phone. Needs to be turned off if rendering brand new phone, or phone needs to be activated
    setSleepmode = function(on)
        Scaleform.phone.instance:run("SET_SLEEPMODE", on)
    end,
    -- Sets the current time and displayed day. Day is a string
    setTime = function(hour, min, dayStr)
        Scaleform.phone.instance:run("SET_TITLEBAR_TIME", hour, min, dayStr)
    end,
    -- Sets the background.
    setBackground = function(imageIndex)
        Scaleform.phone.instance:run("SET_BACKGROUND_IMAGE", imageIndex)
    end,
    -- signal: Value of 1 to 4. Any higher will just display as max
    -- provider(optional): Either 0 or 1 (default)
    setSignal = function(signal, provider)
        if provider then
            Scaleform.phone.instance:run("SET_PROVIDER_ICON", provider, signal)
        else
            Scaleform.phone.instance:run("SET_SIGNAL_STRENGTH", signal)
        end
    end,
    -- Wipes the phone to a blank screen
    clear = function(_)
        Scaleform.phone.instance:run("SHUTDOWN_MOVIE")
    end,
    -- Gets the current selected item entry.
    -- On homepage: 0=Emaill, 1=Texts, 2=Contacts, 3=Quick Job, 4=Job List, 5=Settings, 6=Snapmatic, 7=Browser, 8=SecuroServ
    -- Contacts: Lester=12, Mechanic=12, MerryWeather=17, MorsMutual=18, Pegasus=22, Cab=6, 911=7, Lamar=10
    getCurrentSelection = function(_)
        Scaleform.phone.instance:run("GET_CURRENT_SELECTION")
        return Scaleform.endMethodGetInt()
    end,
    up = function(_) Scaleform.phone.instance:run("SET_INPUT_EVENT", 1) end,
    left = function(_) Scaleform.phone.instance:run("SET_INPUT_EVENT", 4) end,
    right = function(_) Scaleform.phone.instance:run("SET_INPUT_EVENT", 2) end,
    down = function(_) Scaleform.phone.instance:run("SET_INPUT_EVENT", 3) end,
    press = function(_) Scaleform.phone.instance:run("SET_INPUT_EVENT", 1) end,
    -- Enters a raw input. Directional inputs are: .up(), .down(), .left(), .right()
    rawInput = function(input) Scaleform.phone.instance:run("SET_INPUT_EVENT", input) end
}

return Scaleform