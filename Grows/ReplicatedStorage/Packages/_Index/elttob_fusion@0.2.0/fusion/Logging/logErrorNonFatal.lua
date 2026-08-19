-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.Types);
local messages = require(Parent.Logging.messages);

return function(p1, p2, ...) -- Line: 11, Name: logErrorNonFatal
    -- upvalues: messages (copy)
    local v3;

    if messages[p1] == nil then
        p1 = "unknownMessage";
        v3 = messages[p1];
    else
        v3 = messages[p1];
    end;

    local u4;

    if p2 == nil then
        u4 = string.format("[Fusion] " .. v3 .. "\n(ID: " .. p1 .. ")", ...);
    else
        local v5 = v3:gsub("ERROR_MESSAGE", p2.message);
        u4 = string.format("[Fusion] " .. v5 .. "\n(ID: " .. p1 .. ")\n---- Stack trace ----\n" .. p2.trace, ...);
    end;

    task.spawn(function(...) -- Line: 29
        -- upvalues: u4 (ref)
        error(u4:gsub("\n", "\n    "), 0);
    end, ...);
end;