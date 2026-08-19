-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local AddDebris = require(ReplicatedStorage.Library.Functions.AddDebris);
local AssetColorUtil = require(ReplicatedStorage.Library.Util.AssetColorUtil);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local AssetInvertedModelPresentation = require(ReplicatedStorage.Library.Modules.AssetInvertedModelPresentation);
local AssetModels = require(ReplicatedStorage.Library.Modules.AssetModels);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local ExpRetry = require(ReplicatedStorage.Library.Functions.ExpRetry);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local AssetSoundUtil = require(ReplicatedStorage.Library.Util.AssetSoundUtil);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local Physics = require(ReplicatedStorage.Library.Modules.Physics);
local SpecialLuckyBlockAsset = require(ReplicatedStorage.Library.Util.SpecialLuckyBlockAsset);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u2 = Vector2.new(70, 30);
local Data = ReplicatedStorage.Assets.Extra.Data;
local u3 = {};

local function getDisplayWeight(p4, p5) -- Line: 69
    -- upvalues: Assets (copy)
    return (tonumber(Assets.Directory[p4].ModelWeight) or 1) * (typeof(p5) ~= "number" and 1 or math.max(p5, 0));
end;

local function getOrderedDisplayMutations(p6, p7) -- Line: 83
    local u8 = table.create(#p6 + 1);
    local u9 = {};

    local function addMutation(p10) -- Line: 87
        -- upvalues: u9 (copy), u8 (copy)
        if p10 == nil or (p10 == "" or u9[p10]) then
            return;
        end;

        u9[p10] = true;
        table.insert(u8, p10);
    end;

    if p7 ~= nil and (p7 ~= "" and not u9[p7]) then
        u9[p7] = true;
        table.insert(u8, p7);
    end;

    for _, v in ipairs(p6) do
        if v ~= nil and v ~= "" then
            if not u9[v] then
                u9[v] = true;
                table.insert(u8, v);
            end;
        end;
    end;

    return u8;
end;

local function getAssetDisplayName(p11, p12, p13) -- Line: 104
    -- upvalues: getOrderedDisplayMutations (copy), Mutations (copy)
    local v14 = getOrderedDisplayMutations(p12, p13);

    if #v14 == 0 then
        return p11;
    end;

    local v15 = table.create(#v14);

    for i, v in ipairs(v14) do
        v15[i] = Mutations.GetDisplayName(v);
    end;

    return `{table.concat(v15, " + ")} {p11}`;
end;

local function formatToolName(p16, p17, p18, p19) -- Line: 118
    -- upvalues: getAssetDisplayName (copy)
    return string.format("%s (%.2f kg)", getAssetDisplayName(p16, p17, p18), p19);
end;

local function escapeRichText(p20) -- Line: 122
    return p20:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;");
end;

local function formatMutationRichText(p21) -- Line: 126
    -- upvalues: Mutations (copy)
    local v22 = Mutations.GetMutation(p21);

    if v22 == nil then
        return nil;
    end;

    local Color = v22.Color;
    local v23 = Mutations.GetDisplayName(p21);

    return `<font color="#{Color:ToHex()}">{v23:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")}</font>`;
end;

local function getDisplayMutationState(p24, p25) -- Line: 183
    -- upvalues: AssetSoundUtil (copy)
    local v26, v27 = AssetSoundUtil.GetMutationStateFromAttributes(p24, "Mutations", "BaseMutation");

    if #v26 > 0 or v27 then
        return v26, v27;
    end;

    if p25 then
        return p25.Mutations or {}, p25.BaseMutation;
    end;

    return {}, nil;
end;

local function baseCreateModel(p28, p29) -- Line: 200
    -- upvalues: AssetItem (copy), AssetModels (copy), AssetColorUtil (copy), Mutations (copy), Assets (copy), Personalities (copy), AssetInvertedModelPresentation (copy)
    assert(AssetItem.AssetItemData(p28));
    local Category = p28.Category;
    local Scale = p28.Scale;
    local Mutations2 = p28.Mutations;
    local v30 = AssetModels.GetModelTemplate(Category);
    local v31 = `couldn't find model for: {Category}`;
    local v32 = assert(v30, v31):Clone();
    v32.PrimaryPart = v32:FindFirstChild("Segment1", true) or v32.PrimaryPart;
    local PrimaryPart = v32.PrimaryPart;
    local v33 = `couldn't find model primary for: "{Category}"`;
    assert(PrimaryPart, v33);

    for _, descendant in ipairs(v32:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CanQuery = descendant.Transparency ~= 1;

            if descendant.Transparency == 1 or p29 then
                descendant.CanCollide = false;
            end;
        end;
    end;

    local v34 = AssetColorUtil.ResolveFields(Category, p28.EyeColor, p28.ColorSeed, p28.ColorIndex);
    AssetColorUtil.Apply(v32, Category, v34.EyeColor, v34.ColorSeed, v34.ColorIndex);
    local v35 = Mutations.FilterMutationsForCombo(Mutations2);

    for _, v in ipairs(v35) do
        Mutations.AddMutationByName(v32, v, nil, v34.ColorSeed);
    end;

    local BaseModelScale = Assets.Directory[Category].BaseModelScale;
    v32:ScaleTo((typeof(Scale) ~= "number" and 1 or math.max(Scale, 0)) * BaseModelScale);

    if p28.Personality == Personalities.Personalities.InvertedModel then
        AssetInvertedModelPresentation.Apply(v32);
    end;

    return v32;
end;

local function destroyInstancesClockSliced(p36) -- Line: 247
    local v37 = os.clock();

    for i, v in ipairs(p36) do
        v:Destroy();

        if i < #p36 and os.clock() - v37 >= 0.002 then
            task.wait();
            v37 = os.clock();
        end;
    end;
end;

function u3.StripRuntimeRig(p38, p39, p40) -- Line: 260
    -- upvalues: Asserts (copy), destroyInstancesClockSliced (copy)
    Asserts.Model(p38);
    local v41 = p38.PrimaryPart or p38:FindFirstChild("HumanoidRootPart", true);
    local v42 = {};

    for _, descendant in ipairs(p38:GetDescendants()) do
        if (descendant:IsA("Humanoid") or (descendant:IsA("AnimationController") or (descendant:IsA("Animator") or descendant:IsA("Bone")))) and not (descendant:IsA("Bone") and p39 or (descendant:IsA("AnimationController") or descendant:IsA("Animator")) and p40) then
            v42[#v42 + 1] = descendant;
        end;
    end;

    destroyInstancesClockSliced(v42);

    if v41 and v41:IsA("BasePart") then
        p38.PrimaryPart = v41;
    end;
end;

local function attachDataBillboard(u43, p44, u45, u46) -- Line: 290
    -- upvalues: Asserts (copy), AssetItem (copy), Data (copy), u2 (copy), Assets (copy), Personalities (copy), getDisplayMutationState (copy), getAssetDisplayName (copy), AssetGenerationUtil (copy), Simple (copy)
    Asserts.string(p44);

    if u46 ~= nil then
        Asserts.number(u46);
    end;

    local CENTER = u43:FindFirstChild("CENTER");

    if not (CENTER and CENTER:IsA("BasePart")) then
        return nil;
    end;

    if u45 then
        assert(AssetItem.AssetItemData(u45));
    end;

    local u47 = Data:Clone();
    u47.Adornee = CENTER;
    local Mutations2 = u47:FindFirstChild("Mutations");

    if Mutations2 then
        Mutations2:Destroy();
    end;

    local BaseMutation = u47:FindFirstChild("BaseMutation");

    if BaseMutation then
        BaseMutation:Destroy();
    end;

    local Size = CENTER.Size;
    u47.Size = UDim2.fromScale(math.min(u2.X, u47.Size.X.Scale * (Size.X / 0.8610000014305115)), (math.min(u2.Y, u47.Size.Y.Scale * (Size.Y / 0.7670000195503235))));
    local u48 = Assets.Directory[p44];
    local DisplayName = u47.DisplayName;
    local PerSecond = u47.PerSecond;
    local Rarity = u47:FindFirstChild("Rarity");
    local Odds = u47:FindFirstChild("Odds");
    local u49 = u45 or {
        BaseMutation = nil,
        Scale = 1,
        HasBeenFirstPlaced = true,
        Category = p44,
        Mutations = {},
        Personality = Personalities.Personalities.Normal
    };

    if Rarity then
        for _, child in ipairs(Rarity:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy();
            end;
        end;

        Rarity.Visible = false;
        Rarity.Text = "";
    end;

    if Odds then
        for _, child in ipairs(Odds:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy();
            end;
        end;

        local Rarity2 = u48.Rarity;

        if Rarity2 and Rarity2.Gradient then
            Rarity2.Gradient:Clone().Parent = Odds;
        end;

        Odds.Text = u48.Rarity.DisplayName;
        Odds.Visible = true;
    end;

    (function() -- Line: 384, Name: updateBillboard
        -- upvalues: getDisplayMutationState (ref), u43 (copy), u45 (copy), u47 (copy), u48 (copy), getAssetDisplayName (ref), u46 (copy), AssetGenerationUtil (ref), u49 (copy), PerSecond (copy), Simple (ref)
        local v50, v51 = getDisplayMutationState(u43, u45);
        local v52 = u47;
        local DisplayName2 = u48.DisplayName;
        local DisplayName3 = v52:FindFirstChild("DisplayName");

        if DisplayName3 then
            DisplayName3.RichText = true;
            DisplayName3.Text = getAssetDisplayName(DisplayName2, v50, v51);
        end;

        local Level = v52:FindFirstChild("Level");

        if Level then
            Level.Visible = false;
            Level.Text = "";
        end;

        local v53 = u46 == nil and 0 or u46;

        if u46 == nil then
            local success, result = pcall(AssetGenerationUtil.GetRate, u49, 0);
            v53 = not success and 0 or result;
        end;

        if PerSecond then
            if v53 > 0 then
                PerSecond.Visible = true;
                PerSecond.Text = "$" .. Simple.FormatCompact(v53) .. "/s";

                return;
            end;

            PerSecond.Visible = false;
            PerSecond.Text = "";
        end;
    end)();
    u47.Parent = u43;

    return u47, DisplayName, PerSecond;
end;

u3.CreateDataBillboard = attachDataBillboard;

function u3.SetDataBillboardMoneyPerSecond(p54, p55) -- Line: 423
    -- upvalues: Asserts (copy), Simple (copy)
    Asserts.Instance(p54);
    Asserts.number(p55);
    local PerSecond = p54:FindFirstChild("PerSecond");
    local v56;

    if PerSecond == nil then
        v56 = false;
    else
        v56 = PerSecond:IsA("TextLabel");
    end;

    assert(v56, "Data billboard must expose a PerSecond label");

    if p55 > 0 then
        PerSecond.Visible = true;
        PerSecond.Text = "$" .. Simple.FormatCompact(p55) .. "/s";

        return;
    end;

    PerSecond.Visible = false;
    PerSecond.Text = "";
end;

function u3.CreateModel(p57, p58) -- Line: 441
    -- upvalues: baseCreateModel (copy)
    return baseCreateModel(p57);
end;

function u3.CreateWanderingAssetModel(p59, p60, p61, p62) -- Line: 445
    -- upvalues: Asserts (copy), AssetItem (copy), baseCreateModel (copy), BBFromModelVisibleOnly (copy)
    Asserts.number(p59);
    Asserts.string(p60);
    Asserts.Instance(p62);
    assert(AssetItem.AssetItemData(p61));
    local v63 = baseCreateModel(p61, true);
    v63.Name = `{p59}_{p60}`;
    local PrimaryPart = v63.PrimaryPart;
    local v64 = `Asset model {p61.Category} must have a PrimaryPart`;
    local v65 = assert(PrimaryPart, v64);
    local v66, v67 = BBFromModelVisibleOnly(v63);
    v65.PivotOffset = CFrame.new(0, v66.Position.Y - v67.Y * 0.5 - v65.Position.Y, 0);

    for _, descendant in v63:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = descendant.Transparency ~= 1;
            descendant.CanTouch = false;
            descendant.Massless = true;
            descendant.Anchored = false;
        end;
    end;

    v65.Anchored = true;
    v63:SetAttribute("UID", p60);
    v63:SetAttribute("OwnerUserId", p59);
    v63.Parent = p62;

    return v63;
end;

function u3.GetVisibleBounds(p68) -- Line: 480
    -- upvalues: AssetItem (copy), AssetModels (copy)
    assert(AssetItem.AssetItemData(p68));
    local v69 = AssetModels.GetVisibleBoundsData(p68.Category);
    local TemplateScale = v69.TemplateScale;
    local v70 = `Asset model {p68.Category} scale must be greater than 0`;
    assert(TemplateScale > 0, v70);

    return v69.Size / TemplateScale;
end;

function u3.CreateActiveModelWithHumanoid(p71, p72) -- Line: 490
    -- upvalues: u3 (copy)
    return u3.CreateActiveModel(p71, p72);
end;

function u3.CreateActiveModel(p73, p74, p75, p76, p77) -- Line: 497
    -- upvalues: Asserts (copy), baseCreateModel (copy), SpecialLuckyBlockAsset (copy), Assets (copy), Constants (copy), ExpRetry (copy), u1 (copy), u3 (copy)
    Asserts.optional.string(p73);
    local u78 = baseCreateModel(p74, true);
    assert(u78.PrimaryPart, "model is missing PrimaryPart").Anchored = true;
    u78:SetAttribute("SpecialLuckyBlockAsset", SpecialLuckyBlockAsset.IsItemData(p74));
    local v79 = Assets.Directory[p74.Category];
    local Idle = v79.Animations.Idle;

    if p75 and Idle then
        local v80 = `missing idle animation for category {p74.Category}`;
        assert(Idle, v80);
        local v81 = u78:FindFirstChildWhichIsA("AnimationController", true);

        if v81 then
            local v82 = v81:FindFirstChildWhichIsA("Animator");

            if v82 then
                v82:Destroy();
            end;

            v81:Destroy();
        end;

        local AnimationController = Instance.new("AnimationController");
        AnimationController.Name = "AnimationController";
        AnimationController.Parent = u78:WaitForChild("Model");
        local Animator = Instance.new("Animator");

        if Constants.IS_SERVER then
            Animator:SetAttribute("ActiveAssetRarity", v79.Rarity._id);
        end;

        Animator.Parent = AnimationController;
        local u83 = nil;
        u83 = u78.AncestryChanged:Connect(function(p84, p85) -- Line: 536
            -- upvalues: u83 (ref), ExpRetry (ref), Animator (copy), Idle (copy), u1 (ref), u78 (copy)
            if p85 and p85:IsDescendantOf(workspace) or p85 == workspace then
                u83:Disconnect();
                local v86, v87 = ExpRetry(function() -- Line: 540
                    -- upvalues: Animator (ref), Idle (ref)
                    return Animator:LoadAnimation(Idle);
                end):await();

                if not v86 then
                    u1:AtError():Log((`Failed to load animation for model {u78.Name}: {v87}`));

                    return;
                end;

                v87.Looped = true;
                v87.Priority = Enum.AnimationPriority.Idle;
                v87:Play();
            end;
        end);
    else
        u3.StripRuntimeRig(u78, u78:GetAttribute("DontRemoveBones") or p76, p77);
    end;

    if p73 then
        u78:SetAttribute("UID", p73);
    end;

    return u78;
end;

function u3.GetNameFromItemData(p88) -- Line: 569
    -- upvalues: AssetItem (copy), Assets (copy), getAssetDisplayName (copy)
    assert(AssetItem.AssetItemData(p88));

    return getAssetDisplayName(Assets.Directory[p88.Category].DisplayName or "Unknown", p88.Mutations, p88.BaseMutation);
end;

local function ensureToolHandle(p89) -- Line: 578
    local Handle = p89:FindFirstChild("Handle");

    if Handle and Handle:IsA("BasePart") then
        return Handle;
    end;

    local Part = Instance.new("Part");
    Part.Name = "Handle";
    Part.Size = Vector3.new(0.2, 0.2, 0.2);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Anchored = false;
    Part.Massless = true;
    Part.Parent = p89;
    p89.RequiresHandle = true;
    p89.CanBeDropped = false;

    return Part;
end;

local function attachCenteredHandle(p90, p91, p92, p93) -- Line: 601
    -- upvalues: ensureToolHandle (copy), BBFromModelVisibleOnly (copy)
    local v94 = p92 or 1;
    assert(v94, "luau");
    local PrimaryPart = p91.PrimaryPart;
    local v95 = `model "{p91:GetFullName()}" is missing PrimaryPart`;
    local v96 = assert(PrimaryPart, v95);
    local v97 = p91:GetPivot();
    local v98 = ensureToolHandle(p90);
    local v99;

    if p93 == "HumanoidRootPart" or p93 == "HumanoidRootPartXZBoundsBottomY" then
        local HumanoidRootPart = p91:FindFirstChild("HumanoidRootPart", true);
        local v100;

        if HumanoidRootPart == nil then
            v100 = false;
        else
            v100 = HumanoidRootPart:IsA("BasePart");
        end;

        local v101 = `model "{p91:GetFullName()}" is missing HumanoidRootPart`;
        assert(v100, v101);

        if p93 == "HumanoidRootPartXZBoundsBottomY" then
            local v102, v103 = BBFromModelVisibleOnly(p91);
            v99 = HumanoidRootPart.CFrame.Rotation + Vector3.new(HumanoidRootPart.Position.X, v102.Position.Y - v103.Y * 0.5, HumanoidRootPart.Position.Z);
        else
            v99 = HumanoidRootPart.CFrame;
        end;
    else
        local v104, v105 = BBFromModelVisibleOnly(p91);
        v99 = v104 * CFrame.new(0, v105.Y * -0.5, v94 * (v105.Z * 0.1));
    end;

    local v106 = v99:ToObjectSpace(v97);
    p91:PivotTo(v98.CFrame * v106);
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = v96;
    WeldConstraint.Part1 = v98;
    WeldConstraint.Parent = v96;

    return v98;
end;

function u3.GetDataBillboardMaxDistance() -- Line: 648
    -- upvalues: Data (copy)
    return Data.MaxDistance;
end;

function u3.CreateTool(u107, u108, p109) -- Line: 652
    -- upvalues: AssetItem (copy), Asserts (copy), Assets (copy), AssetColorUtil (copy), u3 (copy), CollectionService (copy), Constants (copy), AssetGenerationUtil (copy), ensureToolHandle (copy), AddDebris (copy), Personalities (copy), Physics (copy), attachCenteredHandle (copy), AssetInvertedModelPresentation (copy), AssetSoundUtil (copy), getAssetDisplayName (copy), Simple (copy), attachDataBillboard (copy)
    assert(AssetItem.AssetItemData(u107));
    Asserts.string(u108);
    local Category = u107.Category;
    local Scale = u107.Scale;
    local Mutations2 = u107.Mutations;
    local BaseMutation = u107.BaseMutation;
    local v110 = Assets.Directory[Category];
    local v111 = (tonumber(Assets.Directory[Category].ModelWeight) or 1) * (typeof(Scale) ~= "number" and 1 or math.max(Scale, 0));
    local v112 = AssetColorUtil.ResolveFields(Category, u107.EyeColor, u107.ColorSeed, u107.ColorIndex);
    local Tool = Instance.new("Tool");
    local v113 = table.concat(Mutations2, ", ");
    Tool.Name = u3.GetNameFromItemData(u107);
    Tool.RequiresHandle = true;
    Tool.CanBeDropped = false;
    Tool:SetAttribute("GuardTransparencyExcluded", true);
    Tool:SetAttribute("UID", u108);
    Tool:SetAttribute("Mutations", v113);
    Tool:SetAttribute("BaseMutation", BaseMutation);
    Tool:SetAttribute("DisplayName", v110.DisplayName or Category);
    Tool:SetAttribute("Weight", v111);
    Tool:SetAttribute("Scale", Scale);
    Tool:SetAttribute("EyeColor", v112.EyeColor);
    Tool:SetAttribute("ColorSeed", v112.ColorSeed);
    Tool:SetAttribute("ColorIndex", v112.ColorIndex);
    Tool:SetAttribute("Category", v110._id);
    Tool:SetAttribute("Favorite", u107.IsFavorite or false);
    Tool:SetAttribute("ItemType", "Asset");
    CollectionService:AddTag(Tool, "AssetTool");
    local Configuration = Instance.new("Configuration");
    Configuration.Name = "Configuration";
    Configuration.Parent = Tool;
    Configuration:SetAttribute("mutations", v113);
    Configuration:SetAttribute("baseMutation", BaseMutation);
    Configuration:SetAttribute("displayName", v110.DisplayName or Category);
    Configuration:SetAttribute("scale", Scale);
    Configuration:SetAttribute("eyeColor", v112.EyeColor);
    Configuration:SetAttribute("colorSeed", v112.ColorSeed);
    Configuration:SetAttribute("colorIndex", v112.ColorIndex);
    Configuration:SetAttribute("rarity", v110.Rarity._id);
    Configuration:SetAttribute("money", u107.GeneratedMoney or 0);
    local v114 = 0;
    local v115 = nil;

    if Constants.IS_SERVER then
        local v116, v117 = require(game:GetService("ServerScriptService").Library.Database).UnsafeGetProfileAwait(p109);

        if v116 and v117 then
            v114 = v117.Rebirth or 0;
            v115 = v117.Gamepasses;
        end;
    end;

    local v118 = AssetGenerationUtil.GetRate(u107, v114, v115);
    local v119 = AssetGenerationUtil.GetRateWithoutRebirth(u107, v115);
    Configuration:SetAttribute("perSecond", v118);
    Configuration:SetAttribute("perSecondDisplay", v119);
    local u120 = ensureToolHandle(Tool);
    local u121 = nil;
    local u122 = nil;
    local u123 = nil;

    local function syncToolMutationState() -- Line: 726
        -- upvalues: Tool (copy), Configuration (copy), u121 (ref)
        local v124 = Tool:GetAttribute("Mutations");
        local v125 = Tool:GetAttribute("BaseMutation");

        if Configuration:GetAttribute("mutations") ~= v124 then
            Configuration:SetAttribute("mutations", v124);
        end;

        if Configuration:GetAttribute("baseMutation") ~= v125 then
            Configuration:SetAttribute("baseMutation", v125);
        end;

        if u121 then
            if u121:GetAttribute("Mutations") ~= v124 then
                u121:SetAttribute("Mutations", v124);
            end;

            if u121:GetAttribute("BaseMutation") ~= v125 then
                u121:SetAttribute("BaseMutation", v125);
            end;
        end;
    end;

    local function destroyToolBillboard() -- Line: 745
        -- upvalues: u122 (ref), AddDebris (ref), u123 (ref)
        if u122 then
            AddDebris(u122, 0);
            u122 = nil;
            u123 = nil;
        end;
    end;

    local function destroyToolRender() -- Line: 753
        -- upvalues: u122 (ref), AddDebris (ref), u123 (ref), u121 (ref)
        if u122 then
            AddDebris(u122, 0);
            u122 = nil;
            u123 = nil;
        end;

        if u121 then
            AddDebris(u121, 0);
            u121 = nil;
        end;
    end;

    local function ensureToolRender() -- Line: 762
        -- upvalues: u121 (ref), Tool (copy), u120 (ref), u122 (ref), AddDebris (ref), u123 (ref), u107 (copy), Personalities (ref), u3 (ref), u108 (copy), Category (copy), Physics (ref), attachCenteredHandle (ref), AssetInvertedModelPresentation (ref), syncToolMutationState (copy)
        if u121 and (u121.Parent == Tool and u120.Parent == Tool) then
            return u121;
        end;

        if u122 then
            AddDebris(u122, 0);
            u122 = nil;
            u123 = nil;
        end;

        if u121 then
            AddDebris(u121, 0);
            u121 = nil;
        end;

        local v126 = u107.Personality == Personalities.Personalities.InvertedModel;
        local v127 = u107;

        if v126 then
            v127 = table.clone(u107);
            v127.Mutations = table.clone(u107.Mutations);
            v127.Personality = Personalities.Personalities.Normal;
        end;

        local v128 = u3.CreateActiveModel(u108, v127, true, true);
        Physics.DisableAllPhysics(v128);
        Physics.SetAnchored(v128, false);
        u120 = attachCenteredHandle(Tool, v128, nil, (Category == "Cave Dragon" or (Category == "Warden" or Category == "Eternal Lunar Dragon")) and "HumanoidRootPart" or (Category == "Unicorn" and "HumanoidRootPartXZBoundsBottomY" or nil));

        if v126 then
            AssetInvertedModelPresentation.Apply(v128);
            Physics.SetAnchored(v128, false);
        end;

        for _, descendant in v128:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant:SetAttribute("KillPartIgnore", true);
            end;
        end;

        u121 = v128;
        v128.Parent = Tool;
        syncToolMutationState();

        return v128;
    end;

    local function updateBillboard() -- Line: 804
        -- upvalues: Configuration (copy), Category (copy), Assets (ref), Tool (copy), AssetSoundUtil (ref), syncToolMutationState (copy), getAssetDisplayName (ref), u122 (ref), u123 (ref), Simple (ref)
        local v129 = Configuration:GetAttribute("displayName") or "";
        local v130 = Configuration:GetAttribute("scale");
        local v131 = typeof(v130) ~= "number" and 1 or v130;
        local v132 = (tonumber(Assets.Directory[Category].ModelWeight) or 1) * (typeof(v131) ~= "number" and 1 or math.max(v131, 0));
        local v133 = Tool:GetAttribute("Mutations") or "";
        local v134 = AssetSoundUtil.ParseMutationsAttribute(v133);
        local v135 = Tool:GetAttribute("BaseMutation");
        syncToolMutationState();
        Tool:SetAttribute("Weight", v132);
        Tool.Name = string.format("%s (%.2f kg)", getAssetDisplayName(v129, v134, v135), v132);

        if not u122 then
            return;
        end;

        local v136 = u122;
        local DisplayName = v136:FindFirstChild("DisplayName");

        if DisplayName then
            DisplayName.RichText = true;
            DisplayName.Text = getAssetDisplayName(v129, v134, v135);
        end;

        local Level = v136:FindFirstChild("Level");

        if Level then
            Level.Visible = false;
            Level.Text = "";
        end;

        if not u123 then
            return;
        end;

        local v137 = Configuration:GetAttribute("perSecondDisplay");

        if typeof(v137) ~= "number" then
            v137 = Configuration:GetAttribute("perSecond");
        end;

        u123.Text = "$" .. Simple.FormatCompact(v137) .. "/s";
    end;

    local function ensureToolBillboard() -- Line: 834
        -- upvalues: ensureToolRender (copy), u122 (ref), attachDataBillboard (ref), Category (copy), u107 (copy), u123 (ref), updateBillboard (copy)
        local v138 = ensureToolRender();

        if u122 then
            return;
        end;

        local v139, _, v140 = attachDataBillboard(v138, Category, u107);

        if not v139 then
            return;
        end;

        u122 = v139;
        v139.MaxDistance = v139.MaxDistance * 2.8;
        v139.Enabled = true;
        u123 = v140;
        updateBillboard();
    end;

    local u141 = Configuration:GetAttributeChangedSignal("perSecondDisplay"):Connect(updateBillboard);
    local u142 = Configuration:GetAttributeChangedSignal("perSecond"):Connect(updateBillboard);
    local u143 = Configuration:GetAttributeChangedSignal("displayName"):Connect(updateBillboard);
    local u144 = Configuration:GetAttributeChangedSignal("scale"):Connect(updateBillboard);
    local u148 = Tool:GetAttributeChangedSignal("Mutations"):Connect(function() -- Line: 858
        -- upvalues: syncToolMutationState (copy), u122 (ref), AddDebris (ref), u123 (ref), ensureToolRender (copy), attachDataBillboard (ref), Category (copy), u107 (copy), updateBillboard (copy)
        syncToolMutationState();

        if u122 then
            if u122 then
                AddDebris(u122, 0);
                u122 = nil;
                u123 = nil;
            end;

            local v145 = ensureToolRender();

            if not u122 then
                local v146, _, v147 = attachDataBillboard(v145, Category, u107);

                if v146 then
                    u122 = v146;
                    v146.MaxDistance = v146.MaxDistance * 2.8;
                    v146.Enabled = true;
                    u123 = v147;
                    updateBillboard();
                end;
            end;
        end;

        updateBillboard();
    end);
    local u152 = Tool:GetAttributeChangedSignal("BaseMutation"):Connect(function() -- Line: 866
        -- upvalues: syncToolMutationState (copy), u122 (ref), AddDebris (ref), u123 (ref), ensureToolRender (copy), attachDataBillboard (ref), Category (copy), u107 (copy), updateBillboard (copy)
        syncToolMutationState();

        if u122 then
            if u122 then
                AddDebris(u122, 0);
                u122 = nil;
                u123 = nil;
            end;

            local v149 = ensureToolRender();

            if not u122 then
                local v150, _, v151 = attachDataBillboard(v149, Category, u107);

                if v150 then
                    u122 = v150;
                    v150.MaxDistance = v150.MaxDistance * 2.8;
                    v150.Enabled = true;
                    u123 = v151;
                    updateBillboard();
                end;
            end;
        end;

        updateBillboard();
    end);
    local u156 = Tool.Equipped:Connect(function() -- Line: 875
        -- upvalues: ensureToolRender (copy), u122 (ref), attachDataBillboard (ref), Category (copy), u107 (copy), u123 (ref), updateBillboard (copy)
        local v153 = ensureToolRender();

        if not u122 then
            local v154, _, v155 = attachDataBillboard(v153, Category, u107);

            if v154 then
                u122 = v154;
                v154.MaxDistance = v154.MaxDistance * 2.8;
                v154.Enabled = true;
                u123 = v155;
                updateBillboard();
            end;
        end;

        updateBillboard();
    end);
    local u157 = Tool.Unequipped:Connect(destroyToolRender);
    Tool.Destroying:Connect(function() -- Line: 881
        -- upvalues: u141 (copy), u142 (copy), u143 (copy), u144 (copy), u148 (copy), u152 (copy), u156 (copy), u157 (copy), u122 (ref), AddDebris (ref), u123 (ref), u121 (ref)
        u141:Disconnect();
        u142:Disconnect();
        u143:Disconnect();
        u144:Disconnect();
        u148:Disconnect();
        u152:Disconnect();
        u156:Disconnect();
        u157:Disconnect();

        if u122 then
            AddDebris(u122, 0);
            u122 = nil;
            u123 = nil;
        end;

        if u121 then
            AddDebris(u121, 0);
            u121 = nil;
        end;
    end);
    Tool.Parent = p109:WaitForChild("Backpack");

    return Tool;
end;

function u3.GetDisplayScale(p158) -- Line: 54
    return typeof(p158) ~= "number" and 1 or math.max(p158, 0);
end;

function u3.GetModelScale(p159, p160) -- Line: 62
    -- upvalues: Assets (copy)
    local BaseModelScale = Assets.Directory[p159].BaseModelScale;

    return (typeof(p160) ~= "number" and 1 or math.max(p160, 0)) * BaseModelScale;
end;

function u3.GetMutationRichTextLine(p161, p162) -- Line: 924
    -- upvalues: Asserts (copy), Mutations (copy)
    Asserts.table(p161);
    Asserts.optional.string(p162);
    local u163 = {};
    local u164 = {};

    local function _(p165) -- Line: 931
        -- upvalues: u164 (copy), Mutations (ref), u163 (copy)
        if p165 == nil or (p165 == "" or u164[p165]) then
            return;
        end;

        u164[p165] = true;
        local v166 = Mutations.GetMutation(p165);
        local v167;

        if v166 == nil then
            v167 = nil;
        else
            local Color = v166.Color;
            local v168 = Mutations.GetDisplayName(p165);
            v167 = `<font color="#{Color:ToHex()}">{v168:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")}</font>`;
        end;

        if v167 ~= nil then
            table.insert(u163, v167);
        end;
    end;

    if p162 ~= nil and (p162 ~= "" and not u164[p162]) then
        u164[p162] = true;
        local v169 = Mutations.GetMutation(p162);
        local v170;

        if v169 == nil then
            v170 = nil;
        else
            local Color = v169.Color;
            local v171 = Mutations.GetDisplayName(p162);
            v170 = `<font color="#{Color:ToHex()}">{v171:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")}</font>`;
        end;

        if v170 ~= nil then
            table.insert(u163, v170);
        end;
    end;

    for _, v in ipairs(p161) do
        if v ~= nil and v ~= "" then
            if not u164[v] then
                u164[v] = true;
                local v172 = Mutations.GetMutation(v);
                local v173;

                if v172 == nil then
                    v173 = nil;
                else
                    local Color = v172.Color;
                    local v174 = Mutations.GetDisplayName(v);
                    v173 = `<font color="#{Color:ToHex()}">{v174:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")}</font>`;
                end;

                if v173 ~= nil then
                    table.insert(u163, v173);
                end;
            end;
        end;
    end;

    if #u163 == 0 then
        return nil;
    end;

    return table.concat(u163, ", ");
end;

function u3.IsDroppableBaseMutation(p175) -- Line: 137
    -- upvalues: Mutations (copy)
    if typeof(p175) ~= "string" or p175 == "" then
        return false;
    end;

    local v176 = Mutations.GetMutation(p175);
    local v177;

    if v176 == nil then
        v177 = false;
    else
        v177 = v176.DropWeight > 0;
    end;

    return v177;
end;

function u3.ResolveBaseMutation(p178, p179) -- Line: 146
    -- upvalues: Mutations (copy)
    local v180;

    if typeof(p178) == "string" and p178 ~= "" then
        local v181 = Mutations.GetMutation(p178);

        if v181 == nil then
            v180 = false;
        else
            v180 = v181.DropWeight > 0;
        end;
    else
        v180 = false;
    end;

    if v180 then
        return p178;
    end;

    if typeof(p179) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(p179) do
        local v182;

        if typeof(v) == "string" and v ~= "" then
            local v183 = Mutations.GetMutation(v);

            if v183 == nil then
                v182 = false;
            else
                v182 = v183.DropWeight > 0;
            end;
        else
            v182 = false;
        end;

        if v182 then
            return v;
        end;
    end;

    return nil;
end;

function u3.ApplyModelScale(p184, p185, p186) -- Line: 76
    -- upvalues: Assets (copy)
    local BaseModelScale = Assets.Directory[p185].BaseModelScale;
    local v187 = (typeof(p186) ~= "number" and 1 or math.max(p186, 0)) * BaseModelScale;
    p184:ScaleTo(v187);

    return v187;
end;

function u3.ApplyBillboardDisplay(p188, p189, p190, p191) -- Line: 164
    -- upvalues: getAssetDisplayName (copy)
    local DisplayName = p188:FindFirstChild("DisplayName");

    if DisplayName then
        DisplayName.RichText = true;
        DisplayName.Text = getAssetDisplayName(p189, p190, p191);
    end;

    local Level = p188:FindFirstChild("Level");

    if Level then
        Level.Visible = false;
        Level.Text = "";
    end;
end;

return u3;