-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");

return function(u1, u2, u3) -- Line: 2
    -- upvalues: RunService (copy)
    local u4 = 0;
    local u5 = nil;
    u5 = RunService.Heartbeat:Connect(function(p6) -- Line: 6
        -- upvalues: u4 (ref), u1 (ref), u3 (copy), u5 (ref), u2 (copy)
        u4 = u4 + p6;

        if u4 > 1 then
            u4 = u4 - 1;
            u1 = u1 - 1;

            if u1 <= 0 then
                if u3 then
                    u3();
                end;

                u5:Disconnect();

                return;
            end;

            if u2 then
                u2(u1);
            end;
        end;
    end);

    return function() -- Line: 24
        -- upvalues: u1 (ref)
        return u1;
    end, function() -- Line: 26
        -- upvalues: u5 (ref)
        u5:Disconnect();
    end;
end;