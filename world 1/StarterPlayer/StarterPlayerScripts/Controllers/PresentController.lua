-- Decompiled with Potassium's decompiler.

local v1 = {};
local Debris = game:GetService("Debris");
local TweenService = game:GetService("TweenService");
local HapticService = game:GetService("HapticService");
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local CamShake = require(game.ReplicatedStorage.ClientModules.CamShake);
local LocalPlayer = game.Players.LocalPlayer;
local Presents = game.Workspace.Presents;
local Confetti = game.SoundService.SFX.Confetti;
local Present_Open = game.SoundService.SFX.Present_Open;
local CrateLand = game.SoundService.SFX.CrateSFX.CrateLand;
local ScreenConfetti = require(game.ReplicatedStorage.ClientModules.Effects.ScreenConfetti);
local ChestOpenEffect = require(script.Parent:WaitForChild("ChestController"):WaitForChild("ChestOpenEffect"));
local RarityVisuals = require(game.ReplicatedStorage.SharedModules.RarityVisuals);
local Assets = game.ReplicatedStorage.Assets;
local CrateVFX = Assets.VFX.CrateVFX;
local CrateSFX = game.SoundService.SFX.CrateSFX;
local u2 = Color3.fromRGB(255, 215, 0);

local function findPresent(p3) -- Line: 88
    -- upvalues: Presents (copy)
    for _, child in Presents:GetChildren() do
        if child:IsA("Model") and child:GetAttribute("PresentId") == p3 then
            return child;
        end;
    end;

    return nil;
end;

local function getPrimary(p4) -- Line: 97
    local Primary = p4:FindFirstChild("Primary");

    if Primary and Primary:IsA("BasePart") then
        return Primary;
    end;

    if p4.PrimaryPart then
        return p4.PrimaryPart;
    end;

    return p4:FindFirstChildWhichIsA("BasePart", true);
end;

local function playAt(p5, p6, p7) -- Line: 113
    local u8 = p5:Clone();
    u8.Name = "PresentSFX";
    u8.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    u8.RollOffMode = Enum.RollOffMode.InverseTapered;
    u8.RollOffMinDistance = 10;
    u8.RollOffMaxDistance = 80;

    if p7 then
        u8.Volume = p5.Volume * p7;
    end;

    u8.Parent = p6;
    u8:Play();
    u8.Ended:Once(function() -- Line: 127
        -- upvalues: u8 (copy)
        u8:Destroy();
    end);
end;

function v1.EmitConfetti(p9, p10) -- Line: 134
    local Primary = p10:FindFirstChild("Primary");

    if not (Primary and Primary:IsA("BasePart")) then
        if p10.PrimaryPart then
            Primary = p10.PrimaryPart;
        else
            Primary = p10:FindFirstChildWhichIsA("BasePart", true);
        end;
    end;

    if Primary then
        Primary = Primary:FindFirstChild("Attachment");
    end;

    if not Primary then
        return;
    end;

    for _, child in Primary:GetChildren() do
        if child:IsA("ParticleEmitter") then
            task.spawn(function() -- Line: 141
                -- upvalues: child (copy)
                local v11 = child:GetAttribute("EmitDelay") or 0;

                if v11 > 0 then
                    task.wait(v11);
                end;

                if child.Parent then
                    child:Emit(child:GetAttribute("EmitCount") or 25);
                end;
            end);
        end;
    end;
end;

function v1.PlaySmallHaptic(p12) -- Line: 158
    -- upvalues: Debris (copy), HapticService (copy)
    local success, result = pcall(function() -- Line: 159
        local HapticEffect = Instance.new("HapticEffect");
        HapticEffect.Type = Enum.HapticEffectType.UIClick;
        HapticEffect.Parent = workspace;

        return HapticEffect;
    end);

    if success and result then
        result:Play();
        Debris:AddItem(result, 1);
    end;

    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0.25);
        task.delay(0.12, function() -- Line: 174
            -- upvalues: HapticService (ref)
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0);
        end);
    end;
end;

local u13 = nil;

function v1.PlayScreenConfetti(p14) -- Line: 185
    -- upvalues: u13 (ref), ScreenConfetti (copy)
    local success, result = pcall(function() -- Line: 186
        -- upvalues: u13 (ref), ScreenConfetti (ref)
        if u13 and u13:IsActive() then
            u13:Stop();
        end;

        u13 = ScreenConfetti.Play({
            Duration = 0,
            Burst = 80
        });
    end);

    if not success then
        warn("[PresentController] screen confetti failed:", result);
    end;
end;

local u15 = 0;

local function queueLandShake(p16) -- Line: 207
    -- upvalues: u15 (ref), CamShake (copy)
    if p16 <= u15 then
        return;
    end;

    local v17 = u15 > 0;
    u15 = p16;

    if v17 then
        return;
    end;

    task.defer(function() -- Line: 215
        -- upvalues: u15 (ref), CamShake (ref)
        local v18 = u15;
        u15 = 0;
        CamShake:ShakeOnce(v18, 7, 0, 0.35);
    end);
end;

function v1.PlayLandVisual(p19, p20) -- Line: 230
    -- upvalues: findPresent (copy), playAt (copy), CrateLand (copy), LocalPlayer (copy), u15 (ref), CamShake (copy)
    local v21 = findPresent(p20);

    if not v21 then
        return;
    end;

    local Primary = v21:FindFirstChild("Primary");

    if not (Primary and Primary:IsA("BasePart")) then
        if v21.PrimaryPart then
            Primary = v21.PrimaryPart;
        else
            Primary = v21:FindFirstChildWhichIsA("BasePart", true);
        end;
    end;

    if not Primary then
        return;
    end;

    playAt(CrateLand, Primary, 3);
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not Character then
        return;
    end;

    local Magnitude = (Character.Position - Primary.Position).Magnitude;

    if Magnitude >= 80 then
        return;
    end;

    local v22 = 2.4 * (1 - Magnitude / 80);

    if v22 <= u15 then
        return;
    end;

    local v23 = u15 > 0;
    u15 = v22;

    if v23 then
        return;
    end;

    task.defer(function() -- Line: 215
        -- upvalues: u15 (ref), CamShake (ref)
        local v24 = u15;
        u15 = 0;
        CamShake:ShakeOnce(v24, 7, 0, 0.35);
    end);
end;

function v1.PlayHitVisual(p25, p26) -- Line: 248
    -- upvalues: findPresent (copy), playAt (copy), Confetti (copy)
    local v27 = findPresent(p26);

    if not v27 then
        return;
    end;

    local Primary = v27:FindFirstChild("Primary");

    if not (Primary and Primary:IsA("BasePart")) then
        if v27.PrimaryPart then
            Primary = v27.PrimaryPart;
        else
            Primary = v27:FindFirstChildWhichIsA("BasePart", true);
        end;
    end;

    if Primary then
        playAt(Confetti, Primary);
    end;

    p25:EmitConfetti(v27);
end;

function v1.PlayRewardReveal(p28, u29, u30) -- Line: 265
    -- upvalues: ChestOpenEffect (copy), LocalPlayer (copy), RarityVisuals (copy), u2 (copy), Assets (copy), CrateVFX (copy), CrateSFX (copy)
    if type(u30) ~= "table" then
        return;
    end;

    if type(u30.Name) ~= "string" then
        return;
    end;

    task.spawn(function() -- Line: 269
        -- upvalues: ChestOpenEffect (ref), LocalPlayer (ref), u29 (copy), u30 (copy), RarityVisuals (ref), u2 (ref), Assets (ref), CrateVFX (ref), CrateSFX (ref)
        local success, result = pcall(function() -- Line: 270
            -- upvalues: ChestOpenEffect (ref), LocalPlayer (ref), u29 (ref), u30 (ref), RarityVisuals (ref), u2 (ref), Assets (ref), CrateVFX (ref), CrateSFX (ref)
            local PlayReveal = ChestOpenEffect.PlayReveal;
            local v31 = {
                Player = LocalPlayer,
                Position = u29,
                ItemImage = u30.Image,
                ItemName = u30.Name,
                RarityName = u30.RarityName
            };
            local v32;

            if u30.RarityName then
                v32 = RarityVisuals.GetStaticColor(u30.RarityName);
            else
                v32 = u2;
            end;

            v31.RarityColor = v32;
            v31.Rarity = (u30.Chance or 0) / 100;
            v31.BillboardTemplate = Assets.BillboardUIs.CrateItemBillboard;
            v31.Particles = {
                Explosion = CrateVFX.Explosion:GetChildren()
            };
            v31.Sounds = {
                Reveal = CrateSFX.CrateReward,
                Collect = CrateSFX.CrateCollect
            };
            PlayReveal(v31);
        end);

        if not success then
            warn("[PresentController] reward reveal failed:", result);
        end;
    end);
end;

function v1.PlayExplodeVisual(p33, p34) -- Line: 301
    -- upvalues: findPresent (copy), playAt (copy), Confetti (copy), Present_Open (copy), TweenService (copy)
    local u35 = findPresent(p34);

    if not u35 then
        return;
    end;

    local Primary = u35:FindFirstChild("Primary");

    if not (Primary and Primary:IsA("BasePart")) then
        if u35.PrimaryPart then
            Primary = u35.PrimaryPart;
        else
            Primary = u35:FindFirstChildWhichIsA("BasePart", true);
        end;
    end;

    if Primary then
        playAt(Confetti, Primary);
        playAt(Present_Open, Primary);
    end;

    p33:EmitConfetti(u35);
    local v36 = {};

    for _, descendant in u35:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            table.insert(v36, descendant);
        end;
    end;

    local v37, v38 = u35:GetBoundingBox();
    u35.WorldPivot = CFrame.new(v37.Position - Vector3.new(0, v38.Y / 2, 0));
    local v39 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v40 = u35:GetScale();
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = "ExplodeScale";
    NumberValue.Value = v40;
    NumberValue.Parent = u35;
    NumberValue.Changed:Connect(function(p41) -- Line: 338
        -- upvalues: u35 (copy)
        if u35.Parent then
            u35:ScaleTo(p41);
        end;
    end);
    TweenService:Create(NumberValue, v39, {
        Value = v40 * 1.5
    }):Play();

    for _, v in v36 do
        TweenService:Create(v, v39, {
            Transparency = 1
        }):Play();

        for _, child in v:GetChildren() do
            if child:IsA("Decal") or child:IsA("Texture") then
                TweenService:Create(child, v39, {
                    Transparency = 1
                }):Play();
            elseif child:IsA("PointLight") then
                TweenService:Create(child, v39, {
                    Brightness = 0
                }):Play();
            end;
        end;
    end;
end;

function v1.PlayReward(u42, u43, u44) -- Line: 363
    u42:PlaySmallHaptic();
    u42:PlayScreenConfetti();
    task.delay(0.35, function() -- Line: 366
        -- upvalues: u42 (copy), u43 (copy), u44 (copy)
        u42:PlayRewardReveal(u43, u44);
    end);
end;

function v1.Init(u45) -- Line: 371
    -- upvalues: Networking (copy)
    Networking.Present.LandPresentVisualClient.OnClientEvent:Connect(function(p46) -- Line: 372
        -- upvalues: u45 (copy)
        if type(p46) ~= "table" or type(p46.Id) ~= "string" then
            return;
        end;

        u45:PlayLandVisual(p46.Id);
    end);
    Networking.Present.HitPresentVisualClient.OnClientEvent:Connect(function(p47) -- Line: 377
        -- upvalues: u45 (copy)
        if type(p47) ~= "table" or type(p47.Id) ~= "string" then
            return;
        end;

        u45:PlayHitVisual(p47.Id);
    end);
    Networking.Present.ExplodePresentVisualClient.OnClientEvent:Connect(function(p48) -- Line: 382
        -- upvalues: u45 (copy)
        if type(p48) ~= "table" or type(p48.Id) ~= "string" then
            return;
        end;

        u45:PlayExplodeVisual(p48.Id);
    end);
    Networking.Present.PresentRewardClient.OnClientEvent:Connect(function(p49) -- Line: 387
        -- upvalues: u45 (copy)
        if type(p49) ~= "table" then
            return;
        end;

        local Position = p49.Position;

        if type(Position) ~= "table" or type(Position[1]) ~= "number" then
            return;
        end;

        u45:PlayReward(Vector3.new(Position[1], Position[2], Position[3]), p49.Reward);
    end);
end;

return v1;