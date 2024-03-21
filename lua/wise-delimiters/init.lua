local M = {}

local i = "i";

local delimiters = {
    ['"'] = '"',
    ["'"] = "'",
    ["{"] = "}",
    ["["] = "]",
    ["("] = ")",
    ["<"] = ">"
}

local closing_delimiters = ""

local function update_closing_delimiters()
    closing_delimiters = ""
    for _, closing in pairs(delimiters) do
        closing_delimiters = closing_delimiters .. closing
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
    -- todo
    map(i, '<BS>', function ()
        -- local line = vim.fn.getline('.');
        -- local col = vim.fn.col('.')
        -- local next_char = line:sub(col, col)
    end)

    print("backspace is remapped")
end

local function remap_delimiters()
    for opening, closing in pairs(delimiters) do
        map(i, opening, opening .. closing .. "<left>")

        if opening == '{' then
            map(i, '{<CR>', '{<CR>}<ESC>O')
        end
    end
end

local function is_char(possible_char)
    return type(possible_char) == "string" and #possible_char == 1
end

local function get_index(table, check_value)
    for index, value in pairs(table) do
        if value == check_value then
            return index
        end
    end
    return -1
end

function M.setup()
    update_closing_delimiters()
    remap_Tab()
    remap_backspace()
    remap_delimiters()
end

M.list_delimiters = function()
    local all_delimiters = ""
    for opening, closing in pairs(delimiters) do
        all_delimiters = all_delimiters .. opening .. "-" .. closing .. "   "
    end
    print("Here are your delimiters: " .. all_delimiters)
end

M.add_delimiter_pair = function(opening, closing)
    if is_char(opening) and is_char(closing) then
        if get_index(delimiters, opening) ~= -1 then
            print("Delimiters table already contains " .. opening .. " value. No need to add another one.")
            return
        end
        delimiters[opening] = closing
        update_closing_delimiters()
        print("Delimiters pair   " .. opening .. "-" .. closing .. "   added succesfully.")
        return
    else
        print(
            "Only characters allowed to be delimeters. Pass one character at a time. Don't forget to use double quotes.")
        return
    end
end

M.remove_delimiter_pair = function(opening)
    if not is_char(opening) then
        print("Only characters allowed to be delimeters. Pass one character at a time.")
        return
    end
    if delimiters[opening] ~= nil then
        delimiters[opening] = nil
        update_closing_delimiters()
        print("Delimiter pair removed succesfully.")
        return
    end

    print("There is no " .. opening .. " in delimiters table.")
end

return M
