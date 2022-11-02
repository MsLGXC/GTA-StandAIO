-- TOUCH THESE
background_color = {
    r = 0.0,
    g = 0.0,
    b = 0.0,
    a = 0.6
}
highlight_color = {
    r = 1.0,
    g = 1.0,
    b = 1.0,
    a = 0.7
}
subhead_color = {
    r = 1.0,
    g = 1.0,
    b = 1.0,
    a = 1.0
}
label_color = {
    r = 1.0,
    g = 1.0,
    b = 1.0,
    a = 1.0
}
header_color = {
    r = 0.2,
    g = 0.2,
    b = 0.2,
    a = 0.6
}

blur_strength = 0

require("natives-1627063482") -- da natives
require("imgui_for_glance")
function reinit_window()
    glance = UI.new()
    glance.set_background_colour(background_color.r, background_color.g, background_color.b, background_color.a)
    glance.set_highlight_colour(highlight_color.r, highlight_color.g, highlight_color.b, highlight_color.a)
    glance.set_header_colour(header_color.r, header_color.g, header_color.b, header_color.a)
end

reinit_window()
--local label_color = {r = 1, g = 1, b = 1, a = 1}
local green = {r = 0, g = 1, b = 0, a = 1}
local red = {r = 1, g = 0, b = 0, a = 1}
local black = {r = 0, g = 0, b = 0, a = 1}
local purple = {r = 0.5, g = 0, b= 0.5, a = 1}
local brighter_purple = {r = 0.7, g = 0, b = 0.7, a = 1}
local darker_red = {r = 0.5, g = 0, b = 0, a  = 1}

-- credits to https://stackoverflow.com/questions/10989788/format-integer-in-lua
function format_int(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    -- reverse the int-string back remove an optional comma and put the 
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

function do_percentage_scale_color(perc)
    local color = {r = 0, g = 1, b = 0, a = 1.0}
    if 0.5 < perc and perc < 1.0 then 
        color.r = 0.747 
        color.g = 0.330
        color.b = 0.000
    elseif perc < 0.5 then 
        color.r = 1.0
        color.g = 0.0
        color.b = 0.0
    end
    return color
end

function conditional_color(bool) 
    if bool then
        return green 
    else
        return red 
    end
end

function none_conditional_color(stringy) 
    if stringy == "无" then 
        return red 
    end
    return green 
end

function bool_to_yes_no(bool)
    if bool then 
        return "是"
    else
        return "否"
    end
end

local languages = {
[0] = "英语",
[1] = "法语",
[2] = "德语",
[3] = "意大利语",
[4] = "西班牙语",
[5] = "巴西语",
[6] = "波兰语",
[7] = "俄语",
[8] = "韩语",
[9] = "中文（繁体）",
[10] = "日语",
[11] = "墨西哥语",
[12] = "中文（简体）"
}
overlay_x_offset = 0.00
overlay_y_offset = 0.00

x_offset_slider = menu.slider_float(menu.my_root(), "叠加X偏移", {"glancexoffset"}, "", -1000, 1000, 55, 1, function(s)
    overlay_x_offset = s * 0.001
    reinit_window()
end)

y_offset_slider = menu.slider_float(menu.my_root(), "叠加Y偏移", {"glanceyoffset"}, "", -1000, 1000, -315, 1, function(s)
    overlay_y_offset = s * 0.001
    reinit_window()
end)

color1 = menu.colour(menu.my_root(), "背景色", {"glancebgcolor"}, "", background_color, true, function(on_change)
    background_color = on_change
    reinit_window()
end)

color2 = menu.colour(menu.my_root(), "高亮颜色", {"glancehighcolor"}, "", highlight_color, true, function(on_change)
    highlight_color = on_change
    reinit_window()
end)

color3 = menu.colour(menu.my_root(), "小标题颜色", {"glancesubheadcolor"}, "", subhead_color, true, function(on_change)
    subhead_color = on_change
    reinit_window()
end)

color4 = menu.colour(menu.my_root(), "标签颜色", {"glancelabelcolor"}, "", label_color, true, function(on_change)
    label_color = on_change
    reinit_window()
end)

color5 = menu.colour(menu.my_root(), "标题颜色", {"glanceheadercolor"}, "", header_color, true, function(on_change)
    header_color = on_change
    reinit_window()
end)

async_http.init("pastebin.com", "/raw/nrMdhHwE", function(result)
    menu.hyperlink(menu.my_root(), "加入 discord", result, "这是作者xSetrox的服务器")
end)
async_http.dispatch()

async_http.init("pastebin.com", "/raw/HScMyPPf", function(result)
    menu.hyperlink(menu.my_root(), "加入qq群", result, "这是不是作者的群，是汉化者MrLGXC的")
end)
async_http.dispatch()


x_offset_focused = false
menu.on_focus(x_offset_slider, function()
    x_offset_focused = true
    end
)

menu.on_blur(x_offset_slider, function()
    x_offset_focused = false
end)

y_offset_focused = false
menu.on_focus(y_offset_slider, function()
    y_offset_focused = true
end)

menu.on_blur(y_offset_slider, function()
    y_offset_focused = false
end)

color1_focused = false
menu.on_focus(color1, function()
    color1_focused = true
end)

menu.on_blur(color1, function()
    color1_focused = false
end)

color2_focused = false
menu.on_focus(color2, function()
    color2_focused = true
end)

menu.on_blur(color2, function()
    color2_focused = false
end)

color3_focused = false
menu.on_focus(color3, function()
    color3_focused = true
end)

menu.on_blur(color3, function()
    color3_focused = false
end)

color4_focused = false
menu.on_focus(color4, function()
    color4_focused = true
end)

menu.on_blur(color4, function()
    color4_focused = false
end)

color5_focused = false
menu.on_focus(color5, function()
    color4_focused = true
end)

menu.on_blur(color5, function()
    color5_focused = false
end)


all_weapons = {}
temp_weapons = util.get_weapons()
-- create a table with just weapon hashes, labels
for a,b in pairs(temp_weapons) do
    all_weapons[#all_weapons + 1] = {hash = b['hash'], label_key = b['label_key']}
end
function get_weapon_name_from_hash(hash) 
    for k,v in pairs(all_weapons) do 
        if v.hash == hash then 
            return util.get_label_text(v.label_key)
        end
    end
    return '无'
end

-- shamelessly stolen from keks
function dec_to_ipv4(ip)
	return string.format(
		"%i.%i.%i.%i", 
		ip >> 24 & 0xFF, 
		ip >> 16 & 0xFF, 
		ip >> 8  & 0xFF, 
		ip 		 & 0xFF
	)
end

local ammo_in_clip_alloc = memory.alloc_int()

while true do
    if not util.is_session_transition_active() then
        local focused_tbl = players.get_focused()
        if focused_tbl[1] ~= nil and menu.is_open() or (y_offset_focused or x_offset_focused or color1_focused or color2_focused or color3_focused or color4_focused) then 
            if PAD.IS_CONTROL_JUST_PRESSED(2, 29) then
                glance.toggle_cursor_mode()
            end
            if (y_offset_focused or x_offset_focused or blur_slider_focused  or color1_focused or color2_focused or color3_focused or color4_focused) then 
                focused = players.user()
            else
                focused = focused_tbl[1]
            end
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(focused)
            local playerpos = players.get_position(focused)
            local playername = players.get_name(focused)
            local m_x, m_y = menu.get_position()
            glance.begin(playername, m_x - 0.3 + overlay_x_offset, m_y + overlay_y_offset)
            glance.subhead("玩家", subhead_color)
            glance.start_horizontal()
            local script_host = players.get_script_host()
            local host = players.get_host()
        
            glance.label("主机: ", bool_to_yes_no(focused == host), label_color, conditional_color(focused == host))
            glance.divider()
            glance.label("脚本主机: ", bool_to_yes_no(focused == script_host), label_color, conditional_color(focused == script_host))
            glance.divider()
            glance.label("作弊者: ", bool_to_yes_no(players.is_marked_as_modder(focused)), label_color, conditional_color(players.is_marked_as_modder(focused)))
            glance.divider()
            glance.label("攻击过你: ", bool_to_yes_no(players.is_marked_as_attacker(focused)), label_color, conditional_color(players.is_marked_as_attacker(focused)))
            glance.end_horizontal()
            glance.start_horizontal()
            glance.label("钱包: ", '$' .. format_int(players.get_wallet(focused)), label_color, green)
            glance.divider()
            glance.label("银行: ", '$' .. format_int(players.get_bank(focused)), label_color, green)
            glance.divider()
            glance.label("总计: ", '$' .. format_int(players.get_money(focused)), label_color, green)
            glance.end_horizontal()
            local tags = players.get_tags_string(focused)
            if tags == "" then 
                tags = "无"
            end
            glance.start_horizontal()
            glance.label('标签: ', tags, label_color, cyan)
            glance.end_horizontal()
            local rid = players.get_rockstar_id(focused)
            local rid2 = players.get_rockstar_id_2(focused)
            glance.start_horizontal()
            glance.label("RID: ", if rid == rid2 then rid else rid .. '/' .. rid2, label_color, cyan)
            glance.end_horizontal()
            glance.start_horizontal()
            glance.label("IP: ", dec_to_ipv4(players.get_connect_ip(focused)), label_color, cyan)
            glance.end_horizontal()
            glance.start_horizontal()
            glance.label("等级: ", players.get_rank(focused), label_color, cyan)
            glance.end_horizontal()
            local kd = tonumber(string.format("%.2f", players.get_kd(focused)))
            glance.start_horizontal()
            glance.label("K/D: ", kd, label_color, cyan)
            glance.end_horizontal()
            glance.start_horizontal()
            glance.label("通缉等级: ", PLAYER.GET_PLAYER_WANTED_LEVEL(focused), label_color, cyan)
            glance.end_horizontal()
            glance.start_horizontal()
            glance.label("语言: ", languages[players.get_language(focused)], label_color, cyan)
            glance.end_horizontal()
            if focused == players.user() then
                glance.start_horizontal()
                glance.label("是女装大佬吗: ", "是", label_color, green)
                glance.end_horizontal()
            end
            glance.text(" ")
            if ENTITY.DOES_ENTITY_EXIST(ped) then 
                glance.subhead("角色", subhead_color)
                glance.start_horizontal()
                glance.label("X: ", math.floor(playerpos.x), label_color, cyan)
                glance.divider()
                glance.label("Y: ", math.floor(playerpos.y), label_color, cyan)
                glance.divider()
                glance.label("Z: ", math.floor(playerpos.z), label_color, cyan)
                glance.end_horizontal()
                glance.start_horizontal()
                local c1 = players.get_position(players.user())
                local c2 = players.get_position(focused)
                glance.label("与你的距离: ", math.ceil(MISC.GET_DISTANCE_BETWEEN_COORDS(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z)), label_color, cyan)
                glance.end_horizontal()
                glance.start_horizontal()
                local health_perc = ENTITY.GET_ENTITY_HEALTH(ped) / ENTITY.GET_ENTITY_MAX_HEALTH(ped)
                local hp_color = do_percentage_scale_color(health_perc)
                glance.label("血量: ", tostring(ENTITY.GET_ENTITY_HEALTH(ped)) .. '/' .. tostring(ENTITY.GET_ENTITY_MAX_HEALTH(ped)), label_color, hp_color)
                glance.divider()
                local armor_perc = PED.GET_PED_ARMOUR(ped)/PLAYER.GET_PLAYER_MAX_ARMOUR(pid)
                local armor_color = do_percentage_scale_color(armor_perc)
                glance.label("护甲: ", tostring(PED.GET_PED_ARMOUR(ped)) .. '/' .. tostring(PLAYER.GET_PLAYER_MAX_ARMOUR(pid)), label_color, armor_color)
                glance.divider()
                glance.label("无敌: ", bool_to_yes_no(players.is_godmode(focused)), label_color, conditional_color(players.is_godmode(focused)))
                glance.end_horizontal()
                glance.start_horizontal()
                glance.label("在室内: ", bool_to_yes_no(players.is_in_interior(focused)), label_color, conditional_color(players.is_in_interior(focused)))
                glance.end_horizontal()
                glance.start_horizontal()
                glance.label("雷达匿踪: ", bool_to_yes_no(players.is_otr(focused)), label_color, conditional_color(players.is_otr(focused)))
                glance.end_horizontal()
                local vehicle = players.get_vehicle_model(focused)
                if vehicle == 0 then 
                    disp_vehicle = "无"
                else
                    disp_vehicle = util.get_label_text(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(vehicle))
                end
                glance.start_horizontal()

                glance.label("载具: ", disp_vehicle, label_color, none_conditional_color(disp_vehicle)) 
                glance.end_horizontal()
                glance.text(" ")
                glance.subhead("武器", subhead_color)
                local wep_hash = WEAPON.GET_SELECTED_PED_WEAPON(ped)
                glance.start_horizontal()
                local wep_name =  get_weapon_name_from_hash(wep_hash)
                glance.label("武器: ", wep_name, label_color, none_conditional_color(wep_name))
                glance.end_horizontal()
                glance.start_horizontal()
                WEAPON.GET_AMMO_IN_CLIP(ped, wep_hash, ammo_in_clip_alloc)
                glance.label("弹夹: ", memory.read_int(ammo_in_clip_alloc) .. '/' .. WEAPON.GET_MAX_AMMO_IN_CLIP(ped, wep_hash, true), label_color, cyan)
                glance.end_horizontal()
            end
            glance.text(" ")
            glance.start_horizontal()
            if glance.button("传送到", purple, brighter_purple) then
                local c = players.get_position(focused)
                PED.SET_PED_COORDS_KEEP_VEHICLE(players.user_ped(), c.x, c.y, c.z)
            end
            if glance.button("踢出", red, darker_red) then
                menu.trigger_commands("kick " .. players.get_name(focused))
            end
            if glance.button("杀死", red, darker_red) then
                menu.trigger_commands("kill " .. players.get_name(focused))
            end
            glance.end_horizontal()
            glance.finish()
        end
    end
    util.yield() -- keeps the script running at all times.
end
