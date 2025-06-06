local api = require("neovibe.api")

local vibe = {
    key = "",
    temperature = 0.3,
    model = "openrouter::deepseek/deepseek-prover-v2:free",
}

local function process(input)
    local req = api.request(vibe, input)

    if req.status ~= 200 then
        vim.notify("Request failed: " .. req.error, vim.log.levels.ERROR)
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
    if not opts.key then
        vim.notify("API key was not provided", vim.log.levels.ERROR)
    end

    vibe.key = opts.key

    if opts.model then
        vibe.model = opts.model
    end

    if not opts.temperature then
        vibe.temperature = opts.temperature
    end

end

return vibe
