-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local u2 = nil;
local u3 = nil;

local function computePriority(p4, p5) -- Line: 40
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character.PrimaryPart) then
        return false;
    end;

    local v6 = p4:GetAttribute("HoveringState");
    local v7 = p5:GetAttribute("HoveringState");

    if v6 == "Hovering" then
        return true;
    end;

    if v7 == "Hovering" then
        return false;
    end;

    local v8 = p4:GetAttribute("CanPickup");
    local v9 = p5:GetAttribute("CanPickup");

    if v8 == false then
        return false;
    end;

    if v9 == false then
        return true;
    end;

    if p4.PrimaryPart and p5.PrimaryPart then
        return (Character.PrimaryPart.Position - p4.PrimaryPart.Position).Magnitude < (Character.PrimaryPart.Position - p5.PrimaryPart.Position).Magnitude;
    end;

    return false;
end;

local function hasHoveredInteractables() -- Line: 79
    -- upvalues: CollectionService (copy)
    return #CollectionService:GetTagged("IsHoveringInteractable") > 0;
end;

local function stopUpdateConnection() -- Line: 85
    -- upvalues: u3 (ref)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function syncUpdateConnection() -- Line: 94
    -- upvalues: LocalPlayer (copy), CollectionService (copy), u3 (ref), RunServiceController (copy), u1 (copy), u2 (ref)
    if LocalPlayer.Character and #CollectionService:GetTagged("IsHoveringInteractable") > 0 then
        if u3 then
            return;
        end;

        u3 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p10) -- Line: 100
            -- upvalues: LocalPlayer (ref), CollectionService (ref), u1 (ref), u2 (ref), u3 (ref)
            if LocalPlayer.Character and #CollectionService:GetTagged("IsHoveringInteractable") > 0 then
                u1.Render(p10);

                return;
            end;

            u2.Visible = false;

            if u3 then
                u3:Disconnect();
                u3 = nil;
            end;
        end);

        return;
    end;

    u2.Visible = false;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

function u1.Render(p11) -- Line: 120
    -- upvalues: CollectionService (copy), computePriority (copy), GetSkinDisplayName (copy), Skins (copy), Rarities (copy), u2 (ref)
    local v12 = CollectionService:GetTagged("IsHoveringInteractable");
    table.sort(v12, computePriority);
    local v13 = v12[1];

    if not v13 then
        u2.Visible = false;

        return;
    end;

    local v14 = v13:GetAttribute("Weapon");
    local v15 = v13:GetAttribute("Skin");
    local v16 = GetSkinDisplayName(v15);
    local v17 = v14:find("Zeus") and "Taser" or v14;
    local v18 = Skins.GetSkinInformation(v14, v15);
    assert(v18, "Skin data not found for weapon: " .. v14 .. " and skin: " .. v15);
    local v19 = Rarities[v18.rarity];
    local v20 = math.floor(v19.Color.R * 255);
    local v21 = math.floor(v19.Color.G * 255);
    local v22 = math.floor(v19.Color.B * 255);
    u2.TextLabel.Text = `[E] Swap for <font color = "rgb({v20}, {v21}, {v22})"><b>{v17} | {v16}</b></font>`;
    u2.Visible = true;
end;

function u1.Initialize(p23, p24) -- Line: 156
    -- upvalues: u2 (ref), CollectionService (copy), syncUpdateConnection (copy), LocalPlayer (copy), u3 (ref), RunServiceController (copy), u1 (copy)
    u2 = p24;
    CollectionService:GetInstanceAddedSignal("IsHoveringInteractable"):Connect(syncUpdateConnection);
    CollectionService:GetInstanceRemovedSignal("IsHoveringInteractable"):Connect(syncUpdateConnection);
    LocalPlayer.CharacterAdded:Connect(syncUpdateConnection);
    LocalPlayer.CharacterRemoving:Connect(syncUpdateConnection);

    if LocalPlayer.Character and #CollectionService:GetTagged("IsHoveringInteractable") > 0 then
        if u3 then
            return;
        end;

        u3 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(p25) -- Line: 100
            -- upvalues: LocalPlayer (ref), CollectionService (ref), u1 (ref), u2 (ref), u3 (ref)
            if LocalPlayer.Character and #CollectionService:GetTagged("IsHoveringInteractable") > 0 then
                u1.Render(p25);

                return;
            end;

            u2.Visible = false;

            if u3 then
                u3:Disconnect();
                u3 = nil;
            end;
        end);

        return;
    end;

    u2.Visible = false;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

return u1;