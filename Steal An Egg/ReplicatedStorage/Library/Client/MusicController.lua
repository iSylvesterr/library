-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local Audio = require(ReplicatedStorage.Library.Audio);
local AreaEggResetCycle = require(ReplicatedStorage.Directory.AreaEggResetCycle);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local CreateMusicSound = require(ReplicatedStorage.Library.Audio.CreateMusicSound);
local GuardAreaLookupUtil = require(ReplicatedStorage.Library.Util.GuardAreaLookupUtil);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Player = require(ReplicatedStorage.Library.Player);
local SettingsCmds = require(ReplicatedStorage.Library.Client.SettingsCmds);
local Shuffle = require(ReplicatedStorage.Library.Functions.Shuffle);
local Treadmills = require(ReplicatedStorage.Directory.Treadmills);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = {
    Id = 5026653246,
    Volume = 1.5
};
local u2 = {
    Id = 77770487605071,
    Volume = 0.4
};
local u3 = { {
        Id = 1836009208,
        Volume = 0.22
    }, {
        Id = 1846088038,
        Volume = 0.22
    }, {
        Id = 9045766074,
        Volume = 0.22
    }, {
        Id = 1842150151,
        Volume = 0.22
    } };
local u4 = { {
        Id = 77770487605071,
        Volume = 0.5
    } };
local u5 = { {
        Id = 95532010565428,
        Volume = 0
    }, {
        Id = 140667339171815,
        Volume = 0
    }, {
        Id = 95532010565428,
        Volume = 0
    } };
local Quad = Enum.EasingStyle.Quad;
local InOut = Enum.EasingDirection.InOut;
local Treadmills2 = Constants.NETWORK_MAP.Treadmills;
local LocalPlayer = Players.LocalPlayer;
local u6 = Log.new():LimitUnderLevel("Warning");
local __OBJECTS = Workspace.__OBJECTS;
local v7 = __OBJECTS:IsA("Folder");
assert(v7, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v8 = Areas:IsA("Folder");
assert(v8, "Workspace.__OBJECTS.Areas must be a Folder");
local SeparationLine = Areas.SeparationLine;
local v9 = SeparationLine:IsA("BasePart");
assert(v9, "Workspace.__OBJECTS.Areas.SeparationLine must be a BasePart");
local v10 = {};
local u11 = nil;

local function createManagedSound(p12, p13, p14, p15) -- Line: 111
    return {
        Tween = nil,
        Generation = 0,
        ResumeTimePosition = 0,
        Sound = p12,
        BaseVolume = p13,
        ShouldResumeTimePosition = p14 == true,
        KeepPlayingWhenSilent = p15 == true
    };
end;

local function resolveOutsideStates() -- Line: 128
    -- upvalues: u3 (copy), CreateMusicSound (copy)
    local v16 = {};

    for i, v in ipairs(u3) do
        local v17 = CreateMusicSound(`OutsidePlaylistMusic_{i}_{v.Id}`, v.Id, false);
        v16[#v16 + 1] = {
            Tween = nil,
            Generation = 0,
            ResumeTimePosition = 0,
            ShouldResumeTimePosition = false,
            KeepPlayingWhenSilent = true,
            Sound = v17,
            BaseVolume = v.Volume
        };
    end;

    assert(#v16 > 0, "MusicController expected at least one outside playlist track");

    return v16;
end;

local function resolveInStagesState() -- Line: 140
    -- upvalues: CreateMusicSound (copy)
    return {
        BaseVolume = 0.4,
        Tween = nil,
        Generation = 0,
        ResumeTimePosition = 0,
        ShouldResumeTimePosition = false,
        KeepPlayingWhenSilent = false,
        Sound = CreateMusicSound(`CoreGameplayMusic_{77770487605071}`, 77770487605071, true)
    };
end;

local function resolveGameplayBackgroundState() -- Line: 146
    -- upvalues: CreateMusicSound (copy)
    return {
        BaseVolume = 1.5,
        Tween = nil,
        Generation = 0,
        ResumeTimePosition = 0,
        ShouldResumeTimePosition = false,
        KeepPlayingWhenSilent = false,
        Sound = CreateMusicSound(`GameplayBackgroundMusic_{5026653246}`, 5026653246, true)
    };
end;

local function resolveResetNightState() -- Line: 155
    -- upvalues: AreaEggResetCycle (copy), CreateMusicSound (copy)
    local NightMusic = AreaEggResetCycle.NightMusic;

    return NightMusic ~= nil and {
        Tween = nil,
        Generation = 0,
        ResumeTimePosition = 0,
        ShouldResumeTimePosition = false,
        KeepPlayingWhenSilent = false,
        Sound = CreateMusicSound(`AreaEggResetNightMusic_{NightMusic.Id}`, NightMusic.Id, true),
        BaseVolume = NightMusic.Volume
    } or nil;
end;

local function createSaveZoneSound(p18) -- Line: 165
    -- upvalues: CreateMusicSound (copy)
    return {
        Tween = nil,
        Generation = 0,
        ResumeTimePosition = 0,
        ShouldResumeTimePosition = false,
        KeepPlayingWhenSilent = false,
        Sound = CreateMusicSound(`SaveZoneMusic_{p18.Id}`, p18.Id, true),
        BaseVolume = p18.Volume
    };
end;

local function createTreadmillSound(p19) -- Line: 170
    -- upvalues: CreateMusicSound (copy)
    return {
        Tween = nil,
        Generation = 0,
        ResumeTimePosition = 0,
        ShouldResumeTimePosition = false,
        KeepPlayingWhenSilent = false,
        Sound = CreateMusicSound(`TreadmillMusic_{p19.Id}_{math.floor(p19.Volume * 100)}`, p19.Id, false),
        BaseVolume = p19.Volume
    };
end;

local function refillOutsideOrder(p20) -- Line: 175
    -- upvalues: Shuffle (copy)
    table.clear(p20.OutsideOrder);

    for i = 1, #p20.OutsideStates do
        p20.OutsideOrder[i] = i;
    end;

    Shuffle(p20.OutsideOrder, p20.OutsideRandom);
    p20.CurrentOutsideOrderPosition = 1;
    p20.CurrentOutsideIndex = assert(p20.OutsideOrder[p20.CurrentOutsideOrderPosition], "MusicController outside playlist order must not be empty");
end;

local function resolveRuntime() -- Line: 189
    -- upvalues: u11 (ref), Trove (copy), resolveOutsideStates (copy), CreateMusicSound (copy), u1 (copy), u2 (copy), AreaEggResetCycle (copy), Variables (copy), SettingsCmds (copy), refillOutsideOrder (copy)
    local v21 = u11;

    if v21 ~= nil then
        return v21;
    end;

    local v22 = {
        GameplaySideScanAccumulator = 0,
        CurrentOutsideIndex = 1,
        CurrentOutsideOrderPosition = 1,
        CurrentTreadmillIndex = 1,
        GameplayAreaActive = false,
        ResetNightActive = false,
        ResetNightTrackActive = false,
        SaveZoneActive = false,
        Started = false,
        NonDefaultTreadmillActive = false,
        LastDesiredMode = nil,
        Trove = Trove.new(),
        OutsideStates = resolveOutsideStates(),
        GameplayBackgroundState = {
            Tween = nil,
            Generation = 0,
            ResumeTimePosition = 0,
            ShouldResumeTimePosition = false,
            KeepPlayingWhenSilent = false,
            Sound = CreateMusicSound(`GameplayBackgroundMusic_{u1.Id}`, u1.Id, true),
            BaseVolume = u1.Volume
        },
        InStagesState = {
            Tween = nil,
            Generation = 0,
            ResumeTimePosition = 0,
            ShouldResumeTimePosition = false,
            KeepPlayingWhenSilent = false,
            Sound = CreateMusicSound(`CoreGameplayMusic_{u2.Id}`, u2.Id, true),
            BaseVolume = u2.Volume
        }
    };
    local NightMusic = AreaEggResetCycle.NightMusic;
    v22.ResetNightState = NightMusic ~= nil and {
        Tween = nil,
        Generation = 0,
        ResumeTimePosition = 0,
        ShouldResumeTimePosition = false,
        KeepPlayingWhenSilent = false,
        Sound = CreateMusicSound(`AreaEggResetNightMusic_{NightMusic.Id}`, NightMusic.Id, true),
        BaseVolume = NightMusic.Volume
    } or nil;
    v22.SaveZoneStates = {};
    v22.TreadmillStates = {};
    v22.OutsideOrder = {};
    v22.OutsideRandom = Random.new();
    v22.CarryingAreaEgg = Variables.Locks.AreaEggRunBack:IsLocked();
    v22.GuardedGameplayActive = Variables.Locks.GuardedGameplayMusic:IsLocked();
    v22.MusicEnabled = SettingsCmds.IsEnabled("Music");
    v22.UiHidden = Variables.Locks.HideUI:IsLocked();
    refillOutsideOrder(v22);
    u11 = v22;

    return v22;
end;

local function resolveResumeTimePosition(p23) -- Line: 227
    local Sound = p23.Sound;
    local ResumeTimePosition = p23.ResumeTimePosition;

    return Sound.TimeLength > 0 and Sound.TimeLength - 0.05 <= ResumeTimePosition and 0 or ResumeTimePosition;
end;

local function ensureSoundPlaying(p24) -- Line: 238
    local Sound = p24.Sound;

    if Sound.TimeLength > 0 and Sound.TimePosition >= Sound.TimeLength - 0.05 then
        Sound.TimePosition = 0;
    end;

    if p24.ShouldResumeTimePosition and not Sound.IsPlaying then
        local Sound2 = p24.Sound;
        local ResumeTimePosition = p24.ResumeTimePosition;
        Sound.TimePosition = Sound2.TimeLength > 0 and Sound2.TimeLength - 0.05 <= ResumeTimePosition and 0 or ResumeTimePosition;
    end;

    if not Sound.IsPlaying then
        Sound:Play();
    end;
end;

local function finalizeMutedState(p25) -- Line: 253
    local Sound = p25.Sound;

    if p25.ShouldResumeTimePosition then
        p25.ResumeTimePosition = Sound.TimePosition;
    end;

    if Sound.IsPlaying then
        Sound:Pause();
    end;

    Sound.Volume = 0;
end;

local function resetManagedSoundTimePosition(p26) -- Line: 265
    local Sound = p26.Sound;
    p26.ResumeTimePosition = 0;
    Sound.TimePosition = 0;
end;

local function stopManagedSoundImmediately(p27) -- Line: 271
    p27.Generation = p27.Generation + 1;
    local Tween = p27.Tween;

    if Tween ~= nil then
        Tween:Cancel();
        p27.Tween = nil;
    end;

    local Sound = p27.Sound;

    if p27.ShouldResumeTimePosition then
        p27.ResumeTimePosition = Sound.TimePosition;
    end;

    if Sound.IsPlaying then
        Sound:Pause();
    end;

    Sound.Volume = 0;
end;

local function driveManagedSound(u28, u29, u30, p31) -- Line: 283
    -- upvalues: Audio (copy), Quad (copy), InOut (copy)
    local Sound = u28.Sound;
    u28.Generation = u28.Generation + 1;
    local Generation = u28.Generation;
    local Tween = u28.Tween;

    if Tween ~= nil then
        Tween:Cancel();
        u28.Tween = nil;
    end;

    if u29 then
        local Sound2 = u28.Sound;

        if Sound2.TimeLength > 0 and Sound2.TimePosition >= Sound2.TimeLength - 0.05 then
            Sound2.TimePosition = 0;
        end;

        if u28.ShouldResumeTimePosition and not Sound2.IsPlaying then
            local Sound3 = u28.Sound;
            local ResumeTimePosition = u28.ResumeTimePosition;
            Sound2.TimePosition = Sound3.TimeLength > 0 and Sound3.TimeLength - 0.05 <= ResumeTimePosition and 0 or ResumeTimePosition;
        end;

        if not Sound2.IsPlaying then
            Sound2:Play();
        end;
    end;

    if math.abs(Sound.Volume - u30) <= 0.001 then
        Sound.Volume = u30;

        if u30 <= 0 and not (u29 and u28.KeepPlayingWhenSilent) then
            local Sound2 = u28.Sound;

            if u28.ShouldResumeTimePosition then
                u28.ResumeTimePosition = Sound2.TimePosition;
            end;

            if Sound2.IsPlaying then
                Sound2:Pause();
            end;

            Sound2.Volume = 0;
        end;

        return;
    end;

    local u32 = Audio.Fade(Sound, u30, p31, Quad, InOut);
    u28.Tween = u32;
    u32.Completed:Once(function(p33) -- Line: 315
        -- upvalues: u28 (copy), Generation (copy), u32 (copy), Sound (copy), u30 (copy), u29 (copy)
        if u28.Generation ~= Generation or u28.Tween ~= u32 then
            return;
        end;

        u28.Tween = nil;

        if p33 ~= Enum.PlaybackState.Completed then
            return;
        end;

        Sound.Volume = u30;

        if u30 <= 0 and not (u29 and u28.KeepPlayingWhenSilent) then
            local v34 = u28;
            local Sound2 = v34.Sound;

            if v34.ShouldResumeTimePosition then
                v34.ResumeTimePosition = Sound2.TimePosition;
            end;

            if Sound2.IsPlaying then
                Sound2:Pause();
            end;

            Sound2.Volume = 0;
        end;
    end);
end;

local function ensureSaveZoneStates(p35) -- Line: 332
    -- upvalues: u4 (copy), CreateMusicSound (copy)
    if #p35.SaveZoneStates > 0 then
        return p35.SaveZoneStates;
    end;

    for _, v in ipairs(u4) do
        p35.SaveZoneStates[#p35.SaveZoneStates + 1] = {
            Tween = nil,
            Generation = 0,
            ResumeTimePosition = 0,
            ShouldResumeTimePosition = false,
            KeepPlayingWhenSilent = false,
            Sound = CreateMusicSound(`SaveZoneMusic_{v.Id}`, v.Id, true),
            BaseVolume = v.Volume
        };
    end;

    return p35.SaveZoneStates;
end;

local function ensureTreadmillStates(p36) -- Line: 344
    -- upvalues: u5 (copy), CreateMusicSound (copy)
    if #p36.TreadmillStates > 0 then
        return p36.TreadmillStates;
    end;

    for _, v in ipairs(u5) do
        p36.TreadmillStates[#p36.TreadmillStates + 1] = {
            Tween = nil,
            Generation = 0,
            ResumeTimePosition = 0,
            ShouldResumeTimePosition = false,
            KeepPlayingWhenSilent = false,
            Sound = CreateMusicSound(`TreadmillMusic_{v.Id}_{math.floor(v.Volume * 100)}`, v.Id, false),
            BaseVolume = v.Volume
        };
    end;

    return p36.TreadmillStates;
end;

local function resetTreadmillPlaylist(p37) -- Line: 356
    -- upvalues: ensureTreadmillStates (copy)
    p37.CurrentTreadmillIndex = 1;

    for _, v in ipairs((ensureTreadmillStates(p37))) do
        v.Generation = v.Generation + 1;
        local Tween = v.Tween;

        if Tween ~= nil then
            Tween:Cancel();
            v.Tween = nil;
        end;

        local Sound = v.Sound;

        if v.ShouldResumeTimePosition then
            v.ResumeTimePosition = Sound.TimePosition;
        end;

        if Sound.IsPlaying then
            Sound:Pause();
        end;

        Sound.Volume = 0;
        v.Sound.TimePosition = 0;
    end;
end;

local function resolveDesiredMode(p38) -- Line: 365
    return p38.MusicEnabled and (p38.ResetNightActive and "ResetNight" or (p38.NonDefaultTreadmillActive and "Treadmill" or (p38.GuardedGameplayActive and "Muted" or (p38.GameplayAreaActive and (p38.CarryingAreaEgg and "GuardedGameplay" or "GameplayBackground") or (p38.UiHidden and "Muted" or (p38.SaveZoneActive and "SaveZone" or "Outside")))))) or "Muted";
end;

local function moveToNextOutsideTrack(p39) -- Line: 401
    -- upvalues: refillOutsideOrder (copy)
    p39.CurrentOutsideOrderPosition = p39.CurrentOutsideOrderPosition + 1;

    if p39.CurrentOutsideOrderPosition > #p39.OutsideOrder then
        refillOutsideOrder(p39);

        return;
    end;

    p39.CurrentOutsideIndex = assert(p39.OutsideOrder[p39.CurrentOutsideOrderPosition], "MusicController outside playlist order position must reference a track");
end;

local function applyMusicState(p40) -- Line: 414
    -- upvalues: resetTreadmillPlaylist (copy), u6 (copy), driveManagedSound (copy), ensureSaveZoneStates (copy), ensureTreadmillStates (copy), AreaEggResetCycle (copy)
    local v41;

    if p40.MusicEnabled then
        if p40.ResetNightActive then
            v41 = "ResetNight";
        elseif p40.NonDefaultTreadmillActive then
            v41 = "Treadmill";
        elseif p40.GuardedGameplayActive then
            v41 = "Muted";
        elseif p40.GameplayAreaActive then
            v41 = p40.CarryingAreaEgg and "GuardedGameplay" or "GameplayBackground";
        else
            v41 = p40.UiHidden and "Muted" or (p40.SaveZoneActive and "SaveZone" or "Outside");
        end;
    else
        v41 = "Muted";
    end;

    local LastDesiredMode = p40.LastDesiredMode;
    local v42 = v41 == "GuardedGameplay" and true or LastDesiredMode == "GuardedGameplay";
    local v43 = v41 == "GameplayBackground" and true or LastDesiredMode == "GameplayBackground";

    if LastDesiredMode ~= v41 then
        if v41 == "Treadmill" then
            resetTreadmillPlaylist(p40);
        end;

        p40.LastDesiredMode = v41;
        u6:AtDebug():Log("MusicController mode updated", {
            Mode = v41
        });
    end;

    for i, v in ipairs(p40.OutsideStates) do
        local v44 = i == p40.CurrentOutsideIndex;
        local v45;

        if v41 == "Outside" then
            v45 = v44;
        else
            v45 = false;
        end;

        driveManagedSound(v, v44, not v45 and 0 or v.BaseVolume, v41 == "SaveZone" and 1 or (v42 and 0.1 or (v43 and 0.4 or 0.8)));
    end;

    local SaveZoneStates = p40.SaveZoneStates;

    if v41 == "SaveZone" or #SaveZoneStates > 0 then
        SaveZoneStates = ensureSaveZoneStates(p40);
    end;

    for _, v in ipairs(SaveZoneStates) do
        local v46 = v41 == "SaveZone";
        driveManagedSound(v, v46, not v46 and 0 or v.BaseVolume, v42 and 0.1 or (v43 and 0.4 or 1.25));
    end;

    local TreadmillStates = p40.TreadmillStates;

    if v41 == "Treadmill" or #TreadmillStates > 0 then
        TreadmillStates = ensureTreadmillStates(p40);
    end;

    for i, v in ipairs(TreadmillStates) do
        local v47;

        if v41 == "Treadmill" then
            v47 = i == p40.CurrentTreadmillIndex;
        else
            v47 = false;
        end;

        driveManagedSound(v, v47, not v47 and 0 or v.BaseVolume, v42 and 0.1 or (v43 and 0.4 or 1));
    end;

    local GameplayBackgroundState = p40.GameplayBackgroundState;
    local v48 = v41 == "GameplayBackground";
    driveManagedSound(GameplayBackgroundState, v48, not v48 and 0 or GameplayBackgroundState.BaseVolume, v42 and 0.1 or 0.4);
    local InStagesState = p40.InStagesState;
    local v49 = v41 == "GuardedGameplay";
    driveManagedSound(InStagesState, v49, not v49 and 0 or InStagesState.BaseVolume, v42 and 0.1 or (v49 and 1 or 0.8));
    local ResetNightState = p40.ResetNightState;

    if ResetNightState ~= nil then
        local v50;

        if v41 == "ResetNight" then
            v50 = p40.ResetNightTrackActive;
        else
            v50 = false;
        end;

        driveManagedSound(ResetNightState, v50, not v50 and 0 or ResetNightState.BaseVolume, AreaEggResetCycle.MusicTransitionSeconds);
    end;
end;

local function handleOutsideTrackEnded(p51, p52) -- Line: 517
    -- upvalues: refillOutsideOrder (copy), applyMusicState (copy)
    if p52 ~= p51.CurrentOutsideIndex then
        return;
    end;

    p51.CurrentOutsideOrderPosition = p51.CurrentOutsideOrderPosition + 1;

    if p51.CurrentOutsideOrderPosition > #p51.OutsideOrder then
        refillOutsideOrder(p51);
    else
        p51.CurrentOutsideIndex = assert(p51.OutsideOrder[p51.CurrentOutsideOrderPosition], "MusicController outside playlist order position must reference a track");
    end;

    applyMusicState(p51);
end;

local function moveToNextTreadmillTrack(p53) -- Line: 526
    p53.CurrentTreadmillIndex = p53.CurrentTreadmillIndex + 1;

    if p53.CurrentTreadmillIndex > #p53.TreadmillStates then
        p53.CurrentTreadmillIndex = 1;
    end;
end;

local function handleTreadmillTrackEnded(p54, p55) -- Line: 533
    -- upvalues: applyMusicState (copy)
    local v56;

    if p54.MusicEnabled then
        if p54.ResetNightActive then
            v56 = "ResetNight";
        elseif p54.NonDefaultTreadmillActive then
            v56 = "Treadmill";
        elseif p54.GuardedGameplayActive then
            v56 = "Muted";
        elseif p54.GameplayAreaActive then
            v56 = p54.CarryingAreaEgg and "GuardedGameplay" or "GameplayBackground";
        else
            v56 = p54.UiHidden and "Muted" or (p54.SaveZoneActive and "SaveZone" or "Outside");
        end;
    else
        v56 = "Muted";
    end;

    if v56 ~= "Treadmill" then
        return;
    end;

    if p55 ~= p54.CurrentTreadmillIndex then
        return;
    end;

    p54.CurrentTreadmillIndex = p54.CurrentTreadmillIndex + 1;

    if p54.CurrentTreadmillIndex > #p54.TreadmillStates then
        p54.CurrentTreadmillIndex = 1;
    end;

    applyMusicState(p54);
end;

local function updateGameplayAreaState(p57) -- Line: 546
    -- upvalues: Player (copy), LocalPlayer (copy), GuardAreaLookupUtil (copy), SeparationLine (copy), applyMusicState (copy)
    local v58 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v59;

    if v58 == nil or not v58:IsA("BasePart") then
        v59 = false;
    else
        v59 = GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v58.Position);
    end;

    if p57.GameplayAreaActive == v59 then
        return;
    end;

    p57.GameplayAreaActive = v59;
    applyMusicState(p57);
end;

function v10.StartSaveZoneMusic() -- Line: 566
    -- upvalues: resolveRuntime (copy), applyMusicState (copy)
    local v60 = resolveRuntime();

    if v60.SaveZoneActive then
        return;
    end;

    v60.SaveZoneActive = true;
    applyMusicState(v60);
end;

function v10.StopSaveZoneMusic() -- Line: 576
    -- upvalues: resolveRuntime (copy), applyMusicState (copy)
    local v61 = resolveRuntime();

    if not v61.SaveZoneActive then
        return;
    end;

    v61.SaveZoneActive = false;
    applyMusicState(v61);
end;

function v10.StopInStagesMusicInstant() -- Line: 586
    -- upvalues: resolveRuntime (copy)
    local InStagesState = resolveRuntime().InStagesState;
    InStagesState.Generation = InStagesState.Generation + 1;
    local Tween = InStagesState.Tween;

    if Tween ~= nil then
        Tween:Cancel();
        InStagesState.Tween = nil;
    end;

    local Sound = InStagesState.Sound;

    if InStagesState.ShouldResumeTimePosition then
        InStagesState.ResumeTimePosition = Sound.TimePosition;
    end;

    if Sound.IsPlaying then
        Sound:Pause();
    end;

    Sound.Volume = 0;
end;

function v10.ResetInStagesMusicInstant() -- Line: 591
    -- upvalues: resolveRuntime (copy)
    local InStagesState = resolveRuntime().InStagesState;
    InStagesState.Generation = InStagesState.Generation + 1;
    local Tween = InStagesState.Tween;

    if Tween ~= nil then
        Tween:Cancel();
        InStagesState.Tween = nil;
    end;

    local Sound = InStagesState.Sound;

    if InStagesState.ShouldResumeTimePosition then
        InStagesState.ResumeTimePosition = Sound.TimePosition;
    end;

    if Sound.IsPlaying then
        Sound:Pause();
    end;

    Sound.Volume = 0;
    local Sound2 = InStagesState.Sound;
    InStagesState.ResumeTimePosition = 0;
    Sound2.TimePosition = 0;
end;

function v10.IsNonDefaultTreadmillActive() -- Line: 598
    -- upvalues: resolveRuntime (copy)
    return resolveRuntime().NonDefaultTreadmillActive;
end;

function v10.SetResetNightActive(p62, p63) -- Line: 602
    -- upvalues: resolveRuntime (copy), applyMusicState (copy)
    local v64 = resolveRuntime();
    local v65;

    if p62 then
        v65 = p63 == true;
    else
        v65 = p62;
    end;

    if v64.ResetNightActive == p62 and v64.ResetNightTrackActive == v65 then
        return;
    end;

    v64.ResetNightActive = p62;
    v64.ResetNightTrackActive = v65;
    applyMusicState(v64);
end;

function v10.Start() -- Line: 614
    -- upvalues: resolveRuntime (copy), refillOutsideOrder (copy), applyMusicState (copy), ensureTreadmillStates (copy), SettingsCmds (copy), Variables (copy), Network (copy), Treadmills2 (copy), Treadmills (copy), RunService (copy), updateGameplayAreaState (copy)
    local u66 = resolveRuntime();

    if u66.Started then
        return;
    end;

    u66.Started = true;

    for i, v in ipairs(u66.OutsideStates) do
        u66.Trove:Add(v.Sound.Ended:Connect(function() -- Line: 623
            -- upvalues: u66 (copy), i (copy), refillOutsideOrder (ref), applyMusicState (ref)
            local v67 = u66;

            if i ~= v67.CurrentOutsideIndex then
                return;
            end;

            v67.CurrentOutsideOrderPosition = v67.CurrentOutsideOrderPosition + 1;

            if v67.CurrentOutsideOrderPosition > #v67.OutsideOrder then
                refillOutsideOrder(v67);
            else
                v67.CurrentOutsideIndex = assert(v67.OutsideOrder[v67.CurrentOutsideOrderPosition], "MusicController outside playlist order position must reference a track");
            end;

            applyMusicState(v67);
        end));
    end;

    for i, v in ipairs((ensureTreadmillStates(u66))) do
        u66.Trove:Add(v.Sound.Ended:Connect(function() -- Line: 629
            -- upvalues: u66 (copy), i (copy), applyMusicState (ref)
            local v68 = u66;
            local v69;

            if v68.MusicEnabled then
                if v68.ResetNightActive then
                    v69 = "ResetNight";
                elseif v68.NonDefaultTreadmillActive then
                    v69 = "Treadmill";
                elseif v68.GuardedGameplayActive then
                    v69 = "Muted";
                elseif v68.GameplayAreaActive then
                    v69 = v68.CarryingAreaEgg and "GuardedGameplay" or "GameplayBackground";
                else
                    v69 = v68.UiHidden and "Muted" or (v68.SaveZoneActive and "SaveZone" or "Outside");
                end;
            else
                v69 = "Muted";
            end;

            if v69 ~= "Treadmill" then
                return;
            end;

            if i ~= v68.CurrentTreadmillIndex then
                return;
            end;

            v68.CurrentTreadmillIndex = v68.CurrentTreadmillIndex + 1;

            if v68.CurrentTreadmillIndex > #v68.TreadmillStates then
                v68.CurrentTreadmillIndex = 1;
            end;

            applyMusicState(v68);
        end));
    end;

    u66.Trove:Add(SettingsCmds.Changed:Connect(function(p70, p71) -- Line: 634
        -- upvalues: u66 (copy), applyMusicState (ref)
        if p70 ~= "Music" then
            return;
        end;

        u66.MusicEnabled = p71;
        applyMusicState(u66);
    end));
    u66.Trove:Add(Variables.Locks.HideUI.Modified:Connect(function() -- Line: 643
        -- upvalues: u66 (copy), Variables (ref), applyMusicState (ref)
        u66.UiHidden = Variables.Locks.HideUI:IsLocked();
        applyMusicState(u66);
    end));
    u66.Trove:Add(Variables.Locks.GuardedGameplayMusic.Modified:Connect(function() -- Line: 648
        -- upvalues: u66 (copy), Variables (ref), applyMusicState (ref)
        u66.GuardedGameplayActive = Variables.Locks.GuardedGameplayMusic:IsLocked();
        applyMusicState(u66);
    end));
    u66.Trove:Add(Variables.Locks.AreaEggRunBack.Modified:Connect(function() -- Line: 653
        -- upvalues: u66 (copy), Variables (ref), applyMusicState (ref)
        u66.CarryingAreaEgg = Variables.Locks.AreaEggRunBack:IsLocked();
        applyMusicState(u66);
    end));
    u66.Trove:Add(Network.Fired(Treadmills2.ACTIVE_TREADMILL_EVENT):Connect(function(p72) -- Line: 658
        -- upvalues: Treadmills (ref), u66 (copy), applyMusicState (ref)
        local v73;

        if p72 == nil then
            v73 = false;
        else
            local v74 = Treadmills.GetUpgradeLevel(p72) ~= nil;
            local v75 = `Missing treadmill config "{p72}"`;
            assert(v74, v75);
            v73 = true;
        end;

        u66.NonDefaultTreadmillActive = v73;
        applyMusicState(u66);
    end));
    u66.Trove:Add(RunService.Heartbeat:Connect(function(p76) -- Line: 669
        -- upvalues: u66 (copy), updateGameplayAreaState (ref)
        local v77 = u66;
        v77.GameplaySideScanAccumulator = v77.GameplaySideScanAccumulator + p76;

        if u66.GameplaySideScanAccumulator < 0.1 then
            return;
        end;

        u66.GameplaySideScanAccumulator = 0;
        updateGameplayAreaState(u66);
    end));
    updateGameplayAreaState(u66);
    applyMusicState(u66);
end;

v10.Start();

return v10;