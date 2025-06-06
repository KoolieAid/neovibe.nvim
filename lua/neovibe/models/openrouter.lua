local path_separator = require("neovibe.common").separate
local openrouter = {}
local meta = {}
setmetatable(openrouter, meta)

function meta.__index(self, index)
    -- Example: deepseek, deepseek/deepseek-r1:free
    -- domain should probably have the same api since theyre the same company such as
    -- openai/o4-mini-high
    -- If I would have money, I would probably point this to a proper api and clean it up instead of using openrouter
    local llm, version = path_separator(index, "^(.-)/(.*)$")

    return require("neovibe.models.openrouter." .. llm)[version]
end

return openrouter
