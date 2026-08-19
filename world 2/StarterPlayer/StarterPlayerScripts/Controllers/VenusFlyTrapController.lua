-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
game:GetService("CollectionService");
game:GetService("RunService");
game:GetService("TweenService");
local u1 = {};
local CCDIKController = require(script.CCDIKController);
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local RagdollModule = require(game.ReplicatedStorage.ClientModules.RagdollModule);
local EffectLoadManager = require(game.ReplicatedStorage.SharedModules.EffectLoadManager);

local function lerp(p2, p3, p4) -- Line: 15
    return p2 + (p3 - p2) * p4;
end;

local function weldFruitToPlant(p5, p6) -- Line: 19
    local v7 = p6.PlantModel and p6.PlantModel.Base and p6.PlantModel.Base:FindFirstChild("PLAYER_POINT");

    if not v7 then
        return;
    end;

    if not p5:IsA("Model") then
        if p5:IsA("BasePart") then
            p5.Anchored = false;
            p5.CanCollide = false;
            p5.CFrame = v7.CFrame;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = p5;
            WeldConstraint.Part1 = v7;
            WeldConstraint.Parent = p5;
        end;

        return;
    end;

    local PrimaryPart = p5.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    for _, descendant in p5:GetDescendants() do
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

    p5:PivotTo(v7.CFrame);
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = PrimaryPart;
    WeldConstraint.Part1 = v7;
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

local function connectParts(p8, p9) -- Line: 120
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
                v14.Name = "EndJoint";
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

local function hzToTick(p18) -- Line: 220
    return p18 <= 0 and 0.02 or 1 / math.clamp(p18, 15, 60);
end;

local function groupArmJoints(p19, p20) -- Line: 225
    -- upvalues: CCDIKController (copy)
    local v21 = {};

    for _, child in p20:GetChildren() do
        local v22 = child:FindFirstChildOfClass("Motor6D");

        if v22 then
            v21[tonumber(child.Name)] = v22;
        end;
    end;

    local v23 = nil;

    for i = 1, #v21 do
        if v21[i] ~= nil then
            v23 = i;
            break;
        end;
    end;

    local v24 = { table.unpack(v21, v23) };
    local CFrame2 = p20.EndJoint.CFrame;
    local Attachment = Instance.new("Attachment");
    Attachment.Parent = p19.RotationHandler;
    Attachment.WorldCFrame = CFrame2;

    return {
        bend = CCDIKController.new(v24),
        Attachment = Attachment,
        joints = v24,
        startingCF = Attachment.Position,
        maxRange = (CFrame2.Position - (v24[1].C0 * v24[1].Part0.CFrame).Position).Magnitude * 0.9
    };
end;

local function addStemBallSockets(p25, p26) -- Line: 257
    local v27 = {};

    for i, v in p25 do
        if p26[i] then
            local v28 = v.CFrame * CFrame.new(0, v.Size.Y / 2, 0);
            local Attachment = Instance.new("Attachment");
            Attachment.Name = v.Name .. "AxisAttachment";
            Attachment.Parent = v;
            Attachment.WorldCFrame = v28 * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
            local v29 = p25[i + 1];

            if v29 then
                local Attachment2 = Instance.new("Attachment");
                Attachment2.Name = v.Name .. "JointAttachment";
                Attachment2.Parent = v29;
                Attachment2.WorldCFrame = v28 * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966);
                local BallSocketConstraint = Instance.new("BallSocketConstraint");
                BallSocketConstraint.Name = v.Name .. "BallSocket";
                BallSocketConstraint.LimitsEnabled = true;
                BallSocketConstraint.UpperAngle = 90;
                BallSocketConstraint.Attachment0 = Attachment;
                BallSocketConstraint.Attachment1 = Attachment2;
                BallSocketConstraint.Parent = v;
                table.insert(v27, BallSocketConstraint);
            end;
        end;
    end;

    return v27;
end;

local function ProcessBite(p30) -- Line: 307
    -- upvalues: RagdollModule (copy), Networking (copy)
    RagdollModule:Ragdoll(game.Players.LocalPlayer.Character, 2);
    Networking.FlytrapService.Chomp:Fire(p30);
end;

local function setupFlyTrap(u31) -- Line: 446
    -- upvalues: connectParts (copy), addStemBallSockets (copy), weldFruitToPlant (copy), groupArmJoints (copy), u1 (copy)
    local v32 = {};

    if not u31:HasTag("InitializationComplete") then
        repeat
            task.wait();
        until u31:HasTag("InitializationComplete");
    end;

    for i = 1, 8 do
        if u31:FindFirstChild((tostring(i))) then
            local v33 = tostring(i);
            table.insert(v32, u31:FindFirstChild(v33));
        end;
    end;

    connectParts(v32);
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Part0 = v32[#v32];
    Motor6D.Part1 = u31.PlantModel.Rig.RootPart;
    Motor6D.C0 = CFrame.new(0, v32[#v32].Size.Y / 2, 0);
    Motor6D.Name = "HeadWeld";
    Motor6D.C1 = u31.PlantModel.Rig.RootPart.CFrame:Inverse() * (v32[#v32].CFrame * Motor6D.C0);
    Motor6D.Parent = v32[#v32];

    for _, child in u31.PlantModel:GetChildren() do
        if child:IsA("Model") and child.Name ~= "Rig" then
            local v34 = u31.PlantModel.Rig[child.Name];

            for _, descendant in child:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local WeldConstraint = Instance.new("WeldConstraint");
                    WeldConstraint.Part0 = descendant;
                    WeldConstraint.Part1 = v34;
                    WeldConstraint.Parent = descendant;
                end;
            end;
        end;
    end;

    local Fruit_Spawn = u31.FruitSpawnLocations:FindFirstChild("Fruit_Spawn");
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = Fruit_Spawn;
    WeldConstraint.Part1 = u31.PlantModel.Rig.Base;
    WeldConstraint.Parent = Fruit_Spawn;
    local Motor6D2 = Instance.new("Motor6D");
    Motor6D2.Part0 = u31.Base;
    Motor6D2.Part1 = v32[1];
    Motor6D2.Name = "Root";
    Motor6D2.C0 = CFrame.new(0, u31.Base.Size.Y / 2, 0);
    Motor6D2.C1 = v32[1].CFrame:Inverse() * (u31.Base.CFrame * Motor6D2.C0);
    Motor6D2.Parent = u31.Base;
    local v35 = {};

    for _, v in v32 do
        local v36 = v:FindFirstChild(v.Name) or v:FindFirstChildOfClass("Motor6D");
        table.insert(v35, v36);
    end;

    u31.PlantModel.Rig.RootPart:FindFirstChildOfClass("Motor6D");
    addStemBallSockets(v32, v35);
    local v37 = {};
    local v38 = {};

    for _, v in v35 do
        if v then
            v37[v] = v.C0;
            v38[v] = v.C1;
        end;
    end;

    local Fruits = u31:FindFirstChild("Fruits");

    if Fruits then
        for _, child in Fruits:GetChildren() do
            weldFruitToPlant(child, u31);
        end;

        Fruits.ChildAdded:Connect(function(u39) -- Line: 542
            -- upvalues: u31 (copy), weldFruitToPlant (ref)
            task.defer(function() -- Line: 543
                -- upvalues: u39 (copy), u31 (ref), weldFruitToPlant (ref)
                if u39 and (u39.Parent and (u31 and u31.Parent)) then
                    weldFruitToPlant(u39, u31);
                end;
            end);
        end);
    end;

    for _, descendant in u31:GetDescendants() do
        if descendant:IsA("BasePart") and (descendant.Name ~= "Base" and (descendant.Name ~= "HarvestPart" and not descendant:FindFirstAncestor("PotVisual"))) then
            descendant.Anchored = false;
            descendant.Massless = true;
        end;
    end;

    local v40 = {};

    for _, descendant in u31:GetDescendants() do
        if descendant:IsA("BasePart") and (descendant ~= u31.Base and (descendant.Name ~= "HarvestPart" and not descendant:FindFirstAncestor("PotVisual"))) then
            v40[descendant] = u31.Base.CFrame:ToObjectSpace(descendant.CFrame);
        end;
    end;

    local v41 = script.AnimationController:Clone();
    v41.Parent = u31;
    local v42 = u31.Base:Clone();
    v42:ClearAllChildren();
    v42.Name = "RotationHandler";
    v42.Anchored = true;
    v42.Parent = u31;
    local v43 = { groupArmJoints(u31, u31.Leaf1), (groupArmJoints(u31, u31.Leaf2)) };
    local Attachment = Instance.new("Attachment");
    Attachment.Parent = v42;
    Attachment.WorldCFrame = v32[#v32 - 2].CFrame;
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Parent = v42;
    Attachment2.WorldCFrame = u31.PlantModel.Rig.IKJoint.CFrame;
    Attachment2.Name = "Banana";
    local Center = v41.Center;
    Center.EndEffector = v32[#v32 - 2];
    Center.ChainRoot = v32[2];
    Center.Target = Attachment;
    Center.Enabled = true;
    local Top = v41.Top;
    Top.EndEffector = u31.PlantModel.Rig.IKJoint;
    Top.ChainRoot = v32[#v32 - 2];
    Top.Target = Attachment2;
    Top.Enabled = true;
    local v44 = Random.new():NextInteger(1, 9999);
    local v45 = u31.Base.CFrame:ToObjectSpace(Attachment.WorldCFrame);
    local v46 = u31.Base.CFrame:ToObjectSpace(Attachment2.WorldCFrame);
    u31.PlantModel.Rig.Base.TopJaw.MaxVelocity = 0.15;
    u31.PlantModel.Rig.Base.BottomJaw.MaxVelocity = 0.15;
    tick();
    local v47 = {
        CenterOffset = v45 * CFrame.new(0, 2, 0),
        TopOffset = v46 * CFrame.new(0, 4, 0) * CFrame.Angles(0, 0, -0.7853981633974483)
    };
    local v48 = u31:GetAttribute("UserId");
    local v49 = {
        CurrentTarget = nil,
        TargetLocked = false,
        LookTarget = nil,
        Model = u31,
        Offsets = v47,
        RandomOffset = v44,
        CenterOffset = v45,
        TopOffset = v46,
        Base = v42,
        ArmJoints = v43,
        NextAttack = tick(),
        LastDecision = tick(),
        RestPoses = v37
    };
    local v50;

    if typeof(v48) == "number" then
        v50 = game.Players:GetPlayerByUserId(v48);
    else
        v50 = nil;
    end;

    v49.Owner = v50;
    v49.StartingPivot = v42.CFrame;
    v49.Attachment1 = Attachment;
    v49.Attachment2 = Attachment2;
    u1[u31] = v49;
end;

game.CollectionService:GetInstanceAddedSignal("VenusFlyTrap"):Connect(setupFlyTrap);

local function getDesiredAgeUpdateHz() -- Line: 198
    local success, result = pcall(function() -- Line: 199
        return UserSettings().GameSettings;
    end);

    if not (success and result) then
        return 30;
    end;

    local SavedQualityLevel = result.SavedQualityLevel;
    local v51 = nil;

    if typeof(SavedQualityLevel) == "EnumItem" then
        SavedQualityLevel = SavedQualityLevel.Value;
    elseif type(SavedQualityLevel) ~= "number" then
        SavedQualityLevel = v51;
    end;

    return type(SavedQualityLevel) == "number" and (SavedQualityLevel == 0 and 30 or (SavedQualityLevel >= 7 and 60 or (SavedQualityLevel >= 4 and 25 or 30))) or 50;
end;

local function findTarget(p52) -- Line: 76
    -- upvalues: Players (copy)
    if p52:GetAttribute("Decaying") then
        return;
    end;

    local Night = game.ReplicatedStorage:FindFirstChild("Night");
    local v53;

    if Night and Night:IsA("BoolValue") then
        v53 = Night.Value == true;
    else
        v53 = false;
    end;

    if not v53 then
        return;
    end;

    local v54 = p52:GetAttribute("UserId");
    local v55 = nil;
    local v56 = nil;

    for _, v in Players:GetPlayers() do
        if v54 ~= v.UserId and v.Character then
            local Magnitude = (v.Character:GetPivot().Position - p52.Base.Position).Magnitude;

            if Magnitude < 40 and (not v55 or Magnitude < v55) then
                v56 = v.Character;
                v55 = Magnitude;
            end;
        end;
    end;

    if v56 then
        return v56.HumanoidRootPart;
    end;
end;

local function Attack(u57) -- Line: 314
    -- upvalues: Players (copy), RagdollModule (copy), Networking (copy)
    local v58 = CFrame.new(0, 0, -1) * u57.Offsets.CenterOffset;
    local v59 = CFrame.new(0, 0, -15);
    local u60 = {};
    local v61 = 0;

    for _, descendant in u57.Model.PlantModel:GetDescendants() do
        if descendant:IsA("BasePart") then
            u60[descendant] = descendant.CanCollide;
            descendant.CanCollide = false;
        end;
    end;

    local u62 = true;

    while v61 < 0.3 do
        v61 = v61 + game:GetService("RunService").Heartbeat:Wait();
        local v63 = game.TweenService:GetValue(v61 / 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In);
        u57.CenterOffset = u57.Offsets.CenterOffset:Lerp(v58, v63);
        u57.TopOffset = u57.Offsets.TopOffset:Lerp(v59, v63);
        local v64 = 0.7 * v63;
        u57.Model.PlantModel.Rig.Base.TopJaw.DesiredAngle = v64;
        u57.Model.PlantModel.Rig.Base.BottomJaw.DesiredAngle = -v64;
    end;

    task.spawn(function() -- Line: 355
        -- upvalues: u57 (copy), u62 (ref), Players (ref), RagdollModule (ref), Networking (ref)
        local _, _ = u57.Model.PlantModel.Rig:GetBoundingBox();
        local v65 = {};

        while u62 do
            task.wait(0);
            local v66, v67 = u57.Model.PlantModel.Rig:GetBoundingBox();
            local v68 = OverlapParams.new();
            v68.FilterDescendantsInstances = { Players.LocalPlayer.Character };
            v68.FilterType = Enum.RaycastFilterType.Include;
            v65 = workspace:GetPartBoundsInBox(v66, v67 * 0.7, v68);

            if #v65 > 0 then
                break;
            end;
        end;

        if #v65 <= 0 then
            u57.Model.PlantModel.Rig.Base.BiteMiss:Play();

            return;
        end;

        u57.Model.PlantModel.Rig.Base.Chomp:Play();

        for _, child in u57.Model.PlantModel.Rig.Base.Attachment:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount") or 3);
        end;

        local Owner = u57.Owner;
        RagdollModule:Ragdoll(game.Players.LocalPlayer.Character, 2);
        Networking.FlytrapService.Chomp:Fire(Owner);
    end);
    task.wait(0.1);
    local v69 = 0;

    while v69 < 0.1 do
        v69 = v69 + game:GetService("RunService").Heartbeat:Wait();
        local v70 = -0.7 + 0.85 * game.TweenService:GetValue(v69 / 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        u57.Model.PlantModel.Rig.Base.TopJaw.DesiredAngle = v70;
        u57.Model.PlantModel.Rig.Base.BottomJaw.DesiredAngle = -v70;
    end;

    u62 = false;
    local v71 = {};

    for i, _ in u57.RestPoses do
        v71[i] = {
            C0 = i.C0,
            C1 = i.C1
        };
    end;

    task.delay(1, function() -- Line: 423
        -- upvalues: u60 (copy)
        for i, v in u60 do
            i.CanCollide = v;
        end;
    end);
    local v72 = 0;

    while v72 < 2 do
        v72 = v72 + game:GetService("RunService").Heartbeat:Wait();
        local v73 = game.TweenService:GetValue(v72 / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
        u57.CenterOffset = v58:Lerp(u57.Offsets.CenterOffset, v73);
        u57.TopOffset = v59:Lerp(u57.Offsets.TopOffset, v73);
        local v74 = -0.15 * v73;
        u57.Model.PlantModel.Rig.Base.TopJaw.DesiredAngle = v74;
        u57.Model.PlantModel.Rig.Base.BottomJaw.DesiredAngle = -v74;
    end;
end;

local v75 = {};

for _, v in game.CollectionService:GetTagged("VenusFlyTrap") do
    setupFlyTrap(v);
end;

task.spawn(function() -- Line: 677
    -- upvalues: getDesiredAgeUpdateHz (copy), u1 (copy), EffectLoadManager (copy), findTarget (copy), Attack (copy)
    while true do
        local wait = task.wait;
        local v76 = getDesiredAgeUpdateHz();
        local v77 = wait(v76 <= 0 and 0.02 or 1 / math.clamp(v76, 15, 60));
        debug.profilebegin("Controllers/VenusFlyTrapController/Tick");

        for i, v in u1 do
            if i:IsDescendantOf(workspace) then
                if EffectLoadManager.ShouldAnimateInstance(i, 80) then
                    local Base = i:FindFirstChild("Base");

                    if Base and Base:IsA("BasePart") then
                        if not Base.Anchored then
                            Base.Anchored = true;
                        end;

                        local PlantModel = i:FindFirstChild("PlantModel");

                        if PlantModel then
                            PlantModel = PlantModel:FindFirstChild("Rig");
                        end;

                        if PlantModel then
                            PlantModel = PlantModel:FindFirstChild("RootPart");
                        end;

                        if PlantModel and (PlantModel:IsA("BasePart") and ((PlantModel.Position - Base.Position).Magnitude > 40 and v.RestRelativeCFrames)) then
                            for i2, v2 in v.RestRelativeCFrames do
                                if i2 and i2.Parent then
                                    i2.CFrame = Base.CFrame * v2;
                                    i2.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                                    i2.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                                end;
                            end;
                        end;
                    end;

                    if tick() - v.LastDecision > 1 then
                        v.LastDecision = tick();
                        task.spawn(function() -- Line: 719
                            -- upvalues: v (copy), findTarget (ref), i (copy), Attack (ref)
                            if v.CurrentTarget == nil or not v.CurrentTarget:IsDescendantOf(workspace) then
                                v.CurrentTarget = findTarget(i);

                                if v.CurrentTarget then
                                    v.NextAttack = tick() + 2;
                                end;
                            end;

                            if v.CurrentTarget and ((v.CurrentTarget.Position - i.Base.Position).Magnitude < 30 and tick() - v.NextAttack > 0) then
                                v.TargetLocked = true;
                                v.NextAttack = tick() + 9;
                                Attack(v);
                                v.TargetLocked = false;
                                v.CurrentTarget = findTarget(i);
                            end;
                        end);
                    end;

                    v.LookTarget = v.CurrentTarget and v.CurrentTarget.Position or i.Base.CFrame * CFrame.new(0, 0, 8).Position;
                    local new = CFrame.new;
                    local v78 = (v.RandomOffset + tick()) * 0.7;
                    local v79 = new(0, math.sin(v78), 0);
                    local v80 = (v.LookTarget - v.Base.Position).Unit * Vector3.new(1, 0, 1);

                    if not v.TargetLocked then
                        v.LookTarget = v.CurrentTarget and v.CurrentTarget.Position or i.Base.CFrame * CFrame.new(0, 0, 8).Position;
                    end;

                    local v81 = math.clamp(1 - (v.LookTarget - v.Base.Position).Magnitude / 25, 0, 1);
                    local v82 = CFrame.Angles(math.rad(v81 * -20), 0, 0);
                    local Position = i.Base.Position;
                    v.Base.CFrame = v.Base.CFrame:Lerp(CFrame.new(Position, Position + v80) * v82, v77 * 2);
                    v.Attachment1.WorldCFrame = v.Base.CFrame * v.CenterOffset * v79;
                    v.Attachment2.WorldCFrame = v.Base.CFrame * v.TopOffset * v79 * v82;

                    for _, v2 in v.ArmJoints do
                        local Attachment = v2.Attachment;
                        local startingCF = v2.startingCF;
                        local v83 = (v.RandomOffset + tick()) * 1.2;
                        local v84 = math.sin(v83);
                        local v85 = 4 + v.RandomOffset + tick() * 1.2;
                        local v86 = math.sin(v85);
                        Attachment.Position = startingCF + Vector3.new(0, v84, v86);
                        v2.bend:CCDIKIterateOnce(v2.Attachment.WorldPosition, 0.1, v77);
                    end;
                end;
            else
                u1[i] = nil;
            end;
        end;

        debug.profileend();
    end;
end);

return v75;