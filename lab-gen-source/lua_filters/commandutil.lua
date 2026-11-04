-- UTILITY FOR COMMANDS
local dbg = require("lua_filters.debug")

local DEFAULT_IMAGE = "lab-gen-source/images/portsmouth_logo.png"
local DEFAULT_WIDTH = 0.8

-- Collect every "@!...!@" span found in `stringifiedvalue` into `inputTable`.
-- Returns `inputTable` (it is also filled in place, so existing callers that
-- ignore the return value keep working).
local function extractAllCommands(inputTable, stringifiedvalue)
    dbg.log("Beginning an Extraction.")
    local init = 1
    while true do
        local fp = stringifiedvalue:find("@!", init, true)
        if fp == nil then
            dbg.log("Exit ticket found! Exiting...")
            return inputTable
        end
        -- The closing marker must come after the opening one.
        local ep = stringifiedvalue:find("!@", fp + 2, true)
        if ep == nil then
            dbg.warn("A macro starting with '@!' has no closing '!@'. Ignoring the rest of this block.")
            return inputTable
        end
        dbg.log(stringifiedvalue:sub(fp, ep + 1))
        table.insert(inputTable, stringifiedvalue:sub(fp, ep + 1))
        init = ep + 2
    end
end


-- Parse the body of an @!image macro, e.g.
--     image src="path/to/file.png" width=0.5
-- `width` may optionally be quoted. Missing/invalid parts fall back to defaults
-- so a LaTeX figure is always produced.
local function parseImage(value)
    dbg.log("Image found! Parsing...")
    local image_path = DEFAULT_IMAGE
    local width = DEFAULT_WIDTH

    local src = value:match('src%s*=%s*"([^"]*)"')
    if src == nil then
        dbg.warn('@!image is missing a quoted src="..." value. Using the default image.')
    else
        image_path = src
    end

    local rawWidth = value:match("width%s*=%s*\"?([%d%.]+)\"?")
    if rawWidth ~= nil then
        local parsed = tonumber(rawWidth)
        if parsed == nil then
            dbg.warn("Image width '" .. rawWidth .. "' is not a number. Defaulting to " .. DEFAULT_WIDTH)
        else
            width = parsed
        end
    else
        dbg.log("No width found... Defaulting to " .. DEFAULT_WIDTH)
    end

    local latex = "\\begin{figure}[htbp]\n"
        .. "\t \\centering\n"
        .. "\t \\includegraphics[width=" .. width .. "\\textwidth]{" .. image_path .. "}\n"
        .. "\\end{figure}\n\n"

    return pandoc.RawBlock("latex", latex)
end


-- Command handlers, keyed by the command NAME (the first word of the macro).
-- Each handler receives the whole macro body (name included).
local handlers = {
    -- @!raw \\LaTeX ... !@   -> everything after "raw" is passed through as LaTeX
    raw = function(body)
        return pandoc.RawBlock("latex", body:sub(4))
    end,
    -- @!image src="..." width=0.5 !@
    image = parseImage,
    -- @!toc !@
    toc = function()
        return pandoc.RawBlock("latex", "\\tableofcontents")
    end,
}


-- Turn the body of one macro into a Pandoc block.
--
-- Dispatch is on the leading command name, never on a substring anywhere in
-- the body, so (for example) a `@!raw` block containing `{` or `= ` is always
-- treated as raw LaTeX. Bodies with no recognised name fall back to:
--   "name= value" -> \renewcommand{\name}{ value}
--   body with "{" -> \newpage
--   anything else -> passed through as raw LaTeX
local function findCommandBLOCK(value)
    dbg.log(value)
    local trimmed = value:gsub("^%s+", "")
    local name = trimmed:match("^(%a+)")

    if name ~= nil and handlers[name] ~= nil then
        return handlers[name](trimmed)
    end

    local _, eI = trimmed:find("= ", 1, true)
    if eI ~= nil then
        local eq = trimmed:find("=", 1, true)
        return pandoc.RawBlock("latex",
            "\\renewcommand{\\" .. trimmed:sub(1, eq - 1) .. "}{" .. trimmed:sub(eq + 1) .. "}")
    end

    if trimmed:find("{", 1, true) ~= nil then
        return pandoc.RawBlock("latex", "\\newpage")
    end

    return pandoc.RawBlock("latex", value)
end


local function insertCommands(pandocCommandTable, inputTable)
    for _, value in ipairs(inputTable) do
        table.insert(pandocCommandTable, findCommandBLOCK(value))
    end
end


-- Build the LaTeX \renewcommand for a metadata field.
--   commandAction is "RENEWTYPE:<latexName>" or "COMMANDTYPE:<raw latex>".
local function findCommand(metaString, commandAction)
    dbg.log("Custom Extract Command Found! Extracting...")
    local renewPrefix = "RENEWTYPE:"
    local commandPrefix = "COMMANDTYPE:"

    if commandAction:sub(1, #renewPrefix) == renewPrefix then
        local name = commandAction:sub(#renewPrefix + 1)
        dbg.log("Command variable editing: " .. name)
        if metaString == "none" then
            return pandoc.RawInline("latex", "\\renewcommand{\\" .. name .. "}{}")
        end
        return pandoc.RawInline("latex", "\\renewcommand{\\" .. name .. "}{" .. metaString .. "}")
    end
    if commandAction:sub(1, #commandPrefix) == commandPrefix then
        return pandoc.RawInline("latex", commandAction:sub(#commandPrefix + 1))
    end
    dbg.warn("Unrecognised metadata command action for value '" .. metaString .. "'")
    return pandoc.RawInline("latex", "")
end


return {
    findCommand = findCommand,
    findCommandBLOCK = findCommandBLOCK,
    extractAllCommands = extractAllCommands,
    insertCommands = insertCommands,
}
