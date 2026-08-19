-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local RainbowStep = require(script.Parent.RainbowStep);

function RainbowEffect(u1, u2, p3, p4)
    -- upvalues: RainbowStep (copy), RunService (copy)
    local u5 = RainbowStep(p3, p4);
    local u6 = nil;
    u6 = RunService.RenderStepped:Connect(function(p7) -- Line: 17
        -- upvalues: u1 (copy), u2 (copy), u5 (copy), u6 (ref)
        if u1.Parent then
            u1[u2] = u5(p7);

            return;
        end;

        u6:Disconnect();
    end);

    return function() -- Line: 25
        -- upvalues: u6 (ref)
        u6:Disconnect();
    end;
end;

return RainbowEffect;