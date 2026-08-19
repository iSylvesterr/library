-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local UserInputService = game:GetService("UserInputService");
local GamepadService = game:GetService("GamepadService");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local u2 = LocalPlayer:GetMouse();
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local UseItemFrame = require(script.Parent.UseItemFrame);
local WeaponDropShadows = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.WeaponDropShadows);
local Sort = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Sort);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetResolvedSkinInformation = require(ReplicatedStorage.Components.Common.GetResolvedSkinInformation);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Characters = ReplicatedStorage.Assets.Characters;
local Attachments = require(ReplicatedStorage.Database.Custom.GameStats.Character.Attachments);
local Viewport = require(ReplicatedStorage.Database.Custom.GameStats.Character.Viewport);
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter);
local u3 = "Counter-Terrorists";
local u4 = nil;
local u5 = "Newest";
local u6 = false;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = false;
local u19 = nil;
local u20 = nil;
local u21 = false;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = false;
local u26 = false;
local u27 = false;
local u28 = false;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;

local function IsItemEquippedOnTeam(p34, p35) -- Line: 123
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v36 = DataController.Get(LocalPlayer, "Loadout");

    if not v36 then
        return false;
    end;

    local v37 = v36[p35];

    if not v37 then
        return false;
    end;

    if v37.Loadout then
        for _, v in pairs(v37.Loadout) do
            if v and v.Options then
                for _, v2 in ipairs(v.Options) do
                    if v2 == p34 then
                        return true;
                    end;
                end;
            end;
        end;
    end;

    if v37.Equipped then
        for _, v in pairs(v37.Equipped) do
            if v == p34 then
                return true;
            end;
        end;
    end;

    return false;
end;

local function UpdateItemStatusFrame(p38, p39) -- Line: 160
    -- upvalues: IsItemEquippedOnTeam (copy)
    local Status = p38:FindFirstChild("Status");

    if not Status then
        return;
    end;

    local v40 = Status:FindFirstChild("Counter-Terrorists");
    local Terrorists = Status:FindFirstChild("Terrorists");

    if v40 and Terrorists then
        local v41 = IsItemEquippedOnTeam(p39, "Counter-Terrorists");
        local v42 = IsItemEquippedOnTeam(p39, "Terrorists");
        v40.Visible = v41;
        Terrorists.Visible = v42;
    end;
end;

local u43 = {};
local u44 = {
    CT = nil,
    T = nil
};
local u45 = {
    CT = nil,
    T = nil
};
local u46 = {
    CT = {},
    T = {}
};
local u47 = {};
local u48 = {
    CT = nil,
    T = nil
};
local u49 = {};
local u50 = 0;
local u51 = false;
local u52 = false;
local u53 = UDim2.fromScale(0.2, 0.2);
local u54 = Vector2.new(0, 0);
local u55 = {
    Pistol = "Pistols",
    SMG = "Mid Tier",
    Heavy = "Mid Tier",
    Rifle = "Rifles"
};
local u56 = {
    ["Incendiary Grenade"] = true,
    ["Decoy Grenade"] = true,
    ["Smoke Grenade"] = true,
    ["HE Grenade"] = true,
    Flashbang = true,
    Molotov = true
};
local u57 = {
    Charm = true,
    ["Charm Capsule"] = true,
    Sticker = true,
    ["Sticker Capsule"] = true,
    Grenade = true,
    Case = true,
    Package = true,
    Booth = true
};
local u58 = {
    Pistol = 1,
    SMG = 2,
    Heavy = 3,
    Rifle = 4,
    Equipment = 5,
    Miscellaneous = 6
};
local u59 = {
    Glove = "Equipped Gloves",
    Melee = "Equipped Melee",
    ["Zeus x27"] = "Equipped Zeus x27",
    Badge = "Equipped Badge",
    ["Music Kit"] = "Equipped Music Kit",
    Graffiti = "Equipped Graffiti"
};
local u60 = {
    ["Equipped Gloves"] = "Gloves",
    ["Equipped Melee"] = "Melee",
    ["Equipped Zeus x27"] = "Zeus",
    ["Equipped Badge"] = "Badge",
    ["Equipped Music Kit"] = "Music Kit",
    ["Equipped Graffiti"] = "Graffiti"
};
local u61 = { "Melee", "Gloves", "Zeus", "Badge" };

local function GetSidebarItemType(p62) -- Line: 260
    return p62 == "Melee" and "Melee" or (p62 == "Gloves" and "Glove" or (p62 == "Badge" and "Badge" or "Zeus x27"));
end;

local function GetSidebarWeaponClass(p63) -- Line: 272
    return p63 == "Melee" and "Melee" or (p63 == "Gloves" and "Glove" or nil);
end;

local function ShouldSidebarPreviewWeapon(p64) -- Line: 282
    return p64 == "Melee" and true or p64 == "Zeus";
end;

local u65 = {
    Terrorists = { "Glock-18" },
    ["Counter-Terrorists"] = { "USP-S", "P2000" }
};
local u66 = nil;

local function ClearFrame(p67, p68) -- Line: 298
    for _, child in ipairs(p67:GetChildren()) do
        if not table.find(p68, child.Name) then
            child:Destroy();
        end;
    end;
end;

local function GetAnimationForWeaponType(p69, p70, p71, p72) -- Line: 308
    if p69 == nil then
        return nil;
    end;

    return p70 == "SniperScope" and "Sniper" or (p69 == "Heavy" and (p71 == "MachineGun" and "LMG" or "Heavy") or (p69 == "Equipment" and p72 == "Grenade" and "Grenade" or ({
        Pistol = "Pistol",
        Rifle = "Rifle",
        SMG = "SMG",
        Equipment = nil,
        Miscellaneous = nil
    })[p69]));
end;

local function GetAnimationForWeapon(p73, p74) -- Line: 354
    -- upvalues: Viewport (copy)
    if not (p73 and Viewport.ANIMATION_MAPPING[p73]) then
        return nil;
    end;

    local v75 = Viewport.ANIMATION_MAPPING[p73];

    if p74 and v75[p74] then
        return v75[p74];
    end;

    return v75.Default;
end;

local function HasAnyInformationFrameButton() -- Line: 372
    -- upvalues: u33 (ref)
    if not u33 then
        return false;
    end;

    if u33.Charm and u33.Charm.Visible then
        return true;
    end;

    if u33.Inspect and u33.Inspect.Visible then
        return true;
    end;

    if u33.ReplaceCT and u33.ReplaceCT.Visible then
        return true;
    end;

    if u33.ReplaceT and u33.ReplaceT.Visible then
        return true;
    end;

    if u33.Unlock and u33.Unlock.Visible then
        return true;
    end;

    local QuickUnlock = u33:FindFirstChild("QuickUnlock");

    return QuickUnlock and QuickUnlock.Visible or false;
end;

local function FindWeaponSlotOnTeam(p76, p77, p78) -- Line: 397
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v79 = DataController.Get(LocalPlayer, "Loadout");
    local v80 = DataController.Get(LocalPlayer, "Inventory");

    if not (v79 and v80) then
        return nil;
    end;

    local v81 = v79[p77];

    if not (v81 and (v81.Loadout and v81.Loadout[p78])) then
        return nil;
    end;

    for i, v in ipairs(v81.Loadout[p78].Options) do
        if v and v ~= "" then
            for _, v2 in ipairs(v80) do
                if v2._id == v and v2.Name == p76 then
                    return i;
                end;
            end;
        end;
    end;

    return nil;
end;

local function ReplaceItemOnTeam(p82, p83) -- Line: 422
    -- upvalues: GetWeaponProperties (copy), u55 (copy), FindWeaponSlotOnTeam (copy), Remotes (copy), u59 (copy)
    if p82.Type ~= "Weapon" then
        if p82.Type == "Melee" then
            if p82.Name == "CT Knife" and p83 == "Terrorists" then
                return;
            end;

            if p82.Name == "T Knife" and p83 == "Counter-Terrorists" then
                return;
            end;
        end;

        local v84 = u59[p82.Type];

        if v84 then
            Remotes.Inventory.EquipSpecialItem.Send({
                Identifier = p82._id,
                Path = v84,
                Team = p83
            });
        end;

        return;
    end;

    local success, result = pcall(GetWeaponProperties, p82.Name);
    local v85;

    if success and (result and result.Type) then
        v85 = u55[result.Type];
    else
        v85 = nil;
    end;

    if not v85 then
        return;
    end;

    local v86 = FindWeaponSlotOnTeam(p82.Name, p83, v85) or 1;
    Remotes.Inventory.EquipLoadoutSkin.Send({
        Type = v85,
        Slot = v86 - 1,
        Team = p83,
        Identifier = p82._id
    });
end;

function u1.SetupInformationFrameNavigation() -- Line: 459
    -- upvalues: u33 (ref)
    if not u33 then
        return;
    end;

    local v87 = {};

    if u33.Charm and u33.Charm.Visible then
        table.insert(v87, {
            button = u33.Charm,
            order = u33.Charm.LayoutOrder
        });
    end;

    if u33.Inspect and u33.Inspect.Visible then
        table.insert(v87, {
            button = u33.Inspect,
            order = u33.Inspect.LayoutOrder
        });
    end;

    if u33.ReplaceCT and u33.ReplaceCT.Visible then
        table.insert(v87, {
            button = u33.ReplaceCT,
            order = u33.ReplaceCT.LayoutOrder
        });
    end;

    if u33.ReplaceT and u33.ReplaceT.Visible then
        table.insert(v87, {
            button = u33.ReplaceT,
            order = u33.ReplaceT.LayoutOrder
        });
    end;

    if u33.Unlock and u33.Unlock.Visible then
        table.insert(v87, {
            button = u33.Unlock,
            order = u33.Unlock.LayoutOrder
        });
    end;

    local QuickUnlock = u33:FindFirstChild("QuickUnlock");

    if QuickUnlock and QuickUnlock.Visible then
        table.insert(v87, {
            button = QuickUnlock,
            order = QuickUnlock.LayoutOrder
        });
    end;

    table.sort(v87, function(p88, p89) -- Line: 485
        return p88.order < p89.order;
    end);
    local v90 = {};

    for _, v in ipairs(v87) do
        table.insert(v90, v.button);
    end;

    for i, v in ipairs(v90) do
        v.NextSelectionUp = v90[i > 1 and i - 1 or #v90];
        v.NextSelectionDown = v90[i < #v90 and i + 1 or 1];
        v.NextSelectionLeft = nil;
        v.NextSelectionRight = nil;
    end;
end;

function u1.SelectFirstInformationFrameButton() -- Line: 502
    -- upvalues: u33 (ref), u1 (copy), GuiService (copy)
    if not (u33 and u33.Visible) then
        return;
    end;

    u1.SetupInformationFrameNavigation();

    if u33.Charm and u33.Charm.Visible then
        GuiService.SelectedObject = u33.Charm;

        return;
    end;

    if u33.Inspect and u33.Inspect.Visible then
        GuiService.SelectedObject = u33.Inspect;

        return;
    end;

    if u33.ReplaceCT and u33.ReplaceCT.Visible then
        GuiService.SelectedObject = u33.ReplaceCT;

        return;
    end;

    if u33.ReplaceT and u33.ReplaceT.Visible then
        GuiService.SelectedObject = u33.ReplaceT;

        return;
    end;

    if u33.Unlock and u33.Unlock.Visible then
        GuiService.SelectedObject = u33.Unlock;

        return;
    end;

    local QuickUnlock = u33:FindFirstChild("QuickUnlock");

    if QuickUnlock and QuickUnlock.Visible then
        GuiService.SelectedObject = QuickUnlock;
    end;
end;

function u1.SetupInformationFrame(p91) -- Line: 527
    -- upvalues: Profiler (copy), u33 (ref), GetWeaponProperties (copy), IsItemEquippedOnTeam (copy)
    Profiler.mark("UI.Loadout.SetupInformationFrame");
    local v92 = p91.Type == "Weapon";
    local v93 = p91.Type == "Melee";
    local v94 = p91.Type == "Glove";
    local v95 = p91.Type == "Badge";
    local v96 = p91.Type == "Zeus x27";
    u33.Inspect.Visible = v92 or (v94 or (v93 or (v96 or (p91.Type == "Charm" and true or v95))));

    if u33.Unlock then
        u33.Unlock.Visible = p91.Type == "Case" and true or p91.Type == "Package";
    end;

    if u33.Loadout then
        u33.Loadout.Visible = false;
    end;

    local QuickUnlock = u33:FindFirstChild("QuickUnlock");

    if QuickUnlock then
        QuickUnlock.Visible = false;
    end;

    local UnlockDivider = u33:FindFirstChild("UnlockDivider");

    if UnlockDivider then
        UnlockDivider.Visible = false;
    end;

    local v97 = v92 or (v96 or p91.Type == "Charm");

    if u33.Charm then
        u33.Charm.Visible = v97;
        local v98 = v97 and u33.Charm:FindFirstChildWhichIsA("TextLabel", true);

        if v98 then
            if p91.Type == "Charm" then
                v98.Text = "Attach to Weapon";
            else
                local v99;

                if p91.Charm == nil or p91.Charm == false then
                    v99 = false;
                else
                    v99 = (type(p91.Charm) == "string" or p91.Charm == true) and true or type(p91.Charm) == "table";
                end;

                v98.Text = v99 and "Detach Charm" or "Attach Charm";
            end;
        end;
    end;

    local v100 = false;
    local v101 = false;

    if v92 then
        local success, result = pcall(GetWeaponProperties, p91.Name);

        if success and (result and result.Team) then
            if result.Team == "Both" then
                v100 = true;
                v101 = true;
            elseif result.Team == "Counter-Terrorists" then
                v100 = true;
            elseif result.Team == "Terrorists" then
                v101 = true;
            end;
        end;
    elseif v93 then
        if p91.Name == "CT Knife" then
            v100 = true;
        elseif p91.Name == "T Knife" then
            v101 = true;
        else
            v100 = true;
            v101 = true;
        end;
    elseif v94 then
        local v102 = GetWeaponProperties(p91.Name);

        if v102 and v102.Team then
            if v102.Team == "Both" then
                v100 = true;
                v101 = true;
            elseif v102.Team == "Counter-Terrorists" then
                v100 = true;
            elseif v102.Team == "Terrorists" then
                v101 = true;
            end;
        end;
    elseif v95 or v96 then
        v100 = true;
        v101 = true;
    end;

    local v103 = IsItemEquippedOnTeam(p91._id, "Counter-Terrorists");
    local v104 = IsItemEquippedOnTeam(p91._id, "Terrorists");
    local v105 = v92 or (v93 or (v94 or (v95 or v96)));

    if u33.ReplaceCT then
        if v105 then
            if v100 then
                v100 = not v103;
            end;
        else
            v100 = v105;
        end;

        u33.ReplaceCT.Visible = v100;
    end;

    if u33.ReplaceT then
        if v105 then
            if v101 then
                v101 = not v104;
            end;
        else
            v101 = v105;
        end;

        u33.ReplaceT.Visible = v101;
    end;

    local v106 = {
        {
            dividerName = "CharmDivider",
            action = u33.Charm
        },
        {
            dividerName = "InspectDivider",
            action = u33.Inspect
        },
        {
            dividerName = "ReplaceCTDivider",
            action = u33.ReplaceCT
        },
        {
            dividerName = "ReplaceTDivider",
            action = u33.ReplaceT
        },
        {
            dividerName = "LoadoutDivider",
            action = u33.Loadout
        }
    };
    local v107 = { "UnlockDivider" };

    for _, v in ipairs(v106) do
        table.insert(v107, v.dividerName);
    end;

    for _, v in ipairs(v106) do
        local v108 = u33:FindFirstChild(v.dividerName);

        if v108 and v.action then
            if v.action.Visible then
                local LayoutOrder = v108.LayoutOrder;
                local v109 = false;

                for _, child in ipairs(u33:GetChildren()) do
                    local v110 = false;

                    for _, v2 in ipairs(v107) do
                        if child.Name == v2 then
                            v110 = true;
                            break;
                        end;
                    end;

                    if not v110 and (child ~= v108 and (child ~= v.action and (child:IsA("Frame") or child:IsA("TextButton")))) and (child.LayoutOrder < LayoutOrder and child.Visible) then
                        v109 = true;
                    end;
                end;

                v108.Visible = v109;
            else
                v108.Visible = false;
            end;
        end;
    end;
end;

local function PositionInformationFrame(p111, p112) -- Line: 682
    -- upvalues: u33 (ref), UserInputService (copy), u2 (copy)
    local Parent = u33.Parent.Parent;
    local AbsolutePosition = Parent.AbsolutePosition;
    local AbsoluteSize = Parent.AbsoluteSize;
    local v113, v114;

    if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 or p112 then
        if p111 then
            local AbsolutePosition2 = p111.AbsolutePosition;
            local AbsoluteSize2 = p111.AbsoluteSize;
            local v115 = (AbsolutePosition2.X + AbsoluteSize2.X / 2 - AbsolutePosition.X) / AbsoluteSize.X;
            v113 = (AbsolutePosition2.Y + AbsoluteSize2.Y / 2 - AbsolutePosition.Y) / AbsoluteSize.Y + u33.Size.Y.Scale / 2;

            if 1 - v115 >= u33.Size.X.Scale + 0.01 then
                v114 = v115 + u33.Size.X.Scale / 2 + 0.01;
            else
                v114 = v115 - u33.Size.X.Scale / 2 - 0.01;
            end;
        else
            v114 = 0.5;
            v113 = 0.5;
        end;
    else
        local v116 = (u2.X - AbsolutePosition.X) / AbsoluteSize.X;
        v113 = (u2.Y - AbsolutePosition.Y) / AbsoluteSize.Y + u33.Size.Y.Scale / 2;

        if 1 - v116 >= u33.Size.X.Scale + 0.01 then
            v114 = v116 + u33.Size.X.Scale / 2 + 0.01;
        else
            v114 = v116 - u33.Size.X.Scale / 2 - 0.01;
        end;
    end;

    u33.Position = UDim2.fromScale(v114, v113);
end;

local function ShowContextMenu(p117, p118, p119, u120) -- Line: 723
    -- upvalues: DataController (copy), LocalPlayer (copy), u30 (ref), u31 (ref), u32 (ref), u33 (ref), Router (copy), u1 (copy), HasAnyInformationFrameButton (copy), PositionInformationFrame (copy), Profiler (copy)
    local v121 = DataController.Get(LocalPlayer, "Inventory");

    if v121 then
        for _, v in ipairs(v121) do
            if v._id == p117._id then
                p117 = v;
                break;
            end;
        end;
    end;

    u30 = p117;
    u31 = p117;
    u32 = p119;

    if not u33 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    u1.SetupInformationFrame(p117);

    if not HasAnyInformationFrameButton() then
        u33.Visible = false;

        return;
    end;

    if u120 then
        u33.Visible = true;
    else
        u33.Visible = not u33.Visible;
    end;

    if u33.Visible then
        PositionInformationFrame(p119, u120);
        Profiler.defer("UI.Loadout.InformationNavigationDeferred", function() -- Line: 764
            -- upvalues: u1 (ref), u120 (copy)
            u1.SetupInformationFrameNavigation();

            if u120 then
                u1.SelectFirstInformationFrameButton();
            end;
        end);
    end;
end;

local function HideContextMenu() -- Line: 775
    -- upvalues: u33 (ref), u30 (ref), u31 (ref)
    if u33 then
        u33.Visible = false;
    end;

    u30 = nil;
    u31 = nil;
end;

local function OnInspectClicked() -- Line: 786
    -- upvalues: u30 (ref), u33 (ref), u31 (ref), Router (copy)
    if not u30 then
        return;
    end;

    local v122 = u30;

    if u33 then
        u33.Visible = false;
    end;

    u30 = nil;
    u31 = nil;
    Router.broadcastRouter("WeaponInspect", v122.Name, v122.Skin, v122.Float, v122.StatTrack, v122.NameTag, v122.Charm, v122.Stickers, v122.Type, v122.Pattern, v122._id, v122.Serial, v122.IsTradeable);
end;

local function GetInventoryItemFromIdentifier(p123, p124) -- Line: 817
    for _, v in ipairs(p123) do
        if v._id == p124 then
            return v;
        end;
    end;

    return nil;
end;

local u125 = {
    Pistols = 1,
    ["Mid Tier"] = 2,
    Rifles = 3
};
local u126 = {
    ["Equipped Melee"] = 1,
    ["Equipped Gloves"] = 2,
    ["Equipped Badge"] = 3,
    ["Equipped Music Kit"] = 4,
    ["Equipped Graffiti"] = 5,
    ["Equipped Zeus x27"] = 6
};

local function GetEquippedItemPriorityInLoadout(p127) -- Line: 849
    -- upvalues: DataController (copy), LocalPlayer (copy), u125 (copy), u126 (copy)
    local v128 = DataController.Get(LocalPlayer, "Loadout");

    if not v128 then
        return nil;
    end;

    local v129 = nil;

    for _, v in ipairs({ "Counter-Terrorists", "Terrorists" }) do
        local v130 = v128[v];

        if v130 and v130.Loadout then
            for i, v2 in pairs(u125) do
                if v2 and (v130.Loadout[i] and v130.Loadout[i].Options) then
                    for i2, v3 in ipairs(v130.Loadout[i].Options) do
                        if v3 == p127 then
                            local v131 = v2 * 1000 + i2;

                            if not v129 or v131 < v129 then
                                v129 = v131;
                            end;
                        end;
                    end;
                end;
            end;

            if v130.Equipped then
                for i, v2 in pairs(v130.Equipped) do
                    if v2 == p127 then
                        local v132 = u126[i] or 99;

                        if not v129 or v132 < v129 then
                            v129 = v132;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v129;
end;

local function IsItemEquippedInLoadout(p133) -- Line: 901
    -- upvalues: GetEquippedItemPriorityInLoadout (copy)
    return GetEquippedItemPriorityInLoadout(p133) ~= nil;
end;

local u134 = nil;
Collections.ObserveAvailableCollections(function(p135) -- Line: 911
    -- upvalues: u134 (ref)
    u134 = p135;
end);

local function GetCollectionNameForItem(p136) -- Line: 916
    -- upvalues: Cases (copy), u134 (ref), GetResolvedSkinInformation (copy)
    if p136.Type ~= "Case" then
        local v137 = GetResolvedSkinInformation(p136.Name, p136.Skin);

        return v137 and v137.collection or nil;
    end;

    local v138 = Cases.GetCaseByName(p136.Skin);

    if not (v138 and u134) then
        return nil;
    end;

    for _, v in ipairs(u134) do
        if v.cases then
            for _, v2 in ipairs(v.cases) do
                if v2 == v138.name then
                    return v.name;
                end;
            end;
        end;
    end;

    return nil;
end;

local function IsWeaponValidForTeam(p139, p140) -- Line: 947
    -- upvalues: GetWeaponProperties (copy)
    if not p139 or (type(p139) ~= "string" or p139 == "") then
        return false;
    end;

    local success, result = pcall(GetWeaponProperties, p139);

    if success and (result and result.Team) then
        return result.Team == "Both" and true or result.Team == p140;
    end;

    return false;
end;

local function IsSpecialItem(p141) -- Line: 967
    -- upvalues: u59 (copy)
    return u59[p141.Type] ~= nil;
end;

local function GetSortedLoadoutData() -- Line: 973
    -- upvalues: DataController (copy), LocalPlayer (copy), Sort (copy), u5 (ref), u134 (ref), u57 (copy), u56 (copy), u59 (copy), GetWeaponProperties (copy), u3 (ref), u4 (ref), u7 (ref), u8 (ref), u6 (ref)
    local v142 = DataController.Get(LocalPlayer, "Inventory");

    if not v142 then
        return {};
    end;

    local u143 = Sort.GetSortComparisonFunction(u5, LocalPlayer, function() -- Line: 979
        -- upvalues: u134 (ref)
        return u134;
    end);
    local v144 = {};
    local v145 = {};

    for _, v in ipairs(v142) do
        if v and (v._id and (not v144[v._id] and (not u57[v.Type] and (not u56[v.Name] and (v.Name and type(v.Name) == "string"))))) then
            if u59[v.Type] ~= nil then
                local success, result = pcall(GetWeaponProperties, v.Name);
                local v146 = not (success and (result and result.Team));
                local Name = v.Name;
                local v147 = u3;
                local v148;

                if Name and (type(Name) == "string" and Name ~= "") then
                    local success2, result2 = pcall(GetWeaponProperties, Name);

                    if success2 and (result2 and result2.Team) then
                        v148 = result2.Team == "Both" and true or result2.Team == v147;
                    else
                        v148 = false;
                    end;
                else
                    v148 = false;
                end;

                if v146 or v148 then
                    v144[v._id] = true;
                    table.insert(v145, v);
                end;
            else
                local Name = v.Name;
                local v149 = u3;
                local v150;

                if Name and (type(Name) == "string" and Name ~= "") then
                    local success, result = pcall(GetWeaponProperties, Name);

                    if success and (result and result.Team) then
                        v150 = result.Team == "Both" and true or result.Team == v149;
                    else
                        v150 = false;
                    end;
                else
                    v150 = false;
                end;

                if v150 then
                    v144[v._id] = true;
                    table.insert(v145, v);
                else
                    local success, result = pcall(GetWeaponProperties, v.Name);

                    if not (success and (result and result.Team)) then
                        v144[v._id] = true;
                        table.insert(v145, v);
                    end;
                end;
            end;
        end;
    end;

    if u4 then
        v145 = {};

        for _, v in ipairs(v145) do
            if v.Type ~= "Case" and (v.Type ~= "Package" and (v.Type ~= "Charm Capsule" and (v.Type ~= "Sticker Capsule" and (v.Name and type(v.Name) == "string")))) then
                local success, result = pcall(GetWeaponProperties, v.Name);

                if success and (result and result.Type == u4) then
                    table.insert(v145, v);
                end;
            end;
        end;
    end;

    if not u7 then
        if u8 then
            v145 = {};

            for _, v in ipairs(v145) do
                if v.Name == u8.weaponName and (u8.skinName == nil and true or v.Skin == u8.skinName) then
                    table.insert(v145, v);
                end;
            end;
        end;

        if u143 then
            if u6 then
                table.sort(v145, function(p151, p152) -- Line: 1102
                    -- upvalues: u143 (copy)
                    local v153, v154 = u143(p151, p152);

                    if v154 then
                        return v153;
                    end;

                    return u143(p152, p151);
                end);

                return v145;
            end;

            table.sort(v145, u143);
        end;

        return v145;
    end;

    local sidebarName = u7.sidebarName;
    local v155 = sidebarName == "Melee" and "Melee" or (sidebarName == "Gloves" and "Glove" or (sidebarName == "Badge" and "Badge" or "Zeus x27"));
    local sidebarName2 = u7.sidebarName;
    local v156 = sidebarName2 == "Melee" and "Melee" or (sidebarName2 == "Gloves" and "Glove" or nil);
    local v157 = u7.teamKey == "CT" and "Counter-Terrorists" or "Terrorists";
    v145 = {};

    for _, v in ipairs(v145) do
        if v.Type == v155 then
            local success, result = pcall(GetWeaponProperties, v.Name);

            if not v156 or (not success or (not result or (not result.Class or result.Class == v156))) then
                local Name = v.Name;
                local v158, v159, v160, v161, v162;

                if v157 == "Counter-Terrorists" then
                    if Name ~= "T Knife" and Name ~= "T Gloves" then
                        v158 = not (success and (result and result.Team));
                        v159 = v.Name;

                        if v159 and (type(v159) == "string" and v159 ~= "") then
                            v160, v161 = pcall(GetWeaponProperties, v159);

                            if v160 and (v161 and v161.Team) then
                                v162 = v161.Team == "Both" and true or v161.Team == v157;
                            else
                                v162 = false;
                            end;
                        else
                            v162 = false;
                        end;

                        if v158 or v162 then
                            table.insert(v145, v);
                        end;
                    end;
                elseif v157 ~= "Terrorists" or Name ~= "CT Knife" and Name ~= "CT Gloves" then
                    v158 = not (success and (result and result.Team));
                    v159 = v.Name;

                    if v159 and (type(v159) == "string" and v159 ~= "") then
                        v160, v161 = pcall(GetWeaponProperties, v159);

                        if v160 and (v161 and v161.Team) then
                            v162 = v161.Team == "Both" and true or v161.Team == v157;
                        else
                            v162 = false;
                        end;
                    else
                        v162 = false;
                    end;

                    if v158 or v162 then
                        table.insert(v145, v);
                    end;
                end;
            end;
        end;
    end;

    if u8 then
        v145 = {};

        for _, v in ipairs(v145) do
            if v.Name == u8.weaponName and (u8.skinName == nil and true or v.Skin == u8.skinName) then
                table.insert(v145, v);
            end;
        end;
    end;

    if u143 then
        if u6 then
            table.sort(v145, function(p151, p152) -- Line: 1102
                -- upvalues: u143 (copy)
                local v153, v154 = u143(p151, p152);

                if v154 then
                    return v153;
                end;

                return u143(p152, p151);
            end);

            return v145;
        end;

        table.sort(v145, u143);
    end;

    return v145;
end;

local function RenderLoadoutTemplates() -- Line: 1122
    -- upvalues: Profiler (copy), u66 (ref), u50 (ref), u49 (ref), u1 (copy)
    Profiler.mark("UI.Loadout.RenderLoadoutTemplates");

    if not u66 then
        return;
    end;

    local Container = u66.Container.List.Container;
    local v163 = math.min(u50 + 25, #u49);

    for i = u50 + 1, v163 do
        local v164 = u49[i];

        if v164 and not Container:FindFirstChild(v164._id) then
            u1.CreateItemTemplate(v164);
        end;
    end;

    u50 = v163;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
            for i, v in ipairs(u49) do
                if v._id == child.Name then
                    child.LayoutOrder = i;
                    break;
                end;
            end;
        end;
    end;
end;

local function OnLoadoutScrollPositionChanged() -- Line: 1163
    -- upvalues: u66 (ref), u50 (ref), u49 (ref), RenderLoadoutTemplates (copy)
    if not u66 then
        return;
    end;

    local Container = u66.Container.List.Container;
    local v165 = Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y;

    if v165 <= 0 or (u50 >= #u49 or v165 - Container.CanvasPosition.Y >= 200) then
        return;
    end;

    RenderLoadoutTemplates();
end;

local function CalculateLoadoutInitialRenderCount() -- Line: 1184
    -- upvalues: u66 (ref)
    if not (u66 and u66.Visible) then
        return 50;
    end;

    local Container = u66.Container.List.Container;
    local v166 = Container:FindFirstChildOfClass("UIGridLayout");

    if not v166 then
        return 50;
    end;

    local AbsoluteSize = Container.AbsoluteSize;
    local Y = AbsoluteSize.Y;
    local X = AbsoluteSize.X;
    local CellSize = v166.CellSize;
    local CellPadding = v166.CellPadding;
    local v167 = CellSize.Y.Scale * Y + CellSize.Y.Offset;
    local v168 = CellPadding.Y.Scale * Y + CellPadding.Y.Offset;
    local v169 = CellSize.X.Scale * X + CellSize.X.Offset;
    local v170 = CellPadding.X.Scale * X + CellPadding.X.Offset;
    local v171 = Container:FindFirstChildOfClass("UIPadding");
    local v172, v173, v174, v175;

    if v171 then
        v172 = v171.PaddingTop.Scale * Y + v171.PaddingTop.Offset;
        v173 = v171.PaddingBottom.Scale * Y + v171.PaddingBottom.Offset;
        v174 = v171.PaddingLeft.Scale * X + v171.PaddingLeft.Offset;
        v175 = v171.PaddingRight.Scale * X + v171.PaddingRight.Offset;
    else
        v172 = 0;
        v173 = 0;
        v174 = 0;
        v175 = 0;
    end;

    local v176 = Y - v172 - v173;
    local v177 = X - v174 - v175;
    local v178 = v169 + v170;
    local v179;

    if v178 > 0 then
        local v180 = math.floor((v177 + v170) / v178);
        v179 = math.max(1, v180);
    else
        v179 = 1;
    end;

    local v181 = v167 + v168;
    local v182;

    if v181 > 0 then
        local v183 = math.floor((v176 + v168) / v181);
        v182 = math.max(1, v183);
    else
        v182 = 1;
    end;

    return v182 * v179 + v179;
end;

local function RenderInitialLoadoutTemplates() -- Line: 1256
    -- upvalues: Profiler (copy), u66 (ref), u50 (ref), CalculateLoadoutInitialRenderCount (copy), u49 (ref), u1 (copy), u51 (ref)
    Profiler.mark("UI.Loadout.RenderInitialLoadoutTemplates");

    if not (u66 and u66.Visible) then
        return;
    end;

    local Container = u66.Container.List.Container;
    u50 = 0;
    local v184 = CalculateLoadoutInitialRenderCount();
    local v185 = math.max(v184, 50);
    local v186 = math.min(v185, #u49);

    for i = 1, v186 do
        local v187 = u49[i];

        if v187 and not Container:FindFirstChild(v187._id) then
            u1.CreateItemTemplate(v187);
        end;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
            for i, v in ipairs(u49) do
                if v._id == child.Name then
                    child.LayoutOrder = i;
                    break;
                end;
            end;
        end;
    end;

    u50 = v186;
    u51 = false;
end;

local function UpdateLoadoutTemplates() -- Line: 1306
    -- upvalues: Profiler (copy), u66 (ref), u49 (ref), u50 (ref), u51 (ref), RenderInitialLoadoutTemplates (copy)
    Profiler.mark("UI.Loadout.UpdateLoadoutTemplates");

    if not u66 then
        return;
    end;

    local Container = u66.Container.List.Container;
    local v188 = {};

    for _, v in ipairs(u49) do
        if v and v._id then
            v188[v._id] = true;
        end;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIPadding" and not v188[child.Name])) then
            child:Destroy();
        end;
    end;

    u50 = 0;
    u51 = true;

    if u66.Visible then
        RenderInitialLoadoutTemplates();
    end;
end;

local function SortContainer(p189, p190) -- Line: 1342
    -- upvalues: u66 (ref), u52 (ref), u51 (ref), u49 (ref), GetSortedLoadoutData (copy), UpdateLoadoutTemplates (copy)
    if u66 and u66.Visible then
        u49 = GetSortedLoadoutData();
        UpdateLoadoutTemplates();

        return;
    end;

    u52 = true;
    u51 = true;
end;

local function AnimateSortButton(p191, p192) -- Line: 1361
    -- upvalues: TweenService (copy)
    TweenService:Create(p191, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = p192 and 0.85 or 1
    }):Play();
end;

local function FadeCategoryLabels(p193, p194) -- Line: 1370
    -- upvalues: TweenService (copy)
    local v195 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v196 = p194 and 0 or 1;

    for _, child in ipairs(p193:GetChildren()) do
        if child:IsA("Frame") and (child:FindFirstChild("Price") and child:FindFirstChild("WeaponName")) then
            local Price = child:FindFirstChild("Price");
            local WeaponName = child:FindFirstChild("WeaponName");
            TweenService:Create(Price, v195, {
                TextTransparency = v196
            }):Play();
            TweenService:Create(WeaponName, v195, {
                TextTransparency = v196
            }):Play();
        end;
    end;
end;

local function CloseAllDropdowns() -- Line: 1391
    -- upvalues: u66 (ref)
    local DropdownContent = u66.Container.List.Top.Weapon.DropdownContent;
    u66.Container.List.Top.Filter.DropdownContent.Visible = false;
    DropdownContent.Visible = false;
end;

local function UpdateResetButtonVisibility() -- Line: 1401
    -- upvalues: u66 (ref), u4 (ref), u7 (ref)
    local Reset = u66.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u4 ~= nil or u7 ~= nil) and true or u66.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;
end;

local function UpdateSortButtonVisuals(p197, p198) -- Line: 1414
    for _, child in ipairs(p197:GetChildren()) do
        if child:IsA("TextButton") then
            local Frame = child:FindFirstChild("Frame");

            if Frame then
                local v199 = child.Name == p198;
                Frame.BackgroundTransparency = v199 and 0 or 1;

                if v199 then
                    Frame.BackgroundColor3 = Color3.fromRGB(53, 83, 99);
                end;
            end;
        end;
    end;
end;

local function CreateDropdownOption(p200, p201, p202, p203, p204) -- Line: 1432
    -- upvalues: ReplicatedStorage (copy), AnimateSortButton (copy)
    local SortingTemplate = ReplicatedStorage.Assets.UI.Loadout:FindFirstChild("SortingTemplate");

    if not SortingTemplate then
        return nil;
    end;

    local u205 = SortingTemplate:Clone();
    u205.Name = p201;
    u205.LayoutOrder = p203;
    u205.BackgroundTransparency = 1;
    u205.Parent = p200;
    local Frame = u205:FindFirstChild("Frame");

    if Frame then
        local TextButton = Frame:FindFirstChild("TextButton");

        if TextButton then
            TextButton.Text = p202;
        end;

        Frame.BackgroundTransparency = 1;
        Frame.Active = false;
    end;

    u205.MouseEnter:Connect(function() -- Line: 1465
        -- upvalues: AnimateSortButton (ref), u205 (copy)
        AnimateSortButton(u205, true);
    end);
    u205.MouseLeave:Connect(function() -- Line: 1468
        -- upvalues: AnimateSortButton (ref), u205 (copy)
        AnimateSortButton(u205, false);
    end);
    u205.MouseButton1Click:Connect(p204);

    return u205;
end;

local function ClearDropdownOptions(p206) -- Line: 1478
    for _, child in ipairs(p206:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;
end;

local function GetUniqueCategories() -- Line: 1488
    -- upvalues: DataController (copy), LocalPlayer (copy), u57 (copy), u56 (copy), GetWeaponProperties (copy), u58 (copy)
    local v207 = DataController.Get(LocalPlayer, "Inventory");

    if not v207 then
        return {};
    end;

    local v208 = {};

    for _, v in ipairs(v207) do
        if not (u57[v.Type] or u56[v.Name]) then
            local success, result = pcall(GetWeaponProperties, v.Name);

            if success and (result and result.Type) then
                v208[result.Type] = true;
            end;
        end;
    end;

    local v209 = {};

    for i in pairs(v208) do
        table.insert(v209, i);
    end;

    table.sort(v209, function(p210, p211) -- Line: 1509
        -- upvalues: u58 (ref)
        return (u58[p210] or 99) < (u58[p211] or 99);
    end);

    return v209;
end;

local function GetWeaponsInCategory(p212) -- Line: 1518
    -- upvalues: DataController (copy), LocalPlayer (copy), u57 (copy), u56 (copy), GetWeaponProperties (copy)
    local v213 = DataController.Get(LocalPlayer, "Inventory");

    if not v213 then
        return {};
    end;

    local v214 = {};

    for _, v in ipairs(v213) do
        if not (u57[v.Type] or u56[v.Name]) then
            local success, result = pcall(GetWeaponProperties, v.Name);

            if success and (result and (not p212 or result.Type == p212)) then
                v214[v.Name] = true;
            end;
        end;
    end;

    local v215 = {};

    for i in pairs(v214) do
        table.insert(v215, i);
    end;

    table.sort(v215);

    return v215;
end;

local function GetLoadoutCategoryForWeapon(p216) -- Line: 1550
    -- upvalues: GetWeaponProperties (copy), u55 (copy)
    local success, result = pcall(GetWeaponProperties, p216);

    if success and (result and result.Type) then
        return u55[result.Type];
    end;

    return nil;
end;

local function IsValidStarterPistol(p217, p218) -- Line: 1560
    -- upvalues: u65 (copy)
    local v219 = u65[p218];

    if v219 then
        return table.find(v219, p217) ~= nil;
    end;

    return false;
end;

local function IsMouseOverPlayerFrame(p220) -- Line: 1576
    -- upvalues: u66 (ref), PlayerGui (copy)
    local Teams = u66.Container.Teams;
    local v221 = PlayerGui:GetGuiObjectsAtPosition(p220.X, p220.Y);

    for _, v in ipairs(v221) do
        if v.Name ~= "DragIcon" and (v == Teams or v:IsDescendantOf(Teams)) then
            return true;
        end;
    end;

    return false;
end;

local function CreateDragIcon(p222) -- Line: 1594
    -- upvalues: GetResolvedSkinInformation (copy), Skins (copy), u53 (copy)
    local v223 = GetResolvedSkinInformation(p222.Name, p222.Skin);

    if not v223 then
        return nil;
    end;

    local v224 = Skins.GetWearImageForFloat(v223, p222.Float or 0.9999) or v223.imageAssetId or "";
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DragIcon";
    ImageLabel.Size = u53;
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = v224;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.ZIndex = 100;
    ImageLabel.Active = false;

    return ImageLabel;
end;

local function CleanupPendingDrag() -- Line: 1621
    -- upvalues: u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;
end;

local function ShowMoveFramesForCategory(p225, p226) -- Line: 1632
    -- upvalues: u66 (ref), u3 (ref), u65 (copy)
    local Teams = u66.Container.Teams;
    local v227 = (u3 == "Counter-Terrorists" and Teams.CT.Guns or Teams.T.Guns):FindFirstChild(p225);

    if v227 then
        local v228 = 0;

        for _, child in ipairs(v227:GetChildren()) do
            if child:IsA("ImageButton") then
                v228 = v228 + 1;
                local v229;

                if p225 == "Pistols" and (v228 == 1 and p226) then
                    local v230 = u65[u3];

                    if v230 then
                        v229 = table.find(v230, p226) ~= nil;
                    else
                        v229 = false;
                    end;
                else
                    v229 = true;
                end;

                local MoveFrame = child:FindFirstChild("MoveFrame");

                if MoveFrame and MoveFrame:IsA("GuiObject") then
                    MoveFrame.Visible = v229;
                end;

                if v229 then
                    local Weapon = child:FindFirstChild("Weapon");

                    if Weapon then
                        local Icon = Weapon:FindFirstChild("Icon");

                        if Icon then
                            Icon.Size = UDim2.fromScale(0.9, 0.85);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local function ShowPlayerFrameMoveFrame() -- Line: 1672
    -- upvalues: u66 (ref), u3 (ref)
    local v231 = u66.Container.Teams:FindFirstChild(u3 == "Counter-Terrorists" and "CT" or "T");
    local v232 = v231 and v231:FindFirstChild("Player");

    if v232 then
        local MoveFrame = v232:FindFirstChild("MoveFrame");

        if MoveFrame and MoveFrame:IsA("GuiObject") then
            MoveFrame.Visible = true;
        end;
    end;
end;

local function HideAllMoveFrames() -- Line: 1690
    -- upvalues: u66 (ref)
    local Teams = u66.Container.Teams;

    for _, v in ipairs({ Teams.CT.Guns, Teams.T.Guns }) do
        for _, v2 in ipairs({ "Mid Tier", "Pistols", "Rifles" }) do
            local List = v:FindFirstChild(v2).List;

            if List then
                for _, child in ipairs(List:GetChildren()) do
                    if child:IsA("Frame") and child.Name ~= "Frame" then
                        local MoveFrame = child:FindFirstChild("MoveFrame");

                        if MoveFrame and MoveFrame:IsA("GuiObject") then
                            MoveFrame.Visible = false;
                        end;

                        local Weapon = child:FindFirstChild("Weapon");

                        if Weapon then
                            local Icon = Weapon:FindFirstChild("Icon");

                            if Icon then
                                Icon.Size = UDim2.fromScale(1, 0.95);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    for _, v in ipairs({ "CT", "T" }) do
        local v233 = Teams:FindFirstChild(v);

        if v233 then
            local Player = v233:FindFirstChild("Player");

            if Player then
                local MoveFrame = Player:FindFirstChild("MoveFrame");

                if MoveFrame and MoveFrame:IsA("GuiObject") then
                    MoveFrame.Visible = false;
                end;
            end;
        end;
    end;
end;

local function CleanupDrag() -- Line: 1735
    -- upvalues: u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (copy)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    u9 = false;
    u11 = nil;
    u12 = nil;
    u13 = nil;
    HideAllMoveFrames();
end;

local function EnableVirtualCursor(u234) -- Line: 1757
    -- upvalues: u26 (ref), GuiService (copy), GamepadService (copy), u66 (ref)
    if u26 then
        return;
    end;

    u26 = true;
    GuiService.AutoSelectGuiEnabled = false;
    GuiService.SelectedObject = nil;
    pcall(function() -- Line: 1766
        -- upvalues: GamepadService (ref), u234 (copy), u66 (ref)
        GamepadService:EnableGamepadCursor(u234 or u66);
    end);
end;

local function DisableVirtualCursor() -- Line: 1773
    -- upvalues: u26 (ref), GamepadService (copy), GuiService (copy)
    if not u26 then
        return;
    end;

    u26 = false;
    pcall(function() -- Line: 1779
        -- upvalues: GamepadService (ref)
        GamepadService:DisableGamepadCursor();
    end);
    GuiService.AutoSelectGuiEnabled = true;
end;

local function CleanupControllerHeld() -- Line: 1788
    -- upvalues: u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (copy), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (copy), GuiService (copy)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    u9 = false;
    u11 = nil;
    u12 = nil;
    u13 = nil;
    HideAllMoveFrames();
    u20 = nil;
    u21 = false;
    u22 = nil;
    u23 = nil;
    u24 = nil;
    u27 = false;

    if u26 then
        u26 = false;
        pcall(function() -- Line: 1779
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
    end;

    HideAllMoveFrames();
end;

local function GetLoadoutSlotInfo(p235) -- Line: 1807
    local Parent = p235.Parent;

    if not (Parent and Parent:IsA("Frame")) then
        return nil, nil;
    end;

    local Parent2 = Parent.Parent;

    if not (Parent2 and Parent2:IsA("Frame")) then
        return nil, nil;
    end;

    local Name = Parent2.Name;

    if Name ~= "Mid Tier" and (Name ~= "Pistols" and Name ~= "Rifles") then
        return nil, nil;
    end;

    local v236 = 0;

    for _, child in ipairs(Parent2:GetChildren()) do
        if child:IsA("Frame") and (child.Name ~= "Frame" and child:FindFirstChild("Button")) then
            v236 = v236 + 1;

            if child == Parent then
                return Name, v236;
            end;
        end;
    end;

    return nil, nil;
end;

local function GetInventoryItemFromButton(p237) -- Line: 1841
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v238 = DataController.Get(LocalPlayer, "Inventory");

    if not v238 then
        return nil;
    end;

    if not (p237 and p237:IsA("ImageButton")) then
        return nil;
    end;

    local Name = p237.Name;

    for _, v in ipairs(v238) do
        if v._id == Name then
            return v;
        end;
    end;

    return nil;
end;

local function GetEquippedItemFromButton(p239) -- Line: 1859
    -- upvalues: DataController (copy), LocalPlayer (copy), GetLoadoutSlotInfo (copy)
    local v240 = DataController.Get(LocalPlayer, "Inventory");

    if not v240 then
        return nil, nil, nil;
    end;

    local Parent = p239.Parent;

    if not (Parent and Parent:IsA("Frame")) then
        return nil, nil, nil;
    end;

    local Name = Parent.Name;
    local v241, v242 = GetLoadoutSlotInfo(p239);

    if not (v241 and v242) then
        return nil, nil, nil;
    end;

    for _, v in ipairs(v240) do
        if v._id == Name then
            break;
        end;
    end;

    return v, v241, v242;
end;

local function IsButtonInInventoryContainer(p243) -- Line: 1880
    local Parent = p243.Parent;

    if not Parent then
        return false;
    end;

    local Parent2 = Parent.Parent;

    if not Parent2 then
        return false;
    end;

    local v244;

    if Parent2.Name == "Container" then
        v244 = Parent2:IsA("ScrollingFrame");
    else
        v244 = false;
    end;

    return v244;
end;

local function IsButtonInLoadoutSlot(p245) -- Line: 1897
    -- upvalues: GetLoadoutSlotInfo (copy)
    local v246, v247 = GetLoadoutSlotInfo(p245);
    local v248;

    if v246 == nil then
        v248 = false;
    else
        v248 = v247 ~= nil;
    end;

    return v248;
end;

local function IsButtonSpecialItemDropZone(p249) -- Line: 1904
    local Parent = p249.Parent;

    if not Parent then
        return false;
    end;

    if Parent.Name == "Player" and Parent:IsA("ViewportFrame") then
        local Parent2 = Parent.Parent;

        if Parent2 and (Parent2.Name == "CT" or Parent2.Name == "T") then
            return true;
        end;
    end;

    return false;
end;

local function ControllerPickUpItem(u250) -- Line: 1924
    -- upvalues: u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (copy), DataController (copy), LocalPlayer (copy), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u26 (ref), GuiService (copy), GamepadService (copy), u66 (ref), u59 (copy), ShowPlayerFrameMoveFrame (copy), GetWeaponProperties (copy), u55 (copy), ShowMoveFramesForCategory (copy), GetEquippedItemFromButton (copy)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    u9 = false;
    u11 = nil;
    u12 = nil;
    u13 = nil;
    HideAllMoveFrames();
    local v251 = DataController.Get(LocalPlayer, "Inventory");

    if v251 and (u250 and u250:IsA("ImageButton")) then
        local Name = u250.Name;

        for _, v in ipairs(v251) do
            if v._id == Name then
                break;
            end;
        end;
    else
        local v = nil;
    end;

    if not v then
        local v252, v253, v254 = GetEquippedItemFromButton(u250);

        if not (v252 and (v253 and v254)) then
            return;
        end;

        u20 = v252;
        u21 = true;
        u22 = u250;
        u23 = v253;
        u24 = v254;

        if not u26 then
            u26 = true;
            GuiService.AutoSelectGuiEnabled = false;
            GuiService.SelectedObject = nil;
            pcall(function() -- Line: 1766
                -- upvalues: GamepadService (ref), u250 (copy), u66 (ref)
                GamepadService:EnableGamepadCursor(u250 or u66);
            end);
        end;

        ShowMoveFramesForCategory(v253, v252.Name);

        return;
    end;

    u20 = v;
    u21 = false;
    u22 = u250;
    u23 = nil;
    u24 = nil;

    if not u26 then
        u26 = true;
        GuiService.AutoSelectGuiEnabled = false;
        GuiService.SelectedObject = nil;
        pcall(function() -- Line: 1766
            -- upvalues: GamepadService (ref), u250 (copy), u66 (ref)
            GamepadService:EnableGamepadCursor(u250 or u66);
        end);
    end;

    if u59[v.Type] then
        ShowPlayerFrameMoveFrame();

        return;
    end;

    local success, result = pcall(GetWeaponProperties, v.Name);
    local v255;

    if success and (result and result.Type) then
        v255 = u55[result.Type];
    else
        v255 = nil;
    end;

    if v255 then
        ShowMoveFramesForCategory(v255, v.Name);

        return;
    end;

    local success2, result2 = pcall(GetWeaponProperties, v.Name);

    if success2 and (result2 and (result2.Class == "Melee" or result2.Class == "Glove")) then
        ShowPlayerFrameMoveFrame();
    end;
end;

local function GetSlotIndexInList(p256, p257, p258) -- Line: 1979
    -- upvalues: DataController (copy), LocalPlayer (copy), u3 (ref)
    local v259 = DataController.Get(LocalPlayer, "Loadout");

    if v259 then
        v259 = v259[u3];
    end;

    local v260 = v259 and v259.Loadout and v259.Loadout[p258];

    if v260 then
        for i, v in ipairs(v260.Options) do
            if v == p256.Name then
                return i;
            end;
        end;
    end;

    local v261 = 0;

    for _, child in ipairs(p257:GetChildren()) do
        if child:IsA("GuiObject") then
            v261 = v261 + 1;

            if child == p256 then
                return v261;
            end;
        end;
    end;

    return 1;
end;

local function GetDropTargetCategory(p262) -- Line: 2007
    -- upvalues: u12 (ref), u20 (ref), GetWeaponProperties (copy), u55 (copy), u66 (ref), PlayerGui (copy), GetSlotIndexInList (copy)
    local v263 = u12 or u20 and u20.Name;

    if not v263 then
        return nil, nil;
    end;

    local success, result = pcall(GetWeaponProperties, v263);
    local v264;

    if success and (result and result.Type) then
        v264 = u55[result.Type];
    else
        v264 = nil;
    end;

    if not v264 then
        return nil, nil;
    end;

    local Teams = u66.Container.Teams;
    local v265 = PlayerGui:GetGuiObjectsAtPosition(p262.X, p262.Y);
    local v266 = nil;
    local v267 = false;

    for _, v in ipairs(v265) do
        if v.Name ~= "DragIcon" then
            v267 = (v == Teams or v:IsDescendantOf(Teams)) and true or v267;

            if not v266 then
                while v and v ~= Teams do
                    local Parent = v.Parent;

                    if Parent and Parent.Name == "List" then
                        local Parent2 = Parent.Parent;

                        if Parent2 and Parent2.Name == v264 then
                            v266 = GetSlotIndexInList(v, Parent, v264);
                        end;

                        break;
                    end;

                    local v = Parent;
                end;
            end;
        end;
    end;

    if v267 then
        return v264, v266;
    end;

    return nil, nil;
end;

local function IsItemEquippedInCategory(p268, p269) -- Line: 2061
    -- upvalues: DataController (copy), LocalPlayer (copy), u3 (ref)
    local v270 = DataController.Get(LocalPlayer, "Loadout");

    if not v270 then
        return false, nil;
    end;

    local v271 = v270[u3];

    if not (v271 and (v271.Loadout and v271.Loadout[p269])) then
        return false, nil;
    end;

    for i, v in ipairs(v271.Loadout[p269].Options) do
        if v == p268 then
            return true, i;
        end;
    end;

    return false, nil;
end;

local function IsWeaponEquippedInCategory(p272, p273) -- Line: 2084
    -- upvalues: DataController (copy), LocalPlayer (copy), u3 (ref)
    local v274 = DataController.Get(LocalPlayer, "Loadout");
    local v275 = DataController.Get(LocalPlayer, "Inventory");

    if not (v274 and v275) then
        return false, nil, nil;
    end;

    local v276 = v274[u3];

    if not (v276 and (v276.Loadout and v276.Loadout[p273])) then
        return false, nil, nil;
    end;

    local v277, v278, v279;
    v277, v278, v279 = ipairs(v276.Loadout[p273].Options);

    while true do
        local v280, v281 = v277(v278, v279);

        if v280 == nil then
            break;
        end;

        v279 = v280;

        if not v281 or v281 == "" then
            continue;
        end;

        for _, v in ipairs(v275) do
            if v._id == v281 then
                break;
            end;
        end;

        if v and v.Name == p272 then
            return true, v280, v281;
        end;
    end;
end;

local function GetItemIdAtSlot(p282, p283) -- Line: 2112
    -- upvalues: DataController (copy), LocalPlayer (copy), u3 (ref)
    local v284 = DataController.Get(LocalPlayer, "Loadout");

    if not v284 then
        return nil;
    end;

    local v285 = v284[u3];

    if v285 and (v285.Loadout and v285.Loadout[p282]) then
        return v285.Loadout[p282].Options[p283];
    end;

    return nil;
end;

local function EquipLoadoutSkin(p286, p287, p288) -- Line: 2129
    -- upvalues: u28 (ref), Remotes (copy), u3 (ref)
    if u28 then
        return false;
    end;

    u28 = true;
    Remotes.Inventory.EquipLoadoutSkin.Send({
        Type = p286,
        Slot = p287 - 1,
        Team = u3,
        Identifier = p288
    });
    task.delay(5, function() -- Line: 2147
        -- upvalues: u28 (ref)
        u28 = false;
    end);

    return true;
end;

local function SwapLoadoutSkins(p289, p290, p291) -- Line: 2154
    -- upvalues: u28 (ref), Remotes (copy), u3 (ref)
    if u28 then
        return false;
    end;

    u28 = true;
    Remotes.Inventory.SwapLoadoutSkins.Send({
        Type = p289,
        SlotOne = p290 - 1,
        SlotTwo = p291 - 1,
        Team = u3
    });
    task.delay(5, function() -- Line: 2172
        -- upvalues: u28 (ref)
        u28 = false;
    end);

    return true;
end;

local function EquipSpecialItem(p292, p293) -- Line: 2181
    -- upvalues: u28 (ref), Remotes (copy), u3 (ref)
    if u28 then
        return false;
    end;

    u28 = true;
    Remotes.Inventory.EquipSpecialItem.Send({
        Path = p292,
        Team = u3,
        Identifier = p293
    });
    task.delay(5, function() -- Line: 2198
        -- upvalues: u28 (ref)
        u28 = false;
    end);

    return true;
end;

local function u309() -- Line: 2208
    -- upvalues: u20 (ref), UserInputService (copy), GuiService (copy), u59 (copy), GetDropTargetCategory (copy), u3 (ref), GetWeaponProperties (copy), u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (copy), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (copy), u55 (copy), IsItemEquippedInCategory (copy), SwapLoadoutSkins (copy), IsWeaponEquippedInCategory (copy), EquipLoadoutSkin (copy), IsMouseOverPlayerFrame (copy), EquipSpecialItem (copy)
    if not u20 then
        return;
    end;

    local v294 = UserInputService:GetMouseLocation();
    local v295 = GuiService:GetGuiInset();
    local v296 = Vector2.new(v294.X - v295.X, v294.Y - v295.Y);
    local v297 = u20.Type and u59[u20.Type];
    local v298, v299 = GetDropTargetCategory(v296);

    if not v298 or v297 then
        local v300 = u20.Type and u59[u20.Type];

        if not v300 then
            local success, result = pcall(GetWeaponProperties, u20.Name);
            v300 = success and (result and (result.Class == "Melee" or result.Class == "Glove")) and true or v300;
        end;

        if not (v300 and IsMouseOverPlayerFrame(v296)) then
            if u17 then
                u17:Disconnect();
                u17 = nil;
            end;

            u15 = nil;
            u16 = nil;
            u18 = false;
            u19 = nil;

            if u14 then
                u14:Disconnect();
                u14 = nil;
            end;

            if u10 then
                u10:Destroy();
                u10 = nil;
            end;

            u9 = false;
            u11 = nil;
            u12 = nil;
            u13 = nil;
            HideAllMoveFrames();
            u20 = nil;
            u21 = false;
            u22 = nil;
            u23 = nil;
            u24 = nil;
            u27 = false;

            if u26 then
                u26 = false;
                pcall(function() -- Line: 1779
                    -- upvalues: GamepadService (ref)
                    GamepadService:DisableGamepadCursor();
                end);
                GuiService.AutoSelectGuiEnabled = true;
            end;

            HideAllMoveFrames();

            return;
        end;

        local v301 = u59[u20.Type];

        if not v301 then
            local success, result = pcall(GetWeaponProperties, u20.Name);

            if success and result then
                v301 = result.Class == "Melee" and "Equipped Melee" or (result.Class == "Glove" and "Equipped Gloves" or v301);
            end;
        end;

        if v301 then
            EquipSpecialItem(v301, u20._id);
        end;

        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u15 = nil;
        u16 = nil;
        u18 = false;
        u19 = nil;

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        u9 = false;
        u11 = nil;
        u12 = nil;
        u13 = nil;
        HideAllMoveFrames();
        u20 = nil;
        u21 = false;
        u22 = nil;
        u23 = nil;
        u24 = nil;
        u27 = false;

        if u26 then
            u26 = false;
            pcall(function() -- Line: 1779
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
        end;

        HideAllMoveFrames();

        return;
    end;

    local Name = u20.Name;
    local v302 = u3;
    local v303;

    if Name and (type(Name) == "string" and Name ~= "") then
        local success, result = pcall(GetWeaponProperties, Name);

        if success and (result and result.Team) then
            v303 = result.Team == "Both" and true or result.Team == v302;
        else
            v303 = false;
        end;
    else
        v303 = false;
    end;

    if not v303 then
        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u15 = nil;
        u16 = nil;
        u18 = false;
        u19 = nil;

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        u9 = false;
        u11 = nil;
        u12 = nil;
        u13 = nil;
        HideAllMoveFrames();
        u20 = nil;
        u21 = false;
        u22 = nil;
        u23 = nil;
        u24 = nil;
        u27 = false;

        if u26 then
            u26 = false;
            pcall(function() -- Line: 1779
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
        end;

        HideAllMoveFrames();

        return;
    end;

    local success, result = pcall(GetWeaponProperties, u20.Name);
    local v304;

    if success and (result and result.Type) then
        v304 = u55[result.Type];
    else
        v304 = nil;
    end;

    if v304 ~= v298 then
        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u15 = nil;
        u16 = nil;
        u18 = false;
        u19 = nil;

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        u9 = false;
        u11 = nil;
        u12 = nil;
        u13 = nil;
        HideAllMoveFrames();
        u20 = nil;
        u21 = false;
        u22 = nil;
        u23 = nil;
        u24 = nil;
        u27 = false;

        if u26 then
            u26 = false;
            pcall(function() -- Line: 1779
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
        end;

        HideAllMoveFrames();

        return;
    end;

    local v305, v306 = IsItemEquippedInCategory(u20._id, v298);

    if v305 and v306 then
        if v299 and v306 ~= v299 then
            SwapLoadoutSkins(v298, v306, v299);
        end;
    else
        local v307, v308 = IsWeaponEquippedInCategory(u20.Name, v298);

        if v307 and v308 then
            EquipLoadoutSkin(v298, v308, u20._id);
        else
            EquipLoadoutSkin(v298, v299 or 1, u20._id);
        end;
    end;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    u9 = false;
    u11 = nil;
    u12 = nil;
    u13 = nil;
    HideAllMoveFrames();
    u20 = nil;
    u21 = false;
    u22 = nil;
    u23 = nil;
    u24 = nil;
    u27 = false;

    if u26 then
        u26 = false;
        pcall(function() -- Line: 1779
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
    end;

    HideAllMoveFrames();
end;

local function u310() -- Line: 2307
    -- upvalues: u66 (ref), u20 (ref), u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (copy), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (copy), GuiService (copy)
    if not (u66 and u66.Visible) then
        return;
    end;

    if u20 then
        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u15 = nil;
        u16 = nil;
        u18 = false;
        u19 = nil;

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        u9 = false;
        u11 = nil;
        u12 = nil;
        u13 = nil;
        HideAllMoveFrames();
        u20 = nil;
        u21 = false;
        u22 = nil;
        u23 = nil;
        u24 = nil;
        u27 = false;

        if u26 then
            u26 = false;
            pcall(function() -- Line: 1779
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
        end;

        HideAllMoveFrames();
    end;
end;

local function NormalizeAssetId(p311) -- Line: 2318
    if typeof(p311) == "string" and p311 ~= "" then
        return p311:gsub("^rbxassetid://", "");
    end;

    return nil;
end;

local function GetDropShadowImageForItem(p312, p313) -- Line: 2326
    -- upvalues: WeaponDropShadows (copy)
    local v314;

    if typeof(p313) == "string" and p313 ~= "" then
        v314 = p313:gsub("^rbxassetid://", "");
    else
        v314 = nil;
    end;

    local v315 = WeaponDropShadows[p312.Name] or (WeaponDropShadows[p312.Skin] or p313 and WeaponDropShadows[p313]);

    if v315 then
        v314 = v315;
    elseif v314 then
        v314 = WeaponDropShadows[v314];
    end;

    return v314;
end;

function u1.HandleSpecialItemDrop() -- Line: 2338
    -- upvalues: u11 (ref), u13 (ref), u59 (copy), u12 (ref), GetWeaponProperties (copy), EquipSpecialItem (copy)
    if not (u11 and u13) then
        return;
    end;

    local v316 = u59[u13];

    if not v316 and u12 then
        local success, result = pcall(GetWeaponProperties, u12);

        if success and result then
            v316 = result.Class == "Melee" and "Equipped Melee" or (result.Class == "Glove" and "Equipped Gloves" or v316);
        end;
    end;

    if not v316 then
        return;
    end;

    EquipSpecialItem(v316, u11);
end;

function u1.HandleDrop(p317, p318) -- Line: 2368
    -- upvalues: u11 (ref), u12 (ref), u3 (ref), GetWeaponProperties (copy), u55 (copy), DataController (copy), LocalPlayer (copy), IsItemEquippedInCategory (copy), SwapLoadoutSkins (copy), IsWeaponEquippedInCategory (copy), EquipLoadoutSkin (copy)
    if not (u11 and u12) then
        return;
    end;

    local v319 = u12;
    local v320 = u3;
    local v321;

    if v319 and (type(v319) == "string" and v319 ~= "") then
        local success, result = pcall(GetWeaponProperties, v319);

        if success and (result and result.Team) then
            v321 = result.Team == "Both" and true or result.Team == v320;
        else
            v321 = false;
        end;
    else
        v321 = false;
    end;

    if not v321 then
        return;
    end;

    local success, result = pcall(GetWeaponProperties, u12);
    local v322;

    if success and (result and result.Type) then
        v322 = u55[result.Type];
    else
        v322 = nil;
    end;

    if v322 ~= p317 then
        return;
    end;

    local v323 = DataController.Get(LocalPlayer, "Loadout");

    if not v323 then
        return;
    end;

    local v324 = v323[u3];

    if not (v324 and (v324.Loadout and v324.Loadout[p317])) then
        return;
    end;

    local Options = v324.Loadout[p317].Options;
    local v325, v326 = IsItemEquippedInCategory(u11, p317);

    if v325 and v326 then
        if p318 and (p318 >= 1 and (p318 <= #Options and v326 ~= p318)) then
            SwapLoadoutSkins(p317, v326, p318);
        end;

        return;
    end;

    local v327, v328 = IsWeaponEquippedInCategory(u12, p317);

    if v327 and v328 then
        EquipLoadoutSkin(p317, v328, u11);

        return;
    end;

    EquipLoadoutSkin(p317, #Options <= 0 and 1 or math.clamp(p318 or 1, 1, #Options), u11);
end;

local function BeginActualDrag(p329) -- Line: 2430
    -- upvalues: u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u9 (ref), u20 (ref), u26 (ref), CreateDragIcon (copy), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u59 (copy), ShowPlayerFrameMoveFrame (copy), GetWeaponProperties (copy), u55 (copy), ShowMoveFramesForCategory (copy), PlayerGui (copy), UserInputService (copy), u54 (copy), u14 (ref), RunServiceController (copy)
    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;

    if u9 then
        return;
    end;

    if u20 or u26 then
        return;
    end;

    local v330 = CreateDragIcon(p329);

    if not v330 then
        return;
    end;

    u9 = true;
    u10 = v330;
    u11 = p329._id;
    u12 = p329.Name;
    u13 = p329.Type;

    if u59[p329.Type] then
        ShowPlayerFrameMoveFrame();
    else
        local success, result = pcall(GetWeaponProperties, p329.Name);
        local v331;

        if success and (result and result.Type) then
            v331 = u55[result.Type];
        else
            v331 = nil;
        end;

        if v331 then
            ShowMoveFramesForCategory(v331, p329.Name);
        else
            local success2, result2 = pcall(GetWeaponProperties, p329.Name);

            if success2 and (result2 and (result2.Class == "Melee" or result2.Class == "Glove")) then
                ShowPlayerFrameMoveFrame();
            end;
        end;
    end;

    local MainGui = PlayerGui:FindFirstChild("MainGui");

    if MainGui then
        v330.Parent = MainGui;
    else
        v330.Parent = PlayerGui;
    end;

    local v332 = UserInputService:GetMouseLocation();
    v330.Position = UDim2.fromOffset(v332.X + u54.X, v332.Y + u54.Y);
    u14 = RunServiceController.BindToRenderStep("UI.Loadout.DragIcon", function() -- Line: 2482
        -- upvalues: u10 (ref), UserInputService (ref), u54 (ref)
        if u10 then
            local v333 = UserInputService:GetMouseLocation();
            u10.Position = UDim2.fromOffset(v333.X + u54.X, v333.Y + u54.Y);
        end;
    end);
end;

function u1.OnItemMouseDown(p334, p335, p336) -- Line: 2493
    -- upvalues: UserInputService (copy), u20 (ref), u26 (ref), u9 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u17 (ref), RunServiceController (copy), BeginActualDrag (copy)
    local v337 = UserInputService:GetMouseLocation();

    if u20 or u26 then
        return;
    end;

    if u9 or u15 then
        return;
    end;

    u15 = p334;
    u16 = v337;
    u18 = p335 or false;
    u19 = p336;
    u17 = RunServiceController.BindToRenderStep("UI.Loadout.PendingDrag", function() -- Line: 2513
        -- upvalues: u15 (ref), u16 (ref), u20 (ref), u26 (ref), u17 (ref), u18 (ref), u19 (ref), UserInputService (ref), BeginActualDrag (ref)
        if u15 and u16 then
            if u20 or u26 then
                if u17 then
                    u17:Disconnect();
                    u17 = nil;
                end;

                u15 = nil;
                u16 = nil;
                u18 = false;
                u19 = nil;

                return;
            end;

            if (UserInputService:GetMouseLocation() - u16).Magnitude >= 10 then
                local v338 = u15;

                if u17 then
                    u17:Disconnect();
                    u17 = nil;
                end;

                u15 = nil;
                u16 = nil;
                u18 = false;
                u19 = nil;
                BeginActualDrag(v338);
            end;
        end;
    end);
end;

function u1.OnItemClick(p339) -- Line: 2534
    -- upvalues: u7 (ref), u1 (copy)
    u7 = nil;
    u1.SortByWeapon(p339.Name);
end;

function u1.EndDrag() -- Line: 2557
    -- upvalues: u15 (ref), u9 (ref), u18 (ref), u19 (ref), UserInputService (copy), u17 (ref), u16 (ref), u1 (copy), ShowContextMenu (copy), GuiService (copy), u13 (ref), u59 (copy), u12 (ref), GetWeaponProperties (copy), IsMouseOverPlayerFrame (copy), GetDropTargetCategory (copy), u14 (ref), u10 (ref), u11 (ref), HideAllMoveFrames (copy)
    if u15 and not u9 then
        local v340 = u15;
        local v341 = u18;
        local v342 = u19;
        local v343 = UserInputService:GetMouseLocation();

        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u15 = nil;
        u16 = nil;
        u18 = false;
        u19 = nil;

        if v341 then
            u1.OnItemClick(v340);

            return;
        end;

        ShowContextMenu(v340, v343, v342, false);

        return;
    end;

    if not u9 then
        return;
    end;

    local v344 = UserInputService:GetMouseLocation();
    local v345 = GuiService:GetGuiInset();
    local v346 = Vector2.new(v344.X - v345.X, v344.Y - v345.Y);
    local v347 = u13 and u59[u13];

    if not v347 and u12 then
        local success, result = pcall(GetWeaponProperties, u12);
        v347 = success and (result and (result.Class == "Melee" or result.Class == "Glove")) and true or v347;
    end;

    if v347 and IsMouseOverPlayerFrame(v346) then
        u1.HandleSpecialItemDrop();
    elseif not v347 then
        local v348, v349 = GetDropTargetCategory(v346);

        if v348 then
            u1.HandleDrop(v348, v349);
        end;
    end;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    u9 = false;
    u11 = nil;
    u12 = nil;
    u13 = nil;
    HideAllMoveFrames();
end;

function u1.CreateItemTemplate(u350) -- Line: 2610
    -- upvalues: Profiler (copy), GetResolvedSkinInformation (copy), ReplicatedStorage (copy), Rarities (copy), u66 (ref), Skins (copy), GetSkinDisplayName (copy), WeaponDropShadows (copy), TweenService (copy), u1 (copy), UserInputService (copy), ShowContextMenu (copy), u20 (ref), ControllerPickUpItem (copy), UpdateItemStatusFrame (copy)
    Profiler.mark("UI.Loadout.CreateItemTemplate");
    local v351 = GetResolvedSkinInformation(u350.Name, u350.Skin);

    if v351 then
        local u352 = ReplicatedStorage.Assets.UI.Loadout.ItemTemplate:Clone();
        u352.ItemContent.Rarity.BackgroundColor3 = Rarities[v351.rarity].Color;
        u352.Parent = u66.Container.List.Container;
        local v353 = Skins.GetWearImageForFloat(v351, u350.Float or 0.9999) or (v351.imageAssetId or "");
        u352.ItemContent.Content.Icon.Image = v353;
        local Name = u350.Name;
        local v354 = Name and Name:find("Zeus") and "Taser" or Name;

        if u350.StatTrack then
            v354 = "KillTrak™ " .. v354 or v354;
        end;

        if u350.Type == "Melee" then
            v354 = "★ " .. v354;
        end;

        u352.Bottom.Footer.WeaponName.Text = v354;
        u352.Bottom.Footer.SkinName.Text = GetSkinDisplayName(u350.Skin);
        u352.Name = u350._id;
        local v355;

        if typeof(v353) == "string" and v353 ~= "" then
            v355 = v353:gsub("^rbxassetid://", "");
        else
            v355 = nil;
        end;

        local v356 = WeaponDropShadows[u350.Name] or (WeaponDropShadows[u350.Skin] or v353 and WeaponDropShadows[v353]);

        if v356 then
            v355 = v356;
        elseif v355 then
            v355 = WeaponDropShadows[v355];
        end;

        local u357;

        if v355 then
            u357 = u352.ItemContent.Content.Icon:Clone();
            u357.Name = "DropShadow";
            u357.Image = v355;
            u357.ImageTransparency = 1;
            u357.ZIndex = u352.ItemContent.Content.Icon.ZIndex - 1;
            u357.Parent = u352.ItemContent.Content;
        else
            u357 = nil;
        end;

        local Icon = u352.ItemContent.Content.Icon;
        local Position = Icon.Position;
        local u358 = UDim2.new(0, 0, -0.05, 0);
        local u359 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        u352.MouseEnter:Connect(function() -- Line: 2662
            -- upvalues: Position (copy), u358 (copy), TweenService (ref), Icon (copy), u359 (copy), u357 (ref)
            TweenService:Create(Icon, u359, {
                Position = UDim2.new(Position.X.Scale + u358.X.Scale, Position.X.Offset + u358.X.Offset, Position.Y.Scale + u358.Y.Scale, Position.Y.Offset + u358.Y.Offset)
            }):Play();

            if u357 then
                TweenService:Create(u357, u359, {
                    ImageTransparency = 0.3
                }):Play();
            end;
        end);
        u352.MouseLeave:Connect(function() -- Line: 2679
            -- upvalues: TweenService (ref), Icon (copy), u359 (copy), Position (copy), u357 (ref)
            TweenService:Create(Icon, u359, {
                Position = Position
            }):Play();

            if u357 then
                TweenService:Create(u357, u359, {
                    ImageTransparency = 1
                }):Play();
            end;
        end);
        u352.MouseButton1Down:Connect(function() -- Line: 2690
            -- upvalues: u1 (ref), u350 (copy), u352 (copy)
            u1.OnItemMouseDown(u350, false, u352);
        end);
        u352.MouseButton2Click:Connect(function() -- Line: 2695
            -- upvalues: UserInputService (ref), ShowContextMenu (ref), u350 (copy), u352 (copy)
            ShowContextMenu(u350, UserInputService:GetMouseLocation(), u352, false);
        end);
        u352.Selectable = true;
        u352.SelectionGained:Connect(function() -- Line: 2704
            -- upvalues: Position (copy), u358 (copy), TweenService (ref), Icon (copy), u359 (copy), u357 (ref)
            TweenService:Create(Icon, u359, {
                Position = UDim2.new(Position.X.Scale + u358.X.Scale, Position.X.Offset + u358.X.Offset, Position.Y.Scale + u358.Y.Scale, Position.Y.Offset + u358.Y.Offset)
            }):Play();

            if u357 then
                TweenService:Create(u357, u359, {
                    ImageTransparency = 0.3
                }):Play();
            end;
        end);
        u352.SelectionLost:Connect(function() -- Line: 2718
            -- upvalues: TweenService (ref), Icon (copy), u359 (copy), Position (copy), u357 (ref)
            TweenService:Create(Icon, u359, {
                Position = Position
            }):Play();

            if u357 then
                TweenService:Create(u357, u359, {
                    ImageTransparency = 1
                }):Play();
            end;
        end);
        u352.Activated:Connect(function(p360) -- Line: 2727
            -- upvalues: u20 (ref), ControllerPickUpItem (ref), u352 (copy)
            if p360 and (p360.UserInputType == Enum.UserInputType.Gamepad1 and not u20) then
                ControllerPickUpItem(u352);
            end;
        end);
        UpdateItemStatusFrame(u352, u350._id);
    end;
end;

function u1.CreateLoadoutTemplate(p361, u362, p363) -- Line: 2744
    -- upvalues: Profiler (copy), GetResolvedSkinInformation (copy), GetWeaponProperties (copy), ReplicatedStorage (copy), Rarities (copy), Skins (copy), WeaponDropShadows (copy), TweenService (copy), u29 (ref), u1 (copy), UserInputService (copy), ShowContextMenu (copy), u20 (ref), ControllerPickUpItem (copy)
    Profiler.mark("UI.Loadout.CreateLoadoutTemplate");
    local v364 = GetResolvedSkinInformation(u362.Name, u362.Skin);
    local success, result = pcall(GetWeaponProperties, u362.Name);
    local v365 = success and (result and result.Cost) or 0;

    if v364 then
        local u366 = ReplicatedStorage.Assets.UI.Loadout:FindFirstChild(p363 == "Counter-Terrorists" and "LoadoutTemplateCT" or "LoadoutTemplateT"):Clone();
        u366.Rarity.BackgroundColor3 = Rarities[v364.rarity].Color;
        u366.Parent = p361;
        u366.Name = u362._id;
        local v367 = Skins.GetWearImageForFloat(v364, u362.Float or 0.9999) or (v364.imageAssetId or "");
        u366.Content.Footer.Cost.Text = "$" .. tostring(v365);
        u366.Content.Footer.Frame.WeaponName.Text = u362.Name:find("Zeus") and "Taser" or u362.Name;
        u366.Content.Footer.Frame.SkinName.Text = u362.Skin;
        u366.Content.Icon.Image = v367;
        local v368;

        if typeof(v367) == "string" and v367 ~= "" then
            v368 = v367:gsub("^rbxassetid://", "");
        else
            v368 = nil;
        end;

        local v369 = WeaponDropShadows[u362.Name] or (WeaponDropShadows[u362.Skin] or v367 and WeaponDropShadows[v367]);

        if v369 then
            v368 = v369;
        elseif v368 then
            v368 = WeaponDropShadows[v368];
        end;

        local u370;

        if v368 then
            u370 = u366.Content.Icon:Clone();
            u370.Name = "DropShadow";
            u370.Image = v368;
            u370.ImageTransparency = 1;
            u370.ZIndex = u366.Content.Icon.ZIndex - 1;
            u370.Parent = u366.Content;
        else
            u370 = nil;
        end;

        local Icon = u366.Content.Icon;
        local Position = Icon.Position;
        local u371 = UDim2.new(0, 0, -0.05, 0);
        local u372 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        u366.Button.MouseEnter:Connect(function() -- Line: 2793
            -- upvalues: Position (copy), u371 (copy), TweenService (ref), Icon (copy), u372 (copy), u370 (ref)
            TweenService:Create(Icon, u372, {
                Position = UDim2.new(Position.X.Scale + u371.X.Scale, Position.X.Offset + u371.X.Offset, Position.Y.Scale + u371.Y.Scale, Position.Y.Offset + u371.Y.Offset)
            }):Play();

            if u370 then
                TweenService:Create(u370, u372, {
                    ImageTransparency = 0.3
                }):Play();
            end;
        end);
        u366.Button.MouseLeave:Connect(function() -- Line: 2810
            -- upvalues: TweenService (ref), Icon (copy), u372 (copy), Position (copy), u370 (ref)
            TweenService:Create(Icon, u372, {
                Position = Position
            }):Play();

            if u370 then
                TweenService:Create(u370, u372, {
                    ImageTransparency = 1
                }):Play();
            end;
        end);
        local _ = u29 == p361.Name;
        u366.Button.MouseButton1Down:Connect(function() -- Line: 2827
            -- upvalues: u1 (ref), u362 (copy), u366 (copy)
            u1.OnItemMouseDown(u362, true, u366);
        end);
        u366.Button.MouseButton2Click:Connect(function() -- Line: 2831
            -- upvalues: UserInputService (ref), ShowContextMenu (ref), u362 (copy), u366 (copy)
            ShowContextMenu(u362, UserInputService:GetMouseLocation(), u366, false);
        end);
        u366.Button.MouseEnter:Connect(function() -- Line: 2836
            -- upvalues: u1 (ref), u362 (copy)
            u1.OnLoadoutItemHover(u362);
        end);
        u366.Button.MouseLeave:Connect(function() -- Line: 2839
            -- upvalues: u1 (ref)
            u1.OnLoadoutItemUnhover();
        end);
        u366.Button.Selectable = true;
        u366.Button.SelectionGained:Connect(function() -- Line: 2847
            -- upvalues: u1 (ref), u362 (copy), Position (copy), u371 (copy), TweenService (ref), Icon (copy), u372 (copy), u370 (ref)
            u1.OnLoadoutItemHover(u362);
            TweenService:Create(Icon, u372, {
                Position = UDim2.new(Position.X.Scale + u371.X.Scale, Position.X.Offset + u371.X.Offset, Position.Y.Scale + u371.Y.Scale, Position.Y.Offset + u371.Y.Offset)
            }):Play();

            if u370 then
                TweenService:Create(u370, u372, {
                    ImageTransparency = 0.3
                }):Play();
            end;
        end);
        u366.Button.SelectionLost:Connect(function() -- Line: 2862
            -- upvalues: TweenService (ref), Icon (copy), u372 (copy), Position (copy), u370 (ref)
            TweenService:Create(Icon, u372, {
                Position = Position
            }):Play();

            if u370 then
                TweenService:Create(u370, u372, {
                    ImageTransparency = 1
                }):Play();
            end;
        end);
        u366.Button.Activated:Connect(function(p373) -- Line: 2871
            -- upvalues: u20 (ref), ControllerPickUpItem (ref), u366 (copy)
            if p373 and (p373.UserInputType == Enum.UserInputType.Gamepad1 and not u20) then
                ControllerPickUpItem(u366.Button);
            end;
        end);
    end;
end;

function u1.PopulateCategoryDropdown() -- Line: 2885
end;

function u1.PopulateWeaponDropdown() -- Line: 2917
    -- upvalues: u66 (ref), ClearDropdownOptions (copy), CreateDropdownOption (copy), u1 (copy), GetWeaponsInCategory (copy), u4 (ref)
    local Scroll = u66.Container.List.Top.Weapon.DropdownContent.Scroll;

    if not (Scroll and (Scroll:IsA("Frame") or Scroll:IsA("ScrollingFrame"))) then
        return;
    end;

    ClearDropdownOptions(Scroll);
    CreateDropdownOption(Scroll, "All", "All Weapons", 0, function() -- Line: 2929
        -- upvalues: u1 (ref), Scroll (copy)
        u1.SortByWeapon(nil);
        Scroll.Parent.Visible = false;
    end);
    local v374 = GetWeaponsInCategory(u4);

    for i, v in ipairs(v374) do
        CreateDropdownOption(Scroll, v, v, i, function() -- Line: 2938
            -- upvalues: u1 (ref), v (copy), Scroll (copy)
            u1.SortByWeapon(v);
            Scroll.Parent.Visible = false;
        end);
    end;
end;

function u1.SortByCategory(p375) -- Line: 2951
    -- upvalues: u4 (ref), u8 (ref), u7 (ref), u66 (ref), u1 (copy), GetWeaponProperties (copy), u58 (copy), u52 (ref), u51 (ref), u49 (ref), GetSortedLoadoutData (copy), UpdateLoadoutTemplates (copy)
    u4 = p375;
    u8 = nil;
    u7 = nil;
    local _ = u66.Container.List.Container;
    u66.Container.List.Top.Filter.Container.Left.Title.Text = p375 or "All Categories";
    u1.PopulateWeaponDropdown();
    u66.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";
    local Reset = u66.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u4 ~= nil or u7 ~= nil) and true or u66.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;

    local function _(p376, p377) -- Line: 2968
        -- upvalues: GetWeaponProperties (ref), u58 (ref)
        local success, result = pcall(GetWeaponProperties, p376.Name);
        local success2, result2 = pcall(GetWeaponProperties, p377.Name);
        local v378 = u58[success and (result and result.Type) or "ZZZ"] or 99;
        local v379 = u58[success2 and (result2 and result2.Type) or "ZZZ"] or 99;

        if v378 == v379 then
            return (p376.Name or "") < (p377.Name or "");
        end;

        return v378 < v379;
    end;

    if u66 and u66.Visible then
        u49 = GetSortedLoadoutData();
        UpdateLoadoutTemplates();

        return;
    end;

    u52 = true;
    u51 = true;
end;

function u1.SortByWeapon(p380, p381) -- Line: 2985
    -- upvalues: u8 (ref), u7 (ref), u66 (ref), Sort (copy), u5 (ref), LocalPlayer (copy), u134 (ref), u52 (ref), u51 (ref), u49 (ref), GetSortedLoadoutData (copy), UpdateLoadoutTemplates (copy), u4 (ref)
    u8 = p380 and ({
        weaponName = p380,
        skinName = p381
    } or nil) or nil;
    u7 = nil;
    local _ = u66.Container.List.Container;
    u66.Container.List.Top.Weapon.Container.Left.Title.Text = p380 or "All Weapons";

    if Sort.GetSortComparisonFunction(u5, LocalPlayer, function() -- Line: 2993
        -- upvalues: u134 (ref)
        return u134;
    end) then
        if u66 and u66.Visible then
            u49 = GetSortedLoadoutData();
            UpdateLoadoutTemplates();
        else
            u52 = true;
            u51 = true;
        end;
    end;

    local Reset = u66.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u4 ~= nil or u7 ~= nil) and true or u66.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;
end;

function u1.SortBySkinMetadata(p382) -- Line: 3005
    -- upvalues: Profiler (copy), u5 (ref), u66 (ref), Sort (copy), LocalPlayer (copy), u134 (ref), u52 (ref), u51 (ref), u49 (ref), GetSortedLoadoutData (copy), UpdateLoadoutTemplates (copy)
    Profiler.mark((`UI.Loadout.SortBySkinMetadata.{p382}`));
    u5 = p382;
    local _ = u66.Container.List.Container;
    u66.Container.List.Top.Filter.Container.Left.Title.Text = p382;

    if Sort.GetSortComparisonFunction(p382, LocalPlayer, function() -- Line: 3014
        -- upvalues: u134 (ref)
        return u134;
    end) then
        if not (u66 and u66.Visible) then
            u52 = true;
            u51 = true;

            return;
        end;

        u49 = GetSortedLoadoutData();
        UpdateLoadoutTemplates();
    end;
end;

function u1.UpdateInventoryContainer() -- Line: 3024
    -- upvalues: Profiler (copy), u66 (ref), u52 (ref), u51 (ref), u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (copy), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (copy), GuiService (copy), DataController (copy), LocalPlayer (copy), u1 (copy), u5 (ref)
    Profiler.mark("UI.Loadout.UpdateInventoryContainer");

    if not u66 then
        return;
    end;

    if not u66.Visible then
        u52 = true;
        u51 = true;

        return;
    end;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    u9 = false;
    u11 = nil;
    u12 = nil;
    u13 = nil;
    HideAllMoveFrames();
    u20 = nil;
    u21 = false;
    u22 = nil;
    u23 = nil;
    u24 = nil;
    u27 = false;

    if u26 then
        u26 = false;
        pcall(function() -- Line: 1779
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
    end;

    HideAllMoveFrames();
    local v383 = DataController.Get(LocalPlayer, "Inventory");
    local v384 = {};

    for _, v in ipairs(v383) do
        if v and v._id then
            v384[v._id] = true;
        end;
    end;

    for _, child in ipairs(u66.Container.List.Container:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIPadding" and not v384[child.Name])) then
            child:Destroy();
        end;
    end;

    u1.PopulateCategoryDropdown();
    u1.PopulateWeaponDropdown();
    u1.SortBySkinMetadata(u5);
end;

function u1.UpdateLoadoutContainer(p385) -- Line: 3067
    -- upvalues: Profiler (copy), u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (copy), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (copy), GuiService (copy), DataController (copy), LocalPlayer (copy), u66 (ref), u3 (ref), ClearFrame (copy), u1 (copy)
    Profiler.mark("UI.Loadout.UpdateLoadoutContainer");

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    u15 = nil;
    u16 = nil;
    u18 = false;
    u19 = nil;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    u9 = false;
    u11 = nil;
    u12 = nil;
    u13 = nil;
    HideAllMoveFrames();
    u20 = nil;
    u21 = false;
    u22 = nil;
    u23 = nil;
    u24 = nil;
    u27 = false;

    if u26 then
        u26 = false;
        pcall(function() -- Line: 1779
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
        GuiService.AutoSelectGuiEnabled = true;
    end;

    HideAllMoveFrames();
    local v386 = DataController.Get(LocalPlayer, "Inventory");
    local Teams = u66.Container.Teams;
    local v387 = u3 == "Counter-Terrorists" and Teams.CT.Guns or Teams.T.Guns;
    local v388, v389, v390;
    v388, v389, v390 = ipairs({ "Mid Tier", "Pistols", "Rifles" });
    local v391, v392;

    if type(v388) == "function" then
        v391, v392 = v388(v389, v390);
    else
        v391, v392 = next(v388, v390);
    end;

    v390 = v391;
    local List = v387:FindFirstChild(v392).List;
    ClearFrame(List, { "UIListLayout", "Frame" });
    local v393 = p385[u3];
    local v394 = `[Loadout] Failed to get player team loadout for {u3}`;
    assert(v393, v394);
    local v395, v396, v397;
    v395, v396, v397 = ipairs(v393.Loadout[v392].Options);

    while true do
        local v398, v399 = v395(v396, v397);

        if v398 == nil then
            break;
        end;

        v397 = v398;

        for _, v in ipairs(v386) do
            if v._id == v399 then
                break;
            end;
        end;

        if v then
            u1.CreateLoadoutTemplate(List, v, u3);
        end;
    end;
end;

function u1.UpdateSidebarFrames(p400, p401) -- Line: 3098
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u3 (ref), u66 (ref), u60 (copy), GetResolvedSkinInformation (copy), Skins (copy), Rarities (copy)
    Profiler.mark("UI.Loadout.UpdateSidebarFrames");
    local v402 = DataController.Get(LocalPlayer, "Inventory");
    local v403 = p401 or u3;
    local v404 = u66.Container.Teams:FindFirstChild(v403 == "Counter-Terrorists" and "CT" or "T");

    if not v404 then
        return;
    end;

    local Equipments = v404:FindFirstChild("Equipments");

    if not Equipments then
        return;
    end;

    local v405 = p400[v403];

    if not (v405 and v405.Equipped) then
        return;
    end;

    for i, v in pairs(u60) do
        local v406 = v405.Equipped[i];
        local v407 = Equipments:FindFirstChild(v);

        if v407 then
            local v408 = nil;
            local v409 = false;
            local v410;

            if not v406 or v406 == "" then
                v410 = v408;

                if not v409 then
                    v407.Container.Icon.Visible = true;
                    v407.Rarity.Visible = false;
                end;

                if v407 and (v == "Melee" or (v == "Gloves" or v == "Zeus")) then
                    if v410 then
                        v407:SetAttribute("EquippedItemId", v410._id);
                    else
                        v407:SetAttribute("EquippedItemId", nil);
                    end;

                    v407:SetAttribute("SidebarName", v);
                    v407:SetAttribute("TeamKey", v403 == "Counter-Terrorists" and "CT" or "T");
                end;
            end;

            for _, v410 in ipairs(v402) do
                if v410._id == v406 then
                    break;
                end;
            end;

            if v410 then
                local v411 = GetResolvedSkinInformation(v410.Name, v410.Skin);

                if v411 then
                    local v412 = Skins.GetWearImageForFloat(v411, v410.Float or 0.9999) or (v411.imageAssetId or "");
                    v407.Container.Icon.Image = v412;
                    v407.Container.Icon.Visible = true;
                    v407.Rarity.BackgroundColor3 = Rarities[v411.rarity].Color;
                    v409 = true;
                end;
            else
                v410 = v408;
            end;

            if not v409 then
                v407.Container.Icon.Visible = true;
                v407.Rarity.Visible = false;
            end;

            if v407 and (v == "Melee" or (v == "Gloves" or v == "Zeus")) then
                if v410 then
                    v407:SetAttribute("EquippedItemId", v410._id);
                else
                    v407:SetAttribute("EquippedItemId", nil);
                end;

                v407:SetAttribute("SidebarName", v);
                v407:SetAttribute("TeamKey", v403 == "Counter-Terrorists" and "CT" or "T");
            end;
        end;
    end;
end;

local function SetupViewportCharacters() -- Line: 3179
    -- upvalues: Profiler (copy), u66 (ref), Viewport (copy), Characters (copy), u43 (copy)
    Profiler.mark("UI.Loadout.SetupViewportCharacters");
    local Teams = u66.Container.Teams;

    for _, v in ipairs({ "CT", "T" }) do
        local v413 = Viewport.VIEWPORT_CHARACTER_CONFIG[v];
        local v414 = Teams:FindFirstChild(v);

        if v414 then
            local Player = v414.Viewport:FindFirstChild("Player");

            if Player then
                for _, child in ipairs(Player:GetChildren()) do
                    if child:IsA("WorldModel") or child:IsA("Camera") then
                        child:Destroy();
                    end;
                end;

                local v415 = Characters:FindFirstChild(v413.Character);

                if v415 then
                    local WorldModel = Instance.new("WorldModel");
                    WorldModel.Name = "CharacterWorldModel";
                    WorldModel.Parent = Player;
                    local v416 = v415:Clone();
                    v416.Name = "ViewportCharacter";
                    v416.Parent = WorldModel;
                    u43[v] = v416;
                    local v417 = v413.CharacterOffset or CFrame.new(0, 0, 0);

                    if v416.PrimaryPart then
                        v416:SetPrimaryPartCFrame(v417);
                    else
                        v416:PivotTo(v417);
                    end;

                    local v418 = v416:FindFirstChildOfClass("Humanoid");

                    if v418 and v413.IdleAnimation then
                        local v419 = v418:FindFirstChildOfClass("Animator");

                        if not v419 then
                            v419 = Instance.new("Animator");
                            v419.Parent = v418;
                        end;

                        local Animation = Instance.new("Animation");
                        Animation.AnimationId = v413.IdleAnimation;
                        local v420 = v419:LoadAnimation(Animation);
                        v420.Looped = true;
                        v420:Play();
                    end;

                    local Camera = Instance.new("Camera");
                    Camera.Name = "ViewportCamera";
                    Camera.CameraType = Enum.CameraType.Scriptable;
                    Camera.FieldOfView = 50;
                    Camera.CFrame = CFrame.new(0, 0, 0) * v413.CameraOffset;
                    Camera.Parent = Player;
                    Player.CurrentCamera = Camera;
                end;
            end;
        end;
    end;
end;

local function EquipGlovesToViewport(p421) -- Line: 3267
    -- upvalues: u43 (copy), u46 (copy), DataController (copy), LocalPlayer (copy), Skins (copy), AttachGlovesToCharacter (copy)
    local v422 = u43[p421];

    if not v422 then
        return;
    end;

    local v423 = u46[p421];

    if v423 then
        for _, v in ipairs(v423) do
            if v and v.Parent then
                v:Destroy();
            end;
        end;

        u46[p421] = {};
    end;

    local v424 = p421 == "CT" and "Counter-Terrorists" or "Terrorists";
    local v425 = DataController.Get(LocalPlayer, "Loadout");

    if not (v425 and v425[v424]) then
        return;
    end;

    local v426 = v425[v424].Equipped and v425[v424].Equipped["Equipped Gloves"];

    if not v426 then
        return;
    end;

    local v427 = DataController.Get(LocalPlayer, "Inventory");
    local v428 = nil;

    for _, v in ipairs(v427) do
        if v._id == v426 then
            v428 = v;
            break;
        end;
    end;

    if not v428 then
        return;
    end;

    local v429 = Skins.GetGloves(v428.Name, v428.Skin, v428.Float);

    if not v429 then
        return;
    end;

    u46[p421] = AttachGlovesToCharacter(v429:GetChildren(), v422, v422);
    v429:Destroy();
end;

local function EquipWeaponToViewport(p430, p431) -- Line: 3326
    -- upvalues: u43 (copy), u48 (copy), u45 (copy), GetWeaponProperties (copy), GetAnimationForWeaponType (copy), Viewport (copy), u44 (copy), Attachments (copy), Skins (copy)
    local v432 = u43[p430];

    if not v432 then
        return;
    end;

    if p431 and u48[p430] == p431._id then
        local v433 = u45[p430];

        if not (v433 and v433.IsPlaying) then
            local v434 = v432:FindFirstChildOfClass("Humanoid");
            local v435 = v434 and v434:FindFirstChildOfClass("Animator");

            if v435 then
                local v436 = nil;

                if p431.Type == "Melee" then
                    v436 = "Melee";
                else
                    local success, result = pcall(GetWeaponProperties, p431.Name);

                    if success and result then
                        v436 = GetAnimationForWeaponType(result.Type, result.AimingOptions, result.MuzzleType, result.Class);
                    end;
                end;

                if v436 then
                    local Name = p431.Name;
                    local v437;

                    if v436 and Viewport.ANIMATION_MAPPING[v436] then
                        local v438 = Viewport.ANIMATION_MAPPING[v436];

                        if Name and v438[Name] then
                            v437 = v438[Name];
                        else
                            v437 = v438.Default;
                        end;
                    else
                        v437 = nil;
                    end;

                    if v437 then
                        local v439 = v435:LoadAnimation(v437);
                        v439.Looped = true;
                        v439.Priority = Enum.AnimationPriority.Action;
                        v439:Play();
                        u45[p430] = v439;
                    end;
                end;
            end;
        end;

        return;
    end;

    local v440 = u45[p430];

    if v440 then
        v440:Stop();
        u45[p430] = nil;
    end;

    local v441 = u44[p430];

    if v441 then
        v441:Destroy();
        u44[p430] = nil;
    end;

    u48[p430] = nil;

    for _, v in pairs({ Attachments.DEFAULT_JOINT_PART, "UpperTorso", "LeftHand" }) do
        local v442 = v432:FindFirstChild(v);

        if v442 then
            local WeaponAttachment = v442:FindFirstChild("WeaponAttachment");

            if WeaponAttachment then
                WeaponAttachment:Destroy();
            end;

            local WeaponAttachmentHandleR = v442:FindFirstChild("WeaponAttachmentHandleR");

            if WeaponAttachmentHandleR then
                WeaponAttachmentHandleR:Destroy();
            end;

            local WeaponAttachmentHandleL = v442:FindFirstChild("WeaponAttachmentHandleL");

            if WeaponAttachmentHandleL then
                WeaponAttachmentHandleL:Destroy();
            end;
        end;
    end;

    if not p431 then
        return;
    end;

    local v443 = Skins.GetCharacterModel(p431.Name, p431.Skin, p431.Float, p431.StatTrack, p431.NameTag);

    if not v443 then
        return;
    end;

    v443.Name = p431.Name;
    local v444 = v432:FindFirstChild(Attachments.WEAPON_JOINT_PARTS[p431.Name] or Attachments.DEFAULT_JOINT_PART);

    if not v444 then
        v443:Destroy();

        return;
    end;

    if not v443.PrimaryPart then
        local Weapon = v443:FindFirstChild("Weapon");

        if Weapon then
            Weapon = Weapon:FindFirstChild("Insert");
        end;

        if Weapon then
            v443.PrimaryPart = Weapon;
        else
            local Insert = v443:FindFirstChild("Insert", true);

            if Insert then
                v443.PrimaryPart = Insert;
            end;
        end;
    end;

    if not v443.PrimaryPart then
        v443:Destroy();

        return;
    end;

    for _, descendant in ipairs(v443:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Anchored = false;
            descendant.Massless = true;
        end;
    end;

    v443.Parent = v432;
    local success, result = pcall(GetWeaponProperties, p431.Name);
    local v445;

    if success and result then
        v445 = result.ShootingOptions == "Dual";
    else
        v445 = false;
    end;

    local Properties = v443:FindFirstChild("Properties");

    if not Properties then
        local Weapon = v443:FindFirstChild("Weapon");

        if Weapon then
            Properties = Weapon:FindFirstChild("Properties");
        end;
    end;

    local v446 = Properties or v443:FindFirstChild("Properties", true);

    if v445 then
        local RightHand = v432:FindFirstChild("RightHand");
        local LeftHand = v432:FindFirstChild("LeftHand");

        if RightHand and LeftHand then
            local HandleR = v443:FindFirstChild("HandleR", true);

            if HandleR then
                local Motor6D = Instance.new("Motor6D");
                Motor6D.Name = "WeaponAttachmentHandleR";
                Motor6D.Part0 = RightHand;
                Motor6D.Part1 = HandleR;
                Motor6D.Parent = RightHand;

                if v446 then
                    local C0RIGHT = v446:FindFirstChild("C0RIGHT");

                    if C0RIGHT then
                        Motor6D.C0 = C0RIGHT.Value;
                    end;

                    local C1RIGHT = v446:FindFirstChild("C1RIGHT");

                    if C1RIGHT then
                        Motor6D.C1 = C1RIGHT.Value;
                    end;
                end;
            end;

            local HandleL = v443:FindFirstChild("HandleL", true);

            if HandleL then
                local Motor6D = Instance.new("Motor6D");
                Motor6D.Name = "WeaponAttachmentHandleL";
                Motor6D.Part0 = LeftHand;
                Motor6D.Part1 = HandleL;
                Motor6D.Parent = LeftHand;

                if v446 then
                    local C0LEFT = v446:FindFirstChild("C0LEFT");

                    if C0LEFT then
                        Motor6D.C0 = C0LEFT.Value;
                    end;

                    local C1LEFT = v446:FindFirstChild("C1LEFT");

                    if C1LEFT then
                        Motor6D.C1 = C1LEFT.Value;
                    end;
                end;
            end;
        end;
    else
        local Motor6D = Instance.new("Motor6D");
        Motor6D.Name = "WeaponAttachment";
        Motor6D.Part0 = v444;
        Motor6D.Part1 = v443.PrimaryPart;
        Motor6D.Parent = v444;

        if v446 then
            local C0 = v446:FindFirstChild("C0");

            if C0 then
                Motor6D.C0 = C0.Value;
            end;

            local C1 = v446:FindFirstChild("C1");

            if C1 then
                Motor6D.C1 = C1.Value;
            end;
        end;
    end;

    u44[p430] = v443;
    u48[p430] = p431._id;
    local v447 = v432:FindFirstChildOfClass("Humanoid");

    if not v447 then
        return;
    end;

    local v448 = v447:FindFirstChildOfClass("Animator");

    if not v448 then
        return;
    end;

    local v449 = nil;

    if p431.Type == "Melee" then
        v449 = "Melee";
    elseif result then
        v449 = GetAnimationForWeaponType(result.Type, result.AimingOptions, result.MuzzleType, result.Class);
    else
        local success2, result2 = pcall(GetWeaponProperties, p431.Name);

        if success2 and result2 then
            v449 = GetAnimationForWeaponType(result2.Type, result2.AimingOptions, result2.MuzzleType, result2.Class);
        end;
    end;

    if v449 then
        local Name = p431.Name;
        local v450;

        if v449 and Viewport.ANIMATION_MAPPING[v449] then
            local v451 = Viewport.ANIMATION_MAPPING[v449];

            if Name and v451[Name] then
                v450 = v451[Name];
            else
                v450 = v451.Default;
            end;
        else
            v450 = nil;
        end;

        if v450 then
            local v452 = v448:LoadAnimation(v450);
            v452.Looped = true;
            v452.Priority = Enum.AnimationPriority.Action;
            v452:Play();
            u45[p430] = v452;
        end;
    end;
end;

local function EquipDefaultKnifeToViewport(p453) -- Line: 3632
    -- upvalues: DataController (copy), LocalPlayer (copy), EquipWeaponToViewport (copy)
    local v454 = DataController.Get(LocalPlayer, "Loadout");
    local v455 = DataController.Get(LocalPlayer, "Inventory");

    if not (v454 and v455) then
        return;
    end;

    local v456 = v454[p453 == "CT" and "Counter-Terrorists" or "Terrorists"];

    if not (v456 and v456.Equipped) then
        return;
    end;

    local v457 = v456.Equipped["Equipped Melee"];

    if not v457 or v457 == "" then
        EquipWeaponToViewport(p453, {
            _id = "default_knife",
            Type = "Melee",
            Serial = 0,
            Skin = "Stock",
            Float = 0,
            StatTrack = false,
            IsTradeable = false,
            NameTag = false,
            Charm = false,
            Name = p453 == "CT" and "CT Knife" or "T Knife"
        });

        return;
    end;

    for _, v in ipairs(v455) do
        if v._id == v457 then
            break;
        end;
    end;

    if v then
        EquipWeaponToViewport(p453, v);

        return;
    end;

    EquipWeaponToViewport(p453, {
        _id = "default_knife",
        Type = "Melee",
        Serial = 0,
        Skin = "Stock",
        Float = 0,
        StatTrack = false,
        IsTradeable = false,
        NameTag = false,
        Charm = false,
        Name = p453 == "CT" and "CT Knife" or "T Knife"
    });
end;

function u1.OnLoadoutItemHover(p458) -- Line: 3677
    -- upvalues: u3 (ref), EquipWeaponToViewport (copy)
    EquipWeaponToViewport(u3 == "Counter-Terrorists" and "CT" or "T", p458);
end;

function u1.OnLoadoutItemUnhover() -- Line: 3684
end;

local function SetupSidebarHoverEvents() -- Line: 3690
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u66 (ref), u61 (copy), u47 (copy), EquipWeaponToViewport (copy), EquipDefaultKnifeToViewport (copy)
    Profiler.mark("UI.Loadout.SetupSidebarHoverEvents");
    local u459 = DataController.Get(LocalPlayer, "Inventory");

    if not u459 then
        return;
    end;

    local Teams = u66.Container.Teams;

    for _, v in ipairs({ "CT", "T" }) do
        local v460 = Teams:FindFirstChild(v);

        if v460 then
            local Equipments = v460:FindFirstChild("Equipments");

            if Equipments then
                for _, v2 in ipairs(u61) do
                    local u461 = Equipments:FindFirstChild(v2);

                    if u461 then
                        local v462 = v .. "_" .. v2;
                        local v463 = u47[v462];

                        if v463 then
                            if v463.MouseEnter then
                                v463.MouseEnter:Disconnect();
                            end;

                            if v463.MouseLeave then
                                v463.MouseLeave:Disconnect();
                            end;
                        end;

                        u47[v462] = {
                            MouseEnter = u461.MouseEnter:Connect(function() -- Line: 3729
                                -- upvalues: u461 (copy), v (copy), u459 (copy), v2 (copy), EquipWeaponToViewport (ref), EquipDefaultKnifeToViewport (ref)
                                local v464 = u461:GetAttribute("EquippedItemId");
                                local v465 = u461:GetAttribute("TeamKey") or v;

                                if v464 and v464 ~= "" then
                                    for _, v3 in ipairs(u459) do
                                        if v3._id == v464 then
                                            break;
                                        end;
                                    end;

                                    if v3 then
                                        local v466 = v2;

                                        if v466 == "Melee" and true or v466 == "Zeus" then
                                            EquipWeaponToViewport(v465, v3);

                                            return;
                                        end;
                                    end;

                                    return;
                                end;

                                if v2 == "Melee" then
                                    EquipDefaultKnifeToViewport(v465);
                                end;
                            end),
                            MouseLeave = u461.MouseLeave:Connect(function() -- Line: 3745
                            end)
                        };
                    end;
                end;
            end;
        end;
    end;
end;

function u1.SelectTeam(p467) -- Line: 3753
    -- upvalues: Profiler (copy), u66 (ref), u3 (ref), u4 (ref), u8 (ref), u7 (ref), DataController (copy), LocalPlayer (copy), u1 (copy)
    Profiler.mark((`UI.Loadout.SelectTeam.{p467}`));
    local Teams = u66.Container.Teams;
    Teams.CT.Visible = p467 == "CT";
    Teams.T.Visible = p467 == "T";
    u3 = p467 == "CT" and "Counter-Terrorists" or (p467 == "T" and "Terrorists" or false);
    u4 = nil;
    u8 = nil;
    u7 = nil;
    u66.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
    u66.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";
    local v468 = DataController.Get(LocalPlayer, "Loadout");
    u1.UpdateLoadoutContainer(v468);
    u1.UpdateSidebarFrames(v468);
    u1.UpdateInventoryContainer();
    u1.PopulateCategoryDropdown();
    u1.PopulateWeaponDropdown();
end;

function u1.Initialize(p469, p470) -- Line: 3785
    -- upvalues: Profiler (copy), u66 (ref), u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (copy), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (copy), GuiService (copy), u52 (ref), u1 (copy), u5 (ref), u51 (ref), RenderInitialLoadoutTemplates (copy), u50 (ref), u49 (ref), RenderLoadoutTemplates (copy), OnLoadoutScrollPositionChanged (copy), u33 (ref), u30 (ref), u31 (ref), MenuState (copy), Router (copy), CloseButtonRegistry (copy), u32 (ref), Remotes (copy), UseItemFrame (copy), ReplaceItemOnTeam (copy), WeaponDropShadows (copy), ContentProvider (copy), SetupViewportCharacters (copy), EquipGlovesToViewport (copy), EquipDefaultKnifeToViewport (copy), u29 (ref), FadeCategoryLabels (copy), DataController (copy), LocalPlayer (copy), u28 (ref), SetupSidebarHoverEvents (copy), UpdateItemStatusFrame (copy), UserInputService (copy), u310 (ref), u309 (ref), u25 (ref), AnimateSortButton (copy), u6 (ref), ClearDropdownOptions (copy), u4 (ref), u8 (ref), u7 (ref)
    Profiler.mark("UI.Loadout.Initialize");
    u66 = p470;
    u66:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3790
        -- upvalues: u66 (ref), u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (ref), GuiService (ref), u52 (ref), u1 (ref), u5 (ref), u51 (ref), RenderInitialLoadoutTemplates (ref)
        if u66.Visible then
            if u52 then
                u52 = false;
                u1.SortBySkinMetadata(u5);
            end;

            if u51 then
                RenderInitialLoadoutTemplates();
            end;

            return;
        end;

        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u15 = nil;
        u16 = nil;
        u18 = false;
        u19 = nil;

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        u9 = false;
        u11 = nil;
        u12 = nil;
        u13 = nil;
        HideAllMoveFrames();

        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        u15 = nil;
        u16 = nil;
        u18 = false;
        u19 = nil;

        if u14 then
            u14:Disconnect();
            u14 = nil;
        end;

        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        u9 = false;
        u11 = nil;
        u12 = nil;
        u13 = nil;
        HideAllMoveFrames();
        u20 = nil;
        u21 = false;
        u22 = nil;
        u23 = nil;
        u24 = nil;
        u27 = false;

        if u26 then
            u26 = false;
            pcall(function() -- Line: 1779
                -- upvalues: GamepadService (ref)
                GamepadService:DisableGamepadCursor();
            end);
            GuiService.AutoSelectGuiEnabled = true;
        end;

        HideAllMoveFrames();
    end);
    local Container = u66.Container.List.Container;
    Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 3811
        -- upvalues: u66 (ref), u50 (ref), u49 (ref), RenderLoadoutTemplates (ref)
        if not u66 then
            return;
        end;

        local Container2 = u66.Container.List.Container;
        local v471 = Container2.AbsoluteCanvasSize.Y - Container2.AbsoluteSize.Y;

        if v471 <= 0 or (u50 >= #u49 or v471 - Container2.CanvasPosition.Y >= 200) then
            return;
        end;

        RenderLoadoutTemplates();
    end);
    Container:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- Line: 3816
        -- upvalues: Profiler (ref), OnLoadoutScrollPositionChanged (ref)
        Profiler.defer("UI.Loadout.ScrollDeferred", OnLoadoutScrollPositionChanged);
    end);
    local Menu = p469:FindFirstChild("Menu");

    if Menu then
        Menu:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3823
            -- upvalues: Menu (copy), u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (ref), GuiService (ref), u33 (ref), u30 (ref), u31 (ref), MenuState (ref), Router (ref)
            if not Menu.Visible then
                if u17 then
                    u17:Disconnect();
                    u17 = nil;
                end;

                u15 = nil;
                u16 = nil;
                u18 = false;
                u19 = nil;

                if u14 then
                    u14:Disconnect();
                    u14 = nil;
                end;

                if u10 then
                    u10:Destroy();
                    u10 = nil;
                end;

                u9 = false;
                u11 = nil;
                u12 = nil;
                u13 = nil;
                HideAllMoveFrames();

                if u17 then
                    u17:Disconnect();
                    u17 = nil;
                end;

                u15 = nil;
                u16 = nil;
                u18 = false;
                u19 = nil;

                if u14 then
                    u14:Disconnect();
                    u14 = nil;
                end;

                if u10 then
                    u10:Destroy();
                    u10 = nil;
                end;

                u9 = false;
                u11 = nil;
                u12 = nil;
                u13 = nil;
                HideAllMoveFrames();
                u20 = nil;
                u21 = false;
                u22 = nil;
                u23 = nil;
                u24 = nil;
                u27 = false;

                if u26 then
                    u26 = false;
                    pcall(function() -- Line: 1779
                        -- upvalues: GamepadService (ref)
                        GamepadService:DisableGamepadCursor();
                    end);
                    GuiService.AutoSelectGuiEnabled = true;
                end;

                HideAllMoveFrames();

                if u33 then
                    u33.Visible = false;
                end;

                u30 = nil;
                u31 = nil;

                if MenuState.IsInspectActive() then
                    Router.broadcastRouter("WeaponInspectClose");
                end;
            end;
        end);
    end;

    u33 = u66.Ignore.Information;

    if u33 then
        u33.Visible = false;
        CloseButtonRegistry.Add(u33, nil, function() -- Line: 3841
            -- upvalues: Router (ref), u33 (ref), u32 (ref), GuiService (ref)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u33.Visible = false;

            if u32 then
                local Button = u32:FindFirstChild("Button");

                if Button and Button:IsA("GuiButton") then
                    GuiService.SelectedObject = Button;
                end;
            end;
        end);

        if u33.Inspect then
            u33.Inspect.Selectable = true;
            u33.Inspect.MouseButton1Click:Connect(function() -- Line: 3854, Name: handleInspectClick
                -- upvalues: Router (ref), u31 (ref), u33 (ref)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if u31 then
                    u33.Visible = false;
                    Router.broadcastRouter("WeaponInspect", u31.Name, u31.Skin, u31.Float, u31.StatTrack, u31.NameTag, u31.Charm, u31.Stickers, u31.Type, u31.Pattern, u31._id, u31.Serial, u31.IsTradeable);
                end;
            end);
            u33.Inspect.Activated:Connect(function(p472) -- Line: 3876
                -- upvalues: Router (ref), u31 (ref), u33 (ref)
                if p472 and p472.UserInputType == Enum.UserInputType.Gamepad1 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");

                    if u31 then
                        u33.Visible = false;
                        Router.broadcastRouter("WeaponInspect", u31.Name, u31.Skin, u31.Float, u31.StatTrack, u31.NameTag, u31.Charm, u31.Stickers, u31.Type, u31.Pattern, u31._id, u31.Serial, u31.IsTradeable);
                    end;
                end;
            end);
        end;

        if u33.Charm then
            u33.Charm.Selectable = true;

            local function handleCharmClick() -- Line: 3885
                -- upvalues: Router (ref), u31 (ref), u33 (ref), Remotes (ref), u66 (ref), UseItemFrame (ref)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if u31 then
                    local v473;

                    if u31.Charm == nil or u31.Charm == false then
                        v473 = false;
                    else
                        v473 = (type(u31.Charm) == "string" or u31.Charm == true) and true or type(u31.Charm) == "table";
                    end;

                    u33.Visible = false;

                    if v473 then
                        Remotes.Inventory.RemoveWeaponCharm.Send({
                            WeaponId = u31._id
                        });

                        return;
                    end;

                    u66.Visible = false;
                    UseItemFrame.TriggerAction("AttachCharm", u31);
                end;
            end;

            u33.Charm.MouseButton1Click:Connect(handleCharmClick);
            u33.Charm.Activated:Connect(function(p474) -- Line: 3905
                -- upvalues: handleCharmClick (copy)
                if p474 and p474.UserInputType == Enum.UserInputType.Gamepad1 then
                    handleCharmClick();
                end;
            end);
        end;

        UseItemFrame.OnClosed:Connect(function() -- Line: 3912
            -- upvalues: MenuState (ref), u66 (ref)
            if MenuState.GetCurrentScreen() == "Loadout" then
                u66.Visible = true;
            end;
        end);

        if u33.Unlock then
            u33.Unlock.Selectable = true;
            u33.Unlock.Visible = false;
        end;

        if u33.ReplaceT then
            u33.ReplaceT.Selectable = true;
            u33.ReplaceT.MouseButton1Click:Connect(function() -- Line: 3925, Name: handleReplaceTClick
                -- upvalues: Router (ref), u31 (ref), u33 (ref), ReplaceItemOnTeam (ref)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if u31 then
                    u33.Visible = false;
                    ReplaceItemOnTeam(u31, "Terrorists");
                end;
            end);
            u33.ReplaceT.Activated:Connect(function(p475) -- Line: 3933
                -- upvalues: Router (ref), u31 (ref), u33 (ref), ReplaceItemOnTeam (ref)
                if p475 and p475.UserInputType == Enum.UserInputType.Gamepad1 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");

                    if u31 then
                        u33.Visible = false;
                        ReplaceItemOnTeam(u31, "Terrorists");
                    end;
                end;
            end);
        end;

        if u33.ReplaceCT then
            u33.ReplaceCT.Selectable = true;
            u33.ReplaceCT.MouseButton1Click:Connect(function() -- Line: 3942, Name: handleReplaceCTClick
                -- upvalues: Router (ref), u31 (ref), u33 (ref), ReplaceItemOnTeam (ref)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");

                if u31 then
                    u33.Visible = false;
                    ReplaceItemOnTeam(u31, "Counter-Terrorists");
                end;
            end);
            u33.ReplaceCT.Activated:Connect(function(p476) -- Line: 3950
                -- upvalues: Router (ref), u31 (ref), u33 (ref), ReplaceItemOnTeam (ref)
                if p476 and p476.UserInputType == Enum.UserInputType.Gamepad1 then
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");

                    if u31 then
                        u33.Visible = false;
                        ReplaceItemOnTeam(u31, "Counter-Terrorists");
                    end;
                end;
            end);
        end;
    end;

    Profiler.spawn("UI.Loadout.PreloadDropShadows", function() -- Line: 3959
        -- upvalues: WeaponDropShadows (ref), ContentProvider (ref)
        local v477 = {};

        for _, v in pairs(WeaponDropShadows) do
            table.insert(v477, v);
        end;

        ContentProvider:PreloadAsync(v477);
    end);
    SetupViewportCharacters();
    EquipGlovesToViewport("CT");
    EquipGlovesToViewport("T");
    EquipDefaultKnifeToViewport("CT");
    EquipDefaultKnifeToViewport("T");
    local Teams = u66.Container.Teams;

    for _, v in ipairs({ Teams.CT.Guns, Teams.T.Guns }) do
        for _, v2 in ipairs({ "Mid Tier", "Pistols", "Rifles" }) do
            local List = v:FindFirstChild(v2).List;

            if List and List:IsA("Frame") then
                List.MouseEnter:Connect(function() -- Line: 3984
                    -- upvalues: u29 (ref), v2 (copy), FadeCategoryLabels (ref), List (copy)
                    u29 = v2;
                    FadeCategoryLabels(List, true);
                end);
                List.MouseLeave:Connect(function() -- Line: 3988
                    -- upvalues: u29 (ref), FadeCategoryLabels (ref), List (copy)
                    u29 = nil;
                    FadeCategoryLabels(List, false);
                end);
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Loadout", function(p478) -- Line: 3997
        -- upvalues: Profiler (ref), u28 (ref), u1 (ref), EquipGlovesToViewport (ref), SetupSidebarHoverEvents (ref), u66 (ref), UpdateItemStatusFrame (ref)
        Profiler.mark("UI.Loadout.LoadoutChanged");
        u28 = false;
        u1.UpdateLoadoutContainer(p478);
        u1.UpdateSidebarFrames(p478, "Counter-Terrorists");
        u1.UpdateSidebarFrames(p478, "Terrorists");
        EquipGlovesToViewport("CT");
        EquipGlovesToViewport("T");
        SetupSidebarHoverEvents();

        if u66 and u66.Visible then
            for _, child in ipairs(u66.Container.List.Container:GetChildren()) do
                if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
                    UpdateItemStatusFrame(child, child.Name);
                end;
            end;
        end;
    end);
    Remotes.Inventory.LoadoutResponse.Listen(function() -- Line: 4027
        -- upvalues: u28 (ref)
        u28 = false;
    end);
    DataController.CreateListener(LocalPlayer, "Inventory", function() -- Line: 4032
        -- upvalues: Profiler (ref), u1 (ref), u66 (ref), UpdateItemStatusFrame (ref)
        Profiler.mark("UI.Loadout.InventoryChanged");
        u1.UpdateInventoryContainer();

        if u66 and u66.Visible then
            for _, child in ipairs(u66.Container.List.Container:GetChildren()) do
                if child:IsA("Frame") and (child.Name ~= "UIGridLayout" and (child.Name ~= "UIListLayout" and child.Name ~= "UIPadding")) then
                    UpdateItemStatusFrame(child, child.Name);
                end;
            end;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p479, p480) -- Line: 4053
        -- upvalues: u9 (ref), u15 (ref), u1 (ref)
        if (p479.UserInputType == Enum.UserInputType.MouseButton1 or p479.UserInputType == Enum.UserInputType.Touch) and (u9 or u15) then
            u1.EndDrag();
        end;
    end);
    UserInputService.InputBegan:Connect(function(p481, p482) -- Line: 4065
        -- upvalues: u20 (ref), u26 (ref), u27 (ref), u310 (ref)
        if p481.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        if p481.KeyCode == Enum.KeyCode.ButtonA then
            if u20 and u26 then
                u27 = true;
            end;
        elseif p481.KeyCode == Enum.KeyCode.ButtonB then
            u310();
        end;
    end);
    UserInputService.InputEnded:Connect(function(p483, p484) -- Line: 4084
        -- upvalues: u20 (ref), u26 (ref), u27 (ref), u309 (ref)
        if p483.UserInputType ~= Enum.UserInputType.Gamepad1 then
            return;
        end;

        if p483.KeyCode == Enum.KeyCode.ButtonA and (u20 and (u26 and u27)) then
            u309();
        end;
    end);
    UserInputService.LastInputTypeChanged:Connect(function(p485) -- Line: 4100
        -- upvalues: u25 (ref), u17 (ref), u15 (ref), u16 (ref), u18 (ref), u19 (ref), u14 (ref), u10 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), HideAllMoveFrames (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u26 (ref), GamepadService (ref), GuiService (ref)
        local v486 = u25;
        u25 = p485 == Enum.UserInputType.Gamepad1;

        if v486 and not u25 then
            if u17 then
                u17:Disconnect();
                u17 = nil;
            end;

            u15 = nil;
            u16 = nil;
            u18 = false;
            u19 = nil;

            if u14 then
                u14:Disconnect();
                u14 = nil;
            end;

            if u10 then
                u10:Destroy();
                u10 = nil;
            end;

            u9 = false;
            u11 = nil;
            u12 = nil;
            u13 = nil;
            HideAllMoveFrames();
            u20 = nil;
            u21 = false;
            u22 = nil;
            u23 = nil;
            u24 = nil;
            u27 = false;

            if u26 then
                u26 = false;
                pcall(function() -- Line: 1779
                    -- upvalues: GamepadService (ref)
                    GamepadService:DisableGamepadCursor();
                end);
                GuiService.AutoSelectGuiEnabled = true;
            end;

            HideAllMoveFrames();
        end;

        if not v486 and u25 then
            if u17 then
                u17:Disconnect();
                u17 = nil;
            end;

            u15 = nil;
            u16 = nil;
            u18 = false;
            u19 = nil;

            if u14 then
                u14:Disconnect();
                u14 = nil;
            end;

            if u10 then
                u10:Destroy();
                u10 = nil;
            end;

            u9 = false;
            u11 = nil;
            u12 = nil;
            u13 = nil;
            HideAllMoveFrames();
        end;
    end);
    u25 = UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1;
    local Filter = u66.Container.List.Top.Filter;
    local Scroll = Filter.DropdownContent.Scroll;
    Filter.MouseButton1Click:Connect(function() -- Line: 4121
        -- upvalues: Scroll (copy), u66 (ref)
        local Visible = Scroll.Parent.Visible;
        local DropdownContent = u66.Container.List.Top.Weapon.DropdownContent;
        u66.Container.List.Top.Filter.DropdownContent.Visible = false;
        DropdownContent.Visible = false;
        Scroll.Parent.Visible = not Visible;
    end);

    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundTransparency = 1;
            child.MouseEnter:Connect(function() -- Line: 4130
                -- upvalues: AnimateSortButton (ref), child (copy)
                AnimateSortButton(child, true);
            end);
            child.MouseLeave:Connect(function() -- Line: 4133
                -- upvalues: AnimateSortButton (ref), child (copy)
                AnimateSortButton(child, false);
            end);
            child.MouseButton1Click:Connect(function() -- Line: 4136
                -- upvalues: u1 (ref), child (copy), Scroll (copy)
                u1.SortBySkinMetadata(child.Name);
                Scroll.Parent.Visible = false;
            end);
        end;
    end;

    local Reverse = u66.Container.List.Top.Filter.Container.Left.Reverse;

    if Reverse then
        local function handleReverseSortButtonClick() -- Line: 4146
            -- upvalues: u6 (ref), u1 (ref), u5 (ref), Router (ref)
            u6 = not u6;
            u1.SortBySkinMetadata(u5);
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end;

        Reverse.Selectable = true;
        Reverse.MouseButton1Click:Connect(handleReverseSortButtonClick);
        Reverse.Activated:Connect(function(p487) -- Line: 4155
            -- upvalues: u6 (ref), u1 (ref), u5 (ref), Router (ref)
            if p487 and p487.UserInputType == Enum.UserInputType.Gamepad1 then
                u6 = not u6;
                u1.SortBySkinMetadata(u5);
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
            end;
        end);
    end;

    local Weapon = u66.Container.List.Top.Weapon;
    local Scroll2 = Weapon.DropdownContent.Scroll;

    if Scroll2 and (Scroll2:IsA("Frame") or Scroll2:IsA("ScrollingFrame")) then
        ClearDropdownOptions(Scroll2);
        Weapon.MouseButton1Click:Connect(function() -- Line: 4181
            -- upvalues: Scroll2 (copy), u66 (ref)
            local Visible = Scroll2.Parent.Visible;
            local DropdownContent = u66.Container.List.Top.Weapon.DropdownContent;
            u66.Container.List.Top.Filter.DropdownContent.Visible = false;
            DropdownContent.Visible = false;
            Scroll2.Parent.Visible = not Visible;
        end);
    end;

    local Reset = u66.Container.List.Top.Reset;

    if Reset then
        Reset.Visible = false;
        Reset.MouseButton1Click:Connect(function() -- Line: 4194
            -- upvalues: u4 (ref), u8 (ref), u7 (ref), Weapon (copy), Reset (copy), u1 (ref), u66 (ref), u5 (ref)
            u4 = nil;
            u8 = nil;
            u7 = nil;
            Weapon.Container.Left.Title.Text = "All Weapons";
            Reset.Visible = false;
            u1.PopulateWeaponDropdown();

            for _, child in ipairs(u66.Container.List.Container:GetChildren()) do
                if child:IsA("ImageButton") then
                    child.Visible = true;
                end;
            end;

            u1.SortBySkinMetadata(u5);
        end);
    end;
end;

function u1.ViewInLoadout(p488) -- Line: 4224
    -- upvalues: DataController (copy), LocalPlayer (copy), GetWeaponProperties (copy), u4 (ref), u66 (ref), u1 (copy), u7 (ref), MenuState (copy)
    local v489 = DataController.Get(LocalPlayer, "Inventory");

    for _, v in ipairs(v489) do
        if v._id == p488 then
            break;
        end;
    end;

    if not v then
        return;
    end;

    local Name = v.Name;
    local Skin = v.Skin;
    local success, result = pcall(GetWeaponProperties, Name);

    if success and (result and result.Type) then
        u4 = result.Type;
        u66.Container.List.Top.Filter.Container.Left.Title.Text = result.Type;
        u1.PopulateWeaponDropdown();
    end;

    u1.SortByWeapon(Name, Skin);
    local Reset = u66.Container.List.Top:FindFirstChild("Reset");

    if Reset then
        Reset.Visible = (u4 ~= nil or u7 ~= nil) and true or u66.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
    end;

    if u66.Visible then
        return;
    end;

    MenuState.SetScreen("Loadout");
    u66.Visible = true;
end;

function u1.Start() -- Line: 4266
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u1 (copy), SetupSidebarHoverEvents (copy), u4 (ref), u8 (ref), u7 (ref), u66 (ref), u5 (ref), u61 (copy), u3 (ref)
    debug.setmemorycategory("UI.Loadout.Start");
    Profiler.mark("UI.Loadout.Start.Begin");
    DataController.WaitForDataLoaded(LocalPlayer);
    Profiler.mark("UI.Loadout.Start.DataLoaded");
    u1.SelectTeam("CT");
    Profiler.mark("UI.Loadout.Start.InitialTeam");
    local v490 = DataController.Get(LocalPlayer, "Loadout");

    if v490 then
        u1.UpdateSidebarFrames(v490, "Counter-Terrorists");
        u1.UpdateSidebarFrames(v490, "Terrorists");
        SetupSidebarHoverEvents();
    end;

    u1.PopulateCategoryDropdown();
    u1.PopulateWeaponDropdown();
    u1.SortBySkinMetadata("Newest");

    local function ClearFiltersAndShowAll() -- Line: 4294
        -- upvalues: u4 (ref), u8 (ref), u7 (ref), u66 (ref), u1 (ref), u5 (ref)
        u4 = nil;
        u8 = nil;
        u7 = nil;
        u66.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
        u66.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";

        for _, child in ipairs(u66.Container.List.Container:GetChildren()) do
            if child:IsA("ImageButton") then
                child.Visible = true;
            end;
        end;

        u1.SortBySkinMetadata(u5);
        local Reset = u66.Container.List.Top:FindFirstChild("Reset");

        if Reset then
            Reset.Visible = (u4 ~= nil or u7 ~= nil) and true or u66.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
        end;
    end;

    local u491 = {};

    local function SetupSidebarButtonClicks() -- Line: 4316
        -- upvalues: Profiler (ref), u66 (ref), u61 (ref), u7 (ref), ClearFiltersAndShowAll (copy), u4 (ref), u8 (ref), u1 (ref), u5 (ref), u491 (copy)
        Profiler.mark("UI.Loadout.SetupSidebarButtonClicks");
        local Teams = u66.Container.Teams;

        for _, v in ipairs({ "CT", "T" }) do
            local Equipments = Teams[v].Equipments;

            for _, v2 in ipairs(u61) do
                local v492 = Equipments[v2];

                local function handleSelection() -- Line: 4326
                    -- upvalues: u7 (ref), v (copy), v2 (copy), ClearFiltersAndShowAll (ref), u4 (ref), u8 (ref), u66 (ref), u1 (ref), u5 (ref)
                    local v493 = u7;

                    if v493 then
                        if u7.teamKey == v then
                            v493 = u7.sidebarName == v2;
                        else
                            v493 = false;
                        end;
                    end;

                    if v493 then
                        u7 = nil;
                        ClearFiltersAndShowAll();

                        return;
                    end;

                    u4 = nil;
                    u8 = nil;
                    u66.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
                    u66.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";
                    u7 = {
                        teamKey = v,
                        sidebarName = v2
                    };
                    u1.SortBySkinMetadata(u5);
                    local Reset = u66.Container.List.Top:FindFirstChild("Reset");

                    if Reset then
                        Reset.Visible = (u4 ~= nil or u7 ~= nil) and true or u66.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
                    end;
                end;

                local v494 = `{v}_{v2}`;

                if u491[v494] then
                    u491[v494]:Disconnect();
                end;

                u491[v494] = v492.MouseButton1Click:Connect(handleSelection);
            end;
        end;
    end;

    SetupSidebarButtonClicks();
    u66.Teams.ButtonCT.MouseButton1Click:Connect(function() -- Line: 4371
        -- upvalues: u3 (ref), u1 (ref), u66 (ref), u7 (ref), u4 (ref), u8 (ref), u5 (ref), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u3 ~= "Counter-Terrorists" then
            u1.SelectTeam("CT");
            u66.Teams.ButtonCT.Interactable = false;
            u66.Teams.ButtonT.Interactable = true;
            u7 = nil;
            u4 = nil;
            u8 = nil;
            u66.Container.List.Top.Filter.Container.Left.Title.Text = "All Categories";
            u66.Container.List.Top.Weapon.Container.Left.Title.Text = "All Weapons";

            for _, child in ipairs(u66.Container.List.Container:GetChildren()) do
                if child:IsA("ImageButton") then
                    child.Visible = true;
                end;
            end;

            u1.SortBySkinMetadata(u5);
            local Reset = u66.Container.List.Top:FindFirstChild("Reset");

            if Reset then
                Reset.Visible = (u4 ~= nil or u7 ~= nil) and true or u66.Container.List.Top.Weapon.Container.Left.Title.Text ~= "All Weapons";
            end;

            Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
        end;
    end);
    u66.Teams.ButtonT.MouseButton1Click:Connect(function() -- Line: 4404
        -- upvalues: u3 (ref), u1 (ref), u66 (ref), u7 (ref), ClearFiltersAndShowAll (copy), Profiler (ref), SetupSidebarButtonClicks (copy)
        if u3 ~= "Terrorists" then
            u1.SelectTeam("T");
            u66.Teams.ButtonT.Interactable = false;
            u66.Teams.ButtonCT.Interactable = true;
            u7 = nil;
            ClearFiltersAndShowAll();
            Profiler.defer("UI.Loadout.SidebarButtonsDeferred", SetupSidebarButtonClicks);
        end;
    end);
    u66.Teams.ButtonCT.Interactable = false;
    u66.Teams.ButtonT.Interactable = true;
end;

return u1;