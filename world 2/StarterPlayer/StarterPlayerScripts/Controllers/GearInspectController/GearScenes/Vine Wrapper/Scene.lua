-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CatmullRomSpline = require(ReplicatedStorage.ClientModules.CatmullRomSpline);
local CCDIKController = require(ReplicatedStorage.ClientModules.CCDIKController);
local VineWrapperController = require(game.Players.LocalPlayer.PlayerScripts.Controllers.VineWrapperController);
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://96203034991173";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://116086843391846";
local Animation3 = Instance.new("Animation");
Animation3.AnimationId = "rbxassetid://96228963929073";
local VineInspect = script.Parent.VineInspect;
VineInspect.Parent = nil;
local u2 = game.MaterialService.ToolMaterials.GlowWeldTemplate:Clone();
u2.Name = "WeldGlow_Player_Shop";
u2.Parent = game.MaterialService.ToolMaterials;
local Vine = ReplicatedStorage.Assets.Vine;

local function RandomPerpendicularOffset(p3, p4) -- Line: 47
    local v5 = Random.new();
    local v6 = p3.Unit:Dot(Vector3.new(0, 1, 0));
    local v7 = math.abs(v6) > 0.9 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0);
    local Unit = p3.Unit:Cross(v7).Unit;
    local Unit2 = p3.Unit:Cross(Unit).Unit;

    return Unit * v5:NextNumber(-p4, p4) + Unit2 * v5:NextNumber(-p4, p4);
end;

local function BuildSpline(p8, p9) -- Line: 56
    -- upvalues: RandomPerpendicularOffset (copy), CatmullRomSpline (copy)
    local v10 = p9 - p8;
    local Magnitude = v10.Magnitude;
    local v11 = p8 + v10 * 0.33 + RandomPerpendicularOffset(v10, 3) + Vector3.new(0, 15, 0);
    local v12 = p8 + v10 * 0.66 + RandomPerpendicularOffset(v10, 3) + Vector3.new(0, 12, 0);
    local v13 = p8 - v10.Unit * (Magnitude * 0.15) + RandomPerpendicularOffset(v10, 0.8999999999999999);
    local v14 = p9 + v10.Unit * (Magnitude * 0.15) + RandomPerpendicularOffset(v10, 0.8999999999999999);
    local v15 = CatmullRomSpline.new({
        v13,
        p8,
        v11,
        v12
    });
    v15:AddPoint(p9);
    v15:AddPoint(v14);

    return v15;
end;

local function GrowSegment(p16, p17, u18) -- Line: 74
    -- upvalues: RunService (copy), Vine (copy)
    local v19 = math.round((p16 - p17).Magnitude / 2) + 1;
    local PrimaryPart = u18.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Size = Vector3.new(0.01, 0.01, 0.01);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.MaterialVariant = "Weld 2x2 Plastic";
    Part.Color = Color3.fromRGB(44, 101, 29);
    Part.Parent = u18;
    local u20 = 0;
    local u21 = 0.1 + v19 * 0.005;
    local Z = PrimaryPart.Size.Z;
    task.spawn(function() -- Line: 94
        -- upvalues: u20 (ref), u21 (copy), u18 (copy), RunService (ref), Z (copy), PrimaryPart (copy), Part (copy)
        while u20 < u21 and u18.Parent do
            u20 = u20 + RunService.Heartbeat:Wait();
            local v22 = u20 / u21;
            local v23 = v22 * Z;
            local v24 = CFrame.new(0, 0, Z / 2 - v23 / 2);
            Part.CFrame = PrimaryPart.CFrame * v24;
            Part.Size = Vector3.new(0.7 * v22, 0.7 * v22, v23);
        end;

        if not u18.Parent then
            return;
        end;

        Part.CFrame = PrimaryPart.CFrame;
        local WeldConstraint = Instance.new("WeldConstraint");
        Part.Anchored = false;
        WeldConstraint.Part0 = Part;
        WeldConstraint.Part1 = u18.PrimaryPart;
        WeldConstraint.Parent = Part;
    end);

    for i = 0, v19 do
        if not u18.Parent then
            return;
        end;

        local v25 = i / math.round(v19);
        local Z2 = PrimaryPart.Size.Z;
        local v26 = CFrame.new(0, 0, Z2 / 2 - v25 * Z2);
        local v27 = PrimaryPart.CFrame * v26;
        local v28 = Vine:Clone();
        local v29 = v28.Size * Random.new():NextNumber(0.8, 1.3);
        v28.Size = Vector3.new(0, 0, 0);
        v28.Parent = u18;
        v28.CFrame = CFrame.new(v27.Position, v27.Position + Random.new():NextUnitVector());
        game.TweenService:Create(v28, TweenInfo.new(0.3), {
            Size = v29
        }):Play();
        game.TweenService:Create(v28.SurfaceAppearance, TweenInfo.new(0.35), {
            Color = Color3.fromRGB(44, 101, 29)
        }):Play();
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v28;
        WeldConstraint.Part1 = u18.PrimaryPart;
        WeldConstraint.Parent = v28;
        v28.Anchored = false;
        v28.Massless = true;
        v28.CanCollide = false;
        v28.CanQuery = false;
        v28.CanTouch = false;
        task.wait(0.005);
    end;
end;

local function FireVine(p30, p31, p32, p33) -- Line: 146
    -- upvalues: BuildSpline (copy), CCDIKController (copy), GrowSegment (copy)
    local v34 = BuildSpline(p30, p31);
    local Model = Instance.new("Model");
    Model.Name = "VineGroup";
    Model.Parent = p33;
    local u35 = {};
    local v36 = {};
    local v37 = {};

    for i = 1, 10 do
        local Model2 = Instance.new("Model");
        Model2.Name = "Segment_" .. i;
        Model2.Parent = Model;
        u35[i] = Model2;
        local v38 = v34:CalculatePositionAt((i - 1) / 10);
        local v39 = v34:CalculatePositionAt(i / 10);
        v36[i] = v38;

        if i == 10 then
            v36[i + 1] = v39;
        end;

        table.insert(v37, {
            SegStart = v38,
            SegEnd = v39
        });
        local Magnitude = (v39 - v38).Magnitude;
        local Part = Instance.new("Part");
        Part.Name = "PrimaryPart";
        Part.Anchored = false;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.Massless = true;
        Part.Transparency = 1;
        Part.Size = Vector3.new(1, 1, Magnitude);
        Part.CFrame = CFrame.lookAt((v38 + v39) / 2, v39);
        Part.Parent = Model2;
        Model2.PrimaryPart = Part;
    end;

    local u40 = {};
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "RootJoint";
    Motor6D.Part0 = p32;
    Motor6D.Part1 = u35[1].PrimaryPart;
    local v41 = CFrame.new(v36[1]);
    Motor6D.C0 = p32.CFrame:Inverse() * v41;
    Motor6D.C1 = u35[1].PrimaryPart.CFrame:Inverse() * v41;
    Motor6D.Parent = p32;
    u40[1] = Motor6D;

    for i = 1, 9 do
        local PrimaryPart = u35[i].PrimaryPart;
        local PrimaryPart2 = u35[i + 1].PrimaryPart;
        local v42 = CFrame.new(v36[i + 1]);
        local Motor6D2 = Instance.new("Motor6D");
        Motor6D2.Name = "Joint_" .. i;
        Motor6D2.Part0 = PrimaryPart;
        Motor6D2.Part1 = PrimaryPart2;
        Motor6D2.C0 = PrimaryPart.CFrame:Inverse() * v42;
        Motor6D2.C1 = PrimaryPart2.CFrame:Inverse() * v42;
        Motor6D2.Parent = PrimaryPart;
        u40[i + 1] = Motor6D2;
    end;

    for _, v in u35 do
        v.PrimaryPart.Anchored = false;
    end;

    for _, v in u40 do
        local Attachment = Instance.new("Attachment");
        Attachment.Name = v.Part0.Name .. "AxisAttachment";
        Attachment.CFrame = v.C0;
        Attachment.Parent = v.Part0;
        local Attachment2 = Instance.new("Attachment");
        Attachment2.Name = v.Part0.Name .. "JointAttachment";
        Attachment2.CFrame = v.C1;
        Attachment2.Parent = v.Part1;
    end;

    local v43 = {};

    for _, v in u40 do
        v43[v] = {
            ConstraintType = "BallSocketConstraint",
            UpperAngle = 35,
            TwistLimitsEnabled = false
        };
    end;

    local u44 = CCDIKController.new(u40, v43);
    u44.LerpMode = false;
    u44.ConstantLerpSpeed = false;
    u44.AngularSpeed = 0.7853981633974483;
    u44.UseLastMotor = false;

    for i, v in v37 do
        local u45 = u35[i];
        task.spawn(function() -- Line: 253
            -- upvalues: GrowSegment (ref), v (copy), u45 (copy)
            GrowSegment(v.SegStart, v.SegEnd, u45);
        end);
    end;

    return {
        Retract = function() -- Line: 265, Name: Retract
            -- upvalues: Model (copy), u35 (copy), u40 (copy)
            if not Model.Parent then
                return;
            end;

            for _, v in u35 do
                if v.Parent then
                    v.PrimaryPart.Anchored = true;
                    task.spawn(function() -- Line: 271
                        -- upvalues: v (copy)
                        for _, child in v:GetChildren() do
                            if child ~= v.PrimaryPart then
                                if child:IsA("MeshPart") then
                                    game.TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                                        Size = Vector3.new(0, 0, 0),
                                        CFrame = CFrame.new(child.Position, child.Position + Random.new():NextUnitVector())
                                    }):Play();

                                    if child:FindFirstChildOfClass("SurfaceAppearance") then
                                        game.TweenService:Create(child.SurfaceAppearance, TweenInfo.new(0.2), {
                                            Color = Color3.fromRGB(71, 35, 14)
                                        }):Play();
                                    end;
                                elseif child:IsA("BasePart") then
                                    game.TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                                        Size = Vector3.new(0, 0, 0)
                                    }):Play();
                                end;

                                task.wait(0.005);
                            end;
                        end;
                    end);
                end;
            end;

            task.delay(0.6, function() -- Line: 292
                -- upvalues: u40 (ref), Model (ref)
                for _, v in u40 do
                    if v and v.Parent then
                        v:Destroy();
                    end;
                end;

                if Model and Model.Parent then
                    Model:Destroy();
                end;
            end);
        end,

        UpdateGoal = function(p46, p47) -- Line: 259, Name: UpdateGoal
            -- upvalues: Model (copy), u44 (copy)
            if not Model.Parent then
                return;
            end;

            u44:CCDIKIterateOnce(p46, 0, p47);
        end
    };
end;

function v1.Run(p48) -- Line: 304
    -- upvalues: VineInspect (copy), RunService (copy), Animation (copy), Animation2 (copy), Animation3 (copy), VineWrapperController (copy), ReplicatedStorage (copy), u2 (copy), FireVine (copy)
    local _ = p48.Plot;
    local PlayerModel = p48.PlayerModel;
    local Camera = p48.Camera;
    local Trove = p48.Trove;

    if not (PlayerModel and p48.PlayerHumanoid) then
        return;
    end;

    local u49 = VineInspect:Clone();
    Trove:Add(u49);
    local u50 = PlayerModel:Clone();
    u50.PrimaryPart = u50.HumanoidRootPart;
    u50:PivotTo(u49.Player1:GetPivot());
    u50.Parent = u49;
    local u51 = u49.Player1["Vine Wrapper"]:Clone();
    u51.Parent = u50;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = u51.Handle;
    WeldConstraint.Part1 = u50["Right Arm"];
    WeldConstraint.Parent = u50;
    u49.Player1:Destroy();
    u50.Name = "Player1";
    u49.Parent = workspace.Terrain;
    Camera.CameraType = Enum.CameraType.Scriptable;
    local u53 = RunService.RenderStepped:Connect(function(p52) -- Line: 360
        -- upvalues: u49 (copy), Camera (copy)
        if not u49.Parent then
            return;
        end;

        workspace.CurrentCamera.CFrame = u49.Camera.Camera.CFrame;
        Camera.FieldOfView = 35;
    end);
    Trove:Add(u53);
    local v54 = { Animation, Animation2, Animation3 };
    game:GetService("ContentProvider"):PreloadAsync(v54);
    local u55 = script.FadeIn:Clone();
    u55.Parent = game.Players.LocalPlayer.PlayerGui;
    u55.Frame.BackgroundTransparency = 0;
    Trove:Add(u55);

    repeat
        task.wait(0.25);
    until game:GetService("ContentProvider").RequestQueueSize == 0;

    if not u49.Parent then
        return;
    end;

    local u56 = u50.Humanoid.Animator:LoadAnimation(Animation);
    local u57 = u49.Player2.Humanoid.Animator:LoadAnimation(Animation2);
    local u58 = u49.Camera.AnimationController.Animator:LoadAnimation(Animation3);
    p48:ApplyRandomFriendAppearance(u49.Player2, nil, true);
    local v59 = {};
    workspace.CurrentCamera.FieldOfView = 35;
    local u60 = true;
    Trove:Add(u58:GetMarkerReachedSignal("Start"):Connect(function() -- Line: 397
        -- upvalues: u55 (copy)
        game.TweenService:Create(u55.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play();
    end));

    if not u49:FindFirstChild("Temporary") then
        local Folder = Instance.new("Folder");
        Folder.Name = "Temporary";
        Folder.Parent = u49;
    end;

    local v61 = u58:GetMarkerReachedSignal("Chargeup");
    table.insert(v59, v61:Connect(function() -- Line: 409
        -- upvalues: VineWrapperController (ref), u50 (copy), ReplicatedStorage (ref), u2 (ref), u51 (copy), u60 (ref), u49 (copy)
        task.spawn(function() -- Line: 410
            -- upvalues: VineWrapperController (ref), u50 (ref), ReplicatedStorage (ref), u2 (ref), u51 (ref), u60 (ref), u49 (ref)
            local v62 = VineWrapperController.WrapCharacter(u50, ReplicatedStorage.Assets.VineArmTemplate);
            game.TweenService:Create(u2, TweenInfo.new(1), {
                EmissiveStrength = 2
            }):Play();

            for _, child in u51.Handle.VineEmitterAttachment:GetChildren() do
                child.Enabled = true;
                child:Emit(child:GetAttribute("EmitCount"));
            end;

            u60 = true;

            while u60 do
                task.wait(0.1);
                local v63 = u49 and u49.Parent and u49:FindFirstChild("Temporary");

                if not v63 then
                    break;
                end;

                local Part = Instance.new("Part");
                Part.Size = Vector3.new(0.2, 0.2, 0.2);
                Part.Color = ({ Color3.fromRGB(162, 227, 51), Color3.fromRGB(56, 158, 40), Color3.fromRGB(45, 141, 52) })[Random.new():NextInteger(1, 3)];
                Part.Parent = v63;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanTouch = false;
                Part.CanQuery = false;
                Part.MaterialVariant = u2.Name;
                game.TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {
                    Size = Vector3.new(0.4, 0.4, 0.4)
                }):Play();
                local u64 = 0.8 / #u51.DetailEffect:GetChildren();
                local u65 = nil;
                task.spawn(function() -- Line: 446
                    -- upvalues: u51 (ref), u65 (ref), u64 (copy), Part (copy)
                    for i = 1, #u51.DetailEffect:GetChildren() do
                        if not u51:FindFirstChild("DetailEffect") then
                            return;
                        end;

                        local v66 = u51.DetailEffect:FindFirstChild((tostring(i)));

                        if u65 == nil then
                            u65 = v66;
                        else
                            local v67 = 0;

                            while v67 < u64 do
                                v67 = v67 + game:GetService("RunService").Heartbeat:Wait();
                                Part.CFrame = u65.CFrame:Lerp(v66.CFrame, v67 / u64);
                            end;

                            u65 = v66;
                        end;
                    end;

                    Part:Destroy();
                end);
            end;

            v62();
        end);
    end));
    local u68 = nil;
    local u69 = nil;
    local v70 = u58:GetMarkerReachedSignal("CreateVine");
    table.insert(v59, v70:Connect(function() -- Line: 482
        -- upvalues: u2 (ref), u51 (copy), u68 (ref), FireVine (ref), u49 (copy), u69 (ref), VineWrapperController (ref), RunService (ref), Trove (copy)
        game.TweenService:Create(u2, TweenInfo.new(1), {
            EmissiveStrength = 1
        }):Play();

        for _, child in u51.Handle.VineEmitterAttachment:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount"));
        end;

        local v71 = game.SoundService.SFX["Vine Cast"]:Clone();
        v71.Parent = u51.Handle;
        v71:Play();
        game.Debris:AddItem(v71, 3);
        u68 = FireVine(u51.Handle.VineEmitter.Position, u49.Player2.Torso.Position, u51.Handle.VineEmitter, u49.Temporary);
        u69 = VineWrapperController.WrapCharacter(u49.Player2);
        local u72 = nil;
        u72 = RunService.Heartbeat:Connect(function(p73) -- Line: 502
            -- upvalues: u49 (ref), u72 (ref), u68 (ref)
            if u49.Parent and u49.Temporary.Parent then
                u68.UpdateGoal(u49.Player2.Torso.Position, p73);

                return;
            end;

            if u72 then
                u72:Disconnect();
            end;
        end);
        Trove:Add(u69);
        Trove:Add(u72);
    end));
    local v74 = u58:GetMarkerReachedSignal("VineDisconnect");
    table.insert(v59, v74:Connect(function() -- Line: 513
        -- upvalues: u68 (ref), u60 (ref), u69 (ref), u2 (ref), u51 (copy)
        if u68.Retract then
            pcall(u68.Retract);
        end;

        u60 = false;
        u69();
        game.TweenService:Create(u2, TweenInfo.new(1), {
            EmissiveStrength = 0
        }):Play();

        for _, child in u51.Handle.VineEmitterAttachment:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount"));
            child.Enabled = false;
        end;

        local v75 = game.SoundService.SFX.VineStrike:Clone();
        v75.Parent = u51.Handle;
        v75:Play();
        game.Debris:AddItem(v75, 3);
        local v76 = game.SoundService.SFX.VineCrumble:Clone();
        v76.Parent = u51.Handle;
        v76:Play();
        game.Debris:AddItem(v76, 2);
    end));
    local v77 = u58:GetMarkerReachedSignal("FadeOut");
    table.insert(v59, v77:Connect(function() -- Line: 543
        -- upvalues: u55 (copy)
        game.TweenService:Create(u55.Frame, TweenInfo.new(0.3), {
            BackgroundTransparency = 0
        }):Play();
    end));
    u56.Looped = true;
    u57.Looped = true;
    u58.Looped = true;
    u56:Play();
    u57:Play();
    u58:Play();
    Camera.FieldOfView = 25;
    Trove:Add(function() -- Line: 562
        -- upvalues: u60 (ref), u68 (ref), u69 (ref), u55 (copy), u53 (ref), u56 (copy), u58 (copy), u57 (copy)
        u60 = false;

        if u68 and u68.Retract then
            pcall(u68.Retract);
        end;

        if u69 then
            u69();
            u69 = nil;
        end;

        if u55 then
            u55:Destroy();
        end;

        if u53 then
            u53:Disconnect();
        end;

        if u56 then
            u56:Stop();
            u56:Destroy();
        end;

        if u58 then
            u58:Stop();
            u58:Destroy();
        end;

        if u57 then
            u57:Stop();
            u57:Destroy();
        end;
    end);
end;

return v1;