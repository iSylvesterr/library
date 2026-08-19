-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local u2 = nil;
local Signal = require(ReplicatedStorage.Packages.Signal);
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Weapons = Assets:WaitForChild("Weapons");
local Skins = Assets:WaitForChild("Skins");
local u3 = Signal.new();
u1.OnItemStockSchemasUpdated = u3;
local u4 = {};
local u5 = {};
local u6 = { {
        max = 0.07,
        wear = "Factory New"
    }, {
        max = 0.15,
        wear = "Minimal Wear"
    }, {
        max = 0.38,
        wear = "Field-Tested"
    }, {
        max = 0.45,
        wear = "Well-Worn"
    }, {
        max = 1,
        wear = "Battle-Scarred"
    } };
local u7 = {
    ["Factory New"] = "Mint Condition",
    ["Minimal Wear"] = "Near-Mint",
    ["Field-Tested"] = "Standard-Grade",
    ["Well-Worn"] = "Combat-Worn",
    ["Battle-Scarred"] = "War-Torn"
};

local function GetDataController() -- Line: 61
    -- upvalues: u2 (ref), ReplicatedStorage (copy)
    if not u2 then
        local success, result = pcall(function() -- Line: 63
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.DataController);
        end);

        if success then
            u2 = result;
        end;
    end;

    return u2;
end;

local function ResolveCharmFromId(p8) -- Line: 75
    -- upvalues: u2 (ref), ReplicatedStorage (copy), Players (copy)
    if not u2 then
        local success, result = pcall(function() -- Line: 63
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.DataController);
        end);

        if success then
            u2 = result;
        end;
    end;

    local v9 = u2;

    if not v9 then
        return nil;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return nil;
    end;

    local v10 = v9.Get(LocalPlayer, "Inventory");

    if not v10 or typeof(v10) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v10) do
        if v._id == p8 and v.Type == "Charm" then
            return {
                Skin = v.Skin,
                Pattern = v.Pattern
            };
        end;
    end;

    return nil;
end;

local function ValidateInputs(p11, p12) -- Line: 106
    local v13;

    if typeof(p11) == "string" and (typeof(p12) == "string" and p11 ~= "") then
        v13 = p12 ~= "";
    else
        v13 = false;
    end;

    return v13;
end;

local function Weld(p14, p15) -- Line: 112
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p14;
    WeldConstraint.Part1 = p15;
    WeldConstraint.Parent = p14;
end;

local function UpdateAvailableSkins(p16) -- Line: 121
    -- upvalues: u4 (ref), HttpService (copy), u3 (copy)
    u4 = HttpService:JSONDecode(p16);

    if #u3:GetConnections() <= 0 then
        return;
    end;

    u3:Fire(u4);
end;

local function CreateSyntheticStockSchema(p17) -- Line: 132
    -- upvalues: GetWeaponProperties (copy)
    local v18 = GetWeaponProperties(p17);

    return v18 and {
        paintId = "stock",
        skin = "Stock",
        rarity = "Stock",
        supportsStatTrak = false,
        statTrakChance = 0,
        isEnabled = true,
        isMarketplaceVisible = false,
        collection = nil,
        description = "Standard issue finish.",
        caseRarity = "Stock",
        type = v18.Class,
        name = p17,
        floatRange = {
            min = 0,
            max = 0.07
        },
        floatChances = { {
                wear = "Factory New",
                chance = 100
            } },
        charmImages = {},
        wearImages = {},
        imageAssetId = v18.Icon or v18.ReverseIcon
    } or nil;
end;

local function GetSyntheticStockSchema(p19) -- Line: 169
    -- upvalues: u5 (copy), CreateSyntheticStockSchema (copy)
    local v20 = u5[p19];

    if v20 and v20.Stock then
        return v20.Stock;
    end;

    local v21 = CreateSyntheticStockSchema(p19);

    if not v21 then
        return nil;
    end;

    local v22 = v20 or {};
    v22.Stock = v21;
    u5[p19] = v22;

    return v21;
end;

local function GetKillTrackValue(p23, u24) -- Line: 189
    -- upvalues: GetWeaponProperties (copy)
    local v25 = p23 or 0;
    local v26 = typeof(v25) == "number";
    assert(v26, "KillCount must be a number");
    local success, result = pcall(function(...) -- Line: 194
        -- upvalues: GetWeaponProperties (ref), u24 (copy)
        return GetWeaponProperties(u24);
    end);

    if not (success and result) then
        return nil;
    end;

    if result.Class == "Melee" then
        local v27 = math.floor(v25);
        local v28 = math.clamp(v27, 0, 9999);

        return tostring(v28);
    end;

    local v29 = math.floor(v25);
    local v30 = math.clamp(v29, 0, 999999);

    return string.format("%06d", v30);
end;

local function GetWeaponFolder(p31) -- Line: 213
    -- upvalues: Weapons (copy)
    local v32 = Weapons:FindFirstChild(p31);

    if v32 and v32:IsA("Folder") then
        return v32;
    end;

    return nil;
end;

local function GetSkinTextureFolder(p33, p34, p35) -- Line: 221
    -- upvalues: Skins (copy)
    local v36 = Skins:FindFirstChild(p33);

    if not v36 then
        return nil;
    end;

    if p35 and p33 == "Smoke Grenade" then
        local v37 = v36:FindFirstChild(p35);

        if v37 and v37:IsA("Folder") then
            return v37;
        end;
    end;

    local v38 = v36:FindFirstChild(p34);

    if v38 and v38:IsA("Folder") then
        return v38;
    end;

    return nil;
end;

local function GetWearFromFloat(p39, p40) -- Line: 243
    -- upvalues: u6 (copy), u7 (copy)
    local v41 = math.max(p39.floatRange.min, p39.floatRange.max - 1e-12);
    local v42 = math.clamp(p40, p39.floatRange.min, v41);
    local v43 = math.clamp(v42, 0, 1);

    for _, v in ipairs(u6) do
        if v43 < v.max then
            return v.wear, u7[v.wear];
        end;
    end;

    return "Battle-Scarred", "War-Torn";
end;

local function GetWearTextureFolder(p44, p45, p46) -- Line: 261
    -- upvalues: GetWearFromFloat (copy), u6 (copy)
    if not (p44 and p44:IsA("Folder")) then
        return nil;
    end;

    local v47 = GetWearFromFloat(p45, p46);

    if v47 then
        v47 = p44:FindFirstChild(v47);
    end;

    if v47 and v47:IsA("Folder") then
        return v47;
    end;

    for _, v in ipairs(u6) do
        local v48 = p44:FindFirstChild(v.wear);

        if v48 and v48:IsA("Folder") then
            return v48;
        end;
    end;

    return nil;
end;

local function FindMatchingMeshParts(p49, p50) -- Line: 291
    local v51 = {};

    for _, descendant in ipairs(p49:GetDescendants()) do
        if descendant:IsA("MeshPart") and descendant.Name == p50 then
            table.insert(v51, descendant);
        end;
    end;

    return v51;
end;

local function ApplySkinTextures(p52, p53) -- Line: 305
    -- upvalues: FindMatchingMeshParts (copy)
    local v54 = 0;
    local v55 = 0;
    local v56 = {};

    for _, child in ipairs(p53:GetChildren()) do
        if child:IsA("SurfaceAppearance") then
            v54 = v54 + 1;
            local v57 = FindMatchingMeshParts(p52, child.Name);

            if #v57 > 0 then
                for _, v in ipairs(v57) do
                    local v58 = v:FindFirstChildOfClass("SurfaceAppearance");

                    if v58 then
                        v58:Destroy();
                    end;

                    child:Clone().Parent = v;
                end;

                v55 = v55 + 1;
            else
                table.insert(v56, child.Name);
            end;
        end;
    end;

    return v54, v55, v56;
end;

local function AttachStatTrakToWeapon(p59, p60, p61, u62) -- Line: 346
    -- upvalues: GetWeaponProperties (copy), Assets (copy), GetKillTrackValue (copy)
    local success, result = pcall(function(...) -- Line: 348
        -- upvalues: GetWeaponProperties (ref), u62 (copy)
        return GetWeaponProperties(u62);
    end);
    local v63 = Assets.Other[success and (result and result.Class == "Melee") and "KillTrackKnife" or "KillTrak"]:Clone();
    local PrimaryPart = p60.PrimaryPart;

    if not PrimaryPart then
        v63:Destroy();

        return;
    end;

    local KillTrack = p60:FindFirstChild("KillTrack", true);

    if not KillTrack then
        v63:Destroy();

        return;
    end;

    local PrimaryPart2 = v63.PrimaryPart;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = PrimaryPart2;
    WeldConstraint.Part1 = PrimaryPart;
    WeldConstraint.Parent = PrimaryPart2;
    v63:PivotTo(KillTrack.WorldCFrame);
    v63.Screen.SurfaceGui.TextLabel.Text = GetKillTrackValue(p61, u62);
    v63.Parent = p59;
end;

local function AttachStatTrak(p64, p65, p66) -- Line: 381
    -- upvalues: AttachStatTrakToWeapon (copy)
    local Weapon = p64:FindFirstChild("Weapon");

    if Weapon then
        AttachStatTrakToWeapon(p64, Weapon, p65, p66);

        return;
    end;

    local WeaponL = p64:FindFirstChild("WeaponL");
    local WeaponR = p64:FindFirstChild("WeaponR");

    if WeaponL then
        AttachStatTrakToWeapon(p64, WeaponL, p65, p66);
    end;

    if WeaponR then
        AttachStatTrakToWeapon(p64, WeaponR, p65, p66);
    end;
end;

local function AttachNameTagToWeapon(p67, p68, p69) -- Line: 406
    -- upvalues: Assets (copy)
    local v70 = Assets.Other.NamePlate:Clone();
    local PrimaryPart = p68.PrimaryPart;

    if not PrimaryPart then
        v70:Destroy();

        return;
    end;

    local Nametag = PrimaryPart:FindFirstChild("Nametag");

    if not Nametag then
        v70:Destroy();

        return;
    end;

    local PrimaryPart2 = v70.PrimaryPart;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = PrimaryPart2;
    WeldConstraint.Part1 = PrimaryPart;
    WeldConstraint.Parent = PrimaryPart2;
    v70:PivotTo(Nametag.WorldCFrame);
    v70.Screen.SurfaceGui.TextLabel.Text = tostring(p69);
    v70.Parent = p67;
end;

local function AttachNameTag(p71, p72) -- Line: 432
    -- upvalues: AttachNameTagToWeapon (copy)
    local Weapon = p71:FindFirstChild("Weapon");

    if Weapon then
        AttachNameTagToWeapon(p71, Weapon, p72);

        return;
    end;

    local WeaponL = p71:FindFirstChild("WeaponL");
    local WeaponR = p71:FindFirstChild("WeaponR");

    if WeaponL then
        AttachNameTagToWeapon(p71, WeaponL, p72);
    end;

    if WeaponR then
        AttachNameTagToWeapon(p71, WeaponR, p72);
    end;
end;

local function AttachStatTrakCameraToWeapon(p73, p74, p75, u76) -- Line: 457
    -- upvalues: GetWeaponProperties (copy), Assets (copy), GetKillTrackValue (copy)
    local success, result = pcall(function(...) -- Line: 464
        -- upvalues: GetWeaponProperties (ref), u76 (copy)
        return GetWeaponProperties(u76);
    end);
    local v77 = Assets.Other[success and (result and result.Class == "Melee") and "KillTrackKnife" or "KillTrak"]:Clone();
    local PrimaryPart = p74.PrimaryPart;

    if not PrimaryPart then
        v77:Destroy();

        return;
    end;

    local KillTrack = p74:FindFirstChild("KillTrack", true);

    if not KillTrack then
        v77:Destroy();

        return;
    end;

    local PrimaryPart2 = v77.PrimaryPart;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = PrimaryPart2;
    WeldConstraint.Part1 = PrimaryPart;
    WeldConstraint.Parent = PrimaryPart2;
    v77:PivotTo(KillTrack.WorldCFrame);
    local SurfaceGui = v77.Screen.SurfaceGui;
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
    SurfaceGui.CanvasSize = Vector2.new(100, 25);
    SurfaceGui.TextLabel.Text = GetKillTrackValue(p75, u76);
    SurfaceGui.TextLabel.TextSize = 29;
    SurfaceGui.TextLabel.Size = UDim2.fromScale(1, 1);
    v77.Parent = p73;
end;

local function AttachStatTrakCamera(p78, p79, p80) -- Line: 507
    -- upvalues: AttachStatTrakCameraToWeapon (copy)
    local Weapon = p78:FindFirstChild("Weapon");

    if Weapon then
        AttachStatTrakCameraToWeapon(p78, Weapon, p79, p80);

        return;
    end;

    local WeaponL = p78:FindFirstChild("WeaponL");
    local WeaponR = p78:FindFirstChild("WeaponR");

    if WeaponL then
        AttachStatTrakCameraToWeapon(p78, WeaponL, p79, p80);
    end;

    if WeaponR then
        AttachStatTrakCameraToWeapon(p78, WeaponR, p79, p80);
    end;
end;

local function AttachNameTagCameraToWeapon(p81, p82, p83) -- Line: 532
    -- upvalues: Assets (copy)
    local v84 = Assets.Other.NamePlate:Clone();
    local PrimaryPart = p82.PrimaryPart;

    if not PrimaryPart then
        v84:Destroy();

        return;
    end;

    local Nametag = PrimaryPart:FindFirstChild("Nametag");

    if not Nametag then
        v84:Destroy();

        return;
    end;

    local PrimaryPart2 = v84.PrimaryPart;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = PrimaryPart2;
    WeldConstraint.Part1 = PrimaryPart;
    WeldConstraint.Parent = PrimaryPart2;
    v84:PivotTo(Nametag.WorldCFrame);
    local SurfaceGui = v84.Screen.SurfaceGui;
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
    SurfaceGui.CanvasSize = Vector2.new(100, 8);
    SurfaceGui.TextLabel.Text = tostring(p83);
    SurfaceGui.TextLabel.TextSize = 8.98;
    SurfaceGui.TextLabel.Size = UDim2.fromScale(0.95, 1);
    SurfaceGui.TextLabel.Position = UDim2.fromOffset(5, 0);
    v84.Parent = p81;
end;

local function AttachNameTagCamera(p85, p86) -- Line: 568
    -- upvalues: AttachNameTagCameraToWeapon (copy)
    local Weapon = p85:FindFirstChild("Weapon");

    if Weapon then
        AttachNameTagCameraToWeapon(p85, Weapon, p86);

        return;
    end;

    local WeaponL = p85:FindFirstChild("WeaponL");
    local WeaponR = p85:FindFirstChild("WeaponR");

    if WeaponL then
        AttachNameTagCameraToWeapon(p85, WeaponL, p86);
    end;

    if WeaponR then
        AttachNameTagCameraToWeapon(p85, WeaponR, p86);
    end;
end;

local function AttachCharmToWeapon(p87, p88, p89, p90) -- Line: 593
    -- upvalues: Assets (copy)
    local Charms = Assets:FindFirstChild("Charms");
    local v91;

    if Charms then
        v91 = Charms:FindFirstChild("CharmBase");
    else
        v91 = Charms;
    end;

    if not (v91 and v91:IsA("Model")) then
        warn("Charm base not found for weapon:", p87.Name);

        return;
    end;

    local v92 = Charms:FindFirstChild(p88);

    if v92 then
        v92 = v92:FindFirstChild((tostring(p89)));
    end;

    if not (v92 and v92:IsA("Model")) then
        warn("Specific charm not found for weapon:", p87.Name, p88, p89);

        return;
    end;

    local v93 = p87:FindFirstChild("Charm" .. p90, true);

    if not v93 then
        print("Charm attachment not found for weapon:", p87.Name, p90);

        return;
    end;

    local Parent = v93.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        return;
    end;

    local v94 = v91:Clone();
    v94.Parent = p87;
    v94:PivotTo(v93.WorldCFrame * CFrame.Angles(0, 0, 0));

    if v94.PrimaryPart then
        local PrimaryPart = v94.PrimaryPart;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = PrimaryPart;
        WeldConstraint.Part1 = Parent;
        WeldConstraint.Parent = PrimaryPart;
    end;

    local v95 = v92:Clone();
    v95.Parent = v94;
    local Part = v94:FindFirstChild("Part");

    if Part and Part:IsA("BasePart") then
        v95:PivotTo(Part.CFrame);
        Part:Destroy();
    end;

    local HingeConstraint = v94:FindFirstChild("HingeConstraint", true);
    local v96 = HingeConstraint and (v95.PrimaryPart and v95.PrimaryPart:FindFirstChild("Attachment"));

    if v96 then
        HingeConstraint.Attachment1 = v96;
    end;
end;

local function AttachCharm(p97, p98) -- Line: 660
    -- upvalues: ResolveCharmFromId (copy), AttachCharmToWeapon (copy)
    if typeof(p98) ~= "table" then
        return;
    end;

    if not (p98._id and p98.Position) then
        return;
    end;

    local Position = p98.Position;
    local v99, v100;

    if p98.Skin and p98.Pattern then
        v99 = p98.Skin;
        v100 = p98.Pattern;
    else
        local v101 = ResolveCharmFromId(p98._id);

        if not v101 then
            return;
        end;

        v99 = v101.Skin;
        v100 = v101.Pattern;
    end;

    if not (v99 and v100) then
        return;
    end;

    if p97:FindFirstChild("Weapon") then
        AttachCharmToWeapon(p97, v99, v100, Position);

        return;
    end;

    local WeaponL = p97:FindFirstChild("WeaponL");
    p97:FindFirstChild("WeaponR");

    if WeaponL then
        AttachCharmToWeapon(p97, v99, v100, Position);
    end;
end;

local function AttachCharmCameraToWeapon(p102, p103, p104, p105) -- Line: 719
    -- upvalues: Assets (copy)
    local Charms = Assets:FindFirstChild("Charms");
    local v106;

    if Charms then
        v106 = Charms:FindFirstChild("CharmBase");
    else
        v106 = Charms;
    end;

    if not (v106 and v106:IsA("Model")) then
        return;
    end;

    local v107 = Charms:FindFirstChild(p103);

    if v107 then
        v107 = v107:FindFirstChild((tostring(p104)));
    end;

    if not (v107 and v107:IsA("Model")) then
        return;
    end;

    local v108 = p102:FindFirstChild("Charm" .. p105, true);

    if not v108 then
        return;
    end;

    local Parent = v108.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        return;
    end;

    local v109 = v106:Clone();
    v109.Parent = p102;
    v109:PivotTo(v108.WorldCFrame * CFrame.Angles(0, 0, 0));

    if v109.PrimaryPart then
        local PrimaryPart = v109.PrimaryPart;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = PrimaryPart;
        WeldConstraint.Part1 = Parent;
        WeldConstraint.Parent = PrimaryPart;
    end;

    local v110 = v107:Clone();
    v110.Parent = v109;
    local Part = v109:FindFirstChild("Part");

    if Part and Part:IsA("BasePart") then
        v110:PivotTo(Part.CFrame);
        Part:Destroy();
    end;

    local HingeConstraint = v109:FindFirstChild("HingeConstraint", true);
    local v111 = HingeConstraint and (v110.PrimaryPart and v110.PrimaryPart:FindFirstChild("Attachment"));

    if v111 then
        HingeConstraint.Attachment1 = v111;
    end;
end;

local function AttachCharmCamera(p112, p113) -- Line: 783
    -- upvalues: ResolveCharmFromId (copy), AttachCharmCameraToWeapon (copy)
    if typeof(p113) ~= "table" then
        return;
    end;

    if not (p113._id and p113.Position) then
        return;
    end;

    local Position = p113.Position;
    local v114, v115;

    if p113.Skin and p113.Pattern then
        v114 = p113.Skin;
        v115 = p113.Pattern;
    else
        local v116 = ResolveCharmFromId(p113._id);

        if not v116 then
            return;
        end;

        v114 = v116.Skin;
        v115 = v116.Pattern;
    end;

    if not (v114 and v115) then
        return;
    end;

    if p112:FindFirstChild("Weapon") then
        AttachCharmCameraToWeapon(p112, v114, v115, Position);

        return;
    end;

    local WeaponL = p112:FindFirstChild("WeaponL");
    local WeaponR = p112:FindFirstChild("WeaponR");

    if WeaponL then
        AttachCharmCameraToWeapon(p112, v114, v115, Position);
    end;

    if WeaponR then
        AttachCharmCameraToWeapon(p112, v114, v115, Position);
    end;
end;

function u1.GetCharmModel(p117, p118) -- Line: 843
    -- upvalues: Assets (copy)
    local Charms = Assets:FindFirstChild("Charms");
    local v119;

    if Charms then
        v119 = Charms:FindFirstChild("CharmBase");
    else
        v119 = Charms;
    end;

    if not (v119 and v119:IsA("Model")) then
        warn((`Skins.GetCharmModel: Charm base not found for charm "{p117}" with pattern "{p118}"`));

        return nil;
    end;

    local v120 = Charms:FindFirstChild(p117);

    if v120 then
        v120 = v120:FindFirstChild((tostring(p118)));
    end;

    if not (v120 and v120:IsA("Model")) then
        warn((`Skins.GetCharmModel: Specific charm not found for charm "{p117}" with pattern "{p118}"`));

        return nil;
    end;

    local v121 = v119:Clone();
    v121.Name = p117;
    local v122 = v120:Clone();
    v122.Parent = v121;
    local Part = v121:FindFirstChild("Part");

    if Part and Part:IsA("BasePart") then
        v122:PivotTo(Part.CFrame);
        Part:Destroy();
    end;

    local HingeConstraint = v121:FindFirstChild("HingeConstraint", true);
    local v123 = HingeConstraint and (v122.PrimaryPart and v122.PrimaryPart:FindFirstChild("Attachment"));

    if v123 then
        HingeConstraint.Attachment1 = v123;
    end;

    return v121;
end;

function u1.GetBadgeModel(p124) -- Line: 887
    -- upvalues: Assets (copy)
    local Badges = Assets:FindFirstChild("Badges");

    if not Badges then
        warn((`Skins.GetBadgeModel: Badges folder not found for badge "{p124}"`));

        return nil;
    end;

    local v125 = Badges:FindFirstChild(p124);

    if v125 and v125:IsA("Model") then
        return v125:Clone();
    end;

    warn((`Skins.GetBadgeModel: Badge model not found for "{p124}"`));

    return nil;
end;

function u1.GetWearNameForFloat(p126, p127) -- Line: 901
    -- upvalues: GetWearFromFloat (copy)
    local v128, v129 = GetWearFromFloat(p126, p127);

    return v128, v129;
end;

function u1.GetKillTrackValue(p130, p131) -- Line: 908
    -- upvalues: GetKillTrackValue (copy)
    return GetKillTrackValue(p130, p131);
end;

function u1.GetMagazine(p132, p133, p134) -- Line: 914
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), Skins (copy), GetWearTextureFolder (copy), ApplySkinTextures (copy)
    local v135;

    if typeof(p132) == "string" and (typeof(p133) == "string" and p132 ~= "") then
        v135 = p133 ~= "";
    else
        v135 = false;
    end;

    if not v135 then
        return nil;
    end;

    local v136 = u1.GetSkinInformation(p132, p133);

    if not v136 and next(u4) == nil then
        u3:Wait();
        v136 = u1.GetSkinInformation(p132, p133);
    end;

    if not v136 then
        return nil;
    end;

    local v137 = Weapons:FindFirstChild(p132);

    if not (v137 and v137:IsA("Folder")) then
        v137 = nil;
    end;

    if v137 then
        v137 = v137:FindFirstChild("Character");
    end;

    if not (v137 and v137:IsA("Model")) then
        return nil;
    end;

    local v138 = {};

    for _, descendant in ipairs(v137:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant:HasTag("CharacterMagazine") then
            table.insert(v138, descendant);
        end;
    end;

    if #v138 == 0 then
        return nil;
    end;

    local Model = Instance.new("Model");
    Model.Name = "Magazine";

    for _, v in ipairs(v138) do
        local v139 = v:Clone();
        v139.Parent = Model;

        if not Model.PrimaryPart then
            Model.PrimaryPart = v139;
        end;
    end;

    local v140 = Skins:FindFirstChild(p132);
    local v141;

    if v140 then
        v141 = v140:FindFirstChild(p133);

        if not (v141 and v141:IsA("Folder")) then
            v141 = nil;
        end;
    else
        v141 = nil;
    end;

    if v141 then
        v141 = v141:FindFirstChild("Character");
    end;

    local v142 = GetWearTextureFolder(v141, v136, p134 or v136.floatRange.min);

    if v142 then
        ApplySkinTextures(Model, v142);
    end;

    return Model;
end;

function u1.GetGloves(p143, p144, p145) -- Line: 982
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), Skins (copy), GetWearTextureFolder (copy), ApplySkinTextures (copy)
    local v146;

    if typeof(p143) == "string" and (typeof(p144) == "string" and p143 ~= "") then
        v146 = p144 ~= "";
    else
        v146 = false;
    end;

    if not v146 then
        return nil;
    end;

    local v147 = u1.GetSkinInformation(p143, p144);

    if not v147 and next(u4) == nil then
        u3:Wait();
        v147 = u1.GetSkinInformation(p143, p144);
    end;

    if not v147 then
        return nil;
    end;

    local v148 = Weapons:FindFirstChild(p143);

    if not (v148 and v148:IsA("Folder")) then
        v148 = nil;
    end;

    if not v148 then
        return nil;
    end;

    local Model = Instance.new("Model");
    Model.Name = p143;

    for _, child in ipairs(v148:GetChildren()) do
        if child:IsA("BasePart") then
            child:Clone().Parent = Model;
        end;
    end;

    local v149 = Skins:FindFirstChild(p143);
    local v150;

    if v149 then
        v150 = v149:FindFirstChild(p144);

        if not (v150 and v150:IsA("Folder")) then
            v150 = nil;
        end;
    else
        v150 = nil;
    end;

    if v150 then
        v150 = v150:FindFirstChild("Camera");
    end;

    local v151 = GetWearTextureFolder(v150, v147, p145 or v147.floatRange.min);

    if v151 then
        ApplySkinTextures(Model, v151);
    end;

    return Model;
end;

function u1.GetCharacterModel(p152, p153, p154, p155, p156, p157, p158, p159) -- Line: 1031
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), GetSkinTextureFolder (copy), GetWearTextureFolder (copy), ApplySkinTextures (copy), AttachStatTrak (copy), AttachNameTag (copy), AttachCharm (copy)
    local v160;

    if typeof(p152) == "string" and (typeof(p153) == "string" and p152 ~= "") then
        v160 = p153 ~= "";
    else
        v160 = false;
    end;

    if not v160 then
        return nil;
    end;

    local v161 = u1.GetSkinInformation(p152, p153);

    if not v161 and next(u4) == nil then
        u3:Wait();
        v161 = u1.GetSkinInformation(p152, p153);
    end;

    if not v161 then
        warn((`SkinHandler.GetCharacterModel: Skin "{p153}" not found for weapon "{p152}"`));

        return nil;
    end;

    local v162 = Weapons:FindFirstChild(p152);

    if not (v162 and v162:IsA("Folder")) then
        v162 = nil;
    end;

    if v162 then
        v162 = v162:FindFirstChild("Character");
    end;

    if not (v162 and v162:IsA("Model")) then
        warn((`SkinHandler.GetCharacterModel: Base character model not found for weapon "{p152}"`));

        return nil;
    end;

    local v163 = v162:Clone();
    local v164 = GetSkinTextureFolder(p152, p153, p159);

    if v164 then
        v164 = v164:FindFirstChild("Character");
    end;

    local v165 = GetWearTextureFolder(v164, v161, p154 or v161.floatRange.max);

    if v165 then
        ApplySkinTextures(v163, v165);
    end;

    if p155 then
        AttachStatTrak(v163, p155, p152);
    end;

    if p156 then
        AttachNameTag(v163, p156);
    end;

    if p157 then
        AttachCharm(v163, p157);
    end;

    return v163;
end;

function u1.GetWorldModel(p166, p167, p168, p169, p170, p171, p172) -- Line: 1104
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), Skins (copy), GetWearTextureFolder (copy), ApplySkinTextures (copy), AttachStatTrak (copy), AttachNameTag (copy), AttachCharm (copy)
    local v173;

    if typeof(p166) == "string" and (typeof(p167) == "string" and p166 ~= "") then
        v173 = p167 ~= "";
    else
        v173 = false;
    end;

    if not v173 then
        return nil;
    end;

    local v174 = u1.GetSkinInformation(p166, p167);

    if not v174 and next(u4) == nil then
        u3:Wait();
        v174 = u1.GetSkinInformation(p166, p167);
    end;

    if not v174 then
        return nil;
    end;

    local v175 = Weapons:FindFirstChild(p166);

    if not (v175 and v175:IsA("Folder")) then
        v175 = nil;
    end;

    if v175 then
        v175 = v175:FindFirstChild("Other");
    end;

    if v175 then
        v175 = v175:FindFirstChild("World");
    end;

    if not (v175 and v175:IsA("Model")) then
        return nil;
    end;

    local v176 = v175:Clone();
    local v177 = Skins:FindFirstChild(p166);
    local v178;

    if v177 then
        v178 = v177:FindFirstChild(p167);

        if not (v178 and v178:IsA("Folder")) then
            v178 = nil;
        end;
    else
        v178 = nil;
    end;

    if v178 then
        v178 = v178:FindFirstChild("Character");
    end;

    local v179 = GetWearTextureFolder(v178, v174, p168 or v174.floatRange.max);

    if v179 then
        ApplySkinTextures(v176, v179);
    end;

    if p169 then
        AttachStatTrak(v176, p169, p166);
    end;

    if p170 then
        AttachNameTag(v176, p170);
    end;

    if p171 then
        AttachCharm(v176, p171);
    end;

    return v176;
end;

function u1.GetCameraModel(p180, p181, p182, p183, p184, p185, p186, p187) -- Line: 1174
    -- upvalues: u1 (copy), u4 (ref), u3 (copy), Weapons (copy), GetSkinTextureFolder (copy), GetWearTextureFolder (copy), ApplySkinTextures (copy), AttachStatTrakCamera (copy), AttachNameTagCamera (copy), AttachCharmCamera (copy)
    local v188;

    if typeof(p180) == "string" and (typeof(p181) == "string" and p180 ~= "") then
        v188 = p181 ~= "";
    else
        v188 = false;
    end;

    if not v188 then
        return nil;
    end;

    local v189 = u1.GetSkinInformation(p180, p181);

    if not v189 and next(u4) == nil then
        u3:Wait();
        v189 = u1.GetSkinInformation(p180, p181);
    end;

    if not v189 then
        return nil;
    end;

    local v190 = Weapons:FindFirstChild(p180);

    if not (v190 and v190:IsA("Folder")) then
        v190 = nil;
    end;

    if v190 then
        v190 = v190:FindFirstChild("Camera");
    end;

    if not (v190 and v190:IsA("Model")) then
        return nil;
    end;

    local v191 = GetSkinTextureFolder(p180, p181, p187);

    if v191 then
        v191 = v191:FindFirstChild("Camera");
    end;

    local v192 = GetWearTextureFolder(v191, v189, p182 or v189.floatRange.max);
    local v193 = v190:Clone();

    if v192 then
        ApplySkinTextures(v193, v192);
    end;

    if p183 then
        AttachStatTrakCamera(v193, p183, p180);
    end;

    if p184 then
        AttachNameTagCamera(v193, p184);
    end;

    if p185 then
        AttachCharmCamera(v193, p185);
    end;

    return v193;
end;

function u1.GetSkinInformation(p194, p195) -- Line: 1244
    -- upvalues: u4 (ref), u5 (copy), CreateSyntheticStockSchema (copy)
    local v196;

    if typeof(p194) == "string" and (typeof(p195) == "string" and p194 ~= "") then
        v196 = p195 ~= "";
    else
        v196 = false;
    end;

    if not v196 then
        return nil;
    end;

    local v197 = u4[p194];

    if v197 and v197[p195] then
        return v197[p195];
    end;

    if p195 ~= "Stock" then
        return nil;
    end;

    local v198 = u5[p194];

    if v198 and v198.Stock then
        return v198.Stock;
    end;

    local v199 = CreateSyntheticStockSchema(p194);

    if not v199 then
        return nil;
    end;

    local v200 = v198 or {};
    v200.Stock = v199;
    u5[p194] = v200;

    return v199;
end;

function u1.GetAllSkinsForWeapon(p201) -- Line: 1268
    -- upvalues: u4 (ref)
    if typeof(p201) ~= "string" or p201 == "" then
        return nil;
    end;

    local v202 = u4[p201];

    if not v202 then
        return nil;
    end;

    local v203 = {};

    for _, v in pairs(v202) do
        table.insert(v203, v);
    end;

    return v203;
end;

function u1.GetWearImageForFloat(p204, p205) -- Line: 1292
    -- upvalues: GetWearFromFloat (copy)
    local v206 = GetWearFromFloat(p204, p205);

    if not v206 then
        return nil;
    end;

    for _, v in ipairs(p204.wearImages) do
        if v.wear == v206 then
            return v.assetId;
        end;
    end;

    return nil;
end;

function u1.GetBaseWeaponModel(p207, p208) -- Line: 1312
    -- upvalues: Weapons (copy)
    if typeof(p207) ~= "string" or p207 == "" then
        return nil;
    end;

    local v209 = Weapons:FindFirstChild(p207);

    if not (v209 and v209:IsA("Folder")) then
        v209 = nil;
    end;

    if not v209 then
        return nil;
    end;

    local v210 = v209:FindFirstChild(p208);

    if v210 and v210:IsA("Model") then
        return v210:Clone();
    end;

    return nil;
end;

if ReplicatedStorage:GetAttribute("AvaiableSkins") then
    u4 = HttpService:JSONDecode((ReplicatedStorage:GetAttribute("AvaiableSkins")));

    if #u3:GetConnections() > 0 then
        u3:Fire(u4);
    end;
end;

ReplicatedStorage:GetAttributeChangedSignal("AvaiableSkins"):Connect(function() -- Line: 1340
    -- upvalues: ReplicatedStorage (copy), u4 (ref), HttpService (copy), u3 (copy)
    local v211 = ReplicatedStorage:GetAttribute("AvaiableSkins");

    if not v211 then
        return;
    end;

    u4 = HttpService:JSONDecode(v211);

    if #u3:GetConnections() <= 0 then
        return;
    end;

    u3:Fire(u4);
end);

return u1;