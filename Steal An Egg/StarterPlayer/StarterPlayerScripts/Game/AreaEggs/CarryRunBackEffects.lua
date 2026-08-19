-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
require(ReplicatedStorage.Library.Types.AreaEggs);
local Audio = require(ReplicatedStorage.Library.Audio);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local ScreenEffects = require(script.ScreenEffects);
local HideImportantUI = require(ReplicatedStorage.Library.Client.HideImportantUI);
local Player = require(ReplicatedStorage.Library.Player);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Variables = require(ReplicatedStorage.Library.Variables);
local LocalPlayer = Players.LocalPlayer;
local __OBJECTS = Workspace.__OBJECTS;
local v1 = __OBJECTS:IsA("Folder");
assert(v1, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v2 = Areas:IsA("Folder");
assert(v2, "Workspace.__OBJECTS.Areas must be a Folder");
local GuardAreas = Areas.GuardAreas;
local v3 = GuardAreas:IsA("Folder");
assert(v3, "Workspace.__OBJECTS.Areas.GuardAreas must be a Folder");
local u4 = nil;
local v5 = {};

local function releaseMusicLock(p6) -- Line: 56
    local ReleaseMusicLock = p6.ReleaseMusicLock;

    if ReleaseMusicLock == nil then
        return;
    end;

    p6.ReleaseMusicLock = nil;
    ReleaseMusicLock();
end;

local function releaseUiHideLock(p7) -- Line: 66
    local ReleaseUiHideLock = p7.ReleaseUiHideLock;

    if ReleaseUiHideLock == nil then
        return;
    end;

    p7.ReleaseUiHideLock = nil;
    ReleaseUiHideLock();
end;

local function releaseRunBackActiveLock(p8) -- Line: 76
    local ReleaseRunBackActiveLock = p8.ReleaseRunBackActiveLock;

    if ReleaseRunBackActiveLock == nil then
        return;
    end;

    p8.ReleaseRunBackActiveLock = nil;
    ReleaseRunBackActiveLock();
end;

local function cancelGuardStateWait(p9) -- Line: 86
    local GuardStateConnection = p9.GuardStateConnection;

    if GuardStateConnection == nil then
        return;
    end;

    p9.GuardStateConnection = nil;
    GuardStateConnection:Disconnect();
end;

local function obtainUiHideLock() -- Line: 96
    -- upvalues: HideImportantUI (copy)
    local u10 = false;
    HideImportantUI:Hide();

    return function() -- Line: 100
        -- upvalues: u10 (ref), HideImportantUI (ref)
        if u10 then
            return;
        end;

        u10 = true;
        HideImportantUI:UnHide();
    end;
end;

local function releaseMusicLockForGeneration(p11, p12) -- Line: 110
    if p11.MusicLockGeneration ~= p12 then
        return;
    end;

    local ReleaseMusicLock = p11.ReleaseMusicLock;

    if ReleaseMusicLock == nil then
        return;
    end;

    p11.ReleaseMusicLock = nil;
    ReleaseMusicLock();
end;

local function stopRunBackState(p13) -- Line: 118
    local GuardStateConnection = p13.GuardStateConnection;

    if GuardStateConnection ~= nil then
        p13.GuardStateConnection = nil;
        GuardStateConnection:Disconnect();
    end;

    if not p13.Active then
        return;
    end;

    p13.Active = false;
    p13.Effects:Stop();
    local ReleaseMusicLock = p13.ReleaseMusicLock;

    if ReleaseMusicLock ~= nil then
        p13.ReleaseMusicLock = nil;
        ReleaseMusicLock();
    end;

    local ReleaseRunBackActiveLock = p13.ReleaseRunBackActiveLock;

    if ReleaseRunBackActiveLock == nil then
        return;
    end;

    p13.ReleaseRunBackActiveLock = nil;
    ReleaseRunBackActiveLock();
end;

local function startCarryState(p14) -- Line: 130
    -- upvalues: Player (copy), LocalPlayer (copy), HideImportantUI (copy)
    if p14.ReleaseUiHideLock ~= nil then
        return;
    end;

    local v15 = Player.Optional.Humanoid(LocalPlayer);

    if v15 ~= nil then
        v15:UnequipTools();
    end;

    local u16 = false;
    HideImportantUI:Hide();

    function p14.ReleaseUiHideLock() -- Line: 100
        -- upvalues: u16 (ref), HideImportantUI (ref)
        if u16 then
            return;
        end;

        u16 = true;
        HideImportantUI:UnHide();
    end;
end;

local function stopCarryState(p17) -- Line: 143
    p17.CarryGeneration = p17.CarryGeneration + 1;
    local GuardStateConnection = p17.GuardStateConnection;

    if GuardStateConnection ~= nil then
        p17.GuardStateConnection = nil;
        GuardStateConnection:Disconnect();
    end;

    if p17.Active then
        p17.Active = false;
        p17.Effects:Stop();
        local ReleaseMusicLock = p17.ReleaseMusicLock;

        if ReleaseMusicLock ~= nil then
            p17.ReleaseMusicLock = nil;
            ReleaseMusicLock();
        end;

        local ReleaseRunBackActiveLock = p17.ReleaseRunBackActiveLock;

        if ReleaseRunBackActiveLock ~= nil then
            p17.ReleaseRunBackActiveLock = nil;
            ReleaseRunBackActiveLock();
        end;
    end;

    local ReleaseUiHideLock = p17.ReleaseUiHideLock;

    if ReleaseUiHideLock == nil then
        return;
    end;

    p17.ReleaseUiHideLock = nil;
    ReleaseUiHideLock();
end;

local function startRunBackState(u18) -- Line: 149
    -- upvalues: Variables (copy), Audio (copy)
    local GuardStateConnection = u18.GuardStateConnection;

    if GuardStateConnection ~= nil then
        u18.GuardStateConnection = nil;
        GuardStateConnection:Disconnect();
    end;

    if u18.Active then
        return;
    end;

    u18.Active = true;
    u18.MusicLockGeneration = u18.MusicLockGeneration + 1;
    local MusicLockGeneration = u18.MusicLockGeneration;
    u18.ReleaseRunBackActiveLock = Variables.Locks.AreaEggRunBack:ObtainLock();
    u18.ReleaseMusicLock = Variables.Locks.GuardedGameplayMusic:ObtainLock();
    u18.Effects:Start();
    local v19 = Audio.Play("rbxassetid://113113198465358", script, 1.07, 2);

    if v19 ~= nil and v19.SoundId ~= "" then
        u18.Trove:Add(v19.Ended:Once(function() -- Line: 167
            -- upvalues: u18 (copy), MusicLockGeneration (copy)
            local v20 = u18;

            if MusicLockGeneration ~= v20.MusicLockGeneration then
                return;
            end;

            local ReleaseMusicLock = v20.ReleaseMusicLock;

            if ReleaseMusicLock == nil then
                return;
            end;

            v20.ReleaseMusicLock = nil;
            ReleaseMusicLock();
        end));
        u18.Trove:Add(v19.Stopped:Once(function() -- Line: 170
            -- upvalues: u18 (copy), MusicLockGeneration (copy)
            local v21 = u18;

            if MusicLockGeneration ~= v21.MusicLockGeneration then
                return;
            end;

            local ReleaseMusicLock = v21.ReleaseMusicLock;

            if ReleaseMusicLock == nil then
                return;
            end;

            v21.ReleaseMusicLock = nil;
            ReleaseMusicLock();
        end));

        return;
    end;

    if u18.MusicLockGeneration ~= MusicLockGeneration then
        return;
    end;

    local ReleaseMusicLock = u18.ReleaseMusicLock;

    if ReleaseMusicLock == nil then
        return;
    end;

    u18.ReleaseMusicLock = nil;
    ReleaseMusicLock();
end;

local function startWhenGuardWakeFinishes(u22, p23) -- Line: 175
    -- upvalues: startRunBackState (copy), GuardAreas (copy)
    u22.CarryGeneration = u22.CarryGeneration + 1;
    local CarryGeneration = u22.CarryGeneration;
    local GuardStateConnection = u22.GuardStateConnection;

    if GuardStateConnection ~= nil then
        u22.GuardStateConnection = nil;
        GuardStateConnection:Disconnect();
    end;

    if u22.Active then
        return;
    end;

    if p23.RunBackWakeDelayRequired ~= true then
        startRunBackState(u22);

        return;
    end;

    local AreaId = p23.AreaId;
    assert(AreaId ~= nil, "Carried area egg state must include AreaId");
    local v24 = GuardAreas[AreaId];
    local v25 = `Workspace.__OBJECTS.Areas.GuardAreas.{AreaId} is required`;
    assert(v24 ~= nil, v25);
    local v26 = v24:IsA("Model");
    local v27 = `Workspace.__OBJECTS.Areas.GuardAreas.{AreaId} must be a Model`;
    assert(v26, v27);
    local Guard = v24.Guard;
    local v28 = `{v24:GetFullName()}.Guard is required`;
    assert(Guard ~= nil, v28);
    local v29 = Guard:IsA("Model");
    local v30 = `{v24:GetFullName()}.Guard must be a Model`;
    assert(v29, v30);

    if Guard:GetAttribute("GuardState") == "Chasing" then
        startRunBackState(u22);

        return;
    end;

    u22.GuardStateConnection = Guard:GetAttributeChangedSignal("GuardState"):Connect(function() -- Line: 204
        -- upvalues: u22 (copy), CarryGeneration (copy), Guard (copy), startRunBackState (ref)
        if u22.CarryGeneration ~= CarryGeneration then
            return;
        end;

        if Guard:GetAttribute("GuardState") ~= "Chasing" then
            return;
        end;

        startRunBackState(u22);
    end);
end;

local function applyCarryState(p31, p32) -- Line: 217
    -- upvalues: Player (copy), LocalPlayer (copy), HideImportantUI (copy), startWhenGuardWakeFinishes (copy)
    if p32.IsCarrying then
        if p31.ReleaseUiHideLock == nil then
            local v33 = Player.Optional.Humanoid(LocalPlayer);

            if v33 ~= nil then
                v33:UnequipTools();
            end;

            local u34 = false;
            HideImportantUI:Hide();

            function p31.ReleaseUiHideLock() -- Line: 100
                -- upvalues: u34 (ref), HideImportantUI (ref)
                if u34 then
                    return;
                end;

                u34 = true;
                HideImportantUI:UnHide();
            end;
        end;

        startWhenGuardWakeFinishes(p31, p32);

        return;
    end;

    p31.CarryGeneration = p31.CarryGeneration + 1;
    local GuardStateConnection = p31.GuardStateConnection;

    if GuardStateConnection ~= nil then
        p31.GuardStateConnection = nil;
        GuardStateConnection:Disconnect();
    end;

    if p31.Active then
        p31.Active = false;
        p31.Effects:Stop();
        local ReleaseMusicLock = p31.ReleaseMusicLock;

        if ReleaseMusicLock ~= nil then
            p31.ReleaseMusicLock = nil;
            ReleaseMusicLock();
        end;

        local ReleaseRunBackActiveLock = p31.ReleaseRunBackActiveLock;

        if ReleaseRunBackActiveLock ~= nil then
            p31.ReleaseRunBackActiveLock = nil;
            ReleaseRunBackActiveLock();
        end;
    end;

    local ReleaseUiHideLock = p31.ReleaseUiHideLock;

    if ReleaseUiHideLock == nil then
        return;
    end;

    p31.ReleaseUiHideLock = nil;
    ReleaseUiHideLock();
end;

local function resolveRuntime() -- Line: 227
    -- upvalues: u4 (ref), ScreenEffects (copy), Trove (copy)
    local v35 = u4;

    if v35 ~= nil then
        return v35;
    end;

    local v36 = {
        Active = false,
        CarryGeneration = 0,
        GuardStateConnection = nil,
        MusicLockGeneration = 0,
        ReleaseMusicLock = nil,
        ReleaseRunBackActiveLock = nil,
        ReleaseUiHideLock = nil,
        Started = false,
        Effects = ScreenEffects.new(),
        Trove = Trove.new()
    };
    u4 = v36;

    return v36;
end;

function v5.Start() -- Line: 253
    -- upvalues: resolveRuntime (copy), EggCmds (copy), Player (copy), LocalPlayer (copy), HideImportantUI (copy), startWhenGuardWakeFinishes (copy)
    local u37 = resolveRuntime();

    if u37.Started then
        return;
    end;

    u37.Started = true;
    u37.Trove:Add(EggCmds.AreaEggCarryStateChanged:Connect(function(p38) -- Line: 261
        -- upvalues: u37 (copy), Player (ref), LocalPlayer (ref), HideImportantUI (ref), startWhenGuardWakeFinishes (ref)
        local v39 = u37;

        if p38.IsCarrying then
            if v39.ReleaseUiHideLock == nil then
                local v40 = Player.Optional.Humanoid(LocalPlayer);

                if v40 ~= nil then
                    v40:UnequipTools();
                end;

                local u41 = false;
                HideImportantUI:Hide();

                function v39.ReleaseUiHideLock() -- Line: 100
                    -- upvalues: u41 (ref), HideImportantUI (ref)
                    if u41 then
                        return;
                    end;

                    u41 = true;
                    HideImportantUI:UnHide();
                end;
            end;

            startWhenGuardWakeFinishes(v39, p38);

            return;
        end;

        v39.CarryGeneration = v39.CarryGeneration + 1;
        local GuardStateConnection = v39.GuardStateConnection;

        if GuardStateConnection ~= nil then
            v39.GuardStateConnection = nil;
            GuardStateConnection:Disconnect();
        end;

        if v39.Active then
            v39.Active = false;
            v39.Effects:Stop();
            local ReleaseMusicLock = v39.ReleaseMusicLock;

            if ReleaseMusicLock ~= nil then
                v39.ReleaseMusicLock = nil;
                ReleaseMusicLock();
            end;

            local ReleaseRunBackActiveLock = v39.ReleaseRunBackActiveLock;

            if ReleaseRunBackActiveLock ~= nil then
                v39.ReleaseRunBackActiveLock = nil;
                ReleaseRunBackActiveLock();
            end;
        end;

        local ReleaseUiHideLock = v39.ReleaseUiHideLock;

        if ReleaseUiHideLock == nil then
            return;
        end;

        v39.ReleaseUiHideLock = nil;
        ReleaseUiHideLock();
    end));
    u37.Trove:Connect(LocalPlayer.CharacterRemoving, function() -- Line: 265
        -- upvalues: u37 (copy)
        local v42 = u37;
        v42.CarryGeneration = v42.CarryGeneration + 1;
        local GuardStateConnection = v42.GuardStateConnection;

        if GuardStateConnection ~= nil then
            v42.GuardStateConnection = nil;
            GuardStateConnection:Disconnect();
        end;

        if v42.Active then
            v42.Active = false;
            v42.Effects:Stop();
            local ReleaseMusicLock = v42.ReleaseMusicLock;

            if ReleaseMusicLock ~= nil then
                v42.ReleaseMusicLock = nil;
                ReleaseMusicLock();
            end;

            local ReleaseRunBackActiveLock = v42.ReleaseRunBackActiveLock;

            if ReleaseRunBackActiveLock ~= nil then
                v42.ReleaseRunBackActiveLock = nil;
                ReleaseRunBackActiveLock();
            end;
        end;

        local ReleaseUiHideLock = v42.ReleaseUiHideLock;

        if ReleaseUiHideLock == nil then
            return;
        end;

        v42.ReleaseUiHideLock = nil;
        ReleaseUiHideLock();
    end);
    u37.Trove:Add(function() -- Line: 268
        -- upvalues: u37 (copy)
        local v43 = u37;
        v43.CarryGeneration = v43.CarryGeneration + 1;
        local GuardStateConnection = v43.GuardStateConnection;

        if GuardStateConnection ~= nil then
            v43.GuardStateConnection = nil;
            GuardStateConnection:Disconnect();
        end;

        if v43.Active then
            v43.Active = false;
            v43.Effects:Stop();
            local ReleaseMusicLock = v43.ReleaseMusicLock;

            if ReleaseMusicLock ~= nil then
                v43.ReleaseMusicLock = nil;
                ReleaseMusicLock();
            end;

            local ReleaseRunBackActiveLock = v43.ReleaseRunBackActiveLock;

            if ReleaseRunBackActiveLock ~= nil then
                v43.ReleaseRunBackActiveLock = nil;
                ReleaseRunBackActiveLock();
            end;
        end;

        local ReleaseUiHideLock = v43.ReleaseUiHideLock;

        if ReleaseUiHideLock == nil then
            return;
        end;

        v43.ReleaseUiHideLock = nil;
        ReleaseUiHideLock();
    end);
end;

return v5;