-- UTILITY FOR TABLES

function stripTableFromMacro(tabled) 
    for key,value in pairs(tabled) do
        if (tabled[key]:find("@!") == nil) then
            print("Pass; ")
        elseif (tabled[key]:find("!@") ~= nil) then
            tabled[key] = value:sub(tabled[key]:find("@!")+2,tabled[key]:find("!@")-1);
        end
    end
end

-- Print a table by sorting through key, value pairs
function printTable(tabled)
    for key,value in pairs(tabled) do
        print(value)
    end
end

-- Return the functions 
return {
    stripTableFromMacro=stripTableFromMacro,
    printTable=printTable,
}