local api = require("neovibe.api")
local models = require("neovibe.models")

-- Not used yet idk, maybe on refactor
local model = models["deepseek"]

local vibe = {
    key = nil,
}

local function process(input)
    vim.cmd("redraw!")
    local req = api.request("deepseek-chat", input, { key = vibe.key })

    if not req.func then
        return
    end
    local status, err = pcall(req.func)

    if not status then
        vim.notify("Function call error: " .. err, vim.log.levels.ERROR)
    end
end

vim.api.nvim_create_user_command("Vibe", function(args)

    if #args.fargs > 0 then
        process(args.args)
    else
        vim.ui.input({
            prompt = "Enter prompt:",
        }, process)
    end

end, { nargs = "*" })

function vibe.setup(opts)
    vibe = opts

end

return vibe
