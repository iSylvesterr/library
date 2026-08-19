-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CatmullRomSpline = require(ReplicatedStorage.ClientModules.CatmullRomSpline);
local CCDIKController = require(ReplicatedStorage.ClientModules.CCDIKController);
local LocalPlayer = Players.LocalPlayer;

local function LoadAnim(p1) -- Line: 21
    if not p1 then
        return;
    end;

    local v2 = p1:FindFirstChildOfClass("Humanoid");

    if not v2 then
        return;
    end;

    local v3 = v2:FindFirstChildOfClass("Animator");

    if not v3 then
        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://78592768207309";
    v3:LoadAnimation(Animation).Priority = Enum.AnimationPriority.Action;
end;

local u4 = RaycastParams.new();
u4.FilterType = Enum.RaycastFilterType.Exclude;

local function Raycast(p5, p6) -- Line: 48
    -- upvalues: LocalPlayer (copy), u4 (copy)
    local v7 = {};

    if LocalPlayer.Character then
        table.insert(v7, LocalPlayer.Character);
    end;

    if p6 then
        for _, v in game.CollectionService:GetTagged("Character") do
            table.insert(v7, v);
        end;
    end;

    local v8 = 10;

    while true do
        u4.FilterDescendantsInstances = v7;
        local v9 = workspace:Raycast(p5.Origin, p5.Direction * 40, u4);

        if not v9 then
            break;
        end;

        local Instance2 = v9.Instance;

        if Instance2.Transparency < 1 and (Instance2.CanQuery and not Instance2:IsDescendantOf(LocalPlayer.Character)) then
            return v9.Position, Instance2, v9.Normal;
        end;

        table.insert(v7, Instance2);
        v8 = v8 - 1;

        if v8 == 0 then
            return;
        end;
    end;

    return p5.Origin + p5.Direction * 40;
end;

local function randomPerpOffset(p10, p11) -- Line: 86
    local v12 = Random.new();
    local v13 = p10.Unit:Dot(Vector3.new(0, 1, 0));
    local v14 = math.abs(v13) > 0.9 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0);
    local Unit = p10.Unit:Cross(v14).Unit;
    local Unit2 = p10.Unit:Cross(Unit).Unit;

    return Unit * v12:NextNumber(-p11, p11) + Unit2 * v12:NextNumber(-p11, p11);
end;

local Vine = game.ReplicatedStorage.Assets.Vine;

local function FollowPath(p15, p16, u17) -- Line: 97
    -- upvalues: RunService (copy), Vine (copy), TweenService (copy)
    local v18 = math.round((p15 - p16).Magnitude / 2) + 1;
    local Part = Instance.new("Part");
    Part.Size = Vector3.new(0.01, 0.01, 0.01);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.CastShadow = false;
    Part.EnableFluidForces = false;
    Part.MaterialVariant = "Weld 2x2 Plastic";
    Part.Color = Color3.fromRGB(44, 101, 29);
    Part.Parent = u17;
    local u19 = 0;
    local u20 = 0.1 + v18 * 0.005;
    local PrimaryPart = u17.PrimaryPart;
    local Z = PrimaryPart.Size.Z;
    task.spawn(function() -- Line: 122
        -- upvalues: u19 (ref), u20 (copy), RunService (ref), Z (copy), PrimaryPart (copy), Part (copy), u17 (copy)
        while u19 < u20 do
            u19 = u19 + RunService.Heartbeat:Wait();
            local v21 = u19 / u20;
            local v22 = v21 * Z;
            local v23 = CFrame.new(0, 0, Z / 2 - v22 / 2);
            Part.CFrame = PrimaryPart.CFrame * v23;
            Part.Size = Vector3.new(0.7 * v21, 0.7 * v21, v22);
        end;

        Part.CFrame = PrimaryPart.CFrame;
        local WeldConstraint = Instance.new("WeldConstraint");
        Part.Anchored = false;
        WeldConstraint.Part0 = Part;
        WeldConstraint.Part1 = u17.PrimaryPart;
        WeldConstraint.Parent = Part;
    end);

    for i = 0, v18 do
        local v24 = i / math.round(v18);
        p15:Lerp(p16, v24);
        local v25 = Vine:Clone();
        local v26 = v25.Size * Random.new():NextNumber(0.8, 1.3);
        v25.Size = Vector3.new(0, 0, 0);
        v25.Parent = u17;
        local PrimaryPart2 = u17.PrimaryPart;
        local Z2 = PrimaryPart2.Size.Z;
        local v27 = CFrame.new(0, 0, Z2 / 2 - v24 * Z2);
        local v28 = PrimaryPart2.CFrame * v27;
        v25.CFrame = CFrame.new(v28.Position, v28.Position + Random.new():NextUnitVector());
        TweenService:Create(v25, TweenInfo.new(0.3), {
            Size = v26
        }):Play();
        TweenService:Create(v25.SurfaceAppearance, TweenInfo.new(0.35), {
            Color = Color3.fromRGB(44, 101, 29)
        }):Play();
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v25;
        WeldConstraint.Part1 = u17.PrimaryPart;
        WeldConstraint.Parent = v25;
        v25.Anchored = false;
        v25.Massless = true;
        v25.CanCollide = false;
        v25.CanQuery = false;
        v25.CanTouch = false;
        v25.CastShadow = false;
        v25.EnableFluidForces = false;
        task.wait(0.005);
    end;
end;

local function BuildSpline(p29, p30) -- Line: 195
    -- upvalues: randomPerpOffset (copy), CatmullRomSpline (copy)
    local v31 = p30 - p29;
    local Magnitude = v31.Magnitude;
    local v32 = p29 + v31 * 0.33 + randomPerpOffset(v31, 3) + Vector3.new(0, 5, 0);
    local v33 = p29 + v31 * 0.66 + randomPerpOffset(v31, 3) + Vector3.new(0, 4, 0);
    local v34 = p29 - v31.Unit * (Magnitude * 0.15) + randomPerpOffset(v31, 0.8999999999999999);
    local v35 = p30 + v31.Unit * (Magnitude * 0.15) + randomPerpOffset(v31, 0.8999999999999999);
    local v36 = CatmullRomSpline.new({
        v34,
        p29,
        v32,
        v33
    });
    v36:AddPoint(p30);
    v36:AddPoint(v35);

    return v36;
end;

local function FollowSplinePath(p37, p38, p39) -- Line: 213
    -- upvalues: BuildSpline (copy), FollowPath (copy)
    local v40 = BuildSpline(p37, p38);
    local Model = Instance.new("Model");
    Model.Name = "VineGroup";
    Model.Parent = workspace.Temporary;
    local v41 = {};
    local v42 = {};
    local v43 = {};
    local v44 = 0;

    for i = 1, 6 do
        local Model2 = Instance.new("Model");
        Model2.Name = "Segment_" .. i;
        Model2.Parent = Model;
        v41[i] = Model2;
        local v45 = v40:CalculatePositionAt((i - 1) / 6);
        local v46 = v40:CalculatePositionAt(i / 6);
        v42[i] = v45;

        if i == 6 then
            v42[i + 1] = v46;
        end;

        table.insert(v43, {
            SegStart = v45,
            SegEnd = v46
        });
        local Magnitude = (v46 - v45).Magnitude;
        local Part = Instance.new("Part");
        Part.Name = "PrimaryPart";
        Part.Anchored = false;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Massless = true;
        Part.CastShadow = false;
        Part.EnableFluidForces = false;
        Part.Transparency = 1;
        Part.Size = Vector3.new(1, 1, Magnitude);
        Part.CFrame = CFrame.lookAt((v45 + v46) / 2, v46);
        Part.Parent = Model2;
        Model2.PrimaryPart = Part;
        v44 = v44 + Magnitude;
    end;

    local v47 = {};
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "RootJoint";
    Motor6D.Part0 = p39;
    Motor6D.Part1 = v41[1].PrimaryPart;
    local v48 = CFrame.new(v42[1]);
    Motor6D.C0 = p39.CFrame:Inverse() * v48;
    Motor6D.C1 = v41[1].PrimaryPart.CFrame:Inverse() * v48;
    Motor6D.Parent = p39;
    v47[1] = Motor6D;

    for i = 1, 5 do
        local PrimaryPart = v41[i].PrimaryPart;
        local PrimaryPart2 = v41[i + 1].PrimaryPart;
        local v49 = CFrame.new(v42[i + 1]);
        local Motor6D2 = Instance.new("Motor6D");
        Motor6D2.Name = "Joint_" .. i;
        Motor6D2.Part0 = PrimaryPart;
        Motor6D2.Part1 = PrimaryPart2;
        Motor6D2.C0 = PrimaryPart.CFrame:Inverse() * v49;
        Motor6D2.C1 = PrimaryPart2.CFrame:Inverse() * v49;
        Motor6D2.Parent = PrimaryPart;
        v47[i + 1] = Motor6D2;
    end;

    for _, v in v47 do
        local Attachment = Instance.new("Attachment");
        Attachment.Name = v.Part0.Name .. "AxisAttachment";
        Attachment.CFrame = v.C0;
        Attachment.Parent = v.Part0;
        local Attachment2 = Instance.new("Attachment");
        Attachment2.Name = v.Part0.Name .. "JointAttachment";
        Attachment2.CFrame = v.C1;
        Attachment2.Parent = v.Part1;
    end;

    local PrimaryPart = v41[6].PrimaryPart;
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "Target";
    Attachment.CFrame = CFrame.new(0, 0, -PrimaryPart.Size.Z / 2);
    Attachment.Parent = PrimaryPart;

    for _, v in v41 do
        v.PrimaryPart.Anchored = false;
    end;

    for i, v in v43 do
        local u50 = v41[i];
        task.spawn(function() -- Line: 333
            -- upvalues: FollowPath (ref), v (copy), u50 (copy)
            FollowPath(v.SegStart, v.SegEnd, u50);
        end);
    end;

    return v41, v47, v44, Model;
end;

local function createVine(p51, p52) -- Line: 342
    -- upvalues: LocalPlayer (copy), Networking (copy), FollowSplinePath (copy), Players (copy), CCDIKController (copy), UserInputService (copy), Raycast (copy), RunService (copy), TweenService (copy)
    local Character = p51.Character;

    if not Character then
        return;
    end;

    local v53 = nil;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and (child:HasTag("VineWrapper") or (child:GetAttribute("VineWrapper") or child.Name == "Vine Wrapper")) then
            v53 = child;
            break;
        end;
    end;

    if not v53 then
        return;
    end;

    local Handle = v53:FindFirstChild("Handle");

    if not (Handle and Handle:FindFirstChild("VineEmitter")) then
        return;
    end;

    local v54 = game.SoundService.SFX["Vine Cast"]:Clone();
    v54.Parent = v53.Handle;
    v54:Play();
    game.Debris:AddItem(v54, 3);
    local VineEmitter = v53.Handle.VineEmitter;

    if p51 == LocalPlayer then
        Networking.VineWrapper.Activate:Fire(p52);
    end;

    local v55, v56, v57, v58 = FollowSplinePath(VineEmitter.Position, p52, VineEmitter);
    local v59 = nil;

    if p51 == LocalPlayer then
        local v60 = OverlapParams.new();
        v60.FilterDescendantsInstances = game.CollectionService:GetTagged("Character");
        v60.FilterType = Enum.RaycastFilterType.Whitelist;
        local v61 = workspace:GetPartBoundsInRadius(p52, 12, v60);

        if #v61 > 0 then
            for _, v in v61 do
                if v.Parent ~= Character and (v.Parent and v.Parent:HasTag("Character")) then
                    local v62 = Players:GetPlayerFromCharacter(v.Parent);

                    if not (v62 and (v62:GetAttribute("InSafeZone") or v62:GetAttribute("IsInOwnGarden"))) then
                        v59 = v.Parent;
                        break;
                    end;
                end;
            end;
        end;

        if v59 then
            Networking.VineWrapper.AssignTarget:Fire(v59, v57);
        end;
    else
        local v63 = tick();

        repeat
            task.wait();
            v59 = v53.Target.Value;
        until v59 or tick() - v63 > 2;
    end;

    local v64 = {};

    for _, v in v56 do
        v64[v] = {
            ConstraintType = "BallSocketConstraint",
            UpperAngle = 35,
            TwistLimitsEnabled = false
        };
    end;

    local v65 = CCDIKController.new(v56, v64);
    v65.LerpMode = false;
    v65.ConstantLerpSpeed = false;
    v65.AngularSpeed = 12.566370614359172;
    v65.UseLastMotor = false;
    tick();
    local v66 = 0;
    local v67 = p51 ~= LocalPlayer;
    local v68 = 0;
    v54:Stop();
    local v69 = game.SoundService.SFX.VineStrike:Clone();
    v69.Parent = v53.Handle;
    v69:Play();
    game.Debris:AddItem(v69, 3);

    if v59 then
        game.Debris:AddItem(v69, 3);
        local v70 = p52;
        local v71 = v70;
        local v72 = v70;
        v70 = v71;
        v72 = v71;

        while v68 < 7.5 and (v59 and (Character:FindFirstChild("HumanoidRootPart") and (v53 and (v53:IsDescendantOf(workspace) and v53:GetAttribute("Active") == true)))) do
            local v73 = game:GetService("RunService").Heartbeat:Wait();
            v68 = v68 + v73;

            if p51 == LocalPlayer then
                local v74 = UserInputService:GetMouseLocation();
                local v75, _, v76 = Raycast(workspace.CurrentCamera:ViewportPointToRay(v74.X, v74.Y), true);
                local v77 = v75 + (v76 or Vector3.new(0, 0.3, 0)) * 8;
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
                local v78;

                if HumanoidRootPart then
                    v78 = HumanoidRootPart:FindFirstChild("VineTarget");
                else
                    v78 = HumanoidRootPart;
                end;

                if v78 and v78:IsA("Attachment") then
                    local Position = HumanoidRootPart.Position;

                    if v57 < (v77 - Position).Magnitude then
                        v77 = Position + (v77 - Position).Unit * v57;
                    end;

                    v70 = v70:Lerp(v77, 1 - math.exp(-18 * v73));
                    v78.WorldCFrame = CFrame.new(v70, Position);
                end;
            end;

            if v59 and v59:FindFirstChild("HumanoidRootPart") then
                v71 = v59.HumanoidRootPart.Position;
            end;

            local v79;

            if v67 then
                v79 = tick();

                if v79 - v66 >= 0.03333333333333333 then
                    if (v71 - p52).Magnitude ^ 2 > 0.01 or v66 == 0 then
                        v65:CCDIKIterateOnce(v71, 0, v79 - v66);
                        p52 = v71;
                    end;
                else
                    v79 = v66;
                end;
            else
                v65:CCDIKIterateUntil(v71, 0.5, 3, v73);
                v79 = v66;
                p52 = v71;
            end;

            v66 = v79;
        end;
    elseif p51 == LocalPlayer then
        local v80 = tick();

        while tick() - v80 < 0.3 and (v53 and (v53:IsDescendantOf(workspace) and v53:GetAttribute("Active") == true)) do
            RunService.Heartbeat:Wait();
        end;
    end;

    v53:SetAttribute("Active", false);
    local Attachment = Instance.new("Attachment");
    Attachment.Position = v58:GetPivot().Position;
    local v81 = game.SoundService.SFX.VineCrumble:Clone();
    v81.Parent = Attachment;
    v81:Play();
    Attachment.Parent = workspace.Terrain;
    game.Debris:AddItem(Attachment, 3);

    for _, v in v55 do
        v.PrimaryPart.Anchored = true;
        task.spawn(function() -- Line: 544
            -- upvalues: v (copy), TweenService (ref)
            for _, child in v:GetChildren() do
                if child ~= v.PrimaryPart then
                    if child:IsA("MeshPart") then
                        TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Size = Vector3.new(0, 0, 0),
                            CFrame = CFrame.new(child.Position, child.Position + Random.new():NextUnitVector())
                        }):Play();
                        TweenService:Create(child.SurfaceAppearance, TweenInfo.new(0.2), {
                            Color = Color3.fromRGB(71, 35, 14)
                        }):Play();
                    elseif child:IsA("BasePart") then
                        TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Size = Vector3.new(0, 0, 0)
                        }):Play();
                    end;

                    task.wait(0.005);
                end;
            end;

            task.delay(0.2, function() -- Line: 565
                -- upvalues: v (ref)
                v:Destroy();
            end);
        end);
    end;

    for _, v in v56 do
        v:Destroy();
    end;

    game.Debris:AddItem(v58, 5);
end;

local u82 = game.MaterialService.ToolMaterials.GlowWeldTemplate:Clone();
u82.Name = "WeldGlow_Player_Vine";
u82.Parent = game.MaterialService.ToolMaterials;

local function newVineWrapper(u83) -- Line: 585
    -- upvalues: LocalPlayer (copy), UserInputService (copy), Raycast (copy), ReplicatedStorage (copy), u82 (copy), createVine (copy)
    if u83.Parent ~= LocalPlayer.Backpack and u83.Parent ~= LocalPlayer.Character then
        return;
    end;

    local u84 = false;
    local u85 = 0;

    local function toolEquipped() -- Line: 596
        -- upvalues: u84 (ref), u83 (copy)
        u84 = true;

        for _, child in u83.Handle.Vines:GetChildren() do
            child.MaterialVariant = "WeldGlow_Player_Vine";
        end;
    end;

    local function toolUnequipped() -- Line: 605
        -- upvalues: u84 (ref)
        u84 = false;
    end;

    local function activated() -- Line: 611
        -- upvalues: UserInputService (ref), u85 (ref), u83 (copy), LocalPlayer (ref), Raycast (ref), ReplicatedStorage (ref), u82 (ref), createVine (ref)
        local v86 = UserInputService:GetMouseLocation();
        local v87 = workspace.CurrentCamera:ViewportPointToRay(v86.X, v86.Y);

        if tick() - u85 < 2 then
            return;
        end;

        if u83:GetAttribute("Active") == true then
            return;
        end;

        local v88 = u83:GetAttribute("CooldownUntil");

        if v88 and workspace:GetServerTimeNow() < v88 then
            return;
        end;

        if LocalPlayer.Character and LocalPlayer.Character:GetAttribute("VineWrapped") then
            return;
        end;

        u85 = tick();
        u83:SetAttribute("Active", true);
        local v89, v90, _ = Raycast(v87);
        local u91 = true;
        local v92;

        if u83:IsDescendantOf(LocalPlayer.Character) then
            v92 = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage.Assets.Animations.VinewrapperSlam);
            v92.Priority = Enum.AnimationPriority.Action;
            v92:Play(0.5, 1, 1);
            game.TweenService:Create(u82, TweenInfo.new(1), {
                EmissiveStrength = 2
            }):Play();

            for _, child in u83.Handle.VineEmitterAttachment:GetChildren() do
                child.Enabled = true;
            end;

            task.spawn(function() -- Line: 665
                -- upvalues: u91 (ref), u82 (ref), u83 (ref)
                while u91 do
                    task.wait(0.1);
                    local Part = Instance.new("Part");
                    Part.Size = Vector3.new(0.2, 0.2, 0.2);
                    Part.Color = ({ Color3.fromRGB(162, 227, 51), Color3.fromRGB(56, 158, 40), Color3.fromRGB(45, 141, 52) })[Random.new():NextInteger(1, 3)];
                    Part.Parent = workspace.Temporary;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CanTouch = false;
                    Part.CanQuery = false;
                    Part.MaterialVariant = u82.Name;
                    game.TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {
                        Size = Vector3.new(0.4, 0.4, 0.4)
                    }):Play();
                    local u93 = 0.8 / #u83.DetailEffect:GetChildren();
                    local u94 = nil;
                    task.spawn(function() -- Line: 691
                        -- upvalues: u83 (ref), u94 (ref), u93 (copy), Part (copy)
                        for i = 1, #u83.DetailEffect:GetChildren() do
                            local v95 = u83.DetailEffect:FindFirstChild((tostring(i)));

                            if u94 == nil then
                                u94 = v95;
                            else
                                local v96 = 0;

                                while v96 < u93 do
                                    v96 = v96 + game:GetService("RunService").Heartbeat:Wait();
                                    Part.CFrame = u94.CFrame:Lerp(v95.CFrame, v96 / u93);
                                end;

                                u94 = v95;
                            end;
                        end;

                        Part:Destroy();
                    end);
                end;
            end);
            local u97 = ClientTrapCharacter(LocalPlayer.Character, game.ReplicatedStorage.Assets.VineArmTemplate);
            v92:GetMarkerReachedSignal("SlamDown"):Wait();
            v92:AdjustSpeed(0);
            game.TweenService:Create(u82, TweenInfo.new(1), {
                EmissiveStrength = 1
            }):Play();

            for _, child in u83.Handle.VineEmitterAttachment:GetChildren() do
                child:Emit(child:GetAttribute("EmitCount"));
            end;

            task.spawn(function() -- Line: 725
                -- upvalues: LocalPlayer (ref), u91 (ref), u82 (ref), u97 (copy), u83 (ref)
                local v98 = LocalPlayer.Character.Torso:WaitForChild("Left Shoulder");
                local v99 = LocalPlayer.Character.Torso:WaitForChild("Right Shoulder");
                local C0 = v98.C0;
                local C02 = v99.C0;
                local v100 = 0;

                while u91 do
                    v100 = v100 + task.wait(0);
                    local v101 = math.sin(v100 * 4) * 0.03490658503988659;
                    local v102 = math.cos(v100 * 4) * 0.03490658503988659;
                    local v103 = (math.sin(v100 * 20) * 0.6 + math.sin(v100 * 20 * 1.4) * 0.4) * 0.03490658503988659;
                    v99.C0 = C02 * CFrame.Angles(v101 + v103, 0, v102 + v103);
                    v98.C0 = C0 * CFrame.Angles(v101 + v103, 0, -(v102 + v103));
                end;

                game.TweenService:Create(u82, TweenInfo.new(1), {
                    EmissiveStrength = 0
                }):Play();
                u97();

                for _, child in u83.Handle.VineEmitterAttachment:GetChildren() do
                    child.Enabled = false;
                    child:Emit(child:GetAttribute("EmitCount"));
                end;

                v98.C0 = C0;
                v99.C0 = C02;
            end);
        else
            v92 = nil;
        end;

        if not v89 then
            u83:SetAttribute("Active", false);

            return;
        end;

        if v90 then
            local v104 = v90:FindFirstAncestorOfClass("Model");

            while v104 and v104 ~= workspace do
                if v104:HasTag("Character") and v104 ~= LocalPlayer.Character then
                    local HumanoidRootPart = v104:FindFirstChild("HumanoidRootPart");

                    if HumanoidRootPart then
                        v89 = HumanoidRootPart.Position;
                    end;

                    break;
                end;

                local Parent = v104.Parent;

                if Parent then
                    v104 = v104.Parent:FindFirstAncestorOfClass("Model");
                else
                    v104 = Parent;
                end;
            end;
        end;

        createVine(LocalPlayer, v89);
        v92:AdjustSpeed(-1);
        u91 = false;
        u83:SetAttribute("Active", false);
    end;

    local function syncCooldownVisual() -- Line: 800
        -- upvalues: u83 (copy)
        local v105 = u83:GetAttribute("CooldownUntil");

        if typeof(v105) ~= "number" then
            return;
        end;

        local v106 = v105 - workspace:GetServerTimeNow();
        local v107 = math.max(0, v106);
        u83:SetAttribute("CooldownEnd", os.clock() + v107);
    end;

    u83:GetAttributeChangedSignal("CooldownUntil"):Connect(syncCooldownVisual);
    syncCooldownVisual();
    u83.Activated:Connect(activated);
    u83.Unequipped:Connect(toolUnequipped);
    u83.Equipped:Connect(toolEquipped);
end;

game.CollectionService:GetInstanceAddedSignal("VineWrapper"):Connect(newVineWrapper);
local v108 = {};

for _, v in game.CollectionService:GetTagged("VineWrapper") do
    newVineWrapper(v);
end;

Networking.VineWrapper.SendVisual.OnClientEvent:Connect(function(p109, p110) -- Line: 823
    -- upvalues: createVine (copy)
    createVine(p109, p110);
end);
local VineWrapperAssets = ReplicatedStorage.Assets:WaitForChild("VineWrapperAssets");
local VineTemplate = VineWrapperAssets:WaitForChild("VineTemplate");
local Flower = VineWrapperAssets:WaitForChild("Flower");
local u111 = { {
        Name = "Left Leg",
        Wait = 0
    }, {
        Name = "Right Leg",
        Wait = 0.05
    }, {
        Name = "Torso",
        Wait = 0.1
    }, {
        Name = "Left Arm",
        Wait = 0.18
    }, {
        Name = "Right Arm",
        Wait = 0.2
    } };
local u112 = {
    Color3.fromRGB(255, 180, 200),
    Color3.fromRGB(255, 230, 130),
    Color3.fromRGB(200, 160, 255),
    Color3.fromRGB(255, 120, 100),
    Color3.fromRGB(180, 220, 255)
};
local u113 = {};

local function Weld(p114, p115) -- Line: 854
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p115;
    WeldConstraint.Part1 = p114;
    WeldConstraint.Parent = p114;
end;

local function HushPart(p116) -- Line: 862
    p116.CanCollide = false;
    p116.CanQuery = false;
    p116.CanTouch = false;
    p116.Massless = true;
    p116.CastShadow = false;
    p116.EnableFluidForces = false;
end;

local function GrowLimb(u117, p118, p119) -- Line: 872
    -- upvalues: TweenService (copy), Flower (copy), u112 (copy)
    local CFrame2 = p119.CFrame;
    local u120 = {};

    for _, descendant in u117:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= p119 then
            u120[descendant] = {
                Offset = CFrame2:ToObjectSpace(descendant.CFrame),
                TargetSize = descendant.Size
            };
        end;
    end;

    for i, v in u120 do
        i.CFrame = p118.CFrame * v.Offset;
        i.Size = Vector3.new(0.01, 0.01, 0.01);
        i.Transparency = 1;
        i.Anchored = false;
        i.CanCollide = false;
        i.CanQuery = false;
        i.CanTouch = false;
        i.Massless = true;
        i.CastShadow = false;
        i.EnableFluidForces = false;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = p118;
        WeldConstraint.Part1 = i;
        WeldConstraint.Parent = i;
    end;

    u117.Parent = p118;
    local v121 = {};

    for i, _ in u120 do
        local v122 = math.floor((i.Position - p119.Position).Magnitude / 0.5);
        v121[v122] = v121[v122] or {};
        table.insert(v121[v122], i);
    end;

    local v123 = {};

    for i in v121 do
        table.insert(v123, i);
    end;

    table.sort(v123);
    local v124 = 0;

    for _, v in v123 do
        local u125 = v121[v];
        task.delay(v124, function() -- Line: 909
            -- upvalues: u125 (copy), u120 (copy), TweenService (ref), Flower (ref), u112 (ref), u117 (copy)
            for _, v2 in u125 do
                if v2.Parent then
                    local v126 = u120[v2];

                    if v126 then
                        v2.Transparency = 0;
                        TweenService:Create(v2, TweenInfo.new(0.04), {
                            Size = v126.TargetSize
                        }):Play();
                        task.spawn(function() -- Line: 916
                            -- upvalues: v2 (copy), Flower (ref), u112 (ref), u117 (ref), TweenService (ref)
                            local Sprout = v2:FindFirstChild("Sprout");

                            if not (Sprout and Sprout:IsA("Attachment")) then
                                return;
                            end;

                            local u127 = Flower:Clone();

                            if not (u127:FindFirstChild("Petals") and u127:FindFirstChild("Base")) then
                                u127:Destroy();

                                return;
                            end;

                            local v128 = u112[Random.new():NextInteger(1, #u112)];

                            for _, child in u127.Petals:GetChildren() do
                                child.Color = v128;
                            end;

                            u127.Parent = u117;
                            u127:PivotTo(Sprout.WorldCFrame);

                            for _, descendant in u127:GetDescendants() do
                                if descendant:IsA("BasePart") then
                                    descendant.CanCollide = false;
                                    descendant.CanQuery = false;
                                    descendant.CanTouch = false;
                                    descendant.Massless = true;
                                    descendant.CastShadow = false;
                                    descendant.EnableFluidForces = false;
                                end;
                            end;

                            local Weld2 = Instance.new("Weld");
                            Weld2.Part0 = Sprout.Parent;
                            Weld2.Part1 = u127.Base;
                            Weld2.C0 = Sprout.Parent.CFrame:ToObjectSpace(u127.Base.CFrame);
                            Weld2.C1 = CFrame.new();
                            Weld2.Parent = u127.Base;
                            u127:ScaleTo(0.01);
                            local v129 = Random.new():NextNumber(0.6, 1.1);

                            for _, descendant in u127:GetDescendants() do
                                if descendant:IsA("BasePart") then
                                    local _ = descendant.Size * (v129 / 0.01);
                                    TweenService:Create(descendant, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                        Size = descendant.Size * v129 * 100
                                    }):Play();
                                end;
                            end;

                            task.delay(0.5, function() -- Line: 960
                                -- upvalues: u127 (copy)
                                for _, child in u127.Base:GetChildren() do
                                    if child:IsA("Motor6D") then
                                        child.DesiredAngle = 0.7853981633974483;

                                        if child.Name == "Reverse" then
                                            child.DesiredAngle = child.DesiredAngle * -1;
                                        end;

                                        child.MaxVelocity = 0.03;
                                    end;
                                end;
                            end);
                        end);
                        task.wait(0.01);
                    end;
                end;
            end;
        end);
        v124 = v124 + 0.02;
    end;
end;

function ClientTrapCharacter(u130, p131)
    -- upvalues: VineTemplate (copy), u111 (copy), GrowLimb (copy), TweenService (copy)
    local v132 = (p131 or VineTemplate):Clone();
    v132.Name = "Vines";
    local u133 = {};

    for _, v in u111 do
        local v134 = v132:FindFirstChild(v.Name);
        local u135 = u130:FindFirstChild(v.Name);

        if v134 and u135 then
            local u136 = nil;

            for _, child in v134:GetChildren() do
                if child:IsA("BasePart") and child.Name == v.Name then
                    u136 = child;
                    break;
                end;
            end;

            if u136 then
                local Model = v134:FindFirstChild("Model");

                if Model then
                    task.delay(v.Wait, function() -- Line: 1005
                        -- upvalues: u130 (copy), u135 (copy), GrowLimb (ref), Model (copy), u136 (ref)
                        if not (u130.Parent and u135.Parent) then
                            return;
                        end;

                        GrowLimb(Model, u135, u136);
                    end);
                    u136:Destroy();
                    table.insert(u133, Model);
                end;
            end;
        end;
    end;

    return function() -- Line: 1014, Name: Destroy
        -- upvalues: u133 (copy), TweenService (ref)
        for _, v in u133 do
            game.Debris:AddItem(v, 1);
            local v137 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            local v138 = Color3.fromRGB(71, 35, 14);

            for _, child in v:GetChildren() do
                if child:IsA("BasePart") then
                    TweenService:Create(child, v137, {
                        Size = Vector3.new(0, 0, 0),
                        Color = v138
                    }):Play();
                elseif child:IsA("Model") then
                    for _, descendant in child:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            TweenService:Create(descendant, v137, {
                                Size = Vector3.new(0, 0, 0),
                                Color = v138
                            }):Play();
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

Networking.VineWrapper.WrapCharacter.OnClientEvent:Connect(function(p139) -- Line: 1037
    -- upvalues: u113 (copy)
    if not (p139 and p139:IsDescendantOf(workspace)) then
        return;
    end;

    if u113[p139] then
        pcall(u113[p139]);
        u113[p139] = nil;
    end;

    u113[p139] = ClientTrapCharacter(p139);
end);
Networking.VineWrapper.UnwrapCharacter.OnClientEvent:Connect(function(p140) -- Line: 1047
    -- upvalues: u113 (copy)
    if not p140 then
        return;
    end;

    local v141 = u113[p140];

    if v141 then
        u113[p140] = nil;
        pcall(v141);
    end;
end);
v108.WrapCharacter = ClientTrapCharacter;

return v108;