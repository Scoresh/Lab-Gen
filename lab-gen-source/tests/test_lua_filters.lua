-- Tests for the Lab-Gen Lua filters.
-- Run from lab-gen-source/ (pandoc supplies the `pandoc` Lua API):
--     pandoc lua tests/test_lua_filters.lua

local commandutil = require("lua_filters.commandutil")
local tableutil = require("lua_filters.tableutil")

local failures, total = 0, 0

local function check(name, actual, expected)
    total = total + 1
    if actual ~= expected then
        failures = failures + 1
        print("FAIL: " .. name)
        print("  expected: " .. tostring(expected))
        print("  actual:   " .. tostring(actual))
    end
end

local function latexOf(block) return block.text end

-- extractAllCommands -------------------------------------------------------
local found = commandutil.extractAllCommands({}, "intro @!toc !@ middle @!raw \\x !@ end")
check("extract: count", #found, 2)
check("extract: first", found[1], "@!toc !@")
check("extract: second", found[2], "@!raw \\x !@")
check("extract: returns the table", type(commandutil.extractAllCommands({}, "none")), "table")
check("extract: unterminated is ignored", #commandutil.extractAllCommands({}, "@!toc"), 0)

-- stripTableFromMacro ------------------------------------------------------
local stripped = { "@!toc !@" }
tableutil.stripTableFromMacro(stripped)
check("strip: removes delimiters", stripped[1], "toc ")

-- findCommandBLOCK: dispatch -----------------------------------------------
check("toc", latexOf(commandutil.findCommandBLOCK("toc ")), "\\tableofcontents")
check("raw passthrough", latexOf(commandutil.findCommandBLOCK("raw \\textbf{x} ")), " \\textbf{x} ")
-- Regression: a raw block containing '{' or '= ' must stay raw LaTeX.
check("raw with braces stays raw",
    latexOf(commandutil.findCommandBLOCK("raw \\foo{a} = b")), " \\foo{a} = b")
check("renew", latexOf(commandutil.findCommandBLOCK("authorDOC= Me")),
    "\\renewcommand{\\authorDOC}{ Me}")
check("brace -> newpage", latexOf(commandutil.findCommandBLOCK("{ ")), "\\newpage")
check("unknown passthrough", latexOf(commandutil.findCommandBLOCK("hello")), "hello")

-- findCommandBLOCK: images -------------------------------------------------
local img = latexOf(commandutil.findCommandBLOCK('image src="a/b.png" width=0.3'))
check("image src", img:find("{a/b.png}", 1, true) ~= nil, true)
check("image unquoted width", img:find("width=0.3\\textwidth", 1, true) ~= nil, true)

local quoted = latexOf(commandutil.findCommandBLOCK('image src="a.png" width="0.5"'))
check("image quoted width", quoted:find("width=0.5\\textwidth", 1, true) ~= nil, true)

-- Regression: width must not leak from a previous image.
local noWidth = latexOf(commandutil.findCommandBLOCK('image src="c.png"'))
check("image default width", noWidth:find("width=0.8\\textwidth", 1, true) ~= nil, true)

local noSrc = latexOf(commandutil.findCommandBLOCK("image width=0.4"))
check("image missing src uses default",
    noSrc:find("portsmouth_logo.png", 1, true) ~= nil, true)

local spaced = latexOf(commandutil.findCommandBLOCK('image src="my dir/a b.png"'))
check("image path with spaces", spaced:find("{my dir/a b.png}", 1, true) ~= nil, true)

-- findCommand (metadata) ---------------------------------------------------
check("meta renew", commandutil.findCommand("Bob", "RENEWTYPE:authorDOC").text,
    "\\renewcommand{\\authorDOC}{Bob}")
check("meta none", commandutil.findCommand("none", "RENEWTYPE:dateDOC").text,
    "\\renewcommand{\\dateDOC}{}")
check("meta command", commandutil.findCommand("x", "COMMANDTYPE:\\foo").text, "\\foo")

print(string.format("%d/%d Lua checks passed", total - failures, total))
if failures > 0 then os.exit(1) end
