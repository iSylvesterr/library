-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Input = require(ReplicatedStorage.Library.Modules.Packages.Input);
local PlacedEggRenderer = require(script.Parent.PlacedEggRenderer);
local u1 = Input.Mouse.new();
local v2 = {};

local function placementRaycastParams(p3, p4) -- Line: 24
    -- upvalues: PlacedEggRenderer (copy)
    local v5 = { p3 };
    PlacedEggRenderer.AppendRaycastTargets(v5, p4);
    local v6 = RaycastParams.new();
    v6.FilterType = Enum.RaycastFilterType.Include;
    v6.FilterDescendantsInstances = v5;
    v6.IgnoreWater = true;

    return v6;
end;

function v2.Raycast(p7, p8) -- Line: 39
    -- upvalues: Asserts (copy), u1 (copy), placementRaycastParams (copy)
    Asserts.BasePart(p7);
    Asserts.number(p8);

    return u1:Raycast(placementRaycastParams(p7, p8), 500);
end;

return v2;