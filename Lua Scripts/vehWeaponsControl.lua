util.require_no_lag('natives-1640181023')

function get_seat_ped_is_in(ped)
    local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)

    if veh == 0 then return false end

    local hash = ENTITY.GET_ENTITY_MODEL(veh)
    local seats = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(hash)
    
    for i = -1, seats - 2, 1 do
        if VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, i, false) == ped then return true, i end
    end
    return false
end

function get_vtable_entry_pointer(address, index)
    return memory.read_long(memory.read_long(address) + (8 * index))
end

function get_sub_handling_types(vehicle, type)
    local veh_handling_address = memory.read_long(entities.handle_to_pointer(vehicle) + 0x918)
    local sub_handling_array = memory.read_long(veh_handling_address + 0x0158)
    local sub_handling_count = memory.read_ushort(veh_handling_address + 0x0160)

    local types = {registerd = sub_handling_count, found = 0}

    for i = 0, sub_handling_count - 1, 1 do
        local sub_handling_data = memory.read_long(sub_handling_array + 8 * i)

        if sub_handling_data ~= 0 then
            local GetSubHandlingType_address = get_vtable_entry_pointer(sub_handling_data, 2)
            local result = util.call_foreign_function(GetSubHandlingType_address, sub_handling_data)

            if type and type == result then return sub_handling_data end
            
            types[#types+1] = {type = result, address = sub_handling_data}
            types.found = types.found + 1
        end
    end
    if type then return nil end
    return types
end

menu.action(menu.my_root(), "控制载具武器", {"vehWeaponsControl"}, "使您能够在当前座位上使用车辆上的任何武器", function ()
    local CVehicleWeaponHandlingDataAddress = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 9)

    if CVehicleWeaponHandlingDataAddress == 0 then util.toast("oopsie","这辆车似乎没有任何武器.") return end

    local WeaponSeats = CVehicleWeaponHandlingDataAddress + 0x0020
    local succes, seat = get_seat_ped_is_in(PLAYER.PLAYER_PED_ID())

    if succes then
        for i = 0, 4, 1 do
            memory.write_int(WeaponSeats + i * 4, seat + 1)
        end
        menu.trigger_commands("fixvehicle")
    end
end)