-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CamShake = require(ReplicatedStorage.ClientModules.CamShake);
local Presets = CamShake.Presets;
local LocalPlayer = Players.LocalPlayer;
local u2 = 0;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 0;

local function stopShake() -- Line: 61
    -- upvalues: u5 (ref), u2 (ref), u6 (ref), u3 (ref), u4 (ref), TweenService (copy)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    u2 = 0;
    u6 = 0;

    if u3 then
        u3:StartFadeOut(1.5);
        u3 = nil;
    end;

    local u7 = u4;
    u4 = nil;

    if u7 then
        local v8 = TweenService:Create(u7, TweenInfo.new(1), {
            Volume = 0
        });
        v8.Completed:Once(function() -- Line: 80
            -- upvalues: u7 (copy)
            u7:Destroy();
        end);
        v8:Play();
    end;
end;

local function startRumble() -- Line: 87
    -- upvalues: SoundService (copy), TweenService (copy), u4 (ref)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Earthquake");
    end;

    if not (SFX and SFX:IsA("Sound")) then
        return;
    end;

    local v9 = SFX:Clone();
    v9.Name = "BeanstalkShakeRumble";
    v9.Volume = 0;
    v9.Looped = true;
    v9.Parent = SoundService;
    v9:Play();
    TweenService:Create(v9, TweenInfo.new(1), {
        Volume = 0.7
    }):Play();
    u4 = v9;
end;

local function stepJolts(p10) -- Line: 105
    -- upvalues: u2 (ref), LocalPlayer (copy), stopShake (copy), u6 (ref)
    if u2 <= os.clock() or LocalPlayer:GetAttribute("InBeanstalkClimb") ~= true then
        stopShake();

        return;
    end;

    u6 = u6 + p10;

    if u6 < 0.45 then
        return;
    end;

    u6 = u6 - 0.45;
    local Character = LocalPlayer.Character;
    local v11;

    if Character then
        v11 = Character:FindFirstChild("HumanoidRootPart");
    else
        v11 = nil;
    end;

    if not (v11 and v11:IsA("BasePart")) then
        return;
    end;

    local v12 = math.random() * 2 * 3.141592653589793;
    local AssemblyLinearVelocity = v11.AssemblyLinearVelocity;
    local v13 = math.cos(v12) * 13;
    local v14 = math.sin(v12) * 13;
    v11.AssemblyLinearVelocity = AssemblyLinearVelocity + Vector3.new(v13, 0, v14);
end;

local function onShake(p15) -- Line: 130
    -- upvalues: LocalPlayer (copy), u2 (ref), u5 (ref), u3 (ref), CamShake (copy), Presets (copy), startRumble (copy), u6 (ref), RunService (copy), stepJolts (copy)
    if LocalPlayer:GetAttribute("InBeanstalkClimb") ~= true then
        return;
    end;

    local v16 = (typeof(p15) ~= "number" or p15 <= 0) and 6 or p15;
    local v17 = os.clock() + v16;
    u2 = math.max(u2, v17);

    if u5 then
        return;
    end;

    u3 = CamShake:ShakeSustain(Presets.Earthquake);
    startRumble();
    u6 = 0;
    u5 = RunService.Heartbeat:Connect(stepJolts);
end;

function v1.Init(p18) -- Line: 150
    -- upvalues: Networking (copy), onShake (copy), LocalPlayer (copy), u5 (ref), stopShake (copy)
    Networking.Beanstalk.Shake.OnClientEvent:Connect(onShake);
    LocalPlayer:GetAttributeChangedSignal("InBeanstalkClimb"):Connect(function() -- Line: 153
        -- upvalues: LocalPlayer (ref), u5 (ref), stopShake (ref)
        if LocalPlayer:GetAttribute("InBeanstalkClimb") ~= true and u5 then
            stopShake();
        end;
    end);
end;

function v1.Start(p19) -- Line: 160
end;

return v1;