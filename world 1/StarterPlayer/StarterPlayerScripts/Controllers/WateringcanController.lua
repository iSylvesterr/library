-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local WateringcanData = require(ReplicatedStorage.SharedModules.WateringcanData);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CutsceneGate = require(ReplicatedStorage.ClientModules.CutsceneGate);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Water = game.SoundService.SFX.Water;
local Temporary = workspace.Temporary;
local Baseplate = workspace:WaitForChild("Baseplate");
local u2 = Color3.fromRGB(100, 175, 255);
local u3 = Color3.fromRGB(255, 100, 100);
local u4 = 0;
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://75347951865143";
local u5 = nil;
local u6 = nil;
local u7 = false;
local u8 = nil;
local u9 = Color3.fromRGB(100, 175, 255);
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = {};

local function debugPrint(...) -- Line: 77
end;

local function debugWarn(...) -- Line: 83
end;

function v1.Init(p15) -- Line: 93
    -- upvalues: WateringcanData (copy), u14 (copy), debugPrint (copy)
    for _, v in WateringcanData do
        u14[v.Name] = v;
    end;

    debugPrint("Init complete. Loaded", #WateringcanData, "watering can definitions");
end;

function v1.Start(u16) -- Line: 100
    -- upvalues: debugPrint (copy), UserInputService (copy), CutsceneGate (copy), LocalPlayer (copy), Networking (copy)
    debugPrint("Start. TouchEnabled =", UserInputService.TouchEnabled, "| MouseEnabled =", UserInputService.MouseEnabled);
    UserInputService.InputBegan:Connect(function(p17, p18) -- Line: 104
        -- upvalues: u16 (copy)
        u16:OnInputBegan(p17, p18);
    end);
    UserInputService.InputEnded:Connect(function(p19, p20) -- Line: 108
        -- upvalues: u16 (copy)
        u16:OnInputEnded(p19);
    end);
    UserInputService.TouchTapInWorld:Connect(function(p21, p22) -- Line: 115
        -- upvalues: debugPrint (ref), CutsceneGate (ref), u16 (copy)
        if p22 then
            debugPrint("TouchTapInWorld ignored (processed by UI)");

            return;
        end;

        if CutsceneGate.IsActive() then
            return;
        end;

        local v23 = u16:GetEquippedTool();

        if not (v23 and v23:GetAttribute("WateringCan")) then
            debugPrint("TouchTapInWorld ignored (no watering can equipped)");

            return;
        end;

        debugPrint(("TouchTapInWorld at screen (%.0f, %.0f)"):format(p21.X, p21.Y));
        u16:TryWater(p21);
    end);
    local Character = LocalPlayer.Character;

    if Character then
        u16:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p24) -- Line: 136
        -- upvalues: u16 (copy)
        u16:SetupCharacter(p24);
    end);
    Networking.WateringCan.WateringCanFx.OnClientEvent:Connect(function(p25, p26, p27) -- Line: 140
        -- upvalues: debugPrint (ref), u16 (copy)
        debugPrint("FX event received:", p26, "at", p25, "from", p27 and (p27.Name or "nil") or "nil");
        u16:PlayWateringEffect(p25, p26);
        u16:PlayWaterStream(p27, p25, p26);
    end);
    Networking.WateringCan.SwanSpitFx.OnClientEvent:Connect(function(p28, p29, p30, p31) -- Line: 148
        -- upvalues: u16 (copy)
        u16:PlayWateringEffectAt(p28, p29, p30, false);
    end);
end;

function v1.PlayWateringEffect(p32, p33, p34) -- Line: 157
    -- upvalues: u14 (copy), debugWarn (copy)
    local v35 = u14[p34];
    local v36 = v35 and (v35.SplashRadius or 8) or 8;
    local v37 = v35 and (v35.EffectTime or 10) or 10;

    if not v35 then
        debugWarn("PlayWateringEffect: unknown can name \'" .. tostring(p34) .. "\', using defaults");
    end;

    local v38;

    if v35 == nil then
        v38 = false;
    else
        v38 = v35.SuperTier == true;
    end;

    p32:PlayWateringEffectAt(p33, v36, v37, v38);
end;

function v1.PlayWateringEffectAt(p39, p40, p41, u42, p43) -- Line: 172
    -- upvalues: u9 (copy), RunService (copy), Temporary (copy), Water (copy), TweenService (copy), Debris (copy), debugPrint (copy)
    local v44 = Vector3.new(0.15, p41, p41);
    local v45 = Vector3.new(0.15, p41 * 2, p41 * 2);
    local u46 = game.ReplicatedStorage.Assets.Stud_Part:Clone();
    u46.BackSurface = Enum.SurfaceType.Studs;
    u46.TopSurface = Enum.SurfaceType.Studs;
    u46.LeftSurface = Enum.SurfaceType.Studs;
    u46.RightSurface = Enum.SurfaceType.Studs;
    u46.FrontSurface = Enum.SurfaceType.Studs;
    u46.BottomSurface = Enum.SurfaceType.Studs;
    u46.Material = Enum.Material.Glacier;
    u46.MaterialVariant = "2022 Weld";
    u46.Name = "WateringCanFx";
    u46.Shape = Enum.PartType.Cylinder;
    u46.Size = v44;
    u46.CFrame = CFrame.new(p40 + Vector3.new(0, 0.075, 0)) * CFrame.Angles(0, 0, 1.5707963267948966);
    u46.Transparency = 1;
    u46.Color = u9;
    local u47;

    if p43 then
        u47 = RunService.RenderStepped:Connect(function() -- Line: 198
            -- upvalues: u46 (copy)
            if u46 and u46.Parent then
                u46.Color = Color3.fromHSV(os.clock() * 0.5 % 1, 1, 1);
            end;
        end);
    else
        u47 = nil;
    end;

    u46.CanCollide = false;
    u46.CanQuery = false;
    u46.CanTouch = false;
    u46.Anchored = true;
    u46.CastShadow = false;
    u46.Parent = Temporary;
    local u48 = Water:Clone();
    u48.Name = "WateringCanSFX";
    u48.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    u48.RollOffMode = Enum.RollOffMode.InverseTapered;
    u48.RollOffMinDistance = 10;
    u48.RollOffMaxDistance = 80;
    u48.Parent = u46;
    u48:Play();
    u48.Ended:Once(function() -- Line: 220
        -- upvalues: u48 (copy)
        u48:Destroy();
    end);
    local v49 = TweenService:Create(u46, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0.5,
        Size = v45
    });
    local v50 = Vector3.new(0.15, p41 * 2 * 0.6, p41 * 2 * 0.6);
    local u51 = TweenService:Create(u46, TweenInfo.new(u42, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Transparency = 0.8,
        Size = v50
    });
    local u52 = TweenService:Create(u46, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    });
    v49:Play();
    Debris:AddItem(v49, 1.3);
    task.delay(0.3, function() -- Line: 248
        -- upvalues: u46 (copy), u51 (copy), Debris (ref), u42 (copy)
        if u46 and u46.Parent then
            u51:Play();
            Debris:AddItem(u51, u42 + 1);
        end;
    end);
    task.delay(u42 + 0.3, function() -- Line: 255
        -- upvalues: u46 (copy), u52 (copy), Debris (ref)
        if u46 and u46.Parent then
            u52:Play();
            Debris:AddItem(u52, 1.2);
        end;
    end);
    task.delay(u42 + 0.3 + 0.2, function() -- Line: 262
        -- upvalues: u47 (ref), u46 (copy), debugPrint (ref)
        if u47 then
            u47:Disconnect();
            u47 = nil;
        end;

        if u46 and u46.Parent then
            u46:Destroy();
        end;

        debugPrint("Puddle FX cleaned up");
    end);
end;

Color3.fromRGB(100, 175, 255);

function v1.PlayWaterStream(p53, p54, u55, p56) -- Line: 281
    -- upvalues: debugWarn (copy), u14 (copy), Temporary (copy), RunService (copy), TweenService (copy), Debris (copy)
    if not p54 then
        return;
    end;

    local Character = p54.Character;

    if not Character then
        debugWarn("PlayWaterStream: no character for", p54.Name);

        return;
    end;

    local u57 = u14[p56];
    local u58 = u57 and (u57.SplashRadius or 8) or 8;
    local v59 = Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand");
    local u60;

    if v59 and v59:IsA("BasePart") then
        u60 = (v59.CFrame * CFrame.new(0, -v59.Size.Y / 2 - 2, 0.65)).Position;
    else
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            debugWarn("PlayWaterStream: no arm or HumanoidRootPart found");

            return;
        end;

        u60 = HumanoidRootPart.Position + Vector3.new(0, 1, 0);
    end;

    task.spawn(function() -- Line: 308
        -- upvalues: u57 (copy), u58 (copy), u55 (copy), Temporary (ref), RunService (ref), u60 (ref), TweenService (ref), Debris (ref)
        local u61 = {};
        local u62 = {};
        local u63 = {};
        local u64;

        if u57 == nil then
            u64 = false;
        else
            u64 = u57.SuperTier == true;
        end;

        for _ = 1, 12 do
            local v65 = math.random() * 3.141592653589793 * 2;
            local v66 = math.random() * u58;
            local v67 = math.cos(v65) * v66;
            local v68 = math.sin(v65) * v66;
            local v69 = u55 + Vector3.new(v67, -3, v68);
            local Angles = CFrame.Angles;
            local v70 = math.random(0, 360);
            local v71 = math.rad(v70);
            local v72 = math.random(0, 360);
            local v73 = math.rad(v72);
            local v74 = math.random(0, 360);
            local v75 = Angles(v71, v73, (math.rad(v74)));
            local v76 = game.ReplicatedStorage.Assets.Stud_Part:Clone();
            v76.BackSurface = Enum.SurfaceType.Studs;
            v76.TopSurface = Enum.SurfaceType.Studs;
            v76.LeftSurface = Enum.SurfaceType.Studs;
            v76.RightSurface = Enum.SurfaceType.Studs;
            v76.FrontSurface = Enum.SurfaceType.Studs;
            v76.BottomSurface = Enum.SurfaceType.Studs;
            v76.Material = Enum.Material.Glacier;
            v76.MaterialVariant = "2022 Weld";
            v76.Color = u64 and Color3.fromHSV(v76.Position.Y % 6 / 6, 1, 1) or Color3.new(0, 0.666667, 1);
            v76.Size = Vector3.new(1, 1, 1);
            v76.Transparency = 0.3;
            v76.Anchored = true;
            v76.CanCollide = false;
            v76.CanQuery = false;
            v76.CanTouch = false;
            v76.CastShadow = false;
            v76.Parent = Temporary;
            table.insert(u61, v76);
            table.insert(u62, v69);
            table.insert(u63, v75);
        end;

        local u77 = 0;
        local u78 = nil;
        u78 = RunService.RenderStepped:Connect(function(p79) -- Line: 360
            -- upvalues: u77 (ref), u61 (copy), u62 (copy), u60 (ref), u63 (copy), u64 (copy), u78 (ref), TweenService (ref), Debris (ref)
            u77 = u77 + p79;
            local v80 = true;

            for i, v in u61 do
                local v81 = u62[i];
                local v82 = math.clamp(u77 / 0.4 - (i - 1) / 12 * 0.6, 0, 1);

                if v82 < 1 then
                    v80 = false;
                end;

                v.CFrame = CFrame.new((1 - v82) * (1 - v82) * u60 + (1 - v82) * 2 * v82 * ((u60 + v81) / 2 + Vector3.new(0, 8, 0)) + v82 * v82 * v81) * u63[i];
                v.Transparency = v82 * 0.4 + 0.3;

                if u64 then
                    v.Color = Color3.fromHSV(v.Position.Y % 6 / 6, 1, 1);
                end;

                v.Size = Vector3.new(1, 1, 1) * (1 - v82 * 0.5);
            end;

            if v80 then
                u78:Disconnect();
                local v83 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

                for _, v in u61 do
                    local v84 = TweenService:Create(v, v83, {
                        Transparency = 1,
                        Size = Vector3.new(0.1, 0.1, 0.1)
                    });
                    v84:Play();
                    Debris:AddItem(v84, v83.Time);
                end;

                task.delay(0.35, function() -- Line: 401
                    -- upvalues: u61 (ref)
                    for _, v in u61 do
                        v:Destroy();
                    end;
                end);
            end;
        end);
    end);
end;

function v1.LoadUseTrack(p85, p86) -- Line: 413
    -- upvalues: Animation (copy), u5 (ref)
    local v87 = p86:FindFirstChildOfClass("Humanoid");

    if not v87 then
        return;
    end;

    local v88 = v87:FindFirstChildOfClass("Animator");

    if not v88 then
        return;
    end;

    local v89 = v88:LoadAnimation(Animation);
    v89.Priority = Enum.AnimationPriority.Action;
    v89.Looped = false;
    u5 = v89;
end;

function v1.ClearUseTrack(p90) -- Line: 426
    -- upvalues: u5 (ref)
    if u5 then
        u5:Stop(0);
        u5 = nil;
    end;
end;

function v1.SetupCharacter(u91, u92) -- Line: 433
    -- upvalues: debugPrint (copy)
    debugPrint("SetupCharacter for", u92.Name);
    u92.ChildAdded:Connect(function(p93) -- Line: 436
        -- upvalues: debugPrint (ref), u91 (copy), u92 (copy)
        if p93:IsA("Tool") and p93:GetAttribute("WateringCan") then
            debugPrint("Watering can equipped:", p93:GetAttribute("WateringCan"));
            u91:CreatePreview(p93:GetAttribute("WateringCan"));
            u91:LoadUseTrack(u92);
        end;
    end);
    u92.ChildRemoved:Connect(function(p94) -- Line: 444
        -- upvalues: debugPrint (ref), u91 (copy)
        if p94:IsA("Tool") and p94:GetAttribute("WateringCan") then
            debugPrint("Watering can unequipped:", p94:GetAttribute("WateringCan"));
            u91:DestroyPreview();
            u91:StopHold();
            u91:ClearUseTrack();
        end;
    end);

    for _, child in u92:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("WateringCan") then
            u91:CreatePreview(child:GetAttribute("WateringCan"));
            u91:LoadUseTrack(u92);
        end;
    end;
end;

function v1.IsTouchInput(p95) -- Line: 461
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled;
end;

function v1.GetFacingTargetPosition(p96) -- Line: 465
    -- upvalues: LocalPlayer (copy), CurrentCamera (copy), UserInputService (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    if p96:IsUsingGamepad() then
        local LookVector = CurrentCamera.CFrame.LookVector;
        local v97 = Vector3.new(LookVector.X, 0, LookVector.Z);

        if v97.Magnitude < 0.001 then
            return nil;
        end;

        return HumanoidRootPart.Position + v97.Unit * 10;
    end;

    if p96:IsTouchInput() then
        return nil;
    end;

    local v98 = UserInputService:GetMouseLocation();
    local v99 = CurrentCamera:ViewportPointToRay(v98.X, v98.Y);
    local Origin = v99.Origin;
    local Direction = v99.Direction;

    if math.abs(Direction.Y) < 0.001 then
        return nil;
    end;

    local v100 = (HumanoidRootPart.Position.Y - Origin.Y) / Direction.Y;

    if v100 < 0 then
        return nil;
    end;

    return Origin + Direction * v100;
end;

function v1.UpdateFacing(p101) -- Line: 493
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v102 = Character:FindFirstChildOfClass("Humanoid");

    if not (HumanoidRootPart and (HumanoidRootPart:IsA("BasePart") and v102)) then
        return;
    end;

    if v102.Health <= 0 then
        return;
    end;

    if v102.Sit then
        return;
    end;

    local v103 = p101:GetFacingTargetPosition();

    if not v103 then
        v102.AutoRotate = true;

        return;
    end;

    local v104 = Vector3.new(v103.X, HumanoidRootPart.Position.Y, v103.Z);

    if (v104 - HumanoidRootPart.Position).Magnitude < 0.1 then
        v102.AutoRotate = true;

        return;
    end;

    v102.AutoRotate = false;
    HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, v104);
end;

function v1.EnableCharacterFacing(u105) -- Line: 520
    -- upvalues: u13 (ref), RunService (copy)
    u105:DisableCharacterFacing();
    u13 = RunService.RenderStepped:Connect(function() -- Line: 523
        -- upvalues: u105 (copy)
        u105:UpdateFacing();
    end);
end;

function v1.DisableCharacterFacing(p106) -- Line: 528
    -- upvalues: u13 (ref), LocalPlayer (copy)
    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    local Character = LocalPlayer.Character;
    local v107 = Character and Character:FindFirstChildOfClass("Humanoid");

    if v107 then
        v107.AutoRotate = true;
    end;
end;

function v1.CreatePreview(u108, p109) -- Line: 543
    -- upvalues: debugPrint (copy), u12 (ref), u14 (copy), debugWarn (copy), u10 (ref), u2 (copy), Temporary (copy), u11 (ref), RunService (copy)
    u108:DestroyPreview();
    debugPrint("CreatePreview for", p109);
    u12 = u14[p109];

    if not u12 then
        debugWarn("CreatePreview: no data found for \'" .. tostring(p109) .. "\', using default radius");
    end;

    if u108:IsTouchInput() then
        debugPrint("CreatePreview skipped (mobile) - no preview, no facing");

        return;
    end;

    local v110 = u12 and u12.SplashRadius or 8;
    u10 = game.ReplicatedStorage.Assets.Stud_Part:Clone();
    u10.BackSurface = Enum.SurfaceType.Studs;
    u10.TopSurface = Enum.SurfaceType.Studs;
    u10.LeftSurface = Enum.SurfaceType.Studs;
    u10.RightSurface = Enum.SurfaceType.Studs;
    u10.FrontSurface = Enum.SurfaceType.Studs;
    u10.BottomSurface = Enum.SurfaceType.Studs;
    u10.Material = Enum.Material.Glacier;
    u10.MaterialVariant = "2022 Weld";
    u10.Name = "WateringCanPreview";
    u10.Shape = Enum.PartType.Cylinder;
    u10.Size = Vector3.new(0.15, v110 * 2, v110 * 2);
    u10.CFrame = CFrame.Angles(0, 0, 1.5707963267948966);
    u10.Transparency = 0.6;
    u10.Color = u2;
    u10.CanCollide = false;
    u10.CanQuery = false;
    u10.CanTouch = false;
    u10.Anchored = true;
    u10.CastShadow = false;
    u10.Parent = Temporary;
    u11 = RunService.RenderStepped:Connect(function() -- Line: 588
        -- upvalues: u108 (copy)
        u108:UpdatePreview();
    end);
    u108:EnableCharacterFacing();
end;

function v1.DestroyPreview(p111) -- Line: 595
    -- upvalues: u10 (ref), debugPrint (copy), u11 (ref), u12 (ref)
    if u10 then
        debugPrint("DestroyPreview");
        u10:Destroy();
        u10 = nil;
    end;

    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    u12 = nil;
    p111:DisableCharacterFacing();
end;

function v1.SetPreviewColor(p112, p113) -- Line: 612
    -- upvalues: u10 (ref), u2 (copy), u3 (copy)
    if not u10 then
        return;
    end;

    u10.Color = p113 and u2 or u3;
end;

function v1.IsUsingGamepad(p114) -- Line: 621
    -- upvalues: UserInputService (copy)
    local v115 = UserInputService:GetLastInputType();

    return (v115 == Enum.UserInputType.Gamepad1 or (v115 == Enum.UserInputType.Gamepad2 or v115 == Enum.UserInputType.Gamepad3)) and true or v115 == Enum.UserInputType.Gamepad4;
end;

function v1.GetGamepadPlacementRay(p116) -- Line: 629
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 8 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0);
    end;

    return nil;
end;

function v1.CreateRaycastParams(p117) -- Line: 644
    -- upvalues: CollectionService (copy), Baseplate (copy)
    local v118 = RaycastParams.new();
    v118.FilterType = Enum.RaycastFilterType.Include;
    local v119 = CollectionService:GetTagged("PlantArea");
    table.insert(v119, Baseplate);
    v118.FilterDescendantsInstances = v119;

    return v118;
end;

function v1.IsValidPlacement(p120, p121) -- Line: 655
    -- upvalues: CollectionService (copy)
    return CollectionService:HasTag(p121, "PlantArea");
end;

function v1.UpdatePreview(p122) -- Line: 659
    -- upvalues: u10 (ref), UserInputService (copy), CurrentCamera (copy), Temporary (copy), u12 (ref)
    if not u10 then
        return;
    end;

    local v123 = p122:CreateRaycastParams();
    local v124;

    if p122:IsUsingGamepad() then
        local v125, v126 = p122:GetGamepadPlacementRay();

        if not v125 then
            u10.Parent = nil;

            return;
        end;

        v124 = workspace:Raycast(v125, v126, v123);
    else
        local v127 = UserInputService:GetMouseLocation();
        local v128 = CurrentCamera:ViewportPointToRay(v127.X, v127.Y);
        v124 = workspace:Raycast(v128.Origin, v128.Direction * 5000, v123);
    end;

    if not v124 then
        u10.Parent = nil;

        return;
    end;

    u10.Parent = Temporary;
    local Position = v124.Position;
    local v129 = p122:IsValidPlacement(v124.Instance);
    u10.CFrame = CFrame.new(Position + Vector3.new(0, -0.225, 0)) * CFrame.Angles(0, 0, 1.5707963267948966);

    if v129 and (u12 and u12.SuperTier) then
        u10.Color = Color3.fromHSV(os.clock() * 0.5 % 1, 1, 1);

        return;
    end;

    p122:SetPreviewColor(v129);
end;

function v1.GetEquippedTool(p130) -- Line: 698
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChildWhichIsA("Tool");
    end;

    return nil;
end;

function v1.IsValidWateringInput(p131, p132) -- Line: 707
    return p132.UserInputType == Enum.UserInputType.MouseButton1 and true or p132.KeyCode == Enum.KeyCode.ButtonR2;
end;

function v1.TryWater(p133, p134) -- Line: 720
    -- upvalues: u4 (ref), debugPrint (copy), UserInputService (copy), CurrentCamera (copy), Networking (copy), u5 (ref)
    local v135 = os.clock();

    if v135 - u4 < 0.5 then
        debugPrint(("TryWater blocked: cooldown (%.2fs remaining)"):format(0.5 - (v135 - u4)));

        return false;
    end;

    local v136 = p133:GetEquippedTool();

    if not v136 then
        debugPrint("TryWater blocked: no tool equipped");

        return false;
    end;

    local v137 = v136:GetAttribute("WateringCan");

    if not v137 then
        debugPrint("TryWater blocked: equipped tool is not a watering can");

        return false;
    end;

    local v138 = p133:CreateRaycastParams();
    local v139;

    if p133:IsUsingGamepad() then
        local v140, v141 = p133:GetGamepadPlacementRay();

        if not v140 then
            debugPrint("TryWater blocked: gamepad ray unavailable (no character?)");

            return false;
        end;

        v139 = workspace:Raycast(v140, v141, v138);
    else
        local v142 = p134 or UserInputService:GetMouseLocation();
        local v143 = CurrentCamera:ViewportPointToRay(v142.X, v142.Y);
        v139 = workspace:Raycast(v143.Origin, v143.Direction * 5000, v138);
    end;

    if not v139 then
        debugPrint("TryWater blocked: raycast hit nothing");

        return false;
    end;

    if not p133:IsValidPlacement(v139.Instance) then
        debugPrint("TryWater blocked: hit", v139.Instance:GetFullName(), "(not tagged \'PlantArea\')");

        return false;
    end;

    u4 = v135;
    debugPrint(("Watering with \'%s\' at (%.1f, %.1f, %.1f)"):format(v137, v139.Position.X, v139.Position.Y, v139.Position.Z));
    Networking.WateringCan.UseWateringCan:Fire(v139.Position - Vector3.new(0, 0.3, 0), v137, v136);

    if u5 then
        u5:Stop(0);
        u5:Play(0.1);
    end;

    return true;
end;

function v1.StopHold(p144) -- Line: 782
    -- upvalues: u7 (ref), debugPrint (copy), u6 (ref), u8 (ref)
    if u7 then
        debugPrint("Hold stopped");
    end;

    u7 = false;
    u6 = nil;

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;
end;

function v1.OnInputBegan(u145, p146, p147) -- Line: 794
    -- upvalues: CutsceneGate (copy), debugPrint (copy), u6 (ref), u7 (ref), u8 (ref), RunService (copy)
    if p147 then
        return;
    end;

    if CutsceneGate.IsActive() then
        return;
    end;

    if not u145:IsValidWateringInput(p146) then
        return;
    end;

    debugPrint("InputBegan:", p146.UserInputType.Name, p146.KeyCode == Enum.KeyCode.Unknown and "" or (p146.KeyCode.Name or ""));
    u145:TryWater();
    u6 = os.clock();
    u7 = true;

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    local u148 = u6;
    u8 = RunService.Heartbeat:Connect(function() -- Line: 817
        -- upvalues: u7 (ref), u6 (ref), u148 (copy), u145 (copy), debugPrint (ref)
        if not u7 or u6 ~= u148 then
            u145:StopHold();

            return;
        end;

        local v149 = u145:GetEquippedTool();

        if v149 and v149:GetAttribute("WateringCan") then
            if os.clock() - u6 < 1 then
                return;
            end;

            u145:TryWater();

            return;
        end;

        debugPrint("Hold cancelled: tool unequipped mid-hold");
        u145:StopHold();
    end);
end;

function v1.OnInputEnded(p150, p151) -- Line: 839
    if not p150:IsValidWateringInput(p151) then
        return;
    end;

    p150:StopHold();
end;

return v1;