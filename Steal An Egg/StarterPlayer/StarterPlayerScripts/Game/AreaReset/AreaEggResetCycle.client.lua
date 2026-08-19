-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Workspace = game:GetService("Workspace");
local AreaEggResetCycle = require(ReplicatedStorage.Directory.AreaEggResetCycle);
local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil);
local Audio = require(ReplicatedStorage.Library.Audio);
local LightingsController = require(ReplicatedStorage.Library.Client.LightingsController);
require(ReplicatedStorage.Directory.Lightings);
local MusicController = require(ReplicatedStorage.Library.Client.MusicController);
local PreloadSounds = require(ReplicatedStorage.Library.Functions.PreloadSounds);
local DayTransitionSoundId = AreaEggResetCycle.DayTransitionSoundId;
local u1 = nil;

local function transformToNight(p2) -- Line: 32
    -- upvalues: AreaEggResetCycle (copy)
    local v3 = table.clone(p2);
    local NightLighting = AreaEggResetCycle.NightLighting;
    v3.Ambient = NightLighting.Ambient;
    v3.Brightness = NightLighting.Brightness;
    v3.ClockTime = NightLighting.ClockTime;
    v3.ColorShift_Bottom = NightLighting.ColorShift_Bottom;
    v3.ColorShift_Top = NightLighting.ColorShift_Top;
    v3.OutdoorAmbient = NightLighting.OutdoorAmbient;

    return v3;
end;

local function resolvePhase(p4) -- Line: 44
    -- upvalues: Workspace (copy), AreaEggResetTimeUtil (copy), AreaEggResetCycle (copy)
    return Workspace:GetAttribute("Event_DemonicEvent") == true and "Day" or (AreaEggResetTimeUtil.IsNight(p4) and "Night" or (AreaEggResetTimeUtil.IsNightTransition(p4, AreaEggResetCycle.NightLightingTransitionSeconds, AreaEggResetCycle.NightLightingStartDelaySeconds) and "NightTransition" or "Day"));
end;

local function setPhase(p5, p6, p7) -- Line: 63
    -- upvalues: u1 (ref), AreaEggResetTimeUtil (copy), AreaEggResetCycle (copy), LightingsController (copy), transformToNight (copy), MusicController (copy), DayTransitionSoundId (copy), Audio (copy), SoundService (copy)
    if u1 == p5 then
        return;
    end;

    local v8 = u1;
    u1 = p5;

    if p5 == "NightTransition" then
        local v9 = AreaEggResetTimeUtil.GetNightStartsAt(p7) + AreaEggResetCycle.NightLightingStartDelaySeconds - p7;
        local v10 = math.max(v9, 0);
        LightingsController:SetModifier("AreaEggResetNight", transformToNight, AreaEggResetCycle.LightingModifierPriority, v10);
        MusicController.SetResetNightActive(false);

        return;
    end;

    if p5 == "Night" then
        if v8 ~= "NightTransition" then
            local v11 = AreaEggResetTimeUtil.GetNightStartsAt(p7) + AreaEggResetCycle.NightLightingStartDelaySeconds;
            LightingsController:SetModifier("AreaEggResetNight", transformToNight, AreaEggResetCycle.LightingModifierPriority, (math.max(v11 - p7, 0)));
        end;

        MusicController.SetResetNightActive(true, true);

        return;
    end;

    LightingsController:ClearModifier("AreaEggResetNight", (p6 or v8 == nil) and 0 or AreaEggResetCycle.DayLightingTransitionSeconds);
    MusicController.SetResetNightActive(false);

    if not p6 and DayTransitionSoundId ~= nil then
        Audio.Play(DayTransitionSoundId, SoundService);
    end;
end;

local function runCycle() -- Line: 108
    -- upvalues: Workspace (copy), AreaEggResetTimeUtil (copy), AreaEggResetCycle (copy), setPhase (copy)
    local v12 = true;

    while true do
        local v13 = Workspace:GetServerTimeNow();
        local v14 = Workspace:GetAttribute("Event_DemonicEvent") == true and "Day" or (AreaEggResetTimeUtil.IsNight(v13) and "Night" or (AreaEggResetTimeUtil.IsNightTransition(v13, AreaEggResetCycle.NightLightingTransitionSeconds, AreaEggResetCycle.NightLightingStartDelaySeconds) and "NightTransition" or "Day"));
        setPhase(v14, v12, v13);
        v12 = false;
        local v15;

        if v14 == "Night" then
            v15 = AreaEggResetTimeUtil.GetNextResetAt(v13);
        elseif v14 == "NightTransition" then
            v15 = AreaEggResetTimeUtil.GetNightStartsAt(v13);
        else
            v15 = AreaEggResetTimeUtil.GetNightTransitionStartsAt(v13, AreaEggResetCycle.NightLightingTransitionSeconds, AreaEggResetCycle.NightLightingStartDelaySeconds);
        end;

        local wait = task.wait;
        local v16 = v15 - Workspace:GetServerTimeNow();
        wait((math.clamp(v16, 0.05, AreaEggResetTimeUtil.SchedulePollSeconds)));
    end;
end;

if DayTransitionSoundId ~= nil then
    task.spawn(PreloadSounds, DayTransitionSoundId);
end;

Workspace:GetAttributeChangedSignal("Event_DemonicEvent"):Connect(function() -- Line: 147
    -- upvalues: Workspace (copy), setPhase (copy), AreaEggResetTimeUtil (copy), AreaEggResetCycle (copy)
    local v17 = Workspace:GetServerTimeNow();
    setPhase(Workspace:GetAttribute("Event_DemonicEvent") == true and "Day" or (AreaEggResetTimeUtil.IsNight(v17) and "Night" or (AreaEggResetTimeUtil.IsNightTransition(v17, AreaEggResetCycle.NightLightingTransitionSeconds, AreaEggResetCycle.NightLightingStartDelaySeconds) and "NightTransition" or "Day")), false, v17);
end);
runCycle();