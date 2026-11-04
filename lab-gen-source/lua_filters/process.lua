local commandutil = require("lua_filters.commandutil")
local tableutil = require("lua_filters.tableutil")
local dbg = require("lua_filters.debug")


-- Replace any block containing "@!...!@" macros with the LaTeX they expand to.
-- Blocks without macros are passed through unchanged.
function Pandoc(el)
    local pandocCOMMANDS = {}

    for _, value in ipairs(el.blocks) do
        local stringifiedvalue = pandoc.utils.stringify(value)
        if stringifiedvalue:find("@!", 1, true) then
            dbg.log("A macro command has been found outside of Document Metadata. Parsing...")
            local fp = stringifiedvalue:find("@!", 1, true)
            local ep = stringifiedvalue:find("!@", fp + 2, true)
            if ep == nil then
                dbg.warn("Found '@!' without a closing '!@'; leaving this block as-is: "
                    .. stringifiedvalue:sub(1, 60))
                table.insert(pandocCOMMANDS, value)
            else
                local tempTable = commandutil.extractAllCommands({}, stringifiedvalue)
                dbg.log("PRE AXATION ==> ")
                tableutil.printTable(tempTable)
                tableutil.stripTableFromMacro(tempTable)
                dbg.log("POST AXATION ==> ")
                tableutil.printTable(tempTable)
                commandutil.insertCommands(pandocCOMMANDS, tempTable)
            end
        else
            -- Nothing to expand: keep the block exactly as it was.
            table.insert(pandocCOMMANDS, value)
        end
    end

    el.blocks = pandoc.List(pandocCOMMANDS)
    return el
end


return {
    Pandoc = Pandoc,
}
