-------------------------------
--- Author: Rostal#9913
-------------------------------

util.keep_running()
util.require_natives("1681379138")


local function get_stat_int(stat)
    local ptr = memory.alloc_int()
    STATS.STAT_GET_INT(util.joaat(stat), ptr, -1)
    return memory.read_int(ptr)
end

local function set_stat_int(stat, value)
    STATS.STAT_SET_INT(util.joaat(stat), value, true)
end


local menu_root = menu.my_root()

menu.divider(menu_root, "Crew Level Editor")

for i = 0, 4, 1 do
    i = tostring(i)
    local crew_level_stat = "MPPLY_CREW_LOCAL_XP_" .. i
    local crew_id_stat = "MPPLY_CREW_" .. i .. "_ID"

    local crew_current_menu
    local crew_id_menu
    local crew_rp_menu

    local crew_menu = menu.list(menu_root, "Crew " .. i, {}, "", function()
        local crew_id = get_stat_int(crew_id_stat)
        local crew_rp = get_stat_int(crew_level_stat)

        menu.set_value(crew_id_menu, crew_id)
        menu.set_value(crew_rp_menu, crew_rp)

        local current_crew_level = get_stat_int("MPPLY_CURRENT_CREW_RANK")
        if current_crew_level > 8000 then current_crew_level = 8000 end
        if current_crew_level < 1 then current_crew_level = 1 end
        local current_crew_rp_min = util.get_rp_required_for_rank(current_crew_level)
        local current_crew_rp_max = util.get_rp_required_for_rank(current_crew_level + 1)

        if crew_rp >= current_crew_rp_min and crew_rp < current_crew_rp_max then
            menu.set_value(crew_current_menu, current_crew_level)
            menu.set_visible(crew_current_menu, true)
        else
            menu.set_visible(crew_current_menu, false)
        end
    end)

    crew_id_menu = menu.readonly(crew_menu, "Crew ID")
    crew_rp_menu = menu.readonly(crew_menu, "Crew RP")
    crew_current_menu = menu.readonly(crew_menu, "Crew Level [Current]")


    local crew_level = menu.slider(crew_menu, "Crew Level", { "crew" .. i .. "level" }, "", 1, 8000, 1, 1,
        function(value)
        end)

    menu.action(crew_menu, "Set Crew Level", { "setcrew" .. i .. "level" }, "", function()
        local rp = util.get_rp_required_for_rank(menu.get_value(crew_level))
        set_stat_int(crew_level_stat, rp)
        util.toast("Done!")
    end)
end
