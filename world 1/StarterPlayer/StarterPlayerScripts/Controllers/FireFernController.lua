-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local FireFernFlags = require(ReplicatedStorage.SharedModules.Flags.FireFernFlags);
local EffectLoadManager = require(ReplicatedStorage.SharedModules.EffectLoadManager);
local v1 = {};
local u2 = {};
local u3 = {};

local function GetDesiredAgeUpdateHz() -- Line: 23
    local success, result = pcall(function() -- Line: 24
        return UserSettings().GameSettings;
    end);

    if not (success and result) then
        return 30;
    end;

    local SavedQualityLevel = result.SavedQualityLevel;
    local v4 = nil;

    if typeof(SavedQualityLevel) == "EnumItem" then
        SavedQualityLevel = SavedQualityLevel.Value;
    elseif type(SavedQualityLevel) ~= "number" then
        SavedQualityLevel = v4;
    end;

    return type(SavedQualityLevel) == "number" and (SavedQualityLevel == 0 and 30 or (SavedQualityLevel >= 7 and 60 or (SavedQualityLevel >= 4 and 25 or 30))) or 60;
end;

local function HzToTick(p5) -- Line: 46
    return p5 <= 0 and 0.02 or 1 / math.clamp(p5, 15, 60);
end;

local function GetSizeFactor(u6) -- Line: 52
    local success, result = pcall(function() -- Line: 53
        -- upvalues: u6 (copy)
        local _, v7 = u6:GetBoundingBox();

        return v7;
    end);

    if not success or typeof(result) ~= "Vector3" then
        return 1;
    end;

    local v8 = math.max(result.X, result.Z) / 13.65;

    return math.max(v8, 1);
end;

local function ScaleFireRig(p9, p10) -- Line: 62
    if p10 <= 0 or p10 == 1 then
        return;
    end;

    if p9:GetAttribute("FireScaled") then
        return;
    end;

    p9:SetAttribute("FireScaled", true);

    if p9:IsA("Attachment") then
        for _, child in p9:GetChildren() do
            if child:IsA("Attachment") then
                local CFrame = child.CFrame;
                child.CFrame = CFrame - CFrame.Position + CFrame.Position * p10;
            end;
        end;
    end;
end;

local function DisableFire(p11) -- Line: 78
    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;
end;

local function EmitFire(p12) -- Line: 87
    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v13 = descendant:GetAttribute("EmitCount");
            local v14 = descendant:GetAttribute("EmitDelay");
            local u15 = typeof(v13) ~= "number" and 1 or v13;
            local v16 = typeof(v14) ~= "number" and 0 or v14;

            if v16 > 0 then
                task.delay(v16, function() -- Line: 95
                    -- upvalues: descendant (copy), u15 (copy)
                    if descendant.Parent then
                        descendant:Emit(u15);
                    end;
                end);
            else
                descendant:Emit(u15);
            end;
        end;
    end;
end;

local function PlayAttackSound(p17) -- Line: 106
    -- upvalues: SoundService (copy), Debris (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("HypnoBloomAttack");
    end;

    if not (SFX and SFX:IsA("Sound")) then
        return;
    end;

    local u18 = SFX:Clone();
    u18.Parent = p17;
    u18:Play();
    u18.Ended:Once(function() -- Line: 117
        -- upvalues: u18 (copy)
        u18:Destroy();
    end);
    Debris:AddItem(u18, 10);
end;

local function FindRig(p19) -- Line: 124
    local v20 = p19.PrimaryPart or p19:FindFirstChild("Base");

    if v20 and v20:IsA("BasePart") then
        return v20:FindFirstChild("FireRing"), v20;
    end;

    return nil, nil;
end;

local function SetupPlant(u21) -- Line: 131
    -- upvalues: u2 (copy), DisableFire (copy), ScaleFireRig (copy)
    local v22 = u21.PrimaryPart or u21:FindFirstChild("Base");
    local v23;

    if v22 and v22:IsA("BasePart") then
        v23 = v22:FindFirstChild("FireRing");
    else
        v23 = nil;
        v22 = nil;
    end;

    local success, result = pcall(function() -- Line: 53
        -- upvalues: u21 (copy)
        local _, v24 = u21:GetBoundingBox();

        return v24;
    end);
    local v25;

    if success and typeof(result) == "Vector3" then
        local v26 = math.max(result.X, result.Z) / 13.65;
        v25 = math.max(v26, 1);
    else
        v25 = 1;
    end;

    u2[u21] = {
        NextEmitAt = 0,
        Model = u21,
        FireRing = v23,
        SizeFactor = v25
    };

    if v23 and v22 then
        DisableFire(v23);
        ScaleFireRig(v23, v25);
    end;
end;

local function IsSpotLit(p27) -- Line: 147
    -- upvalues: u3 (ref)
    for _, v in u3 do
        if (p27 - v).Magnitude <= 5 then
            return true;
        end;
    end;

    return false;
end;

local function RunFireLoop() -- Line: 155
    -- upvalues: GetDesiredAgeUpdateHz (copy), u2 (copy), EffectLoadManager (copy), DisableFire (copy), ScaleFireRig (copy), u3 (ref), EmitFire (copy), PlayAttackSound (copy), FireFernFlags (copy)
    while true do
        local wait = task.wait;
        local v28 = GetDesiredAgeUpdateHz();
        wait(v28 <= 0 and 0.02 or 1 / math.clamp(v28, 15, 60));
        local u29 = os.clock();

        for i, v in u2 do
            if i:IsDescendantOf(workspace) then
                if EffectLoadManager.ShouldAnimateInstance(i, 80) then
                    pcall(function() -- Line: 170
                        -- upvalues: v (copy), i (copy), DisableFire (ref), ScaleFireRig (ref), u3 (ref), u29 (copy), EmitFire (ref), PlayAttackSound (ref), FireFernFlags (ref)
                        local FireRing = v.FireRing;
                        local v30;

                        if FireRing and FireRing.Parent then
                            v30 = i.PrimaryPart or i:FindFirstChild("Base");
                        else
                            local v31 = i;
                            v30 = v31.PrimaryPart or v31:FindFirstChild("Base");

                            if v30 and v30:IsA("BasePart") then
                                FireRing = v30:FindFirstChild("FireRing");
                            else
                                FireRing = nil;
                                v30 = nil;
                            end;

                            v.FireRing = FireRing;

                            if FireRing and v30 then
                                DisableFire(FireRing);
                                ScaleFireRig(FireRing, v.SizeFactor);
                            end;
                        end;

                        if not (FireRing and (v30 and v30:IsA("BasePart"))) then
                            return;
                        end;

                        local Position = v30.Position;
                        local v32 = false;

                        for _, v2 in u3 do
                            if (Position - v2).Magnitude <= 5 then
                                v32 = true;
                                break;
                            end;
                        end;

                        if v32 and u29 >= v.NextEmitAt then
                            EmitFire(FireRing);
                            PlayAttackSound(FireRing);
                            v.NextEmitAt = u29 + FireFernFlags.FireFernRingInterval:Get();
                        end;
                    end);
                end;
            else
                u2[i] = nil;
            end;
        end;
    end;
end;

function v1.Start(p33) -- Line: 196
    -- upvalues: ReplicatedStorage (copy), u3 (ref), CollectionService (copy), SetupPlant (copy), RunFireLoop (copy)
    ReplicatedStorage:WaitForChild("FireFernLit").OnClientEvent:Connect(function(p34) -- Line: 198
        -- upvalues: u3 (ref)
        u3 = p34 or {};
    end);
    CollectionService:GetInstanceAddedSignal("FireFern"):Connect(function(p35) -- Line: 202
        -- upvalues: SetupPlant (ref)
        pcall(SetupPlant, p35);
    end);

    for _, v in CollectionService:GetTagged("FireFern") do
        pcall(SetupPlant, v);
    end;

    task.spawn(RunFireLoop);
end;

return v1;