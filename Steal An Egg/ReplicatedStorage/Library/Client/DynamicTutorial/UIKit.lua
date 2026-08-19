-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local TutorialBeam = require(ReplicatedStorage.Library.Client.WorldFX.TutorialBeam);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local TutorialTap = ReplicatedStorage.Assets.UI.OTHER.TutorialTap;
local u1 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u2 = 0;
local u3 = 0;
local u4 = nil;
local u5 = nil;
task.spawn(function() -- Line: 30
    -- upvalues: Players (copy), u4 (ref), u5 (ref)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local v6 = PlayerGui:WaitForChild("NotificationsTuto"):Clone();
    v6.Name = "DynamicTutorialMessage";
    v6.Enabled = false;
    v6.Parent = PlayerGui;
    u4 = v6;
    u5 = v6.MessageTop.Message.Frame.TextLabel;
end);

return {
    CreateBeam = function(p7) -- Line: 48, Name: CreateBeam
        -- upvalues: TutorialBeam (copy)
        return TutorialBeam.Create(p7);
    end,

    UpdateBeamTarget = function(p8, p9) -- Line: 52, Name: UpdateBeamTarget
        -- upvalues: TutorialBeam (copy)
        TutorialBeam.UpdateTarget(p8, p9);
    end,

    DestroyBeam = function(p10) -- Line: 56, Name: DestroyBeam
        -- upvalues: TutorialBeam (copy)
        TutorialBeam.Destroy(p10);
    end,

    CreateTapIndicator = function(p11, p12, p13, p14) -- Line: 60, Name: CreateTapIndicator
        -- upvalues: Asserts (copy), Trove (copy), TutorialTap (copy), TweenService (copy), u1 (copy)
        local v15;

        if p12 then
            v15 = p11;
        else
            v15 = p11.Parent;
        end;

        if not p12 and p11.Parent == nil then
            return nil;
        end;

        Asserts.optional.UDim(p13);
        Asserts.optional.UDim2(p14);
        local v16 = Trove.new();
        local v17 = TutorialTap:Clone();
        v17.Name = "TutorialTap";
        v17.Active = false;

        if p12 then
            v17.Position = UDim2.new(0, 0, 0, 0);
            v17.Size = UDim2.fromScale(1, 1);
            v17.AnchorPoint = Vector2.new(0, 0);
        else
            v17.Position = p11.Position;
            v17.Size = p11.Size;
            v17.AnchorPoint = p11.AnchorPoint;
        end;

        if p13 then
            v17.Frame.UICorner.CornerRadius = p13;
        end;

        if p14 then
            v17.Size = p14;
        end;

        v17.ZIndex = p11.ZIndex + 1;
        v17.Parent = v15;
        v16:Add(v17);
        local Arrow = v17.Arrow;
        local Position = Arrow.Position;
        Arrow.Position = UDim2.new(1, Position.X.Offset, Position.Y.Scale, Position.Y.Offset);
        local u18 = TweenService:Create(Arrow, u1, {
            Position = UDim2.new(1.2, Position.X.Offset, Position.Y.Scale, Position.Y.Offset)
        });
        u18:Play();
        v16:Add(function() -- Line: 101
            -- upvalues: u18 (copy)
            u18:Cancel();
        end);

        return {
            _trove = v16
        };
    end,

    DestroyTapIndicator = function(p19) -- Line: 109, Name: DestroyTapIndicator
        if p19 then
            p19._trove:Destroy();
        end;
    end,

    ShowMessage = function(p20, p21) -- Line: 115, Name: ShowMessage
        -- upvalues: u4 (ref), u5 (ref), u2 (ref), u3 (ref)
        if u4 == nil or u5 == nil then
            return {
                _id = -1
            };
        end;

        u2 = u2 + 1;
        u3 = u2;
        local v22 = u5;
        v22.RichText = true;
        v22.Text = p20;
        v22.TextColor3 = p21;
        u4.Enabled = true;

        return {
            _id = u2
        };
    end,

    DestroyMessage = function(p23) -- Line: 133, Name: DestroyMessage
        -- upvalues: u3 (ref), u4 (ref), u5 (ref)
        if p23 == nil or p23._id ~= u3 then
            return;
        end;

        u3 = 0;

        if u4 then
            u4.Enabled = false;
        end;

        if u5 then
            u5.Text = "";
        end;
    end
};