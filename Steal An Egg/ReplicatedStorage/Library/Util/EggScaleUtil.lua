-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AdminAbuseEgg = require(ReplicatedStorage.Directory.AdminAbuseEgg);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local u2 = {
    ClampSavedScale = function(p1) -- Line: 27, Name: ClampSavedScale
        -- upvalues: Asserts (copy)
        Asserts.finite(p1);

        return math.clamp(p1, 0.002, 200);
    end
};

function u2.GetFitScaleForContainer(p3, p4) -- Line: 33
    -- upvalues: Asserts (copy), BBFromModelVisibleOnly (copy), u2 (copy)
    Asserts.Model(p3);
    Asserts.finiteVector3(p4);
    local _, v5 = BBFromModelVisibleOnly(p3);
    local v6 = p4.X / math.max(v5.X, 0.002);
    local v7 = p4.Y / math.max(v5.Y, 0.002);
    local v8 = p4.Z / math.max(v5.Z, 0.002);
    local v9 = math.min(v6, v7, v8) * 0.92;

    return u2.ClampSavedScale(p3:GetScale() * v9);
end;

function u2.GetRawVisualScale(p10, p11) -- Line: 47
    -- upvalues: Asserts (copy)
    Asserts.finite(p10);
    Asserts.finite(p11);

    return p10 * math.max(p11, 0.002);
end;

function u2.GetMinRenderedScale(p12, p13) -- Line: 54
    -- upvalues: Asserts (copy), AdminAbuseEgg (copy)
    Asserts.finite(p12);
    Asserts.optional.string(p13);

    if AdminAbuseEgg.IsEventCategory(p13) then
        return p12 * 1;
    end;

    return p12 * 0.6;
end;

function u2.ClampRenderedScale(p14, p15, p16) -- Line: 65
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.finite(p14);
    Asserts.finite(p15);
    local v17 = u2.GetMinRenderedScale(p14, p16);

    return math.max(v17, p15);
end;

function u2.GetPreGrowthVisualScale(p18, p19, p20) -- Line: 72
    -- upvalues: u2 (copy)
    local v21 = u2.GetRawVisualScale(p18, p19);
    local v22 = u2.GetMinRenderedScale(p18, p20);

    return math.clamp(v21, v22, p18 * 8);
end;

function u2.GetPlacedStartScale(p23, p24, p25) -- Line: 85
    -- upvalues: u2 (copy)
    return u2.GetPreGrowthVisualScale(p23, p24, p25);
end;

function u2.GetPlacedTargetScale(p26, p27, p28) -- Line: 93
    -- upvalues: u2 (copy)
    local v29 = u2.GetRawVisualScale(p26, p27);
    local v30 = u2.GetMinRenderedScale(p26, p28);

    if v29 < v30 then
        return v30;
    end;

    return v29 * 3;
end;

return u2;