-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local GetHolder = require(script.Parent.GetHolder);
local Pulse = ReplicatedStorage.Assets.UI.OTHER.Shockwave.Pulse;

return function(u1, p2, p3, p4) -- Line: 21
    -- upvalues: Pulse (copy), GetHolder (copy), Tween (copy), RunService (copy)
    local u5 = Pulse:Clone();
    local u6 = p2 or 1;
    local u7 = p3 or 0;
    local u8 = 15 * (p4 or 1);
    u5.UIScale.Scale = 0;
    u5.Size = UDim2.fromOffset(u1.AbsoluteSize.X, u1.AbsoluteSize.Y);
    u5.Position = UDim2.new(0, u1.AbsolutePosition.X + u1.AbsoluteSize.X / 2, 0, u1.AbsolutePosition.Y + u1.AbsoluteSize.Y / 2);
    u5.Parent = GetHolder();
    task.spawn(function() -- Line: 43
        -- upvalues: u5 (copy), u7 (copy), Tween (ref), u6 (copy), u8 (copy)
        u5.ImageTransparency = u7;
        Tween(u5, {
            ImageTransparency = 1
        }, { u6, "Sine", "Out" });
        Tween(u5.UIScale, {
            Scale = u8
        }, { u6, "Sine", "Out" }).Completed:Wait();
        u5:Destroy();
    end);
    task.spawn(function() -- Line: 62
        -- upvalues: u5 (copy), u1 (copy), RunService (ref)
        while u5.Parent do
            u5.Position = UDim2.new(0, u1.AbsolutePosition.X + u1.AbsoluteSize.X / 2, 0, u1.AbsolutePosition.Y + u1.AbsoluteSize.Y / 2);
            RunService.RenderStepped:Wait();
        end;
    end);

    return u5;
end;