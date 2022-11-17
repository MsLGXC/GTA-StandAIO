-- HornSongs
-- by Hexarobi
-- Install in `Stand/Lua Scripts`

local SCRIPT_NAME = "HornSongs"
local SCRIPT_VERSION = "1.2"
local SOURCE_URL = "https://github.com/hexarobi/stand-lua-hornsongs"
local AUTO_UPDATE_HOST = "raw.githubusercontent.com"
local AUTO_UPDATE_PATH = "/hexarobi/stand-lua-hornsongs/main/HornSongs.lua"

util.require_natives(1660775568)

local pitch_map = {
    rest = 0,
    C = 16,
    D = 17,
    E = 18,
    F = 19,
    G = 20,
    A = 21,
    B = 22,
    C2 = 23,
}

local rest = 0

local double = 2
local whole = 1
local half = 0.5
local quarter = 0.25
local eighth = 0.125
local sixteenth = 0.0625

local MOD_HORN = 14

local horn_on = false

local script_store_dir = filesystem.store_dir() .. SCRIPT_NAME .. '\\'
if not filesystem.is_dir(script_store_dir) then
    filesystem.mkdirs(script_store_dir)
end

local function join_path(parent, child)
    local sub = parent:sub(-1)
    if sub == "/" or sub == "\\" then
        return parent .. child
    else
        return parent .. "/" .. child
    end
end

---
--- Play Music
---

local function get_note(note)
    if type(note) ~= "table" then
        note = {pitch=note}
    end
    if type(note.pitch) ~= "number" then
        note.pitch = pitch_map[note.pitch]
    end
    if note.length == nil then
        note.length = quarter
    end
    return note
end

local function play_note(vehicle, song, note, index)
    note = get_note(note)
    local note_playtime = math.floor(song.beat_length * note.length)
    if note.pitch ~= rest then
        horn_on = true
        --VEHICLE.START_VEHICLE_HORN(vehicle, note_delay, util.joaat("HELDDOWN"), false)
    end
    util.yield(note_playtime)
    horn_on = false
    -- Que up pitch for next note
    if song.notes[index+1] ~= nil then
        local next_note = get_note(song.notes[index+1])
        if next_note.pitch ~= rest then
            VEHICLE.SET_VEHICLE_MOD(vehicle, MOD_HORN, next_note.pitch)
        end
    end
    util.yield(song.beat_length - note_playtime)
    end

local function play_song(song)
    song.beat_length = math.floor(60000 / song.bpm)
    if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), true) then
        util.toast("除非在车内，否则不能吹喇叭")
        return
    end
    local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    if vehicle then
        local original_horn = VEHICLE.GET_VEHICLE_MOD(vehicle, MOD_HORN)
        play_note(vehicle, song, rest, 0)
        for index, note in pairs(song.notes) do
            play_note(vehicle, song, note, index)
        end
        VEHICLE.SET_VEHICLE_MOD(vehicle, MOD_HORN, original_horn)
    end
end

---
--- Songs Menu
---

local songs_menu = menu.list(menu.my_root(), "播放歌曲")

local status, json = pcall(require, "json")
local function load_song_from_file(filepath)
    local file = io.open(filepath, "r")
    if file then
        local data = json.decode(file:read("*a"))
        if not data.target_version then
            util.toast("无效的歌曲文件格式。缺少target_version.")
            return nil
        end
        file:close()
        return data
    else
        error("无法读取文件 '" .. filepath .. "'")
    end
end

local function load_songs(directory)
    local loaded_songs = {}
    for _, filepath in ipairs(filesystem.list_files(directory)) do
        local _, filename, ext = string.match(filepath, "(.-)([^\\/]-%.?([^%.\\/]*))$")
        if not filesystem.is_dir(filepath) and ext == "horn" then
            table.insert(loaded_songs, load_song_from_file(filepath))
        end
    end
    return loaded_songs
end

local songs_dir = join_path(script_store_dir, "songs")
songs = load_songs(songs_dir)
for _, song in pairs(songs) do
    menu.action(songs_menu, "播放 "..song.name, {}, song.description .. "\nBPM: " .. song.bpm, function()
        play_song(song)
    end)
end

---
--- Script Meta
---

local script_meta_menu = menu.list(menu.my_root(), "脚本支持")

menu.divider(script_meta_menu, SCRIPT_NAME)
menu.readonly(script_meta_menu, "版本", SCRIPT_VERSION)
menu.hyperlink(script_meta_menu, "资源", SOURCE_URL, "在Github上查看源文件")

local version_file = join_path(script_store_dir, "版本.txt")

local function read_version_id()
    local f = io.open(version_file)
    if f then
        local version = f:read()
        f:close()
        return version
    end
end

local function write_version_id(version_id)
    local file = io.open(version_file, "wb")
    if file == nil then
        util.toast("保存版本ID时出错")
    end
    file:write(version_id)
    file:close()
end

local function replace_current_script(new_script)
    local file = io.open(filesystem.scripts_dir() .. SCRIPT_RELPATH, "wb")
    if file == nil then
        util.toast("脚本文件写入时出错")
    end
    file:write(new_script.."\n")
    file:close()
end

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

menu.action(script_meta_menu, "检查更新", {}, "尝试更新到最新版本", function()
    async_http.init(AUTO_UPDATE_HOST, AUTO_UPDATE_PATH, function(result, status_code, headers)
        if status_code == 304 then
            -- No update found
            return
        end
        if not result or result == "" then
            util.toast("没有更新.")
            return
        end
        -- Lua scripts should begin with a comment but other HTML responses will not
        if not string.starts(result, "--") then
            util.toast("发现无效的更新! 无法应用")
            util.toast(result)
            return
        end
        replace_current_script(result)
        if headers then
            for header_key, header_value in pairs(headers) do
                if header_key == "etag" then
                    write_version_id(header_value)
                end
            end
        end
        -- write_version_id('W/"f0e184e9746c341efd4be01c36825cdf28bb3036c4bc744f1dbbe11c3c3e3031"')
        util.toast("脚本已更新。 请重新启动.")
        util.stop_script()
    end, function()
        util.toast("脚本更新下载失败.")
    end)
    local cached_version_id = read_version_id()
    if cached_version_id then
        async_http.add_header("If-None-Match", cached_version_id)
    end
    async_http.dispatch()
end)

util.create_tick_handler(function()
    if horn_on then
        PAD._SET_CONTROL_NORMAL(0, 86, 1)
    end
    return true
end)
