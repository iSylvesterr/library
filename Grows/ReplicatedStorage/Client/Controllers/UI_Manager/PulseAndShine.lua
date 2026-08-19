-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Packages = ReplicatedStorage:WaitForChild("Packages");
ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
local Effects = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Effects");
local Maid = require(Packages:WaitForChild("Maid"));
local ShineV1Shine = Effects:WaitForChild("ShineV1Shine");
local u1 = {};
local u2 = {};

return function(p3) -- Line: 26
    -- upvalues: u1 (copy), Maid (copy), TweenService (copy), u2 (copy), ShineV1Shine (copy), RunService (copy)
    function p3.AddPulse(p4, u5, p6) -- Line: 32
        -- upvalues: u1 (ref), Maid (ref), TweenService (ref)
        if u1[u5] then
            return;
        end;

        u1[u5] = {};
        u1[u5].maid = Maid.new();
        u1[u5].ogSize = u5.Size;
        u1[u5].bigSize = UDim2.new(u1[u5].ogSize.X.Scale * p6, u1[u5].ogSize.X.Offset * p6, u1[u5].ogSize.Y.Scale * p6, u1[u5].ogSize.Y.Offset * p6);
        u1[u5].tween = TweenService:Create(u5, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
            Size = u1[u5].bigSize
        });
        u1[u5].tween:Play();
        u1[u5].maid:GiveTask(function() -- Line: 48
            -- upvalues: u1 (ref), u5 (copy)
            if u1[u5].tween then
                u1[u5].tween:Cancel();
            end;

            u1[u5].Size = u1[u5].ogSize;
        end);
    end;

    function p3.RemovePulse(p7, p8) -- Line: 56
        -- upvalues: u1 (ref)
        if u1[p8] then
            u1[p8].maid:Destroy();
            u1[p8] = nil;
        end;
    end;

    local NumberValue = Instance.new("NumberValue");
    NumberValue.Parent = script;

    function p3.AddShine(p9, u10, p11, p12, p13) -- Line: 68
        -- upvalues: u2 (ref), Maid (ref), ShineV1Shine (ref), NumberValue (copy)
        if u2[u10] then
            return;
        end;

        u2[u10] = {};
        u2[u10].maid = Maid.new();
        local u14 = ShineV1Shine:Clone();
        local u15 = ShineV1Shine:Clone();

        if p12 then
            u14.ImageColor3 = p12;
            u15.ImageColor3 = p13 or p12;
        end;

        local v16 = p11 or 1;
        u2[u10].shine1 = u14;
        u2[u10].shine2 = u15;
        local Frame = Instance.new("Frame");
        Frame.Name = "ShineContainer";
        Frame.Size = u10.Size;
        Frame.AnchorPoint = u10.AnchorPoint;
        Frame.Position = u10.Position;
        Frame.BackgroundTransparency = 1;
        Frame.ZIndex = -9999;
        u14.Parent = Frame;
        u15.Parent = Frame;
        Frame.Parent = u10.Parent;
        u14.Size = UDim2.new(v16 * 1, 0, v16 * 1, 0);
        u15.Size = UDim2.new(v16 * 1.3, 0, v16 * 1.3, 0);
        u2[u10].shine1Connection = NumberValue.Changed:Connect(function(p17) -- Line: 107
            -- upvalues: u14 (copy)
            u14.Rotation = p17;
        end);
        u2[u10].shine2Connection = NumberValue.Changed:Connect(function(p18) -- Line: 110
            -- upvalues: u15 (copy)
            u15.Rotation = -p18 * 2;
        end);
        u2[u10].maid:GiveTask(function() -- Line: 114
            -- upvalues: u14 (copy), u15 (copy), Frame (copy), u2 (ref), u10 (copy)
            u14:Destroy();
            u15:Destroy();
            Frame:Destroy();
            u2[u10].shine1Connection:Disconnect();
            u2[u10].shine2Connection:Disconnect();
        end);
    end;

    function p3.RemoveShine(p19, p20) -- Line: 125
        -- upvalues: u2 (ref)
        if u2[p20] then
            u2[p20].maid:Destroy();
            u2[p20] = nil;
        end;
    end;

    RunService.RenderStepped:Connect(function() -- Line: 132
        -- upvalues: NumberValue (copy)
        local v21 = NumberValue;
        v21.Value = v21.Value + 1;
    end);
end;