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
local SoundService = game:GetService("SoundService");
local BillboardGui = script.BillboardGui;
local _ = BillboardGui.TextLabel.TextLabel;
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local CutsceneGate = require(ReplicatedStorage.ClientModules.CutsceneGate);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Assets = ReplicatedStorage.Assets;
local Gnome = Assets:WaitForChild("Gnome");
local Temporary = workspace.Temporary;
local u2 = 0;

local function raycastSkipTransparent(p3, p4, p5) -- Line: 36
    for _ = 1, 10 do
        local v6 = workspace:Raycast(p3, p4, p5);

        if not v6 then
            return nil;
        end;

        if v6.Instance.Transparency < 1 then
            return v6;
        end;

        local v7 = table.clone(p5.FilterDescendantsInstances);
        table.insert(v7, v6.Instance);
        p5.FilterDescendantsInstances = v7;
    end;

    return nil;
end;

local u8 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u9 = Color3.fromRGB(100, 255, 100);
local u10 = Color3.fromRGB(255, 100, 100);
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local Gnomes = workspace:WaitForChild("Gnomes");
local Folder = Instance.new("Folder");
Folder.Name = "GnomeVisuals";
Folder.Parent = workspace;
local u16 = {};
local u17 = {};
Networking.Gnome.Positions.OnClientEvent:Connect(function(p18) -- Line: 78
    -- upvalues: u17 (copy)
    if typeof(p18) ~= "table" then
        return;
    end;

    for _, v in p18 do
        local v19 = v[1];
        local v20 = v[2];

        if typeof(v19) == "Instance" and (v19:IsA("BasePart") and typeof(v20) == "Vector3") then
            u17[v19] = v20;
        end;
    end;
end);
local u21 = nil;

local function createRangeIndicator(p22) -- Line: 108
    -- upvalues: Assets (copy), u17 (copy)
    if p22.RangeIndicator then
        return;
    end;

    local v23 = p22.Part:GetAttribute("Range") or 50;
    local v24 = Assets.SprinklerRadius:Clone();
    v24.Name = "GnomeRangeIndicator";
    v24.Size = Vector3.new(v23, 0.5, v23);
    v24.Anchored = true;
    v24.CanCollide = false;
    v24.CanQuery = false;
    v24.CanTouch = false;
    local v25 = u17[p22.Part] or p22.Part.Position;
    v24.CFrame = CFrame.new(v25.X, v25.Y - p22.Part.Size.Y / 2 + 0.1, v25.Z);
    p22.RangeIndicator = v24;
end;

local function showRangeIndicator(p26) -- Line: 128
    -- upvalues: createRangeIndicator (copy), Temporary (copy)
    if not p26.RangeIndicator then
        createRangeIndicator(p26);
    end;

    local RangeIndicator = p26.RangeIndicator;

    if not RangeIndicator then
        return;
    end;

    RangeIndicator.Parent = Temporary;
    p26.IsHovered = true;
end;

local function hideRangeIndicator(p27) -- Line: 140
    if p27.RangeIndicator then
        p27.RangeIndicator.Parent = nil;
    end;

    p27.IsHovered = false;
end;

local function updateHoverDetection() -- Line: 147
    -- upvalues: LocalPlayer (copy), UserInputService (copy), CurrentCamera (copy), u16 (copy), u21 (ref), createRangeIndicator (copy), Temporary (copy)
    if not LocalPlayer.Character then
        return;
    end;

    local v28 = UserInputService:GetMouseLocation();
    local v29 = CurrentCamera:ViewportPointToRay(v28.X, v28.Y);
    local v30 = {};

    for _, v in u16 do
        if v.Model and v.Model.Parent then
            table.insert(v30, v.Model);
        end;
    end;

    if #v30 == 0 then
        if u21 then
            local v31 = u21;

            if v31.RangeIndicator then
                v31.RangeIndicator.Parent = nil;
            end;

            v31.IsHovered = false;
            u21 = nil;
        end;

        return;
    end;

    local v32 = RaycastParams.new();
    v32.FilterType = Enum.RaycastFilterType.Include;
    v32.FilterDescendantsInstances = v30;
    local v33 = workspace:Raycast(v29.Origin, v29.Direction * 500, v32);
    local v34 = nil;

    if v33 and v33.Instance then
        for _, v in u16 do
            if v.Part:GetAttribute("Owner") == LocalPlayer.Name and (v33.Instance:IsDescendantOf(v.Model) or v33.Instance == v.Model.PrimaryPart) then
                v34 = v;
                break;
            end;
        end;
    end;

    if v34 ~= u21 then
        if u21 then
            local v35 = u21;

            if v35.RangeIndicator then
                v35.RangeIndicator.Parent = nil;
            end;

            v35.IsHovered = false;
        end;

        if v34 then
            if not v34.RangeIndicator then
                createRangeIndicator(v34);
            end;

            local RangeIndicator = v34.RangeIndicator;

            if RangeIndicator then
                RangeIndicator.Parent = Temporary;
                v34.IsHovered = true;
            end;
        end;

        u21 = v34;
    end;
end;

local function setupVisualGnome(u36) -- Line: 204
    -- upvalues: u16 (copy), Gnome (copy), u17 (copy), Folder (copy), BillboardGui (copy)
    if u16[u36] then
        return;
    end;

    local v37 = Gnome:Clone();
    v37.Name = "GnomeVisual_" .. u36.Name;
    local v38 = v37:FindFirstChildOfClass("AnimationController");

    if not v38 then
        v38 = Instance.new("AnimationController");
        v38.Parent = v37;
    end;

    local u39 = v38:FindFirstChildOfClass("Animator");

    if not u39 then
        u39 = Instance.new("Animator");
        u39.Parent = v38;
    end;

    local PrimaryPart = v37.PrimaryPart;

    if PrimaryPart then
        PrimaryPart.Anchored = true;
    end;

    for _, descendant in v37:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
            descendant.Anchored = false;
        end;

        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = true;
            descendant.CanTouch = false;
        end;
    end;

    local v40 = (u17[u36] or u36.Position) + Vector3.new(0, 0, 0);
    local _, v41, _ = u36.CFrame:ToEulerAnglesYXZ();
    local v42 = CFrame.new(v40) * CFrame.Angles(0, v41, 0);

    if PrimaryPart then
        v37:PivotTo(v42);
    end;

    v37.Parent = Folder;
    local v43 = {};
    local v44 = {};

    for _, child in v37:GetChildren() do
        if child:IsA("Animation") then
            v43[child.Name] = child;
        end;
    end;

    local Animations = v37:FindFirstChild("Animations");

    if Animations then
        for _, child in Animations:GetChildren() do
            if child:IsA("Animation") then
                v43[child.Name] = child;
            end;
        end;
    end;

    for i, v in v43 do
        local success, result = pcall(function() -- Line: 270
            -- upvalues: u39 (ref), v (copy)
            return u39:LoadAnimation(v);
        end);

        if success and result then
            v44[i] = result;

            if i == "Idle" or i == "Walk" then
                result.Looped = true;
            elseif i == "Attack" then
                result.Looped = false;
            end;
        end;
    end;

    local v45 = BillboardGui:Clone();

    if PrimaryPart then
        v45.Adornee = PrimaryPart;
        v45.Parent = PrimaryPart;
    end;

    local u46 = {
        CurrentState = "",
        AttributeConn = nil,
        RangeIndicator = nil,
        IsHovered = false,
        Part = u36,
        Model = v37,
        Animator = u39,
        Tracks = v44,
        CurrentCF = v42,
        Billboard = v45
    };
    u46.AttributeConn = u36.AttributeChanged:Connect(function(p47) -- Line: 305
        -- upvalues: u36 (copy), u46 (copy)
        if p47 == "GnomeState" then
            local v48 = u36:GetAttribute("GnomeState");
            switchAnimation(u46, v48);
        end;
    end);
    u16[u36] = u46;
    local v49 = u36:GetAttribute("GnomeState") or "idle";
    switchAnimation(u46, v49);
end;

function switchAnimation(p50, p51)
    if p50.CurrentState == p51 then
        return;
    end;

    p50.CurrentState = p51;

    for _, v in p50.Tracks do
        if v.IsPlaying then
            v:Stop(0.2);
        end;
    end;

    local v52 = p51 == "idle" and "Idle" or ((p51 == "wandering" or p51 == "chasing") and "Walk" or (p51 == "attacking" and "Attack" or nil));

    if v52 and p50.Tracks[v52] then
        p50.Tracks[v52]:Play(0.2);
    end;
end;

local function cleanupVisualGnome(p53) -- Line: 343
    -- upvalues: u16 (copy), u21 (ref), u17 (copy)
    local v54 = u16[p53];

    if not v54 then
        return;
    end;

    if u21 == v54 then
        u21 = nil;
    end;

    if v54.AttributeConn then
        v54.AttributeConn:Disconnect();
    end;

    if v54.RangeIndicator then
        v54.RangeIndicator:Destroy();
    end;

    if v54.Billboard then
        v54.Billboard:Destroy();
    end;

    for _, v in v54.Tracks do
        v:Stop(0);
        v:Destroy();
    end;

    if v54.Model then
        v54.Model:Destroy();
    end;

    u17[p53] = nil;
    u16[p53] = nil;
end;

function v1.Init(p55) -- Line: 381
end;

function v1.Start(u56) -- Line: 384
    -- upvalues: UserInputService (copy), CutsceneGate (copy), LocalPlayer (copy)
    UserInputService.InputBegan:Connect(function(p57, p58) -- Line: 385
        -- upvalues: u56 (copy)
        u56:OnInput(p57, p58);
    end);
    UserInputService.TouchTapInWorld:Connect(function(p59, p60) -- Line: 392
        -- upvalues: CutsceneGate (ref), u56 (copy)
        if p60 then
            return;
        end;

        if CutsceneGate.IsActive() then
            return;
        end;

        local v61 = u56:GetEquippedTool();

        if not (v61 and v61:GetAttribute("Gnome")) then
            return;
        end;

        u56:TryPlace(p59);
    end);
    local Character = LocalPlayer.Character;

    if Character then
        u56:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p62) -- Line: 406
        -- upvalues: u56 (copy)
        u56:SetupCharacter(p62);
    end);
    u56:StartGnomeVisuals();
end;

function v1.StartGnomeVisuals(p63) -- Line: 413
    -- upvalues: Gnomes (copy), setupVisualGnome (copy), cleanupVisualGnome (copy), RunService (copy), u16 (copy), u17 (copy), updateHoverDetection (copy)
    for _, child in Gnomes:GetChildren() do
        if child:IsA("BasePart") then
            setupVisualGnome(child);
        end;
    end;

    Gnomes.ChildAdded:Connect(function(p64) -- Line: 420
        -- upvalues: setupVisualGnome (ref)
        if p64:IsA("BasePart") then
            setupVisualGnome(p64);
        end;
    end);
    Gnomes.ChildRemoved:Connect(function(p65) -- Line: 426
        -- upvalues: cleanupVisualGnome (ref)
        if p65:IsA("BasePart") then
            cleanupVisualGnome(p65);
        end;
    end);
    RunService.RenderStepped:Connect(function(p66) -- Line: 433
        -- upvalues: u16 (ref), cleanupVisualGnome (ref), u17 (ref), updateHoverDetection (ref)
        debug.profilebegin("Controllers/GnomeController/RenderStepped");
        local v67 = math.min(1, 15 * p66);

        for i, v in u16 do
            if i and i.Parent then
                local Model = v.Model;

                if Model and Model.PrimaryPart then
                    local v68 = (u17[i] or i.Position) + Vector3.new(0, 0, 0);
                    local Position = v.CurrentCF.Position;
                    local v69 = Position:Lerp(v68, v67);
                    local v70 = v68.X - Position.X;
                    local v71 = v68.Z - Position.Z;
                    local v72;

                    if v70 * v70 + v71 * v71 > 0.01 and (v.CurrentState == "wandering" or v.CurrentState == "chasing") then
                        local v73 = v69 + Vector3.new(v70, 0, v71);
                        v72 = CFrame.lookAt(v69, v73);
                    else
                        local _, v74, _ = v.CurrentCF:ToEulerAnglesYXZ();
                        v72 = CFrame.new(v69) * CFrame.Angles(0, v74, 0);
                    end;

                    v.CurrentCF = v72;
                    Model.PrimaryPart.CFrame = v72;

                    if v.RangeIndicator and v.IsHovered then
                        local v75 = u17[i] or i.Position;
                        v.RangeIndicator.CFrame = CFrame.new(v75.X, v75.Y - i.Size.Y / 2 + 0.1, v75.Z);
                    end;

                    if v.Billboard then
                        local v76 = i:GetAttribute("PlacedAt");
                        local v77 = i:GetAttribute("Lifetime") or 600;

                        if v76 then
                            local v78 = v77 - (workspace:GetServerTimeNow() - v76);
                            local v79 = math.ceil(v78);
                            local v80 = math.max(0, v79);
                            local v81 = math.floor(v80 / 60);
                            local v82 = v80 % 60;
                            local TextLabel = v.Billboard:FindFirstChild("TextLabel");

                            if TextLabel then
                                TextLabel.Text = string.format("%d:%02d", v81, v82);
                                local TextLabel2 = TextLabel:FindFirstChild("TextLabel");

                                if TextLabel2 then
                                    TextLabel2.Text = string.format("%d:%02d", v81, v82);
                                end;
                            end;
                        end;
                    end;
                end;
            else
                cleanupVisualGnome(i);
            end;
        end;

        updateHoverDetection();
        debug.profileend();
    end);
end;

function v1.SetupCharacter(u83, p84) -- Line: 507
    p84.ChildAdded:Connect(function(p85) -- Line: 508
        -- upvalues: u83 (copy)
        if p85:IsA("Tool") and p85:GetAttribute("Gnome") then
            u83:CreatePreview();
        end;
    end);
    p84.ChildRemoved:Connect(function(p86) -- Line: 514
        -- upvalues: u83 (copy)
        if p86:IsA("Tool") and p86:GetAttribute("Gnome") then
            u83:DestroyPreview();
        end;
    end);

    for _, child in p84:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Gnome") then
            u83:CreatePreview();
        end;
    end;
end;

function v1.CreatePreview(u87) -- Line: 527
    -- upvalues: u11 (ref), Gnome (copy), Assets (copy), u12 (ref), u14 (ref), TweenService (copy), u8 (copy), u15 (ref), Temporary (copy), u13 (ref), RunService (copy)
    u87:DestroyPreview();
    u11 = Gnome:Clone();
    u11.Name = "GnomePreview";
    local v88 = Assets.SprinklerRadius:Clone();
    v88.Size = Vector3.new(50, 0.5, 50);
    v88.Anchored = true;
    v88.CanCollide = false;
    v88.CanQuery = false;
    v88.CanTouch = false;
    v88.Parent = u11;
    u12 = v88;
    local SurfaceGui = v88:FindFirstChild("SurfaceGui");

    if SurfaceGui then
        local PrimaryCircle = SurfaceGui:FindFirstChild("PrimaryCircle");

        if PrimaryCircle and PrimaryCircle:IsA("ImageLabel") then
            u14 = TweenService:Create(PrimaryCircle, u8, {
                ImageTransparency = 0.5
            });
            u15 = task.spawn(function() -- Line: 552
                -- upvalues: u12 (ref), PrimaryCircle (copy), SurfaceGui (copy), TweenService (ref)
                while u12 do
                    local u89 = PrimaryCircle:Clone();
                    local v90 = u89:FindFirstChildOfClass("UIScale");

                    if not v90 then
                        v90 = Instance.new("UIScale");
                        v90.Parent = u89;
                    end;

                    u89.Parent = SurfaceGui;
                    v90.Scale = 0;
                    local v91 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    TweenService:Create(v90, v91, {
                        Scale = 1
                    }):Play();
                    local v92 = TweenService:Create(u89, v91, {
                        ImageTransparency = 0
                    });
                    v92:Play();
                    v92.Completed:Once(function() -- Line: 570
                        -- upvalues: TweenService (ref), u89 (copy)
                        local v93 = TweenService:Create(u89, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 1
                        });
                        v93:Play();
                        v93.Completed:Once(function() -- Line: 574
                            -- upvalues: u89 (ref)
                            u89:Destroy();
                        end);
                    end);
                    task.wait(1.1);
                end;
            end);
        end;
    end;

    for _, descendant in u11:GetDescendants() do
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

    u11.Parent = Temporary;
    u13 = RunService.RenderStepped:Connect(function() -- Line: 600
        -- upvalues: u87 (copy)
        debug.profilebegin("Controllers/GnomeController/PreviewUpdate");
        u87:UpdatePreview();
        debug.profileend();
    end);
end;

function v1.DestroyPreview(p94) -- Line: 607
    -- upvalues: u15 (ref), u14 (ref), u11 (ref), u12 (ref), u13 (ref)
    if u15 then
        task.cancel(u15);
        u15 = nil;
    end;

    if u14 then
        u14:Cancel();
        u14 = nil;
    end;

    if u11 then
        u11:Destroy();
        u11 = nil;
    end;

    u12 = nil;

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;
end;

function v1.SetPreviewColor(p95, p96) -- Line: 631
    -- upvalues: u11 (ref)
    if not u11 then
        return;
    end;

    for _, descendant in u11:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Color = p96;
        end;
    end;
end;

function v1.IsUsingGamepad(p97) -- Line: 641
    -- upvalues: UserInputService (copy)
    local v98 = UserInputService:GetLastInputType();

    return (v98 == Enum.UserInputType.Gamepad1 or (v98 == Enum.UserInputType.Gamepad2 or v98 == Enum.UserInputType.Gamepad3)) and true or v98 == Enum.UserInputType.Gamepad4;
end;

function v1.GetGamepadPlacementRay(p99) -- Line: 649
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

function v1.CreateRaycastParams(p100) -- Line: 664
    -- upvalues: LocalPlayer (copy), Temporary (copy), Folder (copy)
    local v101 = RaycastParams.new();
    v101.FilterType = Enum.RaycastFilterType.Exclude;
    local Character = LocalPlayer.Character;
    local v102 = { Temporary, Folder };

    if Character then
        table.insert(v102, Character);
    end;

    v101.FilterDescendantsInstances = v102;

    return v101;
end;

local u103 = nil;

local function getLocalGarden() -- Line: 681
    -- upvalues: u103 (ref), LocalPlayer (copy)
    if u103 and u103.Parent then
        return u103;
    end;

    u103 = nil;

    for _, child in workspace.Gardens:GetChildren() do
        if child:GetAttribute("Owner") == LocalPlayer.Name then
            u103 = child;
            break;
        end;
    end;

    return u103;
end;

local function getGardenAreaPart(p104) -- Line: 695
    -- upvalues: CollectionService (copy)
    for _, descendant in p104:GetDescendants() do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "GardenTotalArea") then
            return descendant;
        end;
    end;

    return nil;
end;

function v1.IsValidPlacement(p105, p106) -- Line: 704
    -- upvalues: getLocalGarden (copy), getGardenAreaPart (copy)
    local v107 = getLocalGarden();

    if not v107 then
        return false;
    end;

    local v108 = getGardenAreaPart(v107);

    if not v108 then
        return false;
    end;

    local v109 = RaycastParams.new();
    v109.FilterType = Enum.RaycastFilterType.Include;
    v109.FilterDescendantsInstances = { v108 };

    return workspace:Raycast(p106 + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0), v109) ~= nil;
end;

function v1.UpdatePreview(p110) -- Line: 722
    -- upvalues: u11 (ref), raycastSkipTransparent (copy), UserInputService (copy), CurrentCamera (copy), Temporary (copy), getLocalGarden (copy), u103 (ref), u12 (ref), u9 (copy), u10 (copy)
    if not u11 then
        return;
    end;

    local v111 = p110:CreateRaycastParams();
    local v112;

    if p110:IsUsingGamepad() then
        local v113, v114 = p110:GetGamepadPlacementRay();

        if not v113 then
            u11.Parent = nil;

            return;
        end;

        v112 = raycastSkipTransparent(v113, v114, v111);
    else
        local v115 = UserInputService:GetMouseLocation();
        local v116 = CurrentCamera:ViewportPointToRay(v115.X, v115.Y);
        v112 = raycastSkipTransparent(v116.Origin, v116.Direction * 5000, v111);
    end;

    if not v112 then
        u11.Parent = nil;

        return;
    end;

    u11.Parent = Temporary;
    local Position = v112.Position;
    local v117 = Position + Vector3.new(0, 1.5, 0);
    getLocalGarden();
    local v118 = CFrame.Angles(0, 0, 0);

    if u103 and u103:FindFirstChild("SpawnPoint") then
        v118 = (u103.SpawnPoint.CFrame - u103.SpawnPoint.CFrame.Position) * CFrame.Angles(0, 3.141592653589793, 0);
    end;

    if u11.PrimaryPart then
        u11:PivotTo(CFrame.new(v117) * v118);
    end;

    if u12 then
        u12.CFrame = CFrame.new(Position) * v118;
    end;

    if p110:IsValidPlacement(Position) then
        p110:SetPreviewColor(u9);

        return;
    end;

    p110:SetPreviewColor(u10);
end;

function v1.GetEquippedTool(p119) -- Line: 781
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChildWhichIsA("Tool");
    end;

    return nil;
end;

function v1.OnInput(p120, p121, p122) -- Line: 790
    -- upvalues: CutsceneGate (copy)
    if p122 then
        return;
    end;

    if CutsceneGate.IsActive() then
        return;
    end;

    if p121.UserInputType ~= Enum.UserInputType.MouseButton1 and p121.KeyCode ~= Enum.KeyCode.ButtonR2 then
        return;
    end;

    p120:TryPlace();
end;

function v1.TryPlace(p123, p124) -- Line: 806
    -- upvalues: u2 (ref), raycastSkipTransparent (copy), UserInputService (copy), CurrentCamera (copy), u103 (ref), Networking (copy), LocalPlayer (copy), SoundService (copy)
    local v125 = os.clock();

    if v125 - u2 < 0.5 then
        return false;
    end;

    local v126 = p123:GetEquippedTool();

    if not v126 then
        return false;
    end;

    local v127 = v126:GetAttribute("Gnome");

    if not v127 then
        return false;
    end;

    local v128 = p123:CreateRaycastParams();
    local v129;

    if p123:IsUsingGamepad() then
        local v130, v131 = p123:GetGamepadPlacementRay();

        if not v130 then
            return false;
        end;

        v129 = raycastSkipTransparent(v130, v131, v128);
    else
        local v132 = p124 or UserInputService:GetMouseLocation();
        local v133 = CurrentCamera:ViewportPointToRay(v132.X, v132.Y);
        v129 = raycastSkipTransparent(v133.Origin, v133.Direction * 5000, v128);
    end;

    if not v129 then
        return false;
    end;

    if not p123:IsValidPlacement(v129.Position) then
        return false;
    end;

    u2 = v125;
    local Position = v129.Position;
    local v134;

    if u103 and u103:FindFirstChild("SpawnPoint") then
        local _, v135, _ = u103.SpawnPoint.CFrame:ToEulerAnglesYXZ();
        v134 = math.deg(v135) + 180;
    else
        v134 = 0;
    end;

    Networking.Place.PlaceGnome:Fire(Position, v127, v126, v134);
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

    return true;
end;

return v1;