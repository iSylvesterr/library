-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local GetTimerFormat = require(ReplicatedStorage.Components.Common.GetTimerFormat);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CollectionService = game:GetService("CollectionService");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Spring = require(ReplicatedStorage.Shared.Spring);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local BuyMenuInfo = require(script:WaitForChild("BuyMenuInfo"));
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local u2 = Janitor.new();
local u3 = Janitor.new();
local u4 = Spring.new(1, 8, 0);
local u5 = {};
local u6 = nil;
local u7 = nil;
local u8 = {
    ["1"] = "Kevlar",
    ["2"] = "Kevlar + Helmet"
};
local u9 = {
    Kevlar = true,
    ["Kevlar + Helmet"] = true,
    ["Defuse Kit"] = true,
    ["Rescue Kit"] = true
};
local u10 = {
    {
        Name = "Yellow",
        Color = Color3.fromRGB(255, 221, 51)
    },
    {
        Name = "Green",
        Color = Color3.fromRGB(0, 153, 0)
    },
    {
        Name = "Blue",
        Color = Color3.fromRGB(0, 102, 204)
    },
    {
        Name = "Purple",
        Color = Color3.fromRGB(153, 51, 204)
    },
    {
        Name = "Orange",
        Color = Color3.fromRGB(255, 128, 0)
    }
};
local u11 = Janitor.new();
local u12 = {};
local u13 = {};
local u14 = nil;
local u15 = {};
local u16 = {};
local u17 = nil;
local u18 = Color3.fromRGB(255, 255, 255);
local u19 = { 1, 2, 3, 4 };

local function CommaNumber(p20) -- Line: 128
    return tostring(p20):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function ResolveTemplateSkinName(p21) -- Line: 133
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v22 = p21:GetAttribute("InventoryItemId");

    if not v22 or (v22 == "" or v22 == "__buymenu_zeus_placeholder__") then
        return nil;
    end;

    if string.sub(v22, 1, 10) == "equipment:" then
        return nil;
    end;

    local v23 = DataController.Get(LocalPlayer, "Inventory");

    if not v23 or typeof(v23) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(v23) do
        if v and v._id == v22 then
            local Skin = v.Skin;

            if typeof(Skin) == "string" and Skin ~= "" then
                return Skin;
            end;

            return nil;
        end;
    end;

    return nil;
end;

local function ShowWeaponInfoFrame(p24) -- Line: 159
    -- upvalues: u6 (ref), ResolveTemplateSkinName (copy), Skins (copy), Rarities (copy), GetSkinDisplayName (copy), u18 (copy), BuyMenuInfo (copy), u19 (copy)
    local v25 = p24:GetAttribute("Weapon");

    if not v25 or v25 == "" then
        return;
    end;

    local WeaponInfoFrame = u6.WeaponInfoFrame;
    local v26 = ResolveTemplateSkinName(p24);
    local v27 = nil;

    if v26 and v26 ~= "Stock" then
        local v28 = Skins.GetSkinInformation(v25, v26);

        if v28 and v28.rarity then
            v27 = v28.rarity;
        end;
    end;

    local v29 = v25:find("Zeus") and "Taser" or v25;

    if v26 and (v26 ~= "Stock" and v27) then
        local v30 = Rarities[v27];
        WeaponInfoFrame.WeaponName.Text = `{v29} | {GetSkinDisplayName(v26)}`;
        WeaponInfoFrame.WeaponName.TextColor3 = v30 and v30.Color or u18;
    else
        WeaponInfoFrame.WeaponName.Text = v29;
        WeaponInfoFrame.WeaponName.TextColor3 = u18;
    end;

    local v31 = BuyMenuInfo.Weapons[v29];
    local Stats = WeaponInfoFrame.Stats;
    local v32 = v31 and (v31.Stars or 0) or 0;
    Stats.Info.Text = v31 and (v31.Info or "") or "";
    Stats.Tip.Text = v31 and v31.Tip or "";
    local v33 = v32 >= 1 and BuyMenuInfo.GetStarColor(v32) or u18;

    for _, v in ipairs(u19) do
        local v34 = Stats.Difficulty:FindFirstChild((tostring(v)));

        if v34 then
            local v35 = v <= v32;
            v34.Visible = v35;

            if v35 then
                v34.ImageColor3 = v33;
            end;
        end;
    end;

    WeaponInfoFrame.Visible = true;
end;

local function HideWeaponInfoFrame() -- Line: 211
    -- upvalues: u6 (ref)
    if u6 and u6.WeaponInfoFrame then
        u6.WeaponInfoFrame.Visible = false;
    end;
end;

local function IsObjectiveEquipmentAvailableForPlayer(p36, p37, p38) -- Line: 219
    if p37 ~= "Counter-Terrorists" then
        return false;
    end;

    if p36 == "Defuse Kit" then
        return p38 == "Bomb Defusal";
    end;

    return p36 ~= "Rescue Kit" and true or p38 == "Hostage Rescue";
end;

local function IsCompetitiveServerGamemode() -- Line: 239
    return workspace:GetAttribute("ServerGamemode") == "Competitive";
end;

local function IsEquipmentAvailableForLocalPlayer(p39) -- Line: 245
    -- upvalues: u9 (copy), LocalPlayer (copy)
    if u9[p39] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return false;
    end;

    if p39 ~= "Defuse Kit" and p39 ~= "Rescue Kit" then
        return true;
    end;

    local v40 = LocalPlayer:GetAttribute("Team");
    local v41 = workspace:GetAttribute("Gamemode");

    if v40 ~= "Counter-Terrorists" then
        return false;
    end;

    if p39 == "Defuse Kit" then
        return v41 == "Bomb Defusal";
    end;

    return p39 ~= "Rescue Kit" and true or v41 == "Hostage Rescue";
end;

local function GetEquipmentByTemplate(p42) -- Line: 261
    -- upvalues: u8 (copy), IsEquipmentAvailableForLocalPlayer (copy), u9 (copy), LocalPlayer (copy)
    local v43 = u8[p42];

    if v43 then
        if IsEquipmentAvailableForLocalPlayer(v43) then
            return v43;
        end;

        return nil;
    end;

    if p42 ~= "3" then
        return nil;
    end;

    local v44;

    if u9["Defuse Kit"] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        v44 = false;
    else
        local v45 = LocalPlayer:GetAttribute("Team");
        local v46 = workspace:GetAttribute("Gamemode");

        if v45 == "Counter-Terrorists" then
            v44 = v46 == "Bomb Defusal";
        else
            v44 = false;
        end;
    end;

    if v44 then
        return "Defuse Kit";
    end;

    local v47;

    if u9["Rescue Kit"] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        v47 = false;
    else
        local v48 = LocalPlayer:GetAttribute("Team");
        local v49 = workspace:GetAttribute("Gamemode");

        if v48 == "Counter-Terrorists" then
            v47 = v49 == "Hostage Rescue";
        else
            v47 = false;
        end;
    end;

    return v47 and "Rescue Kit" or nil;
end;

local function GetLocalPlayerArmorState() -- Line: 288
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local u50 = LocalPlayer:GetAttribute("Armor");

    if typeof(u50) == "string" and u50 ~= "" then
        local success, result = pcall(function() -- Line: 291
            -- upvalues: HttpService (ref), u50 (copy)
            return HttpService:JSONDecode(u50);
        end);

        if success and typeof(result) == "table" then
            return {
                Type = tostring(result.Type or ""),
                Health = tonumber(result.Health) or 0
            };
        end;
    end;

    return {
        Type = "",
        Health = 0
    };
end;

local function GetDisplayCost(p51, p52) -- Line: 312
    -- upvalues: GameState (copy), GetLocalPlayerArmorState (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" or GameState.GetState() == "Warmup" then
        return 0;
    end;

    if workspace:GetAttribute("VIPInfiniteCashEnabled") == true then
        return 0;
    end;

    local Cost = p52.Cost;

    if p51 == "Kevlar + Helmet" then
        local v53 = GetLocalPlayerArmorState();
        Cost = v53.Type == "Kevlar" and v53.Health >= 100 and 350 or Cost;
    end;

    return Cost;
end;

local function IsEquipmentOwned(p54) -- Line: 333
    -- upvalues: LocalPlayer (copy), GetLocalPlayerArmorState (copy)
    if p54 == "Defuse Kit" then
        return LocalPlayer:GetAttribute("HasDefuseKit") == true;
    end;

    if p54 == "Rescue Kit" then
        return LocalPlayer:GetAttribute("HasRescueKit") == true;
    end;

    local v55 = GetLocalPlayerArmorState();

    if p54 == "Kevlar" then
        local v56;

        if v55.Health > 0 then
            v56 = v55.Type == "Kevlar";
        else
            v56 = false;
        end;

        return v56;
    end;

    if p54 ~= "Kevlar + Helmet" then
        return false;
    end;

    local v57;

    if v55.Health > 0 then
        v57 = v55.Type == "Kevlar + Helmet";
    else
        v57 = false;
    end;

    return v57;
end;

local function IsEquipmentPurchaseBlockedForLocalPlayer(p58) -- Line: 352
    -- upvalues: IsEquipmentAvailableForLocalPlayer (copy), IsEquipmentOwned (copy), GetLocalPlayerArmorState (copy)
    if not IsEquipmentAvailableForLocalPlayer(p58) then
        return true;
    end;

    if p58 == "Defuse Kit" or p58 == "Rescue Kit" then
        return IsEquipmentOwned(p58);
    end;

    local v59 = GetLocalPlayerArmorState();
    local v60;

    if v59.Type == "Kevlar + Helmet" then
        v60 = v59.Health > 0;
    else
        v60 = false;
    end;

    local v61;

    if v60 then
        v61 = v59.Health >= 100;
    else
        v61 = v60;
    end;

    if p58 == "Kevlar" then
        local v62;

        if v59.Type == "Kevlar" then
            v62 = v59.Health >= 100;
        else
            v62 = false;
        end;

        return v62 or v61;
    end;

    if p58 == "Kevlar + Helmet" then
        return v60;
    end;

    return false;
end;

local function setupBuyMenuTemplates() -- Line: 376
    -- upvalues: Profiler (copy), u6 (ref), Router (copy), LocalPlayer (copy), u1 (copy), u8 (copy), IsEquipmentAvailableForLocalPlayer (copy), u9 (copy)
    Profiler.mark("UI.BuyMenu.SetupBuyMenuTemplates");

    for _, descendant in ipairs(u6.Menu.Container:GetDescendants()) do
        if descendant:IsA("TextButton") then
            if descendant.Parent.Name == "Equipment" then
                if descendant.Name == "4" then
                    local v63 = Router.broadcastRouter("GetEquippedInventoryItem", LocalPlayer, "Equipped.Equipped Zeus x27");

                    if v63 and v63.Name then
                        u1.createTemplate(descendant, v63, false, "Equipped.Equipped Zeus x27");
                    else
                        u1.createTemplate(descendant, {
                            Name = "Zeus x27",
                            _id = "__buymenu_zeus_placeholder__"
                        }, false, "Equipped.Equipped Zeus x27");
                    end;
                else
                    local Name = descendant.Name;
                    local v64 = u8[Name];

                    if v64 then
                        if not IsEquipmentAvailableForLocalPlayer(v64) then
                            v64 = nil;
                        end;
                    elseif Name == "3" then
                        local v65;

                        if u9["Defuse Kit"] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
                            v65 = false;
                        else
                            local v66 = LocalPlayer:GetAttribute("Team");
                            local v67 = workspace:GetAttribute("Gamemode");

                            if v66 == "Counter-Terrorists" then
                                v65 = v67 == "Bomb Defusal";
                            else
                                v65 = false;
                            end;
                        end;

                        if v65 then
                            v64 = "Defuse Kit";
                        else
                            local v68;

                            if u9["Rescue Kit"] and workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
                                v68 = false;
                            else
                                local v69 = LocalPlayer:GetAttribute("Team");
                                local v70 = workspace:GetAttribute("Gamemode");

                                if v69 == "Counter-Terrorists" then
                                    v68 = v70 == "Hostage Rescue";
                                else
                                    v68 = false;
                                end;
                            end;

                            v64 = v68 and "Rescue Kit" or nil;
                        end;
                    else
                        v64 = nil;
                    end;

                    if v64 then
                        u1.createTemplate(descendant, {
                            Name = v64,
                            _id = `equipment:{v64}`
                        }, true, nil);
                    else
                        descendant:SetAttribute("IsEquipment", nil);
                        descendant:SetAttribute("Weapon", nil);
                        descendant.Visible = false;
                    end;
                end;
            else
                u1.setupTemplate(descendant, (`Loadout.{descendant.Parent.Name}.Options.{tonumber(descendant.Name)}`));
            end;
        end;
    end;
end;

local function GetInventoryItemProperties(p71, p72) -- Line: 430
    -- upvalues: ReplicatedStorage (copy)
    local v73 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p71) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(p71);

    if v73 then
        return require(v73);
    end;

    return nil;
end;

local function QueryInventoryItem(p74, p75) -- Line: 448
    for _, v in ipairs(p74) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p75 then
                return v2;
            end;
        end;
    end;

    return false;
end;

local function QueryInventoryItemPurchasedThisRound(p76, p77) -- Line: 472
    -- upvalues: u5 (copy), QueryInventoryItem (copy)
    for _, v in ipairs(p76) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p77 and table.find(u5, v2.Identifier) then
                return v2;
            end;
        end;
    end;

    return QueryInventoryItem(p76, p77);
end;

local function GetInventoryItemToReplace(p78, p79) -- Line: 496
    if not p78 or #p78._items == 0 then
        return nil;
    end;

    for _, v in ipairs(p78._items) do
        if v.Name == p79 then
            return v;
        end;
    end;

    for _, v in ipairs(p78._items) do
        if v.Properties and v.Properties.Droppable then
            return v;
        end;
    end;

    return p78._items[1];
end;

local function GetInventoryItemCount(p80, p81) -- Line: 523
    local v82 = 0;

    for _, v in ipairs(p80) do
        for _, v2 in ipairs(v._items) do
            if v2.Name == p81 then
                v82 = v82 + 1;
            end;
        end;
    end;

    return v82;
end;

local function GetPlayerArmorState(p83) -- Line: 539
    -- upvalues: HttpService (copy)
    local u84 = p83:GetAttribute("Armor");

    if typeof(u84) == "string" and u84 ~= "" then
        local success, result = pcall(function() -- Line: 542
            -- upvalues: HttpService (ref), u84 (copy)
            return HttpService:JSONDecode(u84);
        end);

        if success and typeof(result) == "table" then
            return {
                Type = tostring(result.Type or ""),
                Health = tonumber(result.Health) or 0
            };
        end;
    end;

    return {
        Type = "",
        Health = 0
    };
end;

local function ResetTemplateTeammateIndicators(p85) -- Line: 561
    -- upvalues: u10 (copy)
    local Teammates = p85.Teammates;
    Teammates.Visible = false;

    for _, v in ipairs(u10) do
        local v86 = Teammates[v.Name];

        if v86 then
            v86.Visible = false;
        end;
    end;
end;

local function GetCompetitiveTeammateIndicator(p87, p88) -- Line: 574
    -- upvalues: u10 (copy)
    local v89 = p88:GetAttribute("CompetitivePlayerColor");

    if not v89 then
        return nil;
    end;

    local Teammates = p87.Teammates;

    for _, v in ipairs(u10) do
        if v89 == v.Color then
            return Teammates[v.Name];
        end;
    end;

    return nil;
end;

local function ClearCompetitiveTeammateInventoryCache() -- Line: 592
    -- upvalues: u15 (copy), u16 (copy)
    table.clear(u15);
    table.clear(u16);
end;

local function RequestCompetitiveTeammateInventory(u90) -- Line: 599
    -- upvalues: LocalPlayer (copy), Players (copy), u16 (copy), Remotes (copy)
    if u90 == LocalPlayer or not u90:IsDescendantOf(Players) then
        return;
    end;

    if u16[u90] then
        return;
    end;

    local v91 = LocalPlayer:GetAttribute("Team");

    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" or u90:GetAttribute("Team") ~= v91 then
        return;
    end;

    u16[u90] = true;
    Remotes.Inventory.RequestSpectatedPlayerInventory.Send(u90);
    task.delay(0.15, function() -- Line: 615
        -- upvalues: u16 (ref), u90 (copy)
        u16[u90] = nil;
    end);
end;

local function RequestCompetitiveTeammateInventories() -- Line: 622
    -- upvalues: LocalPlayer (copy), Players (copy), RequestCompetitiveTeammateInventory (copy)
    if workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return;
    end;

    local v92 = LocalPlayer:GetAttribute("Team");

    if not v92 or v92 ~= "Counter-Terrorists" and v92 ~= "Terrorists" then
        return;
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v:GetAttribute("Team") == v92 then
            RequestCompetitiveTeammateInventory(v);
        end;
    end;
end;

local function PlayerHasTemplateItem(p93, p94, p95) -- Line: 641
    -- upvalues: LocalPlayer (copy), IsEquipmentOwned (copy), GetPlayerArmorState (copy), InventoryController (copy), u15 (copy)
    if not p95 then
        local v96;

        if p93 == LocalPlayer then
            v96 = InventoryController.getCurrentInventory();
        else
            v96 = u15[p93];
        end;

        if not v96 then
            return false;
        end;

        for _, v in ipairs(v96) do
            for _, v2 in ipairs(v._items) do
                if v2.Name == p94 then
                    return true;
                end;
            end;
        end;

        return false;
    end;

    if p93 == LocalPlayer then
        return IsEquipmentOwned(p94);
    end;

    if p94 == "Defuse Kit" then
        return p93:GetAttribute("HasDefuseKit") == true;
    end;

    if p94 == "Rescue Kit" then
        return p93:GetAttribute("HasRescueKit") == true;
    end;

    local v97 = GetPlayerArmorState(p93);

    if p94 == "Kevlar" then
        local v98;

        if v97.Type == "Kevlar" then
            v98 = v97.Health > 0;
        else
            v98 = false;
        end;

        return v98;
    end;

    if p94 ~= "Kevlar + Helmet" then
        return false;
    end;

    local v99;

    if v97.Type == "Kevlar + Helmet" then
        v99 = v97.Health > 0;
    else
        v99 = false;
    end;

    return v99;
end;

local function UpdateTemplateTeammateIndicators(p100) -- Line: 683
    -- upvalues: u10 (copy), LocalPlayer (copy), Players (copy), u15 (copy), RequestCompetitiveTeammateInventory (copy), PlayerHasTemplateItem (copy), GetCompetitiveTeammateIndicator (copy)
    local Teammates = p100.Teammates;
    Teammates.Visible = false;

    for _, v in ipairs(u10) do
        local v101 = Teammates[v.Name];

        if v101 then
            v101.Visible = false;
        end;
    end;

    if not p100.Visible or workspace:GetAttribute("ServerGamemode") ~= "Competitive" then
        return;
    end;

    local v102 = LocalPlayer:GetAttribute("Team");

    if not v102 or v102 ~= "Counter-Terrorists" and v102 ~= "Terrorists" then
        return;
    end;

    local v103 = p100:GetAttribute("Weapon");

    if not v103 then
        return;
    end;

    local v104 = p100:GetAttribute("IsEquipment") == true;
    local v105 = false;

    for _, v in ipairs(Players:GetPlayers()) do
        if v:GetAttribute("Team") == v102 then
            if v ~= LocalPlayer and not (v104 or u15[v]) then
                RequestCompetitiveTeammateInventory(v);
            end;

            if PlayerHasTemplateItem(v, v103, v104) then
                local v106 = GetCompetitiveTeammateIndicator(p100, v);

                if v106 then
                    v106.Visible = true;
                    v105 = true;
                end;
            end;
        end;
    end;

    p100.Teammates.Visible = v105;
end;

local function UpdateAllTeammateIndicators() -- Line: 724
    -- upvalues: Profiler (copy), u6 (ref), UpdateTemplateTeammateIndicators (copy)
    Profiler.mark("UI.BuyMenu.UpdateAllTeammateIndicators");

    if not u6 then
        return;
    end;

    for _, descendant in ipairs(u6.Menu.Container:GetDescendants()) do
        if descendant:IsA("TextButton") then
            UpdateTemplateTeammateIndicators(descendant);
        end;
    end;
end;

local function CanCarryDuplicate(p107, p108) -- Line: 739
    -- upvalues: GetInventoryItemCount (copy), Grenades (copy)
    local v109 = GetInventoryItemCount(p107, p108);
    local v110 = Grenades[p108];

    if v110 then
        return v109 < v110;
    end;

    return v109 == 0;
end;

local function GetRoundPurchaseLimit(p111) -- Line: 752
    -- upvalues: Grenades (copy)
    local v112 = Grenades[p111];

    if not v112 then
        if p111 == "Zeus x27" then
            return 1;
        end;

        v112 = nil;
    end;

    return v112;
end;

local function WaitForAttribute(p113, p114) -- Line: 758
    local v115 = p113:GetAttribute(p114);

    while not v115 do
        v115 = p113:GetAttribute(p114);
        task.wait();
    end;

    return v115;
end;

local function UpdateBuyMenuTimerText() -- Line: 771
    -- upvalues: GameState (copy), u6 (ref), GetTimerFormat (copy)
    local v116 = 0;
    local v117 = GameState.GetState();

    if v117 == "Buy Period" or v117 == "Round In Progress" then
        local v118 = workspace:GetAttribute("BuyTimerRemaining");

        if typeof(v118) == "number" then
            local v119 = math.floor(v118);
            v116 = math.max(0, v119);
        else
            local v120 = workspace:GetAttribute("Timer");

            if typeof(v120) == "number" then
                local v121 = math.floor(v120);
                v116 = math.max(0, v121);
            end;
        end;
    else
        local v122 = workspace:GetAttribute("Timer");

        if typeof(v122) == "number" then
            local v123 = math.floor(v122);
            v116 = math.max(0, v123);
        end;
    end;

    u6.Menu.TopFrame.Timer.Text = GetTimerFormat(v116);
end;

function u1.purchase(p124, p125, p126) -- Line: 798
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), GetDisplayCost (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), IsInBuyArea (copy), GameState (copy), Grenades (copy), InventoryController (copy), GetInventoryItemCount (copy), NumberSlots (copy), GetInventoryItemToReplace (copy), u5 (copy), Router (copy), Remotes (copy)
    local v127 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p124) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(p124);
    local v128;

    if v127 then
        v128 = require(v127);
    else
        v128 = nil;
    end;

    if not v128 then
        return;
    end;

    local v129 = LocalPlayer:GetAttribute("Money");
    local v130 = GetDisplayCost(p124, v128);
    local v131 = workspace:GetAttribute("Gamemode");

    if p126 and IsEquipmentPurchaseBlockedForLocalPlayer(p124) then
        return;
    end;

    if not IsInBuyArea(LocalPlayer) then
        return;
    end;

    local v132 = (v131 == "Deathmatch" or GameState.GetState() == "Warmup") and 0 or v130;
    local v133 = not p126 and Grenades[p124] ~= nil;
    local v134;

    if p126 then
        v134 = nil;
    else
        v134 = Grenades[p124] or (p124 == "Zeus x27" and 1 or nil) or nil;
    end;

    if v134 then
        local v135 = InventoryController.getCurrentInventory();

        if v135 and v134 <= GetInventoryItemCount(v135, p124) then
            return;
        end;
    end;

    local v136 = v133 and InventoryController.getCurrentInventory();

    if v136 then
        local v137 = v136[NumberSlots.Grenade];

        if v137 and #v137._items >= v137._settings._strict_slot_space then
            return;
        end;
    end;

    if not p126 and (LocalPlayer:GetAttribute("BuyMenu") and (v131 == "Hostage Rescue" or v131 == "Bomb Defusal")) then
        local v138 = InventoryController.getCurrentInventory();
        local v139 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p124) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(p124);
        local v140;

        if v139 then
            v140 = require(v139);
        else
            v140 = nil;
        end;

        local v141 = NumberSlots[v140.Slot];

        if v138 and v140 then
            local v142 = v138[v141];

            if v142 and #v142._items > 0 then
                local v143 = GetInventoryItemToReplace(v142, p124);

                if v143 and table.find(u5, v143.Identifier) then
                    local Name = v143.Name;
                    local v144 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name);
                    local v145;

                    if v144 then
                        v145 = require(v144);
                    else
                        v145 = nil;
                    end;

                    if v145 then
                        v132 = v130 - (tonumber(v145.Cost) or 0);
                    end;
                end;
            end;
        end;
    end;

    if v129 and v132 <= v129 then
        Router.broadcastRouter("RunInterfaceSound", "Successful Buy Menu Purchase");
        Remotes.Inventory.BuyMenuPurchase.Send({
            Equipment = p126,
            Name = p124,
            Path = p125 or ""
        });
    end;
end;

function u1.createTemplate(u146, p147, u148, u149) -- Line: 893
    -- upvalues: Profiler (copy), LocalPlayer (copy), ReplicatedStorage (copy), GetDisplayCost (copy), u10 (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), GetPreferenceColor (copy), InventoryController (copy), IsEquipmentOwned (copy), GetInventoryItemCount (copy), Grenades (copy), GameState (copy), u2 (copy), Router (copy), QueryInventoryItem (copy), TweenService (copy), ShowWeaponInfoFrame (copy), u6 (ref), u1 (copy), IsInBuyArea (copy), Remotes (copy), QueryInventoryItemPurchasedThisRound (copy), UpdateTemplateTeammateIndicators (copy)
    Profiler.mark("UI.BuyMenu.CreateTemplate");
    local u150 = p147.Name == "Molotov" and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" and {
        Name = "Incendiary Grenade",
        _id = p147._id
    } or p147;
    local Name = u150.Name;
    local v151 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(Name) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(Name);
    local v152;

    if v151 then
        v152 = require(v151);
    else
        v152 = nil;
    end;

    if not v152 then
        u146.Visible = false;

        return;
    end;

    local v153 = workspace:GetAttribute("Gamemode");
    local v154 = GetDisplayCost(u150.Name, v152);
    u146.Icon.Image = v152.ReverseIcon or v152.Icon;
    u146.Cost.Text = "$" .. tostring(v154):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    local Keybind = u146.Keybind;
    local v155 = tonumber(u146.Name);
    Keybind.Text = tostring(v155);
    u146.Cost.Visible = v153 ~= "Deathmatch";
    u146.LayoutOrder = tonumber(u146.Name);
    u146.ItemName.Text = u150.Name:find("Zeus") and "Taser" or u150.Name;
    local Teammates = u146.Teammates;
    Teammates.Visible = false;

    for _, v in ipairs(u10) do
        local v156 = Teammates[v.Name];

        if v156 then
            v156.Visible = false;
        end;
    end;

    u146.Visible = true;
    local v157 = tonumber(LocalPlayer:GetAttribute("Money")) or 0;
    local v158;

    if u148 then
        v158 = IsEquipmentPurchaseBlockedForLocalPlayer(u150.Name);
    else
        v158 = u148;
    end;

    local v159 = (v157 < v154 or v158) and Color3.fromRGB(149, 149, 149) or GetPreferenceColor();
    u146.ItemName.TextColor3 = v159;
    u146.Keybind.TextColor3 = v159;
    u146.Icon.ImageColor3 = v159;
    u146.Cost.TextColor3 = v159;
    u146:SetAttribute("Weapon", u150.Name);
    u146:SetAttribute("IsEquipment", u148);
    u146:SetAttribute("InventoryItemId", u150._id);
    local v160 = InventoryController.getCurrentInventory();
    local v161 = false;
    local v162 = false;

    if u148 then
        v161 = IsEquipmentOwned(u150.Name);
    elseif v160 then
        v161 = GetInventoryItemCount(v160, u150.Name) > 0;
        local Name2 = u150.Name;
        local v163 = GetInventoryItemCount(v160, Name2);
        local v164 = Grenades[Name2];

        if v164 then
            v162 = v163 < v164;
        elseif v163 == 0 then
            v162 = true;
        else
            v162 = false;
        end;
    end;

    local Return = u146.Return;
    local v165;

    if v161 then
        if GameState.GetState() == "Warmup" or v153 == "Deathmatch" then
            v165 = false;
        elseif u148 then
            v165 = u148;
        else
            local v166;

            if u146.Parent.Name == "Pistols" then
                v166 = u146.Name == "1";
            else
                v166 = false;
            end;

            v165 = not v166;
        end;
    else
        v165 = v161;
    end;

    Return.Visible = v165;
    u146.Hover.Visible = v161;
    u146.Hover.UIStroke.Transparency = v161 and not v162 and 0 or 1;
    u2:Add(u146.MouseEnter:Connect(function() -- Line: 967
        -- upvalues: InventoryController (ref), Router (ref), u148 (copy), IsEquipmentOwned (ref), u150 (ref), QueryInventoryItem (ref), u146 (copy), TweenService (ref), ShowWeaponInfoFrame (ref)
        local v167 = InventoryController.getCurrentInventory();
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        local v168 = u148 and IsEquipmentOwned(u150.Name);

        if v168 then
            v167 = v168;
        elseif v167 then
            v167 = QueryInventoryItem(v167, u150.Name);
        end;

        if not v167 then
            u146.Hover.UIStroke.Transparency = 1;
            u146.Hover.Visible = true;
            TweenService:Create(u146.Hover.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 0.8
            }):Play();
        end;

        TweenService:Create(u146.Icon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(0.7, 0.7)
        }):Play();
        ShowWeaponInfoFrame(u146);
    end));
    u2:Add(u146.MouseLeave:Connect(function() -- Line: 997
        -- upvalues: InventoryController (ref), u148 (copy), IsEquipmentOwned (ref), u150 (ref), QueryInventoryItem (ref), u146 (copy), TweenService (ref), u6 (ref)
        local v169 = InventoryController.getCurrentInventory();
        local v170 = u148 and IsEquipmentOwned(u150.Name);

        if v170 then
            v169 = v170;
        elseif v169 then
            v169 = QueryInventoryItem(v169, u150.Name);
        end;

        if not v169 then
            u146.Hover.UIStroke.Transparency = 1;
            u146.Hover.Visible = false;
        end;

        TweenService:Create(u146.Icon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(0.75, 0.75)
        }):Play();

        if u6 and u6.WeaponInfoFrame then
            u6.WeaponInfoFrame.Visible = false;
        end;
    end));
    u2:Add(u146.MouseButton1Down:Connect(function() -- Line: 1018
        -- upvalues: TweenService (ref), u146 (copy)
        TweenService:Create(u146.Icon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(0.65, 0.65)
        }):Play();
    end));
    u2:Add(u146.MouseButton1Up:Connect(function() -- Line: 1025
        -- upvalues: TweenService (ref), u146 (copy)
        TweenService:Create(u146.Icon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(0.7, 0.7)
        }):Play();
    end));
    u2:Add(u146.MouseButton1Click:Connect(function() -- Line: 1032
        -- upvalues: u1 (ref), u150 (ref), u149 (copy), u148 (copy)
        u1.purchase(u150.Name, u149, u148);
    end));
    u2:Add(u146.Return.MouseButton1Click:Connect(function() -- Line: 1037
        -- upvalues: u148 (copy), IsInBuyArea (ref), LocalPlayer (ref), Remotes (ref), u150 (ref), InventoryController (ref), QueryInventoryItemPurchasedThisRound (ref)
        if u148 then
            if IsInBuyArea(LocalPlayer) then
                Remotes.Inventory.ReturnBuyMenuPurchase.Send({
                    Equipment = true,
                    Identifier = u150.Name
                });
            end;

            return;
        end;

        local v171 = InventoryController.getCurrentInventory();

        if not v171 then
            return;
        end;

        local v172 = QueryInventoryItemPurchasedThisRound(v171, u150.Name);

        if v172 and IsInBuyArea(LocalPlayer) then
            Remotes.Inventory.ReturnBuyMenuPurchase.Send({
                Equipment = false,
                Identifier = v172.Identifier
            });
        end;
    end));
    UpdateTemplateTeammateIndicators(u146);
end;

function u1.setupTemplate(p173, p174) -- Line: 1070
    -- upvalues: Router (copy), LocalPlayer (copy), u1 (copy)
    local v175 = Router.broadcastRouter("GetEquippedInventoryItem", LocalPlayer, p174);

    if v175 and v175.Name then
        u1.createTemplate(p173, v175, false, p174);

        return;
    end;

    p173:SetAttribute("IsEquipment", nil);
    p173:SetAttribute("Weapon", nil);
    p173.Visible = false;
end;

function u1.updateBuyMenuTemplate(p176, p177) -- Line: 1087
    -- upvalues: Profiler (copy), u10 (copy), ReplicatedStorage (copy), GetDisplayCost (copy), LocalPlayer (copy), IsEquipmentPurchaseBlockedForLocalPlayer (copy), GetPreferenceColor (copy), IsEquipmentOwned (copy), GetInventoryItemCount (copy), Grenades (copy), GameState (copy), TweenService (copy), UpdateTemplateTeammateIndicators (copy)
    Profiler.mark("UI.BuyMenu.UpdateBuyMenuTemplate");
    local v178 = p177:GetAttribute("IsEquipment");
    local v179 = p177:GetAttribute("Weapon");

    if not v179 then
        local Teammates = p177.Teammates;
        Teammates.Visible = false;

        for _, v in ipairs(u10) do
            local v180 = Teammates[v.Name];

            if v180 then
                v180.Visible = false;
            end;
        end;

        return;
    end;

    local v181 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(v179) or ReplicatedStorage.Database.Custom.GameStats.Equipment:FindFirstChild(v179);
    local v182;

    if v181 then
        v182 = require(v181);
    else
        v182 = nil;
    end;

    if v182 then
        local v183 = GetDisplayCost(v179, v182);
        p177.Cost.Text = "$" .. tostring(v183):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        local v184 = LocalPlayer:GetAttribute("Money");
        local v185;

        if v178 then
            v185 = IsEquipmentPurchaseBlockedForLocalPlayer(v179);
        else
            v185 = v178;
        end;

        if v184 then
            local v186 = (v184 < v183 or v185) and Color3.fromRGB(149, 149, 149) or GetPreferenceColor();
            p177.ItemName.TextColor3 = v186;
            p177.Keybind.TextColor3 = v186;
            p177.Icon.ImageColor3 = v186;
            p177.Cost.TextColor3 = v186;
        end;
    end;

    if p177.Visible then
        local v187 = false;
        local v188 = false;

        if v178 then
            v187 = IsEquipmentOwned(v179);
        elseif p176 then
            v187 = GetInventoryItemCount(p176, v179) > 0;
            local v189 = GetInventoryItemCount(p176, v179);
            local v190 = Grenades[v179];

            if v190 then
                v188 = v189 < v190;
            elseif v189 == 0 then
                v188 = true;
            else
                v188 = false;
            end;
        end;

        local v191 = workspace:GetAttribute("Gamemode");
        local Return = p177.Return;

        if v187 then
            if v191 == "Deathmatch" or GameState.GetState() == "Warmup" then
                v178 = false;
            elseif not v178 then
                local v192;

                if p177.Parent.Name == "Pistols" then
                    v192 = p177.Name == "1";
                else
                    v192 = false;
                end;

                v178 = not v192;
            end;
        else
            v178 = v187;
        end;

        Return.Visible = v178;
        p177.Hover.Visible = v187;

        if not v187 then
            p177.Hover.UIStroke.Transparency = 1;
            UpdateTemplateTeammateIndicators(p177);

            return;
        end;

        TweenService:Create(p177.Hover.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = v188 and 1 or 0
        }):Play();
    end;

    UpdateTemplateTeammateIndicators(p177);
end;

local function getDroppedCategory(p193) -- Line: 1171
    local Slot = p193.Slot;

    if Slot == "Grenade" then
        return "Grenades";
    end;

    if Slot == "Secondary" then
        return "Pistols";
    end;

    if Slot ~= "Primary" then
        return nil;
    end;

    local Type = p193.Type;

    return (Type == "SMG" or Type == "Heavy") and "Mid Tier" or "Rifles";
end;

local function getCategoryTemplateCount(p194) -- Line: 1189
    local v195 = 0;

    for _, child in ipairs(p194:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Template" then
            v195 = v195 + 1;
        end;
    end;

    return v195;
end;

local function setDroppedTemplatePickedUp(p196, p197) -- Line: 1199
    local ImageLabel = p196:FindFirstChild("ImageLabel");
    local TextLabel = p196:FindFirstChild("TextLabel");

    if p197 then
        p196:SetAttribute("_OrigBG", p196.BackgroundColor3);
        p196.BackgroundColor3 = Color3.fromRGB(15, 15, 15);

        if ImageLabel then
            ImageLabel:SetAttribute("_OrigColor", ImageLabel.ImageColor3);
            ImageLabel:SetAttribute("_OrigTrans", ImageLabel.ImageTransparency);
            ImageLabel.ImageColor3 = Color3.new(1, 1, 1);
            ImageLabel.ImageTransparency = 0.6;
        end;

        if TextLabel then
            TextLabel:SetAttribute("_OrigColor", TextLabel.TextColor3);
            TextLabel:SetAttribute("_OrigTrans", TextLabel.TextTransparency);
            TextLabel.TextColor3 = Color3.new(1, 1, 1);
            TextLabel.TextTransparency = 0.8;
        end;
    else
        local v198 = p196:GetAttribute("_OrigBG");

        if v198 then
            p196.BackgroundColor3 = v198;
        end;

        if ImageLabel then
            local v199 = ImageLabel:GetAttribute("_OrigColor");
            local v200 = ImageLabel:GetAttribute("_OrigTrans");

            if v199 then
                ImageLabel.ImageColor3 = v199;
            end;

            if v200 ~= nil then
                ImageLabel.ImageTransparency = v200;
            end;
        end;

        if TextLabel then
            local v201 = TextLabel:GetAttribute("_OrigColor");
            local v202 = TextLabel:GetAttribute("_OrigTrans");

            if v201 then
                TextLabel.TextColor3 = v201;
            end;

            if v202 ~= nil then
                TextLabel.TextTransparency = v202;
            end;
        end;
    end;
end;

local function isWithinPickupRange(p203) -- Line: 1245
    -- upvalues: LocalPlayer (copy)
    local v204 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if p203 then
        p203 = p203.PrimaryPart;
    end;

    if v204 and p203 then
        return (v204.Position - p203.Position).Magnitude <= 45;
    end;

    return false;
end;

local function getSlotNumberForCategory(p205) -- Line: 1254
    return p205 == "Pistols" and 2 or ((p205 == "Mid Tier" or p205 == "Rifles") and 1 or (p205 == "Grenades" and 4 or nil));
end;

local function tryPickupDroppedWeapon(p206, p207) -- Line: 1267
    -- upvalues: LocalPlayer (copy), InventoryController (copy), Grenades (copy), GetWeaponProperties (copy), NumberSlots (copy), Remotes (copy), GetCharacterVelocity (copy), u14 (ref)
    local v208 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
    local v209;

    if p206 then
        v209 = p206.PrimaryPart;
    else
        v209 = p206;
    end;

    local v210;

    if v208 and v209 then
        v210 = (v208.Position - v209.Position).Magnitude <= 45;
    else
        v210 = false;
    end;

    if not v210 then
        return;
    end;

    if not p206:GetAttribute("CanPickup") then
        return;
    end;

    local v211 = p207 == "Pistols" and 2 or ((p207 == "Mid Tier" or p207 == "Rifles") and 1 or (p207 == "Grenades" and 4 or nil));

    if not v211 then
        return;
    end;

    local v212 = InventoryController.getCurrentInventory();

    if not v212 then
        return;
    end;

    local v213 = v212[v211];

    if not v213 then
        return;
    end;

    if p207 == "Grenades" then
        local v214 = p206:GetAttribute("Weapon");

        if #v213._items >= v213._settings._strict_slot_space then
            return;
        end;

        if Grenades[v214] then
            local v215 = 0;

            for _, v in ipairs(v213._items) do
                if v.Name == v214 then
                    v215 = v215 + 1;
                end;
            end;

            if Grenades[v214] <= v215 then
                return;
            end;
        end;
    elseif #v213._items >= v213._settings._strict_slot_space then
        local v216 = InventoryController.getCurrentEquipped();
        local v217 = false;

        if v216 then
            local v218 = GetWeaponProperties(v216.Name);

            if v218 and (NumberSlots[v218.Slot] == v211 and v216.drop) then
                v216:drop();
                v217 = true;
            end;
        end;

        if not v217 then
            local v219 = v213._items[1];

            if not (v219 and (v219.Properties and v219.Properties.Droppable)) then
                return;
            end;

            if v216 and v216.Identifier == v219.Identifier then
                v216:unequip();
            end;

            Remotes.Inventory.DropWeapon.Send({
                CharacterVelocity = GetCharacterVelocity(LocalPlayer.Character),
                Direction = workspace.CurrentCamera.CFrame.LookVector,
                Identifier = v219.Identifier
            });
        end;
    end;

    if p207 ~= "Grenades" then
        u14 = v211;
    end;

    Remotes.Inventory.PickupWeapon.Send({
        AllowAutoEquip = true,
        Identity = p206.Name
    });
end;

local function getDroppedKey(p220, p221) -- Line: 1348
    return p220 .. "::" .. p221;
end;

local function findClosestModelInEntry(p222) -- Line: 1352
    -- upvalues: LocalPlayer (copy)
    local v223 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if not v223 then
        return nil;
    end;

    local v224 = (1 / 0);
    local v225 = nil;

    for i in pairs(p222.models) do
        if i and (i.Parent and (i.PrimaryPart and i:GetAttribute("CanPickup"))) then
            local Magnitude = (v223.Position - i.PrimaryPart.Position).Magnitude;

            if Magnitude <= 45 and Magnitude < v224 then
                v225 = i;
                v224 = Magnitude;
            end;
        end;
    end;

    return v225;
end;

local function hasAnyModelInRange(p226) -- Line: 1371
    -- upvalues: LocalPlayer (copy)
    local v227 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if not v227 then
        return false;
    end;

    for i in pairs(p226.models) do
        if i and (i.Parent and (i.PrimaryPart and (v227.Position - i.PrimaryPart.Position).Magnitude <= 45)) then
            return true;
        end;
    end;

    return false;
end;

local function updateDroppedTemplateRangeStates() -- Line: 1386
    -- upvalues: Profiler (copy), u12 (copy), hasAnyModelInRange (copy), setDroppedTemplatePickedUp (copy)
    Profiler.mark("UI.BuyMenu.UpdateDroppedTemplateRangeStates");

    for _, v in pairs(u12) do
        if next(v.models) then
            local v228 = hasAnyModelInRange(v);
            local v229 = v.template:GetAttribute("_OutOfRange");

            if v228 or v229 then
                if v228 and v229 then
                    v.template:SetAttribute("_OutOfRange", nil);
                    local template = v.template;
                    local ImageLabel = template:FindFirstChild("ImageLabel");
                    local TextLabel = template:FindFirstChild("TextLabel");
                    local v230 = template:GetAttribute("_OrigBG");

                    if v230 then
                        template.BackgroundColor3 = v230;
                    end;

                    if ImageLabel then
                        local v231 = ImageLabel:GetAttribute("_OrigColor");
                        local v232 = ImageLabel:GetAttribute("_OrigTrans");

                        if v231 then
                            ImageLabel.ImageColor3 = v231;
                        end;

                        if v232 ~= nil then
                            ImageLabel.ImageTransparency = v232;
                        end;
                    end;

                    if TextLabel then
                        local v233 = TextLabel:GetAttribute("_OrigColor");
                        local v234 = TextLabel:GetAttribute("_OrigTrans");

                        if v233 then
                            TextLabel.TextColor3 = v233;
                        end;

                        if v234 ~= nil then
                            TextLabel.TextTransparency = v234;
                        end;
                    end;
                end;
            else
                v.template:SetAttribute("_OutOfRange", true);
                setDroppedTemplatePickedUp(v.template, true);
            end;
        end;
    end;
end;

local function getModelCount(p235) -- Line: 1404
    local v236 = 0;

    for _ in pairs(p235) do
        v236 = v236 + 1;
    end;

    return v236;
end;

local function updateDroppedTemplateLabel(p237) -- Line: 1412
    local TextLabel = p237.template:FindFirstChild("TextLabel");

    if not TextLabel then
        return;
    end;

    local v238 = 0;

    for _ in pairs(p237.models) do
        v238 = v238 + 1;
    end;

    if v238 > 1 then
        TextLabel.Text = `x{v238} {p237.weaponName}`;

        return;
    end;

    TextLabel.Text = p237.weaponName;
end;

local function onWeaponDropped(p239) -- Line: 1425
    -- upvalues: LocalPlayer (copy), GetWeaponProperties (copy), u12 (copy), u13 (copy), u6 (ref), getCategoryTemplateCount (copy), GetPreferenceColor (copy), findClosestModelInEntry (copy), Router (copy), tryPickupDroppedWeapon (copy), u11 (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return;
    end;

    local v240 = p239:GetAttribute("Weapon");

    if not v240 then
        return;
    end;

    if p239:GetAttribute("DroppedByTeam") ~= LocalPlayer:GetAttribute("Team") then
        return;
    end;

    local v241 = GetWeaponProperties(v240);

    if not v241 then
        return;
    end;

    local Slot = v241.Slot;
    local u242;

    if Slot == "Grenade" then
        u242 = "Grenades";
    elseif Slot == "Secondary" then
        u242 = "Pistols";
    elseif Slot == "Primary" then
        local Type = v241.Type;
        u242 = (Type == "SMG" or Type == "Heavy") and "Mid Tier" or "Rifles";
    else
        u242 = nil;
    end;

    if not u242 then
        return;
    end;

    local v243 = u242 .. "::" .. v240;
    local v244 = u12[v243];

    if v244 then
        v244.models[p239] = true;
        u13[p239] = v243;
        v244.template:SetAttribute("_OutOfRange", nil);
        local template = v244.template;
        local ImageLabel = template:FindFirstChild("ImageLabel");
        local TextLabel = template:FindFirstChild("TextLabel");
        local v245 = template:GetAttribute("_OrigBG");

        if v245 then
            template.BackgroundColor3 = v245;
        end;

        if ImageLabel then
            local v246 = ImageLabel:GetAttribute("_OrigColor");
            local v247 = ImageLabel:GetAttribute("_OrigTrans");

            if v246 then
                ImageLabel.ImageColor3 = v246;
            end;

            if v247 ~= nil then
                ImageLabel.ImageTransparency = v247;
            end;
        end;

        if TextLabel then
            local v248 = TextLabel:GetAttribute("_OrigColor");
            local v249 = TextLabel:GetAttribute("_OrigTrans");

            if v248 then
                TextLabel.TextColor3 = v248;
            end;

            if v249 ~= nil then
                TextLabel.TextTransparency = v249;
            end;
        end;

        local TextLabel2 = v244.template:FindFirstChild("TextLabel");

        if TextLabel2 then
            local v250 = 0;

            for _ in pairs(v244.models) do
                v250 = v250 + 1;
            end;

            if v250 > 1 then
                TextLabel2.Text = `x{v250} {v244.weaponName}`;
            else
                TextLabel2.Text = v244.weaponName;
            end;
        end;

        local ImageButton = v244.template:FindFirstChild("ImageButton");

        if ImageButton then
            ImageButton.Active = true;
        end;

        return;
    end;

    local Dropped = u6.Menu:FindFirstChild("Dropped");

    if not Dropped then
        return;
    end;

    local Container = Dropped:FindFirstChild("Container");

    if not Container then
        return;
    end;

    local v251 = Container:FindFirstChild(u242);

    if not v251 then
        return;
    end;

    if getCategoryTemplateCount(v251) >= 4 then
        return;
    end;

    local Template = Container:FindFirstChild("Template");

    if not Template then
        return;
    end;

    local v252 = Template:Clone();
    v252.Name = v243;
    v252.Visible = true;
    v252.Parent = v251;
    local v253 = v241.ReverseIcon or v241.Icon;
    local ImageLabel = v252:FindFirstChild("ImageLabel");
    local TextLabel = v252:FindFirstChild("TextLabel");
    local ImageButton = v252:FindFirstChild("ImageButton");

    if ImageLabel then
        ImageLabel.Image = v253;
        ImageLabel.ImageColor3 = GetPreferenceColor();
    end;

    if TextLabel then
        TextLabel.Text = v240;
        TextLabel.TextColor3 = GetPreferenceColor();
    end;

    local u254 = {
        template = v252,
        category = u242,
        weaponName = v240,
        models = {
            [p239] = true
        }
    };
    u12[v243] = u254;
    u13[p239] = v243;

    if ImageButton then
        u11:Add((ImageButton.MouseButton1Click:Connect(function() -- Line: 1521
            -- upvalues: findClosestModelInEntry (ref), u254 (copy), Router (ref), tryPickupDroppedWeapon (ref), u242 (copy)
            local v255 = findClosestModelInEntry(u254);

            if v255 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                tryPickupDroppedWeapon(v255, u242);
            end;
        end)));
    end;
end;

local function onWeaponDropRemoved(p256) -- Line: 1532
    -- upvalues: u13 (copy), u12 (copy), setDroppedTemplatePickedUp (copy)
    local v257 = u13[p256];

    if not v257 then
        return;
    end;

    u13[p256] = nil;
    local v258 = u12[v257];

    if not v258 then
        return;
    end;

    v258.models[p256] = nil;

    if next(v258.models) then
        local TextLabel = v258.template:FindFirstChild("TextLabel");

        if not TextLabel then
            return;
        end;

        local v259 = 0;

        for _ in pairs(v258.models) do
            v259 = v259 + 1;
        end;

        if v259 > 1 then
            TextLabel.Text = `x{v259} {v258.weaponName}`;

            return;
        end;

        TextLabel.Text = v258.weaponName;
    else
        v258.template:SetAttribute("_OutOfRange", nil);
        setDroppedTemplatePickedUp(v258.template, true);
        local ImageButton = v258.template:FindFirstChild("ImageButton");

        if ImageButton then
            ImageButton.Active = false;
        end;
    end;
end;

local function updateDroppedFrameVisibility() -- Line: 1558
    -- upvalues: u6 (ref)
    local v260 = u6 and u6.Menu and u6.Menu:FindFirstChild("Dropped");

    if not v260 then
        return;
    end;

    v260.Visible = workspace:GetAttribute("Gamemode") ~= "Deathmatch";
end;

local function cleanupAllDroppedEntries() -- Line: 1567
    -- upvalues: u12 (copy), u13 (copy), u11 (copy), u6 (ref)
    for _, v in pairs(u12) do
        v.template:Destroy();
    end;

    table.clear(u12);
    table.clear(u13);
    u11:Cleanup();
    local v261 = u6 and u6.Menu and u6.Menu:FindFirstChild("Dropped");

    if not v261 then
        return;
    end;

    local Container = v261:FindFirstChild("Container");

    if not Container then
        return;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Template" then
            for _, child2 in ipairs(child:GetChildren()) do
                if child2:IsA("Frame") then
                    child2:Destroy();
                end;
            end;
        end;
    end;
end;

local function updateBuyMenuHeartbeat(p262) -- Line: 1596
    -- upvalues: Profiler (copy), u4 (copy), u6 (ref), GetPreferenceColor (copy), IsInBuyArea (copy), LocalPlayer (copy), u1 (copy), updateDroppedTemplateRangeStates (copy)
    Profiler.mark("UI.BuyMenu.Heartbeat");
    local v263 = u4:getPosition();
    local v264 = math.round(v263);
    local v265 = tostring(v264):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    u6.Menu.TopFrame.Money.TextColor3 = GetPreferenceColor();
    u6.Menu.TopFrame.Money.Text = "$" .. v265;
    u4:update(p262);

    if u6.Visible and not IsInBuyArea(LocalPlayer) then
        local v266 = workspace:GetAttribute("Gamemode");

        if v266 == "Bomb Defusal" or v266 == "Hostage Rescue" then
            u1.closeFrame();

            return;
        end;
    end;

    updateDroppedTemplateRangeStates();
end;

local function startBuyMenuUpdate() -- Line: 1617
    -- upvalues: u17 (ref), RunServiceController (copy), updateBuyMenuHeartbeat (copy)
    if u17 then
        return;
    end;

    u17 = RunServiceController.BindToHeartbeat("UI.BuyMenu.Update", updateBuyMenuHeartbeat);
    updateBuyMenuHeartbeat(0);
end;

local function stopBuyMenuUpdate() -- Line: 1628
    -- upvalues: u17 (ref)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;
end;

function u1.openFrame() -- Line: 1637
    -- upvalues: Profiler (copy), EndScreenController (copy), LocalPlayer (copy), IsInBuyArea (copy), u6 (ref), CameraController (copy), u7 (ref), u17 (ref), RunServiceController (copy), updateBuyMenuHeartbeat (copy), RequestCompetitiveTeammateInventories (copy), UpdateAllTeammateIndicators (copy)
    Profiler.mark("UI.BuyMenu.OpenFrame");

    if EndScreenController.IsActive() then
        return;
    end;

    local v267 = LocalPlayer:GetAttribute("BuyMenu");

    if not IsInBuyArea(LocalPlayer) then
        return;
    end;

    if not v267 or u6.Visible then
        return;
    end;

    CameraController.setForceLockOverride("BuyMenu", true);
    CameraController.setPerspective(true, true);
    u7.Gameplay.Bottom.Health.Visible = false;
    u7.Gameplay.Bottom.Middle.Visible = false;
    u7.Gameplay.Bottom.Armor.Visible = false;
    u7.Gameplay.Bottom.Money.Visible = false;
    u7.Gameplay.Bottom.Ammo.Visible = false;
    u6.Visible = true;

    if not u17 then
        u17 = RunServiceController.BindToHeartbeat("UI.BuyMenu.Update", updateBuyMenuHeartbeat);
        updateBuyMenuHeartbeat(0);
    end;

    if u6 and u6.WeaponInfoFrame then
        u6.WeaponInfoFrame.Visible = false;
    end;

    RequestCompetitiveTeammateInventories();
    UpdateAllTeammateIndicators();
end;

function u1.closeFrame() -- Line: 1670
    -- upvalues: Profiler (copy), u6 (ref), CameraController (copy), u7 (ref), GetLocalPlayerArmorState (copy), u17 (ref)
    Profiler.mark("UI.BuyMenu.CloseFrame");

    if not u6.Visible then
        return;
    end;

    CameraController.setForceLockOverride("BuyMenu", false);
    CameraController.setPerspective(true, false);
    u7.Gameplay.Bottom.Health.Visible = true;
    u7.Gameplay.Bottom.Middle.Visible = true;
    u7.Gameplay.Bottom.Armor.Visible = GetLocalPlayerArmorState().Health > 0;
    u7.Gameplay.Bottom.Money.Visible = true;
    u7.Gameplay.Bottom.Ammo.Visible = true;
    u6.Visible = false;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    if u6 and u6.WeaponInfoFrame then
        u6.WeaponInfoFrame.Visible = false;
    end;
end;

function u1.toggleFrame() -- Line: 1692
    -- upvalues: EndScreenController (copy), LocalPlayer (copy), u6 (ref), u1 (copy)
    if EndScreenController.IsActive() then
        return;
    end;

    if LocalPlayer:GetAttribute("BuyMenu") and not u6.Visible then
        u1.openFrame();

        return;
    end;

    if not u6.Visible then
        return;
    end;

    u1.closeFrame();
end;

function u1.characterAdded(p268) -- Line: 1710
    -- upvalues: Profiler (copy), WaitForAttribute (copy), LocalPlayer (copy), u2 (copy), setupBuyMenuTemplates (copy)
    Profiler.mark("UI.BuyMenu.CharacterAdded");

    if not WaitForAttribute(LocalPlayer, "Money") then
        return;
    end;

    u2:Cleanup();
    setupBuyMenuTemplates();
end;

function u1.Initialize(p269, p270) -- Line: 1728
    -- upvalues: Profiler (copy), u7 (ref), u6 (ref), UpdateBuyMenuTimerText (copy), InventoryController (copy), u1 (copy), UpdateAllTeammateIndicators (copy), LocalPlayer (copy), u3 (copy), u15 (copy), RequestCompetitiveTeammateInventory (copy), u16 (copy), Players (copy), Remotes (copy), RequestCompetitiveTeammateInventories (copy), Observers (copy), cleanupAllDroppedEntries (copy), u2 (copy), setupBuyMenuTemplates (copy), u5 (copy), u14 (ref), RemoveFromArray (copy), u4 (copy), GameState (copy), DataController (copy), CollectionService (copy), onWeaponDropped (copy), onWeaponDropRemoved (copy), u12 (copy), GetPreferenceColor (copy)
    Profiler.mark("UI.BuyMenu.Initialize");
    u7 = p269;
    u6 = p270;
    UpdateBuyMenuTimerText();

    if u6 and u6.WeaponInfoFrame then
        u6.WeaponInfoFrame.Visible = false;
    end;

    local function refreshBuyMenuTemplates() -- Line: 1734
        -- upvalues: Profiler (ref), InventoryController (ref), u6 (ref), u1 (ref), UpdateAllTeammateIndicators (ref)
        Profiler.mark("UI.BuyMenu.RefreshTemplates");
        local v271 = InventoryController.getCurrentInventory();

        for _, descendant in ipairs(u6.Menu.Container:GetDescendants()) do
            if descendant:IsA("TextButton") then
                u1.updateBuyMenuTemplate(v271, descendant);
            end;
        end;

        UpdateAllTeammateIndicators();
    end;

    local function trackCompetitiveTeammate(u272) -- Line: 1745
        -- upvalues: LocalPlayer (ref), u3 (ref), u15 (ref), RequestCompetitiveTeammateInventory (ref), UpdateAllTeammateIndicators (ref)
        if u272 == LocalPlayer then
            return;
        end;

        u3:Add(u272:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 1750
            -- upvalues: u272 (copy), LocalPlayer (ref), u15 (ref), RequestCompetitiveTeammateInventory (ref), UpdateAllTeammateIndicators (ref)
            if u272:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
                u15[u272] = nil;
            end;

            RequestCompetitiveTeammateInventory(u272);
            UpdateAllTeammateIndicators();
        end));
        u3:Add(u272:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(function() -- Line: 1757
            -- upvalues: UpdateAllTeammateIndicators (ref)
            UpdateAllTeammateIndicators();
        end));
        u3:Add(u272:GetAttributeChangedSignal("Armor"):Connect(function() -- Line: 1760
            -- upvalues: UpdateAllTeammateIndicators (ref)
            UpdateAllTeammateIndicators();
        end));
        u3:Add(u272:GetAttributeChangedSignal("HasDefuseKit"):Connect(function() -- Line: 1763
            -- upvalues: UpdateAllTeammateIndicators (ref)
            UpdateAllTeammateIndicators();
        end));
        u3:Add(u272:GetAttributeChangedSignal("HasRescueKit"):Connect(function() -- Line: 1766
            -- upvalues: UpdateAllTeammateIndicators (ref)
            UpdateAllTeammateIndicators();
        end));

        for i = 1, 5 do
            u3:Add(u272:GetAttributeChangedSignal("Slot" .. i):Connect(function() -- Line: 1771
                -- upvalues: RequestCompetitiveTeammateInventory (ref), u272 (copy), UpdateAllTeammateIndicators (ref)
                RequestCompetitiveTeammateInventory(u272);
                UpdateAllTeammateIndicators();
            end));
        end;
    end;

    (function() -- Line: 1778, Name: setupCompetitiveTeammateObservers
        -- upvalues: Profiler (ref), u3 (ref), u15 (ref), u16 (ref), Players (ref), trackCompetitiveTeammate (copy), RequestCompetitiveTeammateInventory (ref), UpdateAllTeammateIndicators (ref), Remotes (ref), LocalPlayer (ref), RequestCompetitiveTeammateInventories (ref)
        Profiler.mark("UI.BuyMenu.SetupCompetitiveTeammateObservers");
        u3:Cleanup();
        table.clear(u15);
        table.clear(u16);
        u3:Add(Players.PlayerAdded:Connect(function(p273) -- Line: 1783
            -- upvalues: trackCompetitiveTeammate (ref), RequestCompetitiveTeammateInventory (ref), UpdateAllTeammateIndicators (ref)
            trackCompetitiveTeammate(p273);
            RequestCompetitiveTeammateInventory(p273);
            UpdateAllTeammateIndicators();
        end));
        u3:Add(Players.PlayerRemoving:Connect(function(p274) -- Line: 1788
            -- upvalues: u15 (ref), u16 (ref), UpdateAllTeammateIndicators (ref)
            u15[p274] = nil;
            u16[p274] = nil;
            UpdateAllTeammateIndicators();
        end));
        u3:Add(Remotes.Inventory.SpectatedPlayerInventory.Listen(function(p275) -- Line: 1793
            -- upvalues: LocalPlayer (ref), u15 (ref), u16 (ref), UpdateAllTeammateIndicators (ref)
            if p275.Player == LocalPlayer then
                return;
            end;

            u15[p275.Player] = p275.Inventory;
            u16[p275.Player] = nil;
            UpdateAllTeammateIndicators();
        end));

        for _, v in ipairs(Players:GetPlayers()) do
            trackCompetitiveTeammate(v);
        end;

        RequestCompetitiveTeammateInventories();
        UpdateAllTeammateIndicators();
    end)();
    Observers.observeAttribute(LocalPlayer, "Team", function(p276) -- Line: 1819
        -- upvalues: cleanupAllDroppedEntries (ref), u15 (ref), u16 (ref), u2 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy), RequestCompetitiveTeammateInventories (ref)
        cleanupAllDroppedEntries();
        table.clear(u15);
        table.clear(u16);
        u2:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
        RequestCompetitiveTeammateInventories();
    end);
    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 1829
        -- upvalues: u2 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy), RequestCompetitiveTeammateInventories (ref)
        u2:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
        RequestCompetitiveTeammateInventories();
    end);
    Observers.observeAttribute(workspace, "ServerGamemode", function() -- Line: 1836
        -- upvalues: u15 (ref), u16 (ref), u2 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy), RequestCompetitiveTeammateInventories (ref)
        table.clear(u15);
        table.clear(u16);
        u2:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
        RequestCompetitiveTeammateInventories();
    end);
    Remotes.Inventory.NewInventoryItem.Listen(function(p277) -- Line: 1845
        -- upvalues: u5 (ref), u14 (ref), Profiler (ref), InventoryController (ref)
        table.insert(u5, p277.identifier);

        if u14 then
            local v278 = u14;
            u14 = nil;
            Profiler.defer("UI.BuyMenu.PendingDroppedEquipDeferred", InventoryController.equip, v278, 1);
        end;
    end);
    Remotes.Inventory.RemoveInventoryItem.Listen(function(u279) -- Line: 1855
        -- upvalues: RemoveFromArray (ref), u5 (ref)
        RemoveFromArray(u5, function(p280, p281) -- Line: 1856
            -- upvalues: u279 (copy)
            return p281 == u279;
        end);
    end);
    Observers.observeAttribute(LocalPlayer, "MinimumNextRoundIncome", function(p282) -- Line: 1862
        -- upvalues: u6 (ref)
        u6.Menu.TopFrame.NextRoundMoney.Text = "Next Round Minimum:  $" .. tostring(p282):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end);
    Observers.observeAttribute(LocalPlayer, "Money", function(p283) -- Line: 1868
        -- upvalues: u4 (ref), refreshBuyMenuTemplates (copy)
        u4:setGoal(p283);
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(LocalPlayer, "Armor", function() -- Line: 1875
        -- upvalues: refreshBuyMenuTemplates (copy)
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(LocalPlayer, "HasDefuseKit", function() -- Line: 1878
        -- upvalues: refreshBuyMenuTemplates (copy)
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(LocalPlayer, "HasRescueKit", function() -- Line: 1881
        -- upvalues: refreshBuyMenuTemplates (copy)
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(workspace, "VIPInfiniteCashEnabled", function() -- Line: 1884
        -- upvalues: refreshBuyMenuTemplates (copy)
        refreshBuyMenuTemplates();
    end);
    Observers.observeAttribute(LocalPlayer, "BuyMenu", function(p284) -- Line: 1889
        -- upvalues: u1 (ref)
        return function() -- Line: 1890
            -- upvalues: u1 (ref)
            u1.closeFrame();
        end;
    end);
    Observers.observeAttribute(workspace, "Timer", function() -- Line: 1897
        -- upvalues: UpdateBuyMenuTimerText (ref)
        UpdateBuyMenuTimerText();
    end);
    Observers.observeAttribute(workspace, "BuyTimerRemaining", function() -- Line: 1901
        -- upvalues: UpdateBuyMenuTimerText (ref)
        UpdateBuyMenuTimerText();
    end);
    GameState.ListenToState(function(p285, p286) -- Line: 1907
        -- upvalues: u5 (ref), UpdateBuyMenuTimerText (ref)
        if p286 == "Buy Period" then
            table.clear(u5);
        end;

        UpdateBuyMenuTimerText();
    end);
    InventoryController.OnInventoryChanged:Connect(function(p287) -- Line: 1916
        -- upvalues: u6 (ref), u1 (ref)
        for _, descendant in ipairs(u6.Menu.Container:GetDescendants()) do
            if descendant:IsA("TextButton") then
                u1.updateBuyMenuTemplate(p287, descendant);
            end;
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 1927
        -- upvalues: refreshBuyMenuTemplates (copy)
        refreshBuyMenuTemplates();
    end);
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1932
        -- upvalues: LocalPlayer (ref), u2 (ref), setupBuyMenuTemplates (ref), refreshBuyMenuTemplates (copy)
        if not LocalPlayer.Character then
            return;
        end;

        u2:Cleanup();
        setupBuyMenuTemplates();
        refreshBuyMenuTemplates();
    end);
    CollectionService:GetInstanceAddedSignal("WeaponDropped"):Connect(function(p288) -- Line: 1947
        -- upvalues: onWeaponDropped (ref)
        if p288:IsA("Model") then
            onWeaponDropped(p288);
        end;
    end);
    CollectionService:GetInstanceRemovedSignal("WeaponDropped"):Connect(function(p289) -- Line: 1952
        -- upvalues: onWeaponDropRemoved (ref)
        if p289:IsA("Model") then
            onWeaponDropRemoved(p289);
        end;
    end);

    for _, v in ipairs(CollectionService:GetTagged("WeaponDropped")) do
        if v:IsA("Model") then
            Profiler.spawn("UI.BuyMenu.ExistingDroppedWeapon", onWeaponDropped, v);
        end;
    end;

    Observers.observeAttribute(workspace, "Gamemode", function() -- Line: 1964
        -- upvalues: u6 (ref), cleanupAllDroppedEntries (ref)
        local v290 = u6 and u6.Menu and u6.Menu:FindFirstChild("Dropped");

        if v290 then
            v290.Visible = workspace:GetAttribute("Gamemode") ~= "Deathmatch";
        end;

        cleanupAllDroppedEntries();
    end);
    local v291 = u6 and u6.Menu and u6.Menu:FindFirstChild("Dropped");

    if v291 then
        v291.Visible = workspace:GetAttribute("Gamemode") ~= "Deathmatch";
    end;

    GameState.ListenToState(function(p292, p293) -- Line: 1971
        -- upvalues: cleanupAllDroppedEntries (ref)
        if p293 == "Buy Period" then
            cleanupAllDroppedEntries();
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 1978
        -- upvalues: u12 (ref), GetPreferenceColor (ref)
        for _, v in pairs(u12) do
            local template = v.template;
            local ImageLabel = template:FindFirstChild("ImageLabel");
            local TextLabel = template:FindFirstChild("TextLabel");

            if not template:GetAttribute("_OrigBG") then
                if ImageLabel then
                    ImageLabel.ImageColor3 = GetPreferenceColor();
                end;

                if TextLabel then
                    TextLabel.TextColor3 = GetPreferenceColor();
                end;
            end;
        end;
    end);
end;

function u1.Start() -- Line: 1998
    -- upvalues: Profiler (copy), LocalPlayer (copy), u1 (copy)
    debug.setmemorycategory("UI.BuyMenu.Start");
    Profiler.mark("UI.BuyMenu.Start");

    if LocalPlayer.Character then
        u1.characterAdded(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p294) -- Line: 2006
        -- upvalues: u1 (ref)
        u1.characterAdded(p294);
    end);
end;

return u1;