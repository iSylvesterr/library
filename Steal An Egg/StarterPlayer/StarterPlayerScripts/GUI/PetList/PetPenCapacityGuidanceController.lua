-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds);
local GetOrCreateUIScale = require(ReplicatedStorage.Library.Functions.GetOrCreateUIScale);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local LocalPlayer = Players.LocalPlayer;
local v1 = GUI.PetList();
local Pets = GUI.SideButtons().Tabs.Pets;
local EquipBest = v1.Frame.EquipBest;
local Badge = Pets.Badge;
local Badge2 = EquipBest.Badge;
local u2 = nil;
local u3 = nil;
local v4 = v1:IsA("ScreenGui");
assert(v4, "PlayerGui.PetList must be a ScreenGui");
local v5 = Pets:IsA("GuiButton");
assert(v5, "Elements.Tabs.Pets must be a GuiButton");
local v6 = EquipBest:IsA("GuiButton");
assert(v6, "PetList.Frame.EquipBest must be a GuiButton");
local v7 = Badge:IsA("Frame");
assert(v7, "Elements.Tabs.Pets.Badge must be a Frame");
local v8 = Badge2:IsA("Frame");
assert(v8, "PetList.Frame.EquipBest.Badge must be a Frame");
local v9 = {};

local function stopBadgePulse(p10, p11) -- Line: 60
    -- upvalues: GetOrCreateUIScale (copy)
    if p11 ~= nil then
        p11:Cancel();
        p11:Destroy();
    end;

    GetOrCreateUIScale(p10).Scale = 1;
    p10.Visible = false;

    return nil;
end;

local function startBadgePulse(p12, p13) -- Line: 70
    -- upvalues: GetOrCreateUIScale (copy), Tween (copy)
    p12.Visible = true;

    if p13 ~= nil then
        return p13;
    end;

    local v14 = GetOrCreateUIScale(p12);
    v14.Scale = 0.8;

    return Tween(v14, {
        Scale = 1.2
    }, {
        0.7,
        Enum.EasingStyle.Elastic,
        Enum.EasingDirection.Out,
        -1,
        true
    });
end;

local function refresh() -- Line: 85
    -- upvalues: Save (copy), LocalPlayer (copy), u2 (ref), startBadgePulse (copy), Badge (copy), GetOrCreateUIScale (copy), u3 (ref), Badge2 (copy)
    local v15 = Save.Get(LocalPlayer);
    local v16;

    if v15 == nil then
        v16 = nil;
    else
        v16 = v15.PetPenCapacityGuidance;
    end;

    local v17;

    if v16 == nil then
        v17 = false;
    else
        v17 = v16.Triggered and not v16.PetsTabAcknowledged;
    end;

    local v18;

    if v16 == nil then
        v18 = false;
    else
        v18 = v16.Triggered and not v16.EquipBestAcknowledged;
    end;

    if v17 then
        u2 = startBadgePulse(Badge, u2);
    else
        local v19 = Badge;
        local v20 = u2;

        if v20 ~= nil then
            v20:Cancel();
            v20:Destroy();
        end;

        GetOrCreateUIScale(v19).Scale = 1;
        v19.Visible = false;
        u2 = nil;
    end;

    if v18 then
        u3 = startBadgePulse(Badge2, u3);

        return;
    end;

    local v21 = Badge2;
    local v22 = u3;

    if v22 ~= nil then
        v22:Cancel();
        v22:Destroy();
    end;

    GetOrCreateUIScale(v21).Scale = 1;
    v21.Visible = false;
    u3 = nil;
end;

function v9.AcknowledgePetsBadge() -- Line: 107
    -- upvalues: Badge (copy), u2 (ref), GetOrCreateUIScale (copy), wcall (copy), AssetCmds (copy), refresh (copy)
    if not Badge.Visible then
        return;
    end;

    local v23 = Badge;
    local v24 = u2;

    if v24 ~= nil then
        v24:Cancel();
        v24:Destroy();
    end;

    GetOrCreateUIScale(v23).Scale = 1;
    v23.Visible = false;
    u2 = nil;
    task.spawn(function() -- Line: 112
        -- upvalues: wcall (ref), AssetCmds (ref), refresh (ref)
        local v25, v26 = wcall(AssetCmds.AcknowledgePenFullPetsBadge);

        if not v25 or v26 ~= true then
            refresh();
        end;
    end);
end;

function v9.AcknowledgeEquipBestBadge() -- Line: 120
    -- upvalues: Badge2 (copy), u3 (ref), GetOrCreateUIScale (copy), wcall (copy), AssetCmds (copy), refresh (copy)
    if not Badge2.Visible then
        return;
    end;

    local v27 = Badge2;
    local v28 = u3;

    if v28 ~= nil then
        v28:Cancel();
        v28:Destroy();
    end;

    GetOrCreateUIScale(v27).Scale = 1;
    v27.Visible = false;
    u3 = nil;
    task.spawn(function() -- Line: 125
        -- upvalues: wcall (ref), AssetCmds (ref), refresh (ref)
        local v29, v30 = wcall(AssetCmds.AcknowledgePenFullEquipBestBadge);

        if not v29 or v30 ~= true then
            refresh();
        end;
    end);
end;

function v9.Initialize() -- Line: 133
    -- upvalues: Save (copy), refresh (copy)
    Save.GetStatChangedSignal("PetPenCapacityGuidance"):Connect(refresh);
    task.spawn(refresh);
end;

return v9;