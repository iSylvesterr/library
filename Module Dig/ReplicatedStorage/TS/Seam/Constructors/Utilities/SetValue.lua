-- Decompiled with Potassium's decompiler.

return setmetatable({}, {
    __call = function(p1, p2, p3) -- Line: 8, Name: __call
        if p2 == nil then
            return p3;
        end;

        if typeof(p2) == "table" and p2.Value ~= nil then
            p2.Value = p3;
        end;

        return p3;
    end,

    __index = function(p4, p5) -- Line: 20, Name: __index
        if p5 == "__SEAM_CAN_BE_SCOPED" then
            return false;
        end;

        return nil;
    end
});