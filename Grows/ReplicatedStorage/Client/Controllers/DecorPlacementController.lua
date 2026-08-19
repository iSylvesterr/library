-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local DecorAssets = require(ReplicatedStorage.Shared.Utility.DecorAssets);
local PetAssets = require(ReplicatedStorage.Shared.Utility.PetAssets);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local v1 = Knit.CreateController({
    Name = "DecorPlacementController"
});

local function getPartWorldExtentsXZ(p2) -- Line: 32
    local CFrame2 = p2.CFrame;
    local Size = p2.Size;

    return math.abs(CFrame2.RightVector.X) * Size.X / 2 + math.abs(CFrame2.UpVector.X) * Size.Y / 2 + math.abs(CFrame2.LookVector.X) * Size.Z / 2, math.abs(CFrame2.RightVector.Z) * Size.X / 2 + math.abs(CFrame2.UpVector.Z) * Size.Y / 2 + math.abs(CFrame2.LookVector.Z) * Size.Z / 2;
end;

local function isPositionOnPart(p3, p4) -- Line: 41
    -- upvalues: getPartWorldExtentsXZ (copy)
    local v5, v6 = getPartWorldExtentsXZ(p4);
    local v7;

    if math.abs(p3.X - p4.Position.X) <= v5 then
        v7 = math.abs(p3.Z - p4.Position.Z) <= v6;
    else
        v7 = false;
    end;

    return v7;
end;

local function modelFootprintAABB(p8) -- Line: 48
    local v9, v10 = p8:GetBoundingBox();
    local v11 = math.abs(v9.RightVector.X) * v10.X / 2 + math.abs(v9.UpVector.X) * v10.Y / 2 + math.abs(v9.LookVector.X) * v10.Z / 2;
    local v12 = math.abs(v9.RightVector.Z) * v10.X / 2 + math.abs(v9.UpVector.Z) * v10.Y / 2 + math.abs(v9.LookVector.Z) * v10.Z / 2;

    return v9.X - v11, v9.X + v11, v9.Z - v12, v9.Z + v12;
end;

local function aabbOverlap(p13, p14) -- Line: 57
    local v15;

    if p13[1] <= p14[2] and (p14[1] <= p13[2] and p13[3] <= p14[4]) then
        v15 = p14[3] <= p13[4];
    else
        v15 = false;
    end;

    return v15;
end;

local function getDecorBasePart(p16) -- Line: 62
    local v17 = p16.PrimaryPart or (p16:FindFirstChild("Base") or p16:FindFirstChild("MainPart"));

    if not (v17 and (v17:IsA("BasePart") and v17)) then
        v17 = nil;
    end;

    return v17;
end;

local function partWorldBottomY(p18) -- Line: 67
    local CFrame2 = p18.CFrame;
    local Size = p18.Size;
    local v19 = math.abs(CFrame2.RightVector.Y) * Size.X / 2 + math.abs(CFrame2.UpVector.Y) * Size.Y / 2 + math.abs(CFrame2.LookVector.Y) * Size.Z / 2;

    return CFrame2.Position.Y - v19;
end;

function v1.KnitStart(p20) -- Line: 78
    -- upvalues: Maid (copy), Players (copy), Knit (copy), RunService (copy), CustomEnum (copy), PetAssets (copy), DecorAssets (copy), partWorldBottomY (copy), getPartWorldExtentsXZ (copy), UserInputService (copy)
    local v21 = Maid.new();
    p20._maid = v21;
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local CurrentCamera = workspace.CurrentCamera;
    local u22 = LocalPlayer:GetMouse();
    local u23 = Knit.GetController("UserInputParser");

    local function isMobile() -- Line: 89
        -- upvalues: RunService (ref), u23 (copy), CustomEnum (ref)
        return RunService:IsStudio() and workspace:GetAttribute("debugForceMobile") and true or u23:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
    end;

    local u24 = Knit.GetService("PlayerPlotService");
    local KeybindHints = PlayerGui:WaitForChild("HUD"):WaitForChild("KeybindHints");
    KeybindHints.Visible = false;
    local u25 = nil;
    local u26 = nil;
    local u27 = 0;
    local u28 = nil;
    local u29 = nil;
    local u30 = {};
    local u31 = Maid.new();
    local u32 = nil;
    local u33 = nil;
    local u34 = nil;
    local u35 = nil;
    local u36 = 0;
    local identity = CFrame.identity;
    local u37 = false;
    local u38 = false;
    local u39 = nil;
    local u40 = nil;
    local u41 = nil;
    local u42 = false;
    local u43 = nil;
    local u44 = nil;
    local u45 = nil;

    local function findActiveDirt() -- Line: 132
        -- upvalues: u25 (ref)
        if not u25 then
            return nil;
        end;

        for _, v in { "Plot3", "Plot2", "Plot1" } do
            local v46 = u25:FindFirstChild(v);

            if v46 then
                v46 = v46:FindFirstChild("Dirt");
            end;

            if v46 and v46:IsA("BasePart") then
                return v46;
            end;
        end;

        return nil;
    end;

    local function applyDirt() -- Line: 142
        -- upvalues: u26 (ref), findActiveDirt (copy)
        u26 = findActiveDirt();
    end;

    local function setupPlot(p47) -- Line: 146
        -- upvalues: u25 (ref), u27 (ref), u26 (ref), findActiveDirt (copy)
        u25 = workspace:WaitForChild("BigField"):WaitForChild("PlayerPlots"):WaitForChild("PlayerPlot" .. p47);
        u27 = u27 + 1;
        u26 = findActiveDirt();

        if not u26 then
            local u48 = u27;
            task.spawn(function() -- Line: 154
                -- upvalues: u48 (copy), u27 (ref), u26 (ref), findActiveDirt (ref)
                for _ = 1, 50 do
                    task.wait(0.2);

                    if u48 ~= u27 then
                        return;
                    end;

                    u26 = findActiveDirt();

                    if u26 then
                        break;
                    end;
                end;
            end);
        end;
    end;

    v21:GiveTask(u24.PlotAssigned:Connect(function(p49) -- Line: 165
        -- upvalues: setupPlot (copy)
        setupPlot(p49);
    end));
    task.spawn(function() -- Line: 169
        -- upvalues: u24 (copy), setupPlot (copy)
        local v50, v51 = u24:GetMyPlot():await();

        if v50 and v51 then
            setupPlot(v51);
        end;
    end);

    local function getEquippedDecorTool() -- Line: 179
        -- upvalues: LocalPlayer (copy)
        local Character = LocalPlayer.Character;

        if not Character then
            return nil, nil;
        end;

        for _, child in Character:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("IsDecor") then
                return child, "Decor";
            end;
        end;

        return nil, nil;
    end;

    local function destroyGhost() -- Line: 192
        -- upvalues: u31 (copy), u39 (ref), u40 (ref), u41 (ref), u42 (ref), u44 (ref), u28 (ref), u29 (ref), u30 (ref), u37 (ref), u32 (ref), u33 (ref), u34 (ref), u35 (ref)
        u31:DoCleaning();

        if u39 then
            u39:Destroy();
        end;

        u39 = nil;
        u40 = nil;
        u41 = nil;
        u42 = false;
        u44 = nil;
        u28 = nil;
        u29 = nil;
        u30 = {};
        u37 = false;
        u32 = nil;
        u33 = nil;
        u34 = nil;
        u35 = nil;
    end;

    local u52 = Color3.fromRGB(255, 40, 40);

    local function setGhostState(p53) -- Line: 213
        -- upvalues: u30 (ref), u52 (copy), u29 (ref)
        for _, v in u30 do
            if p53 == "hidden" then
                v.part.Transparency = 1;
            else
                v.part.Transparency = v.transparency;
                v.part.Color = p53 == "invalid" and u52 or v.color;
            end;
        end;

        if not u29 then
            return;
        end;

        u29.Enabled = p53 ~= "hidden";

        if p53 ~= "invalid" then
            if p53 == "valid" then
                u29.FillColor = Color3.fromRGB(80, 230, 100);
                u29.FillTransparency = 0.6;
                u29.OutlineColor = Color3.fromRGB(150, 255, 170);
            end;

            return;
        end;

        u29.FillColor = Color3.fromRGB(255, 0, 0);
        u29.FillTransparency = 0.2;
        u29.OutlineColor = Color3.fromRGB(255, 40, 40);
    end;

    local function buildGhost(p54, p55, p56, p57) -- Line: 235
        -- upvalues: destroyGhost (copy), PetAssets (ref), DecorAssets (ref), identity (ref), u30 (ref), partWorldBottomY (ref), u31 (copy), u28 (ref), u29 (ref), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref)
        destroyGhost();
        local v58 = p57 == "Egg" and PetAssets.resolveEgg(p55) or DecorAssets.resolveTemplate(p54, p55);

        if not v58 then
            return;
        end;

        local v59 = v58:Clone();
        v59.Name = "DecorGhost";
        identity = v59:GetPivot().Rotation;
        u30 = {};

        for _, descendant in v59:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;

                if descendant.Name == "SpawnPart" or descendant.Transparency >= 1 then
                    local v60 = partWorldBottomY(descendant);
                    descendant.Transparency = 1;
                    descendant.Size = Vector3.new(0.05, 0.05, 0.05);
                    descendant.CFrame = descendant.CFrame.Rotation + Vector3.new(descendant.Position.X, v60 + 0.025, descendant.Position.Z);
                else
                    descendant.Transparency = math.max(descendant.Transparency, 0.4);
                    table.insert(u30, {
                        part = descendant,
                        transparency = descendant.Transparency,
                        color = descendant.Color
                    });
                end;
            end;

            if descendant:IsA("Script") or (descendant:IsA("LocalScript") or (descendant:IsA("ProximityPrompt") or descendant:IsA("Sound"))) then
                descendant:Destroy();
            end;
        end;

        local Highlight = Instance.new("Highlight");
        Highlight.FillTransparency = 0.6;
        Highlight.OutlineTransparency = 0;
        Highlight.Parent = v59;
        v59.Parent = workspace;
        u31:GiveTask(v59);
        u28 = v59;
        u29 = Highlight;
        u32 = p56;
        u33 = p54;
        u34 = p55;
        u35 = p57;
        u36 = 0;
    end;

    local function groundRaycastParams() -- Line: 295
        -- upvalues: LocalPlayer (copy), u28 (ref), u25 (ref)
        local v61 = { LocalPlayer.Character };

        if u28 then
            table.insert(v61, u28);
        end;

        if u25 then
            for _, child in u25:GetChildren() do
                if child:IsA("Model") and (child.Name:match("^PlotTree_") or child.Name:match("^PlotDecor_")) then
                    table.insert(v61, child);
                end;
            end;
        end;

        local v62 = RaycastParams.new();
        v62.FilterType = Enum.RaycastFilterType.Exclude;
        v62.FilterDescendantsInstances = v61;

        return v62;
    end;

    local function raycastGround(p63) -- Line: 311
        -- upvalues: u22 (copy), CurrentCamera (copy), groundRaycastParams (copy)
        local v64 = CurrentCamera:ScreenPointToRay(p63 and p63.X or u22.X, p63 and p63.Y or u22.Y);
        local v65 = workspace:Raycast(v64.Origin, v64.Direction * 2000, (groundRaycastParams()));

        return v65 and v65.Position or nil;
    end;

    local function groundHitNearCharacter() -- Line: 322
        -- upvalues: LocalPlayer (copy), groundRaycastParams (copy)
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if not Character then
            return nil;
        end;

        local LookVector = Character.CFrame.LookVector;
        local v66 = Vector3.new(LookVector.X, 0, LookVector.Z);
        local v67 = workspace:Raycast(Character.Position + (v66.Magnitude > 0.01 and v66.Unit or Vector3.new(0, 0, 1)) * 8 + Vector3.new(0, 10, 0), Vector3.new(0, -60, 0), (groundRaycastParams()));

        return v67 and v67.Position or nil;
    end;

    local function isValidPlacement() -- Line: 336
        -- upvalues: u28 (ref), u26 (ref), getPartWorldExtentsXZ (ref)
        if not (u28 and u26) then
            return false;
        end;

        local Position = u28:GetPivot().Position;
        local v68 = u26;
        local v69, v70 = getPartWorldExtentsXZ(v68);
        local v71;

        if math.abs(Position.X - v68.Position.X) <= v69 then
            v71 = math.abs(Position.Z - v68.Position.Z) <= v70;
        else
            v71 = false;
        end;

        return v71;
    end;

    local function updateGhostTransform(p72, p73) -- Line: 343
        -- upvalues: u28 (ref), u44 (ref), raycastGround (copy), u36 (ref), identity (ref), partWorldBottomY (ref)
        if not u28 then
            return false;
        end;

        local v74 = p73 and u44 or raycastGround(p72);

        if not v74 then
            return false;
        end;

        u44 = v74;
        local v75 = math.round(v74.X / 0.5) * 0.5;
        local v76 = math.round(v74.Z / 0.5) * 0.5;
        local v77 = CFrame.Angles(0, u36, 0) * identity;
        u28:PivotTo(CFrame.new(v75, v74.Y, v76) * v77);
        local v78 = u28;
        local v79 = v78.PrimaryPart or (v78:FindFirstChild("Base") or v78:FindFirstChild("MainPart"));

        if not (v79 and (v79:IsA("BasePart") and v79)) then
            v79 = nil;
        end;

        local v80 = v79 and (partWorldBottomY(v79) or (1 / 0)) or (1 / 0);

        if not v79 then
            for _, descendant in u28:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local v81 = partWorldBottomY(descendant);

                    if v81 < v80 then
                        v80 = v81;
                    end;
                end;
            end;
        end;

        local v82 = u28:GetPivot();
        u28:PivotTo(CFrame.new(v75, v74.Y + (v82.Y - v80), v76) * v77);

        return true;
    end;

    v21:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 372
        -- upvalues: getEquippedDecorTool (copy), u28 (ref), destroyGhost (copy), KeybindHints (copy), u32 (ref), u34 (ref), u35 (ref), buildGhost (copy), RunService (ref), u23 (copy), CustomEnum (ref), u39 (ref), CurrentCamera (copy), updateGhostTransform (ref), u44 (ref), groundHitNearCharacter (copy), u45 (ref), u42 (ref), u43 (ref), u40 (ref), u26 (ref), getPartWorldExtentsXZ (ref), u37 (ref), setGhostState (copy), u41 (ref), u30 (ref), u29 (ref)
        local v83, v84 = getEquippedDecorTool();

        if not v83 then
            if u28 then
                destroyGhost();
            end;

            KeybindHints.Visible = false;

            return;
        end;

        local v85 = v83:GetAttribute("FurnitureType");
        local v86 = v84 == "Egg" and v83:GetAttribute("EggId") or v83:GetAttribute("FurnitureId");
        local v87 = v83:GetAttribute("ItemId");

        if not v86 then
            return;
        end;

        if u32 ~= v87 or (u34 ~= v86 or u35 ~= v84) then
            buildGhost(v85, v86, v87, v84);
        end;

        if not u28 then
            return;
        end;

        KeybindHints.Visible = not (RunService:IsStudio() and workspace:GetAttribute("debugForceMobile")) and u23:getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE and true or false;

        if not (RunService:IsStudio() and workspace:GetAttribute("debugForceMobile")) and u23:getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE then
            if u39 then
                u39:Destroy();
                u39 = nil;
                u40 = nil;
                u41 = nil;
                u42 = false;
            end;

            if updateGhostTransform() then
                local v88;

                if u28 and u26 then
                    local Position = u28:GetPivot().Position;
                    local v89 = u26;
                    local v90, v91 = getPartWorldExtentsXZ(v89);

                    if math.abs(Position.X - v89.Position.X) <= v90 then
                        v88 = math.abs(Position.Z - v89.Position.Z) <= v91;
                    else
                        v88 = false;
                    end;
                else
                    v88 = false;
                end;

                u37 = v88;
                setGhostState(v88 and "valid" or "invalid");

                return;
            end;

            u37 = false;

            for _, v in u30 do
                v.part.Transparency = 1;
            end;

            if not u29 then
                return;
            end;

            u29.Enabled = false;

            return;
        end;

        if not u39 then
            local ViewportSize = CurrentCamera.ViewportSize;

            if not updateGhostTransform(Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)) then
                u44 = groundHitNearCharacter();
                updateGhostTransform(nil, true);
            end;

            u45();
        end;

        if u42 then
            updateGhostTransform(u43);
        elseif not updateGhostTransform(nil, true) then
            u44 = groundHitNearCharacter();
            updateGhostTransform(nil, true);
        end;

        if u40 then
            local v92 = u28;
            local v93 = v92.PrimaryPart or (v92:FindFirstChild("Base") or v92:FindFirstChild("MainPart"));

            if not (v93 and (v93:IsA("BasePart") and v93)) then
                v93 = nil;
            end;

            local v94 = CurrentCamera:WorldToViewportPoint((v93 and v93.Position or u28:GetPivot().Position) + Vector3.new(0, 3, 0));

            if v94.Z > 0 then
                u40.Visible = true;
                u40.Position = UDim2.fromOffset(v94.X, v94.Y);
            else
                u40.Visible = false;
            end;
        end;

        local v95;

        if u28 and u26 then
            local Position = u28:GetPivot().Position;
            local v96 = u26;
            local v97, v98 = getPartWorldExtentsXZ(v96);

            if math.abs(Position.X - v96.Position.X) <= v97 then
                v95 = math.abs(Position.Z - v96.Position.Z) <= v98;
            else
                v95 = false;
            end;
        else
            v95 = false;
        end;

        u37 = v95;
        setGhostState(v95 and "valid" or "invalid");

        if u41 then
            u41.Visible = v95;
        end;
    end));

    local function tryPlace() -- Line: 454
        -- upvalues: u38 (ref), u28 (ref), u32 (ref), u37 (ref), u26 (ref), getPartWorldExtentsXZ (ref), u35 (ref), u24 (copy)
        if u38 or not (u28 and u32) then
            return;
        end;

        if u37 then
            local v99;

            if u28 and u26 then
                local Position = u28:GetPivot().Position;
                local v100 = u26;
                local v101, v102 = getPartWorldExtentsXZ(v100);

                if math.abs(Position.X - v100.Position.X) <= v101 then
                    v99 = math.abs(Position.Z - v100.Position.Z) <= v102;
                else
                    v99 = false;
                end;
            else
                v99 = false;
            end;

            if v99 then
                local v103 = u28:GetPivot();
                u38 = true;

                if u35 == "Egg" then
                    u24:PlaceEgg(u32, { v103:GetComponents() });
                else
                    u24:PlaceDecor(u32, { v103:GetComponents() });
                end;

                u38 = false;
            end;
        end;
    end;

    local function circleButton(p104, p105) -- Line: 469
        local ImageButton = Instance.new("ImageButton");
        ImageButton.Name = p104;
        ImageButton.Size = UDim2.fromOffset(58, 58);
        ImageButton.BackgroundTransparency = 1;
        ImageButton.Image = p105;
        ImageButton.ScaleType = Enum.ScaleType.Crop;
        ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(1, 0);
        UICorner.Parent = ImageButton;

        return ImageButton;
    end;

    u45 = function() -- Line: 486, Name: createPlacementBillboard
        -- upvalues: u39 (ref), PlayerGui (copy), circleButton (copy), u41 (ref), u36 (ref), tryPlace (copy), u42 (ref), u43 (ref), u40 (ref)
        if u39 then
            u39:Destroy();
        end;

        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "PlacementUI";
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.DisplayOrder = 100;
        ScreenGui.Parent = PlayerGui;
        local Frame = Instance.new("Frame");
        Frame.Name = "Cluster";
        Frame.BackgroundTransparency = 1;
        Frame.Size = UDim2.fromOffset(190, 150);
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Parent = ScreenGui;
        local v106 = circleButton("Place", "rbxassetid://81396787144131");
        v106.Position = UDim2.fromScale(0.5, 0.2);
        v106.Parent = Frame;
        u41 = v106;
        local v107 = circleButton("Move", "rbxassetid://99574362580177");
        v107.Position = UDim2.fromScale(0.5, 0.68);
        v107.Parent = Frame;
        local v108 = circleButton("RotateLeft", "rbxassetid://130362277402032");
        v108.Position = UDim2.fromScale(0.16, 0.68);
        v108.Parent = Frame;
        local v109 = circleButton("RotateRight", "rbxassetid://115660242323853");
        v109.Position = UDim2.fromScale(0.84, 0.68);
        v109.Parent = Frame;
        v108.Activated:Connect(function() -- Line: 519
            -- upvalues: u36 (ref)
            u36 = u36 + 0.2617993877991494;
        end);
        v109.Activated:Connect(function() -- Line: 520
            -- upvalues: u36 (ref)
            u36 = u36 - 0.2617993877991494;
        end);
        v106.Activated:Connect(tryPlace);
        v107.InputBegan:Connect(function(p110) -- Line: 522
            -- upvalues: u42 (ref), u43 (ref)
            if p110.UserInputType == Enum.UserInputType.Touch or p110.UserInputType == Enum.UserInputType.MouseButton1 then
                u42 = true;
                u43 = Vector2.new(p110.Position.X, p110.Position.Y);
            end;
        end);
        u40 = Frame;
        u39 = ScreenGui;
    end;

    v21:GiveTask(UserInputService.InputBegan:Connect(function(p111, p112) -- Line: 534
        -- upvalues: getEquippedDecorTool (copy), u36 (ref), RunService (ref), u23 (copy), CustomEnum (ref), tryPlace (copy)
        if p112 then
            return;
        end;

        if not getEquippedDecorTool() then
            return;
        end;

        if p111.KeyCode == Enum.KeyCode.Q then
            u36 = u36 - 0.2617993877991494;

            return;
        end;

        if p111.KeyCode == Enum.KeyCode.R then
            u36 = u36 + 0.2617993877991494;

            return;
        end;

        if not (RunService:IsStudio() and workspace:GetAttribute("debugForceMobile")) and u23:getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE and p111.UserInputType == Enum.UserInputType.MouseButton1 then
            tryPlace();
        end;
    end));
    v21:GiveTask(UserInputService.InputChanged:Connect(function(p113) -- Line: 550
        -- upvalues: u42 (ref), u43 (ref)
        if u42 and (p113.UserInputType == Enum.UserInputType.Touch or p113.UserInputType == Enum.UserInputType.MouseMovement) then
            u43 = Vector2.new(p113.Position.X, p113.Position.Y);
        end;
    end));
    v21:GiveTask(UserInputService.InputEnded:Connect(function(p114) -- Line: 556
        -- upvalues: u42 (ref)
        if p114.UserInputType == Enum.UserInputType.Touch or p114.UserInputType == Enum.UserInputType.MouseButton1 then
            u42 = false;
        end;
    end));
    v21:GiveTask(Players.LocalPlayer.CharacterRemoving:Connect(function() -- Line: 563
        -- upvalues: destroyGhost (copy)
        destroyGhost();
    end));
end;

return v1;