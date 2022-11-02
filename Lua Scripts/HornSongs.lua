-- HornSongs
-- by Hexarobi
-- Install in `Stand/Lua Scripts`

local SCRIPT_VERSION = "1.5"
local SOURCE_URL = "https://github.com/hexarobi/stand-lua-hornsongs"
local RAW_SOURCE_URL = "https://raw.githubusercontent.com/hexarobi/stand-lua-hornsongs/main/HornSongs.lua"

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
        util.toast("Cannot play horn unless within a vehicle")
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

local songs_menu = menu.list(menu.my_root(), "Play Song")

local status, json = pcall(require, "json")
local function load_song_from_file(filepath)
    local file = io.open(filepath, "r")
    if file then
        local data = json.decode(file:read("*a"))
        if not data.target_version then
            util.toast("Invalid horn file format. Missing target_version.")
            return nil
        end
        file:close()
        return data
    else
        error("Could not read file '" .. filepath .. "'")
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
    menu.action(songs_menu, "Play "..song.name, {}, song.description .. "\nBPM: " .. song.bpm, function()
        play_song(song)
    end)
end

---
--- Script Meta
---

local script_meta_menu = menu.list(menu.my_root(), "Script Meta")

menu.divider(script_meta_menu, SCRIPT_NAME:gsub(".lua", ""))
menu.readonly(script_meta_menu, "Version", SCRIPT_VERSION)
menu.hyperlink(script_meta_menu, "Source", SOURCE_URL, "View source files on Github")

---
--- Auto Update
---

local function require_or_download(lib_name, download_source_host, download_source_path)
    local status, lib = pcall(require, lib_name)
    if (status) then return lib end
    async_http.init(download_source_host, download_source_path, function(result, headers, status_code)
        local error_prefix = "Error downloading "..lib_name..": "
        if status_code ~= 200 then util.toast(error_prefix..status_code) return false end
        if not result or result == "" then util.toast(error_prefix.."Found empty file.") return false end
        local file = io.open(filesystem.scripts_dir() .. "lib\\" .. lib_name .. ".lua", "wb")
        if file == nil then util.toast(error_prefix.."Could not open file for writing.") return false end
        file:write(result) file:close()
        util.toast("Successfully installed lib "..lib_name)
    end, function() util.toast("Error downloading "..lib_name..". Update failed to download.") end)
    async_http.dispatch()
    util.yield(3000)    -- Pause to let download finish before continuing
    require(lib_name)
end

require_or_download(
    "auto-updater",
    "raw.githubusercontent.com",
    "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua"
)

local auto_update_config = {
    source_url=RAW_SOURCE_URL,
    script_name=SCRIPT_NAME,
    script_relpath=SCRIPT_RELPATH,
}
-- Manually check for updates with a menu option
menu.action(script_meta_menu, "Check for Update", {}, "Attempt to update to latest version", function()
    auto_update(auto_update_config)
end)

-- Check for updates anytime the script is run
auto_update(auto_update_config)

util.create_tick_handler(function()
    if horn_on then
        PAD._SET_CONTROL_NORMAL(0, 86, 1)
    end
    return true
end)

