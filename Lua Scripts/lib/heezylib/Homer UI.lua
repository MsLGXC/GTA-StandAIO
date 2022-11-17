require"lib.heezylib.natives"
require"lib.heezylib.lua_imGUI V3"
require"lib.heezylib.HomerUIlib"

myUI = UI.new()

local icon_self = directx.create_texture(filesystem.scripts_dir() .. "\\HeezyScript\\" .. "imGUI_self.png")
local icon_world = directx.create_texture(filesystem.scripts_dir() .. "\\HeezyScript\\" .. "imGUI_world.png")
local icons = {
    self = icon_self,
    world = icon_world
}

menu.toggle(yulexx, "HomerMenu", {"UI"}, "",
    function(state)
        UItoggle = state


        while UItoggle do
            local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())

            local playerpos = ENTITY.GET_ENTITY_COORDS(player)

            if PAD.IS_CONTROL_JUST_PRESSED(2, 29) then
                myUI.toggle_cursor_mode()
            end

-- #region tabbed window
            tabs = {
                [1] = { 
                    data = {
                        title = "自我",
                        icon = icons.self
                    },
                    
                    content = function ()
                    myUI.subhead("玩家坐标")
                    myUI.start_horizontal()
                    myUI.label("X           ", math.floor(playerpos.x))
                    myUI.divider()
                    myUI.label("Y           ", math.floor(playerpos.y))
                    myUI.divider()
                    myUI.label("Z           ", math.floor(playerpos.z))
                    myUI.end_horizontal()
        
                    myUI.divider()
        
                    myUI.subhead("玩家信息")
                    myUI.label("生命值 ", ENTITY.GET_ENTITY_HEALTH(player))
                    myUI.label("弹药 ", PED.GET_PED_ARMOUR(player))
                    myUI.label("是否在载具内 ", PED.IS_PED_IN_ANY_VEHICLE(player, true))
        
                    myUI.divider()
                    myUI.start_horizontal()

                    fireman = myUI.toggle("火人", fireman, nil, function (state)
                        if state then
                            menu.trigger_commands("godmode off")
                            FIRE.START_ENTITY_FIRE(PLAYER.PLAYER_PED_ID())
                        else
                            FIRE.STOP_ENTITY_FIRE(PLAYER.PLAYER_PED_ID())
                            menu.trigger_commands("godmode on")
                        end
                    end)

                    wings = myUI.toggle("翅膀" , wings, nil, function (on_toggle)
                        if on_toggle then	
                            local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
                            local wings = OBJECT.CREATE_OBJECT(util.joaat("vw_prop_art_wings_01a"), pos.x, pos.y, pos.z, true, true, true)
                            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(util.joaat("vw_prop_art_wings_01a"))
                            ENTITY.ATTACH_ENTITY_TO_ENTITY(wings, PLAYER.PLAYER_PED_ID(), PED.GET_PED_BONE_INDEX(PLAYER.PLAYER_PED_ID(), 0x5c01), -1.0, 0.0, 0.0, 0.0, 90.0, 0.0, false, true, false, true, 0, true)
                        else
                            local count = 0
                                    for k,ent in pairs(entities.get_all_objects_as_handles()) do
                                        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
                                        entities.delete_by_handle(ent)
                                        count = count + 1
                                        util.yield()
                                    end
                                    end
                    end)
                    myUI.end_horizontal()
                    
                end},
                [2] = {
                    data = {
                        title = "在线",
                        icon = icons.world
                    },
                    content = function ()
                    myUI.subhead("战局信息")
                    myUI.label("主机", PLAYER.GET_PLAYER_NAME(players.get_host()), {
                        ["r"] = 0.2,
                        ["g"] = 0.9,
                        ["b"] = 0.9,
                        ["a"] = 1
                    })
                    myUI.label("脚本主机", PLAYER.GET_PLAYER_NAME(players.get_script_host()), {
                        ["r"] = 0.9,
                        ["g"] = 0.9,
                        ["b"] = 0.2,
                        ["a"] = 1
                    })
        
                    if NETWORK.NETWORK_IS_SESSION_STARTED() then
                        myUI.divider()
                        myUI.text("玩家信息")
                        myUI.label("RP: ", players.get_rp(players.user()))
                        myUI.label("存款总计: ", players.get_money(players.user()))
                        myUI.start_horizontal()
                        myUI.label("银行存款:", players.get_bank(players.user()))
                        myUI.label("现金:", players.get_wallet(players.user()))
                        myUI.end_horizontal()
                    end
                    myUI.divider()
                    myUI.start_horizontal()
                    if myUI.button("防空警报") then
                        fangkongjingbao()
                    end
                    if myUI.button("噪音") then
                        zaoyin()
                    end                   
                    if myUI.button("载具伞崩") then
                        chesan()
                    end
                    if myUI.button("不知名崩溃") then
                        local spped = PLAYER.PLAYER_PED_ID()
                        local SelfPlayerPos = ENTITY.GET_ENTITY_COORDS(spped, true)
                        SelfPlayerPos.x = SelfPlayerPos.x + 10
                        TTPos.x = TTPos.x + 10
                        local carc = CreateObject(util.joaat("apa_prop_flag_china"), TTPos, ENTITY.GET_ENTITY_HEADING(spped), true)
                        local carcPos = ENTITY.GET_ENTITY_COORDS(vehicle, true)
                        local pedc = CreatePed(26, util.joaat("A_C_HEN"), TTPos, 0)
                        local pedcPos = ENTITY.GET_ENTITY_COORDS(vehicle, true)
                        local ropec = PHYSICS.ADD_ROPE(TTPos.x, TTPos.y, TTPos.z, 0, 0, 0, 1, 1, 0.00300000000000000000000000000000000000000000000001, 1, 1, true, true, true, 1.0, true, 0)
                        PHYSICS.ATTACH_ENTITIES_TO_ROPE(ropec,carc,pedc,carcPos.x, carcPos.y, carcPos.z ,pedcPos.x, pedcPos.y, pedcPos.z,2, false, false, 0, 0, "Center","Center")
                        util.yield(3500)
                        PHYSICS.DELETE_CHILD_ROPE(ropec)
                        entities.delete_by_handle(pedc)
                    end
                    myUI.end_horizontal()
                    myUI.start_horizontal()
                    if myUI.button("人物伞崩V1") then
                        san1()
                    end
                    if myUI.button("人物伞崩V2") then
                        wudihh()
                    end
                    if myUI.button("人物伞崩V3") then
                        renwusanrnm()
                    end
                    myUI.end_horizontal()
                    myUI.start_horizontal()
                    if myUI.button("冷战崩溃") then
                        rlengzhan()
                    end
                    if myUI.button("数学崩溃") then
                        shuxuebeng()
                    end
                    if myUI.button("声音崩溃") then
                    local TPP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
                    local time = util.current_time_millis() + 2000
                    while time > util.current_time_millis() do
		            local TPPS = ENTITY.GET_ENTITY_COORDS(TPP, true)
			    for i = 1, 20 do
				    AUDIO.PLAY_SOUND_FROM_COORD(-1, "Event_Message_Purple", TPPS.x,TPPS.y,TPPS.z, "GTAO_FM_Events_Soundset", true, 100000, false)
			    end
			        util.yield()
			    for i = 1, 20 do
			        AUDIO.PLAY_SOUND_FROM_COORD(-1, "5s", TPPS.x,TPPS.y,TPPS.z, "GTAO_FM_Events_Soundset", true, 100000, false)
			    end
			        util.yield()
		        end
                    util.toast("Sound Spam Crash [Lobby] executed successfully.")
                end
                    myUI.end_horizontal()
                end},
                [3] = {
                    data = {
                        title = "防护",
                        icon = icons.self
                    },
                    content = function ()
                        if myUI.button("强制停止所有声音事件") then
                        for i=-1,100 do
                            AUDIO.STOP_SOUND(i)
                            AUDIO.RELEASE_SOUND_ID(i)
                        end
                    end

                    if myUI.button("超级清除") then
                        local cleanse_entitycount = 0
        for _, ped in pairs(entities.get_all_peds_as_handles()) do
            if ped ~= players.user_ped() and not PED.IS_PED_A_PLAYER(ped) then
                entities.delete_by_handle(ped)
                cleanse_entitycount += 1
            end
        end
        util.toast("已清除" .. cleanse_entitycount .. "个NPC")
        cleanse_entitycount = 0
        for _, veh in ipairs(entities.get_all_vehicles_as_handles()) do
            entities.delete_by_handle(veh)
            cleanse_entitycount += 1
            util.yield()
        end
        util.toast("已清除".. cleanse_entitycount .."个载具")
        cleanse_entitycount = 0
        for _, object in pairs(entities.get_all_objects_as_handles()) do
            entities.delete_by_handle(object)
            cleanse_entitycount += 1
        end
        util.toast("已清除" .. cleanse_entitycount .. "物体")
        cleanse_entitycount = 0
        for _, pickup in pairs(entities.get_all_pickups_as_handles()) do
            entities.delete_by_handle(pickup)
            cleanse_entitycount += 1
        end
        util.toast("已清除" .. cleanse_entitycount .. "可拾取物体")
        local temp = memory.alloc(4)
        for i = 0, 100 do
            memory.write_int(temp, i)
            PHYSICS.DELETE_ROPE(temp)
        end
        util.toast("已清除所有绳索")
        local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        MISC.CLEAR_AREA_OF_PROJECTILES(pos.x, pos.y, pos.z, 400, 0)
        util.toast("已清除所有投掷物")
    end

        Raw_Network_Events = myUI.toggle("阻止网络事件", Raw_Network_Events, nil, function (state)
            local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
            local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
            if state then
                menu.trigger_command(BlockNetEvents)
                util.toast("已阻止所有网络传输")
            else
                menu.trigger_command(UnblockNetEvents)
                util.toast("关闭阻止网络传输")
            end
        end)

        desyncall = myUI.toggle("阻止网络事件", desyncall, nil, function (state)
            if state then
                util.toast("开启阻止网络事件传出")
                menu.trigger_commands("desyncall on")
            else
                util.toast("关闭阻止网络事件传出")
                menu.trigger_commands("desyncall off")
            end
        end)

        anticrashcam = myUI.toggle("防崩镜头", anticrashcam, nil, function (state)
            if state then
                util.toast("开启防崩视角")
                menu.trigger_commands("anticrashcam on")
                menu.trigger_commands("potatomode on")
            else
                util.toast("关闭防崩视角")
                menu.trigger_commands("anticrashcam off")
                menu.trigger_commands("potatomode off")
            end
        end)

        zibi = myUI.toggle("昏哥模式", zibi, nil, function (state)
            local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
		local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
		local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
		local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
		if state then
			util.toast("开启昏哥模式")
			menu.trigger_commands("desyncall on")
			menu.trigger_command(BlockIncSyncs)
			menu.trigger_command(BlockNetEvents)
		else
			util.toast("关闭昏哥模式")
			menu.trigger_commands("desyncall off")
			menu.trigger_command(UnblockIncSyncs)
			menu.trigger_command(UnblockNetEvents)
		end
	end)
                    end}
        }
            myUI.start_tab_container("尊贵的HomerMenu用户: "..PLAYER.GET_PLAYER_NAME(players.user()), 0.067, 0.4, tabs, "asidghufiopuas")



            myUI.begin("玩家", 0.7, 0.25, "kpjbgkzjsdbg")
            myUI.start_horizontal()
            if myUI.button("               踢出               ") then
                menu.trigger_commands("kickall")
            end
            if myUI.button("               崩溃               ") then
                menu.trigger_commands("kickall")
            end
            if myUI.button("               爆炸               ") then
                menu.trigger_commands("explodeall")
            end
            myUI.end_horizontal()
            local player_table = players.list()
            for i, pid in pairs(player_table) do
                myUI.start_horizontal()
                myUI.label(PLAYER.GET_PLAYER_NAME(pid).." ", players.get_rank(pid))
                myUI.divider()
                myUI.label("",players.get_tags_string(pid).."                        ")
                myUI.divider()
                if myUI.button("踢出") then
                    menu.trigger_commands("kick "..PLAYER.GET_PLAYER_NAME(pid))
                end
                if myUI.button("崩溃") then
                    menu.trigger_commands("crash "..PLAYER.GET_PLAYER_NAME(pid))
                end
                if myUI.button("佩岛") then
                    util.trigger_script_event(1 << pid, {1214823473, pid, 0, 0, 3, 1, 0})
                end
                if myUI.button("笼子") then
                    ptlz(pid)
                 end
                 if myUI.button("传送") then
                    menu.trigger_commands("tp"..PLAYER.GET_PLAYER_NAME(pid))
                 end
                    myUI.end_horizontal()
            end
            myUI.finish()



            util.yield()
        end
    end
)

while true do
    util.yield() -- keeps the script running at all times.
end
