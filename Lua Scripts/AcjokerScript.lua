   --credits to Keramis for the tutorial
   --credits to Jerry123 for major help with multiple portions of the script and his LangLib for translations
   --credits to Sapphire for the help in programming they are the real MVP for helping everyone
   --credits to Vsus and ghozt for pointing me in the right direction
   --credits to Nowiry for their script it was a heavy influence on the Charger weapon
   --credits to aaronlink127#0127 for the ScaleformLib script and help with executing it
   --Script made by acjoker8818
   -------------------------------------------------------------------------
   
--github
Load = true
local localVer = 1.8 -- all credits for the updater go to Prisuhm#7717 Thank You
util.require_natives(1663599433)
util.ensure_package_is_installed('lua/ScaleformLib')
local AClang = require ('lib/AClangLib')
LANG_SETTINGS = {}
SEC = ENTITY.SET_ENTITY_COORDS
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
    local play = ENTITY.GET_ENTITY_COORDS(players.user_ped(), true)
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
-------------------------------------------------------------------------------------------------------


-------------------------------- Teleports---------------------------------------------------
TeleRoot = AClang.list(onlineroot, 'Teleports', {}, '')
AClang.action(TeleRoot, 'TP into Avenger', {'tpaven'}, 'Teleport into Avengers holding area/facility', function ()
    SEC(players.user_ped(), 514.31335, 4750.5264, -68.99592, false, false, false, false)
    end)

AClang.action(TeleRoot, 'TP into Kosatka', {'tpkosatka'}, 'MUST HAVE CALLED IN Teleport to Kosatka Cayo Perico Heist board', function ()
    local kos = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(760))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(760))
    if kos.x ==0 and kos.y ==0 and kos.z ==0 then
        if set.alert then
            AClang.toast('Kosatka not found') 
        end
    else    SEC(players.user_ped(), 1561.1543, 385.98312, -49.68535, false, false, false, false)
    end
    end)

AClang.action(TeleRoot, 'TP into MOC', {'tpMOC'}, 'Teleport into MOC command center/bunker', function ()
    SEC(players.user_ped(), 1103.3782, -3011.6018, -38.999435, false, false, false, false)
    end)

AClang.action(TeleRoot, 'TP into Terrorbyte', {'tpterro'}, 'Teleport to Terrorbyte Business control', function ()
    local ter = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(632))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(632))
    if ter.x ==0 and ter.y ==0 and ter.z ==0 then
        if set.alert then
            AClang.toast('Terrorbyte not found')
        end
    else    SEC(players.user_ped(), -1421.2347, -3012.9988, -79.04994, false, false, false, false)
    end
    end)

AClang.action(TeleRoot, 'TP to Special Cargo', {'tpscargo'}, 'Teleport to Special Cargo pickup', function ()
    local cPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(478))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(478))
        if cPickup.x == 0 and cPickup.y == 0 and cPickup.z == 0 then
            if set.alert then
                AClang.toast('No Special Cargo Found')  
            end
        else
            SEC(players.user_ped(), cPickup.x, cPickup.y, cPickup.z, false, false, false, false)
        end
    end)

AClang.action(TeleRoot, 'TP to Vehicle Cargo', {'tpvcargo'}, 'Teleport to Vehicle Cargo pickup', function ()
    local vPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(523))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(523))
        if vPickup.x == 0 and vPickup.y == 0 and vPickup.z == 0 then
            if set.alert then
                AClang.toast('No Vehicle Cargo Found')
            end
        else
            SEC(players.user_ped(), vPickup.x, vPickup.y, vPickup.z, false, false, false, false)
        end
    end)
AClang.action(TeleRoot, 'TP to PC', {'tpdesk'}, 'Teleport to PC at the Desk', function ()
    local pcD = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(521))
    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(521))
        if pcD.x == 0 and pcD.y == 0 and pcD.z == 0 then
            if set.alert then
                AClang.toast('No PC Found')  
            end
        else
                SEC(players.user_ped(), pcD.x- 1.0, pcD.y + 1.0 , pcD.z, false, false, false, false)
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
            SEC(players.user_ped(), pPickup.x - 1.5, pPickup.y , pPickup.z, false, false, false, false)
            if set.alert then
                AClang.toast('TP to MC Product')   
            end
            
        end
        if hPickup.x == 0 and hPickup.y == 0 and hPickup.z == 0 then

        elseif hPickup.x ~= 0 and hPickup.y ~= 0 and hPickup.z ~= 0 then
            SEC(players.user_ped(), hPickup.x- 1.5, hPickup.y, hPickup.z, false, false, false, false)
            if set.alert then
                AClang.toast('TP to Heli')
            end
        end
        if bPickup.x == 0 and bPickup.y == 0 and bPickup.z == 0 then

        elseif bPickup.x ~= 0 and bPickup.y ~= 0 and bPickup.z ~= 0 then
            SEC(players.user_ped(), bPickup.x, bPickup.y, bPickup.z + 1.0 , false, false, false, false)
            if set.alert then
                AClang.toast('TP to Boat')
            end
        end
        if plPickup.x == 0 and plPickup.y == 0 and plPickup.z == 0 then

        elseif plPickup.x ~= 0 and plPickup.y ~= 0 and plPickup.z ~= 0 then
            SEC(players.user_ped(), plPickup.x, plPickup.y + 1.5, plPickup.z - 1, false, false, false, false)
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
                SEC(players.user_ped(), sPickup.x, sPickup.y + 2.0, sPickup.z - 1.0, false, false, false, false)
                if set.alert then
                    AClang.toast('TP to Supplies')
                end
            end
            if dPickup.x == 0 and dPickup.y == 0 and dPickup.z == 0 then
            elseif dPickup.x ~= 0 and dPickup.y ~= 0 and dPickup.z ~= 0 then
                SEC(players.user_ped(), dPickup.x, dPickup.y, dPickup.z, false, false, false, false)
                if set.alert then
                    AClang.toast('TP to Dune')
                end
            end
            if fPickup.x == 0 and fPickup.y == 0 and fPickup.z == 0 then
            elseif fPickup.x ~= 0 and fPickup.y ~= 0 and fPickup.z ~= 0 then
                SEC(players.user_ped(), fPickup.x, fPickup.y, fPickup.z + 1.0 , false, false, false, false)
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
                    SEC(players.user_ped(), payPhon.x, payPhon.y, payPhon.z + 1, false, false, false, false)
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
                PED.SET_PED_COORDS_KEEP_VEHICLE(players.user_ped(), 1169.5736, -2971.932, 5.9021106)
            end
        end
    end)

    local forw = {amount = 0.5} --credits to lance#8011
    AClang.action(TeleRoot, 'TP Foward', {'tpforw'}, 'Teleport Forward your set amount', function ()
        local fv = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, forw.amount, -1.0)
        SEC(players.user_ped(), fv.x , fv.y, fv.z, false, false, false, false)
    end)

    AClang.slider(TeleRoot, 'TP Forward Amount', {''}, 'Adjust the amount you teleport forward by', 1, 100, 1, 1, function (a)
        forw.amount = a*0.1
    end)

 ------------------------------------------
 ------------------------------------------



 --------------------------------------------------------
-- Vehicles


local rgbvm = AClang.list(vehroot, 'RGB Vehicle', {}, '')
local rgb = {cus = 100}

    

    AClang.toggle_loop(rgbvm, 'Custom RGB Synced', {}, 'Change the vehicle color and neon lights to custom RGB with a synced color', function ()
       if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) ~= 0 then
        local vmod = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
        RGBNeonKit(players.user_ped())
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
       if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped()) ~= 0 then
        local vmod = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
        RGBNeonKit(players.user_ped())
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
        local car = ENTITY.GET_ENTITY_COORDS(players.user_ped())
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
            if PED.IS_PED_IN_VEHICLE(players.user_ped(), FFchar, false) ==true then
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
    local pedSi = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
    local pCoor = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    local pH = ENTITY.GET_ENTITY_HEADING(pCoor)

        if players.is_in_interior(players.user()) ==true then
            if set.alert then
                AClang.toast('Charger will not Spawn in interior')
            end
            menu.set_value(Spawn, false)
            return
        end

    if PED.IS_PED_IN_VEHICLE(players.user_ped(), FFchar, true) ==false and PED.IS_PED_IN_ANY_VEHICLE(players.user_ped()) ==true then
        local curcar = entities.get_user_vehicle_as_handle()
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(curcar)
        entities.delete_by_handle(curcar)
        if set.alert then
            AClang.toast('Fuck that car')
        end
        for i = 1, 1 do
            Ccreate(pCoor, pedSi)
        end
        

        elseif PED.IS_PED_IN_VEHICLE(players.user_ped(), FFchar, true) ==true then
            Magout()
        elseif PED.IS_PED_IN_ANY_VEHICLE(players.user_ped()) ==false then
                Ccreate(pCoor, pedSi)
                 if set.alert then
                    AClang.toast('Charger Spawned')
                 end
        end

if PED.IS_PED_GETTING_INTO_A_VEHICLE(players.user_ped()) ==false and PED.IS_PED_IN_VEHICLE(players.user_ped(), FFchar , false) ==false
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


--------------------------------------------------------------



AClang.action(onlineroot, 'Snowball Fight', {}, 'Gives everyone in the lobby Snowballs and notifies them via text', function ()
    local plist = players.list()
    local snowballs = util.joaat('WEAPON_SNOWBALL')
    for i = 1, #plist do
        local plyr = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(plist[i])
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(plyr, snowballs, 20, true)
        WEAPON.SET_PED_AMMO(plyr, snowballs, 20)
        players.send_sms(plist[i], players.user(), AClang.str_trans('Snowball Fight! You now have snowballs'))
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
        players.send_sms(plist[i], players.user(), AClang.str_trans('Murica f*** ya! You now have Fireworks'))
        util.yield()
    end
   
end)

AClang.toggle_loop(onlineroot, 'Money Trail', {}, 'Everywhere you walk fake money appears', function ()
    local targets = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
    local tar1 = ENTITY.GET_ENTITY_COORDS(players.user_ped(), true)
    Streamptfx('scr_exec_ambient_fm')
    if TASK.IS_PED_WALKING(targets) or TASK.IS_PED_RUNNING(targets) or TASK.IS_PED_SPRINTING(targets) then
        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD('scr_ped_foot_banknotes', tar1.x, tar1.y, tar1.z - 1, 0, 0, 0, 1.0, true, true, true)
    end
    
end)

AClang.action(onlineroot, 'Stop Spectating', {'sspect'}, 'Stop Spectating anyone in the lobby', function ()
    Specon(players.user())
    Specoff(players.user())
end)

AClang.action(onlineroot, 'Stop Sounds', {'ssound'}, 'Stop all sounds incase they are going off constantly', function ()
    Stopsound()
end)

-------------------------------Player Options-----------------------------------------------

players.on_join(function(pid)

    AClang.divider(menu.player_root(pid), 'AcjokerScript')
    local frienm = AClang.list(menu.player_root(pid), 'Friendly', {}, '')
    local vehmenu = AClang.list(frienm, 'Vehicles', {}, 'If you are too far away from them it will spectate them to complete task')
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



    local lscm = AClang.list(vehmenu, 'Los Santos Customs', {}, 'Works better/faster if you are near them')

  local bodym = AClang.list(lscm, 'Body Modifications', {}, 'Only shows what is available to be changed. If they get in a new vehicle back out of Body Modifications to refresh options')

  local lighm = AClang.list(lscm, 'Lights', {}, '')

    local colm  = AClang.list(lscm, 'Vehicle Colors', {}, '')

    local wmenu = AClang.list(lscm, 'Wheels', {}, '')



      local vehmenus = {}
      local  vehopts = { 
        {1 , AClang.trans("Spoilers")},
        {2 , AClang.trans("Front Bumper / Countermeasures")},
        {3 , AClang.trans("Rear Bumper")},
        {4 , AClang.trans("Side Skirt")},
        {5 , AClang.trans("Exhaust")},
        {6 , AClang.trans("Frame")},
        {7 , AClang.trans("Grille")},
        {8 , AClang.trans("Hood")},
        {9 , AClang.trans("Fender")},
        {10 , AClang.trans("Right Fender")},
        {11 , AClang.trans("Roof / Weapons")},
        {12 , AClang.trans("Engine")},
        {13 , AClang.trans("Brakes")},
        {14 , AClang.trans("Transmission")},
        {15 , AClang.trans("Horns")},
        {16 , AClang.trans("Suspension")},
        {17 , AClang.trans("Armour")},
        {24 , AClang.trans("Front Wheels")},
        {25 , AClang.trans("Motorcycle Back Wheel Design")},
        {26 , AClang.trans("Plate Holders")},
        {28 , AClang.trans("Trim Design")},
        {29 , AClang.trans("Ornaments")},
        {31 , AClang.trans("Dial Design")},
        {34 , AClang.trans("Steering Wheel")},
        {35 , AClang.trans("Shifter Leavers")},
        {36 , AClang.trans("Plaques")},
        {39 , AClang.trans("Hydraulics")},
        {49 , AClang.trans("Livery")},
        }


        local vehtogs = {
        {19 , AClang.trans("Turbo")},
        {21 , AClang.trans("Tire Smoke")},
        {23 , AClang.trans("Xenon Headlights")},
        }
     

        menu.on_focus(bodym, function ()
            for _, m in ipairs(vehmenus) do
                menu.delete(m)
            end
            vehmenus = {}
            if not players.exists(pid) then
                util.stop_thread()
            end
            local pedm = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local vmod = PED.GET_VEHICLE_PED_IS_IN(pedm, false)
            if PED.IS_PED_IN_ANY_VEHICLE(pedm, false) then    
                GetPlayVeh(pid, function ()
                for _, v in pairs(vehopts) do
                    local current = VEHICLE.GET_VEHICLE_MOD(vmod, v[1] -1)
                    local maxmods = Getmodcou(pid, v[1] - 1)
                    if maxmods > 0  then
                        local modnames = v[2]
                        local s = menu.slider(bodym, modnames , {''}, '',  -1, maxmods  , current, 1, function (mod)
                            Changemod(pid, v[1] -1, mod)
                        end)
              
                     
                      table.insert(vehmenus, s)
                    util.yield()
                    end
                end

                  for i, v in pairs(vehtogs) do
                    local current = VEHICLE.IS_TOGGLE_MOD_ON(vmod, v[1] -1)
                    local tognames = v[2]
                    local t = menu.toggle(bodym, tognames, {''}, '', function (on)
                        VEHICLE.TOGGLE_VEHICLE_MOD(vmod, v[1] - 1, on)
                      end, current)         
                    table.insert(vehmenus, t)
                  util.yield()
                end

                end)
                 end


        end)
           

    local color = {}
    local mainc = {
        AClang.trans('Metallic Black'),
        AClang.trans('Metallic Graphite Black'),
        AClang.trans('Metallic Black Steal'),
        AClang.trans('Metallic Dark Silver'),	
        AClang.trans('Metallic Silver'),
        AClang.trans('Metallic Blue Silver'),
        AClang.trans('Metallic Steel Gray'),
        AClang.trans('Metallic Shadow Silver'),
        AClang.trans('Metallic Stone Silver'),
        AClang.trans('Metallic Midnight Silver'),
        AClang.trans('Metallic Gun Metal'),
        AClang.trans('Metallic Anthracite Grey'),
        AClang.trans('Matte Black'),
        AClang.trans('Matte Gray'),
        AClang.trans('Matte Light Grey'),	
        AClang.trans('Util Black'),
        AClang.trans('Util Black Poly'),
        AClang.trans('Util Dark silver'),	
        AClang.trans('Util Silver'),
        AClang.trans('Util Gun Metal'),	
        AClang.trans('Util Shadow Silver'),
        AClang.trans('Worn Black'),
        AClang.trans('Worn Graphite'),
        AClang.trans('Worn Silver Grey'),	
        AClang.trans('Worn Silver'),
        AClang.trans('Worn Blue Silver'), 	
        AClang.trans('Worn Shadow Silver'),	
        AClang.trans('Metallic Red'),
        AClang.trans('Metallic Torino Red'),
        AClang.trans('Metallic Formula Red'),
        AClang.trans('Metallic Blaze Red'), 	
        AClang.trans('Metallic Graceful Red'),	
        AClang.trans('Metallic Garnet Red'),
        AClang.trans('Metallic Desert Red'),
        AClang.trans('Metallic Cabernet Red'),
        AClang.trans('Metallic Candy Red'),
        AClang.trans('Metallic Sunrise Orange'),	
        AClang.trans('Metallic Classic Gold'),
        AClang.trans('Metallic Orange'),	
        AClang.trans('Matte Red'), 	
        AClang.trans('Matte Dark Red'),	
        AClang.trans('Matte Orange'),
        AClang.trans('Matte Yellow'),	
        AClang.trans('Util Red'),
        AClang.trans('Util Bright Red'),	
        AClang.trans('Util Garnet Red'),	
        AClang.trans('Worn Red'),
        AClang.trans('Worn Golden Red'),
        AClang.trans('Worn Dark Red'),
        AClang.trans('Metallic Dark Green'),	
        AClang.trans('Metallic Racing Green'),
        AClang.trans('Metallic Sea Green'),	
        AClang.trans('Metallic Olive Green'),	
        AClang.trans('Metallic Green'),
        AClang.trans('Metallic Gasoline Blue Green'),
        AClang.trans('Matte Lime Green'),
        AClang.trans('Util Dark Green'), 	
        AClang.trans('Util Green'),
        AClang.trans('Worn Dark Green'),	
        AClang.trans('Worn Green'),
        AClang.trans('Worn Sea Wash'),
        AClang.trans('Metallic Midnight Blue'),	
        AClang.trans('Metallic Dark Blue'),	
        AClang.trans('Metallic Saxony Blue'),	
        AClang.trans('Metallic Blue'),
        AClang.trans('Metallic Mariner Blue'), 	
        AClang.trans('Metallic Harbor Blue'), 	
        AClang.trans('Metallic Diamond Blue'),	
        AClang.trans('Metallic Surf Blue'),
        AClang.trans('Metallic Nautical Blue'),	
        AClang.trans('Metallic Bright Blue'),
        AClang.trans('Metallic Purple Blue'),	
        AClang.trans('Metallic Spinnaker Blue'), 	
        AClang.trans('Metallic Ultra Blue'),	
        AClang.trans('Metallic Bright Blue'),	
        AClang.trans('Util Dark Blue'),
        AClang.trans('Util Midnight Blue'), 	
        AClang.trans('Util Blue'),
        AClang.trans('Util Sea Foam Blue'),
        AClang.trans('Util Lightning blue'),
        AClang.trans('Util Maui Blue Poly'),
        AClang.trans('Util Bright Blue'),
        AClang.trans('Matte Dark Blue'),
        AClang.trans('Matte Blue'),
        AClang.trans('Matte Midnight Blue'),	
        AClang.trans('Worn Dark blue'),
        AClang.trans('Worn Blue'),
        AClang.trans('Worn Light blue'),
        AClang.trans('Metallic Taxi Yellow'),
        AClang.trans('Metallic Race Yellow'),
        AClang.trans('Metallic Bronze'),
        AClang.trans('Metallic Yellow Bird'),
        AClang.trans('Metallic Lime'),
        AClang.trans('Metallic Champagne'),
        AClang.trans('Metallic Pueblo Beige'),	
        AClang.trans('Metallic Dark Ivory'),
        AClang.trans('Metallic Choco Brown'),
        AClang.trans('Metallic Golden Brown'),
        AClang.trans('Metallic Light Brown'),
        AClang.trans('Metallic Straw Beige'),	
        AClang.trans('Metallic Moss Brown'),
        AClang.trans('Metallic Biston Brown'),
        AClang.trans('Metallic Beechwood'),
        AClang.trans('Metallic Dark Beechwood'), 	
        AClang.trans('Metallic Choco Orange'),	
        AClang.trans('Metallic Beach Sand'),
        AClang.trans('Metallic Sun Bleeched Sand'),	
        AClang.trans('Metallic Cream'),
        AClang.trans('Util Brown'),	
        AClang.trans('Util Medium Brown'),	
        AClang.trans('Util Light Brown'),	
        AClang.trans('Metallic White'),	
        AClang.trans('Metallic Frost White'),
        AClang.trans('Worn Honey Beige'),
        AClang.trans('Worn Brown'),	
        AClang.trans('Worn Dark Brown'),
        AClang.trans('Worn straw beige'),	
        AClang.trans('Brushed Steel'),
        AClang.trans('Brushed Black steel'), 	
        AClang.trans('Brushed Aluminium'),
        AClang.trans('Chrome'),
        AClang.trans('Worn Off White'), 
        AClang.trans('Util Off White'), 
        AClang.trans('Worn Orange'), 
        AClang.trans('Worn Light Orange'), 
        AClang.trans('Metallic Securicor Green'),  	
        AClang.trans('Worn Taxi Yellow'), 
        AClang.trans('police car blue'),  	
        AClang.trans('Matte Green'), 	
        AClang.trans('Matte Brown'), 	
        AClang.trans('Worn Orange'), 
        AClang.trans('Matte White'), 	
        AClang.trans('Worn White'),
        AClang.trans('Worn Olive Army Green'), 	
        AClang.trans('Pure White'),	
        AClang.trans('Hot Pink'), 	
        AClang.trans('Salmon pink'),
        AClang.trans('Metallic Vermillion Pink'),
        AClang.trans('Orange'),
        AClang.trans('Green'),	
        AClang.trans('Blue'),
        AClang.trans('Mettalic Black Blue'), 	
        AClang.trans('Metallic Black Purple'),	
        AClang.trans('Metallic Black Red'),
        AClang.trans('Hunter Green'),
        AClang.trans('Metallic Purple'),
        AClang.trans('Metaillic V Dark Blue'),	
        AClang.trans('MODSHOP BLACK1'), 
        AClang.trans('Matte Purple'),
        AClang.trans('Matte Dark Purple'), 	
        AClang.trans('Metallic Lava Red'),	
        AClang.trans('Matte Forest Green'),	
        AClang.trans('Matte Olive Drab'),	
        AClang.trans('Matte Desert Brown'),
        AClang.trans('Matte Desert Tan'), 	
        AClang.trans('Matte Foilage Green'),
        AClang.trans('DEFAULT ALLOY COLOR'),
        AClang.trans('Epsilon Blue'),
        AClang.trans('Pure Gold'),
        AClang.trans('Brushed Gold')
    }

    AClang.list_select(colm, 'Primary Color', {''}, 'Changes the Primary Color on the Vehicle', mainc, 1, 
    function (t)
        color.prim = t - 1
        GetPlayVeh(pid, function ()
            Changecolor(pid, color)
        end)
    end)

    AClang.list_select(colm, 'Secondary Color', {''}, 'Changes the Secondary Color on the Vehicle', mainc, 1, 
    function (t)
        color.sec = t - 1
        GetPlayVeh(pid, function ()
            Changecolor(pid, color)
        end)
    end)

    AClang.list_select(colm, 'Pearlescent Color', {''}, 'Changes the Pearlescent Color on the Vehicle', mainc, 1, 
    function (t)
        color.per = t - 1
        GetPlayVeh(pid, function ()
            Changewhepercolor(pid, color)
        end)
    end)
   
    AClang.list_select(colm, 'Wheel Color', {''}, 'Changes the Wheel Color on the Vehicle', mainc, 1, 
    function (t)
        color.whe = t - 1
        GetPlayVeh(pid, function ()
            Changewhepercolor(pid, color)
        end)
    end)

    AClang.list_select(colm, 'Interior Color', {''}, 'Changes the Interior Color on the Vehicle', mainc, 1, 
    function (t)
        color.int = t - 1
        GetPlayVeh(pid, function ()
            Changeintcolor(pid, color.int)
        end)
    end)

    AClang.list_select(colm, 'Dashboard Color', {''}, 'Changes the Dashboard Color on the Vehicle', mainc, 1, 
    function (t)
        color.das = t - 1
        GetPlayVeh(pid, function ()
            Changedashcolor(pid, color.das)
        end)
    end)

    local til = {
        AClang.trans('NONE'),
        AClang.trans('BLACK'),
        AClang.trans('DARKSMOKE'),
        AClang.trans('LIGHTSMOKE'),
        AClang.trans('STOCK'),
        AClang.trans('LIMO'),
        AClang.trans('GREEN')
    }
    AClang.list_select(lscm, 'Window Tints', {''}, 'Changes the Tint on the Vehicle', til, 1, 
    function (t)
        local tint = t - 1
        GetPlayVeh(pid, function ()
            Changetint(pid, tint)
        end)
        
    end)


    local lighc = {
        AClang.trans('White'),
        AClang.trans('Blue'),
        AClang.trans('Electric Blue'),
        AClang.trans('Mint Green'),
        AClang.trans('Lime Green'),
        AClang.trans('Yellow'),
        AClang.trans('Golden Shower'),
        AClang.trans('Orange'),
        AClang.trans('Red'),
        AClang.trans('Pony Pink'),
        AClang.trans('Hot Pink'),
        AClang.trans('Purple'),
        AClang.trans('Blacklight')

    }
    
    AClang.list_select(lighm, 'Headlights', {''}, 'Changes the Headlights to different colors', lighc, 1, 

    function(c)
        local hcolor = c - 1

        GetPlayVeh(pid, function ()
            Changehead(pid, hcolor)
        end)
    end)


    AClang.list_select(lighm, 'Neons', {''}, 'Changes the Neons to different colors', mainc, 1, 

    function(c)
        local ncolor = c - 1
        GetPlayVeh(pid, function ()
            Changeneon(pid, ncolor)
        end)
    end)
    
local nrgb = {color= {r= 0, g = 255, b = 0, a = 1}}

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


    local bbw = {
        AClang.trans('Chrome OG Hunnets'),
        AClang.trans('Gold OG Hunnets'),
        AClang.trans('Chrome Wires'),
        AClang.trans('Gold Wires'),
        AClang.trans('Chrome Spoked Out'),
        AClang.trans('Gold Spoked Out'),
        AClang.trans('Chrome Knock-Offs'),
        AClang.trans('Gold Knock-Offs'),
        AClang.trans('Chrome Bigger Worm'),
        AClang.trans('Gold Bigger Worm'),
        AClang.trans('Chrome Vintage Wire'),
        AClang.trans('Gold Vintage Wire'),
        AClang.trans('Chrome Classic Wire'),
        AClang.trans('Gold Classic Wire'),
        AClang.trans('GroundRide'),
        AClang.trans('Chrome Smoothie'),
        AClang.trans('Gold Smoothie'),
        AClang.trans('Chrome Classic Rod'),
        AClang.trans('Gold Classic Rod'),
        AClang.trans('Chrome Dollar'),
        AClang.trans('Gold Dollar'),
        AClang.trans('Chrome Mighty Star'),
        AClang.trans('Gold Mighty Star'),
        AClang.trans('Chrome Decadent Dish'),
        AClang.trans('Gold Decadent Dish'),
        AClang.trans('Gold Razor Style'),
        AClang.trans('Chrome Celtic Knot'),
        AClang.trans('Gold Celtic Knot'),
        AClang.trans('Chrome Warrior Dish'),
        AClang.trans('Gold Warrior Dish'),
        AClang.trans('Gold Big Dog Spokes'),
    }




    AClang.list_select(wmenu, 'Bennys Bespoke', {''}, 'Changes the wheels to Bennys Bespoke wheels', bbw, 1, 
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 9, wheel)
        end)
        
    end)

    local bow = {
        AClang.trans('OG Hunnets'),
        AClang.trans('OG Hunnets (Chrome Lip)'),
        AClang.trans('Knock-Offs'),
        AClang.trans('Knock-Offs (Chrome Lip)'),
        AClang.trans('Spoked Out'),
        AClang.trans('Spoked Out (Chrome Lip)'),
        AClang.trans('Vintage Wire'),
        AClang.trans('Vintage Wire (Chrome Lip)'),
        AClang.trans('Smoothie'),
        AClang.trans('Smoothie (Chrome Lip)'),
        AClang.trans('Smoothie (Solid Color)'),
        AClang.trans('Rod Me Up'),
        AClang.trans('Rod Me Up (Chrome Lip)'),
        AClang.trans('Rod Me Up (Solid Color)'),
        AClang.trans('Clean'),
        AClang.trans('Lotta Chrome'),
        AClang.trans('Spindles'),
        AClang.trans('Viking'),
        AClang.trans('Triple Spoke'),
        AClang.trans('Pharohe'),
        AClang.trans('Tiger Style'),
        AClang.trans('Three Wheelin'),
        AClang.trans('Big Bar'),
        AClang.trans('Biohazard'),
        AClang.trans('Waves'),
        AClang.trans('Lick Lick'),
        AClang.trans('Spiralizer'),
        AClang.trans('Hypnotics'),
        AClang.trans('Psycho-Delic'),
        AClang.trans('Half Cut'),
        AClang.trans('Super Electric'),
    }
    AClang.list_select(wmenu, 'Bennys Originals', {''}, 'Changes the wheels to Bennys Originals wheels', bow, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 8, wheel)
        end)
        
    end)

    local bw = {
        AClang.trans('Speedway'),
        AClang.trans('Street Special'),
        AClang.trans('Racer'),
        AClang.trans('Track Star'),
        AClang.trans('Overlord'),
        AClang.trans('Trident'),
        AClang.trans('Triple Threat'),
        AClang.trans('Stilleto'),
        AClang.trans('Wires'),
        AClang.trans('Bobber'),
        AClang.trans('Solidus'),
        AClang.trans('Ice Shield'),
        AClang.trans('Loops'),
        AClang.trans('Chrome Speedway'),
        AClang.trans('Chrome Street Special'),
        AClang.trans('Chrome Racer'),
        AClang.trans('Chrome Track Star'),
        AClang.trans('Chrome Overlord'),
        AClang.trans('Chrome Trident'),
        AClang.trans('Chrome Triple Threat'),
        AClang.trans('Chrome Stilleto'),
        AClang.trans('Chrome Wires'),
        AClang.trans('Chrome Bobber'),
        AClang.trans('Chrome Solidus'),
        AClang.trans('Chrome Ice Shield'),
        AClang.trans('Chrome Loops'),
        AClang.trans('Romper Racing'),
        AClang.trans('Warp Drive'),
        AClang.trans('Snowflake'),
        AClang.trans('Holy Spoke'),
        AClang.trans('Old Skool Triple'),
        AClang.trans('Futura'),
        AClang.trans('Quarter Mile King'),
        AClang.trans('Cartwheel'),
        AClang.trans('Double Five'),
        AClang.trans('Shuriken'),
        AClang.trans('Simple Six'),
        AClang.trans('Celtic'),
        AClang.trans('Razer'),
        AClang.trans('Twisted'),
        AClang.trans('Morning Star'),
        AClang.trans('Jagged Spokes'),
        AClang.trans('Eidolon'),
        AClang.trans('Enigma'),
        AClang.trans('Big Spokes'),
        AClang.trans('Webs'),
        AClang.trans('Hotplate'),
        AClang.trans('Bobsta'),
        AClang.trans('Grouch'),
    }
    AClang.list_select(wmenu, 'Bike', {''}, 'Changes the wheels to Bike(motorcycle) wheels', bw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 6, wheel)
        end)
        
    end)

    local hew = {
        AClang.trans('Shadow'),
        AClang.trans('Hyper'),
        AClang.trans('Blade'),
        AClang.trans('Diamond'),
        AClang.trans('Supa Gee'),
        AClang.trans('Chromatic Z '),
        AClang.trans('Mercie Ch.Lip'),
        AClang.trans('Obey RS'),
        AClang.trans('GT Chrome'),
        AClang.trans('Cheetah R'),
        AClang.trans('Solar'),
        AClang.trans('Split Ten'),
        AClang.trans('Dash VIP'),
        AClang.trans('LozSpeed Ten'),
        AClang.trans('Carbon Inferno'),
        AClang.trans('Carbon Shadow'),
        AClang.trans('Carbonic Z'),
        AClang.trans('Carbon Solar'),
        AClang.trans('Cheetah Carbon R'),
        AClang.trans('Carbon S Racer'),
        AClang.trans('Chrome Shadow'),
        AClang.trans('Chrome Hyper'),
        AClang.trans('Chrome Blade'),
        AClang.trans('Chrome Diamond'),
        AClang.trans('Chrome Supa Gee'),
        AClang.trans('Chrome Chromatic Z '),
        AClang.trans('Chrome Mercie Ch.Lip'),
        AClang.trans('Chrome Obey RS'),
        AClang.trans('Chrome GT Chrome'),
        AClang.trans('Chrome Cheetah R'),
        AClang.trans('Chrome Solar'),
        AClang.trans('Chrome Split Ten'),
        AClang.trans('Chrome Dash VIP'),
        AClang.trans('Chrome LozSpeed Ten'),
        AClang.trans('Chrome Carbon Inferno'),
        AClang.trans('Chrome Carbon Shadow'),
        AClang.trans('Chrome Carbonic Z'),
        AClang.trans('Chrome Carbon Solar'),
        AClang.trans('Chrome Cheetah Carbon R'),
        AClang.trans('Chrome Carbon S Racer'),
    }
    AClang.list_select(wmenu, 'High End', {''}, 'Changes the wheels to High End wheels', hew, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 7, wheel)

        end)
        
    end)

    local lw = {
        AClang.trans('Flare'),
        AClang.trans('Wired'),
        AClang.trans('Triple Golds'),
        AClang.trans('Big Worm'),
        AClang.trans('Seven Fives'),
        AClang.trans('Split Six'),
        AClang.trans('Fresh Mesh'),
        AClang.trans('Lead Sled'),
        AClang.trans('Turbine'),
        AClang.trans('Super Fin'),
        AClang.trans('Classic Rod'),
        AClang.trans('Dollar'),
        AClang.trans('Dukes'),
        AClang.trans('Low Five'),
        AClang.trans('Gooch'),
        AClang.trans('Chrome Flare'),
        AClang.trans('Chrome Wired'),
        AClang.trans('Chrome Triple Golds'),
        AClang.trans('Chrome Big Worm'),
        AClang.trans('Chrome Seven Fives'),
        AClang.trans('Chrome Split Six'),
        AClang.trans('Chrome Fresh Mesh'),
        AClang.trans('Chrome Lead Sled'),
        AClang.trans('Chrome Turbine'),
        AClang.trans('Chrome Super Fin'),
        AClang.trans('Chrome Classic Rod'),
        AClang.trans('Chrome Dollar'),
        AClang.trans('Chrome Dukes'),
        AClang.trans('Chrome Low Five'),
        AClang.trans('Chrome Gooch'),
    }
    AClang.list_select(wmenu, 'Lowrider', {''}, 'Changes the wheels to Lowrider wheels', lw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 2, wheel)
        end)
        
    end)
    local mw = {
        AClang.trans('Classic Five'),
        AClang.trans('Dukes'),
        AClang.trans('Muscle Freak'),
        AClang.trans('Kracka'),
        AClang.trans('Azreal'),
        AClang.trans('Mecha'),
        AClang.trans('Black Top'),
        AClang.trans('Drag SPL'),
        AClang.trans('Revolver'),
        AClang.trans('Classic Rod '),
        AClang.trans('Fairlie'),
        AClang.trans('Spooner'),
        AClang.trans('Five Star'),
        AClang.trans('Old School'),
        AClang.trans('El Jefe'),
        AClang.trans('Dodman'),
        AClang.trans('Six Gun'),
        AClang.trans('Mercenary'),
        AClang.trans('Chrome Classic Five'),
        AClang.trans('Chrome Dukes'),
        AClang.trans('Chrome Muscle Freak'),
        AClang.trans('Chrome Kracka'),
        AClang.trans('Chrome Azreal'),
        AClang.trans('Chrome Mecha'),
        AClang.trans('Chrome Black Top'),
        AClang.trans('Chrome Drag SPL'),
        AClang.trans('Chrome Revolver'),
        AClang.trans('Chrome Classic Rod '),
        AClang.trans('Chrome Fairlie'),
        AClang.trans('Chrome Spooner'),
        AClang.trans('Chrome Five Star'),
        AClang.trans('Chrome Old School'),
        AClang.trans('Chrome El Jefe'),
        AClang.trans('Chrome Dodman'),
        AClang.trans('Chrome Six Gun'),
        AClang.trans('Chrome Mercenary'),

    }
    AClang.list_select(wmenu, 'Muscle', {''}, 'Changes the wheels to Muscle wheels', mw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 1, wheel)

        end)
        
    end)

    local orw = {
        AClang.trans('Raider'),
        AClang.trans('Mudslinger'),
        AClang.trans('Nevis'),
        AClang.trans('Cairngorm'),
        AClang.trans('Amazon'),
        AClang.trans('Challenger'),
        AClang.trans('Dune Basher'),
        AClang.trans('Five Star'),
        AClang.trans('Rock Crawler'),
        AClang.trans('Mill Spec Steelie'),
        AClang.trans('Chrome Raider'),
        AClang.trans('Chrome Mudslinger'),
        AClang.trans('Chrome Nevis'),
        AClang.trans('Chrome Cairngorm'),
        AClang.trans('Chrome Amazon'),
        AClang.trans('Chrome Challenger'),
        AClang.trans('Chrome Dune Basher'),
        AClang.trans('Chrome Five Star'),
        AClang.trans('Chrome Rock Crawler'),
        AClang.trans('Chrome Mill Spec Steelie'),
        AClang.trans('Retro Steelie'),
        AClang.trans('Heavy Duty Steelie'),
        AClang.trans('Concave Steelie'),
        AClang.trans('Police Issue Steelie'),
        AClang.trans('Lightweight Steelie'),
        AClang.trans('Dukes'),
        AClang.trans('Avalanche'),
        AClang.trans('Mountain Man'),
        AClang.trans('Rigde Climber'),
        AClang.trans('Concave 5'),
        AClang.trans('Flat Six'),
        AClang.trans('All Terrain Monster'),
        AClang.trans('Drag SPL'),
        AClang.trans('Concave Rally Master'),
        AClang.trans('Rugged Snowflake'),
    }
    AClang.list_select(wmenu, 'Offroad', {''}, 'Changes the wheels to Offroad wheels', orw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 4, wheel)

        end)
        
    end)

    local rw = {
        AClang.trans('Classic 5'),
        AClang.trans('Classic 5 (Striped)'),
        AClang.trans('Retro Star'),
        AClang.trans('Retro Star (Striped)'),
        AClang.trans('Triplex'),
        AClang.trans('Triplex (Striped)'),
        AClang.trans('70s Spec'),
        AClang.trans('70s Spec (Striped)'),
        AClang.trans('Super 5R'),
        AClang.trans('Super 5R (Striped)'),
        AClang.trans('Speedster'),
        AClang.trans('Speedster (Striped)'),
        AClang.trans('GP-90'),
        AClang.trans('GP-90 (Striped)'),
        AClang.trans('Superspoke'),
        AClang.trans('Superspoke (Striped)'),
        AClang.trans('Gridline'),
        AClang.trans('Gridline (Striped)'),
        AClang.trans('Snowflake'),
        AClang.trans('Snowflake (Striped)'),
    }
    AClang.list_select(wmenu, 'Racing(Formula 1 Wheels)', {''}, 'Changes the wheels to Racing(Formula 1 Wheels) wheels', rw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 10, wheel)

        end)
        
    end)

    local spw = {
        AClang.trans('Inferno'),
        AClang.trans('Deep Five'),
        AClang.trans('Lozspeed Mk.V'),
        AClang.trans('Diamond Cut'),
        AClang.trans('Chrono'),
        AClang.trans('Feroci RR'),
        AClang.trans('FiftyNine'),
        AClang.trans('Mercie'),
        AClang.trans('Synthetic Z'),
        AClang.trans('Organic Type 0'),
        AClang.trans('Endo v.1'),
        AClang.trans('GT One'),
        AClang.trans('Duper 7'),
        AClang.trans('Uzer'),
        AClang.trans('GroundRide'),
        AClang.trans('S Racer'),
        AClang.trans('Venum'),
        AClang.trans('Cosmo'),
        AClang.trans('Dash VIP'),
        AClang.trans('Ice Kid'),
        AClang.trans('Ruff Weld'),
        AClang.trans('Wangan Master'),
        AClang.trans('Super Five'),
        AClang.trans('Endo v.2'),
        AClang.trans('Split Six'),
        AClang.trans('Chrome Inferno'),
        AClang.trans('Chrome Deep Five'),
        AClang.trans('Chrome Lozspeed Mk.V'),
        AClang.trans('Chrome Diamond Cut'),
        AClang.trans('Chrome Chrono'),
        AClang.trans('Chrome Feroci RR'),
        AClang.trans('Chrome FiftyNine'),
        AClang.trans('Chrome Mercie'),
        AClang.trans('Chrome Synthetic Z'),
        AClang.trans('Chrome Organic Type 0'),
        AClang.trans('Chrome Endo v.1'),
        AClang.trans('Chrome GT One'),
        AClang.trans('Chrome Duper 7'),
        AClang.trans('Chrome Uzer'),
        AClang.trans('Chrome GroundRide'),
        AClang.trans('Chrome S Racer'),
        AClang.trans('Chrome Venum'),
        AClang.trans('Chrome Cosmo'),
        AClang.trans('Chrome Dash VIP'),
        AClang.trans('Chrome Ice Kid'),
        AClang.trans('Chrome Ruff Weld'),
        AClang.trans('Chrome Wangan Master'),
        AClang.trans('Chrome Super Five'),
        AClang.trans('Chrome Endo v.2'),
        AClang.trans('Chrome Split Six'),
    }
    AClang.list_select(wmenu, 'Sport', {''}, 'Changes the wheels to Sport wheels', spw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 0, wheel)

        end)
        
    end)
    
    local stw = {
        AClang.trans('Retro Steelie'),
        AClang.trans('Poverty Spec Steelie'),
        AClang.trans('Concave Steelie'),
        AClang.trans('Nebula'),
        AClang.trans('Hotring Steelie'),
        AClang.trans('Cup Champion'),
        AClang.trans('Stanced EG Custom'),
        AClang.trans('Kracka Custom'),
        AClang.trans('Dukes Custom'),
        AClang.trans('Endo v.3 Custom'),
        AClang.trans('V8 Killer'),
        AClang.trans('Fujiwara Custom'),
        AClang.trans('Cosmo MKII'),
        AClang.trans('Aero Star'),
        AClang.trans('Hype Five'),
        AClang.trans('Ruff Weld Mega Deep '),
        AClang.trans('Mercie Concave'),
        AClang.trans('Sugoi Concave'),
        AClang.trans('Synthetic Z Concave'),
        AClang.trans('Endo v.4 Dished'),
        AClang.trans('Hyperfresh'),
        AClang.trans('Truffade Concave'),
        AClang.trans('Organic Type II'),
        AClang.trans('Big Mamba'),
        AClang.trans('Deep Flake'),
        AClang.trans('Cosmo MKIII'),
        AClang.trans('Concave Racer'),
        AClang.trans('Deep Flake Reverse'),
        AClang.trans('Wild Wagon'),
        AClang.trans('Concave Mega Mesh'),
    }
    AClang.list_select(wmenu, 'Street', {''}, 'Changes the wheels to Street wheels', stw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 11, wheel)

        end)
        
    end)

    local suw = {
        AClang.trans('VIP'),
        AClang.trans('Benefactor'),
        AClang.trans('Cosmo'),
        AClang.trans('Bippu'),
        AClang.trans('Royal Six '),
        AClang.trans('Fagorme'),
        AClang.trans('Deluxe'),
        AClang.trans('Iced Out'),
        AClang.trans('Cognoscenti'),
        AClang.trans('LozSpeed Ten'),
        AClang.trans('Supernova'),
        AClang.trans('Obey RS'),
        AClang.trans('LozSpeed Baller'),
        AClang.trans('Extravaganzo'),
        AClang.trans('Split Six'),
        AClang.trans('Empowered'),
        AClang.trans('Sunrise'),
        AClang.trans('Dash VIP'),
        AClang.trans('Cutter'),
        AClang.trans('Chrome VIP'),
        AClang.trans('Chrome Benefactor'),
        AClang.trans('Chrome Cosmo'),
        AClang.trans('Chrome Bippu'),
        AClang.trans('Chrome Royal Six '),
        AClang.trans('Chrome Fagorme'),
        AClang.trans('Chrome Deluxe'),
        AClang.trans('Chrome Iced Out'),
        AClang.trans('Chrome Cognoscenti'),
        AClang.trans('Chrome LozSpeed Ten'),
        AClang.trans('Chrome Supernova'),
        AClang.trans('Chrome Obey RS'),
        AClang.trans('Chrome LozSpeed Baller'),
        AClang.trans('Chrome Extravaganzo'),
        AClang.trans('Chrome Split Six'),
        AClang.trans('Chrome Empowered'),
        AClang.trans('Chrome Sunrise'),
        AClang.trans('Chrome Dash VIP'),
        AClang.trans('Chrome Cutter'),
    }
    AClang.list_select(wmenu, 'SUV', {''}, 'Changes the wheels to SUV wheels', suw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 3, wheel)
        end)
      
        
    end)


    local trw = {
        AClang.trans('Rally Throwback'),
        AClang.trans('Gravel Trap'),
        AClang.trans('Stove Top'),
        AClang.trans('Stove Top Mesh'),
        AClang.trans('Retro 3 Piece'),
        AClang.trans('Rally Monoblock'),
        AClang.trans('Forged 5'),
        AClang.trans('Split Star'),
        AClang.trans('Speed Boy'),
        AClang.trans('90s Running'),
        AClang.trans('Tropos'),
        AClang.trans('Exos'),
        AClang.trans('High Five'),
        AClang.trans('Super Luxe'),
        AClang.trans('Pure Business'),
        AClang.trans('Pepper Pot'),
        AClang.trans('Blacktop Blender'),
        AClang.trans('Throwback'),
        AClang.trans('Expressway'),
        AClang.trans('Hidden Six'),
        AClang.trans('Dinka SPL'),
        AClang.trans('Retro Turbofan'),
        AClang.trans('Conical Turbofan'),
        AClang.trans('Ice Storm'),
        AClang.trans('Super Turbine'),
        AClang.trans('Modern Mesh'),
        AClang.trans('Forged Star'),
        AClang.trans('Snowflake'),
        AClang.trans('Giga Mesh'),
        AClang.trans('Mesh Meister'),
    }
    AClang.list_select(wmenu, 'Track', {''}, 'Changes the wheels to Track wheels', trw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid,  function ()
            Changewheel(pid, 12, wheel)
        end)

    end)

    local tuw = {
        AClang.trans('Cosmo'),
        AClang.trans('Super Mesh'),
        AClang.trans('Outsider'),
        AClang.trans('Rollas'),
        AClang.trans('Driftmeister'),
        AClang.trans('Slicer'),
        AClang.trans('El Quatro'),
        AClang.trans('Dubbed'),
        AClang.trans('Five Star'),
        AClang.trans('Slideways'),
        AClang.trans('Apex'),
        AClang.trans('Stanced EG'),
        AClang.trans('Countersteer'),
        AClang.trans('Endo v.1'),
        AClang.trans('Endo v.2 Dish'),
        AClang.trans('Gruppe Z'),
        AClang.trans('Choku-Dori'),
        AClang.trans( 'Chicane'),
        AClang.trans('Saisoku'),
        AClang.trans('Dished Eight'),
        AClang.trans('Fujiwara'),
        AClang.trans('Zokusha'),
        AClang.trans('Battle VIII'),
        AClang.trans('Rally Master'),
        AClang.trans('Chrome Cosmo'),
        AClang.trans('Chrome Super Mesh'),
        AClang.trans('Chrome Outsider'),
        AClang.trans('Chrome Rollas'),
        AClang.trans('Chrome Driftmeister'),
        AClang.trans('Chrome Slicer'),
        AClang.trans('Chrome El Quatro'),
        AClang.trans('Chrome Dubbed'),
        AClang.trans('Chrome Five Star'),
        AClang.trans('Chrome Slideways'),
        AClang.trans('Chrome Apex'),
        AClang.trans('Chrome Stanced EG'),
        AClang.trans('Chrome Countersteer'),
        AClang.trans('Chrome Endo v.1'),
        AClang.trans('Chrome Endo v.2 Dish'),
        AClang.trans('Chrome Gruppe Z'),
        AClang.trans('Chrome Choku-Dori'),
        AClang.trans('Chrome Chicane'),
        AClang.trans('Chrome Saisoku'),
        AClang.trans('Chrome Dished Eight'),
        AClang.trans('Chrome Fujiwara'),
        AClang.trans('Chrome Zokusha'),
        AClang.trans('Chrome Battle VIII'),
        AClang.trans('Chrome Rally Master'),
    }
    AClang.list_select(wmenu, 'Tuner', {''}, 'Changes the wheels to Tuner wheels', tuw, 1,
    function(w)
        local wheel = w - 1
        GetPlayVeh(pid, function ()
            Changewheel(pid, 5, wheel)
        end)
    end)




    AClang.action(vehmenu, 'Max out their Vehicle', {'maxv'}, 'Max out their Vehicle with an increased top speed (will put random wheels on the Vehicle each time you press it)', function ()
        GetPlayVeh(pid,  function ()
            Maxoutcar(pid)
        end)
     end, nil, nil, COMMANDPERM_FRIENDLY)


    AClang.text_input(vehmenu, 'Change their license plate', {'lplate'}, 'Change the license plate to a custom text', function (cusplate)
        GetPlayVeh(pid,  function ()
           Platechange(cusplate, pid)
        end)
    end)


    AClang.action(vehmenu, 'Repair Vehicle', {'repv'}, 'Repair their vehicle', function ()
        GetPlayVeh(pid,  function ()
            Fixveh(pid)
        end)
     end, nil, nil, COMMANDPERM_FRIENDLY)

     
     AClang.click_slider(vehmenu, 'Accelerate Vehicle', {'accel'}, 'Accelerate Vehicle Forward by your set amount (actual speed is roughly double the number in MPH)', 10, 150, 40, 10, function (s)
       local  speed = s
        GetPlayVeh(pid, function ()
           Accelveh( speed, pid)
           util.yield(1000)
        end)
    end)
    local spec = menu.get_value(menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Ninja Method"))
    AClang.toggle_loop(vehmenu, 'Slow Vehicle Down', {'slowv'}, 'Does not freeze them just slows down the vehicles velocity', function ()
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

    local cvmenu = AClang.list(vehmenu, 'Give Them a Vehicle', {}, '')

    local cus = {veh = util.joaat('toreador')}
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

    AClang.action(vehmenu, 'Randomize Paint', {'rpaint'}, 'Randomize the Paint of their vehicle', function ()
        GetPlayVeh(pid, function ()
            Rpaint(pid)
        end)
    end, nil, nil, COMMANDPERM_FRIENDLY)

    AClang.action(vehmenu, 'Spectate Player', {''}, AClang.str_trans('Turn on/off spectating of player'), function ()
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

    local exlist = {
        AClang.trans('Grenade'), --modified list from jerryscript
        AClang.trans('Grenade Launcher'),
        AClang.trans('Sticky Bomb'),
        AClang.trans('Molotov'),
        AClang.trans('Rocket'),
        AClang.trans('Tank Shell'),
        AClang.trans('Hi Octane'),
        AClang.trans('Car'),
        AClang.trans('Plane'),
        AClang.trans('Gasoline Pump'),
        AClang.trans('Motorcycle'),
        AClang.trans('Steam'),
        AClang.trans('Flame'),
        AClang.trans('Water Jet'),
        AClang.trans('Gas Canister Flame'),
        AClang.trans('Boat'),
        AClang.trans('Ship Destroy'),
        AClang.trans('Truck'),
        AClang.trans('Bullet'),
        AClang.trans('Smoke Grenade Launcher (adjust delay to start)'),
        AClang.trans('Smoke Grenade (adjust delay to start)'),
        AClang.trans('BZ Gas'),
        AClang.trans('Flare'),
        AClang.trans('Gas Canister'),
        AClang.trans('Fire Extinguisher'),
        AClang.trans('Programmable AR'),
        AClang.trans('Train'),
        AClang.trans('Barrel'),
        AClang.trans('Propane'),
        AClang.trans('Blimp'),
        AClang.trans('Yet Another Flame'),
        AClang.trans('Tanker'),
        AClang.trans('Plane Rocket'),
        AClang.trans('Vehicle Bullet'),
        AClang.trans('Gas Tank'),
        AClang.trans('Bird Crap'),
        AClang.trans('Rail Gun'),
        AClang.trans('Blimp 2'),
        AClang.trans('Firework'),
        AClang.trans('Snowball'),
        AClang.trans('Proximity Mine'),
        AClang.trans('Valkyrie Cannon'),
        AClang.trans('Air Defence (can not be seen outside of water)'),
        AClang.trans('Pipe Bomb'),
        AClang.trans('Vehicle Mine'),
        AClang.trans('Explosive Ammo'),
        AClang.trans('APC Shell'),
        AClang.trans('Bomb Cluster'),
        AClang.trans('Bomb Gas (can not be seen)'),
        AClang.trans('Bomb Incendiary'),
        AClang.trans('Bomb Standard'),
        AClang.trans('Torpedo'),
        AClang.trans('Torpedo Underwater (Use this if they are in the water)'),
        AClang.trans('Bombushka Cannon'),
        AClang.trans('Bomb Cluster Secondary'),
        AClang.trans('Hunter Barrage'),
        AClang.trans('Hunter Cannon'),
        AClang.trans('Rogue Cannon'),
        AClang.trans('Mine Underwater'),
        AClang.trans('Orbital Cannon (can not be seen outside of water)'),
        AClang.trans('Bomb Standard Wide'),
        AClang.trans('Explosive Ammo Shotgun'),
        AClang.trans('Oppressor MK2 Cannon'),
        AClang.trans('Mortar Kinetic'),
        AClang.trans('Vehicle Mine Kinetic'),
        AClang.trans('Vehicle Mine EMP'),
        AClang.trans('Vehicle Mine Spike'),
        AClang.trans('Vehicle Mine Slick'),
        AClang.trans('Vehicle Mine Tar'),
        AClang.trans('Script drone'),
        AClang.trans('Up-n-Atomizer'),
        AClang.trans('Buried Mine'),
        AClang.trans('Script Missile'),
        AClang.trans('RC Tank Rocket'),
        AClang.trans('Bomb Water (can not be seen outside of water)'),
        AClang.trans('Bomb Water Secondary (can not be seen outside of water)'),
        AClang.trans('Stun Grenade Alt'),
        AClang.trans('Stun Grenade Alt 2'),
        AClang.trans('Flash Grenade'),
        AClang.trans('Stun Grenade'),
        AClang.trans('Stun Grenade Alt 3'),
        AClang.trans('Script Missile Large'),
        AClang.trans('Submarine Big'),
        AClang.trans('EMP Launcher EMP'),
    }
    AClang.list_select(eplaym, 'Change Explosion Type', {''}, 'Changes Explosion used for exploding the player', exlist, 1,
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


    local p1 = Pedspawn(pedhash, tar1)
    local p2 = Pedspawn(pedhash, tar1)
    local p3 = Pedspawn(pedhash, tar1)
    local p4 = Pedspawn(pedhash, tar1)
    local p5 = Pedspawn(pedhash, tar1)
    local p6 = Pedspawn(pedhash, tar1)
    local p7 = Pedspawn(pedhash, tar1)
    local p8 = Pedspawn(pedhash, tar1)

    SetPedCoor(p1, tar1.x, tar1.y - 0.5, tar1.z - 1.0)
    SetPedCoor(p2, tar1.x - 0.5, tar1.y - 0.5, tar1.z - 1.0)
    SetPedCoor(p3, tar1.x - 0.5, tar1.y, tar1.z - 1.0)
    SetPedCoor(p4, tar1.x - 0.5, tar1.y + 0.5, tar1.z - 1.0)
    SetPedCoor(p5, tar1.x, tar1.y + 0.5, tar1.z - 1.0)
    SetPedCoor(p6, tar1.x + 0.5, tar1.y + 0.5, tar1.z - 1.0)
    SetPedCoor(p7, tar1.x + 0.5, tar1.y, tar1.z - 1.0)
    SetPedCoor(p8, tar1.x + 0.5, tar1.y - 0.5, tar1.z - 1.0)

    ---------Audio--------------
    if pedhash == util.joaat('IG_LesterCrest')  then
        Teabagtime(p1, p2, p3, p4, p5, p6, p7, p8)
    elseif pedhash == util.joaat('player_two') then
        Trevortime(peds)
    elseif pedhash == util.joaat('u_m_m_jesus_01') then
        Jesuslovesyou(peds)  
    elseif pedhash ~= util.joaat('IG_LesterCrest') or util.joaat('player_two') then
    if AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(p1, 'GENERIC_FUCK_YOU') ==true
    then Fuckyou(peds)

    elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(p1, 'Provoke_Trespass')
    then Provoke(peds)

    elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(p1, 'Generic_Insult_High')
    then Insulthigh(peds)

    elseif AUDIO.DOES_CONTEXT_EXIST_FOR_THIS_PED(p1, 'GENERIC_WAR_CRY')
    then Warcry(peds)
    else
    end
    end

          -----------Anim-------------------------
        Streamanim('rcmpaparazzo_2')
        Streamanim('mp_player_int_upperfinger')
        Streamanim('misscarsteal2peeing')
        Streamanim('mp_player_int_upperpeace_sign')
        local ped_anim = {p2, p3, p4, p5, p6, p7, p8}
        for _, Pedanim in ipairs(ped_anim) do
            if pedhash == util.joaat('player_two') then
                Runanim(Pedanim, 'misscarsteal2peeing','peeing_loop')
               local tre = PED.GET_PED_BONE_INDEX(Pedanim, 0x2e28)
                Streamptfx('core')
               --credits to saltyscript for gfx part
               GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE("ent_amb_peeing", Pedanim, 0, 0, 0, -90, 0, 0, tre, 2, false, false, false)
            elseif pedhash == util.joaat('u_m_m_jesus_01') then
                Runanim(p1, 'mp_player_int_upperpeace_sign', 'mp_player_int_peace_sign')
                Runanim(Pedanim, 'mp_player_int_upperpeace_sign', 'mp_player_int_peace_sign')
            else
                Runanim(Pedanim, 'mp_player_int_upperfinger', 'mp_player_int_finger_02_fp')
                Runanim(p1, 'rcmpaparazzo_2', 'shag_loop_a')
            end

    end
        local ped_tab = {p1, p2, p3, p4, p5, p6, p7, p8}
        for _, spawned_ped in ipairs(ped_tab) do
            table.insert(peds,  spawned_ped)
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
        local o1 = ObjFrezSpawn(hsel, tar1)
        local o2 = ObjFrezSpawn(hsel, tar1)
        local o3 = ObjFrezSpawn(hsel, tar1)
        local o4 = ObjFrezSpawn(hsel, tar1)
        local o5 = ObjFrezSpawn(hsel, tar1)
        local o6 = ObjFrezSpawn(hsel, tar1)
        local o7 = ObjFrezSpawn(hsel, tar1)
        local o8 = ObjFrezSpawn(hsel, tar1)

        SetObjCo(o1, tar1.x, tar1.y - 0.5, tar1.z - 1.0)
        SetObjCo(o2, tar1.x - 0.5, tar1.y - 0.5, tar1.z - 1.0)
        SetObjCo(o3, tar1.x - 0.5, tar1.y, tar1.z - 1.0)
        SetObjCo(o4, tar1.x - 0.5, tar1.y + 0.5, tar1.z - 1.0)
        SetObjCo(o5, tar1.x, tar1.y + 0.5, tar1.z - 1.0)
        SetObjCo(o6, tar1.x + 0.5, tar1.y + 0.5, tar1.z - 1.0)
        SetObjCo(o7, tar1.x + 0.5, tar1.y, tar1.z - 1.0)
        SetObjCo(o8, tar1.x + 0.5, tar1.y - 0.5, tar1.z - 1.0)

        ENTITY.SET_ENTITY_ROTATION(o1, 0, 0, 180, 1, true)
        ENTITY.SET_ENTITY_ROTATION(o2, 0, 0, 135, 1, true)
        ENTITY.SET_ENTITY_ROTATION(o3, 0, 0, 90, 1, true)
        ENTITY.SET_ENTITY_ROTATION(o4, 0, 0, 45, 1, true)
        ENTITY.SET_ENTITY_ROTATION(o6, 0, 0, 315, 1, true)
        ENTITY.SET_ENTITY_ROTATION(o7, 0, 0, 270, 1, true)
        ENTITY.SET_ENTITY_ROTATION(o8, 0, 0, 225, 1, true)

        local obj_tab = {o1, o2, o3, o4, o5, o6, o7, o8}

        for _, horn in ipairs(obj_tab) do
            AUDIO.PLAY_SOUND_FROM_ENTITY(-1, 'Alarm_Interior', horn, 'DLC_H3_FM_FIB_Raid_Sounds', 0, 0)
        end

        for _, spawned_obj in ipairs(obj_tab) do
            table.insert(objs,  spawned_obj)
        end

        obj_table[pid] = objs
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



--------------------------------------------Tables-----------------------------------------------------------
 ----------------------------------------PTFX-------------------------------------------------------------------
Fxcorelist = {

    AClang.trans("Concrete Smash"),
    AClang.trans("Grenade"),
    AClang.trans("Flashbang"),
    AClang.trans("Gobstoppers"),
    AClang.trans("Blood(Turn them into Carrie)"),
    AClang.trans("Metal Fragment"),
    AClang.trans("Water"),
    AClang.trans("Oil(will start glitching out)"),
    AClang.trans("Paparazzi Flash"),
    AClang.trans("Gasoline Pump Explosion"),
    AClang.trans("Molotov"),
    AClang.trans("Cig Exhale(Chain Smoker)"),
    AClang.trans("Wood"),
    AClang.trans("Electrical Fire"),
    AClang.trans("Water Splash"),
    AClang.trans("Polystyrene"),
    AClang.trans("Gasoline"),
    AClang.trans("Flame(Human Torch)"),
    AClang.trans("Casino Chips"),
    AClang.trans("Flying Cigarettes"),
    AClang.trans("Rain Oranges"),
    AClang.trans("Vehicle Respray Smoke(Very Laggy)"),
    AClang.trans("Sparking Wires"),
    AClang.trans("Sub Large Explosion"),
    AClang.trans("Dust(Turn them into Pig-Pen)"),
    AClang.trans("Show them they are TRASH"),
    AClang.trans("Extinguisher(Very Laggy)"),
    AClang.trans("Splash Pee"),
    AClang.trans("Bubbles Everywhere"),
    AClang.trans("Water Mist(Very Laggy)"),
    AClang.trans("Coins"),
    AClang.trans("Foundry Steam"),
    AClang.trans("Mail"),
    AClang.trans("XS Ray"),
    AClang.trans("Extinguisher Water(starts glitching)"),
    AClang.trans("Smoke Grenade"),
    AClang.trans("Telegraph Pole"),
    AClang.trans("Launched Emp"),
    AClang.trans("Electrical Box"),
}

 Fxha = {

    "ent_dst_concrete_large",
    "exp_grd_grenade_lod",
    "exp_arc_grd_flashbang_lod",
    "ent_dst_gen_gobstop",
    "blood_stab",
    "ent_brk_metal_frag",
    "bul_water_heli",
    "ent_sht_oil",
    "ent_anim_paparazzi_flash",
    "exp_grd_petrol_pump",
    "exp_air_molotov",
    "ent_anim_cig_exhale_mth_car",
    "ent_dst_wood_chunky",
    "ent_dst_elec_fire_sp",
    "water_splash_plane_in",
    "ent_dst_polystyrene",
    "ent_sht_petrol",
    "ent_sht_flame",
    "ent_dst_casino_chips",
    "ent_dst_cig_packets",
    "ent_col_tree_oranges",
    "veh_respray_smoke",
    "ent_brk_sparking_wires",
    "exp_grd_sub_large",
    "ent_anim_dusty_hands",
    "ent_dst_rubbish",
    "exp_extinguisher",
    "liquid_splash_pee",
    "water_boat_exit",
    "ent_anim_bm_water_mist",
    "ent_brk_coins",
    "ent_amb_foundry_steam_spawn",
    "ent_dst_mail",
    "exp_xs_ray",
    "ent_sht_extinguisher_water",
    "weap_smoke_grenade",
    "ent_sht_telegraph_pole",
    "exp_sec_launched_emp",
    "ent_sht_electrical_box",
 }


 ---------------------------------------------------------------------------------------------------------
 ------------------------------Big Object List------------------------------------------------------------

 Bigobjlist =  {
    AClang.trans('Meteor'),
    AClang.trans('Ufo'),
    AClang.trans('Cargo Plane'),
    AClang.trans('Ferris Wheel'),
    AClang.trans('Tug Boat'),

 }

 Bigobj = {
    'prop_asteroid_01',
    'imp_prop_ship_01a',
    'cargoplane',
    'prop_ld_ferris_wheel',
    'hei_prop_heist_tug',

 }

 ----------------------------------------------------------------------------------
 -------------------------------Weapons----------------------------------------------------
 Weaplist = {
    AClang.trans('Firework Launcher'),
    AClang.trans('Grenade Launcher'),
    AClang.trans('Heavy Sniper Mk II'),
    AClang.trans('Molotovs'),
    AClang.trans('Rail Gun'),
    AClang.trans('Rockets'),
    AClang.trans('Snowball'),
    AClang.trans('Unholy Hellbringer'),
    AClang.trans('Up-n-Atomizer'),
 }

 Weap = {
    'weapon_firework',
    'weapon_grenadelauncher',
    'weapon_heavysniper_mk2',
    'WEAPON_MOLOTOV',
    'weapon_railgun',
    'WEAPON_RPG',
    'WEAPON_SNOWBALL',
    'weapon_raycarbine',
    'weapon_raypistol',
 }

 ----------------------------------------------------------------------
  ---------------------------------Vehicles------------------------------------

  Vehlist = {
    AClang.trans('Clown Van'),
    AClang.trans('Phantom Wedge'),
    AClang.trans('Space Docker'),
    AClang.trans('Ramp Car'),
    AClang.trans('Insurgent Custom'),
    AClang.trans('Faggio'),
    AClang.trans('Chernobog'),
    AClang.trans('RC Bandito'),
    AClang.trans('MOC Cab'),
    AClang.trans('Benefactor BR8'),
    AClang.trans('Lawn Mower'),
    AClang.trans('Future Shock Bruiser'),

}

Vehha = {
    'speedo2',
    'phantom2',
    'dune2',
    'dune4',
    'insurgent3',
    'faggio3',
    'chernobog',
    'rcbandito',
    'hauler2',
    'openwheel1',
    'mower',
    'bruiser2',
}

----------------------------------------------------
--------------------Objects---------------------

------------------Signs--------------------------
Siglist = {
'Stop Sign Wrong Way',
'Do Not Enter Wrong Way',
'Airport Hanger Sale Sign',
'Towed',
'No Loud Stereos',
'No Stopping Zone',
'No Parking Zone',
'Prison Area',
'No Trespassing',
}

Sigha = {
'prop_sign_road_01b',
'prop_sign_road_03b',
'prop_airport_sale_sign',
'poro_06_sig1_c_source',
'prop_sign_road_03w',
'prop_sign_road_04zb',
'prop_sign_road_04za',
'prop_sign_road_06s',
'prop_sign_road_restriction_10',
}

------------------Doors-----------------------

Dolist = {
'Mine Shaft Door',
'Tunnel Door',
'Garage Gated Door',
'Vault Slide Door Large',
'Vault Slide Door Small',
'Car Mod Garage Door',
'Sliding Glass Door',
'Windowed Garage Door',
'LS Garage Door',
'Revolving Door',
'Garage Gate',
'Union Depository Garage Door',
'Bunker Door (Sometimes slowly moves them upwards and tosses them around)',
'Fencing',
'Arcade Fortune Door',
'Hanger Door',
'Office Elevator Door',
'Prison Gate',
'Iron Gate Large',
}


Doha = {
'prop_mineshaft_door',
'ch_prop_ch_tunnel_door01a',
'apa_prop_ss1_mpint_garage2',
'ch_prop_ch_vault_slide_door_lrg',
'ch_prop_ch_vault_slide_door_sm',
'v_ilev_carmod3door',
'v_ilev_fh_slidingdoor',
'prop_ch2_05d_g_door',
'prop_com_ls_door_01',
'prop_ql_revolving_door',
'prop_sc1_06_gate_l',
'prop_sec_gate_01d',
'gr_prop_gr_doorpart',
'gr_prop_gr_fnclink_03e',
'ch_prop_arcade_fortune_door_01a',
'sum_prop_hangerdoor_01a',
'h4_prop_office_elevator_door_01',
'p_gate_prison_01_s',
'prop_lrggate_02',
}

------------------Interior----------------------
Interlist = {
'420 Display',
'Gas Cylinder',
'Crate Pile (Sometimes forces them upwards)',
'Storage Locker',
'Speakers',
'Epsilon TV stand',
'Wood Cabinet',
'Bean Machine Vending Machine',
'TV and Speakers',
'Xmas Tree',
}

Intob = {
'prop_disp_cabinet_01',
'prop_gascyl_02a',
'prop_cratepile_02a',
'p_cs_locker_01_s',
'prop_speaker_01',
'prop_tv_stand_01',
'prop_rub_cabinet02',
'prop_vend_coffe_01',
'apa_mp_h_str_avunitm_01',
'prop_xmas_tree_int',
}

----------------------------Exterior-----------------
Extlist = {
'Flat Ramp',
'Carrier Radar (Sometimes sends them spinning upward)',
'Carrier Defense Minigun (Will sometimes kill player even if invulnerable if they move out of it)',
'Electrical Transformer',
'Phone Booth',
'Phone Box',
'Inflatable Dancer',
'Post Box',
'Vintage Gas Pump',
'Gravestone',

}

Extob = {
'prop_skate_flatramp',
'hei_prop_carrier_radar_1',
'hei_prop_carrier_defense_02',
'prop_sub_trans_02a',
'prop_phonebox_04',
'prop_phonebox_01a',
'p_airdancer_01_s',
'prop_postbox_ss_01a',
'prop_vintage_pump',
'prop_gravestones_07a',


}

--------------------------NPCS-----------
SPClist = {
    'Lester',
    'Trevor',
    'Jesus'
}


SPC = {
    'ig_lestercrest',
    'player_two',
    'u_m_m_jesus_01'
}



----------------------------------Ambient Females-------------------------------

AfClist = {
'Beach Bikini',--1
'Beverly Hills 1',--2
'Beverly Hills 2',--3
'Bodybuilder',--4
'Business',--5
'Downtown 1',--6
'East SA',--7
'East SA 2',--8
'Fat Black 1',--9
'Fat Cult',--10
'Fat White',--11
'K town 1',--12
'K Town 2',--13
'Prologue Hostage',--14
'Salton',--15
'Skidrow ',--16
'South Central',--17
'South Central 2',--18
'South Central MC',--19
'Tourist',--20
'Tramp',--21
'Tramp Beach', --22
'Older General Street Female',--23
'Older Indian',--24
'Older Ktown',--25
'Older Salton',--26
'Older South Central 1',--27
'Older South Central 2',--28
'Young Beach',--29
'Young Beverly Hills 1',--30
'Young Beverly Hills 2',--31
'Young Beverly Hills 3',--32
'Young Beverly Hills 4' ,--33
'Young Business 1',--34
'Young Business 2',--35
'Young Business 3',--36
'Young Business 4',--37
'Young East SA 1',--38 
'Young East SA 2',--39
'Young East SA 3',--40
'Young Epsilon',--41
'Young Agent',--42
'Young Fitness 1',--43
'Young Fitness 2',--44
'General Female',--45
'Golfer',--46
'Hiker',--47
'Young Hippe',--48
'Young Hipster 1',--49
'Young Hipster 2',--50
'Young Hipster 3',--51
'Young Hipster 4',--52
'Young Indian',--53
'Young Juggalo',--54
'Runner',--55
'Rural Meth',--56
'Dressy',--57
'Skater',--58
'Young South Central 1',--59
'Young South Central 2',--60
'Young South Central 3',--61
' Tennis Player',--62
'Topless ',--63
'Young  Tourist 1',--64
'Young  Tourist 2',--65
' Vinewood 1',--66
' Vinewood 2',--67
' Vinewood 3',--68
' Vinewood 4',--69
' Yoga'--70
}

AfC = {
'a_f_m_beach_01',--1
'a_f_m_bevhills_01',--2
'a_f_m_bevhills_02',--3
'a_f_m_bodybuild_01',--4
'a_f_m_business_02',--5
'a_f_m_downtown_01',--6
'a_f_m_eastsa_01',--7
'a_f_m_eastsa_02',--8
'a_f_m_fatbla_01',--9
'a_f_m_fatcult_01',--10
'a_f_m_fatwhite_01',--11
'a_f_m_ktown_01',--12
'a_f_m_ktown_02',--13
'a_f_m_prolhost_01',--14
'a_f_m_salton_01',--15
'a_f_m_skidrow_01',--16
'a_f_m_soucent_01',--17
'a_f_m_soucent_02',--18
'a_f_m_soucentmc_01',--19
'a_f_m_tourist_01',--20
'a_f_m_tramp_01',--21
'a_f_m_trampbeac_01',--22
'a_f_o_genstreet_01',--23
'a_f_o_indian_01',--24
'a_f_o_ktown_01',--25
'a_f_o_salton_01',--26
'a_f_o_soucent_01',--27
'a_f_o_soucent_02',--28
'a_f_y_beach_01',--29
'a_f_y_bevhills_01',--30
'a_f_y_bevhills_02',--31
'a_f_y_bevhills_03',--32
'a_f_y_bevhills_04' ,--33
'a_f_y_business_01',--34
'a_f_y_business_02',--35
'a_f_y_business_03',--36
'a_f_y_business_04',--37
'a_f_y_eastsa_01',--38 
'a_f_y_eastsa_02',--39
'a_f_y_eastsa_03',--40
'a_f_y_epsilon_01',--41
'a_f_y_femaleagent',--42
'a_f_y_fitness_01',--43
'a_f_y_fitness_02',--44
'a_f_y_genhot_01',--45
'a_f_y_golfer_01',--46
'a_f_y_hiker_01',--47
'a_f_y_hippie_01',--48
'a_f_y_hipster_01',--49
'a_f_y_hipster_02',--50
'a_f_y_hipster_03',--51
'a_f_y_hipster_04',--52
'a_f_y_indian_01',--53
'a_f_y_juggalo_01',--54
'a_f_y_runner_01',--55
'a_f_y_rurmeth_01',--56
'a_f_y_scdressy_01',--57
'a_f_y_skater_01',--58
'a_f_y_soucent_01',--59
'a_f_y_soucent_02',--60
'a_f_y_soucent_03',--61
'a_f_y_tennis_01',--62
'a_f_y_topless_01',--63
'a_f_y_tourist_01',--64
'a_f_y_tourist_02',--65
'a_f_y_vinewood_01',--66
'a_f_y_vinewood_02',--67
'a_f_y_vinewood_03',--68
'a_f_y_vinewood_04',--69
'a_f_y_yoga_01'--70
}

------------------------------------------Ambient Males-----------------------------------------------------------

AMClist = {
'Naked Altruist Cult',
'African American',
'Beach 1',
'Beach 2',
'Beverly hills 1',
'Beverly hills 2',
'Business 1',
'East SA 1',
'East SA 2',
'Farmer',
'Fat Latino',
'Generic Fat 1',
'Generic Fat 2',
'Golfer',
'Rabbi',
'Hillbilly 1',
'Hillbilly 2',
'Indian 1',
'Ktown 1',
'Malibu 1',
'Mexican Country',
'Mexican Laborer',
'a_m_m_og_boss_01',
'Paparazzi',
'Polynesian',
'Prologue Hostage',
'Rural Meth Head',
'Salton 1',
'Salton 2',
'Salton 3',
'Salton 4',
'Skater',
'Skid Row',
'South Central Latino',
'South Central 1',
'South Central 2',
'South Central 3',
'South Central 4',
'Latino 2',
'Tennis',
'Yourist',
'Tramp',
'Tramp Beach',
'Tranvest',
'Tranvest 2',
'Old Altruist Cult 1',
'Old Altruist Cult 2',
'Old Beach',
'Old Generic Street',
'Old Ktown 2',
'Old Salton ',
'Old South Central 1',
'Old South Central 2',
'Old South Central 3',
'Old Tramp 1',
'Young Altruist Cult 1',
'Young Altruist Cult 2',
'Young Beach_01',
'Young Beach_02',
'Young Beach_03',
'Young Beach Vesp 1',
'Young Beach Vesp 2',
'Young Beverly Hills 1',
'Young Beverly Hills 2',
'Breakdance',
'Young Business',
'Young Business 1',
'Young Business 2',
'Young Business 3',
'Cyclist',
'Cyclist 2',
'Young Downtown',
'Young East SA 1',
'Young East SA 2',
'Young Epsilon 1',
'Young Epsilon 2',
'Gay 1',
'Gay 2',
'Young Generic Street 1',
'Young Generic Street 2',
'Young golfer 1',
'Young Rabbi',
'Young Hiker',
'Young Hippy',
'Young Hipster 1',
'Young Hipster 2',
'Young Hipster 3',
'a_m_y_indian_01',
'a_m_y_jetski_01',
'a_m_y_juggalo_01',
'a_m_y_ktown_01',
'a_m_y_ktown_02',
'a_m_y_latino_01',
'Young Meth Head',
'Young Mexican',
'a_m_y_motox_01',
'a_m_y_motox_02',
'a_m_y_musclbeac_01',
'a_m_y_musclbeac_02',
'a_m_y_polynesian_01',
'a_m_y_roadcyc_01',
'Young Runner 1',
'Young Runner 2',
'Young Salton',
'Young Skater 1',
'Young Skater 2',
'Young South Central 1',
'Young South Central 2',
'Young South Central 3',
'Young South Central 4',
'a_m_y_stbla_01',
'a_m_y_stbla_02',
'a_m_y_stlat_01',
'a_m_y_stwhi_01',
'a_m_y_stwhi_02',
'Sunbather',
'Surfer',
'Vinewood Douche',
'Vinewood 1',
'Vinewood 2',
'Vinewood 3',
'Vinewood 4',
'Yoga',
}

AMC = {
'a_m_m_acult_01',
'a_m_m_afriamer_01',
'a_m_m_beach_01',
'a_m_m_beach_02',
'a_m_m_bevhills_01',
'a_m_m_bevhills_02',
'a_m_m_business_01',
'a_m_m_eastsa_01',
'a_m_m_eastsa_02',
'a_m_m_farmer_01',
'a_m_m_fatlatin_01',
'a_m_m_genfat_01',
'a_m_m_genfat_02',
'a_m_m_golfer_01',
'a_m_m_hasjew_01',
'a_m_m_hillbilly_01',
'a_m_m_hillbilly_02',
'a_m_m_indian_01',
'a_m_m_ktown_01',
'a_m_m_malibu_01',
'a_m_m_mexcntry_01',
'a_m_m_mexlabor_01',
'a_m_m_og_boss_01',
'a_m_m_paparazzi_01',
'a_m_m_polynesian_01',
'a_m_m_prolhost_01',
'a_m_m_rurmeth_01',
'a_m_m_salton_01',
'a_m_m_salton_02',
'a_m_m_salton_03',
'a_m_m_salton_04',
'a_m_m_skater_01',
'a_m_m_skidrow_01',
'a_m_m_socenlat_01',
'a_m_m_soucent_01',
'a_m_m_soucent_02',
'a_m_m_soucent_03',
'a_m_m_soucent_04',
'a_m_m_stlat_02',
'a_m_m_tennis_01',
'a_m_m_tourist_01',
'a_m_m_tramp_01',
'a_m_m_trampbeac_01',
'a_m_m_tranvest_01',
'a_m_m_tranvest_02',
'a_m_o_acult_01',
'a_m_o_acult_02',
'a_m_o_beach_01',
'a_m_o_genstreet_01',
'a_m_o_ktown_01',
'a_m_o_salton_01',
'a_m_o_soucent_01',
'a_m_o_soucent_02',
'a_m_o_soucent_03',
'a_m_o_tramp_01',
'a_m_y_acult_01',
'a_m_y_acult_02',
'a_m_y_beach_01',
'a_m_y_beach_02',
'a_m_y_beach_03',
'a_m_y_beachvesp_01',
'a_m_y_beachvesp_02',
'a_m_y_bevhills_01',
'a_m_y_bevhills_02',
'a_m_y_breakdance_01',
'a_m_y_busicas_01',
'a_m_y_business_01',
'a_m_y_business_02',
'a_m_y_business_03',
'a_m_y_cyclist_01',
'a_m_y_dhill_01',
'a_m_y_downtown_01',
'a_m_y_eastsa_01',
'a_m_y_eastsa_02',
'a_m_y_epsilon_01',
'a_m_y_epsilon_02',
'a_m_y_gay_01',
'a_m_y_gay_02',
'a_m_y_genstreet_01',
'a_m_y_genstreet_02',
'a_m_y_golfer_01',
'a_m_y_hasjew_01',
'a_m_y_hiker_01',
'a_m_y_hippy_01',
'a_m_y_hipster_01',
'a_m_y_hipster_02',
'a_m_y_hipster_03',
'a_m_y_indian_01',
'a_m_y_jetski_01',
'a_m_y_juggalo_01',
'a_m_y_ktown_01',
'a_m_y_ktown_02',
'a_m_y_latino_01',
'a_m_y_methhead_01',
'a_m_y_mexthug_01',
'a_m_y_motox_01',
'a_m_y_motox_02',
'a_m_y_musclbeac_01',
'a_m_y_musclbeac_02',
'a_m_y_polynesian_01',
'a_m_y_roadcyc_01',
'a_m_y_runner_01',
'a_m_y_runner_02',
'a_m_y_salton_01',
'a_m_y_skater_01',
'a_m_y_skater_02',
'a_m_y_soucent_01',
'a_m_y_soucent_02',
'a_m_y_soucent_03',
'a_m_y_soucent_04',
'a_m_y_stbla_01',
'a_m_y_stbla_02',
'a_m_y_stlat_01',
'a_m_y_stwhi_01',
'a_m_y_stwhi_02',
'a_m_y_sunbathe_01',
'a_m_y_surfer_01',
'a_m_y_vindouche_01',
'a_m_y_vinewood_01',
'a_m_y_vinewood_02',
'a_m_y_vinewood_03',
'a_m_y_vinewood_04',
'a_m_y_yoga_01',
}

-----------------------------------Cutscene Peds--------------------------------------------------------------

Csplist = {
    'Amanda Townley',
    'Andreas',
    'Ashley',
    'Bank Manager',
    'Barry',
    'Beverly',
    'Brad',
    'Brad Cadaver',
    'Car Buyer',
    'Casey',
    'Cheng SR',
    'Chris Formage',
    'Clay',
    'Dale',
    'Dave Norton',
    'Debra',
    'Denise',
    'Devin',
    'Dom',
    'Peter Dreyfuss',
    'Dr Friedlander',
    'Fabien',
    'FBI Suit',
    'Floyd',
    'Guadalope',
    'Gurk',
    'Hunter',
    'Janet',
    'Jewelery Assistant',
    'Jimmy Boston',
    'Jimmy Disanto',
    'Joe Minuteman',
    'Johnny Klebitz',
    'Josef',
    'Josh',
    'Karen Daniels',
    'Lamar Davis',
    'Lazlow',
    'Lester Crest',
    'Lester Crest 2',
    'Rickie Lukens',
    'Magenta',
    'Manuel',
    'Marnie',
    'Martin Madrazo',
    'Mary Ann',
    'Michelle',
    'Milton',
    'Molly',
    'Movie Premier Female',
    'Movie Premier Male',
    'Mark',
    'Mrs Thornhill',
    'Mrs Phillips',
    'Natalia',
    'Nervous Ron',
    'Nigel',
    'Old Man 1',
    'Old Man 2',
    'Omega',
    'Bigfoot',
    'Agent ULP',
    'Patricia',
    'Priest',
    'Prologue Security 2',
    'Russian Drunk',
    'Simeon Yetarian',
    'Solomon',
    'Steve Hains',
    'Stretch',
    'Tanisha',
    'Tao Cheng',
    'Taos Translator',
    'Tennis Coach',
    'Terry',
    'Tom',
    'Tom Epsilon',
    'Tracy Disanto',
    'Wade',
    'Zimbor',
    'Abigail',
    'Agent',
    'Alan',
    'Anita',
    'Anton',
    'Avon',
    'Ballas OG',
    'Bogdan',
    'Bride',
    'BurgerShot Drug Dealer',
    'Bryony',
    'Car guy 1',
    'Car guy 2',
    'Chef',
    'Chef2',
    'Chinese Goon',
    'Cletus',
    'Cop',
    'Customer',
    'Denise Friend',
    'FOS Rep',
    'csb_g',
    'Groom',
    'Grove Street Dealer',
    'Hao',
    'Hugh',
    'csb_imran',
    'Jack Howitzer',
    'Janitor',
    'Maude',
    'Money',
    'Agent 14',
    'Phoenicia Rackman',
    'Merryweather',
    'Ortega',
    'Oscar',
    'Paige',
    'Dimitri Popov',
    'Porn Dudes',
    'Prologue Driver',
    'prologue Security',
    'Rampage Gang',
    'Rampage Hics',
    'Rampage Hipster',
    'Rampage Marine',
    'Ramage Mexicans',
    'Rashcosvki',
    'Reporter',
    'Roccope Pelosi',
    'Screen Writer',
    'Stripper 1',
    'Stripper 2',
    'Tonya',
    'Traffic Warden',
    'Undercover',
    'Vagos Funeral Speaker',
}

CSP = {
    'cs_amandatownley',
    'cs_andreas',
    'cs_ashley',
    'cs_bankman',
    'cs_barry',
    'cs_beverly',
    'cs_brad',
    'cs_bradcadaver',
    'cs_carbuyer',
    'cs_casey',
    'cs_chengsr',
    'cs_chrisformage',
    'cs_clay',
    'cs_dale',
    'cs_davenorton',
    'cs_debra',
    'cs_denise',
    'cs_devin',
    'cs_dom',
    'cs_dreyfuss',
    'cs_drfriedlander',
    'cs_fabien',
    'cs_fbisuit_01',
    'cs_floyd',
    'cs_guadalope',
    'cs_gurk',
    'cs_hunter',
    'cs_janet',
    'cs_jewelass',
    'cs_jimmyboston',
    'cs_jimmydisanto',
    'cs_joeminuteman',
    'cs_johnnyklebitz',
    'cs_josef',
    'cs_josh',
    'cs_karen_daniels',
    'cs_lamardavis',
    'cs_lazlow',
    'cs_lestercrest',
    'cs_lestercrest_2',
    'cs_lifeinvad_01',
    'cs_magenta',
    'cs_manuel',
    'cs_marnie',
    'cs_martinmadrazo',
    'cs_maryann',
    'cs_michelle',
    'cs_milton',
    'cs_molly',
    'cs_movpremf_01',
    'cs_movpremmale',
    'cs_mrk',
    'cs_mrs_thornhill',
    'cs_mrsphillips',
    'cs_natalia',
    'cs_nervousron',
    'cs_nigel',
    'cs_old_man1a',
    'cs_old_man2',
    'cs_omega',
    'cs_orleans',
    'cs_paper',
    'cs_patricia',
    'cs_priest',
    'cs_prolsec_02',
    'cs_russiandrunk',
    'cs_siemonyetarian',
    'cs_solomon',
    'cs_stevehains',
    'cs_stretch',
    'cs_tanisha',
    'cs_taocheng',
    'cs_taostranslator',
    'cs_tenniscoach',
    'cs_terry',
    'cs_tom',
    'cs_tomepsilon',
    'cs_tracydisanto',
    'cs_wade',
    'cs_zimbor',
    'csb_abigail',
    'csb_agent',
    'csb_alan',
    'csb_anita',
    'csb_anton',
    'csb_avon',
    'csb_ballasog',
    'csb_bogdan',
    'csb_bride',
    'csb_burgerdrug',
    'csb_bryony',
    'csb_car3guy,1',
    'csb_car3guy2',
    'csb_chef',
    'csb_chef2',
    'csb_chin_goon',
    'csb_cletus',
    'csb_cop',
    'csb_customer',
    'csb_denise_friend',
    'csb_fos_rep',
    'csb_g',
    'csb_groom',
    'csb_grove_str_dlr',
    'csb_hao',
    'csb_hugh',
    'csb_imran',
    'csb_jackhowitzer',
    'csb_janitor',
    'csb_maude',
    'csb_money',
    'csb_mp_agent14',
    'csb_mrs_r',
    'csb_mweather',
    'csb_ortega',
    'csb_oscar',
    'csb_paige',
    'csb_popov',
    'csb_porndudes',
    'csb_prologuedriver',
    'csb_prolsec',
    'csb_ramp_gang',
    'csb_ramp_hic',
    'csb_ramp_hipster',
    'csb_ramp_marine',
    'csb_ramp_mex',
    'csb_rashcosvki',
    'csb_reporter',
    'csb_roccopelosi',
    'csb_screen_writer',
    'csb_stripper_01',
    'csb_stripper_02',
    'csb_tonya',
    'csb_trafficwarden',
    'csb_undercover',
    'csb_vagspeak',

}

-------------------------------------Gang Members--------------------------------------------------------

GMlist = {
'Female Import Export',
'Ballas Female',
'Grove Street Female',
'Lost MC Female',
'Vagos Female',
'Male Import Export',
'Armenian Boss',
'Armenian Goon 1',
'Armenian Lieutenant',
'Chem Plant Worker',
'Chinese Boss',
'Older Chinese Goon ',
'Chinese Goon 1',
'Chinese Goon 2',
'Korean Boss 1',
'Mexican Boss 1',
'Mexican Boss 2',
'Armenian Goon 2',
'Azteca',
'Ballas Easy',
'Ballas Original',
'Ballas South',
'Grove Street 1',
'Grove Street 2',
'Grove Street 3',
'Korean Goon 1',
'Korean Goon ',
'Korean Lieutenant',
'Lost 1',
'Lost 2',
'Lost 3',
'Mexican Gang',
'Mexican Goon 1',
'Mexican Goon 2',
'Mexican Goon 3',
'Polynesian Goon 1',
'Polynesian Goon 2',
'Salvadoran Boss',
'Salvadoran Goon 1',
'Salvadoran Goon 2',
'Salvadoran Goon 3',
'Street Punk 1',
'Street Punk 2',
}

GM = {
'g_f_importexport_01',
'g_f_y_ballas_01',
'g_f_y_families_01',
'g_f_y_lost_01',
'g_f_y_vagos_01',
'g_m_importexport_01',
'g_m_m_armboss_01',
'g_m_m_armgoon_01',
'g_m_m_armlieut_01',
'g_m_m_chemwork_01',
'g_m_m_chiboss_01',
'g_m_m_chicold_01',
'g_m_m_chigoon_01',
'g_m_m_chigoon_02',
'g_m_m_korboss_01',
'g_m_m_mexboss_01',
'g_m_m_mexboss_02',
'g_m_y_armgoon_02',
'g_m_y_azteca_01',
'g_m_y_ballaeast_01',
'g_m_y_ballaorig_01',
'g_m_y_ballasout_01',
'g_m_y_famca_01',
'g_m_y_famdnf_01',
'g_m_y_famfor_01',
'g_m_y_korean_01',
'g_m_y_korean_02',
'g_m_y_korlieut_01',
'g_m_y_lost_01',
'g_m_y_lost_02',
'g_m_y_lost_03',
'g_m_y_mexgang_01',
'g_m_y_mexgoon_01',
'g_m_y_mexgoon_02',
'g_m_y_mexgoon_03',
'g_m_y_pologoon_01',
'g_m_y_pologoon_02',
'g_m_y_salvaboss_01',
'g_m_y_salvagoon_01',
'g_m_y_salvagoon_02',
'g_m_y_salvagoon_03',
'g_m_y_strpunk_01',
'g_m_y_strpunk_02',
}

----------------------------------------Multiplayer------------------------------------------------------------

Mpplist = {
'Benny Mechanic',
'Female Boat Staff',
'Female Car Designer',
'Female Bartender',
'Female Cocaine Worker',
'Female Counterfeit Worker',
'Dead Hooker',
'Female Executive Assistant 1',
'Female Executive Assistant 2',
'Female Forgery Worker',
'Female Freemode',
'Female Helistaff',
'Female Meth Worker',
'Misty',
'Stripper',
'Female Weed Worker',
'Heist Goons',
'Avon Goon',
'Male Boat Staff',
'Bogdan Goon',
'Claude',
'Male Cocaine Worker',
'Male Counterfeit Worker',
'Ex Army Vet',
'Male exec PA ',
'Grove Street',
'Male FIB Secretary',
'Male Forgery Worker',
'Male Freemode',
'John Marston',
'Male Meth Worker',
'Niko Belic',
'Securo Guard',
'Male Shopkeep',
'Warehouse Mechanic',
'Male Weed Worker',
'Vagos Funeral',
'Male Armoured',
'Weapons Expert',
'Weapons Worker',
}

Mpp = {
'mp_f_bennymech_01',
'mp_f_boatstaff_01',
'mp_f_cardesign_01',
'mp_f_chbar_01',
'mp_f_cocaine_01',
'mp_f_counterfeit_01',
'mp_f_deadhooker',
'mp_f_execpa_01',
'mp_f_execpa_02',
'mp_f_forgery_01',
'mp_f_freemode_01',
'mp_f_helistaff_01',
'mp_f_meth_01',
'mp_f_misty_01',
'mp_f_stripperlite',
'mp_f_weed_01',
'mp_g_m_pros_01',
'mp_m_avongoon',
'mp_m_boatstaff_01',
'mp_m_bogdangoon',
'mp_m_claude_01',
'mp_m_cocaine_01',
'mp_m_counterfeit_01',
'mp_m_exarmy_01',
'mp_m_execpa_01',
'mp_m_famdd_01',
'mp_m_fibsec_01',
'mp_m_forgery_01',
'mp_m_freemode_01',
'mp_m_marston_01',
'mp_m_meth_01',
'mp_m_niko_01',
'mp_m_securoguard_01',
'mp_m_shopkeep_01',
'mp_m_waremech_01',
'mp_m_weed_01',
'mp_m_g_vagfun_01',
'mp_s_m_armoured_01',
'mp_m_weapexp_01',
'mp_m_weapwork_01',
}

------------------------------MP Scenario Females----------------------------------------


MSFlist = {
'Barber',
'Maid',
'Highend Shop Keeper',
'Sweatshop Worker',
'Air Hostess',
'Bartender',
'Lifguard',
'Cop',
'Factory Worker',
'Hooker 1',
'Hooker 2',
'Hooker 3',
'Migrant',
'Movie Premier',
'Ranger',
'Nurse Scrubs',
'Sheriff',
'Low End Shop Keeper',
'Mid Level Shop Keeper',
'Stripper 1',
'Stripper 2',
'Stripper 3',
'Sweat Shop 2',
}

MSF = {
's_f_m_fembarber',
's_f_m_maid_01',
's_f_m_shop_high',
's_f_m_sweatshop_01',
's_f_y_airhostess_01',
's_f_y_bartender_01',
's_f_y_baywatch_01',
's_f_y_cop_01',
's_f_y_factory_01',
's_f_y_hooker_01',
's_f_y_hooker_02',
's_f_y_hooker_03',
's_f_y_migrant_01',
's_f_y_movprem_01',
's_f_y_ranger_01',
's_f_y_scrubs_01',
's_f_y_sheriff_01',
's_f_y_shop_low',
's_f_y_shop_mid',
's_f_y_stripper_01',
's_f_y_stripper_02',
's_f_y_stripperlite',
's_f_y_sweatshop_01',
}

----------------------------------MP Scenario Males-------------------------------------------------------

MCMlist = {
'Male Ammunation Clerk 1',
'Armoured Male 1',
'Armoured Male 2',
'Autoshop 1',
'Autoshop 2',
'Bouncer',
'Aircraft Carrier Crew',
'Chem Plant Security',
'CIA Security',
'Country Bartender',
'Dock Worker',
'Doctor',
'FIB Office Worker 1',
'FIB Office Worker 2',
'FIB Security',
'Gaffer',
'Gardener',
'General Transport Worker',
'Hair dresser',
'Highend Security 1',
'Highend security 2',
'Janitor',
'Latino Handyman',
'Life Invader',
'Line Cook',
'LS metro',
'Mariachi Band',
'Marine 1',
'Marine 2',
'Migrant',
'Alien Costume',
'Movie Premier',
'Movie Astronaut',
'Paramedic',
'Pilot 1',
'Pilot 2',
'Postal 1',
'Postal 2',
'Prison Guard',
'Scientist',
'Security Guard',
'Snow Cop',
'Street Performer',
'Street Preacher',
'Street Vendor',
'Trucker',
'Ups 1',
'Ups 2',
'Busker',
'Airline Worker',
'Ammunation City',
'Army Mechanic',
'Autopsy Doc',
'Bartender',
'Lifguard',
'Blackops 1',
'Blackops 2',
'Blackops 3',
'Busboy',
'Chef',
'Clown',
'Construction 1',
'Construction 2',
'Cop',
'Dealer',
'Devin Security',
'Dock Worker',
'Doorman',
'Airport Service 1',
'Airport Service 2',
'Factory Worker',
'Fireman',
'Garbage Collector',
'Vinewood Grip',
'Highway Cop',
'Young Marine 1',
'Young Marine 2',
'Young Marine 3',
'Mime',
'Pest Control',
'Pilot',
'Prisoner muscular',
'Prisoner',
'Ranger',
'Robber',
'Sheriff',
'Shop Mask Vendor',
'Young street Vendor',
'SWAT',
'US Coast Guard',
'Valet',
'Waiter',
'Window Cleaner',
'Mechanic',
'Mechanic MP'
}

MCM = {
's_m_m_ammucountry',
's_m_m_armoured_01',
's_m_m_armoured_02',
's_m_m_autoshop_01',
's_m_m_autoshop_02',
's_m_m_bouncer_01',
's_m_m_ccrew_01',
's_m_m_chemsec_01',
's_m_m_ciasec_01',
's_m_m_cntrybar_01',
's_m_m_dockwork_01',
's_m_m_doctor_01',
's_m_m_fiboffice_01',
's_m_m_fiboffice_02',
's_m_m_fibsec_01',
's_m_m_gaffer_01',
's_m_m_gardener_01',
's_m_m_gentransport',
's_m_m_hairdress_01',
's_m_m_highsec_01',
's_m_m_highsec_02',
's_m_m_janitor',
's_m_m_lathandy_01',
's_m_m_lifeinvad_01',
's_m_m_linecook',
's_m_m_lsmetro_01',
's_m_m_mariachi_01',
's_m_m_marine_01',
's_m_m_marine_02',
's_m_m_migrant_01',
's_m_m_movalien_01',
's_m_m_movprem_01',
's_m_m_movspace_01',
's_m_m_paramedic_01',
's_m_m_pilot_01',
's_m_m_pilot_02',
's_m_m_postal_01',
's_m_m_postal_02',
's_m_m_prisguard_01',
's_m_m_scientist_01',
's_m_m_security_01',
's_m_m_snowcop_01',
's_m_m_strperf_01',
's_m_m_strpreach_01',
's_m_m_strvend_01',
's_m_m_trucker_01',
's_m_m_ups_01',
's_m_m_ups_02',
's_m_o_busker_01',
's_m_y_airworker',
's_m_y_ammucity_01',
's_m_y_armymech_01',
's_m_y_autopsy_01',
's_m_y_barman_01',
's_m_y_baywatch_01',
's_m_y_blackops_01',
's_m_y_blackops_02',
's_m_y_blackops_03',
's_m_y_busboy_01',
's_m_y_chef_01',
's_m_y_clown_01',
's_m_y_construct_01',
's_m_y_construct_02',
's_m_y_cop_01',
's_m_y_dealer_01',
's_m_y_devinsec_01',
's_m_y_dockwork_01',
's_m_y_doorman_01',
's_m_y_dwservice_01',
's_m_y_dwservice_02',
's_m_y_factory_01',
's_m_y_fireman_01',
's_m_y_garbage',
's_m_y_grip_01',
's_m_y_hwaycop_01',
's_m_y_marine_01',
's_m_y_marine_02',
's_m_y_marine_03',
's_m_y_mime',
's_m_y_pestcont_01',
's_m_y_pilot_01',
's_m_y_prismuscl_01',
's_m_y_prisoner_01',
's_m_y_ranger_01',
's_m_y_robber_01',
's_m_y_sheriff_01',
's_m_y_shop_mask',
's_m_y_strvend_01',
's_m_y_swat_01',
's_m_y_uscg_01',
's_m_y_valet_01',
's_m_y_waiter_01',
's_m_y_winclean_01',
's_m_y_xmech_01',
's_m_y_xmech_02_mp'
}

-----------------------------------------Story Mode---------------------------------------------------

SMClist = {
'Heist Crew Driver',--1
'Heist Crew Gunman',--2
'Heist Crew Hacker',--3
'Abigail',--4
'Agent',--5
'Amanda Townley',--6
'Andreas',--7
'Ashley',--8
'Avon',--9
'Ballas OG',--10
'Bankman',--11
'Barry',--12
'Benny ',--13
'Bestmen Wedding',
'Beverly',
'Brad',
'Bride',
'Car Guy 1',
'Car Guy 2',
'Casey',
'Chef',
'Chef2',
'Cheng SR',
'Chris Formage',
'Clay',
'Clay Pain',
'Cletus',
'Dale',
'Dave Norton',
'Denise',
'Devin',
'Dom',
'Peter Dreyfuss',
'Dr Friedlander',
'Fabien',
'Fbi Suit',
'Floyd',
'Franklin',
'Gerald',
'Groom',
'Hao',
'Hunter',
'Janet',
'Jay Norris',
'Jewel Assitant',
'Jimmy Boston',
'Jimmy Disanto',
'Joe Minuteman',
'Johnny Klebitz',
'Jose',
'Josh',
'Karen Daniels',
'Kerry Mcintosh',
'Lamar Davis',
'Lazlow',
'Lestercrest',
'Lestercrest 2',
'Rickie Lukens',
'Lifeinvader Employee',
'Magenta',
'Malc',
'Manuel',
'Marnie',
'Mary Ann',
'Maude',
'Michael',
'Michelle',
'Milton',
'Molly',
'Money',
'MP Agent 14',
'Torture Victim',
'Mrs Thornhill',
'Mrs Phillips',
'Natalia',
'Nervous Ron',
'Nigel',
'Old Man 1',
'Old Man 2',
'Omega',
'Oneil Brothers',
'Bigfoot',
'Ortega',
'Paige',
'Agent ULP',
'Patricia',
'Dima Popov',
'Priest',
'Prologue Security',
'Rampage Gang',
'Rampage Hics',
'Rampage Hipsters',
'Rampage Vagos',
'Rashcosvki',
'Rocco Pelosi',
'Russian Drunk',
'Sacha',
'Screen Writer',
'Simeon Yetarian',
'Solomon',
'Steve Hains',
'Stretch',
'Talina',
'Tanisha',
'Tao Cheng',
'Taos Translator',
'Tennis Coach',
'Terry',
'Tom Epsilon',
'Tonya',
'Tracy Disanto',
'Traffic Warden',
'Trevor',
'Tyler Dix',
'Vagos Funeral',
'Wade',
'Zimbor',
}

SMC = {
'hc_driver',--1
'hc_gunman',--2
'hc_hacker',--3
'ig_abigail',--4
'ig_agent',--5
'ig_amandatownley',--6
'ig_andreas',--7
'ig_ashley',--8
'ig_avon',--9
'ig_ballasog',--10
'ig_bankman',--11
'ig_barry',--12
'ig_benny ',--13
'ig_bestmen',
'ig_beverly',
'ig_brad',
'ig_bride',
'ig_car3guy1',
'ig_car3guy2',
'ig_casey',
'ig_chef',
'ig_chef2',
'ig_chengsr',
'ig_chrisformage',
'ig_clay',
'ig_claypain',
'ig_cletus',
'ig_dale',
'ig_davenorton',
'ig_denise',
'ig_devin',
'ig_dom',
'ig_dreyfuss',
'ig_drfriedlander',
'ig_fabien',
'ig_fbisuit_01',
'ig_floyd',
'player_one',
'ig_g',
'ig_groom',
'ig_hao',
'ig_hunter',
'ig_janet',
'ig_jay_norris',
'ig_jewelass',
'ig_jimmyboston',
'ig_jimmydisanto',
'ig_joeminuteman',
'ig_johnnyklebitz',
'ig_josef',
'ig_josh',
'ig_karen_daniels',
'ig_kerrymcintosh',
'ig_lamardavis',
'ig_lazlow',
'ig_lestercrest',
'ig_lestercrest_2',
'ig_lifeinvad_01',
'ig_lifeinvad_02',
'ig_magenta',
'ig_malc',
'ig_manuel',
'ig_marnie',
'ig_maryann',
'ig_maude',
'player_zero',
'ig_michelle',
'ig_milton',
'ig_molly',
'ig_money',
'ig_mp_agent14',
'ig_mrk',
'ig_mrs_thornhill',
'ig_mrsphillips',
'ig_natalia',
'ig_nervousron',
'ig_nigel',
'ig_old_man1a',
'ig_old_man2',
'ig_omega',
'ig_oneil',
'ig_orleans',
'ig_ortega',
'ig_paige',
'ig_paper',
'ig_patricia',
'ig_popov',
'ig_priest',
'ig_prolsec_02',
'ig_ramp_gang',
'ig_ramp_hic',
'ig_ramp_hipster',
'ig_ramp_mex',
'ig_rashcosvki',
'ig_roccopelosi',
'ig_russiandrunk',
'ig_sacha',
'ig_screen_writer',
'ig_siemonyetarian',
'ig_solomon',
'ig_stevehains',
'ig_stretch',
'ig_talina',
'ig_tanisha',
'ig_taocheng',
'ig_taostranslator',
'ig_tenniscoach',
'ig_terry',
'ig_tomepsilon',
'ig_tonya',
'ig_tracydisanto',
'ig_trafficwarden',
'player_two',
'ig_tylerdix',
'ig_vagspeak',
'ig_wade',
'ig_zimbor',
}

--------------------------------Story Scenario Females-------------------------------------------------------

Ssflist = {
    'Corpse 1',
    'Drowned Body',
    'Miranda',
    'Mourner',
    'Movie Star',
    'Prologue Hostage',
    'Biker Chic',
    'Jane',
    'Corpse 2',
    'Corpse 3',
    'Posh Female',
    'Jewel Store Assistant',
    'Mistress',
    'Poppy Mitchell',
    'Princess',
    'Spy Actress',
}

Ssf = {
    'u_f_m_corpse_01',
    'u_f_m_drowned_01',
    'u_f_m_miranda',
    'u_f_m_promourn_01',
    'u_f_o_moviestar',
    'u_f_o_prolhost_01',
    'u_f_y_bikerchic',
    'u_f_y_comjane',
    'u_f_y_corpse_01',
    'u_f_y_corpse_02',
    'u_f_y_hotposh_01',
    'u_f_y_jewelass_01',
    'u_f_y_mistress',
    'u_f_y_poppymich',
    'u_f_y_princess',
    'u_f_y_spyactress',
}

-------------------------------------------Story Scenario Males---------------------------------------------------------

Ssmlist = {
    'Al Di Napoli',
    'Bank Manager',
    'Bike Hire',
    'DOA Agent',
    'Eddie Toh',
    'FIB Architect',
    'Film Director',
    'Glen Stank',
    'Griff_01',
    'Jesus',
    'Jewelery Security',
    'Jewel Thief',
    'Mark Fostenburg',
    'Party Target',
    'Prologue Security',
    'Prologue Mourn Male',
    'Rival Paparazzo',
    'Spy Actor',
    'Street Artist',
    'Love Fist Willy',
    'Film Noir',
    'Financial Guru',
    'Tap Dancing Hillbilly',
    'Old Male Tramp',
    'Abner',
    'Anton Beaudelaire',
    'Baby D',
    'Baygor(kifflom)',
    'Burgershot Drug Dealer',
    'Chip',
    'Male Corpse 1',
    'Male Cyclist',
    'FIB Mugger',
    'Guido',
    'Gun Vendor',
    'Hippie',
    'Impotent Rage',
    'Juggernaut',
    'Justin',
    'Mani',
    'Military Bum',
    'Paparazzi',
    'Party',
    'Pogo',
    'Prisoner',
    'Prologue Driver',
    'Republican Space Ranger',
    'Sports Bike Rider',
    'Hanger Mechanic',
    'Groom Stag Party',
    'Tattoo Artist',
    'Zombie',
}

Ssm = {
    'u_m_m_aldinapoli',
    'u_m_m_bankman',
    'u_m_m_bikehire_01',
    'u_m_m_doa_01',
    'u_m_m_edtoh',
    'u_m_m_fibarchitect',
    'u_m_m_filmdirector',
    'u_m_m_glenstank_01',
    'u_m_m_griff_01',
    'u_m_m_jesus_01',
    'u_m_m_jewelsec_01',
    'u_m_m_jewelthief',
    'u_m_m_markfost',
    'u_m_m_partytarget',
    'u_m_m_prolsec_01',
    'u_m_m_promourn_01',
    'u_m_m_rivalpap',
    'u_m_m_spyactor',
    'u_m_m_streetart_01',
    'u_m_m_willyfist',
    'u_m_o_filmnoir',
    'u_m_o_finguru_01',
    'u_m_o_taphillbilly',
    'u_m_o_tramp_01',
    'u_m_y_abner',
    'u_m_y_antonb',
    'u_m_y_babyd',
    'u_m_y_baygor',
    'u_m_y_burgerdrug_01',
    'u_m_y_chip',
    'u_m_y_corpse_01',
    'u_m_y_cyclist_01',
    'u_m_y_fibmugger_01',
    'u_m_y_guido_01',
    'u_m_y_gunvend_01',
    'u_m_y_hippie_01',
    'u_m_y_imporage',
    'u_m_y_juggernaut_01',
    'u_m_y_justin',
    'u_m_y_mani',
    'u_m_y_militarybum',
    'u_m_y_paparazzi',
    'u_m_y_party_01',
    'u_m_y_pogo_01',
    'u_m_y_prisoner_01',
    'u_m_y_proldriver_01',
    'u_m_y_rsranger_01',
    'u_m_y_sbike',
    'u_m_y_smugmech_01',
    'u_m_y_staggrm_01',
    'u_m_y_tattoo_01',
    'u_m_y_zombie_01',
}

-----------------------------------DLC Peds------------------------------------------------------------

Dlcplist = {
    'Female Club Customer 1',
    'Female Club Customer 2',
    'Female Club Customer 3',
    'Male Club Customer 1',
    'Male Club Customer 2',
    'Male Club Customer 3',
    'Dixon',
    'DJ the Black Madonna',
    'ig_djblamrupert',
    'ig_djblamryanh',
    'ig_djblamryans',
    'Dixon Manager',
    'ig_djgeneric_01',
    'ig_djsolfotios',
    'ig_djsoljakob',
    'DJ Solomun Manager',
    'ig_djsolmike',
    'ig_djsolrobt',
    'ig_djtalaurelia',
    'ig_djtalignazio',
    'English Dave',
    'Jimmy Boston 2',
    'Kerry Mcintosh 2',
    'Lacey Jones 2',
    'Lazlow 2',
    'Solomun',
    'ig_talcc',
    'ig_talmm',
    'Tony Prince',
    'Tyler Dix',
    'Female Club Bar',
    'Male Club Bar',
    'Warehouse Tech',
    'Miranda 2',
    'u_f_y_danceburl_01',
    'u_f_y_dancelthr_01',
    'u_f_y_dancerave_01',
    'Poppy Mitchell',
    'u_m_y_danceburl_01',
    'u_m_y_dancelthr_01',
    'u_m_y_dancerave_01',
    'Agatha',
    'Avery',
    'Brucie 2',
    'Tao Cheng 2',
    'Taos Translator 2',
    'Thornton',
    'Tom Connors',
    'Vincent',
    'Female General Casino',
    'Female Smart Casino',
    'A_M_M_MLCrisis_01',
    'Male General Casino',
    'Male Smart Casino',
    'G_M_M_CasRN_01',
    'S_M_Y_WestSec_01',
    'Female Casino',
    'Male Casino',
    'Carol',
    'Eileen',
    'Casino Cashier',
    'Casino Shop Clerk',
    'Debbie',
    'Beth',
    'Lauren',
    'Taylor',
    'Blane',
    'Curtis',
    'Vince',
    'Dean',
    'Caleb',
    'CroupThief_01',
    'Gabriel',
    'Ushi',
    'a_f_y_bevhills_05',
    'ig_celeb_01',
    'Georgina Cheng',
    'Huang',
    'Jimmy Disanto 2',
    'Lester Crest 3',
    'Vincent',
    'Wendy',
    'Highend Security 3',
    'West Security 2',
    'Female Beach 2',
    'Club customer 3',
    'Male Beach 1',
    'Male Beach 2',
    'Club Customer 4',
    'Cartel Guards 1',
    'Cartel Guards 2',
    'Dre (better)',
    'English Dave 2',
    'Gustavo',
    'Helmsman Pavel',
    'ig_isldj_00',
    'ig_isldj_01',
    'ig_isldj_02',
    'ig_isldj_03',
    'ig_isldj_04',
    'ig_isldj_04_d_01',
    'ig_isldj_04_d_02',
    'ig_isldj_04_e_01',
    'Jackie',
    'Jimmy Iovine (better)',
    'Juan Strickler(El Rubio)',
    'Kaylee',
    'Miguel Madrazo',
    'DJ Pooh (better)',
    'Old Rich Guy',
    'Patricia 2',
    'Pilot',
    'ig_sss',
    'Beach Bar Staff',
    'Female Club Bar 2',
    'Bouncer 2',
    'Drug Processor',
    'Fieldworker',
    'Highend Security 4',
    'Female Car Club 1',
    'Male Car Club 1',
    'Tattoo Customer',
    'Prisoners 1',
    'Slasher 1',
    'Avi Schwartzman 2',
    'Benny 2',
    'Drug Dealer',
    'Hao 2',
    'Lil Dee',
    'Mimi',
    'Moodyman 2',
    'Sessanta',
    'Female Autoshop 1',
    'Retail Staff',
    'Male Autoshop 3',
    'Race Organizer 1',
    'Tattoo Artist',
    'Female Studio Party 1',
    'Female Studio Party 2',
    'Male Studio Party 1',
    'Male Studio Party 2',
    'Goons 1',
    'Dre',
    'Ballas Leader',
    'Billionaire',
    'Entourage A',
    'Entourage B',
    'Golfer A',
    'Golfer B',
    'Imani',
    'Jimmy Iovine',
    'Johnny Guns',
    'Lamar Davis 2',
    'DJ Pooh',
    'Musician',
    'Party Promoter',
    'Requisition Officer',
    'Security A',
    'Sound Engineer',
    'Vagos Leader',
    'Vernon',
    'Vincent 3',
    'Franklin 2',
    'Female Studio Assist',
    'Highend Security',
    'Male Studio Assist',
    'Studio Producer',
    'Studio Sound Engineer',
}

Dlcp = {
   'a_f_y_clubcust_01',
    'a_f_y_clubcust_02',
    'a_f_y_clubcust_03',
    'a_m_y_clubcust_01',
    'a_m_y_clubcust_02',
    'a_m_y_clubcust_03',
    'ig_dix',
    'ig_djblamadon',
    'ig_djblamrupert',
    'ig_djblamryanh',
    'ig_djblamryans',
    'ig_djdixmanager',
    'ig_djgeneric_01',
    'ig_djsolfotios',
    'ig_djsoljakob',
    'ig_djsolmanager',
    'ig_djsolmike',
    'ig_djsolrobt',
    'ig_djtalaurelia',
    'ig_djtalignazio',
    'ig_englishdave',
    'ig_jimmyboston_02',
    'ig_kerrymcintosh_02',
    'ig_lacey_jones_02',
    'ig_lazlow_2',
    'ig_sol',
    'ig_talcc',
    'ig_talmm',
    'ig_tonyprince',
    'ig_tylerdix_02',
    's_f_y_clubbar_01',
    's_m_y_clubbar_01',
    's_m_y_waretech_01',
    'u_f_m_miranda_02',
    'u_f_y_danceburl_01',
    'u_f_y_dancelthr_01',
    'u_f_y_dancerave_01',
    'u_f_y_poppymich_02',
    'u_m_y_danceburl_01',
    'u_m_y_dancelthr_01',
    'u_m_y_dancerave_01',
    'IG_Agatha',
    'IG_Avery',
    'IG_Brucie2',
    'IG_TaoCheng2',
    'IG_TaosTranslator2',
    'IG_Thornton',
    'IG_TomCasino',
    'IG_Vincent',
    'A_F_Y_GenCasPat_01',
    'A_F_Y_SmartCasPat_01',
    'A_M_M_MLCrisis_01',
    'A_M_Y_GenCasPat_01',
    'A_M_Y_SmartCasPat_01',
    'G_M_M_CasRN_01',
    'S_M_Y_WestSec_01',
    'S_F_Y_Casino_01',
    'S_M_Y_Casino_01',
    'U_F_O_Carol',
    'U_F_O_Eileen',
    'U_F_M_CasinoCash_01',
    'U_F_M_CasinoShop_01',
    'U_F_M_Debbie_01',
    'U_F_Y_Beth',
    'U_F_Y_Lauren',
    'U_F_Y_Taylor',
    'U_M_M_Blane',
    'U_M_M_Curtis',
    'U_M_M_Vince',
    'U_M_O_Dean',
    'U_M_Y_Caleb',
    'U_M_Y_CroupThief_01',
    'U_M_Y_Gabriel',
    'U_M_Y_Ushi',
    'a_f_y_bevhills_05',
    'ig_celeb_01',
    'ig_georginacheng',
    'ig_huang',
    'ig_jimmydisanto2',
    'ig_lestercrest_3',
    'ig_vincent_2',
    'ig_wendy',
    's_m_m_highsec_03',
    's_m_y_westsec_02',
    'a_f_y_beach_02',
    'a_f_y_clubcust_04',
    'a_m_o_beach_02',
    'a_m_y_beach_04',
    'a_m_y_clubcust_04',
    'g_m_m_cartelguards_01',
    'g_m_m_cartelguards_02',
    'ig_ary',
    'ig_englishdave_02',
    'ig_gustavo',
    'ig_helmsmanpavel',
    'ig_isldj_00',
    'ig_isldj_01',
    'ig_isldj_02',
    'ig_isldj_03',
    'ig_isldj_04',
    'ig_isldj_04_d_01',
    'ig_isldj_04_d_02',
    'ig_isldj_04_e_01',
    'ig_jackie',
    'ig_jio',
    'ig_juanstrickler',
    'ig_kaylee',
    'ig_miguelmadrazo',
    'ig_mjo',
    'ig_oldrichguy',
    'ig_patricia_02',
    'ig_pilot',
    'ig_sss',
    's_f_y_beachbarstaff_01',
    's_f_y_clubbar_02',
    's_m_m_bouncer_02',
    's_m_m_drugprocess_01',
    's_m_m_fieldworker_01',
    's_m_m_highsec_04',
    'A_F_Y_CarClub_01',
    'A_M_Y_CarClub_01',
    'A_M_Y_TattooCust_01',
    'G_M_M_Prisoners_01',
    'G_M_M_Slasher_01',
    'IG_AviSchwartzman_02',
    'IG_Benny_02',
    'IG_DrugDealer',
    'IG_Hao_02',
    'IG_LilDee',
    'IG_Mimi',
    'IG_Moodyman_02',
    'IG_Sessanta',
    'S_F_M_Autoshop_01',
    'S_F_M_RetailStaff_01',
    'S_M_M_Autoshop_03',
    'S_M_M_RaceOrg_01',
    'S_M_M_Tattoo_01',
    'A_F_Y_StudioParty_01',
    'A_F_Y_StudioParty_02',
    'A_M_M_StudioParty_01',
    'A_M_Y_StudioParty_01',
    'G_M_M_Goons_01',
    'IG_ARY_02',
    'IG_Ballas_Leader',
    'IG_Billionaire',
    'IG_Entourage_A',
    'IG_Entourage_B',
    'IG_Golfer_A',
    'IG_Golfer_B',
    'IG_Imani',
    'IG_JIO_02',
    'IG_Johnny_Guns',
    'IG_LamarDavis_02',
    'IG_MJO_02',
    'IG_Musician_00',
    'IG_Party_Promo',
    'IG_Req_Officer',
    'IG_Security_A',
    'IG_SoundEng_00',
    'IG_Vagos_Leader',
    'IG_Vernon',
    'IG_Vincent_3',
    'P_Franklin_02',
    'S_F_M_StudioAssist_01',
    'S_M_M_HighSec_05',
    'S_M_M_StudioAssist_02',
    'S_M_M_StudioProd_01',
    'S_M_M_StudioSouEng_02',
}

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
                    local f = io.open(filesystem.store_dir() .. 'AcjokerScript\\Languages\\'.. file, "wb")
                    f:write(a)
                    f:close()
                end)
                util.yield(100)
                async_http.dispatch() 
            end
            util.yield(100)

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
    util.yield(100)

    async_http.init('raw.githubusercontent.com','/acjoker8818/AcjokerScript/main/AClangLib.lua',function(c)
        local err = select(2,load(c))
        if err then
            AClang.toast("AClanglib.lua failed to download. Please try again later. If this continues to happen then manually update via github.")
        return end
        local f = io.open(filesystem.scripts_dir()..'\\lib\\AClangLib.lua', "wb")
        f:write(c)
        f:close()
        AClang.toast("Successfully updated AcjokerScript :)")
        util.restart_script()
    end)
    async_http.dispatch()  
    util.yield(100)
        end)
    end
end, function() response = true end)
async_http.dispatch()
repeat 
    util.yield()
until response


util.keep_running()

util.on_stop(function ()
    Load = false
end)

