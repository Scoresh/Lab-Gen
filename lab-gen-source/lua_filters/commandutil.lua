



function findCommand(metaString,commandAction)
    print("Custom Extract Command Found! Extracting...")
    if commandAction:find("RENEWTYPE:") then
        local firstIndex,lastIndex = string.find(commandAction,"RENEWTYPE:")
        commandAction = string.sub(commandAction,lastIndex+1)
        print("Command variable editing: " .. commandAction)
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
}