-- Decompiled with Potassium's decompiler.

local function Clamp(u1, u2) -- Line: 1
    return function(p3) -- Line: 2
        -- upvalues: u1 (copy), u2 (copy)
        return math.clamp(p3, u1, u2);
    end;
end;

local function Offset(u4) -- Line: 11
    return function(p5) -- Line: 12
        -- upvalues: u4 (copy)
        return p5 + u4;
    end;
end;

local v6 = {};
local u7 = 0;
local u8 = 1;

function v6.Damping(p9) -- Line: 2
    -- upvalues: u7 (copy), u8 (copy)
    return math.clamp(p9, u7, u8);
end;

function v6.AnchorDepth(p10) -- Line: 7
    return math.floor(p10);
end;

local u11 = 0;
local u12 = 1;

function v6.Stiffness(p13) -- Line: 2
    -- upvalues: u11 (copy), u12 (copy)
    return math.clamp(p13, u11, u12);
end;

local u14 = 0;
local u15 = 1;

function v6.Inertia(p16) -- Line: 2
    -- upvalues: u14 (copy), u15 (copy)
    return math.clamp(p16, u14, u15);
end;

local u17 = 0;
local u18 = 1;

function v6.Elasticity(p19) -- Line: 2
    -- upvalues: u17 (copy), u18 (copy)
    return math.clamp(p19, u17, u18);
end;

local u20 = 0;
local u21 = 1;

function v6.BlendWeight(p22) -- Line: 2
    -- upvalues: u20 (copy), u21 (copy)
    return math.clamp(p22, u20, u21);
end;

local u23 = 0;
local u24 = 165;

function v6.UpdateRate(p25) -- Line: 2
    -- upvalues: u23 (copy), u24 (copy)
    return math.clamp(p25, u23, u24);
end;

local u26 = 0;
local u27 = 10;

function v6.WindStrength(p28) -- Line: 2
    -- upvalues: u26 (copy), u27 (copy)
    return math.clamp(p28, u26, u27);
end;

local u29 = Vector3.new(0, -0.01, 0);

function v6.Gravity(p30) -- Line: 12
    -- upvalues: u29 (copy)
    return p30 + u29;
end;

return v6;