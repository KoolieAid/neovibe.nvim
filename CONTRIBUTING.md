# Contributing to Neovibe

Available APIs:
`require("neovibe.common")`
Returns a table that has the common functions:
path_separator(string, string)
    - separates a text into 2 parts, by the separator
    - Honestly this is just a string.match underneath the hood

append_message(table, string, string)
 - This is just a table insert
 - Useful for adding stuff in the message history
 - Usage: `append_message(require("neovibe.api).history(), "user", "some stuff")

 require("neovibe.api").history()
    - This is a function BTW
    - Used to get the history of the requests

# How to add an endpoint API
The library expects a module to return a table with 2 functions.
1. parse_request(context, message_history)
    context is a table where the key is stored, along with other opts from setup.
    message_history is where you pass in the history

    returns:
    a request table that includes the link, headers, and other info related to the API.
    This table is then passed into `plenary.curl`'s post function.

2. parse_response(response)
    response is the response returned by `plenary.curl`'s post. It is up to the endpoint author to clean it up
    The normal return type should be a function that is loaded by `load(string)` already.
    I made it like this because some LLM api's are not that consistent with others y'know

    returns:
    fn, err
    fn: The function that is generated (To be executed later on)
    err: if there an error on loading, fn should be nil, and err should return the error

Files should be under the models folder
