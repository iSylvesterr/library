-- Decompiled with Potassium's decompiler.

return setmetatable({}, {
    __call = function(p1, p2, u3) -- Line: 8, Name: __call
        return p2.AttachedToInstance:Connect(function(...) -- Line: 9
            -- upvalues: u3 (copy)
            u3(...);
        end);
    end,

    __index = function(p4, p5) -- Line: 15, Name: __index
        return p5 == "__SEAM_INDEX" and "OnAttached" or (p5 == "__SEAM_CAN_BE_SCOPED" and true or nil);
    end
});