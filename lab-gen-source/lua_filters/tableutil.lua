-- UTILITY FOR TABLES
local dbg = require("lua_filters.debug")

-- Replace each "@!body!@" entry in the list with just "body".
-- Entries without both delimiters are left unchanged.
local function stripTableFromMacro(tabled)
    for key, value in ipairs(tabled) do
        local fp = value:find("@!", 1, true)
        local ep = value:find("!@", 1, true)
        if fp ~= nil and ep ~= nil then
            tabled[key] = value:sub(fp + 2, ep - 1)
        end
    end
end

-- Print a list (debug only).
local function printTable(tabled)
    for _, value in ipairs(tabled) do
        dbg.log(value)
    end
end

-- Return the functions
return {
    stripTableFromMacro = stripTableFromMacro,
    printTable = printTable,
}
