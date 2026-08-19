-- Decompiled with Potassium's decompiler.

return setmetatable({}, {
    __call = function(p1, u2) -- Line: 8, Name: __call
        local u3 = nil;

        return setmetatable({
            Destroy = function() -- Line: 12, Name: Destroy
                -- upvalues: u3 (ref)
                if u3 and u3.Connected then
                    u3:Disconnect();
                end;
            end
        }, {
            __call = function(p4, p5, p6) -- Line: 18, Name: __call
                -- upvalues: u3 (ref), u2 (copy)
                if not u3 then
                    u3 = p5[u2]:Connect(p6);

                    return u3;
                end;
            end,

            __index = function(p7, p8) -- Line: 30, Name: __index
                return p8 == "__SEAM_INDEX" and "OnEvent" or nil;
            end
        });
    end,

    __index = function(p9, p10) -- Line: 42, Name: __index
        return p10 == "__SEAM_CAN_BE_SCOPED" and true or nil;
    end
});