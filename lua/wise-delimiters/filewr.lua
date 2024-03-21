local M = {}

function M.write(data, filename)
    os.remove(filename)
    local file = io.open(filename, "w")

    if file == nil then
        print("Error writing to a file ", filename)
        return
    end

    for key, value in pairs(data) do
        file:write(key .. " = " .. value .. "\n")
    end

    file:close()
end

function M.read(data, filename)
    local file = io.open(filename, "r")

    if file == nil then
        print("Error reading from a file ", filename)
        return
    end

    for line in file:lines() do
        local key, value = line:match("(%S+)%s*=%s*(%S+)")
        if key and value then
            data[key] = value
        end
    end

    file:close()
end

return M
