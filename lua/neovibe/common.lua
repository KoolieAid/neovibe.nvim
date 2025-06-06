-- Helper function
-- @param payload: table - Main table of messages
-- @param role: string - Role of the appeneded message
-- @param message: string - Content of the appeneded message
local function append_message(payload, role, message)
    table.insert(payload, {
        content = message,
        role = role,
    })
end

local function path_separator(text, separator)
    if true then return text:match(separator) end

    local matches = {}
    for m in text:gmatch(separator) do
        table.insert(matches, m)
    end
    return matches[1], matches[2]
end


return {
    append_message = append_message,
    separate = path_separator
}
