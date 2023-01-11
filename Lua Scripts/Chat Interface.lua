local function nullsub()end
local function GET_PLAYER_NAME(--[[Player (int)]] player)native_invoker.begin_call();native_invoker.push_arg_int(player);native_invoker.end_call("6D0DE6A7B5DA71F8");return native_invoker.get_return_value_string();end

menu.action(menu.my_root(), "Send Chat Message", {"sendchatmessage"}, "", function(click_type)
	menu.show_command_box_click_based(click_type, "sendchatmessage ")
end, function(message)
	chat.send_message(message, false, true, true)
end, "sendchatmessage [message]")

menu.action(menu.my_root(), "Send Team Chat Message", {"sendteamchatmessage"}, "", function(click_type)
	menu.show_command_box_click_based(click_type, "sendteamchatmessage ")
end, function(message)
	chat.send_message(message, true, true, true)
end, "sendteamchatmessage [message]")

chat.on_message(function(packet_sender, message_sender, msg, is_team_chat)
	if message_sender ~= nil and message_sender ~= packet_sender then
		msg = "(Spoofing as " .. GET_PLAYER_NAME(message_sender) .. ") " .. msg
	end
	if is_team_chat then
		msg = " [TEAM] " .. msg
	else
		msg = " [ALL] " .. msg
	end
	msg = GET_PLAYER_NAME(packet_sender) .. msg
	menu.action(menu.my_root(), msg, {}, "", nullsub)
end)

while true do
	util.yield()
end
