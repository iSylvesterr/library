-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Knit = require(ReplicatedStorage.Packages.Knit);
local PetConfig = require(ReplicatedStorage.Shared.Info.PetConfig);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local PetAssets = require(ReplicatedStorage.Shared.Utility.PetAssets);
local PlotFootprint = require(ReplicatedStorage.Shared.Utility.PlotFootprint);
local TreeMountPoint = require(ReplicatedStorage.Shared.Utility.TreeMountPoint);
local AbbreviateNumber = require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local u1 = CFrame.Angles(0, 3.141592653589793, 0);
local u2 = UDim2.fromOffset(560, 360);
local u3 = CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 1.5707963267948966, 0);
local v4 = Knit.CreateController({
    Name = "PetsController"
});
local u5 = Random.new();
local u6 = {};

local function nextSoundDelay() -- Line: 68
    -- upvalues: u5 (copy)
    return 6 + u5:NextNumber() * 6;
end;

local function playPetSound(p7, p8) -- Line: 74
    -- upvalues: SoundService (copy), Knit (copy), Debris (copy)
    local PetSounds = SoundService:FindFirstChild("PetSounds", true);

    if p7 then
        if PetSounds then
            PetSounds = PetSounds:FindFirstChild(p7);
        end;
    else
        PetSounds = p7;
    end;

    if not (PetSounds and p8) then
        return;
    end;

    local v9 = Knit.GetController("SoundController"):PlaySoundAtPosition(PetSounds, p8.Position);

    if v9 then
        v9 = v9:FindFirstChildWhichIsA("Sound");
    end;

    if not v9 then
        return;
    end;

    v9.Parent = p8;
    Debris:AddItem(v9, v9.TimeLength + 0.5);
end;

local u10 = nil;

local function yawOf(p11) -- Line: 88
    return math.atan2(-p11.X, -p11.Z);
end;

local function flatDistance(p12, p13) -- Line: 92
    return Vector3.new(p12.X - p13.X, 0, p12.Z - p13.Z).Magnitude;
end;

local function findPlotDirt(p14) -- Line: 97
    for _, v in { "Plot3", "Plot2", "Plot1" } do
        local v15 = p14:FindFirstChild(v);

        if v15 then
            v15 = v15:FindFirstChild("Dirt");
        end;

        if v15 and v15:IsA("BasePart") then
            return v15;
        end;
    end;

    return nil;
end;

local function randomPoint(p16) -- Line: 108
    -- upvalues: u5 (copy)
    local v17 = p16.Size.X / 2 - 4;
    local v18 = p16.Size.Z / 2 - 4;

    if v17 <= 0 or v18 <= 0 then
        return nil;
    end;

    return (p16.CFrame * CFrame.new(u5:NextNumber(-v17, v17), 0, u5:NextNumber(-v18, v18))).Position;
end;

local function spotClear(p19, p20) -- Line: 115
    -- upvalues: PlotFootprint (copy)
    return PlotFootprint.isClear(PlotFootprint.ofPoint(p20, p19.radius), p19.obstacles);
end;

local function pathClear(p21, p22, p23) -- Line: 120
    -- upvalues: PlotFootprint (copy)
    local v24 = p23 - p22;
    local Magnitude = v24.Magnitude;

    if Magnitude < 0.001 then
        return true;
    end;

    local v25 = math.ceil(Magnitude / 3);
    local v26 = math.clamp(v25, 1, 24);
    local v27 = p21.radius + Magnitude / v26 / 2;

    for i = 1, v26 do
        if not PlotFootprint.isClear(PlotFootprint.ofPoint(p22 + v24 * (i / v26), v27), p21.obstacles) then
            return false;
        end;
    end;

    return true;
end;

local function pickTarget(p28) -- Line: 137
    -- upvalues: randomPoint (copy), PlotFootprint (copy), pathClear (copy)
    local dirt = p28.dirt;

    for _ = 1, 10 do
        local v29 = randomPoint(dirt);

        if not v29 then
            return nil;
        end;

        if PlotFootprint.isClear(PlotFootprint.ofPoint(v29, p28.radius), p28.obstacles) and pathClear(p28, p28.pos, v29) then
            return v29;
        end;
    end;

    return not PlotFootprint.isClear(PlotFootprint.ofPoint(p28.pos, p28.radius), p28.obstacles) and randomPoint(dirt) or nil;
end;

local function setupAnimation(u30) -- Line: 150
    -- upvalues: PetConfig (copy), Knit (copy)
    local v31 = PetConfig.GetPet(u30.petType);

    if not (v31 and (v31.idleAnim and v31.runAnim)) then
        return;
    end;

    local model = u30.model;
    local v32 = model:FindFirstChildOfClass("AnimationController");

    if not v32 then
        v32 = Instance.new("AnimationController");
        v32.Parent = model;
    end;

    local u33 = v32:FindFirstChildOfClass("Animator");

    if not u33 then
        u33 = Instance.new("Animator");
        u33.Parent = v32;
    end;

    local function load(p34) -- Line: 166
        -- upvalues: u33 (ref)
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://" .. tostring(p34);
        local success, result = pcall(function() -- Line: 169
            -- upvalues: u33 (ref), Animation (copy)
            return u33:LoadAnimation(Animation);
        end);

        return success and result and result or nil;
    end;

    local idleAnim = v31.idleAnim;
    local Animation = Instance.new("Animation");
    Animation.AnimationId = "rbxassetid://" .. tostring(idleAnim);
    local success, result = pcall(function() -- Line: 169
        -- upvalues: u33 (ref), Animation (copy)
        return u33:LoadAnimation(Animation);
    end);
    u30.idleTrack = success and result and result or nil;
    local runAnim = v31.runAnim;
    local Animation2 = Instance.new("Animation");
    Animation2.AnimationId = "rbxassetid://" .. tostring(runAnim);
    local success2, result2 = pcall(function() -- Line: 169
        -- upvalues: u33 (ref), Animation2 (copy)
        return u33:LoadAnimation(Animation2);
    end);
    u30.runTrack = success2 and result2 and result2 or nil;
    local v35;

    if v31.peckAnim then
        local peckAnim = v31.peckAnim;
        local Animation3 = Instance.new("Animation");
        Animation3.AnimationId = "rbxassetid://" .. tostring(peckAnim);
        local success3, result3 = pcall(function() -- Line: 169
            -- upvalues: u33 (ref), Animation3 (copy)
            return u33:LoadAnimation(Animation3);
        end);
        v35 = success3 and result3 and result3 or nil or nil;
    else
        v35 = nil;
    end;

    u30.peckTrack = v35;

    for _, v in { u30.idleTrack, u30.runTrack, u30.peckTrack } do
        v.Looped = true;
    end;

    if u30.peckTrack then
        u30.peckTrack.DidLoop:Connect(function() -- Line: 182
            -- upvalues: u30 (copy), Knit (ref)
            if not u30.model then
                return;
            end;

            Knit.GetController("SoundController"):PlaySoundAtPosition("WoodpeckerPeck", u30.model:GetPivot().Position);
        end);
    end;
end;

local function setupFlapSound(p36) -- Line: 191
    -- upvalues: PetConfig (copy), SoundService (copy)
    local v37 = PetConfig.GetPet(p36.petType);

    if not (v37 and v37.flying) then
        return;
    end;

    local v38 = p36.model.PrimaryPart or p36.model:FindFirstChildWhichIsA("BasePart", true);
    local BirdFlap = SoundService:FindFirstChild("BirdFlap", true);

    if not (v38 and BirdFlap) then
        return;
    end;

    local v39 = BirdFlap:Clone();
    v39.Looped = true;
    v39.Parent = v38;
    p36.flapSound = v39;
end;

local function setPose(p40, p41) -- Line: 204
    if p40.pose == p41 then
        return;
    end;

    local v42 = {
        idle = p40.idleTrack,
        run = p40.runTrack,
        peck = p40.peckTrack
    };
    local v43 = v42[p40.pose];
    local v44 = v42[p41] or v42.idle;
    p40.pose = p41;

    if v43 then
        v43:Stop(0.2);
    end;

    if v44 then
        v44:Play(0.2);
    end;

    if p40.flapSound then
        p40.flapSound.Playing = p41 == "run";
    end;
end;

local function setMoving(p45, p46) -- Line: 215
    -- upvalues: setPose (copy)
    setPose(p45, p46 and "run" or "idle");
end;

local LocalPlayer = Players.LocalPlayer;
local u47 = nil;

local function onMobile() -- Line: 226
    -- upvalues: Knit (copy), CustomEnum (copy)
    local v48 = Knit.GetController("UserInputParser");
    local v49;

    if v48 == nil then
        v49 = false;
    else
        v49 = v48:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
    end;

    return v49;
end;

local function billboardSize(p50) -- Line: 232
    -- upvalues: Knit (copy), CustomEnum (copy)
    local v51 = Knit.GetController("UserInputParser");
    local v52;

    if v51 == nil then
        v52 = false;
    else
        v52 = v51:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
    end;

    if v52 then
        return UDim2.new(p50.X.Scale * 0.5, p50.X.Offset * 0.5, p50.Y.Scale * 0.5, p50.Y.Offset * 0.5);
    end;

    return p50;
end;

local function holdingFruit() -- Line: 239
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    for _, v in Character and Character:GetChildren() or {} do
        if v:IsA("Tool") and v:GetAttribute("IsFruit") then
            return true;
        end;
    end;

    return false;
end;

local function feedPet(u53) -- Line: 247
    -- upvalues: Knit (copy)
    Knit.GetService("PlayerPlotService"):FeedPet(u53.uid):andThen(function(p54) -- Line: 248
        -- upvalues: u53 (copy), Knit (ref)
        local v55 = u53.model and u53.model.PrimaryPart;

        if not (p54 and v55) then
            return;
        end;

        Knit.GetController("SoundController"):PlaySoundAtPosition("PetFeed", v55.Position);
    end);
end;

local u56 = nil;
local u57 = nil;
local u58 = nil;
local u59 = nil;

local function uiFolder() -- Line: 260
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("UI");
    end;

    return Assets;
end;

local function setBar(p60, p61, p62) -- Line: 267
    if not p60 then
        return;
    end;

    local LevelBar = p60:FindFirstChild("LevelBar");
    local v63;

    if LevelBar then
        v63 = LevelBar:FindFirstChild("FillBar");
    else
        v63 = LevelBar;
    end;

    if v63 then
        v63.Size = UDim2.new(math.clamp(p61, 0, 1), 0, v63.Size.Y.Scale, v63.Size.Y.Offset);
    end;

    if LevelBar then
        LevelBar = LevelBar:FindFirstChild("PetName");
    end;

    if LevelBar and LevelBar:IsA("TextLabel") then
        LevelBar.Text = p62;
    end;
end;

local function refreshInfoBillboard(p64) -- Line: 278
    -- upvalues: PetConfig (copy), setBar (copy), AbbreviateNumber (copy)
    local infoBillboard = p64.infoBillboard;

    if not infoBillboard then
        return;
    end;

    local marker = p64.marker;
    local PetName = infoBillboard:FindFirstChild("PetName");

    if PetName and PetName:IsA("TextLabel") then
        PetName.Text = string.format("%s [%s]", p64.petType, (tostring(marker:GetAttribute("PetName"))));
    end;

    local Bars = infoBillboard:FindFirstChild("Bars");

    if not Bars then
        return;
    end;

    local v65 = marker:GetAttribute("Hunger") or 0;
    local v66 = marker:GetAttribute("MaxHunger") or PetConfig.GetMaxHunger(p64.petType);
    setBar(Bars:FindFirstChild("Hunger"), v66 > 0 and (v65 / v66 or 0) or 0, "$" .. AbbreviateNumber(v65));
    local v67 = marker:GetAttribute("Level") or 0;
    local v68 = marker:GetAttribute("Xp") or 0;
    local v69 = PetConfig.GetXpRequired(v67);
    setBar(Bars:FindFirstChild("Level"), v69 > 0 and v68 / v69 or 0, "Level " .. tostring(v67));
end;

local function hideActionBillboard() -- Line: 299
    -- upvalues: u59 (ref)
    if u59 and u59.actionBillboard then
        u59.actionBillboard.Enabled = false;
    end;

    u59 = nil;
end;

local function ensureActionBillboard(u70) -- Line: 307
    -- upvalues: u58 (ref), u56 (ref), u2 (copy), Knit (copy), CustomEnum (copy), u47 (ref), u59 (ref), hideActionBillboard (copy)
    if u70.actionBillboard then
        return u70.actionBillboard;
    end;

    if not u58 then
        return nil;
    end;

    local v71 = u58:Clone();
    v71.Adornee = u70.model.PrimaryPart;
    v71.Enabled = false;
    v71.ResetOnSpawn = false;
    v71.Parent = u56;
    local Buttons = v71:FindFirstChild("Buttons");
    local v72;

    if Buttons then
        v72 = Buttons:FindFirstChild("View");
    else
        v72 = Buttons;
    end;

    local v73;

    if Buttons then
        v73 = Buttons:FindFirstChild("Feed");
    else
        v73 = Buttons;
    end;

    local PickUp = v71:FindFirstChild("PickUp");
    local Exit = v71:FindFirstChild("Exit");
    local v74 = v71:FindFirstChildOfClass("UIListLayout");

    if v74 then
        v74:Destroy();
    end;

    local v75 = u2;
    local v76 = Knit.GetController("UserInputParser");
    local v77;

    if v76 == nil then
        v77 = false;
    else
        v77 = v76:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
    end;

    if v77 then
        v75 = UDim2.new(v75.X.Scale * 0.5, v75.X.Offset * 0.5, v75.Y.Scale * 0.5, v75.Y.Offset * 0.5);
    end;

    v71.Size = v75;

    if PickUp then
        PickUp.AnchorPoint = Vector2.new(0.5, 0);
        PickUp.Position = UDim2.fromScale(0.5, 0);
        PickUp.Size = UDim2.fromScale(0.46, 0.3);
    end;

    if Buttons then
        Buttons.AnchorPoint = Vector2.new(0.5, 1);
        Buttons.Position = UDim2.fromScale(0.5, 1);
        Buttons.Size = UDim2.fromScale(1, 0.3);
        local v78 = Buttons:FindFirstChildOfClass("UIListLayout");

        if v78 then
            v78:Destroy();
        end;

        if v73 then
            v73.AnchorPoint = Vector2.new(0, 1);
            v73.Position = UDim2.fromScale(0, 1);
            v73.Size = UDim2.fromScale(0.44, 1);
        end;

        if v72 then
            v72.AnchorPoint = Vector2.new(1, 1);
            v72.Position = UDim2.fromScale(1, 1);
            v72.Size = UDim2.fromScale(0.44, 1);
        end;
    end;

    if Exit then
        Exit.AnchorPoint = Vector2.new(0.5, 0.5);
        Exit.Position = UDim2.fromScale(0.5, 0.5);
        Exit.Size = UDim2.fromScale(0.17, 0.17);
    end;

    u70.actionButtons = {};

    local function wire(p79, p80) -- Line: 356
        -- upvalues: u70 (copy), u47 (ref)
        if not p79 then
            return;
        end;

        table.insert(u70.actionButtons, {
            obj = p79,
            fn = p80
        });
        p79.Activated:Connect(p80);
        u47:AddBounceButton(p79, 1.08, false);
    end;

    if v72 then
        v72 = v72:FindFirstChild("Button");
    end;

    wire(v72, function() -- Line: 363
        -- upvalues: u59 (ref), Knit (ref), u70 (copy)
        if u59 and u59.actionBillboard then
            u59.actionBillboard.Enabled = false;
        end;

        u59 = nil;
        local v81 = Knit.GetController("ViewPetController");

        if v81 and v81.Open then
            v81.Open(u70.uid);
        end;
    end);

    if v73 then
        v73 = v73:FindFirstChild("Button");
    end;

    wire(v73, function() -- Line: 368
        -- upvalues: u70 (copy), Knit (ref)
        local u82 = u70;
        Knit.GetService("PlayerPlotService"):FeedPet(u82.uid):andThen(function(p83) -- Line: 248
            -- upvalues: u82 (copy), Knit (ref)
            local v84 = u82.model and u82.model.PrimaryPart;

            if not (p83 and v84) then
                return;
            end;

            Knit.GetController("SoundController"):PlaySoundAtPosition("PetFeed", v84.Position);
        end);
    end);

    if PickUp then
        PickUp = PickUp:FindFirstChild("Button");
    end;

    wire(PickUp, function() -- Line: 371
        -- upvalues: u59 (ref), Knit (ref), u70 (copy)
        if u59 and u59.actionBillboard then
            u59.actionBillboard.Enabled = false;
        end;

        u59 = nil;
        Knit.GetService("PlayerPlotService"):PickupPet(u70.uid);
    end);

    if Exit then
        Exit = Exit:FindFirstChild("Button");
    end;

    wire(Exit, hideActionBillboard);
    u70.actionBillboard = v71;

    return v71;
end;

local function hitActionButton(p85) -- Line: 382
    -- upvalues: u59 (ref)
    local v86 = u59;
    local v87;

    if v86 then
        v87 = v86.actionBillboard;
    else
        v87 = v86;
    end;

    if not (v87 and (v87.Enabled and v87.Adornee)) then
        return false;
    end;

    local v88, v89 = workspace.CurrentCamera:WorldToScreenPoint(v87.Adornee.Position + v87.StudsOffset);

    if not v89 then
        return false;
    end;

    local v90 = Vector2.new(v88.X, v88.Y) - v87.AbsoluteSize / 2;

    for _, v in v86.actionButtons or {} do
        local obj = v.obj;

        if obj.Visible and obj.Parent then
            local v91 = v90 + obj.AbsolutePosition;

            if p85.X >= v91.X and (p85.X <= v91.X + obj.AbsoluteSize.X and (p85.Y >= v91.Y and p85.Y <= v91.Y + obj.AbsoluteSize.Y)) then
                return true;
            end;
        end;
    end;

    return false;
end;

local function setupBillboards(u92) -- Line: 405
    -- upvalues: ReplicatedStorage (copy), u57 (ref), u58 (ref), u56 (ref), Knit (copy), CustomEnum (copy), LocalPlayer (copy), holdingFruit (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("UI");
    end;

    if not Assets then
        return;
    end;

    u57 = u57 or Assets:FindFirstChild("PetInfoBillboard");
    u58 = u58 or Assets:FindFirstChild("PetBillboard");

    if u57 then
        local v93 = u57:Clone();
        v93.Adornee = u92.model.PrimaryPart;
        v93.Enabled = false;
        v93.MaxDistance = 80;
        v93.ResetOnSpawn = false;
        v93.Parent = u56;
        u92.infoBaseSize = u57.Size;
        local infoBaseSize = u92.infoBaseSize;
        local v94 = Knit.GetController("UserInputParser");
        local v95;

        if v94 == nil then
            v95 = false;
        else
            v95 = v94:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
        end;

        if v95 then
            infoBaseSize = UDim2.new(infoBaseSize.X.Scale * 0.5, infoBaseSize.X.Offset * 0.5, infoBaseSize.Y.Scale * 0.5, infoBaseSize.Y.Offset * 0.5);
        end;

        v93.Size = infoBaseSize;
        u92.infoBillboard = v93;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.new(1, 1, 1);
    Highlight.OutlineTransparency = 0;
    Highlight.Enabled = false;
    Highlight.Parent = u92.model;
    u92.highlight = Highlight;

    if u92.ownerId == LocalPlayer.UserId and u92.model.PrimaryPart then
        local ProximityPrompt = Instance.new("ProximityPrompt");
        ProximityPrompt.Name = "FeedPrompt";
        ProximityPrompt.ActionText = "Feed";
        local v96 = u92.marker:GetAttribute("PetName") or u92.petType;
        ProximityPrompt.ObjectText = tostring(v96);
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
        ProximityPrompt.MaxActivationDistance = 14;
        ProximityPrompt.HoldDuration = 0;
        ProximityPrompt.RequiresLineOfSight = false;
        ProximityPrompt.Enabled = holdingFruit();
        ProximityPrompt.Parent = u92.model.PrimaryPart;
        ProximityPrompt.Triggered:Connect(function() -- Line: 442
            -- upvalues: u92 (copy), Knit (ref)
            local u97 = u92;
            Knit.GetService("PlayerPlotService"):FeedPet(u97.uid):andThen(function(p98) -- Line: 248
                -- upvalues: u97 (copy), Knit (ref)
                local v99 = u97.model and u97.model.PrimaryPart;

                if not (p98 and v99) then
                    return;
                end;

                Knit.GetController("SoundController"):PlaySoundAtPosition("PetFeed", v99.Position);
            end);
        end);
        u92.feedPrompt = ProximityPrompt;
    end;
end;

local function pickCentre(p100) -- Line: 467
    local PrimaryPart = p100.model.PrimaryPart;

    if not p100.pickOffsetY then
        local v101, v102 = p100.model:GetBoundingBox();
        p100.pickOffsetY = v101.Position.Y - PrimaryPart.Position.Y;
        p100.pickReach = v102.Magnitude * 0.5;
    end;

    return PrimaryPart.Position + Vector3.new(0, p100.pickOffsetY, 0);
end;

local function screenRadius(p103, p104, p105) -- Line: 477
    local PrimaryPart = p104.model.PrimaryPart;

    if not p104.pickOffsetY then
        local v106, v107 = p104.model:GetBoundingBox();
        p104.pickOffsetY = v106.Position.Y - PrimaryPart.Position.Y;
        p104.pickReach = v107.Magnitude * 0.5;
    end;

    local v108 = p103:WorldToScreenPoint(PrimaryPart.Position + Vector3.new(0, p104.pickOffsetY, 0) + Vector3.new(0, p104.pickReach, 0)).Y - p105.Y;
    local v109 = math.abs(v108);

    return math.max(v109, 24);
end;

local function pickPetAt(p110) -- Line: 483
    -- upvalues: LocalPlayer (copy), u6 (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (CurrentCamera and Character) then
        return nil;
    end;

    local v111 = (1 / 0);
    local v112 = nil;

    for _, v in u6 do
        if v ~= true then
            local PrimaryPart = v.model.PrimaryPart;

            if PrimaryPart and (PrimaryPart.Parent and (PrimaryPart.Position - Character.Position).Magnitude <= 40) then
                local PrimaryPart2 = v.model.PrimaryPart;

                if not v.pickOffsetY then
                    local v113, v114 = v.model:GetBoundingBox();
                    v.pickOffsetY = v113.Position.Y - PrimaryPart2.Position.Y;
                    v.pickReach = v114.Magnitude * 0.5;
                end;

                local v115, v116 = CurrentCamera:WorldToScreenPoint(PrimaryPart2.Position + Vector3.new(0, v.pickOffsetY, 0));

                if v116 then
                    local Magnitude = (Vector2.new(v115.X, v115.Y) - p110).Magnitude;
                    local PrimaryPart3 = v.model.PrimaryPart;

                    if not v.pickOffsetY then
                        local v117, v118 = v.model:GetBoundingBox();
                        v.pickOffsetY = v117.Position.Y - PrimaryPart3.Position.Y;
                        v.pickReach = v118.Magnitude * 0.5;
                    end;

                    local v119 = CurrentCamera:WorldToScreenPoint(PrimaryPart3.Position + Vector3.new(0, v.pickOffsetY, 0) + Vector3.new(0, v.pickReach, 0)).Y - v115.Y;
                    local v120 = math.abs(v119);

                    if Magnitude <= math.max(v120, 24) and Magnitude < v111 then
                        v112 = v;
                        v111 = Magnitude;
                    end;
                end;
            end;
        end;
    end;

    return v112;
end;

local function pickPet() -- Line: 505
    -- upvalues: LocalPlayer (copy), UserInputService (copy), u6 (copy), GuiService (copy), pickPetAt (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (CurrentCamera and Character) then
        return nil;
    end;

    if not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) then
        local v121 = GuiService:GetGuiInset();
        local v122 = UserInputService:GetMouseLocation() - Vector2.new(v121.X, v121.Y);

        return pickPetAt(Vector2.new(v122.X, v122.Y));
    end;

    local Position = CurrentCamera.CFrame.Position;
    local LookVector = CurrentCamera.CFrame.LookVector;
    local v123 = 0.96;
    local v124 = nil;

    for _, v in u6 do
        if v ~= true then
            local PrimaryPart = v.model.PrimaryPart;

            if PrimaryPart and PrimaryPart.Parent then
                local v125 = PrimaryPart.Position - Position;
                local Magnitude = v125.Magnitude;

                if Magnitude <= 40 and Magnitude >= 1 then
                    local v126 = LookVector:Dot(v125 / Magnitude);

                    if v123 < v126 then
                        v124 = v;
                        v123 = v126;
                    end;
                end;
            end;
        end;
    end;

    return v124;
end;

local function gazePass() -- Line: 535
    -- upvalues: pickPet (copy), u6 (copy), u59 (ref), refreshInfoBillboard (copy)
    local v127 = pickPet();

    for _, v in u6 do
        if v ~= true then
            local v128 = v == v127;

            if v.infoBillboard then
                local v129;

                if v128 then
                    v129 = v ~= u59;
                else
                    v129 = v128;
                end;

                v.infoBillboard.Enabled = v129;

                if v128 then
                    refreshInfoBillboard(v);
                end;
            end;

            if v.highlight then
                v.highlight.Enabled = v128;
            end;
        end;
    end;

    return v127;
end;

local function buildVisual(p130, p131) -- Line: 552
    -- upvalues: PetConfig (copy), PetAssets (copy)
    local v132 = PetConfig.GetPet(p130);
    local v133;

    if v132 and v132.rig then
        v133 = PetAssets.resolveRig(v132.rig) or nil;
    else
        v133 = nil;
    end;

    local v134 = v133 or PetAssets.resolvePet(p130);

    if not v134 then
        return nil;
    end;

    local v135 = v134:Clone();
    v135.Name = "LocalPet_" .. p130;
    local v136 = {};

    if v133 then
        for _, descendant in v135:GetDescendants() do
            if descendant:IsA("Motor6D") then
                if descendant.Part0 then
                    v136[descendant.Part0] = true;
                end;

                if descendant.Part1 then
                    v136[descendant.Part1] = true;
                end;
            end;
        end;
    end;

    for _, descendant in v135:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = not v133 or descendant == v135.PrimaryPart;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;

            if v136[descendant] then
                descendant.Transparency = 1;
            end;
        end;
    end;

    v135:PivotTo(p131 * (v132 and v132.baseCF or CFrame.identity));

    local function bottomOf(p137) -- Line: 586
        local CFrame2 = p137.CFrame;
        local Size = p137.Size;

        return CFrame2.Position.Y - (math.abs(CFrame2.RightVector.Y) * Size.X + math.abs(CFrame2.UpVector.Y) * Size.Y + math.abs(CFrame2.LookVector.Y) * Size.Z) / 2;
    end;

    local v138 = v135:GetPivot();
    local v139 = (1 / 0);

    if v133 then
        for _, descendant in v135:GetDescendants() do
            if descendant:IsA("BasePart") then
                local CFrame2 = descendant.CFrame;
                local Size = descendant.Size;
                local v140 = CFrame2.Position.Y - (math.abs(CFrame2.RightVector.Y) * Size.X + math.abs(CFrame2.UpVector.Y) * Size.Y + math.abs(CFrame2.LookVector.Y) * Size.Z) / 2;
                v139 = math.min(v139, v140);
            end;
        end;
    else
        local Base = v135:FindFirstChild("Base");

        if Base and Base:IsA("BasePart") then
            local CFrame2 = Base.CFrame;
            local Size = Base.Size;
            v139 = CFrame2.Position.Y - (math.abs(CFrame2.RightVector.Y) * Size.X + math.abs(CFrame2.UpVector.Y) * Size.Y + math.abs(CFrame2.LookVector.Y) * Size.Z) / 2 or (1 / 0);
        else
            v139 = (1 / 0);
        end;
    end;

    if v139 ~= (1 / 0) then
        v135:PivotTo(v138 + Vector3.new(0, p131.Y - v139, 0));
    end;

    v135.Parent = workspace;

    return v135;
end;

local function registerPet(u141) -- Line: 610
    -- upvalues: u6 (copy), findPlotDirt (copy), buildVisual (copy), PetConfig (copy), u5 (copy), PlotFootprint (copy), setupAnimation (copy), setupFlapSound (copy), setPose (copy), setupBillboards (copy), u59 (ref)
    if u6[u141] then
        return;
    end;

    u6[u141] = true;
    task.spawn(function() -- Line: 614
        -- upvalues: u141 (copy), u6 (ref), findPlotDirt (ref), buildVisual (ref), PetConfig (ref), u5 (ref), PlotFootprint (ref), setupAnimation (ref), setupFlapSound (ref), setPose (ref), setupBillboards (ref)
        local v142 = os.clock() + 10;
        local v143, v144;

        while true do
            v143 = u141:GetAttribute("PetType");
            v144 = u141:GetAttribute("Anchor");

            if v143 and v144 then
                break;
            end;

            task.wait(0.2);

            if v142 < os.clock() or u141.Parent == nil then
                break;
            end;
        end;

        if not v143 or (not v144 or u141.Parent == nil) then
            u6[u141] = nil;

            return;
        end;

        local Parent = u141.Parent;
        local v145 = findPlotDirt(Parent);

        if not v145 then
            u6[u141] = nil;

            return;
        end;

        local v146 = buildVisual(v143, v144);

        if not (v146 and v146.PrimaryPart) then
            u6[u141] = nil;

            return;
        end;

        local v147 = v146:GetPivot();
        local _, v148 = v146:GetBoundingBox();
        local v149 = PetConfig.GetPet(v143);
        local v150 = v149 and v149.yawFlip or PetConfig.DefaultYawFlip;
        local v151 = v145.Position.Y + v145.Size.Y / 2;
        local v152 = {
            flightStart = nil,
            target = nil,
            moving = nil,
            model = v146,
            marker = u141,
            uid = u141.Name:sub(9),
            ownerId = u141:GetAttribute("OwnerUserId"),
            petType = v143,
            dirt = v145,
            plotModel = Parent,
            radius = math.max(v148.X, v148.Z) / 2,
            yawFlip = v150,
            baseCF = v149 and v149.baseCF or CFrame.identity,
            pos = v149 and v149.flying and Vector3.new(v147.Position.X, v151 + PetConfig.FlightHeight, v147.Position.Z) or v147.Position,
            cruiseY = v149 and v149.flying and v151 + PetConfig.FlightHeight or v147.Position.Y,
            restY = v147.Position.Y
        };
        local v153;

        if v149 then
            v153 = v149.flying or false;
        else
            v153 = false;
        end;

        v152.flying = v153;
        v152.departY = v149 and v149.flying and v151 + PetConfig.FlightHeight or v147.Position.Y;
        v152.speedMult = v149 and v149.speedMult or 1;
        local LookVector = v147.LookVector;
        v152.yaw = math.atan2(-LookVector.X, -LookVector.Z) + v150;
        v152.waitUntil = os.clock() + u5:NextNumber(0, 10);
        v152.obstacles = PlotFootprint.collectObstacles(Parent, v151);
        v152.obstacleRefresh = os.clock() + 5;
        v152.groundY = v151;
        setupAnimation(v152);
        setupFlapSound(v152);
        setPose(v152, "idle");
        setupBillboards(v152);
        u6[u141] = v152;
    end);
    u141.AncestryChanged:Connect(function(p154, p155) -- Line: 682
        -- upvalues: u6 (ref), u141 (copy), u59 (ref)
        if p155 == nil then
            local v156 = u6[u141];

            if type(v156) == "table" then
                if v156.model then
                    v156.model:Destroy();
                end;

                if v156.infoBillboard then
                    v156.infoBillboard:Destroy();
                end;

                if v156.actionBillboard then
                    v156.actionBillboard:Destroy();
                end;

                if u59 == v156 then
                    u59 = nil;
                end;
            end;

            u6[u141] = nil;
        end;
    end);
end;

local function tryRegister(p157) -- Line: 696
    -- upvalues: registerPet (copy)
    if p157:IsA("Configuration") and p157.Name:sub(1, 8) == "PlotPet_" then
        registerPet(p157);
    end;
end;

local function stepPet(p158, p159, p160) -- Line: 702
    -- upvalues: u5 (copy), playPetSound (copy), u59 (ref), PlotFootprint (copy), TreeMountPoint (copy), setPose (copy), pickTarget (copy), u1 (copy)
    if p158.model then
        p158.nextSoundAt = p158.nextSoundAt or p159 + (6 + u5:NextNumber() * 6);

        if p158.nextSoundAt <= p159 then
            p158.nextSoundAt = p159 + (6 + u5:NextNumber() * 6);
            playPetSound(p158.petType, p158.model.PrimaryPart);
        end;
    end;

    if p158 == u59 then
        return;
    end;

    if p158.obstacleRefresh <= p159 then
        p158.obstacles = PlotFootprint.collectObstacles(p158.plotModel, p158.groundY);
        p158.obstacleRefresh = p159 + 5;
    end;

    local v161 = p158.marker:GetAttribute("PeckTarget");

    if v161 ~= p158.peckTarget then
        p158.peckTarget = v161;
        p158.target = nil;
        p158.waitUntil = nil;
    end;

    if v161 then
        local v162 = p158.plotModel:FindFirstChild(v161);
        p158.mountCF = TreeMountPoint.perchCF(v162);

        if p158.mountCF then
            local Position = p158.mountCF.Position;
            p158.target = Vector3.new(Position.X, p158.pos.Y, Position.Z);
        end;
    else
        p158.mountCF = nil;
    end;

    if p158.waitUntil and p159 < p158.waitUntil then
        setPose(p158, v161 and p158.peckTrack and "peck" or "idle");

        return;
    end;

    p158.waitUntil = nil;

    if not p158.target then
        local v163 = pickTarget(p158);

        if not v163 then
            p158.waitUntil = p159 + 1;

            return;
        end;

        p158.target = Vector3.new(v163.X, p158.pos.Y, v163.Z);
        p158.flightStart = p158.pos;
        p158.departY = p158.pos.Y;
    end;

    local v164 = Vector3.new(p158.target.X - p158.pos.X, 0, p158.target.Z - p158.pos.Z);
    local Magnitude = v164.Magnitude;
    local v165 = 3.5 * p158.speedMult * p160;

    if Magnitude > 0.01 then
        local Unit = v164.Unit;
        local v166 = (math.atan2(-Unit.X, -Unit.Z) - p158.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;
        p158.yaw = p158.yaw + math.clamp(v166, p160 * -3, p160 * 3);
        v165 = math.abs(v166) > 0.6 and 0 or v165;
    end;

    local v167;

    if v165 > 0 then
        v167 = Magnitude > 0.01;
    else
        v167 = false;
    end;

    setPose(p158, v167 and "run" or "idle");

    if Magnitude <= v165 then
        p158.pos = p158.target;
        p158.target = nil;

        if v161 and p158.mountCF then
            p158.pos = p158.mountCF.Position;
            p158.model:PivotTo(p158.mountCF * u1 * p158.baseCF);
            p158.waitUntil = (1 / 0);

            return;
        end;

        p158.waitUntil = p159 + u5:NextNumber(6, 10);
    elseif v165 > 0 then
        p158.pos = p158.pos + v164.Unit * v165;

        if v161 and p158.mountCF then
            local Y = p158.mountCF.Position.Y;
            local v168 = math.clamp(Magnitude / 12, 0, 1);
            p158.pos = Vector3.new(p158.pos.X, Y + (p158.cruiseY - Y) * v168, p158.pos.Z);
        end;
    end;

    if p158.cruiseY ~= p158.restY and not v161 then
        local v169;

        if p158.flightStart then
            local pos = p158.pos;
            local flightStart = p158.flightStart;
            v169 = Vector3.new(pos.X - flightStart.X, 0, pos.Z - flightStart.Z).Magnitude or 0;
        else
            v169 = 0;
        end;

        local v170;

        if p158.target then
            local pos = p158.pos;
            local target = p158.target;
            v170 = Vector3.new(pos.X - target.X, 0, pos.Z - target.Z).Magnitude or 0;
        else
            v170 = 0;
        end;

        local v171 = math.clamp(v169 / 10, 0, 1);
        local v172 = math.clamp(v170 / 10, 0, 1);
        local v173 = p158.departY + (p158.cruiseY - p158.departY) * v171;
        p158.pos = Vector3.new(p158.pos.X, v173 + (p158.restY - v173) * (1 - v172), p158.pos.Z);
    end;

    p158.model:PivotTo(CFrame.new(p158.pos) * CFrame.Angles(0, p158.yaw + p158.yawFlip, 0) * p158.baseCF);
end;

local function setupHeldPets() -- Line: 811
    -- upvalues: PetConfig (copy), PetAssets (copy), u3 (copy), RunService (copy), LocalPlayer (copy)
    local u174 = nil;
    local u175 = nil;
    local u176 = nil;
    local u177 = nil;
    local u178 = nil;
    local u179 = {};

    local function showServerModel() -- Line: 819
        -- upvalues: u178 (ref)
        if not u178 then
            return;
        end;

        for _, descendant in u178:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 0;
            end;
        end;

        u178 = nil;
    end;

    local function clear() -- Line: 827
        -- upvalues: u176 (ref), u175 (ref), u174 (ref), showServerModel (copy), u177 (ref)
        if u176 then
            u176:Disconnect();
        end;

        if u175 then
            u175:Stop(0);
        end;

        if u174 then
            u174:Destroy();
        end;

        showServerModel();
        u174 = nil;
        u175 = nil;
        u176 = nil;
        u177 = nil;
    end;

    local function attach(p180) -- Line: 835
        -- upvalues: u177 (ref), u174 (ref), u176 (ref), u175 (ref), showServerModel (copy), PetConfig (ref), PetAssets (ref), u178 (ref), u3 (ref), RunService (ref)
        if u177 == p180 and u174 then
            return;
        end;

        if u176 then
            u176:Disconnect();
        end;

        if u175 then
            u175:Stop(0);
        end;

        if u174 then
            u174:Destroy();
        end;

        showServerModel();
        u174 = nil;
        u175 = nil;
        u176 = nil;
        u177 = nil;
        local v181 = p180:GetAttribute("PetType");

        if v181 then
            v181 = PetConfig.GetPet(v181);
        end;

        local v182 = v181 and v181.rig and PetAssets.resolveRig(v181.rig);
        local Handle = p180:FindFirstChild("Handle");

        if not (v182 and (v181.idleAnim and Handle)) then
            return;
        end;

        u177 = p180;
        local u183 = p180:FindFirstChildWhichIsA("Model");

        if u183 then
            u178 = u183;

            for _, descendant in u183:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = 1;
                end;
            end;
        end;

        local u184 = v182:Clone();
        u184.Name = "HeldPetRig";
        local PrimaryPart = u184.PrimaryPart;

        if not PrimaryPart then
            u184:Destroy();

            return;
        end;

        local v185 = {};

        for _, descendant in u184:GetDescendants() do
            if descendant:IsA("Motor6D") then
                if descendant.Part0 then
                    v185[descendant.Part0] = true;
                end;

                if descendant.Part1 then
                    v185[descendant.Part1] = true;
                end;
            end;
        end;

        local _, v186 = u184:GetBoundingBox();
        local v187 = math.max(v186.X, v186.Y, v186.Z);

        if v187 > 6 then
            u184:ScaleTo(6 / v187);
        end;

        for _, descendant in u184:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = false;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Massless = true;

                if v185[descendant] then
                    descendant.Transparency = 1;
                end;
            end;
        end;

        PrimaryPart.Anchored = true;
        local u188 = u3 * (v181.baseCF or CFrame.identity);
        u184:PivotTo(Handle.CFrame * u188);
        u184.Parent = workspace;
        u174 = u184;
        u176 = RunService.RenderStepped:Connect(function() -- Line: 887
            -- upvalues: u184 (copy), Handle (copy), u188 (copy), u175 (ref), u178 (ref)
            if not (u184.Parent and Handle.Parent) then
                return;
            end;

            u184:PivotTo(Handle.CFrame * u188);

            if u175 and not u175.IsPlaying then
                u175:Play(0);
            end;

            if u178 then
                for _, descendant in u178:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = 1;
                    end;
                end;
            end;
        end);
        local v189 = u184:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController");
        local u190 = v189:FindFirstChildOfClass("Animator") or Instance.new("Animator");
        u190.Parent = v189;
        v189.Parent = u184;
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://" .. tostring(v181.idleAnim);
        local success, result = pcall(function() -- Line: 908
            -- upvalues: u190 (copy), Animation (copy)
            return u190:LoadAnimation(Animation);
        end);

        if success and result then
            result.Looped = true;
            result:Play(0);
            u175 = result;
        end;

        task.delay(0.5, function() -- Line: 916
            -- upvalues: u174 (ref), u184 (copy), u190 (copy), u176 (ref), u175 (ref), showServerModel (ref), u177 (ref), u183 (copy)
            if u174 ~= u184 then
                return;
            end;

            local v191 = false;

            for _, v in u190:GetPlayingAnimationTracks() do
                if v.WeightCurrent > 0 then
                    v191 = true;
                    break;
                end;
            end;

            if v191 then
                return;
            end;

            if u176 then
                u176:Disconnect();
            end;

            if u175 then
                u175:Stop(0);
            end;

            if u174 then
                u174:Destroy();
            end;

            showServerModel();
            u174 = nil;
            u175 = nil;
            u176 = nil;
            u177 = nil;

            if u183 then
                for _, descendant in u183:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = 0;
                    end;
                end;
            end;
        end);
    end;

    local function watch(u192) -- Line: 932
        -- upvalues: u176 (ref), u175 (ref), u174 (ref), showServerModel (copy), u177 (ref), u179 (ref), attach (copy)
        if u176 then
            u176:Disconnect();
        end;

        if u175 then
            u175:Stop(0);
        end;

        if u174 then
            u174:Destroy();
        end;

        showServerModel();
        u174 = nil;
        u175 = nil;
        u176 = nil;
        u177 = nil;

        for _, v in u179 do
            v:Disconnect();
        end;

        u179 = {};

        local function onChild(u193) -- Line: 937
            -- upvalues: u192 (copy), attach (ref)
            if not u193:IsA("Tool") then
                return;
            end;

            task.spawn(function() -- Line: 939
                -- upvalues: u193 (copy), u192 (ref), attach (ref)
                local v194 = os.clock() + 10;

                while u193.Parent == u192 and os.clock() < v194 do
                    if u193:GetAttribute("IsPet") and u193:GetAttribute("PetType") then
                        attach(u193);

                        return;
                    end;

                    task.wait(0.1);
                end;
            end);
        end;

        for _, child in u192:GetChildren() do
            if child:IsA("Tool") then
                task.spawn(function() -- Line: 939
                    -- upvalues: child (copy), u192 (copy), attach (ref)
                    local v195 = os.clock() + 10;

                    while child.Parent == u192 and os.clock() < v195 do
                        if child:GetAttribute("IsPet") and child:GetAttribute("PetType") then
                            attach(child);

                            return;
                        end;

                        task.wait(0.1);
                    end;
                end);
            end;
        end;

        table.insert(u179, u192.ChildAdded:Connect(onChild));
        table.insert(u179, u192.ChildRemoved:Connect(function(p196) -- Line: 952
            -- upvalues: u176 (ref), u175 (ref), u174 (ref), showServerModel (ref), u177 (ref)
            if p196:IsA("Tool") and p196:GetAttribute("IsPet") then
                if u176 then
                    u176:Disconnect();
                end;

                if u175 then
                    u175:Stop(0);
                end;

                if u174 then
                    u174:Destroy();
                end;

                showServerModel();
                u174 = nil;
                u175 = nil;
                u176 = nil;
                u177 = nil;
            end;
        end));
    end;

    if LocalPlayer.Character then
        watch(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(watch);
end;

local function refreshFeedPrompts() -- Line: 961
    -- upvalues: holdingFruit (copy), u6 (copy)
    local v197 = holdingFruit();

    for _, v in u6 do
        if v ~= true and (v.feedPrompt and v.feedPrompt.Parent) then
            v.feedPrompt.Enabled = v197;
        end;
    end;
end;

local function watchHeldFruit(p198) -- Line: 971
    -- upvalues: refreshFeedPrompts (copy)
    p198.ChildAdded:Connect(function(p199) -- Line: 972
        -- upvalues: refreshFeedPrompts (ref)
        if p199:IsA("Tool") then
            task.defer(refreshFeedPrompts);
        end;
    end);
    p198.ChildRemoved:Connect(function(p200) -- Line: 975
        -- upvalues: refreshFeedPrompts (ref)
        if p200:IsA("Tool") then
            task.defer(refreshFeedPrompts);
        end;
    end);
    refreshFeedPrompts();
end;

function v4.KnitStart(p201) -- Line: 981
    -- upvalues: u56 (ref), LocalPlayer (copy), u47 (ref), Knit (copy), watchHeldFruit (copy), u6 (copy), CustomEnum (copy), u2 (copy), setupHeldPets (copy), u5 (copy), playPetSound (copy), registerPet (copy), RunService (copy), stepPet (copy), u10 (ref), gazePass (copy), u59 (ref), UserInputService (copy), hitActionButton (copy), pickPetAt (copy), pickPet (copy), ensureActionBillboard (copy)
    u56 = LocalPlayer:WaitForChild("PlayerGui");
    u47 = Knit.GetController("UI_Manager");

    if LocalPlayer.Character then
        watchHeldFruit(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(watchHeldFruit);
    Knit.GetController("UserInputParser").InputTypeChanged:Connect(function() -- Line: 990
        -- upvalues: u6 (ref), Knit (ref), CustomEnum (ref), u2 (ref)
        for _, v in u6 do
            if v ~= true then
                if v.infoBillboard and v.infoBaseSize then
                    local infoBillboard = v.infoBillboard;
                    local infoBaseSize = v.infoBaseSize;
                    local v202 = Knit.GetController("UserInputParser");
                    local v203;

                    if v202 == nil then
                        v203 = false;
                    else
                        v203 = v202:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
                    end;

                    if v203 then
                        infoBaseSize = UDim2.new(infoBaseSize.X.Scale * 0.5, infoBaseSize.X.Offset * 0.5, infoBaseSize.Y.Scale * 0.5, infoBaseSize.Y.Offset * 0.5);
                    end;

                    infoBillboard.Size = infoBaseSize;
                end;

                if v.actionBillboard then
                    local actionBillboard = v.actionBillboard;
                    local v204 = u2;
                    local v205 = Knit.GetController("UserInputParser");
                    local v206;

                    if v205 == nil then
                        v206 = false;
                    else
                        v206 = v205:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
                    end;

                    if v206 then
                        v204 = UDim2.new(v204.X.Scale * 0.5, v204.X.Offset * 0.5, v204.Y.Scale * 0.5, v204.Y.Offset * 0.5);
                    end;

                    actionBillboard.Size = v204;
                end;
            end;
        end;
    end);
    setupHeldPets();
    task.spawn(function() -- Line: 1006
        -- upvalues: u5 (ref), LocalPlayer (ref), playPetSound (ref)
        while true do
            task.wait(6 + u5:NextNumber() * 6);
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChildWhichIsA("Tool");
            end;

            local v207;

            if Character then
                v207 = Character:FindFirstChild("Handle");
            else
                v207 = Character;
            end;

            if v207 then
                playPetSound(Character:GetAttribute("PetType"), v207);
            end;
        end;
    end);

    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("Configuration") and descendant.Name:sub(1, 8) == "PlotPet_" then
            registerPet(descendant);
        end;
    end;

    workspace.DescendantAdded:Connect(function(p208) -- Line: 1019
        -- upvalues: registerPet (ref)
        if p208:IsA("Configuration") and p208.Name:sub(1, 8) == "PlotPet_" then
            registerPet(p208);
        end;
    end);
    local u209 = {};

    local function trackEgg(u210) -- Line: 1029
        -- upvalues: u209 (copy)
        if not u210:IsA("Model") or u210.Name:sub(1, 8) ~= "PlotEgg_" then
            return;
        end;

        task.spawn(function() -- Line: 1031
            -- upvalues: u210 (copy), u209 (ref)
            local v211 = os.clock() + 10;
            local v212;

            while true do
                v212 = u210:FindFirstChildWhichIsA("ProximityPrompt", true);

                if v212 then
                    break;
                end;

                task.wait(0.2);

                if v211 < os.clock() or u210.Parent == nil then
                    return;
                end;
            end;

            u209[u210] = v212;
        end);
    end;

    for _, descendant in workspace:GetDescendants() do
        trackEgg(descendant);
    end;

    workspace.DescendantAdded:Connect(trackEgg);
    task.spawn(function() -- Line: 1043
        -- upvalues: LocalPlayer (ref), u209 (copy), CustomEnum (ref)
        while true do
            task.wait(0.4);
            local Character = LocalPlayer.Character;

            if Character then
                Character = Character:FindFirstChild("HumanoidRootPart");
            end;

            local v213 = (1 / 0);
            local v214 = nil;

            for i, v in u209 do
                if i.Parent and v.Parent then
                    local v215;

                    if i:GetAttribute("EggState") == CustomEnum.EGG_STATE.HATCHING then
                        v215 = false;
                    else
                        v215 = v.ActionText ~= "Open" and true or i:GetAttribute("OwnerUserId") == LocalPlayer.UserId;
                    end;

                    if v215 and Character then
                        local Magnitude = (i:GetPivot().Position - Character.Position).Magnitude;

                        if Magnitude <= v.MaxActivationDistance and Magnitude < v213 then
                            v214 = i;
                            v213 = Magnitude;
                        end;
                    end;
                else
                    u209[i] = nil;
                end;
            end;

            for i, v in u209 do
                if i.Parent and v.Parent then
                    v.Enabled = i == v214;
                end;
            end;
        end;
    end);
    RunService.Heartbeat:Connect(function(p216) -- Line: 1076
        -- upvalues: u6 (ref), stepPet (ref), u10 (ref), gazePass (ref), u59 (ref)
        local v217 = os.clock();

        for i, v in u6 do
            if v ~= true then
                if i.Parent then
                    stepPet(v, v217, p216);
                else
                    u6[i] = nil;
                end;
            end;
        end;

        u10 = gazePass();

        if u59 and (u59.actionBillboard and not u59.model.Parent) then
            if u59 and u59.actionBillboard then
                u59.actionBillboard.Enabled = false;
            end;

            u59 = nil;
        end;
    end);
    UserInputService.InputBegan:Connect(function(p218, p219) -- Line: 1091
        -- upvalues: hitActionButton (ref), Knit (ref), CustomEnum (ref), pickPetAt (ref), pickPet (ref), u10 (ref), u59 (ref), LocalPlayer (ref), ensureActionBillboard (ref)
        if p219 then
            return;
        end;

        if p218.UserInputType ~= Enum.UserInputType.MouseButton1 and p218.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local Position = p218.Position;
        local v220 = Vector2.new(Position.X, Position.Y);

        if hitActionButton(v220) then
            return;
        end;

        local v221 = Knit.GetController("UserInputParser");
        local v222;

        if v221 == nil then
            v222 = false;
        else
            v222 = v221:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
        end;

        local v223;

        if v222 then
            v223 = pickPetAt(v220);
        else
            v223 = pickPet() or u10;
        end;

        if not v223 then
            if u59 and u59.actionBillboard then
                u59.actionBillboard.Enabled = false;
            end;

            u59 = nil;

            return;
        end;

        if v223.ownerId and v223.ownerId ~= LocalPlayer.UserId then
            if u59 and u59.actionBillboard then
                u59.actionBillboard.Enabled = false;
            end;

            u59 = nil;
            local v224 = Knit.GetController("ViewPetController");

            if v224 and v224.Open then
                v224.Open(v223.uid);
            end;

            return;
        end;

        if u59 == v223 then
            if u59 and u59.actionBillboard then
                u59.actionBillboard.Enabled = false;
            end;

            u59 = nil;

            return;
        end;

        if u59 and u59.actionBillboard then
            u59.actionBillboard.Enabled = false;
        end;

        u59 = nil;
        local v225 = ensureActionBillboard(v223);

        if v225 then
            v225.Enabled = true;
            u59 = v223;
        end;
    end);
end;

function v4.HideActionBillboard(p226) -- Line: 1131
    -- upvalues: u59 (ref)
    if u59 and u59.actionBillboard then
        u59.actionBillboard.Enabled = false;
    end;

    u59 = nil;
end;

return v4;