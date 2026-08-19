-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 8
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local FruitIdentity = require(ReplicatedStorage.SharedModules.FruitIdentity);
local PotScale = require(ReplicatedStorage.SharedModules.PotScale);
local PlacementGrid = require(ReplicatedStorage.ClientModules.PlacementGrid);
local NotificationController = require(script.Parent.NotificationController);
local LocalPlayer = Players.LocalPlayer;
local Gardens = workspace:WaitForChild("Gardens");
local POT = ReplicatedStorage.Assets.POT;
local Plants = ReplicatedStorage.PlantGenerationModules.Plants;
local Fruits = ReplicatedStorage.PlantGenerationModules.Fruits;
local u2 = false;
local u3 = 0;
local u4 = nil;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = false;
local u12 = nil;
local u13 = nil;
local u14 = RaycastParams.new();
u14.FilterType = Enum.RaycastFilterType.Exclude;

local function GetPlayerPlot() -- Line: 62
    -- upvalues: LocalPlayer (copy), Gardens (copy)
    local v15 = LocalPlayer:GetAttribute("PlotId");

    if v15 then
        return Gardens:FindFirstChild("Plot" .. tostring(v15));
    end;

    return nil;
end;

local function GetSpawnPoint() -- Line: 69
    -- upvalues: LocalPlayer (copy), Gardens (copy)
    local v16 = LocalPlayer:GetAttribute("PlotId");
    local v17;

    if v16 then
        v17 = Gardens:FindFirstChild("Plot" .. tostring(v16));
    else
        v17 = nil;
    end;

    if v17 then
        return v17:FindFirstChild("SpawnPoint");
    end;

    return nil;
end;

local function IsTouchInput() -- Line: 77
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled;
end;

local function BuildPropAreaCache() -- Line: 82
    -- upvalues: LocalPlayer (copy), Gardens (copy), u8 (ref), CollectionService (copy)
    local v18 = LocalPlayer:GetAttribute("PlotId");
    local v19;

    if v18 then
        v19 = Gardens:FindFirstChild("Plot" .. tostring(v18));
    else
        v19 = nil;
    end;

    if not v19 then
        u8 = nil;

        return;
    end;

    local v20 = {};

    for _, descendant in v19:GetDescendants() do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "PropArea") then
            table.insert(v20, descendant);
        end;
    end;

    u8 = v20;
end;

local function IsPositionInPropArea(p21) -- Line: 98
    -- upvalues: u8 (ref)
    local v22 = u8;

    if not v22 then
        return false;
    end;

    for _, v in v22 do
        local v23 = v.CFrame:PointToObjectSpace(p21);
        local v24 = v.Size * 0.5;

        if math.abs(v23.X) <= v24.X + 0.5 and math.abs(v23.Z) <= v24.Z + 0.5 then
            return true;
        end;
    end;

    return false;
end;

local function UpdateRaycastParams(p25) -- Line: 112
    -- upvalues: LocalPlayer (copy), u14 (copy)
    local v26 = {};
    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v26, Character);
    end;

    if p25 then
        table.insert(v26, p25);
    end;

    u14.FilterDescendantsInstances = v26;

    return u14;
end;

local function RaycastFromMouse(p27, p28) -- Line: 128
    -- upvalues: LocalPlayer (copy), u14 (copy), UserInputService (copy), CollectionService (copy)
    local v29 = {};
    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v29, Character);
    end;

    if p27 then
        table.insert(v29, p27);
    end;

    u14.FilterDescendantsInstances = v29;
    local v30 = u14;
    local CurrentCamera = workspace.CurrentCamera;
    local v31 = p28 or UserInputService:GetMouseLocation();
    local v32 = CurrentCamera:ViewportPointToRay(v31.X, v31.Y);
    local v33 = table.clone(v30.FilterDescendantsInstances);

    for _ = 1, 10 do
        local v34 = workspace:Raycast(v32.Origin, v32.Direction * 900, v30);

        if not v34 then
            return nil;
        end;

        local v35 = (CollectionService:HasTag(v34.Instance, "PropArea") or CollectionService:HasTag(v34.Instance, "PlantArea")) and math.abs(v34.Normal.Y) < 0.1;

        if v34.Instance.Transparency <= 0 and not v35 then
            return v34;
        end;

        table.insert(v33, v34.Instance);
        v30.FilterDescendantsInstances = v33;
    end;

    return nil;
end;

local function UpdatePreviewColor(p36) -- Line: 156
    -- upvalues: u4 (ref)
    if not u4 then
        return;
    end;

    local SelectionBox = u4:FindFirstChild("SelectionBox");

    if SelectionBox and SelectionBox:IsA("SelectionBox") then
        SelectionBox.Color3 = p36 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0);
    end;
end;

local function CreateSelectionBox() -- Line: 165
    -- upvalues: u4 (ref)
    if not (u4 and u4.PrimaryPart) then
        return;
    end;

    local SelectionBox = Instance.new("SelectionBox");
    SelectionBox.Name = "SelectionBox";
    SelectionBox.Color3 = Color3.fromRGB(0, 255, 0);
    SelectionBox.LineThickness = 0.03;
    SelectionBox.Transparency = 0.3;
    SelectionBox.Adornee = u4.PrimaryPart;
    SelectionBox.Parent = u4;
end;

local function StopRotateHold() -- Line: 177
    -- upvalues: u9 (ref)
    if u9 then
        task.cancel(u9);
        u9 = nil;
    end;
end;

local function StartRotateHold() -- Line: 185
    -- upvalues: u9 (ref), u3 (ref)
    if u9 then
        task.cancel(u9);
        u9 = nil;
    end;

    u9 = task.spawn(function() -- Line: 187
        -- upvalues: u3 (ref)
        task.wait(1);

        while true do
            u3 = (u3 + 15) % 360;
            task.wait(0.08);
        end;
    end);
end;

local u37 = nil;

local function HideHeldVisual() -- Line: 200
    -- upvalues: u37 (ref), u13 (ref), LocalPlayer (copy), u11 (ref), u2 (ref)
    if u37 then
        u37:Disconnect();
        u37 = nil;
    end;

    for _, child in u13:GetChildren() do
        if child:GetAttribute("Owner") == LocalPlayer.UserId then
            for _, descendant in child:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    if not descendant:GetAttribute("OriginalTransparency") then
                        descendant:SetAttribute("OriginalTransparency", descendant.Transparency);
                    end;

                    descendant.Transparency = 1;
                end;
            end;

            u11 = true;

            return;
        end;
    end;

    u37 = u13.ChildAdded:Connect(function(u38) -- Line: 224
        -- upvalues: u2 (ref), u37 (ref), LocalPlayer (ref), u11 (ref)
        if not u2 then
            u37:Disconnect();
            u37 = nil;

            return;
        end;

        if u38:GetAttribute("Owner") ~= LocalPlayer.UserId then
            return;
        end;

        u37:Disconnect();
        u37 = nil;
        task.defer(function() -- Line: 234
            -- upvalues: u38 (copy), u2 (ref), u11 (ref)
            for _, descendant in u38:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    if not descendant:GetAttribute("OriginalTransparency") then
                        descendant:SetAttribute("OriginalTransparency", descendant.Transparency);
                    end;

                    descendant.Transparency = 1;
                end;
            end;

            u38.DescendantAdded:Connect(function(p39) -- Line: 244
                -- upvalues: u2 (ref), u11 (ref)
                if not (u2 and u11) then
                    return;
                end;

                if p39:IsA("BasePart") or p39:IsA("Decal") then
                    if not p39:GetAttribute("OriginalTransparency") then
                        p39:SetAttribute("OriginalTransparency", p39.Transparency);
                    end;

                    p39.Transparency = 1;
                end;
            end);
            u11 = true;
        end);
    end);
end;

local function ShowHeldVisual() -- Line: 258
    -- upvalues: u37 (ref), u11 (ref), u13 (ref), LocalPlayer (copy)
    if u37 then
        u37:Disconnect();
        u37 = nil;
    end;

    if not u11 then
        return;
    end;

    u11 = false;

    for _, child in u13:GetChildren() do
        if child:GetAttribute("Owner") == LocalPlayer.UserId then
            for _, descendant in child:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    descendant.Transparency = descendant:GetAttribute("OriginalTransparency") or 0;
                    descendant:SetAttribute("OriginalTransparency", nil);
                end;
            end;

            return;
        end;
    end;
end;

local function RebuildPreviewVisualPartsCache() -- Line: 284
    -- upvalues: u4 (ref), u12 (ref)
    if not u4 then
        u12 = nil;

        return;
    end;

    local v40 = {};

    for _, descendant in u4:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            table.insert(v40, descendant);
        end;
    end;

    u12 = v40;
end;

local function BuildPreview(p41) -- Line: 299
    -- upvalues: u4 (ref), POT (copy), PotScale (copy), ReplicatedStorage (copy), Plants (copy), Fruits (copy), FruitIdentity (copy), RebuildPreviewVisualPartsCache (copy)
    if u4 then
        u4:Destroy();
        u4 = nil;
    end;

    local v42 = p41:GetAttribute("PlantName");
    local v43 = p41:GetAttribute("Seed");
    local v44 = p41:GetAttribute("SizeMultiplier") or 1;
    local _ = p41:GetAttribute("Age") or 0;
    local v45 = p41:GetAttribute("MaxAge") or 100;
    local v46 = p41:GetAttribute("Mutation");
    local v47 = POT:Clone();
    v47.Name = "PottedPlantPreview";
    v47:ScaleTo(v44 * PotScale.Get(v42));

    for _, descendant in v47:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 0.5;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = true;
        end;
    end;

    if v42 and v43 then
        local v48 = ReplicatedStorage.Assets.Plants:FindFirstChild(v42);
        local v49 = Plants:FindFirstChild(v42);
        local v50;

        if v48 then
            v50 = false;
        else
            v48 = ReplicatedStorage.Assets.Fruits:FindFirstChild(v42);
            v49 = Fruits:FindFirstChild(v42);
            v50 = true;
        end;

        if v48 and v49 then
            local v51 = require(v49);
            local v52 = v48:Clone();
            v52:SetAttribute("Age", v45);
            v52:SetAttribute("MaxAge", v45);

            if v46 and v46 ~= "" then
                v52:SetAttribute("Mutation", v46);
            end;

            v52.Parent = workspace;
            (v50 and v51.InitFruit or v51.InitPlant)(v52, v43, v44, p41:GetAttribute("PlantedAt") or os.time());
            local v53 = 0;

            repeat
                v53 = v53 + task.wait();
            until v52:HasTag("InitializationComplete") or v53 > 5;

            (v50 and v51.BeginFruitGrowth or v51.BeginPlantGrowth)(v52);
            task.wait();

            for _, descendant in v52:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                    descendant.Transparency = 0.5;
                    descendant.CanCollide = false;
                    descendant.CanQuery = false;
                    descendant.CanTouch = false;
                    descendant.Anchored = true;
                end;
            end;

            local PlantRoot = v47:FindFirstChild("PlantRoot", true);

            if PlantRoot then
                local PrimaryPart = v52.PrimaryPart;
                local v54 = PrimaryPart and PrimaryPart.Position.Y - PrimaryPart.Size.Y / 2 or v52:GetPivot().Position.Y;

                for _, descendant in v52:GetDescendants() do
                    if descendant:IsA("BasePart") and (descendant.Transparency < 1 and descendant.Size.Y > 0.01) then
                        local v55 = descendant.Position.Y - descendant.Size.Y / 2;

                        if v55 < v54 then
                            v54 = v55;
                        end;
                    end;
                end;

                local v56 = v52:GetPivot().Position.Y - v54;
                local Position = PlantRoot.WorldCFrame.Position;
                v52:PivotTo(CFrame.new(Position.X, Position.Y + v56, Position.Z));
            end;

            local Fruits2 = ReplicatedStorage.Assets.Fruits;
            local FruitSpawnLocations = v52:FindFirstChild("FruitSpawnLocations");
            local u57 = p41:GetAttribute("SavedFruitsJSON");

            if FruitSpawnLocations and (u57 and u57 ~= "") then
                local success, result = pcall(function() -- Line: 399
                    -- upvalues: u57 (copy)
                    return game:GetService("HttpService"):JSONDecode(u57);
                end);

                if success and (result and #result > 0) then
                    local v58 = FruitIdentity.ResolveFruitName(v42);
                    local v59 = FruitIdentity.GetVisualScale(v42);
                    local v60 = Fruits2:FindFirstChild(v58);
                    local v61 = Fruits:FindFirstChild(v58);

                    if v60 and v61 then
                        local v62 = require(v61);

                        for _, v in result do
                            local v63 = FruitSpawnLocations:FindFirstChild((tostring(v.SpawnLocationIndex))) or FruitSpawnLocations:GetChildren()[v.SpawnLocationIndex];

                            if v63 then
                                local v64 = v60:Clone();
                                v64:SetAttribute("Age", v45);
                                v64:SetAttribute("MaxAge", v45);

                                if v.Mutation and v.Mutation ~= "" then
                                    v64:SetAttribute("Mutation", v.Mutation);
                                end;

                                v64.Parent = workspace;
                                v64:SetAttribute("PlantSeed", v43);
                                v62.InitFruit(v64, v.Seed, (v.SizeMultiplier or 1) * v59);
                                local v65 = 0;

                                repeat
                                    v65 = v65 + task.wait();
                                until v64:HasTag("InitializationComplete") or v65 > 5;

                                v62.BeginFruitGrowth(v64);
                                task.wait();

                                if v.OvertimeGrowth and v.OvertimeGrowth > 1 then
                                    v64:ScaleTo(v.OvertimeGrowth);
                                end;

                                for _, descendant in v64:GetDescendants() do
                                    if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                                        descendant.Transparency = 0.5;
                                        descendant.CanCollide = false;
                                        descendant.CanQuery = false;
                                        descendant.CanTouch = false;
                                        descendant.Anchored = true;
                                    end;
                                end;

                                v64:PivotTo(v63.CFrame);
                                v64.Parent = v47;
                            end;
                        end;
                    end;
                end;
            end;

            v52.Parent = v47;
        end;
    end;

    v47.Parent = workspace;
    u4 = v47;

    if u4 and u4.PrimaryPart then
        local SelectionBox = Instance.new("SelectionBox");
        SelectionBox.Name = "SelectionBox";
        SelectionBox.Color3 = Color3.fromRGB(0, 255, 0);
        SelectionBox.LineThickness = 0.03;
        SelectionBox.Transparency = 0.3;
        SelectionBox.Adornee = u4.PrimaryPart;
        SelectionBox.Parent = u4;
    end;

    RebuildPreviewVisualPartsCache();
end;

local function UpdatePreviewVisibility() -- Line: 476
    -- upvalues: u4 (ref), LocalPlayer (copy), u12 (ref), RebuildPreviewVisualPartsCache (copy), HideHeldVisual (copy), ShowHeldVisual (copy)
    if not u4 then
        return;
    end;

    local v66 = LocalPlayer:GetAttribute("IsInOwnGarden");
    local v67 = v66 and 0.5 or 1;
    local v68 = u12;

    if not v68 then
        RebuildPreviewVisualPartsCache();
        v68 = u12;
    end;

    if v68 then
        for _, v in v68 do
            if v.Parent then
                if v:IsA("BasePart") then
                    v.Transparency = v67;
                elseif v:IsA("Decal") then
                    v.Transparency = v67;
                end;
            end;
        end;
    end;

    local SelectionBox = u4:FindFirstChild("SelectionBox");

    if SelectionBox and SelectionBox:IsA("SelectionBox") then
        SelectionBox.Visible = v66;
    end;

    if v66 then
        HideHeldVisual();

        return;
    end;

    ShowHeldVisual();
end;

local function UpdatePreview(p69) -- Line: 517
    -- upvalues: u4 (ref), LocalPlayer (copy), UpdatePreviewVisibility (copy), RaycastFromMouse (copy), Gardens (copy), PlacementGrid (copy), u6 (ref), u3 (ref), u5 (ref), IsPositionInPropArea (copy), UpdatePreviewColor (copy)
    if not (u4 and u4.PrimaryPart) then
        return;
    end;

    if not LocalPlayer:GetAttribute("IsInOwnGarden") then
        UpdatePreviewVisibility();

        return;
    end;

    local v70 = RaycastFromMouse(u4, p69);

    if not v70 then
        return;
    end;

    local v71 = LocalPlayer:GetAttribute("PlotId");
    local v72;

    if v71 then
        v72 = Gardens:FindFirstChild("Plot" .. tostring(v71));
    else
        v72 = nil;
    end;

    local v73;

    if v72 then
        v73 = v72:FindFirstChild("SpawnPoint");
    else
        v73 = nil;
    end;

    local v74;

    if v73 and math.abs(v70.Normal.Y) > 0.1 then
        v74 = PlacementGrid.SnapToGrid(v70.Position, v73, 0.5);
    else
        local v75 = math.floor(v70.Position.X / 0.5 + 0.5) * 0.5;
        local Y = v70.Position.Y;
        local v76 = math.floor(v70.Position.Z / 0.5 + 0.5) * 0.5;
        v74 = Vector3.new(v75, Y, v76);
    end;

    u6 = v74;
    local v77 = v73 and PlacementGrid.GetGardenRotationY(v73) or 0;
    u4:PivotTo((PlacementGrid.PositionModel(u4, v74, v77, u3)));
    u5 = IsPositionInPropArea(v74);
    UpdatePreviewColor(u5);
    UpdatePreviewVisibility();
end;

local function PlacePot() -- Line: 556
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), LocalPlayer (copy), NotificationController (copy), Gardens (copy), PlacementGrid (copy), u3 (ref), Networking (copy)
    if not (u4 and (u5 and (u6 and u7))) then
        return;
    end;

    if not LocalPlayer:GetAttribute("IsInOwnGarden") then
        NotificationController:CreateNotification("You must be in your garden to place this!");

        return;
    end;

    local v78 = LocalPlayer:GetAttribute("PlotId");
    local v79;

    if v78 then
        v79 = Gardens:FindFirstChild("Plot" .. tostring(v78));
    else
        v79 = nil;
    end;

    local v80;

    if v79 then
        v80 = v79:FindFirstChild("SpawnPoint");
    else
        v80 = nil;
    end;

    local v81 = v80 and PlacementGrid.GetGardenRotationY(v80) or 0;
    local v82 = math.deg(v81) + u3;
    Networking.PotPlacement.PlacePottedPlant:Fire(u6, v82, u7:GetAttribute("Id"));
end;

local function ClearConnections() -- Line: 579
    -- upvalues: u10 (ref)
    for _, v in u10 do
        v:Disconnect();
    end;

    u10 = {};
end;

local function ExitPlacementMode() -- Line: 585
    -- upvalues: u2 (ref), u9 (ref), u10 (ref), u8 (ref), u4 (ref), u12 (ref), u3 (ref), u6 (ref), u5 (ref)
    u2 = false;

    if u9 then
        task.cancel(u9);
        u9 = nil;
    end;

    for _, v in u10 do
        v:Disconnect();
    end;

    u10 = {};
    u8 = nil;

    if u4 then
        u4:Destroy();
        u4 = nil;
    end;

    u12 = nil;
    u3 = 0;
    u6 = nil;
    u5 = false;
end;

local function EnterPlacementMode(u83) -- Line: 601
    -- upvalues: u2 (ref), u9 (ref), u10 (ref), u8 (ref), u4 (ref), u12 (ref), u3 (ref), u6 (ref), u5 (ref), u7 (ref), BuildPreview (copy), BuildPropAreaCache (copy), RunService (copy), UpdatePreview (copy), UserInputService (copy), PlacePot (copy), LocalPlayer (copy), HideHeldVisual (copy), RebuildPreviewVisualPartsCache (copy), UpdatePreviewVisibility (copy)
    if u2 then
        u2 = false;

        if u9 then
            task.cancel(u9);
            u9 = nil;
        end;

        for _, v in u10 do
            v:Disconnect();
        end;

        u10 = {};
        u8 = nil;

        if u4 then
            u4:Destroy();
            u4 = nil;
        end;

        u12 = nil;
        u3 = 0;
        u6 = nil;
        u5 = false;
    end;

    u2 = true;
    u7 = u83;
    BuildPreview(u83);
    BuildPropAreaCache();
    table.insert(u10, RunService.RenderStepped:Connect(function() -- Line: 614
        -- upvalues: UpdatePreview (ref)
        UpdatePreview();
    end));
    table.insert(u10, u83.Activated:Connect(function() -- Line: 621
        -- upvalues: UserInputService (ref), u2 (ref), PlacePot (ref)
        if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
            return;
        end;

        if not u2 then
            return;
        end;

        PlacePot();
    end));
    table.insert(u10, UserInputService.InputBegan:Connect(function(p84, p85) -- Line: 628
        -- upvalues: u2 (ref), u3 (ref), u9 (ref), u10 (ref), u8 (ref), u4 (ref), u12 (ref), u6 (ref), u5 (ref)
        if p85 then
            return;
        end;

        if not u2 then
            return;
        end;

        if p84.KeyCode == Enum.KeyCode.R or p84.KeyCode == Enum.KeyCode.ButtonR1 then
            u3 = (u3 + 15) % 360;

            if u9 then
                task.cancel(u9);
                u9 = nil;
            end;

            u9 = task.spawn(function() -- Line: 187
                -- upvalues: u3 (ref)
                task.wait(1);

                while true do
                    u3 = (u3 + 15) % 360;
                    task.wait(0.08);
                end;
            end);

            return;
        end;

        if p84.KeyCode ~= Enum.KeyCode.Escape and p84.KeyCode ~= Enum.KeyCode.ButtonB then
            return;
        end;

        u2 = false;

        if u9 then
            task.cancel(u9);
            u9 = nil;
        end;

        for _, v in u10 do
            v:Disconnect();
        end;

        u10 = {};
        u8 = nil;

        if u4 then
            u4:Destroy();
            u4 = nil;
        end;

        u12 = nil;
        u3 = 0;
        u6 = nil;
        u5 = false;
    end));
    table.insert(u10, UserInputService.TouchTapInWorld:Connect(function(p86, p87) -- Line: 656
        -- upvalues: u2 (ref), UpdatePreview (ref), PlacePot (ref)
        if p87 then
            return;
        end;

        if not u2 then
            return;
        end;

        UpdatePreview(p86);
        PlacePot();
    end));
    table.insert(u10, UserInputService.InputEnded:Connect(function(p88) -- Line: 664
        -- upvalues: u9 (ref)
        if (p88.KeyCode == Enum.KeyCode.R or p88.KeyCode == Enum.KeyCode.ButtonR1) and u9 then
            task.cancel(u9);
            u9 = nil;
        end;
    end));
    local v89 = u83:GetPropertyChangedSignal("Parent");
    table.insert(u10, v89:Connect(function() -- Line: 671
        -- upvalues: u83 (copy), LocalPlayer (ref), u2 (ref), u9 (ref), u10 (ref), u8 (ref), u4 (ref), u12 (ref), u3 (ref), u6 (ref), u5 (ref)
        if u83.Parent ~= LocalPlayer.Character then
            u2 = false;

            if u9 then
                task.cancel(u9);
                u9 = nil;
            end;

            for _, v in u10 do
                v:Disconnect();
            end;

            u10 = {};
            u8 = nil;

            if u4 then
                u4:Destroy();
                u4 = nil;
            end;

            u12 = nil;
            u3 = 0;
            u6 = nil;
            u5 = false;
        end;
    end));

    if LocalPlayer:GetAttribute("IsInOwnGarden") then
        HideHeldVisual();
    end;

    local v90 = LocalPlayer:GetAttributeChangedSignal("IsInOwnGarden");
    table.insert(u10, v90:Connect(function() -- Line: 683
        -- upvalues: RebuildPreviewVisualPartsCache (ref), UpdatePreviewVisibility (ref), LocalPlayer (ref), BuildPropAreaCache (ref)
        RebuildPreviewVisualPartsCache();
        task.defer(UpdatePreviewVisibility);

        if LocalPlayer:GetAttribute("IsInOwnGarden") then
            BuildPropAreaCache();
        end;
    end));
end;

function v1.Init(p91) -- Line: 701
    -- upvalues: u13 (ref)
    u13 = workspace:WaitForChild("PottedPlantVisuals");
end;

function v1.Start(p92) -- Line: 705
    -- upvalues: EnterPlacementMode (copy), u2 (ref), u9 (ref), u10 (ref), u8 (ref), u4 (ref), u12 (ref), u3 (ref), u6 (ref), u5 (ref), LocalPlayer (copy), Networking (copy)
    local function SetupCharacter(u93) -- Line: 706
        -- upvalues: EnterPlacementMode (ref), u2 (ref), u9 (ref), u10 (ref), u8 (ref), u4 (ref), u12 (ref), u3 (ref), u6 (ref), u5 (ref)
        u93.ChildAdded:Connect(function(u94) -- Line: 708
            -- upvalues: u93 (copy), EnterPlacementMode (ref)
            if u94:IsA("Tool") and u94:GetAttribute("PottedPlant") then
                task.defer(function() -- Line: 710
                    -- upvalues: u94 (copy), u93 (ref), EnterPlacementMode (ref)
                    if u94.Parent == u93 then
                        EnterPlacementMode(u94);
                    end;
                end);
            end;
        end);
        u93.ChildRemoved:Connect(function(p95) -- Line: 719
            -- upvalues: u2 (ref), u9 (ref), u10 (ref), u8 (ref), u4 (ref), u12 (ref), u3 (ref), u6 (ref), u5 (ref)
            if p95:IsA("Tool") and p95:GetAttribute("PottedPlant") then
                u2 = false;

                if u9 then
                    task.cancel(u9);
                    u9 = nil;
                end;

                for _, v in u10 do
                    v:Disconnect();
                end;

                u10 = {};
                u8 = nil;

                if u4 then
                    u4:Destroy();
                    u4 = nil;
                end;

                u12 = nil;
                u3 = 0;
                u6 = nil;
                u5 = false;
            end;
        end);
    end;

    SetupCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait());
    LocalPlayer.CharacterAdded:Connect(SetupCharacter);
    Networking.PotPlacement.PottedPlantPlaced.OnClientEvent:Connect(function() -- Line: 731
        -- upvalues: u2 (ref), u9 (ref), u10 (ref), u8 (ref), u4 (ref), u12 (ref), u3 (ref), u6 (ref), u5 (ref)
        u2 = false;

        if u9 then
            task.cancel(u9);
            u9 = nil;
        end;

        for _, v in u10 do
            v:Disconnect();
        end;

        u10 = {};
        u8 = nil;

        if u4 then
            u4:Destroy();
            u4 = nil;
        end;

        u12 = nil;
        u3 = 0;
        u6 = nil;
        u5 = false;
    end);
end;

return v1;