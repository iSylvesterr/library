-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ContextActionService = game:GetService("ContextActionService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local HypnoBloomFlags = require(game.ReplicatedStorage.SharedModules.Flags.HypnoBloomFlags);
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local EffectLoadManager = require(game.ReplicatedStorage.SharedModules.EffectLoadManager);
local LocalPlayer = Players.LocalPlayer;
local u1 = false;
local v2 = {};
local v3 = 0;
local v4 = game.ReplicatedStorage.PlantGenerationModules.Fruits:FindFirstChild("Hypno Bloom");

if v4 then
    v4 = v4:FindFirstChild("Emitter");
end;

if v4 then
    for _, descendant in v4:GetDescendants() do
        if descendant:IsA("ParticleEmitter") and descendant.Name == "big ring" then
            for _, v in descendant.Size.Keypoints do
                v3 = math.max(v3, v.Value);
            end;
        end;
    end;
end;

local function hzToTick(p5) -- Line: 63
    return p5 <= 0 and 0.02 or 1 / math.clamp(p5, 15, 60);
end;

local function isNightNow() -- Line: 70
    local Night = game.ReplicatedStorage:FindFirstChild("Night");

    return Night and (Night:IsA("BoolValue") and Night.Value == true) and true or workspace:GetAttribute("ActivePhase") == "Night";
end;

local function isInPlantGarden(p6, p7) -- Line: 81
    local PetState = p6:FindFirstChild("PetState");

    if PetState then
        PetState = PetState:FindFirstChild("InGarden");
    end;

    if not (PetState and PetState:IsA("StringValue")) then
        return false;
    end;

    if PetState.Value == "" then
        return false;
    end;

    return (not p7 or p7 == "") and true or PetState.Value == p7;
end;

local function getSizeFactor(p8) -- Line: 94
    local _, v9 = p8:GetBoundingBox();
    local v10 = math.max(v9.X, v9.Z) / 19;

    return math.max(1, v10);
end;

local function getPlantModel(p11) -- Line: 103
    local Parent = p11.Parent;

    if Parent and Parent.Name == "Fruits" then
        local Parent2 = Parent.Parent;

        if Parent2 and Parent2:IsA("Model") then
            return Parent2;
        end;
    end;

    return p11;
end;

local function getBaseRadius(p12) -- Line: 116
    -- upvalues: HypnoBloomFlags (copy)
    local v13 = p12:GetAttribute("PulseRadius");

    if typeof(v13) == "number" and v13 > 0 then
        return v13;
    end;

    return HypnoBloomFlags.PulseRadius:Get();
end;

local function scaleEmitterSizes(p14, p15) -- Line: 142
    if p15 <= 0 or p15 == 1 then
        return;
    end;

    if p14:GetAttribute("PulseScaled") then
        return;
    end;

    p14:SetAttribute("PulseScaled", true);

    if p14:IsA("Attachment") then
        for _, child in p14:GetChildren() do
            if child:IsA("Attachment") then
                local CFrame2 = child.CFrame;
                child.CFrame = CFrame2 - CFrame2.Position + CFrame2.Position * p15;
            end;
        end;
    end;

    for _, descendant in p14:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v16 = {};

            for _, v in descendant.Size.Keypoints do
                table.insert(v16, NumberSequenceKeypoint.new(v.Time, v.Value * p15, v.Envelope * p15));
            end;

            descendant.Size = NumberSequence.new(v16);
            descendant.Speed = NumberRange.new(descendant.Speed.Min * p15, descendant.Speed.Max * p15);
            descendant.Acceleration = descendant.Acceleration * p15;
        end;
    end;
end;

local function disableAllEmitters(p17) -- Line: 207
    for _, descendant in p17:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            descendant.Enabled = false;
        end;
    end;
end;

local u18 = {};

local function setupPlant(u19) -- Line: 217
    -- upvalues: u18 (copy), Players (copy), disableAllEmitters (copy), scaleEmitterSizes (copy)
    local v20 = u19:GetAttribute("UserId");
    local v21 = {
        Mode = "Idle",
        PhaseEndsAt = 0,
        CooldownUntil = 0,
        LocalHitCooldownUntil = 0,
        HitThisPulse = false,
        SizeFactor = 1,
        Model = u19
    };
    local v22;

    if typeof(v20) == "number" then
        v22 = Players:GetPlayerByUserId(v20);
    else
        v22 = nil;
    end;

    v21.Owner = v22;
    u18[u19] = v21;
    local Base = u19:FindFirstChild("Base");
    local u23;

    if Base then
        u23 = Base:FindFirstChild("Emitter");
    else
        u23 = Base;
    end;

    if not u23 then
        return;
    end;

    disableAllEmitters(u23);
    task.spawn(function() -- Line: 242
        -- upvalues: u19 (copy), u18 (ref), scaleEmitterSizes (ref), u23 (copy), Base (copy)
        local v24 = u19;

        for _ = 1, 60 do
            v24 = u19;
            local Parent = v24.Parent;

            if Parent and Parent.Name == "Fruits" then
                local Parent2 = Parent.Parent;

                if Parent2 and Parent2:IsA("Model") then
                    v24 = Parent2;
                end;
            end;

            if v24 ~= u19 then
                break;
            end;

            task.wait();
        end;

        local _, v25 = v24:GetBoundingBox();
        local v26 = math.max(v25.X, v25.Z) / 19;
        local v27 = math.max(1, v26);
        local v28 = u18[u19];

        if v28 then
            v28.SizeFactor = v27;
        end;

        scaleEmitterSizes(u23, v27);

        if u23:IsA("Attachment") and Base:IsA("BasePart") then
            local v29, v30 = v24:GetBoundingBox();
            u23.WorldCFrame = CFrame.new(v29.Position.X, v29.Position.Y - v30.Y / 2, v29.Position.Z);
        end;
    end);
end;

CollectionService:GetInstanceAddedSignal("HypnoBloom"):Connect(function(u31) -- Line: 261
    -- upvalues: setupPlant (copy)
    local success, result = pcall(function() -- Line: 262
        -- upvalues: setupPlant (ref), u31 (copy)
        setupPlant(u31);
    end);

    if not success then
        warn((`[HypnoBloomController] setup failed for {u31:GetFullName()}: {result}`));
    end;
end);

local function setSustainedEmitters(p32, p33) -- Line: 169
    for _, descendant in p32:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v34 = descendant:GetAttribute("EmitDuration");

            if typeof(v34) == "number" and v34 > 0 then
                descendant.Enabled = p33;
            end;
        end;
    end;
end;

local function playAttackSound(p35) -- Line: 126
    -- upvalues: SoundService (copy), Debris (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("HypnoBloomAttack");
    end;

    if not (SFX and SFX:IsA("Sound")) then
        return;
    end;

    local u36 = SFX:Clone();
    u36.Parent = p35;
    u36:Play();
    u36.Ended:Once(function() -- Line: 134
        -- upvalues: u36 (copy)
        u36:Destroy();
    end);
    Debris:AddItem(u36, 10);
end;

local function fireBurstEmitters(p37) -- Line: 182
    for _, descendant in p37:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local v38 = descendant:GetAttribute("EmitDuration");

            if typeof(v38) ~= "number" or v38 <= 0 then
                local v39 = descendant:GetAttribute("EmitCount");
                local u40 = typeof(v39) ~= "number" and 1 or v39;
                local v41 = descendant:GetAttribute("EmitDelay");
                local v42 = typeof(v41) ~= "number" and 0 or v41;

                if v42 > 0 then
                    task.delay(v42, function() -- Line: 194
                        -- upvalues: descendant (copy), u40 (copy)
                        if descendant.Parent then
                            descendant:Emit(u40);
                        end;
                    end);
                else
                    descendant:Emit(u40);
                end;
            end;
        end;
    end;
end;

local function getDesiredAgeUpdateHz() -- Line: 41
    local success, result = pcall(function() -- Line: 42
        return UserSettings().GameSettings;
    end);

    if not (success and result) then
        return 30;
    end;

    local SavedQualityLevel = result.SavedQualityLevel;
    local v43 = nil;

    if typeof(SavedQualityLevel) == "EnumItem" then
        SavedQualityLevel = SavedQualityLevel.Value;
    elseif type(SavedQualityLevel) ~= "number" then
        SavedQualityLevel = v43;
    end;

    return type(SavedQualityLevel) == "number" and (SavedQualityLevel == 0 and 30 or (SavedQualityLevel >= 7 and 60 or (SavedQualityLevel >= 4 and 25 or 30))) or 60;
end;

for _, v in CollectionService:GetTagged("HypnoBloom") do
    local success, result = pcall(function() -- Line: 270
        -- upvalues: setupPlant (copy), v (copy)
        setupPlant(v);
    end);

    if not success then
        warn((`[HypnoBloomController] setup failed for {v:GetFullName()}: {result}`));
    end;
end;

local u44 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u45 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u46 = 0;
local u47 = Vector3.new(0, 0, 0);
local u48 = 0;
local u49 = nil;
local u50 = nil;
local u51 = nil;
local u52 = {};
local u53 = 0;

local function registerLocalHit(p54) -- Line: 296
    -- upvalues: u52 (ref), HypnoBloomFlags (copy), u53 (ref)
    table.insert(u52, p54);
    local v55 = p54 - HypnoBloomFlags.StunlockWindow:Get();
    local v56 = {};

    for _, v in u52 do
        if v55 <= v then
            table.insert(v56, v);
        end;
    end;

    u52 = v56;

    if #u52 >= HypnoBloomFlags.StunlockHitLimit:Get() then
        u53 = p54 + HypnoBloomFlags.StunlockCooldown:Get();
        table.clear(u52);
    end;
end;

local function GetHypnoFxImage() -- Line: 314
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("RadialScreenFlash");
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("HypnoBloom");
    end;

    if PlayerGui and PlayerGui:IsA("ImageLabel") then
        return PlayerGui;
    end;

    return nil;
end;

local function TweenHypnoFx(p57, p58) -- Line: 324
    -- upvalues: LocalPlayer (copy), u51 (ref), TweenService (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("RadialScreenFlash");
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("HypnoBloom");
    end;

    if not (PlayerGui and PlayerGui:IsA("ImageLabel")) then
        PlayerGui = nil;
    end;

    if not PlayerGui then
        return;
    end;

    if u51 then
        u51:Cancel();
        u51 = nil;
    end;

    local v59 = TweenService:Create(PlayerGui, p58, {
        ImageTransparency = p57
    });
    u51 = v59;
    v59:Play();
end;

local function GetControls() -- Line: 336
    -- upvalues: u50 (ref), LocalPlayer (copy)
    if not u50 then
        local success, result = pcall(function() -- Line: 338
            -- upvalues: LocalPlayer (ref)
            local PlayerModule = LocalPlayer.PlayerScripts:WaitForChild("PlayerModule");

            return require(PlayerModule):GetControls();
        end);

        if success then
            u50 = result;
        end;
    end;

    return u50;
end;

local function StopHypnotize() -- Line: 349
    -- upvalues: u1 (ref), u49 (ref), u50 (ref), LocalPlayer (copy), ContextActionService (copy), TweenHypnoFx (copy), u45 (copy)
    if not u1 then
        return;
    end;

    u1 = false;

    if u49 then
        u49:Disconnect();
        u49 = nil;
    end;

    if not u50 then
        local success, result = pcall(function() -- Line: 338
            -- upvalues: LocalPlayer (ref)
            local PlayerModule = LocalPlayer.PlayerScripts:WaitForChild("PlayerModule");

            return require(PlayerModule):GetControls();
        end);

        if success then
            u50 = result;
        end;
    end;

    local v60 = u50;

    if v60 then
        v60:Enable();
    end;

    ContextActionService:UnbindAction("HypnoBloomBlockJump");
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character then
        Character.AutoRotate = true;
        Character:SetStateEnabled(Enum.HumanoidStateType.Jumping, true);
        Character:Move(Vector3.new(0, 0, 0));
    end;

    TweenHypnoFx(1, u45);
end;

local function StartHypnotize(p61) -- Line: 376
    -- upvalues: u47 (ref), u46 (ref), HypnoBloomFlags (copy), u1 (ref), u48 (ref), u50 (ref), LocalPlayer (copy), ContextActionService (copy), TweenHypnoFx (copy), u44 (copy), NotificationController (copy), u49 (ref), RunService (copy), StopHypnotize (copy)
    if p61.Magnitude < 0.05 then
        return;
    end;

    u47 = p61.Unit;
    u46 = workspace:GetServerTimeNow() + HypnoBloomFlags.HypnotizeDuration:Get();

    if u1 then
        return;
    end;

    u1 = true;
    u48 = 0;

    if not u50 then
        local success, result = pcall(function() -- Line: 338
            -- upvalues: LocalPlayer (ref)
            local PlayerModule = LocalPlayer.PlayerScripts:WaitForChild("PlayerModule");

            return require(PlayerModule):GetControls();
        end);

        if success then
            u50 = result;
        end;
    end;

    local v62 = u50;

    if v62 then
        v62:Disable();
    end;

    ContextActionService:BindAction("HypnoBloomBlockJump", function() -- Line: 393
        return Enum.ContextActionResult.Sink;
    end, false, Enum.PlayerActions.CharacterJump);
    TweenHypnoFx(0, u44);
    NotificationController:CreateNotification("You\'ve been hypnotized by a Hypno Bloom!");
    u49 = RunService.Heartbeat:Connect(function(p63) -- Line: 400
        -- upvalues: u46 (ref), StopHypnotize (ref), LocalPlayer (ref), u47 (ref), HypnoBloomFlags (ref), u48 (ref)
        if u46 <= workspace:GetServerTimeNow() then
            StopHypnotize();

            return;
        end;

        local Character = LocalPlayer.Character;
        local v64;

        if Character then
            v64 = Character:FindFirstChildOfClass("Humanoid");
        else
            v64 = Character;
        end;

        if not v64 or v64.Health <= 0 then
            StopHypnotize();

            return;
        end;

        v64:SetStateEnabled(Enum.HumanoidStateType.Jumping, false);
        v64:Move(u47, false);
        local v65 = HypnoBloomFlags.SpinSpeedDegrees:Get();

        if v65 > 0 then
            v64.AutoRotate = false;

            if Character then
                Character = Character:FindFirstChild("HumanoidRootPart");
            end;

            if Character and Character:IsA("BasePart") then
                u48 = u48 + p63 * math.rad(v65);
                Character.CFrame = CFrame.new(Character.Position) * CFrame.Angles(0, u48, 0);
            end;
        else
            v64.AutoRotate = true;
        end;
    end);
end;

local function anyPlayerInRange(p66, p67, p68) -- Line: 432
    -- upvalues: Players (copy)
    local v69 = p66:GetAttribute("UserId");
    local v70 = Players:GetPlayerByUserId(v69);

    if v70 then
        v70 = v70.Name;
    end;

    for _, v in Players:GetPlayers() do
        if v.UserId ~= v69 then
            local Character = v.Character;

            if Character then
                local PetState = Character:FindFirstChild("PetState");

                if PetState then
                    PetState = PetState:FindFirstChild("InGarden");
                end;

                local v71;

                if PetState and PetState:IsA("StringValue") and PetState.Value ~= "" then
                    v71 = (not v70 or v70 == "") and true or PetState.Value == v70;
                else
                    v71 = false;
                end;

                if v71 and ((Character:GetPivot().Position - p67) * Vector3.new(1, 0, 1)).Magnitude <= p68 then
                    return true;
                end;
            end;
        end;
    end;

    return false;
end;

local function tryHitLocal(p72, p73, p74, p75, p76, p77) -- Line: 459
    -- upvalues: LocalPlayer (copy), u1 (ref), u53 (ref), Players (copy), HypnoBloomFlags (copy), registerLocalHit (copy), StartHypnotize (copy), Networking (copy)
    if p73.Owner == LocalPlayer then
        return;
    end;

    if u1 then
        return;
    end;

    if p77 < u53 then
        return;
    end;

    if p77 < p73.LocalHitCooldownUntil then
        return;
    end;

    if not (p76 and p76:IsA("BasePart")) then
        return;
    end;

    local Character = LocalPlayer.Character;
    local v78 = Players:GetPlayerByUserId((p72:GetAttribute("UserId")));

    if Character then
        if v78 then
            v78 = v78.Name;
        end;

        local PetState = Character:FindFirstChild("PetState");

        if PetState then
            PetState = PetState:FindFirstChild("InGarden");
        end;

        local v79;

        if PetState and PetState:IsA("StringValue") and PetState.Value ~= "" then
            v79 = (not v78 or v78 == "") and true or PetState.Value == v78;
        else
            v79 = false;
        end;

        if v79 then
            local v80 = (p76.Position - p74) * Vector3.new(1, 0, 1);

            if p75 < v80.Magnitude then
                return;
            end;

            p73.LocalHitCooldownUntil = p77 + HypnoBloomFlags.HitCooldown:Get();
            registerLocalHit(p77);

            if v80.Magnitude < 0.05 then
                v80 = p76.CFrame.LookVector * Vector3.new(1, 0, 1);
            end;

            StartHypnotize(v80);

            if p73.Owner then
                Networking.HypnoBloom.Hit:Fire(p73.Owner);
            end;
        end;
    end;
end;

task.spawn(function() -- Line: 490
    -- upvalues: getDesiredAgeUpdateHz (copy), LocalPlayer (copy), u18 (copy), EffectLoadManager (copy), HypnoBloomFlags (copy), anyPlayerInRange (copy), setSustainedEmitters (copy), playAttackSound (copy), fireBurstEmitters (copy), tryHitLocal (copy)
    while true do
        local wait = task.wait;
        local v81 = getDesiredAgeUpdateHz();
        wait(v81 <= 0 and 0.02 or 1 / math.clamp(v81, 15, 60));
        local u82 = workspace:GetServerTimeNow();
        local Night = game.ReplicatedStorage:FindFirstChild("Night");
        local u83 = Night and (Night:IsA("BoolValue") and Night.Value == true) and true or workspace:GetAttribute("ActivePhase") == "Night";
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        for i, v in u18 do
            if i:IsDescendantOf(workspace) then
                if v.Mode ~= "Idle" or EffectLoadManager.ShouldAnimateInstance(i, 80) then
                    local success, result = pcall(function() -- Line: 517
                        -- upvalues: i (copy), HypnoBloomFlags (ref), v (copy), u83 (copy), u82 (copy), anyPlayerInRange (ref), setSustainedEmitters (ref), playAttackSound (ref), fireBurstEmitters (ref), tryHitLocal (ref), Character (copy)
                        local Base = i:FindFirstChild("Base");
                        local v84;

                        if Base then
                            v84 = Base:FindFirstChild("Emitter");
                        else
                            v84 = Base;
                        end;

                        if not (Base and (Base:IsA("BasePart") and v84)) then
                            return;
                        end;

                        local v85 = i:GetAttribute("PulseRadius");

                        if typeof(v85) ~= "number" or v85 <= 0 then
                            v85 = HypnoBloomFlags.PulseRadius:Get();
                        end;

                        local v86 = math.min(v85 * (v.SizeFactor or 1), HypnoBloomFlags.PulseRadiusMax:Get());

                        if v.Mode == "Idle" then
                            if u83 and (u82 >= v.CooldownUntil and anyPlayerInRange(i, Base.Position, v86)) then
                                v.Mode = "Windup";
                                v.PhaseEndsAt = u82 + HypnoBloomFlags.PulseWindup:Get();
                                v.HitThisPulse = false;
                                setSustainedEmitters(v84, true);
                                playAttackSound(v84);
                            end;
                        elseif v.Mode == "Windup" then
                            if u82 >= v.PhaseEndsAt then
                                v.Mode = "Active";
                                v.PhaseEndsAt = u82 + HypnoBloomFlags.PulseActiveDuration:Get();
                                fireBurstEmitters(v84);
                            end;
                        elseif v.Mode == "Active" then
                            tryHitLocal(i, v, Base.Position, v86, Character, u82);

                            if u82 >= v.PhaseEndsAt then
                                v.Mode = "Cooldown";
                                v.CooldownUntil = u82 + HypnoBloomFlags.PulseCooldown:Get();
                                setSustainedEmitters(v84, false);
                            end;
                        elseif v.Mode == "Cooldown" and u82 >= v.CooldownUntil then
                            v.Mode = "Idle";
                        end;
                    end);

                    if not success then
                        warn((`[HypnoBloomController] update failed for {i:GetFullName()}: {result}`));
                    end;
                end;
            else
                u18[i] = nil;
            end;
        end;
    end;
end);

return v2;