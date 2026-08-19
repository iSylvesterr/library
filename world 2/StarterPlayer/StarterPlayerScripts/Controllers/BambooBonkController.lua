-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local SoundService = game:GetService("SoundService");
local BambooBonkData = require(ReplicatedStorage.SharedModules.BambooBonkData);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = { "LoadingScreenDone", "OfflineCutscenePlaying", "CutsceneInputBlocked" };
local u4 = nil;

local function isReady() -- Line: 92
    -- upvalues: LocalPlayer (copy)
    local v5;

    if LocalPlayer:GetAttribute("LoadingScreenDone") == true and LocalPlayer:GetAttribute("OfflineCutscenePlaying") ~= true then
        v5 = LocalPlayer:GetAttribute("CutsceneInputBlocked") ~= true;
    else
        v5 = false;
    end;

    return v5;
end;

local function reportReadiness() -- Line: 98
    -- upvalues: LocalPlayer (copy), u4 (ref), Networking (copy)
    local v6;

    if LocalPlayer:GetAttribute("LoadingScreenDone") == true and LocalPlayer:GetAttribute("OfflineCutscenePlaying") ~= true then
        v6 = LocalPlayer:GetAttribute("CutsceneInputBlocked") ~= true;
    else
        v6 = false;
    end;

    if v6 == u4 then
        return;
    end;

    u4 = v6;
    Networking.BambooBonk.SetReady:Fire(v6);
end;

local u7 = nil;

local function isParticipant() -- Line: 115
    -- upvalues: LocalPlayer (copy), BambooBonkData (copy)
    return LocalPlayer:GetAttribute(BambooBonkData.PlayerSlotAttribute) ~= nil;
end;

local function getBambooSound(p8) -- Line: 119
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("BambooBonk");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p8);
    end;

    if SFX and SFX:IsA("Sound") then
        return SFX;
    end;

    return nil;
end;

local function playBambooSound2D(p9) -- Line: 129
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("BambooBonk");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p9);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        return;
    end;

    local u10 = SFX:Clone();
    u10.Looped = false;
    u10.Parent = SoundService;
    u10:Play();
    u10.Ended:Once(function() -- Line: 138
        -- upvalues: u10 (copy)
        u10:Destroy();
    end);
end;

local function stopLaserLoop() -- Line: 143
    -- upvalues: u7 (ref)
    if u7 then
        u7:Stop();
        u7:Destroy();
        u7 = nil;
    end;
end;

local function startLaserLoop() -- Line: 151
    -- upvalues: u7 (ref), SoundService (copy)
    if u7 then
        u7:Stop();
        u7:Destroy();
        u7 = nil;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("BambooBonk");
    end;

    if SFX then
        SFX = SFX:FindFirstChild("BambooBonkLaserLoop");
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        return;
    end;

    local v11 = SFX:Clone();
    v11.Looped = true;
    v11.Parent = SoundService;
    v11:Play();
    u7 = v11;
end;

local function getCFrameAttribute(p12, p13) -- Line: 165
    local v14 = p12:GetAttribute(p13);

    if typeof(v14) == "CFrame" then
        return v14;
    end;

    return nil;
end;

local function findTagged(p15, p16) -- Line: 175
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTagged(p16) do
        if v:IsDescendantOf(p15) then
            return v;
        end;
    end;

    return nil;
end;

local function resolve(p17) -- Line: 187
    -- upvalues: BambooBonkData (copy), CollectionService (copy)
    local Arena = p17.Arena;

    if not p17.Platforms then
        local v18 = Arena:FindFirstChild(BambooBonkData.PlayerPlatformsName, true);
        local v19;

        if v18 then
            v19 = v18:GetAttribute(BambooBonkData.BasePivotAttribute);

            if typeof(v19) ~= "CFrame" then
                v19 = nil;
            end;
        else
            v19 = v18;
        end;

        if v18 and (v18:IsA("Model") and v19) then
            p17.Platforms = v18;
            p17.PlatformsBase = v19;
        end;
    end;

    if p17.Rotating then
        return;
    end;

    for _, v in CollectionService:GetTagged(BambooBonkData.RotatingTag) do
        if v:IsDescendantOf(Arena) then
            break;
        end;
    end;

    if v and v:IsA("Model") then
        local v20 = v:GetAttribute(BambooBonkData.BasePivotAttribute);

        if typeof(v20) ~= "CFrame" then
            v20 = nil;
        end;

        local v21 = v:GetAttribute(BambooBonkData.ArmBaseAttribute);

        if typeof(v21) ~= "CFrame" then
            v21 = nil;
        end;

        local PrimaryPart = v.PrimaryPart;

        if v20 and (v21 and PrimaryPart) then
            p17.Rotating = v;
            p17.RotatingBase = v20;
            p17.Arm = PrimaryPart;
            p17.SpinCenter = v21.Position;
            p17.BaseAngle = BambooBonkData.XZAngle(v21.RightVector.X, v21.RightVector.Z);
        end;
    end;
end;

local function addArena(p22) -- Line: 216
    -- upvalues: u2 (copy), BambooBonkData (copy)
    if u2[p22] or not p22:IsA("Model") then
        return;
    end;

    u2[p22] = {
        RaiseSettled = false,
        Reported = false,
        RiseAudioStarted = false,
        LaserAudioStarted = false,
        Arena = p22,
        Jump = BambooBonkData.NewJumpTracker()
    };
end;

local function removeArena(p23) -- Line: 230
    -- upvalues: u2 (copy), u7 (ref)
    u2[p23] = nil;

    if u7 then
        u7:Stop();
        u7:Destroy();
        u7 = nil;
    end;
end;

local function applyRaiseOffset(p24, p25) -- Line: 240
    -- upvalues: Players (copy), BambooBonkData (copy)
    local Platforms = p24.Platforms;
    local PlatformsBase = p24.PlatformsBase;

    if Platforms and PlatformsBase then
        Platforms:PivotTo(CFrame.new(0, p25, 0) * PlatformsBase);
    end;

    for _, v in Players:GetPlayers() do
        local v26 = v:GetAttribute(BambooBonkData.PlayerAnchorAttribute);

        if typeof(v26) ~= "CFrame" then
            v26 = nil;
        end;

        if v26 then
            local Character = v.Character;

            if Character and Character.Parent then
                Character:PivotTo(CFrame.new(0, p25, 0) * v26);
            end;
        end;
    end;
end;

local function settleRaise(p27, p28) -- Line: 259
    -- upvalues: applyRaiseOffset (copy)
    if p28 then
        applyRaiseOffset(p27, 0);
        p27.RaiseSettled = true;

        return;
    end;

    local Platforms = p27.Platforms;
    local PlatformsBase = p27.PlatformsBase;

    if Platforms and PlatformsBase then
        Platforms:PivotTo(PlatformsBase);
    end;

    p27.RaiseSettled = true;
end;

local function stepRaise(p29, p30) -- Line: 278
    -- upvalues: BambooBonkData (copy), applyRaiseOffset (copy), playBambooSound2D (copy)
    if p29.RaiseSettled or not p29.Platforms then
        return;
    end;

    local v31 = tonumber(p29.Arena:GetAttribute(BambooBonkData.RaiseStartAttribute));

    if not v31 then
        return;
    end;

    local v32 = p29.Arena:GetAttribute(BambooBonkData.SpinStartAttribute) ~= nil;
    local v33 = BambooBonkData.GetRaiseOffset(p30, v31);

    if v33 ~= 0 and not v32 then
        if not p29.RiseAudioStarted and v31 <= p30 then
            p29.RiseAudioStarted = true;
            playBambooSound2D("BambooBonkRise");
        end;

        applyRaiseOffset(p29, v33);

        return;
    end;

    if not v32 then
        applyRaiseOffset(p29, 0);
        p29.RaiseSettled = true;

        return;
    end;

    local Platforms = p29.Platforms;
    local PlatformsBase = p29.PlatformsBase;

    if Platforms and PlatformsBase then
        Platforms:PivotTo(PlatformsBase);
    end;

    p29.RaiseSettled = true;
end;

local function stepSpin(p34, p35) -- Line: 312
    -- upvalues: BambooBonkData (copy), u7 (ref), LocalPlayer (copy), playBambooSound2D (copy), SoundService (copy)
    local Rotating = p34.Rotating;
    local RotatingBase = p34.RotatingBase;
    local SpinCenter = p34.SpinCenter;

    if not (Rotating and (RotatingBase and SpinCenter)) then
        return;
    end;

    local v36 = tonumber(p34.Arena:GetAttribute(BambooBonkData.SpinStartAttribute));

    if not v36 then
        return;
    end;

    local v37 = tonumber(p34.Arena:GetAttribute(BambooBonkData.SpinEndAttribute));

    if v37 then
        p35 = math.min(p35, v37);
    end;

    local v38 = p35 - v36;

    if v37 then
        if u7 then
            u7:Stop();
            u7:Destroy();
            u7 = nil;
        end;

        p34.LaserAudioStarted = true;
    elseif LocalPlayer:GetAttribute(BambooBonkData.PlayerSlotAttribute) ~= nil then
        if not p34.LaserAudioStarted then
            p34.LaserAudioStarted = true;
            playBambooSound2D("BambooBonkLaserSpawn");

            if u7 then
                u7:Stop();
                u7:Destroy();
                u7 = nil;
            end;

            local SFX = SoundService:FindFirstChild("SFX");

            if SFX then
                SFX = SFX:FindFirstChild("BambooBonk");
            end;

            if SFX then
                SFX = SFX:FindFirstChild("BambooBonkLaserLoop");
            end;

            if not (SFX and SFX:IsA("Sound")) then
                SFX = nil;
            end;

            if SFX then
                local v39 = SFX:Clone();
                v39.Looped = true;
                v39.Parent = SoundService;
                v39:Play();
                u7 = v39;
            end;
        end;
    elseif u7 then
        u7:Stop();
        u7:Destroy();
        u7 = nil;
    end;

    Rotating:PivotTo(CFrame.new(SpinCenter) * CFrame.Angles(0, BambooBonkData.GetSpinAngle(v38), 0) * CFrame.new(-SpinCenter) * RotatingBase);
    local Arm = p34.Arm;

    if Arm and not v37 then
        Arm.Size = BambooBonkData.GetArmSize(v38);
    end;
end;

local function stepLocalHit(p40, p41) -- Line: 369
    -- upvalues: BambooBonkData (copy), LocalPlayer (copy), Networking (copy)
    local SpinCenter = p40.SpinCenter;
    local BaseAngle = p40.BaseAngle;

    if p40.Reported or not (SpinCenter and BaseAngle) then
        return;
    end;

    local v42 = tonumber(p40.Arena:GetAttribute(BambooBonkData.SpinStartAttribute));

    if not v42 or p40.Arena:GetAttribute(BambooBonkData.SpinEndAttribute) ~= nil then
        return;
    end;

    if LocalPlayer:GetAttribute(BambooBonkData.PlayerSlotAttribute) == nil then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not (Character and Character.Parent) then
        return;
    end;

    local v43 = p41 - v42;
    local v44 = p40.CheckedElapsed or v43;
    p40.CheckedElapsed = v43;
    local v45 = BambooBonkData.GetBodySpanY(Character);
    BambooBonkData.TrackJump(p40.Jump, v45, p41);

    if BambooBonkData.IsJumpForgiven(p40.Jump, p41) then
        return;
    end;

    if BambooBonkData.WasSweptInto(Character, SpinCenter, BaseAngle, v44, v43) then
        p40.Reported = true;
        Networking.BambooBonk.ReportHit:Fire(p41);
    end;
end;

local function step() -- Line: 410
    -- upvalues: u2 (copy), u7 (ref), resolve (copy), stepRaise (copy), stepSpin (copy), stepLocalHit (copy)
    local v46 = workspace:GetServerTimeNow();

    for i, v in u2 do
        if i.Parent then
            if not (v.Platforms and v.Rotating) then
                resolve(v);
            end;

            stepRaise(v, v46);
            stepSpin(v, v46);
            stepLocalHit(v, v46);
        else
            u2[i] = nil;

            if u7 then
                u7:Stop();
                u7:Destroy();
                u7 = nil;
            end;
        end;
    end;
end;

function v1.Init(p47) -- Line: 427
end;

function v1.Start(p48) -- Line: 429
    -- upvalues: u3 (copy), LocalPlayer (copy), reportReadiness (copy), u4 (ref), Networking (copy), CollectionService (copy), BambooBonkData (copy), addArena (copy), removeArena (copy), RunService (copy), step (copy)
    for _, v in u3 do
        LocalPlayer:GetAttributeChangedSignal(v):Connect(reportReadiness);
    end;

    local v49;

    if LocalPlayer:GetAttribute("LoadingScreenDone") == true and LocalPlayer:GetAttribute("OfflineCutscenePlaying") ~= true then
        v49 = LocalPlayer:GetAttribute("CutsceneInputBlocked") ~= true;
    else
        v49 = false;
    end;

    if v49 ~= u4 then
        u4 = v49;
        Networking.BambooBonk.SetReady:Fire(v49);
    end;

    for _, v in CollectionService:GetTagged(BambooBonkData.ArenaTag) do
        addArena(v);
    end;

    CollectionService:GetInstanceAddedSignal(BambooBonkData.ArenaTag):Connect(addArena);
    CollectionService:GetInstanceRemovedSignal(BambooBonkData.ArenaTag):Connect(removeArena);
    RunService.RenderStepped:Connect(step);
end;

return v1;