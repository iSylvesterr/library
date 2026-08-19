-- Decompiled with Potassium's decompiler.

local function ErrorHandler(p1) -- Line: 20
    warn((`{tostring(p1)}\nStack Begin\n{debug.traceback(nil, 3)}Stack End`));
end;

return function(p2, ...) -- Line: 24, Name: WCall
    -- upvalues: ErrorHandler (copy)
    return xpcall(p2, ErrorHandler, ...);
end;