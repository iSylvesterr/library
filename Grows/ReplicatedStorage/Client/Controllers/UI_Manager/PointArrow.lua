-- Decompiled with Potassium's decompiler.

game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
local Effects = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Effects");
local Maid = require(Packages:WaitForChild("Maid"));
require(Info:WaitForChild("Images"));
local ArrowImage = Effects:WaitForChild("ArrowImage");
local u1 = {};

return function(p2) -- Line: 26
    -- upvalues: u1 (copy), Maid (copy), ArrowImage (copy), TweenService (copy)
    p2.DIRECTIONS = {
        BELOW = "BELOW"
    };

    function p2.AddPointArrow(p3, p4, p5, p6, p7, p8, p9) -- Line: 36
        -- upvalues: u1 (ref), Maid (ref), ArrowImage (ref), TweenService (ref)
        if u1[p4] then
            return;
        end;

        u1[p4] = {};
        u1[p4].maid = Maid.new();
        local u10 = ArrowImage:Clone();
        u10.ImageColor3 = p8;
        u1[p4].arrow = u10;
        u10.ZIndex = p4.ZIndex + 1;
        u10.Parent = p4;
        u10.Size = p6;
        local v11, v12, v13;

        if p9 == p3.DIRECTIONS.BELOW then
            v11 = p5 + UDim2.fromScale(0, p7);
            v12 = Vector2.new(0.5, 1);
            v13 = 0;
        else
            v13 = nil;
            v12 = nil;
            v11 = nil;
        end;

        u10.Rotation = v13;
        u10.Position = p5;
        u10.AnchorPoint = v12;
        local u14 = TweenService:Create(u10, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
            Position = v11
        });
        u14:Play();
        u1[p4].maid:GiveTask(function() -- Line: 72
            -- upvalues: u14 (copy), u10 (copy)
            if u14 then
                u14:Cancel();
            end;

            if u10 then
                u10:Destroy();
            end;
        end);
    end;

    function p2.RemovePointArrow(p15, p16) -- Line: 80
        -- upvalues: u1 (ref)
        if u1[p16] then
            u1[p16].maid:Destroy();
            u1[p16] = nil;
        end;
    end;
end;