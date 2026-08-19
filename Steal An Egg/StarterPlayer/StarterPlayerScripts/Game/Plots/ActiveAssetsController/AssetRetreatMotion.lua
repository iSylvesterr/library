-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Directory.Assets.Types.Personality);
local AssetWanderArea = require(script.Parent.AssetWanderArea);
local u1 = table.freeze({ 0, 0.6108652381980153, -0.6108652381980153, 1.2217304763960306, -1.2217304763960306, 1.8325957145940461, -1.8325957145940461, 2.443460952792061, -2.443460952792061, 3.141592653589793 });
local v2 = {};

local function rotateLocalFlatDirection(p3, p4) -- Line: 35
    local v5 = math.cos(p4);
    local v6 = math.sin(p4);

    return Vector3.new(p3.X * v5 - p3.Z * v6, 0, p3.X * v6 + p3.Z * v5);
end;

local function distanceToAreaEdge(p7, p8, p9) -- Line: 41
    -- upvalues: AssetWanderArea (copy)
    local v10, v11 = AssetWanderArea.HalfExtents(p7);
    local v12 = (1 / 0);
    local v13 = (1 / 0);

    if p9.X > 0 then
        v12 = (v10 - p8.X) / p9.X;
    elseif p9.X < 0 then
        v12 = (-v10 - p8.X) / p9.X;
    end;

    if p9.Z > 0 then
        v13 = (v11 - p8.Z) / p9.Z;
    elseif p9.Z < 0 then
        v13 = (-v11 - p8.Z) / p9.Z;
    end;

    local v14 = math.min(v12, v13) - 2;

    return math.max(v14, 0);
end;

local function ownerAwayDirection(p15, p16, p17) -- Line: 60
    local v18 = Vector3.new(p17.X - p16.X, 0, p17.Z - p16.Z);

    if v18.Magnitude > 0 then
        return v18.Unit;
    end;

    local v19 = Vector3.new(p17.X - p15.Position.X, 0, p17.Z - p15.Position.Z);

    if v19.Magnitude > 0 then
        return v19.Unit;
    end;

    local LookVector = p15.CFrame.LookVector;
    local v20 = Vector3.new(LookVector.X, 0, LookVector.Z);
    assert(v20.Magnitude > 0, "Asset area must provide a horizontal retreat direction");

    return v20.Unit;
end;

function v2.Destination(p21, p22, p23, p24, p25) -- Line: 81
    -- upvalues: ownerAwayDirection (copy), u1 (copy), distanceToAreaEdge (copy), AssetWanderArea (copy)
    local v26 = p21.CFrame:PointToObjectSpace(p25);
    local v27 = ownerAwayDirection(p21, p24, p25);
    local v28 = p21.CFrame:VectorToObjectSpace(v27);
    local v29 = Vector3.new(v28.X, 0, v28.Z);
    assert(v29.Magnitude > 0, "Retreat direction must be horizontal");
    local Unit = v29.Unit;
    local v30 = Unit;
    local v31 = (-1 / 0);
    local v32 = 0;

    for _, v in ipairs(u1) do
        local v33 = math.cos(v);
        local v34 = math.sin(v);
        local Unit2 = Vector3.new(Unit.X * v33 - Unit.Z * v34, 0, Unit.X * v34 + Unit.Z * v33).Unit;
        local v35 = distanceToAreaEdge(p21, v26, Unit2);
        local v36 = Unit2:Dot(Unit);
        local v37 = v35 * (math.max(v36, 0) + 0.6);

        if v31 < v37 then
            v30 = Unit2;
            v32 = v35;
            v31 = v37;
        end;
    end;

    if v32 <= 0 then
        return AssetWanderArea.RandomPoint(p21, p22);
    end;

    if p23.MaxTravelDistance ~= nil then
        v32 = math.min(p23.MaxTravelDistance, v32);
    end;

    local v38 = v26 + v30 * v32;

    return (p21.CFrame * CFrame.new(v38.X, 0, v38.Z)).Position;
end;

return v2;