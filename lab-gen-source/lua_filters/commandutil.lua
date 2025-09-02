



function findCommand(element,commandName,commandAction)
    print("Custom Extract Command Found! Extracting...")
    local command = pandoc.utils.stringify(element)
    if (commandAction:find("COMMANDTYPE:")) then
        print("Command Type Found.")
        return pandoc.RawInline("latex",string.sub(commandAction,#"COMMANDTYPE:"+1))
    end


    sIndex,eIndex = string.find(command,commandName)
    -- Shift End Index by 1
    command = string.sub(command,eIndex+1)
    print("VALUE OF COMMAND: " .. command)



    print("No command was found: " .. command)
end


return{
    findCommand=findCommand,
}