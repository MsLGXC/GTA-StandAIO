   --credits to Keramis for the tutorial
   --credits to Jerry123 for major help with multiple portions of the script and his LangLib for translations
   --credits to Sapphire for the help in programming they are the real MVP for helping everyone
   --credits to Vsus and ghozt for pointing me in the right direction
   --credits to Nowiry for their script it was a heavy influence on the Charger and Lazer Space Docker weapons
   --credits to aaronlink127#0127 for the ScaleformLib script and help with executing it
   --Script made by acjoker8818
   -------------------------------------------------------------------------
   
--github

local localVer = 2.6 -- all credits for the updater go to Prisuhm#7717 Thank You
util.require_natives(1663599433)
util.ensure_package_is_installed('lua/ScaleformLib')
local AClang = require ('lib/AClangLib')
require ('store/AcjokerScript/ACJSTables')
LANG_SETTINGS = {}
SEC = ENTITY.SET_ENTITY_COORDS
local playerid = players.user()
local playerped = players.user_ped()
local set = {alert = true}


AClang.action(menu.my_root(), 'Restart Script', {}, 'Restarts the script to check for updates', function ()
    util.restart_script()
end)

AClang.action(menu.my_root(), 'Player Options', {}, 'Redirects you to the Player list in Stand for the Trolling and Friendly options', function ()
    menu.trigger_commands("players")
end)

local onlineroot = AClang.list(menu.my_root(), 'Online', {}, '')
local vehroot = AClang.list(menu.my_root(), 'Vehicles', {}, '')
local setroot = AClang.list(menu.my_root(), 'Settings', {}, '')
AClang.toggle(setroot, 'Alerts Off', {'ACAlert'}, 'Turn off the alerts you get from AcjokerScript', function (on)
    set.alert = not on
end)

 ------------------


 --------------------Functions-------------------------------------



function PFP(pedm, playerm)--Ped Facing Player adapted from PhoenixScript
    local ppos = ENTITY.GET_ENTITY_COORDS(playerm)
    local pmpos = ENTITY.GET_ENTITY_COORDS(pedm)
    local hx = ppos.x - pmpos.x
    local hy = ppos.y - pmpos.y
    local head = MISC.GET_HEADING_FROM_VECTOR_2D(hx, hy)
    return ENTITY.SET_ENTITY_HEADING(pedm, head)
end

function Streament(hash) --Streaming Model
    STREAMING.REQUEST_MODEL(hash)
    while STREAMING.HAS_MODEL_LOADED(hash) ==false do
    util.yield()
    end
end

function Streamptfx(lib)
    STREAMING.REQUEST_NAMED_PTFX_ASSET(lib)
    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(lib) do
        util.yield()
    end
    GRAPHICS.USE_PARTICLE_FX_ASSET(lib)
end

function Streamanim(anim) --Streaming Model
    STREAMING.REQUEST_ANIM_DICT(anim)
    while STREAMING.HAS_ANIM_DICT_LOADED(anim) ==false do
        STREAMING.REQUEST_ANIM_DICT(anim)
        util.yield()
    end
end

function Runanim(ent, animdict, anim)
    TASK.TASK_PLAY_ANIM(ent, animdict, anim, 1.0, 1.0, -1, 3, 0.5, false, false, false)
    while ENTITY.IS_ENTITY_PLAYING_ANIM(ent, animdict, anim, 3) ==false do
        TASK.TASK_PLAY_ANIM(ent, animdict, anim, 1.0, 1.0, -1, 3, 0.5, false, false, false)
        util.yield()
    end
end


function SF() --Scaleform Full credits to aaron
    local scaleform = require('ScaleformLib')
    local sf = scaleform('instructional_buttons')
    HUD.HIDE_HUD_COMPONENT_THIS_FRAME(6)
    HUD.HIDE_HUD_COMPONENT_THIS_FRAME(7)
    HUD.HIDE_HUD_COMPONENT_THIS_FRAME(8)
    HUD.HIDE_HUD_COMPONENT_THIS_FRAME(9)
---@diagnostic disable-next-line: param-type-mismatch
    memory.write_int(memory.script_global(1645739+1121), 1)
    sf.CLEAR_ALL()
    sf.TOGGLE_MOUSE_BUTTONS(false)
    sf.SET_DATA_SLOT(0,PAD.GET_CONTROL_INSTRUCTIONAL_BUTTONS_STRING(0, 86, true), AClang.str_trans('Push Away or Blow up'))
    sf.DRAW_INSTRUCTIONAL_BUTTONS()
    sf:draw_fullscreen()
end

function SFlsd() --Scaleform Full credits to aaron
    local scaleform = require('ScaleformLib')
    local sf = scaleform('instructional_buttons')
    HUD.HIDE_HUD_COMPONENT_THIS_FRAME(6)
    HUD.HIDE_HUD_COMPONENT_THIS_FRAME(7)
    HUD.HIDE_HUD_COMPONENT_THIS_FRAME(8)
    HUD.HIDE_HUD_COMPONENT_THIS_FRAME(9)
---@diagnostic disable-next-line: param-type-mismatch
    memory.write_int(memory.script_global(1645739+1121), 1)
    sf.CLEAR_ALL()
    sf.TOGGLE_MOUSE_BUTTONS(false)
    sf.SET_DATA_SLOT(0,PAD.GET_CONTROL_INSTRUCTIONAL_BUTTONS_STRING(0, 86, true), AClang.str_trans('Lazers'))
    sf.DRAW_INSTRUCTIONAL_BUTTONS()
    sf:draw_fullscreen()
end


function Pedspawn(pedhash, tar1)
    Streament(pedhash)
    local pedS = entities.create_ped(1, pedhash, tar1, 0)
    ENTITY.SET_ENTITY_INVINCIBLE(pedS, true)
    ENTITY.FREEZE_ENTITY_POSITION(pedS, true)
    PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pedS, true)
    PED.SET_PED_CAN_LOSE_PROPS_ON_DAMAGE(pedS, false)
    if pedhash == util.joaat('ig_lestercrest') then
        PED.SET_PED_PROP_INDEX(pedS, 1)
    end

    return pedS
end

function SetPedCoor(pedS, tarx, tary, tarz)
    SEC(pedS, tarx, tary, tarz, false, true, true, false)
end


function Teabagtime(p1, p2, p3, p4, p5, p6, p7, p8)
    util.create_tick_handler (function ()
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p1, 'LES1A_DHAC', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p2, 'TUSCO_AHAD', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p3, 'LES1A_DHAC', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p4, 'TUSCO_AHAD', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p5, 'LES1A_DHAC', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p6, 'TUSCO_AHAD', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p7, 'LES1A_DHAC', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
        AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p8, 'TUSCO_AHAD', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
--AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(p1, 'HS3LE_ANAB', 'LESTER', 'SPEECH_PARAMS_FORCE_SHOUTED', 1)
        util.yield(100)
        end)
end



function Jesuslovesyou(ped_tab)
    util.create_tick_handler (function ()
        for _, pi in ipairs(ped_tab) do
            AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(pi, 'BUMP', 'JESSE', 'SPEECH_PARAMS_FORCE', 1)
            util.yield(250)
        end
    end)
end

function Trevortime(ped_tab)
    util.create_tick_handler (function ()
        for _, pi in ipairs(ped_tab) do
            AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(pi, 'TR2_ABAJ', 'TREVOR', 'SPEECH_PARAMS_FORCE', 1)
            util.yield(100)
        end
    end)
end

function Fuckyou(ped_tab)
    util.create_tick_handler (function ()
        for _, pi in ipairs(ped_tab) do
            AUDIO.PLAY_PED_AMBIENT_SPEECH_NATIVE(pi, 'GENERIC_FUCK_YOU', 'SPEECH_PARAMS_FORCE', 1)
            util.yield(100)
        end
    end)
end

function Insulthigh(ped_tab)
    util.create_tick_handler (function ()
        for _, pi in ipairs(ped_tab) do
            AUDIO.PLAY_PED_AMBIENT_SPEECH_NATIVE(pi, 'Generic_Insult_High', 'SPEECH_PARAMS_FORCE', 1)
            util.yield(100)
        end
    end)
end

function Warcry(ped_tab)
    util.create_tick_handler (function ()
        for _, pi in ipairs(ped_tab) do
            AUDIO.PLAY_PED_AMBIENT_SPEECH_NATIVE(pi, 'GENERIC_WAR_CRY', 'SPEECH_PARAMS_FORCE', 1)
            util.yield(100)
        end

    end)
end

function Provoke(ped_tab)
    util.create_tick_handler (function ()
        for _, pi in ipairs(ped_tab) do
            AUDIO.PLAY_PED_AMBIENT_SPEECH_NATIVE(pi, 'Provoke_Trespass', 'Speech_Params_Force_Shouted_Critical', 1)
            util.yield(100)
        end

    end)
end


function DelEnt(ped_tab)
    for _, Pedm in ipairs(ped_tab) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(Pedm)
        entities.delete_by_handle(Pedm)
    end
end

function Stopsound()
    for i = 0, 99 do
        AUDIO.STOP_SOUND(i)
    end
end

function IPM(targets, tar1, pname, cage_table, pid)
            local tar2 = ENTITY.GET_ENTITY_COORDS(targets)
            local disbet = SYSTEM.VDIST2(tar2.x, tar2.y, tar2.z, tar1.x, tar1.y, tar1.z)
            if disbet <= 0.5  then
            if set.alert then
                util.toast(pname..AClang.str_trans(' Caged'))
            end
            util.yield(800)

            elseif disbet >= 0.5  then
            util.yield(800)
            if set.alert then
                util.toast(pname..AClang.str_trans(' Broke Free'))
            end
            DelEnt(cage_table[pid])
            cage_table[pid] = false
            Stopsound()
            end
end

function ObjSpawn(hsel, tar1)
    local objHash = hsel
  local objS =  OBJECT.CREATE_OBJECT(objHash, tar1.x, tar1.y, tar1.z, true, true, true)
  return objS
end

function ObjFrezSpawn(hsel, tar1)
    local objHash = hsel
  local objfS =  OBJECT.CREATE_OBJECT(objHash, tar1.x, tar1.y, tar1.z, true, true, true)
  ENTITY.FREEZE_ENTITY_POSITION(objfS, true)
  return objfS
end

function SetObjCo(objS, tarx, tary, tarz)
    SEC(objS, tarx, tary, tarz, false, true, true, false)
end

function Vmod(vmod, plate)
    VEHICLE.SET_VEHICLE_FIXED(vmod)
    for M=0, 49 do
        local modn = VEHICLE.GET_NUM_VEHICLE_MODS(vmod, M)
        VEHICLE.SET_VEHICLE_MOD(vmod, M, modn -1, false)
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vmod, plate)
        VEHICLE.GET_VEHICLE_MOD_KIT(vmod, 0)
        VEHICLE.SET_VEHICLE_MOD_KIT(vmod, 0)
        VEHICLE.SET_VEHICLE_MOD(vmod, 14, 0)
        VEHICLE.TOGGLE_VEHICLE_MOD(vmod, 22, true)
        VEHICLE.TOGGLE_VEHICLE_MOD(vmod, 18, true)
        VEHICLE.TOGGLE_VEHICLE_MOD(vmod, 20, true)
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(vmod, 0, 0, 0)
        VEHICLE.SET_VEHICLE_MAX_SPEED(vmod, 100)
        VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vmod, 40)
        VEHICLE.SET_VEHICLE_BURNOUT(vmod, false)
    end
end

function Vspawn(mod, pCoor, pedSi, plate)
    
    Streament(mod)
   local vmod = VEHICLE.CREATE_VEHICLE(mod, pCoor.x, pCoor.y, pCoor.z, 0, true, true, false)
    PED.SET_PED_INTO_VEHICLE(pedSi, vmod, -1)
    VEHICLE.SET_VEHICLE_COLOURS(vmod, math.random(0, 160), math.random(0, 160))
    Vmod(vmod, plate)
    local CV = CAM.GET_GAMEPLAY_CAM_RELATIVE_HEADING()
    ENTITY.SET_ENTITY_HEADING(vmod, CV)
end

function Delcar(vic, spec, pid)
    if PED.IS_PED_IN_ANY_VEHICLE(vic) ==true then
        local tarcar = PED.GET_VEHICLE_PED_IS_IN(vic, true)
        GetControl(tarcar, spec, pid)
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(tarcar)
        entities.delete_by_handle(tarcar)
    end
end

function SmashCar(Veh_h, tar1,  invis_aveh, rate)
   local  CC = VEHICLE.CREATE_VEHICLE(Veh_h, tar1.x, tar1.y, tar1.z + 5.0, 0, true, true, false)
   if invis_aveh then
    ENTITY.SET_ENTITY_VISIBLE(CC, false, 0)
end
    ENTITY.SET_ENTITY_INVINCIBLE(CC, true)
    ENTITY.SET_ENTITY_VELOCITY(CC, 0, 0, -1000)
    VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(CC, true)
    VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_NON_SCRIPT_PLAYERS(CC, true)
    util.yield(rate)
    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(CC)
    entities.delete_by_handle(CC)
end

function RamCar(Veh_h, tar1x, tar1y, tar1z, invis_aveh, targets, rate)
    local RC = VEHICLE.CREATE_VEHICLE(Veh_h, tar1x, tar1y, tar1z, 0, true, true, false)
    if invis_aveh then
        ENTITY.SET_ENTITY_VISIBLE(RC, false, 0)
    end
    PFP(RC, targets)
    ENTITY.SET_ENTITY_INVINCIBLE(RC, true)
    VEHICLE.SET_VEHICLE_FORWARD_SPEED(RC, 1000)
    VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(RC, true)
    VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_NON_SCRIPT_PLAYERS(RC, true)
    util.yield(rate)
    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(RC)
    entities.delete_by_handle(RC)
end

function JuggleCar(Vehj_h, tar1,  invisjugc, jugr)
    local  CC = VEHICLE.CREATE_VEHICLE(Vehj_h, tar1.x, tar1.y, tar1.z - 5.0, 0, true, true, false)
    if invisjugc then
     ENTITY.SET_ENTITY_VISIBLE(CC, false, 0)
 end
     ENTITY.SET_ENTITY_INVINCIBLE(CC, true)
     ENTITY.SET_ENTITY_VELOCITY(CC, 0, 0, 1000)
     VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(CC, true)
     VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_NON_SCRIPT_PLAYERS(CC, true)
     util.yield(jugr)
     ENTITY.SET_ENTITY_AS_MISSION_ENTITY(CC)
     entities.delete_by_handle(CC)
end

function Getveh(vic)
    local tick = 0
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vic)
    while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vic) do
        local nid = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(vic)
        NETWORK.SET_NETWORK_ID_CAN_MIGRATE(nid, true)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vic)
        util.yield()
        tick =  tick + 1
        if tick > 10 then
            if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vic) then
                if set.alert then
                    AClang.toast('Could not gain control')
                end
                util.stop_thread()
            end
        
        end
    end
end

function GetControl(vic, spec, pid)
    if pid == playerid then
        return
    end    
    if not players.exists(pid) then
        util.stop_thread()
    end
    local tick = 0
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vic)
    while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vic) do
        local nid = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(vic)
        NETWORK.SET_NETWORK_ID_CAN_MIGRATE(nid, true)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vic)
        util.yield()
        tick =  tick + 1
        if tick > 10 then
            if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vic) then
                if set.alert then
                    AClang.toast('Could not gain control')
                end
                if not spec then
                    Specoff(pid)
                end
                util.stop_thread()
            end
        
        end
    end


end

function Disbet(pid)
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
    local play = ENTITY.GET_ENTITY_COORDS(playerped, true)
    local disbet = SYSTEM.VDIST2(play.x, play.y, play.z, tar1.x, tar1.y, tar1.z)
    return disbet
end

function Specon(pid)
    menu.trigger_commands("spectate".. players.get_name(pid).. ' on')
    util.yield(3000)
end

function Specoff(pid)
    menu.trigger_commands("spectate".. players.get_name(pid).. ' off')
end

function Maxoutcar(pid)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    GetControl(vmod, spec, pid)
     Vmod(vmod, AClang.str_trans("URWLCUM"))
     VEHICLE.SET_VEHICLE_WHEEL_TYPE(vmod, math.random(0, 7))
     VEHICLE.SET_VEHICLE_MOD(vmod, 23, math.random(-1, 50))
     ENTITY.SET_ENTITY_INVINCIBLE(vmod, true)
     if set.alert then
     AClang.toast('Vehicle Maxed out')
     end
end

function Platechange(cusplate, pid)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vmod, cusplate)
    if set.alert then
    AClang.toast('Vehicle plate changed')
    end
end

function Fixveh(pid)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FIXED(vmod)
    if set.alert then
    AClang.toast('Vehicle Repaired')
    end
end

function Accelveh( speed, pid)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FORWARD_SPEED(vmod, speed)
    if set.alert then
    AClang.toast('Vehicle Accelerated')
    end
end

function Stopveh(pid)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FORWARD_SPEED(vmod, -1000)
    ENTITY.SET_ENTITY_VELOCITY(vmod, 0, 0, 0)
    VEHICLE.SET_VEHICLE_ENGINE_ON(vmod, false, false, false)
    if set.alert then
    AClang.toast('Slowing down Vehicle')
    end
end

function Rpaint(pid)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FIXED(vmod)
    VEHICLE.SET_VEHICLE_COLOURS(vmod, math.random(0, 160), math.random(0, 160))
    if set.alert then
    AClang.toast('Vehicle Painted')
    end
end

function GetPlayVeh(pid, opt)

    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    if not players.exists(pid) then
        util.stop_thread()
    end
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if set.alert then
        AClang.toast('Getting control of vehicle')
    end
    if Disbet(pid) > 750000  then
        Specon(pid)
    if PED.IS_PED_IN_ANY_VEHICLE(pedm, true) then
        opt()
        if not spec then
            Specoff(pid)
        end
        return
    else
        if set.alert then
        AClang.toast('Player not in vehicle')
        end
        Specoff(pid)
    end
    elseif Disbet(pid) < 750000 then
        if PED.IS_PED_IN_ANY_VEHICLE(pedm, true) then
            opt()
            if not spec then
                Specoff(pid)
            end
        return
        end
    else
        if set.alert then
        AClang.toast('Player not in vehicle')
        end
    end
end

function RGBNeonKit(pedm)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    for i = 0, 3 do
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vmod, i, true)
    end
end

function Changewheel(pid, wtype, wheel)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
    local vhash = ENTITY.GET_ENTITY_MODEL(vmod)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
        GetControl(vmod, spec, pid)
    if VEHICLE.IS_THIS_MODEL_A_BIKE(vhash) then
        VEHICLE.SET_VEHICLE_WHEEL_TYPE(vmod, wtype)
        VEHICLE.SET_VEHICLE_MOD(vmod, 23, wheel)
        VEHICLE.SET_VEHICLE_MOD(vmod, 24, wheel)
    else
        VEHICLE.SET_VEHICLE_WHEEL_TYPE(vmod, wtype)
        VEHICLE.SET_VEHICLE_MOD(vmod, 23, wheel)
    end
end


function Changehead(pid, color)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
        GetControl(vmod, spec, pid)
    VEHICLE.TOGGLE_VEHICLE_MOD(vmod, 22, true)
    VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vmod, color)
end

function Changeneon(pid, color)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
        GetControl(vmod, spec, pid)
    RGBNeonKit(pedm)
    VEHICLE.SET_VEHICLE_NEON_INDEX_COLOUR(vmod, color)

end

function Changetint(pid, tint)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
        GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FIXED(vmod)
    VEHICLE.SET_VEHICLE_WINDOW_TINT(vmod, tint)
end


function Changecolor(pid, color)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
        GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FIXED(vmod)
    VEHICLE.SET_VEHICLE_COLOURS(vmod, color.prim, color.sec)
end


function Changewhepercolor(pid, color)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
        GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FIXED(vmod)
    VEHICLE.SET_VEHICLE_EXTRA_COLOURS(vmod, color.per, color.whe)
end

function Changeintcolor(pid, color)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
        GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FIXED(vmod)
    VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(vmod, color)
end

function Changedashcolor(pid, color)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
        GetControl(vmod, spec, pid)
    VEHICLE.SET_VEHICLE_FIXED(vmod)
    VEHICLE.SET_VEHICLE_EXTRA_COLOUR_6(vmod, color)
end

function Changemod(pid, modtype, mod)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    if not players.exists(pid) then
        util.stop_thread()
    end
    if PED.IS_PED_IN_ANY_VEHICLE(pedm) ==true then
        local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, true)
            GetControl(vmod, spec, pid)
        VEHICLE.GET_NUM_MOD_KITS(vmod)
        VEHICLE.GET_VEHICLE_MOD_KIT(vmod)
        VEHICLE.SET_VEHICLE_MOD_KIT(vmod, 0)
        VEHICLE.SET_VEHICLE_MOD(vmod, modtype, mod, false)
    end
end

function Getmodcou(pid, mod)
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    if PED.IS_PED_IN_ANY_VEHICLE(pedm) ==true then
        local max = VEHICLE.GET_NUM_VEHICLE_MODS(vmod, mod)
        return max
    end
    
end

function CombineTables(table1, table2, table3, table4, table5, table6, table7, table8, table9, table10, table11, result)
	for _, v in ipairs(table1) do
		table.insert(result, v)
	end
	for _, v in ipairs(table2) do
		table.insert(result, v)
	end
    for _, v in ipairs(table3) do
		table.insert(result, v)
	end
	for _, v in ipairs(table4) do
		table.insert(result, v)
	end
    for _, v in ipairs(table5) do
		table.insert(result, v)
	end
	for _, v in ipairs(table6) do
		table.insert(result, v)
	end
    for _, v in ipairs(table7) do
		table.insert(result, v)
	end
	for _, v in ipairs(table8) do
		table.insert(result, v)
	end
    for _, v in ipairs(table9) do
		table.insert(result, v)
	end
	for _, v in ipairs(table10) do
		table.insert(result, v)
	end
    for _, v in ipairs(table11) do
		table.insert(result, v)
	end

end
    --memory stuff skidded from heist control
    local Int_PTR = memory.alloc_int()

    local function getMPX()
        return 'MP'.. util.get_char_slot() ..'_'
    end

    local function STAT_GET_INT(Stat)
        STATS.STAT_GET_INT(util.joaat(getMPX() .. Stat), Int_PTR, -1)
        return memory.read_int(Int_PTR)
    end
    

    function Rolladown(pid)
        local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
        local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
        GetControl(pedm, spec, pid)
        VEHICLE.ROLL_DOWN_WINDOWS(vmod)
    end

    function Rollaup(pid)
        local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
        local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
        GetControl(pedm, spec, pid)
        for i = 0, 7 do
            VEHICLE.ROLL_UP_WINDOW(vmod, i)
        end
    end
    
    function Rolldindivid(pid, win)
        local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
        local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
        GetControl(pedm, spec, pid)
        VEHICLE.ROLL_DOWN_WINDOW(vmod, win)
    end

    function Rolluindivid(pid, win)
        local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
        local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
        GetControl(pedm, spec, pid)
        VEHICLE.ROLL_UP_WINDOW(vmod, win)
    end
-------------------------------------------------------------------------------------------------------


-------------------------------- Teleports---------------------------------------------------
TeleRoot = AClang.list(onlineroot, 'Teleports', {}, '')
-- credits to Jerry this is a modified version of his property TP
local ownedprops = {
    {AClang.trans('Agency'), 826},
    {AClang.trans('Arcade'), 740},
    {AClang.trans('Auto shop'), 779},
    {AClang.trans('Bunker'), 557},
    {AClang.trans('Cargo Warehouses'), 473},
    {AClang.trans('CEO Office'),   475 },
    {AClang.trans('Facility'), 590},
    {AClang.trans('Hangar'), 569},
    {AClang.trans('MC Clubhouse'), 492,
    mcprops = {AClang.trans('MC Businesses'), loc = {
        {AClang.trans('Cocaine Lockup'), 497 },
        {AClang.trans('Counterfeit Cash'), 500 },
        {AClang.trans('Document Forgery'), 498 },
        {AClang.trans('Methamphetamine Lab'), 499 },
        {AClang.trans('Weed Farm'), 496 },
    }}},
    {AClang.trans('Night Club'), 614},
    {AClang.trans('Vehicle Warehouse'), 524}
}

local function getblip(id)
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(id)
    while blip ~= 0 do
        local blipColour = HUD.GET_BLIP_COLOUR(blip)
        if HUD.DOES_BLIP_EXIST(blip) and blipColour != 55 and blipColour != 3 then return blip end
        blip = HUD.GET_NEXT_BLIP_INFO_ID(id)
    end
end

local function tpToBlip(blip)
    local pos = HUD.GET_BLIP_COORDS(blip)
    SEC(playerped, pos.x, pos.y, pos.z, false, false, false, false)
end

local properties = {}
local function regenerateTpLocations(root)
    for k, _ in pairs(properties) do
        menu.delete(properties[k])
        properties[k] = nil
    end
    for i = 1, #ownedprops do
        local propblip = getblip(ownedprops[i][2])
        if propblip == nil then break end

        properties[ownedprops[i][1]] = menu.action(root, ownedprops[i][1], {}, '', function()
            if not HUD.DOES_BLIP_EXIST(propblip) then
                AClang.toast('Could not find property.')
                return
            end
            tpToBlip(propblip)
        end)
        if ownedprops[i].mcprops then
            local mcprops = ownedprops[i].mcprops
            local listName = mcprops[1]
            properties[listName] = menu.list(root, listName, {}, '')
            for j = 1, #mcprops.loc do
                local mcproploc = getblip(mcprops.loc[j][2])
                if propblip == nil then break end

                menu.action(properties[listName], mcprops.loc[j][1], {}, '', function() 
                    if not HUD.DOES_BLIP_EXIST(propblip) then
                        AClang.toast('Could not find property.')
                        return
                    end
                    tpToBlip(mcproploc)
                end)
            end
        end
    end
end

Proptp = AClang.list(TeleRoot, 'Property Teleports', {'tpprop'}, 'Lets you teleport to the properties you own.', function()
    regenerateTpLocations(Proptp)
end)

local vteles = AClang.list(TeleRoot, 'Vehicle Teleports', {}, '')

AClang.action(vteles, 'TP into Avenger', {'tpaven'}, 'Teleport into Avengers holding area/facility', function ()
    SEC(playerped, 514.31335, 4750.5264, -68.99592, false, false, false, false)
    end)

AClang.action(vteles, 'TP into Kosatka', {'tpkosatka'}, 'MUST HAVE CALLED IN Teleport to Kosatka Cayo Perico Heist board', function ()
    local kos = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(760))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(760))
    if kos.x ==0 and kos.y ==0 and kos.z ==0 then
        if set.alert then
            AClang.toast('Kosatka not found') 
        end
    else    SEC(playerped, 1561.1543, 385.98312, -49.68535, false, false, false, false)
    end
    end)

AClang.action(vteles, 'TP into MOC', {'tpMOC'}, 'Teleport into MOC command center/bunker', function ()
    SEC(playerped, 1103.3782, -3011.6018, -38.999435, false, false, false, false)
    end)

AClang.action(vteles, 'TP into Terrorbyte', {'tpterro'}, 'Teleport to Terrorbyte Business control', function ()
    local ter = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(632))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(632))
    if ter.x == 0 and ter.y == 0 and ter.z == 0 then
        if set.alert then
            AClang.toast('Terrorbyte not found')
        end
    else    SEC(playerped, -1421.2347, -3012.9988, -79.04994, false, false, false, false)
    end
    end)

    local cargoteles = AClang.list(TeleRoot, 'CEO Cargo Teleports', {}, '')

AClang.action(cargoteles, 'TP to Special Cargo', {'tpscargo'}, 'Teleport to Special Cargo pickup', function ()
    local cPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(478))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(478))
        if cPickup.x == 0 and cPickup.y == 0 and cPickup.z == 0 then
            if set.alert then
                AClang.toast('No Special Cargo Found')  
            end
        else
            SEC(playerped, cPickup.x, cPickup.y, cPickup.z, false, false, false, false)
        end
    end)

AClang.action(cargoteles, 'TP to Vehicle Cargo', {'tpvcargo'}, 'Teleport to Vehicle Cargo pickup', function ()
    local vPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(523))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(523))
        if vPickup.x == 0 and vPickup.y == 0 and vPickup.z == 0 then
            if set.alert then
                AClang.toast('No Vehicle Cargo Found')
            end
        else
            SEC(playerped, vPickup.x, vPickup.y, vPickup.z, false, false, false, false)
        end
    end)

    local intteles = AClang.list(TeleRoot, 'Interior Teleports', {}, '')

AClang.action(intteles, 'TP to PC', {'tpdesk'}, 'Teleport to PC at the Desk', function ()
    local pcD = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(521))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(521))
        if pcD.x ~= 0 and pcD.y ~= 0 and pcD.z ~= 0 then
            SEC(playerped, pcD.x- 1.0, pcD.y + 1.0 , pcD.z, false, false, false, false)
        else
            if set.alert then
                AClang.toast('No PC Found')  
            end
        end
    end)


    AClang.action(intteles, 'TP to Nightclub Person', {'tpNCPerson'}, 'Teleport to the Nightclub Person', function ()
        local nigh1 = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(143))
        local nigh2 = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(480))
        HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(143))
        HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(480))
            if nigh1.x ~= 0 and nigh1.y ~= 0 and nigh1.z ~= 0 then
                SEC(playerped, nigh1.x, nigh1.y, nigh1.z, false, false, false, false)
            elseif nigh2.x ~= 0 and nigh2.y ~= 0 and nigh2.z ~= 0 then
                SEC(playerped, nigh2.x, nigh2.y, nigh2.z, false, false, false, false)
            else 
                if set.alert then
                AClang.toast('No Person Found')
                end
            end

        end)

    AClang.action(intteles, 'TP to Safe', {'tpsafe'}, 'Teleport to Safe inside Agency, Arcade, or Nightclub', function ()
        local saf1 = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(108))
        local saf2 = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(207))
        HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(108))
        HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(207))
            if saf1.x ~= 0 and saf1.y ~= 0 and saf1.z ~= 0 then
                SEC(playerped, saf1.x - 1.0, saf1.y + 1.0 , saf1.z, false, false, false, false)
            elseif saf2.x ~= 0 and saf2.y ~= 0 and saf2.z ~= 0 then
                SEC(playerped, saf2.x, saf2.y + 1.0 , saf2.z, false, false, false, false)
            else
                if set.alert then
                    AClang.toast('No Safe Found')  
                end
            end
        end)

        

AClang.action(TeleRoot, 'TP to MC Product', {'tpMCproduct'}, 'Teleport to MC Club Product Pickup/Sale', function ()
    local pPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(501))
    local hPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(64))
    local bPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(427))
    local plPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(423))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(501))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(64))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(427))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(423))
        if pPickup.x == 0 and pPickup.y == 0 and pPickup.z == 0 then

        elseif pPickup.x ~= 0 and pPickup.y ~= 0 and pPickup.z ~= 0 then
            SEC(playerped, pPickup.x - 1.5, pPickup.y , pPickup.z, false, false, false, false)
            if set.alert then
                AClang.toast('TP to MC Product')   
            end
            
        end
        if hPickup.x == 0 and hPickup.y == 0 and hPickup.z == 0 then

        elseif hPickup.x ~= 0 and hPickup.y ~= 0 and hPickup.z ~= 0 then
            SEC(playerped, hPickup.x- 1.5, hPickup.y, hPickup.z, false, false, false, false)
            if set.alert then
                AClang.toast('TP to Heli')
            end
        end
        if bPickup.x == 0 and bPickup.y == 0 and bPickup.z == 0 then

        elseif bPickup.x ~= 0 and bPickup.y ~= 0 and bPickup.z ~= 0 then
            SEC(playerped, bPickup.x, bPickup.y, bPickup.z + 1.0 , false, false, false, false)
            if set.alert then
                AClang.toast('TP to Boat')
            end
        end
        if plPickup.x == 0 and plPickup.y == 0 and plPickup.z == 0 then

        elseif plPickup.x ~= 0 and plPickup.y ~= 0 and plPickup.z ~= 0 then
            SEC(playerped, plPickup.x, plPickup.y + 1.5, plPickup.z - 1, false, false, false, false)
            if set.alert then
                AClang.toast('TP to Plane')
            end
        else                 
        if set.alert then
            AClang.toast('No MC Product Found')
        end
        end


    end)

AClang.action(TeleRoot, 'TP to Bunker Supplies/Sale', {'tpBSupplies'}, 'Teleport to Bunker Supplies/Sale Pickup', function ()
        local sPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(556))
        local dPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(561))
        local fPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(477))
        local plPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(423))
                        HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(556))
                        HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(561))
                        HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(477))
                        HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(423))
            if sPickup.x == 0 and sPickup.y == 0 and sPickup.z == 0 then
            elseif sPickup.x ~= 0 and sPickup.y ~= 0 and sPickup.z ~= 0 then
                SEC(playerped, sPickup.x, sPickup.y + 2.0, sPickup.z - 1.0, false, false, false, false)
                if set.alert then
                    AClang.toast('TP to Supplies')
                end
            end
            if dPickup.x == 0 and dPickup.y == 0 and dPickup.z == 0 then
            elseif dPickup.x ~= 0 and dPickup.y ~= 0 and dPickup.z ~= 0 then
                SEC(playerped, dPickup.x, dPickup.y, dPickup.z, false, false, false, false)
                if set.alert then
                    AClang.toast('TP to Dune')
                end
            end
            if fPickup.x == 0 and fPickup.y == 0 and fPickup.z == 0 then
            elseif fPickup.x ~= 0 and fPickup.y ~= 0 and fPickup.z ~= 0 then
                SEC(playerped, fPickup.x, fPickup.y, fPickup.z + 1.0 , false, false, false, false)
                if set.alert then
                    AClang.toast('TP to Flatbed')
                end
            else
                 if set.alert then
                    AClang.toast('No Bunker Supplies Found')
                 end
            end

        end)

AClang.action(TeleRoot, 'TP to Payphone', {'tppayphone'}, 'Teleport to Payphone (must have called Franklin already)', function ()
        local payPhon = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(817))
            HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(817))
            if payPhon.x == 0 and payPhon.y == 0 and payPhon.z == 0 then
                if set.alert then
                    AClang.toast('No Payhone Found')
                end
                else
                    SEC(playerped, payPhon.x, payPhon.y, payPhon.z + 1, false, false, false, false)
            end
    end)

    AClang.action(TeleRoot, 'TP to Exotic Export Dock', {'tpEED'}, 'Teleport to Exotic Export Dock', function ()
        if HUD.DOES_BLIP_EXIST(HUD.GET_CLOSEST_BLIP_INFO_ID(780)) then
           local eDock = HUD.GET_BLIP_COORDS(HUD.GET_CLOSEST_BLIP_INFO_ID(780))
           if  eDock.x == 0 and eDock.y == 0 and eDock.z == 0
           then
            if set.alert then
            AClang.toast('Dock Not Found')
           end
            elseif eDock.x ~= 0 and eDock.y ~= 0 and eDock.z ~= 0 then
                PED.SET_PED_COORDS_KEEP_VEHICLE(playerped, 1169.5736, -2971.932, 5.9021106)
            end
        end
    end)

    local forwteles = AClang.list(TeleRoot, 'TP Forward Teleports', {}, '')

    local forw = {amount = 0.5} --credits to lance#8011
    AClang.action(forwteles, 'TP Foward', {'tpforw'}, 'Teleport Forward your set amount', function ()
        if PED.IS_PED_IN_ANY_VEHICLE(playerped, false) then
            return
        end
        local fv = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerped, 0, forw.amount, -1.0)
            SEC(playerped, fv.x , fv.y, fv.z, false, false, false, false)
    end)

     AClang.toggle_loop(forwteles, 'TP Foward Toggle', {''}, 'Teleport Forward toggle for your gamepad RB and DPAD Down', function ()
        local fv = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerped, 0, forw.amount, -1.0)
        if PED.IS_PED_IN_ANY_VEHICLE(playerped, false) then
            return
        end
        if PAD.IS_CONTROL_PRESSED(0, 187) or PAD.IS_CONTROL_PRESSED(0, 47) or PAD.IS_CONTROL_PRESSED(0, 19) and PAD.IS_CONTROL_PRESSED(0, 44) then
            SEC(playerped, fv.x , fv.y, fv.z, false, false, false, false)
        else util.yield()
        end
        util.yield(250)
    end)

    AClang.slider(forwteles, 'TP Forward Amount', {'tpslider'}, 'Adjust the amount you teleport forward by', 1, 10000, 1, 1, function (a)
        forw.amount = a*0.1
    end)


    AClang.toggle_loop(TeleRoot, 'Levitate Toggle', {''}, 'Leveitate toggle for your gamepad RB and DPAD Down', function ()
        local fv = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerped, 0, forw.amount, -1.0)
        if PED.IS_PED_IN_ANY_VEHICLE(playerped, false) then
            return
        end
        if  PAD.IS_CONTROL_PRESSED(0, 44) then
         if PAD.IS_CONTROL_PRESSED(0, 187) or PAD.IS_CONTROL_PRESSED(0, 47) or PAD.IS_CONTROL_PRESSED(0, 19) then
            menu.trigger_commands('levitate')
         end
        end
        util.yield(250)
    end)



    

 ------------------------------------------
 ------------------------------------------



 --------------------------------------------------------
-- Vehicles

local plscm = AClang.list(vehroot, 'Los Santos Customs', {}, '')

local pbodym = AClang.list(plscm, 'Body Modifications', {}, 'Only shows what is available to be changed. If they get in a new vehicle back out of Body Modifications to refresh options')

local plighm = AClang.list(plscm, 'Lights', {}, '')

  local pcolm  = AClang.list(plscm, 'Vehicle Colors', {}, '')

  local pwmenu = AClang.list(plscm, 'Wheels', {}, '')

    local vehmenu = {}
  menu.on_focus(pbodym, function ()
    for _, m in ipairs(vehmenu) do
        menu.delete(m)
    end
    vehmenu = {}
    if not players.exists(playerid) then
        util.stop_thread()
    end
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    if PED.IS_PED_IN_ANY_VEHICLE(pedm, false) then
        for _, v in pairs(Vehopts) do
            local current = VEHICLE.GET_VEHICLE_MOD(vmod, v[1] -1)
            local maxmods = Getmodcou(playerid, v[1] - 1)
            if maxmods > 0  then
                local modnames = v[2]
                local s = menu.slider(pbodym, modnames , {''}, '',  -1, maxmods  , current, 1, function (mod)
                    Changemod(playerid, v[1] -1, mod)
                end)
              table.insert(vehmenu, s)
            util.yield()
            end
        end

          for i, v in pairs(Vehtogs) do
            local current = VEHICLE.IS_TOGGLE_MOD_ON(vmod, v[1] -1)
            local tognames = v[2]
            local t = menu.toggle(pbodym, tognames, {''}, '', function (on)
                VEHICLE.TOGGLE_VEHICLE_MOD(vmod, v[1] - 1, on)
              end, current)         
            table.insert(vehmenu, t)
          util.yield()
        end
        end


end)

local pcolor = {}

AClang.list_select(pcolm, 'Primary Color', {''}, 'Changes the Primary Color on the Vehicle', Mainc, 1, 
function (t)
    pcolor.prim = t - 1
        Changecolor(playerid, pcolor)
end)

AClang.list_select(pcolm, 'Secondary Color', {''}, 'Changes the Secondary Color on the Vehicle', Mainc, 1, 
function (t)
    pcolor.sec = t - 1
        Changecolor(playerid, pcolor)
end)

AClang.list_select(pcolm, 'Pearlescent Color', {''}, 'Changes the Pearlescent Color on the Vehicle', Mainc, 1, 
function (t)
    pcolor.per = t - 1
        Changewhepercolor(playerid, pcolor)
end)

AClang.list_select(pcolm, 'Wheel Color', {''}, 'Changes the Wheel Color on the Vehicle', Mainc, 1, 
function (t)
    pcolor.whe = t - 1
        Changewhepercolor(playerid, pcolor)
end)

AClang.list_select(pcolm, 'Interior Color', {''}, 'Changes the Interior Color on the Vehicle', Mainc, 1, 
function (t)
    pcolor.int = t - 1
        Changeintcolor(playerid, pcolor.int)
end)

AClang.list_select(pcolm, 'Dashboard Color', {''}, 'Changes the Dashboard Color on the Vehicle', Mainc, 1, 
function (t)
    pcolor.das = t - 1
        Changedashcolor(playerid, pcolor.das)
end)

AClang.list_select(plighm, 'Neons', {''}, 'Changes the Neons to different colors', Mainc, 1, 
function(c)
    local ncolor = c - 1
        Changeneon(playerid, ncolor)
end)

AClang.list_select(plscm, 'Window Tints', {''}, 'Changes the Tint on the Vehicle', Til, 1, 
function (t)
    local tint = t - 1
        Changetint(playerid, tint)
end)

AClang.list_select(plighm, 'Headlights', {''}, 'Changes the Headlights to different colors', Lighc, 1, 

function(c)
    local hcolor = c - 1

        Changehead(playerid, hcolor)

end)




local pnrgb = {color= {r= 0, g = 1, b = 0, a = 1}}

AClang.action(plighm, 'Change RGB Neons', {}, 'Change the Color for the Neons to RGB of your choice', function ()
    local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerid)
    local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
    RGBNeonKit(pedm)
    local red = pnrgb.color.r * 255
    local green = pnrgb.color.g * 255
    local blue = pnrgb.color.b * 255
    VEHICLE.SET_VEHICLE_NEON_COLOUR(vmod, red, green, blue)
end)

AClang.colour(plighm, 'RGB Neon Color', {'rgbsc'}, 'Choose the Color for the Neons be changed to ', pnrgb.color, false, function(ncolor)
    pnrgb.color = ncolor
end)

AClang.list_select(pwmenu, 'Bennys Bespoke', {''}, 'Changes the wheels to Bennys Bespoke wheels', Bbw, 1, 
function(w)
    local wheel = w - 1
        Changewheel(playerid, 9, wheel)
end)


AClang.list_select(pwmenu, 'Bennys Originals', {''}, 'Changes the wheels to Bennys Originals wheels', Bow, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 8, wheel)

end)


AClang.list_select(pwmenu, 'Bike', {''}, 'Changes the wheels to Bike(motorcycle) wheels', Bw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 6, wheel)

end)


AClang.list_select(pwmenu, 'High End', {''}, 'Changes the wheels to High End wheels', Hew, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 7, wheel)
end)


AClang.list_select(pwmenu, 'Lowrider', {''}, 'Changes the wheels to Lowrider wheels', Lw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 2, wheel)
    
end)

AClang.list_select(pwmenu, 'Muscles', {''}, 'Changes the wheels to Muscle wheels', Mw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 1, wheel)

end)


AClang.list_select(pwmenu, 'Offroad', {''}, 'Changes the wheels to Offroad wheels', Orw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 4, wheel)
end)


AClang.list_select(pwmenu, 'Racing(Formula 1 Wheels)', {''}, 'Changes the wheels to Racing(Formula 1 Wheels) wheels', Rw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 10, wheel)
end)


AClang.list_select(pwmenu, 'Sport', {''}, 'Changes the wheels to Sport wheels', Spw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 0, wheel)
end)


AClang.list_select(pwmenu, 'Street', {''}, 'Changes the wheels to Street wheels', Stw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 11, wheel)
end)


AClang.list_select(pwmenu, 'SUV', {''}, 'Changes the wheels to SUV wheels', Suw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 3, wheel)
    
end)

AClang.list_select(pwmenu, 'Tracks', {''}, 'Changes the wheels to Track wheels', Trw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 12, wheel)
end)


AClang.list_select(pwmenu, 'Tuner', {''}, 'Changes the wheels to Tuner wheels', Tuw, 1,
function(w)
    local wheel = w - 1
        Changewheel(playerid, 5, wheel)
end)

local pwinmenu = AClang.list(vehroot, 'Windows', {}, '')

AClang.action(pwinmenu, 'Roll Up All Windows', {'upwin'}, 'Rolls up all windows at once', function ()
        Rollaup(playerid)
end)

AClang.action(pwinmenu, 'Roll Down All Windows', {'downwin'}, 'Rolls up all windows at once', function ()
        Rolladown(playerid)
end)


local winmen = AClang.list(pwinmenu, 'Roll Up and Down Windows', {''}, 'Roll Up and Down Individual Windows')
        
for index, name in ipairs(Windows) do
    menu.toggle(winmen, 'Roll up or down '..name, {''}, 'Roll up or down '..name, function (on)
        local win = index - 1
        local curcar = entities.get_user_vehicle_as_handle()
        local winup= on
        if winup ~= nil then
            if winup then
                VEHICLE.ROLL_DOWN_WINDOW(curcar, win)
            else
                VEHICLE.ROLL_UP_WINDOW(curcar, win)
            end
        end

    end)
    end

    





local rgbvm = AClang.list(vehroot, 'RGB Vehicle', {}, '')
local rgb = {cus = 100}

    

    AClang.toggle_loop(rgbvm, 'Custom RGB Synced', {}, 'Change the vehicle color and neon lights to custom RGB with a synced color', function ()
       if PED.IS_PED_IN_ANY_VEHICLE(playerped, true) ~= 0 then
        local vmod = PED.GET_VEHICLE_PED_IS_IN(playerped, true)
        RGBNeonKit(playerped)
        local red = (math.random(0, 255))
        local green = (math.random(0, 255))
        local blue = (math.random(0, 255))
        VEHICLE.SET_VEHICLE_NEON_COLOUR(vmod, red, green, blue)
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vmod, red, green, blue)
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vmod, red, green, blue)
        util.yield(rgb.cus)
       end
    end)

    AClang.slider(rgbvm, 'Custom RGB Speed', {''}, 'Adjust the speed of the custom RGB', 1, 1000, 100, 10, function (c)
        rgb.cus = c
    end)


    local srgb = {cus = 100}
    AClang.toggle_loop(rgbvm, 'Synced Color with Headlights', {}, 'Change the neons, headlights, interior and vehicle color to the same color', function ()
        local color = {
          {64, 1}, --blue
          {73, 2}, --eblue  
          {51, 3}, --mgreen
          {92, 4}, --lgreen
          {89, 5}, --yellow
          {88, 6}, --gshower
          {38, 7}, --orange
          {39 , 8}, --red
          {137, 9}, --ponypink
          {135, 10}, --hotpink
          {145, 11}, --purple
          {142, 12} --blacklight
        }
       if PED.IS_PED_IN_ANY_VEHICLE(playerped) ~= 0 then
        local vmod = PED.GET_VEHICLE_PED_IS_IN(playerped, true)
        RGBNeonKit(playerped)
        local rcolor = math.random(1, 12)
        VEHICLE.TOGGLE_VEHICLE_MOD(vmod, 22, true)
        VEHICLE.SET_VEHICLE_NEON_INDEX_COLOUR(vmod, color[rcolor][1])
        VEHICLE.SET_VEHICLE_COLOURS(vmod, color[rcolor][1], color[rcolor][1])
        VEHICLE.SET_VEHICLE_EXTRA_COLOURS(vmod, 0, color[rcolor][1])
        VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(vmod, color[rcolor][1])
        VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vmod, color[rcolor][2])
        util.yield(srgb.cus)
       end
    end)
  
    AClang.slider(rgbvm, 'Synced RGB Speed', {''}, 'Adjust the speed of the synced RGB', 1, 1000, 100, 10, function (c)
        srgb.cus = c
    end)
 ---------------------------------Space Docker------------------------------------------------
    local sdroot = AClang.list(vehroot, 'Lazer Space Docker', {}, 'Space Docker with lazers') --credits to Nowiry for the functions to make this work
    local lsd ={weap = 'WEAPON_RAYCARBINE', hash = util.joaat('dune2')}
    local function SDcreate(pCoor, pedSi)
        Lsdcar = VEHICLE.CREATE_VEHICLE(lsd.hash, pCoor.x, pCoor.y, pCoor.z, 0, true, true, false)
        PED.SET_PED_INTO_VEHICLE(pedSi, Lsdcar, -1)
        Vmod(Lsdcar, 'Lazers')
       local CV = CAM.GET_GAMEPLAY_CAM_RELATIVE_HEADING()
       ENTITY.SET_ENTITY_HEADING(Lsdcar, CV)
     
       local lsdweap = {
        AClang.trans('Unholy Hellbringer'),
        AClang.trans('Up-n-Atomizer'),
    }
    local lsdh = {
        'weapon_raycarbine',
        'weapon_raypistol',
    }

    Lsd_w = AClang.list_select(sdroot, 'LSD Weapon', {'lsdweap'},'Changes weapon for Lazer Space Docker', lsdweap, 1, function(vweap)
        lsd.weap = lsdh[vweap]
        end)
     
       util.create_tick_handler(function ()
            if PED.IS_PED_IN_VEHICLE(playerped, Lsdcar, false) ==true then
            VEHICLE.SET_VEHICLE_DIRT_LEVEL(Lsdcar, 0)
            ENTITY.SET_ENTITY_INVINCIBLE(Lsdcar, true)
            VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(Lsdcar, false)
            SFlsd()
            end
        end)


    end


    local get_vehicle_cam_relative_heading = function(vehicle)
        local camDir = CAM.GET_GAMEPLAY_CAM_ROT(0):toDir()
        local fwdVector = ENTITY.GET_ENTITY_FORWARD_VECTOR(vehicle)
        camDir.z, fwdVector.z = 0.0, 0.0
        local angle = math.acos(fwdVector:dot(camDir) / (#camDir * #fwdVector))
        return math.deg(angle)
    end
    local shoot_from_vehicle = function (vehicle, damage, weaponHash, ownerPed, isAudible, isVisible, speed, target, position)
        local min, max = v3.new(), v3.new()
        local offset
        MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), min, max)
        if position == 0 then
            offset = v3.new(min.x + 0.3, max.y + 0.25, 0.5)
        elseif position == 1 then
            offset = v3.new(min.x + 0.3, min.y + 4, 0.5)
        elseif position == 2 then
            offset = v3.new(max.x - 0.3, max.y + 0.25, 0.5)
        elseif position == 3 then
            offset = v3.new(max.x - 0.3, min.y + 4, 0.5)
        else
            error("got unexpected position")offset = v3.new(min.x + 0.25, max.y, 0.5)
        end
        local a = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, offset.x, offset.y - 3.15, offset.z + 1.05)
        local direction = ENTITY.GET_ENTITY_ROTATION(vehicle, 2):toDir()
        if get_vehicle_cam_relative_heading(vehicle) > 95.0 then
            direction:mul(-1)
        end
        local b = v3.new(direction)
        b:mul(300.0); b:add(a)
    
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY_NEW(
            a.x, a.y, a.z,
            b.x, b.y, b.z - 15,
            damage,
            true,
            weaponHash,
            ownerPed,
            isAudible,
            not isVisible,
            speed,
            vehicle,
            false, false, target, false, 0, 0, 0
        )
    end


    SDspawn = AClang.toggle_loop(sdroot, 'Spawn Lazer Space Docker', {'lsdspawn'}, 'Space Docker that can shoot lazers', function ()

        Streament(lsd.hash)
        local pedSi = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerid)
        local pCoor = ENTITY.GET_ENTITY_COORDS(playerped)
        local pH = ENTITY.GET_ENTITY_HEADING(pCoor)
    
            if players.is_in_interior(playerid) ==true then
                if set.alert then
                    AClang.toast('Lazer Space Docker will not Spawn in interior')
                end
                menu.set_value(SDspawn, false)
                return
            end
            
        if PED.IS_PED_IN_VEHICLE(playerped, Lsdcar, true) ==false and PED.IS_PED_IN_ANY_VEHICLE(playerped) ==true then
            local curcar = entities.get_user_vehicle_as_handle()
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(curcar)
            entities.delete_by_handle(curcar)
            if set.alert then
                AClang.toast('Fuck that car')
            end
            for i = 1, 1 do
                SDcreate(pCoor, pedSi)
            end

    
            elseif PED.IS_PED_IN_VEHICLE(playerped, Lsdcar, true) ==true then
                local weap = util.joaat(lsd.weap)
                WEAPON.REQUEST_WEAPON_ASSET(weap)
            
                if not ENTITY.DOES_ENTITY_EXIST(Lsdcar) or not PAD.IS_CONTROL_PRESSED(0, 86)
                then
                    return
                elseif get_vehicle_cam_relative_heading(Lsdcar) < 95.0 then
                    shoot_from_vehicle(Lsdcar, 200, weap, players.user_ped(), true, true, 2000.0, 0, 0)
                    shoot_from_vehicle(Lsdcar, 200, weap, players.user_ped(), true, true, 2000.0, 0, 2)
                else
                    shoot_from_vehicle(Lsdcar, 200, weap, players.user_ped(), true, true, 2000.0, 0, 1)
                    shoot_from_vehicle(Lsdcar, 200, weap, players.user_ped(), true, true, 2000.0, 0, 3)
                end


            elseif PED.IS_PED_IN_ANY_VEHICLE(playerped) ==false and not ENTITY.DOES_ENTITY_EXIST(Lsdcar) then
                SDcreate(pCoor, pedSi)
                     if set.alert then
                        AClang.toast('Lazer Space Docker Spawned')
                     end
            end
    
    if PED.IS_PED_GETTING_INTO_A_VEHICLE(playerped) ==false and PED.IS_PED_IN_VEHICLE(playerped, Lsdcar , false) ==false
                then
                    if set.alert then
                        AClang.toast('Player has left the Lazer Space Docker and it has been deleted')
                    end
            ---@diagnostic disable-next-line: param-type-mismatch
                  menu.set_value(SDspawn, false)
                  STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(lsd.hash)
                  ENTITY.SET_ENTITY_AS_MISSION_ENTITY(Lsdcar)
                  entities.delete_by_handle(Lsdcar)
                  menu.delete(Lsd_w)
                  util.stop_thread()
                end
        
    end)

    ----------------------------------------------
---------------------------------- FF9 Charger ----------------------------------
local charroot = AClang.list(vehroot, 'Charger', {}, 'Duke O Death with Electro Magnet capabilities')
local charger = {charg = util.joaat('dukes2'), emp = util.joaat('hei_prop_heist_emp')}
local function Ccreate(pCoor, pedSi)

        FFchar = VEHICLE.CREATE_VEHICLE(charger.charg, pCoor.x, pCoor.y, pCoor.z, 0, true, true, false)
        PED.SET_PED_INTO_VEHICLE(pedSi, FFchar, -1)
        VEHICLE.SET_VEHICLE_COLOURS(FFchar, 118, 0)
        Vmod(FFchar, 'Mopar')
        VEHICLE.SET_VEHICLE_WHEEL_TYPE(FFchar, 7)
        VEHICLE.SET_VEHICLE_MOD(FFchar, 23, 26)
        util.yield(150)

       local ccoor = ENTITY.GET_ENTITY_COORDS(FFchar)

        if  ENTITY.DOES_ENTITY_EXIST(charger.emp) ==false
        then Empa = OBJECT.CREATE_OBJECT(charger.emp, ccoor.x, ccoor.y -1, ccoor.z -1, true, true, true)
            ENTITY.ATTACH_ENTITY_TO_ENTITY(Empa, FFchar, 0, 0.0, -2.0, 0.5, 0.0, 0.0, 0.0, false, true, false, false, 0, true)
            local CV = CAM.GET_GAMEPLAY_CAM_RELATIVE_HEADING()
            ENTITY.SET_ENTITY_HEADING(FFchar, CV)
            util.yield()
        end

    local magtf = {true, false}
    local maglist = {AClang.str_trans('Push Away'), AClang.str_trans('Blow Up')}
    local magval = {scale = 5000, nodam = true}
    function Magout()
        if  PAD.IS_CONTROL_PRESSED(0, 86) then
        local car = ENTITY.GET_ENTITY_COORDS(playerped)
        for x = 0, 10 do
            FIRE.ADD_EXPLOSION(car.x + x, car.y, car.z, 81, magval.scale, false, true, 0.0, magval.nodam)
        end
        for y = 0, 10 do
            FIRE.ADD_EXPLOSION(car.x, car.y + y, car.z, 81, magval.scale, false, true, 0.0, magval.nodam)
        end
        end
    util.yield()
end
    Mag_int = menu.list_action(charroot, AClang.str_trans('Magnet Intensity'), {'Magint'}, AClang.str_trans('Changes Magnet to Push Away or Blow up'), maglist, function(magint)
        magval.nodam = magtf[magint]
        end)

    Mag_sca = AClang.slider(charroot, AClang.str_trans('Magnet Push Away Scale'), {}, AClang.str_trans('Change how far you push away objects'), 0, 10000, 5000, 5000, function (s)
        magval.scale = s
    end)    
      util.create_tick_handler(function ()
            if PED.IS_PED_IN_VEHICLE(playerped, FFchar, false) ==true then
            VEHICLE.SET_VEHICLE_DIRT_LEVEL(FFchar, 0)
            ENTITY.SET_ENTITY_INVINCIBLE(FFchar, true)
            VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(FFchar, false)
            SF()
            end
        end)
    end
 Spawn = AClang.toggle_loop(charroot, 'Spawn FF9 EMP Charger', {'FF9Wspawn'}, 'Spawn Charger from FF9 with Electro Magnet capabilities', function ()

    Streament(charger.charg)
    Streament(charger.emp)
    local pedSi = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerid)
    local pCoor = ENTITY.GET_ENTITY_COORDS(playerped)
    local pH = ENTITY.GET_ENTITY_HEADING(pCoor)

        if players.is_in_interior(playerid) ==true then
            if set.alert then
                AClang.toast('Charger will not Spawn in interior')
            end
            menu.set_value(Spawn, false)
            return
        end

    if PED.IS_PED_IN_VEHICLE(playerped, FFchar, true) ==false and PED.IS_PED_IN_ANY_VEHICLE(playerped) ==true then
        local curcar = entities.get_user_vehicle_as_handle()
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(curcar)
        entities.delete_by_handle(curcar)
        if set.alert then
            AClang.toast('Fuck that car')
        end
        for i = 1, 1 do
            Ccreate(pCoor, pedSi)
        end
        

        elseif PED.IS_PED_IN_VEHICLE(playerped, FFchar, true) ==true then
            Magout()
        elseif PED.IS_PED_IN_ANY_VEHICLE(playerped) ==false then
                Ccreate(pCoor, pedSi)
                 if set.alert then
                    AClang.toast('Charger Spawned')
                 end
        end

if PED.IS_PED_GETTING_INTO_A_VEHICLE(playerped) ==false and PED.IS_PED_IN_VEHICLE(playerped, FFchar , false) ==false
            then
                if set.alert then
                    AClang.toast('Player has left Charger and it has been deleted')
                end
        ---@diagnostic disable-next-line: param-type-mismatch
              menu.set_value(Spawn, false)
              ENTITY.SET_ENTITY_AS_MISSION_ENTITY(FFchar)
              entities.delete_by_handle(FFchar)
              ENTITY.SET_ENTITY_AS_MISSION_ENTITY(Empa)
              entities.delete_by_handle(Empa)
              menu.delete(Mag_int)
              menu.delete(Mag_sca)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(charger.charg)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(charger.emp)

              util.stop_thread()

            end
end)

AClang.toggle(vehroot, 'Reduce Burnout', {'Rburnout'}, 'Makes it to where the vehicle does not burnout as easily', function (tog)
    PHYSICS.SET_IN_ARENA_MODE(tog)
end)

AClang.toggle_loop(vehroot, 'Stick to Walls', {'sticktg'}, 'Makes it to where the vehicle sticks to walls(using horn boost on the lowest setting helps get up on the walls)', function ()
    local curcar = entities.get_user_vehicle_as_handle()
    if PED.IS_PED_IN_ANY_VEHICLE(playerped) then
        ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(curcar, 1, 0, 0, - 0.5, 0, true, true, true, true)
        VEHICLE.MODIFY_VEHICLE_TOP_SPEED(curcar, 40)
    else
        util.yield()
    end

end)


local horn = {speed = 40}
AClang.toggle_loop(vehroot, 'Horn Boost', {'horn'}, 'Boost the car when the horn is pressed you can hold it down to go continously', function ()
        local vmod = entities.get_user_vehicle_as_handle()
        if PLAYER.IS_PLAYER_PRESSING_HORN(playerid) then
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(vmod, horn.speed)
        end
end)

AClang.slider(vehroot, 'Change Speed for Horn Boost', {''}, 'Change Speed for Horn Boost (actual speed is roughly double the number in MPH)', 10, 150, 40, 10, function (s)
    horn.speed = s
 end)


--------------------------------------------------------------



AClang.action(onlineroot, 'Snowball Fight', {}, 'Gives everyone in the lobby Snowballs and notifies them via text', function ()
    local plist = players.list()
    local snowballs = util.joaat('WEAPON_SNOWBALL')
    for i = 1, #plist do
        local plyr = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(plist[i])
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(plyr, snowballs, 20, true)
        WEAPON.SET_PED_AMMO(plyr, snowballs, 20)
        players.send_sms(plist[i], playerid, AClang.str_trans('Snowball Fight! You now have snowballs'))
        util.yield()
    end
   
end)


AClang.action(onlineroot, 'Murica', {}, 'Gives everyone in the lobby Firework Launchers and notifies them via text', function ()
    local plist = players.list()
    local fireworks = util.joaat('weapon_firework')
    for i = 1, #plist do
        local plyr = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(plist[i])
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(plyr, fireworks, 20, true)
        WEAPON.SET_PED_AMMO(plyr, fireworks, 20)
        players.send_sms(plist[i], playerid, AClang.str_trans('Murica f*** ya! You now have Fireworks'))
        util.yield()
    end
   
end)

AClang.toggle_loop(onlineroot, 'Money Trail', {}, 'Everywhere you walk fake money appears', function ()
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerid)
    local tar1 = ENTITY.GET_ENTITY_COORDS(playerped, true)
    Streamptfx('scr_exec_ambient_fm')
    if TASK.IS_PED_WALKING(targets) or TASK.IS_PED_RUNNING(targets) or TASK.IS_PED_SPRINTING(targets) then
        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD('scr_ped_foot_banknotes', tar1.x, tar1.y, tar1.z - 1, 0, 0, 0, 1.0, true, true, true)
    end
    
end)

AClang.action(onlineroot, 'Stop Spectating', {'sspect'}, 'Stop Spectating anyone in the lobby', function ()
    Specon(playerid)
    Specoff(playerid)
end)

AClang.action(onlineroot, 'Stop Sounds', {'ssound'}, 'Stop all sounds incase they are going off constantly', function ()
    Stopsound()
end)

AClang.toggle_loop(onlineroot, 'Nightclub Popularity', {'ncmax'}, 'Keeps the Nightclub Popularity at max', function ()
    if util.is_session_started() then
        local ncpop = math.floor(STAT_GET_INT('CLUB_POPULARITY') / 10)
        if ncpop < 100 then
            menu.trigger_commands('clubpopularity 100')
            util.yield(250)
        end
    end

end)


AClang.toggle_loop(onlineroot, 'Increase Kosatka Missile Range', {'krange'}, 'You can use it anywhere in the map now', function ()
    if util.is_session_started() then
    memory.write_float(memory.script_global(262145 + 30176), 200000.0)
    end
end)

local menus = {}
--Vehicle Aliases added by Hexarobi
    AClang.toggle(onlineroot, 'Vehicle Aliases', {'Valiases'}, 'Activate the list of vehicle name aliases used for spawning, you can use this to turn it off if mulitple people have it running', function (on)
        menus.vehicle_alias = on
    end)
    menus.vehicle_aliases = menu.list(onlineroot, 'Vehicle Aliases List', {}, 'A list of vehicle name aliases used for spawning')
    for alias, vehicle in pairs(VEHICLE_ALIASES) do
        menu.action(menus.vehicle_aliases, alias, {alias}, "Spawn "..vehicle, function(click_type, pid)
                local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
                local veh = util.joaat(vehicle)
                if menus.vehicle_alias then
                    Vspawn(veh, tar1, targets, tostring(players.get_name(pid)))
                    else
                end
        end, nil, nil, COMMANDPERM_SPAWN)
    end



-------------------------------Player Options-----------------------------------------------

players.on_join(function(pid)

    AClang.divider(menu.player_root(pid), 'AcjokerScript')
    local frienm = AClang.list(menu.player_root(pid), 'Friendly', {}, '')
    local pvehmenu = AClang.list(frienm, 'Vehicles', {}, 'If you are too far away from them it will spectate them to complete task')
    local plamenu = AClang.list(frienm, 'Player Menu', {}, '')

    local firw = {speed = 1000}
    AClang.toggle_loop(frienm, 'Fireworks Show', {'firew'}, 'Start a fireworks show at the players location', function ()
          local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
          local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
          local weap = util.joaat('weapon_firework')
          WEAPON.REQUEST_WEAPON_ASSET(weap)
          FIRE.ADD_EXPLOSION(tar1.x, tar1.y, tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          FIRE.ADD_EXPLOSION(tar1.x + math.random(-50, 50), tar1.y, tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          FIRE.ADD_EXPLOSION(tar1.x, tar1.y + math.random(-50, 50), tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          FIRE.ADD_EXPLOSION(tar1.x + math.random(-50, 50), tar1.y + math.random(-50, 50), tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          FIRE.ADD_EXPLOSION(tar1.x - math.random(-50, 50), tar1.y, tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          FIRE.ADD_EXPLOSION(tar1.x, tar1.y - math.random(-50, 50), tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          FIRE.ADD_EXPLOSION(tar1.x - math.random(-50, 50), tar1.y - math.random(-50, 50), tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          FIRE.ADD_EXPLOSION(tar1.x - math.random(-50, 50), tar1.y + math.random(-50, 50), tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          FIRE.ADD_EXPLOSION(tar1.x + math.random(-50, 50), tar1.y - math.random(-50, 50), tar1.z + math.random(50, 75), 38, 1, false, false, 0, false)
          MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 4.0, tar1.x, tar1.y, tar1.z + math.random(10, 15), 200, 0, weap, 0, false, true, firw.speed)
          MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 4.0, tar1.x + math.random(-50, 50), tar1.y, tar1.z + math.random(10, 15), 200, 0, weap, 0, false, false, firw.speed)
          MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 4.0, tar1.x , tar1.y + math.random(-50, 50), tar1.z + math.random(10, 15), 200, 0, weap, 0, false, false, firw.speed)
          MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 4.0, tar1.x + math.random(-50, 50), tar1.y, tar1.z + math.random(10, 15), 200, 0, weap, 0, false, false, firw.speed)
          MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 4.0, tar1.x + math.random(-50, 50), tar1.y + math.random(-50, 50), tar1.z + math.random(10, 15), 200, 0, weap, 0, false, false, firw.speed)
          MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 4.0, tar1.x - math.random(-50, 50), tar1.y, tar1.z + math.random(10, 15), 200, 0, weap, 0, false, false, firw.speed)
          MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 4.0, tar1.x , tar1.y - math.random(-50, 50), tar1.z + math.random(10, 15), 200, 0, weap, 0, false, false, firw.speed)
          MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 4.0, tar1.x - math.random(-50, 50), tar1.y - math.random(-50, 50), tar1.z + math.random(10, 15), 200, 0, weap, 0, false, false, firw.speed)
          if not players.exists(pid) then
              util.stop_thread()
          end
      end)

AClang.toggle_loop(frienm, 'Fake Money Rain', {}, 'Rains Fake Money on the Player', function ()
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
    Streamptfx('core')
    GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD( 'ent_brk_banknotes', tar1.x, tar1.y, tar1.z + 1, 0, 0, 0, 3.0, true, true, true)
    if not players.exists(pid) then
        util.stop_thread()
    end
end)

    AClang.action(plamenu, 'Max Protect Player', {'max'}, 'Turns on Auto Heal, All Weapons, and Never wanted commands all at once', function ()
        menu.trigger_commands("bail".. players.get_name(pid))
        menu.trigger_commands("autoheal".. players.get_name(pid))
        menu.trigger_commands("arm".. players.get_name(pid))
    end, nil, nil, COMMANDPERM_FRIENDLY)

    local winmenu = AClang.list(pvehmenu, 'Windows Menu', {}, 'Works better/faster if you are near them')

    AClang.action(winmenu, 'Roll Up All Windows', {'rolluwin'}, 'Rolls up all windows at once', function ()
        GetPlayVeh(pid, function ()
            Rollaup(pid)
        end)
    end, nil, nil, COMMANDPERM_FRIENDLY)

    AClang.action(winmenu, 'Roll Down All Windows', {'rolldwin'}, 'Rolls up all windows at once', function ()
        GetPlayVeh(pid, function ()
            Rolladown(pid)
        end)
    end, nil, nil, COMMANDPERM_FRIENDLY)

    AClang.list_action(winmenu, 'Roll Up Individual Windows', {''}, 'Roll Up Individual Windows', Windows,
    function(index)
        local win = index - 1
        GetPlayVeh(pid, function ()
            Rolluindivid(pid, win)
        end)
    end)

    AClang.list_action(winmenu, 'Roll Down Individual Windows', {''}, 'Roll Down Individual Windows', Windows,
    function(index)
        local win = index - 1
        GetPlayVeh(pid, function ()
            Rolldindivid(pid, win)
        end)
    end)


    



    local lscm = AClang.list(pvehmenu, 'Los Santos Customs', {}, 'Works better/faster if you are near them')

  local bodym = AClang.list(lscm, 'Body Modifications', {}, 'Only shows what is available to be changed. If they get in a new vehicle back out of Body Modifications to refresh options')

  local lighm = AClang.list(lscm, 'Lights', {}, '')

    local colm  = AClang.list(lscm, 'Vehicle Colors', {}, '')

    local wmenu = AClang.list(lscm, 'Wheels', {}, '')



      local vehmenus = {}


        menu.on_focus(bodym, function ()
            for _, m in ipairs(vehmenus) do
                menu.delete(m)
            end
            vehmenus = {}
            if not players.exists(pid) then
                util.stop_thread()
            end
            GetPlayVeh(pid, function ()
            local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
            if PED.IS_PED_IN_ANY_VEHICLE(pedm, false) then    
               
                for _, v in pairs(Vehopts) do
                    local current = VEHICLE.GET_VEHICLE_MOD(vmod, v[1] -1)
                    local maxmods = Getmodcou(pid, v[1] - 1)
                    if maxmods > 0  then
                        local modnames = v[2]
                        local s = menu.slider(bodym, modnames , {''}, '',  -1, maxmods  , current, 1, function (mod)
                            GetPlayVeh(pid, function ()
                            Changemod(pid, v[1] -1, mod)
                            end)
                        end)
              
                     
                      table.insert(vehmenus, s)
                    util.yield()
                    end
                end

                  for i, v in pairs(Vehtogs) do
                    local current = VEHICLE.IS_TOGGLE_MOD_ON(vmod, v[1] -1)
                    local tognames = v[2]
                    local t = menu.toggle(bodym, tognames, {''}, '', function (on)
                        VEHICLE.TOGGLE_VEHICLE_MOD(vmod, v[1] - 1, on)
                      end, current)         
                    table.insert(vehmenus, t)
                  util.yield()
                end

                
                 end
                end)

        end)
           

    local color = {}


    AClang.list_select(colm, 'Primary Color', {''}, 'Changes the Primary Color on the Vehicle', Mainc, 1, 
    function (t)
        color.prim = t - 1
        GetPlayVeh(pid, function ()
            Changecolor(pid, color)
        end)
    end)

    AClang.list_select(colm, 'Secondary Color', {''}, 'Changes the Secondary Color on the Vehicle', Mainc, 1, 
    function (t)
        color.sec = t - 1
        GetPlayVeh(pid, function ()
            Changecolor(pid, color)
        end)
    end)

    AClang.list_select(colm, 'Pearlescent Color', {''}, 'Changes the Pearlescent Color on the Vehicle', Mainc, 1, 
    function (t)
        color.per = t - 1
        GetPlayVeh(pid, function ()
            Changewhepercolor(pid, color)
        end)
    end)
   
    AClang.list_select(colm, 'Wheel Color', {''}, 'Changes the Wheel Color on the Vehicle', Mainc, 1, 
    function (t)
        color.whe = t - 1
        GetPlayVeh(pid, function ()
            Changewhepercolor(pid, color)
        end)
    end)

    AClang.list_select(colm, 'Interior Color', {''}, 'Changes the Interior Color on the Vehicle', Mainc, 1, 
    function (t)
        color.int = t - 1
        GetPlayVeh(pid, function ()
            Changeintcolor(pid, color.int)
        end)
    end)

    AClang.list_select(colm, 'Dashboard Color', {''}, 'Changes the Dashboard Color on the Vehicle', Mainc, 1, 
    function (t)
        color.das = t - 1
        GetPlayVeh(pid, function ()
            Changedashcolor(pid, color.das)
        end)
    end)

    
    AClang.list_select(lighm, 'Neons', {''}, 'Changes the Neons to different colors', Mainc, 1, 
    function(c)
        local ncolor = c - 1
        GetPlayVeh(pid, function ()
            Changeneon(pid, ncolor)
        end)
    end)


    AClang.list_select(lscm, 'Window Tints', {''}, 'Changes the Tint on the Vehicle', Til, 1, 
    function (t)
        local tint = t - 1
        GetPlayVeh(pid, function ()
            Changetint(pid, tint)
        end)
        
    end)



    
    AClang.list_select(lighm, 'Headlights', {''}, 'Changes the Headlights to different colors', Lighc, 1, 

    function(c)
        local hcolor = c - 1

        GetPlayVeh(pid, function ()
            Changehead(pid, hcolor)
        end)
    end)


    
local nrgb = {color= {r= 0, g = 1, b = 0, a = 1}}

    AClang.action(lighm, 'Change RGB Neons', {}, 'Change the Color for the Neons to RGB of your choice', function ()

        GetPlayVeh(pid, function ()
            local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
            local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
            GetControl(vmod, spec, pid)
            RGBNeonKit(pedm)
            local red = nrgb.color.r * 255
            local green = nrgb.color.g * 255
            local blue = nrgb.color.b * 255
            VEHICLE.SET_VEHICLE_NEON_COLOUR(vmod, red, green, blue)
            if not spec then
                Specoff(pid)
            end
        end)
    end)


    AClang.colour(lighm, 'RGB Neon Color', {'rgbsc'}, 'Choose the Color for the Neons be changed to ', nrgb.color, false, function(ncolor)
        nrgb.color = ncolor
    end)




    AClang.list_select(wmenu, 'Bennys Bespoke', {''}, 'Changes the wheels to Bennys Bespoke wheels', Bbw, 1, 
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 9, wheel)
        end)
        
    end)


    AClang.list_select(wmenu, 'Bennys Originals', {''}, 'Changes the wheels to Bennys Originals wheels', Bow, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 8, wheel)
        end)
        
    end)


    AClang.list_select(wmenu, 'Bike', {''}, 'Changes the wheels to Bike(motorcycle) wheels', Bw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 6, wheel)
        end)
        
    end)


    AClang.list_select(wmenu, 'High End', {''}, 'Changes the wheels to High End wheels', Hew, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 7, wheel)

        end)
        
    end)


    AClang.list_select(wmenu, 'Lowrider', {''}, 'Changes the wheels to Lowrider wheels', Lw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 2, wheel)
        end)
        
    end)

    AClang.list_select(wmenu, 'Muscle', {''}, 'Changes the wheels to Muscle wheels', Mw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 1, wheel)

        end)
        
    end)


    AClang.list_select(wmenu, 'Offroad', {''}, 'Changes the wheels to Offroad wheels', Orw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 4, wheel)

        end)
        
    end)


    AClang.list_select(wmenu, 'Racing(Formula 1 Wheels)', {''}, 'Changes the wheels to Racing(Formula 1 Wheels) wheels', Rw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 10, wheel)

        end)
        
    end)


    AClang.list_select(wmenu, 'Sport', {''}, 'Changes the wheels to Sport wheels', Spw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 0, wheel)

        end)
        
    end)
    

    AClang.list_select(wmenu, 'Street', {''}, 'Changes the wheels to Street wheels', Stw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 11, wheel)

        end)
        
    end)


    AClang.list_select(wmenu, 'SUV', {''}, 'Changes the wheels to SUV wheels', Suw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 3, wheel)
        end)
      
        
    end)

    AClang.list_select(wmenu, 'Track', {''}, 'Changes the wheels to Track wheels', Trw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 12, wheel)
        end)

    end)


    AClang.list_select(wmenu, 'Tuner', {''}, 'Changes the wheels to Tuner wheels', Tuw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 5, wheel)
        end)
    end)




    AClang.action(pvehmenu, 'Max out their Vehicle', {'maxv'}, 'Max out their Vehicle with an increased top speed (will put random wheels on the Vehicle each time you press it)', function ()
        GetPlayVeh(pid,  function ()
            Maxoutcar(pid)
        end)
     end, nil, nil, COMMANDPERM_FRIENDLY)


    AClang.text_input(pvehmenu, 'Change their license plate', {'lplate'}, 'Change the license plate to a custom text', function (cusplate)
        GetPlayVeh(pid,  function ()
           Platechange(cusplate, pid)
        end)
    end)


    AClang.action(pvehmenu, 'Repair Vehicle', {'repv'}, 'Repair their vehicle', function ()
        GetPlayVeh(pid,  function ()
            Fixveh(pid)
        end)
     end, nil, nil, COMMANDPERM_FRIENDLY)

     
     AClang.click_slider(pvehmenu, 'Accelerate Vehicle', {'accel'}, 'Accelerate Vehicle Forward by your set amount (actual speed is roughly double the number in MPH)', 10, 150, 40, 10, function (s)
       local  speed = s
        GetPlayVeh(pid, function ()
           Accelveh( speed, pid)
           util.yield(1000)
        end)
    end)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    AClang.toggle_loop(pvehmenu, 'Slow Vehicle Down', {'slowv'}, 'Does not freeze them just slows down the vehicles velocity', function ()
        Specon(pid)
        GetPlayVeh(pid, function ()
            Stopveh(pid)
        end)
        return spec
    end, function ()
        
        if not spec then
            Specoff(pid)
        end
    end)

    local cvmenu = AClang.list(pvehmenu, 'Give Them a Vehicle', {}, '')

    local cus = {veh = 'toreador'}
    AClang.action(cvmenu, 'Spawn Vehicle', {'spv'}, 'Spawn them a custom vehicle the default is toreador', function ()
        local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
        Vspawn(cus.veh, tar1, targets, 'custveh')
    end, nil, nil, COMMANDPERM_FRIENDLY)

    AClang.text_input(cvmenu, 'Enter Custom Vehicle Hash', {'cussmash'}, 'Enter Vehicle Hash to change Vehicle given to player', function(cusveh)
        if not players.exists(pid) then
            util.stop_thread()
        end
        if STREAMING.IS_MODEL_A_VEHICLE(util.joaat(cusveh)) then
           cus.veh = util.joaat(cusveh)
        else
           if set.alert then
               AClang.toast('Improper Vehicle Name (check the spelling)')
           end
        end
    end, 'toreador')

    AClang.action(pvehmenu, 'Randomize Paint', {'rpaint'}, 'Randomize the Paint of their vehicle', function ()
        GetPlayVeh(pid, function ()
            Rpaint(pid)
        end)
    end, nil, nil, COMMANDPERM_FRIENDLY)

    AClang.action(pvehmenu, 'Spectate Player', {''}, AClang.str_trans('Turn on/off spectating of player'), function ()
        menu.trigger_commands("spectate".. players.get_name(pid))
    end)



    
    local trollm = AClang.list(menu.player_root(pid), 'Trolling', {}, '' )
    local pcagem = AClang.list(trollm, 'Cages', {}, '')
    local cplaym = AClang.list(trollm, 'Vehicular Assault', {}, '')
    local jplaym = AClang.list(trollm, 'Juggle Player', {}, '')
    local mrplaym = AClang.list(trollm, 'Make it Rain', {}, '')
    local eplaym = AClang.list(trollm, 'Explode Player', {}, '')
    local metmenu = AClang.list(trollm, 'Big Object Shower', {}, '')
    local ptfxmenu = AClang.list(trollm, 'PTFX Spam', {}, '')



    AClang.action(trollm, 'The Full Monty', {}, 'Activate ped cage, object cage, and explode loop at the same time', function ()
        menu.trigger_commands("EXPL".. players.get_name(pid))
        menu.trigger_commands("PCAGE".. players.get_name(pid))
        menu.trigger_commands("ObjCage".. players.get_name(pid))
    end)

 local mir = {weap = 'WEAPON_SNOWBALL', speed = 1000}
  local mirloop =  AClang.toggle_loop(mrplaym, 'Make it Rain', {'rain'}, 'Make it Rain your choice of weapon in all directions', function ()
        local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
        local weap = util.joaat(mir.weap)
        local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
        Delcar(targets, spec, pid)
        WEAPON.REQUEST_WEAPON_ASSET(weap)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z, tar1.x , tar1.y, tar1.z - 2.0, 200, 0, weap, 0, true, false, mir.speed)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y, tar1.z + 1.0, tar1.x , tar1.y, tar1.z, 200, 0, weap, 0, true, false, mir.speed)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y + 1.0, tar1.z, tar1.x , tar1.y, tar1.z, 200, 0, weap, 0, true, false, mir.speed)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x + 1.0, tar1.y , tar1.z, tar1.x , tar1.y, tar1.z, 200, 0, weap, 0, true, false, mir.speed)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x + 1.0, tar1.y + 1.0, tar1.z, tar1.x , tar1.y, tar1.z, 200, 0, weap, 0, true, false, mir.speed)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x - 1.0, tar1.y, tar1.z, tar1.x , tar1.y, tar1.z, 200, 0, weap, 0, true, false, mir.speed)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x, tar1.y - 1.0, tar1.z, tar1.x , tar1.y, tar1.z, 200, 0, weap, 0, true, false, mir.speed)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(tar1.x - 1.0, tar1.y - 1.0, tar1.z, tar1.x , tar1.y, tar1.z, 200, 0, weap, 0, true, false, mir.speed)
    
        if not players.exists(pid) then
            if set.alert then
                AClang.toast('You made them rage quit')
            end
            util.stop_thread()
        end
    end)
    
    AClang.list_select(mrplaym, 'Weapon Choices', {''}, 'Changes the weapon that rains down on them', Weaplist, 1, function(weapsel)
        mir.weap = Weap[weapsel]
    end)

   local weaspeed = AClang.slider(mrplaym, 'Weapon Speed', {''}, 'Adjust the speed of the Weapons', 100, 6000, 1000, 100, function (s)
        mir.speed = s
    end)
        
    AClang.action(trollm, 'Katy Perry', {}, 'Turn them into a Firework by hitting them up in the air with Juggle and activating Make it Rain Fireworks', function ()
        menu.set_value(weaspeed, 100)
        mir.weap = 'weapon_firework'
        menu.trigger_commands("rain".. players.get_name(pid))
        menu.trigger_commands("JuggleC".. players.get_name(pid))
    end)

    AClang.action(trollm, 'Stop the Madness', {}, 'Turn off The Full Monty and Katy Perry and stop them from being targeted', function ()
        menu.trigger_commands("FreePedcage".. players.get_name(pid))
        menu.trigger_commands("FreeObjcage".. players.get_name(pid))
        menu.trigger_commands("EXPL".. players.get_name(pid)..' off')
        menu.trigger_commands("rain".. players.get_name(pid)..' off')
        menu.trigger_commands("JuggleC".. players.get_name(pid)..' off')
    end)




local bigolist = {} 
local bigobjset  = {obj= util.joaat('prop_asteroid_01'), ptfx = false, exp = false, speed = 1000}
AClang.toggle_loop(metmenu, 'Big Object Shower', {'Oshower'}, 'Make Objects rain down from the sky', function ()
    
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local oha = bigobjset.obj --credits to lance#8011 for this function
    local r1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS( targets, math.random(-500, 500), math.random(-500, 500), 300.0)
    local r2 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS( targets, math.random(-500, 500), math.random(-500, 500), 0)
    local diff = {}
    diff.x = (r2.x - r1.x)*500
    diff.y = (r2.y - r1.y)*500
    diff.z = (r2.z - r1.z)*500
    Streament(oha)
    local bigobj = OBJECT.CREATE_OBJECT(oha, r1.x, r1.y, r1.z, true, true, true)
    ENTITY.SET_ENTITY_HAS_GRAVITY(bigobj, true)
    ENTITY.APPLY_FORCE_TO_ENTITY(bigobj, 2, diff.x, diff.y, diff.z, 0, 0, 0, 0, true, false, true, false, true)
    OBJECT.SET_OBJECT_PHYSICS_PARAMS(bigobj, 100000, 5, 1, 0, 0, .5, 0, 0, 0, 0, 0)
    util.yield(100)

    bigolist[#bigolist + 1] = bigobj
    for _, met in ipairs(bigolist) do
        local mcoor = ENTITY.GET_ENTITY_COORDS(met)
    if ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(bigolist) < 0.5 then
        Streamptfx("scr_xm_orbital")
        if bigobjset.exp then
            FIRE.ADD_EXPLOSION(mcoor.x, mcoor.y, mcoor.z, 8, 100, true, bigobjset.ptfx, 1, false)
            FIRE.ADD_EXPLOSION(mcoor.x, mcoor.y, mcoor.z, 59, 100, true, bigobjset.ptfx, 1, false)
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD('scr_xm_orbital_blast', mcoor.x, mcoor.y, mcoor.z + 10, 0, 180, 0, 10.0, true, true, true)
        end
    end
end
if #bigolist > 175 then
    DelEnt(bigolist)
    bigolist= {}
end
    util.yield(bigobjset.speed)
    if not players.exists(pid) then
        util.stop_thread()
    end

end)

AClang.toggle(metmenu, 'Orbital Cannon Explosions', {''}, 'Turn on Orbital Cannon Explosions', function (on)
    bigobjset.exp = on
end)

AClang.slider(metmenu, 'Object Speed', {''}, 'Adjust the rate objects spawn', 0, 3000, 1000, 100, function (s)
    bigobjset.speed = s
end)

AClang.list_action(metmenu, 'Object List', {''}, 'Changes Objects used for Big Object Shower', Bigobjlist, function(objsel)
    bigobjset.obj = util.joaat(Bigobj[objsel])
end)




local ptfx = {lib = 'scr_rcbarry2', sel = 'scr_clown_appears'}
AClang.toggle_loop(ptfxmenu, 'PTFX Spam', {}, 'Spam your selection of Particle Effects', function ()
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
    Streamptfx(ptfx.lib)
    GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD( ptfx.sel, tar1.x, tar1.y, tar1.z + 1, 0, 0, 0, 10.0, true, true, true)
end)

AClang.list_action(ptfxmenu, 'Ptfx List', {''}, 'Choose a PTFX from the list', Fxcorelist, function(fxsel)
    ptfx.sel = Fxha[fxsel]
    ptfx.lib = 'core'
end)




 -------------------------------------
    local exset = {exsel = 0, scale = 1000, isaud = true, invis = false, shake = 0, damage = false, delay = 1}
   local exloop = AClang.toggle_loop(eplaym, 'Explode Player Loop', {'EXPL'}, 'Explode Player in a continous loop', function ()
        local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)

        for i = -1.5, 1.5, 0.5 do
            FIRE.ADD_EXPLOSION(tar1.x, tar1.y, tar1.z + i, exset.exsel, exset.scale, exset.isaud, exset.invis, exset.shake, exset.damage)
        end
        util.yield(exset.delay)

        if not players.exists(pid) then
            if set.alert then
                AClang.toast('You made them rage quit')
            end
            util.stop_thread()
        end
    end)

   
    AClang.list_select(eplaym, 'Change Explosion Type', {''}, 'Changes Explosion used for exploding the player', Exlist, 1,
    function(index)
        exset.exsel = index - 1
    end)

    AClang.slider(eplaym, 'Explosion Damage Scale', {''}, 'Adjust the Damage Scale of the Explosions', 100, 6000, 1000, 100, function (s)
        exset.scale = s
     end)

     AClang.toggle(eplaym, 'Invisible Explosions', {''}, 'Change the Explosions to invisible', function (on)
        exset.invis = on
    end)

    AClang.toggle(eplaym, 'Inaudible Explosions', {''}, 'Change the Explosions so that you can no longer hear them', function (on)
        exset.isaud = not on
    end)

    AClang.slider(eplaym, 'Explosion Shake', {''}, 'Adjust the Camera Shake caused by the Explosions', 0, 100, 0, 10, function (sh)
        exset.shake = sh
     end)

     AClang.toggle(eplaym, 'Damage Off', {''}, 'Change the Explosions to not cause Damage', function (on)
        exset.damage = on
    end)

    AClang.slider(eplaym, 'Explosion Delay', {''}, 'Adjust the Delay in between Explosions', 0, 1000, 100, 10, function (de)
        exset.delay = de
     end)

  -------------------------------------------------






    local vehaset = {invis_aveh = false, vehasel = util.joaat('speedo2') , vehra = 1000}
   local vehaloop =  AClang.toggle_loop(cplaym, 'Vehicular Assault', {'SmashPla'},'Will Smash or Run the Player over every time they try and stand up', function ()
        local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
        local pname = PLAYER.GET_PLAYER_NAME(pid)
        local UV = ENTITY.GET_ENTITY_UPRIGHT_VALUE(targets)
        local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
        Delcar(targets, spec, pid)
        Streament(vehaset.vehasel)

        if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            SmashCar(vehaset.vehasel, tar1, vehaset.invis_aveh, vehaset.vehra)
            if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                if set.alert then
                    util.toast(pname.. AClang.str_trans(' has been smashed'))
                end
            elseif ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            RamCar(vehaset.vehasel, tar1.x + 15, tar1.y, tar1.z, vehaset.invis_aveh, targets, vehaset.vehra)
                if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                    if set.alert then
                        util.toast(pname.. AClang.str_trans(' has been run over'))
                    end
            elseif ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            RamCar(vehaset.vehasel, tar1.x - 15, tar1.y, tar1.z, vehaset.invis_aveh, targets, vehaset.vehra)
                if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                    if set.alert then
                        util.toast(pname.. AClang.str_trans(' has been run over'))
                    end
            elseif ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            RamCar(vehaset.vehasel, tar1.x, tar1.y + 15, tar1.z, vehaset.invis_aveh, targets, vehaset.vehra)
                if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                    if set.alert then
                        util.toast(pname.. AClang.str_trans(' has been run over'))
                    end
            elseif ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            RamCar(vehaset.vehasel, tar1.x, tar1.y - 15, tar1.z, vehaset.invis_aveh, targets, vehaset.vehra)
                if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                    if set.alert then
                        util.toast(pname.. AClang.str_trans(' has been run over'))
                    end
            elseif ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            RamCar(vehaset.vehasel, tar1.x - 15, tar1.y - 15, tar1.z, vehaset.invis_aveh, targets, vehaset.vehra)
                if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                    if set.alert then
                        util.toast(pname.. AClang.str_trans(' has been run over'))
                    end
            elseif ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            RamCar(vehaset.vehasel, tar1.x + 15, tar1.y + 15, tar1.z, vehaset.invis_aveh, targets, vehaset.vehra)
                if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                    if set.alert then
                        util.toast(pname.. AClang.str_trans(' has been run over'))
                    end
            elseif ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            RamCar(vehaset.vehasel, tar1.x + 15, tar1.y - 15, tar1.z, vehaset.invis_aveh, targets, vehaset.vehra)
                if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                    if set.alert then
                        util.toast(pname.. AClang.str_trans(' has been run over'))
                    end
            elseif ENTITY.IS_ENTITY_UPRIGHT(targets, UV) then
            RamCar(vehaset.vehasel, tar1.x - 15, tar1.y + 15, tar1.z, vehaset.invis_aveh, targets, vehaset.vehra)
                if ENTITY.IS_ENTITY_UPRIGHT(targets, UV) ==false then
                    if set.alert then
                        util.toast(pname.. AClang.str_trans(' has been run over'))
                    end


            else
                if set.alert then
                    util.toast(AClang.str_trans('Could not reach ') ..pname)
                end

            end
            end
            end
            end
            end
            end
            end
            end
            end
        end

        if not players.exists(pid) then

            if set.alert then
                AClang.toast('You made them rage quit')
            end
            util.stop_thread()

            
        end
    end)

    menu.set_value(vehaloop, nil)

    AClang.toggle(cplaym, 'Invisible Vehicles', {}, 'Change the assault vehicles to invisible', function (on)
        vehaset.invis_aveh = on
    end)
    local cclist = AClang.list(cplaym, 'Change Vehicle used for Vehicular Assault', {}, '')
    AClang.list_action(cclist, 'Vehicle List', {''}, 'Changes Vehicles used for Vehicular Assault', Vehlist, function(vehsel)
        vehaset.vehasel = util.joaat(Vehha[vehsel])
    end)

    AClang.slider(cplaym, 'Assault Rate', {'assaultrate'}, 'Adjust rate at which vehicles attack', 100, 4000, 1000, 100, function (ar)
        vehaset.vehra = ar
   
     end)


     AClang.text_input(cclist, 'Enter Custom Vehicle Hash', {'cussmash'}, 'Enter Vehicle Hash to change Vehicular Assault Vehicle', function(cussma)
        if not players.exists(pid) then
            util.stop_thread()
        end
         if STREAMING.IS_MODEL_A_VEHICLE(util.joaat(cussma)) then
            vehaset.vehasel = util.joaat(cussma)
         else
            if set.alert then
                AClang.toast('Improper Vehicle Name (check the spelling)')
            end
         end

  end, 'toreador')

  local juglset = {invisjugc = false, jugsel = util.joaat('speedo2') , jugr = 1000}


  local jugloop = AClang.toggle_loop(jplaym, 'Juggle Player with Vehicles', {'JuggleC'}, 'Juggles Player by hitting them upwards repeatedly', function ()
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
    local pname = PLAYER.GET_PLAYER_NAME(pid)

    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    Delcar(targets, spec, pid)
        Streament(juglset.jugsel)

    if not PED.IS_PED_RAGDOLL(targets) then
        JuggleCar(juglset.jugsel, tar1, juglset.invisjugc, juglset.jugr)
        else
            if set.alert then
                util.toast(pname..AClang.str_trans(' is being juggled'))
            end
    end

    if not players.exists(pid) then
        if set.alert then
            AClang.toast('You made them rage quit')
        end
        util.stop_thread()
    end

  end)

  menu.set_value(jugloop, nil)

   AClang.toggle(jplaym, 'Invisible Vehicles', {}, 'Change the Juggle vehicles to invisible', function (on)
    juglset.invisjugc = on
end)

local jclist = AClang.list(jplaym, 'Change Vehicle used for Juggling', {}, '')
AClang.list_action(jclist, 'Vehicle List', {''}, 'Changes Vehicles used for Juggling', Vehlist, function(jugsel)
    juglset.jugsel = util.joaat(Vehha[jugsel])
end)

AClang.slider(jplaym, 'Juggle Rate', {'jugglerate'}, 'Adjust rate at which vehicles shoot upwards', 100, 4000, 1000, 100, function (jr)
    juglset.jugr = jr
 end)

 AClang.text_input(jclist, 'Enter Custom Vehicle Hash', {'cusjug'}, 'Enter Vehicle Hash to change Juggle Vehicle', function(cusveh)
    if STREAMING.IS_MODEL_A_VEHICLE(util.joaat(cusveh)) then
        juglset.jugsel = util.joaat(cusveh)
    else
        if set.alert then
            AClang.toast('Improper Vehicle Name (check the spelling)')
        end
    end

end, 'toreador')





  local cage_table = {}
  local pedset = {mdl = 'u_m_m_jesus_01'}
 local pedca =  AClang.toggle_loop(pcagem, 'Ped Cage', {'PCAGE'}, 'Traps Player in a Cage of Peds', function ()
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
    local pname = PLAYER.GET_PLAYER_NAME(pid)
    if not cage_table[pid] then
        local peds = {}
        local pedhash = util.joaat(pedset.mdl)
        local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
        Delcar(targets, spec, pid)

        local ped_tab = {'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8'}
        for _, spawned_ped in ipairs(ped_tab) do
            spawned_ped = Pedspawn(pedhash, tar1)
            table.insert(peds,  spawned_ped)
        end

    SetPedCoor(peds[1], tar1.x, tar1.y - 0.5, tar1.z - 1.0)
    SetPedCoor(peds[2], tar1.x - 0.5, tar1.y - 0.5, tar1.z - 1.0)
    SetPedCoor(peds[3], tar1.x - 0.5, tar1.y, tar1.z - 1.0)
    SetPedCoor(peds[4], tar1.x - 0.5, tar1.y + 0.5, tar1.z - 1.0)
    SetPedCoor(peds[5], tar1.x, tar1.y + 0.5, tar1.z - 1.0)
    SetPedCoor(peds[6], tar1.x + 0.5, tar1.y + 0.5, tar1.z - 1.0)
    SetPedCoor(peds[7], tar1.x + 0.5, tar1.y, tar1.z - 1.0)
    SetPedCoor(peds[8], tar1.x + 0.5, tar1.y - 0.5, tar1.z - 1.0)

    ---------Audio--------------
    if pedhash == util.joaat('IG_LesterCrest')  then
        Teabagtime(peds[1], peds[2], peds[3], peds[4], peds[5], peds[6], peds[7], peds[8])
    elseif pedhash == util.joaat('player_two') then
        Trevortime(peds)
    elseif pedhash == util.joaat('u_m_m_jesus_01') then
        Jesuslovesyou(peds)  
    elseif pedhash ~= util.joaat('IG_LesterCrest') or util.joaat('player_two') then
    if AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(peds[1], 'GENERIC_FUCK_YOU') ==true
    then Fuckyou(peds)

    elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(peds[1], 'Provoke_Trespass')
    then Provoke(peds)

    elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(peds[1], 'Generic_Insult_High')
    then Insulthigh(peds)

    elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(peds[1], 'GENERIC_WAR_CRY')
    then Warcry(peds)
    else
    end
    end

          -----------Anim-------------------------
        Streamanim('rcmpaparazzo_2')
        Streamanim('mp_player_int_upperfinger')
        Streamanim('misscarsteal2peeing')
        Streamanim('mp_player_int_upperpeace_sign')
        local ped_anim = {peds[2], peds[3], peds[4], peds[5], peds[6], peds[7], peds[8]}
        for _, Pedanim in ipairs(ped_anim) do
            if pedhash == util.joaat('player_two') then
                Runanim(Pedanim, 'misscarsteal2peeing','peeing_loop')
               local tre = PED.GET_PED_BONE_INDEX(Pedanim, 0x2e28)
                Streamptfx('core')
               --credits to saltyscript for gfx part
               GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE("ent_amb_peeing", Pedanim, 0, 0, 0, -90, 0, 0, tre, 2, false, false, false)
            elseif pedhash == util.joaat('u_m_m_jesus_01') then
                Runanim(peds[1], 'mp_player_int_upperpeace_sign', 'mp_player_int_peace_sign')
                Runanim(Pedanim, 'mp_player_int_upperpeace_sign', 'mp_player_int_peace_sign')
            else
                Runanim(Pedanim, 'mp_player_int_upperfinger', 'mp_player_int_finger_02_fp')
                Runanim(peds[1], 'rcmpaparazzo_2', 'shag_loop_a')
            end

    end


    for _, Pedm in ipairs(peds) do
        PFP(Pedm, targets) --- ped facing player
    end


    cage_table[pid] = peds
    end --if not cage_table[pid] end

   while cage_table[pid] do
    IPM(targets, tar1, pname, cage_table, pid)


   end


    if not players.exists(pid) then

        if set.alert then
            AClang.toast('You made them rage quit')
        end
        util.stop_thread()

        cage_table[pid] = nil
    end


    end)

    local PedClist = AClang.list(pcagem, 'Change Ped for Cage', {}, 'Will Change the Ped if they move or if you delete current ped')

    AClang.action(pcagem, 'Free from Ped Cage', {'FreePedcage'}, 'Free Player from Ped Cage', function ()
        if cage_table[pid] then
            DelEnt(cage_table[pid])
            menu.set_value(pedca, false)
            cage_table[pid] = false
            else
                 if set.alert then
                    AClang.toast('No Ped Cage Found')
                 end
        end
    end)
    local pcages = {}
    CombineTables(AMC, AfC, CSP, GM, Mpp, MSF, MCM, SMC, Ssf, Ssm, Dlcp, pcages)
    local rcage_table = {}
    local rpedca =  AClang.toggle_loop(pcagem, 'Random Ped Cage', {'PCAGE'}, 'Traps Player in a Cage of Random Peds', function ()
      local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
      local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
      local pname = PLAYER.GET_PLAYER_NAME(pid)
      if not rcage_table[pid] then
          local rpeds = {}
          local rpedind = math.random(1, #pcages)
          local rpedset = pcages[rpedind]
          local pedhash = util.joaat(rpedset)
          local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
          Delcar(targets, spec, pid)
  
          local ped_tab = {'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8'}
        for _, spawned_ped in ipairs(ped_tab) do
            spawned_ped = Pedspawn(pedhash, tar1)
            table.insert(rpeds,  spawned_ped)
        end

  
        SetPedCoor(rpeds[1], tar1.x, tar1.y - 0.5, tar1.z - 1.0)
        SetPedCoor(rpeds[2], tar1.x - 0.5, tar1.y - 0.5, tar1.z - 1.0)
        SetPedCoor(rpeds[3], tar1.x - 0.5, tar1.y, tar1.z - 1.0)
        SetPedCoor(rpeds[4], tar1.x - 0.5, tar1.y + 0.5, tar1.z - 1.0)
        SetPedCoor(rpeds[5], tar1.x, tar1.y + 0.5, tar1.z - 1.0)
        SetPedCoor(rpeds[6], tar1.x + 0.5, tar1.y + 0.5, tar1.z - 1.0)
        SetPedCoor(rpeds[7], tar1.x + 0.5, tar1.y, tar1.z - 1.0)
        SetPedCoor(rpeds[8], tar1.x + 0.5, tar1.y - 0.5, tar1.z - 1.0)
  
      ---------Audio--------------
      if pedhash == util.joaat('IG_LesterCrest')  then
        Teabagtime(rpeds[1], rpeds[2], rpeds[3], rpeds[4], rpeds[5], rpeds[6], rpeds[7], rpeds[8])
      elseif pedhash == util.joaat('player_two') then
          Trevortime(rpeds)
      elseif pedhash == util.joaat('u_m_m_jesus_01') then
          Jesuslovesyou(rpeds)  
      elseif pedhash ~= util.joaat('IG_LesterCrest') or util.joaat('player_two') then
      if AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(rpeds[1], 'GENERIC_FUCK_YOU') ==true
      then Fuckyou(rpeds)
  
      elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(rpeds[1], 'Provoke_Trespass')
      then Provoke(rpeds)
  
      elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(rpeds[1], 'Generic_Insult_High')
      then Insulthigh(rpeds)
  
      elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(rpeds[1], 'GENERIC_WAR_CRY')
      then Warcry(rpeds)
      else
      end
      end
  
            -----------Anim-------------------------
          Streamanim('rcmpaparazzo_2')
          Streamanim('mp_player_int_upperfinger')
          Streamanim('misscarsteal2peeing')
          Streamanim('mp_player_int_upperpeace_sign')
          local ped_anim = {rpeds[2], rpeds[3], rpeds[4], rpeds[5], rpeds[6], rpeds[7], rpeds[8]}
          for _, Pedanim in ipairs(ped_anim) do
              if pedhash == util.joaat('player_two') then
                  Runanim(Pedanim, 'misscarsteal2peeing','peeing_loop')
                 local tre = PED.GET_PED_BONE_INDEX(Pedanim, 0x2e28)
                  Streamptfx('core')
                 --credits to saltyscript for gfx part
                 GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE("ent_amb_peeing", Pedanim, 0, 0, 0, -90, 0, 0, tre, 2, false, false, false)
              elseif pedhash == util.joaat('u_m_m_jesus_01') then
                  Runanim(rpeds[1], 'mp_player_int_upperpeace_sign', 'mp_player_int_peace_sign')
                  Runanim(Pedanim, 'mp_player_int_upperpeace_sign', 'mp_player_int_peace_sign')
              else
                  Runanim(Pedanim, 'mp_player_int_upperfinger', 'mp_player_int_finger_02_fp')
                  Runanim(rpeds[1], 'rcmpaparazzo_2', 'shag_loop_a')
              end
  
      end

  
      for _, Pedm in ipairs(rpeds) do
          PFP(Pedm, targets) --- ped facing player
      end
  
  
      rcage_table[pid] = rpeds
      end --if not cage_table[pid] end
  
     while rcage_table[pid] do
      IPM(targets, tar1, pname, rcage_table, pid)
     end

      if not players.exists(pid) then
  
          if set.alert then
              AClang.toast('You made them rage quit')
          end
          util.stop_thread()
  
          rcage_table[pid] = nil
      end
  
  
      end)
  
    
      AClang.action(pcagem, 'Free from Random Ped Cage', {'FreeRPedcage'}, 'Free Player from Random Ped Cage', function ()
          if rcage_table[pid] then
              DelEnt(rcage_table[pid])
              menu.set_value(rpedca, false)
              rcage_table[pid] = false
              else
                   if set.alert then
                      AClang.toast('No Ped Cage Found')
                   end
          end
      end)


    local obj_table = {}
    local objset = {mdl = 'prop_mineshaft_door'}
 local objca = AClang.toggle_loop(pcagem, 'Object Cage', {'ObjCage'}, 'Traps Player in a Cage of Objects', function ()
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
    local pname = PLAYER.GET_PLAYER_NAME(pid)

    if not obj_table[pid] then
        local objs = {}

        local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
        Delcar(targets, spec, pid)
        
local hsel = util.joaat(objset.mdl)
        Streament(hsel)
        local obj_tab = {'o1', 'o2', 'o3', 'o4', 'o5', 'o6', 'o7', 'o8'}
        for _, spawned_obj in ipairs(obj_tab) do
            spawned_obj =  ObjFrezSpawn(hsel, tar1)
            table.insert(objs,  spawned_obj)
        end
        obj_table[pid] = objs

        SetObjCo(objs[1], tar1.x, tar1.y - 0.5, tar1.z - 1.0)
        SetObjCo(objs[2], tar1.x - 0.5, tar1.y - 0.5, tar1.z - 1.0)
        SetObjCo(objs[3], tar1.x - 0.5, tar1.y, tar1.z - 1.0)
        SetObjCo(objs[4], tar1.x - 0.5, tar1.y + 0.5, tar1.z - 1.0)
        SetObjCo(objs[5], tar1.x, tar1.y + 0.5, tar1.z - 1.0)
        SetObjCo(objs[6], tar1.x + 0.5, tar1.y + 0.5, tar1.z - 1.0)
        SetObjCo(objs[7], tar1.x + 0.5, tar1.y, tar1.z - 1.0)
        SetObjCo(objs[8], tar1.x + 0.5, tar1.y - 0.5, tar1.z - 1.0)

        ENTITY.SET_ENTITY_ROTATION(objs[1], 0, 0, 180, 1, true)
        ENTITY.SET_ENTITY_ROTATION(objs[2], 0, 0, 135, 1, true)
        ENTITY.SET_ENTITY_ROTATION(objs[3], 0, 0, 90, 1, true)
        ENTITY.SET_ENTITY_ROTATION(objs[4], 0, 0, 45, 1, true)
        ENTITY.SET_ENTITY_ROTATION(objs[6], 0, 0, 315, 1, true)
        ENTITY.SET_ENTITY_ROTATION(objs[7], 0, 0, 270, 1, true)
        ENTITY.SET_ENTITY_ROTATION(objs[8], 0, 0, 225, 1, true)

        

        for _, horn in ipairs(objs) do
            AUDIO.PLAY_SOUND_FROM_ENTITY(-1, 'Alarm_Interior', horn, 'DLC_H3_FM_FIB_Raid_Sounds', 0, 0)
        end


    
    end
while obj_table[pid] do
    IPM(targets, tar1, pname, obj_table, pid)
end

if not players.exists(pid) then

    if set.alert then
        AClang.toast('You made them rage quit')
    end
    util.stop_thread()

    obj_table[pid] = nil
end

 end)

 local ObjSlist = AClang.list(pcagem, 'Change Object for Cage', {}, 'Will Change the Object if they move or if you delete current object')

 AClang.action(pcagem, 'Free from Object Cage', {'FreeObjcage'}, 'Free Player from Object Cage', function ()
    if obj_table[pid] then
        DelEnt(obj_table[pid])
        menu.set_value(objca, false)
        Stopsound()
        obj_table[pid] = false
        else
            if set.alert then
                AClang.toast('No Obj Cage Found')    
            end
    end

end)

 ------------------NPC List Actions------------

 AClang.list_action(PedClist, 'Special Ped Cages', {''}, 'Changes Peds to One of the Custom Pedcages', SPClist, function(pedsel)
    pedset.mdl = SPC[pedsel]
end)

 ----------------------------------Ambient Females-------------------------------

    AClang.list_action(PedClist, 'Ambient Female NPCs', {''}, 'Changes Peds to Ambient Females', AfClist, function(pedsel)
        pedset.mdl = AfC[pedsel]
    end)

    -------------------------------------------------------------------------------------------------
 ------------------------------------------Ambient Males-----------------------------------------------------------

    AClang.list_action(PedClist, 'Ambient Male NPCs', {''}, 'Changes Peds to Ambient Males', AMClist, function(pedsel)
    pedset.mdl = AMC[pedsel]
    end)

 -------------------------------------------------------------------------------------------    
 -----------------------------------Cutscene Peds--------------------------------------------------------------

    AClang.list_action(PedClist, 'Cutscene Peds', {''}, 'Changes Peds to Cutscene Peds(dont usually speak)', Csplist, function(pedsel)
        pedset.mdl = CSP[pedsel]
    end)

 ------------------------------------------------------------------------------------------------------
 -------------------------------------Gang Members--------------------------------------------------------

    AClang.list_action(PedClist, 'Gang Members', {''}, 'Changes Peds to Gang Members', GMlist, function(pedsel)
        pedset.mdl = GM[pedsel]
    end)

    ------------------------------------------------------------------------
 ----------------------------------------Multiplayer------------------------------------------------------------

    AClang.list_action(PedClist, 'Multiplayer Peds', {''}, 'Changes Peds to Multiplayer Peds', Mpplist, function(pedsel)
        pedset.mdl = Mpp[pedsel]
    end)

----------------------------------------------------------------------------------------------------------
    ------------------------------MP Scenario Females----------------------------------------

        AClang.list_action(PedClist, 'Multiplayer Scenario Females', {''}, 'Changes Peds to Multiplayer Scenario Females', MSFlist, function(pedsel)
            pedset.mdl = MSF[pedsel]
        end)

    ----------------------------------------------------------------------------------
 ----------------------------------MP Scenario Males-------------------------------------------------------

    AClang.list_action(PedClist, 'Multiplayer Scenario Males', {''}, 'Changes Peds to Multiplayer Scenario Males', MCMlist, function(pedsel)
        pedset.mdl = MCM[pedsel]
    end)

 -------------------------------------------------------------------------------------


 -----------------------------------------Story Mode---------------------------------------------------

        AClang.list_action(PedClist, 'Story Mode Characters', {''}, 'Changes Peds to Story Mode Characters', SMClist, function(pedsel)
            pedset.mdl = SMC[pedsel]
        end)
    --------------------------------------------------------------------------------

    --------------------------------Story Scenario Females-------------------------------------------------------
        AClang.list_action(PedClist, 'Story Scenario Females', {''}, 'Changes Peds to Story Scenario Females', Ssflist, function(pedsel)
            pedset.mdl = Ssf[pedsel]
        end)
  ------------------------------------------------------------------------------------------------------

  -------------------------------------------Story Scenario Males---------------------------------------------------------
    AClang.list_action(PedClist, 'Story Scenario Males', {''}, 'Changes Peds to Story Scenario Males', Ssmlist, function(pedsel)
        pedset.mdl = Ssm[pedsel]
    end)

  ---------------------------------------------------------------------------------------------------
  -----------------------------------DLC Peds------------------------------------------------------------
    AClang.list_action(PedClist, 'DLC Peds', {''}, 'Changes Peds to Peds from the DLCs', Dlcplist, function(pedsel)
        pedset.mdl = Dlcp[pedsel]
    end)


 -----------------Object Actions----------
 -----signs---
 AClang.list_action(ObjSlist, 'Street Signs', {''}, 'Changes Objects to Street Signs', Siglist, function(objsel)
    objset.mdl = Sigha[objsel]
end)

 -----Doors---
 AClang.list_action(ObjSlist, 'Doors', {''}, 'Changes Objects to Doors', Dolist, function(objsel)
    objset.mdl = Doha[objsel]
end)

 ------Interior---
 AClang.list_action(ObjSlist, 'Interior', {''}, 'Changes Objects to Interior Props', Interlist, function(objsel)
    objset.mdl = Intob[objsel]
end)

 ------Exterior---
 AClang.list_action(ObjSlist, 'Exterior', {''}, 'Changes Objects to Exterior Props', Extlist, function(objsel)
    objset.mdl = Extob[objsel]
end)

 -------------------------------Player Join End-----------------------------------------------------------------------------

end)





players.dispatch_on_join()



 -------------------
 AClang.action(setroot, 'Version Number', {}, tostring(localVer), function ()
 end)

 AClang.hyperlink(setroot, 'Join the Discord', 'https://discord.gg/fn4uBbFNnA', 'Join the AcjokerScript Discord if you have any problems, want to suggest features, or want to help with translations')

 Credroot = AClang.list(setroot, 'Credits', {}, '')
 AClang.action(Credroot, 'Jerry123', {}, 'For major help with multiple portions of the script and his LangLib for translations', function ()
 end)
 AClang.action(Credroot, 'Keramis', {}, 'For the tutorial I would have had a harder time without it', function ()
 end)
 AClang.action(Credroot, 'aaron', {}, 'For the ScaleformLib script and help with executing it', function ()
 end)
 AClang.action(Credroot, 'Nowiry', {}, 'For their script it was a heavy influence on the Charger weapon', function ()
 end)
 AClang.action(Credroot, 'hexarobi', {}, 'For all the help with the script they are always a big help', function ()
 end)
 AClang.action(Credroot, 'Prisuhm', {}, 'For the auto updater and help with it', function ()
 end)
 AClang.action(Credroot, 'lance', {}, 'For a couple functions in this script', function ()
 end)
 AClang.action(Credroot, '=)', {}, 'For the peeing animation for Trevor', function ()
 end)
 AClang.action(Credroot, 'ICYPhoenix', {}, 'For the Ped Facing Ped function used in Ped Cage', function ()
 end)
 Troot = AClang.list(Credroot, 'Translators', {}, '')
 AClang.action(Troot, 'lu_zi', {}, 'For the Chinese translations', function ()
 end)
 AClang.action(Troot, 'akaitawa', {}, 'For the Portuguese translations', function ()
 end)
 AClang.action(Troot, '- THEKING -', {}, 'For the German translations', function ()
 end)
 AClang.action(Troot, 'Laavi', {}, 'For the Dutch translations', function ()
 end)
 AClang.action(Troot, 'akatozi and BloodyStall_', {}, 'For the French translations', function ()
 end)
  -------------------------------------------------------------------------------------------------------
 local response = false
async_http.init("raw.githubusercontent.com", "/acjoker8818/AcjokerScript/main/AcjokerScriptVersion", function(output)
    local currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        AClang.toast("New AcjokerScript version is available, update the lua to get the newest version.")
        AClang.action(menu.my_root(), AClang.str_trans("Update Lua"), {}, "", function()
            while response do
                util.toast('Downloading AcjokerScript Files')
                util.yield()

            local lang = {
                'ACPortuguese.lua',
                'ACFrench.lua',
                'ACLithuanian.lua',
                'ACGerman.lua',
                'ACDutch.lua',
                'ACSpanish.lua',
                'ACPolish.lua',
                'ACChinese.lua'
            }
    
            for _, file in ipairs(lang) do
                async_http.init('raw.githubusercontent.com','/acjoker8818/AcjokerScript/main/'.. file,function(a)
                    local err = select(2,load(a))
                    if err then
                        AClang.toast("Languages failed to download. Please try again later. If this continues to happen then manually update via github.")
                    return end
                    local f = io.open(filesystem.resources_dir() .. 'AcjokerScript\\Languages\\'.. file, "wb")
                    f:write(a)
                    f:close()
                end)
                util.yield(500)
                async_http.dispatch() 
            end
            util.yield(500)

            

    async_http.init('raw.githubusercontent.com','/acjoker8818/AcjokerScript/main/AcjokerScript.lua',function(b)
        local err = select(2,load(b))
        if err then
            AClang.toast("Main Script failed to download. Please try again later. If this continues to happen then manually update via github.")
        return end
        local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
        f:write(b)
        f:close()
    end)
    async_http.dispatch()
    util.yield(500)

    async_http.init('raw.githubusercontent.com','/acjoker8818/AcjokerScript/main/ACJSTables.lua',function(c)
        local err = select(2,load(c))
        if err then
            AClang.toast("ACJSTables.lua failed to download. Please try again later. If this continues to happen then manually update via github.")
        return end
        local f = io.open(filesystem.resources_dir() .. 'AcjokerScript\\ACJSTables.lua', "wb")
        f:write(c)
        f:close()
    end)
    async_http.dispatch()  
    util.yield(500)

    async_http.init('raw.githubusercontent.com','/acjoker8818/AcjokerScript/main/AClangLib.lua',function(d)
        local err = select(2,load(d))
        if err then
            AClang.toast("AClanglib.lua failed to download. Please try again later. If this continues to happen then manually update via github.")
        return end
        local f = io.open(filesystem.resources_dir()..'AcjokerScript\\AClangLib.lua', "wb")
        f:write(d)
        f:close()
        AClang.toast("Successfully updated AcjokerScript :)")
        util.restart_script()
    end)
    async_http.dispatch()  
    util.yield(100)
end
        end)
    end
end, function() response = true end)
async_http.dispatch()
repeat 
    util.yield()
until response


util.keep_running()


