-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local GrapplingHookFlags = require(ReplicatedStorage.SharedModules.Flags.GrapplingHookFlags);
local NotificationController = require(script.Parent.NotificationController);
local LocalPlayer = Players.LocalPlayer;
local u2 = BrickColor.new("Really black");
local u3 = {};
local u4 = nil;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = {};

local function getVisualsFolder() -- Line: 56
    -- upvalues: u7 (ref)
    if u7 and u7.Parent then
        return u7;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "GrapplingHookVisuals";
    Folder.Parent = workspace;
    u7 = Folder;

    return Folder;
end;

local function getGrappleSfxTemplate(p10) -- Line: 67
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("GrapplingHook");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p10);
    end;

    if SFX and SFX:IsA("Sound") then
        return SFX;
    end;

    return nil;
end;

local function makeWorldLoop(p11, p12) -- Line: 79
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("GrapplingHook");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p11);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        return nil;
    end;

    local v13 = SFX:Clone();
    v13.Looped = true;
    v13.RollOffMode = Enum.RollOffMode.InverseTapered;
    v13.RollOffMinDistance = 10;
    v13.RollOffMaxDistance = 150;
    v13.Parent = p12;

    return v13;
end;

local function playWorldOneShot(p14, p15) -- Line: 93
    -- upvalues: SoundService (copy), u7 (ref), Debris (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("GrapplingHook");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p14);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Size = Vector3.new(1, 1, 1);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Transparency = 1;
    Part.Position = p15;
    local v16;

    if u7 and u7.Parent then
        v16 = u7;
    else
        v16 = Instance.new("Folder");
        v16.Name = "GrapplingHookVisuals";
        v16.Parent = workspace;
        u7 = v16;
    end;

    Part.Parent = v16;
    local v17 = SFX:Clone();
    v17.Looped = false;
    v17.RollOffMode = Enum.RollOffMode.InverseTapered;
    v17.RollOffMinDistance = 10;
    v17.RollOffMaxDistance = 150;
    v17.Parent = Part;
    v17:Play();
    v17.Ended:Once(function() -- Line: 116
        -- upvalues: Part (copy)
        Part:Destroy();
    end);
    Debris:AddItem(Part, 10);
end;

local function getRoot(p18) -- Line: 122
    if not p18 then
        return nil;
    end;

    local HumanoidRootPart = p18:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    return nil;
end;

local function getBuiltInTipPivot(p19) -- Line: 133
    local GrapplingHookTip = p19:FindFirstChild("GrapplingHookTip");

    if GrapplingHookTip and GrapplingHookTip:IsA("PVInstance") then
        return GrapplingHookTip:GetPivot();
    end;

    return nil;
end;

local function getTipSpawnCFrame(p20) -- Line: 143
    local v21 = p20.PrimaryPart or p20:FindFirstChild("Handle");

    if not v21 then
        return nil;
    end;

    local TipSpawn = v21:FindFirstChild("TipSpawn");

    if not TipSpawn then
        return nil;
    end;

    if TipSpawn:IsA("Attachment") then
        return TipSpawn.WorldCFrame;
    end;

    if TipSpawn:IsA("BasePart") then
        return TipSpawn.CFrame;
    end;

    return nil;
end;

local function rotationBetween(p22, p23) -- Line: 157
    local Unit = p22.Unit;
    local Unit2 = p23.Unit;
    local v24 = Unit:Dot(Unit2);
    local v25 = math.clamp(v24, -1, 1);

    if v25 > 0.9999 then
        return CFrame.identity;
    end;

    if v25 >= -0.9999 then
        return CFrame.fromAxisAngle(Unit:Cross(Unit2).Unit, (math.acos(v25)));
    end;

    local v26 = Unit:Cross(Vector3.new(1, 0, 0));

    if v26.Magnitude < 0.001 then
        v26 = Unit:Cross(Vector3.new(0, 1, 0));
    end;

    return CFrame.fromAxisAngle(v26.Unit, 3.141592653589793);
end;

local function isConsole() -- Line: 174
    -- upvalues: UserInputService (copy)
    return UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled;
end;

local function getAimScreenPoint(p27) -- Line: 182
    -- upvalues: UserInputService (copy)
    local ViewportSize = p27.ViewportSize;

    if not (UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled) then
        local v28 = UserInputService:GetMouseLocation();

        return Vector2.new(v28.X, v28.Y);
    end;

    if not UserInputService.MouseIconEnabled then
        return ViewportSize / 2;
    end;

    local v29 = UserInputService:GetMouseLocation();

    return Vector2.new(v29.X, v29.Y);
end;

local function raycastSurface(p30) -- Line: 197
    -- upvalues: getAimScreenPoint (copy), u7 (ref)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    local v31 = getAimScreenPoint(CurrentCamera);
    local v32 = CurrentCamera:ViewportPointToRay(v31.X, v31.Y);
    local v33 = RaycastParams.new();
    v33.FilterType = Enum.RaycastFilterType.Exclude;
    local v34 = {};
    local v35;

    if u7 and u7.Parent then
        v35 = u7;
    else
        v35 = Instance.new("Folder");
        v35.Name = "GrapplingHookVisuals";
        v35.Parent = workspace;
        u7 = v35;
    end;

    v34[1], v34[2] = p30, v35;
    v33.FilterDescendantsInstances = v34;
    local Origin = v32.Origin;
    local v36 = v32.Direction * 5000;

    for _ = 1, 10 do
        local v37 = workspace:Raycast(Origin, v36, v33);

        if not v37 then
            return nil;
        end;

        if v37.Instance.Transparency < 1 then
            return v37.Position;
        end;

        local FilterDescendantsInstances = v33.FilterDescendantsInstances;
        table.insert(FilterDescendantsInstances, v37.Instance);
        v33.FilterDescendantsInstances = FilterDescendantsInstances;
    end;

    return nil;
end;

local function hideBuiltInTip(p38) -- Line: 235
    local v39 = {};
    local GrapplingHookTip = p38:FindFirstChild("GrapplingHookTip");

    if not GrapplingHookTip then
        return v39;
    end;

    for _, descendant in GrapplingHookTip:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1;
            table.insert(v39, descendant);
        end;
    end;

    return v39;
end;

local function restoreBuiltInTip(p40) -- Line: 250
    for _, v in p40 do
        if v and v.Parent then
            v.LocalTransparencyModifier = 0;
        end;
    end;
end;

local function sinkAction() -- Line: 261
    return Enum.ContextActionResult.Sink;
end;

local function bindPullControls() -- Line: 265
    -- upvalues: u8 (ref), ContextActionService (copy), sinkAction (copy)
    if u8 then
        return;
    end;

    u8 = true;
    ContextActionService:BindAction("GrapplingHookSink", sinkAction, false, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump);
end;

local function unbindPullControls() -- Line: 282
    -- upvalues: u8 (ref), ContextActionService (copy)
    if not u8 then
        return;
    end;

    u8 = false;
    ContextActionService:UnbindAction("GrapplingHookSink");
end;

local function stopLocalPullPhysics() -- Line: 290
    -- upvalues: u4 (ref), u8 (ref), ContextActionService (copy)
    if u4 then
        if u4.linearVelocity then
            u4.linearVelocity:Destroy();
            u4.linearVelocity = nil;
        end;

        if u4.pullAttachment then
            u4.pullAttachment:Destroy();
            u4.pullAttachment = nil;
        end;

        u4.pulling = false;
    end;

    if not u8 then
        return;
    end;

    u8 = false;
    ContextActionService:UnbindAction("GrapplingHookSink");
end;

local function finishLocalGrapple(p41) -- Line: 308
    -- upvalues: u4 (ref), u8 (ref), ContextActionService (copy), GrapplingHookFlags (copy), u5 (ref), Networking (copy)
    if not u4 or u4.finished then
        return;
    end;

    u4.finished = true;

    if u4 then
        if u4.linearVelocity then
            u4.linearVelocity:Destroy();
            u4.linearVelocity = nil;
        end;

        if u4.pullAttachment then
            u4.pullAttachment:Destroy();
            u4.pullAttachment = nil;
        end;

        u4.pulling = false;
    end;

    if u8 then
        u8 = false;
        ContextActionService:UnbindAction("GrapplingHookSink");
    end;

    local tool = u4.tool;

    if tool and tool.Parent then
        tool:SetAttribute("CooldownEnd", os.clock() + GrapplingHookFlags.Cooldown:Get());
    end;

    u5 = false;

    if p41 then
        Networking.GrapplingHook.ReportEnd:Fire();
    end;
end;

local function teardownHook(p42) -- Line: 329
    -- upvalues: u3 (copy), u4 (ref), u8 (ref), ContextActionService (copy), GrapplingHookFlags (copy), u5 (ref)
    local v43 = u3[p42];

    if not v43 then
        return;
    end;

    u3[p42] = nil;

    if v43 == u4 then
        if u4 and not u4.finished then
            u4.finished = true;

            if u4 then
                if u4.linearVelocity then
                    u4.linearVelocity:Destroy();
                    u4.linearVelocity = nil;
                end;

                if u4.pullAttachment then
                    u4.pullAttachment:Destroy();
                    u4.pullAttachment = nil;
                end;

                u4.pulling = false;
            end;

            if u8 then
                u8 = false;
                ContextActionService:UnbindAction("GrapplingHookSink");
            end;

            local tool = u4.tool;

            if tool and tool.Parent then
                tool:SetAttribute("CooldownEnd", os.clock() + GrapplingHookFlags.Cooldown:Get());
            end;

            u5 = false;
        end;

        u4 = nil;
    end;

    if v43.shootLoopSound then
        v43.shootLoopSound:Stop();
        v43.shootLoopSound:Destroy();
        v43.shootLoopSound = nil;
    end;

    if v43.reelSound then
        v43.reelSound:Stop();
        v43.reelSound = nil;
    end;

    if v43.tipModel then
        v43.tipModel:Destroy();
    end;

    if v43.anchorPart then
        v43.anchorPart:Destroy();
    end;

    if v43.hidden then
        for _, v in v43.hidden do
            if v and v.Parent then
                v.LocalTransparencyModifier = 0;
            end;
        end;
    end;
end;

local function startHook(p44, p45, p46, p47) -- Line: 362
    -- upvalues: u3 (copy), ReplicatedStorage (copy), getTipSpawnCFrame (copy), u7 (ref), u2 (copy), rotationBetween (copy), GrapplingHookFlags (copy), hideBuiltInTip (copy), LocalPlayer (copy), playWorldOneShot (copy), SoundService (copy), u4 (ref), u5 (ref)
    if u3[p44] then
        return;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("GearAssets");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("GrapplingHookTip");
    end;

    if not Assets then
        return;
    end;

    local v48 = getTipSpawnCFrame(p44);
    local GrapplingHookTip = p44:FindFirstChild("GrapplingHookTip");
    local v49;

    if GrapplingHookTip and GrapplingHookTip:IsA("PVInstance") then
        v49 = GrapplingHookTip:GetPivot();
    else
        v49 = nil;
    end;

    local v50 = v49 or (v48 or CFrame.new(p45));
    local Position = v50.Position;
    local v51 = Assets:Clone();

    for _, descendant in v51:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.Massless = true;
        end;
    end;

    local v52;

    if u7 and u7.Parent then
        v52 = u7;
    else
        v52 = Instance.new("Folder");
        v52.Name = "GrapplingHookVisuals";
        v52.Parent = workspace;
        u7 = v52;
    end;

    v51.Parent = v52;
    v51:PivotTo(v50);
    local LineAttachment = v51:FindFirstChild("LineAttachment", true);
    local Part = Instance.new("Part");
    Part.Name = "GrapplingHookRopeAnchor";
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.CFrame = v48 or CFrame.new(Position);
    local v53;

    if u7 and u7.Parent then
        v53 = u7;
    else
        v53 = Instance.new("Folder");
        v53.Name = "GrapplingHookVisuals";
        v53.Parent = workspace;
        u7 = v53;
    end;

    Part.Parent = v53;
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "RopeAttachment";
    Attachment.Parent = Part;
    local v54;

    if LineAttachment and LineAttachment:IsA("Attachment") then
        v54 = Instance.new("RopeConstraint");
        v54.Visible = true;
        v54.Color = u2;
        v54.Thickness = 0.06;
        v54.Attachment0 = LineAttachment;
        v54.Attachment1 = Attachment;
        v54.Length = (LineAttachment.WorldPosition - Attachment.WorldPosition).Magnitude;
        v54.Parent = Part;
    else
        v54 = nil;
    end;

    local v55 = p45 - Position;
    local Unit = (v55.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v55).Unit;
    local Rotation = v50.Rotation;

    if LineAttachment and LineAttachment:IsA("Attachment") then
        local v56 = v50:PointToObjectSpace(LineAttachment.WorldPosition);

        if v56.Magnitude > 0.001 then
            Rotation = rotationBetween(v50:VectorToWorldSpace(v56.Unit), Unit) * v50.Rotation;
        end;
    end;

    local v57 = v51.PrimaryPart or v51:FindFirstChildWhichIsA("BasePart", true);
    local v58 = {
        pulling = false,
        finished = false,
        impactPlayed = false,
        reelStarted = false,
        shootLoopSound = nil,
        reelSound = nil,
        tool = p44,
        targetPoint = p45,
        fireServerTime = p46
    };
    local v59 = (p45 - Position).Magnitude / GrapplingHookFlags.TipTravelSpeed:Get();
    v58.flightTime = math.max(v59, 0.0001);
    v58.startPos = Position;
    v58.flightRotation = Rotation;
    v58.tipModel = v51;
    v58.anchorPart = Part;
    v58.rope = v54;
    v58.lineAttachment = LineAttachment;
    v58.anchorAttachment = Attachment;
    v58.hidden = hideBuiltInTip(p44);
    v58.isLocal = p47 == LocalPlayer;
    u3[p44] = v58;
    playWorldOneShot("GrappleShoot", Position);

    if v57 then
        local SFX = SoundService:FindFirstChild("SFX");

        if SFX then
            SFX = SFX:FindFirstChild("GrapplingHook");
        end;

        if SFX then
            SFX = SFX:FindFirstChild("GrappleShootLoop");
        end;

        if not (SFX and SFX:IsA("Sound")) then
            SFX = nil;
        end;

        local v60;

        if SFX then
            v60 = SFX:Clone();
            v60.Looped = true;
            v60.RollOffMode = Enum.RollOffMode.InverseTapered;
            v60.RollOffMinDistance = 10;
            v60.RollOffMaxDistance = 150;
            v60.Parent = v57;
        else
            v60 = nil;
        end;

        if v60 then
            v60:Play();
            v58.shootLoopSound = v60;
        end;
    end;

    if v58.isLocal then
        u4 = v58;
        u5 = false;
    end;
end;

local function beginPull(p61) -- Line: 486
    -- upvalues: LocalPlayer (copy), finishLocalGrapple (copy), GrapplingHookFlags (copy), u8 (ref), ContextActionService (copy), sinkAction (copy)
    local Character = LocalPlayer.Character;
    local v62;

    if Character then
        v62 = Character:FindFirstChild("HumanoidRootPart");

        if not (v62 and v62:IsA("BasePart")) then
            v62 = nil;
        end;
    else
        v62 = nil;
    end;

    if not v62 then
        finishLocalGrapple(true);

        return;
    end;

    v62.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "GrapplingHookPull";
    Attachment.Parent = v62;
    local v63 = p61.targetPoint - v62.Position;
    local v64 = GrapplingHookFlags.PullSpeed:Get();
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
    LinearVelocity.MaxForce = (1 / 0);
    LinearVelocity.VectorVelocity = v63.Magnitude <= 0 and Vector3.new(0, 0, 0) or v63.Unit * v64;
    LinearVelocity.Parent = v62;
    p61.pullAttachment = Attachment;
    p61.linearVelocity = LinearVelocity;
    p61.pulling = true;
    p61.initialPullDistance = v63.Magnitude;
    p61.pullStartClock = os.clock();
    p61.progressDist = v63.Magnitude;
    p61.progressClock = os.clock();

    if u8 then
        return;
    end;

    u8 = true;
    ContextActionService:BindAction("GrapplingHookSink", sinkAction, false, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump);
end;

local function updatePull(p65) -- Line: 521
    -- upvalues: LocalPlayer (copy), finishLocalGrapple (copy), GrapplingHookFlags (copy)
    local Character = LocalPlayer.Character;
    local v66;

    if Character then
        v66 = Character:FindFirstChild("HumanoidRootPart");

        if not (v66 and v66:IsA("BasePart")) then
            v66 = nil;
        end;
    else
        v66 = nil;
    end;

    if not (v66 and p65.linearVelocity) then
        finishLocalGrapple(true);

        return;
    end;

    local v67 = p65.targetPoint - v66.Position;
    local Magnitude = v67.Magnitude;

    if Magnitude > 0 then
        p65.linearVelocity.VectorVelocity = v67.Unit * GrapplingHookFlags.PullSpeed:Get();
    end;

    if Magnitude <= GrapplingHookFlags.ReleaseDistance:Get() then
        finishLocalGrapple(true);

        return;
    end;

    if p65.progressDist - Magnitude >= GrapplingHookFlags.StuckMinProgress:Get() then
        p65.progressDist = Magnitude;
        p65.progressClock = os.clock();
    elseif os.clock() - p65.progressClock >= GrapplingHookFlags.StuckWindow:Get() then
        finishLocalGrapple(true);

        return;
    end;

    local v68 = p65.initialPullDistance / GrapplingHookFlags.PullSpeed:Get();

    if os.clock() - p65.pullStartClock > v68 + GrapplingHookFlags.TimeoutBuffer:Get() then
        finishLocalGrapple(true);
    end;
end;

local function onRender() -- Line: 560
    -- upvalues: u3 (copy), teardownHook (copy), getTipSpawnCFrame (copy), playWorldOneShot (copy), GrapplingHookFlags (copy), SoundService (copy), u4 (ref), beginPull (copy), updatePull (copy)
    local v69 = workspace:GetServerTimeNow();

    for i, v in u3 do
        if i.Parent then
            local v70 = getTipSpawnCFrame(i);

            if v70 then
                local v71 = v69 - v.fireServerTime;
                local v72;

                if v71 < v.flightTime then
                    v72 = v.startPos:Lerp(v.targetPoint, v71 / v.flightTime);
                else
                    v72 = v.targetPoint;

                    if not v.impactPlayed then
                        v.impactPlayed = true;

                        if v.shootLoopSound then
                            v.shootLoopSound:Stop();
                            v.shootLoopSound:Destroy();
                            v.shootLoopSound = nil;
                        end;

                        playWorldOneShot("GrappleImpact", v.targetPoint);
                    end;
                end;

                v.tipModel:PivotTo(CFrame.new(v72) * v.flightRotation);
                v.anchorPart.CFrame = v70;

                if v.rope and v.lineAttachment then
                    v.rope.Length = (v.lineAttachment.WorldPosition - v.anchorAttachment.WorldPosition).Magnitude;
                end;

                if not v.reelStarted and v.fireServerTime + v.flightTime + GrapplingHookFlags.PullStartDelay:Get() <= v69 then
                    v.reelStarted = true;
                    local anchorPart = v.anchorPart;
                    local SFX = SoundService:FindFirstChild("SFX");

                    if SFX then
                        SFX = SFX:FindFirstChild("GrapplingHook");
                    end;

                    if SFX then
                        SFX = SFX:FindFirstChild("GrappleReelLoop");
                    end;

                    if not (SFX and SFX:IsA("Sound")) then
                        SFX = nil;
                    end;

                    local v73;

                    if SFX then
                        v73 = SFX:Clone();
                        v73.Looped = true;
                        v73.RollOffMode = Enum.RollOffMode.InverseTapered;
                        v73.RollOffMinDistance = 10;
                        v73.RollOffMaxDistance = 150;
                        v73.Parent = anchorPart;
                    else
                        v73 = nil;
                    end;

                    if v73 then
                        v73:Play();
                        v.reelSound = v73;
                    end;
                end;

                if v == u4 and (not v.finished and v.fireServerTime + v.flightTime + GrapplingHookFlags.PullStartDelay:Get() <= v69) then
                    if v.pulling then
                        updatePull(v);
                    else
                        beginPull(v);
                    end;
                end;
            else
                teardownHook(i);
            end;
        else
            teardownHook(i);
        end;
    end;
end;

function v1.OnToolActivated(p74, p75) -- Line: 633
    -- upvalues: LocalPlayer (copy), u4 (ref), u5 (ref), raycastSurface (copy), NotificationController (copy), GrapplingHookFlags (copy), Networking (copy)
    local Character = LocalPlayer.Character;

    if not Character or p75.Parent ~= Character then
        return;
    end;

    local v76 = p75:GetAttribute("CooldownEnd");

    if typeof(v76) == "number" and os.clock() < v76 then
        return;
    end;

    if u4 or u5 then
        return;
    end;

    if Character:GetAttribute("Ragdolled") then
        return;
    end;

    if LocalPlayer:GetAttribute("IsStealingFruit") then
        return;
    end;

    local v77 = raycastSurface(Character);

    if not v77 then
        NotificationController:CreateNotification("You cannot grapple that far away!");

        return;
    end;

    local v78;

    if Character then
        v78 = Character:FindFirstChild("HumanoidRootPart");

        if not (v78 and v78:IsA("BasePart")) then
            v78 = nil;
        end;
    else
        v78 = nil;
    end;

    if not v78 then
        return;
    end;

    if (v77 - v78.Position).Magnitude > GrapplingHookFlags.ClientMaxDistance:Get() then
        NotificationController:CreateNotification("You cannot grapple that far away!");

        return;
    end;

    u5 = true;
    task.delay(2, function() -- Line: 659
        -- upvalues: u5 (ref), u4 (ref)
        if u5 and not u4 then
            u5 = false;
        end;
    end);
    Networking.GrapplingHook.Fire:Fire(v77, p75);
end;

function v1.OnEquipped(p79, p80) -- Line: 671
    -- upvalues: u6 (ref)
    u6 = p80;
end;

function v1.OnUnequipped(p81, p82) -- Line: 675
    -- upvalues: u6 (ref), u4 (ref), finishLocalGrapple (copy)
    if u6 == p82 then
        u6 = nil;
    end;

    if u4 and u4.tool == p82 then
        finishLocalGrapple(true);
    end;
end;

function v1.SetupCharacter(u83, p84) -- Line: 685
    -- upvalues: u9 (copy)
    local function tryConnect(u85) -- Line: 686
        -- upvalues: u9 (ref), u83 (copy)
        if u85:IsA("Tool") and u85:GetAttribute("GrapplingHook") then
            table.insert(u9, u85.Activated:Connect(function() -- Line: 688
                -- upvalues: u83 (ref), u85 (copy)
                u83:OnToolActivated(u85);
            end));
            table.insert(u9, u85.Equipped:Connect(function() -- Line: 691
                -- upvalues: u83 (ref), u85 (copy)
                u83:OnEquipped(u85);
            end));
            table.insert(u9, u85.Unequipped:Connect(function() -- Line: 694
                -- upvalues: u83 (ref), u85 (copy)
                u83:OnUnequipped(u85);
            end));
        end;
    end;

    table.insert(u9, p84.ChildAdded:Connect(tryConnect));

    for _, child in p84:GetChildren() do
        tryConnect(child);
    end;
end;

function v1.Init(p86) -- Line: 709
end;

function v1.Start(u87) -- Line: 712
    -- upvalues: u7 (ref), RunService (copy), onRender (copy), Networking (copy), Players (copy), startHook (copy), teardownHook (copy), u4 (ref), u8 (ref), ContextActionService (copy), u5 (ref), u9 (copy), LocalPlayer (copy)
    if not (u7 and u7.Parent) then
        local Folder = Instance.new("Folder");
        Folder.Name = "GrapplingHookVisuals";
        Folder.Parent = workspace;
        u7 = Folder;
    end;

    RunService:BindToRenderStep("GrapplingHookRender", Enum.RenderPriority.Camera.Value - 1, onRender);
    Networking.GrapplingHook.Started.OnClientEvent:Connect(function(p88, p89, p90) -- Line: 717
        -- upvalues: Players (ref), startHook (ref)
        if not (p88 and p88:IsA("Tool")) then
            return;
        end;

        if typeof(p89) ~= "Vector3" or typeof(p90) ~= "number" then
            return;
        end;

        local Parent = p88.Parent;
        local v91;

        if Parent and Parent:IsA("Model") then
            v91 = Players:GetPlayerFromCharacter(Parent);
        else
            v91 = nil;
        end;

        startHook(p88, p89, p90, v91);
    end);
    Networking.GrapplingHook.Ended.OnClientEvent:Connect(function(p92) -- Line: 725
        -- upvalues: teardownHook (ref)
        if not (p92 and p92:IsA("Tool")) then
            return;
        end;

        teardownHook(p92);
    end);

    local function onCharacter(p93) -- Line: 730
        -- upvalues: u4 (ref), u8 (ref), ContextActionService (ref), teardownHook (ref), u5 (ref), u9 (ref), u87 (copy)
        if u4 then
            if u4.linearVelocity then
                u4.linearVelocity:Destroy();
                u4.linearVelocity = nil;
            end;

            if u4.pullAttachment then
                u4.pullAttachment:Destroy();
                u4.pullAttachment = nil;
            end;

            u4.pulling = false;
        end;

        if u8 then
            u8 = false;
            ContextActionService:UnbindAction("GrapplingHookSink");
        end;

        if u4 then
            teardownHook(u4.tool);
        end;

        u4 = nil;
        u5 = false;

        for _, v in u9 do
            v:Disconnect();
        end;

        table.clear(u9);
        u87:SetupCharacter(p93);
    end;

    if LocalPlayer.Character then
        u87:SetupCharacter(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(onCharacter);
end;

return v1;