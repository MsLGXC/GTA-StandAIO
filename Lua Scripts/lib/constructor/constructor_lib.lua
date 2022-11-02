-- Constructor Lib
-- by Hexarobi
-- A Lua Script for the Stand mod menu for GTA5
-- Allows for constructing custom vehicles and maps
-- https://github.com/hexarobi/stand-lua-constructor

local SCRIPT_VERSION = "3.21.9"

local constructor_lib = {
    LIB_VERSION = SCRIPT_VERSION
}

---
--- Dependencies
---

local status_inspect, inspect = pcall(require, "inspect")
if not status_inspect then error("Could not load inspect lib. This should have been auto-installed.") end

local status_constants, constants = pcall(require, "constructor/constants")
if not status_constants then error("Could not load constants lib. This should have been auto-installed.") end

---
--- Data
---

constructor_lib.ENTITY_TYPES = {"PED", "VEHICLE", "OBJECT"}

constructor_lib.construct_base = {
    target_version = constructor_lib.LIB_VERSION,
    children = {},
    options = {},
    temp = {},
    position = {x=0,y=0,z=0},
    offset = {x=0,y=0,z=0},
    rotation = {x=0,y=0,z=0},
    world_rotation = {x=0,y=0,z=0},
    num_bones = 200,
    heading = 0,
    blip_icon = 1,
    blip_color = 2,
}

---
--- Utilities
---

local function t(text)
    return CONSTRUCTOR_TRANSLATE_FUNCTION(text)
end

local function debug_log(message, additional_details)
    if CONSTRUCTOR_CONFIG.debug_mode then
        if CONSTRUCTOR_CONFIG.debug_mode == 2 and additional_details ~= nil then
            message = message .. "\n" .. inspect(additional_details)
        end
        util.log("[constructor_lib] "..message)
    end
end

util.require_natives(1663599433)

function table.table_copy(obj)
    if type(obj) ~= 'table' then
        return obj
    end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do
        res[table.table_copy(k)] = table.table_copy(v)
    end
    return res
end

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

-- From https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating
function table.array_remove(t, fnKeep)
    local j, n = 1, #t;

    for i=1,n do
        if (fnKeep(t, i, j)) then
            -- Move i's kept value to j's position, if it's not already there.
            if (i ~= j) then
                t[j] = t[i];
                t[i] = nil;
            end
            j = j + 1; -- Increment position of where we'll place the next kept value.
        else
            t[i] = nil;
        end
    end

    return t;
end

constructor_lib.load_hash = function(hash)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        util.yield()
    end
end

constructor_lib.spawn_vehicle_for_player = function(pid, model_name)
    local model = util.joaat(model_name)
    if not STREAMING.IS_MODEL_VALID(model) or not STREAMING.IS_MODEL_A_VEHICLE(model) then
        util.toast(t("Error: Invalid vehicle name"))
        return
    else
        constructor_lib.load_hash(model)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(target_ped, 0.0, 4.0, 0.5)
        local heading = ENTITY.GET_ENTITY_HEADING(target_ped)
        local vehicle = entities.create_vehicle(model, pos, heading)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(model)
        return vehicle
    end
end


---
--- Draw Utils
---


local minimum = memory.alloc()
local maximum = memory.alloc()
local upVector_pointer = memory.alloc()
local rightVector_pointer = memory.alloc()
local forwardVector_pointer = memory.alloc()
local position_pointer = memory.alloc()

-- From GridSpawn
constructor_lib.draw_bounding_box = function(entity, colour)
    if colour == nil then
        colour = {r=255,g=0,b=0,a=255}
    end

    MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(entity), minimum, maximum)
    local minimum_vec = v3.new(minimum)
    local maximum_vec = v3.new(maximum)
    constructor_lib.draw_bounding_box_with_dimensions(entity, colour, minimum_vec, maximum_vec)
end

constructor_lib.draw_bounding_box_with_dimensions = function(entity, colour, minimum_vec, maximum_vec)

    local dimensions = {x = maximum_vec.y - minimum_vec.y, y = maximum_vec.x - minimum_vec.x, z = maximum_vec.z - minimum_vec.z}

    ENTITY.GET_ENTITY_MATRIX(entity, rightVector_pointer, forwardVector_pointer, upVector_pointer, position_pointer);
    local forward_vector = v3.new(forwardVector_pointer)
    local right_vector = v3.new(rightVector_pointer)
    local up_vector = v3.new(upVector_pointer)

    local top_right =           ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entity,       maximum_vec.x, maximum_vec.y, maximum_vec.z)
    local top_right_back =      {x = forward_vector.x * -dimensions.y + top_right.x,        y = forward_vector.y * -dimensions.y + top_right.y,         z = forward_vector.z * -dimensions.y + top_right.z}
    local bottom_right_back =   {x = up_vector.x * -dimensions.z + top_right_back.x,        y = up_vector.y * -dimensions.z + top_right_back.y,         z = up_vector.z * -dimensions.z + top_right_back.z}
    local bottom_left_back =    {x = -right_vector.x * dimensions.x + bottom_right_back.x,  y = -right_vector.y * dimensions.x + bottom_right_back.y,   z = -right_vector.z * dimensions.x + bottom_right_back.z}
    local top_left =            {x = -right_vector.x * dimensions.x + top_right.x,          y = -right_vector.y * dimensions.x + top_right.y,           z = -right_vector.z * dimensions.x + top_right.z}
    local bottom_right =        {x = -up_vector.x * dimensions.z + top_right.x,             y = -up_vector.y * dimensions.z + top_right.y,              z = -up_vector.z * dimensions.z + top_right.z}
    local bottom_left =         {x = forward_vector.x * dimensions.y + bottom_left_back.x,  y = forward_vector.y * dimensions.y + bottom_left_back.y,   z = forward_vector.z * dimensions.y + bottom_left_back.z}
    local top_left_back =       {x = up_vector.x * dimensions.z + bottom_left_back.x,       y = up_vector.y * dimensions.z + bottom_left_back.y,        z = up_vector.z * dimensions.z + bottom_left_back.z}

    GRAPHICS.DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            bottom_left.x, bottom_left.y, bottom_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            top_left_back.x, top_left_back.y, top_left_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            top_left_back.x, top_left_back.y, top_left_back.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            top_left_back.x, top_left_back.y, top_left_back.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left.x, bottom_left.y, bottom_left.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left.x, bottom_left.y, bottom_left.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
end


---
--- Specific Serializers
---

constructor_lib.serialize_vehicle_headlights = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.headlights == nil then vehicle.vehicle_attributes.headlights = {} end
    vehicle.vehicle_attributes.headlights.headlights_color = VEHICLE.GET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle)
    vehicle.vehicle_attributes.headlights.headlights_type = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, 22)
end

constructor_lib.deserialize_vehicle_headlights = function(vehicle)
    if vehicle.vehicle_attributes.headlights == nil then return end
    VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle, vehicle.vehicle_attributes.headlights.headlights_color)
    VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, 22, vehicle.vehicle_attributes.headlights.headlights_type or false)
    VEHICLE.SET_VEHICLE_LIGHT_MULTIPLIER(vehicle.handle, vehicle.vehicle_attributes.headlights.multiplier or 1)
end

constructor_lib.serialize_vehicle_paint = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.paint == nil then vehicle.vehicle_attributes.paint = {} end
    if vehicle.vehicle_attributes.paint.primary == nil then vehicle.vehicle_attributes.paint.primary = {} end
    if vehicle.vehicle_attributes.paint.secondary == nil then vehicle.vehicle_attributes.paint.secondary = {} end

    -- Create pointers to hold color values
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }

    VEHICLE.GET_VEHICLE_COLOR(vehicle.handle, color.r, color.g, color.b)
    vehicle.vehicle_attributes.paint.vehicle_custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    VEHICLE.GET_VEHICLE_COLOURS(vehicle.handle, color.r, color.g)
    vehicle.vehicle_attributes.paint.primary.vehicle_standard_color = memory.read_int(color.r)
    vehicle.vehicle_attributes.paint.secondary.vehicle_standard_color = memory.read_int(color.g)

    vehicle.vehicle_attributes.paint.primary.is_custom = VEHICLE.GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(vehicle.handle)
    if vehicle.vehicle_attributes.paint.primary.is_custom then
        VEHICLE.GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle.handle, color.r, color.g, color.b)
        vehicle.vehicle_attributes.paint.primary.custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    else
        VEHICLE.GET_VEHICLE_MOD_COLOR_1(vehicle.handle, color.r, color.g, color.b)
        vehicle.vehicle_attributes.paint.primary.paint_type = memory.read_int(color.r)
        vehicle.vehicle_attributes.paint.primary.color = memory.read_int(color.g)
        vehicle.vehicle_attributes.paint.primary.pearlescent_color = memory.read_int(color.b)
    end

    vehicle.vehicle_attributes.paint.secondary.is_custom = VEHICLE.GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(vehicle.handle)
    if vehicle.vehicle_attributes.paint.secondary.is_custom then
        VEHICLE.GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle.handle, color.r, color.g, color.b)
        vehicle.vehicle_attributes.paint.secondary.custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    else
        VEHICLE.GET_VEHICLE_MOD_COLOR_2(vehicle.handle, color.r, color.g)
        vehicle.vehicle_attributes.paint.secondary.paint_type = memory.read_int(color.r)
        vehicle.vehicle_attributes.paint.secondary.color = memory.read_int(color.g)
    end

    VEHICLE.GET_VEHICLE_EXTRA_COLOURS(vehicle.handle, color.r, color.g)
    vehicle.vehicle_attributes.paint.extra_colors = { pearlescent = memory.read_int(color.r), wheel = memory.read_int(color.g) }
    VEHICLE.GET_VEHICLE_EXTRA_COLOUR_6(vehicle.handle, color.r)
    vehicle.vehicle_attributes.paint.dashboard_color = memory.read_int(color.r)
    VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(vehicle.handle, color.r)
    vehicle.vehicle_attributes.paint.interior_color = memory.read_int(color.r)
    vehicle.vehicle_attributes.paint.fade = VEHICLE.GET_VEHICLE_ENVEFF_SCALE(vehicle.handle)
    vehicle.vehicle_attributes.paint.dirt_level = VEHICLE.GET_VEHICLE_DIRT_LEVEL(vehicle.handle)
    vehicle.vehicle_attributes.paint.color_combo = VEHICLE.GET_VEHICLE_COLOUR_COMBINATION(vehicle.handle)

    -- Livery is also part of mods, but capture it here as well for when just saving paint
    vehicle.vehicle_attributes.paint.livery = VEHICLE.GET_VEHICLE_MOD(vehicle.handle, 48)
    vehicle.vehicle_attributes.paint.livery_legacy = VEHICLE.GET_VEHICLE_LIVERY(vehicle.handle)
    vehicle.vehicle_attributes.paint.livery2_legacy = VEHICLE.GET_VEHICLE_LIVERY2(vehicle.handle)

    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_paint = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.paint == nil then return end

    VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)
    if vehicle.vehicle_attributes.paint.color_combo ~= nil then
        VEHICLE.SET_VEHICLE_COLOUR_COMBINATION(vehicle.handle, vehicle.vehicle_attributes.paint.color_combo or -1)
    end

    if vehicle.vehicle_attributes.paint.vehicle_custom_color ~= nil then
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(
                vehicle.handle,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.r,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.g,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.b
        )
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(
                vehicle.handle,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.r,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.g,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.b
        )
    end

    if vehicle.vehicle_attributes.paint.primary ~= nil then
        if vehicle.vehicle_attributes.paint.primary.vehicle_standard_color ~= nil
                or vehicle.vehicle_attributes.paint.secondary.vehicle_standard_color ~= nil then
            VEHICLE.SET_VEHICLE_COLOURS(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.primary.vehicle_standard_color,
                    vehicle.vehicle_attributes.paint.secondary.vehicle_standard_color
            )
        end
        if vehicle.vehicle_attributes.paint.primary.is_custom then
            VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.primary.custom_color.r,
                    vehicle.vehicle_attributes.paint.primary.custom_color.g,
                    vehicle.vehicle_attributes.paint.primary.custom_color.b
            )
        end
        if vehicle.vehicle_attributes.paint.primary.paint_type ~= nil then
            VEHICLE.SET_VEHICLE_MOD_COLOR_1(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.primary.paint_type,
                    vehicle.vehicle_attributes.paint.primary.color,
                    vehicle.vehicle_attributes.paint.primary.pearlescent_color
            )
        end
        if vehicle.vehicle_attributes.paint.secondary.is_custom then
            VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.secondary.custom_color.r,
                    vehicle.vehicle_attributes.paint.secondary.custom_color.g,
                    vehicle.vehicle_attributes.paint.secondary.custom_color.b
            )
        end
        if vehicle.vehicle_attributes.paint.secondary.paint_type ~= nil then
            VEHICLE.SET_VEHICLE_MOD_COLOR_2(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.secondary.paint_type,
                    vehicle.vehicle_attributes.paint.secondary.color
            )
        end
    end

    if vehicle.vehicle_attributes.paint.extra_colors.pearlescent ~= nil or vehicle.vehicle_attributes.paint.extra_colors.wheel ~= nil then
        VEHICLE.SET_VEHICLE_EXTRA_COLOURS(
                vehicle.handle,
                vehicle.vehicle_attributes.paint.extra_colors.pearlescent,
                vehicle.vehicle_attributes.paint.extra_colors.wheel
        )
    end

    if vehicle.vehicle_attributes.headlights_color ~= nil then
        VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle, vehicle.vehicle_attributes.headlights_color)
    end
    if vehicle.vehicle_attributes.paint.dashboard_color ~= nil then
        VEHICLE.SET_VEHICLE_EXTRA_COLOUR_6(vehicle.handle, vehicle.vehicle_attributes.paint.dashboard_color)
    end
    if vehicle.vehicle_attributes.paint.interior_color ~= nil then
        VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(vehicle.handle, vehicle.vehicle_attributes.paint.interior_color)
    end
    if vehicle.vehicle_attributes.paint.fade ~= nil then
        VEHICLE.SET_VEHICLE_ENVEFF_SCALE(vehicle.handle, vehicle.vehicle_attributes.paint.fade)
    end
    if vehicle.vehicle_attributes.paint.dirt_level ~= nil then
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle.handle, vehicle.vehicle_attributes.paint.dirt_level)
    end
    if vehicle.vehicle_attributes.paint.livery ~= nil then
        VEHICLE.SET_VEHICLE_MOD(vehicle.handle, 48, vehicle.vehicle_attributes.paint.livery)
    end
    if vehicle.vehicle_attributes.paint.livery_legacy ~= nil then
        VEHICLE.SET_VEHICLE_LIVERY(vehicle.handle, vehicle.vehicle_attributes.paint.livery_legacy)
    end
    if vehicle.vehicle_attributes.paint.livery2_legacy ~= nil then
        VEHICLE.SET_VEHICLE_LIVERY2(vehicle.handle, vehicle.vehicle_attributes.paint.livery2_legacy)
    end
end

constructor_lib.serialize_vehicle_neon = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.neon == nil then vehicle.vehicle_attributes.neon = {} end
    vehicle.vehicle_attributes.neon.lights = {
        left = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 0),
        right = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 1),
        front = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 2),
        back = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 3),
    }
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }
    if (vehicle.vehicle_attributes.neon.lights.left or vehicle.vehicle_attributes.neon.lights.right
            or vehicle.vehicle_attributes.neon.lights.front or vehicle.vehicle_attributes.neon.lights.back) then
        VEHICLE.GET_VEHICLE_NEON_COLOUR(vehicle.handle, color.r, color.g, color.b)
        vehicle.vehicle_attributes.neon.color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    end
    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_neon = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.neon == nil then return end
    if vehicle.vehicle_attributes.neon.lights then
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 0, vehicle.vehicle_attributes.neon.lights.left or false)
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 1, vehicle.vehicle_attributes.neon.lights.right or false)
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 2, vehicle.vehicle_attributes.neon.lights.front or false)
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 3, vehicle.vehicle_attributes.neon.lights.back or false)
    end
    if vehicle.vehicle_attributes.neon.color then
        VEHICLE.SET_VEHICLE_NEON_COLOUR(
                vehicle.handle,
                vehicle.vehicle_attributes.neon.color.r,
                vehicle.vehicle_attributes.neon.color.g,
                vehicle.vehicle_attributes.neon.color.b
        )
    end
end

constructor_lib.serialize_vehicle_wheels = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.wheels == nil then vehicle.vehicle_attributes.wheels = {} end
    if vehicle.vehicle_attributes.wheels.tires_burst == nil then vehicle.vehicle_attributes.wheels.tires_burst = {} end
    vehicle.vehicle_attributes.wheels.wheel_type = VEHICLE.GET_VEHICLE_WHEEL_TYPE(vehicle.handle)
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }
    VEHICLE.GET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, color.r, color.g, color.b)
    vehicle.vehicle_attributes.wheels.tire_smoke_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_wheels = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.wheels == nil then return end
    if vehicle.vehicle_attributes.wheels.bulletproof_tires ~= nil then
        VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle.handle, not vehicle.vehicle_attributes.wheels.bulletproof_tires)
    end
    VEHICLE.SET_VEHICLE_WHEEL_TYPE(vehicle.handle, vehicle.vehicle_attributes.wheels.wheel_type or -1)
    if vehicle.vehicle_attributes.wheels.tire_smoke_color then
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, vehicle.vehicle_attributes.wheels.tire_smoke_color.r or 255,
                vehicle.vehicle_attributes.wheels.tire_smoke_color.g or 255, vehicle.vehicle_attributes.wheels.tire_smoke_color.b or 255)
    end
    if vehicle.vehicle_attributes.wheels.tires_burst then
        for _, tire_position in pairs(constants.tire_position_names) do
            if vehicle.vehicle_attributes.wheels.tires_burst["_"..tire_position.index] then
                VEHICLE.SET_VEHICLE_TYRE_BURST(vehicle.handle, tire_position.index, true, 1.0)
            else
                VEHICLE.SET_VEHICLE_TYRE_FIXED(vehicle.handle, tire_position.index)
            end
        end
    end
end

constructor_lib.serialize_vehicle_doors = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.doors == nil then
        vehicle.vehicle_attributes.doors = { broken = {}, open = {}, }
    end
    vehicle.vehicle_attributes.doors.open.frontleft = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 0)
    vehicle.vehicle_attributes.doors.open.frontright = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 1)
    vehicle.vehicle_attributes.doors.open.backleft = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 2)
    vehicle.vehicle_attributes.doors.open.backright = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 3)
    vehicle.vehicle_attributes.doors.open.hood = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 4)
    vehicle.vehicle_attributes.doors.open.trunk = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 5)
    vehicle.vehicle_attributes.doors.open.trunk2 = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 6)
end

constructor_lib.deserialize_vehicle_doors = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.doors == nil then return end
    if vehicle.vehicle_attributes.doors.broken.frontleft then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 0, true) end
    if vehicle.vehicle_attributes.doors.broken.frontright then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 1, true) end
    if vehicle.vehicle_attributes.doors.broken.backleft then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 2, true) end
    if vehicle.vehicle_attributes.doors.broken.backright then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 3, true) end
    if vehicle.vehicle_attributes.doors.broken.hood then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 4, true) end
    if vehicle.vehicle_attributes.doors.broken.trunk then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 5, true) end
    if vehicle.vehicle_attributes.doors.broken.trunk2 then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 6, true) end

    if vehicle.vehicle_attributes.doors.open.frontleft then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 0, true, true) end
    if vehicle.vehicle_attributes.doors.open.frontright then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 1, true, true) end
    if vehicle.vehicle_attributes.doors.open.backleft then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 2, true, true) end
    if vehicle.vehicle_attributes.doors.open.backright then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 3, true, true) end
    if vehicle.vehicle_attributes.doors.open.hood then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 4, true, true) end
    if vehicle.vehicle_attributes.doors.open.trunk then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 5, true, true) end
    if vehicle.vehicle_attributes.doors.open.trunk2 then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 6, true, true) end

    if vehicle.vehicle_attributes.doors.lock_status ~= nil then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle.handle, vehicle.vehicle_attributes.doors.lock_status)
    end
end

constructor_lib.serialize_vehicle_mods = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.mods == nil then vehicle.vehicle_attributes.mods = {} end
    for mod_index = 0, 49 do
        local mod_value
        if mod_index >= 17 and mod_index <= 22 then
            mod_value = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, mod_index)
        else
            mod_value = VEHICLE.GET_VEHICLE_MOD(vehicle.handle, mod_index)
        end
        vehicle.vehicle_attributes.mods["_"..mod_index] = mod_value
    end
end

constructor_lib.deserialize_vehicle_mods = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.mods == nil then return end
    for mod_index = 0, 49 do
        if mod_index >= 17 and mod_index <= 22 then
            VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, mod_index, vehicle.vehicle_attributes.mods["_"..mod_index])
        else
            VEHICLE.SET_VEHICLE_MOD(vehicle.handle, mod_index, vehicle.vehicle_attributes.mods["_"..mod_index] or -1)
        end
    end
end

constructor_lib.serialize_vehicle_extras = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.extras == nil then vehicle.vehicle_attributes.extras = {} end
    for extra_index = 0, 14 do
        if VEHICLE.DOES_EXTRA_EXIST(vehicle.handle, extra_index) then
            vehicle.vehicle_attributes.extras["_"..extra_index] = VEHICLE.IS_VEHICLE_EXTRA_TURNED_ON(vehicle.handle, extra_index)
        end
    end
end

constructor_lib.deserialize_vehicle_extras = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.extras == nil then return end
    for extra_index = 0, 14 do
        local state = true
        if vehicle.vehicle_attributes.extras["_"..extra_index] ~= nil then
            state = vehicle.vehicle_attributes.extras["_"..extra_index]
        end
        VEHICLE.SET_VEHICLE_EXTRA(vehicle.handle, extra_index, not state)
    end
end

constructor_lib.serialize_vehicle_options = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.options == nil then vehicle.vehicle_attributes.options = {} end
    vehicle.vehicle_attributes.options.bulletproof_tires = VEHICLE.GET_VEHICLE_TYRES_CAN_BURST(vehicle.handle)
    vehicle.vehicle_attributes.options.window_tint = VEHICLE.GET_VEHICLE_WINDOW_TINT(vehicle.handle)
    vehicle.vehicle_attributes.options.radio_loud = AUDIO.CAN_VEHICLE_RECEIVE_CB_RADIO(vehicle.handle)
    vehicle.vehicle_attributes.options.engine_running = VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(vehicle.handle)
    vehicle.vehicle_attributes.options.siren = VEHICLE.IS_VEHICLE_SIREN_AUDIO_ON(vehicle.handle)
    vehicle.vehicle_attributes.options.emergency_lights = VEHICLE.IS_VEHICLE_SIREN_ON(vehicle.handle)
    vehicle.vehicle_attributes.options.search_light = VEHICLE.IS_VEHICLE_SEARCHLIGHT_ON(vehicle.handle)
    vehicle.vehicle_attributes.options.license_plate_text = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(vehicle.handle)
    vehicle.vehicle_attributes.options.license_plate_type = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle.handle)
end

constructor_lib.deserialize_vehicle_options = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.options == nil then return end
    if vehicle.vehicle_attributes.options.siren then
        AUDIO.SET_SIREN_WITH_NO_DRIVER(vehicle.handle, true)
        VEHICLE.SET_VEHICLE_HAS_MUTED_SIRENS(vehicle.handle, false)
        AUDIO.SET_SIREN_BYPASS_MP_DRIVER_CHECK(vehicle.handle, true)
        AUDIO.TRIGGER_SIREN_AUDIO(vehicle.handle, true)
    end
    if vehicle.vehicle_attributes.options.lights_state ~= nil then
        VEHICLE.SET_VEHICLE_LIGHTS(vehicle.handle, vehicle.vehicle_attributes.options.lights_state)
    end
    if vehicle.vehicle_attributes.options.interior_light ~= nil then
        VEHICLE.SET_VEHICLE_INTERIORLIGHT(vehicle.handle, vehicle.vehicle_attributes.options.interior_light)
    end
    if vehicle.vehicle_attributes.options.is_windscreen_detached == true then
        VEHICLE.POP_OUT_VEHICLE_WINDSCREEN(vehicle.handle)
    end
    if vehicle.vehicle_attributes.options.emergency_lights ~= nil then
        VEHICLE.SET_VEHICLE_SIREN(vehicle.handle, vehicle.vehicle_attributes.options.emergency_lights)
    end
    if vehicle.vehicle_attributes.options.search_light ~= nil then
        VEHICLE.SET_VEHICLE_SEARCHLIGHT(vehicle.handle, vehicle.vehicle_attributes.options.search_light, true)
    end
    if vehicle.vehicle_attributes.options.radio_loud ~= nil then
        AUDIO.SET_VEHICLE_RADIO_LOUD(vehicle.handle, vehicle.vehicle_attributes.options.radio_loud)
    end
    if vehicle.vehicle_attributes.options.license_plate_text ~= nil then
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle.handle, vehicle.vehicle_attributes.options.license_plate_text)
    end
    if vehicle.vehicle_attributes.options.license_plate_type ~= nil then
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle.handle, vehicle.vehicle_attributes.options.license_plate_type)
    end
    if vehicle.vehicle_attributes.options.engine_running == true then
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle.handle, true, true, false)
        VEHICLE.SET_VEHICLE_KEEP_ENGINE_ON_WHEN_ABANDONED(vehicle.handle, true)
    end
    if vehicle.vehicle_attributes.options.doors_locked ~= nil then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle.handle, vehicle.vehicle_attributes.options.doors_locked or false)
    end
    if vehicle.vehicle_attributes.options.engine_health ~= nil then
        VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle.handle, vehicle.vehicle_attributes.options.engine_health)
    end
end

---
--- Attachment Construction
---

constructor_lib.animate_peds = function(attachment)
    if attachment.ped_attributes and attachment.ped_attributes.animation_dict then
        STREAMING.REQUEST_ANIM_DICT(attachment.ped_attributes.animation_dict)
        while not STREAMING.HAS_ANIM_DICT_LOADED(attachment.ped_attributes.animation_dict) do
            util.yield()
        end
        TASK.TASK_PLAY_ANIM(attachment.handle, attachment.ped_attributes.animation_dict, attachment.ped_attributes.animation_name, 8.0, 8.0, -1, 1, 1.0, false, false, false)
    end
end

constructor_lib.set_attachment_internal_collisions = function(attachment, new_attachment)
    ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(attachment.handle, new_attachment.handle)
    if attachment.children ~= nil then
        for _, child_attachment in pairs(attachment.children) do
            constructor_lib.set_attachment_internal_collisions(child_attachment, new_attachment)
        end
    end
end

constructor_lib.completely_disable_attachment_collision = function(attachment)
    ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, false, true)
    for _, child_attachment in pairs(attachment.children) do
        constructor_lib.completely_disable_attachment_collision(child_attachment)
    end
end

constructor_lib.set_attachment_defaults = function(attachment)
    debug_log("Defaulting attachment "..tostring(attachment.name))
    if attachment.children == nil then attachment.children = {} end
    if attachment.temp == nil then attachment.temp = {} end
    if attachment.options == nil then attachment.options = {} end
    if attachment.offset == nil then attachment.offset = { x = 0, y = 0, z = 0 } end
    if attachment.rotation == nil then attachment.rotation = { x = 0, y = 0, z = 0 } end
    if attachment.position == nil then attachment.position = { x = 0, y = 0, z = 0 } end
    if attachment.world_rotation == nil then attachment.world_rotation = { x = 0, y = 0, z = 0 } end
    if attachment.heading == nil then
        attachment.heading = (attachment.root and attachment.root.heading or 0)
    end
    if attachment.options.is_visible == nil then attachment.options.is_visible = true end
    if attachment.options.has_gravity == nil then attachment.options.has_gravity = true end
    if attachment.options.has_collision == nil then
        attachment.options.has_collision = true
        if attachment.root ~= nil and attachment.root.type == "PED" then
            attachment.options.has_collision = false
        end
    end
    if attachment.root ~= nil and attachment.root.is_preview then attachment.is_preview = true end
    if attachment.options.is_networked == nil and (attachment.root ~= nil and not attachment.root.is_preview) then
        attachment.options.is_networked = true
    end
    if attachment.options.is_mission_entity == nil then attachment.options.is_mission_entity = false end
    if attachment.options.is_invincible == nil then attachment.options.is_invincible = false end
    if attachment.options.is_bullet_proof == nil then attachment.options.is_bullet_proof = false end
    if attachment.options.is_fire_proof == nil then attachment.options.is_fire_proof = false end
    if attachment.options.is_explosion_proof == nil then attachment.options.is_explosion_proof = false end
    if attachment.options.is_melee_proof == nil then attachment.options.is_melee_proof = false end
    if attachment.options.is_light_on == nil then attachment.options.is_light_on = true end
    if attachment.options.use_soft_pinning == nil then attachment.options.use_soft_pinning = true end
    if attachment.options.bone_index == nil then attachment.options.bone_index = 0 end
    if attachment.options.is_dynamic == nil then attachment.options.is_dynamic = true end
    if attachment.options.lod_distance == nil then attachment.options.lod_distance = 16960 end
    if attachment.options.is_attached == nil then attachment.options.is_attached = (attachment ~= attachment.parent) end
    if attachment == attachment.parent then
        if attachment.blip_sprite == nil then attachment.blip_sprite = 1 end
        if attachment.blip_color == nil then attachment.blip_color = 2 end
    end
    if attachment.hash == nil and attachment.model ~= nil then
        attachment.hash = util.joaat(attachment.model)
    elseif attachment.model == nil and attachment.hash ~= nil then
        attachment.model = util.reverse_joaat(attachment.hash)
    end
    if attachment.name == nil then attachment.name = attachment.model end
    constructor_lib.default_vehicle_attributes(attachment)
    constructor_lib.default_ped_attributes(attachment)
end

constructor_lib.set_preview_visibility = function(attachment)
    local preview_alpha = attachment.alpha or 206
    if attachment.options.is_visible == false then preview_alpha = 0 end
    ENTITY.SET_ENTITY_ALPHA(attachment.handle, preview_alpha, false)
    ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, false, true)
    ENTITY.FREEZE_ENTITY_POSITION(attachment.handle, true)
end

constructor_lib.refresh_blip = function(attachment)
    if attachment ~= attachment.parent or attachment.is_preview then return end
    if attachment.blip_handle then util.remove_blip(attachment.blip_handle) end
    attachment.blip_handle = HUD.ADD_BLIP_FOR_ENTITY(attachment.handle)
    HUD.SET_BLIP_SPRITE(attachment.blip_handle, attachment.blip_sprite)
    HUD.SET_BLIP_COLOUR(attachment.blip_handle, attachment.blip_color)
end

constructor_lib.update_ped_attachment = function(attachment)
    if attachment.type ~= "PED" then return end
    --debug_log("Updating ped attachment "..tostring(attachment.name))
    if attachment.options.is_on_fire then
        FIRE.START_ENTITY_FIRE(attachment.handle)
        ENTITY.SET_ENTITY_PROOFS(
                attachment.handle,
                attachment.options.is_bullet_proof, true,
                attachment.options.is_explosion_proof, attachment.options.is_melee_proof,
                false, 0, false
        )
    else
        FIRE.STOP_ENTITY_FIRE(attachment.handle)
        ENTITY.SET_ENTITY_PROOFS(
                attachment.handle,
                attachment.options.is_bullet_proof, attachment.options.is_fire_proof,
                attachment.options.is_explosion_proof, attachment.options.is_melee_proof,
                false, 0, false
        )
    end
end

constructor_lib.update_attachment_tick = function(attachment)
    if attachment.options.is_frozen ~= nil then
        ENTITY.FREEZE_ENTITY_POSITION(attachment.handle, attachment.options.is_frozen)
    end
end

constructor_lib.update_attachment = function(attachment)
    --debug_log("Updating attachment "..tostring(attachment.name))

    if attachment.is_preview then
        constructor_lib.set_preview_visibility(attachment)
    else
        if attachment.options.alpha ~= nil and attachment.options.alpha < 255 then
            ENTITY.SET_ENTITY_ALPHA(attachment.handle, attachment.options.alpha, false)
            --if attachment.options.alpha == 0 and attachment.options.is_visible == true then
            --    attachment.options.is_visible = false
            --end
        end
        ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.options.is_visible, 0)
    end

    if attachment.options.is_dynamic ~= nil then ENTITY.SET_ENTITY_DYNAMIC(attachment.handle, attachment.options.is_dynamic) end
    if attachment.options.has_gravity ~= nil then ENTITY.SET_ENTITY_HAS_GRAVITY(attachment.handle, attachment.options.has_gravity) end
    if attachment.options.is_light_on == true then
        VEHICLE.SET_VEHICLE_SIREN(attachment.handle, true)
        VEHICLE.SET_VEHICLE_HAS_MUTED_SIRENS(attachment.handle, true)
        ENTITY.SET_ENTITY_LIGHTS(attachment.handle, false)
        AUDIO.TRIGGER_SIREN_AUDIO(attachment.handle, true)
        AUDIO.SET_SIREN_BYPASS_MP_DRIVER_CHECK(attachment.handle, true)
    end
    ENTITY.SET_ENTITY_PROOFS(
            attachment.handle,
            attachment.options.is_bullet_proof, attachment.options.is_fire_proof,
            attachment.options.is_explosion_proof, attachment.options.is_melee_proof,
            false, 0, false
    )
    --ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, attachment.options.has_collision, true)
    if attachment.options.radio_loud ~= nil then AUDIO.SET_VEHICLE_RADIO_LOUD(attachment.handle, attachment.options.radio_loud) end
    if attachment.options.lod_distance ~= nil then ENTITY.SET_ENTITY_LOD_DIST(attachment.handle, attachment.options.lod_distance) end

    --ENTITY.SET_ENTITY_ROTATION(attachment.handle, attachment.world_rotation.x, attachment.world_rotation.y, attachment.world_rotation.z, 2, true)

    if attachment.options.is_attached then
        if attachment.type == "PED" and attachment.parent.is_player then
            util.toast("Cannot attach ped to player. Spawning new ped "..tostring(attachment.name), TOAST_ALL)
        else
            if attachment == attachment.parent then
                debug_log("Cannot attach attachment to itself "..tostring(attachment.name))
            else
                debug_log("Attaching entity to entity "..tostring(attachment.name))
                ENTITY.ATTACH_ENTITY_TO_ENTITY(
                        attachment.handle, attachment.parent.handle, attachment.options.bone_index,
                        attachment.offset.x or 0, attachment.offset.y or 0, attachment.offset.z or 0,
                        attachment.rotation.x or 0, attachment.rotation.y or 0, attachment.rotation.z or 0,
                        false, attachment.options.use_soft_pinning, attachment.options.has_collision, false, 2, true
                )
            end
        end
    --else
    --    constructor_lib.update_attachment_position(attachment)
    end

    constructor_lib.update_ped_attachment(attachment)
end

constructor_lib.update_attachment_position = function(attachment)
    --debug_log("Updating attachment position "..tostring(attachment.name))
    if attachment == attachment.parent or not attachment.options.is_attached then
        ENTITY.SET_ENTITY_ROTATION(
                attachment.handle,
                attachment.world_rotation.x,
                attachment.world_rotation.y,
                attachment.world_rotation.z,
                2, true
        )
        if attachment.position ~= nil then
            if attachment.is_preview then
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(
                        attachment.handle,
                        attachment.position.x,
                        attachment.position.y,
                        attachment.position.z,
                        true, false, false
                )
                ENTITY.SET_ENTITY_ROTATION(
                        attachment.handle,
                        attachment.rotation.x,
                        attachment.rotation.y,
                        attachment.rotation.z,
                        2, true
                )
            else
                ENTITY.SET_ENTITY_COORDS(
                        attachment.handle,
                        attachment.position.x,
                        attachment.position.y,
                        attachment.position.z,
                        true, false, false
                )
            end
        end
    end
end

constructor_lib.load_hash_for_attachment = function(attachment)
    if not STREAMING.IS_MODEL_VALID(attachment.hash) then
        if not STREAMING.IS_MODEL_A_VEHICLE(attachment.hash) then
            error("Error attaching: Invalid model: " .. attachment.model)
            return false
        end
        attachment.type = "VEHICLE"
    end
    constructor_lib.load_hash(attachment.hash)
    return true
end

constructor_lib.build_parent_child_relationship = function(parent_attachment, child_attachment)
    child_attachment.parent = parent_attachment
    child_attachment.root = parent_attachment.root
end

constructor_lib.attach_attachment = function(attachment)
    constructor_lib.set_attachment_defaults(attachment)
    if attachment.is_player and not attachment.is_preview then
        if attachment.model then
            debug_log("Setting player model to "..tostring(attachment.model).." hash="..tostring(attachment.hash))
            constructor_lib.load_hash(attachment.hash)
            PLAYER.SET_PLAYER_MODEL(players.user(), attachment.hash)
            util.yield(100)
            attachment.handle = players.user_ped()
        else
            attachment.hash = ENTITY.GET_ENTITY_MODEL(players.user_ped())
            attachment.model = util.reverse_joaat(attachment.hash)
        end
        constructor_lib.deserialize_ped_attributes(attachment)
        return
    else
        debug_log("Attaching "..tostring(attachment.name).." to "..tostring(attachment.parent.name))
    end
    if attachment.hash == nil and attachment.model == nil then
        error(t("Cannot create attachment").." "..tostring(attachment.name)..": "..t("Requires either a hash or a model"))
    end
    if (not constructor_lib.load_hash_for_attachment(attachment)) then
        debug_log("Failed to load hash for attachment "..tostring(attachment.name))
        return
    end

    if attachment.root == nil then
        error(t("Attachment missing root"))
    end

    local is_networked = attachment.options.is_networked and not attachment.is_preview
    if attachment.type == "VEHICLE" then
        debug_log("Creating vehicle "..tostring(attachment.name))
        if is_networked then
            attachment.handle = entities.create_vehicle(attachment.hash, attachment.offset, attachment.heading)
        else
            attachment.handle = VEHICLE.CREATE_VEHICLE(
                    attachment.hash,
                    attachment.offset.x, attachment.offset.y, attachment.offset.z,
                    attachment.heading,
                    is_networked,
                    attachment.options.is_mission_entity,
                    false
            )
        end
        constructor_lib.deserialize_vehicle_attributes(attachment)
    elseif attachment.type == "PED" then
        debug_log("Creating ped "..tostring(attachment.name))
        local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(attachment.parent.handle, attachment.offset.x, attachment.offset.y, attachment.offset.z)
        if is_networked then
            attachment.handle = entities.create_ped(1, attachment.hash, pos, attachment.heading)
        else
            attachment.handle = PED.CREATE_PED(
                    1, attachment.hash,
                    pos.x, pos.y, pos.z,
                    attachment.heading,
                    is_networked,
                    attachment.options.is_mission_entity
            )
        end
        if attachment.parent.type == "VEHICLE" and attachment.ped_attributes and attachment.ped_attributes.is_seated then
            PED.SET_PED_INTO_VEHICLE(attachment.handle, attachment.parent.handle, -1)
        end
        constructor_lib.deserialize_ped_attributes(attachment)
    else
        debug_log("Creating object "..tostring(attachment.name))
        local pos
        if attachment.position ~= nil then
            pos = attachment.position
        else
            pos = ENTITY.GET_ENTITY_COORDS(attachment.root.handle)
        end
        if is_networked then
            -- breaks rotation!?!
            --attachment.handle = NETWORK.OBJ_TO_NET(entities.create_object(attachment.hash, pos))
            attachment.handle = entities.create_object(attachment.hash, pos)
        else
            attachment.handle = OBJECT.CREATE_OBJECT_NO_OFFSET(
                    attachment.hash,
                    pos.x, pos.y, pos.z,
                    is_networked,
                    attachment.options.is_mission_entity,
                    false
            )
        end
    end

    if not attachment.handle then
        error(t("Error attaching attachment. Could not create handle."))
    end

    if attachment.root.is_preview == true then constructor_lib.set_preview_visibility(attachment) end

    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(attachment.hash)

    if attachment.num_bones == nil or attachment.num_bones == 200 then attachment.num_bones = ENTITY.GET_ENTITY_BONE_COUNT(attachment.handle) end
    if attachment.type == nil then attachment.type = constructor_lib.ENTITY_TYPES[ENTITY.GET_ENTITY_TYPE(attachment.handle)] end
    if attachment.flash_start_on ~= nil then ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.flash_start_on, 0) end
    if attachment.options.is_invincible ~= nil then ENTITY.SET_ENTITY_INVINCIBLE(attachment.handle, attachment.options.is_invincible) end

    constructor_lib.update_attachment(attachment)
    constructor_lib.update_attachment_position(attachment)
    constructor_lib.set_attachment_internal_collisions(attachment.root, attachment)
    constructor_lib.refresh_blip(attachment)

    --if not attachment.is_preview then
    --    -- Pause for a tick between each model load to avoid loading too many at once
    --    --util.yield(2000)
    --end

    debug_log("Done attaching "..tostring(attachment.name))
    return attachment
end

constructor_lib.update_reflection_offsets = function(reflection)
    debug_log("Updating reflection offsets "..tostring(reflection.name))
    --- This function isn't quite right, it breaks with certain root rotations, but close enough for now
    reflection.offset = { x = 0, y = 0, z = 0 }
    reflection.rotation = { x = 0, y = 0, z = 0 }
    if reflection.reflection_axis.x then
        reflection.offset.x = reflection.parent.offset.x * -2
    end
    if reflection.reflection_axis.y then
        reflection.offset.y = reflection.parent.offset.y * -2
    end
    if reflection.reflection_axis.z then
        reflection.offset.z = reflection.parent.offset.z * -2
    end
end

constructor_lib.move_attachment = function(attachment)
    debug_log("Moving attachment "..tostring(attachment.name))
    if attachment.reflection then
        constructor_lib.update_reflection_offsets(attachment.reflection)
        constructor_lib.update_attachment(attachment.reflection)
    end
    constructor_lib.update_attachment(attachment)
    constructor_lib.update_attachment_position(attachment)
end

constructor_lib.detach_attachment = function(attachment)
    debug_log("Detaching attachment "..tostring(attachment.name))
    ENTITY.DETACH_ENTITY(attachment.handle, true, true)
    table.array_remove(attachment.parent.children, function(t, i)
        local child_attachment = t[i]
        return child_attachment ~= attachment
    end)
    attachment.root = attachment
    attachment.parent = attachment
end

constructor_lib.remove_attachment = function(attachment)
    debug_log("Reattaching attachment "..tostring(attachment.name))
    if not attachment then return end
    if attachment.children then
        table.array_remove(attachment.children, function(t, i)
            local child_attachment = t[i]
            constructor_lib.remove_attachment(child_attachment)
            return false
        end)
    end
    if not attachment.is_player or attachment.is_preview then
        if attachment == attachment.parent and attachment.blip_handle then util.remove_blip(attachment.blip_handle) end
        if not attachment.handle then
            util.log("Cannot remove attachment. No valid handle found. "..tostring(attachment.name))
            return
        end
        entities.delete_by_handle(attachment.handle)
        debug_log("Removed attachment. "..tostring(attachment.name))
    end
    if attachment.menus then
        for _, attachment_menu in pairs(attachment.menus) do
            -- Sometimes these menu handles are invalid but I don't know why,
            -- so wrap them in pcall to avoid errors if delete fails
            pcall(function() menu.delete(attachment_menu) end)
        end
    end
end

constructor_lib.remove_attachment_from_parent = function(attachment)
    debug_log("Removing attachment from parent "..tostring(attachment.name))
    if attachment == attachment.parent then
        constructor_lib.remove_attachment(attachment)
    elseif attachment.parent ~= nil then
        table.array_remove(attachment.parent.children, function(t, i)
            local child_attachment = t[i]
            if child_attachment.handle == attachment.handle then
                constructor_lib.remove_attachment(attachment)
                return false
            end
            return true
        end)
        attachment.parent.menus.refresh()
        attachment.parent.menus.focus()
    end
end

constructor_lib.reattach_attachment_with_children = function(attachment)
    debug_log("Reattaching attachment with children "..tostring(attachment.name))
    constructor_lib.attach_attachment(attachment)
    for _, child_attachment in pairs(attachment.children) do
        child_attachment.root = attachment.root
        child_attachment.parent = attachment
        constructor_lib.reattach_attachment_with_children(child_attachment)
    end
end

constructor_lib.attach_attachment_with_children = function(new_attachment)
    debug_log("Attaching attachment with children "..tostring(new_attachment.name))
    for key, value in pairs(constructor_lib.construct_base) do
        if new_attachment[key] == nil then
            new_attachment[key] = table.table_copy(value)
        end
    end
    local attachment = constructor_lib.attach_attachment(new_attachment)
    if not attachment then return end
    if attachment.children then
        for _, child_attachment in pairs(attachment.children) do
            constructor_lib.build_parent_child_relationship(attachment, child_attachment)
            if child_attachment.flash_model then
                child_attachment.flash_start_on = (not child_attachment.parent.flash_start_on)
            end
            if child_attachment.reflection_axis then
                constructor_lib.update_reflection_offsets(child_attachment)
            end
            constructor_lib.attach_attachment_with_children(child_attachment)
        end
    end
    return attachment
end

constructor_lib.add_attachment_to_construct = function(attachment)
    debug_log("Adding attachment to construct "..tostring(attachment.name))
    constructor_lib.attach_attachment_with_children(attachment)
    table.insert(attachment.parent.children, attachment)
    attachment.root.menus.refresh(attachment)
end

constructor_lib.copy_construct_plan = function(construct_plan)
    local is_root = construct_plan == construct_plan.parent
    construct_plan.root = nil
    construct_plan.parent = nil
    local construct = table.table_copy(construct_plan)
    if is_root then
        construct.root = construct
        construct.parent = construct
    end
    return construct
end

constructor_lib.clone_attachment = function(attachment)
    debug_log("Cloning attachment "..tostring(attachment.name))
    if attachment.type == "VEHICLE" then
        attachment.heading = ENTITY.GET_ENTITY_HEADING(attachment.handle) or 0
    end
    local clone = constructor_lib.serialize_attachment(attachment)
    if attachment == attachment.parent then
        clone.root = clone
        clone.parent = clone
    else
        clone.root = attachment.root
        clone.parent = attachment.parent
    end
    debug_log("Cloned "..tostring(attachment.name), clone)
    return clone
end

---
--- Serializers
---

constructor_lib.default_vehicle_attributes = function(vehicle)
    if vehicle.type ~= "VEHICLE" then return end
    debug_log("Defaulting vehicle attributes "..tostring(vehicle.name))
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.paint == nil then vehicle.vehicle_attributes.paint = {} end
    if vehicle.vehicle_attributes.paint.primary == nil then vehicle.vehicle_attributes.paint.primary = {} end
    if vehicle.vehicle_attributes.paint.secondary == nil then vehicle.vehicle_attributes.paint.secondary = {} end
    if vehicle.vehicle_attributes.paint.primary.custom_color == nil then vehicle.vehicle_attributes.paint.primary.custom_color = {} end
    if vehicle.vehicle_attributes.paint.secondary.custom_color == nil then vehicle.vehicle_attributes.paint.secondary.custom_color = {} end
    if vehicle.vehicle_attributes.paint.dirt_level == nil then vehicle.vehicle_attributes.paint.dirt_level = 0 end
    if vehicle.vehicle_attributes.paint.extra_colors == nil then vehicle.vehicle_attributes.paint.extra_colors = {} end
    if vehicle.vehicle_attributes.neon == nil then vehicle.vehicle_attributes.neon = {} end
    if vehicle.vehicle_attributes.neon.lights == nil then vehicle.vehicle_attributes.neon.lights = {} end
    if vehicle.vehicle_attributes.neon.color == nil then vehicle.vehicle_attributes.neon.color = {} end
    if vehicle.vehicle_attributes.wheels == nil then vehicle.vehicle_attributes.wheels = {} end
    if vehicle.vehicle_attributes.wheels.tires_burst == nil then vehicle.vehicle_attributes.wheels.tires_burst = {} end
    if vehicle.vehicle_attributes.wheels.tire_smoke_color == nil then vehicle.vehicle_attributes.wheels.tire_smoke_color = {} end
    if vehicle.vehicle_attributes.headlights == nil then vehicle.vehicle_attributes.headlights = {} end
    if vehicle.vehicle_attributes.options == nil then vehicle.vehicle_attributes.options = {} end
    if vehicle.vehicle_attributes.extras == nil then vehicle.vehicle_attributes.extras = {} end
    if vehicle.vehicle_attributes.doors == nil then vehicle.vehicle_attributes.doors = {} end
    if vehicle.vehicle_attributes.doors.broken == nil then vehicle.vehicle_attributes.doors.broken = {} end
    if vehicle.vehicle_attributes.doors.open == nil then vehicle.vehicle_attributes.doors.open = {} end
    if vehicle.vehicle_attributes.mods == nil then vehicle.vehicle_attributes.mods = {} end
end

constructor_lib.serialize_vehicle_attributes = function(vehicle)
    if vehicle.type ~= "VEHICLE" then return end
    debug_log("Serializing vehicle attributes "..tostring(vehicle.name))
    constructor_lib.default_vehicle_attributes(vehicle)
    if not ENTITY.DOES_ENTITY_EXIST(vehicle.handle) then return end
    debug_log("Serializing vehicle attributes "..tostring(vehicle.name))
    constructor_lib.serialize_vehicle_paint(vehicle)
    constructor_lib.serialize_vehicle_neon(vehicle)
    constructor_lib.serialize_vehicle_wheels(vehicle)
    constructor_lib.serialize_vehicle_headlights(vehicle)
    constructor_lib.serialize_vehicle_options(vehicle)
    constructor_lib.serialize_vehicle_mods(vehicle)
    constructor_lib.serialize_vehicle_extras(vehicle)
end

constructor_lib.deserialize_vehicle_attributes = function(vehicle)
    if vehicle.vehicle_attributes == nil then return end
    debug_log("Deserializing vehicle attributes "..tostring(vehicle.name))

    VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)
    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle.handle, true, true)    -- Needed for plate text

    constructor_lib.deserialize_vehicle_neon(vehicle)
    constructor_lib.deserialize_vehicle_paint(vehicle)
    constructor_lib.deserialize_vehicle_wheels(vehicle)
    constructor_lib.deserialize_vehicle_doors(vehicle)
    constructor_lib.deserialize_vehicle_headlights(vehicle)
    constructor_lib.deserialize_vehicle_options(vehicle)
    constructor_lib.deserialize_vehicle_mods(vehicle)
    constructor_lib.deserialize_vehicle_extras(vehicle)
end

constructor_lib.default_ped_attributes = function(attachment)
    if attachment.type ~= "PED" then return end
    debug_log("Defaulting ped attributes "..tostring(attachment.name))
    if attachment.ped_attributes == nil then attachment.ped_attributes = {} end
    if attachment.ped_attributes.armor == nil then attachment.ped_attributes.armor = 0 end
    if attachment.ped_attributes.props == nil then attachment.ped_attributes.props = {} end
    if attachment.ped_attributes.components == nil then attachment.ped_attributes.components = {} end
    for prop_index = 0, 9 do
        if attachment.ped_attributes.props["_"..prop_index] == nil then attachment.ped_attributes.props["_"..prop_index] = {} end
        if attachment.ped_attributes.props["_"..prop_index].drawable_variation == nil then attachment.ped_attributes.props["_"..prop_index].drawable_variation = -1 end
        if attachment.ped_attributes.props["_"..prop_index].texture_variation == nil then attachment.ped_attributes.props["_"..prop_index].texture_variation = 0 end
        attachment.ped_attributes.props["_"..prop_index].num_drawable_variations = PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS(attachment.handle, prop_index) - 1
        attachment.ped_attributes.props["_"..prop_index].num_texture_variations = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(attachment.handle, prop_index, attachment.ped_attributes.props["_"..prop_index].drawable_variation) - 1
    end
    for component_index = 0, 11 do
        if attachment.ped_attributes.components["_"..component_index] == nil then attachment.ped_attributes.components["_"..component_index] = {} end
        if attachment.ped_attributes.components["_"..component_index].drawable_variation == nil then attachment.ped_attributes.components["_"..component_index].drawable_variation = 0 end
        if attachment.ped_attributes.components["_"..component_index].texture_variation == nil then attachment.ped_attributes.components["_"..component_index].texture_variation = 0 end
        if attachment.ped_attributes.components["_"..component_index].palette_variation == nil then attachment.ped_attributes.components["_"..component_index].palette_variation = 1 end
        attachment.ped_attributes.components["_"..component_index].num_drawable_variations = PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(attachment.handle, component_index) - 1
        attachment.ped_attributes.components["_"..component_index].num_texture_variations = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(attachment.handle, component_index, attachment.ped_attributes.components["_".. component_index].drawable_variation) - 1
    end
end

constructor_lib.serialize_ped_attributes = function(attachment)
    if attachment.type ~= "PED" then return end
    debug_log("Serializing ped attributes "..tostring(attachment.name))
    constructor_lib.default_ped_attributes(attachment)
    attachment.hash = ENTITY.GET_ENTITY_MODEL(attachment.handle)
    for index = 0, 9 do
        attachment.ped_attributes.props["_"..index] = {
            drawable_variation = PED.GET_PED_PROP_INDEX(attachment.handle, index),
            texture_variation = PED.GET_PED_PROP_TEXTURE_INDEX(attachment.handle, index)
        }
    end
    for index = 0, 11 do
        attachment.ped_attributes.components["_"..index] = {
            drawable_variation = PED.GET_PED_DRAWABLE_VARIATION(attachment.handle, index),
            texture_variation = PED.GET_PED_TEXTURE_VARIATION(attachment.handle, index),
            palette_variation = PED.GET_PED_PALETTE_VARIATION(attachment.handle, index),
        }
    end
end

constructor_lib.deserialize_ped_attributes = function(attachment)
    debug_log("Deserializing ped attributes "..tostring(attachment.name))
    if attachment.ped_attributes == nil then return end
    if attachment.ped_attributes.can_rag_doll ~= nil then
        PED.SET_PED_CAN_RAGDOLL(attachment.handle, attachment.ped_attributes.can_rag_doll)
    end
    if attachment.ped_attributes.weapon_hash == nil and attachment.ped_attributes.weapon ~= nil then
        attachment.ped_attributes.weapon_hash = util.joaat(attachment.ped_attributes.weapon)
        debug_log("Setting weapon hash "..tostring(attachment.ped_attributes.weapon_hash))
    end
    if attachment.ped_attributes.weapon_hash ~= nil then
        constructor_lib.load_hash(attachment.ped_attributes.weapon_hash)
        debug_log("Setting current weapon "..attachment.ped_attributes.weapon_hash)
        util.toast("Setting current weapon "..attachment.ped_attributes.weapon_hash, TOAST_ALL)
        --WEAPON.GIVE_WEAPON_TO_PED(attachment.handle, attachment.ped_attributes.weapon_hash, 1, false, true)
        --WEAPON.SET_CURRENT_PED_WEAPON(attachment.handle, attachment.ped_attributes.weapon_hash, true)
    end
    --if attachment.ped_attributes.weapon then
    --end
    if attachment.ped_attributes.armour then
        PED.SET_PED_ARMOUR(attachment.handle, attachment.ped_attributes.armour)
    end
    if attachment.options.is_on_fire == true then
        FIRE.START_ENTITY_FIRE(attachment.handle)
        ENTITY.SET_ENTITY_PROOFS(
                attachment.handle,
                attachment.options.is_bullet_proof, true,
                attachment.options.is_explosion_proof, attachment.options.is_melee_proof,
                false, 0, false
        )
    else
        FIRE.STOP_ENTITY_FIRE(attachment.handle)
        ENTITY.SET_ENTITY_PROOFS(
                attachment.handle,
                attachment.options.is_bullet_proof, attachment.options.is_fire_proof,
                attachment.options.is_explosion_proof, attachment.options.is_melee_proof,
                false, 0, false
        )
    end
    if attachment.ped_attributes.props ~= nil then
        for index = 0, 9 do
            local prop = attachment.ped_attributes.props["_".. index]
            if prop ~= nil then
                if prop.drawable_variation >= 0 then
                    PED.SET_PED_PROP_INDEX(
                            attachment.handle,
                            index,
                            tonumber(prop.drawable_variation),
                            tonumber(prop.texture_variation),
                            true
                    )
                else
                    PED.CLEAR_PED_PROP(attachment.handle, index)
                end
                prop.num_drawable_variations = PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS(attachment.handle, index) - 1
                prop.num_texture_variations = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(attachment.handle, index, prop.drawable_variation) - 1
            end
        end
    end
    if attachment.ped_attributes.components ~= nil then
        for index = 0, 11 do
            local component = attachment.ped_attributes.components["_".. index]
            if component ~= nil then
                PED.SET_PED_COMPONENT_VARIATION(
                        attachment.handle,
                        index,
                        tonumber(component.drawable_variation),
                        tonumber(component.texture_variation),
                        tonumber(component.palette_variation)
                )
                component.num_drawable_variations = PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(attachment.handle, index) - 1
                component.num_texture_variations = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(attachment.handle, index, attachment.ped_attributes.components["_".. index].drawable_variation) - 1
            end
        end
    end
    constructor_lib.animate_peds(attachment)
end

constructor_lib.copy_serializable = function(attachment)
    debug_log("Copying serializable "..tostring(attachment.name))
    local serializeable_attachment = {
        children = {}
    }
    for k, v in pairs(attachment) do
        if not (
            k == "handle" or k == "root" or k == "parent" or k == "menus" or k == "children" or k == "temp" or k == "load_menu" or k == "menu_auto_focus"
            or k == "is_preview" or k == "is_editing" or k == "dimensions" or k == "camera_distance" or k == "heading"
        ) then
            serializeable_attachment[k] = table.table_copy(v)
        end
    end
    return serializeable_attachment
end

constructor_lib.serialize_attachment = function(attachment)
    debug_log("Serializing attachment "..tostring(attachment.name))
    if attachment.target_version == nil then attachment.target_version = constructor_lib.LIB_VERSION end
    constructor_lib.serialize_vehicle_attributes(attachment)
    constructor_lib.serialize_ped_attributes(attachment)
    local serialized_attachment = constructor_lib.copy_serializable(attachment)
    if attachment.children then
        for _, child_attachment in pairs(attachment.children) do
            if not child_attachment.options.is_temporary then
                table.insert(serialized_attachment.children, constructor_lib.serialize_attachment(child_attachment))
            end
        end
    end
    --debug_log("Serialized attachment "..inspect(serialized_attachment))
    return serialized_attachment
end

---
--- Return
---

return constructor_lib
