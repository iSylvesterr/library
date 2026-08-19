-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(u1, p2) -- Line: 6
    -- upvalues: Asserts (copy), RunService (copy)
    Asserts.GuiObject(u1);
    Asserts.optional.number(p2);
    local Size = u1.Size;
    local u3 = 0;
    u1:GetAttributeChangedSignal("TargetFill"):Connect(function() -- Line: 13
        -- upvalues: u3 (ref), u1 (copy), Asserts (ref), Size (copy)
        u3 = u1:GetAttribute("TargetFill");
        Asserts.number(u3);

        if u3 < u1.Size.X.Scale then
            u1.Size = UDim2.new(u3, Size.X.Offset, Size.Y.Scale, Size.Y.Offset);
        end;
    end);
    local u4 = p2 or 10;
    local u6 = RunService.RenderStepped:Connect(function(p5) -- Line: 23
        -- upvalues: u1 (copy), u3 (ref), u4 (copy), Size (copy)
        local Scale = u1.Size.X.Scale;

        if math.abs(Scale - u3) >= 0.01 then
            u1.Size = UDim2.new(Scale + (u3 - Scale) * (1 - math.exp(-u4 * p5)), Size.X.Offset, Size.Y.Scale, Size.Y.Offset);
        end;
    end);

    return function() -- Line: 35
        -- upvalues: u6 (copy)
        u6:Disconnect();
    end;
end;