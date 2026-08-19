-- Decompiled with Potassium's decompiler.

return setmetatable({}, {
    __call = function(p1, p2) -- Line: 8, Name: __call
        if typeof(p2) == "table" then
            return p2.__SEAM_COMPONENT and true or false;
        end;

        return false;
    end,

    __index = function(p3, p4) -- Line: 20, Name: __index
        if p4 == "__SEAM_CAN_BE_SCOPED" then
            return false;
        end;

        return nil;
    end
});