-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local SharedModules = ReplicatedStorage:WaitForChild("SharedModules");

local function tryRequire(p1) -- Line: 10
    -- upvalues: SharedModules (copy)
    local v2 = SharedModules:FindFirstChild(p1);

    if not (v2 and v2:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, v2);

    if success then
        return result;
    end;

    return nil;
end;

local SeedData = SharedModules:FindFirstChild("SeedData");
local u3;

if SeedData and SeedData:IsA("ModuleScript") then
    local v4;
    v4, u3 = pcall(require, SeedData);

    if not v4 then
        u3 = nil;
    end;
else
    u3 = nil;
end;

local SprinklerData = SharedModules:FindFirstChild("SprinklerData");
local u5;

if SprinklerData and SprinklerData:IsA("ModuleScript") then
    local v6;
    v6, u5 = pcall(require, SprinklerData);

    if not v6 then
        u5 = nil;
    end;
else
    u5 = nil;
end;

local WateringcanData = SharedModules:FindFirstChild("WateringcanData");
local u7;

if WateringcanData and WateringcanData:IsA("ModuleScript") then
    local v8;
    v8, u7 = pcall(require, WateringcanData);

    if not v8 then
        u7 = nil;
    end;
else
    u7 = nil;
end;

local MushroomData = SharedModules:FindFirstChild("MushroomData");
local u9;

if MushroomData and MushroomData:IsA("ModuleScript") then
    local v10;
    v10, u9 = pcall(require, MushroomData);

    if not v10 then
        u9 = nil;
    end;
else
    u9 = nil;
end;

local RaccoonData = SharedModules:FindFirstChild("RaccoonData");
local u11;

if RaccoonData and RaccoonData:IsA("ModuleScript") then
    local v12;
    v12, u11 = pcall(require, RaccoonData);

    if not v12 then
        u11 = nil;
    end;
else
    u11 = nil;
end;

local GnomeData = SharedModules:FindFirstChild("GnomeData");
local u13;

if GnomeData and GnomeData:IsA("ModuleScript") then
    local v14;
    v14, u13 = pcall(require, GnomeData);

    if not v14 then
        u13 = nil;
    end;
else
    u13 = nil;
end;

local PowerHoseData = SharedModules:FindFirstChild("PowerHoseData");
local u15;

if PowerHoseData and PowerHoseData:IsA("ModuleScript") then
    local v16;
    v16, u15 = pcall(require, PowerHoseData);

    if not v16 then
        u15 = nil;
    end;
else
    u15 = nil;
end;

local CrateData = SharedModules:FindFirstChild("CrateData");
local u17;

if CrateData and CrateData:IsA("ModuleScript") then
    local v18;
    v18, u17 = pcall(require, CrateData);

    if not v18 then
        u17 = nil;
    end;
else
    u17 = nil;
end;

local GuildCrateData = SharedModules:FindFirstChild("GuildCrateData");
local u19;

if GuildCrateData and GuildCrateData:IsA("ModuleScript") then
    local v20;
    v20, u19 = pcall(require, GuildCrateData);

    if not v20 then
        u19 = nil;
    end;
else
    u19 = nil;
end;

local SeedPackData = SharedModules:FindFirstChild("SeedPackData");
local u21;

if SeedPackData and SeedPackData:IsA("ModuleScript") then
    local v22;
    v22, u21 = pcall(require, SeedPackData);

    if not v22 then
        u21 = nil;
    end;
else
    u21 = nil;
end;

local EggData = SharedModules:FindFirstChild("EggData");
local u23;

if EggData and EggData:IsA("ModuleScript") then
    local v24;
    v24, u23 = pcall(require, EggData);

    if not v24 then
        u23 = nil;
    end;
else
    u23 = nil;
end;

local TrowelData = SharedModules:FindFirstChild("TrowelData");
local u25;

if TrowelData and TrowelData:IsA("ModuleScript") then
    local v26;
    v26, u25 = pcall(require, TrowelData);

    if not v26 then
        u25 = nil;
    end;
else
    u25 = nil;
end;

local PropData = SharedModules:FindFirstChild("PropData");
local u27;

if PropData and PropData:IsA("ModuleScript") then
    local v28;
    v28, u27 = pcall(require, PropData);

    if not v28 then
        u27 = nil;
    end;
else
    u27 = nil;
end;

local GearShopData = SharedModules:FindFirstChild("GearShopData");
local u29;

if GearShopData and GearShopData:IsA("ModuleScript") then
    local v30;
    v30, u29 = pcall(require, GearShopData);

    if not v30 then
        u29 = nil;
    end;
else
    u29 = nil;
end;

local SellValueData = SharedModules:FindFirstChild("SellValueData");
local u31;

if SellValueData and SellValueData:IsA("ModuleScript") then
    local v32;
    v32, u31 = pcall(require, SellValueData);

    if not v32 then
        u31 = nil;
    end;
else
    u31 = nil;
end;

local FruitValueCalc = SharedModules:FindFirstChild("FruitValueCalc");
local u33;

if FruitValueCalc and FruitValueCalc:IsA("ModuleScript") then
    local v34;
    v34, u33 = pcall(require, FruitValueCalc);

    if not v34 then
        u33 = nil;
    end;
else
    u33 = nil;
end;

local v35 = nil;
local SharedData = ReplicatedStorage:FindFirstChild("SharedData");
local v36 = SharedData and SharedData:FindFirstChild("PetData");
local u37;

if v36 and v36:IsA("ModuleScript") then
    local v38;
    v38, u37 = pcall(require, v36);

    if not v38 then
        u37 = v35;
    end;
else
    u37 = v35;
end;

local v39 = nil;
local SharedData2 = ReplicatedStorage:FindFirstChild("SharedData");

if SharedData2 then
    SharedData2 = SharedData2:FindFirstChild("PetSizes");
end;

local u40;

if SharedData2 and SharedData2:IsA("ModuleScript") then
    local v41;
    v41, u40 = pcall(require, SharedData2);

    if not v41 then
        u40 = v39;
    end;
else
    u40 = v39;
end;

local GearImages = SharedModules:FindFirstChild("GearImages");
local PropImages = SharedModules:FindFirstChild("PropImages");

local function getStringValue(p42, p43) -- Line: 60
    if not p42 then
        return "";
    end;

    local v44 = p42:FindFirstChild(p43);

    if v44 and v44:IsA("StringValue") then
        return v44.Value;
    end;

    return not (v44 and v44:IsA("ImageLabel")) and "" or v44.Image;
end;

local function getGearImage(p45) -- Line: 71
    -- upvalues: GearImages (copy)
    local v46 = GearImages;

    if not v46 then
        return "";
    end;

    local v47 = v46:FindFirstChild(p45);

    if v47 and v47:IsA("StringValue") then
        return v47.Value;
    end;

    return not (v47 and v47:IsA("ImageLabel")) and "" or v47.Image;
end;

local function getPropImage(p48) -- Line: 75
    -- upvalues: PropImages (copy)
    local v49 = PropImages;

    if not v49 then
        return "";
    end;

    local v50 = v49:FindFirstChild(p48);

    if v50 and v50:IsA("StringValue") then
        return v50.Value;
    end;

    return not (v50 and v50:IsA("ImageLabel")) and "" or v50.Image;
end;

local function findEntry(p51, p52, p53) -- Line: 79
    if typeof(p51) ~= "table" then
        return nil;
    end;

    for _, v in p51 do
        for _, v2 in p53 do
            if v[v2] == p52 then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function getSeedAssetField(p54, p55) -- Line: 91
    -- upvalues: u3 (copy), findEntry (copy)
    local v56 = u3;

    if typeof(v56) ~= "table" then
        return nil;
    end;

    local v57 = findEntry(v56, p54, { "SeedName" });

    if not v57 then
        return nil;
    end;

    local v58 = v57[p55];

    if typeof(v58) == "Instance" then
        if v58:IsA("StringValue") then
            return v58.Value;
        end;

        if v58:IsA("ImageLabel") then
            return v58.Image;
        end;
    end;

    return v58;
end;

local u59 = {
    Categories = { "Pets", "Sprinklers", "WateringCans", "Mushrooms", "Gnomes", "Raccoons", "Crates", "SeedPacks", "Trowels", "Props", "Seeds", "HarvestedFruits", "EmptyPots" }
};

function u59.IsGiftable(p60) -- Line: 124
    -- upvalues: u59 (copy)
    for _, v in u59.Categories do
        if v == p60 then
            return true;
        end;
    end;

    return false;
end;

local function lookupSimple(p61, p62, p63, p64) -- Line: 131
    -- upvalues: findEntry (copy)
    if typeof(p61) ~= "table" then
        return p62, "";
    end;

    local v65 = findEntry(p61, p62, { p63 });

    if not v65 then
        return p62, "";
    end;

    local v66 = v65[p64];
    local v67 = typeof(v66) ~= "string" and "" or v66;

    return v65[p63] or p62, v67;
end;

local function lookupGearByName(p68, p69, p70, p71) -- Line: 140
    -- upvalues: lookupSimple (copy)
    if typeof(p68) == "table" and typeof(p68.Data) == "table" then
        p68 = p68.Data;
    end;

    return lookupSimple(p68, p69, p70, p71);
end;

function u59.Resolve(p72, p73, p74) -- Line: 151
    -- upvalues: getSeedAssetField (copy), u37 (ref), u40 (ref), lookupGearByName (copy), u5 (copy), u7 (copy), u9 (copy), u11 (copy), u13 (copy), u15 (copy), u19 (copy), u17 (copy), u21 (copy), u23 (copy), PropImages (copy), u27 (copy), u25 (copy), GearImages (copy)
    if p72 == "Seeds" then
        local v75 = getSeedAssetField(p73, "SeedImage") or "";
        local v76 = string.lower(p73);

        if string.sub(v76, -5) ~= " seed" and v76 ~= "seed" then
            p73 = p73 .. " Seed";
        end;

        return p73, typeof(v75) == "string" and v75 and v75 or "";
    end;

    if p72 == "HarvestedFruits" then
        local v77;

        if typeof(p74) == "table" then
            p73 = p74.FruitName or (p74.Name or p73);
            v77 = p74.Mutation;
        else
            v77 = nil;
        end;

        local v78 = getSeedAssetField(p73, "FruitImage") or "";

        if v77 and v77 ~= "" then
            p73 = string.format("%s [%s]", p73, v77);
        end;

        return p73, typeof(v78) == "string" and v78 and v78 or "";
    end;

    if p72 == "Pets" then
        local v79, v80, v81;

        if typeof(p74) == "table" then
            p73 = p74.Name or p73;
            v79 = p74.Mutation;
            v80 = p74.Size;
            v81 = p74.Type;
        else
            v81 = nil;
            v80 = nil;
            v79 = nil;
        end;

        local v82 = "";
        local v83;

        if typeof(u37) == "table" then
            if typeof(u37.GetImage) == "function" then
                local v84;
                v84, v83 = pcall(u37.GetImage, p73, v80);

                if v84 and typeof(v83) == "string" then
                    if v83 == "" then
                        v83 = v82;
                    end;
                else
                    v83 = v82;
                end;
            else
                v83 = v82;
            end;

            if v83 == "" then
                local v85 = u37[p73];

                if typeof(v85) == "table" and typeof(v85.Image) == "string" then
                    v83 = v85.Image;
                end;
            end;
        else
            v83 = v82;
        end;

        local v86;

        if typeof(u37) == "table" and typeof(u37.GetSpeciesDisplayName) == "function" then
            local v87;
            v87, v86 = pcall(u37.GetSpeciesDisplayName, p73);

            if v87 and typeof(v86) == "string" then
                if v86 == "" then
                    v86 = p73;
                end;
            else
                v86 = p73;
            end;
        else
            v86 = p73;
        end;

        local v88 = {};

        if v81 ~= nil and v81 ~= "" then
            table.insert(v88, v81);
        end;

        if v80 ~= nil and v80 ~= "" then
            if u40 then
                v80 = u40.DisplaySize(v80) or v80;
            end;

            table.insert(v88, v80);
        end;

        table.insert(v88, v86);
        local v89 = table.concat(v88, " ");

        if v79 ~= nil and v79 ~= "" then
            v89 = string.format("%s [%s]", v89, v79);
        end;

        return v89, v83;
    end;

    if p72 == "Sprinklers" then
        return lookupGearByName(u5, p73, "SprinklerName", "Image");
    end;

    if p72 == "WateringCans" then
        return lookupGearByName(u7, p73, "Name", "Image");
    end;

    if p72 == "Mushrooms" then
        return lookupGearByName(u9, p73, "Name", "IMG");
    end;

    if p72 == "Raccoons" then
        return lookupGearByName(u11, p73, "Name", "IMG");
    end;

    if p72 == "Gnomes" then
        return lookupGearByName(u13, p73, "Name", "IMG");
    end;

    if p72 == "PowerHoses" then
        return lookupGearByName(u15, p73, "Name", "IMG");
    end;

    if p72 == "Crates" then
        local v90 = u19 and u19.GetData and u19.GetData(p73);

        if v90 then
            return v90.Name or p73, v90.IMG or "";
        end;

        local v91 = u17 and u17.GetData and u17.GetData(p73);

        if v91 then
            return v91.Name or p73, v91.IMG or "";
        end;

        return p73, "";
    end;

    if p72 == "SeedPacks" then
        return lookupGearByName(u21, p73, "PackName", "IMG");
    end;

    if p72 == "Eggs" then
        local v92 = typeof(u23) == "table" and typeof(u23.GetData) == "function" and u23.GetData(p73);

        if not v92 then
            return p73, "";
        end;

        local IMG = v92.IMG;
        local v93 = v92.EggName or p73;

        if typeof(IMG) == "string" then
            return v93, IMG;
        end;

        return v93, "";
    end;

    if p72 ~= "Props" then
        if p72 == "Trowels" then
            local v94 = "";

            if typeof(u25) == "table" then
                local Data = u25.Data;

                if typeof(Data) == "table" and typeof(Data.IMG) == "string" then
                    v94 = Data.IMG;
                end;
            end;

            if v94 == "" then
                local v95 = GearImages;

                if v95 then
                    local v96 = v95:FindFirstChild(p73);

                    if v96 and v96:IsA("StringValue") then
                        v94 = v96.Value;
                    else
                        v94 = not (v96 and v96:IsA("ImageLabel")) and "" or v96.Image;
                    end;
                else
                    v94 = "";
                end;
            end;

            return p73, v94;
        end;

        local v97 = GearImages;

        if not v97 then
            return p73, "";
        end;

        local v98 = v97:FindFirstChild(p73);

        if v98 and v98:IsA("StringValue") then
            return p73, v98.Value;
        end;

        if v98 and v98:IsA("ImageLabel") then
            return p73, v98.Image;
        end;

        return p73, "";
    end;

    local v99 = PropImages;
    local v100;

    if v99 then
        local v101 = v99:FindFirstChild(p73);

        if v101 and v101:IsA("StringValue") then
            v100 = v101.Value;
        else
            v100 = not (v101 and v101:IsA("ImageLabel")) and "" or v101.Image;
        end;
    else
        v100 = "";
    end;

    if v100 == "" and (typeof(u27) == "table" and typeof(u27.Data) == "table") then
        for _, v in u27.Data do
            if typeof(v) == "table" and v.PropName == p73 then
                if typeof(v.IMG) == "string" then
                    v100 = v.IMG;
                end;

                break;
            end;
        end;
    end;

    return p73, v100;
end;

local u102 = nil;

local function getGearRarity(p103) -- Line: 305
    -- upvalues: u102 (ref), u29 (copy)
    if u102 == nil then
        local v104 = {};

        if typeof(u29) == "table" and typeof(u29.Data) == "table" then
            for _, v in u29.Data do
                if typeof(v) == "table" and (typeof(v.ItemName) == "string" and typeof(v.Rarity) == "string") then
                    v104[v.ItemName] = v.Rarity;
                end;
            end;
        end;

        u102 = v104;
    end;

    return u102[p103] or "";
end;

function u59.ResolveRarity(p105, p106) -- Line: 326
    -- upvalues: u37 (ref), u23 (copy), u21 (copy), findEntry (copy), u19 (copy), u17 (copy), getGearRarity (copy)
    if p105 == "Pets" then
        if typeof(u37) == "table" then
            local v107 = u37[p106];

            if typeof(v107) == "table" and typeof(v107.Rarity) == "string" then
                return v107.Rarity;
            end;
        end;
    elseif p105 == "Eggs" then
        if typeof(u23) == "table" and typeof(u23.GetData) == "function" then
            local v108 = u23.GetData(p106);

            if typeof(v108) == "table" and typeof(v108.Rarity) == "string" then
                return v108.Rarity;
            end;
        end;
    elseif p105 == "SeedPacks" then
        local v109 = u21;

        if typeof(v109) == "table" and typeof(v109.Data) == "table" then
            v109 = v109.Data;
        end;

        local v110 = findEntry(v109, p106, { "PackName" });

        if typeof(v110) == "table" and typeof(v110.Rarity) == "string" then
            return v110.Rarity;
        end;
    elseif p105 == "Crates" then
        if u19 and u19.GetData then
            local v111 = u19.GetData(p106);

            if typeof(v111) == "table" and typeof(v111.Rarity) == "string" then
                return v111.Rarity;
            end;
        end;

        if u17 and u17.GetData then
            local v112 = u17.GetData(p106);

            if typeof(v112) == "table" and typeof(v112.Rarity) == "string" then
                return v112.Rarity;
            end;
        end;

        return "";
    end;

    return getGearRarity(p106);
end;

local u113 = nil;

local function buildGearCostIndex() -- Line: 375
    -- upvalues: u113 (ref), u29 (copy)
    if u113 ~= nil then
        return;
    end;

    local v114 = {};

    if typeof(u29) == "table" and typeof(u29.Data) == "table" then
        for _, v in u29.Data do
            if typeof(v) == "table" and (typeof(v.ItemName) == "string" and typeof(v.Cost) == "number") then
                v114[v.ItemName] = v.Cost;
            end;
        end;
    end;

    u113 = v114;
end;

function u59.GetValue(p115, p116, p117, p118) -- Line: 395
    -- upvalues: u33 (copy), u31 (copy), buildGearCostIndex (copy), u113 (ref)
    if p115 == "HarvestedFruits" then
        if typeof(p117) ~= "table" then
            return 0;
        end;

        if typeof(u33) ~= "function" then
            return 0;
        end;

        local success, result = pcall(u33, p117.FruitName or (p117.Name or p116), p117.SizeMultiplier or 1, p117.Mutation, p118);

        return (not success or typeof(result) ~= "number") and 0 or result;
    end;

    if p115 == "Seeds" then
        if typeof(u31) == "table" then
            local v119 = u31[p116];

            if typeof(v119) == "number" then
                return v119;
            end;
        end;

        return 0;
    end;

    buildGearCostIndex();
    local v120 = u113;

    return (not v120 or typeof(v120[p116]) ~= "number") and 0 or v120[p116];
end;

local u121 = {};

function u59.GetCachedHeadshot(p122) -- Line: 432
    -- upvalues: u121 (copy)
    return u121[p122];
end;

function u59.GetHeadshot(u123) -- Line: 436
    -- upvalues: u121 (copy), Players (copy)
    local v124 = u121[u123];

    if v124 ~= nil then
        return v124;
    end;

    local success, result = pcall(function() -- Line: 442
        -- upvalues: Players (ref), u123 (copy)
        return Players:GetUserThumbnailAsync(u123, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
    end);

    if not success or typeof(result) ~= "string" then
        return "";
    end;

    u121[u123] = result;

    return result;
end;

local function setLabelChain(p125, p126) -- Line: 488
    if p125:IsA("TextLabel") or p125:IsA("TextButton") then
        p125.Text = p126;
    end;

    for _, descendant in p125:GetDescendants() do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            descendant.Text = p126;
        end;
    end;
end;

local u127 = {
    Common = "#bfbfbf",
    Uncommon = "#44d200",
    Rare = "#2f8bff",
    Epic = "#a64bff",
    Legendary = "#ffd11a",
    Mythic = "#ff3b3b",
    Super = "#ffffff"
};

local function pickGuildRewardTemplate(u128, p129) -- Line: 544
    local function child(p130) -- Line: 548
        -- upvalues: u128 (copy)
        local v131 = u128:FindFirstChild(p130);

        if v131 and v131:IsA("Frame") then
            return v131;
        end;

        return nil;
    end;

    if p129 == "Owner" then
        local GuildRewardTemplate_Owner = u128:FindFirstChild("GuildRewardTemplate_Owner");

        if not (GuildRewardTemplate_Owner and GuildRewardTemplate_Owner:IsA("Frame")) then
            GuildRewardTemplate_Owner = nil;
        end;

        if GuildRewardTemplate_Owner then
            return GuildRewardTemplate_Owner, "Owner";
        end;
    end;

    if p129 == "Elder" then
        local GuildRewardTemplate_Elder = u128:FindFirstChild("GuildRewardTemplate_Elder");

        if not (GuildRewardTemplate_Elder and GuildRewardTemplate_Elder:IsA("Frame")) then
            GuildRewardTemplate_Elder = nil;
        end;

        if GuildRewardTemplate_Elder then
            return GuildRewardTemplate_Elder, "Elder";
        end;
    end;

    local GuildRewardTemplate = u128:FindFirstChild("GuildRewardTemplate");

    if not (GuildRewardTemplate and GuildRewardTemplate:IsA("Frame")) then
        GuildRewardTemplate = nil;
    end;

    return GuildRewardTemplate, "Member";
end;

local function findPrizeDisplayTemplate(p132) -- Line: 570
    local Frame = p132:FindFirstChild("Frame");

    if Frame then
        local PrizeDisplayTemplate = Frame:FindFirstChild("PrizeDisplayTemplate");

        if PrizeDisplayTemplate and PrizeDisplayTemplate:IsA("Frame") then
            return PrizeDisplayTemplate, Frame;
        end;
    end;

    local PrizeDisplayTemplate = p132:FindFirstChild("PrizeDisplayTemplate");

    if PrizeDisplayTemplate and PrizeDisplayTemplate:IsA("Frame") then
        return PrizeDisplayTemplate, p132;
    end;

    return nil, nil;
end;

local SeedpackReward = game.SoundService.SFX.SeedpackSFX.SeedpackReward;

function u59.PlayGuildRewardClaimSFX() -- Line: 616
    -- upvalues: SeedpackReward (copy)
    SeedpackReward.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    SeedpackReward.Playing = true;
    SeedpackReward.TimePosition = 0;
end;

function u59.BuildGuildRewardVisual(p133, p134, p135, p136) -- Line: 622
    -- upvalues: pickGuildRewardTemplate (copy), u127 (copy), findPrizeDisplayTemplate (copy), u59 (copy)
    if not p133 then
        return nil;
    end;

    local v137 = pickGuildRewardTemplate(p133, typeof(p135.RoleAtFlip) ~= "string" and "Member" or p135.RoleAtFlip);

    if not v137 then
        return nil;
    end;

    local v138 = v137:Clone();
    v138.Name = "Gift_" .. p134;
    v138.Visible = true;
    local Interior = v138:FindFirstChild("Interior");

    if not Interior then
        v138:Destroy();

        return nil;
    end;

    local v139 = typeof(p135.Tier) == "string" and (u127[p135.Tier] or "#ffffff") or "#ffd11a";
    local v140 = string.format("<font color=\"%s\">%s</font>", v139, p135.Local == true and "Local Bracket Reward" or "Guild Reward");
    local TopFrame = Interior:FindFirstChild("TopFrame");

    if TopFrame then
        local SubjectLine1 = TopFrame:FindFirstChild("SubjectLine1");

        if SubjectLine1 and (SubjectLine1:IsA("TextLabel") or SubjectLine1:IsA("TextButton")) then
            SubjectLine1.RichText = true;
            SubjectLine1.Text = v140;
            local SubjectLine2 = SubjectLine1:FindFirstChild("SubjectLine2");

            if SubjectLine2 and (SubjectLine2:IsA("TextLabel") or SubjectLine2:IsA("TextButton")) then
                SubjectLine2.RichText = true;
                SubjectLine2.Text = v140;
            end;
        end;
    end;

    local v141 = tonumber(p135.Placement) or 0;
    local NoteTextlabel = Interior:FindFirstChild("NoteTextlabel");

    if NoteTextlabel and (NoteTextlabel:IsA("TextLabel") or NoteTextlabel:IsA("TextButton")) then
        NoteTextlabel.RichText = false;
        local v142;

        if p135.Local == true then
            local v143 = (typeof(p135.Band) ~= "string" or p135.Band == "") and "local" or p135.Band;

            if v141 > 0 then
                v142 = string.format("Your guild placed #%d in its %s bracket!", v141, v143);
            else
                v142 = string.format("Your guild placed in its %s bracket!", v143);
            end;
        else
            v142 = v141 <= 0 and "Your guild placed in the contest!" or string.format("Your guild placed #%d", v141);
        end;

        NoteTextlabel.Text = v142;
    end;

    local v144, v145 = findPrizeDisplayTemplate(Interior);

    if v144 and v145 then
        v144.Visible = false;
        local v146 = typeof(p135.Items) ~= "table" and {} or p135.Items;

        for i, v in #v146 == 0 and (typeof(p135.CrateName) == "string" and p135.CrateName ~= "") and {
            {
                Category = "Crates",
                ItemName = p135.CrateName,
                Count = tonumber(p135.BaseAmount) or 1
            }
        } or v146 do
            if typeof(v) == "table" then
                local v147 = typeof(v.ItemName) ~= "string" and "" or v.ItemName;
                local v148 = typeof(v.Category) ~= "string" and "Crates" or v.Category;
                local v149 = tonumber(v.Count) or 1;
                local _, v150 = u59.Resolve(v148, v147, v);
                local v151 = v144:Clone();
                v151.Name = string.format("PrizeDisplay_%d", i);
                v151.Visible = true;
                v151.LayoutOrder = i;
                v151.Parent = v145;
                local PrizeImage = v151.Frame:FindFirstChild("PrizeImage");

                if PrizeImage and PrizeImage:IsA("ImageLabel") then
                    PrizeImage.Image = v150;
                end;

                for _, v2 in { "Count", "Amount", "CountLabel" } do
                    local v152 = v151.Frame:FindFirstChild(v2);

                    if v152 and (v152:IsA("TextLabel") or v152:IsA("TextButton")) then
                        v152.Text = "x" .. tostring(v149);
                    end;
                end;
            end;
        end;
    end;

    local Claim = Interior:FindFirstChild("Claim");

    if Claim and Claim:IsA("GuiButton") then
        Claim.MouseButton1Click:Connect(p136);
    end;

    v138.Parent = p133;

    return v138;
end;

function u59.BuildInviteVisual(p153, p154, p155, p156, u157, u158) -- Line: 755
    -- upvalues: setLabelChain (copy), u59 (copy)
    if not (p153 and p153:IsA("Frame")) then
        return nil;
    end;

    local u159 = p153:Clone();
    u159.Name = "Invite_" .. p155;
    u159.Visible = true;
    local Interior = u159:FindFirstChild("Interior");

    if not Interior then
        u159:Destroy();

        return nil;
    end;

    local v160 = tostring(p156.GuildName or "Unknown Guild");
    local v161 = tostring(p156.GuildTag or "?");
    local v162 = tostring(p156.FromName or "?");
    local TopFrame = Interior:FindFirstChild("TopFrame");

    if TopFrame then
        local SubjectLine1 = TopFrame:FindFirstChild("SubjectLine1");

        if SubjectLine1 then
            setLabelChain(SubjectLine1, string.format("Guild Invite from @%s", v162));
        end;

        local SentPlayerImageLabel = TopFrame:FindFirstChild("SentPlayerImageLabel");

        if SentPlayerImageLabel and SentPlayerImageLabel:IsA("ImageLabel") then
            local u163 = tonumber(p156.FromUserId) or 0;
            local v164;

            if u163 > 0 then
                v164 = u59.GetCachedHeadshot(u163);
            else
                v164 = nil;
            end;

            if v164 and v164 ~= "" then
                SentPlayerImageLabel.Image = v164;
            elseif u163 > 0 then
                task.spawn(function() -- Line: 800
                    -- upvalues: u59 (ref), u163 (copy), u159 (copy), SentPlayerImageLabel (copy)
                    local v165 = u59.GetHeadshot(u163);

                    if v165 ~= "" and u159.Parent then
                        SentPlayerImageLabel.Image = v165;
                    end;
                end);
            end;
        end;
    end;

    local NoteTextlabel = Interior:FindFirstChild("NoteTextlabel");

    if NoteTextlabel then
        local v166 = not (p156.MemberCount and p156.MaxSlots) and "?/? Members" or string.format("%d/%d Members", p156.MemberCount, p156.MaxSlots);
        setLabelChain(NoteTextlabel, string.format("%s [%s] | %s", v160, v161, v166));
    end;

    local JoinButton = Interior:FindFirstChild("JoinButton");

    if JoinButton and JoinButton:IsA("GuiButton") then
        JoinButton.MouseButton1Click:Connect(function() -- Line: 826
            -- upvalues: u157 (copy)
            u157();
        end);
    end;

    local ExitButton = Interior:FindFirstChild("ExitButton");

    if ExitButton and ExitButton:IsA("GuiButton") then
        ExitButton.MouseButton1Click:Connect(function() -- Line: 834
            -- upvalues: u158 (copy)
            u158();
        end);
    end;

    u159.Parent = p154;

    return u159;
end;

return u59;