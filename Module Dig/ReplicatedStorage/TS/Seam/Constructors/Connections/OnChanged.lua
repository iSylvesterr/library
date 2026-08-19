-- Decompiled with Potassium's decompiler.

return setmetatable({}, {
    __call = function(p1, u2, u3) -- Line: 8, Name: __call
        return u2.Changed:Connect(function(p4) -- Line: 12
            -- upvalues: u3 (copy), u2 (copy)
            u3(p4, u2[p4]);
        end);
    end,

    __index = function(p5, p6) -- Line: 18, Name: __index
        return p6 == "__SEAM_INDEX" and "OnChanged" or (p6 == "__SEAM_CAN_BE_SCOPED" and true or nil);
    end
});