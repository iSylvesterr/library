-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    ProximityRange = 6,
    HoverRange = 10
};
local u3 = {};
local u4 = 0;
local u5 = nil;
local u6 = nil;
local u7 = {};

local function UpdateHoveredInstance() -- Line: 52
    -- upvalues: u5 (ref), CenterScreenRaycast (copy)
    u5 = CenterScreenRaycast.GetInstance(10);
end;

local function StopSharedHeartbeatIfIdle() -- Line: 56
    -- upvalues: u4 (ref), u6 (ref), u5 (ref)
    if u4 <= 0 and u6 then
        u6:Disconnect();
        u6 = nil;
        u5 = nil;
    end;
end;

local function EnsureSharedHeartbeat() -- Line: 64
    -- upvalues: u6 (ref), RunServiceController (copy), u4 (ref), u5 (ref), CenterScreenRaycast (copy), u2 (copy), u3 (copy)
    if u6 then
        return;
    end;

    u6 = RunServiceController.BindToHeartbeat("Observers.Game.WeaponDropped.Update", function(p8) -- Line: 69
        -- upvalues: u4 (ref), u6 (ref), u5 (ref), CenterScreenRaycast (ref), u2 (ref), u3 (ref)
        if u4 <= 0 then
            if u4 <= 0 and u6 then
                u6:Disconnect();
                u6 = nil;
                u5 = nil;
            end;

            return;
        end;

        u5 = CenterScreenRaycast.GetInstance(u2.HoverRange);

        for i in pairs(u3) do
            if i.Model and i.Model.PrimaryPart then
                i:updateState(p8);
            end;
        end;
    end);
end;

local function ReserveAutoPickupSlot(u9) -- Line: 85
    -- upvalues: u7 (copy)
    local u10 = os.clock();
    local v11 = u7[u9];

    if v11 and u10 - v11 < 1 then
        return false;
    end;

    u7[u9] = u10;
    task.delay(1, function() -- Line: 93
        -- upvalues: u7 (ref), u9 (copy), u10 (copy)
        if u7[u9] == u10 then
            u7[u9] = nil;
        end;
    end);

    return true;
end;

local function GetInventoryItemCount(p12, p13) -- Line: 108
    local v14 = 0;

    if not p12 then
        return 0;
    end;

    for _, v in ipairs(p12._items) do
        if v.Name == p13 then
            v14 = v14 + 1;
        end;
    end;

    return v14;
end;

local function HasReachedDuplicateLimit(p15, p16) -- Line: 125
    -- upvalues: Grenades (copy)
    local v17 = Grenades[p16];

    if not v17 then
        return false;
    end;

    local v18 = 0;

    if p15 then
        for _, v in ipairs(p15._items) do
            if v.Name == p16 then
                v18 = v18 + 1;
            end;
        end;
    else
        v18 = 0;
    end;

    return v17 <= v18;
end;

function u1.autoPickup(p19) -- Line: 137
    -- upvalues: GetWeaponProperties (copy), NumberSlots (copy), InventoryController (copy), Grenades (copy), u7 (copy), Skins (copy), Rarities (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    local v20 = p19.Model:GetAttribute("Weapon");

    if not v20 then
        return;
    end;

    local v21 = GetWeaponProperties(v20);

    if not v21 then
        return;
    end;

    local u22 = NumberSlots[v21.Slot];

    if not u22 then
        return;
    end;

    local v23 = InventoryController.getInventorySlot(u22);
    local v24 = Grenades[v20];
    local v25;

    if v24 then
        local v26 = 0;

        if v23 then
            for _, v in ipairs(v23._items) do
                if v.Name == v20 then
                    v26 = v26 + 1;
                end;
            end;
        else
            v26 = 0;
        end;

        if v24 <= v26 then
            v25 = true;
        else
            v25 = false;
        end;
    else
        v25 = false;
    end;

    if v25 then
        return;
    end;

    if v23 then
        v23 = #v23._items < v23._settings._strict_slot_space;
    end;

    if not v23 then
        return;
    end;

    if p19.Model:GetAttribute("CanPickup") then
        local Name = p19.Model.Name;

        if not p19.SentPickupRequest then
            local u27 = os.clock();
            local v28 = u7[u22];
            local v29;

            if v28 and u27 - v28 < 1 then
                v29 = false;
            else
                u7[u22] = u27;
                task.delay(1, function() -- Line: 93
                    -- upvalues: u7 (ref), u22 (copy), u27 (copy)
                    if u7[u22] == u27 then
                        u7[u22] = nil;
                    end;
                end);
                v29 = true;
            end;

            if v29 then
                p19.SentPickupRequest = true;
                local v30 = Skins.GetSkinInformation(p19.Weapon, p19.Skin);
                assert(v30, "Skin data not found for weapon: " .. p19.Weapon .. " and skin: " .. p19.Skin);
                local v31 = Rarities[v30.rarity];
                local v32 = math.floor(v31.Color.R * 255);
                local v33 = math.floor(v31.Color.G * 255);
                local v34 = math.floor(v31.Color.B * 255);

                if p19.Weapon == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
                    return;
                end;

                Router.broadcastRouter("CreateNotification", "Item Picked Up", `You picked up a <font color = "rgb({v32}, {v33}, {v34})"><b>{p19.Weapon:find("Zeus") and "Taser" or p19.Weapon} | {p19.Skin}</b></font>`, 2);
                Remotes.Inventory.PickupWeapon.Send({
                    AllowAutoEquip = false,
                    Identity = Name
                });
            end;
        end;
    end;
end;

function u1.updateState(p35, p36) -- Line: 206
    -- upvalues: u5 (ref), LocalPlayer (copy), DataController (copy), GetWeaponProperties (copy)
    p35.AlphaTime = p35.AlphaTime + p36;

    if not p35.Model.PrimaryPart then
        return;
    end;

    local v37 = u5;
    local v38;

    if v37 == nil then
        v38 = false;
    else
        v38 = v37:IsDescendantOf(p35.Model);
    end;

    local v39 = v38 and "Hovering";
    local v40 = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart;
    local v41 = v40 and (v40.Position - p35.Model.PrimaryPart.Position).Magnitude <= 6 and (v39 or "Proximity") or v39;

    if p35.Weapon == "C4" then
        local v42 = LocalPlayer:GetAttribute("Team");

        if p35.AlphaTime >= 1 then
            local FlashingLight = p35.Model.Weapon:FindFirstChild("FlashingLight");
            p35.AlphaTime = 0;

            if FlashingLight then
                FlashingLight.Attachment.PointLight.Enabled = not FlashingLight.Attachment.PointLight.Enabled;
                FlashingLight.Attachment.PointLight.Color = Color3.fromRGB(255, 255, 15);
                FlashingLight.Attachment.PointLight.Brightness = 5;
            end;
        end;

        if v42 ~= "Terrorists" then
            v41 = false;
        end;
    end;

    local v43 = (v41 == "Hovering" or v41 == "Proximity") and v41 and v41 or nil;

    if p35.LastHoveringState ~= v43 then
        p35.LastHoveringState = v43;
        p35.Model:SetAttribute("HoveringState", v43);
    end;

    local v44 = v43 ~= nil;

    if p35.IsInteractableTagged ~= v44 then
        p35.IsInteractableTagged = v44;

        if v44 then
            p35.Model:AddTag("IsHoveringInteractable");
        else
            p35.Model:RemoveTag("IsHoveringInteractable");
        end;
    end;

    if v43 and v43 == "Proximity" then
        local v45 = DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Pickup Dropped Weapons");
        local v46 = GetWeaponProperties(p35.Weapon);

        if v46 then
            v46 = v46.Slot;
        end;

        if v45 ~= false or (v46 == "Grenade" or v46 == "C4") then
            p35:autoPickup();
        end;
    end;
end;

function u1.new(p47) -- Line: 290
    -- upvalues: u1 (copy), Janitor (copy), u3 (copy), u4 (ref), u6 (ref), RunServiceController (copy), u5 (ref), CenterScreenRaycast (copy), u2 (copy)
    local v48 = setmetatable({}, u1);
    v48.Janitor = Janitor.new();
    v48.Model = p47;
    v48.AlphaTime = 0;
    v48.Weapon = v48.Model:GetAttribute("Weapon");
    v48.Skin = v48.Model:GetAttribute("Skin");
    v48.SentPickupRequest = false;
    v48.LastHoveringState = nil;
    v48.IsInteractableTagged = false;
    u3[v48] = true;
    u4 = u4 + 1;

    if u6 then
        return v48;
    end;

    u6 = RunServiceController.BindToHeartbeat("Observers.Game.WeaponDropped.Update", function(p49) -- Line: 69
        -- upvalues: u4 (ref), u6 (ref), u5 (ref), CenterScreenRaycast (ref), u2 (ref), u3 (ref)
        if u4 <= 0 then
            if u4 <= 0 and u6 then
                u6:Disconnect();
                u6 = nil;
                u5 = nil;
            end;

            return;
        end;

        u5 = CenterScreenRaycast.GetInstance(u2.HoverRange);

        for i in pairs(u3) do
            if i.Model and i.Model.PrimaryPart then
                i:updateState(p49);
            end;
        end;
    end);

    return v48;
end;

function u1.destroy(p50) -- Line: 321
    -- upvalues: u3 (copy), u4 (ref), u6 (ref), u5 (ref)
    if u3[p50] then
        u3[p50] = nil;
        u4 = u4 - 1;

        if u4 <= 0 and u6 then
            u6:Disconnect();
            u6 = nil;
            u5 = nil;
        end;
    end;

    if p50.IsInteractableTagged then
        p50.Model:RemoveTag("IsHoveringInteractable");
        p50.IsInteractableTagged = false;
    end;

    if p50.LastHoveringState ~= nil then
        p50.Model:SetAttribute("HoveringState", nil);
        p50.LastHoveringState = nil;
    end;

    p50.Janitor:Destroy();
end;

return u1;