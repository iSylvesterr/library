-- Decompiled with Potassium's decompiler.

local logError = require(script.Parent.Parent.Logging.logError);

return function(u1, p2) -- Line: 12, Name: restrictRead
    -- upvalues: logError (copy)
    local v3 = getmetatable(p2);

    if v3 == nil then
        v3 = {};
        setmetatable(p2, v3);
    end;

    function v3.__index(p4, p5) -- Line: 21
        -- upvalues: logError (ref), u1 (copy)
        logError("strictReadError", nil, tostring(p5), u1);
    end;

    return p2;
end;