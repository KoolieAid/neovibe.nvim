### I am not proud of this
This is definitely my Frankenstein's monster

# Neovibe
Plugin where you ask AI to change some settings and they do it for you

Ever had a time where you wan't to change something in your config temporarity but don't want to read the docs?
Well now you can just ask someone else to do it for you

As ironic as this sounds, this plugin is not vibe coded. I don't use AI to write code for me.

The use case for this plugin is questionable honestly since vimmers usually read docs and dive deep into the ecosystem
Maybe for the devs who want a one time change but don't want to search the internet on how to do it

I am not held accountable for the code that the AI gives.

## Prerequisite
1. `nvim-lua/plenary.nvim`
2. LLM API Key

# Models
Right now, the available api is the openrouter version of deepseek prover v2. Why? cuz it's free
Maybe if i get money i can implement more models such as the real deepseek api, openai, and gemini
Or you can contribute your the api endpoints in the `models` folder

- `openrouter::deepseek/*` Note: Only prover v2:free and deepseek-r1:free are tested
- `openai/*` - None of these are tested btw. I don't have a money to afford tokens to test it

## Future
I cannot promise that I will be working on this project full-time since this is literally just a pet project

1. Maybe have a runtime path and add files and directories there so the AI code can persist.
2. Crazy idea: vibe an entire config (bad idea)

# Usage
Currently only tested openrouter free API, since I don't have money to afford a real LLM API.
```lua
{
    "KoolieAid/neovibe.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- Defaults
    opts = {
        key = "",
        model = "openrouter::deepseek/deepseek-r1:free",
        temperature = 0.3,
    }
}
```
