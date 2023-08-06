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
local tableBlackHole = {"Black", "White",}
local pushStrength = 1
local pushToX = 1
local pushToY = 1
local pushToZ = 1

-- toggle on and off the blackHole
local blackHoleMenu = menu.toggle(root, "Black hole toggle", {}, "", function(a)
    blackHole = a
end)

-- toggle if the visualHelp is visible at the center of the blackHole
local visualHelpMenu = menu.toggle_loop(root, "Visual help", {}, "spawn an entity at the center of the blackhole (doesn't have colision)", function(a)
    GRAPHICS.DRAW_MARKER_SPHERE(blackHolePos.x, blackHolePos.y, blackHolePos.z, 2, 0, 0, 0, 0.8)
end)

local blackHoleTypeMenu = menu.list_select(root, "Black hole type ", {}, "Choose if you want it to pull (blackhole) or push (whitehole) vehicles arround", tableBlackHole, 1, function(a)
    a -= 1
    if a == 0 then
        blackHoleType = "pull"
    elseif a == 1 then
        blackHoleType = "push"
    end
end)

local pushStrengthMenu = menu.slider(root, "Set blackhole strength", {}, "Set the strength of the pull or push (being too close with force set to 100 make you glitch throught the map) I recommend a strength between 5 and 10", 1, 100, 1, 1, function(a)
    pushStrength = a
end)


local blackHolePosX = menu.slider(root, "Blackhole position X", {"coordBlackHoleX"}, "Set the coord of the blackhole in the X axis of the map", -100000, 100000, 0, 1, function(a)
    blackHolePos.x = a
end)

local blackHolePosY = menu.slider(root, "Blackhole position Y", {"coordBlackHoleY"}, "Set the coord of the blackhole in the Y axis of the map", -100000, 100000, 0, 1, function(a)
    blackHolePos.y = a
end)

local blackHolePosZ = menu.slider(root, "Blackhole position Z", {"coordBlackHoleZ"}, "Set the coord of the blackhole in the Z axis of the map", -100000, 100000, 0, 1, function(a)
    blackHolePos.z = a
end)

menu.action(root, "Set blackhole position here", {}, "Set the position of the blackhole at your ped current location", function()
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


menu.action(root, "Made by ! ! D0uze#1576", {}, "Click to copy to clipboard", function()
    util.copy_to_clipboard("! ! D0uze#1576")
end)

local thx = menu.list(root, "THANKS / OTHER", {}, "")
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
    player:toggle_loop("Attach to player "..players.get_name(pid), {}, "", function()
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
    player:slider("Blackhole strength", {}, "", 1, 100, 1, 1, function(a)
        pushStrengthMenu.value = a
    end)
end



for _,pid in pairs(players.list()) do
    PlayerMenu(pid)
end
players.on_join(PlayerMenu)
