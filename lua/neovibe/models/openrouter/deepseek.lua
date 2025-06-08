-- Openrouter deepseek APIs

local json = vim.json
local deepseek = {}
local meta = {}
setmetatable(deepseek, meta)

local append = require("neovibe.common").append_message

local function generate_module(version)
    return {
        parse_request = function(ctx, message_history)

            local body = {
                -- response_format = { type = 'json_object' },
                model = "deepseek/" .. version,
                messages = message_history,
                temperature = ctx.temperature,
            }

            return {
                url = "https://openrouter.ai/api/v1/chat/completions",
                headers = {
                    ['Content-Type'] = "application/json",
                    Authorization = "Bearer " .. ctx.key,
                },
                body = json.encode(body),
            }

        end,
        parse_response = function(response)
            -- Clean up body
            -- Body returns a string idk why
            response.body = json.decode(response.body)

            -- Handle openrouter errors
            if response.status ~= 200 then
                return nil, response.body.error.message
            end

            -- Handle deepseek api errors
            if response.body.error then
                return nil, response.body.error.code .. ": " .. response.body.error.message
            end

            local content = response.body.choices[1].message.content
            append(require("neovibe.api").history(), "assistant", content)

            -- Some models really be stuborn and include this and some don't. I swear AI makes me mald
            local code_block = string.match(content, "```lua(.*)```")
            -- So let's just risk it lmao
            if not code_block then
                code_block = content
            end

            if not code_block then
                return nil, "Code block is nil. Generated content: " .. content
            end

            vim.notify("Generated code: " .. code_block, vim.log.levels.DEBUG)

            local fn, syntax_error = load(code_block)
            if not fn then
                return nil, syntax_error
            end

            return fn
        end,
    }
end

-- version would theoretically be gpt-4.1 of openai/gpt-4.1
function meta.__index(self, version)
    return generate_module(version)
end

return deepseek
