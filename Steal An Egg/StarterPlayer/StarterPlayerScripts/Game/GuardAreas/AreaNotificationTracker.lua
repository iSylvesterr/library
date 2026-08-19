-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Areas = require(ReplicatedStorage.Directory.Areas);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GuardAreaLookupUtil = require(ReplicatedStorage.Library.Util.GuardAreaLookupUtil);
local Heartbeat = require(ReplicatedStorage.Library.Functions.Heartbeat);
local Player = require(ReplicatedStorage.Library.Player);
local LocalPlayer = Players.LocalPlayer;
local __OBJECTS = Workspace:WaitForChild("__OBJECTS");
local v1 = __OBJECTS:IsA("Folder");
assert(v1, "Workspace.__OBJECTS must be a Folder");
local Areas2 = __OBJECTS.Areas;
local v2 = Areas2:IsA("Folder");
assert(v2, "Workspace.__OBJECTS.Areas must be a Folder");
local SeparationLine = Areas2.SeparationLine;
local v3 = SeparationLine:IsA("BasePart");
assert(v3, "Workspace.__OBJECTS.Areas.SeparationLine must be a BasePart");
local GuardAreas = Areas2.GuardAreas;
local v4 = GuardAreas:IsA("Folder");
assert(v4, "Workspace.__OBJECTS.Areas.GuardAreas must be a Folder");
local v5 = {};
local u6 = {};
local u7 = nil;
local u8 = nil;

local function rebuildAreaEntries(p9) -- Line: 49
    -- upvalues: u6 (copy), GuardAreaLookupUtil (copy), GuardAreas (copy), Areas (copy)
    table.clear(u6);

    for _, v in ipairs(GuardAreaLookupUtil.ResolveAreaBoundsEntries(GuardAreas)) do
        u6[#u6 + 1] = {
            AreaId = v.AreaId,
            Bounds = v.Bounds,
            Config = Areas.Directory[v.AreaId]
        };
    end;

    table.sort(u6, function(p10, p11) -- Line: 60
        local RarityNumber = p10.Config.Rarity.RarityNumber;
        local RarityNumber2 = p11.Config.Rarity.RarityNumber;

        if RarityNumber == RarityNumber2 then
            return p10.AreaId < p11.AreaId;
        end;

        return RarityNumber < RarityNumber2;
    end);
end;

local function resolveCurrentArea(p12) -- Line: 71
    -- upvalues: Asserts (copy), u6 (copy), GuardAreaLookupUtil (copy)
    Asserts.Vector3(p12);

    for _, v in ipairs(u6) do
        if GuardAreaLookupUtil.IsWorldPositionInsideXZBounds(v.Bounds, p12) then
            return v;
        end;
    end;

    return nil;
end;

local function step(p13) -- Line: 83
    -- upvalues: Player (copy), LocalPlayer (copy), u7 (ref), GuardAreaLookupUtil (copy), SeparationLine (copy), u8 (ref), resolveCurrentArea (copy)
    local v14 = Player.Optional.HumanoidRootPart(LocalPlayer);

    if v14 == nil then
        u7 = nil;

        return;
    end;

    local v15 = v14:IsA("BasePart");
    local v16 = `{v14:GetFullName()} must be a BasePart`;
    assert(v15, v16);

    if not GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v14.Position) then
        u7 = nil;
        u8 = nil;

        return;
    end;

    local v17 = resolveCurrentArea(v14.Position);

    if v17 == nil then
        u7 = nil;

        return;
    end;

    if v17.AreaId == u7 then
        return;
    end;

    u7 = v17.AreaId;
    local RarityNumber = v17.Config.Rarity.RarityNumber;
    local v18 = u8;
    u8 = RarityNumber;

    if v18 ~= nil and RarityNumber <= v18 then
        return;
    end;

    p13(v17.Config);
end;

function v5.Start(u19) -- Line: 122
    -- upvalues: Asserts (copy), rebuildAreaEntries (copy), GuardAreas (copy), Heartbeat (copy), step (copy)
    Asserts.func(u19);
    rebuildAreaEntries(nil);
    GuardAreas.ChildAdded:Connect(rebuildAreaEntries);
    GuardAreas.ChildRemoved:Connect(rebuildAreaEntries);
    local u20 = 0;
    Heartbeat(function(p21) -- Line: 130
        -- upvalues: u20 (ref), step (ref), u19 (copy)
        u20 = u20 + p21;

        if u20 < 0.1 then
            return nil;
        end;

        u20 = 0;
        step(u19);

        return nil;
    end);
end;

return v5;