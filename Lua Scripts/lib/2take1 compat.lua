util.require_natives(1651208000)
util.keep_running()

-- keep stand-specific apis to ourselves
local stand = menu
local players = _G["players"]; _G["players"] = nil
local entities = _G["entities"]; _G["entities"] = nil
local chat = _G["chat"]; _G["chat"] = nil
local directx = _G["directx"]; _G["directx"] = nil
local util = _G["util"]; _G["util"] = nil
local lang = _G["lang"]; _G["lang"] = nil
local filesystem = _G["filesystem"]; _G["filesystem"] = nil
local async_http = _G["async_http"]; _G["async_http"] = nil
local memory = _G["memory"]; _G["memory"] = nil
local profiling = _G["profiling"]; _G["profiling"] = nil

-- you wouldn't fork a lua
_PVERSION=nil;newuserdata=nil;io.isdir=nil;io.isfile=nil;io.exists=nil;io.copyto=nil;io.filesize=nil;io.makedir=nil;io.absolute=nil;os.millis=nil;os.nanos=nil;os.seconds=nil;os.unixseconds=nil;string.split=nil;string.lfind=nil;string.rfind=nil;string.strip=nil;string.lstrip=nil;string.rstrip=nil;string.isascii=nil;string.islower=nil;string.isalpha=nil;string.isupper=nil;string.isalnum=nil;string.contains=nil;string.casefold=nil;string.partition=nil;string.endswith=nil;string.startswith=nil;string.find_last_of=nil;string.find_first_of=nil;string.iswhitespace=nil;string.find_last_not_of=nil;string.find_first_not_of=nil;table.freeze=nil;table.isfrozen=nil;table.contains=nil;

-- solving problems for users of our platform? no way!
SCRIPT_NAME=nil
SCRIPT_FILENAME=nil
SCRIPT_RELPATH=nil
SCRIPT_MANUAL_START=nil
SCRIPT_SILENT_START=nil
SCRIPT_MAY_NEED_OS=nil
-- On that note, let's just appreciate all the work kektram is doing:
-- "YOU WOULD HAVE CRASHED IF THIS CHECK WASN'T HERE."
-- "Fixed people being able to spawn certain new vehicles that crash your game with chat commands"

package.path = package.path .. ";" .. filesystem.stand_dir() .. "From 2Take1Menu\\scripts\\?.lua"

local config = {
	spoof_2take1_install_dir = true
}

HANDLER_CONTINUE = true
HANDLER_POP  = false

local split = function (input, sep)
    local t={}
    for str in string.gmatch(input, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local function int_to_uint(int)
	if int >= 0 then
		return int
	end
	return (1 << 32) + int
end

function notif_not_imp()
	util.toast("function not yet implemented")
	util.log(debug.traceback("not implemented", 2))
	return -1
end

local og_get_return_value_vector3 = native_invoker.get_return_value_vector3

native_invoker.get_return_value_vector3 = function ()
	local table = og_get_return_value_vector3()
	return v3(table.x, table.y, table.z)
end

function MenuKey()
	return {
		keys = {},
		push_vk = function (self, key)
			self.keys[#self.keys+1] = key
		end,
		push_str = function (self, key)
			self.keys[#self.keys+1] = key
		end,
		pop = function (self)
			self.keys[#self.keys] = nil
		end,
		clear = function (self)
			self.keys = {}
		end,
		is_down = function (self)
			if #self.keys == 0 then return false end
			for _, key in ipairs(self.keys) do
				if not util.is_key_down(key) then
					return false
				end
			end
			return true
		end,
		is_down_stepped = function (self)
			if #self.keys == 0 then return false end
			for _, key in ipairs(self.keys) do
				if not util.is_key_down(key) then
					return false
				end
			end
			return true
		end
	}
end

local feature_type_ids = { -- The table values are stolen from kek's essentials.lua
	regular = {
		action = 1 << 9,
		toggle = 1 << 0,
		action_value_f = 1 << 1 | 1 << 7 | 1 << 9,
		value_f = 1 << 0 | 1 << 1 | 1 << 7,
		action_slider = 1 << 1 | 1 << 2 | 1 << 9,
		slider = 1 << 0 | 1 << 1 | 1 << 2,
		autoaction_value_str = 1 << 1 | 1 << 5 | 1 << 10,
		autoaction_slider = 1 << 1 | 1 << 2 | 1 << 1,
		action_value_i = 1 << 1 | 1 << 3 | 1 << 9,
		value_i = 1 << 0 | 1 << 1 | 1 << 3,
		autoaction_value_f = 1 << 1 | 1 << 7 | 1 << 1,
		autoaction_value_i = 1 << 1 | 1 << 3 | 1 << 1,
		action_value_str = 1 << 1 | 1 << 5 | 1 << 9,
		value_str = 1 << 0 | 1 << 1 | 1 << 5,
		parent = 1 << 11
	},
	player = {
		action = 1 << 9 | 1 << 15,
		toggle = 1 << 0 | 1 << 15,
		action_value_f = 1 << 1 | 1 << 7 | 1 << 9  | 1 << 15,
		value_f = 1 << 0 | 1 << 1 | 1 << 7  | 1 << 15,
		action_slider = 1 << 1 | 1 << 2 | 1 << 9  | 1 << 15,
		slider = 1 << 0 | 1 << 1 | 1 << 2  | 1 << 15,
		autoaction_value_str = 1 << 1 | 1 << 5 | 1 << 10 | 1 << 15,
		autoaction_slider = 1 << 1 | 1 << 2 | 1 << 10 | 1 << 15,
		action_value_i = 1 << 1 | 1 << 3 | 1 << 9  | 1 << 15,
		value_i = 1 << 0 | 1 << 1 | 1 << 3  | 1 << 15,
		autoaction_value_f = 1 << 1 | 1 << 7 | 1 << 10 | 1 << 15,
		autoaction_value_i = 1 << 1 | 1 << 3 | 1 << 10 | 1 << 15,
		action_value_str = 1 << 1 | 1 << 5 | 1 << 9  | 1 << 15,
		value_str = 1 << 0 | 1 << 1 | 1 << 5  | 1 << 15,
		parent = 1 << 11
	}
}

vec3 = v3

local v2_meta = {
	__div=function (self, other)
		if type(other) == "table" then
			return v2(	self.x / other.x,
						self.y / other.y)
		elseif type(other) == "number" then
			return v2(	self.x / other,
						self.y / other)
		end
	end,
}

v2 = function (x, y)
	local inst = {x = x, y = y}
	setmetatable(inst, v2_meta)
	return inst
end

local v3_meta = {
	__is_const = true,
	__sub=function (self, other)
		if type(other) == "table" then
			return v3(	self.x - other.x,
						self.y - other.y,
						self.z - (other.z or 0))
		elseif type(other) == "number" then
			return v3(	self.x - other,
						self.y - other,
						self.z - other)
		end
	end,
	__add=function (self, other)
		if type(other) == "table" then
			return v3(	self.x + other.x,
						self.y + other.y,
						self.z + (other.z or 0))
		elseif type(other) == "number" then
			return v3(	self.x + other,
						self.y + other,
						self.z + other)
		end
	end,
	__mul=function (self, other)
		if type(other) == "table" then
			return v3(	self.x * other.x,
						self.y * other.y,
						self.z * (other.z or 0))
		elseif type(other) == "number" then
			return v3(	self.x * other,
						self.y * other,
						self.z * other)
		end
	end,
	__div=function (self, other)
		if type(other) == "table" then
			return v3(	self.x / other.x,
						self.y / other.y,
						self.z / (other.z or 0))
		elseif type(other) == "number" then
			return v3(	self.x / other,
						self.y / other,
						self.z / other)
		end
	end,
	__eq=function (self, other)
		return self.x == other.x and self.y == other.y and self.z == other.z
	end,
	__lt=function (self, other)
		return self.x + self.y + self.z < other.x + other.y + other.z
	end,
	__le=function (self, other)
		return self.x + self.y + self.z <= other.x + other.y + other.z
	end,
	__tostring=function (self)
		return "x:"..self.x.." y:"..self.y.." z:"..self.z
	end,
}

v3 = function (x, y, z)
	x = x or 0.0
	y = y or 0.0
	z = z or 0.0
	local vec =
	{	x = x, y = y or x, z = z or x,

		magnitude = function (self, other)
			local end_vec = other and (self - other) or self
			return math.sqrt(end_vec.x^2 + end_vec.y^2 + end_vec.z^2)
		end,
		transformRotToDir = function(self, deg_z, deg_x)
			local rad_z = deg_z * math.pi / 180;
			local rad_x = deg_x * math.pi / 180;
			local num = math.abs(math.cos(rad_x));
			self.x = -math.sin(rad_z) * num
			self.y = math.cos(rad_z) * num
			self.z = math.sin(rad_x)
		end,
		degToRad = function (self)
			self.x = self.x * math.pi / 180
			self.y = self.y * math.pi / 180
			self.z = self.z * math.pi / 180
		end,
		radToDeg = function (self)
			self.x = self.x * 180 / math.pi
			self.y = self.y * 180 / math.pi
			self.z = self.z * 180 / math.pi
		end
	}
	setmetatable(vec, v3_meta)
	return vec
end

local function IntToRGBA(colour)
	local t = {}
	for i = 0, 3 do
		t[i+1] = (colour >> (i * 8)) & 0xFF
	end
	return t
end

local og_type = type
type = function (t)
	t_type = og_type(t)
	if t_type == "table" and t.name then
		return "userdata"
	else
		return t_type
	end
end

local function RGBAToInt(R, G, B, A)
	A = A or 255
	return (
		 (R&0x0ff)<<0x00)|
		((G&0x0ff)<<0x08)|
		((B&0x0ff)<<0x10)|
		((A&0x0ff)<<0x18)
end

local gamerHandle = memory.alloc(13)
local function getGamerHandle(pid)
    NETWORK.NETWORK_HANDLE_FROM_PLAYER(pid, gamerHandle, 13)
    return gamerHandle
end

local function ensure_valid_value(is_float, val)
	if is_float then
		val = val * 100
	end
	return math.floor(val)
end

local function does_type_support_value(type)
	return type == feature_type_ids.regular.action_value_f or type == feature_type_ids.regular.action_value_i or type == feature_type_ids.regular.autoaction_value_f or type == feature_type_ids.regular.autoaction_value_i or type == feature_type_ids.regular.slider
end

local player_feature_setters = {
	min = 	function (self, val)
		val = ensure_valid_value(self.is_float, val)
		for _, command in pairs(self.feats) do
			stand.set_min_value(command.id, val)
		end
		rawset(self, "_min", val)
	end,
	max =	function (self, val)
		val = ensure_valid_value(self.is_float, val)
		for _, command in pairs(self.feats) do
			stand.set_max_value(command.id, val)
		end
		rawset(self, "_max", val)
	end,
	mod = 	function (self, val)
		val = ensure_valid_value(self.is_float, val)
		for _, command in pairs(self.feats) do
			stand.set_value(command.id, val)
		end
		rawset(self, "_mod", val)
	end,
	value = function (self, val)
		val = ensure_valid_value(self.is_float, val)
		for _, command in pairs(self.feats) do
			command.id = val
		end
		rawset(self, "_value", val)
	end,
	hidden = function (self, val)
		for _, command in pairs(self.feats) do
			stand.set_visible(command.id, not not val)
		end
		rawset(self, "_hidden", val)
	end,
	on = function (self, val)
		if self.id_toggle then
			for _, command in pairs(self.feats) do
				command.id_toggle = val
			end
		else
			for _, command in pairs(self.feats) do
				command.on = val
			end
		end
		rawset(self, "_on", val)
	end,
	str_data = function (self, val)
		for _, command in pairs(self.feats) do
			stand.set_action_slider_options(command.id, val)
		end
		rawset(self, "_str_data", val)
	end
}

local feature_setters = {
	name = 	function (self, val)
		if self.id_toggle then
			stand.set_menu_name(self.id_toggle, val)
			stand.set_menu_name(self.id, val.." type")
		else
			stand.set_menu_name(self.id, val)
		end
        rawset(self, "_name", val)
	end,
	min = 	function (self, val)
		val = ensure_valid_value(self.is_float, val)
		stand.set_min_value(self.id, val)
		rawset(self, "_min", val)
	end,
	max =	function (self, val)
		val = ensure_valid_value(self.is_float, val)
		stand.set_max_value(self.id, val)
		rawset(self, "_max", val)
	end,
	mod = 	function (self, val)
		val = ensure_valid_value(self.is_float, val)
		stand.set_step_size(self.id, val)
		rawset(self, "_value", val)
	end,
	value = function (self, val)
		rawset(self, "_value", val)
		if does_type_support_value(self.type) then
			val = ensure_valid_value(self.is_float, val)
			stand.set_value(self.id, val)
		end
	end,
	hidden = function (self, val)
		stand.set_visible(self.id, not not val)
		rawset(self, "_hidden", val)
	end,
	on = function (self, val)
		if self.id_toggle then
			stand.set_value(self.id_toggle, val)
		else
			if self.type == feature_type_ids.player.toggle or self.type == feature_type_ids.regular.toggle then
				stand.set_value(self.id, val)
			end
		end
		rawset(self, "_on", val)
		if self.handler then
			self:handler()
		end
	end,
	str_data = function (self, val)
		stand.set_action_slider_options(self.id, val)
		rawset(self, "_str_data", val)
	end
}

local player_feature_meta = {
    __index=function(self, index)
        	return rawget(self, "_"..index)
    end,
    __newindex=function(self, index, val)
        local setter = player_feature_setters[index]
		if setter then
			setter(self, val)
		else
			rawset(self, index, val)
		end
    end
}

local feat_array_meta = {
	__index=function ()
		return {}
	end
}

local parents = {}

local existing_features = {}

local feature_meta = {
    __index=function(self, index)
        return rawget(self, "_"..index)
    end,
    __newindex=function(self, index, val)
        local setter = feature_setters[index]
		if setter then
			setter(self, val)
		else
			rawset(self, index, val)
		end
    end
}

local player_features = {}



local feat = {
    new = function(name, parent, type)
		local parent_ft = parents[parent]
        local ft = {
			id=0,
			id_toggle=nil,
			parent=parents[parent],
			type=type,
			data={},
			_on=false,
			_name=name,
			_min=0,
			_max=1,
			_value=0,
			_hidden=false,
			set_str_data = function (self, data)
				self.str_data = data
				local feat = player_features[self.id]
				if feat then
					for _, command in ipairs(feat) do
						stand.set_action_slider_options(command, data)
					end
				else
					stand.set_action_slider_options(self.id, data)
				end
			end,
			pid=nil --this is not actually in the 2Take1 API but its usefull for me so i added it
		}
        setmetatable(ft, feature_meta)

		if parent_ft then
			parent_ft.children[#parent_ft.children+1] = ft
			parent_ft.child_count = parent_ft.child_count + 1
		end
        return ft
    end
}

local player_feat = {
    new = function(parent, feats, type)
        local ft = {
			feats = feats,
			id=0,
			parent_id=parent,
			type=type,
			data={},
			_on=false,
			_value=0,
			_min=0,
			_max=1,
			_mod=nil,
			_str_data={},
			set_str_data = function (self, data)
				for _, command in pairs(self.feats) do
					stand.set_action_slider_options(command.id, data)
				end
			end
		}
		setmetatable(ft.feats, feat_array_meta)
        setmetatable(ft, player_feature_meta)

        return ft
    end
}

local root_parent = feat.new("root", nil)
root_parent.id = stand.my_root()
root_parent.children = {}
root_parent.child_count = 0
parents[root_parent.id] = root_parent

local feature_types = {
	parent = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then
			if pid then
				parent = stand.player_root(pid)
			else
				parent = stand.my_root()
			end
		end
		local f = feat.new(name, parent)

		f.id = stand.list(parent, name, {name}, "", function ()
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		f.children = {}
		f.child_count = 0

		parents[f.id] = f

		return f
	end,
	toggle = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id = stand.toggle(parent, name, {name}, "", function (value)
			rawset(f, "on", value)

			while handler(f, pid) == HANDLER_CONTINUE do

				util.yield()
			end
		end)

		return f
	end,
	action = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id = stand.action(parent, name, {name}, "", function ()
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		return f
	end,
	value_i = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id_toggle = stand.toggle(parent, name, {name}, "", function (value)
			rawset(f, "on", value)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		f.id = stand.slider(parent, name.." value", {name.."value"}, "", 0, 1, 0, 1, function(value)
			rawset(f, "_value", value - 1)
		end)

		return f
	end,
	value_f = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id_toggle = stand.toggle(parent, name, {name}, "", function (value)
			rawset(f, "on", value)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		f.id = stand.slider_float(parent, name.." value", {name.."value"}, "", 0, 1, 0, 100, function(value)
			rawset(f, "_value", value - 1)
		end)
		f.is_float = true

		return f
	end,
	slider = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id_toggle = stand.toggle(parent, name, {name}, "", function (value)
			rawset(f, "on", value)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		f.id = stand.slider(parent, name.." value", {name.."value"}, "", 0, 1, 0, 1, function(value)
			rawset(f, "_value", value - 1)
		end)

		return f
	end,
	value_str = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id_toggle = stand.toggle(parent, name, {name}, "", function (value)
			rawset(f, "on", value)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		f.id =  stand.slider_text(parent, name.." type", {name.."type"}, "", {}, function (index)
			rawset(f, "_value", index - 1)
		end)

	 	return f
	end,
	action_value_i = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id = stand.slider(parent, name, {name}, "", 0, 1, 0, 1, function(value, click)
			rawset(f, "value", value)
			if not (click & CLICK_FLAG_AUTO) then
				while handler(f, pid) == HANDLER_CONTINUE do
					util.yield()
				end
			end
		end)

		return f
	end,
	action_value_f = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id = stand.slider_float(parent, name, {name}, "", 0, 1, 0, 100, function (value, click)
			rawset(f, "value", value)
			if not (click & CLICK_FLAG_AUTO) then
				while handler(f, pid) == HANDLER_CONTINUE do
					util.yield()
				end
			end
		end)
		f.is_float = true
		return f
	end,
	action_slider = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id = stand.click_slider(parent, name, {name}, "", 0, 1, 0, 1, function (value)
			rawset(f, "_value", value)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		return f
	end,
	action_value_str = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id =  stand.slider_text(parent, name, {name}, "", {}, function (index)
			rawset(f, "_value", index - 1)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

	 	return f
	end,
	autoaction_value_i = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id = stand.slider(parent, name, {name}, "", 0, 1, 0, 1, function (value)
			rawset(f, "_value", value)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		return f
	end,
	autoaction_value_f = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id = stand.slider_float(parent, name, {name}, "", 0, 1, 0, 100, function (value)
			rawset(f, "_value", value)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)
		f.is_float = true

		return f
	end,
	autoaction_slider = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id = stand.slider(parent, name, {name}, "", 0, 1, 0, 1, function (value)
			rawset(f, "_value", value)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

		return f
	end,
	autoaction_value_str = function (name, parent, handler, pid)
		if parent == 0 or parent == nil then parent = pid and stand.player_root(pid) or stand.my_root() end

		local f = feat.new(name, parent)

		f.id =  stand.slider_text(parent, name, {name}, "", {}, function (index)
			rawset(f, "_value", index - 1)
			while handler(f, pid) == HANDLER_CONTINUE do
				util.yield()
			end
		end)

	 	return f
	end
}

--players.on_join(function(pid)
--	for _, playerfeat in pairs(player_features) do
--		local parent_playerfeat = player_features[playerfeat.parent].playerfeat
--		playerfeat.playerfeat.feats[#playerfeat.playerfeat.feats + 1] = feature_types[playerfeat.type](playerfeat.name, parent_playerfeat.id, playerfeat.handler, pid)
--	end
--end)

menu = {
	add_feature = function (name, type, parent, handler)
		local feature_type = feature_types[type]
		if feature_type == nil then util.toast(type.." not found") return end
		local feature = feature_type(name, parent, handler or function() end)
		feature.type = feature_type_ids.regular[type]
		existing_features[feature.id] = feature
		return feature
	end,
	add_player_feature = function (name, type, parent, handler)
		local feature_type = feature_types[type]
		if feature_type == nil then util.toast(type.." not found") return end
		local feats = {}
		local parent_playerfeat = player_features[parent]
		if parent_playerfeat then
			for _, p_feat in pairs(parent_playerfeat.playerfeat.feats) do
				local new_feat = feature_type(name, p_feat.id, handler or function() end, p_feat.pid)
				new_feat.pid = p_feat.pid
				new_feat.type = feature_type_ids.regular[type]
				feats[p_feat.pid] = new_feat
			end
		else
			for _, pid in ipairs(players.list()) do
				parent = stand.player_root(pid)

				local new_feat = feature_type(name, parent, handler or function() end, pid)
				new_feat.pid = pid
				new_feat.type = feature_type_ids.regular[type]
				feats[pid] = new_feat
			end
		end

		local new_player_feat = player_feat.new(parent, feats, feature_type_ids.player[type])

		new_player_feat.id = util.joaat(name..type..tostring(util.current_time_millis())) --generate an id to use for the player feature

		player_features[new_player_feat.id] = {
			playerfeat = new_player_feat,
			name = name,
			type = type,
			parent = parent,
			handler = handler
		}
		return new_player_feat
	end,
	notify = function (message, title, _, _)
		message = tostring(message)
		if title then message = title.."\n"..message end
		util.toast(message, TOAST_ALL)
	end,
	get_player_feature = function (id)
		return player_features[id].playerfeat
	end,
	delete_feature = function (id)
		local feature = existing_features[id] or player_features[id].playerfeat
		if feature then
			feature.parent.children[feature.id] = nil
		end
		stand.delete(id)
	end,
	delete_player_feature = function (id)
		local p_feature = player_features[id].playerfeat
		if p_feature then
			for _, feature in pairs(p_feature.feats) do
				feature.parent.children[feature.id] = nil
				stand.delete(feature.id)
			end
			player_features[id] = nil
		end
	end,
	create_thread = util.create_thread,
	has_thread_finished = function (t)
		if type(t) == "thread" then
			return coroutine.status(t) == "dead"
		end
		return true
	end,
	delete_thread = function()
		notif_not_imp()
	end,
	is_trusted_mode_enabled = function ()
		return true
	end,
	get_version = function ()
		return "2.62.1"
	end
}

utils = {
	get_all_files_in_directory = function (path, extension)
		local files = filesystem.list_files(path)
		local result = {}
		for _, file in ipairs(files) do
			if filesystem.is_regular_file(file) then
			 	local split_file = split(file, ".")
				if #split_file > 1 and split_file[#split_file] == extension then
					local file_subs = split(file, "\\")
					result[#result+1] = file_subs[#file_subs]
				end
			end
		end
		return result
	end,
	get_all_sub_directories_in_directory = function (path)
		local files = filesystem.list_files(path)
		local result = {}
		for _, file in ipairs(files) do
			if not filesystem.is_regular_file(file) then
				local file_subs = split(file, "\\")
				result[#result+1] = file_subs[#file_subs]
			end
		end
		return result
	end,
	file_exists = filesystem.exists,
	dir_exists = filesystem.is_dir,
	make_dir = filesystem.mkdirs,
	get_appdata_path = function (dir, file)
		if dir[-1] == "\\" then
			dir = dir:sub(1, -2)
		end
		if file ~= "" then
			dir ..= "\\"..file
		end
		if config.spoof_2take1_install_dir and dir:sub(1, 22) == "PopstarDevs\\2Take1Menu" then
			dir = filesystem.stand_dir() .. "From 2Take1Menu\\" .. dir:sub(24)
		else
			dir = filesystem.appdata_dir() .. dir
		end
		if not filesystem.exists(dir) then
			filesystem.mkdir(dir)
		end
		return dir
	end,
	from_clipboard = util.get_clipboard_text,
	to_clipboard = util.copy_to_clipboard,
	time = util.current_unix_time_seconds,
	time_ms = util.current_time_millis,
	str_to_vecu64 = function (str)
		local tbl = {}
		str = str or ""
		for i=0,#str-1 do
			local slot = i//8
			local byte = string.byte(str,i+1)
			tbl[slot+1] = (tbl[slot+1] or 0) | byte<<((i-slot*8)*8)
		end
		return tbl
	end,
	vecu64_to_str = function (vec)
		local mem = memory.alloc(#vec*8)
		for i, value in ipairs(vec) do
			memory.write_long(mem+(8 * (i -1)), value)
		end
		return memory.read_string(mem)
	end
}

input = {
	get = function(header, prefill, max_length)
		local label = util.register_label(header or "")
		MISC.DISPLAY_ONSCREEN_KEYBOARD(1, label, 0, prefill or 0, 0, 0, 0, max_length or 500)
		local status

		repeat
			status = MISC.UPDATE_ONSCREEN_KEYBOARD()
			util.yield()
		until status ~= 0

		if status == 1 then status = 0 end

		return status, MISC.GET_ONSCREEN_KEYBOARD_RESULT() or ""
	end
}

ui = {
	notify_above_map = function (text, title, colour)
		util.toast(title.."\n"..text, TOAST_ABOVE_MAP)
	end,
	get_entity_from_blip = HUD.GET_BLIP_INFO_ID_ENTITY_INDEX,
	get_blip_from_entity = HUD.GET_BLIP_FROM_ENTITY,
	add_blip_for_entity = HUD.ADD_BLIP_FOR_ENTITY,
	set_blip_sprite = HUD.SET_BLIP_SPRITE,
	set_blip_colour = HUD.SET_BLIP_COLOUR,
	hide_hud_component_this_frame = HUD.HIDE_HUD_COMPONENT_THIS_FRAME,
	hide_hud_and_radar_this_frame = HUD.HIDE_HUD_AND_RADAR_THIS_FRAME,
	get_label_text = HUD._GET_LABEL_TEXT,
	draw_rect = GRAPHICS.DRAW_RECT,
	draw_line = function (pos1, pos2 , r, g, b, a)
		GRAPHICS.DRAW_LINE(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, r, g, b, a)
	end,
	draw_text = function (text, pos)
		util.BEGIN_TEXT_COMMAND_DISPLAY_TEXT(text)
		HUD.END_TEXT_COMMAND_DISPLAY_TEXT(pos.x, pos.y, 0)
	end,
	set_text_scale = function (size)
		return HUD.SET_TEXT_SCALE(1.0, size)
	end,
	set_text_color = HUD.SET_TEXT_COLOUR,
	set_text_font = HUD.SET_TEXT_FONT,
	set_text_wrap = HUD.SET_TEXT_WRAP,
	set_text_outline = HUD.SET_TEXT_OUTLINE,
	set_text_centre = HUD.SET_TEXT_CENTRE,
	set_text_right_justify = HUD.SET_TEXT_RIGHT_JUSTIFY,
	set_text_justification = HUD.SET_TEXT_JUSTIFICATION,
	set_new_waypoint = function (pos)
		HUD.SET_NEW_WAYPOINT(pos.x, pos.y)
	end,
	get_waypoint_coord = function()
		local waypoint = HUD.GET_FIRST_BLIP_INFO_ID(8)
		local coords = HUD.GET_BLIP_COORDS(waypoint)
		return v2(coords.x, coords.y)
	end,
	is_hud_component_active = HUD.IS_HUD_COMPONENT_ACTIVE,
	show_hud_component_this_frame = HUD.SHOW_HUD_COMPONENT_THIS_FRAME,
	set_waypoint_off = HUD.SET_WAYPOINT_OFF,
	set_blip_as_mission_creator_blip = HUD.SET_BLIP_AS_MISSION_CREATOR_BLIP,
	is_mission_creator_blip = HUD.IS_MISSION_CREATOR_BLIP,
	add_blip_for_radius = function (pos, radius)
		HUD.ADD_BLIP_FOR_RADIUS(pos.x, pos.y, pos.z, radius)
	end,
	add_blip_for_pickup = HUD.ADD_BLIP_FOR_PICKUP,
	add_blip_for_coord = function(pos)
		HUD.ADD_BLIP_FOR_COORD(pos.x, pos.y, pos.z)
	end,
	set_blip_coord = function (blip, pos)
		HUD.SET_BLIP_COORDS(blip, pos.x, pos.y, pos.z)
	end,
	get_blip_coord = HUD.GET_BLIP_COORDS,
	remove_blip = HUD.REMOVE_BLIP,
	set_blip_route = HUD.SET_BLIP_ROUTE,
	set_blip_route_color = HUD.SET_BLIP_ROUTE_COLOUR,
	get_current_notification = HUD.THEFEED_GET_FIRST_VISIBLE_DELETE_REMAINING,
	remove_notification = HUD.THEFEED_REMOVE_ITEM,
	get_objective_coord = function ()
		local blip = HUD.GET_NEXT_BLIP_INFO_ID(143) or HUD.GET_NEXT_BLIP_INFO_ID(144) or HUD.GET_NEXT_BLIP_INFO_ID(145) or HUD.GET_NEXT_BLIP_INFO_ID(146)
		if not blip then return false end
		HUD.GET_BLIP_COORDS(blip)
	end,
}

scriptdraw = {
	register_sprite = directx.create_texture,
	draw_sprite = function (id, pos, scale, rot, colour)
		local c = IntToRGBA(colour)
		directx.draw_texture(id, scale, scale, 0.5 , 0.5, pos.x, pos.y, rot, c[1], c[2], c[3], c[4])
	end,
	get_text_size = function (str, factor)
		return v2(0.001, 0.001)
	end,
	size_pixel_to_rel_x = function (x)
		return x
	end,
	size_pixel_to_rel_y = function (y)
		return y
	end,
	draw_text = function (text, pos, size, scale, rgba, outline, unk)
		util.BEGIN_TEXT_COMMAND_DISPLAY_TEXT(text)
		HUD.END_TEXT_COMMAND_DISPLAY_TEXT(pos.x, pos.y, 0)
	end,
	draw_line = function(pos1, pos2, unk, rgba)
		notif_not_imp()
	end
}

player = {
	player_id = players.user,
	get_player_ped = players.user_ped,
	set_player_model = PLAYER.SET_PLAYER_MODEL,
	get_player_group = PLAYER.GET_PLAYER_GROUP,
	is_player_female = function (pid)
		return ENTITY.GET_ENTITY_MODEL(PLAYER.GET_PLAYER_PED(pid)) == util.joaat("mp_f_freemode_01")
	end,
	is_player_friend = function (pid)
		return NETWORK.NETWORK_IS_FRIEND(getGamerHandle(pid))
	end,
	is_player_playing = PLAYER.IS_PLAYER_PLAYING,
	is_player_free_aiming = PLAYER.IS_PLAYER_FREE_AIMING,
	get_entity_player_is_aiming_at = function (pid)
		local ent = memory.alloc_int()
		PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(pid, ent)
		local result = memory.read_int(ent)
		return result
	end,
	get_personal_vehicle = entities.get_user_personal_vehicle_as_handle,
	set_player_visible_locally = NETWORK.SET_PLAYER_VISIBLE_LOCALLY,
	set_local_player_visible_locally = NETWORK.SET_LOCAL_PLAYER_VISIBLE_LOCALLY,
	set_player_as_modder = function ()
	end,
	get_player_name = PLAYER.GET_PLAYER_NAME,
	get_player_scid = players.get_rockstar_id,
	is_player_pressing_horn = PLAYER.IS_PLAYER_PRESSING_HORN,
	get_player_ip = players.get_connect_ip,
	is_player_modder = players.is_marked_as_modder,
	is_player_god = players.is_godmode,
	get_player_wanted_level = PLAYER.GET_PLAYER_WANTED_LEVEL,
	player_count = function ()
		return #players.list()
	end,
	is_player_in_any_vehicle = function (pid)
		return PED.IS_PED_IN_ANY_VEHICLE(PLAYER.GET_PLAYER_PED(pid), true)
	end,
	get_player_coords = function (pid)
		return ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid))
	end,
	get_player_heading = function (pid)
		return ENTITY.GET_ENTITY_HEADING(PLAYER.GET_PLAYER_PED(pid))
	end,
	get_player_health = function (pid)
		return ENTITY.GET_ENTITY_HEALTH(PLAYER.GET_PLAYER_PED(pid))
	end,
	get_player_max_health = function (pid)
		return ENTITY.GET_ENTITY_MAX_HEALTH(PLAYER.GET_PLAYER_PED(pid))
	end,
	get_player_armour = function (pid)
		return PED.GET_PED_ARMOUR(PLAYER.GET_PLAYER_PED(pid))
	end,
	get_player_from_ped = function (ped)
		if not PED.IS_PED_A_PLAYER(ped) then return -1 end
		for _, pid in ipairs(players.list()) do
			if PLAYER.GET_PLAYER_PED(pid) == ped then
				return pid
			end
		end
		return -1
	end,
	get_player_team = PLAYER.GET_PLAYER_TEAM,
	get_player_vehicle = function (pid)
		return PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED(pid))
	end,
	is_player_vehicle_god = function (pid)
		return ENTITY.GET_ENTITY_CAN_BE_DAMAGED(PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED(pid)))
	end,
	is_player_host = function (pid)
		return players.get_host() == pid
	end,
	get_host = players.get_host,
	is_player_spectating = function (pid)
		return false
	end,
	get_player_model = function (pid)
		return int_to_uint(ENTITY.GET_ENTITY_MODEL(PLAYER.GET_PLAYER_PED(pid)))
	end,
	send_player_sms = function (pid, message)
		stand.trigger_commands("smstext"..players.get_name(pid).." "..message)
		stand.trigger_commands("smssend"..players.get_name(pid))
	end,
	unset_player_as_modder = function (pid)
	end,
	get_player_modder_flags = function (pid)
		return 0
	end,
	get_modder_flag_text = function (pid)
		return ""
	end,
	get_modder_flag_ends = function (pid)
		return 0
	end,
	add_modder_flag = function (pid)
		return 0
	end,
	is_player_valid = function (pid)
		return players.exists(pid)
	end,
	get_player_host_token = function (pid)
		players.get_host_token(pid)
	end,
	get_player_host_priority = function (pid) --will implement at some point
		return 4
	end,
	set_player_targeting_mode = PLAYER.SET_PLAYER_TARGETING_MODE,
}

ped = {
	is_ped_in_any_vehicle = PED.IS_PED_IN_ANY_VEHICLE,
	set_group_formation = PED.SET_GROUP_FORMATION,
	set_ped_as_group_member = PED.SET_PED_AS_GROUP_MEMBER,
	get_ped_group = PED.GET_PED_GROUP_INDEX,
	get_group_size = PED.GET_GROUP_SIZE,
	get_ped_health = function (ped)
		return ENTITY.GET_ENTITY_HEALTH(ped)
	end,
	set_ped_health = function (ped, value)
		ENTITY.SET_ENTITY_HEALTH(ped, value, 0)
	end,
	is_ped_ragdoll = PED.IS_PED_RAGDOLL,
	is_ped_a_player = PED.IS_PED_A_PLAYER,
	get_current_ped_weapon = WEAPON.GET_CURRENT_PED_WEAPON,
	set_ped_into_vehicle = PED.SET_PED_INTO_VEHICLE,
	get_ped_drawable_variation = PED.GET_PED_DRAWABLE_VARIATION,
	get_ped_texture_variation = PED.GET_PED_TEXTURE_VARIATION,
	get_ped_prop_index = PED.GET_PED_PROP_INDEX,
	get_ped_prop_texture_index = PED.GET_PED_PROP_TEXTURE_INDEX,
	set_ped_component_variation = PED.SET_PED_COMPONENT_VARIATION,
	set_ped_prop_index = PED.SET_PED_PROP_INDEX,
	set_ped_can_switch_weapons = function (ped, state)
		PED.SET_PED_CONFIG_FLAG(ped, 48, state)
	end,
	is_ped_shooting = PED.IS_PED_SHOOTING,
	get_ped_bone_index = PED.GET_PED_BONE_INDEX,
	get_ped_bone_coords = function (ped, boneindex, offset)
		return true, PED.GET_PED_BONE_COORDS(ped, boneindex, offset.x, offset.y, offset.z)
	end,
	get_ped_relationship_group_hash = PED.GET_PED_RELATIONSHIP_GROUP_HASH,
	set_ped_relationship_group_hash = PED.SET_PED_RELATIONSHIP_GROUP_HASH,
	get_vehicle_ped_is_using = PED.GET_VEHICLE_PED_IS_USING,
	clear_all_ped_props = PED.CLEAR_ALL_PED_PROPS,
	clear_ped_tasks_immediately = TASK.CLEAR_PED_TASKS_IMMEDIATELY,
	clear_ped_blood_damage = PED.CLEAR_PED_BLOOD_DAMAGE,
	is_ped_in_vehicle = PED.IS_PED_IN_VEHICLE,
	is_ped_using_any_scenario = PED.IS_PED_USING_ANY_SCENARIO,
	set_ped_to_ragdoll = PED.SET_PED_TO_RAGDOLL,
	set_ped_can_ragdoll = PED.SET_PED_CAN_RAGDOLL,
	can_ped_ragdoll = PED.CAN_PED_RAGDOLL,
	get_ped_last_weapon_impact = function (ped)
		local vec = vec3.new()
		PED.GET_PED_LAST_WEAPON_IMPACT_COORD(ped, vec)
		local coord = {x = vec3.getX(vec), y = vec3.getY(vec), z = vec3.getZ(vec)}
		return coord
	end,
	set_ped_combat_ability = PED.SET_PED_COMBAT_ABILITY,
	get_ped_max_health = PED.GET_PED_MAX_HEALTH,
	set_ped_max_health = PED.SET_PED_MAX_HEALTH,
	resurrect_ped = PED.RESURRECT_PED,
	set_ped_combat_movement = PED.SET_PED_COMBAT_MOVEMENT,
	set_ped_combat_range = PED.SET_PED_COMBAT_RANGE,
	set_ped_combat_attributes = PED.SET_PED_COMBAT_ATTRIBUTES,
	set_ped_accuracy = PED.SET_PED_ACCURACY,
	create_ped = entities.create_ped,
	get_number_of_ped_drawable_variations = PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS,
	get_number_of_ped_texture_variations = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS,
	get_number_of_ped_prop_drawable_variations = PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS,
	get_number_of_ped_prop_texture_variations = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS,
	set_ped_random_component_variation = PED.SET_PED_RANDOM_COMPONENT_VARIATION,
	set_ped_default_component_variation = PED.SET_PED_DEFAULT_COMPONENT_VARIATION,
	set_ped_movement_clipset = PED.SET_PED_MOVEMENT_CLIPSET,
	reset_ped_movement_clipset = PED.RESET_PED_MOVEMENT_CLIPSET,
	clone_ped = PED.CLONE_PED,
	set_ped_config_flag = PED.SET_PED_CONFIG_FLAG,
	set_ped_ragdoll_blocking_flags = PED.SET_RAGDOLL_BLOCKING_FLAGS,
	reset_ped_ragdoll_blocking_flags = PED.CLEAR_RAGDOLL_BLOCKING_FLAGS,
	set_ped_density_multiplier_this_frame = PED.SET_PED_DENSITY_MULTIPLIER_THIS_FRAME,
	set_scenario_ped_density_multiplier_this_frame = PED.SET_SCENARIO_PED_DENSITY_MULTIPLIER_THIS_FRAME,
	get_all_peds = entities.get_all_peds_as_handles,
	create_group = PED.CREATE_GROUP,
	remove_group = PED.REMOVE_GROUP,
	set_ped_as_group_leader = PED.SET_PED_AS_GROUP_LEADER,
	remove_ped_from_group = PED.REMOVE_PED_FROM_GROUP,
	is_ped_group_member = PED.IS_PED_GROUP_MEMBER,
	set_group_formation_spacing = PED.SET_GROUP_FORMATION_SPACING,
	reset_group_formation_default_spacing = PED.RESET_GROUP_FORMATION_DEFAULT_SPACING,
	set_ped_never_leaves_group = PED.SET_PED_NEVER_LEAVES_GROUP,
	does_group_exist = PED.DOES_GROUP_EXIST,
	is_ped_in_group = PED.IS_PED_IN_GROUP,
	set_create_random_cops = PED.SET_CREATE_RANDOM_COPS,
	can_create_random_cops = PED.CAN_CREATE_RANDOM_COPS,
	is_ped_swimming = PED.IS_PED_SWIMMING,
	is_ped_swimming_underwater = PED.IS_PED_SWIMMING_UNDER_WATER,
	clear_relationship_between_groups = PED.CLEAR_RELATIONSHIP_BETWEEN_GROUPS,
	set_relationship_between_groups = PED.SET_RELATIONSHIP_BETWEEN_GROUPS,
	get_ped_head_blend_data = PED.GET_PED_HEAD_BLEND_DATA,
	set_ped_head_blend_data = PED.SET_PED_HEAD_BLEND_DATA,
	--get_ped_face_feature = !#! NO MATCH FOUND !#!,
	set_ped_face_feature = PED._SET_PED_MICRO_MORPH_VALUE,
	--get_ped_hair_color = !#! NO MATCH FOUND !#!, ----need a hook
	--get_ped_hair_highlight_color = !#! NO MATCH FOUND !#!, ----need a hook
	get_ped_eye_color = PED._GET_PED_EYE_COLOR,
	set_ped_hair_colors = PED._SET_PED_HAIR_COLOR,
	set_ped_eye_color = PED._SET_PED_EYE_COLOR,
	set_ped_head_overlay = PED.SET_PED_HEAD_OVERLAY,
	get_ped_head_overlay_value = PED._GET_PED_HEAD_OVERLAY_VALUE,
	--get_ped_head_overlay_opacity = !#! NO MATCH FOUND !#!, --need a hook
	set_ped_head_overlay_color = PED._SET_PED_HEAD_OVERLAY_COLOR,
	--get_ped_head_overlay_color_type = !#! NO MATCH FOUND !#!, --need a hook
	--get_ped_head_overlay_color = !#! NO MATCH FOUND !#!, --need a hook
	--get_ped_head_overlay_highlight_color = !#! NO MATCH FOUND !#!, --need a hook
	set_can_attack_friendly = PED.SET_CAN_ATTACK_FRIENDLY,
	add_relationship_group = PED.ADD_RELATIONSHIP_GROUP,
	does_relationship_group_exist = PED._DOES_RELATIONSHIP_GROUP_EXIST,
	remove_relationship_group = PED.REMOVE_RELATIONSHIP_GROUP
}

network = {
	network_is_host = NETWORK.NETWORK_IS_HOST,
	has_control_of_entity = NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY,
	request_control_of_entity = NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY,
	is_session_started = NETWORK.NETWORK_IS_SESSION_STARTED,
	network_session_kick_player = NETWORK.NETWORK_SESSION_KICK_PLAYER,
	is_friend_online = NETWORK.NETWORK_IS_FRIEND_ONLINE,
	is_friend_in_multiplayer = NETWORK.NETWORK_IS_FRIEND_IN_MULTIPLAYER,
	get_friend_scid = function(name)
		for i=0,NETWORK.NETWORK_GET_FRIEND_COUNT()-1 do
			if NETWORK.NETWORK_GET_FRIEND_NAME(i) == name then
				NETWORK.NETWORK_HANDLE_FROM_FRIEND(i, gamerHandle, 13)
				return tonumber(NETWORK.NETWORK_MEMBER_ID_FROM_GAMER_HANDLE(gamerHandle))
			end
		end
    return 0
	end,
	get_friend_count = NETWORK.NETWORK_GET_FRIEND_COUNT,
	get_max_friends = NETWORK.NETWORK_GET_MAX_FRIENDS,
	network_hash_from_player = NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE,
	get_friend_index_name = NETWORK.NETWORK_GET_FRIEND_NAME,
	is_friend_index_online = NETWORK.NETWORK_IS_FRIEND_INDEX_ONLINE,
	is_scid_friend = function(rid)
    rid = tostring(rid)
    for i=0,NETWORK.NETWORK_GET_FRIEND_COUNT()-1 do
        NETWORK.NETWORK_HANDLE_FROM_FRIEND(i, gamerHandle, 13)
        if NETWORK.NETWORK_MEMBER_ID_FROM_GAMER_HANDLE(gamerHandle) == rid then
            return true
        end
    end
    return false
end,
	get_entity_player_is_spectating = function ()
		return nil
	end,
	get_player_player_is_spectating = function ()
		return nil
	end,
	send_chat_message = function (message, team)
		chat.send_message(message, team, true, true)
	end,
	force_remove_player = function (pid)
		stand.trigger_commands("kick"..players.get_name(pid))
		return false
	end,
}

entity = {
	get_entity_coords = ENTITY.GET_ENTITY_COORDS,
	set_entity_coords_no_offset = function (ent, pos)
		ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ent, pos.x, pos.y, pos.z)
		return true
	end,
	get_entity_rotation = ENTITY.GET_ENTITY_ROTATION,
	set_entity_rotation = function (ent, rot)
		ENTITY.SET_ENTITY_ROTATION(ent, rot.x, rot.y, rot.z, 2, true)
	end,
	set_entity_heading = ENTITY.SET_ENTITY_HEADING,
	set_entity_velocity = function (ent, veh)
		ENTITY.SET_ENTITY_VELOCITY(ent, veh.x, veh.y, veh.z)
	end,
	get_entity_velocity = ENTITY.GET_ENTITY_VELOCITY,
	is_an_entity = ENTITY.IS_AN_ENTITY,
	is_entity_a_ped = ENTITY.IS_ENTITY_A_PED,
	is_entity_a_vehicle = ENTITY.IS_ENTITY_A_VEHICLE,
	is_entity_an_object = ENTITY.IS_ENTITY_AN_OBJECT,
	is_entity_dead = ENTITY.IS_ENTITY_DEAD,
	is_entity_on_fire = FIRE.IS_ENTITY_ON_FIRE,
	is_entity_visible = ENTITY.IS_ENTITY_VISIBLE,
	is_entity_attached = ENTITY.IS_ENTITY_ATTACHED,
	set_entity_visible = ENTITY.SET_ENTITY_VISIBLE,
	get_entity_type = ENTITY.GET_ENTITY_TYPE,
	set_entity_gravity = ENTITY.SET_ENTITY_HAS_GRAVITY,
	apply_force_to_entity = ENTITY.APPLY_FORCE_TO_ENTITY,
	get_entity_attached_to = ENTITY.GET_ENTITY_ATTACHED_TO,
	detach_entity = ENTITY.DETACH_ENTITY,
	get_entity_model_hash = function (veh)
		return int_to_uint(ENTITY.GET_ENTITY_MODEL(veh))
	end,
	get_entity_heading = ENTITY.GET_ENTITY_HEADING,
	attach_entity_to_entity = function (subject,  target,  boneIndex,  offset,  rot,  softPinning,  collision,  isPed,  vertexIndex,  fixedRot)
		ENTITY.ATTACH_ENTITY_TO_ENTITY(subject, target, boneIndex, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, false,  softPinning, collision, isPed, vertexIndex, fixedRot)
		return true
	end,
	set_entity_as_mission_entity = ENTITY.SET_ENTITY_AS_MISSION_ENTITY,
	set_entity_collision = ENTITY.SET_ENTITY_COLLISION,
	is_entity_in_air = ENTITY.IS_ENTITY_IN_AIR,
	set_entity_as_no_longer_needed = function (ent)
		local ent_ptr = memory.alloc_int()
		memory.write_int(ent_ptr, ent)
		ENTITY.SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
	end,
	set_entity_no_collsion_entity = ENTITY.SET_ENTITY_NO_COLLISION_ENTITY,
	freeze_entity = ENTITY.FREEZE_ENTITY_POSITION,
	get_entity_offset_from_coords = ENTITY.GET_OFFSET_FROM_ENTITY_GIVEN_WORLD_COORDS,
	get_entity_offset_from_entity = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS,
	set_entity_alpha = ENTITY.SET_ENTITY_ALPHA,
	reset_entity_alpha = ENTITY.RESET_ENTITY_ALPHA,
	delete_entity = entities.delete_by_handle,
	set_entity_god_mode = ENTITY.SET_ENTITY_INVINCIBLE,
	get_entity_god_mode = function(ent) return not ENTITY._GET_ENTITY_CAN_BE_DAMAGED(ent) end,
	is_entity_in_water = ENTITY.IS_ENTITY_IN_WATER,
	get_entity_speed = ENTITY.GET_ENTITY_SPEED,
	set_entity_lights = ENTITY.SET_ENTITY_LIGHTS,
	set_entity_max_speed = ENTITY.SET_ENTITY_MAX_SPEED,
	get_entity_pitch = ENTITY.GET_ENTITY_PITCH,
	get_entity_roll = ENTITY.GET_ENTITY_ROLL,
	--get_entity_physics_rotation = !#! NO MATCH FOUND !#!,
	get_entity_physics_heading = ENTITY._GET_ENTITY_PHYSICS_HEADING,
	--get_entity_physics_pitch = !#! NO MATCH FOUND !#!,
	--get_entity_physics_roll = !#! NO MATCH FOUND !#!,
	does_entity_have_physics = ENTITY.DOES_ENTITY_HAVE_PHYSICS,
	get_entity_rotation_velocity = ENTITY.GET_ENTITY_ROTATION_VELOCITY,
	get_entity_submerged_level = ENTITY.GET_ENTITY_SUBMERGED_LEVEL,
	get_entity_population_type = ENTITY.GET_ENTITY_POPULATION_TYPE,
	is_entity_static = ENTITY.IS_ENTITY_STATIC,
	is_entity_in_zone = ENTITY.IS_ENTITY_IN_ZONE,
	is_entity_upright = ENTITY.IS_ENTITY_UPRIGHT,
	is_entity_upside_down = ENTITY.IS_ENTITY_UPSIDEDOWN,
	has_entity_been_damaged_by_any_object = ENTITY.HAS_ENTITY_BEEN_DAMAGED_BY_ANY_OBJECT,
	has_entity_been_damaged_by_any_vehicle = ENTITY.HAS_ENTITY_BEEN_DAMAGED_BY_ANY_VEHICLE,
	has_entity_been_damaged_by_any_ped = ENTITY.HAS_ENTITY_BEEN_DAMAGED_BY_ANY_PED,
	has_entity_been_damaged_by_entity = ENTITY.HAS_ENTITY_BEEN_DAMAGED_BY_ENTITY,
	does_entity_have_drawable = ENTITY.DOES_ENTITY_HAVE_DRAWABLE,
	has_entity_collided_with_anything = ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING,
	--get_entity_entity_has_collided_with = !#! NO MATCH FOUND !#!,
	get_entity_bone_index_by_name = ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME,
	get_entity_forward_vector = ENTITY.GET_ENTITY_FORWARD_VECTOR,
	get_entity_model_dimensions = function (hash)
		local minimum = vec3.new()
		local maximum = vec3.new()
		MISC.GET_MODEL_DIMENSIONS(hash, minimum, maximum)
		local maximum_vec = v3(maximum.x, maximum.y, maximum.z)
		local minimum_vec = v3(minimum.x, minimum.y, minimum.z)
		return minimum_vec, maximum_vec
	end
}

object = {
	create_object = function (model, pos, networked, dynamic)
		return OBJECT.CREATE_OBJECT_NO_OFFSET(model, pos.x, pos.y, pos.z, networked, dynamic)
	end,
	create_world_object = entities.create_object,
	get_all_objects = entities.get_all_objects_as_handles,
	get_all_pickups = entities.get_all_pickups_as_handles
}

stats = {
	stat_get_int = function (hash, unk)
		local value_ptr = memory.alloc_int()
		local state = STATS.STAT_GET_INT(hash, value_ptr, unk)
		local value = memory.read_int(value_ptr)
		return value, state
	end,
	stat_get_float = function (hash, unk)
		local value_ptr = memory.alloc_int()
		local state = STATS.STAT_GET_FLOAT(hash, value_ptr, unk)
		local value = memory.read_float(value_ptr)
		return value, state
	end,
	stat_get_bool = function (hash, unk)
		local value_ptr = memory.alloc_int()
		local state = STATS.STAT_GET_BOOl(hash, value_ptr, unk)
		local value = memory.read_bool(value_ptr)
		return value, state
	end,
	stat_set_int = STATS.STAT_SET_INT,
	stat_set_float = STATS.STAT_SET_FLOAT,
	stat_set_bool = STATS.STAT_SET_BOOL,
	stat_get_i64 = notif_not_imp,
	stat_set_i64 = notif_not_imp,
	stat_get_u64 = notif_not_imp,
	stat_set_u64 = notif_not_imp,
	stat_get_masked_int = STATS.STAT_GET_MASKED_INT,
	stat_set_masked_int = STATS.STAT_SET_MASKED_INT,
	stat_get_masked_bool = notif_not_imp,
	stat_set_masked_bool = notif_not_imp,
	stat_get_bool_hash_and_mask = notif_not_imp,
	stat_get_int_hash_and_mask = notif_not_imp,
}

script = {
	trigger_script_event = function (eventId, player, params) 
		util.trigger_script_event(1 << player, {eventId, table.unpack(params)})
	end,
	get_host_of_this_script = players.get_script_host,
	get_global_f = function (i)
		return memory.read_float(memory.script_global(i))
	end,
	get_global_i = function (i)
		return memory.read_int(memory.script_global(i))
	end,
	set_global_f = function (i, v)
		memory.write_float(memory.script_global(i), v)
		return true
	end,
	set_global_i = function (i, v)
		memory.write_int(memory.script_global(i), v)
		return true
	end,
	get_local_f =  function (script, i)
		return memory.read_float(memory.script_local(script, i))
	end,
	get_local_i = function (script, i)
		return memory.read_int(memory.script_local(script, i))
	end,
	set_local_f = function (script, i, v)
		return memory.write_float(memory.script_local(script, i), v)
	end,
	set_local_i = function (script, i, v)
		return memory.write_int(memory.script_local(script, i), v)
	end
}

local weapon_list
--category_id || 0
--hash || -1716189206
--label_key || WT_KNIFE
--category || MELEE
local weapon_hash_to_weapon
local function populate_hash_to_weapon_table()
	if not weapon_list then weapon_list = util.get_weapons() end
	weapon_hash_to_weapon = {}
	for _, weapon in ipairs(weapon_list) do
		weapon_hash_to_weapon[int_to_uint(weapon.hash)] = weapon
	end
end
weapon = {
	give_delayed_weapon_to_ped = WEAPON.GIVE_DELAYED_WEAPON_TO_PED,
	get_weapon_tint_count = WEAPON.GET_WEAPON_TINT_COUNT,
	get_ped_weapon_tint_index = WEAPON.GET_PED_WEAPON_TINT_INDEX,
	set_ped_weapon_tint_index = WEAPON.SET_PED_WEAPON_TINT_INDEX,
	give_weapon_component_to_ped = WEAPON.GIVE_WEAPON_COMPONENT_TO_PED,
	remove_all_ped_weapons = WEAPON.REMOVE_ALL_PED_WEAPONS,
	remove_weapon_from_ped = WEAPON.REMOVE_WEAPON_FROM_PED,
	get_max_ammo = WEAPON.GET_MAX_AMMO,
	set_ped_ammo = WEAPON.SET_PED_AMMO,
	remove_weapon_component_from_ped = WEAPON.REMOVE_WEAPON_COMPONENT_FROM_PED,
	has_ped_got_weapon_component = WEAPON.HAS_PED_GOT_WEAPON_COMPONENT,
	get_ped_ammo_type_from_weapon = WEAPON.GET_PED_AMMO_TYPE_FROM_WEAPON,
	set_ped_ammo_by_type = WEAPON.SET_PED_AMMO_BY_TYPE,
	has_ped_got_weapon = WEAPON.HAS_PED_GOT_WEAPON,
	get_all_weapon_hashes = function ()
		if not weapon_list then weapon_list = util.get_weapons() end
		local result = {}
		for _, weapon in ipairs(weapon_list) do
			result[#result+1] = weapon.hash
		end
		return result
	end,
	get_weapon_name = function (hash)
		if not weapon_hash_to_weapon then
			populate_hash_to_weapon_table()
		end

		if not hash then return "invalid weapon" end

		local weapon = weapon_hash_to_weapon[hash]

		if weapon then
			return util.get_label_text(weapon_hash_to_weapon[hash].label_key)
		else
			return "invalid weapon"
		end

	end,
	get_weapon_weapon_wheel_slot = notif_not_imp,
	get_weapon_model = WEAPON.GET_WEAPONTYPE_MODEL,
	get_weapon_audio_item = notif_not_imp,
	get_weapon_slot = WEAPON.GET_WEAPONTYPE_SLOT,
	get_weapon_ammo_type = function (hash)
		return WEAPON.GET_PED_AMMO_TYPE_FROM_WEAPON(PLAYER.PLAYER_PED_ID(), hash)
	end,
	get_weapon_weapon_group = WEAPON.GET_WEAPONTYPE_GROUP,
	get_weapon_weapon_type = notif_not_imp,
	get_weapon_pickup = notif_not_imp
}

fire = {
	add_explosion = function (pos, type, isAudible, isInvis, fCamShake, owner)
		FIRE.ADD_EXPLOSION(pos.x, pos.y ,pos.z, type, isAudible, isInvis, fCamShake, owner)
	end,
    start_entity_fire = FIRE.START_ENTITY_FIRE,
    stop_entity_fire = FIRE.STOP_ENTITY_FIRE
}

cutscene = {
	stop_cutscene_immediately = CUTSCENE.STOP_CUTSCENE_IMMEDIATELY,
	remove_cutscene = CUTSCENE.REMOVE_CUTSCENE,
	is_cutscene_active = CUTSCENE.IS_CUTSCENE_ACTIVE,
	is_cutscene_playing = CUTSCENE.IS_CUTSCENE_PLAYING
}

vehicle = {
	set_vehicle_reduce_grip = VEHICLE.SET_VEHICLE_REDUCE_GRIP,
	set_vehicle_steer_bias = VEHICLE.SET_VEHICLE_STEER_BIAS,
	set_vehicle_tire_smoke_color = VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR,
	get_ped_in_vehicle_seat = VEHICLE.GET_PED_IN_VEHICLE_SEAT,
	get_free_seat = function (veh)
		local seat_count = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(ENTITY.GET_ENTITY_MODEL(veh))
		for i = -1, seat_count - 2, 1 do
			if VEHICLE.IS_VEHICLE_SEAT_FREE(veh, i, true) then
				return i
			end
		end
	end,
	is_vehicle_full = function (veh)
		return not VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(veh)
	end,
	set_vehicle_stolen = VEHICLE.SET_VEHICLE_IS_STOLEN,
	set_vehicle_color = VEHICLE.SET_VEHICLE_COLOURS,
	get_mod_text_label = VEHICLE.GET_MOD_TEXT_LABEL,
	get_mod_slot_name = VEHICLE.GET_MOD_SLOT_NAME,
	get_num_vehicle_mods = VEHICLE.GET_NUM_VEHICLE_MODS,
	set_vehicle_mod = VEHICLE.SET_VEHICLE_MOD,
	get_vehicle_mod = VEHICLE.GET_VEHICLE_MOD,
	set_vehicle_mod_kit_type = VEHICLE.SET_VEHICLE_MOD_KIT,
	set_vehicle_extra = VEHICLE.SET_VEHICLE_EXTRA,
	does_extra_exist = VEHICLE.DOES_EXTRA_EXIST,
	is_vehicle_extra_turned_on = VEHICLE.IS_VEHICLE_EXTRA_TURNED_ON,
	toggle_vehicle_mod = VEHICLE.TOGGLE_VEHICLE_MOD,
	set_vehicle_bulletproof_tires = VEHICLE.SET_VEHICLE_TYRES_CAN_BURST,
	is_vehicle_a_convertible = VEHICLE.IS_VEHICLE_A_CONVERTIBLE,
	get_convertible_roof_state = VEHICLE.GET_CONVERTIBLE_ROOF_STATE,
	set_convertible_roof = VEHICLE.SET_CONVERTIBLE_ROOF,
	set_vehicle_indicator_lights = VEHICLE.SET_VEHICLE_INDICATOR_LIGHTS,
	set_vehicle_brake_lights = VEHICLE.SET_VEHICLE_BRAKE_LIGHTS,
	set_vehicle_can_be_visibly_damaged = VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED,
	set_vehicle_engine_on = VEHICLE.SET_VEHICLE_ENGINE_ON,
	set_vehicle_fixed = VEHICLE.SET_VEHICLE_FIXED,
	set_vehicle_deformation_fixed = VEHICLE.SET_VEHICLE_DEFORMATION_FIXED,
	set_vehicle_undriveable = VEHICLE.SET_VEHICLE_UNDRIVEABLE,
	set_vehicle_on_ground_properly = VEHICLE.SET_VEHICLE_ON_GROUND_PROPERLY,
	set_vehicle_forward_speed = VEHICLE.SET_VEHICLE_FORWARD_SPEED,
	set_vehicle_number_plate_text = VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT,
	set_vehicle_door_open = VEHICLE.SET_VEHICLE_DOOR_OPEN,
	set_vehicle_doors_shut = VEHICLE.SET_VEHICLE_DOORS_SHUT,
	is_toggle_mod_on = VEHICLE.IS_TOGGLE_MOD_ON,
	set_vehicle_wheel_type = VEHICLE.SET_VEHICLE_WHEEL_TYPE,
	set_vehicle_number_plate_index = VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX,
	set_vehicle_tires_can_burst = VEHICLE.SET_VEHICLE_TYRES_CAN_BURST,
	set_vehicle_tire_burst = VEHICLE.SET_VEHICLE_TYRE_BURST,
	get_num_vehicle_mod = VEHICLE.GET_VEHICLE_MOD,
	is_vehicle_engine_running = VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING,
	set_vehicle_engine_health = VEHICLE.SET_VEHICLE_ENGINE_HEALTH,
	is_vehicle_damaged = function (veh)
		return VEHICLE.GET_ENTITY_MAX_HEALTH(veh) > VEHICLE.GET_ENTITY_HEALTH(veh)
	end,
	is_vehicle_on_all_wheels = VEHICLE.IS_VEHICLE_ON_ALL_WHEELS,
	create_vehicle = function (hash, pos, heading, networked, alwaysFalse)
		local veh = entities.create_vehicle(hash, pos, heading)
		ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(veh, true)
		return veh
	end,
	set_vehicle_doors_locked = VEHICLE.SET_VEHICLE_DOORS_LOCKED,
	set_vehicle_neon_lights_color = function (veh, colour)
		c = IntToRGBA(colour)
		VEHICLE._SET_VEHICLE_NEON_LIGHTS_COLOUR(veh, c.r, c.g, c.b)
	end,
	get_vehicle_neon_lights_color = function (veh)
		local colour_ptr = memory.alloc(12)
		VEHICLE._GET_VEHICLE_NEON_LIGHTS_COLOUR(veh, colour_ptr, colour_ptr + 4, colour_ptr + 8)
		local colour = RGBAToInt(memory.read_byte(colour_ptr), memory.read_byte(colour_ptr + 4), memory.read_byte(colour_ptr + 8), 255)
		return colour
	end,
	set_vehicle_neon_light_enabled = VEHICLE._SET_VEHICLE_NEON_LIGHT_ENABLED,
	is_vehicle_neon_light_enabled = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED,
	set_vehicle_density_multipliers_this_frame = VEHICLE.SET_VEHICLE_DENSITY_MULTIPLIER_THIS_FRAME,
	set_random_vehicle_density_multiplier_this_frame = VEHICLE.SET_RANDOM_VEHICLE_DENSITY_MULTIPLIER_THIS_FRAME,
	set_parked_vehicle_density_multiplier_this_frame = VEHICLE.SET_PARKED_VEHICLE_DENSITY_MULTIPLIER_THIS_FRAME,
	set_ambient_vehicle_range_multiplier_this_frame = VEHICLE.SET_AMBIENT_VEHICLE_RANGE_MULTIPLIER_THIS_FRAME,
	is_vehicle_rocket_boost_active = VEHICLE._IS_VEHICLE_ROCKET_BOOST_ACTIVE,
	set_vehicle_rocket_boost_active = VEHICLE._SET_VEHICLE_ROCKET_BOOST_ACTIVE,
	set_vehicle_rocket_boost_percentage = VEHICLE._SET_VEHICLE_ROCKET_BOOST_PERCENTAGE,
	set_vehicle_rocket_boost_refill_time = VEHICLE._SET_VEHICLE_ROCKET_BOOST_REFILL_TIME,
	control_landing_gear = VEHICLE.CONTROL_LANDING_GEAR,
	get_landing_gear_state = VEHICLE.GET_LANDING_GEAR_STATE,
	get_vehicle_livery = VEHICLE.GET_VEHICLE_LIVERY,
	set_vehicle_livery = VEHICLE.SET_VEHICLE_LIVERY,
	is_vehicle_stopped = VEHICLE.IS_VEHICLE_STOPPED,
	get_vehicle_number_of_passengers = VEHICLE.GET_VEHICLE_NUMBER_OF_PASSENGERS,
	get_vehicle_max_number_of_passengers = VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS,
	get_vehicle_model_number_of_seats = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS,
	get_vehicle_livery_count = VEHICLE.GET_VEHICLE_LIVERY_COUNT,
	get_vehicle_roof_livery_count = VEHICLE._GET_VEHICLE_ROOF_LIVERY_COUNT,
	is_vehicle_model = VEHICLE.IS_VEHICLE_MODEL,
	is_vehicle_stuck_on_roof = VEHICLE.IS_VEHICLE_STUCK_ON_ROOF,
	set_vehicle_doors_locked_for_player = VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER,
	get_vehicle_doors_locked_for_player = VEHICLE.GET_VEHICLE_DOORS_LOCKED_FOR_PLAYER,
	set_vehicle_doors_locked_for_all_players = VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS,
	set_vehicle_doors_locked_for_non_script_players = VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_NON_SCRIPT_PLAYERS,
	set_vehicle_doors_locked_for_team = VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_TEAM,
	explode_vehicle = VEHICLE.EXPLODE_VEHICLE,
	set_vehicle_out_of_control = VEHICLE.SET_VEHICLE_OUT_OF_CONTROL,
	set_vehicle_timed_explosion = VEHICLE.SET_VEHICLE_TIMED_EXPLOSION,
	add_vehicle_phone_explosive_device = VEHICLE.ADD_VEHICLE_PHONE_EXPLOSIVE_DEVICE,
	has_vehicle_phone_explosive_device = VEHICLE.HAS_VEHICLE_PHONE_EXPLOSIVE_DEVICE,
	detonate_vehicle_phone_explosive_device = VEHICLE.DETONATE_VEHICLE_PHONE_EXPLOSIVE_DEVICE,
	set_taxi_lights = VEHICLE.SET_TAXI_LIGHTS,
	is_taxi_light_on = VEHICLE.IS_TAXI_LIGHT_ON,
	set_vehicle_colors = VEHICLE.SET_VEHICLE_COLOURS,
	set_vehicle_extra_colors = VEHICLE.SET_VEHICLE_EXTRA_COLOURS,
	get_vehicle_primary_color = function (veh)
		local a, b = memory.alloc_int(), memory.alloc_int()
		VEHICLE.GET_VEHICLE_COLOURS(veh, a, b)
		local colour = memory.read_int(a)
		return colour
	end,
	get_vehicle_secondary_color = function (veh)
		local a, b = memory.alloc_int(), memory.alloc_int()
		VEHICLE.GET_VEHICLE_COLOURS(veh, a, b)
		local colour = memory.read_int(b)
		return colour
	end,
	get_vehicle_pearlecent_color = function (veh)
		return entities.vehicle_draw_handler_get_pearlecent_colour(entities.get_draw_handler(veh))
	end,
	get_vehicle_wheel_color = function (veh)
		return entities.vehicle_draw_handler_get_wheel_colour(entities.get_draw_handler(veh))
	end,
	set_vehicle_fullbeam = VEHICLE.SET_VEHICLE_FULLBEAM,
	set_vehicle_custom_primary_colour = VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR,
	get_vehicle_custom_primary_colour = VEHICLE.GET_VEHICLE_CUSTOM_PRIMARY_COLOUR,
	clear_vehicle_custom_primary_colour = VEHICLE.CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR,
	is_vehicle_primary_colour_custom = VEHICLE.GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM,
	set_vehicle_custom_secondary_colour = VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR,
	get_vehicle_custom_secondary_colour = VEHICLE.GET_VEHICLE_CUSTOM_SECONDARY_COLOUR,
	clear_vehicle_custom_secondary_colour = VEHICLE.CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR,
	is_vehicle_secondary_colour_custom = VEHICLE.GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM,
	set_vehicle_custom_pearlescent_colour = notif_not_imp,
	get_vehicle_custom_pearlescent_colour = notif_not_imp,
	set_vehicle_custom_wheel_colour = notif_not_imp,
	get_vehicle_custom_wheel_colour = notif_not_imp,
	get_livery_name = VEHICLE.GET_LIVERY_NAME,
	set_vehicle_window_tint = VEHICLE.SET_VEHICLE_WINDOW_TINT,
	get_vehicle_window_tint = VEHICLE.GET_VEHICLE_WINDOW_TINT,
	get_all_vehicle_model_hashes = function ()
		local t = {}
		local v = util.get_vehicles()
		for _, entry in pairs(v) do
			table.insert(t, int_to_uint(util.joaat(entry.name)))
		end
		return t
	end,
	get_all_vehicles = entities.get_all_vehicles_as_handles,
	modify_vehicle_top_speed = VEHICLE.MODIFY_VEHICLE_TOP_SPEED,
	set_vehicle_engine_torque_multiplier_this_frame = VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE,
	get_vehicle_headlight_color = VEHICLE._GET_VEHICLE_XENON_LIGHTS_COLOR,
	set_vehicle_headlight_color = VEHICLE._SET_VEHICLE_XENON_LIGHTS_COLOR,
	set_heli_blades_full_speed = VEHICLE.SET_HELI_BLADES_FULL_SPEED,
	set_heli_blades_speed = VEHICLE.SET_HELI_BLADES_SPEED,
	set_vehicle_parachute_active = VEHICLE._SET_VEHICLE_PARACHUTE_ACTIVE,
	does_vehicle_have_parachute = VEHICLE._GET_VEHICLE_HAS_PARACHUTE,
	can_vehicle_parachute_be_activated = VEHICLE._GET_VEHICLE_CAN_ACTIVATE_PARACHUTE,
	set_vehicle_can_be_locked_on = VEHICLE._SET_VEHICLE_CAN_BE_LOCKED_ON,
	get_vehicle_current_gear =  function (veh)
		return entities.get_current_gear(entities.handle_to_pointer(veh))
	end,
	set_vehicle_current_gear = function (veh, gear)
		entities.set_current_gear(entities.handle_to_pointer(veh), gear)
	end,
	get_vehicle_next_gear = function (veh)
		return entities.get_next_gear(entities.handle_to_pointer(veh))
	end,
	set_vehicle_next_gear = function (veh, gear)
		entities.set_next_gear(entities.handle_to_pointer(veh), gear)
	end,
	--get_vehicle_max_gear = !#! NO MATCH FOUND !#!,
	--set_vehicle_max_gear = !#! NO MATCH FOUND !#!,
	--get_vehicle_gear_ratio = !#! NO MATCH FOUND !#!,
	--set_vehicle_gear_ratio = !#! NO MATCH FOUND !#!,
	get_vehicle_rpm = function (veh)
		return entities.get_rpm(entities.handle_to_pointer(veh))
	end,
	get_vehicle_has_been_owned_by_player = function (veh)
		return entities.get_vehicle_has_been_owned_by_player(entities.handle_to_pointer(veh))
	end,
	set_vehicle_has_been_owned_by_player = VEHICLE.SET_VEHICLE_HAS_BEEN_OWNED_BY_PLAYER,
	--get_vehicle_steer_bias = !#! NO MATCH FOUND !#!,
	--get_vehicle_reduce_grip = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_count = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_tire_radius = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_rim_radius = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_tire_width = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_rotation_speed = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_tire_radius = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_rim_radius = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_tire_width = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_rotation_speed = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_render_size = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_render_size = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_render_width = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_render_width = !#! NO MATCH FOUND !#!,
	set_vehicle_tire_fixed = VEHICLE.SET_VEHICLE_TYRE_FIXED,
	--get_vehicle_wheel_power = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_power = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_health = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_health = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_brake_pressure = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_brake_pressure = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_traction_vector_length = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_traction_vector_length = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_x_offset = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_x_offset = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_y_rotation = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_y_rotation = !#! NO MATCH FOUND !#!,
	--get_vehicle_wheel_flags = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_flags = !#! NO MATCH FOUND !#!,
	--set_vehicle_wheel_is_powered = !#! NO MATCH FOUND !#!,
	get_vehicle_class = VEHICLE.GET_VEHICLE_CLASS,
	get_vehicle_class_name = function (veh)
		local classes = {"Compacts",
						"Sedans",
						"SUVs",
						"Coupes",
						"Muscle",
						"Sports Classics",
						"Sports",
						"Super",
						"Motorcycles",
						"Off-road",
						"Industrial",
						"Utility",
						"Vans",
						"Cycles",
						"Boats",
						"Helicopters",
						"Planes",
						"Service",
						"Emergency",
						"Military",
						"Commercial",
						"Trains"}
		return classes[VEHICLE.GET_VEHICLE_CLASS(veh)]
	end,
	get_vehicle_brand = function(veh)
		return VEHICLE._GET_MAKE_NAME_FROM_VEHICLE_MODEL(ENTITY.GET_ENTITY_MODEL(veh))
	end,
	get_vehicle_model = function(veh)
		local str = util.reverse_joaat(ENTITY.GET_ENTITY_MODEL(veh))
		if str == "" then
			return nil
		end
		return str
	end,
	--get_vehicle_brand_label = !#! NO MATCH FOUND !#!,
	--get_vehicle_model_label = !#! NO MATCH FOUND !#!,
	start_vehicle_horn = VEHICLE.START_VEHICLE_HORN,
	set_vehicle_gravity_amount = function (veh, grav)
		entities.set_gravity(entities.handle_to_pointer(veh), grav)
	end,
	get_vehicle_gravity_amount = function (veh)
		return entities.get_gravity(entities.handle_to_pointer(veh))
	end
}

cutscene = {
	stop_cutscene_immediately = CUTSCENE.STOP_CUTSCENE_IMMEDIATELY,
	remove_cutscene = CUTSCENE.REMOVE_CUTSCENE,
	is_cutscene_active = CUTSCENE.IS_CUTSCENE_ACTIVE,
	is_cutscene_playing = CUTSCENE.IS_CUTSCENE_PLAYING
}

controls = {
	disable_control_action = PAD.DISABLE_CONTROL_ACTION,
	is_control_pressed = PAD.IS_CONTROL_PRESSED,
	is_control_just_pressed = PAD.IS_CONTROL_JUST_PRESSED,
	is_disabled_control_pressed = PAD.IS_DISABLED_CONTROL_PRESSED,
	is_disabled_control_just_pressed = PAD.IS_DISABLED_CONTROL_JUST_PRESSED,
	get_control_normal = PAD.GET_CONTROL_NORMAL,
	set_control_normal = PAD._SET_CONTROL_NORMAL
}

rope = {
	rope_load_textures = PHYSICS.ROPE_LOAD_TEXTURES,
	rope_unload_textures = PHYSICS.ROPE_UNLOAD_TEXTURES,
	rope_are_textures_loaded = PHYSICS.ROPE_ARE_TEXTURES_LOADED,
	add_rope = function (pos, rot, maxLen, ropeType, initLength, minLength, lengthChangeRate, onlyPPU, collisionOn, lockFromFront, timeMultiplier, breakable)
		return PHYSICS.ADD_ROPE(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, initLength, ropeType, maxLen, minLength, lengthChangeRate, onlyPPU, collisionOn, lockFromFront, timeMultiplier, breakable, 0)
	end,
	does_rope_exist = PHYSICS.DOES_ROPE_EXIST,
	delete_rope = function (rope)
		local rope_ptr = memory.alloc_int()
		memory.write_int(rope_ptr, rope)
		PHYSICS.DELETE_ROPE(rope_ptr)
	end,
	attach_rope_to_entity = function (rope, e, offset, a3)
		PHYSICS.ATTACH_ROPE_TO_ENTITY(rope, e, offset.x, offset.y, offset.z, a3)
	end,
	attach_entities_to_rope = function (rope, ent1, ent2, pos_ent1, pos_ent2, len, a7, a8, boneName1, boneName2)
		PHYSICS.ATTACH_ENTITIES_TO_ROPE(rope, ent1, ent2, pos_ent1.x, pos_ent1.y, pos_ent1.z, pos_ent2.x, pos_ent2.y, pos_ent2.z, len, a7, a8, 0, 0)
	end,
	detach_rope_from_entity = PHYSICS.DETACH_ROPE_FROM_ENTITY,
	start_rope_unwinding_front = PHYSICS.START_ROPE_UNWINDING_FRONT,
	start_rope_winding = PHYSICS.START_ROPE_WINDING,
	stop_rope_unwinding_front = PHYSICS.STOP_ROPE_UNWINDING_FRONT,
	stop_rope_winding = PHYSICS.STOP_ROPE_WINDING,
	rope_force_length = PHYSICS.ROPE_FORCE_LENGTH,
	activate_physics = PHYSICS.ACTIVATE_PHYSICS,
}

system = {
	yield = util.yield,
	wait = util.yield
}

local event_types = {
	exit = util.on_stop
}

event = {
	add_event_listener = function (name, callback)
		local event = event_types[name]
		if event then event(callback) end
	end,
	remove_event_listener = function ()
		return false
	end
}

graphics = {
	get_screen_height = function ()
		local _, y = directx.get_client_size()
		return y
	end,
	get_screen_width = directx.get_client_size,
	request_named_ptfx_asset = STREAMING.REQUEST_NAMED_PTFX_ASSET,
	has_named_ptfx_asset_loaded = STREAMING.HAS_NAMED_PTFX_ASSET_LOADED,
	remove_named_ptfx_asset = STREAMING.REMOVE_NAMED_PTFX_ASSET,
	set_next_ptfx_asset = GRAPHICS.USE_PARTICLE_FX_ASSET,
	set_next_ptfx_asset_by_hash = util.use_particle_fx_asset,
	start_ptfx_looped_on_entity = function (name, ent, offset, rot, scale)
		GRAPHICS.START_PARTICLE_FX_LOOPED_ON_ENTITY(name, ent, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
	end,
	start_ptfx_non_looped_on_entity = function (name, ent, offset, rot, scale)
		GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY(name, ent, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
	end,
	start_networked_ptfx_looped_on_entity = function (name, ent, offset, rot, scale)
		GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY(name, ent, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
	end,
	start_networked_ptfx_non_looped_on_entity = function (name, ent, offset, rot, scale)
		GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(name, ent, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
	end,
	remove_ptfx_from_entity = GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY,
	does_looped_ptfx_exist = GRAPHICS.DOES_PARTICLE_FX_LOOPED_EXIST,
	start_ptfx_looped_at_coord = function (name, pos, rot, scale, xAxis, yAxis, zAxis)
		GRAPHICS.START_PARTICLE_FX_LOOPED_AT_COORD(name, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, xAxis, yAxis, zAxis)
	end,
	start_ptfx_non_looped_at_coord = function (name, pos, rot, scale, xAxis, yAxis, zAxis)
		GRAPHICS.START_PARTICLE_FX_NON_LOOPED_AT_COORD(name, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, xAxis, yAxis, zAxis)
	end,
	start_networked_ptfx_non_looped_at_coord = function (name, pos, rot, scale, xAxis, yAxis, zAxis)
		GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(name, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, xAxis, yAxis, zAxis)
	end,
	start_networked_ptfx_looped_at_coord = notif_not_imp,
	remove_particle_fx = GRAPHICS.REMOVE_PARTICLE_FX,
	remove_ptfx_in_range = function (pos, range)
		GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(pos.x, pos.y, pos.z, range)
	end,
	set_ptfx_looped_offsets = function (ptfx, pos, rot)
		GRAPHICS.SET_PARTICLE_FX_LOOPED_OFFSETS(ptfx, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z)
	end,
	set_ptfx_looped_evolution = GRAPHICS.SET_PARTICLE_FX_LOOPED_EVOLUTION,
	set_ptfx_looped_color = GRAPHICS.SET_PARTICLE_FX_LOOPED_COLOUR,
	set_ptfx_looped_alpha = GRAPHICS.SET_PARTICLE_FX_LOOPED_ALPHA,
	set_ptfx_looped_scale = GRAPHICS.SET_PARTICLE_FX_LOOPED_SCALE,
	set_ptfx_looped_far_clip_dist = GRAPHICS.SET_PARTICLE_FX_LOOPED_FAR_CLIP_DIST,
	enable_clown_blood_vfx = GRAPHICS.ENABLE_CLOWN_BLOOD_VFX,
	enable_alien_blood_vfx = GRAPHICS.ENABLE_ALIEN_BLOOD_VFX,
	animpostfx_play = GRAPHICS.ANIMPOSTFX_PLAY,
	animpostfx_stop = GRAPHICS.ANIMPOSTFX_STOP,
	animpostfx_is_running = GRAPHICS.ANIMPOSTFX_IS_RUNNING,
	animpostfx_stop_all = GRAPHICS.ANIMPOSTFX_STOP_ALL,
	request_scaleform_movie = GRAPHICS.REQUEST_SCALEFORM_MOVIE,
	begin_scaleform_movie_method = GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD,
	scaleform_movie_method_add_param_texture_name_string = GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING,
	scaleform_movie_method_add_param_int = GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT,
	scaleform_movie_method_add_param_float = GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT,
	scaleform_movie_method_add_param_bool = GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL,
	draw_scaleform_movie_fullscreen = GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN,
	draw_scaleform_movie = GRAPHICS.DRAW_SCALEFORM_MOVIE,
	end_scaleform_movie_method = GRAPHICS.END_SCALEFORM_MOVIE_METHOD,
	draw_marker = function (type, pos, dir, rot, scale, red, green, blue, alpha, bobUpAndDown, faceCam, a12, rotate, textureDict, textureName, drawOntEnts)
		GRAPHICS.DRAW_MARKER(type, pos.x, pos.y, pos.z, dir.x, dir.y, dir.z, rot.x, rot.y, rot.z, scale.x, scale.y, scale.z, red, green, blue, alpha, bobUpAndDown, faceCam, a12, rotate, textureDict or 0, textureName or 0, drawOntEnts)
	end,
	create_checkpoint = function (type, thisPos, nextPos, radius, red, green, blue, alpha, reserved)
		return	GRAPHICS.CREATE_CHECKPOINT(type, thisPos.x, thisPos.y, thisPos.z, nextPos.x, nextPos.y, nextPos.z, radius, red, green, blue, alpha, reserved)
	end,
	set_checkpoint_icon_height = GRAPHICS._SET_CHECKPOINT_ICON_SCALE,
	set_checkpoint_cylinder_height = GRAPHICS.SET_CHECKPOINT_CYLINDER_HEIGHT,
	set_checkpoint_rgba = GRAPHICS.SET_CHECKPOINT_RGBA,
	set_checkpoint_icon_rgba = 	GRAPHICS.SET_CHECKPOINT_RGBA2,
	delete_checkpoint = GRAPHICS.DELETE_CHECKPOINT,
	has_scaleform_movie_loaded = GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED,
	set_scaleform_movie_as_no_longer_needed = function(h)
		local pH = memory.alloc_int()
		memory.write_int(pH, h)
		GRAPHICS.SET_SCALEFORM_MOVIE_AS_NO_LONGER_NEEDED(pH)
	end,
	project_3d_coord = function (coord)
		local x_ptr, y_ptr = memory.alloc_int(), memory.alloc_int()
		local status = GRAPHICS.GET_SCREEN_COORD_FROM_WORLD_COORD(coord.x, coord.y, coord.z, x_ptr, y_ptr)
		local x, y = memory.read_float(x_ptr), memory.read_float(y_ptr)
		return status, v2(x, y)
	end,
	}

cam = {
		get_gameplay_cam_rot = function() 
			return CAM.GET_FINAL_RENDERED_CAM_COORD(2)
		end,
		get_gameplay_cam_pos = CAM.GET_GAMEPLAY_CAM_COORD,
		get_gameplay_cam_relative_pitch = CAM.GET_GAMEPLAY_CAM_RELATIVE_PITCH,
		get_gameplay_cam_relative_yaw = CAM.GET_GAMEPLAY_CAM_RELATIVE_HEADING
	}

	gameplay = {
		get_hash_key = util.joaat,
		display_onscreen_keyboard = MISC.DISPLAY_ONSCREEN_KEYBOARD,
		update_onscreen_keyboard = MISC.UPDATE_ONSCREEN_KEYBOARD,
		get_onscreen_keyboard_result = MISC.GET_ONSCREEN_KEYBOARD_RESULT,
		is_onscreen_keyboard_active = function ()
			return MISC.UPDATE_ONSCREEN_KEYBOARD() ~= -1
		end,
		set_override_weather = MISC.SET_OVERRIDE_WEATHER,
		clear_override_weather = MISC.CLEAR_OVERRIDE_WEATHER,
		set_blackout = GRAPHICS.SET_ARTIFICIAL_LIGHTS_STATE,
		set_mobile_radio = AUDIO.SET_MOBILE_RADIO_ENABLED_DURING_GAMEPLAY,
		get_game_state = function()
			return entities.player_info_get_game_state(entities.get_player_info(entities.handle_to_pointer(players.user_ped())))
		end,
		is_game_state = function(state)
			return gameplay.get_game_state() == state
		end,
		clear_area_of_objects = function (vec, radius, flags)
			MISC.CLEAR_AREA_OF_OBJECTS(vec.x, vec.y, vec.z, radius, flags)
		end,
		clear_area_of_vehicles = function (coord, radius, a3, a4, a5, a6, a7)
			MISC.CLEAR_AREA_OF_VEHICLES(coord.x, coord.y, coord.z, radius, a3, a4, a5, a6, a7)
		end,
		clear_area_of_peds = function (vec, radius, flags)
			MISC.CLEAR_AREA_OF_PEDS(vec.x, vec.y, vec.z, radius, flags)
		end,
		clear_area_of_cops = function (vec, radius, flags)
			MISC.CLEAR_AREA_OF_COPS(vec.x, vec.y, vec.z, radius, flags)
		end,
		set_cloud_hat_opacity = MISC._SET_CLOUD_HAT_OPACITY,
		get_cloud_hat_opacity = MISC._GET_CLOUD_HAT_OPACITY,
		preload_cloud_hat = MISC.PRELOAD_CLOUD_HAT,
		clear_cloud_hat = MISC.UNLOAD_CLOUD_HAT,
		load_cloud_hat = MISC.LOAD_CLOUD_HAT,
		unload_cloud_hat = MISC.UNLOAD_CLOUD_HAT,
		get_ground_z = function (vec)
			return util.get_ground_z(vec.x, vec.y)
		end,
		get_frame_count = MISC.GET_FRAME_COUNT,
		get_frame_time = MISC.GET_FRAME_TIME,
		shoot_single_bullet_between_coords = function (start, end_point, damage, weapon, owner, audible, invisible, speed)
			MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(start.x, start.y, start.z, end_point.x, end_point.y, end_point.z, damage, weapon, owner, audible, invisible, speed)
		end,
		find_spawn_point_in_direction = function (pos, fwd, dist)
			local vec_ptr = vec3.new()
			local status MISC.FIND_SPAWN_POINT_IN_DIRECTION(pos.x, pos.y, pos.z, fwd.x, fwd.y, fwd.z, dist, vec_ptr)
			local vec = v3(vec3.getX(vec_ptr), vec3.getY(vec_ptr), vec3.getZ(vec_ptr))
			return status, vec
		end
	}

streaming = {
	request_model = STREAMING.REQUEST_MODEL,
	has_model_loaded = STREAMING.HAS_MODEL_LOADED,
	set_model_as_no_longer_needed = STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED,
	is_model_in_cdimage = STREAMING.IS_MODEL_IN_CDIMAGE,
	is_model_valid = STREAMING.IS_MODEL_VALID,
	is_model_a_plane = VEHICLE.IS_THIS_MODEL_A_PLANE,
	is_model_a_vehicle = STREAMING.IS_MODEL_A_VEHICLE,
	is_model_a_heli = VEHICLE.IS_THIS_MODEL_A_HELI,
	request_ipl = STREAMING.REQUEST_IPL,
	remove_ipl = STREAMING.REMOVE_IPL,
	request_anim_set = STREAMING.REQUEST_ANIM_SET,
	has_anim_set_loaded = STREAMING.HAS_ANIM_SET_LOADED,
	request_anim_dict = STREAMING.REQUEST_ANIM_DICT,
	has_anim_dict_loaded = STREAMING.HAS_ANIM_DICT_LOADED,
	is_model_a_bike = VEHICLE.IS_THIS_MODEL_A_BIKE,
	is_model_a_car = VEHICLE.IS_THIS_MODEL_A_CAR,
	is_model_a_bicycle = VEHICLE.IS_THIS_MODEL_A_BICYCLE,
	is_model_a_quad = VEHICLE.IS_THIS_MODEL_A_QUADBIKE,
	is_model_a_boat = VEHICLE.IS_THIS_MODEL_A_BOAT,
	is_model_a_train = VEHICLE.IS_THIS_MODEL_A_TRAIN,
	is_model_an_object = util.is_this_model_an_object,
	is_model_a_world_object = function(hash) return false end,
	is_model_a_ped = STREAMING.IS_MODEL_A_PED,
	remove_anim_dict = STREAMING.REMOVE_ANIM_DICT,
	remove_anim_set = STREAMING.REMOVE_ANIM_SET
}

audio = {
	play_sound = AUDIO.PLAY_SOUND,
	play_sound_frontend = AUDIO.PLAY_SOUND_FRONTEND,
	play_sound_from_entity = AUDIO.PLAY_SOUND_FROM_ENTITY,
	play_sound_from_coord = function (soundId, audioName, pos, audioRef, isNetwork, range, p8)
		AUDIO.PLAY_SOUND_FROM_COORD(soundId, audioName, pos.x, pos.y, pos.z, audioRef, isNetwork, range, p8)
	end,
	stop_sound = AUDIO.STOP_SOUND
}

ai = {
	task_goto_entity = function (e, target, duration, distance, speed)
		TASK.TASK_GOTO_ENTITY_OFFSET(e, target, -1, 0, 0, 0, duration)
	end,
	task_combat_ped = TASK.TASK_COMBAT_PED,
	task_go_to_coord_by_any_means = function (ped, coords, speed, p4, p5, walkStyle, a7)
		TASK.TASK_GO_TO_COORD_ANY_MEANS(ped, coords.x, coords.y, coords.z, speed, p4, p5, walkStyle, a7)
	end,
	task_wander_standard = TASK.TASK_WANDER_STANDARD,
	task_vehicle_drive_wander = TASK.TASK_VEHICLE_DRIVE_WANDER,
	task_start_scenario_in_place = TASK.TASK_START_SCENARIO_IN_PLACE,
	task_start_scenario_at_position = function (ped, name, coord, heading, duration, sittingScenario, teleport)
		TASK.TASK_START_SCENARIO_AT_POSITION(ped, name, coord.x, coord.y, coord.z, heading, duration, sittingScenario, teleport)
	end,
	task_stand_guard = function (ped, coord, heading, name)
		TASK.TASK_STAND_GUARD(ped, coord.x, coord.y, coord.z, heading, name)
	end,
	play_anim_on_running_scenario = TASK.PLAY_ANIM_ON_RUNNING_SCENARIO,
	does_scenario_group_exist = TASK.DOES_SCENARIO_GROUP_EXIST,
	is_scenario_group_enabled = TASK.IS_SCENARIO_GROUP_ENABLED,
	set_scenario_group_enabled = TASK.SET_SCENARIO_GROUP_ENABLED,
	reset_scenario_groups_enabled = TASK.RESET_SCENARIO_GROUPS_ENABLED,
	set_exclusive_scenario_group = TASK.SET_EXCLUSIVE_SCENARIO_GROUP,
	reset_exclusive_scenario_group = TASK.RESET_EXCLUSIVE_SCENARIO_GROUP,
	is_scenario_type_enabled = TASK.IS_SCENARIO_TYPE_ENABLED,
	set_scenario_type_enabled = TASK.SET_SCENARIO_TYPE_ENABLED,
	reset_scenario_types_enabled = TASK.RESET_SCENARIO_TYPES_ENABLED,
	is_ped_active_in_scenario = TASK.IS_PED_ACTIVE_IN_SCENARIO,
	task_follow_to_offset_of_entity = function (ped, entity, offset, speed, timeout, stopRange, persistFollowing)
		TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(ped, entity, offset.x, offset.y, offset.z, speed, timeout, stopRange, persistFollowing)
	end,
	task_vehicle_drive_to_coord_longrange = function (ped, vehicle, pos, speed, mode, stopRange)
		TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(ped, vehicle, pos.x ,pos.y, pos.z, speed, mode, stopRange)
	end,
	task_shoot_at_entity = TASK.TASK_SHOOT_AT_ENTITY,
	task_vehicle_escort = TASK.TASK_VEHICLE_ESCORT,
	task_vehicle_follow = TASK.TASK_VEHICLE_FOLLOW,
	task_vehicle_drive_to_coord = function (ped, vehicle, coord, speed, a5, vehicleModel, driveMode, stopRange, a9)
		TASK.TASK_VEHICLE_DRIVE_TO_COORD(ped, vehicle, coord.x, coord.y, coord.z, speed, a5, vehicleModel, driveMode, stopRange, a9)
	end,
	task_vehicle_shoot_at_coord = function (ped, coord, a3)
		TASK.TASK_VEHICLE_SHOOT_AT_COORD(ped, coord.x, coord.y, coord.z, a3)
	end,
	task_vehicle_shoot_at_ped = TASK.TASK_VEHICLE_SHOOT_AT_PED,
	task_vehicle_aim_at_coord = function (ped, coord)
		TASK.TASK_VEHICLE_AIM_AT_COORD(ped, coord.x, coord.y, coord.z)
	end,
	task_vehicle_aim_at_ped = TASK.TASK_VEHICLE_AIM_AT_PED,
	task_stay_in_cover = TASK.TASK_STAY_IN_COVER,
	task_go_to_coord_while_aiming_at_coord = function (ped, gotoCoord, aimCoord, moveSpeed, a5, a6, a7, a8, flags, a10, firingPattern)
		TASK.TASK_GO_TO_COORD_WHILE_AIMING_AT_COORD(ped, gotoCoord.x, gotoCoord.y, gotoCoord.z, aimCoord.x, aimCoord.y, aimCoord.z, moveSpeed, a5, a6, a7, a8, flags, a10, firingPattern)
	end,
	task_go_to_coord_while_aiming_at_entity = function (ped, gotoCoord, ent, moveSpeed, a5, a6, a7, a8, flags, a10, firingPattern)
		TASK.TASK_GO_TO_COORD_WHILE_AIMING_AT_ENTITY(ped, gotoCoord, ent, moveSpeed, a5, a6, a7, a8, flags, a10, firingPattern)
	end,
	task_go_to_entity_while_aiming_at_coord = function (ped, ent, aimCoord, moveSpeed, a5, a6, a7, a8, flags, a10, firingPattern)
		TASK.TASK_GO_TO_ENTITY_WHILE_AIMING_AT_COORD(ped, ent, aimCoord.x, aimCoord.y, aimCoord.z, moveSpeed, a5, a6, a7, a8, flags, firingPattern)
	end,
	task_go_to_entity_while_aiming_at_entity = TASK.TASK_GO_TO_ENTITY_WHILE_AIMING_AT_ENTITY,
	task_open_vehicle_door = TASK.TASK_OPEN_VEHICLE_DOOR,
	task_enter_vehicle = TASK.TASK_ENTER_VEHICLE,
	task_leave_vehicle = TASK.TASK_LEAVE_VEHICLE,
	task_sky_dive = TASK.TASK_SKY_DIVE,
	task_parachute = TASK.TASK_PARACHUTE,
	task_parachute_to_target = function (ped, coord)
		TASK.TASK_PARACHUTE_TO_TARGET(ped, coord.x, coord.y, coord.z)
	end,
	set_parachute_task_target = function (ped, coord)
		TASK.SET_PARACHUTE_TASK_TARGET(ped, coord.x, coord.y, coord.z)
	end,
	set_parachute_task_thrust = TASK.SET_PARACHUTE_TASK_THRUST,
	task_rappel_from_heli = TASK.TASK_RAPPEL_FROM_HELI,
	task_vehicle_chase = TASK.TASK_VEHICLE_CHASE,
	set_task_vehicle_chase_behaviour_flag = TASK.SET_TASK_VEHICLE_CHASE_BEHAVIOR_FLAG,
	set_task_vehicle_chase_ideal_persuit_distance = TASK.SET_TASK_VEHICLE_CHASE_IDEAL_PURSUIT_DISTANCE,
	task_shoot_gun_at_coord = function (ped, coord, duration, firingPattern)
		TASK.TASK_SHOOT_AT_COORD(ped, coord.x, coord.y, coord.z, duration, firingPattern)
	end,
	task_aim_gun_at_coord = function (ped, coord, time, a4, a5)
		TASK.TASK_AIM_GUN_AT_COORD(ped, coord.x, coord.y, coord.z, time , a4, a5)
	end,
	task_turn_ped_to_face_entity = TASK.TASK_TURN_PED_TO_FACE_ENTITY,
	task_aim_gun_at_entity = TASK.TASK_AIM_GUN_AT_ENTITY,
	is_task_active = TASK.GET_IS_TASK_ACTIVE,
	task_play_anim = TASK.TASK_PLAY_ANIM,
	stop_anim_task = TASK.STOP_ANIM_TASK,
}

decorator = {
	decor_register = DECORATOR.DECOR_REGISTER,
	decor_exists_on = DECORATOR.DECOR_EXIST_ON,
	decor_remove = DECORATOR.DECOR_REMOVE,
	decor_get_int = DECORATOR.DECOR_GET_INT,
	decor_set_int = DECORATOR.DECOR_SET_INT,
	decor_get_float = DECORATOR.DECOR_GET_FLOAT,
	decor_set_float = DECORATOR.DECOR_SET_FLOAT,
	decor_get_bool = DECORATOR.DECOR_GET_BOOL,
	decor_set_bool = DECORATOR.DECOR_SET_BOOL,
	decor_set_time = DECORATOR.DECOR_SET_TIME,
}

hook = { -- silently ignore all this shit because, guess what, stand comes with protections
	register_script_event_hook = function() end,
	register_net_event_hook = function() end,
	remove_script_event_hook = function() end,
	remove_net_event_hook = function() end,
}

native = {
	call = function(hash, ...)
		local args = { ... }
		native_invoker.begin_call()
		for _, arg in ipairs(args) do
			pluto_switch type(arg) do
				pluto_case "int":
				native_invoker.push_arg_int(arg)
				break

				pluto_case "number":
				local i, f = math.modf(arg)
				if f == 0 then
					native_invoker.push_arg_int(arg)
				else
					native_invoker.push_arg_float(arg)
				end
				break

				pluto_case "boolean":
				native_invoker.push_arg_bool(arg)
				break

				pluto_default:
				error("Unsupported argument for native.call: " .. type(arg) .. " " .. tostring(arg))
			end
		end
		native_invoker.end_call(string.format("%X", hash))
		return {
			__tointeger = native_invoker.get_return_value_int,
			__tonumber = native_invoker.get_return_value_float,
			__tostring = native_invoker.get_return_value_string,
			__tov3 = native_invoker.get_return_value_vector3,
		}
	end
}

web = {
	urlencode = function (str) return str end,
	urldecode = function (str) return str end,
	get = function () return 0, "" end
}

local fucky_meta = {
	__newindex=function ()
	end
}

setmetatable(menu, fucky_meta)
setmetatable(utils, fucky_meta)
setmetatable(input, fucky_meta)
setmetatable(ui, fucky_meta)
setmetatable(scriptdraw, fucky_meta)
setmetatable(player, fucky_meta)
setmetatable(ped, fucky_meta)
setmetatable(network, fucky_meta)
setmetatable(entity, fucky_meta)
setmetatable(object, fucky_meta)
setmetatable(weapon, fucky_meta)
setmetatable(vehicle, fucky_meta)
setmetatable(controls, fucky_meta)
setmetatable(system, fucky_meta)
setmetatable(event, fucky_meta)
setmetatable(graphics, fucky_meta)
setmetatable(gameplay, fucky_meta)
setmetatable(streaming, fucky_meta)
setmetatable(ai, fucky_meta)
setmetatable(cam, fucky_meta)
setmetatable(fire, fucky_meta)
setmetatable(hook, fucky_meta)
setmetatable(native, fucky_meta)
setmetatable(web, fucky_meta)

-- checked by 2take1script to make sure the script is loaded via 2take1
-- they might replace this check in a future version, in which case, feel free to use the files from the "From 2Take1Menu" folder in this repository
local og_tostring = tostring
tostring = function(v)
	if type(v) == "table" and #v == 0 then
		return "[]"
	end
	return og_tostring(v)
end

return config