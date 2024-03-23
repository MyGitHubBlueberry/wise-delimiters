local M = {}

local file_path = ""

local function get_data_directory()
    local data_dir_cmd = vim.api.nvim_exec(":echo stdpath('data')", true)

    local data_dir = data_dir_cmd:gsub("\n", "")

    return data_dir
end

local function file_is_empty(filename)
    local file = io.open(filename, "r")
    if file then
        local content = file:read("*all")
        io.close(file)
        return content == nil or content == ""
    else
        return false -- File doesn't exist or couldn't be opened
    end
end

local function is_path_set()
    return file_path ~= ""
end

local function edit_file(data, mode)
    local file = io.open(file_path, mode)

    if file == nil then
        print("Error writing to a file ", file_path)
        return
    end

    for key, value in pairs(data) do
        file:write(key .. " = " .. value .. "\n")
    end

    file:close()
end

function M.set_relative_file_path(path)
    file_path = get_data_directory() .. path
end

function M.init(data)
    if not is_path_set() then
        print("Can`t init a file. Set file path first.")
    end

    local file = io.open(file_path, "r")

    if file == nil or file_is_empty(file_path) then
        edit_file(data, "w")
        return
    end
end

function M.rewrite(data)
    if not is_path_set() then
        print("Can`t rewrite a file. Set file path first.")
    end
    edit_file(data, "w")
end

function M.append(data)
    if not is_path_set() then
        print("Can`t write a file. Set file path first.")
    end
    edit_file(data, "a")
end

function M.read()
    local data = {};

    if not is_path_set() then
        print("Can`t read a file. Set file path first.")
    end

    local file = io.open(file_path, "r")

    if file_is_empty(file_path) or file == nil then
        return data
    end

    for line in file:lines() do
        local key, value = line:match("(%S+)%s*=%s*(%S+)")
        if key and value then
            data[key] = value
        end
    end

    file:close()

    return data;
end

return M
