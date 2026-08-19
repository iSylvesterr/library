-- Decompiled with Potassium's decompiler.

return setmetatable({}, {
    __call = function(p1, u2, u3) -- Line: 8, Name: __call
        if not u3 then
            error("Expected DebugName, got nil");
        end;

        return u2.Changed:Connect(function(p4) -- Line: 13
            -- upvalues: u3 (copy), u2 (copy)
            if p4 then
                print((`SEAM_INSPECT | {u3} | Value changed to {u2[p4]}`));

                return;
            end;

            print((`SEAM_INSPECT | {u3} | Value changed, unknown property that changed`));
        end);
    end,

    __index = function(p5, p6) -- Line: 23, Name: __index
        return p6 == "__SEAM_CAN_BE_SCOPED" and true or nil;
    end
});