-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local Rakes = ReplicatedStorage.Assets.Rakes;
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local RakeData = require(ReplicatedStorage.SharedModules.RakeData);
require(ReplicatedStorage.ClientModules.PlacementGrid);
local CutsceneGate = require(ReplicatedStorage.ClientModules.CutsceneGate);
local RadiusPreviewHeight = require(ReplicatedStorage.ClientModules.RadiusPreviewHeight);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local CurrentCamera = workspace.CurrentCamera;
local Gardens = workspace:WaitForChild("Gardens");
local Assets = ReplicatedStorage.Assets;
local Temporary = workspace.Temporary;

local function debugPrint(...) -- Line: 37
end;

local u2 = 0;
local u3 = Color3.fromRGB(100, 255, 100);
local u4 = Color3.fromRGB(255, 100, 100);
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = 0;
local u12 = false;
local u13 = nil;
local u14 = {};
local u15 = {};
local u16 = nil;
local u17 = nil;

function v1.Init(p18) -- Line: 84
    -- upvalues: RakeData (copy), u10 (copy)
    for _, v in RakeData do
        u10[v.RakeName] = v;
    end;
end;

function v1.Start(u19) -- Line: 90
    -- upvalues: u16 (ref), PlayerGui (copy), u17 (ref), u12 (ref), u11 (ref), debugPrint (copy), UserInputService (copy), LocalPlayer (copy)
    u16 = PlayerGui:WaitForChild("RakeUI");
    u17 = u16:WaitForChild("Rotate");
    u17.Visible = false;
    u17.Activated:Connect(function() -- Line: 95
        -- upvalues: u12 (ref), u11 (ref), debugPrint (ref)
        if u12 then
            u11 = (u11 + 15) % 360;
            debugPrint("UI Rotate pressed, placingRotation =", u11);
        end;
    end);
    UserInputService.InputBegan:Connect(function(p20, p21) -- Line: 102
        -- upvalues: u19 (copy)
        u19:OnInput(p20, p21);
    end);
    UserInputService.InputEnded:Connect(function(p22, p23) -- Line: 106
        -- upvalues: u19 (copy)
        if p22.KeyCode == Enum.KeyCode.R or p22.KeyCode == Enum.KeyCode.ButtonR1 then
            u19:StopRotateHold();
        end;
    end);
    local Character = LocalPlayer.Character;

    if Character then
        u19:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p24) -- Line: 116
        -- upvalues: u19 (copy)
        u19:SetupCharacter(p24);
    end);
    u19:SetupRakeTouchDetection();
end;

function v1.StartRotateHold(p25) -- Line: 126
    -- upvalues: u13 (ref), u11 (ref)
    p25:StopRotateHold();
    u13 = task.spawn(function() -- Line: 128
        -- upvalues: u11 (ref)
        task.wait(1);

        while true do
            u11 = (u11 + 15) % 360;
            task.wait(0.08);
        end;
    end);
end;

function v1.StopRotateHold(p26) -- Line: 137
    -- upvalues: u13 (ref)
    if u13 then
        task.cancel(u13);
        u13 = nil;
    end;
end;

function v1.SetupCharacter(u27, p28) -- Line: 147
    p28.ChildAdded:Connect(function(p29) -- Line: 148
        -- upvalues: u27 (copy)
        if p29:IsA("Tool") and p29:GetAttribute("Rake") then
            u27:EnterPlacingMode(p29:GetAttribute("Rake"));
        end;
    end);
    p28.ChildRemoved:Connect(function(p30) -- Line: 154
        -- upvalues: u27 (copy)
        if p30:IsA("Tool") and p30:GetAttribute("Rake") then
            u27:ExitPlacingMode();
        end;
    end);

    for _, child in p28:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Rake") then
            u27:EnterPlacingMode(child:GetAttribute("Rake"));
        end;
    end;
end;

function v1.EnterPlacingMode(p31, p32) -- Line: 170
    -- upvalues: u12 (ref), u11 (ref), debugPrint (copy), u17 (ref)
    p31:ExitPlacingMode();
    u12 = true;
    u11 = 0;
    debugPrint("EnterPlacingMode: rakeName =", p32, ", placingRotation reset to 0");

    if u17 then
        u17.Visible = true;
    end;

    p31:CreatePreview(p32);
end;

function v1.ExitPlacingMode(p33) -- Line: 185
    -- upvalues: u12 (ref), u17 (ref)
    u12 = false;
    p33:StopRotateHold();

    if u17 then
        u17.Visible = false;
    end;

    p33:DestroyPreview();
end;

function v1.CreatePreview(u34, p35) -- Line: 199
    -- upvalues: Rakes (copy), u10 (copy), u5 (ref), Assets (copy), u6 (ref), u8 (ref), TweenService (copy), u9 (ref), Debris (copy), Temporary (copy), u7 (ref), RunService (copy)
    u34:DestroyPreview();
    local v36 = Rakes:FindFirstChild(p35) or Rakes:FindFirstChild("Rake");
    local v37 = u10[p35];

    if not (v36 and v37) then
        return;
    end;

    u5 = v36:Clone();
    u5.Name = "RakePreview";
    local v38 = v37.Scale or 1;

    if v38 ~= 1 then
        u5:ScaleTo(u5:GetScale() * v38);
    end;

    local v39 = Assets.SprinklerRadius:Clone();
    v39.Size = Vector3.new(v37.Radius * 2, 0.5, v37.Radius * 2);
    v39.Anchored = true;
    v39.CanCollide = false;
    v39.CanQuery = false;
    v39.CanTouch = false;
    v39.Parent = u5;
    u6 = v39;
    local SurfaceGui = v39:FindFirstChild("SurfaceGui");

    if SurfaceGui then
        local PrimaryCircle = SurfaceGui:FindFirstChild("PrimaryCircle");

        if PrimaryCircle and PrimaryCircle:IsA("ImageLabel") then
            u8 = TweenService:Create(PrimaryCircle, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                ImageTransparency = 0.5
            });
            u9 = task.spawn(function() -- Line: 237
                -- upvalues: u6 (ref), PrimaryCircle (copy), SurfaceGui (copy), TweenService (ref), Debris (ref)
                while u6 do
                    local u40 = PrimaryCircle:Clone();
                    local v41 = u40:FindFirstChildOfClass("UIScale");

                    if not v41 then
                        v41 = Instance.new("UIScale");
                        v41.Parent = u40;
                    end;

                    u40.Parent = SurfaceGui;
                    v41.Scale = 0;
                    local v42 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    local v43 = TweenService:Create(v41, v42, {
                        Scale = 1
                    });
                    v43:Play();
                    Debris:AddItem(v43, v42.Time);
                    local v44 = TweenService:Create(u40, v42, {
                        ImageTransparency = 0
                    });
                    v44:Play();
                    Debris:AddItem(v44, v42.Time);
                    v44.Completed:Once(function() -- Line: 259
                        -- upvalues: TweenService (ref), u40 (copy), Debris (ref)
                        local v45 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                        local v46 = TweenService:Create(u40, v45, {
                            ImageTransparency = 1
                        });
                        v46:Play();
                        Debris:AddItem(v46, v45.Time);
                        v46.Completed:Once(function() -- Line: 264
                            -- upvalues: u40 (ref)
                            u40:Destroy();
                        end);
                    end);
                    task.wait(1.1);
                end;
            end);
        end;
    end;

    for _, descendant in u5:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Transparency == 0 then
                descendant.Transparency = 0.5;
            end;

            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = true;
        elseif descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;

    u5.Parent = Temporary;
    u7 = RunService.RenderStepped:Connect(function() -- Line: 290
        -- upvalues: u34 (copy)
        u34:UpdatePreview();
    end);
end;

function v1.DestroyPreview(p47) -- Line: 295
    -- upvalues: u9 (ref), u8 (ref), u5 (ref), u6 (ref), u7 (ref)
    if u9 then
        task.cancel(u9);
        u9 = nil;
    end;

    if u8 then
        u8:Cancel();
        u8:Destroy();
        u8 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    u6 = nil;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;
end;

function v1.SetPreviewColor(p48, p49) -- Line: 321
    -- upvalues: u5 (ref), u3 (copy), u4 (copy)
    if not u5 then
        return;
    end;

    local v50 = p49 and u3 or u4;

    for _, descendant in u5:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Color = v50;
        end;
    end;
end;

function v1.IsUsingGamepad(p51) -- Line: 334
    -- upvalues: UserInputService (copy)
    local v52 = UserInputService:GetLastInputType();

    return (v52 == Enum.UserInputType.Gamepad1 or (v52 == Enum.UserInputType.Gamepad2 or v52 == Enum.UserInputType.Gamepad3)) and true or v52 == Enum.UserInputType.Gamepad4;
end;

function v1.GetGamepadPlacementRay(p53) -- Line: 342
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil, nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 8 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0);
    end;

    return nil, nil;
end;

function v1.CreateRaycastParams(p54) -- Line: 354
    -- upvalues: CollectionService (copy)
    local v55 = RaycastParams.new();
    v55.FilterType = Enum.RaycastFilterType.Include;
    local v56 = CollectionService:GetTagged("GardenTotalArea");

    for _, v in CollectionService:GetTagged("PlantArea") do
        table.insert(v56, v);
    end;

    v55.FilterDescendantsInstances = v56;

    return v55;
end;

function v1.CreatePreviewRaycastParams(p57) -- Line: 369
    -- upvalues: LocalPlayer (copy), Temporary (copy)
    local v58 = RaycastParams.new();
    v58.FilterType = Enum.RaycastFilterType.Exclude;
    local Character = LocalPlayer.Character;
    local v59 = workspace:QueryDescendants("BasePart[Transparency = 1]");
    table.insert(v59, Temporary);

    if Character then
        table.insert(v59, Character);
    end;

    v58.FilterDescendantsInstances = v59;

    return v58;
end;

function v1.GetPlayerPlot(p60) -- Line: 385
    -- upvalues: LocalPlayer (copy), Gardens (copy)
    local v61 = LocalPlayer:GetAttribute("PlotId");

    if v61 then
        return Gardens:FindFirstChild("Plot" .. v61);
    end;

    return nil;
end;

function v1.GetPlotFromPart(p62, p63) -- Line: 391
    -- upvalues: Gardens (copy)
    while p63 do
        if p63.Parent == Gardens and string.match(p63.Name, "^Plot%d+$") then
            return p63;
        end;

        p63 = p63.Parent;

        if p63 == workspace then
            break;
        end;
    end;

    return nil;
end;

function v1.GetPlotId(p64, p65) -- Line: 403
    return tonumber(string.match(p65.Name, "%d+"));
end;

function v1.GetEquippedTool(p66) -- Line: 407
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChildWhichIsA("Tool");
    end;

    return nil;
end;

function v1.GetSpawnPoint(p67) -- Line: 413
    local v68 = p67:GetPlayerPlot();

    if v68 then
        return v68:FindFirstChild("SpawnPoint");
    end;

    return nil;
end;

function v1.GetGardenRotationY(p69) -- Line: 419
    local v70 = p69:GetSpawnPoint();

    if not v70 then
        return 0;
    end;

    local _, v71, _ = v70.CFrame:ToEulerAnglesYXZ();

    return v71;
end;

function v1.IsTooCloseToRake(p72, p73, p74) -- Line: 429
    -- upvalues: u5 (ref)
    if not p73 then
        return false;
    end;

    local Rakes2 = p73:FindFirstChild("Rakes");

    if not Rakes2 then
        return false;
    end;

    for _, descendant in Rakes2:GetDescendants() do
        if descendant:IsA("Model") and (descendant ~= u5 and (descendant.PrimaryPart and (descendant.PrimaryPart.Position - p74).Magnitude < 0.5)) then
            return true;
        end;
    end;

    return false;
end;

function v1.IsValidPlacement(p75, p76) -- Line: 446
    -- upvalues: CollectionService (copy)
    local v77 = CollectionService:GetTagged("GardenTotalArea");

    if #v77 == 0 then
        return false;
    end;

    local v78 = RaycastParams.new();
    v78.FilterType = Enum.RaycastFilterType.Include;
    v78.FilterDescendantsInstances = v77;

    return workspace:Raycast(p76 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0), v78) ~= nil;
end;

function v1.ComputeRakeCFrame(p79, p80) -- Line: 461
    -- upvalues: u11 (ref)
    local v81 = p79:GetGardenRotationY() + math.rad(u11);

    return CFrame.new(p80) * CFrame.Angles(0, v81, 0);
end;

function v1.UpdatePreview(p82) -- Line: 470
    -- upvalues: u5 (ref), UserInputService (copy), CurrentCamera (copy), CollectionService (copy), LocalPlayer (copy), Temporary (copy), u6 (ref), RadiusPreviewHeight (copy)
    if not u5 then
        return;
    end;

    local v83 = p82:CreateRaycastParams();
    local v84;

    if p82:IsUsingGamepad() then
        local v85, v86 = p82:GetGamepadPlacementRay();

        if not v85 then
            u5.Parent = nil;

            return;
        end;

        v84 = workspace:Raycast(v85, v86, v83);
    else
        local v87 = UserInputService:GetMouseLocation();
        local v88 = CurrentCamera:ViewportPointToRay(v87.X, v87.Y);
        v84 = workspace:Raycast(v88.Origin, v88.Direction * 5000, v83);
    end;

    if v84 then
        local Instance2 = v84.Instance;
        local v89 = p82:GetPlotFromPart(Instance2);
        local v90 = v89 and ((CollectionService:HasTag(Instance2, "GardenTotalArea") or CollectionService:HasTag(Instance2, "PlantArea")) and Instance2:IsDescendantOf(v89));

        if v90 then
            if v89:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                v90 = not p82:IsTooCloseToRake(v89, v84.Position) and p82:IsValidPlacement(v84.Position);
            else
                v90 = false;
            end;
        end;

        u5.Parent = Temporary;
        local Position = v84.Position;
        local v91 = Vector3.new(Position.X, Position.Y, Position.Z);
        u5:PivotTo(p82:ComputeRakeCFrame(v91) * CFrame.Angles(0, 3.141592653589793, 0));

        if u6 then
            u6.CFrame = CFrame.new(v91);
        end;

        p82:SetPreviewColor(v90);

        return;
    end;

    local v92 = p82:CreatePreviewRaycastParams();
    local v93;

    if p82:IsUsingGamepad() then
        local v94, v95 = p82:GetGamepadPlacementRay();

        if not v94 then
            u5.Parent = nil;

            return;
        end;

        v93 = workspace:Raycast(v94, v95, v92);
    else
        local v96 = UserInputService:GetMouseLocation();
        local v97 = CurrentCamera:ViewportPointToRay(v96.X, v96.Y);
        v93 = workspace:Raycast(v97.Origin, v97.Direction * 5000, v92);
    end;

    if not v93 then
        u5.Parent = nil;

        return;
    end;

    u5.Parent = Temporary;
    local Position = v93.Position;
    local X = Position.X;
    local v98 = RadiusPreviewHeight.Get();
    local v99 = Vector3.new(X, v98, Position.Z);
    u5:PivotTo(p82:ComputeRakeCFrame(v99) * CFrame.Angles(0, 3.141592653589793, 0));

    if u6 then
        u6.CFrame = CFrame.new(v99);
    end;

    p82:SetPreviewColor(false);
end;

function v1.CleanupTouchConnections(p100) -- Line: 555
    -- upvalues: u15 (ref)
    for _, v in u15 do
        v:Disconnect();
    end;

    u15 = {};
end;

function v1.OnRakeTouched(p101, p102, p103) -- Line: 562
    -- upvalues: LocalPlayer (copy), u10 (copy), u14 (copy), debugPrint (copy), Networking (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    if not p103:IsDescendantOf(Character) then
        return;
    end;

    local v104 = os.clock();
    local v105 = p102:GetAttribute("RakeName") or p102.Name;
    local v106 = p102:GetAttribute("RakeId") or p102.Name;
    local v107 = u10[v105];
    local v108 = u14[v106];

    if v108 and v104 - v108 < (v107 and v107.Cooldown or 3) then
        return;
    end;

    u14[v106] = v104;
    local v109;

    if p102.PrimaryPart then
        v109 = p102.PrimaryPart.Position;
    else
        v109 = p102:GetPivot().Position;
    end;

    debugPrint("=== RAKE TOUCHED ===");
    debugPrint("  rakeName =", v105);
    debugPrint("  rakePosition =", v109);

    if p102.PrimaryPart then
        local CFrame2 = p102.PrimaryPart.CFrame;
        local _, v110, _ = CFrame2:ToEulerAnglesYXZ();
        debugPrint("  Client sees PrimaryPart CFrame =", CFrame2);
        debugPrint("  Client sees PrimaryPart rotY(rad) =", v110, "rotY(deg) =", (math.deg(v110)));
        debugPrint("  Client sees PrimaryPart LookVector =", CFrame2.LookVector);
        debugPrint("  Client sees PrimaryPart RightVector =", CFrame2.RightVector);
    else
        debugPrint("  WARNING: PrimaryPart is nil!");
    end;

    debugPrint("  Firing RakeActivated to server with position =", v109);
    debugPrint("=== END RAKE TOUCHED ===");
    Networking.Place.RakeActivated:Fire(v105, v109);
end;

function v1.ConnectRakeTouch(u111, u112) -- Line: 602
    -- upvalues: u15 (ref)
    for _, descendant in u112:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v114 = descendant.Touched:Connect(function(p113) -- Line: 605
                -- upvalues: u111 (copy), u112 (copy)
                u111:OnRakeTouched(u112, p113);
            end);
            table.insert(u15, v114);
        end;
    end;
end;

function v1.GetRakeModelFromDescendant(p115, p116) -- Line: 614
    -- upvalues: Gardens (copy)
    while p116 and p116 ~= Gardens do
        if p116:IsA("Model") and (p116.Parent and p116.Parent.Name == "Rakes") then
            return p116;
        end;

        p116 = p116.Parent;
    end;

    return nil;
end;

local u117 = {};

function v1.SetupRakeTouchDetection(u118) -- Line: 628
    -- upvalues: debugPrint (copy), Gardens (copy), u117 (copy), u15 (ref)
    debugPrint("SetupRakeTouchDetection: setting up DescendantAdded listener");

    for _, child in Gardens:GetChildren() do
        if child:IsA("Model") then
            local Rakes2 = child:FindFirstChild("Rakes");

            if Rakes2 then
                for _, child2 in Rakes2:GetChildren() do
                    if child2:IsA("Model") and not u117[child2] then
                        u117[child2] = true;
                        u118:ConnectRakeTouch(child2);
                        debugPrint("  Connected existing rake:", child2.Name, "in", child.Name);
                    end;
                end;
            end;
        end;
    end;

    Gardens.DescendantAdded:Connect(function(p119) -- Line: 648
        -- upvalues: u117 (ref), u118 (copy), debugPrint (ref), u15 (ref)
        if not p119:IsA("Model") or (not p119.Parent or p119.Parent.Name ~= "Rakes") then
            if p119:IsA("BasePart") then
                local u120 = u118:GetRakeModelFromDescendant(p119);

                if u120 and u117[u120] then
                    local v122 = p119.Touched:Connect(function(p121) -- Line: 664
                        -- upvalues: u118 (ref), u120 (copy)
                        u118:OnRakeTouched(u120, p121);
                    end);
                    table.insert(u15, v122);
                end;
            end;

            return;
        end;

        task.wait();

        if not u117[p119] then
            u117[p119] = true;
            u118:ConnectRakeTouch(p119);
            debugPrint("  DescendantAdded: connected new rake model:", p119.Name);
        end;
    end);
    Gardens.DescendantRemoving:Connect(function(p123) -- Line: 673
        -- upvalues: u117 (ref)
        if p123:IsA("Model") and u117[p123] then
            u117[p123] = nil;
        end;
    end);
    debugPrint("SetupRakeTouchDetection: done");
end;

function v1.OnInput(p124, p125, p126) -- Line: 685
    -- upvalues: CutsceneGate (copy), u12 (ref), u11 (ref), debugPrint (copy), u2 (ref), CurrentCamera (copy), CollectionService (copy), LocalPlayer (copy), Networking (copy), SoundService (copy)
    if p126 then
        return;
    end;

    if CutsceneGate.IsActive() then
        return;
    end;

    if u12 and (p125.KeyCode == Enum.KeyCode.R or p125.KeyCode == Enum.KeyCode.ButtonR1) then
        u11 = (u11 + 15) % 360;
        debugPrint("R key: placingRotation =", u11);
        p124:StartRotateHold();

        return;
    end;

    if p125.UserInputType ~= Enum.UserInputType.MouseButton1 and p125.UserInputType ~= Enum.UserInputType.Touch and p125.KeyCode ~= Enum.KeyCode.ButtonR2 then
        return;
    end;

    local v127 = os.clock();

    if v127 - u2 < 0.5 then
        return;
    end;

    local v128 = p124:GetEquippedTool();

    if not v128 then
        return;
    end;

    local v129 = v128:GetAttribute("Rake");

    if not v129 then
        return;
    end;

    local v130 = p124:CreateRaycastParams();
    local v131;

    if p124:IsUsingGamepad() then
        local v132, v133 = p124:GetGamepadPlacementRay();

        if not v132 then
            return;
        end;

        v131 = workspace:Raycast(v132, v133, v130);
    else
        local Position = p125.Position;
        local v134 = CurrentCamera:ScreenPointToRay(Position.X, Position.Y);
        v131 = workspace:Raycast(v134.Origin, v134.Direction * 5000, v130);
    end;

    if not v131 then
        return;
    end;

    local Instance2 = v131.Instance;

    if not (CollectionService:HasTag(Instance2, "GardenTotalArea") or CollectionService:HasTag(Instance2, "PlantArea")) then
        return;
    end;

    local v135 = p124:GetPlotFromPart(Instance2);

    if not v135 then
        return;
    end;

    if not Instance2:IsDescendantOf(v135) then
        return;
    end;

    if not v135:GetAttribute("Owner") then
        return;
    end;

    local v136 = p124:GetPlotId(v135);

    if not v136 then
        return;
    end;

    if v135:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
        return;
    end;

    if p124:IsTooCloseToRake(v135, v131.Position) then
        return;
    end;

    if not p124:IsValidPlacement(v131.Position) then
        return;
    end;

    u2 = v127;
    local Position = v131.Position;
    local v137 = p124:GetSpawnPoint();
    local v138 = p124:GetGardenRotationY();
    local v139 = math.deg(v138);
    debugPrint("=== PLACEMENT FIRE ===");
    debugPrint("  hitPosition =", Position);
    debugPrint("  rakeName =", v129);
    debugPrint("  targetPlotId =", v136);
    debugPrint("  SpawnPoint CFrame =", v137 and v137.CFrame or "nil");
    debugPrint("  gardenRotY(rad) =", v138, "gardenRotY(deg) =", v139);
    debugPrint("  placingRotation(deg) =", u11);
    local v140 = v139 + u11;
    debugPrint("  worldRotationDeg = gardenRotYDeg + placingRotation =", v140);
    local v141 = CFrame.new(Position) * CFrame.Angles(0, v138 + math.rad(u11), 0);
    local _, v142, _ = v141:ToEulerAnglesYXZ();
    debugPrint("  PREVIEW CFrame =", v141);
    debugPrint("  PREVIEW rotY(deg) =", (math.deg(v142)));
    debugPrint("  PREVIEW LookVector =", v141.LookVector);
    local SpawnPoint = v135:FindFirstChild("SpawnPoint");

    if SpawnPoint then
        local _, v143, _ = SpawnPoint.CFrame:ToEulerAnglesYXZ();
        local v144 = math.deg(v143);
        debugPrint("  targetSpawnPoint CFrame =", SpawnPoint.CFrame);
        debugPrint("  targetSpawnPoint rotY(rad) =", v143, "rotY(deg) =", v144);
        local v145 = v140 - v144;
        debugPrint("  relativeRotation = worldRotDeg - spawnRotYDeg =", v140, "-", v144, "=", v145);
        v140 = v145;
    else
        debugPrint("  WARNING: no SpawnPoint in targetPlot!");
    end;

    debugPrint("  >>> SENDING TO SERVER: relativeRotation =", v140);
    debugPrint("=== END PLACEMENT FIRE ===");
    Networking.Place.PlaceRake:Fire(Position, v129, v128, v136, v140);
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character then
        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://135948019584556";
        Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
        Sound.Parent = Character;
        Sound:Play();
        game.Debris:AddItem(Sound, 3);
    end;
end;

return v1;