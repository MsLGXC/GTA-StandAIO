-- BallDrop
-- by BigTuna76
-- A Lua Script for the Stand mod menu for GTA5
-- A silly utility that unleashed hordes of oversized soccer balls
-- Special thanks to hexarobi for allowing me to steal much of the content of this script
-- https://github.com/bigtuna76/stand-lua-balldrop

local SCRIPT_VERSION = "0.2b"

---
--- Auto-Updater Lib Install
---

-- Auto Updater from https://github.com/hexarobi/stand-lua-auto-updater
local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
            function(result, headers, status_code)
                local function parse_auto_update_result(result, headers, status_code)
                    local error_prefix = "Error downloading auto-updater: "
                    if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                    if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                    filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                    local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                    if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                    file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
                end
                auto_update_complete = parse_auto_update_result(result, headers, status_code)
            end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

local auto_update_config = {
    source_url="https://raw.githubusercontent.com/bigtuna76/stand-lua-balldrop/main/BallDrop.lua",
    script_relpath=SCRIPT_RELPATH,
    verify_file_begins_with="--",
    check_interval=604800,
    dependencies={}
}

util.require_natives(1651208000)

local config = {
    ball_lifetime = 30000,
    hail_delay = 250,
    max_rain_distance = 3,
    min_rain_height = 2,
    max_rain_height = 30
}

local spawned_objects = {}

local ball_models = {
    "stt_prop_stunt_soccer_sball",
    "stt_prop_stunt_soccer_lball",
    "stt_prop_stunt_soccer_ball"
}

local function array_remove(t, fnKeep)
    local j, n = 1, #t;
    for i=1,#t do
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

local function load_hash(hash)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        util.yield()
    end
end

local function cleanup_expired_objects()
    spawned_objects = array_remove(spawned_objects, function(t, i)
        local spawned_object = t[i]
        local lifetime = util.current_time_millis() - spawned_object.spawn_time
        local allowed_lifetime = config.ball_lifetime
        if util.current_time_millis() > spawned_object.death_time then
            entities.delete_by_handle(spawned_object.handle)
            if ENTITY.DOES_ENTITY_EXIST(spawned_object.handle) then
                util.toast("Delete failed!")
            end
            return false
        end
        return true
    end)
end

local function delete_all_objects()
    local ball_count = 0
    -- Mark balls we know about for death
    for i, spawned_object in pairs(spawned_objects) do
        spawned_object.death_time = util.current_time_millis()
        ball_count = ball_count + 1
    end
    -- Find any orphaned balls and remove them too
    local all_objects = entities.get_all_objects_as_handles()
    for _, ball_model in pairs(ball_models) do
        local ball_hash = util.joaat(ball_model)
        for _, object in pairs(all_objects) do
            local object_hash = ENTITY.GET_ENTITY_MODEL(object)
            if object_hash == ball_hash then
                entities.delete_by_handle(object)
                ball_count = ball_count + 1
            end
        end
    end

    util.toast("打扫了 "..ball_count.." 个球")
end

local function spawn_object_at_pos(pos, model)
    local pickup_hash = util.joaat(model)
    load_hash(pickup_hash)
    local pickup_pos = v3.new(pos.x, pos.y, pos.z)
    local pickup = entities.create_object(pickup_hash, pickup_pos, true)
    ENTITY.SET_ENTITY_COLLISION(pickup, true, true)
    ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(
        pickup, 5, 0, 0, 1,
        true, false, true, true
    )
    local spawned_object = {
        handle=pickup,
        spawn_time=util.current_time_millis(),
        death_time=util.current_time_millis() + config.ball_lifetime
    }
    table.insert(spawned_objects, spawned_object)
end

local function nearby_position(pos, range)
    if range == nil then
        range = {
            x_max=1, y_max=1, z_max=1,
            x_min=-1, y_min=-1, z_min=0,
        }
    end
    return {
        x=pos.x + math.random(range.x_min, range.x_max),
        y=pos.y + math.random(range.y_min, range.y_max),
        z=pos.z + math.random(range.z_min, range.z_max),
    }
end

local function get_drop_range()
    return {
        x_max=config.max_rain_distance, y_max=config.max_rain_distance, z_max=config.max_rain_height,
        x_min=config.max_rain_distance * -1, y_min=config.max_rain_distance * -1, z_min=config.min_rain_height,
    }
end

local function get_random_ball()
    return ball_models[math.random(1, #ball_models)]
end

local function ball_drop(position, range, model)
    local spawn_position = position
    if range then
        spawn_position = nearby_position(position, range)
    end
    if model == nil then
        model = get_random_ball()
    end
    spawn_object_at_pos(spawn_position, model)
end

local function balldrop_player(pid)
    local position = players.get_position(pid)
    local range = get_drop_range()
    ball_drop(position, range)
end

------
------ Menus
------

--- 
--- Main
---

menu.action(menu.my_root(), "落球", {"balldrop"}, "掉落一个足球", function()
    ball_drop(players.get_position(players.user()), get_drop_range())
end)

menu.toggle_loop(menu.my_root(), "混乱", {"ballhail"}, "掉落大量足球", function()
    balldrop_player(players.user())
    util.yield(config.hail_delay)
end)

---
--- Other players
---

player_menu_actions = function(pid)
    menu.divider(menu.player_root(pid), "BallDrop")

    menu.action(menu.player_root(pid), "落球", {"balldrop"}, "", function()
        balldrop_player(pid)
    end)

    menu.toggle_loop(menu.player_root(pid), "混乱", {"ballhail"}, "", function()
        balldrop_player(pid)
        util.yield(config.hail_delay)
    end)

end
players.on_join(player_menu_actions)
players.dispatch_on_join()

---
--- Configuration
---

local options_menu = menu.list(menu.my_root(), "配置")

menu.slider(options_menu, "落球延迟", {}, "每次落球之间的时间", 200, 500, config.hail_delay, 10, function (value)
    config.hail_delay = value
end)

menu.slider(options_menu, "球存在时间", {}, "球落下来后多久才会消失", 500, 60000, config.ball_lifetime, 250, function (value)
    config.ball_lifetime = value
end)

menu.slider(options_menu, "球距离", {}, "玩家与球的最大距离", 1, 20, config.max_rain_distance, 1, function (value)
    config.max_rain_distance = value
end)
menu.slider(options_menu, "球最大高度", {}, "玩家与球的最大高度", 1, 30, config.max_rain_distance, 1, function (value)
    config.max_rain_height = value
end)
menu.slider(options_menu, "球最小高度", {}, "玩家与球的最小高度", 0, 20, config.min_rain_height, 1, function (value)
    config.min_rain_height = value
end)

---
--- Utilities
---

local options_menu = menu.list(menu.my_root(), "其他")

menu.action(options_menu, "清理", {"cleanup"}, "清理球", delete_all_objects)

menu.action(options_menu, "检查更新", {}, "脚本每天都会自动检查更新，但你可以随时使用这个选项手动检查.", function()
    auto_update_config.check_interval = 0
    if auto_updater.run_auto_update(auto_update_config) then
        util.toast("没更新")
    end
end)

---
--- Script Meta
---

local script_meta_menu = menu.list(menu.my_root(), "支持")

menu.divider(script_meta_menu, SCRIPT_NAME:gsub(".lua", ""))
menu.readonly(script_meta_menu, "版本", SCRIPT_VERSION)
menu.hyperlink(script_meta_menu, "来源", "https://github.com/bigtuna76/stand-lua-balldrop", "在Github上查看源代码")


util.create_tick_handler(function()
    if spawned_objects then
        cleanup_expired_objects()
    end
    return true
end)
