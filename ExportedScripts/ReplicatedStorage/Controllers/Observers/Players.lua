-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local Observers = require(ReplicatedStorage.Packages.Observers);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local LocalPlayer = Players.LocalPlayer;
local CreateWeaponModel = require(script.Components.CreateWeaponModel);
local u1 = {};

local function destroyInstance(p2) -- Line: 21
    if not p2 then
        return;
    end;

    p2:Destroy();
end;

local function clearCurrentEquippedVisuals(p3) -- Line: 30
    -- upvalues: u1 (copy)
    u1[p3] = nil;
    local Character = p3.Character;

    if not (Character and Character:IsDescendantOf(workspace)) then
        return;
    end;

    local WeaponAttachments = Character:FindFirstChild("WeaponAttachments");

    if WeaponAttachments then
        WeaponAttachments:ClearAllChildren();
    end;

    local WeaponModel = Character:FindFirstChild("WeaponModel");

    if WeaponModel then
        WeaponModel:ClearAllChildren();
    end;

    local Debris = workspace:FindFirstChild("Debris");

    if not Debris then
        return;
    end;

    local v4 = Debris:FindFirstChild(p3.Name .. "_Weapon");

    if v4 and v4 then
        v4:Destroy();
    end;

    local v5 = Debris:FindFirstChild(p3.Name .. "_WeaponAttachments");

    if v5 then
        if not v5 then
            return;
        end;

        v5:Destroy();
    end;
end;

local function buildInventorySlots(p6) -- Line: 67
    -- upvalues: HttpService (copy)
    local v7 = {};

    for i = 1, 3 do
        local v8 = p6:GetAttribute("Slot" .. i);

        if v8 then
            v7[i] = HttpService:JSONDecode(v8);
        end;
    end;

    return v7;
end;

local function stickerSignature(p9) -- Line: 85
    if typeof(p9) ~= "table" then
        return "";
    end;

    local v10 = {};

    for i, v in ipairs(p9) do
        if typeof(v) == "table" then
            local Position = v.Position;
            local v11 = typeof(Position) == "table" and (Position.Rotation or "") or "";
            local v12 = typeof(Position) == "table" and (Position.X or "") or "";
            local v13 = typeof(Position) == "table" and (Position.Y or "") or "";
            v10[i] = string.format("%s@%s,%s,%s", tostring(v.Sticker or ""), tostring(v11), tostring(v12), (tostring(v13)));
        else
            v10[i] = tostring(v);
        end;
    end;

    return table.concat(v10, ";");
end;

local function visualSignature(p14) -- Line: 108
    -- upvalues: stickerSignature (copy)
    return typeof(p14) ~= "table" and "" or table.concat({
        tostring(p14.Identifier or ""),
        tostring(p14.Name or ""),
        tostring(p14.Skin or ""),
        tostring(p14.Float or ""),
        tostring(p14.StatTrack or ""),
        tostring(p14.NameTag or ""),
        tostring(p14.IsSuppressed or ""),
        stickerSignature(p14.Stickers)
    }, "|");
end;

local function getEquippedWeaponName(p15) -- Line: 129
    return typeof(p15) == "string" and (string.match(p15, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or "";
end;

local function createInventoryListener(u16) -- Line: 141
    -- upvalues: Observers (copy), DebugFlags (copy), clearCurrentEquippedVisuals (copy), HttpService (copy), visualSignature (copy), u1 (copy), CreateWeaponModel (copy), buildInventorySlots (copy)
    return Observers.observeAttribute(u16, "CurrentEquipped", function(p17) -- Line: 142
        -- upvalues: DebugFlags (ref), u16 (copy), clearCurrentEquippedVisuals (ref), HttpService (ref), visualSignature (ref), u1 (ref), CreateWeaponModel (ref), buildInventorySlots (ref)
        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            local v18 = warn;
            local Name = u16.Name;
            local v19 = typeof(p17) == "string" and (#p17 or -1) or -1;
            v18(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(Name, (tostring(v19))));
        end;

        if not p17 then
            clearCurrentEquippedVisuals(u16);

            return function() -- Line: 156
            end;
        end;

        local u20 = HttpService:JSONDecode(p17);
        local v21 = visualSignature(u20);

        if v21 ~= "" and u1[u16] == v21 then
            return function() -- Line: 165
            end;
        end;

        u1[u16] = v21;
        debug.profilebegin("Observers.Players.CurrentEquipped.CreateWeaponModel");
        local v22, v23, _ = pcall(function() -- Line: 171
            -- upvalues: CreateWeaponModel (ref), u16 (ref), u20 (copy), buildInventorySlots (ref)
            return CreateWeaponModel(u16, u20, (buildInventorySlots(u16)));
        end);
        debug.profileend();

        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            if v22 then
                warn(("[ThirdPersonWeaponModels] %s CreateWeaponModel ok"):format(u16.Name));
            else
                warn(("[ThirdPersonWeaponModels] %s CreateWeaponModel failed: %s"):format(u16.Name, (tostring(v23))));
            end;
        end;

        return function() -- Line: 189
            -- upvalues: u16 (ref), clearCurrentEquippedVisuals (ref)
            if u16:GetAttribute("CurrentEquipped") ~= nil then
                return;
            end;

            clearCurrentEquippedVisuals(u16);
        end;
    end);
end;

local function refreshObjectiveKitHolster(u24) -- Line: 201
    -- upvalues: CreateWeaponModel (copy), DebugFlags (copy)
    local success, result = pcall(function() -- Line: 202
        -- upvalues: CreateWeaponModel (ref), u24 (copy)
        CreateWeaponModel.RefreshObjectiveKitHolster(u24);
    end);

    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s RefreshObjectiveKitHolster failed: %s"):format(u24.Name, (tostring(result))));
    end;
end;

local function createObjectiveKitListener(u25) -- Line: 215
    -- upvalues: Observers (copy), refreshObjectiveKitHolster (copy)
    local u26 = Observers.observeAttribute(u25, "HasDefuseKit", function() -- Line: 216
        -- upvalues: refreshObjectiveKitHolster (ref), u25 (copy)
        refreshObjectiveKitHolster(u25);

        return function() -- Line: 218
        end;
    end);
    local u27 = Observers.observeAttribute(u25, "HasRescueKit", function() -- Line: 221
        -- upvalues: refreshObjectiveKitHolster (ref), u25 (copy)
        refreshObjectiveKitHolster(u25);

        return function() -- Line: 223
        end;
    end);
    local u28 = u25.CharacterAdded:Connect(function() -- Line: 226
        -- upvalues: refreshObjectiveKitHolster (ref), u25 (copy)
        refreshObjectiveKitHolster(u25);
    end);
    refreshObjectiveKitHolster(u25);

    return function() -- Line: 232
        -- upvalues: u26 (copy), u27 (copy), u28 (copy)
        u26();
        u27();
        u28:Disconnect();
    end;
end;

local function refreshBombHolster(u29) -- Line: 241
    -- upvalues: CreateWeaponModel (copy), DebugFlags (copy)
    debug.profilebegin("Observers.Players.RefreshBombHolster");
    local success, result = pcall(function() -- Line: 243
        -- upvalues: CreateWeaponModel (ref), u29 (copy)
        CreateWeaponModel.RefreshBombHolster(u29);
    end);

    if DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not success then
        warn(("[ThirdPersonWeaponModels] %s RefreshBombHolster failed: %s"):format(u29.Name, (tostring(result))));
    end;

    debug.profileend();
end;

local function createBombHolsterListener(u30) -- Line: 255
    -- upvalues: refreshBombHolster (copy), Observers (copy)
    local v31 = u30:GetAttribute("CurrentEquipped");
    local u32 = typeof(v31) == "string" and (string.match(v31, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or "";
    local u33 = u30:GetAttributeChangedSignal("Slot5"):Connect(function() -- Line: 261
        -- upvalues: refreshBombHolster (ref), u30 (copy)
        refreshBombHolster(u30);
    end);
    local u36 = Observers.observeAttribute(u30, "CurrentEquipped", function(p34) -- Line: 268
        -- upvalues: u32 (ref), refreshBombHolster (ref), u30 (copy)
        local v35 = typeof(p34) == "string" and (string.match(p34, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or "";

        if v35 == u32 then
            return function() -- Line: 271
            end;
        end;

        u32 = v35;
        refreshBombHolster(u30);

        return function() -- Line: 276
        end;
    end);
    local u37 = u30.CharacterAdded:Connect(function() -- Line: 280
        -- upvalues: refreshBombHolster (ref), u30 (copy)
        refreshBombHolster(u30);
    end);
    refreshBombHolster(u30);

    return function() -- Line: 286
        -- upvalues: u33 (copy), u36 (copy), u37 (copy)
        u33:Disconnect();
        u36();
        u37:Disconnect();
    end;
end;

return Observers.observePlayer(function(u38) -- Line: 296
    -- upvalues: LocalPlayer (copy), Observers (copy), DebugFlags (copy), clearCurrentEquippedVisuals (copy), HttpService (copy), visualSignature (copy), u1 (copy), CreateWeaponModel (copy), buildInventorySlots (copy), createObjectiveKitListener (copy), createBombHolsterListener (copy)
    if u38 == LocalPlayer then
        return function() -- Line: 300
        end;
    end;

    local u46 = Observers.observeAttribute(u38, "CurrentEquipped", function(p39) -- Line: 142
        -- upvalues: DebugFlags (ref), u38 (copy), clearCurrentEquippedVisuals (ref), HttpService (ref), visualSignature (ref), u1 (ref), CreateWeaponModel (ref), buildInventorySlots (ref)
        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            local v40 = warn;
            local Name = u38.Name;
            local v41 = typeof(p39) == "string" and (#p39 or -1) or -1;
            v40(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(Name, (tostring(v41))));
        end;

        if not p39 then
            clearCurrentEquippedVisuals(u38);

            return function() -- Line: 156
            end;
        end;

        local u42 = HttpService:JSONDecode(p39);
        local v43 = visualSignature(u42);

        if v43 ~= "" and u1[u38] == v43 then
            return function() -- Line: 165
            end;
        end;

        u1[u38] = v43;
        debug.profilebegin("Observers.Players.CurrentEquipped.CreateWeaponModel");
        local v44, v45, _ = pcall(function() -- Line: 171
            -- upvalues: CreateWeaponModel (ref), u38 (ref), u42 (copy), buildInventorySlots (ref)
            return CreateWeaponModel(u38, u42, (buildInventorySlots(u38)));
        end);
        debug.profileend();

        if DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            if v44 then
                warn(("[ThirdPersonWeaponModels] %s CreateWeaponModel ok"):format(u38.Name));
            else
                warn(("[ThirdPersonWeaponModels] %s CreateWeaponModel failed: %s"):format(u38.Name, (tostring(v45))));
            end;
        end;

        return function() -- Line: 189
            -- upvalues: u38 (ref), clearCurrentEquippedVisuals (ref)
            if u38:GetAttribute("CurrentEquipped") ~= nil then
                return;
            end;

            clearCurrentEquippedVisuals(u38);
        end;
    end);
    local u47 = createObjectiveKitListener(u38);
    local u48 = createBombHolsterListener(u38);

    return function() -- Line: 306
        -- upvalues: u46 (copy), u47 (copy), u48 (copy), CreateWeaponModel (ref), u38 (copy), u1 (ref)
        u46();
        u47();
        u48();
        CreateWeaponModel.ClearPlayerCache(u38);
        u1[u38] = nil;
    end;
end);