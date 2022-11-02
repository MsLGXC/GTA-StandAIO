local log_dir = filesystem.stand_dir() .. '\\Log.txt'
local full_stdout = ""
local disp_stdout = ""
local max_chars = 200
local max_lines = 20
local font_size = 0.35
local timestamp_toggle = false

local function get_stand_stdout(tbl, n)
    local all_lines = {}
    local disp_lines = {}
    local size = #tbl
    local index = 1
    if size >= n then 
        index = #tbl - n
    end

    for i=index, size do 
        local line = tbl[i]
        local line_copy = line
        if line ~= "" and line ~= '\n' then
            all_lines[#all_lines + 1] = line
            if not timestamp_toggle then
               -- at this point, the line is already added to all lines, so we can just customize it and it wont affect STDOUT clipboard copy
                local _, second_segment = string.partition(line, ']')
                if second_segment ~= nil then
                    line = second_segment
                end
            end
            if string.len(line) > max_chars then
                disp_lines[#disp_lines + 1] = line:sub(1, max_chars) .. ' ...'
            else
                disp_lines[#disp_lines + 1] = line
            end
        end
    end

    -- full_stdout exists so that we can copy the entire console output without "aesthetic" changes or trimming
    -- disp_stdout is the aesthetic, possibly-formatted version that you actually see in-game, WITH trimming
    full_stdout = table.concat(all_lines, '\n')
    disp_stdout = table.concat(disp_lines, '\n')
end

local function get_last_lines(file)
    local f = io.open(file, "r")
    local len = f:seek("end")
    f:seek("set", len - max_lines*1000)
    local text = f:read("*a")
    lines = string.split(text, '\n')
    f:close()
    get_stand_stdout(lines, max_lines)
end

menu.action(menu.my_root(), "将标准输出文件复制到剪贴板", {}, "将STDOUT的完整、未修整的最后x行复制到剪贴板。", function()
    util.copy_to_clipboard(full_stdout, true)
end)


menu.slider(menu.my_root(), "最大显示字符数", {"nconsolemaxchars"}, "", 1, 1000, 200, 1, function(s)
    max_chars = s
end)

menu.slider(menu.my_root(), "最大显示行数", {"nconsolemaxlines"}, "", 1, 60, 20, 1, function(s)
    max_lines = s
end)

menu.slider_float(menu.my_root(), "字体大小", {"nconsolemaxlines"}, "", 1, 1000, 35, 1, function(s)
    font_size = s*0.01
end)

menu.toggle(menu.my_root(), "显示时间戳", {"ndrawconsole"}, "", function(on)
    timestamp_toggle = on
end, false)

draw_toggle = true
menu.toggle(menu.my_root(), "绘制控制台", {"ndrawconsole"}, "", function(on)
    draw_toggle = on
end, true)

local text_color = {r = 1, g = 1, b = 1, a = 1}
menu.colour(menu.my_root(), "文本颜色", {"nconsoletextcolor"}, "", 1, 1, 1, 1, true, function(on_change)
    text_color = on_change
end)

local bg_color = {r = 0, g = 0, b = 0, a = 0.5}
menu.colour(menu.my_root(), "背景颜色", {"nconsolebgcolor"}, "", 0, 0, 0, 0.5, true, function(on_change)
    bg_color = on_change
end)

util.create_tick_handler(function()
    local text = get_last_lines(log_dir)
    if draw_toggle then
        local size_x, size_y = directx.get_text_size(disp_stdout, font_size)
        size_x += 0.01
        size_y += 0.01
        directx.draw_rect(0.0, 0.05, size_x, size_y, bg_color)
        directx.draw_text(0.0, 0.05, disp_stdout, 0, font_size, text_color, true)
    end
end)