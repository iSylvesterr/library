-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local CollectionService = game:GetService("CollectionService");
local SoundService = game:GetService("SoundService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Gardens = workspace:WaitForChild("Gardens");
local Props = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Props");
local u2 = false;

local function UpdateIsMobile() -- Line: 25
    -- upvalues: u2 (ref), UserInputService (copy)
    local v3;

    if workspace.CurrentCamera.ViewportSize.X < 1000 then
        v3 = true;
    else
        v3 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
    end;

    u2 = v3;
end;

local v4;

if workspace.CurrentCamera.ViewportSize.X < 1000 then
    v4 = true;
else
    v4 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
end;

u2 = v4;
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateIsMobile);

local function PlayPlaceSFX() -- Line: 40
    -- upvalues: LocalPlayer (copy), SoundService (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not Character then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://136697624359338";
    Sound.Volume = 1;
    Sound.SoundGroup = SoundService:FindFirstChild("SFXGroup");
    Sound.Parent = Character;
    Sound:Play();
    game.Debris:AddItem(Sound, Sound.TimeLength / math.max(Sound.PlaybackSpeed, 0.01) + 1);
end;

local function profileBegin(p5) -- Line: 55
    debug.profilebegin("Controllers/PropController/" .. p5);
end;

local function profileEnd() -- Line: 59
    debug.profileend();
end;

local u6 = false;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = 0;
local u16 = nil;
local u17 = 0;
local u18 = nil;
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = {};
local u23 = {};
local u24 = 0;

local function debugLog(...) -- Line: 88
end;

local function vec3str(p25) -- Line: 92
    return string.format("(%.4f, %.4f, %.4f)", p25.X, p25.Y, p25.Z);
end;

local function cfstr(p26) -- Line: 96
    local v27, v28, v29 = p26:ToEulerAnglesYXZ();
    local Position = p26.Position;

    return string.format("pos=%s rot=(%.2f, %.2f, %.2f)deg", string.format("(%.4f, %.4f, %.4f)", Position.X, Position.Y, Position.Z), math.deg(v27), math.deg(v28), (math.deg(v29)));
end;

function v1.Init(p30) -- Line: 101
end;

function v1.Start(u31) -- Line: 105
    -- upvalues: LocalPlayer (copy), u16 (ref)
    local Character = LocalPlayer.Character;

    if Character then
        u31:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p32) -- Line: 111
        -- upvalues: u31 (copy)
        u31:SetupCharacter(p32);
    end);
    LocalPlayer:GetAttributeChangedSignal("PlotId"):Connect(function() -- Line: 115
        -- upvalues: u16 (ref)
        u16 = nil;
    end);
end;

function v1.SetupCharacter(u33, p34) -- Line: 120
    -- upvalues: u13 (ref)
    p34.ChildAdded:Connect(function(p35) -- Line: 121
        -- upvalues: u13 (ref)
        if p35:IsA("Tool") and p35:GetAttribute("Build") then
            u13 = p35;
        end;
    end);
    p34.ChildRemoved:Connect(function(p36) -- Line: 127
        -- upvalues: u13 (ref), u33 (copy)
        if p36:IsA("Tool") and (p36:GetAttribute("Build") and u13 == p36) then
            u13 = nil;
            u33:StopPlacement();
        end;
    end);

    for _, child in p34:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Build") then
            u13 = child;
        end;
    end;
end;

function v1.GetPlayerPlotFolder(p37) -- Line: 143
    -- upvalues: u16 (ref), LocalPlayer (copy), Gardens (copy)
    if u16 then
        return u16;
    end;

    local v38 = LocalPlayer:GetAttribute("PlotId");

    if not v38 then
        return nil;
    end;

    local v39 = Gardens:FindFirstChild("Plot" .. tostring(v38));

    if not v39 then
        return nil;
    end;

    u16 = v39;

    return u16;
end;

function v1.GetSpawnPoint(p40) -- Line: 158
    local v41 = p40:GetPlayerPlotFolder();

    if v41 then
        return v41:FindFirstChild("SpawnPoint");
    end;

    return nil;
end;

function v1.SnapToGrid(p42, p43) -- Line: 164
    -- upvalues: u24 (ref), debugLog (copy)
    local v44 = p42:GetSpawnPoint();

    if not v44 then
        debugLog("SnapToGrid: WARNING no spawnPoint, falling back to world-space snap");
        local v45 = math.round(p43.X / 0.5) * 0.5;
        local v46 = math.round(p43.Y / 0.5) * 0.5;
        local v47 = math.round(p43.Z / 0.5) * 0.5;

        return Vector3.new(v45, v46, v47);
    end;

    local v48 = v44.CFrame:PointToObjectSpace(p43);
    local v49 = math.round(v48.X / 0.5) * 0.5;
    local v50 = math.round(v48.Y / 0.5) * 0.5;
    local v51 = math.round(v48.Z / 0.5) * 0.5;
    local v52 = Vector3.new(v49, v50, v51);
    local v53 = v44.CFrame:PointToWorldSpace(v52);

    if u24 < 20 then
        u24 = u24 + 1;
        debugLog("SnapToGrid: worldIn=" .. string.format("(%.4f, %.4f, %.4f)", p43.X, p43.Y, p43.Z));
        local CFrame2 = v44.CFrame;
        local v54, v55, v56 = CFrame2:ToEulerAnglesYXZ();
        local Position = CFrame2.Position;
        debugLog("  spawnCFrame=" .. string.format("pos=%s rot=(%.2f, %.2f, %.2f)deg", string.format("(%.4f, %.4f, %.4f)", Position.X, Position.Y, Position.Z), math.deg(v54), math.deg(v55), (math.deg(v56))));
        debugLog("  localPos=" .. string.format("(%.4f, %.4f, %.4f)", v48.X, v48.Y, v48.Z));
        debugLog("  snappedLocal=" .. string.format("(%.4f, %.4f, %.4f)", v52.X, v52.Y, v52.Z));
        debugLog("  worldOut=" .. string.format("(%.4f, %.4f, %.4f)", v53.X, v53.Y, v53.Z));
        debugLog("  deltaXYZ local=(" .. string.format("%.4f", v48.X - v52.X) .. ", " .. string.format("%.4f", v48.Y - v52.Y) .. ", " .. string.format("%.4f", v48.Z - v52.Z) .. ")");
    end;

    return v53;
end;

function v1.CalculateYOffset(p57, p58) -- Line: 195
    if not (p58 and p58.PrimaryPart) then
        return 0;
    end;

    local PrimaryPart = p58.PrimaryPart;

    return PrimaryPart.Size.Y / 2 + (p58:GetPivot().Position.Y - PrimaryPart.Position.Y);
end;

function v1.CreateRaycastParams(p59) -- Line: 207
    -- upvalues: LocalPlayer (copy), u7 (ref), u18 (ref)
    local v60 = RaycastParams.new();
    v60.FilterType = Enum.RaycastFilterType.Exclude;
    local v61 = {};
    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v61, Character);
    end;

    if u7 then
        table.insert(v61, u7);
    end;

    if u18 then
        table.insert(v61, u18);
    end;

    v60.FilterDescendantsInstances = v61;

    return v60;
end;

function v1.IsTouchInJoystickZone(p62, p63) -- Line: 230
    -- upvalues: CurrentCamera (copy), GuiService (copy)
    local ViewportSize = CurrentCamera.ViewportSize;
    local v64 = GuiService:GetGuiInset();
    local v65 = (p63.Y - v64.Y) / (ViewportSize.Y - v64.Y);
    local v66;

    if p63.X / ViewportSize.X < 0.3 then
        v66 = v65 > 0.6;
    else
        v66 = false;
    end;

    return v66;
end;

function v1.GetPlacementPositionFromScreen(p67, p68, p69) -- Line: 240
    -- upvalues: CurrentCamera (copy), debugLog (copy), u24 (ref), u17 (ref)
    local v70 = p67:CreateRaycastParams();
    local v71 = CurrentCamera:ViewportPointToRay(p68, p69);
    local Origin = v71.Origin;
    local v72 = v71.Direction * 5000;

    for i = 1, 100 do
        local v73 = workspace:Raycast(Origin, v72, v70);

        if not v73 then
            debugLog("Raycast: iteration " .. i .. " hit nothing");

            return nil;
        end;

        if not v73.Instance or (not v73.Instance:IsA("BasePart") or v73.Instance.Transparency < 0.5) then
            local v74 = v73.Instance:GetFullName();
            local Position = v73.Position;
            local v75 = string.format("(%.4f, %.4f, %.4f)", Position.X, Position.Y, Position.Z);
            local Normal = v73.Normal;
            debugLog("Raycast: hit " .. v74 .. " at " .. v75 .. " normal=" .. string.format("(%.4f, %.4f, %.4f)", Normal.X, Normal.Y, Normal.Z));
            u24 = 0;
            local v76 = p67:SnapToGrid(v73.Position);
            local v77 = Vector3.new(v76.X, v76.Y + u17, v76.Z);
            debugLog("Raycast: finalPos=" .. string.format("(%.4f, %.4f, %.4f)", v77.X, v77.Y, v77.Z) .. " (yOffset=" .. string.format("%.4f", u17) .. ")");

            return v77;
        end;

        debugLog("Raycast: iteration " .. i .. " skipping transparent part: " .. v73.Instance:GetFullName() .. " transparency=" .. v73.Instance.Transparency);
        local Magnitude = (v73.Position - Origin).Magnitude;
        Origin = v73.Position + v71.Direction * 0.01;
        v72 = v71.Direction * (5000 - Magnitude - 0.01);
        local v78 = table.clone(v70.FilterDescendantsInstances);
        table.insert(v78, v73.Instance);
        v70.FilterDescendantsInstances = v78;
    end;

    return nil;
end;

function v1.GetPlacementPosition(p79) -- Line: 280
    -- upvalues: UserInputService (copy)
    local v80 = UserInputService:GetMouseLocation();

    return p79:GetPlacementPositionFromScreen(v80.X, v80.Y);
end;

function v1.CreatePreview(p81, p82) -- Line: 285
    -- upvalues: Props (copy), u17 (ref), debugLog (copy), u2 (ref)
    local v83 = Props:FindFirstChild(p82);

    if not v83 then
        return nil;
    end;

    local v84 = v83:Clone();

    for _, descendant in v84:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 0.5;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = true;
        end;
    end;

    v84.Name = "PropPreview";
    v84.Parent = workspace;
    u17 = p81:CalculateYOffset(v84);
    debugLog("CreatePreview: propName=" .. p82 .. " yOffset=" .. string.format("%.4f", u17));

    if u2 then
        for _, descendant in v84:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = 1;
            end;
        end;
    end;

    return v84;
end;

function v1.CreateSelectionBox(p85, p86) -- Line: 320
    -- upvalues: u2 (ref)
    local SelectionBox = Instance.new("SelectionBox");
    SelectionBox.Color3 = Color3.fromRGB(0, 255, 0);
    SelectionBox.LineThickness = 0.05;
    SelectionBox.Transparency = 0.3;
    SelectionBox.Adornee = p86;
    SelectionBox.Parent = p86;

    if u2 then
        SelectionBox.Visible = false;
    end;

    return SelectionBox;
end;

function v1.UpdatePreview(p87) -- Line: 335
    -- upvalues: u2 (ref), u7 (ref), u15 (ref), u8 (ref)
    debug.profilebegin("Controllers/PropController/UpdatePreview");

    if u2 then
        debug.profileend();

        return;
    end;

    if not (u7 and u7.PrimaryPart) then
        debug.profileend();

        return;
    end;

    local v88 = p87:GetPlacementPosition();

    if not v88 then
        debug.profileend();

        return;
    end;

    local v89 = p87:GetGardenRotationY();
    local v90 = CFrame.Angles(0, v89 + math.rad(u15), 0);
    u7:PivotTo(CFrame.new(v88) * v90);

    if u8 then
        u8.Color3 = p87:CanPlace() and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0);
    end;

    debug.profileend();
end;

function v1.CanPlace(p91) -- Line: 364
    -- upvalues: u7 (ref)
    if p91:GetPlayerPlotFolder() then
        return u7 and u7.PrimaryPart and true or false;
    end;

    return false;
end;

function v1.IsPlacing(p92) -- Line: 371
    -- upvalues: u6 (ref)
    return u6;
end;

function v1.GetCurrentPropName(p93) -- Line: 375
    -- upvalues: u14 (ref)
    return u14;
end;

function v1.UnequipTool(p94) -- Line: 379
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v95 = Character and Character:FindFirstChildOfClass("Humanoid");

    if v95 then
        v95:UnequipTools();
    end;
end;

function v1.OnPlacementInput(p96, p97, p98) -- Line: 389
    -- upvalues: u6 (ref), u2 (ref), u19 (copy)
    if not u6 then
        return;
    end;

    if u2 then
        if p97.UserInputType == Enum.UserInputType.Touch then
            u19[p97] = {
                startTime = tick(),
                startPos = p97.Position
            };
        end;

        return;
    end;

    if p98 then
        return;
    end;

    if p97.UserInputType == Enum.UserInputType.MouseButton1 and true or p97.KeyCode == Enum.KeyCode.ButtonR2 then
        p96:PlaceProp();

        return;
    end;

    if p97.KeyCode ~= Enum.KeyCode.R and p97.KeyCode ~= Enum.KeyCode.ButtonR1 then
        return;
    end;

    p96:RotateProp(45);
end;

function v1.OnPlacementInputEnded(p99, p100, p101) -- Line: 418
    -- upvalues: u6 (ref), u2 (ref), u19 (copy)
    if not u6 then
        return;
    end;

    if not u2 then
        return;
    end;

    if p100.UserInputType ~= Enum.UserInputType.Touch then
        return;
    end;

    local v102 = u19[p100];
    u19[p100] = nil;

    if not v102 then
        return;
    end;

    local v103 = tick() - v102.startTime;

    if v103 > 0.3 then
        return;
    end;

    if (p100.Position - v102.startPos).Magnitude > 30 then
        return;
    end;

    local Position = p100.Position;

    if p99:IsTouchInJoystickZone((Vector2.new(Position.X, Position.Y))) then
        return;
    end;

    p99:PlacePropAtScreen(Position.X, Position.Y);
end;

function v1.StartPlacement(u104, p105) -- Line: 450
    -- upvalues: u6 (ref), u13 (ref), u14 (ref), u15 (ref), u7 (ref), u8 (ref), debugLog (copy), u9 (ref), RunService (copy), u10 (ref), UserInputService (copy), u2 (ref), u11 (ref), u12 (ref), u23 (copy), u20 (copy)
    if u6 then
        u104:StopPlacement();
    end;

    if not u13 then
        return;
    end;

    u6 = true;
    u14 = p105;
    u15 = 0;
    u7 = u104:CreatePreview(p105);

    if not u7 then
        u6 = false;

        return;
    end;

    u8 = u104:CreateSelectionBox(u7);
    u104:CreateGrid();
    local v106 = u104:GetSpawnPoint();

    if v106 then
        local CFrame2 = v106.CFrame;
        local v107, v108, v109 = CFrame2:ToEulerAnglesYXZ();
        local Position = CFrame2.Position;
        debugLog("StartPlacement: spawnPoint=" .. string.format("pos=%s rot=(%.2f, %.2f, %.2f)deg", string.format("(%.4f, %.4f, %.4f)", Position.X, Position.Y, Position.Z), math.deg(v107), math.deg(v108), (math.deg(v109))));
        local format = string.format;
        local v110 = u104:GetGardenRotationY();
        debugLog("StartPlacement: gardenRotY=" .. format("%.4f deg", (math.deg(v110))));
    else
        debugLog("StartPlacement: WARNING spawnPoint is nil!");
    end;

    u9 = RunService.RenderStepped:Connect(function() -- Line: 481
        -- upvalues: u104 (copy)
        debug.profilebegin("Controllers/PropController/PreviewUpdate");
        u104:UpdatePreview();
        debug.profileend();
    end);
    u10 = UserInputService.InputBegan:Connect(function(p111, p112) -- Line: 487
        -- upvalues: u104 (copy)
        u104:OnPlacementInput(p111, p112);
    end);

    if u2 then
        u11 = UserInputService.InputEnded:Connect(function(p113, p114) -- Line: 492
            -- upvalues: u104 (copy)
            u104:OnPlacementInputEnded(p113, p114);
        end);
    end;

    if u13 then
        u12 = u13.AttributeChanged:Connect(function(p115) -- Line: 498
            -- upvalues: u13 (ref), u104 (copy), u23 (ref), u14 (ref)
            if p115 == "RemainingCount" then
                local v116 = u13:GetAttribute("RemainingCount");

                if v116 and v116 <= 0 then
                    u104:StopPlacement();
                    u104:UnequipTool();

                    for _, v in u23 do
                        task.spawn(v, u14);
                    end;
                end;
            end;
        end);
    end;

    for _, v in u20 do
        task.spawn(v, p105);
    end;
end;

function v1.StopPlacement(p117) -- Line: 518
    -- upvalues: u6 (ref), u14 (ref), u15 (ref), u17 (ref), u19 (copy), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u8 (ref), u7 (ref), u21 (copy)
    local v118 = u6;
    local v119 = u14;
    u6 = false;
    u14 = nil;
    u15 = 0;
    u17 = 0;
    table.clear(u19);

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    p117:DestroyGrid();

    if u8 then
        u8:Destroy();
        u8 = nil;
    end;

    if u7 then
        u7:Destroy();
        u7 = nil;
    end;

    if v118 then
        for _, v in u21 do
            task.spawn(v, v119);
        end;
    end;
end;

function v1.GetGardenRotationY(p120) -- Line: 569
    local v121 = p120:GetSpawnPoint();

    if not v121 then
        return 0;
    end;

    local _, v122, _ = v121.CFrame:ToEulerAnglesYXZ();

    return v122;
end;

function v1.RotateProp(p123, p124) -- Line: 576
    -- upvalues: u15 (ref)
    u15 = (u15 + p124) % 360;
end;

function v1.CreateGrid(p125) -- Line: 580
    -- upvalues: debugLog (copy), CollectionService (copy), u18 (ref)
    p125:DestroyGrid();
    local v126 = p125:GetSpawnPoint();
    local v127 = p125:GetPlayerPlotFolder();

    if not v126 then
        debugLog("CreateGrid: ABORT - no spawnPoint");

        return;
    end;

    if not v127 then
        debugLog("CreateGrid: ABORT - no plot");

        return;
    end;

    local CFrame2 = v126.CFrame;
    local v128, v129, v130 = CFrame2:ToEulerAnglesYXZ();
    local Position = CFrame2.Position;
    debugLog("CreateGrid: spawnPoint=" .. string.format("pos=%s rot=(%.2f, %.2f, %.2f)deg", string.format("(%.4f, %.4f, %.4f)", Position.X, Position.Y, Position.Z), math.deg(v128), math.deg(v129), (math.deg(v130))));
    local v131 = nil;

    for _, descendant in v127:GetDescendants() do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "PropArea") then
            v131 = descendant;
            break;
        end;
    end;

    if not v131 then
        debugLog("CreateGrid: ABORT - no PropArea found in plot descendants");
        debugLog("CreateGrid: listing plot descendants with tags:");

        for _, descendant in v127:GetDescendants() do
            if descendant:IsA("BasePart") then
                local v132 = CollectionService:GetTags(descendant);

                if #v132 > 0 then
                    debugLog("  " .. descendant:GetFullName() .. " tags=" .. table.concat(v132, ","));
                end;
            end;
        end;

        return;
    end;

    debugLog("CreateGrid: propArea=" .. v131:GetFullName());
    local Size = v131.Size;
    debugLog("CreateGrid: propArea.Size=" .. string.format("(%.4f, %.4f, %.4f)", Size.X, Size.Y, Size.Z));
    local CFrame3 = v131.CFrame;
    local v133, v134, v135 = CFrame3:ToEulerAnglesYXZ();
    local Position2 = CFrame3.Position;
    debugLog("CreateGrid: propArea.CFrame=" .. string.format("pos=%s rot=(%.2f, %.2f, %.2f)deg", string.format("(%.4f, %.4f, %.4f)", Position2.X, Position2.Y, Position2.Z), math.deg(v133), math.deg(v134), (math.deg(v135))));
    debugLog("CreateGrid: propArea.Transparency=" .. v131.Transparency);
    local Folder = Instance.new("Folder");
    Folder.Name = "PlacementGrid";
    local v136 = v126.CFrame:PointToObjectSpace(v131.Position);
    local v137 = v131.Size.X / 2 + 0.5;
    local v138 = v131.Size.Z / 2 + 0.5;
    debugLog("CreateGrid: areaLocalCenter=" .. string.format("(%.4f, %.4f, %.4f)", v136.X, v136.Y, v136.Z));
    debugLog("CreateGrid: halfX=" .. v137 .. " halfZ=" .. v138);
    local v139 = math.ceil((v136.X - v137) / 0.5) * 0.5;
    local v140 = math.floor((v136.X + v137) / 0.5) * 0.5;
    local v141 = math.ceil((v136.Z - v138) / 0.5) * 0.5;
    local v142 = math.floor((v136.Z + v138) / 0.5) * 0.5;
    debugLog("CreateGrid: grid bounds local X=[" .. v139 .. ", " .. v140 .. "] Z=[" .. v141 .. ", " .. v142 .. "]");
    local v143 = v131.Position.Y + v131.Size.Y / 2 + 0.05;
    debugLog("CreateGrid: gridY=" .. string.format("%.4f", v143));
    local v144 = v140 - v139;
    local v145 = v142 - v141;

    if v144 <= 0 or v145 <= 0 then
        debugLog("CreateGrid: ABORT - zero or negative grid dimensions: xLength=" .. v144 .. " zLength=" .. v145);

        return;
    end;

    local v146 = (v139 + v140) / 2;
    local v147 = (v141 + v142) / 2;
    local v148 = Color3.fromRGB(0, 170, 255);
    local _, v149, _ = v126.CFrame:ToEulerAnglesYXZ();
    local v150 = 0;

    for i = 0, math.round((v142 - v141) / 0.5) do
        local v151 = v126.CFrame:PointToWorldSpace((Vector3.new(v146, 0, v141 + i * 0.5)));
        local v152 = Vector3.new(v151.X, v143, v151.Z);
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = v148;
        Part.Transparency = 0.5;
        Part.Size = Vector3.new(v144, 0.1, 0.1);
        Part.CFrame = CFrame.new(v152) * CFrame.Angles(0, v149, 0);
        Part.Parent = Folder;
        v150 = v150 + 1;
    end;

    for i = 0, math.round((v140 - v139) / 0.5) do
        local v153 = v126.CFrame:PointToWorldSpace((Vector3.new(v139 + i * 0.5, 0, v147)));
        local v154 = Vector3.new(v153.X, v143, v153.Z);
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = v148;
        Part.Transparency = 0.5;
        Part.Size = Vector3.new(0.1, 0.1, v145);
        Part.CFrame = CFrame.new(v154) * CFrame.Angles(0, v149, 0);
        Part.Parent = Folder;
        v150 = v150 + 1;
    end;

    debugLog("CreateGrid: created " .. v150 .. " grid lines");
    Folder.Parent = workspace;
    u18 = Folder;
    debugLog("CreateGrid: done, folder parented to workspace");
end;

function v1.DestroyGrid(p155) -- Line: 711
    -- upvalues: u18 (ref)
    if u18 then
        u18:Destroy();
        u18 = nil;
    end;
end;

function v1.PlacePropAtScreen(p156, p157, p158) -- Line: 718
    -- upvalues: u6 (ref), u7 (ref), u14 (ref), u15 (ref), u13 (ref), debugLog (copy), Networking (copy), PlayPlaceSFX (copy), u22 (copy)
    if not (u6 and (u7 and u14)) then
        return;
    end;

    local v159 = p156:GetPlacementPositionFromScreen(p157, p158);

    if not v159 then
        return;
    end;

    local v160 = p156:GetGardenRotationY();
    local v161 = CFrame.Angles(0, v160 + math.rad(u15), 0);
    u7:PivotTo(CFrame.new(v159) * v161);

    if not p156:CanPlace() then
        return;
    end;

    local v162 = u13;

    if not v162 then
        return;
    end;

    local v163 = u14;
    local v164 = math.deg(v160) + u15;
    debugLog("PlacePropAtScreen: pos=" .. string.format("(%.4f, %.4f, %.4f)", v159.X, v159.Y, v159.Z) .. " gardenRotY=" .. string.format("%.2f", (math.deg(v160))) .. " currentRot=" .. u15 .. " worldRot=" .. string.format("%.2f", v164));
    Networking.Prop.PlaceProp:Fire(v159, v163, v162, v164);
    PlayPlaceSFX();

    for _, v in u22 do
        task.spawn(v, v163, v159, v164);
    end;
end;

function v1.PlaceProp(p165) -- Line: 755
    -- upvalues: u6 (ref), u7 (ref), u14 (ref), u13 (ref), u15 (ref), debugLog (copy), Networking (copy), PlayPlaceSFX (copy), u22 (copy)
    if not (u6 and (u7 and u14)) then
        return;
    end;

    if not p165:CanPlace() then
        return;
    end;

    local v166 = p165:GetPlacementPosition();

    if not v166 then
        return;
    end;

    local v167 = u13;

    if not v167 then
        return;
    end;

    local v168 = u14;
    local v169 = p165:GetGardenRotationY();
    local v170 = math.deg(v169) + u15;
    debugLog("PlaceProp: pos=" .. string.format("(%.4f, %.4f, %.4f)", v166.X, v166.Y, v166.Z) .. " gardenRotY=" .. string.format("%.2f", (math.deg(v169))) .. " currentRot=" .. u15 .. " worldRot=" .. string.format("%.2f", v170));
    Networking.Prop.PlaceProp:Fire(v166, v168, v167, v170);
    PlayPlaceSFX();

    for _, v in u22 do
        task.spawn(v, v168, v166, v170);
    end;
end;

function v1.OnPlacementStarted(p171, p172) -- Line: 779
    -- upvalues: u20 (copy)
    table.insert(u20, p172);
end;

function v1.OnPlacementStopped(p173, p174) -- Line: 783
    -- upvalues: u21 (copy)
    table.insert(u21, p174);
end;

function v1.OnPropPlaced(p175, p176) -- Line: 787
    -- upvalues: u22 (copy)
    table.insert(u22, p176);
end;

function v1.OnOutOfProps(p177, p178) -- Line: 791
    -- upvalues: u23 (copy)
    table.insert(u23, p178);
end;

return v1;