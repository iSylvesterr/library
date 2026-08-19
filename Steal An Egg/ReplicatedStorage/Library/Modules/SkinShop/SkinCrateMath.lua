-- Decompiled with Potassium's decompiler.

local SkinCrateConfig = require(script.Parent.SkinCrateConfig);
local u1 = {};

local function foldHash(p2, p3) -- Line: 9
    for i = 1, #p3 do
        p2 = (p2 * 33 + string.byte(p3, i)) % 2147483647;
    end;

    return p2;
end;

function u1.GetCycleBucket(p4) -- Line: 17
    -- upvalues: SkinCrateConfig (copy)
    return math.floor(p4 / SkinCrateConfig.RefreshTime);
end;

function u1.GetCycleWindow(p5) -- Line: 21
    -- upvalues: u1 (copy), SkinCrateConfig (copy)
    local v6 = u1.GetCycleBucket(p5);
    local v7 = v6 * SkinCrateConfig.RefreshTime;

    return v6, v7, v7 + SkinCrateConfig.RefreshTime;
end;

function u1.GetCycleId(p8, p9) -- Line: 28
    return `{p8}:{p9}`;
end;

function u1.GetEligibilityThreshold(p10) -- Line: 32
    -- upvalues: SkinCrateConfig (copy)
    return math.ceil(p10 * SkinCrateConfig.EligibilityRatio);
end;

function u1.ComputeStock(p11, p12, p13) -- Line: 36
    local v14 = math.max(p11, 0) * p12;
    local v15 = math.ceil(v14);

    return math.max(p13, v15);
end;

function u1.ComputeNextPrice(p16, p17, p18, p19, p20) -- Line: 40
    local v21 = math.max(0, p18) / math.max(1, p17);
    local v22 = p19 == nil and 0 or math.max(0, 1 - p19 / p20.TargetSelloutTime);
    local v23 = p16 * math.clamp(1 + (0.1 * (v21 - p20.TargetFill) + v22 * 0.08), p20.MinCycleMultiplier, p20.MaxCycleMultiplier);
    local v24 = math.floor(v23);

    return math.max(1, v24);
end;

function u1.RollSpawn(p25, p26, p27) -- Line: 60
    local v28 = p26 + 17;

    for i = 1, #p25 do
        v28 = (v28 * 33 + string.byte(p25, i)) % 2147483647;
    end;

    return Random.new(v28):NextNumber() <= p27;
end;

return u1;