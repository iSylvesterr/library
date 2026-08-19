-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local CollisionGroups = require(ReplicatedStorage.Library.Types.CollisionGroups);
local u1 = RaycastParams.new();
u1.IgnoreWater = true;
u1.CollisionGroup = CollisionGroups.PLAYER_COLLISION_GROUP;
local v2 = {};

local function getRaycastHit(p3, p4) -- Line: 22
    -- upvalues: u1 (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera == nil then
        return nil;
    end;

    local v5 = CurrentCamera:ViewportPointToRay(p3.X, p3.Y);
    local v6 = workspace:Raycast(v5.Origin, v5.Direction * p4, u1);

    if v6 == nil then
        return nil;
    end;

    return v6.Instance;
end;

function v2.GetHoveredKey(p7, p8, p9) -- Line: 37
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.table(p7);
    Asserts.Vector2(p8);
    Asserts.number(p9);
    assert(p9 > 0, "maxDistance must be greater than 0");
    local CurrentCamera = workspace.CurrentCamera;
    local v10;

    if CurrentCamera == nil then
        v10 = nil;
    else
        local v11 = CurrentCamera:ViewportPointToRay(p8.X, p8.Y);
        local v12 = workspace:Raycast(v11.Origin, v11.Direction * p9, u1);

        if v12 == nil then
            v10 = nil;
        else
            v10 = v12.Instance;
        end;
    end;

    if v10 == nil then
        return nil;
    end;

    for i, v in pairs(p7) do
        Asserts.string(i);
        Asserts.Model(v);

        if v.Parent ~= nil and v10:IsDescendantOf(v) then
            return i;
        end;
    end;

    return nil;
end;

return v2;