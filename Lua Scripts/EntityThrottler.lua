-- Made by d6b

local debugmode <const> = false
local version <const> = "0.7"
local changelog <const> = [[- Updated updater error messages
- const-afied code

- Improved updater and version system (now nicer on the eye)
- Improved performance

- Fixed some minor mistakes]]

local synctimer <const> = {}
local settings <const> = {
    auto = {
        cleanup = false,
        interval = 10000,
        highlimit = 24,
        modellimit = 48,
        totallimit = 128,
        timeout = 30000,
    },
    bigvehicle = {
        excludeplayer = false,
        cleanup = false,
        limit = 5,
        radius = 250,
        timeout = 15000,
    },
    vehicle = {
        excludeplayer = false,
        cleanup = false,
        interval = 5000,
        limit = 10,
        radius = 25,
        timeout = 15000,
    },
    object = {
        cleanup = false,
        interval = 5000,
        limit = 10,
        radius = 25,
        timeout = 15000,
    },
    ped = {
        cleanup = false,
        interval = 2000,
        limit = 10,
        radius = 25,
        timeout = 15000,
    },
    autoupdate = true,
}
local whitelist <const> = {
    auto = {
        logged = {},
    },
    bigvehicle = {
        logged = {},
        owner = {},
    },
    vehicle = {
        timer = {},
        owner = {},
    },
    object = {
        timer = {},
        owner = {},
    },
    ped = {
        timer = {},
        owner = {},
    },
}
local bigvehiclenames <const> = {"titan", "bombushka", "volatol", "alkonost", "kosatka", "avenger", "avenger2", "jet", "cargoplane", "blimp", "blimp2", "blimp3", "bus", "pbus", "pbus2", "nimbus", "airbus", "rentalbus", "tourbus", "tug", "tr", "tr2", "tr3", "tr4", "freight", "freightcar", "freightcar2", "freightcont1", "freighttrailer", "freightcont2", "freightgrain"}
local bigvehicle <const> = {}

for i, Model in ipairs(bigvehiclenames) do
    bigvehicle[util.joaat(Model)] = Model
end

local notification <const> = function(body, ...)
    util.toast(body, ...)
    if debugmode then
        util.log(body)
    end
end
local update_lua <const> = function(automatic)
    local err
    async_http.init("raw.githubusercontent.com", "/d6bDev/EntityThrottler/main/EntityThrottlerDev.lua", function(str, headerfields, statuscode)
        err = ""
        if statuscode == 200 then
            local ver <const> = str:match('local version <const> = %"(.-)%"')
            local gitchangelog <const> = str:match("local changelog <const> = %[%[(.-)%]%]")
            if ver and type(ver) == "string" and gitchangelog and type(gitchangelog) == "string" then
                local gitversion <const>, num <const> = ver:gsub('"', ""):gsub('~', "")
                if gitversion and type(gitversion) == "string" then
                    if gitversion > version then
                        local chunk <const> = load(str)
                        if chunk then
                            local file <const> = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "w")
                            file:write(str)
                            file:close()
                            if num ~= 1 then
                                util.toast("Successfully updated to version "..gitversion.."\n"..gitchangelog)
                                util.restart_script()
                            end
                        else
                            err = "Failed to download update: Error loading file."
                        end
                    end
                end
            else
                err = "Failed to download update: Unable to fetch version information."
            end
        else
            err = "Failed to find version information: Unexpected response code. ("..tostring(statuscode)..")"
        end
    end, function()
        err = "Failed to find version information: Request timed out."
    end)
    async_http.dispatch()
    repeat
        directx.draw_text(0.5, 0.5, "Checking for updates...", ALIGN_CENTRE, 1, {r = 1, g = 1, b = 1, a = 1})
        util.yield()
    until err ~= nil
    if not automatic and err ~= "" then
        local time <const> = util.current_time_millis() + 2000
        while time > util.current_time_millis() do
            directx.draw_text(0.5, 0.5, err, ALIGN_CENTRE, 1, {r = 1, g = 0.5, b = 0.5, a = 1})
            util.yield()
        end
    end
    return err
end
local does_entity_from_pointer_exist <const> = function(addr)
    for i, Pointer in entities.get_all_vehicles_as_pointers() do
        if Pointer == addr then
            return true
        end
    end
    for i, Pointer in entities.get_all_peds_as_pointers() do
        if Pointer == addr then
            return true
        end
    end
    for i, Pointer in entities.get_all_pickups_as_pointers() do
        if Pointer == addr then
            return true
        end
    end
    for i, Pointer in entities.get_all_objects_as_pointers() do
        if Pointer == addr then
            return true
        end
    end
    return false
end
local is_entity_from_pointer_a_player <const> = function(addr)
    for i, Pointer in entities.get_all_peds_as_pointers() do
        if Pointer == addr then
            return entities.get_player_info(addr) ~= 0
        end
    end
    return false
end
local is_entity_from_pointer_a_player_vehicle <const> = function(addr)
    for i, Pointer in entities.get_all_vehicles_as_pointers() do
        if Pointer == addr then
            return entities.get_vehicle_has_been_owned_by_player(addr)
        end
    end
    return false
end
local is_entity_from_pointer_a_mission_entity <const> = function(addr)
    local NetObj <const> = memory.read_long(addr + 0xD0)
    return ((NetObj and NetObj ~= 0) and (memory.read_ubyte(NetObj + 0x4E) ~= 0))
end
local delete <const> = function(addr)
    if does_entity_from_pointer_exist(addr) and not is_entity_from_pointer_a_player(addr) then
        entities.delete_by_pointer(addr)
    end
end
local merge_table <const> = function(noduplicates, ...)
    local tbl <const> = {...}
    local out <const> = (noduplicates and {} or tbl[1])
    for i = 1, #tbl do
        for n = 1, #tbl[i] do
            out[#out+1] = tbl[i][n]
        end
    end
    return out
end
local table_entry_counts <const> = function(tbl)
    local counts <const> = {}
    for k, v in pairs(tbl) do
        local entry <const> = tbl[k]
        counts[entry] = (counts[entry] or 0) + 1
    end
    return counts
end
local get_highest_count <const> = function(tbl)
    local counts <const> = table_entry_counts(tbl)
    local count = 0
    local value = -1
    for k, v in pairs(counts) do
        if v > count then
            count = v
            value = k
        end
    end
    return value, count
end
local get_entity_owner <const> = function(addr)
    if type(addr) == "table" then
        local owners <const> = {}
        for k, v in pairs(addr) do
            owners[#owners+1] = get_entity_owner(v)
        end
        return get_highest_count(owners)
    else
        if util.is_session_started() and not util.is_session_transition_active() then
            local NetObj <const> = memory.read_long(addr + 0xD0)
            if NetObj and NetObj ~= 0 then
                return memory.read_byte(NetObj + 0x49)
            end
            return -1
        end
        return players.user()
    end
end

for i = 0, 31 do
    whitelist.auto[i] = {}
    whitelist.auto[i].owner = {}
    whitelist.auto[i].timer = {}
    whitelist.auto[i].current = {}
    whitelist.auto[i].models = {}
    whitelist.auto[i].highpriority = {
        total = 0,
    }
    synctimer[i] = 0
    util.create_thread(function()
        local pid <const> = i
        while true do
            if players.exists(pid) then
                if pid ~= players.user() and synctimer[pid] > util.current_time_millis() then
                    local Sync <const> = menu.ref_by_rel_path(menu.player_root(pid), "Incoming Syncs>Block")
                    menu.trigger_command(Sync, "on")
                    local knownentities <const> = {}
                    for n, Pointer in entities.get_all_vehicles_as_pointers() do
                        knownentities[Pointer] = true
                    end
                    for n, Pointer in entities.get_all_peds_as_pointers() do
                        knownentities[Pointer] = true
                    end
                    for n, Pointer in entities.get_all_pickups_as_pointers() do
                        knownentities[Pointer] = true
                    end
                    for n, Pointer in entities.get_all_objects_as_pointers() do
                        knownentities[Pointer] = true
                    end
                    while synctimer[pid] > util.current_time_millis() and players.exists(pid) do
                        for n, Pointer in entities.get_all_vehicles_as_pointers() do
                            if not knownentities[Pointer] and get_entity_owner(Pointer) == pid then
                                delete(Pointer)
                            end
                        end
                        for n, Pointer in entities.get_all_peds_as_pointers() do
                            if not knownentities[Pointer] and get_entity_owner(Pointer) == pid then
                                delete(Pointer)
                            end
                        end
                        for n, Pointer in entities.get_all_pickups_as_pointers() do
                            if not knownentities[Pointer] and get_entity_owner(Pointer) == pid then
                                delete(Pointer)
                            end
                        end
                        for n, Pointer in entities.get_all_objects_as_pointers() do
                            if not knownentities[Pointer] and get_entity_owner(Pointer) == pid then
                                delete(Pointer)
                            end
                        end
                        util.yield()
                    end
                    notification(players.get_name(pid).." is no longer in timeout", TOAST_ALL)
                    menu.trigger_command(Sync, "off")
                end
            end
            util.yield()
        end
    end, nil)
end

local autothrottler <const> = menu.list(menu.my_root(), "自动节流", {}, "")

menu.toggle_loop(autothrottler, "启用", {}, "", function()
    local allents <const> = merge_table(false, entities.get_all_vehicles_as_pointers(), entities.get_all_peds_as_pointers(), entities.get_all_pickups_as_pointers(), entities.get_all_objects_as_pointers())
    for i, Pointer in ipairs(allents) do
        local owner <const> = get_entity_owner(Pointer)
        if not whitelist.auto.logged[Pointer] then
            whitelist.auto.logged[Pointer] = true
            if owner ~= -1 and players.exists(owner) and owner ~= players.user() then
                whitelist.auto[owner].owner[#whitelist.auto[owner].owner+1] = Pointer
                whitelist.auto[owner].current[#whitelist.auto[owner].current+1] = Pointer
                whitelist.auto[owner].timer[Pointer] = util.current_time_millis()
                local model <const> = entities.get_model_hash(Pointer)
                whitelist.auto[owner].models[model] = (whitelist.auto[owner].models[model] or 0) + 1
                if is_entity_from_pointer_a_mission_entity(Pointer) then
                    whitelist.auto[owner].highpriority[Pointer] = true
                    whitelist.auto[owner].highpriority.total = (whitelist.auto[owner].highpriority.total or 0) + 1
                end
                if synctimer[owner] > util.current_time_millis() then
                    delete(Pointer)
                end
            end
        end
    end
    for i = 0, 31 do
        if players.exists(i) then
            local existing <const> = {}
            local existing2 <const> = {}
            for n, Pointer in ipairs(whitelist.auto[i].current) do
                if does_entity_from_pointer_exist(Pointer) and whitelist.auto[i].timer[Pointer] + settings.auto.interval > util.current_time_millis() then
                    existing[#existing+1] = Pointer
                else
                    local model <const> = entities.get_model_hash(Pointer)
                    whitelist.auto[i].models[model] = (whitelist.auto[i].models[model] or 1) - 1
                    if whitelist.auto[i].highpriority[Pointer] then
                        whitelist.auto[i].highpriority[Pointer] = nil
                        whitelist.auto[i].highpriority.total = whitelist.auto[i].highpriority.total - 1
                    end
                    whitelist.auto[i].current[n] = nil
                    whitelist.auto[i].timer[Pointer] = nil
                end
            end
            for n, Pointer in ipairs(whitelist.auto[i].owner) do
                if does_entity_from_pointer_exist(Pointer) then
                    existing2[#existing2+1] = Pointer
                else
                    whitelist.auto[i].owner[n] = nil
                end
            end
            whitelist.auto[i].current = existing
            whitelist.auto[i].owner = existing2
            if #whitelist.auto[i].current > settings.auto.totallimit then
                notification("[T] 实体节流来自 "..players.get_name(i), TOAST_ALL)
                if util.current_time_millis() + settings.auto.timeout > synctimer[i] then
                    synctimer[i] = util.current_time_millis() + settings.auto.timeout
                end
                if settings.auto.cleanup then
                    for n, Pointer in ipairs(whitelist.auto[i].owner) do
                        if does_entity_from_pointer_exist(Pointer) then
                            delete(Pointer)
                        end
                    end
                end
            end
            for Model, Num in pairs(whitelist.auto[i].models) do
                if Num > settings.auto.modellimit then
                    notification("[M] 实体节流来自 "..players.get_name(i), TOAST_ALL)
                    if util.current_time_millis() + settings.auto.timeout > synctimer[i] then
                        synctimer[i] = util.current_time_millis() + settings.auto.timeout
                    end
                    if settings.auto.cleanup then
                        for n, Pointer in ipairs(allents) do
                            if does_entity_from_pointer_exist(Pointer) and entities.get_model_hash(Pointer) == Model then
                                delete(Pointer)
                            end
                        end
                    end
                end
            end
            if whitelist.auto[i].highpriority.total > settings.auto.highlimit then
                notification("[H] 实体节流来自 "..players.get_name(i), TOAST_ALL)
                if util.current_time_millis() + settings.auto.timeout > synctimer[i] then
                    synctimer[i] = util.current_time_millis() + settings.auto.timeout
                end
                if settings.auto.cleanup then
                    for n, Pointer in ipairs(whitelist.auto[i].owner) do
                        if does_entity_from_pointer_exist(Pointer) then
                            delete(Pointer)
                        end
                    end
                end
            end
        end
    end
end, function()
    whitelist.auto = {}
    whitelist.auto.logged = {}
    for i = 0, 31 do
        whitelist.auto[i] = {}
        whitelist.auto[i].owner = {}
        whitelist.auto[i].current = {}
        whitelist.auto[i].timer = {}
        whitelist.auto[i].models = {}
        whitelist.auto[i].highpriority = {
            total = 0,
        }
    end
end)
menu.toggle(autothrottler, "清除", {}, "当节流触发时，将自动清除你周围所有对应的实体.", function(toggle)
    settings.auto.cleanup = toggle
end)
menu.slider(autothrottler, "间隔 (秒)", {}, "指定(秒)实体将持续多久时间才会被认定为垃圾实体.", 0, 60, settings.auto.interval/1000, 1, function(value)
    settings.auto.interval = value*1000
end)
menu.slider(autothrottler, "超时 (秒)", {}, "向你发送垃圾实体的玩家应该超时(秒)多久.", 0, 60, settings.auto.timeout/1000, 1, function(value)
    settings.auto.timeout = value*1000
end)
menu.slider(autothrottler, "总限值", {}, "指定实体同步的总限值.", 0, 512, settings.auto.totallimit, 1, function(value)
    settings.auto.totallimit = value
end)
menu.slider(autothrottler, "上限值", {}, '指定高优先级实体同步的总限值.', 0, 64, settings.auto.highlimit, 1, function(value)
    settings.auto.highlimit = value
end)
menu.slider(autothrottler, "模型限值", {}, "相同实体的限值.", 0, 128, settings.auto.modellimit, 1, function(value)
    settings.auto.modellimit = value
end)

local bigthrottler <const> = menu.list(menu.my_root(), "大型载具节流", {}, "")

menu.toggle_loop(bigthrottler, "启用", {}, "", function()
    local Pointers <const> = {}
    local pos <const> = players.get_position(players.user())
    for i, Pointer in ipairs(entities.get_all_vehicles_as_pointers()) do
        if whitelist.bigvehicle.logged[Pointer] == nil and (v3.distance(entities.get_position(Pointer), pos) < settings.bigvehicle.radius) then
            if bigvehicle[entities.get_model_hash(Pointer)] and whitelist.bigvehicle.owner[Pointer] ~= -1 and (debugmode or (whitelist.bigvehicle.owner[Pointer] ~= players.user())) and ((settings.bigvehicle.excludeplayer and not is_entity_from_pointer_a_player_vehicle(Pointer)) or not settings.bigvehicle.excludeplayer) then
                whitelist.bigvehicle.owner[Pointer] = get_entity_owner(Pointer)
                whitelist.bigvehicle.logged[Pointer] = true
            else
                whitelist.bigvehicle.logged[Pointer] = false
            end
        end
        if whitelist.bigvehicle.logged[Pointer] then
            Pointers[#Pointers+1] = Pointer
        end
    end
    if #Pointers > settings.bigvehicle.limit then
        local owners <const> = {}
        local models <const> = {}
        for i, Pointer in ipairs(Pointers) do
            owners[#owners+1] = whitelist.bigvehicle.owner[Pointer]
            if bigvehicle[entities.get_model_hash(Pointer)] then
                models[#models+1] = bigvehicle[entities.get_model_hash(Pointer)]
            end
        end
        local owner <const> = get_highest_count(owners)
        local model <const>, count <const> = get_highest_count(models)
        if players.exists(owner) then
            notification("大型载具节流 ("..tostring(model).." "..count.."x) 来自 "..players.get_name(owner), TOAST_ALL)
            if util.current_time_millis() + settings.bigvehicle.timeout > synctimer[owner] then
                synctimer[owner] = util.current_time_millis() + settings.bigvehicle.timeout
            end
        elseif settings.bigvehicle.cleanup then
            notification("大型载具节流", TOAST_ALL)
        end
        if settings.bigvehicle.cleanup then
            if players.exists(owner) then
                for i, Pointer in ipairs(Pointers) do
                    if get_entity_owner(Pointer) == owner then
                        if does_entity_from_pointer_exist(Pointer) then
                            delete(Pointer)
                        end
                    end
                end
            else
                for i, Pointer in ipairs(Pointers) do
                    if does_entity_from_pointer_exist(Pointer) then
                        delete(Pointer)
                    end
                end
            end
        end
    end
end, function()
    whitelist.bigvehicle.timer = {}
    whitelist.bigvehicle.owner = {}
end)
menu.toggle(bigthrottler, "清除", {}, "当节流触发时，将自动清除你周围所有对应的实体.", function(toggle)
    settings.bigvehicle.cleanup = toggle
end)
menu.toggle(bigthrottler, "排除玩家载具", {}, "排除玩家载具触发节流的可能性", function(toggle)
    settings.bigvehicle.excludeplayer = toggle
end)
menu.slider(bigthrottler, "超时（秒）", {}, "向你发送垃圾实体的玩家应该超时(秒)多久.", 0, 60, settings.bigvehicle.timeout/1000, 1, function(value)
    settings.bigvehicle.timeout = value*1000
end)
menu.slider(bigthrottler, "限制", {}, "范围内指定实体的限制数.", 0, 100, settings.bigvehicle.limit, 1, function(value)
    settings.bigvehicle.limit = value
end)
menu.slider(bigthrottler, "半径", {}, "清除自身范围实体的距离.", 0, 1000, settings.bigvehicle.radius, 5, function(value)
    settings.bigvehicle.radius = value
end)

local vehiclethrottler <const> = menu.list(menu.my_root(), "载具节流", {}, "")

menu.toggle_loop(vehiclethrottler, "启用", {}, "", function()
    local Pointers <const> = {}
    local pos <const> = players.get_position(players.user())
    for i, Pointer in ipairs(entities.get_all_vehicles_as_pointers()) do
        if not whitelist.vehicle.timer[Pointer] and (v3.distance(entities.get_position(Pointer), pos) < settings.vehicle.radius) then
            whitelist.vehicle.owner[Pointer] = get_entity_owner(Pointer)
            if whitelist.vehicle.owner[Pointer] ~= -1 and (debugmode or (whitelist.vehicle.owner[Pointer] ~= players.user())) and ((settings.vehicle.excludeplayer and not is_entity_from_pointer_a_player_vehicle(Pointer)) or not settings.vehicle.excludeplayer) then
                whitelist.vehicle.timer[Pointer] = util.current_time_millis()
            else
                whitelist.vehicle.timer[Pointer] = 0
            end
        end
        if whitelist.vehicle.timer[Pointer] and (whitelist.vehicle.timer[Pointer] + settings.vehicle.interval > util.current_time_millis()) then
            Pointers[#Pointers+1] = Pointer
        end
    end
    if debugmode then
        util.draw_debug_text("Vehicles: "..#Pointers.."/"..#entities.get_all_vehicles_as_pointers())
    end
    if #Pointers > settings.vehicle.limit then
        local owners <const> = {}
        for i, Pointer in ipairs(Pointers) do
            owners[#owners+1] = whitelist.vehicle.owner[Pointer]
        end
        local owner <const> = get_highest_count(owners)
        if players.exists(owner) then
            notification("载具节流来自 "..players.get_name(owner), TOAST_ALL)
            if util.current_time_millis() + settings.vehicle.timeout > synctimer[owner] then
                synctimer[owner] = util.current_time_millis() + settings.vehicle.timeout
            end
        elseif settings.vehicle.cleanup then
            notification("载具节流", TOAST_ALL)
        end
        if settings.vehicle.cleanup then
            if players.exists(owner) then
                for i, Pointer in ipairs(entities.get_all_vehicles_as_pointers()) do
                    if get_entity_owner(Pointer) == owner then
                        if does_entity_from_pointer_exist(Pointer) then
                            delete(Pointer)
                        end
                    end
                end
            else
                for i, Pointer in ipairs(Pointers) do
                    if does_entity_from_pointer_exist(Pointer) then
                        delete(Pointer)
                    end
                end
            end
        end
    end
end, function()
    whitelist.vehicle.timer = {}
    whitelist.vehicle.owner = {}
end)
menu.toggle(vehiclethrottler, "清除", {}, "当节流触发时，将自动清除你周围所有对应的实体.", function(toggle)
    settings.vehicle.cleanup = toggle
end)
menu.toggle(vehiclethrottler, "排除玩家载具", {}, "排除玩家载具触发节流的可能性.", function(toggle)
    settings.vehicle.excludeplayer = toggle
end)
menu.slider(vehiclethrottler, "间隔（秒）", {}, "指定(秒)实体将持续多久时间才会被认定为垃圾实体.", 0, 60, settings.vehicle.interval/1000, 1, function(value)
    settings.vehicle.interval = value*1000
end)
menu.slider(vehiclethrottler, "超时 (秒)", {}, "向你发送垃圾实体的玩家应该超时(秒)多久.", 0, 60, settings.vehicle.timeout/1000, 1, function(value)
    settings.vehicle.timeout = value*1000
end)
menu.slider(vehiclethrottler, "限制", {}, "范围内指定实体的限制数.", 0, 100, settings.vehicle.limit, 1, function(value)
    settings.vehicle.limit = value
end)
menu.slider(vehiclethrottler, "半径", {}, "清除自身范围实体的距离.", 0, 1000, settings.vehicle.radius, 5, function(value)
    settings.vehicle.radius = value
end)

local objectthrottler <const> = menu.list(menu.my_root(), "物体节流", {}, "")

menu.toggle_loop(objectthrottler, "启用", {}, "", function()
    local Pointers <const> = {}
    local pos <const> = players.get_position(players.user())
    local og <const> = merge_table(true, entities.get_all_objects_as_pointers(), entities.get_all_pickups_as_pointers())
    for i, Pointer in ipairs(og) do
        if not whitelist.object.timer[Pointer] and (v3.distance(entities.get_position(Pointer), pos) < settings.object.radius) then
            whitelist.object.owner[Pointer] = get_entity_owner(Pointer)
            if whitelist.object.owner[Pointer] ~= -1 and (debugmode or (whitelist.object.owner[Pointer] ~= players.user())) then
                whitelist.object.timer[Pointer] = util.current_time_millis()
            else
                whitelist.object.timer[Pointer] = 0
            end
        end
        if whitelist.object.timer[Pointer] and (whitelist.object.timer[Pointer] + settings.object.interval > util.current_time_millis()) then
            Pointers[#Pointers+1] = Pointer
        end
    end
    if debugmode then
        util.draw_debug_text("Objects: "..#Pointers.."/"..#og)
    end
    if #Pointers > settings.object.limit then
        local owners <const> = {}
        for i, Pointer in ipairs(Pointers) do
            owners[#owners+1] = whitelist.object.owner[Pointer]
        end
        local owner <const> = get_highest_count(owners)
        if players.exists(owner) then
            notification("物体节流来自 "..players.get_name(owner), TOAST_ALL)
            if util.current_time_millis() + settings.object.timeout > synctimer[owner] then
                synctimer[owner] = util.current_time_millis() + settings.object.timeout
            end
        elseif settings.object.cleanup then
            notification("物体节流", TOAST_ALL)
        end
        if settings.object.cleanup then
            if players.exists(owner) then
                for i, Pointer in ipairs(entities.get_all_objects_as_pointers()) do
                    if get_entity_owner(Pointer) == owner then
                        if does_entity_from_pointer_exist(Pointer) then
                            delete(Pointer)
                        end
                    end
                end
            else
                for i, Pointer in ipairs(Pointers) do
                    if does_entity_from_pointer_exist(Pointer) then
                        delete(Pointer)
                    end
                end
            end
        end
    end
end, function()
    whitelist.object.timer = {}
    whitelist.object.owner = {}
end)
menu.toggle(objectthrottler, "清除", {}, "当节流触发时，将自动清除你周围所有对应的实体.", function(toggle)
    settings.object.cleanup = toggle
end)
menu.slider(objectthrottler, "间隔 (秒)", {}, "指定(秒)实体将持续多久时间才会被认定为垃圾实体.", 0, 60, settings.object.interval/1000, 1, function(value)
    settings.object.interval = value*1000
end)
menu.slider(objectthrottler, "超时 (秒)", {}, "向你发送垃圾实体的玩家应该超时(秒)多久.", 0, 60, settings.object.timeout/1000, 1, function(value)
    settings.object.timeout = value*1000
end)
menu.slider(objectthrottler, "限制", {}, "范围内指定实体的限制数.", 0, 100, settings.object.limit, 1, function(value)
    settings.object.limit = value
end)
menu.slider(objectthrottler, "半径", {}, "清除自身范围实体的距离.", 0, 1000, settings.object.radius, 5, function(value)
    settings.object.radius = value
end)

local pedthrottler = menu.list(menu.my_root(), "人物节流", {}, "")

menu.toggle_loop(pedthrottler, "启用", {}, "", function()
    local Pointers <const> = {}
    local pos <const> = players.get_position(players.user())
    for i, Pointer in ipairs(entities.get_all_peds_as_pointers()) do
        if not whitelist.ped.timer[Pointer] and (v3.distance(entities.get_position(Pointer), pos) < settings.ped.radius) then
            whitelist.ped.owner[Pointer] = get_entity_owner(Pointer)
            if whitelist.ped.owner[Pointer] ~= -1 and entities.get_player_info(Pointer) == 0 and (debugmode or (whitelist.ped.owner[Pointer] ~= players.user())) then
                whitelist.ped.timer[Pointer] = util.current_time_millis()
            else
                whitelist.ped.timer[Pointer] = 0
            end
        end
        if whitelist.ped.timer[Pointer] and (whitelist.ped.timer[Pointer] + settings.ped.interval > util.current_time_millis()) then
            Pointers[#Pointers+1] = Pointer
        end
    end
    if debugmode then
        util.draw_debug_text("Peds: "..#Pointers.."/"..#entities.get_all_peds_as_pointers())
    end
    if #Pointers > settings.ped.limit then
        local owners <const> = {}
        for i, Pointer in ipairs(Pointers) do
            owners[#owners+1] = whitelist.ped.owner[Pointer]
        end
        local owner <const> = get_highest_count(owners)
        if players.exists(owner) then
            notification("人物节流来自 "..players.get_name(owner), TOAST_ALL)
            if util.current_time_millis() + settings.ped.timeout > synctimer[owner] then
                synctimer[owner] = util.current_time_millis() + settings.ped.timeout
            end
        elseif settings.ped.cleanup then
            notification("人物节流", TOAST_ALL)
        end
        if settings.ped.cleanup then
            if players.exists(owner) then
                for i, Pointer in ipairs(entities.get_all_peds_as_pointers()) do
                    if (entities.get_player_info(Pointer) == 0) and get_entity_owner(Pointer) == owner then
                        if does_entity_from_pointer_exist(Pointer) then
                            delete(Pointer)
                        end
                    end
                end
            else
                for i, Pointer in ipairs(Pointers) do
                    if does_entity_from_pointer_exist(Pointer) then
                        delete(Pointer)
                    end
                end
            end
        end
    end
end, function()
    whitelist.ped.timer = {}
    whitelist.ped.owner = {}
end)
menu.toggle(pedthrottler, "清除", {}, "当节流触发时，将自动清除你周围所有对应的实体.", function(toggle)
    settings.ped.cleanup = toggle
end)
menu.slider(pedthrottler, "间隔 (秒)", {}, "指定(秒)实体将持续多久时间才会被认定为垃圾实体.", 0, 60, settings.ped.interval/1000, 1, function(value)
    settings.ped.interval = value*1000
end)
menu.slider(pedthrottler, "超时 (秒)", {}, "向你发送垃圾实体的玩家应该超时(秒)多久.", 0, 60, settings.ped.timeout/1000, 1, function(value)
    settings.ped.timeout = value*1000
end)
menu.slider(pedthrottler, "限制", {}, "范围内指定实体的限制数.", 0, 100, settings.ped.limit, 1, function(value)
    settings.ped.limit = value
end)
menu.slider(pedthrottler, "半径", {}, "清除自身范围实体的距离.", 0, 1000, settings.ped.radius, 5, function(value)
    settings.ped.radius = value
end)

local settingsroot <const> = menu.list(menu.my_root(), "更新设置", {}, "")

menu.toggle(settingsroot, "自动更新", {}, "", function(toggle)
    settings.autoupdate = toggle
end, false)

local updatetimer = 0
menu.action(settingsroot, "检查更新", {}, "手动检查更新.", function()
    if (updatetimer < util.current_time_millis()) or debugmode then
        updatetimer = util.current_time_millis() + 15000
        local err <const> = update_lua()
        if err == "" then
            local time <const> = util.current_time_millis() + 2000
            while time > util.current_time_millis() do
                directx.draw_text(0.5, 0.5, "没有更新.", ALIGN_CENTRE, 1, {r = 0.5, g = 1, b = 0.5, a = 1})
                util.yield()
            end
        end
    else
        notification("请稍候再试.")
    end
end)

menu.action(settingsroot, "更新日志", {}, "", function()
    util.toast("Version "..version.."\n"..changelog)
end)
--[[local version = 0.7
local changelog = [[- Updated updater error messages
- const-afied code

- Improved updater and version system (now nicer on the eye)
- Improved performance

- Fixed some minor mistakes]] -- left to support old versions of script's way to get version information that havent updated yet
util.create_thread(function()
    for i = 1, 8 do
        util.yield()
    end
    if settings.autoupdate then
        update_lua(true)
    end
end, nil)
