-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Directory.Assets.Types.Personality);
local Player = require(ReplicatedStorage.Library.Player);
local AssetWanderArea = require(script.Parent.AssetWanderArea);
local u1 = {};

local function isolatedPointFromOwner(p2, p3, p4) -- Line: 22
    -- upvalues: AssetWanderArea (copy)
    local v5, v6 = AssetWanderArea.HalfExtents(p2);
    local v7 = p2.CFrame:PointToObjectSpace(p4);
    local v8;

    if v7.X >= 0 then
        v8 = p3:NextNumber(-v5, 0);
    else
        v8 = p3:NextNumber(0, v5);
    end;

    local v9;

    if v7.Z >= 0 then
        v9 = p3:NextNumber(-v6, 0);
    else
        v9 = p3:NextNumber(0, v6);
    end;

    return (p2.CFrame * CFrame.new(v8, 0, v9)).Position;
end;

function u1.StepIdle(p10, p11, p12, p13, p14) -- Line: 35
    local v15 = math.max(p11 - p10, 0);
    local v16 = p12 + p10;

    if p14 ~= nil and v15 > 0 then
        local v17 = v16 * p14.CyclesPerSecond * 3.141592653589793 * 2;
        local v18 = math.sin(v17) * p14.Amplitude;
        local v19 = math.sin(v17 * 1.37 + 1.0471975511965976) * p14.Amplitude;
        p13 = p13 * CFrame.new(v18, 0, v19);
    end;

    return p13, v15, v16, v15 <= 0;
end;

function u1.ChooseDestination(p20, p21, p22, p23) -- Line: 55
    -- upvalues: isolatedPointFromOwner (copy), AssetWanderArea (copy)
    if p23 ~= nil and p21:NextNumber() < p22.IsolationPreference then
        return isolatedPointFromOwner(p20, p21, p23);
    end;

    if p23 == nil or p21:NextNumber() >= p22.NearOwnerPreference then
        return AssetWanderArea.RandomPoint(p20, p21);
    end;

    return AssetWanderArea.ClampedPointToward(p20, p23);
end;

function u1.RandomOwnerOffset(p24, p25, p26) -- Line: 71
    local v27 = p25:NextNumber(0, 6.283185307179586);
    local v28 = math.cos(v27) * p26;
    local v29 = math.sin(v27) * p26;
    local v30 = Vector3.new(v28, 0, v29);

    return p24.CFrame:VectorToWorldSpace(v30);
end;

function u1.RollChance(p31, p32) -- Line: 78
    if p32 <= 0 then
        return false;
    end;

    return p32 >= 1 and true or p31:NextNumber() <= p32;
end;

function u1.RandomConfiguredText(p33, p34, p35, p36) -- Line: 89
    local v37 = `Personality {p35} requires at least one {p36} text`;
    assert(#p34 > 0, v37);

    return p34[p33:NextInteger(1, #p34)];
end;

function u1.OwnerRootPosition(p38) -- Line: 99
    -- upvalues: Player (copy)
    local v39 = Player.Optional.PrimaryPart(p38);

    if v39 == nil then
        return nil;
    end;

    return v39.Position;
end;

function u1.DistanceFromPlayerToAreaCenter(p40, p41) -- Line: 104
    -- upvalues: u1 (copy)
    local v42 = u1.OwnerRootPosition(p40);

    if v42 == nil then
        return nil;
    end;

    return (v42 - p41.Position).Magnitude;
end;

function u1.ShouldStartAmbientJump(p43, p44, p45, p46) -- Line: 109
    if p44 <= 0 or p46 then
        return false;
    end;

    return 1 - math.exp(-p44 * p45) >= p43:NextNumber();
end;

return u1;