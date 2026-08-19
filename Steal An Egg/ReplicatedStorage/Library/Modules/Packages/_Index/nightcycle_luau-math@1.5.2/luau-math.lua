-- Decompiled with Potassium's decompiler.

require(script:WaitForChild("Types"));
local Geometry = require(script:WaitForChild("Geometry"));
local Mesh = require(script:WaitForChild("Mesh"));
local Algebra = require(script:WaitForChild("Algebra"));
local Noise = require(script:WaitForChild("Noise"));
local Pathfind = require(script:WaitForChild("Pathfind"));
local Physics = require(script:WaitForChild("Physics"));
local v1 = {
    abs = math.abs,
    acos = math.acos,
    asin = math.asin,
    atan = math.atan,
    atan2 = math.atan2,
    ceil = math.ceil,
    clamp = math.clamp,
    cos = math.cos,
    cosh = math.cosh,
    deg = math.deg,
    exp = math.exp,
    floor = math.floor,
    fmod = math.fmod,
    frexp = math.frexp,
    ldexp = math.ldexp,
    log = math.log,
    log10 = math.log10,
    max = math.max,
    min = math.min,
    modf = math.modf,
    noise = math.noise,
    pow = math.pow,
    rad = math.rad,
    random = math.random,
    randomseed = math.randomseed,
    sign = math.sign,
    sin = math.sin,
    sinh = math.sinh,
    sqrt = math.sqrt,
    tan = math.tan,
    tanh = math.tanh,
    huge = (1 / 0),
    pi = 3.141592653589793,
    Geometry = Geometry,
    Mesh = Mesh,
    Algebra = Algebra,
    Noise = Noise,
    Pathfind = Pathfind,
    Physics = Physics
};

local function u29(p2, p3) -- Line: 179
    -- upvalues: u29 (ref)
    local v4 = p3 or 1;
    assert(v4 ~= nil);

    if typeof(p2) == "number" then
        return math.round(p2 / v4) * v4;
    end;

    if typeof(p2) == "Vector2" then
        local v5 = u29(p2.X, v4);
        local v6 = typeof(v5) == "number";
        assert(v6);
        local v7 = u29(p2.Y, v4);
        local v8 = typeof(v7) == "number";
        assert(v8);

        return Vector2.new(v5, v7);
    end;

    if typeof(p2) == "Vector3" then
        local v9 = u29(p2.X, v4);
        local v10 = typeof(v9) == "number";
        assert(v10);
        local v11 = u29(p2.X, v4);
        local v12 = typeof(v11) == "number";
        assert(v12);
        local v13 = u29(p2.Z, v4);
        local v14 = typeof(v13) == "number";
        assert(v14);

        return Vector3.new(v9, v11, v13);
    end;

    if typeof(p2) == "Color3" then
        local v15 = u29(p2.R, v4);
        local v16 = typeof(v15) == "number";
        assert(v16);
        local v17 = u29(p2.G, v4);
        local v18 = typeof(v17) == "number";
        assert(v18);
        local v19 = u29(p2.B, v4);
        local v20 = typeof(v19) == "number";
        assert(v20);

        return Color3.new(v15, v17, v19);
    end;

    if typeof(p2) ~= "CFrame" then
        error("Bad variable");

        return p2;
    end;

    local v21 = u29(p2.Position, v4);
    local v22 = typeof(v21) == "Vector3";
    assert(v22);
    local v23 = u29(p2.XVector, v4);
    local v24 = typeof(v23) == "Vector3";
    assert(v24);
    local v25 = u29(p2.YVector, v4);
    local v26 = typeof(v25) == "Vector3";
    assert(v26);
    local v27 = u29(p2.ZVector, v4);
    local v28 = typeof(v27) == "Vector3";
    assert(v28);

    return CFrame.fromMatrix(v21, v23, v25, v27);
end;

v1.round = u29;
v1.__index = v1;

return v1;