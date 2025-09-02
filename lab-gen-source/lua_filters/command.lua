
local commandutil = require("lua_filters.commandutil")

function RawInline(el)
    local lookFor = {
        ["@!author="] = "RENEWTYPE:authorDOC",
        ["@!title="] = "RENEWTYPE:titleDOC",
        ["@!date="] = "RENEWTYPE:dateDOC",
        ["@!class="] = "RENEWTYPE:classDOC",
        ["@!toc"] = "COMMANDTYPE:\\tableofcontents\n\\newpage"
    }    
    

    elementText = string.lower(pandoc.utils.stringify(el.content))
    -- First, we should determine if it remotely looks like a command. Look for a !@
    if elementText:find("@!") then
        print("Macro command found.")
        for key,value in pairs(lookFor) do
            if (elementText:find(key)) then
                return commandutil.findCommand(el,key,value)
            end
        end
        print("Unknown Macro Command Found. Returning Command as String.")


    end
    return el
end




return {
    Pandoc=Pandoc,
    RawInline=RawInline,
}