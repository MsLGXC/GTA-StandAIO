-- Auto-Updater v2.5.2
-- by Hexarobi
-- For Lua Scripts for the Stand Mod Menu for GTA5
-- https://github.com/hexarobi/stand-lua-auto-updater

local config = {
    debug_mode = false,
    http_check_delay = 250,
    extraction_ignored_filenames = {
        "readme",
        "readme.txt",
        "readme.md",
        "license",
        "license.txt",
        "license.md",
        "version",
        "version.txt",
        "version.lua",
    }
}

---
--- Dependencies
---

--util.ensure_package_is_installed('lua/json')
--local status_json, json = pcall(require, "json")
--if not status_json then error("Could not load json lib. Make sure it is selected under Stand > Lua Scripts > Repository > json") end

local status_crypto, crypto = pcall(require, "crypto")
if not status_crypto then util.log("Could not load crypto lib") end

---
--- Utilities
---

local function parse_url_host(url)
    return url:match("://(.-)/")
end

local function parse_url_path(url)
    return "/"..url:match("://.-/(.*)")
end

local function modify_github_url_branch(url, switch_to_branch)
    local root, path = url:match("^(https://raw.githubusercontent.com/[^/]+/[^/]+)/[^/]+/([^/].*)$")
    return root.."/"..switch_to_branch.."/"..path
end

local function debug_log(message)
    if config.debug_mode then
        util.log("[auto-updater] "..message)
    end
end

---
--- Version File
---

local function save_version_data(auto_update_config)
    local file = io.open(auto_update_config.version_file, "wb")
    if file == nil then util.toast("Error opening version file for writing: "..auto_update_config.version_file, TOAST_ALL) return end
    file:write(soup.json.encode(auto_update_config.version_data))
    file:close()
end

local function load_version_data(auto_update_config)
    local file = io.open(auto_update_config.version_file)
    if file then
        local version = file:read()
        file:close()
        local status, version_data = pcall(soup.json.decode, version)
        if not status and type(version) == "string" then
            version_data = {version_id=version}
        end
        auto_update_config.version_data = version_data
        --util.toast("Loaded version data "..inspect(auto_update_config.version_data), TOAST_ALL)
    else
        auto_update_config.version_data = {}
        --util.toast("Created new version data "..inspect(auto_update_config.version_data), TOAST_ALL)
    end
end

local function update_version_last_checked_time(auto_update_config)
    load_version_data(auto_update_config)
    auto_update_config.version_data.last_checked = util.current_unix_time_seconds()
    save_version_data(auto_update_config)
end

local function update_version_id(auto_update_config, version_id, file_hash)
    local script_version = auto_update_config.version_data.script_version
    load_version_data(auto_update_config)
    auto_update_config.version_data.version_id = version_id
    auto_update_config.version_data.file_hash = file_hash
    auto_update_config.version_data.fresh_update = true
    auto_update_config.version_data.last_checked = util.current_unix_time_seconds()
    auto_update_config.version_data.script_version = script_version
    save_version_data(auto_update_config)
end

local function process_version(auto_update_config, result, headers)
    local file_hash
    if crypto then
        file_hash = crypto.md5(result)
    end
    if headers then
        for header_key, header_value in pairs(headers) do
            if header_key:lower() == "etag" then
                update_version_id(auto_update_config, header_value, file_hash)
            end
        end
    end
end

---
--- Replacer
---

local function update_file(path, content)
    local dirpath = path:match("(.-)([^\\/]-%.?)$")
    filesystem.mkdirs(dirpath)
    local file = io.open(path, "wb")
    if file == nil then
        util.toast("Error updating "..path..". Could not open file for writing.")
        return false
    end
    file:write(content)
    file:close()
    return true
end

local function replace_current_script(auto_update_config, content)
    if update_file(auto_update_config.script_path, content) then
        auto_update_config.script_updated = true
    end
end

local function parse_script_version(auto_update_config, script)
    auto_update_config.version_data.script_version = script:match('SCRIPT_VERSION = "([^ ]+)"')
end

---
--- Full Restarter
---

local function force_full_restart(auto_update_config)
    local script_body = "util.yield(50) menu.trigger_commands(\"lua"..auto_update_config.script_run_name.."\")\
                        io.remove(filesystem.scripts_dir()..SCRIPT_RELPATH) util.stop_script()"
    update_file(filesystem.scripts_dir().."\\restartscript.lua", script_body)
    menu.trigger_command(menu.ref_by_path("Stand>Lua Scripts"))
    util.yield(50)
    menu.trigger_commands("luarestartscript")
    util.stop_script()
end

---
--- Zip Extractor
---

local function escape_pattern(text)
    return text:gsub("([^%w])", "%%%1")
end

local function is_ignored_filename(filename)
    local filename_lower = filename:lower()
    for _, ignored_filename in pairs(config.extraction_ignored_filenames) do
        if ignored_filename == filename_lower then
            return true
        end
    end
    return false
end

local function build_script_run_name(script_name)
    if script_name ~= nil then
        return script_name:gsub("_", "")
    end
end

local function extract_zip(auto_update_config)
    debug_log("Extracting zip file "..auto_update_config.script_path)
    if auto_update_config.extracted_files == nil then auto_update_config.extracted_files = {} end
    local first_lua_file
    local fr = soup.FileReader(auto_update_config.script_path)
    local zr = soup.ZipReader(fr)
    for _, f in zr:getFileList() do
        for _, extraction in pairs(auto_update_config.extractions) do
            local pattern = "^"..escape_pattern(extraction.from).."/(.*[^/])$"
            local _, _, relative_path = f.name:find(pattern)
            --local relative_path = f.name:gsub(pattern, "")
            if relative_path and not is_ignored_filename(relative_path) then
                local output_filepath = filesystem.stand_dir() .. extraction.to .. relative_path
                debug_log("Extracting file "..output_filepath)
                local expand_status, content = pcall(zr.getFileContents, zr, f)
                if not expand_status then
                    debug_log("Failed to extract "..f.name..": "..content)
                else
                    local _, _, lua_filename = f.name:find("([^/]+)%.lua$")
                    if first_lua_file == nil and lua_filename then
                        debug_log("Found first lua filename "..lua_filename)
                        first_lua_file = lua_filename
                        if auto_update_config.script_run_name == nil then
                            auto_update_config.script_run_name = build_script_run_name(lua_filename)
                        end
                        if auto_update_config.script_filepath == nil then
                            auto_update_config.script_filepath = output_filepath
                        end
                    end
                    update_file(output_filepath, content)
                    debug_log("Extracted file "..output_filepath)
                    table.insert(auto_update_config.extracted_files, output_filepath)
                end
            else
                debug_log("Skipping file due to name doesnt match pattern "..pattern.." "..f.name)
            end
        end
    end
end

---
--- Uninstaller
---

local function delete_file(filepath)
    if filepath == nil or not filesystem.exists(filepath) then return end
    debug_log("Deleting file "..filepath)
    io.remove(filepath)
end

local function uninstall(auto_update_config)
    delete_file(auto_update_config.script_path)
    if auto_update_config.extracted_files ~= nil then
        for _, extracted_file in pairs(auto_update_config.extracted_files) do
            delete_file(extracted_file)
        end
    end
end

---
--- GitHub API
---

local function parse_github_user_and_project(url)
    local _, _, user, project = url:find("^https://github%.com/([^/]+)/([^/]+)/?$")
    if not user or not project then
        error("Invalid project url (must be a GitHub.com project): "..url)
    end
    return user, project
end

local function fetch_json(url)
    local fetch_complete = false
    local response
    async_http.init(parse_url_host(url), parse_url_path(url), function(result, headers, status_code)
        response = soup.json.decode(result)
        fetch_complete = true
    end, function()
        util.toast("Error fetching "..url, TOAST_ALL)
        fetch_complete = true
    end)
    async_http.dispatch()
    while fetch_complete ~= true do util.yield() end
    return response
end

local function get_default_branch(auto_update_config)
    local user, project = parse_github_user_and_project(auto_update_config.project_url)
    local response = fetch_json("https://api.github.com/repos/"..user.."/"..project.."/branches")
    return response[1].name
end


---
--- Config Defaults
---

local function initial_project_config(auto_update_config)
    -- Faster config assumes main branch for now, will use final_project_config to detect actual branch name
    if auto_update_config.project_url ~= nil then
        local user, project = parse_github_user_and_project(auto_update_config.project_url)
        if auto_update_config.author == nil then
            auto_update_config.author = user
        end
        if auto_update_config.source_url == nil then
            auto_update_config.source_url = auto_update_config.project_url
            auto_update_config.is_project_archive = true
            auto_update_config.script_relpath = user .. "-" .. project .. "-main.zip"
        end
    end
end

local function final_project_config(auto_update_config)
    -- Slower config makes API call to get proper branch name, only used at install time
    if auto_update_config.project_url ~= nil and auto_update_config.is_project_archive then
        if auto_update_config.branch == nil then
            -- Get branch from API
            auto_update_config.branch = get_default_branch(auto_update_config)
            debug_log("Set branch "..auto_update_config.branch)
        end
        local user, project = parse_github_user_and_project(auto_update_config.project_url)
        auto_update_config.source_url = "https://codeload.github.com/"..user.."/"..project.."/zip/refs/heads/" .. auto_update_config.branch
        local filename = user .. "-" .. project .. "-" .. auto_update_config.branch .. ".zip"
        auto_update_config.script_relpath = filename
        auto_update_config.script_path = filesystem.store_dir() .. "auto-updater/compressed/" ..  filename
        if auto_update_config.extractions == nil then
            auto_update_config.extractions = {
                {
                    from=project .. "-" .. auto_update_config.branch,
                    to="Lua Scripts\\",
                }
            }
        end
    end
end

local function expand_auto_update_config(auto_update_config)
    initial_project_config(auto_update_config)
    auto_update_config.script_relpath = auto_update_config.script_relpath:gsub("\\", "/")
    if auto_update_config.script_path == nil then
        auto_update_config.script_path = filesystem.scripts_dir() .. auto_update_config.script_relpath
    end
    if auto_update_config.script_filename == nil then
        auto_update_config.script_filename = ("/"..auto_update_config.script_relpath):match("^.*/(.+)$")
    end
    if auto_update_config.name == nil then
        auto_update_config.name = auto_update_config.script_filename
    end
    if auto_update_config.script_run_name == nil and auto_update_config.script_filename then
        auto_update_config.script_run_name = build_script_run_name(auto_update_config.script_filename:match(".-([^\\/]-%.?)[.]lua$"))
    end
    auto_update_config.script_reldirpath = ("/"..auto_update_config.script_relpath):match("^(.*)/[^/]+$")
    filesystem.mkdirs(filesystem.scripts_dir() .. auto_update_config.script_reldirpath)
    if auto_update_config.version_file == nil then
        auto_update_config.version_store_dir = filesystem.store_dir() .. "auto-updater/versions" .. auto_update_config.script_reldirpath
        filesystem.mkdirs(auto_update_config.version_store_dir)
        auto_update_config.version_file = auto_update_config.version_store_dir .. "/" .. auto_update_config.script_filename .. ".version"
    end
    if auto_update_config.source_url == nil then        -- For backward compatibility with older configs
        auto_update_config.source_url = "https://" .. auto_update_config.source_host .. "/" .. auto_update_config.source_path
    end
    if auto_update_config.switch_to_branch ~= nil then
        auto_update_config.source_url = modify_github_url_branch(auto_update_config.source_url, auto_update_config.switch_to_branch)
    end
    --if auto_update_config.restart_delay == nil then
    --    auto_update_config.restart_delay = 100
    --end
    if auto_update_config.http_timeout == nil then
        auto_update_config.http_timeout = 45000
    end
    if auto_update_config.expected_status_code == nil then
        auto_update_config.expected_status_code = 200
    end
    if auto_update_config.check_interval == nil then
        auto_update_config.check_interval = 86400 -- Daily = 86400 seconds
    end
    load_version_data(auto_update_config)
end

---
--- Downloader
---

local is_download_complete

local function is_result_valid(auto_update_config, result, headers, status_code)
    if status_code == 304 then
        -- No update found
        update_version_last_checked_time(auto_update_config)
        is_download_complete = true
        return false
    end
    if status_code == 302 then
        util.toast("Error updating "..auto_update_config.name..": Unexpected redirection from "..auto_update_config.source_url.." to "..headers["Location"], TOAST_ALL)
        is_download_complete = false
        return false
    end
    if status_code ~= auto_update_config.expected_status_code then
        util.toast("Error updating "..auto_update_config.name..": Unexpected status code: "..status_code .. " for URL "..auto_update_config.source_url, TOAST_ALL)
        is_download_complete = false
        return false
    end
    if not result or result == "" then
        util.toast("Error updating "..auto_update_config.name..": Empty content", TOAST_ALL)
        is_download_complete = false
        return false
    end
    if auto_update_config.verify_file_begins_with ~= nil then
        if not string.startswith(result, auto_update_config.verify_file_begins_with) then
            util.toast("Error updating "..auto_update_config.name..": Found invalid content", TOAST_ALL)
            is_download_complete = false
            return false
        end
    end
    if auto_update_config.verify_file_begins_with == nil and auto_update_config.verify_file_does_not_begin_with == nil then
        auto_update_config.verify_file_does_not_begin_with = "<"
    end
    if auto_update_config.verify_file_does_not_begin_with ~= nil
            and string.startswith(result, auto_update_config.verify_file_does_not_begin_with) then
        util.toast("Error updating "..auto_update_config.name..": Found invalid content", TOAST_ALL)
        is_download_complete = false
        return false
    end
    return true
end

local function process_auto_update(auto_update_config)
    final_project_config(auto_update_config)
    async_http.init(parse_url_host(auto_update_config.source_url), parse_url_path(auto_update_config.source_url), function(result, headers, status_code)
        if not is_result_valid(auto_update_config, result, headers, status_code) then
            return
        end
        replace_current_script(auto_update_config, result)
        parse_script_version(auto_update_config, result)
        process_version(auto_update_config, result, headers)
        if auto_update_config.extractions ~= nil then
            extract_zip(auto_update_config)
        end
        is_download_complete = true
        if not auto_update_config.silent_updates then
            util.toast("Updated "..auto_update_config.name, TOAST_ALL)
        end
    end, function()
        util.toast("Error updating "..auto_update_config.name..": Update failed to download.", TOAST_ALL)
    end)
    -- Only use cached version if this is not a clean reinstall, and if the file still exists on disk
    if auto_update_config.clean_reinstall ~= true and filesystem.exists(auto_update_config.script_path) then
        -- Use ETags to only fetch files if they have been updated
        -- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag
        if auto_update_config.version_data.version_id then
            async_http.add_header("If-None-Match", auto_update_config.version_data.version_id)
        end
    end
    async_http.dispatch()
end

local function is_due_for_update_check(auto_update_config)
    return (
        auto_update_config.clean_reinstall == true
        or auto_update_config.version_data.last_checked == nil
        or auto_update_config.check_interval == 0
        or ((util.current_unix_time_seconds() - auto_update_config.version_data.last_checked) > auto_update_config.check_interval)
        or (not filesystem.exists(auto_update_config.script_path))
    )
end

local function is_update_disabled()
    local disable_internet_access_menu = menu.ref_by_path("Stand>Lua Scripts>Settings>Disable Internet Access")
    if not disable_internet_access_menu then util.toast("Could not find disable_internet_access_menu") end
    return disable_internet_access_menu.value
end

---
--- Require with Auto Update (for libs)
---

local function require_with_auto_update(auto_update_config)
    auto_update_config.lib_require_path = auto_update_config.script_relpath:gsub("[.]lua$", "")
    --if auto_update_config.auto_restart == nil then auto_update_config.auto_restart = false end
    run_auto_update(auto_update_config)
    local auto_loaded_lib_status, loaded_lib = pcall(require, auto_update_config.lib_require_path)
    if not auto_loaded_lib_status then
        util.toast("Failed to load required file: "..auto_update_config.script_relpath.."\n"..tostring(loaded_lib), TOAST_ALL)
        return
    end
    auto_update_config.loaded_lib = loaded_lib
    return loaded_lib
end

---
--- Auto Update Check
---

function run_auto_update(auto_update_config)
    expand_auto_update_config(auto_update_config)
    debug_log("Running auto-update on "..auto_update_config.script_filename.."...", TOAST_ALL)
    if is_update_disabled() then
        util.toast("Cannot auto-update due to disabled internet access. To enable auto-updates uncheck Stand > Lua Scripts > Settings > Disable Internet Access", TOAST_ALL)
        return false
    end
    if not auto_update_config.is_dependency then util.set_busy(true) end
    if is_due_for_update_check(auto_update_config) then
        is_download_complete = nil
        util.create_thread(function()
            process_auto_update(auto_update_config)
        end)
        local i = 1
        while (is_download_complete == nil and i < (auto_update_config.http_timeout / config.http_check_delay)) do
            util.yield(config.http_check_delay)
            i = i + 1
        end
        if is_download_complete == nil then
            util.toast("Error updating "..auto_update_config.script_filename..": HTTP Timeout. This error can often be resolved by using Cloudflare DNS settings: 1.1.1.1 and 1.0.0.1 For more info visit http://1.1.1.1/dns/", TOAST_ALL)
            return false
        end
        if (auto_update_config.script_updated and not auto_update_config.is_dependency) and auto_update_config.auto_restart ~= false then
            debug_log("Restarting...", TOAST_ALL)
            if auto_update_config.restart_delay then util.yield(auto_update_config.restart_delay) end
            force_full_restart(auto_update_config)
            return
        end
    end
    local dependency_updated = false
    if auto_update_config.dependencies ~= nil then
        for _, dependency in pairs(auto_update_config.dependencies) do
            dependency.is_dependency = true
            if dependency.silent_updates == nil then dependency.silent_updates = auto_update_config.silent_updates end
            if (is_due_for_update_check(auto_update_config) or auto_update_config.script_updated or auto_update_config.version_data.fresh_update) then dependency.check_interval = 0 end
            if dependency.is_required and dependency.script_relpath:match("(.*)[.]lua$") then
                require_with_auto_update(dependency)
            else
                run_auto_update(dependency)
            end
            if dependency.script_updated then dependency_updated = true end
        end
    end
    if auto_update_config.version_data.fresh_update and not auto_update_config.is_dependency then
        -- TODO: Show changelog
        if auto_update_config.version_data.script_version then
            util.toast("Updated "..auto_update_config.script_filename.." to "..tostring(auto_update_config.version_data.script_version), TOAST_ALL)
        end
        auto_update_config.version_data.fresh_update = false
        save_version_data(auto_update_config)
    end
    if (dependency_updated) and auto_update_config.auto_restart ~= false then
        debug_log("Dependency updated. Restarting...", TOAST_ALL)
        if auto_update_config.restart_delay then util.yield(auto_update_config.restart_delay) end
        force_full_restart(auto_update_config)
        return
    end
    if not auto_update_config.is_dependency then util.set_busy(false) end
    return true
end


---
--- Legacy Compatibility
---

-- Wrapper for old function names
function auto_update(auto_update_config)
    run_auto_update(auto_update_config)
end

---
--- Self-Update
---

util.create_thread(function()
    run_auto_update({
        source_url="https://raw.githubusercontent.com/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        script_relpath="lib/auto-updater.lua",
        auto_restart = false,
        verify_file_begins_with="--",
        check_interval = 86400,
    })
end)

---
--- Return Object
---

return {
    run_auto_update = run_auto_update,
    require_with_auto_update = require_with_auto_update,
    expand_auto_update_config = expand_auto_update_config,
    uninstall = uninstall,
}
