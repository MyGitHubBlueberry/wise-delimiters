print("hello world")

local i = "i";

local delimiters = { '"', "'", '(', '{', '[', '<' } --need to know what is closing delimiter
-- local new_delimiters = { {'"', '"'}, {"'", "'"}, {'(', ')'}, {'{', '}'}, 
-- {'[', ']'}, {'<', '>'}}

local function list_delimiters()
    print("Here are your delimiters: " .. table.concat(delimiters, ', '))
end

local function add_delimiter(new_delimiter)
    if Is_char(new_delimiter) then
        if Get_index(delimiters, new_delimiter) ~= -1 then
            print("Delimiters table already contains " .. new_delimiter .. " value. No need to add another one.")
            return
        end
        table.insert(delimiters, new_delimiter)
        print("Delimiter " .. new_delimiter .. " added succesfully.")
        return
    else
        print(
            "Only characters allowed to be delimeters. Pass one character at a time. Don't forget to use double quotes.")
            return
    end
end

local function remove_delimiter(delimiter_to_remove)
    if not Is_char(delimiter_to_remove) then
        print("Only characters allowed to be delimeters. Pass one character at a time.")
        return
    end
    local index = Get_index(delimiters, delimiter_to_remove);
    if index ~= -1 then
        table.remove(delimiters, index)
        print("Delimiter " .. delimiter_to_remove .. " removed succesfully.")
        return
    end

    print("There is no " .. delimiter_to_remove .. " in delimiters table.")
end

function Is_char(possible_char)
    return type(possible_char) == "string" and #possible_char == 1
end

function Get_index(table, check_value)
    for index, value in pairs(table) do
        if value == check_value then
            return index
        end
    end
    return -1
end

function Remap()
    for _, delimiter in ipairs(delimiters) do
        Map(i, delimiter .. delimiter .. "<left>")
        if delimiter == '{' then
            Map(i, '{<CR>', '{<CR>}<ESC>O')
        end
    end
end

local function setup()
    -- Remap()
    Remap_Tab()
    Remap_backspace()
end

function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

function Remap_delimeters()
    Map(i, "'", "''<left>")
    Map(i, '(', '()<left>')
    Map(i, '[', '[]<left>')
    Map(i, '{', '{}<left>')
    Map(i, '{<CR>', '{<CR>}<ESC>O')
end

function Remap_Tab()
    Map(i, '<Tab>', function()
        local line = vim.fn.getline('.');
        local col = vim.fn.col('.')
        local next_char = line:sub(col, col)

        if next_char:match('[%])}"\'`]') then
            print(1)
            return '<right>'
        else
            print(2)
            return '<Tab>'
        end
    end, { expr = true, })
end

function Remap_backspace()
    print("backspace is remapped")
end

return {
    setup = setup,
    add_delimiter = add_delimiter,
    remove_delimiter = remove_delimiter,
    list_delimiters = list_delimiters,
}
