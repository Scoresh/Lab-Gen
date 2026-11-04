local commandutil = require("lua_filters.commandutil")
local dbg = require("lua_filters.debug")


-- Metadata fields we look for, and the LaTeX command each one renews.
local lookFor = {
    ["author"] = "RENEWTYPE:authorDOC",
    ["title"]  = "RENEWTYPE:titleDOC",
    ["date"]   = "RENEWTYPE:dateDOC",
    ["class"]  = "RENEWTYPE:classDOC",
    ["quote"]  = "RENEWTYPE:quoteDOC",
}


-- Preprocess! Reads the document metadata and prepends the LaTeX that
-- configures the title page.
function Pandoc(doc)
    local el = doc.meta
    -- doesn't see if it is empty; simply detects if is nil
    if el == nil then return doc end

    local returnTable = {}
    dbg.log("\nMeta In File Detected! Running Detectors")
    dbg.log(pandoc.utils.stringify(el))
    for key, value in pairs(lookFor) do
        if el[key] ~= nil then
            local strVal = pandoc.utils.stringify(el[key])
            dbg.log("\nKey " .. key .. " detected!")
            dbg.log("Key Value " .. strVal .. " detected!")
            dbg.log("Adding command " .. value .. " to return.")
            table.insert(returnTable, commandutil.findCommand(strVal, value))
        end
    end
    -- insert title content now that the commands are defined. CHANGE LATER
    table.insert(returnTable, pandoc.RawInline("latex", "\\input{latex_templates/basetitle2.tex}"))

    doc.blocks = pandoc.List(returnTable) .. doc.blocks

    return doc
end


return {
    Pandoc = Pandoc
}
