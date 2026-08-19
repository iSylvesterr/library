-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local PerfFlags = require(ReplicatedStorage.SharedModules.Flags.PerfFlags);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Backspace = Enum.KeyCode.Backspace;
local u2 = Color3.fromRGB(255, 60, 60);
local BillboardGui = script.BillboardGui;
BillboardGui.Parent = nil;
local u3 = {
    Common = true,
    Uncommon = true,
    Rare = true,
    Epic = true,
    Legendary = true,
    Mythic = true,
    Super = true,
    Secret = true
};
local u4 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold);
local u5 = {
    SeedTool = "Seeds",
    Sprinkler = "Sprinklers",
    WateringCan = "WateringCans",
    Mushroom = "Mushrooms",
    Gnome = "Gnomes",
    Raccoon = "Raccoons",
    Crate = "Crates",
    Teleporter = "Teleporters",
    PlayerMagnet = "Magnets",
    FruitMagnet = "FruitMagnets",
    PetTeleporter = "PetTeleporters",
    SeedPack = "SeedPacks",
    Wheelbarrow = "Wheelbarrows",
    Trowel = "Trowels",
    Crowbar = "Crowbars",
    Ladder = "Ladders",
    FreezeRay = "FreezeRays",
    PowerHose = "PowerHoses",
    Rake = "Rakes",
    Sign = "Signs",
    EmptyPot = "EmptyPots",
    Flashbang = "Flashbangs",
    Bird = "Birds"
};
local u6 = {};
local u7 = nil;
local u8 = nil;

local function isMobile() -- Line: 108
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
end;

local u9 = {};

local function u14() -- Line: 126
    -- upvalues: LocalPlayer (copy), u5 (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil, nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") then
            local v10 = child:GetAttribute("HarvestedFruit") == true and child:GetAttribute("Id");

            if v10 then
                return "HarvestedFruits", v10;
            end;

            local v11 = child:GetAttribute("PetId");

            if type(v11) == "string" and v11 ~= "" then
                return "Pets", v11;
            end;

            for i in child:GetAttributes() do
                local v12 = u5[i];

                if v12 then
                    local v13 = child:GetAttribute(i);

                    if v13 then
                        return v12, v13;
                    end;
                end;
            end;
        end;
    end;

    return nil, nil;
end;

local function u18() -- Line: 159
    -- upvalues: u8 (ref), UserInputService (copy), u14 (ref)
    if not u8 then
        return;
    end;

    if not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) then
        u8.Visible = false;

        return;
    end;

    local v15, v16 = u14();
    local v17;

    if v15 == nil then
        v17 = false;
    else
        v17 = v16 ~= nil;
    end;

    u8.Visible = v17;
end;

local function addGlow(p19) -- Line: 170
    local PointLight = Instance.new("PointLight");
    PointLight.Name = "DropGlow";
    PointLight.Brightness = 0.5;
    PointLight.Range = 8;
    PointLight.Color = Color3.fromRGB(255, 255, 200);
    PointLight.Parent = p19;

    return PointLight;
end;

local function computeAboveAdorneeOffset(p20, p21) -- Line: 180
    local Visual = p20:FindFirstChild("Visual");
    local v22 = p21.Position.Y + p21.Size.Y * 0.5;

    if Visual and Visual:IsA("Model") then
        local v23, v24, v25 = pcall(function() -- Line: 184
            -- upvalues: Visual (copy)
            return Visual:GetBoundingBox();
        end);

        if v23 and (v24 and v25) then
            v22 = v24.Position.Y + v25.Y * 0.5;
        end;
    end;

    local v26 = math.max(v22 - p21.Position.Y + 2.5, 5);

    return Vector3.new(0, v26, 0);
end;

local function createTimerLine(p27, p28) -- Line: 193
    -- upvalues: u4 (copy), u2 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "TimerFrame";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.LayoutOrder = 2;
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.Size = UDim2.new(1, 0, 0.3 / p28, 0);
    Frame.Parent = p27;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TimerText";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0);
    TextLabel.Size = UDim2.new(1, 0, 1, 0);
    TextLabel.FontFace = u4;
    TextLabel.Text = "";
    TextLabel.TextColor3 = u2;
    TextLabel.TextScaled = true;
    TextLabel.TextWrapped = true;
    TextLabel.ZIndex = 3;
    TextLabel.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.new(0, 0, 0);
    UIStroke.Thickness = 2;
    UIStroke.Parent = TextLabel;

    return TextLabel;
end;

local function addLabel(p29, p30) -- Line: 227
    -- upvalues: u3 (copy), computeAboveAdorneeOffset (copy), BillboardGui (copy), RarityVisuals (copy), createTimerLine (copy)
    local v31 = p29:GetAttribute("DisplayName");

    if not v31 or v31 == "" then
        return nil, nil;
    end;

    local v32 = p29:GetAttribute("Rarity");
    local v33;

    if v32 == nil then
        v33 = false;
    else
        v33 = u3[v32] == true;
    end;

    local Y = computeAboveAdorneeOffset(p29, p30).Y;
    local v34 = p29:GetAttribute("DropOffsetY") or 0;
    local v35 = p29:FindFirstChild("PromptAnchor") or p30;
    local v36 = BillboardGui:Clone();
    v36.Name = "ItemLabel";
    v36.Adornee = v35;
    local v37 = 1;
    local Visual = p29:FindFirstChild("Visual");

    if Visual and Visual:IsA("Model") then
        local v38, _, v39 = pcall(function() -- Line: 246
            -- upvalues: Visual (copy)
            return Visual:GetBoundingBox();
        end);

        if v38 and v39 then
            local v40 = math.max(v39.X, v39.Y, v39.Z) / 3;
            v37 = math.clamp(v40, 1, 4);
        end;
    end;

    local v41 = p29:GetAttribute("DespawnAt") ~= nil;
    local v42;

    if v41 then
        v42 = 1.3;
        local NameFrame = v36.NameFrame;
        local RarityFrame = v36.RarityFrame;
        NameFrame.Size = UDim2.new(NameFrame.Size.X.Scale, NameFrame.Size.X.Offset, NameFrame.Size.Y.Scale / v42, NameFrame.Size.Y.Offset);
        RarityFrame.Size = UDim2.new(RarityFrame.Size.X.Scale, RarityFrame.Size.X.Offset, RarityFrame.Size.Y.Scale / v42, RarityFrame.Size.Y.Offset);
    else
        v42 = 1;
    end;

    local Size = v36.Size;
    v36.Size = UDim2.new(Size.X.Scale * v37, Size.X.Offset * v37, Size.Y.Scale * v42 * v37, Size.Y.Offset * v42 * v37);

    if v35 ~= p30 then
        v36.StudsOffsetWorldSpace = Vector3.new(0, v34 + Y, 0);
    else
        v36.StudsOffsetWorldSpace = Vector3.new(0, Y, 0);
    end;

    v36.AlwaysOnTop = true;
    v36.MaxDistance = 250;
    v36.Parent = v35;
    local v43 = nil;

    if v33 then
        local RarityFrame = v36.RarityFrame;
        RarityFrame.ItemRarity.Text = v32;
        RarityFrame.ItemRarity.TextLabel.Text = v32;
        RarityFrame.ItemRarity.TextLabel.TextColor3 = RarityVisuals.GetStaticColor(v32);
        v43 = RarityVisuals.ApplyToLabels({ RarityFrame.ItemRarity.TextLabel }, v32);
    else
        v36.RarityFrame.Visible = false;
    end;

    local NameFrame = v36.NameFrame;
    NameFrame.ItemName.Text = v31;
    NameFrame.ItemName.TextLabel.Text = v31;
    local v44;

    if v41 then
        v44 = createTimerLine(v36, v42);
    else
        v44 = nil;
    end;

    return v36, v43, v44;
end;

local function easeOutBack(p45) -- Line: 306
    return (p45 - 1) ^ 3 * 2.70158 + 1 + (p45 - 1) ^ 2 * 1.70158;
end;

local function resolvePrimaryPart(p46) -- Line: 312
    if p46:IsA("BasePart") then
        return p46;
    end;

    if p46:IsA("Model") then
        return p46.PrimaryPart;
    end;

    return nil;
end;

local function hideModelForNonOwner(p47) -- Line: 319
    local function hide(p48) -- Line: 320
        if p48:IsA("BasePart") then
            p48.LocalTransparencyModifier = 1;

            return;
        end;

        if p48:IsA("Decal") or p48:IsA("Texture") then
            p48.LocalTransparencyModifier = 1;

            return;
        end;

        if p48:IsA("ProximityPrompt") then
            p48.Enabled = false;
        end;
    end;

    for _, descendant in p47:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.LocalTransparencyModifier = 1;
        elseif descendant:IsA("ProximityPrompt") then
            descendant.Enabled = false;
        end;
    end;

    local u49 = p47.DescendantAdded:Connect(hide);
    p47.AncestryChanged:Connect(function(p50, p51) -- Line: 335
        -- upvalues: u49 (copy)
        if not p51 then
            u49:Disconnect();
        end;
    end);
end;

local function onItemAdded(u52) -- Line: 342
    -- upvalues: LocalPlayer (copy), hideModelForNonOwner (copy), addLabel (copy), u6 (copy)
    if not u52:IsA("Model") then
        return;
    end;

    task.spawn(function() -- Line: 345
        -- upvalues: u52 (copy), LocalPlayer (ref), hideModelForNonOwner (ref), addLabel (ref), u6 (ref)
        local v53 = u52:GetAttribute("ItemCategory");

        if u52:GetAttribute("OwnerRestricted") == true and u52:GetAttribute("DroppedBy") ~= LocalPlayer.UserId then
            hideModelForNonOwner(u52);

            return;
        end;

        local Visual = u52:WaitForChild("Visual", 5);

        if not Visual then
            return;
        end;

        local v54;

        if Visual:IsA("BasePart") then
            v54 = Visual;
        elseif Visual:IsA("Model") then
            v54 = Visual.PrimaryPart;
        else
            v54 = nil;
        end;

        if not v54 then
            local v55 = os.clock() + 5;

            while os.clock() < v55 do
                if not u52.Parent then
                    return;
                end;

                task.wait(0.05);

                if Visual:IsA("BasePart") then
                    v54 = Visual;
                elseif Visual:IsA("Model") then
                    v54 = Visual.PrimaryPart;
                else
                    v54 = nil;
                end;

                if v54 then
                    break;
                end;
            end;
        end;

        if not v54 then
            return;
        end;

        if not u52.Parent then
            return;
        end;

        local v56 = Visual:GetAttribute("PartCount");

        if Visual:IsA("Model") and (type(v56) == "number" and v56 > 1) then
            local v57 = os.clock() + 3;

            while os.clock() < v57 do
                if not u52.Parent then
                    return;
                end;

                local v58 = 0;

                for _, descendant in Visual:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        v58 = v58 + 1;

                        if v56 <= v58 then
                            break;
                        end;
                    end;
                end;

                if v56 <= v58 then
                    break;
                end;

                task.wait(0.03);
            end;
        end;

        if not u52.Parent then
            return;
        end;

        local Position = v54.Position;
        local PointLight = Instance.new("PointLight");
        PointLight.Name = "DropGlow";
        PointLight.Brightness = 0.5;
        PointLight.Range = 8;
        PointLight.Color = Color3.fromRGB(255, 255, 200);
        PointLight.Parent = v54;
        local v59, v60, v61 = addLabel(u52, v54);
        local v62 = u52:GetAttribute("DespawnAt");
        local v63 = u52:GetAttribute("DisplayName");
        local v64 = (v53 == "Raccoons" or v53 == "Pets" and u52:GetAttribute("ItemName") == "Raccoon") and true or v63 == "Raccoon";
        local v65 = {
            popped = false,
            basePosition = Position,
            visualModel = Visual:IsA("Model") and Visual and Visual or nil,
            primaryPart = v54,
            spawnTime = os.clock(),
            glow = PointLight,
            label = v59,
            rarityCleanup = v60,
            timerLabel = v61
        };

        if type(v62) ~= "number" then
            v62 = nil;
        end;

        v65.despawnAt = v62;
        v65.groundPop = u52:GetAttribute("GroundPop") == true;
        v65.isRaccoon = v64;
        v65.isPet = v53 == "Pets";
        u6[u52] = v65;
    end);
end;

local function onItemRemoved(p66) -- Line: 433
    -- upvalues: u6 (copy)
    if not p66:IsA("Model") then
        return;
    end;

    local v67 = u6[p66];

    if v67 and v67.rarityCleanup then
        v67.rarityCleanup();
    end;

    u6[p66] = nil;
end;

local function getOrCreatePickupFxFolder() -- Line: 442
    local DroppedItemFx = workspace:FindFirstChild("DroppedItemFx");

    if DroppedItemFx and DroppedItemFx:IsA("Folder") then
        return DroppedItemFx;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "DroppedItemFx";
    Folder.Parent = workspace;

    return Folder;
end;

local function onPickupFx(p68, p69) -- Line: 451
    -- upvalues: u6 (copy), Players (copy), TweenService (copy), u9 (copy)
    if not (p68 and p68:IsA("Model")) then
        return;
    end;

    local v70 = u6[p68];
    local _ = p68:GetAttribute("ItemCategory") == "Pets";

    if not v70 then
        return;
    end;

    local v71 = Players:GetPlayerByUserId(p69);

    if not (v71 and v71.Character) then
        return;
    end;

    local HumanoidRootPart = v71.Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    u6[p68] = nil;

    if v70.rarityCleanup then
        v70.rarityCleanup();
    end;

    if v70.label then
        local label = v70.label;
        TweenService:Create(label, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play();
        task.delay(0.3, function() -- Line: 485
            -- upvalues: label (copy)
            if label then
                label:Destroy();
            end;
        end);
    end;

    local v72 = v70.visualModel or v70.primaryPart;

    if not (v72 and v72.Parent) then
        return;
    end;

    local DroppedItemFx = workspace:FindFirstChild("DroppedItemFx");

    if not (DroppedItemFx and DroppedItemFx:IsA("Folder")) then
        DroppedItemFx = Instance.new("Folder");
        DroppedItemFx.Name = "DroppedItemFx";
        DroppedItemFx.Parent = workspace;
    end;

    local v73 = v72:Clone();
    local v74 = nil;
    local v75 = nil;

    if v73:IsA("Model") then
        v74 = v73.PrimaryPart;

        if v74 then
            v75 = v73;
        else
            v75 = v73;

            for _, descendant in v73:GetDescendants() do
                if descendant:IsA("BasePart") then
                    v74 = descendant;
                    break;
                end;
            end;

            if v74 then
                v73.PrimaryPart = v74;
            end;
        end;

        for _, descendant in v73:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
            end;
        end;
    elseif v73:IsA("BasePart") then
        v73.Anchored = true;
        v73.CanCollide = false;
        v73.CanQuery = false;
        v73.CanTouch = false;
        v74 = v73;
    end;

    if not v74 then
        v73:Destroy();

        return;
    end;

    v73.Parent = DroppedItemFx;

    if v70.visualModel and v70.visualModel.Parent then
        for _, descendant in v70.visualModel:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = 1;
            end;

            if descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant.Transparency = 1;
            end;

            if descendant:IsA("SurfaceGui") or descendant:IsA("BillboardGui") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local v76 = {
        glow = nil,
        visualModel = v75,
        primaryPart = v74,
        spawnTime = v70.spawnTime,
        collectStart = os.clock(),
        collectTarget = HumanoidRootPart,
        collectOrigin = v70.basePosition,
        isRaccoon = v70.isRaccoon
    };
    table.insert(u9, v76);
end;

local function updateAnimations(p77) -- Line: 560
    -- upvalues: PerfFlags (copy), u6 (copy), TweenService (copy), u9 (copy)
    local v78 = os.clock();
    local v79 = PerfFlags.DroppedItemAnimationsDisabled:Get();

    for i, v in u6 do
        if i.Parent then
            if v.primaryPart and v.primaryPart.Parent then
                local v80 = v78 - v.spawnTime;
                local basePosition = v.basePosition;

                if v79 then
                    if not v.staticApplied then
                        v.staticApplied = true;
                        v.popped = true;
                        local v81 = v.isRaccoon and 1.5707963267948966 or 0;
                        local v82;

                        if v.isRaccoon then
                            v82 = CFrame.new(basePosition) * CFrame.Angles(v81, 1.5707963267948966, 0);
                        else
                            v82 = CFrame.new(basePosition) * CFrame.Angles(v81, 0, 0);
                        end;

                        if v.visualModel then
                            v.visualModel:ScaleTo(1);
                            v.visualModel:PivotTo(v82);
                        else
                            v.primaryPart.CFrame = v82;
                        end;

                        if v.glow then
                            v.glow.Brightness = 0.5;
                        end;
                    end;

                    if v.timerLabel and v.despawnAt then
                        local v83 = v.despawnAt - workspace:GetServerTimeNow();
                        v.timerLabel.Text = string.format("%ds", (math.ceil(v83 < 0 and 0 or v83)));
                    end;
                else
                    if v.staticApplied then
                        v.staticApplied = nil;
                    end;

                    if v.groundPop and v80 < 0.6 then
                        local v84;

                        if v80 < 0.3 then
                            local v85 = TweenService:GetValue(v80 / 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
                            v84 = math.lerp(basePosition.Y - 3, basePosition.Y + 1.5, v85);
                        else
                            local v86 = TweenService:GetValue(math.clamp((v80 - 0.3) / 0.3, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                            v84 = math.lerp(basePosition.Y + 1.5, basePosition.Y, v86);
                        end;

                        local v87 = CFrame.new(basePosition.X, v84, basePosition.Z);

                        if v.visualModel then
                            v.visualModel:ScaleTo(1);
                            v.visualModel:PivotTo(v87);
                        else
                            v.primaryPart.CFrame = v87;
                        end;

                        if v.glow then
                            v.glow.Brightness = 0.5;
                        end;

                        if v.timerLabel and v.despawnAt then
                            local v88 = v.despawnAt - workspace:GetServerTimeNow();
                            v.timerLabel.Text = string.format("%ds", (math.ceil(v88 < 0 and 0 or v88)));
                        end;
                    else
                        local v89 = 1;

                        if v80 < 0.4 then
                            local v90 = math.clamp(v80 / 0.4, 0, 1);
                            v89 = (v90 - 1) ^ 3 * 2.70158 + 1 + (v90 - 1) ^ 2 * 1.70158;
                        elseif not v.popped then
                            v.popped = true;
                        end;

                        local v91;

                        if v.groundPop then
                            v91 = math.max(0, v80 - 0.6);
                        else
                            v91 = v80;
                        end;

                        local v92 = math.sin(v91 * 0.8 * 3.141592653589793 * 2) * 0.35;
                        local v93 = math.rad(v91 * 50);
                        local v94 = basePosition + Vector3.new(0, v92, 0);
                        local v95 = v.isRaccoon and 1.5707963267948966 or 0;
                        local v96;

                        if v.isRaccoon then
                            v96 = CFrame.new(v94) * CFrame.Angles(v95, 1.5707963267948966, 0) * CFrame.Angles(v93, 0, 0);
                        else
                            v96 = CFrame.new(v94) * CFrame.Angles(v95, 0, 0) * CFrame.Angles(0, v93, 0);
                        end;

                        if v80 < 0.4 then
                            local v97 = math.max(v89, 0.01);

                            if v.visualModel then
                                v.visualModel:ScaleTo(v97);
                            end;
                        elseif not v.popped then
                            if v.visualModel then
                                v.visualModel:ScaleTo(1);
                            end;

                            v.popped = true;
                        end;

                        if v.visualModel then
                            v.visualModel:PivotTo(v96);
                        else
                            v.primaryPart.CFrame = v96;
                        end;

                        if v.glow then
                            local v98 = math.sin(v80 * 2.5) * 0.5 + 0.5;
                            v.glow.Brightness = (v98 * 0.25 + 0.75) * 0.5;
                        end;

                        if v.timerLabel and v.despawnAt then
                            local v99 = v.despawnAt - workspace:GetServerTimeNow();
                            v.timerLabel.Text = string.format("%ds", (math.ceil(v99 < 0 and 0 or v99)));
                        end;
                    end;
                end;
            else
                u6[i] = nil;
            end;
        else
            u6[i] = nil;
        end;
    end;

    for i = #u9, 1, -1 do
        local v100 = u9[i];
        local v101 = math.clamp((v78 - v100.collectStart) / 0.2, 0, 1);
        local v102 = v101 * v101;
        local v103 = v100.collectOrigin:Lerp(v100.collectTarget.Position, v102);
        local v104 = math.max(1 - v102, 0.01);
        local v105 = math.rad((v78 - v100.spawnTime) * 50 * 2);
        local v106 = v100.isRaccoon and 1.5707963267948966 or 0;
        local v107;

        if v100.isRaccoon then
            v107 = CFrame.new(v103) * CFrame.Angles(v106, 1.5707963267948966, 0) * CFrame.Angles(v105, 0, 0);
        else
            v107 = CFrame.new(v103) * CFrame.Angles(v106, 0, 0) * CFrame.Angles(0, v105, 0);
        end;

        if v100.visualModel then
            v100.visualModel:ScaleTo(v104);
            v100.visualModel:PivotTo(v107);
        else
            v100.primaryPart.CFrame = v107;
        end;

        if v100.glow then
            v100.glow.Brightness = (1 - v102) * 0.5;
        end;

        if v101 >= 1 then
            if v100.visualModel then
                v100.visualModel:Destroy();
            else
                v100.primaryPart:Destroy();
            end;

            table.remove(u9, i);
        end;
    end;
end;

function v1.Init(p108) -- Line: 755
    -- upvalues: u7 (ref)
    u7 = workspace:FindFirstChild("DroppedItems");

    if not u7 then
        u7 = Instance.new("Folder");
        u7.Name = "DroppedItems";
        u7.Parent = workspace;
    end;
end;

function v1.Start(p109) -- Line: 764
    -- upvalues: u7 (ref), onItemAdded (copy), onItemRemoved (copy), RunService (copy), updateAnimations (copy), Networking (copy), onPickupFx (copy), UserInputService (copy), Backspace (copy), u14 (ref), PlayerGui (copy), u8 (ref), u18 (ref), LocalPlayer (copy)
    u7.ChildAdded:Connect(onItemAdded);
    u7.ChildRemoved:Connect(onItemRemoved);

    for _, child in u7:GetChildren() do
        task.spawn(onItemAdded, child);
    end;

    RunService.Heartbeat:Connect(updateAnimations);
    Networking.DroppedItem.PickupFx.OnClientEvent:Connect(onPickupFx);
    UserInputService.InputBegan:Connect(function(p110, p111) -- Line: 776
        -- upvalues: Backspace (ref), u14 (ref), Networking (ref)
        if p111 then
            return;
        end;

        if p110.KeyCode ~= Backspace then
            return;
        end;

        local v112, v113 = u14();

        if not (v112 and v113) then
            return;
        end;

        Networking.DroppedItem.RequestDrop:Fire(v112, v113);
    end);
    u8 = PlayerGui:WaitForChild("HoldToCollect"):WaitForChild("Remove");
    u8.Visible = false;
    u8.MouseButton1Click:Connect(function() -- Line: 791
        -- upvalues: u14 (ref), Networking (ref)
        local v114, v115 = u14();

        if not (v114 and v115) then
            return;
        end;

        Networking.DroppedItem.RequestDrop:Fire(v114, v115);
    end);

    local function onCharacterAdded(p116) -- Line: 799
        -- upvalues: u18 (ref)
        p116.ChildAdded:Connect(function(p117) -- Line: 800
            -- upvalues: u18 (ref)
            if p117:IsA("Tool") then
                u18();
            end;
        end);
        p116.ChildRemoved:Connect(function(p118) -- Line: 805
            -- upvalues: u18 (ref)
            if p118:IsA("Tool") then
                u18();
            end;
        end);
        u18();
    end;

    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(onCharacterAdded);
    u18();
end;

return v1;