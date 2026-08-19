-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
game:GetService("CollectionService");
game:GetService("RunService");
game:GetService("TweenService");
local u1 = {};
local CCDIKController = require(game.ReplicatedStorage.ClientModules.CCDIKController);
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
require(game.ReplicatedStorage.ClientModules.RagdollModule);
local EffectLoadManager = require(game.ReplicatedStorage.SharedModules.EffectLoadManager);
local Bezier = require(game.ReplicatedStorage.ClientModules.Bezier);
local VenomSpitterFlags = require(game.ReplicatedStorage.SharedModules.Flags.VenomSpitterFlags);
local SlimeControllers = require(game.Players.LocalPlayer.PlayerScripts.Controllers.SlimeControllers);

local function lerp(p2, p3, p4) -- Line: 17
    return p2 + (p3 - p2) * p4;
end;

local function StableSeedFromString(p5) -- Line: 23
    local v6 = 0;

    for i = 1, #p5 do
        local v7 = v6 * 31 + string.byte(p5, i);
        v6 = bit32.band(v7, 4294967295);
    end;

    return v6;
end;

local function IsNightTime() -- Line: 31
    local Night = game.ReplicatedStorage:FindFirstChild("Night");

    if Night and Night:IsA("BoolValue") then
        return Night.Value == true;
    end;

    return false;
end;

local function connectParts(p8, p9) -- Line: 82
    -- upvalues: connectParts (copy)
    local v10 = p9 or "";

    for i, v in p8 do
        local v11 = p8[i + 1];

        if v and v11 then
            local Motor6D = Instance.new("Motor6D");
            Motor6D.Name = v.Name .. v10;
            Motor6D.Part0 = v;
            Motor6D.Part1 = v11;
            Motor6D.C0 = CFrame.new(0, v.Size.Y / 2, 0);
            local v12 = v.CFrame * Motor6D.C0;
            Motor6D.C1 = v11.CFrame:Inverse() * v12;
            Motor6D.Parent = v;
        end;

        for _, child in v:GetChildren() do
            if child.Name == "Reference" then
                for _, descendant in child.Value:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        local WeldConstraint = Instance.new("WeldConstraint");
                        WeldConstraint.Part0 = descendant;
                        WeldConstraint.Part1 = v;
                        WeldConstraint.Parent = descendant;
                    end;
                end;
            elseif child.Name == "LeafStemReference" then
                local v13 = {};
                local v14 = nil;

                for _, child2 in child.Value:GetChildren() do
                    if child2:IsA("BasePart") then
                        if child2.Name == "EndJoint" then
                            v14 = child2;
                        else
                            v13[tonumber(child2.Name)] = child2;
                        end;
                    end;
                end;

                local v15 = nil;

                for i2 = 1, #v13 do
                    if v13[i2] ~= nil then
                        v15 = i2;
                        break;
                    end;
                end;

                local v16 = { table.unpack(v13, v15) };
                table.insert(v16, v14);
                connectParts(v16, child.Name);
                local Motor6D = Instance.new("Motor6D");
                Motor6D.Name = "Root_" .. child.Name;
                Motor6D.Part0 = v;
                Motor6D.Part1 = v16[1];
                Motor6D.C0 = CFrame.new(0, v.Size.Y / 2, 0);
                local v17 = v.CFrame * Motor6D.C0;
                Motor6D.C1 = v16[1].CFrame:Inverse() * v17;
                Motor6D.Parent = v;
            end;
        end;
    end;
end;

local function hzToTick(p18) -- Line: 175
    return p18 <= 0 and 0.02 or 1 / math.clamp(p18, 15, 60);
end;

local function addStemBallSockets(p19, p20) -- Line: 180
    local v21 = {};

    for i, v in p19 do
        if p20[i] then
            local v22 = v.CFrame * CFrame.new(0, v.Size.Y / 2, 0);
            local Attachment = Instance.new("Attachment");
            Attachment.Name = v.Name .. "AxisAttachment";
            Attachment.Parent = v;
            Attachment.WorldCFrame = v22 * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
            local v23 = p19[i + 1];

            if v23 then
                local Attachment2 = Instance.new("Attachment");
                Attachment2.Name = v.Name .. "JointAttachment";
                Attachment2.Parent = v23;
                Attachment2.WorldCFrame = v22 * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
                local BallSocketConstraint = Instance.new("BallSocketConstraint");
                BallSocketConstraint.Name = v.Name .. "BallSocket";
                BallSocketConstraint.LimitsEnabled = false;
                BallSocketConstraint.UpperAngle = 90;
                BallSocketConstraint.Attachment0 = Attachment;
                BallSocketConstraint.Attachment1 = Attachment2;
                BallSocketConstraint.Parent = v;
                table.insert(v21, BallSocketConstraint);
            end;
        end;
    end;

    return v21;
end;

local function groupArmJoints(p24, p25) -- Line: 217
    -- upvalues: CCDIKController (copy)
    local v26 = {};

    for _, child in p25:GetChildren() do
        local v27 = child:FindFirstChildOfClass("Motor6D");

        if v27 then
            v26[tonumber(child.Name)] = v27;
        end;
    end;

    local v28 = nil;

    for i = 1, #v26 do
        if v26[i] ~= nil then
            v28 = i;
            break;
        end;
    end;

    local v29 = { table.unpack(v26, v28) };
    local CFrame2 = p25.EndJoint.CFrame;
    local Attachment = Instance.new("Attachment");
    Attachment.Parent = p24.RotationHandler;
    Attachment.WorldCFrame = CFrame2;

    return {
        bend = CCDIKController.new(v29),
        Attachment = Attachment,
        joints = v29,
        startingCF = Attachment.Position,
        maxRange = (CFrame2.Position - (v29[1].C0 * v29[1].Part0.CFrame).Position).Magnitude * 0.9
    };
end;

local u30 = {};

local function ScheduleBurnEnd(u31, u32, p33) -- Line: 257
    -- upvalues: u30 (copy), SlimeControllers (copy)
    task.delay(p33, function() -- Line: 258
        -- upvalues: u30 (ref), u31 (copy), u32 (copy), SlimeControllers (ref)
        local v34 = u30[u31];

        if not v34 or v34.Token ~= u32 then
            return;
        end;

        v34.Bubbles.Enabled = false;
        v34.Sound:Stop();
        SlimeControllers:RemoveSlime(u31);
        game.Debris:AddItem(v34.Bubbles, 4);
        game.Debris:AddItem(v34.Sound, 4);

        if v34.Vignette then
            game.Debris:AddItem(v34.Vignette, 0);
        end;

        u30[u31] = nil;
    end);
end;

local function ProcessBite(u35, p36) -- Line: 277
    -- upvalues: VenomSpitterFlags (copy), u30 (copy), Networking (copy), SlimeControllers (copy)
    if not (u35 and u35.PrimaryPart) then
        return;
    end;

    local v37 = VenomSpitterFlags.SpitBurnDuration:Get();
    local v38 = u35 == game.Players.LocalPlayer.Character;
    local u39 = workspace:GetServerTimeNow();
    local v40 = u30[u35];

    if v40 then
        v40.Token = u39;

        if v38 then
            Networking.PoisonPlant.Poison:Fire(p36);

            if v40.Vignette then
                v40.Vignette.ImageLabel.ImageTransparency = 0.6;
                game.TweenService:Create(v40.Vignette.ImageLabel, TweenInfo.new(v37), {
                    ImageTransparency = 1
                }):Play();
            end;
        end;

        task.delay(v37, function() -- Line: 258
            -- upvalues: u30 (ref), u35 (copy), u39 (copy), SlimeControllers (ref)
            local v41 = u30[u35];

            if not v41 or v41.Token ~= u39 then
                return;
            end;

            v41.Bubbles.Enabled = false;
            v41.Sound:Stop();
            SlimeControllers:RemoveSlime(u35);
            game.Debris:AddItem(v41.Bubbles, 4);
            game.Debris:AddItem(v41.Sound, 4);

            if v41.Vignette then
                game.Debris:AddItem(v41.Vignette, 0);
            end;

            u30[u35] = nil;
        end);

        return;
    end;

    local v42 = game.SoundService.SFX.burnEffect:Clone();
    v42.Parent = u35.PrimaryPart;
    v42.Looped = true;
    v42:AddTag("AcidBurn");
    SlimeControllers:AddSlime(u35);
    local v43 = script.bubbles:Clone();
    v43:AddTag("AcidBurn");
    v43.Parent = u35.PrimaryPart;
    local v44;

    if v38 then
        v44 = game.ReplicatedStorage.Assets.Vignette:Clone();
        v44.ImageLabel.ImageColor3 = Color3.fromRGB(89, 255, 0);
        v44.Parent = game.Players.LocalPlayer.PlayerGui;
        v44.ImageLabel.ImageTransparency = 0.6;
        v44.Name = "AcidVignette";
        v44:AddTag("AcidBurn");
        Networking.PoisonPlant.Poison:Fire(p36);
        game.TweenService:Create(v44.ImageLabel.UIScale, TweenInfo.new(1.5), {
            Scale = 1.01
        }):Play();
        game.TweenService:Create(v44.ImageLabel, TweenInfo.new(v37), {
            ImageTransparency = 1
        }):Play();
    else
        v44 = nil;
    end;

    u30[u35] = {
        Token = u39,
        Sound = v42,
        Bubbles = v43,
        Vignette = v44
    };
    task.delay(v37, function() -- Line: 258
        -- upvalues: u30 (ref), u35 (copy), u39 (copy), SlimeControllers (ref)
        local v45 = u30[u35];

        if not v45 or v45.Token ~= u39 then
            return;
        end;

        v45.Bubbles.Enabled = false;
        v45.Sound:Stop();
        SlimeControllers:RemoveSlime(u35);
        game.Debris:AddItem(v45.Bubbles, 4);
        game.Debris:AddItem(v45.Sound, 4);

        if v45.Vignette then
            game.Debris:AddItem(v45.Vignette, 0);
        end;

        u30[u35] = nil;
    end);
end;

local function createProjectile(p46) -- Line: 341
    -- upvalues: Bezier (copy), VenomSpitterFlags (copy), ProcessBite (copy)
    local v47 = script.Projectile:Clone();
    local WorldPosition = p46.Model.Mouth.Rig.Base.Spit.WorldPosition;
    local Position = p46.CurrentTarget.Position;
    local v48 = Bezier.new(WorldPosition, Position + Vector3.new(0, 10, 0), Position);
    v47.Parent = workspace.Temporary;
    local v49 = (Position - WorldPosition).Magnitude / VenomSpitterFlags.SpitTravelSpeed:Get();
    local v50 = math.max(v49, 0.05);
    local v51 = 0;

    while v51 < v50 do
        v51 = v51 + game:GetService("RunService").Heartbeat:Wait();
        local v52 = v51 / v50;
        v47.CFrame = CFrame.new(v48:CalculatePositionAt(v52), v48:CalculatePositionAt(v52 + 0.001));
        local v53 = false;

        for _, v in workspace:GetPartBoundsInRadius(v47.Position, 2) do
            if v.Parent:HasTag("Character") then
                v53 = true;
                break;
            end;
        end;

        if v53 then
            break;
        end;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://117604953306122";
    Sound.Parent = v47;
    Sound:Play();
    Sound.Ended:Once(function() -- Line: 383
        -- upvalues: Sound (copy)
        Sound:Destroy();
    end);
    game.Debris:AddItem(Sound, 5);

    for _, child in v47.Splash:GetChildren() do
        child:Emit(child:GetAttribute("EmitCount"));
    end;

    for _, child in v47:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false;
        end;
    end;

    v47.Transparency = 1;
    local v54 = OverlapParams.new();
    v54.FilterDescendantsInstances = { game.CollectionService:GetTagged("Character") };
    v54.FilterType = Enum.RaycastFilterType.Include;
    local v55 = workspace:GetPartBoundsInRadius(v47.Position, 3, v54);

    if #v55 > 0 then
        local v56 = nil;

        for _, v in v55 do
            if v.Parent:HasTag("Character") then
                v56 = v.Parent;
                break;
            end;
        end;

        if v56 then
            ProcessBite(v56, p46.Owner);
        end;
    end;
end;

local function setupFlyTrap(p57) -- Line: 534
    -- upvalues: connectParts (copy), addStemBallSockets (copy), groupArmJoints (copy), u1 (copy)
    if not p57:HasTag("InitializationComplete") then
        repeat
            task.wait();
        until p57:HasTag("InitializationComplete");
    end;

    local Stem = p57.Stem;
    local v58 = {};

    for i = 1, 9 do
        local v59 = Stem:FindFirstChild((tostring(i)));

        if v59 then
            table.insert(v58, v59);
        end;
    end;

    connectParts(v58);
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "HeadWeld";
    Motor6D.Part0 = v58[#v58];
    Motor6D.Part1 = p57.Mouth.Rig.RootPart;
    Motor6D.C0 = CFrame.new(0, v58[#v58].Size.Y / 2, 0);
    Motor6D.C1 = p57.Mouth.Rig.RootPart.CFrame:Inverse() * (v58[#v58].CFrame * Motor6D.C0);
    Motor6D.Parent = v58[#v58];

    for _, child in p57.Mouth:GetChildren() do
        if child:IsA("Model") and child.Name ~= "Rig" then
            local v60 = p57.Mouth.Rig[child.Name];

            for _, descendant in child:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local WeldConstraint = Instance.new("WeldConstraint");
                    WeldConstraint.Part0 = descendant;
                    WeldConstraint.Part1 = v60;
                    WeldConstraint.Parent = descendant;
                end;
            end;
        end;
    end;

    local Motor6D2 = Instance.new("Motor6D");
    Motor6D2.Name = "Root";
    Motor6D2.Part0 = p57.Base;
    Motor6D2.Part1 = v58[1];
    Motor6D2.C0 = CFrame.new(0, p57.Base.Size.Y / 2, 0);
    Motor6D2.C1 = v58[1].CFrame:Inverse() * (p57.Base.CFrame * Motor6D2.C0);
    Motor6D2.Parent = p57.Base;

    for _, descendant in p57:GetDescendants() do
        if descendant:IsA("BasePart") and (descendant.Name ~= "Base" and (descendant.Name ~= "HarvestPart" and not (descendant:FindFirstAncestor("PotVisual") or (descendant:FindFirstAncestor("Fruits") or descendant:FindFirstAncestor("FruitSpawnLocations"))))) then
            descendant.Anchored = false;
        end;
    end;

    local v61 = {};

    for _, v in v58 do
        local v62 = v:FindFirstChild(v.Name) or v:FindFirstChildOfClass("Motor6D");
        table.insert(v61, v62);
    end;

    addStemBallSockets(v58, v61);
    local v63 = {};
    local v64 = {};

    for _, v in v61 do
        if v then
            v63[v] = v.C0;
            v64[v] = v.C1;
        end;
    end;

    local v65 = script.AnimationController:Clone();
    v65.Parent = p57;
    local v66 = p57.Base:Clone();
    v66:ClearAllChildren();
    v66.Name = "RotationHandler";
    v66.Anchored = true;
    v66.Parent = p57;
    local v67 = {};

    for _, child in p57:GetChildren() do
        if child:HasTag("Tentacle") then
            local v68 = groupArmJoints(p57, child);
            table.insert(v67, v68);
        end;
    end;

    print(v67);
    local Attachment = Instance.new("Attachment");
    Attachment.Parent = v66;
    Attachment.WorldCFrame = v58[#v58 - 2].CFrame;
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Parent = v66;
    Attachment2.WorldCFrame = p57.Mouth.Rig.IKJoint.CFrame;
    Attachment2.Name = "Banana";
    local Center = v65.Center;
    Center.EndEffector = v58[#v58 - 2];
    Center.ChainRoot = v58[2];
    Center.Target = Attachment;
    Center.Enabled = true;
    local Top = v65.Top;
    Top.EndEffector = p57.Mouth.Rig.IKJoint;
    Top.ChainRoot = v58[#v58 - 2];
    Top.Target = Attachment2;
    Top.Enabled = true;
    local v69 = Random.new():NextInteger(1, 9999);
    local v70 = p57:GetAttribute("PlantId") or p57.Name;
    local v71 = tostring(v70);
    local new = Random.new;
    local v72 = 0;

    for i = 1, #v71 do
        local v73 = v72 * 31 + string.byte(v71, i);
        v72 = bit32.band(v73, 4294967295);
    end;

    local v74 = new(v72):NextNumber(0, 6.283185307179586);
    local v75 = p57.Base.CFrame:ToObjectSpace(Attachment.WorldCFrame);
    local v76 = p57.Base.CFrame:ToObjectSpace(Attachment2.WorldCFrame);
    p57.Mouth.Rig.Base.TopJaw.MaxVelocity = 0.1;
    p57.Mouth.Rig.Base.BottomJaw.MaxVelocity = 0.1;
    tick();
    local v77 = {
        CenterOffset = v75 * CFrame.new(0, 2, 0),
        TopOffset = v76 * CFrame.new(0, 4, 0) * CFrame.Angles(0, 0, -0.7853981633974483)
    };
    local v78 = p57:GetAttribute("UserId");
    local v79 = {
        CurrentTarget = nil,
        TargetLocked = false,
        LookTarget = nil,
        Model = p57,
        Offsets = v77,
        RandomOffset = v69,
        IdleYaw = v74,
        CenterOffset = v75,
        TopOffset = v76,
        Base = v66,
        ArmJoints = v67,
        NextAttack = tick(),
        LastDecision = tick(),
        RestPoses = v63
    };
    local v80;

    if typeof(v78) == "number" then
        v80 = game.Players:GetPlayerByUserId(v78);
    else
        v80 = nil;
    end;

    v79.Owner = v80;
    v79.StartingPivot = v66.CFrame;
    v79.Attachment1 = Attachment;
    v79.Attachment2 = Attachment2;
    u1[p57] = v79;
end;

game.CollectionService:GetInstanceAddedSignal("VenomSpitter"):Connect(setupFlyTrap);

local function getDesiredAgeUpdateHz() -- Line: 153
    local success, result = pcall(function() -- Line: 154
        return UserSettings().GameSettings;
    end);

    if not (success and result) then
        return 30;
    end;

    local SavedQualityLevel = result.SavedQualityLevel;
    local v81 = nil;

    if typeof(SavedQualityLevel) == "EnumItem" then
        SavedQualityLevel = SavedQualityLevel.Value;
    elseif type(SavedQualityLevel) ~= "number" then
        SavedQualityLevel = v81;
    end;

    return type(SavedQualityLevel) == "number" and (SavedQualityLevel == 0 and 30 or (SavedQualityLevel >= 7 and 60 or (SavedQualityLevel >= 4 and 25 or 30))) or 50;
end;

local function findTarget(p82) -- Line: 38
    -- upvalues: Players (copy)
    if p82:GetAttribute("Decaying") then
        return;
    end;

    local Night = game.ReplicatedStorage:FindFirstChild("Night");
    local v83;

    if Night and Night:IsA("BoolValue") then
        v83 = Night.Value == true;
    else
        v83 = false;
    end;

    if not v83 then
        return;
    end;

    local v84 = p82:GetAttribute("UserId");
    local v85 = nil;
    local v86 = nil;

    for _, v in Players:GetPlayers() do
        if v84 ~= v.UserId and v.Character then
            local Magnitude = (v.Character:GetPivot().Position - p82.Base.Position).Magnitude;

            if Magnitude < 40 and (not v85 or Magnitude < v85) then
                v86 = v.Character;
                v85 = Magnitude;
            end;
        end;
    end;

    if v86 then
        return v86.HumanoidRootPart;
    end;
end;

local function Attack(u87) -- Line: 427
    -- upvalues: createProjectile (copy)
    local v88 = CFrame.new(0, 10, 20) * u87.Offsets.CenterOffset * CFrame.new(0, 0, 0);
    local v89 = CFrame.new(0, 10, 5) * u87.Offsets.TopOffset;
    local CenterOffset = u87.Offsets.CenterOffset;
    local TopOffset = u87.Offsets.TopOffset;
    local u90 = {};
    local v91 = 0;

    for _, descendant in u87.Model.Mouth:GetDescendants() do
        if descendant:IsA("BasePart") then
            u90[descendant] = descendant.CanCollide;
            descendant.CanCollide = false;
        end;
    end;

    while v91 < 1 do
        v91 = v91 + game:GetService("RunService").Heartbeat:Wait();
        local v92 = game.TweenService:GetValue(v91 / 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        u87.CenterOffset = u87.Offsets.CenterOffset:Lerp(v88, v92);
        u87.TopOffset = u87.Offsets.TopOffset:Lerp(v89, v92);
        u87.Model.Mouth.Rig.Base.BottomJaw.DesiredAngle = -0.4 * v92;
        u87.Model.Mouth.Rig.Base.TopJaw.DesiredAngle = 0.3 * v92;
    end;

    print("open");
    local v93 = 0;

    while v93 < 0.1 do
        v93 = v93 + game:GetService("RunService").Heartbeat:Wait();
        local v94 = game.TweenService:GetValue(v93 / 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In);
        u87.CenterOffset = v88:Lerp(CenterOffset, v94);
        u87.TopOffset = v89:Lerp(TopOffset, v94);
    end;

    task.delay(0.1, function() -- Line: 480
        -- upvalues: u87 (copy), createProjectile (ref)
        for _, child in u87.Model.Mouth.Rig.Base.Spit:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount"));
        end;

        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://132317668925404";
        Sound.Parent = u87.Model.Mouth.Rig.Base.Spit;
        Sound:Play();
        Sound.Ended:Once(function() -- Line: 489
            -- upvalues: Sound (copy)
            Sound:Destroy();
        end);
        game.Debris:AddItem(Sound, 5);
        createProjectile(u87);
    end);
    local v95 = {};

    for i, _ in u87.RestPoses do
        v95[i] = {
            C0 = i.C0,
            C1 = i.C1
        };
    end;

    task.delay(1, function() -- Line: 510
        -- upvalues: u90 (copy)
        for i, v in u90 do
            i.CanCollide = v;
        end;
    end);
    local v96 = 0;

    while v96 < 1 do
        v96 = v96 + game:GetService("RunService").Heartbeat:Wait();
        local v97 = game.TweenService:GetValue(v96 / 1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
        u87.CenterOffset = CenterOffset:Lerp(u87.Offsets.CenterOffset, v97);
        u87.TopOffset = TopOffset:Lerp(u87.Offsets.TopOffset, v97);
        u87.Model.Mouth.Rig.Base.BottomJaw.DesiredAngle = -0.4 + 0.4 * v97;
        u87.Model.Mouth.Rig.Base.TopJaw.DesiredAngle = -(0.3 + -0.3 * v97);
    end;
end;

local v98 = {};

for _, v in game.CollectionService:GetTagged("VenomSpitter") do
    setupFlyTrap(v);
end;

task.spawn(function() -- Line: 716
    -- upvalues: getDesiredAgeUpdateHz (copy), u1 (copy), EffectLoadManager (copy), findTarget (copy), VenomSpitterFlags (copy), Attack (copy)
    while true do
        local wait = task.wait;
        local v99 = getDesiredAgeUpdateHz();
        local v100 = wait(v99 <= 0 and 0.02 or 1 / math.clamp(v99, 15, 60));
        debug.profilebegin("Controllers/VenomSpitterController/Tick");

        for i, v in u1 do
            if i:IsDescendantOf(workspace) then
                if EffectLoadManager.ShouldAnimateInstance(i, 80) then
                    if tick() - v.LastDecision > 1 then
                        v.LastDecision = tick();
                        task.spawn(function() -- Line: 736
                            -- upvalues: v (copy), findTarget (ref), i (copy), VenomSpitterFlags (ref), Attack (ref)
                            if v.CurrentTarget == nil or not v.CurrentTarget:IsDescendantOf(workspace) then
                                v.CurrentTarget = findTarget(i);

                                if v.CurrentTarget then
                                    v.NextAttack = tick() + 2;
                                end;
                            end;

                            if v.CurrentTarget and ((v.CurrentTarget.Position - i.Base.Position).Magnitude < 60 and tick() - v.NextAttack > 0) then
                                v.TargetLocked = true;
                                v.NextAttack = tick() + VenomSpitterFlags.SpitInterval:Get();
                                Attack(v);
                                v.TargetLocked = false;
                                v.CurrentTarget = findTarget(i);
                            end;
                        end);
                    end;

                    local Position = (i.Base.CFrame * CFrame.Angles(0, v.IdleYaw, 0) * CFrame.new(0, 0, 8)).Position;
                    local v101;

                    if v.CurrentTarget then
                        v101 = v.CurrentTarget.Position or Position;
                    else
                        v101 = Position;
                    end;

                    v.LookTarget = v101;
                    local new = CFrame.new;
                    local v102 = (v.RandomOffset + tick()) * 0.7;
                    local v103 = new(0, math.sin(v102), 0);
                    local v104 = (v.LookTarget - v.Base.Position).Unit * Vector3.new(1, 0, 1);

                    if not v.TargetLocked then
                        if v.CurrentTarget then
                            Position = v.CurrentTarget.Position or Position;
                        end;

                        v.LookTarget = Position;
                    end;

                    local v105 = math.clamp(1 - (v.LookTarget - v.Base.Position).Magnitude / 25, 0, 1);
                    local v106 = CFrame.Angles(math.rad(v105 * -20), 0, 0);
                    local Position2 = i.Base.Position;
                    v.Base.CFrame = v.Base.CFrame:Lerp(CFrame.new(Position2, Position2 + v104) * v106, v100 * 2);
                    v.Attachment1.WorldCFrame = v.Base.CFrame * v.CenterOffset * v103;
                    v.Attachment2.WorldCFrame = v.Base.CFrame * v.TopOffset * v103 * v106;

                    for _, v2 in v.ArmJoints do
                        local Attachment = v2.Attachment;
                        local startingCF = v2.startingCF;
                        local v107 = (v.RandomOffset + tick()) * 1.2;
                        local v108 = math.sin(v107);
                        local v109 = 4 + v.RandomOffset + tick() * 1.2;
                        local v110 = math.sin(v109);
                        Attachment.Position = startingCF + Vector3.new(0, v108, v110);
                        v2.bend:CCDIKIterateOnce(v2.Attachment.WorldPosition, 0.1, v100);
                    end;
                end;
            else
                u1[i] = nil;
            end;
        end;

        debug.profileend();
    end;
end);

return v98;