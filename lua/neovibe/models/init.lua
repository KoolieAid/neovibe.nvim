local indexer = require("neovibe.common").separate

local models = {}
local meta = {}

setmetatable(models, meta)

function meta.__index(self, index)

    local domain, sub = indexer(index, "^(.-)::(.*)$")

    if sub then
        return require("neovibe.models." .. domain)[sub]
    end

    return require("neovibe.models." .. index)
end

return models
