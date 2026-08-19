-- Decompiled with Potassium's decompiler.

return (function(p1) -- Line: 1, Name: readonlytable
    return setmetatable({}, {
        __metatable = false,
        __index = p1,

        __newindex = function(p2, p3, p4) -- Line: 5, Name: __newindex
            error("Attempt to modify read-only table: " .. p2 .. ", key=" .. p3 .. ", value=" .. p4);
        end
    });
end)({
    Start = "Start",
    Complete = "Complete",
    Fail = "Fail"
});