local commandutil = require("lua_filters.commandutil")




function Pandoc(doc)
    local el = doc.meta
    -- doesn't see if it is empty; simply detects if is nil
    if (el == nil) then return doc end
    
    returnTable = {}

    print("\nMeta In File Detected! Running Detectors")
    local lookFor = {
        ["author"] = "RENEWTYPE:authorDOC",
        ["title"] = "RENEWTYPE:titleDOC",
        ["date"] = "RENEWTYPE:dateDOC",
        ["class"] = "RENEWTYPE:classDOC",
    }   
    -- loop through meta 
    print(pandoc.utils.stringify(el))
    for key, value in pairs(lookFor) do
        if el[key] ~= nil then
            local strVal = pandoc.utils.stringify(el[key])
            print("\nKey " .. key .. " detected!")
            print("Key Value " .. strVal .. " detected!")
            print("Adding command " .. value .. " to return.")
            -- Insert to returntable: Value of meta, and action of what to insert. 
            table.insert(returnTable,commandutil.findCommand(strVal,value))
        end

    end
    -- insert title content now that the commands are defined. CHANGE LATER
    table.insert(returnTable,pandoc.RawInline("latex","\\input{latex_templates/basetitle.tex}"))

    doc.blocks = pandoc.List(returnTable) .. doc.blocks

    return doc
end



return {
    Pandoc=Pandoc
}