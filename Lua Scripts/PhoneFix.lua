util.keep_running()
util.require_natives(1676318796)

local phonefixloop = false
local removePhoneGUI = true
menu.toggle(menu.my_root(), "PhoneFix", {}, "", function (p)
	util.toast(p)
    if p then
		phonefixloop = true
        util.create_thread(function ()
            while phonefixloop do
                if PAD.IS_CONTROL_JUST_PRESSED(0, 27) then --27 == inputphone
                    --util.toast("press")
                    --ty aaron
                    local localPed = PLAYER.PLAYER_PED_ID()
                    PED.SET_PED_CONFIG_FLAG(localPed, 242, false)
                    PED.SET_PED_CONFIG_FLAG(localPed, 243, false)
                    PED.SET_PED_CONFIG_FLAG(localPed, 244, false)
                    --
                    if (removePhoneGUI) then
	                    util.yield(500)
	                    local phonePos = v3.new()
	                    MOBILE.GET_MOBILE_PHONE_POSITION(phonePos) --Vector3* is param
	                    local phoneTable = {x=v3.getX(phonePos), y=v3.getY(phonePos), z=v3.getZ(phonePos)}
	                    MOBILE.SET_MOBILE_PHONE_POSITION(phoneTable.x - 10000, phoneTable.y, phoneTable.z)
	                end
                    util.yield()
                end
                util.yield()
				--util.toast("While running.")
            end
            util.yield()
        end)
    else
		phonefixloop = false
        --util.toast("Release.")
        local localPed = PLAYER.PLAYER_PED_ID()
        PED.SET_PED_CONFIG_FLAG(localPed, 242, true)
        PED.SET_PED_CONFIG_FLAG(localPed, 243, true)
        PED.SET_PED_CONFIG_FLAG(localPed, 244, true)
    end
end)

menu.toggle(menu.my_root(), "Remove Phone GUI?", {}, "Removes the phone that pops up in the bottom right.", function(t)
	removePhoneGUI = t
end, true)