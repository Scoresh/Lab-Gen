local commandutil = require("lua_filters.commandutil")
local tableutil = require("lua_filters.tableutil")


function Pandoc(el)
    -- loop through the element blocks and print for now
    pandocCOMMANDS = {}

    -- view pairs
    for key,value in ipairs(el.blocks) do
        -- stringify
        local stringifiedvalue = pandoc.utils.stringify(value)
        -- search for super secret delimiters
        if (stringifiedvalue:find("@!")) then
            print("A macro command has been found outside of Document Metadata. Parsing...")
            -- This is the "first" point (@!)
            fp = stringifiedvalue:find("@!")
            -- Look for the "last" point (!@)
            ep = stringifiedvalue:find("!@")
            -- check for both not nil
            if (fp == nil or ep == nil) then
                -- skip 
                print("One or both of the two is nil. Skipping....")
            else 
                -- This is where the quotes is ==> !@   Blah, Blah @!
                --                                  [^            ^]  
                fp = fp + 2
                ep = ep - 1
                -- Print out the stringified value
                print(stringifiedvalue:sub(fp,ep))
                -- find ALL of the commands
                tempTable = {}
                -- extract the commands
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
            -- just insert the pandocCOMMANDS if nothing is found to keep everything the same.
            table.insert(pandocCOMMANDS,value)
        end
    end
    -- return blocks as LIST of pandocCOMMANDS
    el.blocks = pandoc.List(pandocCOMMANDS)
    return el
end



return {
    Pandoc=Pandoc,
}