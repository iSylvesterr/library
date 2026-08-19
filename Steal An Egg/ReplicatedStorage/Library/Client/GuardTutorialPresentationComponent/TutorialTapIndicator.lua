-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u2 = Log.new();
local TutorialTap = ReplicatedStorage.Assets.UI.Tutorial.TutorialTap;

return {
    Create = function(p3, p4, p5, p6) -- Line: 36, Name: Create
        -- upvalues: Asserts (copy), Trove (copy), TutorialTap (copy), TweenService (copy), u1 (copy), u2 (copy)
        Asserts.GuiButton(p3);
        Asserts.optional.boolean(p4);
        Asserts.optional.UDim(p5);
        Asserts.optional.UDim2(p6);
        local v7;

        if p4 == true then
            v7 = p3;
        else
            v7 = p3.Parent;
            assert(v7 ~= nil, "Tutorial tap target button must have a parent");
        end;

        local u8 = Trove.new();
        local v9 = TutorialTap:Clone();
        v9.Name = "GuardTutorialTap";
        v9.Active = false;

        if p4 == true then
            v9.Position = UDim2.new(0, 0, 0, 0);
            v9.Size = UDim2.fromScale(1, 1);
            v9.AnchorPoint = Vector2.zero;
        else
            v9.Position = p3.Position;
            v9.Size = p3.Size;
            v9.AnchorPoint = p3.AnchorPoint;
        end;

        if p5 ~= nil then
            local Frame = v9.Frame;
            local v10 = Frame:IsA("Frame");
            assert(v10, "Tutorial tap template Frame must be a Frame");
            local UICorner = Frame.UICorner;
            local v11 = UICorner:IsA("UICorner");
            assert(v11, "Tutorial tap template UICorner must be a UICorner");
            UICorner.CornerRadius = p5;
        end;

        if p6 ~= nil then
            v9.Size = p6;
        end;

        v9.ZIndex = p3.ZIndex + 1;
        v9.Parent = v7;
        u8:Add(v9);
        local Arrow = v9.Arrow;
        local v12 = Arrow:IsA("ImageLabel");
        assert(v12, "Tutorial tap template Arrow must be an ImageLabel");
        local Position = Arrow.Position;
        Arrow.Position = UDim2.new(1, Position.X.Offset, Position.Y.Scale, Position.Y.Offset);
        local u13 = TweenService:Create(Arrow, u1, {
            Position = UDim2.new(1.2, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
        });
        u13:Play();
        u8:Add(function() -- Line: 96
            -- upvalues: u13 (copy)
            u13:Cancel();
            u13:Destroy();
        end);

        return function() -- Line: 101
            -- upvalues: u2 (ref), u8 (copy)
            u2:AtTrace():Log("[TutorialTapIndicator] Destroying tap indicator");
            u8:Destroy();
        end;
    end
};