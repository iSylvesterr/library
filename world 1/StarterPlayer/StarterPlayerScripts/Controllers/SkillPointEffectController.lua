-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local LevelUpEffect = require(ReplicatedStorage.ClientModules.Effects.LevelUpEffect);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local SkillPointSFX = SoundService.SFX.SkillPointSFX;

return {
    Start = function(p1) -- Line: 16, Name: Start
        -- upvalues: Networking (copy), SkillPointSFX (copy), LocalPlayer (copy), LevelUpEffect (copy)
        if workspace:GetAttribute("SkillPointsOn") ~= true then
            return;
        end;

        Networking.SkillPoints.SkillPointEarned.OnClientEvent:Connect(function() -- Line: 23
            -- upvalues: SkillPointSFX (ref), LocalPlayer (ref), LevelUpEffect (ref)
            SkillPointSFX.TimePosition = 0;
            SkillPointSFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            SkillPointSFX:Play();
            local Character = LocalPlayer.Character;

            if not Character then
                return;
            end;

            if not Character:FindFirstChild("HumanoidRootPart") then
                return;
            end;

            LevelUpEffect:Play(Character);
        end);
    end
};