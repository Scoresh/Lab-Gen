-- UTILITY FOR COMMANDS

function extractAllCommands(inputTable,stringifiedvalue)
    print("Beginning an Extraction.")
    fp = stringifiedvalue:find("@!")
    if (fp == nil) then 
        print("Exit ticket found! Exiting...")
        return inputTable
    end
    ep = stringifiedvalue:find("!@")
    if (ep == nil) then
        -- store into FP; 
        print("ERROR: NO EXIT TICKET FOUND... PLEASE INSERT A !@... Exiting...")
        return inputTable
    else 
        print(stringifiedvalue:sub(fp,ep+1))
        table.insert(inputTable,stringifiedvalue:sub(fp,ep+1))
        extractAllCommands(inputTable,stringifiedvalue:sub(ep+1))
    end
end    




local function findCommandBLOCK(value)
    print(value)
    local lookFor = {
        ["raw"] = "RAWTYPE",
        ["= "] = "RENEWTYPE",
        ["{"] = "LISTTYPE",
        ["toc"] = "\\tableofcontents",
    }
    for key,valued in pairs(lookFor) do
        if (value:find(key) ~= nil) then
            if (valued:find("RAWTYPE") and value:find(key) == 1) then
                --begin from raw
                return pandoc.RawBlock("latex",value:sub(4))
            elseif (valued:find("RENEWTYPE")) then
                fI,eI = value:find("=")
                return pandoc.RawBlock("latex","\\renewcommand{\\" .. value:sub(1,eI-1) .. "}{" .. value:sub(eI+1) .. "}")
            elseif (valued:find("LISTTYPE")) then
                return pandoc.RawBlock("latex","\\newpage")
            else
                return pandoc.RawBlock("latex",valued)
            end
        end
    end
    return pandoc.RawBlock("latex",value)

end


function insertCommands(pandocCommandTable,inputTable) 
    for key,value in pairs(inputTable) do
        table.insert(pandocCommandTable, findCommandBLOCK(value) )
    end
end



function findCommand(metaString,commandAction)
    print("Custom Extract Command Found! Extracting...")
    if commandAction:find("RENEWTYPE:") then
        local firstIndex,lastIndex = string.find(commandAction,"RENEWTYPE:")
        commandAction = string.sub(commandAction,lastIndex+1)
        print("Command variable editing: " .. commandAction)
        if (metaString == "none") then return pandoc.RawInline("latex","\\renewcommand{\\" .. commandAction .. "}{}") end
        print("\\renewcommand{\\" .. commandAction .. "}{" .. metaString .. "}")
        return pandoc.RawInline("latex","\\renewcommand{\\" .. commandAction .. "}{" .. metaString .. "}")
    end
    if (commandAction:find("COMMANDTYPE:")) then
        local firstIndex,lastIndex = string.find(commandAction,"COMMANDTYPE:")
        commandAction = string.sub(commandAction,lastIndex+1)
        return pandoc.RawInline("latex",commandAction)
    end
    print("An error occured while detecting metaString " .. metaString)
    return pandoc.RawInline("latex","")
end


return{
    findCommand=findCommand,
    extractAllCommands=extractAllCommands,
    insertCommands=insertCommands,


}