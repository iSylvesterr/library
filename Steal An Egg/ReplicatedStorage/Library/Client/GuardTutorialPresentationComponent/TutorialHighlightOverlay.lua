-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u2 = Log.new();
local ClickTarget = ReplicatedStorage.Assets.UI.Tutorial.ClickTarget;

return {
    Create = function(u3) -- Line: 32, Name: Create
        -- upvalues: Asserts (copy), GUI (copy), Trove (copy), ClickTarget (copy), TweenService (copy), u1 (copy), u2 (copy)
        Asserts.GuiObject(u3);
        local v4 = GUI.TutorialInstructions();
        local v5 = v4:IsA("ScreenGui");
        assert(v5, "TutorialInstructions must be a ScreenGui");
        local Parent = v4.Parent;
        local v6;

        if Parent == nil then
            v6 = false;
        else
            v6 = Parent:IsA("PlayerGui");
        end;

        assert(v6, "TutorialInstructions must be parented to PlayerGui");
        local u7 = Trove.new();
        local u8 = ClickTarget:Clone();
        u8.Name = "GuardTutorialHighlight";
        u8.Parent = Parent;
        u8.Enabled = true;
        u7:Add(u8);
        local Container = u8.Container;
        local v9 = Container:IsA("Frame");
        assert(v9, "Tutorial highlight Container must be a Frame");
        Container.Size = UDim2.fromScale(0.01, 0.01);
        local u10 = nil;

        local function updateOverlay() -- Line: 52
            -- upvalues: u3 (copy), u8 (copy), u10 (ref), TweenService (ref), Container (copy), u1 (ref)
            local AbsoluteSize = u3.AbsoluteSize;
            local v11 = u3.AbsolutePosition + AbsoluteSize * 0.5 - u8.AbsolutePosition;

            if u10 ~= nil then
                u10:Cancel();
                u10:Destroy();
            end;

            local v12 = TweenService:Create(Container, u1, {
                Size = UDim2.fromOffset(AbsoluteSize.X * 1.15, AbsoluteSize.Y * 1.15),
                Position = UDim2.fromOffset(v11.X, v11.Y)
            });
            u10 = v12;
            v12:Play();
        end;

        updateOverlay();
        u7:Add(u3:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateOverlay));
        u7:Add(u3:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateOverlay));
        u7:Add(u8:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateOverlay));
        u7:Add(function() -- Line: 74
            -- upvalues: u10 (ref)
            if u10 ~= nil then
                u10:Cancel();
                u10:Destroy();
            end;
        end);

        return function() -- Line: 81
            -- upvalues: u2 (ref), u7 (copy)
            u2:AtTrace():Log("[TutorialHighlightOverlay] Destroying highlight overlay");
            u7:Destroy();
        end;
    end
};