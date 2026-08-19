-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();

return {
    Start = function(u2, p3, p4) -- Line: 21, Name: Start
        -- upvalues: Asserts (copy), TweenService (copy), u1 (copy)
        Asserts.GuiButton(u2);
        Asserts.Color3(p3);
        Asserts.TweenInfo(p4);
        local ImageColor3 = u2.ImageColor3;
        local u5 = TweenService:Create(u2, p4, {
            ImageColor3 = p3
        });
        local u6 = false;
        local UIScale = Instance.new("UIScale");
        UIScale.Parent = u2;
        UIScale.Scale = 0.9;
        local u7 = TweenService:Create(UIScale, p4, {
            Scale = 1.15
        });
        u7:Play();
        u5:Play();
        u1:AtTrace():Log("Started image-color pulse");

        return function() -- Line: 43
            -- upvalues: u6 (ref), u5 (copy), u2 (copy), ImageColor3 (copy), u7 (copy), UIScale (copy), u1 (ref)
            if u6 then
                return;
            end;

            u6 = true;
            u5:Cancel();
            u2.ImageColor3 = ImageColor3;
            u7:Cancel();
            UIScale.Scale = 1;

            if not UIScale:GetAttribute("ButtonFXOwned") then
                UIScale:Destroy();
            end;

            u1:AtTrace():Log("Cleared image-color pulse");
        end;
    end
};