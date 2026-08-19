-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ToolSetup = require(ReplicatedStorage.Library.Util.ToolSetup);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local LaserCap = require(ReplicatedStorage.Directory.Gears._Index.Other.LaserCap);
local LaserCap2 = Constants.NETWORK_MAP.LaserCap;
local COOLDOWN = LaserCap.COOLDOWN;
local beamTrail = ReplicatedStorage.Assets.ToolEffects:FindFirstChild("beamTrail");
local LocalPlayer = Players.LocalPlayer;

local function findTargetPart(p1) -- Line: 30
    -- upvalues: LocalPlayer (copy), Workspace (copy)
    local v2 = RaycastParams.new();
    v2.FilterType = Enum.RaycastFilterType.Exclude;

    if LocalPlayer.Character then
        v2.FilterDescendantsInstances = { LocalPlayer.Character };
    end;

    local v3 = Workspace:Raycast(p1, Vector3.new(0, -0.1, 0), v2);

    if v3 and v3.Instance then
        return v3.Instance;
    end;

    return nil;
end;

local function spawnBeamEffect(p4, p5) -- Line: 45
    -- upvalues: beamTrail (copy), Workspace (copy), findTargetPart (copy)
    if not beamTrail then
        warn("[LaserCap] Beam effect template not found");

        return;
    end;

    local u6 = beamTrail:Clone();
    u6.Parent = Workspace;
    local v7 = u6:FindFirstChildWhichIsA("Beam", true);

    if not v7 then
        u6:Destroy();

        return;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "LaserCapBeamStart";
    Attachment.Parent = p4;
    local v8 = findTargetPart(p5);
    local u9;

    if v8 then
        u9 = nil;
    else
        v8 = Instance.new("Part");
        v8.Name = "LaserCapBeamEndAnchor";
        v8.Anchored = true;
        v8.CanCollide = false;
        v8.CanTouch = false;
        v8.CanQuery = false;
        v8.Transparency = 1;
        v8.Size = Vector3.new(0.2, 0.2, 0.2);
        v8.CFrame = CFrame.new(p5);
        v8.Parent = Workspace;
        u9 = v8;
    end;

    local Attachment2 = Instance.new("Attachment");
    Attachment2.Name = "LaserCapBeamEnd";
    Attachment2.Parent = v8;
    Attachment2.WorldPosition = p5;
    v7.Attachment0 = Attachment;
    v7.Attachment1 = Attachment2;
    task.delay(0.3, function() -- Line: 93
        -- upvalues: Attachment (copy), Attachment2 (copy), u9 (ref), u6 (copy)
        if Attachment.Parent then
            Attachment:Destroy();
        end;

        if Attachment2.Parent then
            Attachment2:Destroy();
        end;

        if u9 and u9.Parent then
            u9:Destroy();
        end;

        u6:Destroy();
    end);
end;

local function playBeamVFX(p10, p11) -- Line: 110
    -- upvalues: spawnBeamEffect (copy)
    spawnBeamEffect(p10, p11);
end;

local function playSFX(p12) -- Line: 114
end;

local function getHeadPosition() -- Line: 116
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local Head = Character:FindFirstChild("Head");

    if Head and Head:IsA("BasePart") then
        return Head;
    end;

    return nil;
end;

local u16 = ToolSetup.Initialize(LaserCap.DisplayName, {
    onActivated = function(p13) -- Line: 130, Name: onActivated
        -- upvalues: LocalPlayer (copy), Network (copy), LaserCap2 (copy)
        if not LocalPlayer.Character then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v14;

        if Character then
            v14 = Character:FindFirstChild("Head");

            if not (v14 and v14:IsA("BasePart")) then
                v14 = nil;
            end;
        else
            v14 = nil;
        end;

        if not v14 then
            return;
        end;

        local v15 = LocalPlayer:GetMouse().Hit.Position - v14.Position;
        local Magnitude = v15.Magnitude;

        if Magnitude == 0 or Magnitude ~= Magnitude then
            return;
        end;

        Network.Fire(LaserCap2.REQUEST_FIRE, v14.Position, v15.Unit);
    end
});
Network.Fired(LaserCap2.PLAY_BEAM_VFX):Connect(function(p17, p18) -- Line: 158
    -- upvalues: spawnBeamEffect (copy), ToolSetup (copy), u16 (ref), COOLDOWN (copy)
    spawnBeamEffect(p17, p18);
    ToolSetup.StartCooldown(u16, COOLDOWN);
end);
Network.Fired(LaserCap2.PLAY_SFX):Connect(function(p19) -- Line: 163
end);