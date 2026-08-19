-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
game:GetService("CollectionService");
game:GetService("RunService");
game:GetService("TweenService");
local v1 = {};
local u2 = {};
require(script.CCDIKController);
require(game.ReplicatedStorage.SharedModules.Networking);
require(game.ReplicatedStorage.ClientModules.RagdollModule);
local EffectLoadManager = require(game.ReplicatedStorage.SharedModules.EffectLoadManager);

local function lerp(p3, p4, p5) -- Line: 15
    return p3 + (p4 - p3) * p5;
end;

local function weldFruitToPlant(p6, p7) -- Line: 19
    local v8 = p7.PlantModel and p7.PlantModel.Base and p7.PlantModel.Base:FindFirstChild("PLAYER_POINT");

    if not v8 then
        return;
    end;

    if not p6:IsA("Model") then
        if p6:IsA("BasePart") then
            p6.Anchored = false;
            p6.CanCollide = false;
            p6.CFrame = v8.CFrame;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = p6;
            WeldConstraint.Part1 = v8;
            WeldConstraint.Parent = p6;
        end;

        return;
    end;

    local PrimaryPart = p6.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name ~= "HarvestPart" then
            descendant.Anchored = false;
            descendant.CanCollide = false;

            if descendant ~= PrimaryPart then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = PrimaryPart;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = descendant;
            end;
        end;
    end;

    p6:PivotTo(v8.CFrame);
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = PrimaryPart;
    WeldConstraint.Part1 = v8;
    WeldConstraint.Parent = PrimaryPart;
    WeldConstraint.Name = "AttachWeld";
end;

local function IsNightTime() -- Line: 69
    local Night = game.ReplicatedStorage:FindFirstChild("Night");

    if Night and Night:IsA("BoolValue") then
        return Night.Value == true;
    end;

    return false;
end;

local function findTarget(p9) -- Line: 76
    -- upvalues: Players (copy)
    if p9.Parent:GetAttribute("Decaying") then
        return;
    end;

    local Night = game.ReplicatedStorage:FindFirstChild("Night");
    local v10;

    if Night and Night:IsA("BoolValue") then
        v10 = Night.Value == true;
    else
        v10 = false;
    end;

    if not v10 then
        return;
    end;

    local v11 = p9.Parent:GetAttribute("UserId");
    local v12 = nil;
    local v13 = nil;

    for _, v in Players:GetPlayers() do
        if v.UserId ~= v11 and v.Character then
            local Magnitude = ((v.Character:GetPivot().Position - p9.BasePart.Position) * Vector3.new(1, 0, 1)).Magnitude;

            if Magnitude < 30 and (not v12 or Magnitude < v12) then
                v13 = v.Character;
                v12 = Magnitude;
            end;
        end;
    end;

    if v13 then
        return v13.HumanoidRootPart;
    end;
end;

local u14 = tick();
local FlameEffect = script.FlameEffect;
FlameEffect.Parent = game.Lighting;
FlameEffect.Enabled = false;
local u15 = nil;

local function handleDamage() -- Line: 131
    -- upvalues: u14 (ref), u15 (ref), FlameEffect (copy)
    if tick() - u14 < 1.5 then
        return;
    end;

    u14 = tick();
    local v16 = game.ReplicatedStorage.Assets.Vignette:Clone();
    v16.ImageLabel.ImageColor3 = Color3.fromRGB(255, 35, 35);
    v16.Parent = game.Players.LocalPlayer.PlayerGui;
    v16.ImageLabel.ImageTransparency = 0.6;

    if u15 then
        u15:Cancel();
    end;

    FlameEffect.Brightness = 0.1;
    FlameEffect.Saturation = 0.1;
    FlameEffect.TintColor = Color3.fromRGB(255, 181, 97);
    u15 = game.TweenService:Create(FlameEffect, TweenInfo.new(0.5), {
        Brightness = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    });
    FlameEffect.Enabled = true;
    u15:Play();
    game.TweenService:Create(v16.ImageLabel.UIScale, TweenInfo.new(0.5), {
        Scale = 1.06
    }):Play();
    game.TweenService:Create(v16.ImageLabel, TweenInfo.new(0.5), {
        ImageTransparency = 1
    }):Play();
    task.delay(0.5, function() -- Line: 159
        -- upvalues: FlameEffect (ref)
        FlameEffect.Enabled = false;
    end);
    game.Debris:AddItem(v16, 0.5);
end;

local function hzToTick(p17) -- Line: 195
    return p17 <= 0 and 0.02 or 1 / math.clamp(p17, 15, 60);
end;

local function addStemBallSockets(p18, p19) -- Line: 201
    local v20 = { 10, 15, 20, 25, 30, 30, 15, 10 };
    local v21 = {};

    for i, v in p18 do
        if p19[i] then
            local v22 = v.CFrame * CFrame.new(0, v.Size.Y / 2, 0);
            local Attachment = Instance.new("Attachment");
            Attachment.Name = v.Name .. "AxisAttachment";
            Attachment.Parent = v;
            Attachment.WorldCFrame = v22 * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
            local v23 = p18[i + 1];

            if v23 then
                local Attachment2 = Instance.new("Attachment");
                Attachment2.Name = v.Name .. "JointAttachment";
                Attachment2.Parent = v23;
                Attachment2.WorldCFrame = v22 * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
                local BallSocketConstraint = Instance.new("BallSocketConstraint");
                BallSocketConstraint.Name = v.Name .. "BallSocket";
                BallSocketConstraint.LimitsEnabled = true;
                BallSocketConstraint.UpperAngle = v20[i];
                BallSocketConstraint.Attachment0 = Attachment;
                BallSocketConstraint.Attachment1 = Attachment2;
                BallSocketConstraint.Parent = v;
                table.insert(v21, BallSocketConstraint);
            end;
        end;
    end;

    return v21;
end;

local function setupFlyTrap(p24) -- Line: 252
    -- upvalues: addStemBallSockets (copy), u2 (copy)
    if not p24:IsDescendantOf(workspace.Gardens) then
        return;
    end;

    local v25 = {};

    if not p24.Parent:HasTag("InitializationComplete") then
        repeat
            task.wait();
        until p24.Parent:HasTag("InitializationComplete");
    end;

    for _, child in ipairs(p24.Spine:GetChildren()) do
        if child:FindFirstChild("Motor6D") then
            table.insert(v25, child);
        end;
    end;

    table.sort(v25, function(p26, p27) -- Line: 268
        return tonumber(p26.Name) < tonumber(p27.Name);
    end);
    local v28 = {};

    for _, v in v25 do
        local v29 = v:FindFirstChild(v.Name) or v:FindFirstChildOfClass("Motor6D");
        table.insert(v28, v29);
    end;

    addStemBallSockets(v25, v28);
    local v30 = {};
    local v31 = {};

    for _, v in v28 do
        if v then
            v30[v] = v.C0;
            v31[v] = v.C1;
        end;
    end;

    for _, descendant in p24:GetDescendants() do
        if descendant:IsA("BasePart") and (descendant.Name ~= "BasePart" and (descendant.Name ~= "HarvestPart" and descendant.Parent ~= p24.Base)) then
            descendant.Anchored = false;
        end;
    end;

    local AnimationController = p24.AnimationController;
    local v32 = p24.BasePart:Clone();
    v32.Name = "RotationHandler";
    v32.Anchored = true;
    v32.Parent = p24;
    local Target1 = v32.Target1;
    local Target2 = v32.Target2;
    local Center = AnimationController.Center;
    Center.Target = Target1;
    Center.Enabled = true;
    local Top = AnimationController.Top;
    Top.Target = Target2;
    Top.Enabled = true;
    local v33 = Random.new():NextInteger(1, 9999);
    local v34 = p24.BasePart.CFrame:ToObjectSpace(Target1.WorldCFrame);
    local v35 = p24.BasePart.CFrame:ToObjectSpace(Target2.WorldCFrame);
    local v36 = {
        CenterOffset = v34 * CFrame.new(0, 2, 0),
        TopOffset = v35
    };
    local v37 = p24.Parent and p24.Parent:GetAttribute("UserId");
    local v38 = {
        CurrentTarget = nil,
        TargetLocked = false,
        LookTarget = nil,
        Model = p24,
        Offsets = v36,
        RandomOffset = v33,
        CenterOffset = v34,
        TopOffset = v35,
        Base = v32,
        OriginalCF = p24:GetPivot(),
        NextAttack = tick(),
        LastDecision = tick(),
        RestPoses = v30
    };
    local v39;

    if typeof(v37) == "number" then
        v39 = game.Players:GetPlayerByUserId(v37);
    else
        v39 = nil;
    end;

    v38.Owner = v39;
    v38.StartingPivot = v32.CFrame;
    v38.Attachment1 = Target1;
    v38.Attachment2 = Target2;
    v38.DragonBreathEnd = game.ReplicatedStorage.Assets.DragonBreathEnd:Clone();
    v38.PrimaryPart = v32;
    u2[p24] = v38;
end;

game.CollectionService:GetInstanceAddedSignal("DragonBreath"):Connect(setupFlyTrap);

local function getDesiredAgeUpdateHz() -- Line: 171
    local success, result = pcall(function() -- Line: 172
        return UserSettings().GameSettings;
    end);

    if not (success and result) then
        return 30;
    end;

    local SavedQualityLevel = result.SavedQualityLevel;
    local v40 = nil;

    if typeof(SavedQualityLevel) == "EnumItem" then
        SavedQualityLevel = SavedQualityLevel.Value;
    elseif type(SavedQualityLevel) ~= "number" then
        SavedQualityLevel = v40;
    end;

    return type(SavedQualityLevel) == "number" and (SavedQualityLevel == 0 and 30 or (SavedQualityLevel >= 7 and 60 or (SavedQualityLevel >= 4 and 25 or 30))) or 60;
end;

for _, v in game.CollectionService:GetTagged("DragonBreath") do
    setupFlyTrap(v);
end;

task.spawn(function() -- Line: 389
    -- upvalues: getDesiredAgeUpdateHz (copy), u2 (copy), EffectLoadManager (copy), findTarget (copy), Players (copy), handleDamage (copy)
    while true do
        local wait = task.wait;
        local v41 = getDesiredAgeUpdateHz();
        local v42 = wait(v41 <= 0 and 0.02 or 1 / math.clamp(v41, 15, 60));
        debug.profilebegin("Controllers/DragonBreathController/Tick");

        for i, v in u2 do
            if i:IsDescendantOf(workspace) then
                if EffectLoadManager.ShouldAnimateInstance(i, 80) then
                    if tick() - v.LastDecision > 1 then
                        v.LastDecision = tick();
                        v.CurrentTarget = findTarget(i);
                    end;

                    if v.CurrentTarget then
                        i.Head.Base.TopJaw.DesiredAngle = -0.2;
                        i.Head.Base.BottomJaw.DesiredAngle = 0.5;
                        v.DragonBreathEnd.Parent = workspace.Temporary;

                        if not v.DragonBreathEnd:GetAttribute("Enabled") then
                            v.DragonBreathEnd:SetAttribute("Enabled", true);

                            for _, descendant in v.DragonBreathEnd:GetDescendants() do
                                if descendant:IsA("ParticleEmitter") or descendant:IsA("SurfaceGui") then
                                    descendant.Enabled = true;
                                end;
                            end;

                            for _, child in i.Head.Base.Emitter:GetChildren() do
                                if child:IsA("Beam") then
                                    child.Attachment1 = v.DragonBreathEnd.Attachment;
                                end;
                            end;

                            for _, child in i.Head.Base.Emitter:GetChildren() do
                                if child:IsA("Beam") or child:IsA("ParticleEmitter") then
                                    child.Enabled = true;
                                end;
                            end;
                        end;

                        i.Head.Base.Emitter.WorldCFrame = CFrame.new(i.Head.Base.Emitter.WorldPosition, v.CurrentTarget.Position);
                        local v43 = v.CurrentTarget.Position * Vector3.new(1, 0, 1) + Vector3.new(0, workspace.Baseplate.Center.Position.Y, 0);

                        if not v.LastPosition then
                            v.LastPosition = v43;
                        end;

                        v.LastPosition = v.LastPosition:Lerp(v43, v42 * 3);
                        local v44 = v.LastPosition - i.Head.Base.Emitter.WorldPosition;
                        local v45 = v.Owner:GetAttribute("PlotId");
                        local v46;

                        if v45 then
                            v46 = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. v45);
                        else
                            v46 = i.Parent.Parent.Parent;
                        end;

                        local v47 = RaycastParams.new();
                        v47.FilterType = Enum.RaycastFilterType.Include;
                        v47.FilterDescendantsInstances = {
                            v46.Visual,
                            workspace.Baseplate,
                            v.CurrentTarget.Parent,
                            game.Players.LocalPlayer.Character
                        };
                        local v48 = workspace:Raycast(i.Head.Base.Emitter.WorldPosition, v44, v47);

                        if v48 and v48.Position then
                            v.DragonBreathEnd.CFrame = CFrame.new(v48.Position + Vector3.new(0, 0.1, 0));

                            if v48.Instance:IsDescendantOf(game.Players.LocalPlayer.Character) or v48.Instance:IsDescendantOf(v.CurrentTarget.Parent) then
                                v.DragonBreathEnd.SurfaceGui.Enabled = false;
                            else
                                v.DragonBreathEnd.SurfaceGui.Enabled = true;
                            end;
                        else
                            v.DragonBreathEnd.CFrame = CFrame.new(v.LastPosition + Vector3.new(0, 0.1, 0));
                            v.DragonBreathEnd.SurfaceGui.Enabled = true;
                        end;

                        local v49 = OverlapParams.new();
                        v49.FilterDescendantsInstances = { game.Players.LocalPlayer.Character };
                        v49.FilterType = Enum.RaycastFilterType.Include;

                        if #workspace:GetPartBoundsInRadius(v.DragonBreathEnd.Position, 2.2, v49) > 0 and v.Owner ~= Players.LocalPlayer then
                            handleDamage();
                        end;
                    else
                        if v.DragonBreathEnd:GetAttribute("Enabled") then
                            for _, descendant in v.DragonBreathEnd:GetDescendants() do
                                if descendant:IsA("ParticleEmitter") or descendant:IsA("SurfaceGui") then
                                    descendant.Enabled = false;
                                end;
                            end;

                            for _, child in i.Head.Base.Emitter:GetChildren() do
                                if child:IsA("Beam") or child:IsA("ParticleEmitter") then
                                    child.Enabled = false;
                                end;
                            end;

                            v.DragonBreathEnd:SetAttribute("Enabled", false);
                        end;

                        i.Head.Base.TopJaw.DesiredAngle = 0;
                        i.Head.Base.BottomJaw.DesiredAngle = 0;
                    end;

                    v.Attachment1.WorldCFrame = v.Base.CFrame * v.CenterOffset;
                    v.Attachment2.WorldCFrame = v.Base.CFrame * v.TopOffset;
                elseif v.DragonBreathEnd and v.DragonBreathEnd:GetAttribute("Enabled") then
                    v.CurrentTarget = nil;

                    for _, descendant in v.DragonBreathEnd:GetDescendants() do
                        if descendant:IsA("ParticleEmitter") or descendant:IsA("SurfaceGui") then
                            descendant.Enabled = false;
                        end;
                    end;

                    for _, child in i.Head.Base.Emitter:GetChildren() do
                        if child:IsA("Beam") or child:IsA("ParticleEmitter") then
                            child.Enabled = false;
                        end;
                    end;

                    v.DragonBreathEnd:SetAttribute("Enabled", false);
                    i.Head.Base.TopJaw.DesiredAngle = 0;
                    i.Head.Base.BottomJaw.DesiredAngle = 0;
                end;
            else
                u2[i] = nil;
            end;
        end;

        debug.profileend();
    end;
end);

return v1;