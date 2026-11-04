-- DEBUG LOGGING FOR THE LAB-GEN FILTERS
--
-- The filters used to print on nearly every branch. That output is now silent
-- by default; enable it by setting the LABGEN_DEBUG environment variable
-- (any non-empty value other than "0"), e.g. in cmd:
--     set LABGEN_DEBUG=1 && generate.bat -file MyLab

local flag = os.getenv("LABGEN_DEBUG")
local enabled = (flag ~= nil and flag ~= "" and flag ~= "0")

local M = {}

-- Print a debug message (only when LABGEN_DEBUG is set).
function M.log(...)
    if enabled then
        print(...)
    end
end

-- Print a warning. Always shown, since it means something in the user's
-- document was malformed.
function M.warn(msg)
    io.stderr:write("[LabGen warning] " .. tostring(msg) .. "\n")
end

M.enabled = enabled

return M
