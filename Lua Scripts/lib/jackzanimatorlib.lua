ANIMATOR_LIB_VERSION = "1.0.0"
RECORDING_FORMAT_VERSION = 2

local json = require("json")

local STORE_DIRECTORY = filesystem.store_dir() .. "jackz_animator"
local RECORDINGS_DIR = STORE_DIRECTORY .. "/recordings"
filesystem.mkdirs(RECORDINGS_DIR)


local RESOURCES_DIR = filesystem.resources_dir() .. "/jackz_animator"
if not filesystem.exists(RESOURCES_DIR) then
    error("Missing jackz_animator resources folder")
end
local PLAY_2X_ICON = directx.create_texture(RESOURCES_DIR .. "/forward.png")
local PLAY_3X_ICON = directx.create_texture(RESOURCES_DIR .. "/forward-fast.png")
local PLAY_ICON =  directx.create_texture(RESOURCES_DIR .. "/play.png")
local RECORD_ICON = directx.create_texture(RESOURCES_DIR .. "/record.png")
-- https://www.flaticon.com/free-icons/rec Rec icons created by kliwir art - Flaticon
local ICON_SIZE = 0.0070

function shallowCopyArray(t)
    local t2 = {}
    for k, v in ipairs(t) do
      t2[k] = v
    end
    return t2
end

RecordingController = {
    active = false,
    positions = {},
    positionsCount = 0,
    interval = 750,
    prevData = {
        weaponModel = nil
    }
}

-- Starts a recording at the specified interval
function RecordingController.StartRecording(self, recordingInterval)
    if not recordingInterval then recordingInterval = 750 end

    local myPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
    self.rootPosition = v3.new(ENTITY.GET_ENTITY_COORDS(myPed))
    self.active = true
    self.positions = {}
    self.positionsCount = 0
    self.interval = recordingInterval
    util.create_tick_handler(function() return self:_renderUI() end)
    util.create_tick_handler(function() return self:_recordFrame() end)
end

function RecordingController.IsRecording(self)
    return self.active
end

function RecordingController.PauseRecording(self)
    self.active = false
end

function RecordingController.ResumeRecording(self)
    self.active = true
end

-- Stops a recording and returns the positions and interval of the recording
function RecordingController.StopRecording(self)
    self.active = false
    local positions = shallowCopyArray(self.positions)
    self.positions = {}
    return positions, self.interval
end

function RecordingController._renderUI(self)
    directx.draw_rect(0.93, 0.00, 0.25, 0.03, { r = 0.0, g = 0.0, b = 0.0, a = 0.3 })
    directx.draw_texture_client(RECORD_ICON, ICON_SIZE, ICON_SIZE, 0, 0, 0.94, 0.0, 0, 1.0, 1.0, 1.0, 1.0)
    directx.draw_text_client(0.999, 0.0132, "Frame " .. self.positionsCount, ALIGN_CENTRE_RIGHT, 0.65, { r = 1.0, g = 1.0, b = 1.0, a = 1.0})
    return self.active
end

function RecordingController._recordFrame(self)
    local myPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
    local weaponIndex = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(myPed)
    local offset = v3.new(ENTITY.GET_ENTITY_COORDS(myPed))
    offset:sub(self.rootPosition)
    local ang = ENTITY.GET_ENTITY_ROTATION(myPed)
    
    local weaponModel = ENTITY.GET_ENTITY_MODEL(weaponIndex)
    if self.prevData.weaponModel == weaponModel then
        weaponModel = 0
    else
        self.prevData.weaponModel = weaponModel
    end
    self.positionsCount = self.positionsCount + 1
    self.positions[self.positionsCount] = {
        offset:getX(), offset:getY(), offset:getZ(),
        ang.x, ang.y, ang.z,
        weaponModel
    }
    util.yield(self.interval)
    return self.active
end

function RecordingController.ListRecordings(onListEntry)
    if onListEntry then
        for _, path in ipairs(filesystem.list_files(RECORDINGS_DIR)) do
            local _, filename = string.match(path, "(.-)([^\\/]-%.?([^%.\\/]*))$")
            if not filesystem.is_dir(path) then
                onListEntry(path, filename)
            end

        end
        return
    end
    return filesystem.list_files(RECORDINGS_DIR)
end

-- Returns the json data and the size of the file
function RecordingController.LoadRecordingData(filepath)
    local file = io.open(filepath, "r")
    if file then
        local status, data = pcall(json.decode, file:read("*a"))
        if status then
            local size = file:seek("end")
            return data, size
        else
            error("Invalid JSON reading file: " .. data)
        end
    else
        error("Could not read file")
    end
end


PlaybackController = {
    animations = {}, activePlayer = nil
}

--[[ 
Playback will start at the entity's current position, or specify startPosition to change the position

Value is the defaults,     
Options: {
    speed = 1.0, -- Starting speed
    startFrame = 1,
    initialFrame = 1
    endFrame = #positions,
    debug = false,
    repeat = false,
    onFinish = function(endingFrame, time)
    onFrame = function(frame, time),
    keepOnEnd = false -- Prevent playback from being deleted when completed. Requires PlaybackController:Stop(entity) to be called to delete. :Resume() to restart
        Also prevents onFinish called until :Stop is called
}]]
function PlaybackController.StartPlayback(self, entity, positions, recordInterval, options)
    if not entity then return error("Missing required parameter: entity") end
    if not positions then return error("Missing a required parameter: positions (array of positions)") end
    if not recordInterval then return error("Missing a required parameter: recordInterval") end
    if #positions == 0 then
        return
    end
    if not options.startFrame then options.startFrame = 1 end
    if not options.positionsFormat then options.positionsFormat = RECORDING_FORMAT_VERSION end
    if options.positionsFormat > 1 and not options.startingPosition then options.startingPosition = ENTITY.GET_ENTITY_COORDS(entity) end
    local entityType = 0
    if ENTITY.IS_ENTITY_A_PED(entity) then
        entityType = 1
    end
    self.animations[entity] = {
        active = true,
        entity = entity,
        entityType = entityType,
        positionsFormat = options.positionsFormat,
        -- Don't record root position if on legacy
        rootPosition = options.startingPosition,
        positions = shallowCopyArray(positions),
        time = recordInterval * (options.startFrame - 1),
        prevTime = os.clock() * 1000,
        speed = options.speed or 1.0,
        frame = options.initalFrame or options.startFrame,
        startFrame = options.startFrame,
        endFrame = options.endFrame or #positions - 1,
        interval = recordInterval,
        animTick = 0.0,
        debug = options.debug,
        ["repeat"] = options["repeat"],
        onFinish = options.onFinish,
        onFrame = options.onFrame,
        keepOnEnd = options.keepOnEnd
    }
    if options.showUI then
        self.activePlayer = entity
    end
end
function PlaybackController.IsInPlayback(self, entity)
    if entity == nil then return false end
    return self.animations[entity] ~= nil
end
function PlaybackController.ShowPlayerUI(self, entity)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    else
        self.activePlayer = entity
    end
end
function PlaybackController.SetSpeed(self, entity, speed)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    else
        self.animations[entity].speed = speed
    end
end
-- Returns the current frame, starting frame, and ending frame
function PlaybackController.GetFrame(self, entity)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    else
        return self.animations[entity].frame, self.animations[entity].startFrame, self.animations[entity].endFrame
    end
end

function PlaybackController.SetFrame(self, entity, frame, startFrame, endFrame)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    elseif frame and frame <= 0 then
        error("Frame is out of range. Minimum of 1")
    elseif frame and frame > self.animations[entity].endFrame then
        error("Frame is out of range. Minimum of 1")
    elseif startFrame and startFrame <= 0 then
        error("Start Frame is out of range. Minimum of 1")
    elseif startFrame and startFrame > self.animations[entity].endFrame then
        error("Start Frame is out of range. Minimum of 1")
    elseif endFrame and endFrame <= 0 then
        error("End Frame is out of range. Minimum of 1")
    elseif endFrame and endFrame > self.animations[entity].endFrame then
        error("End Frame is out of range. Range must be between 1 and " .. self.animations[entity].endFrame)
    else
        if frame ~= nil then
            self.animations[entity].frame = frame
            self.animations[entity].time = self.animations[entity].interval * (frame - 1)
        end
        if startFrame then
            self.animations[entity].startFrame = startFrame
        end
        if endFrame then
            self.animations[entity].endFrame = endFrame
        end
    end
end

function PlaybackController.GetTime(self ,entity)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    else
        return self.animations[entity].time
    end
end

function PlaybackController.Pause(self, entity)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    else
        self.animations[entity].active = false
    end
end
function PlaybackController.Resume(self, entity)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    else
        self.animations[entity].active = true
        self.animations[entity].prevTime = os.clock() * 1000
    end
end
function PlaybackController.SetPaused(self, entity, value)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    else
        self.animations[entity].active = not value
        if not value then
            self.animations[entity].prevTime = os.clock() * 1000
        end
    end
end
function PlaybackController.IsPaused(self, entity)
    if not self.animations[entity] then
        error("No running playback for specified entity")
    else
        return not self.animations[entity].active
    end
end

function PlaybackController.Stop(self, entity)
    if self.animations[entity] then
        self:_stop(entity, true)
    end
end
function PlaybackController.StopAll(self)
    for entity, _ in pairs(self.animations) do
        self:_stop(entity)
    end
end
function PlaybackController._stop(self, entity, forceDelete)
    TASK.CLEAR_PED_TASKS(entity)
    util.toast(entity .. ": End of animation on frame " .. self.animations[entity].frame .. " time " .. self.animations[entity].time)
    if forceDelete or not self.animations[entity].keepOnEnd then
        util.toast("deleting record data")
        if self.activePlayer == entity then
            self.activePlayer = nil
        end
        if self.animations[entity].onFinish then
            self.animations[entity].onFinish(self.animations[entity].frame, self.animations[entity].time)
        end
        self.animations[entity] = nil
    else
        self.animations[entity].active = false
    end
end
function PlaybackController._DisplayPlayerInfo(self, entity)
    directx.draw_rect(0.93, 0.00, 0.25, 0.03, { r = 0.0, g = 0.0, b = 0.0, a = 0.3 })
    local animation = self.animations[entity]
    if animation.speed > 2.0 then
        directx.draw_texture_client(PLAY_3X_ICON, ICON_SIZE, ICON_SIZE, 0, 0, 0.90, 0.0, 0, 1.0, 1.0, 1.0, 1.0)
    elseif animation.speed > 1.0 then
        directx.draw_texture_client(PLAY_2X_ICON, ICON_SIZE, ICON_SIZE, 0, 0, 0.90, 0.0, 0, 1.0, 1.0, 1.0, 1.0)
    end
    directx.draw_texture_client(PLAY_ICON, ICON_SIZE, ICON_SIZE, 0, 0, 0.90, 0.0, 0, 1.0, 1.0, 1.0, 1.0)
    directx.draw_text_client(0.999, 0.0132, "Frame " .. animation.frame .. "/" .. #animation.positions, ALIGN_CENTRE_RIGHT, 0.65, { r = 1.0, g = 1.0, b = 1.0, a = 1.0}, true)
end
function PlaybackController._processFrame(self)
    local now = os.clock() * 1000
    if self.activePlayer then
        self:_DisplayPlayerInfo(self.activePlayer)
    end
    for entity, animation in pairs(self.animations) do
        if animation.active then
            animation.frame = math.floor(animation.time / animation.interval) + 1
            local a = animation.positions[animation.frame]
            local b = animation.positions[animation.frame + 1]
            if animation.frame <= animation.endFrame and b then
                local timeDelta = animation.time % animation.interval / animation.interval
                local pX, pY, pZ = computeInterpVec(a, b, 1, timeDelta)
                local rX, rY, rZ = computeInterpVec(a, b, 4, timeDelta)
                if animation.rootPosition then
                    pX = animation.rootPosition.x + pX
                    pY = animation.rootPosition.y + pY
                    pZ = animation.rootPosition.z + pZ
                end
                local frameTime = now - animation.prevTime

                if animation.debug then
                    util.draw_debug_text(" ")
                    util.draw_debug_text("process " .. entity)
                    util.draw_debug_text("time: " .. animation.time)
                    util.draw_debug_text("interval: " .. animation.interval)
                    util.draw_debug_text("delta: " .. timeDelta)
                    util.draw_debug_text("frame time: " .. frameTime)
                end

                if animation.entityType == 0 then
                    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(animation.entity, pX, pY, pZ)
                    ENTITY.SET_ENTITY_ROTATION(animation.entity, rX, rY, rZ)
                elseif animation.entityType == 1 then
                    animation.animTick = animation.animTick + 0.005
                    if animation.animTick > 1.0 then animation.animTick = 0.0 end
                    TASK.TASK_PLAY_ANIM_ADVANCED(animation.entity, "anim@move_f@grooving@", "walk", pX, pY, pZ, rX, rY, rZ, 1.0, 1.0, frameTime , 5, animation.animTick)
                end
                if animation.onFrame then
                    animation.onFrame(animation.frame, animation.time)
                end
                animation.time = animation.time + (animation.speed * frameTime)
                animation.prevTime = now
            else
                if animation["repeat"] then
                    animation.time = 0
                    animation.prevTime = now
                    animation.frame = 1
                else
                    self:_stop(entity)
                end
            end
        end
    end
end

function computeInterp(a, b, timeDelta)
    return a + (b - a) * timeDelta
end
function computeInterpVec(a, b, startIndex, timeDelta)
    local x = a[startIndex] + (b[startIndex] - a[startIndex]) * timeDelta
    startIndex = startIndex + 1
    local y = a[startIndex] + (b[startIndex] - a[startIndex]) * timeDelta
    startIndex = startIndex + 1
    local z = a[startIndex] + (b[startIndex] - a[startIndex]) * timeDelta

    return x, y, z
end

util.create_tick_handler(function() PlaybackController:_processFrame() end)

return {
    VERSION = ANIMATOR_LIB_VERSION,
    RECORDING_FORMAT_VERSION = RECORDING_FORMAT_VERSION,
    RECORDINGS_DIRECTORY = RECORDINGS_DIR,
    RecordingController = RecordingController,
    PlaybackController = PlaybackController,
}