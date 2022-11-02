-- Train Control - 1.0
-- Created By Jackz

require("natives-1627063482")

local models = {
    util.joaat("metrotrain"), util.joaat("freight"), util.joaat("freightcar"), util.joaat("freightcont1"), util.joaat("freightcont2"), util.joaat("freightgrain"), util.joaat("tankercar")
}
local variations = {
    "Variation 1", "Variation 2", "Variation 3", "Variation 4", "Variation 5", "Variation 6", "Variation 7", "Variation 8", "Variation 9", "Variation 10", "Variation 11", "Variation 12", "Variation 13", "Variation 14", "Variation 15", "Variation 16", "Variation 17", "Variation 18", "Variation 19", "Variation 20", "Variation 21", "Variation 22"
}

local last_train = 0
local last_train_menu = 0
    
local thanks_list = menu.list(menu.my_root(), "本脚本由Vermouth汉化",{},"玩的开心！！！")
local spawnedMenu = menu.list(menu.my_root(), "列车管理", {}, "")

for _, model in ipairs(models) do
    STREAMING.REQUEST_MODEL(model)
    while not STREAMING.HAS_MODEL_LOADED(model) do
        util.yield()
    end
end

local function spawn_train(variation, pos) 
    local train = VEHICLE.CREATE_MISSION_TRAIN(variation, pos.x, pos.y, pos.z, 0)
    last_train = train
    
    local posTrain = ENTITY.GET_ENTITY_COORDS(last_train)
    local netid = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(veh)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(netid)
    NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netid, false)
    -- Setup menu actions (set speed, delete, etc)
    local submenu = menu.list(spawnedMenu, "Train " .. last_train, {"train" .. last_train}, "") 
    menu.click_slider(submenu, "速度", {"setspeedtrain" .. last_train}, "设置这个产生的火车速度.数值超过+/- 80将导致玩家向后滑动.倒车的火车看起来与其他玩家不同步.", -250, 250, 10, 5, function(value, prev)
        VEHICLE.SET_TRAIN_CRUISE_SPEED(train, value)
        VEHICLE.SET_TRAIN_SPEED(train, value)
    end)

    menu.toggle(submenu, "出轨", {"derailtrain" .. last_train}, "看火车出轨", function(on)
        VEHICLE.SET_RENDER_TRAIN_AS_DERAILED(train, on)
    end, false)

    menu.action(submenu, "删除引擎", {"deleteengine" .. last_train}, "删除产生的火车引擎", function(v)
        util.delete_entity(train)
    end)

    menu.action(submenu, "删除", {"deletetrain" .. last_train}, "删除这个产生的火车", function(v)
        for i = 0,100 do
            local cart = VEHICLE.GET_TRAIN_CARRIAGE(train, i)
            util.delete_entity(cart)
        end
        util.delete_entity(train)
        if last_train == train then
            last_train = 0
            last_train_menu = 0
        end
        menu.delete(submenu)
    end)

    util.toast(string.format("Train spawned at (%.1f, %.1f, %.1f) variant %d", posTrain.x, posTrain.y, posTrain.z, variation))
    last_train_menu = submenu
    return train
end

-- MENU SETUP


menu.divider(menu.my_root(), "火车生成")

menu.click_slider(menu.my_root(), "火车生产数量", {"spawntrain"}, "产生具有有一定变化的火车", 1, 23, 1, 1, function(variation, prev)
    local ped = PLAYER.GET_PLAYER_PED(players.user())
    local pos = ENTITY.GET_ENTITY_COORDS(ped, 1)

    spawn_train(variation - 1, pos)
end)

menu.action(menu.my_root(), "生成地铁列车", {"spawnmetro"}, "制造地铁列车", function()
    local ped = PLAYER.GET_PLAYER_PED(players.user())
    local pos = ENTITY.GET_ENTITY_COORDS(ped, 1)

    spawn_train(21, pos)
end)

menu.click_slider(menu.my_root(), "设定生成的列车速度", {"setspawnedspeed"}, "设置最后产生的火车速度.数值超过+/- 80将导致玩家向后滑动.倒车的火车看起来与其他玩家不同步.", -250, 250, 10, 5, function(value, prev)
    VEHICLE.SET_TRAIN_CRUISE_SPEED(last_train, value)
    VEHICLE.SET_TRAIN_SPEED(last_train, value)
end)

menu.action(menu.my_root(), "删除最后生成的火车", {"delltrain"}, "删除最后生成的火车", function(v)
    if last_train > 0 then
        last_train = 0
        for i = 0,100 do
            local cart = VEHICLE.GET_TRAIN_CARRIAGE(train, i)
            util.delete_entity(cart)
        end
        util.delete_entity(train)
        menu.delete(last_train_menu)
        last_train_menu = 0
    end
end)

menu.divider(menu.my_root(), "全部")

menu.click_slider(menu.my_root(), "设定全部火车速度", {"settrainspeed", "trainspeed"}, "设置附近所有的火车速度.数值超过+/- 80将导致玩家向后滑动.倒车的火车看起来与其他玩家不同步.", -250, 250, 10, 5, function(value, prev)
    -- Should _probably_ check if the model is a ya know train but ehh
    local vehicles = util.get_all_vehicles()
    for _, vehicle in pairs(vehicles) do 
        VEHICLE.SET_TRAIN_CRUISE_SPEED(vehicle, value)
        VEHICLE.SET_TRAIN_SPEED(vehicle, value)
    end
end)

menu.action(menu.my_root(), "删除所有火车", {"delalltrains"}, "删除游戏中的所有火车", function(v)
    local vehicles = util.get_all_vehicles()
    local count = 0
    for _, vehicle in pairs(vehicles) do 
        local vehicleModel = ENTITY.GET_ENTITY_MODEL(vehicle)
        for _, model in ipairs(models) do
            -- Check if the vehicle is a train
            if model == vehicleModel then
                count = count + 1
                util.delete_entity(vehicle)
            end
        end
    end
    util.toast("Deleted " .. count .. " trains")
end)

menu.toggle(menu.my_root(), "出轨火车", {"setderailed"}, "使所有火车都呈现出脱轨状态", function(on)
    local vehicles = util.get_all_vehicles()
    for _, vehicle in pairs(vehicles) do 
        local vehicleModel = ENTITY.GET_ENTITY_MODEL(vehicle)
        for _, model in ipairs(models) do
            -- Check if the vehicle is a train
            if model == vehicleModel then
                VEHICLE.SET_RENDER_TRAIN_AS_DERAILED(vehicle, on)
            end
        end
    end
end, false)

-- Old crap


local crazyTrains = false
menu.toggle(menu.my_root(), "坏的火车", {}, "", function(on)
    crazyTrains = on
end, crazyTrains)


local textc = {
    r = 255,
    g = 255,
    b = 255,
    a = 0
}
local speed = 0.0
local tick = 0
local increment = 5.0
while true do
    if crazyTrains then
        directx.draw_text(0.2, 0.5, string.format("speed %3.0f %s", speed, (increment > 0.0 and " forward" or " backwards")), 1, 0.5, textc, false)
        tick = tick + 1
        if tick > 20 then
            speed = speed + increment
            if speed == 0.0 then
                speed = increment
            elseif speed >= 80.0 or speed <= -80.0 then
                increment = -increment
            end
            local vehicles = util.get_all_vehicles()
            for k, vehicle in pairs(vehicles) do 
                VEHICLE.SET_TRAIN_CRUISE_SPEED(vehicle, speed)
                VEHICLE.SET_TRAIN_SPEED(vehicle, speed)
            end
            tick = 0
        end
    end
    util.yield()
end