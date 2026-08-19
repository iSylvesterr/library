-- Decompiled with Potassium's decompiler.

local messages = require(script.Parent.Parent.Logging.messages);

return function(p1, ...) -- Line: 10, Name: logWarn
    -- upvalues: messages (copy)
    local v2;

    if messages[p1] == nil then
        p1 = "unknownMessage";
        v2 = messages[p1];
    else
        v2 = messages[p1];
    end;

    warn(string.format("[Fusion] " .. v2 .. "\n(ID: " .. p1 .. ")", ...));
end;