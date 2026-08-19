-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
game:GetService("TextService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local u2 = LocalPlayer:GetMouse();
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Buttons = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons);
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local UseItemFrame = require(script.Parent.UseItemFrame);
local Loadout = require(script.Parent.Loadout);
local Store = require(script.Parent.Store);
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
Color3.fromRGB(53, 83, 99);
local u3 = Color3.fromRGB(34, 38, 47);
local u4 = Color3.fromRGB(125, 206, 243);
local u5 = {};
local u6 = table.find(GetUserPlatform(), "PC") ~= nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = 0;
local u12 = false;
local u13 = nil;
local u14 = nil;
local u15 = false;
local u16 = false;
local u17 = nil;
local u18 = 0;
local u19 = nil;
local u20 = {};
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = {};
local u27 = nil;
local u28 = false;
local u29 = {
    ["Charm Capsule"] = "Charm Pack",
    Package = "Package"
};
local u30 = {
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue"
};
local u31 = {
    Glove = "Equipped Gloves",
    Badge = "Equipped Badge",
    ["Zeus x27"] = "Equipped Zeus x27"
};
local u32 = {};

local function ClearQuickOpenPending(p33) -- Line: 133
    -- upvalues: u19 (ref), Store (copy), u16 (ref)
    if p33 and u19 ~= p33 then
        return false;
    end;

    if u19 then
        Store.ClearPendingOpenCaseRequest(u19);
    end;

    u16 = false;
    u19 = nil;

    return true;
end;

local function MultiplyUdim2(p34, p35) -- Line: 147
    return UDim2.new(p34.X.Scale * p35, p34.X.Offset, p34.Y.Scale * p35, p34.Y.Offset);
end;

local function hasAnyInformationFrameButton() -- Line: 152
    -- upvalues: u21 (ref)
    if not u21 then
        return false;
    end;

    if u21.Charm and u21.Charm.Visible then
        return true;
    end;

    if u21.Inspect and u21.Inspect.Visible then
        return true;
    end;

    if u21.ReplaceCT and u21.ReplaceCT.Visible then
        return true;
    end;

    if u21.ReplaceT and u21.ReplaceT.Visible then
        return true;
    end;

    if u21.Unlock and u21.Unlock.Visible then
        return true;
    end;

    local QuickUnlock = u21:FindFirstChild("QuickUnlock");

    return QuickUnlock and QuickUnlock.Visible and true or false;
end;

local function ClearFrame(p36, p37) -- Line: 180
    local v38 = p36:GetChildren();

    for _, v in ipairs(v38) do
        if v.ClassName == p37 then
            v:Destroy();
        end;
    end;
end;

local function GetInventoryItemFromIdentifier(p39, p40) -- Line: 193
    for _, v in ipairs(p39) do
        if v._id == p40 then
            return v;
        end;
    end;

    return nil;
end;

local function IsItemEquippedOnTeam(p41, p42) -- Line: 208
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v43 = DataController.Get(LocalPlayer, "Loadout");

    if not v43 then
        return false;
    end;

    local v44 = v43[p42];

    if not v44 then
        return false;
    end;

    if v44.Loadout then
        for _, v in pairs(v44.Loadout) do
            if v and v.Options then
                for _, v2 in ipairs(v.Options) do
                    if v2 == p41 then
                        return true;
                    end;
                end;
            end;
        end;
    end;

    if v44.Equipped then
        for _, v in pairs(v44.Equipped) do
            if v == p41 then
                return true;
            end;
        end;
    end;

    return false;
end;

local function UpdateItemStatusFrame(p45, p46) -- Line: 247
    -- upvalues: IsItemEquippedOnTeam (copy)
    local Status = p45:FindFirstChild("Status");

    if not Status then
        return;
    end;

    local v47 = Status:FindFirstChild("Counter-Terrorists");
    local Terrorists = Status:FindFirstChild("Terrorists");

    if v47 and Terrorists then
        local v48 = IsItemEquippedOnTeam(p46, "Counter-Terrorists");
        local v49 = IsItemEquippedOnTeam(p46, "Terrorists");
        v47.Visible = v48;
        Terrorists.Visible = v49;
    end;
end;

local function IsWeaponEquippedInTeamCategory(p50, p51, p52) -- Line: 270
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v53 = DataController.Get(LocalPlayer, "Loadout");
    local v54 = DataController.Get(LocalPlayer, "Inventory");

    if not (v53 and v54) then
        return false, nil;
    end;

    local v55 = v53[p51];

    if not (v55 and (v55.Loadout and v55.Loadout[p52])) then
        return false, nil;
    end;

    local v56, v57, v58;
    v56, v57, v58 = ipairs(v55.Loadout[p52].Options);

    while true do
        local v59, v60 = v56(v57, v58);

        if v59 == nil then
            break;
        end;

        v58 = v59;

        if not v60 or v60 == "" then
            continue;
        end;

        for _, v in ipairs(v54) do
            if v._id == v60 then
                break;
            end;
        end;

        if v and v.Name == p50 then
            return true, v59;
        end;
    end;
end;

local function GetWeaponCategory(p61) -- Line: 302
    -- upvalues: GetWeaponProperties (copy)
    local v62 = {
        Pistol = "Pistols",
        SMG = "Mid Tier",
        Heavy = "Mid Tier",
        Rifle = "Rifles"
    };
    local success, result = pcall(GetWeaponProperties, p61);

    if success and (result and result.Type) then
        return v62[result.Type];
    end;

    return nil;
end;

local function ReplaceItemOnTeam(p63, p64) -- Line: 321
    -- upvalues: GetWeaponProperties (copy), IsWeaponEquippedInTeamCategory (copy), Remotes (copy), Top (copy), Loadout (copy), Profiler (copy), u31 (copy)
    if p63.Type ~= "Weapon" then
        if p63.Type ~= "Melee" then
            if u31[p63.Type] then
                Remotes.Inventory.EquipSpecialItem.Send({
                    Identifier = p63._id,
                    Path = u31[p63.Type],
                    Team = p64
                });
            end;

            return;
        end;

        if p63.Name == "CT Knife" then
            if p64 == "Terrorists" then
                return;
            end;
        elseif p63.Name == "T Knife" and p64 == "Counter-Terrorists" then
            return;
        end;

        Remotes.Inventory.EquipSpecialItem.Send({
            Path = "Equipped Melee",
            Identifier = p63._id,
            Team = p64
        });

        return;
    end;

    local Name = p63.Name;
    local v65 = {
        Pistol = "Pistols",
        SMG = "Mid Tier",
        Heavy = "Mid Tier",
        Rifle = "Rifles"
    };
    local success, result = pcall(GetWeaponProperties, Name);
    local v66;

    if success and (result and result.Type) then
        v66 = v65[result.Type];
    else
        v66 = nil;
    end;

    if not v66 then
        return;
    end;

    local v67, v68 = IsWeaponEquippedInTeamCategory(Name, p64, v66);

    if v67 and v68 then
        Remotes.Inventory.EquipLoadoutSkin.Send({
            Type = v66,
            Slot = v68 - 1,
            Team = p64,
            Identifier = p63._id
        });

        return;
    end;

    Top.openFrame("Loadout");
    Loadout.SelectTeam(p64 == "Counter-Terrorists" and "CT" or "T");
    Loadout.SortByCategory(nil);
    Loadout.SortByWeapon(Name);
    Profiler.defer("UI.Inventory.LoadoutWeaponFilterDeferred", Loadout.SortByWeapon, Name);
end;

local function setSortDropdownOpen(p69) -- Line: 387
    -- upvalues: u22 (ref)
    local v70 = u22;

    if not v70 then
        return;
    end;

    v70.Visible = p69;
    v70.Active = p69;
    local Scroll = v70:FindFirstChild("Scroll");

    if Scroll and Scroll:IsA("GuiObject") then
        Scroll.Visible = p69;
        Scroll.Active = p69;
    end;
end;

local function IsMouseOverBlockingUI() -- Line: 403
    -- upvalues: u2 (copy), u23 (ref), u22 (ref), u21 (ref)
    local v71 = Vector2.new(u2.X, u2.Y);

    if u23.Ignore.ItemNotification.Visible then
        return true;
    end;

    local v72 = u22;

    if v72 and v72.Visible then
        local AbsolutePosition = v72.AbsolutePosition;
        local AbsoluteSize = v72.AbsoluteSize;

        if v71.X >= AbsolutePosition.X and (v71.X <= AbsolutePosition.X + AbsoluteSize.X and (v71.Y >= AbsolutePosition.Y and v71.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
            return true;
        end;
    end;

    if u21.Visible then
        local AbsolutePosition = u21.AbsolutePosition;
        local AbsoluteSize = u21.AbsoluteSize;

        if v71.X >= AbsolutePosition.X and (v71.X <= AbsolutePosition.X + AbsoluteSize.X and (v71.Y >= AbsolutePosition.Y and v71.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
            return true;
        end;
    end;

    return false;
end;

local function shouldRunInventoryUpdate() -- Line: 441
    -- upvalues: u23 (ref), u26 (copy)
    local v73;

    if u23 == nil then
        v73 = false;
    else
        v73 = u23.Visible or #u26 > 0;
    end;

    return v73;
end;

local function stopInventoryUpdate() -- Line: 447
    -- upvalues: u27 (ref)
    if u27 then
        u27:Disconnect();
        u27 = nil;
    end;
end;

local function updateInventoryHeartbeat(p74) -- Line: 456
    -- upvalues: Profiler (copy), u23 (ref), u24 (ref), u27 (ref), u26 (copy), u6 (copy), u1 (copy), u11 (ref)
    Profiler.mark("UI.Inventory.Heartbeat");

    if not (u23 and u24) then
        if u27 then
            u27:Disconnect();
            u27 = nil;
        end;

        return;
    end;

    local v75;

    if u23 == nil then
        v75 = false;
    else
        v75 = u23.Visible or #u26 > 0;
    end;

    local Alert = u24.Menu.Top.Bottom.Buttons.Inventory.Alert;

    if v75 and (u6 and u23.Visible) then
        u1.UpdateHoverFrame(p74);
    else
        u23.Ignore.Hover.Visible = false;
    end;

    local v76 = #u26;
    Alert.TextLabel.Text = v76;
    Alert.Visible = v76 > 0;

    if v75 and u23.Ignore.ItemNotification.Visible then
        u23.Ignore.ItemNotification.Holder.Light.Rotation = u23.Ignore.ItemNotification.Holder.Light.Rotation + p74 * 10;
    end;

    u23.Ignore.ItemNotification.Holder.Amount.TextLabel.Text = `{u11} / {v76}`;
    u23.Ignore.ItemNotification.Holder.Right.Visible = u11 < v76;
    u23.Ignore.ItemNotification.Holder.Left.Visible = u11 > 1;

    if not v75 and u27 then
        u27:Disconnect();
        u27 = nil;
    end;
end;

local function syncInventoryUpdate() -- Line: 493
    -- upvalues: u23 (ref), u26 (copy), u27 (ref), RunServiceController (copy), updateInventoryHeartbeat (copy)
    local v77;

    if u23 == nil then
        v77 = false;
    else
        v77 = u23.Visible or #u26 > 0;
    end;

    if not v77 then
        updateInventoryHeartbeat(0);

        return;
    end;

    if u27 then
        return;
    end;

    u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
    updateInventoryHeartbeat(0);
end;

local function CalculateHoverPosition(p78) -- Line: 509
    -- upvalues: u23 (ref), GuiService (copy)
    local AbsolutePosition = u23.AbsolutePosition;
    local AbsoluteSize = u23.Ignore.Hover.AbsoluteSize;
    local AbsolutePosition2 = p78.AbsolutePosition;
    local AbsoluteSize2 = u23.AbsoluteSize;
    local AbsoluteSize3 = p78.AbsoluteSize;
    local v79 = AbsolutePosition2.X - AbsolutePosition.X;
    local v80 = AbsoluteSize2.X - (v79 + AbsoluteSize3.X) >= AbsoluteSize.X + 8 and (v79 + AbsoluteSize3.X + 8 + AbsoluteSize.X / 2) / AbsoluteSize2.X or (v79 - 8 - AbsoluteSize.X / 2) / AbsoluteSize2.X;
    local v81 = math.max((AbsolutePosition2.Y - AbsolutePosition.Y + AbsoluteSize3.Y / 2) / AbsoluteSize2.Y, AbsoluteSize.Y / 2 / AbsoluteSize2.Y);
    local v82 = 1 - AbsoluteSize.Y / 2 / AbsoluteSize2.Y;
    local v83 = math.min(v81, v82);

    if GuiService:GetGuiInset().Y >= AbsolutePosition.Y + v83 * AbsoluteSize2.Y - AbsoluteSize.Y / 2 then
        v83 = math.min(v83 + 30 / AbsoluteSize2.Y, v82);
    end;

    return UDim2.fromScale(v80, v83);
end;

local function GetIconImage(p84, p85, p86) -- Line: 563
    -- upvalues: Skins (copy)
    if not p85 then
        return "";
    end;

    if p86 then
        return p85.imageAssetId or "";
    end;

    if p84.Type ~= "Charm" then
        return Skins.GetWearImageForFloat(p85, p84.Float or 0.9999) or p85.imageAssetId or "";
    end;

    local Pattern = p84.Pattern;

    if Pattern and p85.charmImages then
        for _, v in ipairs(p85.charmImages) do
            if v.pattern == Pattern then
                return v.assetId;
            end;
        end;
    end;

    return p85.imageAssetId or "";
end;

local function findCharmInventoryItemInList(p87, p88) -- Line: 590
    if not p87 or (p87 == false or not p88) then
        return nil;
    end;

    local v89 = nil;

    if type(p87) == "table" then
        p87 = p87._id;
    elseif type(p87) ~= "string" then
        p87 = v89;
    end;

    if not p87 then
        return nil;
    end;

    for _, v in ipairs(p88) do
        if v._id == p87 and v.Type == "Charm" then
            return v;
        end;
    end;

    return nil;
end;

local function syncItemTemplateCharmIcon(p90, p91) -- Line: 613
    -- upvalues: DataController (copy), LocalPlayer (copy), findCharmInventoryItemInList (copy), GetResolvedSkinInformation (copy), GetIconImage (copy)
    local Charm = p90.ItemContent:FindFirstChild("Charm");

    if not (Charm and Charm:IsA("ImageLabel")) then
        return;
    end;

    if p91.Type ~= "Weapon" then
        Charm.Visible = false;
        Charm.Image = "";

        return;
    end;

    local v92;

    if p91.Charm == nil or p91.Charm == false then
        v92 = false;
    else
        v92 = (type(p91.Charm) == "string" or p91.Charm == true) and true or type(p91.Charm) == "table";
    end;

    if not v92 then
        Charm.Visible = false;
        Charm.Image = "";

        return;
    end;

    local v93 = DataController.Get(LocalPlayer, "Inventory");
    local v94 = findCharmInventoryItemInList(p91.Charm, v93);

    if not v94 then
        Charm.Visible = false;
        Charm.Image = "";

        return;
    end;

    local v95 = GetResolvedSkinInformation(v94.Name, v94.Skin);

    if not v95 then
        Charm.Visible = false;
        Charm.Image = "";

        return;
    end;

    local v96 = GetIconImage(v94, v95, false);

    if v96 == "" then
        Charm.Visible = false;
        Charm.Image = "";

        return;
    end;

    Charm.Image = v96;
    Charm.Visible = true;
end;

local function GetCollectionNameForItem(p97) -- Line: 660
    -- upvalues: Cases (copy), u13 (ref), GetResolvedSkinInformation (copy)
    if p97.Type ~= "Case" then
        local v98 = GetResolvedSkinInformation(p97.Name, p97.Skin);

        return v98 and v98.collection or nil;
    end;

    local v99 = Cases.GetCaseByName(p97.Skin);

    if not (v99 and u13) then
        return nil;
    end;

    for _, v in ipairs(u13) do
        if v.cases then
            for _, v2 in ipairs(v.cases) do
                if v2 == v99.name then
                    return v.name;
                end;
            end;
        end;
    end;

    return nil;
end;

local function GetSortedInventoryData() -- Line: 689
    -- upvalues: DataController (copy), LocalPlayer (copy), u14 (ref), u23 (ref), Sort (copy), u13 (ref), Grenades (copy), u15 (ref)
    local v100 = DataController.Get(LocalPlayer, "Inventory");

    if not v100 then
        return {};
    end;

    local u101 = Sort.GetSortComparisonFunction(u14 or (u23.Frame.Right.Top.Weapon.Container.Left.Title.Text or "Newest"), LocalPlayer, function() -- Line: 697
        -- upvalues: u13 (ref)
        return u13;
    end);
    local v102 = {};

    for _, v in v100 do
        local v103;

        if v then
            v103 = Grenades[v.Name];
        else
            v103 = v;
        end;

        local v104;

        if v then
            v104 = v.Type == "Case" and true or v.Type == "Package";
        else
            v104 = v;
        end;

        if v and (v._id and v.Name) and (v104 or v.Skin) and not v103 then
            table.insert(v102, v);
        end;
    end;

    if u101 then
        if u15 then
            table.sort(v102, function(p105, p106) -- Line: 715
                -- upvalues: u101 (copy)
                local v107, v108 = u101(p105, p106);

                if v108 then
                    return v107;
                end;

                return u101(p106, p105);
            end);

            return v102;
        end;

        table.sort(v102, u101);
    end;

    return v102;
end;

local function IsNotFiltered(p109, p110) -- Line: 735
    -- upvalues: Buttons (copy), GetWeaponProperties (copy)
    if not p110 or #p110 == 0 then
        return true;
    end;

    local v111 = Buttons.GetEffectiveItemType(p109);
    local v112 = Buttons.IsCapsule(p109);

    for _, v in ipairs(p110) do
        if v111 == v then
            return true;
        end;

        if p109.Type and (p109.Type == v and not v112) then
            return true;
        end;

        local v113;

        if p109.Name then
            v113 = GetWeaponProperties(p109.Name);
        else
            v113 = nil;
        end;

        if string.find(v, ":") then
            local v114 = string.split(v, ":");

            if v114[1] == "Weapon" and (v113 and (v113.Class == "Weapon" and v114[2] == v113.Type)) then
                return true;
            end;
        elseif v113 and v113.Class == v then
            return true;
        end;
    end;

    return false;
end;

local function SetSearchQuery(p115) -- Line: 785
    -- upvalues: u20 (copy)
    table.clear(u20);

    if p115 ~= "" then
        for _, v in ipairs(string.split(string.lower(p115), " ")) do
            if v ~= "" then
                table.insert(u20, v);
            end;
        end;
    end;
end;

local function MatchesSearchQuery(p116) -- Line: 797
    -- upvalues: u20 (copy)
    if #u20 == 0 then
        return true;
    end;

    local v117 = string.lower((p116.Name or "") .. " " .. (p116.Skin or ""));

    if string.find(v117, "zeus", 1, true) then
        v117 = v117 .. " taser";
    end;

    for _, v in ipairs(u20) do
        if string.find(v117, v, 1, true) == nil then
            return false;
        end;
    end;

    return true;
end;

local function ApplyFilterToSortedData(p118) -- Line: 816
    -- upvalues: Buttons (copy), u32 (copy), DataController (copy), LocalPlayer (copy), IsNotFiltered (copy), u20 (copy), MatchesSearchQuery (copy)
    local v119 = {};

    for _, v in Buttons do
        if type(v) == "table" then
            for i, v2 in v do
                if u32[i] then
                    for _, v3 in v2.Search do
                        table.insert(v119, v3);
                    end;
                end;
            end;
        end;
    end;

    local v120 = {};
    local v121 = DataController.Get(LocalPlayer, "Inventory");

    if v121 then
        for _, v in ipairs(v121) do
            if v.Charm then
                local v122 = type(v.Charm) == "table" and v.Charm._id;

                if not v122 then
                    if type(v.Charm) == "string" then
                        v122 = v.Charm;
                    else
                        v122 = false;
                    end;
                end;

                if v122 then
                    v120[v122] = true;
                end;
            end;
        end;
    end;

    local v123 = {};

    for _, v in ipairs(p118) do
        local v124 = IsNotFiltered(v, v119);

        if v124 and (v.Type == "Charm" and v120[v._id]) then
            v124 = false;
        end;

        if v124 then
            table.insert(v123, v);
        end;
    end;

    if #u20 > 0 then
        v123 = {};

        for _, v in ipairs(v123) do
            if MatchesSearchQuery(v) then
                table.insert(v123, v);
            end;
        end;
    end;

    return v123;
end;

local function RenderInventoryTemplates() -- Line: 906
    -- upvalues: Profiler (copy), u23 (ref), u18 (ref), u5 (ref), u1 (copy)
    Profiler.mark("UI.Inventory.RenderInventoryTemplates");

    if u23 and u23.Visible then
        local Container = u23.Frame.Right.Container;
        local v125 = math.min(u18 + 25, #u5);

        for i = u18 + 1, v125 do
            local v126 = u5[i];

            if v126 and not Container:FindFirstChild(v126._id) then
                u1.CreateItemTemplate(v126);
            end;
        end;

        u18 = v125;

        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
                for i, v in ipairs(u5) do
                    if v._id == child.Name then
                        child.LayoutOrder = i;
                        break;
                    end;
                end;
            end;
        end;
    end;
end;

local function OnScrollPositionChanged() -- Line: 943
    -- upvalues: u23 (ref), u18 (ref), u5 (ref), RenderInventoryTemplates (copy)
    if u23 and u23.Visible then
        local v127 = u23.Frame.Right.Container.AbsoluteCanvasSize.Y - u23.Frame.Right.Container.AbsoluteSize.Y;

        if v127 > 0 and (u18 < #u5 and v127 - u23.Frame.Right.Container.CanvasPosition.Y < 200) then
            RenderInventoryTemplates();
        end;
    end;
end;

local function CalculateInitialRenderCount() -- Line: 963
    -- upvalues: u23 (ref)
    if not (u23 and u23.Visible) then
        return 50;
    end;

    local Container = u23.Frame.Right.Container;
    local v128 = Container:FindFirstChildOfClass("UIGridLayout");

    if not v128 then
        return 50;
    end;

    local AbsoluteSize = Container.AbsoluteSize;
    local Y = AbsoluteSize.Y;
    local X = AbsoluteSize.X;
    local CellSize = v128.CellSize;
    local CellPadding = v128.CellPadding;
    local v129 = CellSize.Y.Scale * Y + CellSize.Y.Offset;
    local v130 = CellPadding.Y.Scale * Y + CellPadding.Y.Offset;
    local v131 = CellSize.X.Scale * X + CellSize.X.Offset;
    local v132 = CellPadding.X.Scale * X + CellPadding.X.Offset;
    local v133 = Container:FindFirstChildOfClass("UIPadding");
    local v134, v135, v136, v137;

    if v133 then
        v134 = v133.PaddingTop.Scale * Y + v133.PaddingTop.Offset;
        v135 = v133.PaddingBottom.Scale * Y + v133.PaddingBottom.Offset;
        v136 = v133.PaddingLeft.Scale * X + v133.PaddingLeft.Offset;
        v137 = v133.PaddingRight.Scale * X + v133.PaddingRight.Offset;
    else
        v134 = 0;
        v135 = 0;
        v136 = 0;
        v137 = 0;
    end;

    local v138 = Y - v134 - v135;
    local v139 = X - v136 - v137;
    local v140 = v131 + v132;
    local v141;

    if v140 > 0 then
        local v142 = math.floor((v139 + v132) / v140);
        v141 = math.max(1, v142);
    else
        v141 = 1;
    end;

    local v143 = v129 + v130;
    local v144;

    if v143 > 0 then
        local v145 = math.floor((v138 + v130) / v143);
        v144 = math.max(1, v145);
    else
        v144 = 1;
    end;

    return v144 * v141 + v141;
end;

local function RenderInitialTemplates() -- Line: 1035
    -- upvalues: Profiler (copy), u23 (ref), u18 (ref), CalculateInitialRenderCount (copy), u5 (ref), u1 (copy)
    Profiler.mark("UI.Inventory.RenderInitialTemplates");

    if not (u23 and u23.Visible) then
        return;
    end;

    local Container = u23.Frame.Right.Container;
    u18 = 0;
    local v146 = CalculateInitialRenderCount();
    local v147 = math.max(v146, 50);
    local v148 = math.min(v147, #u5);

    for i = 1, v148 do
        local v149 = u5[i];

        if v149 and not Container:FindFirstChild(v149._id) then
            u1.CreateItemTemplate(v149);
        end;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
            for i, v in ipairs(u5) do
                if v._id == child.Name then
                    child.LayoutOrder = i;
                    break;
                end;
            end;
        end;
    end;

    u18 = v148;
end;

local function IsItemTemplate(p150) -- Line: 1084
    local v151 = p150:IsA("ImageButton");

    if v151 then
        if p150.Name == "UIGridLayout" or (p150.Name == "UIListLayout" or (p150.Name == "UIPadding" or p150.Name == "Title")) then
            v151 = false;
        else
            v151 = p150.Name ~= "Label";
        end;
    end;

    return v151;
end;

local function UpdateInventoryTemplates() -- Line: 1095
    -- upvalues: Profiler (copy), u23 (ref), u18 (ref), RenderInitialTemplates (copy)
    Profiler.mark("UI.Inventory.UpdateInventoryTemplates");

    if not u23 then
        return;
    end;

    for _, child in ipairs(u23.Frame.Right.Container:GetChildren()) do
        local v152 = child:IsA("ImageButton");

        if v152 then
            if child.Name == "UIGridLayout" or (child.Name == "UIListLayout" or (child.Name == "UIPadding" or child.Name == "Title")) then
                v152 = false;
            else
                v152 = child.Name ~= "Label";
            end;
        end;

        if v152 then
            child:Destroy();
        end;
    end;

    u18 = 0;

    if u23.Visible then
        RenderInitialTemplates();
    end;
end;

local function ApplyCurrentSort() -- Line: 1122
    -- upvalues: Profiler (copy), u23 (ref), u5 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy)
    Profiler.mark("UI.Inventory.ApplyCurrentSort");

    if not u23 then
        return;
    end;

    if not u23.Visible then
        return;
    end;

    u5 = GetSortedInventoryData();
    u5 = ApplyFilterToSortedData(u5);
    UpdateInventoryTemplates();
end;

local function AnimateSortButton(u153, u154, u155, u156, u157) -- Line: 1143
    -- upvalues: Router (copy), u21 (ref), u14 (ref), Profiler (copy), u23 (ref), u5 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy)
    u154.Selectable = true;

    local function handleSortOptionClick() -- Line: 1154
        -- upvalues: Router (ref), u21 (ref), u14 (ref), u155 (copy), Profiler (ref), u23 (ref), u5 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u156 (copy), u153 (copy), u154 (copy), u157 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if u21 then
            u21.Visible = false;
        end;

        u14 = u155;
        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if u23 and u23.Visible then
            u5 = GetSortedInventoryData();
            u5 = ApplyFilterToSortedData(u5);
            UpdateInventoryTemplates();
        end;

        u156.Text = u155;

        for _, child in ipairs(u153:GetChildren()) do
            if child:IsA("TextButton") then
                child.Frame.BackgroundTransparency = child == u154 and 0 or 1;
            end;
        end;

        u157();
    end;

    u154.MouseButton1Click:Connect(handleSortOptionClick);
    u154.Activated:Connect(function(p158) -- Line: 1174
        -- upvalues: handleSortOptionClick (copy)
        if p158 and p158.UserInputType == Enum.UserInputType.Gamepad1 then
            handleSortOptionClick();
        end;
    end);
end;

function u1.CreateItemTemplate(u159) -- Line: 1186
    -- upvalues: Profiler (copy), Cases (copy), GetResolvedSkinInformation (copy), Rarities (copy), GetIconImage (copy), ReplicatedStorage (copy), u23 (ref), GetWeaponProperties (copy), syncItemTemplateCharmIcon (copy), u29 (copy), GetSkinDisplayName (copy), UpdateItemStatusFrame (copy), IsMouseOverBlockingUI (copy), DataController (copy), LocalPlayer (copy), Router (copy), u10 (ref), u7 (ref), u1 (copy), hasAnyInformationFrameButton (copy), u21 (ref), UserInputService (copy), u2 (copy), u9 (ref), u17 (ref), u6 (copy), u8 (ref)
    Profiler.mark("UI.Inventory.CreateItemTemplate");

    if not (u159 and u159._id) then
        return;
    end;

    local v160 = u159.Type == "Case" and true or u159.Type == "Package";
    local v161 = v160 and Cases.GetCaseByName(u159.Skin) or GetResolvedSkinInformation(u159.Name, u159.Skin);

    if not v161 then
        print((`[Inventory] Skipping template creation for item: {u159.Name} | {u159.Skin} (Type: {u159.Type}) - No item information found`));

        return;
    end;

    local v162 = Rarities[v160 and v161.caseRarity or v161.rarity];
    local v163 = GetIconImage(u159, v161, v160);
    local u164 = ReplicatedStorage.Assets.UI.Inventory.ItemTemplate:Clone();
    u164.ItemContent.Rarity.BackgroundColor3 = v162.Color;
    u164.Parent = u23.Frame.Right.Container;
    u164.ItemContent.Content.Icon.Image = v163;
    u164.Name = u159._id;
    local v165 = GetWeaponProperties(u159.Name);

    if v165 and v165.InventoryIconData then
        u164.ItemContent.Content.Icon.ScaleType = v165.InventoryIconData.ScaleType or (u164.ItemContent.Content.Icon.ScaleType or u164.ItemContent.Content.Icon.Position);
        u164.ItemContent.Content.Icon.Size = v165.InventoryIconData.Size or u164.itemTemplate.ItemContent.Content.Icon.Size;
    end;

    syncItemTemplateCharmIcon(u164, u159);
    local Name = u159.Name;
    local v166 = Name and Name:find("Zeus") and "Taser" or Name;
    local v167 = v160 and v161.caseType and u29[v161.caseType] or v160 and v161.caseType;

    if v167 then
        v166 = v167;
    elseif u159.StatTrack then
        v166 = "KillTrak™ " .. v166 or v166;
    end;

    local v168 = GetSkinDisplayName(v160 and v161.skin or (u159.Skin or ""));

    if u159.Type == "Melee" then
        v166 = "★ " .. v166;
    end;

    u164.Bottom.Footer.WeaponName.Text = v166;
    u164.Bottom.Footer.SkinName.Text = v168;
    UpdateItemStatusFrame(u164, u159._id);
    u164.Selectable = true;

    local function handleItemSelection(u169) -- Line: 1280
        -- upvalues: u23 (ref), IsMouseOverBlockingUI (ref), DataController (ref), LocalPlayer (ref), u159 (ref), Router (ref), u10 (ref), u164 (copy), u7 (ref), u1 (ref), hasAnyInformationFrameButton (ref), u21 (ref), UserInputService (ref), u2 (ref), Profiler (ref), u9 (ref), u17 (ref)
        if u23.Ignore.ItemNotification.Visible or IsMouseOverBlockingUI() then
            return;
        end;

        local v170 = DataController.Get(LocalPlayer, "Inventory");

        if v170 then
            for _, v in ipairs(v170) do
                if v._id == u159._id then
                    u159 = v;
                    break;
                end;
            end;
        end;

        local v171 = u159.Type == "Case" and true or u159.Type == "Package";
        local v172 = u159.Type == "Charm Capsule" and true or u159.Type == "Sticker Capsule";
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u10 = u164;
        u7 = u159;
        u1.SetupInformationFrame(u159);

        if not hasAnyInformationFrameButton() then
            u21.Visible = false;

            return;
        end;

        local function positionInformationFrame() -- Line: 1311
            -- upvalues: u21 (ref), UserInputService (ref), u169 (copy), u164 (ref), u2 (ref)
            local Parent = u21.Parent.Parent;
            local AbsolutePosition = Parent.AbsolutePosition;
            local AbsoluteSize = Parent.AbsoluteSize;
            local v173, v174;

            if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 or u169 then
                if u164 and u164:IsA("GuiObject") then
                    local AbsolutePosition2 = u164.AbsolutePosition;
                    local AbsoluteSize2 = u164.AbsoluteSize;
                    local v175 = (AbsolutePosition2.X + AbsoluteSize2.X / 2 - AbsolutePosition.X) / AbsoluteSize.X;
                    v173 = (AbsolutePosition2.Y + AbsoluteSize2.Y / 2 - AbsolutePosition.Y) / AbsoluteSize.Y + u21.Size.Y.Scale / 2;

                    if 1 - v175 >= u21.Size.X.Scale + 0.01 then
                        v174 = v175 + u21.Size.X.Scale / 2 + 0.01;
                    else
                        v174 = v175 - u21.Size.X.Scale / 2 - 0.01;
                    end;
                else
                    v174 = 0.5;
                    v173 = 0.5;
                end;
            else
                local v176 = (u2.X - AbsolutePosition.X) / AbsoluteSize.X;
                v173 = (u2.Y - AbsolutePosition.Y) / AbsoluteSize.Y + u21.Size.Y.Scale / 2;

                if 1 - v176 >= u21.Size.X.Scale + 0.01 then
                    v174 = v176 + u21.Size.X.Scale / 2 + 0.01;
                else
                    v174 = v176 - u21.Size.X.Scale / 2 - 0.01;
                end;
            end;

            u21.Position = UDim2.fromScale(v174, v173);
        end;

        if v171 or v172 then
            u21.Visible = true;
            positionInformationFrame();
            u23.Ignore.Hover.Visible = false;

            if u169 then
                Profiler.defer("UI.Inventory.InformationNavigationDeferred", function() -- Line: 1363
                    -- upvalues: u1 (ref)
                    u1.SetupInformationFrameNavigation();
                    u1.SelectFirstInformationFrameButton();
                end);
            end;

            return;
        end;

        if u169 then
            u21.Visible = true;
        else
            u21.Visible = not u21.Visible;
        end;

        if not u21.Visible then
            if u9 then
                u17 = tick();
            end;

            return;
        end;

        positionInformationFrame();
        u23.Ignore.Hover.Visible = false;
        Profiler.defer("UI.Inventory.InformationNavigationDeferred", function() -- Line: 1382
            -- upvalues: u1 (ref), u169 (copy)
            u1.SetupInformationFrameNavigation();

            if u169 then
                u1.SelectFirstInformationFrameButton();
            end;
        end);
    end;

    u164.MouseButton1Click:Connect(function() -- Line: 1394
        -- upvalues: handleItemSelection (copy)
        handleItemSelection(false);
    end);
    u164.Activated:Connect(function(p177) -- Line: 1399
        -- upvalues: handleItemSelection (copy)
        if p177 and p177.UserInputType == Enum.UserInputType.Gamepad1 then
            handleItemSelection(true);
        end;
    end);

    if u6 then
        u164.MouseEnter:Connect(function() -- Line: 1407
            -- upvalues: u8 (ref), u159 (ref), u9 (ref), u164 (copy), u17 (ref)
            u8 = u159;
            u9 = u164;
            u17 = tick();
        end);
        u164.MouseLeave:Connect(function() -- Line: 1414
            -- upvalues: u9 (ref), u8 (ref), u17 (ref)
            u9 = nil;
            u8 = nil;
            u17 = nil;
        end);
    end;
end;

function u1.UpdateInventoryFilter() -- Line: 1424
    -- upvalues: Profiler (copy), u23 (ref), u5 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy)
    Profiler.mark("UI.Inventory.ApplyCurrentSort");

    if not u23 then
        return;
    end;

    if not u23.Visible then
        return;
    end;

    u5 = GetSortedInventoryData();
    u5 = ApplyFilterToSortedData(u5);
    UpdateInventoryTemplates();
end;

function u1.UpdateInventory(p178) -- Line: 1430
    -- upvalues: Profiler (copy), u23 (ref), u7 (ref), u10 (ref), u8 (ref), u21 (ref), u5 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy)
    Profiler.mark("UI.Inventory.UpdateInventory");

    if not u23 then
        return;
    end;

    if not p178 or type(p178) ~= "table" then
        print("UpdateInventory received invalid inventory data:", p178);

        return;
    end;

    if not u23.Visible then
        return;
    end;

    local Container = u23.Frame.Right.Container;
    local v179 = {};

    for _, v in ipairs(p178) do
        if v and v._id then
            v179[v._id] = true;
        end;
    end;

    if u7 and (u7._id and not v179[u7._id]) then
        u7 = nil;
        u10 = nil;
        u8 = nil;

        if u21 then
            u21.Visible = false;
        end;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        local v180 = child:IsA("ImageButton");

        if v180 then
            if child.Name == "UIGridLayout" or (child.Name == "UIListLayout" or (child.Name == "UIPadding" or child.Name == "Title")) then
                v180 = false;
            else
                v180 = child.Name ~= "Label";
            end;
        end;

        if v180 and not v179[child.Name] then
            child:Destroy();
        end;
    end;

    Profiler.mark("UI.Inventory.ApplyCurrentSort");

    if not u23 then
        return;
    end;

    if not u23.Visible then
        return;
    end;

    u5 = GetSortedInventoryData();
    u5 = ApplyFilterToSortedData(u5);
    UpdateInventoryTemplates();
end;

function u1.UpdateTemplates(p181) -- Line: 1479
    -- upvalues: Profiler (copy), u23 (ref), GetResolvedSkinInformation (copy), Rarities (copy), GetIconImage (copy), syncItemTemplateCharmIcon (copy), UpdateItemStatusFrame (copy)
    Profiler.mark("UI.Inventory.UpdateTemplates");

    if not (u23 and u23.Visible) then
        return;
    end;

    local Container = u23.Frame.Right.Container;

    if p181 then
        for _, v in ipairs(p181) do
            local v182 = Container:FindFirstChild(v._id);

            if v182 and v182:IsA("Frame") then
                local v183 = GetResolvedSkinInformation(v.Name, v.Skin);

                if v183 then
                    v182.Main.RarityFrame.UIGradient.Color = Rarities[v183.rarity].ColorSequence;
                    v182.Main.Glow.UIGradient.Color = Rarities[v183.rarity].ColorSequence;
                    v182.Main.Icon.Image = GetIconImage(v, v183, false);
                end;

                syncItemTemplateCharmIcon(v182, v);
                UpdateItemStatusFrame(v182, v._id);
            end;
        end;
    end;
end;

function u1.SetupInformationFrameNavigation() -- Line: 1514
    -- upvalues: u21 (ref)
    if not u21 then
        return;
    end;

    local v184 = {};

    if u21.Charm and u21.Charm.Visible then
        table.insert(v184, {
            button = u21.Charm,
            order = u21.Charm.LayoutOrder
        });
    end;

    if u21.Inspect and u21.Inspect.Visible then
        table.insert(v184, {
            button = u21.Inspect,
            order = u21.Inspect.LayoutOrder
        });
    end;

    if u21.ReplaceCT and u21.ReplaceCT.Visible then
        table.insert(v184, {
            button = u21.ReplaceCT,
            order = u21.ReplaceCT.LayoutOrder
        });
    end;

    if u21.ReplaceT and u21.ReplaceT.Visible then
        table.insert(v184, {
            button = u21.ReplaceT,
            order = u21.ReplaceT.LayoutOrder
        });
    end;

    if u21.Unlock and u21.Unlock.Visible then
        table.insert(v184, {
            button = u21.Unlock,
            order = u21.Unlock.LayoutOrder
        });
    end;

    local QuickUnlock = u21:FindFirstChild("QuickUnlock");

    if QuickUnlock and QuickUnlock.Visible then
        table.insert(v184, {
            button = QuickUnlock,
            order = QuickUnlock.LayoutOrder
        });
    end;

    table.sort(v184, function(p185, p186) -- Line: 1542
        return p185.order < p186.order;
    end);
    local v187 = {};

    for _, v in ipairs(v184) do
        table.insert(v187, v.button);
    end;

    for i, v in ipairs(v187) do
        v.NextSelectionUp = v187[i > 1 and i - 1 or #v187];
        v.NextSelectionDown = v187[i < #v187 and i + 1 or 1];
        v.NextSelectionLeft = nil;
        v.NextSelectionRight = nil;
    end;
end;

function u1.SetupItemNotificationNavigation() -- Line: 1566
    -- upvalues: u23 (ref)
    if not (u23 and u23.Ignore.ItemNotification) then
        return;
    end;

    local Holder = u23.Ignore.ItemNotification.Holder;
    local v188 = {};

    if Holder.ViewLoadout and Holder.ViewLoadout.Visible then
        table.insert(v188, {
            button = Holder.ViewLoadout,
            order = Holder.ViewLoadout.LayoutOrder or 1
        });
    end;

    if Holder.Continue and Holder.Continue.Visible then
        table.insert(v188, {
            button = Holder.Continue,
            order = Holder.Continue.LayoutOrder or 2
        });
    end;

    if #v188 == 0 then
        return;
    end;

    table.sort(v188, function(p189, p190) -- Line: 1587
        return p189.order < p190.order;
    end);

    for i, v in ipairs(v188) do
        local button = v.button;
        button.NextSelectionUp = v188[i > 1 and i - 1 or #v188].button;
        button.NextSelectionDown = v188[i < #v188 and i + 1 or 1].button;
        button.NextSelectionLeft = nil;
        button.NextSelectionRight = nil;
    end;
end;

function u1.SelectFirstItemNotificationButton() -- Line: 1602
    -- upvalues: UserInputService (copy), u23 (ref), GuiService (copy)
    if not UserInputService.GamepadEnabled then
        return;
    end;

    if not (u23 and (u23.Ignore.ItemNotification and u23.Ignore.ItemNotification.Visible)) then
        return;
    end;

    local Holder = u23.Ignore.ItemNotification.Holder;

    if Holder.ViewLoadout and (Holder.ViewLoadout.Visible and Holder.ViewLoadout.Selectable) then
        GuiService.SelectedObject = Holder.ViewLoadout;

        return;
    end;

    if Holder.Continue and (Holder.Continue.Visible and Holder.Continue.Selectable) then
        GuiService.SelectedObject = Holder.Continue;
    end;
end;

function u1.SelectFirstInformationFrameButton() -- Line: 1623
    -- upvalues: u21 (ref), u1 (copy), GuiService (copy)
    if not (u21 and u21.Visible) then
        return;
    end;

    u1.SetupInformationFrameNavigation();

    if u21.Charm and u21.Charm.Visible then
        GuiService.SelectedObject = u21.Charm;

        return;
    end;

    if u21.Inspect and u21.Inspect.Visible then
        GuiService.SelectedObject = u21.Inspect;

        return;
    end;

    if u21.ReplaceCT and u21.ReplaceCT.Visible then
        GuiService.SelectedObject = u21.ReplaceCT;

        return;
    end;

    if u21.ReplaceT and u21.ReplaceT.Visible then
        GuiService.SelectedObject = u21.ReplaceT;

        return;
    end;

    if u21.Unlock and u21.Unlock.Visible then
        GuiService.SelectedObject = u21.Unlock;

        return;
    end;

    local QuickUnlock = u21:FindFirstChild("QuickUnlock");

    if QuickUnlock and QuickUnlock.Visible then
        GuiService.SelectedObject = QuickUnlock;
    end;
end;

function u1.SetupInformationFrame(p191) -- Line: 1652
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u21 (ref), GetWeaponProperties (copy), IsItemEquippedOnTeam (copy)
    Profiler.mark("UI.Inventory.SetupInformationFrame");
    local v192 = DataController.Get(LocalPlayer, "Inventory");

    if v192 then
        local _id = p191._id;

        for _, v in ipairs(v192) do
            if v._id == _id then
                break;
            end;
        end;

        p191 = v or p191;
    end;

    local v193 = p191.Type == "Weapon";
    local v194 = p191.Type == "Melee";
    local v195 = p191.Type == "Glove";
    local v196 = p191.Type == "Badge";
    local v197 = p191.Type == "Zeus x27";
    u21.Inspect.Visible = v193 or (v195 or (v194 or (v197 or (p191.Type == "Charm" and true or v196))));
    u21.Unlock.Visible = p191.Type == "Case" and true or p191.Type == "Package";
    u21.Loadout.Visible = false;
    local QuickUnlock = u21:FindFirstChild("QuickUnlock");

    if QuickUnlock then
        QuickUnlock.Visible = false;
    end;

    local UnlockDivider = u21:FindFirstChild("UnlockDivider");

    if UnlockDivider then
        UnlockDivider.Visible = false;
    end;

    local v198 = v193 or (v197 or p191.Type == "Charm");

    if not u21.Charm then
        warn("[Inventory] InformationFrame.Charm element not found - item type:", p191.Type);
    end;

    if u21.Charm then
        u21.Charm.Visible = v198;
        local v199 = v198 and u21.Charm:FindFirstChildWhichIsA("TextLabel", true);

        if v199 then
            if p191.Type == "Charm" then
                v199.Text = "Attach to Weapon";
            else
                local v200;

                if p191.Charm == nil or p191.Charm == false then
                    v200 = false;
                else
                    v200 = (type(p191.Charm) == "string" or p191.Charm == true) and true or type(p191.Charm) == "table";
                end;

                v199.Text = v200 and "Detach Charm" or "Attach Charm";
            end;
        end;
    end;

    local v201 = false;
    local v202 = false;

    if v193 then
        local success, result = pcall(GetWeaponProperties, p191.Name);

        if success and (result and result.Team) then
            if result.Team == "Both" then
                v201 = true;
                v202 = true;
            elseif result.Team == "Counter-Terrorists" then
                v201 = true;
            elseif result.Team == "Terrorists" then
                v202 = true;
            end;
        end;
    elseif v194 then
        if p191.Name == "CT Knife" then
            v201 = true;
            v202 = false;
        elseif p191.Name == "T Knife" then
            v201 = false;
            v202 = true;
        else
            v201 = true;
            v202 = true;
        end;
    elseif v195 then
        local v203 = GetWeaponProperties(p191.Name);

        if v203 and v203.Team then
            if v203.Team == "Both" then
                v201 = true;
                v202 = true;
            elseif v203.Team == "Counter-Terrorists" then
                v201 = true;
            elseif v203.Team == "Terrorists" then
                v202 = true;
            end;
        end;
    elseif v196 then
        v201 = true;
        v202 = true;
    elseif v197 then
        v201 = true;
        v202 = true;
    end;

    local v204 = IsItemEquippedOnTeam(p191._id, "Counter-Terrorists");
    local v205 = IsItemEquippedOnTeam(p191._id, "Terrorists");
    local v206 = v193 or (v194 or (v195 or (v196 or v197)));

    if u21.ReplaceCT then
        if v206 then
            if v201 then
                v201 = not v204;
            end;
        else
            v201 = v206;
        end;

        u21.ReplaceCT.Visible = v201;
    end;

    if u21.ReplaceT then
        if v206 then
            if v202 then
                v202 = not v205;
            end;
        else
            v202 = v206;
        end;

        u21.ReplaceT.Visible = v202;
    end;

    local v207 = {
        {
            dividerName = "CharmDivider",
            action = u21.Charm
        },
        {
            dividerName = "InspectDivider",
            action = u21.Inspect
        },
        {
            dividerName = "ReplaceCTDivider",
            action = u21.ReplaceCT
        },
        {
            dividerName = "ReplaceTDivider",
            action = u21.ReplaceT
        },
        {
            dividerName = "LoadoutDivider",
            action = u21.Loadout
        }
    };
    local v208 = { "UnlockDivider" };

    for _, v in ipairs(v207) do
        table.insert(v208, v.dividerName);
    end;

    for _, v in ipairs(v207) do
        local v209 = u21:FindFirstChild(v.dividerName);

        if v209 and v.action then
            if v.action.Visible then
                local LayoutOrder = v209.LayoutOrder;
                local v210 = false;

                for _, child in ipairs(u21:GetChildren()) do
                    local v211 = false;

                    for _, v2 in ipairs(v208) do
                        if child.Name == v2 then
                            v211 = true;
                            break;
                        end;
                    end;

                    if not v211 and (child ~= v209 and (child ~= v.action and (child:IsA("Frame") or child:IsA("TextButton")))) and (child.LayoutOrder < LayoutOrder and child.Visible) then
                        v210 = true;
                    end;
                end;

                v209.Visible = v210;
            else
                v209.Visible = false;
            end;
        end;
    end;
end;

function u1.SelectOption(p212, p213) -- Line: 1838
    -- upvalues: u21 (ref), u23 (ref), u3 (copy), u4 (copy), u1 (copy)
    if u21 then
        u21.Visible = false;
    end;

    p212.Frame.BackgroundTransparency = 0;

    for _, child in ipairs(u23.SubButtons:GetChildren()) do
        if child:IsA("TextButton") then
            child.Frame.BackgroundColor3 = u3;
            child:SetAttribute("Selected", nil);

            if child.Name == p213 then
                child.Frame.BackgroundColor3 = u4;
                child:SetAttribute("Selected", true);
            end;
        end;
    end;

    u1.UpdateInventoryFilter();
end;

function u1.ShowNewItemNotification(p214) -- Line: 1861
    -- upvalues: Profiler (copy), u26 (copy), u23 (ref), u1 (copy), u27 (ref), RunServiceController (copy), updateInventoryHeartbeat (copy)
    Profiler.mark("UI.Inventory.ShowNewItemNotification");
    local v215 = false;
    local v216 = 0;

    for i, v in ipairs(u26) do
        if v._id == p214._id then
            v216 = i;
            v215 = true;
            break;
        end;
    end;

    if not v215 then
        table.insert(u26, p214);
        v216 = #u26;
    end;

    u23.Visible = true;
    u1.NextInventoryItem(v216);
    local v217;

    if u23 == nil then
        v217 = false;
    else
        v217 = u23.Visible or #u26 > 0;
    end;

    if not v217 then
        updateInventoryHeartbeat(0);

        return;
    end;

    if u27 then
        return;
    end;

    u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
    updateInventoryHeartbeat(0);
end;

function u1.NextInventoryItem(p218) -- Line: 1888
    -- upvalues: Profiler (copy), u26 (copy), u11 (ref), Cases (copy), GetResolvedSkinInformation (copy), Rarities (copy), GetIconImage (copy), u23 (ref), u28 (ref), Router (copy), u1 (copy), u27 (ref), RunServiceController (copy), updateInventoryHeartbeat (copy)
    Profiler.mark("UI.Inventory.NextInventoryItem");
    local v219 = u26[p218];
    u11 = p218;

    if v219 then
        local v220 = v219.Type == "Case" and true or v219.Type == "Package";
        local v221 = v220 and Cases.GetCaseByName(v219.Skin) or GetResolvedSkinInformation(v219.Name, v219.Skin);
        local v222 = Rarities[v221 and (v220 and v221.caseRarity or v221.rarity) or (v219.Rarity or "Blue")] or Rarities.Blue;
        local v223;

        if v220 and (v221 and v221.Skin) then
            v223 = v221.Skin;
        else
            local Name = v219.Name;
            local v224 = Name and Name:find("Zeus") and "Taser" or Name;

            if v219.StatTrack then
                v224 = "KillTrak™ " .. v224 or v224;
            end;

            v223 = `{v224} | {v219.Skin}`;
        end;

        local v225 = GetIconImage(v219, v221, v220);
        local v226;

        if v219.Type == "Case" then
            v226 = false;
        else
            v226 = v219.Type ~= "Package";
        end;

        u23.Ignore.ItemNotification.Holder.ViewLoadout.Visible = v226;
        u23.Ignore.ItemNotification.Holder.RarityFrame.UIGradient.Color = v222.ColorSequence;
        u23.Ignore.ItemNotification.Holder.Background.ImageColor3 = v222.Color;
        u23.Ignore.ItemNotification.Holder.IconShadow.Image = v225;
        u23.Ignore.ItemNotification.Holder.Light.ImageColor3 = v222.Color;
        u23.Ignore.ItemNotification.Holder.WeaponName.Text = v223;
        u23.Ignore.ItemNotification.Holder.Icon.Image = v225;
        u23.Ignore.ItemNotification.Visible = true;

        if not u28 then
            u28 = true;
            Router.broadcastRouter("RunInterfaceSound", "New Item Reveal");
        end;

        u23.Ignore.ItemNotification.Holder.Title.TextColor3 = Color3.new(v222.Color.R * 0.56, v222.Color.G * 0.56, v222.Color.B * 0.56);
        Profiler.defer("UI.Inventory.ItemNotificationDeferred", function() -- Line: 1945
            -- upvalues: u1 (ref)
            u1.SetupItemNotificationNavigation();
            u1.SelectFirstItemNotificationButton();
        end);
        local v227;

        if u23 == nil then
            v227 = false;
        else
            v227 = u23.Visible or #u26 > 0;
        end;

        if v227 then
            if u27 then
                return;
            end;

            u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
            updateInventoryHeartbeat(0);

            return;
        end;

        updateInventoryHeartbeat(0);
    end;
end;

function u1.SelectCategory(p228) -- Line: 1955
    -- upvalues: Profiler (copy), u21 (ref), Buttons (copy), ReplicatedStorage (copy), u3 (copy), u23 (ref), u1 (copy), ActivateButton (copy), Router (copy)
    Profiler.mark((`UI.Inventory.SelectCategory.{p228}`));

    if u21 then
        u21.Visible = false;
    end;

    local v229 = Buttons[p228];

    if v229 then
        for i, v in pairs(v229) do
            local u230 = ReplicatedStorage.Assets.UI.Inventory.OptionTemplate:Clone();
            u230.Frame.BackgroundColor3 = u3;
            u230.LayoutOrder = v.LayoutOrder;
            u230.Parent = u23.SubButtons;
            u230.Visible = i ~= "Default";
            u230.Frame.TextLabel.Text = i;
            u230.Name = i;

            if v.LayoutOrder == 0 then
                u1.SelectOption(u230, i);
            end;

            ActivateButton(u230);
            u230.Selectable = true;
            u230.MouseButton1Click:Connect(function() -- Line: 2012, Name: handleOptionClick
                -- upvalues: u1 (ref), u230 (copy), i (copy), Router (ref)
                u1.SelectOption(u230, i);
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
            end);
            u230.Activated:Connect(function(p231) -- Line: 2017
                -- upvalues: u1 (ref), u230 (copy), i (copy), Router (ref)
                if p231 and p231.UserInputType == Enum.UserInputType.Gamepad1 then
                    u1.SelectOption(u230, i);
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                end;
            end);
        end;

        return;
    end;

    warn((`[Inventory] Category "{p228}" not found in InventoryButtons`));
end;

function u1.SetupCategoryButton(p232) -- Line: 2027
    -- upvalues: ActivateButton (copy), Router (copy)
    ActivateButton(p232);
    p232.Selectable = true;

    local function handleCategoryClick() -- Line: 2030
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end;

    ActivateButton(p232);
    p232.MouseButton1Click:Connect(handleCategoryClick);
    p232.Activated:Connect(function(p233) -- Line: 2038
        -- upvalues: Router (ref)
        if p233 and p233.UserInputType == Enum.UserInputType.Gamepad1 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end;
    end);
end;

function u1.UpdateHoverFrame(p234) -- Line: 2047
    -- upvalues: u17 (ref), IsMouseOverBlockingUI (copy), u23 (ref), u21 (ref), u9 (ref), u8 (ref), CalculateHoverPosition (copy), Cases (copy), GetResolvedSkinInformation (copy), u29 (copy), GetSkinDisplayName (copy), GetCollectionNameForItem (copy), Collections (copy), DataController (copy), LocalPlayer (copy), ReplicatedStorage (copy), Rarities (copy), Skins (copy), GetWeaponProperties (copy)
    local v235 = tick() - (u17 or 0);
    local v236 = IsMouseOverBlockingUI();

    if not u23.Visible or (v236 or (u21.Visible or (not u9 or (not u8 or v235 <= 0.75)))) then
        u23.Ignore.Hover.Visible = false;

        return;
    end;

    u23.Ignore.Hover.Position = CalculateHoverPosition(u9);
    local v237 = u8;
    local v238 = v237.Type == "Case" and true or v237.Type == "Package";
    local v239 = v238 and Cases.GetCaseByName(v237.Skin) or GetResolvedSkinInformation(v237.Name, v237.Skin);

    if v239 then
        local Name = v237.Name;
        local v240 = Name and Name:find("Zeus") and "Taser" or Name;
        local v241 = v238 and v239.caseType and u29[v239.caseType] or v238 and v239.caseType;

        if v241 then
            v240 = v241;
        elseif v237.StatTrack then
            v240 = "KillTrak™ " .. v240 or v240;
        end;

        local v242 = GetSkinDisplayName(v238 and v239.skin or v237.Skin);
        u23.Ignore.Hover.ItemName.Frame.ItemName.Text = ((v237.Type == "Melee" and "★ " or "") .. v240) .. (v242 == "Vanilla" and "" or (" | " .. v242 or ""));
        local v243 = GetCollectionNameForItem(v237);
        u23.Ignore.Hover.ItemName.Frame.Collection.Text = v243 or "";
        local CollectionIcon = u23.Ignore.Hover.ItemName.CollectionIcon;

        if v243 then
            local v244 = Collections.GetCollectionByName(v243);

            if v244 and v244.imageAssetId then
                CollectionIcon.Image = v244.imageAssetId;
                CollectionIcon.Visible = true;
            else
                CollectionIcon.Visible = false;
            end;
        else
            CollectionIcon.Visible = false;
        end;

        local CollectionName = u23.Ignore.Hover:FindFirstChild("CollectionName");

        if CollectionName then
            if v243 then
                CollectionName.Text = v243 .. ":";
                CollectionName.Visible = true;
            else
                CollectionName.Visible = false;
            end;
        end;

        if v243 and not v238 then
            local v245 = Collections.GetCollectionByName(v243);

            if v245 and v245.items then
                local Collection = u23.Ignore.Hover.Collection;
                local v246 = DataController.Get(LocalPlayer, "Inventory");

                for _, child in ipairs(Collection:GetChildren()) do
                    if child:IsA("Frame") and child.Name ~= "UIListLayout" then
                        child:Destroy();
                    end;
                end;

                local v247 = {};

                if v246 then
                    for _, v in ipairs(v246) do
                        if v.Name and v.Skin then
                            v247[v.Name .. "|" .. v.Skin] = true;
                        end;
                    end;
                end;

                local v248 = {
                    Blue = 1,
                    Purple = 2,
                    Pink = 3,
                    Red = 4,
                    Special = 5,
                    Forbidden = 6,
                    Stock = 7
                };
                local v249 = {};

                for _, v in ipairs(v245.items) do
                    if v.itemName and v.skinName then
                        local v250 = GetResolvedSkinInformation(v.itemName, v.skinName);

                        if v250 then
                            table.insert(v249, {
                                item = v,
                                rarity = v250.rarity,
                                rarityOrder = v248[v250.rarity] or 99
                            });
                        end;
                    end;
                end;

                table.sort(v249, function(p251, p252) -- Line: 2181
                    if p251.rarityOrder == p252.rarityOrder then
                        return p251.item.itemName < p252.item.itemName;
                    end;

                    return p251.rarityOrder < p252.rarityOrder;
                end);
                local CollectionNameTemplate = ReplicatedStorage.Assets.UI.Inventory.CollectionNameTemplate;

                for i, v in ipairs(v249) do
                    local item = v.item;
                    local v253 = GetResolvedSkinInformation(item.itemName, item.skinName);

                    if v253 and CollectionNameTemplate then
                        local v254 = CollectionNameTemplate:Clone();
                        v254.Parent = Collection;
                        v254.LayoutOrder = i;
                        v254.Visible = true;
                        local v255 = v254:FindFirstChild("CollectionName") or v254:FindFirstChild("gun");

                        if v255 then
                            v255.Text = "[" .. item.itemName .. "] | " .. item.skinName;
                            local v256 = v253.rarity and Rarities[v253.rarity];

                            if v256 then
                                v255.TextColor3 = v256.Color;
                            end;

                            v255.Visible = true;
                        end;

                        local ImageLabel = v254:FindFirstChild("ImageLabel");

                        if ImageLabel then
                            ImageLabel.Visible = v247[item.itemName .. "|" .. item.skinName] == true;
                        end;
                    end;
                end;

                if CollectionName then
                    CollectionName.Visible = true;
                end;

                Collection.Visible = true;
                local CollectionSpacer = u23.Ignore.Hover:FindFirstChild("CollectionSpacer");

                if CollectionSpacer then
                    CollectionSpacer.Visible = true;
                end;
            else
                local Collection = u23.Ignore.Hover.Collection;

                if Collection then
                    for _, child in ipairs(Collection:GetChildren()) do
                        if child:IsA("Frame") and child.Name ~= "UIListLayout" then
                            child:Destroy();
                        end;
                    end;

                    Collection.Visible = false;
                end;

                local CollectionName2 = u23.Ignore.Hover:FindFirstChild("CollectionName");

                if CollectionName2 then
                    CollectionName2.Visible = false;
                end;

                local CollectionSpacer = u23.Ignore.Hover:FindFirstChild("CollectionSpacer");

                if CollectionSpacer then
                    CollectionSpacer.Visible = false;
                end;
            end;
        else
            local Collection = u23.Ignore.Hover.Collection;

            if Collection then
                for _, child in ipairs(Collection:GetChildren()) do
                    if child:IsA("Frame") and child.Name ~= "UIListLayout" then
                        child:Destroy();
                    end;
                end;

                Collection.Visible = false;
            end;

            local CollectionName2 = u23.Ignore.Hover:FindFirstChild("CollectionName");

            if CollectionName2 then
                CollectionName2.Visible = false;
            end;

            local CollectionSpacer = u23.Ignore.Hover:FindFirstChild("CollectionSpacer");

            if CollectionSpacer then
                CollectionSpacer.Visible = false;
            end;
        end;

        if v238 or v237.Type ~= "Weapon" and (v237.Type ~= "Melee" and (v237.Type ~= "Glove" and v237.Type ~= "Zeus x27")) then
            if v238 then
                if v239.description then
                    u23.Ignore.Hover.Description.Text = v239.description;
                else
                    u23.Ignore.Hover.Description.Text = "";
                end;
            elseif v239.description then
                u23.Ignore.Hover.Description.Text = v239.description;
            else
                u23.Ignore.Hover.Description.Text = "";
            end;
        else
            local v257 = GetResolvedSkinInformation(v237.Type == "Melee" and "T Knife" or (v237.Type == "Glove" and "T Glove" or v237.Name), "Stock");

            if v257 and v257.description then
                u23.Ignore.Hover.Description.Text = v257.description;
            else
                u23.Ignore.Hover.Description.Text = "";
            end;
        end;

        if v238 or (v237.Type == "Charm Capsule" and true or v237.Type == "Sticker Capsule") then
            u23.Ignore.Hover.Information.Visible = false;
        else
            u23.Ignore.Hover.Information.Visible = true;
        end;

        local v258 = v238 and v239.caseRarity or v239.rarity;

        if v258 then
            local v259 = Rarities[v258];

            if v259 then
                u23.Ignore.Hover.Information.Rarity.Label.Text = ({
                    Blue = "Blue",
                    Purple = "Purple",
                    Pink = "Pink",
                    Red = "Red",
                    Special = "★ Special",
                    Forbidden = "★ Special"
                })[v258] or v258;
                u23.Ignore.Hover.Information.Rarity.Label.TextColor3 = v259.Color;
            else
                u23.Ignore.Hover.Information.Rarity.Label.Text = "";
            end;
        else
            u23.Ignore.Hover.Information.Rarity.Label.Text = "";
        end;

        local Exterior = u23.Ignore.Hover.Information.Exterior;

        if v238 then
            Exterior.Visible = false;
        else
            local v260, v261 = Skins.GetWearNameForFloat(v239, v237.Float or v239.floatRange.max);

            if v260 and v261 then
                Exterior.Label.Text = v261;
                Exterior.Visible = true;
            else
                Exterior.Visible = false;
            end;
        end;

        local Team = u23.Ignore.Hover.Information.Team.Team;

        if (v237.Type == "Melee" or (v237.Type == "Glove" or (v237.Type == "Badge" or v237.Type == "Charm"))) and true or v237.Type == "Zeus x27" then
            Team.CT.Visible = true;
            Team.T.Visible = true;
            Team.Label.Visible = true;
            Team.Label.Text = "Both";
        elseif v237.Type == "Weapon" then
            local v262 = GetWeaponProperties(v237.Name);

            if v262 and v262.Team then
                local Team2 = v262.Team;

                if Team2 == "Counter-Terrorists" then
                    Team.CT.Visible = true;
                    Team.T.Visible = false;
                    Team.Label.Visible = true;
                    Team.Label.Text = "Counter-Terrorists";
                elseif Team2 == "Terrorists" then
                    Team.CT.Visible = false;
                    Team.T.Visible = true;
                    Team.Label.Visible = true;
                    Team.Label.Text = "Terrorists";
                else
                    Team.CT.Visible = true;
                    Team.T.Visible = true;
                    Team.Label.Visible = true;
                    Team.Label.Text = "Both";
                end;
            end;
        end;
    end;

    u23.Ignore.Hover.Visible = true;
end;

function u1.Initialize(p263, p264) -- Line: 2431
    -- upvalues: Profiler (copy), u24 (ref), u23 (ref), u21 (ref), CloseButtonRegistry (copy), Router (copy), u10 (ref), GuiService (copy), Collections (copy), u13 (ref), u7 (ref), ActivateButton (copy), Remotes (copy), UseItemFrame (copy), MenuState (copy), u16 (ref), Cases (copy), Store (copy), ReplaceItemOnTeam (copy), u11 (ref), u1 (copy), u26 (copy), UserInputService (copy), LocalPlayer (copy), u28 (ref), u27 (ref), RunServiceController (copy), updateInventoryHeartbeat (copy), Loadout (copy), u22 (ref), u14 (ref), u15 (ref), u5 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy), AnimateSortButton (copy), GetResolvedSkinInformation (copy), Rarities (copy), GetIconImage (copy), GetWeaponProperties (copy), syncItemTemplateCharmIcon (copy), GetSkinDisplayName (copy), TweenService (copy), u6 (copy), u8 (ref), u9 (ref), u17 (ref), DataController (copy), Sort (copy), u30 (copy), u25 (ref), ContentProvider (copy), SetSearchQuery (copy), u20 (copy), OnScrollPositionChanged (copy)
    Profiler.mark("UI.Inventory.Initialize");
    u24 = p263;
    u23 = p264;
    u21 = p264.Ignore.Information;
    CloseButtonRegistry.Add(u21, nil, function() -- Line: 2437
        -- upvalues: Router (ref), u21 (ref), u10 (ref), GuiService (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u21.Visible = false;

        if u10 and u10:FindFirstChild("Button") then
            local Button = u10:FindFirstChild("Button");

            if Button and Button:IsA("GuiButton") then
                GuiService.SelectedObject = Button;
            end;
        end;
    end);
    Collections.ObserveAvailableCollections(function(p265) -- Line: 2451
        -- upvalues: u13 (ref)
        u13 = p265;
    end);
    u21.Inspect.Selectable = true;

    local function handleInspectClick() -- Line: 2459
        -- upvalues: Router (ref), u7 (ref), u21 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if not u7 then
            return;
        end;

        u21.Visible = false;
        Router.broadcastRouter("WeaponInspect", u7.Name, u7.Skin, u7.Float, u7.StatTrack, u7.NameTag, u7.Charm, u7.Stickers, u7.Type, u7.Pattern, u7._id, u7.Serial, u7.IsTradeable);
    end;

    ActivateButton(u21.Inspect);
    u21.Inspect.MouseButton1Click:Connect(handleInspectClick);
    u21.Inspect.Activated:Connect(function(p266) -- Line: 2485
        -- upvalues: Router (ref), u7 (ref), u21 (ref)
        if not p266 or p266.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if not u7 then
            return;
        end;

        u21.Visible = false;
        Router.broadcastRouter("WeaponInspect", u7.Name, u7.Skin, u7.Float, u7.StatTrack, u7.NameTag, u7.Charm, u7.Stickers, u7.Type, u7.Pattern, u7._id, u7.Serial, u7.IsTradeable);
    end);

    if u21.Charm then
        u21.Charm.Selectable = true;

        local function handleCharmClick() -- Line: 2495
            -- upvalues: Router (ref), u7 (ref), u21 (ref), Remotes (ref), u23 (ref), UseItemFrame (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u7 then
                local v267;

                if u7.Charm == nil or u7.Charm == false then
                    v267 = false;
                else
                    v267 = (type(u7.Charm) == "string" or u7.Charm == true) and true or type(u7.Charm) == "table";
                end;

                u21.Visible = false;

                if v267 then
                    Remotes.Inventory.RemoveWeaponCharm.Send({
                        WeaponId = u7._id
                    });

                    return;
                end;

                u23.Visible = false;
                UseItemFrame.TriggerAction("AttachCharm", u7);
            end;
        end;

        u21.Charm.MouseButton1Click:Connect(handleCharmClick);
        u21.Charm.Activated:Connect(function(p268) -- Line: 2515
            -- upvalues: handleCharmClick (copy)
            if p268 and p268.UserInputType == Enum.UserInputType.Gamepad1 then
                handleCharmClick();
            end;
        end);
    end;

    UseItemFrame.OnItemSelected:Connect(function(p269, p270) -- Line: 2523
        -- upvalues: UseItemFrame (ref)
        local v271 = UseItemFrame.GetActions().Get(p270.ActionType);

        if v271 then
            v271.OnItemSelected(p269, p270);
        end;
    end);
    UseItemFrame.OnClosed:Connect(function(p272) -- Line: 2532
        -- upvalues: MenuState (ref), u23 (ref)
        if MenuState.GetCurrentScreen() == "Inventory" then
            u23.Visible = true;
        end;
    end);
    u21.Unlock.Selectable = true;
    u21.Unlock.MouseButton1Click:Connect(function() -- Line: 2543, Name: handleUnlockClick
        -- upvalues: u16 (ref), Router (ref), u7 (ref), Cases (ref), Store (ref), u21 (ref), u23 (ref)
        if u16 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if not u7 then
            return;
        end;

        local v273 = Cases.GetCaseByName(u7.Skin);
        Store.OpenCaseContent(v273.caseId, "Open", u7._id);
        u21.Visible = false;
        u23.Visible = false;
    end);
    u21.Unlock.Activated:Connect(function(p274) -- Line: 2560
        -- upvalues: u16 (ref), Router (ref), u7 (ref), Cases (ref), Store (ref), u21 (ref), u23 (ref)
        if p274 and p274.UserInputType == Enum.UserInputType.Gamepad1 then
            if u16 then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u7 then
                local v275 = Cases.GetCaseByName(u7.Skin);
                Store.OpenCaseContent(v275.caseId, "Open", u7._id);
                u21.Visible = false;
                u23.Visible = false;
            end;
        end;
    end);

    if u21.ReplaceT then
        u21.ReplaceT.Selectable = true;
        u21.ReplaceT.MouseButton1Click:Connect(function() -- Line: 2639, Name: handleReplaceTClick
            -- upvalues: Router (ref), u7 (ref), u21 (ref), ReplaceItemOnTeam (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u7 then
                u21.Visible = false;
                ReplaceItemOnTeam(u7, "Terrorists");
            end;
        end);
        u21.ReplaceT.Activated:Connect(function(p276) -- Line: 2647
            -- upvalues: Router (ref), u7 (ref), u21 (ref), ReplaceItemOnTeam (ref)
            if p276 and p276.UserInputType == Enum.UserInputType.Gamepad1 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if u7 then
                    u21.Visible = false;
                    ReplaceItemOnTeam(u7, "Terrorists");
                end;
            end;
        end);
    end;

    if u21.ReplaceCT then
        u21.ReplaceCT.Selectable = true;
        u21.ReplaceCT.MouseButton1Click:Connect(function() -- Line: 2657, Name: handleReplaceCTClick
            -- upvalues: Router (ref), u7 (ref), u21 (ref), ReplaceItemOnTeam (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");

            if u7 then
                u21.Visible = false;
                ReplaceItemOnTeam(u7, "Counter-Terrorists");
            end;
        end);
        u21.ReplaceCT.Activated:Connect(function(p277) -- Line: 2665
            -- upvalues: Router (ref), u7 (ref), u21 (ref), ReplaceItemOnTeam (ref)
            if p277 and p277.UserInputType == Enum.UserInputType.Gamepad1 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if u7 then
                    u21.Visible = false;
                    ReplaceItemOnTeam(u7, "Counter-Terrorists");
                end;
            end;
        end);
    end;

    u23.Ignore.ItemNotification.Holder.Left.MouseButton1Click:Connect(function() -- Line: 2673
        -- upvalues: Router (ref), u11 (ref), u1 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if u11 <= 0 then
            return;
        end;

        u1.NextInventoryItem(u11 - 1);
    end);
    u23.Ignore.ItemNotification.Holder.Right.MouseButton1Click:Connect(function() -- Line: 2682
        -- upvalues: Router (ref), u11 (ref), u26 (ref), u1 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if u11 > #u26 then
            return;
        end;

        u1.NextInventoryItem(u11 + 1);
    end);
    UserInputService.InputBegan:Connect(function(p278, p279) -- Line: 2691
        -- upvalues: LocalPlayer (ref), UserInputService (ref), u23 (ref), u11 (ref), Router (ref), u1 (ref), u26 (ref)
        if p279 then
            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if UserInputService:GetFocusedTextBox() then
            return;
        end;

        if not (u23 and (u23.Ignore.ItemNotification and u23.Ignore.ItemNotification.Visible)) then
            return;
        end;

        if p278.KeyCode == Enum.KeyCode.Left then
            if u11 > 1 then
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u1.NextInventoryItem(u11 - 1);
            end;

            return;
        end;

        if p278.KeyCode ~= Enum.KeyCode.Right then
            return;
        end;

        if u11 < #u26 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.NextInventoryItem(u11 + 1);
        end;
    end);
    u23.Ignore.ItemNotification.Holder.Continue.Selectable = true;
    u23.Ignore.ItemNotification.Holder.ViewLoadout.Selectable = true;
    u23.Ignore.ItemNotification.Holder.Continue.MouseButton1Click:Connect(function() -- Line: 2731, Name: handleContinueClick
        -- upvalues: Router (ref), u23 (ref), u11 (ref), u26 (ref), u28 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u23.Ignore.ItemNotification.Visible = false;
        u11 = 0;
        table.clear(u26);
        u28 = false;
        local v280;

        if u23 == nil then
            v280 = false;
        else
            v280 = u23.Visible or #u26 > 0;
        end;

        if not v280 then
            updateInventoryHeartbeat(0);

            return;
        end;

        if u27 then
            return;
        end;

        u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
        updateInventoryHeartbeat(0);
    end);
    u23.Ignore.ItemNotification.Holder.Continue.Activated:Connect(function(p281) -- Line: 2741
        -- upvalues: Router (ref), u23 (ref), u11 (ref), u26 (ref), u28 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref)
        if p281 and p281.UserInputType == Enum.UserInputType.Gamepad1 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u23.Ignore.ItemNotification.Visible = false;
            u11 = 0;
            table.clear(u26);
            u28 = false;
            local v282;

            if u23 == nil then
                v282 = false;
            else
                v282 = u23.Visible or #u26 > 0;
            end;

            if v282 then
                if u27 then
                    return;
                end;

                u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
                updateInventoryHeartbeat(0);

                return;
            end;

            updateInventoryHeartbeat(0);
        end;
    end);

    local function handleViewLoadoutClick() -- Line: 2748
        -- upvalues: u26 (ref), u11 (ref), Router (ref), u23 (ref), u28 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref), Loadout (ref)
        local v283 = u26[u11];
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u23.Ignore.ItemNotification.Visible = false;
        u11 = 0;
        table.clear(u26);
        u28 = false;
        local v284;

        if u23 == nil then
            v284 = false;
        else
            v284 = u23.Visible or #u26 > 0;
        end;

        if v284 then
            if not u27 then
                u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
                updateInventoryHeartbeat(0);
            end;
        else
            updateInventoryHeartbeat(0);
        end;

        if not v283 or v283.Type ~= "Melee" and (v283.Type ~= "Glove" and (v283.Type ~= "Weapon" and v283.Type ~= "Zeus x27")) then
            return;
        end;

        u23.Visible = false;
        Loadout.ViewInLoadout(v283._id);
    end;

    u23.Ignore.ItemNotification.Holder.ViewLoadout.MouseButton1Click:Connect(handleViewLoadoutClick);
    u23.Ignore.ItemNotification.Holder.ViewLoadout.Activated:Connect(function(p285) -- Line: 2778
        -- upvalues: handleViewLoadoutClick (copy)
        if not p285 or p285.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        handleViewLoadoutClick();
    end);
    local Weapon = u23.Frame.Right.Top.Weapon;
    local Click = Weapon.Click;
    local DropdownContent = Weapon.DropdownContent;
    u22 = DropdownContent;
    Weapon.Active = false;
    Click.Selectable = true;
    local v286 = u22;

    if v286 then
        v286.Visible = false;
        v286.Active = false;
        local Scroll = v286:FindFirstChild("Scroll");

        if Scroll and Scroll:IsA("GuiObject") then
            Scroll.Visible = false;
            Scroll.Active = false;
        end;
    end;

    Click.Activated:Connect(function() -- Line: 2794, Name: handleSortButtonClick
        -- upvalues: DropdownContent (copy), u22 (ref), Router (ref)
        local v287 = not DropdownContent.Visible;
        local v288 = u22;

        if v288 then
            v288.Visible = v287;
            v288.Active = v287;
            local Scroll = v288:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = v287;
                Scroll.Active = v287;
            end;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);

    local function GetInitialSortOption() -- Line: 2800
        -- upvalues: u14 (ref), Click (copy), DropdownContent (copy)
        local v289 = DropdownContent.Scroll:FindFirstChild(u14 or Click.Frame.TextLabel.Text or "Newest");

        if v289 and (v289:IsA("GuiButton") and v289.Selectable) then
            return v289;
        end;

        for _, child in ipairs(DropdownContent.Scroll:GetChildren()) do
            if child:IsA("GuiButton") and child.Selectable then
                return child;
            end;
        end;

        return nil;
    end;

    DropdownContent:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2814
        -- upvalues: GuiService (ref), DropdownContent (copy), GetInitialSortOption (copy), Profiler (ref), Click (copy)
        if GuiService.SelectedObject == nil then
            return;
        end;

        if DropdownContent.Visible then
            local u290 = GetInitialSortOption();

            if u290 then
                Profiler.defer("UI.Inventory.SortFocusDeferred", function() -- Line: 2821
                    -- upvalues: DropdownContent (ref), GuiService (ref), u290 (copy)
                    if DropdownContent.Visible then
                        GuiService.SelectedObject = u290;
                    end;
                end);
            end;
        else
            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject and SelectedObject:IsDescendantOf(DropdownContent.Scroll) then
                GuiService.SelectedObject = Click;
            end;
        end;
    end);
    local ReverseSort = u23.Frame.Right.Top.Weapon.Container.Left.ReverseSort;

    local function handleReverseSortButtonClick() -- Line: 2839
        -- upvalues: u15 (ref), ReverseSort (copy), Profiler (ref), u23 (ref), u5 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), Router (ref)
        u15 = not u15;
        ReverseSort.Rotation = u15 and 180 or 0;
        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if u23 and u23.Visible then
            u5 = GetSortedInventoryData();
            u5 = ApplyFilterToSortedData(u5);
            UpdateInventoryTemplates();
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end;

    ReverseSort.Selectable = true;
    ReverseSort.Activated:Connect(handleReverseSortButtonClick);

    for _, v in { "Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float" } do
        local v291 = DropdownContent.Scroll:FindFirstChild(v);

        if v291 then
            AnimateSortButton(DropdownContent.Scroll, v291, v, Weapon.Container.Left.Title, function() -- Line: 2863
                -- upvalues: u22 (ref)
                local v292 = u22;

                if not v292 then
                    return;
                end;

                v292.Visible = false;
                v292.Active = false;
                local Scroll = v292:FindFirstChild("Scroll");

                if Scroll and Scroll:IsA("GuiObject") then
                    Scroll.Visible = false;
                    Scroll.Active = false;
                end;
            end);
        end;
    end;

    local Title = u23.Frame.Right.Top.Search.Container.Title;
    local Search = u23.Frame.Right.Top.Search;
    Search.MouseButton1Click:Connect(function() -- Line: 2881
        -- upvalues: Title (copy)
        Title:CaptureFocus();
    end);
    Search.Activated:Connect(function() -- Line: 2884
        -- upvalues: Title (copy)
        Title:CaptureFocus();
    end);
    local TradeUp = u23.Frame.Right.Top.TradeUp;
    local TradeUp2 = u23.Frame.TradeUp;
    local u293 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local Container = TradeUp2.TradeContainer.Container;
    local ItemTemplate = Container.ItemTemplate;
    local Exchange = TradeUp2.TradeContainer.Exchange;
    local ItemTemplate2 = Exchange.ItemTemplate;
    local AddTemplate = Exchange.AddTemplate;
    ItemTemplate.Visible = false;
    ItemTemplate2.Visible = false;
    AddTemplate.Visible = false;
    local u294 = {
        Blue = "Purple",
        Purple = "Pink",
        Pink = "Red"
    };
    local u295 = {
        Blue = true,
        Purple = true,
        Pink = true
    };
    local u296 = { "Alphabetical", "Collection", "Equipped", "Newest", "Quality", "Type", "Float" };

    for _, v in { ItemTemplate, ItemTemplate2, AddTemplate } do
        for _, descendant in ipairs(v:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                descendant.Active = false;

                if descendant:IsA("GuiButton") then
                    descendant.Interactable = false;
                    descendant.Selectable = false;
                end;
            end;
        end;

        if not v:FindFirstChildOfClass("UIScale") then
            Instance.new("UIScale").Parent = v;
        end;
    end;

    for _, v in { ItemTemplate, ItemTemplate2 } do
        local Context = v:FindFirstChild("Context");

        if Context and Context:IsA("GuiObject") then
            Context.Visible = false;
        end;
    end;

    for _, v in { Container, Exchange } do
        local v297 = v:FindFirstChildOfClass("UIGridLayout");

        if v297 then
            v297.SortOrder = Enum.SortOrder.LayoutOrder;
        end;
    end;

    local u298 = nil;

    for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
        if child.Name == "WarningForTradeUp" then
            local Container2 = child:FindFirstChild("Container");
            local v299 = Container2 and Container2:FindFirstChild("Left");

            if v299 then
                v299 = v299:FindFirstChild("Title");
            end;

            if v299 and (v299:IsA("TextLabel") and string.find(v299.Text, "Selected For Exchange", 1, true)) then
                u298 = v299;
                break;
            end;
        end;
    end;

    local u300 = "Newest";
    local u301 = false;
    local u302 = {};
    local u303 = {};
    local u304 = nil;
    local u305 = nil;
    local u306 = nil;

    local function tradeUpMatchesSearch(p307) -- Line: 2983
        -- upvalues: u302 (copy)
        if #u302 == 0 then
            return true;
        end;

        local v308 = string.lower((p307.Name or "") .. " " .. (p307.Skin or ""));

        if string.find(v308, "zeus", 1, true) then
            v308 = v308 .. " taser";
        end;

        for _, v in ipairs(u302) do
            if string.find(v308, v, 1, true) == nil then
                return false;
            end;
        end;

        return true;
    end;

    local u309 = {};
    Collections.ObserveAvailableCollections(function() -- Line: 3002
        -- upvalues: u309 (copy)
        table.clear(u309);
    end);

    local function collectionHasNextTier(p310, p311) -- Line: 3005
        -- upvalues: u294 (copy), u13 (ref), u309 (copy), GetResolvedSkinInformation (ref)
        if not p310 or p310 == "" then
            return false;
        end;

        local v312 = u294[p311];

        if not v312 then
            return false;
        end;

        if not u13 then
            return false;
        end;

        local v313 = p310 .. "|" .. v312;
        local v314 = u309[v313];

        if v314 ~= nil then
            return v314;
        end;

        local v315 = false;

        for _, v in ipairs(u13) do
            if v.name == p310 then
                for _, v2 in ipairs(v.items or {}) do
                    local v316 = GetResolvedSkinInformation(v2.itemName, v2.skinName);

                    if v316 and v316.rarity == v312 then
                        v315 = true;
                        break;
                    end;
                end;

                break;
            end;
        end;

        u309[v313] = v315;

        return v315;
    end;

    local u317 = {};

    local function getEligibleTradeUpInfo(p318) -- Line: 3043
        -- upvalues: u317 (copy), GetResolvedSkinInformation (ref), u295 (copy), collectionHasNextTier (copy)
        if p318.Type ~= "Weapon" and p318.Type ~= "Zeus x27" then
            return nil;
        end;

        local v319 = (p318.Name or "") .. "|" .. (p318.Skin or "");
        local v320 = u317[v319];

        if v320 == nil then
            v320 = GetResolvedSkinInformation(p318.Name, p318.Skin);

            if v320 then
                u317[v319] = v320;
            end;
        end;

        if not v320 then
            return nil;
        end;

        local rarity = v320.rarity;

        if not (rarity and u295[rarity]) then
            return nil;
        end;

        if collectionHasNextTier(v320.collection, rarity) then
            return v320;
        end;

        return nil;
    end;

    local function getTradeUpKey(p321, p322) -- Line: 3073
        return tostring(p322.rarity) .. "|" .. (p321.StatTrack and "ST" or "N");
    end;

    local function isTradeUpSelected(p323) -- Line: 3077
        -- upvalues: u303 (copy)
        return table.find(u303, p323) ~= nil;
    end;

    local function updateTradeUpWarning() -- Line: 3081
        -- upvalues: u298 (ref), u303 (copy)
        if u298 then
            u298.Text = `{#u303}/{10} Selected For Exchange`;
        end;
    end;

    local function clearRenderedItems(p324, p325) -- Line: 3088
        for _, child in ipairs(p324:GetChildren()) do
            if child:IsA("GuiObject") and child ~= p325 then
                child:Destroy();
            end;
        end;
    end;

    local function buildTradeUpFrame(p326, p327, u328, p329, u330) -- Line: 3097
        -- upvalues: Rarities (ref), GetIconImage (ref), GetWeaponProperties (ref), syncItemTemplateCharmIcon (ref), GetSkinDisplayName (ref), Router (ref), TweenService (ref), u293 (copy), u6 (ref), u8 (ref), u9 (ref), u17 (ref)
        local v331 = Rarities[p329.rarity];
        local u332 = p326:Clone();
        u332.Name = u328._id;
        u332.Parent = p327;
        u332.Visible = true;
        u332.Selectable = true;
        u332.ItemContent.Rarity.BackgroundColor3 = v331.Color;
        u332.ItemContent.Content.Icon.Image = GetIconImage(u328, p329, false);
        local v333 = GetWeaponProperties(u328.Name);

        if v333 and v333.InventoryIconData then
            u332.ItemContent.Content.Icon.ScaleType = v333.InventoryIconData.ScaleType or u332.ItemContent.Content.Icon.ScaleType;
            u332.ItemContent.Content.Icon.Size = v333.InventoryIconData.Size or u332.ItemContent.Content.Icon.Size;
        end;

        syncItemTemplateCharmIcon(u332, u328);
        local Name = u328.Name;
        local v334 = Name and Name:find("Zeus") and "Taser" or Name;

        if u328.StatTrack then
            v334 = "KillTrak™ " .. v334 or v334;
        end;

        u332.Bottom.Footer.WeaponName.Text = v334;
        u332.Bottom.Footer.SkinName.Text = GetSkinDisplayName(u328.Skin or "");
        local Context = u332:FindFirstChild("Context");
        local Inspect = u332.ItemContent:FindFirstChild("Inspect");

        if Inspect then
            Inspect.Visible = true;
            Inspect.Active = true;
            Inspect.Interactable = true;
            Inspect.MouseButton1Click:Connect(function() -- Line: 3148
                -- upvalues: Router (ref), u328 (copy)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                Router.broadcastRouter("WeaponInspect", u328.Name, u328.Skin, u328.Float, u328.StatTrack, u328.NameTag, u328.Charm, u328.Stickers, u328.Type, u328.Pattern, u328._id, u328.Serial, u328.IsTradeable);
            end);
        end;

        local u335 = u332:FindFirstChildOfClass("UIScale");
        u332.MouseEnter:Connect(function() -- Line: 3172
            -- upvalues: Context (copy), Router (ref), TweenService (ref), u335 (copy), u293 (ref), u6 (ref), u8 (ref), u328 (copy), u9 (ref), u332 (copy), u17 (ref)
            if Context then
                Context.Visible = true;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
            TweenService:Create(u335, u293, {
                Scale = 0.95
            }):Play();

            if u6 then
                u8 = u328;
                u9 = u332;
                u17 = tick();
            end;
        end);
        u332.MouseLeave:Connect(function() -- Line: 3185
            -- upvalues: Context (copy), TweenService (ref), u335 (copy), u293 (ref), u6 (ref), u9 (ref), u332 (copy), u8 (ref), u17 (ref)
            if Context then
                Context.Visible = false;
            end;

            TweenService:Create(u335, u293, {
                Scale = 1
            }):Play();

            if u6 and u9 == u332 then
                u9 = nil;
                u8 = nil;
                u17 = nil;
            end;
        end);
        u332.SelectionGained:Connect(function() -- Line: 3196
            -- upvalues: Context (copy)
            if Context then
                Context.Visible = true;
            end;
        end);
        u332.SelectionLost:Connect(function() -- Line: 3201
            -- upvalues: Context (copy)
            if Context then
                Context.Visible = false;
            end;
        end);
        u332.MouseButton1Down:Connect(function() -- Line: 3206
            -- upvalues: TweenService (ref), u335 (copy), u293 (ref)
            TweenService:Create(u335, u293, {
                Scale = 0.9
            }):Play();
        end);
        u332.MouseButton1Up:Connect(function() -- Line: 3209
            -- upvalues: TweenService (ref), u335 (copy), u293 (ref)
            TweenService:Create(u335, u293, {
                Scale = 0.95
            }):Play();
        end);
        u332.MouseButton1Click:Connect(function() -- Line: 3215
            -- upvalues: u330 (copy)
            u330();
        end);
        u332.Activated:Connect(function(p336) -- Line: 3218
            -- upvalues: u330 (copy)
            if p336 and p336.UserInputType == Enum.UserInputType.Gamepad1 then
                u330();
            end;
        end);

        return u332;
    end;

    local u337 = {};
    local u338 = 0;
    local u339 = 0;
    local u340 = 0;

    local function renderNextTradeUpBatch(p341) -- Line: 3238
        -- upvalues: u338 (ref), u337 (copy), buildTradeUpFrame (copy), ItemTemplate (copy), Container (copy), u305 (ref), u339 (ref)
        local v342 = math.min(u338 + p341, #u337);

        for i = u338 + 1, v342 do
            local u343 = u337[i];
            local v344 = buildTradeUpFrame(ItemTemplate, Container, u343.item, u343.info, function() -- Line: 3243
                -- upvalues: u305 (ref), u343 (copy)
                u305(u343.item, u343.info);
            end);
            u339 = u339 + 1;
            v344.LayoutOrder = u339;
        end;

        u338 = v342;
    end;

    local function renderTradeUpContainer() -- Line: 3255
        -- upvalues: u340 (ref), clearRenderedItems (copy), Container (copy), ItemTemplate (copy), u337 (copy), u338 (ref), u339 (ref), DataController (ref), LocalPlayer (ref), u303 (copy), getEligibleTradeUpInfo (copy), u304 (ref), tradeUpMatchesSearch (copy), Sort (ref), u300 (ref), u13 (ref), u301 (ref), renderNextTradeUpBatch (copy), TradeUp2 (copy)
        u340 = u340 + 1;
        local u345 = u340;
        clearRenderedItems(Container, ItemTemplate);
        table.clear(u337);
        u338 = 0;
        u339 = 0;
        local v346 = DataController.Get(LocalPlayer, "Inventory");

        if not v346 then
            return;
        end;

        for _, v in ipairs(v346) do
            if v and v._id and table.find(u303, v._id) == nil then
                local v347 = getEligibleTradeUpInfo(v);

                if v347 and ((u304 == nil or tostring(v347.rarity) .. "|" .. (v.StatTrack and "ST" or "N") == u304) and tradeUpMatchesSearch(v)) then
                    table.insert(u337, {
                        item = v,
                        info = v347
                    });
                end;
            end;
        end;

        local u348 = Sort.GetSortComparisonFunction(u300, LocalPlayer, function() -- Line: 3283
            -- upvalues: u13 (ref)
            return u13;
        end);

        if u348 then
            table.sort(u337, function(p349, p350) -- Line: 3287
                -- upvalues: u301 (ref), u348 (copy)
                if not u301 then
                    return u348(p349.item, p350.item);
                end;

                local v351, v352 = u348(p349.item, p350.item);

                if v352 then
                    return v351;
                end;

                return u348(p350.item, p349.item);
            end);
        end;

        renderNextTradeUpBatch(25);

        if #u337 > 25 then
            task.defer(function() -- Line: 3303
                -- upvalues: u345 (copy), u340 (ref), TradeUp2 (ref), renderNextTradeUpBatch (ref)
                if u345 == u340 and TradeUp2.Visible then
                    renderNextTradeUpBatch(25);
                end;
            end);
        end;
    end;

    Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 3312
        -- upvalues: TradeUp2 (copy), u338 (ref), u337 (copy), Container (copy), renderNextTradeUpBatch (copy)
        if not TradeUp2.Visible or u338 >= #u337 then
            return;
        end;

        local v353 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y;

        if v353 > 0 and v353 - Container.CanvasPosition.Y < 200 then
            renderNextTradeUpBatch(25);
        end;
    end);
    local u354 = {};
    local u355 = {};

    for i = 1, 10 do
        local v356 = AddTemplate:Clone();
        v356.Name = `AddSlot{i}`;
        v356.Visible = true;
        v356.LayoutOrder = i + 100;
        v356.Active = false;
        v356.Interactable = false;
        v356.Selectable = false;
        v356.Parent = Exchange;
        u354[i] = v356;
        u355[v356] = true;
    end;

    local function updateExchangePlaceholders() -- Line: 3340
        -- upvalues: u303 (copy), u354 (copy)
        local v357 = #u303;

        for i, v in ipairs(u354) do
            v.Visible = v357 < i;
        end;
    end;

    local function appendExchangeFrame(p358, p359, p360) -- Line: 3348
        -- upvalues: buildTradeUpFrame (copy), ItemTemplate2 (copy), Exchange (copy), u306 (ref)
        local _id = p358._id;
        buildTradeUpFrame(ItemTemplate2, Exchange, p358, p359, function() -- Line: 3350
            -- upvalues: u306 (ref), _id (copy)
            u306(_id);
        end).LayoutOrder = p360;
    end;

    local function renderTradeUpExchange() -- Line: 3358
        -- upvalues: Exchange (copy), ItemTemplate2 (copy), AddTemplate (copy), u355 (copy), DataController (ref), LocalPlayer (ref), u303 (copy), getEligibleTradeUpInfo (copy), buildTradeUpFrame (copy), u306 (ref), u354 (copy)
        for _, child in ipairs(Exchange:GetChildren()) do
            if child:IsA("GuiObject") and (child ~= ItemTemplate2 and (child ~= AddTemplate and not u355[child])) then
                child:Destroy();
            end;
        end;

        local v361 = DataController.Get(LocalPlayer, "Inventory");

        if v361 and #u303 > 0 then
            local v362 = {};

            for _, v in ipairs(v361) do
                if v and v._id then
                    v362[v._id] = v;
                end;
            end;

            local v363 = 0;

            for _, v in ipairs(u303) do
                local v364 = v362[v];
                local v365;

                if v364 then
                    v365 = getEligibleTradeUpInfo(v364);
                else
                    v365 = v364;
                end;

                if v365 then
                    v363 = v363 + 1;
                    local _id = v364._id;
                    buildTradeUpFrame(ItemTemplate2, Exchange, v364, v365, function() -- Line: 3350
                        -- upvalues: u306 (ref), _id (copy)
                        u306(_id);
                    end).LayoutOrder = v363;
                end;
            end;
        end;

        local v366 = #u303;

        for i, v in ipairs(u354) do
            v.Visible = v366 < i;
        end;
    end;

    local function renderTradeUp() -- Line: 3394
        -- upvalues: renderTradeUpContainer (copy), renderTradeUpExchange (copy), u298 (ref), u303 (copy)
        renderTradeUpContainer();
        renderTradeUpExchange();

        if u298 then
            u298.Text = `{#u303}/{10} Selected For Exchange`;
        end;
    end;

    u305 = function(p367, p368) -- Line: 3400, Name: selectTradeUpItem
        -- upvalues: Router (ref), u303 (copy), u304 (ref), renderTradeUpContainer (copy), u337 (copy), u338 (ref), Container (copy), renderNextTradeUpBatch (copy), buildTradeUpFrame (copy), ItemTemplate2 (copy), Exchange (copy), u306 (ref), u354 (copy), u298 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if #u303 >= 10 or table.find(u303, p367._id) ~= nil then
            return;
        end;

        local v369 = tostring(p368.rarity) .. "|" .. (p367.StatTrack and "ST" or "N");

        if u304 and v369 ~= u304 then
            return;
        end;

        local v370 = #u303 == 0;

        if v370 then
            u304 = v369;
        end;

        table.insert(u303, p367._id);

        if v370 then
            renderTradeUpContainer();
        else
            for i, v in ipairs(u337) do
                if v.item._id == p367._id then
                    table.remove(u337, i);

                    if i <= u338 then
                        u338 = u338 - 1;
                        local v371 = Container:FindFirstChild(p367._id);

                        if v371 then
                            v371:Destroy();
                        end;
                    end;

                    break;
                end;
            end;

            if u338 < 50 and u338 < #u337 then
                renderNextTradeUpBatch(50 - u338);
            end;
        end;

        local _id = p367._id;
        buildTradeUpFrame(ItemTemplate2, Exchange, p367, p368, function() -- Line: 3350
            -- upvalues: u306 (ref), _id (copy)
            u306(_id);
        end).LayoutOrder = #u303;
        local v372 = #u303;

        for i, v in ipairs(u354) do
            v.Visible = v372 < i;
        end;

        if u298 then
            u298.Text = `{#u303}/{10} Selected For Exchange`;
        end;
    end;

    u306 = function(p373) -- Line: 3449, Name: deselectTradeUpItem
        -- upvalues: Router (ref), u303 (copy), u304 (ref), renderTradeUpContainer (copy), Exchange (copy), u355 (copy), u354 (copy), u298 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local v374 = table.find(u303, p373);

        if not v374 then
            return;
        end;

        table.remove(u303, v374);

        if #u303 == 0 then
            u304 = nil;
        end;

        renderTradeUpContainer();
        local v375 = Exchange:FindFirstChild(p373);

        if v375 and not u355[v375] then
            v375:Destroy();
        end;

        for i, v in ipairs(u303) do
            local v376 = Exchange:FindFirstChild(v);

            if v376 then
                v376.LayoutOrder = i;
            end;
        end;

        local v377 = #u303;

        for i, v in ipairs(u354) do
            v.Visible = v377 < i;
        end;

        if u298 then
            u298.Text = `{#u303}/{10} Selected For Exchange`;
        end;
    end;

    local function clearTradeUpSelection() -- Line: 3479
        -- upvalues: u303 (copy), u304 (ref)
        table.clear(u303);
        u304 = nil;
    end;

    local u378 = false;
    local u379 = false;
    local u380 = nil;
    local u381 = 0;
    local u382 = nil;
    local u383 = false;
    local u384 = false;
    local u385 = false;
    local Title2 = TradeUp2.Options.Proceed.Container.Title;
    local Text = Title2.Text;
    local Position = TradeUp2.Options.Cancel.Position;
    local Position2 = TradeUp2.Options.Proceed.Position;
    local u386 = UDim2.new(0.405, 0, Position.Y.Scale, Position.Y.Offset);
    local u387 = UDim2.new(0.595, 0, Position2.Y.Scale, Position2.Y.Offset);
    local u388 = UDim2.new(0.5, 0, Position2.Y.Scale, Position2.Y.Offset);
    local Frame = TradeUp2.TradeContainer.Contract.Frame;
    local Position3 = Frame.Position;
    local u389 = UDim2.new(Position3.X.Scale, Position3.X.Offset, 1.5, 0);
    local u390 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local u391 = Color3.fromRGB(49, 75, 114);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "DrawingCanvas";
    Frame2.BackgroundTransparency = 1;
    Frame2.AnchorPoint = Vector2.new(Frame.AnchorPoint.X, 0);
    Frame2.Position = UDim2.new(Position3.X.Scale, Position3.X.Offset, 0, 0);
    Frame2.Size = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 1, 0);
    Frame2.ClipsDescendants = true;
    Frame2.ZIndex = 10;
    Frame2.Active = true;
    Frame2.Parent = TradeUp2.TradeContainer.Contract;
    local u392 = 0;
    local u393 = false;
    local u394 = nil;

    local function clearContractDrawing() -- Line: 3546
        -- upvalues: u393 (ref), u394 (ref), u392 (ref), Frame2 (copy)
        u393 = false;
        u394 = nil;
        u392 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;
    end;

    local function toContractCanvasPoint(p395) -- Line: 3557
        -- upvalues: Frame2 (copy)
        local AbsolutePosition = Frame2.AbsolutePosition;
        local AbsoluteSize = Frame2.AbsoluteSize;

        return Vector2.new(math.clamp(p395.X - AbsolutePosition.X, 0, AbsoluteSize.X), (math.clamp(p395.Y - AbsolutePosition.Y, 0, AbsoluteSize.Y)));
    end;

    local function createContractInkFrame() -- Line: 3566
        -- upvalues: u391 (copy)
        local Frame3 = Instance.new("Frame");
        Frame3.BackgroundColor3 = u391;
        Frame3.BorderSizePixel = 0;
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame3.ZIndex = 10;

        return Frame3;
    end;

    local function addContractDrawPoint(p396) -- Line: 3578
        -- upvalues: u392 (ref), u394 (ref), u391 (copy), Frame2 (copy)
        if u392 >= 2500 then
            return;
        end;

        local v397 = u394;

        if v397 and (p396 - v397).Magnitude < 2 then
            return;
        end;

        u392 = u392 + 1;
        local Frame3 = Instance.new("Frame");
        Frame3.BackgroundColor3 = u391;
        Frame3.BorderSizePixel = 0;
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame3.ZIndex = 10;
        Frame3.Position = UDim2.fromOffset(p396.X, p396.Y);
        Frame3.Size = UDim2.fromScale(0.01, 0.01);
        Frame3.Parent = Frame2;

        if v397 then
            local v398 = p396 - v397;
            local v399 = (p396 + v397) / 2;
            local Frame4 = Instance.new("Frame");
            Frame4.BackgroundColor3 = u391;
            Frame4.BorderSizePixel = 0;
            Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
            Frame4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
            Frame4.ZIndex = 10;
            Frame4.Position = UDim2.fromOffset(v399.X, v399.Y);
            Frame4.Size = UDim2.new(0, v398.Magnitude, 0.01, 0);
            local v400 = math.atan(v398.Y / v398.X);
            Frame4.Rotation = math.deg(v400);
            Frame4.Parent = Frame2;
        end;

        u394 = p396;
    end;

    Frame2.InputBegan:Connect(function(p401) -- Line: 3613
        -- upvalues: u393 (ref), u394 (ref), addContractDrawPoint (copy), toContractCanvasPoint (copy)
        if p401.UserInputType == Enum.UserInputType.MouseButton1 or p401.UserInputType == Enum.UserInputType.Touch then
            u393 = true;
            u394 = nil;
            addContractDrawPoint(toContractCanvasPoint(p401.Position));
        end;
    end);
    UserInputService.InputChanged:Connect(function(p402) -- Line: 3626
        -- upvalues: u393 (ref), addContractDrawPoint (copy), toContractCanvasPoint (copy)
        if not u393 then
            return;
        end;

        if p402.UserInputType == Enum.UserInputType.MouseMovement or p402.UserInputType == Enum.UserInputType.Touch then
            addContractDrawPoint(toContractCanvasPoint(p402.Position));
        end;
    end);
    UserInputService.InputEnded:Connect(function(p403) -- Line: 3638
        -- upvalues: u393 (ref), u394 (ref)
        if p403.UserInputType == Enum.UserInputType.MouseButton1 or p403.UserInputType == Enum.UserInputType.Touch then
            u393 = false;
            u394 = nil;
        end;
    end);
    local u404 = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
    local u405 = { {
            maxLevel = 5,
            title = "Recruit"
        }, {
            maxLevel = 10,
            title = "Private"
        }, {
            maxLevel = 15,
            title = "Corporal"
        }, {
            maxLevel = 20,
            title = "Sergeant"
        }, {
            maxLevel = 25,
            title = "Master Sergeant"
        }, {
            maxLevel = 30,
            title = "Lieutenant"
        }, {
            maxLevel = 35,
            title = "Captain"
        }, {
            maxLevel = 40,
            title = "Global Elite"
        } };
    local u406 = 0;

    local function playRandomTypingSound() -- Line: 3666
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
    end;

    local function getContractDate() -- Line: 3671
        -- upvalues: u404 (copy)
        local v407 = os.date("*t");

        return string.format("%s %d, %d", u404[v407.month], v407.day, v407.year);
    end;

    local function getPlayerRankTitle() -- Line: 3676
        -- upvalues: DataController (ref), LocalPlayer (ref), u405 (copy)
        local v408 = DataController.Get(LocalPlayer, "Level");
        local v409 = type(v408) == "table" and tonumber(v408.Level) or 1;

        for _, v in ipairs(u405) do
            if v409 <= v.maxLevel then
                return v.title;
            end;
        end;

        return "Global Elite";
    end;

    local function runContractTypewriter() -- Line: 3688
        -- upvalues: u406 (ref), TradeUp2 (copy), LocalPlayer (ref), u404 (copy), getPlayerRankTitle (copy), Router (ref)
        u406 = u406 + 1;
        local u410 = u406;
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;
        local v411 = Frame3:FindFirstChild("1");
        local v412 = Frame3:FindFirstChild("2");

        if not (v411 and v412) then
            return;
        end;

        local v413 = {};
        local v414 = {
            label = v411:FindFirstChild("ID"),
            text = tostring(LocalPlayer.UserId)
        };
        local v415 = {
            label = v411:FindFirstChild("Name"),
            text = LocalPlayer.Name
        };
        local v416 = {
            label = v411:FindFirstChild("Number"),
            text = tostring(10)
        };
        local v417 = {
            label = v412:FindFirstChild("Date")
        };
        local v418 = os.date("*t");
        v417.text = string.format("%s %d, %d", u404[v418.month], v418.day, v418.year);
        v413[1], v413[2], v413[3], v413[4], v413[5] = v414, v415, v416, v417, {
    label = v412:FindFirstChild("Rank"),
    text = getPlayerRankTitle()
};
        local u419 = 0;
        local u420 = {};

        for _, v in ipairs(v413) do
            if v.label and v.label:IsA("TextLabel") then
                v.label.Text = "";
                u419 = math.max(u419, #v.text);
                table.insert(u420, v);
            end;
        end;

        task.spawn(function() -- Line: 3720
            -- upvalues: u410 (copy), u406 (ref), u419 (ref), u420 (copy), Router (ref)
            task.wait(0.2);

            if u410 ~= u406 then
                return;
            end;

            for i = 1, u419 do
                task.wait(0.12);

                if u410 ~= u406 then
                    return;
                end;

                for _, v in ipairs(u420) do
                    if i <= #v.text then
                        v.label.Text = string.sub(v.text, 1, i);
                    end;
                end;

                Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
            end;
        end);
    end;

    local u421 = 0;

    local function getTradeUpItemName(p422) -- Line: 3751
        if not p422 then
            return "";
        end;

        local v423 = p422.Name or "";
        local v424 = v423:find("Zeus") and "Taser" or v423;
        local v425 = p422.Skin or "";

        if v425 == "" then
            return v424;
        end;

        return `{v424} | {v425}`;
    end;

    local function utf8Prefix(p426, p427) -- Line: 3767
        local v428 = utf8.offset(p426, p427 + 1);

        if v428 then
            return string.sub(p426, 1, v428 - 1);
        end;

        return p426;
    end;

    local function getContractSlotLabel(p429) -- Line: 3776
        -- upvalues: TradeUp2 (copy)
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;
        local v430 = tostring(p429);
        local v431 = Frame3:FindFirstChild("3") and Frame3["3"]:FindFirstChild(v430) or Frame3:FindFirstChild("4") and Frame3["4"]:FindFirstChild(v430);

        if v431 and v431:IsA("TextLabel") then
            return v431;
        end;

        return nil;
    end;

    local function getContractReceivedLabel() -- Line: 3787
        -- upvalues: TradeUp2 (copy)
        local v432 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

        if v432 then
            v432 = v432:FindFirstChild("Received");
        end;

        if v432 and v432:IsA("TextLabel") then
            return v432;
        end;

        return nil;
    end;

    local function clearContractSlots() -- Line: 3798
        -- upvalues: getContractSlotLabel (copy), TradeUp2 (copy)
        for i = 1, 10 do
            local v433 = getContractSlotLabel(i);

            if v433 then
                v433.Text = "";
            end;
        end;

        local v434 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

        if v434 then
            v434 = v434:FindFirstChild("Received");
        end;

        if not (v434 and v434:IsA("TextLabel")) then
            v434 = nil;
        end;

        if v434 then
            v434.Text = "";
        end;
    end;

    local function clearContractHeaderFields() -- Line: 3812
        -- upvalues: TradeUp2 (copy)
        local Frame3 = TradeUp2.TradeContainer.Contract.Frame;
        local v435 = Frame3:FindFirstChild("1");
        local v436 = Frame3:FindFirstChild("2");

        for _, v in ipairs({ "ID", "Name", "Number" }) do
            local v437;

            if v435 then
                v437 = v435:FindFirstChild(v);
            else
                v437 = v435;
            end;

            if v437 and v437:IsA("TextLabel") then
                v437.Text = "";
            end;
        end;

        for _, v in ipairs({ "Date", "Rank" }) do
            local v438;

            if v436 then
                v438 = v436:FindFirstChild(v);
            else
                v438 = v436;
            end;

            if v438 and v438:IsA("TextLabel") then
                v438.Text = "";
            end;
        end;
    end;

    local u439 = nil;

    local function finishTradeUpReveal(u440) -- Line: 3836
        -- upvalues: u439 (ref), GetResolvedSkinInformation (ref), Router (ref), u30 (ref), u28 (ref), u1 (ref), MenuState (ref)
        u439(false);

        if not u440 then
            return;
        end;

        local v441 = GetResolvedSkinInformation(u440.Name, u440.Skin);
        Router.broadcastRouter("RunStoreSound", u30[v441 and v441.rarity or (u440.Rarity or "Blue")] or "Drop Blue");

        local function showNotification() -- Line: 3847
            -- upvalues: u28 (ref), u1 (ref), u440 (copy)
            u28 = false;
            u1.ShowNewItemNotification(u440);
        end;

        local u442 = nil;
        u442 = MenuState.OnInspectStateChanged:Connect(function(p443) -- Line: 3853
            -- upvalues: u442 (ref), u28 (ref), u1 (ref), u440 (copy)
            if p443 then
                return;
            end;

            u442:Disconnect();
            u442 = nil;
            u28 = false;
            u1.ShowNewItemNotification(u440);
        end);
        Router.broadcastRouter("WeaponInspect", u440.Name, u440.Skin, u440.Float, u440.StatTrack, u440.NameTag, u440.Charm, u440.Stickers, u440.Type, u440.Pattern, u440._id, u440.Serial, u440.IsTradeable);

        if u442 and not Router.broadcastRouter("IsInspectActive") then
            u442:Disconnect();
            u442 = nil;
            u28 = false;
            u1.ShowNewItemNotification(u440);
        end;
    end;

    local function runContractConfirmReveal(u444) -- Line: 3889
        -- upvalues: u421 (ref), clearContractSlots (copy), getContractSlotLabel (copy), Router (ref), u382 (ref), TradeUp2 (copy), TweenService (ref), finishTradeUpReveal (copy)
        u421 = u421 + 1;
        local u445 = u421;
        clearContractSlots();
        task.spawn(function() -- Line: 3894
            -- upvalues: getContractSlotLabel (ref), u444 (copy), u445 (copy), u421 (ref), Router (ref), u382 (ref), TradeUp2 (ref), TweenService (ref), finishTradeUpReveal (ref)
            for i = 1, 10 do
                local v446 = getContractSlotLabel(i);
                local v447 = u444[i] or "";

                if v446 then
                    for i2 = 1, utf8.len(v447) or #v447 do
                        task.wait(0.06);

                        if u445 ~= u421 then
                            return;
                        end;

                        local v448 = utf8.offset(v447, i2 + 1);
                        local v449;

                        if v448 then
                            v449 = string.sub(v447, 1, v448 - 1);
                        else
                            v449 = v447;
                        end;

                        v446.Text = v449;
                        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                    end;
                end;
            end;

            while u445 == u421 and u382 == nil do
                task.wait(0.05);
            end;

            if u445 ~= u421 then
                return;
            end;

            local v450 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

            if v450 then
                v450 = v450:FindFirstChild("Received");
            end;

            if not (v450 and v450:IsA("TextLabel")) then
                v450 = nil;
            end;

            local v451 = u382;
            local v452;

            if v451 then
                local v453 = v451.Name or "";
                v452 = v453:find("Zeus") and "Taser" or v453;
                local v454 = v451.Skin or "";

                if v454 ~= "" then
                    v452 = `{v452} | {v454}`;
                end;
            else
                v452 = "";
            end;

            if v450 then
                for i = 1, utf8.len(v452) or #v452 do
                    task.wait(0.06);

                    if u445 ~= u421 then
                        return;
                    end;

                    local v455 = utf8.offset(v452, i + 1);
                    local v456;

                    if v455 then
                        v456 = string.sub(v452, 1, v455 - 1);
                    else
                        v456 = v452;
                    end;

                    v450.Text = v456;
                    Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                end;
            end;

            task.wait(0.1);

            if u445 ~= u421 then
                return;
            end;

            local Approved = TradeUp2.TradeContainer.Contract:FindFirstChild("Approved");

            if Approved and Approved:IsA("ImageLabel") then
                Approved.Size = UDim2.fromScale(0.65, 0.65);
                Approved.ImageTransparency = 0.85;
                Approved.Visible = true;
                Router.broadcastRouter("RunInterfaceSound", "TradeUp Approved");
                local v457 = { TweenService:Create(Approved, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                        ImageTransparency = 0,
                        Size = UDim2.fromScale(0.35, 0.35)
                    }), TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), {
                        Size = UDim2.fromScale(0.365, 0.365)
                    }), TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), {
                        Size = UDim2.fromScale(0.35, 0.35)
                    }) };

                for _, v in ipairs(v457) do
                    v:Play();
                    v.Completed:Wait();

                    if u445 ~= u421 then
                        return;
                    end;
                end;
            end;

            task.wait(1.25);

            if u445 ~= u421 then
                return;
            end;

            finishTradeUpReveal(u382);
        end);
    end;

    local function skipContractReveal() -- Line: 3983
        -- upvalues: u421 (ref), u382 (ref), finishTradeUpReveal (copy)
        u421 = u421 + 1;
        local u458 = u421;
        task.spawn(function() -- Line: 3987
            -- upvalues: u458 (copy), u421 (ref), u382 (ref), finishTradeUpReveal (ref)
            while u458 == u421 and u382 == nil do
                task.wait(0.05);
            end;

            if u458 ~= u421 then
                return;
            end;

            finishTradeUpReveal(u382);
        end);
    end;

    local function setTradeUpItemSelectionState() -- Line: 3999
        -- upvalues: u378 (ref), u383 (ref), u384 (ref), u385 (ref), u406 (ref), u421 (ref), TradeUp2 (copy), Title2 (copy), Text (copy), Position (copy), Position2 (copy), u379 (ref), u24 (ref), u393 (ref), u394 (ref), u392 (ref), Frame2 (copy)
        u378 = false;
        u383 = false;
        u384 = false;
        u385 = false;
        u406 = u406 + 1;
        u421 = u421 + 1;
        TradeUp2.Options.Clear.Visible = true;
        TradeUp2.Options.Proceed.Visible = true;
        TradeUp2.Options.Cancel.Visible = false;
        Title2.Text = Text;
        TradeUp2.Options.Cancel.Position = Position;
        TradeUp2.Options.Proceed.Position = Position2;
        TradeUp2.Top.Visible = true;

        if u379 and (u24 and u24.Menu) then
            u24.Menu.Top.Visible = true;
        end;

        u379 = false;
        TradeUp2.TradeContainer.Container.Visible = true;
        TradeUp2.TradeContainer.Exchange.Visible = true;
        TradeUp2.TradeContainer.Contract.Visible = false;
        u393 = false;
        u394 = nil;
        u392 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;

        for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = child.Name ~= "WarningForContract";
            end;
        end;
    end;

    local function setTradeUpContractState() -- Line: 4041
        -- upvalues: u378 (ref), TradeUp2 (copy), Title2 (copy), u386 (copy), u387 (copy), u24 (ref), u379 (ref), u393 (ref), u394 (ref), u392 (ref), Frame2 (copy), clearContractHeaderFields (copy), clearContractSlots (copy), u406 (ref), Frame (copy), u389 (copy), TweenService (ref), u390 (copy), Position3 (copy), runContractTypewriter (copy), Router (ref)
        u378 = true;
        TradeUp2.Options.Clear.Visible = false;
        TradeUp2.Options.Proceed.Visible = true;
        TradeUp2.Options.Cancel.Visible = true;
        Title2.Text = "CONFIRM";
        TradeUp2.Options.Cancel.Position = u386;
        TradeUp2.Options.Proceed.Position = u387;
        TradeUp2.Top.Visible = false;

        if u24 and u24.Menu then
            u24.Menu.Top.Visible = false;
            u379 = true;
        end;

        for _, child in ipairs(TradeUp2.Warning:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = false;
            end;
        end;

        u393 = false;
        u394 = nil;
        u392 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;

        clearContractHeaderFields();
        clearContractSlots();
        local Approved = TradeUp2.TradeContainer.Contract:FindFirstChild("Approved");

        if Approved and Approved:IsA("ImageLabel") then
            Approved.Visible = false;
        end;

        TradeUp2.TradeContainer.Container.Visible = false;
        TradeUp2.TradeContainer.Exchange.Visible = false;
        u406 = u406 + 1;
        local u459 = u406;
        Frame.Position = u389;

        if not TradeUp2.TradeContainer.Contract.Visible then
            TradeUp2.TradeContainer.Contract.Visible = true;
        end;

        task.delay(0.18, function() -- Line: 4094
            -- upvalues: u459 (copy), u406 (ref), TweenService (ref), Frame (ref), u390 (ref), Position3 (ref), runContractTypewriter (ref), Router (ref)
            if u459 ~= u406 then
                return;
            end;

            local v460 = TweenService:Create(Frame, u390, {
                Position = Position3
            });
            v460.Completed:Connect(function() -- Line: 4103
                -- upvalues: u459 (ref), u406 (ref), runContractTypewriter (ref)
                if u459 ~= u406 then
                    return;
                end;

                runContractTypewriter();
            end);
            Router.broadcastRouter("RunInterfaceSound", "TradeUp Contract Slide");
            v460:Play();
        end);
    end;

    u439 = function(p461) -- Line: 4115, Name: setTradeUpVisible
        -- upvalues: u23 (ref), TradeUp2 (copy), u9 (ref), u8 (ref), u17 (ref), MenuState (ref), u21 (ref), u11 (ref), u26 (ref), u28 (ref), setTradeUpItemSelectionState (copy), u303 (copy), u304 (ref), renderTradeUp (ref), u378 (ref), u383 (ref), u384 (ref), u385 (ref), u406 (ref), u421 (ref), u393 (ref), u394 (ref), u392 (ref), Frame2 (copy), Position (copy), Position2 (copy), Title2 (copy), Text (copy), u379 (ref), u24 (ref)
        u23.Frame.Categories.Visible = not p461;
        u23.Frame.Right.Visible = not p461;
        TradeUp2.Visible = p461;
        u9 = nil;
        u8 = nil;
        u17 = nil;
        u23.Ignore.Hover.Visible = false;

        if p461 then
            MenuState.EnterTradeUp();

            if u21 then
                u21.Visible = false;
            end;

            if u23.Ignore.ItemNotification.Visible then
                u23.Ignore.ItemNotification.Visible = false;
                u11 = 0;
                table.clear(u26);
                u28 = false;
            end;

            setTradeUpItemSelectionState();
            table.clear(u303);
            u304 = nil;
            renderTradeUp();

            return;
        end;

        MenuState.ExitTradeUp();
        u378 = false;
        u383 = false;
        u384 = false;
        u385 = false;
        u406 = u406 + 1;
        u421 = u421 + 1;
        u393 = false;
        u394 = nil;
        u392 = 0;

        for _, child in ipairs(Frame2:GetChildren()) do
            child:Destroy();
        end;

        TradeUp2.Options.Cancel.Position = Position;
        TradeUp2.Options.Proceed.Position = Position2;
        Title2.Text = Text;

        if u379 and (u24 and u24.Menu) then
            u24.Menu.Top.Visible = true;
        end;

        u379 = false;
    end;

    local Clear = TradeUp2.Options.Clear;
    local Proceed = TradeUp2.Options.Proceed;
    local Cancel = TradeUp2.Options.Cancel;
    ActivateButton(Clear);
    Clear.Selectable = true;
    Clear.MouseButton1Click:Connect(function() -- Line: 4170, Name: handleTradeUpClearClick
        -- upvalues: Router (ref), u303 (copy), u304 (ref), renderTradeUp (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        table.clear(u303);
        u304 = nil;
        renderTradeUp();
    end);
    Clear.Activated:Connect(function(p462) -- Line: 4177
        -- upvalues: Router (ref), u303 (copy), u304 (ref), renderTradeUp (ref)
        if p462 and p462.UserInputType == Enum.UserInputType.Gamepad1 then
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            table.clear(u303);
            u304 = nil;
            renderTradeUp();
        end;
    end);
    ActivateButton(Proceed);
    Proceed.Selectable = true;

    local function handleTradeUpProceedClick() -- Line: 4185
        -- upvalues: u384 (ref), u378 (ref), u385 (ref), Router (ref), u421 (ref), u382 (ref), finishTradeUpReveal (copy), u380 (ref), u383 (ref), u303 (copy), TradeUp2 (copy), u388 (copy), Title2 (copy), DataController (ref), LocalPlayer (ref), u381 (ref), Remotes (ref), clearContractSlots (copy), getContractSlotLabel (copy), TweenService (ref), setTradeUpContractState (copy)
        if u384 then
            if u378 and not u385 then
                u385 = true;
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                u421 = u421 + 1;
                local u463 = u421;
                task.spawn(function() -- Line: 3987
                    -- upvalues: u463 (copy), u421 (ref), u382 (ref), finishTradeUpReveal (ref)
                    while u463 == u421 and u382 == nil do
                        task.wait(0.05);
                    end;

                    if u463 ~= u421 then
                        return;
                    end;

                    finishTradeUpReveal(u382);
                end);
            end;

            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if not u378 then
            if #u303 == 10 then
                setTradeUpContractState();
            end;

            return;
        end;

        if u380 or (u383 or #u303 ~= 10) then
            return;
        end;

        u384 = true;
        u385 = false;
        TradeUp2.Options.Cancel.Visible = false;
        TradeUp2.Options.Proceed.Position = u388;
        Title2.Text = "SKIP";
        local v464 = DataController.Get(LocalPlayer, "Inventory") or {};
        local v465 = {};

        for _, v in ipairs(v464) do
            if v and v._id then
                v465[v._id] = v;
            end;
        end;

        local u466 = {};

        for _, v in ipairs(u303) do
            local v467 = v465[v];
            local v468;

            if v467 then
                local v469 = v467.Name or "";
                v468 = v469:find("Zeus") and "Taser" or v469;
                local v470 = v467.Skin or "";

                if v470 ~= "" then
                    v468 = `{v468} | {v470}`;
                end;
            else
                v468 = "";
            end;

            table.insert(u466, v468);
        end;

        u382 = nil;
        u383 = false;
        u381 = u381 + 1;
        local v471 = `TradeUp_{u381}`;
        u380 = v471;
        Remotes.Store.TradeUpItems.Send({
            ItemIds = table.clone(u303),
            RequestId = v471
        });
        u421 = u421 + 1;
        local u472 = u421;
        clearContractSlots();
        task.spawn(function() -- Line: 3894
            -- upvalues: getContractSlotLabel (ref), u466 (copy), u472 (copy), u421 (ref), Router (ref), u382 (ref), TradeUp2 (ref), TweenService (ref), finishTradeUpReveal (ref)
            for i = 1, 10 do
                local v473 = getContractSlotLabel(i);
                local v474 = u466[i] or "";

                if v473 then
                    for i2 = 1, utf8.len(v474) or #v474 do
                        task.wait(0.06);

                        if u472 ~= u421 then
                            return;
                        end;

                        local v475 = utf8.offset(v474, i2 + 1);
                        local v476;

                        if v475 then
                            v476 = string.sub(v474, 1, v475 - 1);
                        else
                            v476 = v474;
                        end;

                        v473.Text = v476;
                        Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                    end;
                end;
            end;

            while u472 == u421 and u382 == nil do
                task.wait(0.05);
            end;

            if u472 ~= u421 then
                return;
            end;

            local v477 = TradeUp2.TradeContainer.Contract.Frame:FindFirstChild("2");

            if v477 then
                v477 = v477:FindFirstChild("Received");
            end;

            if not (v477 and v477:IsA("TextLabel")) then
                v477 = nil;
            end;

            local v478 = u382;
            local v479;

            if v478 then
                local v480 = v478.Name or "";
                v479 = v480:find("Zeus") and "Taser" or v480;
                local v481 = v478.Skin or "";

                if v481 ~= "" then
                    v479 = `{v479} | {v481}`;
                end;
            else
                v479 = "";
            end;

            if v477 then
                for i = 1, utf8.len(v479) or #v479 do
                    task.wait(0.06);

                    if u472 ~= u421 then
                        return;
                    end;

                    local v482 = utf8.offset(v479, i + 1);
                    local v483;

                    if v482 then
                        v483 = string.sub(v479, 1, v482 - 1);
                    else
                        v483 = v479;
                    end;

                    v477.Text = v483;
                    Router.broadcastRouter("RunInterfaceSound", (`TradeUp Type {math.random(1, 3)}`));
                end;
            end;

            task.wait(0.1);

            if u472 ~= u421 then
                return;
            end;

            local Approved = TradeUp2.TradeContainer.Contract:FindFirstChild("Approved");

            if Approved and Approved:IsA("ImageLabel") then
                Approved.Size = UDim2.fromScale(0.65, 0.65);
                Approved.ImageTransparency = 0.85;
                Approved.Visible = true;
                Router.broadcastRouter("RunInterfaceSound", "TradeUp Approved");
                local v484 = { TweenService:Create(Approved, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                        ImageTransparency = 0,
                        Size = UDim2.fromScale(0.35, 0.35)
                    }), TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), {
                        Size = UDim2.fromScale(0.365, 0.365)
                    }), TweenService:Create(Approved, TweenInfo.new(0.03, Enum.EasingStyle.Linear), {
                        Size = UDim2.fromScale(0.35, 0.35)
                    }) };

                for _, v in ipairs(v484) do
                    v:Play();
                    v.Completed:Wait();

                    if u472 ~= u421 then
                        return;
                    end;
                end;
            end;

            task.wait(1.25);

            if u472 ~= u421 then
                return;
            end;

            finishTradeUpReveal(u382);
        end);
    end;

    Proceed.MouseButton1Click:Connect(handleTradeUpProceedClick);
    Proceed.Activated:Connect(function(p485) -- Line: 4242
        -- upvalues: handleTradeUpProceedClick (copy)
        if p485 and p485.UserInputType == Enum.UserInputType.Gamepad1 then
            handleTradeUpProceedClick();
        end;
    end);
    ActivateButton(Cancel);
    Cancel.Selectable = true;
    Cancel.MouseButton1Click:Connect(function() -- Line: 4250, Name: handleTradeUpCancelClick
        -- upvalues: u384 (ref), Router (ref), u421 (ref), u383 (ref), u303 (copy), u304 (ref), setTradeUpItemSelectionState (copy), renderTradeUp (ref)
        if u384 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u421 = u421 + 1;

        if u383 then
            table.clear(u303);
            u304 = nil;
        end;

        setTradeUpItemSelectionState();
        renderTradeUp();
    end);
    Cancel.Activated:Connect(function(p486) -- Line: 4267
        -- upvalues: u384 (ref), Router (ref), u421 (ref), u383 (ref), u303 (copy), u304 (ref), setTradeUpItemSelectionState (copy), renderTradeUp (ref)
        if p486 and p486.UserInputType == Enum.UserInputType.Gamepad1 then
            if u384 then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u421 = u421 + 1;

            if u383 then
                table.clear(u303);
                u304 = nil;
            end;

            setTradeUpItemSelectionState();
            renderTradeUp();
        end;
    end);
    Remotes.Store.TradeUpCompleted.Listen(function(p487) -- Line: 4275
        -- upvalues: u380 (ref), DataController (ref), LocalPlayer (ref), u383 (ref), u382 (ref)
        local v488;

        if p487 and typeof(p487.RequestId) == "string" then
            v488 = p487.RequestId;
        else
            v488 = nil;
        end;

        if not u380 or v488 ~= u380 then
            return;
        end;

        u380 = nil;
        DataController.ApplyInventoryDelta(LocalPlayer, { p487.InventoryItem }, p487.DeletedItemIds);
        u383 = true;
        u382 = p487.InventoryItem;
    end);
    Remotes.Store.TradeUpDenied.Listen(function(p489) -- Line: 4290
        -- upvalues: u380 (ref), u421 (ref), u384 (ref), u385 (ref), TradeUp2 (copy), u439 (ref)
        local v490;

        if p489 and typeof(p489.RequestId) == "string" then
            v490 = p489.RequestId;
        else
            v490 = nil;
        end;

        if v490 and (u380 and v490 ~= u380) then
            return;
        end;

        u380 = nil;
        u421 = u421 + 1;
        u384 = false;
        u385 = false;

        if TradeUp2.Visible then
            u439(false);
        end;
    end);
    ActivateButton(TradeUp);
    TradeUp.Selectable = true;
    TradeUp.MouseButton1Click:Connect(function() -- Line: 4306, Name: handleTradeUpOpenClick
        -- upvalues: u439 (ref), Router (ref)
        u439(true);
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    TradeUp.Activated:Connect(function(p491) -- Line: 4311
        -- upvalues: u439 (ref), Router (ref)
        if p491 and p491.UserInputType == Enum.UserInputType.Gamepad1 then
            u439(true);
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end;
    end);
    u25 = (function() -- Line: 4319, Name: setupTradeUpTopBar
        -- upvalues: u23 (ref), Router (ref), u300 (ref), GuiService (ref), Profiler (ref), u301 (ref), renderTradeUpContainer (copy), u296 (copy), TradeUp2 (copy), u302 (copy)
        local Top2 = u23.Frame.TradeUp.Top;
        local Weapon2 = Top2.Weapon;
        local Click2 = Weapon2.Click;
        local DropdownContent2 = Weapon2.DropdownContent;
        local Title3 = Weapon2.Container.Left.Title;

        local function setDropdownOpen(p492) -- Line: 4326
            -- upvalues: DropdownContent2 (copy)
            DropdownContent2.Visible = p492;
            DropdownContent2.Active = p492;
            local Scroll = DropdownContent2:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = p492;
                Scroll.Active = p492;
            end;
        end;

        Weapon2.Active = false;
        Click2.Selectable = true;
        DropdownContent2.Visible = false;
        DropdownContent2.Active = false;
        local Scroll = DropdownContent2:FindFirstChild("Scroll");

        if Scroll and Scroll:IsA("GuiObject") then
            Scroll.Visible = false;
            Scroll.Active = false;
        end;

        Click2.Activated:Connect(function() -- Line: 4340
            -- upvalues: DropdownContent2 (copy), Router (ref)
            local v493 = not DropdownContent2.Visible;
            DropdownContent2.Visible = v493;
            DropdownContent2.Active = v493;
            local Scroll2 = DropdownContent2:FindFirstChild("Scroll");

            if Scroll2 and Scroll2:IsA("GuiObject") then
                Scroll2.Visible = v493;
                Scroll2.Active = v493;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);

        local function getInitialSortOption() -- Line: 4345
            -- upvalues: u300 (ref), Click2 (copy), DropdownContent2 (copy)
            local v494 = DropdownContent2.Scroll:FindFirstChild(u300 or Click2.Frame.TextLabel.Text or "Newest");

            if v494 and (v494:IsA("GuiButton") and v494.Selectable) then
                return v494;
            end;

            for _, child in ipairs(DropdownContent2.Scroll:GetChildren()) do
                if child:IsA("GuiButton") and child.Selectable then
                    return child;
                end;
            end;

            return nil;
        end;

        DropdownContent2:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4359
            -- upvalues: GuiService (ref), DropdownContent2 (copy), getInitialSortOption (copy), Profiler (ref), Click2 (copy)
            if GuiService.SelectedObject == nil then
                return;
            end;

            if DropdownContent2.Visible then
                local u495 = getInitialSortOption();

                if u495 then
                    Profiler.defer("UI.Inventory.TradeUpSortFocusDeferred", function() -- Line: 4366
                        -- upvalues: DropdownContent2 (ref), GuiService (ref), u495 (copy)
                        if DropdownContent2.Visible then
                            GuiService.SelectedObject = u495;
                        end;
                    end);
                end;
            else
                local SelectedObject = GuiService.SelectedObject;

                if SelectedObject and SelectedObject:IsDescendantOf(DropdownContent2.Scroll) then
                    GuiService.SelectedObject = Click2;
                end;
            end;
        end);
        local ReverseSort2 = Weapon2.Container.Left.ReverseSort;
        ReverseSort2.Selectable = true;
        ReverseSort2.Activated:Connect(function() -- Line: 4383
            -- upvalues: u301 (ref), ReverseSort2 (copy), renderTradeUpContainer (ref), Router (ref)
            u301 = not u301;
            ReverseSort2.Rotation = u301 and 180 or 0;
            renderTradeUpContainer();
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);

        for _, v in u296 do
            local u496 = DropdownContent2.Scroll:FindFirstChild(v);

            if u496 and u496:IsA("TextButton") then
                u496.Selectable = true;

                local function u497() -- Line: 4395
                    -- upvalues: Router (ref), u300 (ref), v (copy), Title3 (copy), DropdownContent2 (copy), u496 (copy), renderTradeUpContainer (ref)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    u300 = v;
                    Title3.Text = v;

                    for _, child in ipairs(DropdownContent2.Scroll:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.Frame.BackgroundTransparency = child == u496 and 0 or 1;
                        end;
                    end;

                    renderTradeUpContainer();
                    DropdownContent2.Visible = false;
                    DropdownContent2.Active = false;
                    local Scroll2 = DropdownContent2:FindFirstChild("Scroll");

                    if Scroll2 and Scroll2:IsA("GuiObject") then
                        Scroll2.Visible = false;
                        Scroll2.Active = false;
                    end;
                end;

                u496.MouseButton1Click:Connect(u497);
                u496.Activated:Connect(function(p498) -- Line: 4408
                    -- upvalues: u497 (copy)
                    if p498 and p498.UserInputType == Enum.UserInputType.Gamepad1 then
                        u497();
                    end;
                end);
            end;
        end;

        local Title4 = Top2.Search.Container.Title;
        local Search2 = Top2.Search;
        Search2.MouseButton1Click:Connect(function() -- Line: 4419
            -- upvalues: Title4 (copy)
            Title4:CaptureFocus();
        end);
        Search2.Activated:Connect(function() -- Line: 4422
            -- upvalues: Title4 (copy)
            Title4:CaptureFocus();
        end);
        Title4:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 4425
            -- upvalues: TradeUp2 (ref), u302 (ref), Title4 (copy), renderTradeUpContainer (ref)
            if not TradeUp2.Visible then
                return;
            end;

            table.clear(u302);
            local Text2 = Title4.Text;

            if Text2 ~= "" then
                for _, v in ipairs(string.split(string.lower(Text2), " ")) do
                    if v ~= "" then
                        table.insert(u302, v);
                    end;
                end;
            end;

            renderTradeUpContainer();
        end);

        return {
            setDropdownOpen = setDropdownOpen,
            searchTextBox = Title4
        };
    end)();
    u23.Frame.TradeUp.Top.TradeUp.Visible = false;
    u439(false);
    clearContractSlots();
    clearContractHeaderFields();
    task.spawn(function() -- Line: 4461
        -- upvalues: TradeUp2 (copy), ContentProvider (ref), u24 (ref)
        local v499 = {};
        local v500 = {};

        for _, descendant in ipairs(TradeUp2.TradeContainer.Contract:GetDescendants()) do
            if (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and (descendant.Image ~= "" and not v499[descendant.Image]) then
                v499[descendant.Image] = true;
                table.insert(v500, descendant.Image);
            end;
        end;

        if #v500 == 0 then
            return;
        end;

        ContentProvider:PreloadAsync(v500);
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "TradeUpContractImageWarmup";
        Frame3.BackgroundTransparency = 1;
        Frame3.Size = UDim2.fromOffset(1, 1);
        Frame3.Position = UDim2.fromOffset(0, 0);

        for _, v in ipairs(v500) do
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.ImageTransparency = 0.99;
            ImageLabel.Size = UDim2.fromOffset(1, 1);
            ImageLabel.Image = v;
            ImageLabel.Parent = Frame3;
        end;

        Frame3.Parent = u24;
        task.wait(0.5);
        Frame3:Destroy();
    end);

    if u24 and u24.Menu then
        u24.Menu.Top:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4501
            -- upvalues: u378 (ref), u24 (ref)
            if u378 and u24.Menu.Top.Visible then
                u24.Menu.Top.Visible = false;
            end;
        end);
    end;

    Router.observerRouter("ResetInventoryToGrid", function() -- Line: 4509
        -- upvalues: u439 (ref)
        u439(false);
    end);
    Title:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 4543
        -- upvalues: u23 (ref), SetSearchQuery (ref), Title (copy), Profiler (ref), u5 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref)
        if not u23.Visible then
            return;
        end;

        SetSearchQuery(Title.Text);
        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if not u23 then
            return;
        end;

        if not u23.Visible then
            return;
        end;

        u5 = GetSortedInventoryData();
        u5 = ApplyFilterToSortedData(u5);
        UpdateInventoryTemplates();
    end);

    local function handleInventoryClosed() -- Line: 4552
        -- upvalues: u22 (ref), u439 (ref), u20 (ref), Title (copy), u302 (copy), u303 (copy), u304 (ref), u25 (ref), UpdateInventoryTemplates (ref)
        local v501 = u22;

        if v501 then
            v501.Visible = false;
            v501.Active = false;
            local Scroll = v501:FindFirstChild("Scroll");

            if Scroll and Scroll:IsA("GuiObject") then
                Scroll.Visible = false;
                Scroll.Active = false;
            end;
        end;

        u439(false);
        table.clear(u20);
        Title.Text = "";
        table.clear(u302);
        table.clear(u303);
        u304 = nil;

        if u25 then
            u25.setDropdownOpen(false);
            u25.searchTextBox.Text = "";
        end;

        UpdateInventoryTemplates();
    end;

    u23:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4576
        -- upvalues: u23 (ref), u26 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref), Profiler (ref), u5 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u11 (ref), u1 (ref), MenuState (ref), handleInventoryClosed (copy)
        local v502;

        if u23 == nil then
            v502 = false;
        else
            v502 = u23.Visible or #u26 > 0;
        end;

        if v502 then
            if not u27 then
                u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
                updateInventoryHeartbeat(0);
            end;
        else
            updateInventoryHeartbeat(0);
        end;

        if u23.Visible then
            Profiler.mark("UI.Inventory.ApplyCurrentSort");

            if u23 and u23.Visible then
                u5 = GetSortedInventoryData();
                u5 = ApplyFilterToSortedData(u5);
                UpdateInventoryTemplates();
            end;

            local v503 = #u26;

            if v503 > 0 and u11 < v503 then
                u1.NextInventoryItem(u11 + 1);
            end;
        elseif not MenuState.IsInspectActive() then
            handleInventoryClosed();
        end;
    end);
    MenuState.OnInspectStateChanged:Connect(function(p504) -- Line: 4593
        -- upvalues: u23 (ref), handleInventoryClosed (copy)
        if p504 then
            return;
        end;

        task.defer(function() -- Line: 4597
            -- upvalues: u23 (ref), handleInventoryClosed (ref)
            if not u23.Visible then
                handleInventoryClosed();
            end;
        end);
    end);

    if u24 and u24.Menu then
        u24.Menu:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4606
            -- upvalues: u24 (ref), u23 (ref), handleInventoryClosed (copy), u26 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref)
            if not u24.Menu.Visible and u23.Visible then
                u23.Visible = false;
                handleInventoryClosed();
                local v505;

                if u23 == nil then
                    v505 = false;
                else
                    v505 = u23.Visible or #u26 > 0;
                end;

                if v505 then
                    if u27 then
                        return;
                    end;

                    u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
                    updateInventoryHeartbeat(0);

                    return;
                end;

                updateInventoryHeartbeat(0);
            end;
        end);
    end;

    u23.Frame.Right.Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 4616
        -- upvalues: OnScrollPositionChanged (ref)
        OnScrollPositionChanged();
    end);
    u23.Frame.Right.Container:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- Line: 4622
        -- upvalues: Profiler (ref), OnScrollPositionChanged (ref)
        Profiler.defer("UI.Inventory.ScrollDeferred", OnScrollPositionChanged);
    end);
end;

function u1.Start() -- Line: 4630
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), UserInputService (copy), u23 (ref), GuiService (copy), Router (copy), u11 (ref), u26 (copy), u28 (ref), u27 (ref), RunServiceController (copy), updateInventoryHeartbeat (copy), u21 (ref), u1 (copy), Skins (copy), Remotes (copy), Players (copy), u19 (ref), Store (copy), u16 (ref), u12 (ref), u14 (ref), u5 (ref), GetSortedInventoryData (copy), ApplyFilterToSortedData (copy), UpdateInventoryTemplates (copy), u7 (ref), UpdateItemStatusFrame (copy), MenuState (copy), CollectionService (copy), u32 (copy), ActivateButton (copy)
    debug.setmemorycategory("UI.Inventory.Start");
    Profiler.mark("UI.Inventory.Start.Begin");
    DataController.WaitForDataLoaded(LocalPlayer);
    Profiler.mark("UI.Inventory.Start.DataLoaded");
    Profiler.mark("UI.Inventory.Start.InitialCategory");
    local u506 = nil;

    local function setupGamepadNavigation() -- Line: 4640
        -- upvalues: Profiler (ref), u506 (ref), UserInputService (ref), u23 (ref), GuiService (ref), Router (ref), u11 (ref), u26 (ref), u28 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref), u21 (ref)
        Profiler.mark("UI.Inventory.SetupGamepadNavigation");

        if u506 then
            u506:Disconnect();
        end;

        u506 = UserInputService.InputBegan:Connect(function(p507, p508) -- Line: 4647
            -- upvalues: u23 (ref), GuiService (ref), Router (ref), u11 (ref), u26 (ref), u28 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref), u21 (ref)
            if p507.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            if not u23 or (not u23.Visible or p508) then
                return;
            end;

            local KeyCode = p507.KeyCode;
            local SelectedObject = GuiService.SelectedObject;
            local v509 = u23 and u23.Ignore.ItemNotification and u23.Ignore.ItemNotification.Visible;

            if KeyCode == Enum.KeyCode.ButtonB then
                if v509 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    u23.Ignore.ItemNotification.Visible = false;
                    u11 = 0;
                    table.clear(u26);
                    u28 = false;
                    local v510;

                    if u23 == nil then
                        v510 = false;
                    else
                        v510 = u23.Visible or #u26 > 0;
                    end;

                    if not v510 then
                        updateInventoryHeartbeat(0);

                        return;
                    end;

                    if u27 then
                        return;
                    end;

                    u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
                    updateInventoryHeartbeat(0);

                    return;
                end;

                if u21 and u21.Visible then
                    u21.Visible = false;
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");

                    return;
                end;

                if u23 and u23.Tabs.Inventory.Sort.Button.Options.Visible then
                    u23.Tabs.Inventory.Sort.Button.Options.Visible = false;
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");

                    return;
                end;
            end;

            if v509 then
                local Holder = u23.Ignore.ItemNotification.Holder;

                if KeyCode == Enum.KeyCode.Thumbstick1 or (KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight) then
                    return;
                end;

                local v511 = KeyCode == Enum.KeyCode.DPadUp;

                if not v511 and KeyCode ~= Enum.KeyCode.DPadDown then
                    return;
                end;

                if SelectedObject and SelectedObject:IsA("GuiButton") then
                    local v512 = v511 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown;

                    if v512 and (v512 == Holder.Continue or v512 == Holder.ViewLoadout) then
                        GuiService.SelectedObject = v512;
                    end;
                end;

                return;
            end;

            local v513 = u21 and u21.Visible;

            if v513 then
                if SelectedObject then
                    v513 = SelectedObject:IsDescendantOf(u21);
                else
                    v513 = SelectedObject;
                end;
            end;

            if v513 and (KeyCode == Enum.KeyCode.Thumbstick1 or (KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight)) then
                return;
            end;

            local v514 = KeyCode == Enum.KeyCode.DPadUp;
            local v515 = (v514 or KeyCode == Enum.KeyCode.DPadDown) and (SelectedObject and SelectedObject:IsA("GuiButton")) and (v514 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown);

            if v515 then
                if v513 then
                    if v515:IsDescendantOf(u21) then
                        GuiService.SelectedObject = v515;
                    end;
                else
                    GuiService.SelectedObject = v515;
                end;
            end;
        end);
    end;

    local u516 = nil;

    local function setupSelectionProtection() -- Line: 4770
        -- upvalues: Profiler (ref), u516 (ref), GuiService (ref), u23 (ref), u1 (ref), u21 (ref)
        Profiler.mark("UI.Inventory.SetupSelectionProtection");

        if u516 then
            u516:Disconnect();
        end;

        u516 = GuiService.Changed:Connect(function(p517) -- Line: 4777
            -- upvalues: u23 (ref), GuiService (ref), Profiler (ref), u1 (ref), u21 (ref)
            if p517 ~= "SelectedObject" then
                return;
            end;

            local v518 = u23 and u23.Ignore.ItemNotification;

            if v518 and v518.Visible then
                local Holder = v518.Holder;
                local SelectedObject = GuiService.SelectedObject;

                if SelectedObject and (SelectedObject ~= Holder.Continue and (SelectedObject ~= Holder.ViewLoadout and not (SelectedObject:IsDescendantOf(Holder) and SelectedObject:IsA("GuiButton")))) then
                    Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u1.SelectFirstItemNotificationButton);
                end;

                return;
            end;

            if not (u21 and u21.Visible) then
                return;
            end;

            local SelectedObject = GuiService.SelectedObject;

            if SelectedObject and not SelectedObject:IsDescendantOf(u21) then
                Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u1.SelectFirstInformationFrameButton);
            end;
        end);
    end;

    if u23 then
        u23:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4824
            -- upvalues: u23 (ref), Profiler (ref), u506 (ref), UserInputService (ref), GuiService (ref), Router (ref), u11 (ref), u26 (ref), u28 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref), u21 (ref), u516 (ref), u1 (ref)
            if u23.Visible then
                Profiler.mark("UI.Inventory.SetupGamepadNavigation");

                if u506 then
                    u506:Disconnect();
                end;

                u506 = UserInputService.InputBegan:Connect(function(p519, p520) -- Line: 4647
                    -- upvalues: u23 (ref), GuiService (ref), Router (ref), u11 (ref), u26 (ref), u28 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref), u21 (ref)
                    if p519.UserInputType ~= Enum.UserInputType.Gamepad1 then
                        return;
                    end;

                    if not u23 or (not u23.Visible or p520) then
                        return;
                    end;

                    local KeyCode = p519.KeyCode;
                    local SelectedObject = GuiService.SelectedObject;
                    local v521 = u23 and u23.Ignore.ItemNotification and u23.Ignore.ItemNotification.Visible;

                    if KeyCode == Enum.KeyCode.ButtonB then
                        if v521 then
                            Router.broadcastRouter("RunInterfaceSound", "UI Click");
                            u23.Ignore.ItemNotification.Visible = false;
                            u11 = 0;
                            table.clear(u26);
                            u28 = false;
                            local v522;

                            if u23 == nil then
                                v522 = false;
                            else
                                v522 = u23.Visible or #u26 > 0;
                            end;

                            if not v522 then
                                updateInventoryHeartbeat(0);

                                return;
                            end;

                            if u27 then
                                return;
                            end;

                            u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
                            updateInventoryHeartbeat(0);

                            return;
                        end;

                        if u21 and u21.Visible then
                            u21.Visible = false;
                            Router.broadcastRouter("RunInterfaceSound", "UI Click");

                            return;
                        end;

                        if u23 and u23.Tabs.Inventory.Sort.Button.Options.Visible then
                            u23.Tabs.Inventory.Sort.Button.Options.Visible = false;
                            Router.broadcastRouter("RunInterfaceSound", "UI Click");

                            return;
                        end;
                    end;

                    if v521 then
                        local Holder = u23.Ignore.ItemNotification.Holder;

                        if KeyCode == Enum.KeyCode.Thumbstick1 or (KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight) then
                            return;
                        end;

                        local v523 = KeyCode == Enum.KeyCode.DPadUp;

                        if not v523 and KeyCode ~= Enum.KeyCode.DPadDown then
                            return;
                        end;

                        if SelectedObject and SelectedObject:IsA("GuiButton") then
                            local v524 = v523 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown;

                            if v524 and (v524 == Holder.Continue or v524 == Holder.ViewLoadout) then
                                GuiService.SelectedObject = v524;
                            end;
                        end;

                        return;
                    end;

                    local v525 = u21 and u21.Visible;

                    if v525 then
                        if SelectedObject then
                            v525 = SelectedObject:IsDescendantOf(u21);
                        else
                            v525 = SelectedObject;
                        end;
                    end;

                    if v525 and (KeyCode == Enum.KeyCode.Thumbstick1 or (KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight)) then
                        return;
                    end;

                    local v526 = KeyCode == Enum.KeyCode.DPadUp;
                    local v527 = (v526 or KeyCode == Enum.KeyCode.DPadDown) and (SelectedObject and SelectedObject:IsA("GuiButton")) and (v526 and SelectedObject.NextSelectionUp or SelectedObject.NextSelectionDown);

                    if v527 then
                        if v525 then
                            if v527:IsDescendantOf(u21) then
                                GuiService.SelectedObject = v527;
                            end;
                        else
                            GuiService.SelectedObject = v527;
                        end;
                    end;
                end);
                Profiler.mark("UI.Inventory.SetupSelectionProtection");

                if u516 then
                    u516:Disconnect();
                end;

                u516 = GuiService.Changed:Connect(function(p528) -- Line: 4777
                    -- upvalues: u23 (ref), GuiService (ref), Profiler (ref), u1 (ref), u21 (ref)
                    if p528 ~= "SelectedObject" then
                        return;
                    end;

                    local v529 = u23 and u23.Ignore.ItemNotification;

                    if v529 and v529.Visible then
                        local Holder = v529.Holder;
                        local SelectedObject = GuiService.SelectedObject;

                        if SelectedObject and (SelectedObject ~= Holder.Continue and (SelectedObject ~= Holder.ViewLoadout and not (SelectedObject:IsDescendantOf(Holder) and SelectedObject:IsA("GuiButton")))) then
                            Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u1.SelectFirstItemNotificationButton);
                        end;

                        return;
                    end;

                    if not (u21 and u21.Visible) then
                        return;
                    end;

                    local SelectedObject = GuiService.SelectedObject;

                    if SelectedObject and not SelectedObject:IsDescendantOf(u21) then
                        Profiler.defer("UI.Inventory.SelectionProtectionDeferred", u1.SelectFirstInformationFrameButton);
                    end;
                end);

                if UserInputService.GamepadEnabled then
                    Profiler.defer("UI.Inventory.AutoSelectDeferred", function() -- Line: 4830
                        -- upvalues: GuiService (ref), u23 (ref)
                        local v530 = 0;

                        while v530 < 5 do
                            task.wait(0.1);
                            v530 = v530 + 1;

                            if GuiService.SelectedObject or not (u23 and u23.Visible) then
                                break;
                            end;

                            if u23.Frame.Right.Container then
                                for _, child in ipairs(u23.Frame.Right.Container:GetChildren()) do
                                    if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
                                        local Button = child:FindFirstChild("Button");

                                        if Button and (Button:IsA("GuiButton") and (Button.Selectable and Button.Visible)) then
                                            GuiService.SelectedObject = Button;

                                            return;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end);
                end;
            else
                if u506 then
                    u506:Disconnect();
                    u506 = nil;
                end;

                if u516 then
                    u516:Disconnect();
                    u516 = nil;
                end;
            end;
        end);
    end;

    local v531;

    if u23 == nil then
        v531 = false;
    else
        v531 = u23.Visible or #u26 > 0;
    end;

    if v531 then
        if not u27 then
            u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
            updateInventoryHeartbeat(0);
        end;
    else
        updateInventoryHeartbeat(0);
    end;

    Skins.OnItemStockSchemasUpdated:Connect(function(p532) -- Line: 4882
        -- upvalues: Profiler (ref), DataController (ref), LocalPlayer (ref), u1 (ref)
        Profiler.mark("UI.Inventory.ItemStockSchemasUpdated");
        local v533 = DataController.Get(LocalPlayer, "Inventory");
        u1.UpdateTemplates(v533);
    end);
    Remotes.Store.NewInventoryItem.Listen(function(p534) -- Line: 4889
        -- upvalues: Profiler (ref), Players (ref), LocalPlayer (ref), u26 (ref), u23 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref)
        Profiler.mark("UI.Inventory.NewInventoryItemRemote");
        local v535 = tonumber(p534.Player);

        if not v535 then
            return;
        end;

        local v536 = Players:GetPlayerByUserId(v535);

        if not v536 or LocalPlayer ~= v536 then
            return;
        end;

        for _, v in ipairs(p534.Items) do
            local v537 = false;

            for _, v2 in ipairs(u26) do
                if v2._id == v._id then
                    v537 = true;
                    break;
                end;
            end;

            if not v537 then
                table.insert(u26, v);
            end;
        end;

        local v538;

        if u23 == nil then
            v538 = false;
        else
            v538 = u23.Visible or #u26 > 0;
        end;

        if not v538 then
            updateInventoryHeartbeat(0);

            return;
        end;

        if u27 then
            return;
        end;

        u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
        updateInventoryHeartbeat(0);
    end);
    Remotes.Store.CaseOpenDenied.Listen(function(p539) -- Line: 4919
        -- upvalues: u19 (ref), Store (ref), u16 (ref), Router (ref)
        local v540;

        if p539 and typeof(p539.RequestId) == "string" then
            v540 = p539.RequestId;
        else
            v540 = nil;
        end;

        local v541;

        if v540 then
            v541 = u19 == v540;
        else
            v541 = v540;
        end;

        if v541 and (not v540 or u19 == v540) then
            if u19 then
                Store.ClearPendingOpenCaseRequest(u19);
            end;

            u16 = false;
            u19 = nil;
        end;

        if v541 and (p539 and p539.Reason == "RateLimited") then
            local v542 = (tonumber(p539.RetryAfterMs) or 0) / 1000;
            local v543 = v542 <= 0 and "Quick open is rate limited. Please wait a moment and try again." or string.format("Quick open is rate limited. Wait %.1fs and try again.", v542);
            Router.broadcastRouter("CreateMenuNotification", "Error", v543);
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function(p544) -- Line: 4935
        -- upvalues: Profiler (ref), u1 (ref), u12 (ref), u23 (ref), u14 (ref), u5 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref), u21 (ref), u7 (ref)
        Profiler.mark("UI.Inventory.InventoryChanged");
        u1.UpdateInventory(p544);

        if not u12 then
            u23.Frame.Right.Top.Weapon.Container.Left.Title.Text = "Newest";
            u14 = "Newest";
            u12 = true;
        end;

        Profiler.mark("UI.Inventory.ApplyCurrentSort");

        if u23 and u23.Visible then
            u5 = GetSortedInventoryData();
            u5 = ApplyFilterToSortedData(u5);
            UpdateInventoryTemplates();
        end;

        if not u21 or (not u21.Visible or (not u7 or (not u7._id or type(p544) ~= "table"))) then
            return;
        end;

        local _id = u7._id;

        for _, v in ipairs(p544) do
            if v._id == _id then
                break;
            end;
        end;

        if v then
            u7 = v;
            u1.SetupInformationFrame(v);
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 4963
        -- upvalues: Profiler (ref), u23 (ref), UpdateItemStatusFrame (ref)
        Profiler.mark("UI.Inventory.LoadoutChanged");

        if u23 and u23.Visible then
            for _, child in ipairs(u23.Frame.Right.Container:GetChildren()) do
                local v545 = child:IsA("ImageButton");

                if v545 then
                    if child.Name == "UIGridLayout" or (child.Name == "UIListLayout" or (child.Name == "UIPadding" or child.Name == "Title")) then
                        v545 = false;
                    else
                        v545 = child.Name ~= "Label";
                    end;
                end;

                if v545 then
                    UpdateItemStatusFrame(child, child.Name);
                end;
            end;
        end;
    end);
    MenuState.OnInspectStateChanged:Connect(function(p546) -- Line: 4977
        -- upvalues: Profiler (ref), u26 (ref), u23 (ref), u11 (ref), u1 (ref)
        if not p546 then
            Profiler.defer("UI.Inventory.InspectClosedDeferred", function() -- Line: 4980
                -- upvalues: u26 (ref), u23 (ref), u11 (ref), u1 (ref)
                local v547 = #u26;

                if u23.Visible and (v547 > 0 and u11 < v547) then
                    u1.NextInventoryItem(u11 + 1);
                end;
            end);
        end;
    end);
    Router.observerRouter("QuickOpenResolved", function(p548) -- Line: 4993
        -- upvalues: u19 (ref), Store (ref), u16 (ref)
        if typeof(p548) == "string" then
            if p548 and u19 ~= p548 then
                return;
            end;

            if u19 then
                Store.ClearPendingOpenCaseRequest(u19);
            end;

            u16 = false;
            u19 = nil;
        end;
    end);
    Router.observerRouter("ShowNewItemNotification", function(p549) -- Line: 5000
        -- upvalues: u1 (ref)
        u1.ShowNewItemNotification(p549);
    end);
    Router.observerRouter("ShowNewItemNotificationAtIndex", function(p550) -- Line: 5005
        -- upvalues: u26 (ref), u1 (ref), u23 (ref), u27 (ref), RunServiceController (ref), updateInventoryHeartbeat (ref)
        if p550 > #u26 then
            return;
        end;

        u1.NextInventoryItem(p550);
        local v551;

        if u23 == nil then
            v551 = false;
        else
            v551 = u23.Visible or #u26 > 0;
        end;

        if not v551 then
            updateInventoryHeartbeat(0);

            return;
        end;

        if u27 then
            return;
        end;

        u27 = RunServiceController.BindToHeartbeat("UI.Inventory.Update", updateInventoryHeartbeat);
        updateInventoryHeartbeat(0);
    end);

    for _, v in CollectionService:GetTagged("CategoryFilter") do
        u32[v.Name] = true;
        ActivateButton(v.Checkbox);
        v.Checkbox.Activated:Connect(function() -- Line: 5017
            -- upvalues: u32 (ref), v (copy), Profiler (ref), u23 (ref), u5 (ref), GetSortedInventoryData (ref), ApplyFilterToSortedData (ref), UpdateInventoryTemplates (ref)
            u32[v.Name] = not u32[v.Name];
            v.Checkbox.Toggle.Visible = u32[v.Name];
            Profiler.mark("UI.Inventory.ApplyCurrentSort");

            if not u23 then
                return;
            end;

            if not u23.Visible then
                return;
            end;

            u5 = GetSortedInventoryData();
            u5 = ApplyFilterToSortedData(u5);
            UpdateInventoryTemplates();
        end);
    end;

    for _, v in CollectionService:GetTagged("CategoryButtons") do
        v.Activated:Connect(function() -- Line: 5026
            -- upvalues: v (copy)
            v.Parent[`{v.Name}Filter`].Visible = not v.Parent[`{v.Name}Filter`].Visible;
        end);
    end;
end;

return u1;