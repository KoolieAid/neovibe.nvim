local api = {}
local http = require("plenary.curl")
local json = vim.json

local memory = {}
local system_prompt =
[[
You are an AI that is supposed to set, modify, and evaluate lua commands
in the latest Neovim version.
Essentially a prompt converter that converts prompts into lua commands
The input is expected to be a prompt that requests a setting, option, or a command that modifies a
Neovim configuration

Responses should be in just in the Lua programming language, do not provide Vimscript or VimL Responses
You are not limited to only 1 line of code. You can have multiple lines of code to change settings in just 1 response.

Do not make use deprecated API functions. Do not make up API functions on your own unless provided by the user.
Do not explain your code in plaintext, only output in VALID lua code that uses the Neovim API. Do not use markdown in your response
You are allowed to add comments to the code, but not in plaintext
]]

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

-- Initial system prompt
append_message(memory, "system", system_prompt)

local function process_response(raw_response)

    if raw_response.status ~= 200 then
        vim.notify(raw_response.body.error.message, vim.log.levels.ERROR)
    end

    if raw_response.body.error then
        vim.notify(raw_response.body.error.code .. ": " ..  raw_response.body.error.message, vim.log.levels.ERROR)
        return
    end

    local response = raw_response.body.choices[1].message.content
    append_message(memory, "assistant", response)

    local code_string = string.match(response, "```lua(.*)```")

    vim.notify("Generated code: " .. code_string, vim.log.levels.DEBUG)

    local fn, syntax_error = load(code_string)
    if not fn then
        vim.notify(syntax_error, vim.log.levels.ERROR)
        return
    end

    return fn
end

local function do_raw_request(model, messages, key)
    local body = {
        response_format = { type = 'json_object' },
        model = "deepseek/deepseek-prover-v2:free",
        messages = messages,
        temperature = 0.3,
    }

    local full_payload = http.post({
        -- Remove once done
        -- dry_run = true,
        url = "https://openrouter.ai/api/v1/chat/completions",
        headers = {
            ['Content-Type'] = "application/json",
            Authorization = "Bearer " .. key,
        },
        body = json.encode(body),
    })

    -- Body returns a string idk why
    full_payload.body = json.decode(full_payload.body)

    return process_response(full_payload)
end

function api.request(ctx, prompt)
    local req = {
        func = nil, -- Will be nil if status not 200
        status = nil, -- Error code; 200 is ok
        error = nil, -- Table / string
    }

    append_message(memory, "user", prompt)
    local fn = do_raw_request(nil, memory, ctx.key)

    -- Maybe I should put it in raw request
    -- And have it call a func in [models]
    if not fn then
        req.status = 1
        req.error = "Unexpected error occurred"
        return req
    end

    req.func = fn
    req.status = 200
    return req
end

return api
