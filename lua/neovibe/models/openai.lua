local json = vim.json
local openai = {}
local meta = {}
setmetatable(openai, meta)

local function generate_module(version)
    return {
        parse_request = function(ctx, message_history)
            local body = {
                model = version,
                -- Yea I'm skeptical of this
                text_format = "lua_code",
                input = message_history,
            }

            return {
                url = "https://api.openai.com/v1/responses",
                headers = {
                    ['Content-Type'] = "application/json",
                    Authorization = "Bearer " .. ctx.key,
                },
                stream = false,
                body = json.encode(body),
            }
        end,

        parse_response = function(response)
            response.body = json.decode(response.body)

            -- Boy i don't have a real way to find the error paths of the API (no keys)
            if response.body.error then
                return nil, response.body.error.code .. ": " .. response.body.error.message
            end

            local content = response.body.output[1].content[1].text
            require("neovibe.common").append_message(require("neovibe.api").history, "assistant", content)

            if not content then
                return nil, "Content is nil, Generated content: " .. response
            end

            vim.notify("Generated code: " .. content, vim.log.levels.DEBUG)

            local fn, syn_error = load(content)
            if not fn then
                return nil, syn_error
            end

            return fn
        end
    }
end

function meta.__index(self, version)
    return generate_module(version)
end

return openai
