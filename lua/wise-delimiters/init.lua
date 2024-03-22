local wr = require("wise-delimiters.filewr")

local M = {}

local i = "i";
local savefile = "delimiters.txt"

local delimiters = {
    ['"'] = '"',
    ["'"] = "'",
    ["{"] = "}",
    ["["] = "]",
    ["("] = ")",
    ["<"] = ">"
}

local closing_delimiters = ""
local opening_delimiters = ""

local function update_delimiters_lookup()
    closing_delimiters = ""
    opening_delimiters = ""
    for opening, closing in pairs(delimiters) do
        closing_delimiters = closing_delimiters .. closing
        opening_delimiters = opening_delimiters .. opening
    end
end

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end


local function remap_Tab()
    map(i, '<Tab>', function()
        local line = vim.fn.getline('.');
        local col = vim.fn.col('.')
        local next_char = line:sub(col, col)

        if next_char == "" then
            return '<Tab>'
        elseif string.find(closing_delimiters, next_char) then
            return '<right>'
        else
            return '<Tab>'
        end
    end, { expr = true, })
end

local function remap_backspace()
    map(i, '<BS>', function()
        local line = vim.fn.getline('.');
        local col = vim.fn.col('.')
        local next_char = line:sub(col, col)
        local prev_char = line:sub(col - 1, col - 1)

        if delimiters[prev_char] == next_char then
            return '<right><BS><BS>'
        else
            return '<BS>'
        end
    end, { expr = true, })
end

local function remap_delimiters()
    for opening, closing in pairs(delimiters) do
        map(i, opening, opening .. closing .. "<left>")

        if opening == '{' then
            map(i, '{<CR>', '{<CR>}<ESC>O')
        end
    end
end

-- local function add_commands()
--     vim.cmd("command! DelimitersAdd lua M.delimiters_add()")
--     vim.cmd("command! DelimitersRemove lua M.delimiters_remove()")
--     vim.cmd("command! DelimitersList lua M.delimiters_list()")
--     print("commands added")
-- end

local function is_char(possible_char)
    return type(possible_char) == "string" and #possible_char == 1
end

function M.setup()
    if io.open(savefile) == nil then
        wr.write(delimiters, savefile)
    else
        wr.read(delimiters, savefile)
    end
    update_delimiters_lookup()
    remap_Tab()
    remap_backspace()
    remap_delimiters()
    -- add_commands()
end

M.delimiters_list = function()
    local all_delimiters = ""
    for opening, closing in pairs(delimiters) do
        all_delimiters = all_delimiters .. opening .. "-" .. closing .. "   "
    end
    print("Here are your delimiters: " .. all_delimiters)
end

M.delimiters_add = function(opening, closing)
    if is_char(opening) and is_char(closing) then
        if delimiters[opening] ~= nil then
            print("Delimiters table already contains " .. opening .. " value. No need to add another one.")
            return
        end
        delimiters[opening] = closing
        wr.write(delimiters, savefile)
        update_delimiters_lookup()
        print("Delimiters pair   " .. opening .. "-" .. closing .. "   added succesfully.")
        return
    else
        print(
            "Only characters allowed to be delimeters. Pass one character at a time. Don't forget to use double quotes.")
        return
    end
end

M.delimiters_remove = function(opening)
    if not is_char(opening) then
        print("Only characters allowed to be delimeters. Pass one character at a time.")
        return
    end
    if delimiters[opening] ~= nil then
        delimiters[opening] = nil
        wr.write(delimiters, savefile)
        update_delimiters_lookup()
        print("Delimiter pair removed succesfully.")
        return
    end

    print("There is no " .. opening .. " in delimiters table.")
end

return M
