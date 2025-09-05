local commandutil = require("lua_filters.commandutil")
local tableutil = require("lua_filters.tableutil")


function Pandoc(el)
    -- loop through the element blocks and print for now
    pandocCOMMANDS = {}


    for key,value in ipairs(el.blocks) do
        local stringifiedvalue = pandoc.utils.stringify(value)
        if (stringifiedvalue:find("@!")) then
            print("A macro command has been found outside of Document Metadata. Parsing...")
            fp = stringifiedvalue:find("@!")

            ep = stringifiedvalue:find("!@")
            if (fp == nil or ep == nil) then
                -- store into FP; 
                print("One or both of the two is nil. Skipping....")
            else 
                fp = fp + 2
                ep = ep - 1
                print(stringifiedvalue:sub(fp,ep))
                tempTable = {}
                commandutil.extractAllCommands(tempTable,stringifiedvalue)
                print("PRE AXATION ==> ")
                tableutil.printTable(tempTable)
                print("POST AXATION ==> ")
                tableutil.stripTableFromMacro(tempTable)
                tableutil.printTable(tempTable)
                -- store into 
                commandutil.insertCommands(pandocCOMMANDS,tempTable)

            end
        else 
            table.insert(pandocCOMMANDS,value)
        end
    end
    el.blocks = pandoc.List(pandocCOMMANDS)
    return el
end



return {
    Pandoc=Pandoc,
}