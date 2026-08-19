-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Audio = require(ReplicatedStorage.Library.Audio);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local u1 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = Log.new();
local ImageLabel = GUI.Damage().ImageLabel;
local u3 = nil;

return {
    Preload = function() -- Line: 30, Name: Preload
        -- upvalues: ImageLabel (copy), ContentProvider (copy), u2 (copy)
        ImageLabel.ImageTransparency = 1;
        task.spawn(function() -- Line: 32
            -- upvalues: ContentProvider (ref), ImageLabel (ref)
            ContentProvider:PreloadAsync({ ImageLabel });
        end);
        u2:AtDebug():Log("Damage feedback image preload requested");
    end,

    Play = function() -- Line: 38, Name: Play
        -- upvalues: u3 (ref), ImageLabel (copy), Audio (copy), TweenService (copy), u1 (copy)
        local v4 = u3;

        if v4 then
            v4:Cancel();
        end;

        ImageLabel.ImageTransparency = 0;
        Audio.Play(139459336979009, script, 1, 0.5);
        local v5 = TweenService:Create(ImageLabel, u1, {
            ImageTransparency = 1
        });
        u3 = v5;
        v5:Play();
    end
};