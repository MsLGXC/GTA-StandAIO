-- 0.1

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

auto_updater.run_auto_update({
    source_url="https://raw.githubusercontent.com/D0uze57/BlackHole/main/12s Black Hole.lua",
    script_relpath=SCRIPT_RELPATH,
    verify_file_begins_with="--"
})

util.keep_running()
util.require_natives(1663599433)
local root = menu.my_root()
local yourself
local yourselfCoord = {x=0,y=0,z=0}
local visualHelp = false
local visualHelpEnt
local entityToSpawn = util.joaat("prop_mk_sphere")
local blackHole = false
local blackHoleType = "pull"
local blackHoleVehicle
local blackHolePos = {x = 0, y = 0, z = 0}
local vehiclePos = {x = 0, y = 0, z = 0}
local tableBlackHole = {"黑洞", "白洞",}
local pushStrength = 1
local pushToX = 1
local pushToY = 1
local pushToZ = 1

-- toggle on and off the blackHole
local blackHoleMenu = menu.toggle(root, "黑洞切换", {}, "", function(a)
    blackHole = a
end)

-- toggle if the visualHelp is visible at the center of the blackHole
local visualHelpMenu = menu.toggle_loop(root, "视觉帮助", {}, "在黑洞中心产生一个实体（没有碰撞）.", function(a)
    GRAPHICS.DRAW_MARKER_SPHERE(blackHolePos.x, blackHolePos.y, blackHolePos.z, 2, 0, 0, 0, 0.8)
end)

local blackHoleTypeMenu = menu.list_select(root, "黑洞类型 ", {}, "选择你想让它拉（黑洞）或推（白洞）车辆到周围", tableBlackHole, 1, function(a)
    a -= 1
    if a == 0 then
        blackHoleType = "pull"
    elseif a == 1 then
        blackHoleType = "push"
    end
end)

local pushStrengthMenu = menu.slider(root, "设置黑洞强度", {}, "设置拉或推的力度（如果力度设置为100，太近的话会使你在地图上滑行），我建议力度在5到10之间.", 1, 100, 1, 1, function(a)
    pushStrength = a
end)


local blackHolePosX = menu.slider(root, "黑洞位置X", {"coordBlackHoleX"}, "设置黑洞在地图X轴上的坐标", -100000, 100000, 0, 1, function(a)
    blackHolePos.x = a
end)

local blackHolePosY = menu.slider(root, "黑洞位置Y", {"coordBlackHoleY"}, "设置黑洞在地图Y轴上的坐标", -100000, 100000, 0, 1, function(a)
    blackHolePos.y = a
end)

local blackHolePosZ = menu.slider(root, "黑洞位置Z", {"coordBlackHoleZ"}, "设置黑洞在地图Z轴上的坐标", -100000, 100000, 0, 1, function(a)
    blackHolePos.z = a
end)

menu.action(root, "在此位置设置黑洞", {}, "将黑洞的位置设置在你的人物当前位置", function()
    -- get your ped coord and make it the blackHole coord
    blackHolePos.x = yourselfCoord.x
    blackHolePos.y = yourselfCoord.y
    blackHolePos.z = yourselfCoord.z
    -- math.floor because menu.slider deosn't like float and make an error so we round it
    blackHolePosX.value = math.floor(blackHolePos.x)
    blackHolePosY.value = math.floor(blackHolePos.y)
    blackHolePosZ.value = math.floor(blackHolePos.z)
end)

-- Could make an entity ignore filter
-- but I'm too lazy to do it
-- just stay on foot everything will be fine...
-- if a car doesn't hit you at mach 5
util.create_tick_handler(function()
    yourself = PLAYER.GET_PLAYER_PED(players.user())
    yourselfCoord = ENTITY.GET_ENTITY_COORDS(yourself)
    if blackHole == true then
        blackHoleVehicle = entities.get_all_vehicles_as_handles()
        for index, value in ipairs(blackHoleVehicle) do
            vehiclePos = ENTITY.GET_ENTITY_COORDS(value)
            if ENTITY.DOES_ENTITY_EXIST(value) == true then
                if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(value) == false then
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(value)
                end

                if blackHoleType == "pull" then
                    -- still dont know how I got the idea to make it
                    -- but it work maybe not that good but it's good enough for me
                    -- should use trigo to get the angle then calculate the force for x,y,z but it might make it laggier..
                    -- and I don't know how to make that yet
                    if blackHolePos.x > vehiclePos.x then
                        pushToX = pushStrength
                    elseif blackHolePos.x < vehiclePos.x then
                        pushToX = -pushStrength
                    end
                    if blackHolePos.y > vehiclePos.y then
                        pushToY = pushStrength
                    elseif blackHolePos.y < vehiclePos.y then
                        pushToY = -pushStrength
                    end
                    if blackHolePos.z > vehiclePos.z then
                        pushToZ = pushStrength
                    elseif blackHolePos.z < vehiclePos.z then
                        pushToZ = -pushStrength
                    end
                    ENTITY.APPLY_FORCE_TO_ENTITY(value, 1, pushToX, pushToY, pushToZ, 0, 0, 0, 0, false, true, true, false)
                elseif blackHoleType == "push" then
                    if blackHolePos.x > vehiclePos.x then
                        pushToX = -pushStrength
                    elseif blackHolePos.x < vehiclePos.x then
                        pushToX = pushStrength
                    end
                    if blackHolePos.y > vehiclePos.y then
                        pushToY = -pushStrength
                    elseif blackHolePos.y < vehiclePos.y then
                        pushToY = pushStrength
                    end
                    if blackHolePos.z > vehiclePos.z then
                        pushToZ = -pushStrength
                    elseif blackHolePos.z < vehiclePos.z then
                        pushToZ = pushStrength
                    end
                    ENTITY.APPLY_FORCE_TO_ENTITY(value, 1, pushToX, pushToY, pushToZ, 0, 0, 0, 0, false, true, true, false)
                end
            end
        end
    end
end)


menu.action(root, "制作者 ! ! D0uze#1576", {}, "点击复制到剪贴板", function()
    util.copy_to_clipboard("! ! D0uze#1576")
end)

local thx = menu.list(root, "感谢/其他", {}, "")
menu.divider(thx, "THANKS TO")
menu.action(thx, "hexarobi#3822", {}, "Explained how to set value in a slider/anything", function()end)
menu.action(thx, "Lance", {}, "For making me want to learn lua by making a blackhole in his script", function()end)
menu.action(thx, "And thank you for using my script ! <3", {}, "", function()end)
menu.divider(thx, "OTHER")
menu.action(thx, "If you can make this better please do", {}, "", function()end)
menu.action(thx, "and show it to me !", {}, "", function()end) -- maybe credit me too ?





PlayerMenu = function(pid)
    local player = menu.player_root(pid)
    player:divider("12's Blackhole")
    player:toggle_loop("附加黑洞 "..players.get_name(pid), {}, "", function()
        local playerCoord = players.get_position(pid)
        blackHolePos.x = playerCoord.x
        blackHolePos.y = playerCoord.y
        blackHolePos.z = playerCoord.z

        blackHolePosX.value = math.floor(blackHolePos.x)
        blackHolePosY.value = math.floor(blackHolePos.y)
        blackHolePosZ.value = math.floor(blackHolePos.z)

        visualHelpMenu.value = false
        blackHoleMenu.value = true
        blackHoleTypeMenu.value = 1

        util.yield(5)
    end, function ()
        blackHoleMenu.value = false
    end)
    player:slider("黑洞强度", {}, "", 1, 100, 1, 1, function(a)
        pushStrengthMenu.value = a
    end)
end



for _,pid in pairs(players.list()) do
    PlayerMenu(pid)
end
players.on_join(PlayerMenu)
