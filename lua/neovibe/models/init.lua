local indexer = require("neovibe.common").separate

local models = {}
local meta = {}

setmetatable(models, meta)

function meta.__index(self, index)

    local domain, sub = indexer(index, "^(.-)::(.*)$")

    if sub then
        return require("neovibe.models." .. domain)[sub]
    end

    local llm, model = indexer(index, "^(.-)/(.*)$")

    return require("neovibe.models." .. llm)[model]
end

return models
