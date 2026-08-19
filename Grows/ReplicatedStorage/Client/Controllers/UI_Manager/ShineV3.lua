-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
local Effects = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Effects");
local Maid = require(Packages:WaitForChild("Maid"));
local Images = require(Info:WaitForChild("Images"));
local ShineV3Shine = Effects:WaitForChild("ShineV3Shine");
local u1 = {};

return function(p2) -- Line: 26
    -- upvalues: u1 (copy), Maid (copy), ShineV3Shine (copy), Images (copy), RunService (copy)
    function p2.AddShineV3(p3, u4, p5, p6, p7) -- Line: 34
        -- upvalues: u1 (ref), Maid (ref), ShineV3Shine (ref), Images (ref), RunService (ref)
        if u1[u4] then
            return;
        end;

        local v8 = p7 or {};
        u1[u4] = {};
        u1[u4].maid = Maid.new();
        local u9 = ShineV3Shine:Clone();
        local u10 = ShineV3Shine:Clone();
        u9.Image = Images.SUNRAY;
        u10.Image = Images.TWINKLE_THIN;

        if v8.noThinTwinkle then
            u10.Visible = false;
        end;

        u9.ImageColor3 = p6;
        u10.ImageColor3 = p6;
        u9.ImageTransparency = 0.7;
        u10.ImageTransparency = 0.2;
        local v11 = p5 or 1;
        u1[u4].shine1 = u9;
        u1[u4].shine2 = u10;
        local Frame = Instance.new("Frame");
        Frame.Name = "ShineContainer";
        Frame.Size = u4.Size;
        Frame.AnchorPoint = u4.AnchorPoint;
        Frame.Position = u4.Position;
        Frame.BackgroundTransparency = 1;
        Frame.ZIndex = -9999;
        u9.ZIndex = u4.ZIndex - 1;
        u10.ZIndex = u4.ZIndex - 1;
        u9.Parent = Frame;
        u10.Parent = Frame;
        Frame.Parent = u4.Parent;
        u9.Size = UDim2.new(v11 * 1, 0, v11 * 1, 0);
        u10.Size = UDim2.new(v11 * 1, 0, v11 * 1, 0);
        local u12 = v8.rotSpeed or 120;
        u1[u4].shine1Connection = RunService.RenderStepped:Connect(function(p13) -- Line: 84
            -- upvalues: u9 (copy), u12 (copy)
            local v14 = u9;
            v14.Rotation = v14.Rotation + p13 * u12;
        end);
        u1[u4].shine2Connection = RunService.RenderStepped:Connect(function(p15) -- Line: 87
            -- upvalues: u10 (copy), u12 (copy)
            local v16 = u10;
            v16.Rotation = v16.Rotation + p15 * u12;
        end);
        u1[u4].maid:GiveTask(function() -- Line: 91
            -- upvalues: u9 (copy), u10 (copy), Frame (copy), u1 (ref), u4 (copy)
            u9:Destroy();
            u10:Destroy();
            Frame:Destroy();
            u1[u4].shine1Connection:Disconnect();
            u1[u4].shine2Connection:Disconnect();
        end);
    end;

    function p2.RemoveShineV3(p17, p18) -- Line: 102
        -- upvalues: u1 (ref)
        if u1[p18] then
            u1[p18].maid:Destroy();
            u1[p18] = nil;
        end;
    end;
end;