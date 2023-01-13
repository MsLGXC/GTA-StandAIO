-- Lua Translations API
-- Created by Jackz
-- File format: Empty lines and lines that start with # (only first two characters checked) are ignored.
-- Note: First character MUST be a # for auto download to work.
-- See the return { } table at bottom for public methods
-- See jackz_chat or jackz_vehicles for examples (jackz_vehicles: line 73)

-- If you wish to view example lua scripts for my libs:
-- https://jackz.me/stand/get-lib-zip

local LIB_VERSION = "1.3.3"
local translations = {}
local translationAvailable = false
local autodownload = {
    active = false,
    domain = nil,
    uri = nil
}

local GAME_LANGUAGE_IDS = {
    ["en"] = "en-US",
    ["fr"] = "fr-FR",
    ["de"] = "de-DE",
    ["it"] = "it-IT",
    ["es"] = "es-ES",
    ["pt"] = "pt-BR",
    ["pl"] = "pl-PL",
    ["ru"] = "ru-RU",
    ["ko"] = "ko-KR",
    ["zh"] = "zh-TW",
    ["ja"] = "ja-JP",
}
local LANGUAGE_NAMES = {
    ["en-US"] = "English",
    ["fr-FR"] = "French",
    ["de-DE"] = "German",
    ["it-IT"] = "Italian",
    ["es-ES"] = "Spanish",
    ["pt-BR"] = "Brazilian",
    ["pl-PL"] = "Polish",
    ["ru-RU"] = "Russian",
    ["ko-KR"] = "Korean",
    ["zh-TW"] = "Chinese (Traditional)",
    ["ja-JP"] = "Japanese",
    ["es-MX"] = "Spanish (Mexican)",
    ["zh-CN"] = "Chinese (Simplified)"
}
local activeLang = GAME_LANGUAGE_IDS["en"]
if GAME_LANGUAGE_IDS[lang.get_current()] then
    activeLang = GAME_LANGUAGE_IDS[lang.get_current()]
    util.log("lib/translations.lua: Using stand language '" .. activeLang .. '"')
else
    util.log("lib/translations.lua: Stand Language '" .. lang.get_current() .. "' not found, defaulting to en-US")
end
local HARDCODED_TRANSLATIONS = {
    ["en-US"] = {
        ["ERR_NO_TRANSLATION_FILE"] = "No language translation is available.",
        ["ERR_NO_TRANSLATION_FILE_LOADED"] = "Translation file was never loaded. Contact the developer of this script",
        ["ERR_AUTODL_FAIL"] = "Could not automatically download translation files.",
        ["ERR_INVALID_STORED_LANGUAGE"] = "Ignoring unknown preferred language, falling back to en-US",
        ["LANG_PREF_CHANGED"] = "Preferred language has been switched. Please restart scripts to use the selected language."
    }
}
-- Automatically tries to find a internal message in their language, falls back to en-US or even hardcoded string
local function get_internal_message(key)
    if HARDCODED_TRANSLATIONS[lang] and HARDCODED_TRANSLATIONS[lang][key] then
        return HARDCODED_TRANSLATIONS[lang][key]
    elseif HARDCODED_TRANSLATIONS["en-US"][key] then
        return HARDCODED_TRANSLATIONS["en-US"][key]
    else
        return "_NO_TRANSLATION_AVAILABLE_"
    end
end
local TRANSLATIONS_FOLDER = filesystem.resources_dir() .. "/Translations/"
filesystem.mkdirs(TRANSLATIONS_FOLDER)
-- Loaded a user's preferred language iso. Pretty legacy and probably can be axed
local PREF_FILE_PATH = TRANSLATIONS_FOLDER .. "Preferred Language.txt"
local prefFile = io.open(PREF_FILE_PATH, "r")
if prefFile ~= nil then
    local value = prefFile:read("*a")
    local valid = false
    for _, language in pairs(GAME_LANGUAGE_IDS) do
        if value == language then
            activeLang = value
            valid = true
            break
        end
    end
    -- Discard invalid languages
    if not valid then
        util.toast(get_internal_message("ERR_INVALID_STORED_LANGUAGE"))
    end
    prefFile:close()
end
-- Main function that parses the translation .txt file.
local function parse_translations_from_file(filename)
    local path = TRANSLATIONS_FOLDER .. filename .. ".txt"
    local file = io.open(path, "r")
    if file == nil then
        return false
    end
    -- Probably can optimize this but... it works so... shrug
    for line in file:lines() do
        local key = ""
        local value = ""
        local readerState = 0 -- -1: done, 0: read key, 1: seperator found, trimming spaces, 2: read value
        -- Loop every character for every line
        line:gsub(".", function(c)
            if readerState == -1 then return end -- Done reading
            if readerState > 0 then
                if readerState == 1 and c ~= " " then -- Skip any beginning spaces between : and value
                    readerState = 2
                end
                -- Finally, parse the final message
                if readerState == 2 then
                    value = value .. c
                end
            elseif c ~= ":" then -- If part of key and key does not start with #, add to key string
                if c == "#" then -- If starts with #, because cant break out of function, just set var to skip every next call:
                    readerState = -1
                end
                key = key .. c
            else
                readerState = 1 -- Found first colon separator, key has been found. switch to string
            end
        end)
        -- If a valid line was parsed (such that a key and value exist), add to table
        if readerState == 2 then
            translations[string.upper(key)] = value:gsub("\\([nt])", {n="\n", t="\t"})
        elseif readerState == 1 then
            -- Leave blank (for empty sections)
            translations[string.upper(key)] = ""
        end
    end
    return true
end


---------------
-- Public API
---------------
-- Set the saved language preference. Returns true on success, returns false on invalid language
-- prefLang: Valid ISO Code (see GAME_LANGUAGE_IDS)
function set_language_preference(prefLang)
    for _, language in pairs(GAME_LANGUAGE_IDS) do
        if prefLang == language then
            local file = io.open(PREF_FILE_PATH, "w")
            if file == nil then
                util.toast("Could not save language preference")
                return false
            end
            file:write(prefLang)
            file:close()
            return true
        end
    end
    return false
end
-- Optional, will automatically download translation files from domain and uri if set
-- Only supports web servers that the server filename is identical to final filename (/path/file.txt -> file.txt)
-- You can call download_translation_file manually, has serverFileName parameter
function set_autodownload_uri(domain, uri)
    autodownload.domain = domain
    autodownload.uri = uri
end
-- Attempt to load the specified translation file, returns language if successful or false if none found
-- Needs to be called or all text will return translated ERR_NO_TRANSLATION_FILE_LOADED
-- filePrefix: filename to load. Do not put extension.
-- Will append active language to filename (filePrefix = "jackz_vehicles") results in "jackz_vehicles_en-US.txt" being loaded
function load_translation_file(filePrefix)
    if parse_translations_from_file(filePrefix .. "_" .. activeLang) then
        translationAvailable = true
        return activeLang
    elseif autodownload.domain ~= nil then
        -- Attempt to download language file for preferred language:
        download_translation_file(autodownload.domain, autodownload.uri, filePrefix .. "_" .. activeLang)
        while autodownload.active do
            util.yield()
        end

        if translationAvailable then
            return activeLang
        end
        -- Don't fallback to en-US if there is no en-US
        if activeLang == "en_US" then
            return false
        end
        if parse_translations_from_file(filePrefix .. "_" .. "en-US") then -- Could not find any file to auto download, fall back to english
            translationAvailable = true
            activeLang = "en-US"
            return activeLang
        else
            download_translation_file(autodownload.domain, autodownload.uri, filePrefix .. "_en-US")
            while autodownload.active do
                util.yield()
            end
            if translationAvailable then
                activeLang = "en-US"
                return activeLang
            else
                return false
            end
        end
    end
    return false
end
-- Attempt to download a translation file from https://domai/path/fileprefix_lang-code.txt
-- Example: download_translation_file("jackz.me", "/stand/translations/", "jackz_vehicles") -> https://jackz.me/stand/translations/jackz_vehicles-en-US.txt
-- Domain & URI: The prefix to append to download file from.
-- saveAsName: The name to save the file as on disk (and is added onto uri if serverFileName is nil)
-- serverFileName(optional): The filename to append to uri, incase you downloading from a crappy webhost
function download_translation_file(domain, uri, saveAsName, serverFileName)
    local dlPart = serverFileName or saveAsName 
    async_http.init(domain, uri .. dlPart .. ".txt" , function(result)
        if result:sub(1, 1) ~= "#" then -- IS HTML
            autodownload.active = false
            util.log(string.format("lib/translations: Could not download translations file from %s/%s/%s as %s: Server responded with invalid file", domain, uri, saveAsName, serverFileName or saveAsName))
            util.toast(get_internal_message("ERR_AUTODL_FAIL"))
            return
        end
        local file = io.open(TRANSLATIONS_FOLDER .. saveAsName .. ".txt", "w")
        if file == nil then
            util.log(string.format("lib/translations: Could not download translations file from %s/%s/%s as %s: Could not open file", domain, uri, saveAsName, serverFileName or saveAsName))
            util.toast(get_internal_message("ERR_AUTODL_FAIL"))
            autodownload.active = false
            return
        end
        file:write(result:gsub("\r", "") .. "\n")
        file:flush() -- redudant, probably?
        file:close()
        parse_translations_from_file(saveAsName)
        translationAvailable = true
        autodownload.active = false
    end, function(e)
        util.toast(get_internal_message("ERR_AUTODL_FAIL"))
        autodownload.active = false
    end)
    autodownload.active = true
    async_http.dispatch()
end
-- Only works if an autodownload url was set
-- Updates a filePrefix (filename w/o ext) for preferred language & fallback lang (en-US)
function update_translation_file(filePrefix)
    download_translation_file(autodownload.domain, autodownload.uri, filePrefix .. "_" .. activeLang)
    if activeLang ~= "en-US" then
        download_translation_file(autodownload.domain, autodownload.uri, filePrefix .. "_en-US")
    end
end
-- Gets the language name (in english). en-US -> English, etc
function get_language_name()
    return LANGUAGE_NAMES[activeLang]
end
-- Gets the ISO language code (en-US, fr-FR, etc)
function get_language_id()
    return activeLang
end
-- Returns the raw translation text for an id
-- Similar to .format(id) except returns nil if id does not exist
function get_raw_string(translationID)
    return translations[string.upper(translationID)]
end
-- Formats the specified localized text entry with optional arguments. Calls string.format if arguments provided
-- Returns an error message if no translation file was loaded.
-- Returns translation id if translation was not found.
function format(translationID, ...)
    if not translationAvailable then
        return get_internal_message("ERR_NO_TRANSLATION_FILE_LOADED")
    end
    local text = translations[string.upper(translationID)]
    if text == nil then
        util.log("Missing translation for \"" .. translationID .. "\"")
        return string.upper(translationID)
    elseif ... ~= nil then
        return string.format(text, ...)
    else
        return text
    end
end

-- Formats the specified localized text entry with optional arguments. Calls string.format if arguments provided
-- Toasts an error message if no translation file was loaded.
-- Toasts translation id if translation was not found.
-- Shortcut to util.toast(lang.format(...))
function toast(translationID, ...)
    if not translationAvailable then
        util.toast(get_internal_message("ERR_NO_TRANSLATION_FILE_LOADED"))
    end
    local text = (... == nil) and format(translationID) or format(translationID, ...)
    util.toast(text)
end

-- Will add a new list "Language >" list to root with a selection of languages.
-- Selection will set their preferred language for all scripts that use this library.
function add_language_selector_to_menu(root)
    local list = menu.list(root, "Language", {}, "Sets your preferred language.\nCurrent language: " .. get_language_name() .. " (" .. activeLang .. ")")
    for _, iso in pairs(GAME_LANGUAGE_IDS) do
        menu.action(list, LANGUAGE_NAMES[iso], {}, iso, function(_)
            set_language_preference(iso)
            util.toast(get_internal_message("LANG_PREF_CHANGED"))
        end)
    end
end
-- Needed due to menu.action not liking nil for somereason on 2nd callbacks
function no_op() end

local menus = {
    --- Creates a menu.list() with translation prefix
    list = function(root, translationKey, commands, callback, callback2)
        return menu.list(root, format(translationKey .. "_NAME"), commands, format(translationKey .. "_DESC"), callback or no_op, callback2 or no_op)
    end,
    -- Creates a menu.action() with translation prefix
    action = function(root, translationKey, commands, callback, callback2, syntax)
        return menu.action(root, format(translationKey .. "_NAME"), commands, format(translationKey .. "_DESC"), callback, callback2 or no_op, syntax or "")
    end,
    --- Creates a menu.divider() with translation prefix
    divider = function(root, translationKey)
        return menu.divider(root, format(translationKey .. "_DIVIDER"))
    end,
    --- Creates a menu.toggle() with translation prefix
    toggle = function(root, translationKey, commands, callback, default)
        return menu.toggle(root, format(translationKey .. "_NAME"), commands,format(translationKey .. "_DESC"), callback, default or false)
    end,
    --- Creates a menu.slider() with translation prefix
    slider = function(root, translationKey, commands, min, max, default, step, callback)
        return menu.slider(root, format(translationKey .. "_NAME"), commands, format(translationKey .. "_DESC"), min, max, default or 0, step or 1, callback)
    end,
    --- Creates a menu.click_slider() with translation prefix
    click_slider = function(root, translationKey, commands, min, max, default, step, callback)
        return menu.click_slider(root, format(translationKey .. "_NAME"), commands, format(translationKey .. "_DESC"), min, max, default or 0, step or 1, callback)
    end,
    --- Creates a menu.colour() (first method) with translation prefix
    colour = function(root, translationKey, commands, color, transparency, callback)
        return menu.colour(root, format(translationKey .. "_NAME"), commands, format(translationKey .. "_DESC"), color, transparency, callback)
    end,
    --- Creates a menu.text_input() with translation prefix
    text_input = function(root, translationKey, commands, callback, defaultStr)
        return menu.text_input(root, format(translationKey .. "_NAME"), commands, format(translationKey .. "_DESC"), callback, defaultStr or "")
    end
}
return {
    VERSION = LIB_VERSION,
    load_translation_file = load_translation_file,
    download_translation_file = download_translation_file,
    set_autodownload_uri = set_autodownload_uri,
    update_translation_file = update_translation_file,
    set_language_preference = set_language_preference,
    get_language_name = get_language_name,
    get_language_id = get_language_id,
    format = format,
    toast = toast,
    get_raw_string = get_raw_string,
    GAME_LANGUAGE_IDS = GAME_LANGUAGE_IDS, -- Return table of lang iso's - don't mutate
    LANGUAGE_NAMES = LANGUAGE_NAMES, -- Returns table of language english names - don't mutate
    -- Implement implementations of stand menu items w/ nicer translation support.
    -- Lang keys inputted (translationKey) will automatically be suffixed with _NAME and _DESC
    -- MY_TRANSL_KEY -> MY_TRANSL_KEY_NAME as command name && MY_TRANSL_KEY_DESC as command description
    menus = menus,
    add_language_selector_to_menu = add_language_selector_to_menu,

    list = menus.list,
    action = menus.action,
    divider = menus.divider,
    toggle = menus.toggle,
    slider = menus.slider,
    click_slider = menus.click_slider,
    colour = menus.colour,
    text_input = menus.text_input
}