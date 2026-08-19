-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};
u1.__index = u1;
u1.__class = "RandomWrapper";

function u1.new(p2) -- Line: 24
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3:_init(p2);

    return v3;
end;

function u1._init(p4, p5) -- Line: 30
    if p5 == nil then
        p4._rng = Random.new();

        return;
    end;

    if type(p5) == "number" then
        p4._rng = Random.new(p5);

        return;
    end;

    if typeof(p5) == "Random" then
        p4._rng = p5;

        return;
    end;

    error((`Unknown seed type: {typeof(p5)}`));
end;

function u1.handle(p6) -- Line: 46
    return p6._rng;
end;

function u1.clone(p7) -- Line: 51
    -- upvalues: u1 (copy)
    return u1.new(p7._rng:Clone());
end;

function u1.seed(p8, p9) -- Line: 55
    p8._rng = Random.new(p9);
end;

function u1.number(p10, p11, p12) -- Line: 59
    if p11 == nil or p12 == nil then
        return p10._rng:NextNumber(0, 1);
    end;

    return p10._rng:NextNumber(p11, p12);
end;

function u1.takeCutOffNumber(p13, p14, p15) -- Line: 67
    -- upvalues: Asserts (copy)
    Asserts.number(p14);
    Asserts.number(p15);
    local v16 = math.abs(p14) * p15;

    return p13:number(p14 - v16, p14 + v16);
end;

function u1.boolean(p17, p18) -- Line: 78
    return p17._rng:NextNumber() < (p18 or 0.5);
end;

function u1.integer(p19, p20, p21) -- Line: 82
    return p19._rng:NextInteger(p20, p21);
end;

function u1.integerArray(p22, p23) -- Line: 86
    -- upvalues: Asserts (copy)
    Asserts.table(p23);
    Asserts.array.notEmpty(p23);

    if #p23 == 1 then
        return p23[1];
    end;

    return p22._rng:NextInteger(unpack(p23));
end;

function u1.numberArray(p24, p25) -- Line: 97
    -- upvalues: Asserts (copy)
    Asserts.table(p25);
    Asserts.array.notEmpty(p25);

    if #p25 == 1 then
        return p25[1];
    end;

    return p24._rng:NextNumber(unpack(p25));
end;

function u1.normal(p26, p27, p28) -- Line: 109
    local v29 = math.max(2.2250738585072014e-308, p26._rng:NextNumber());
    local v30 = math.log(v29) * -2;
    local v31 = math.sqrt(v30) * (p28 or 1);
    local v32 = p26._rng:NextNumber() * 6.283185307179586;
    local v33 = p27 or 0;

    return v31 * math.cos(v32) + v33, v31 * math.sin(v32) + v33;
end;

function u1.Vector3(p34, p35) -- Line: 117
    return p34._rng:NextUnitVector() * (p35 or 1);
end;

function u1.Vector2(p36, p37) -- Line: 122
    local v38 = p36._rng:NextNumber() * 6.283185307179586;

    return Vector2.new(math.cos(v38), (math.sin(v38))) * (p37 or 1);
end;

function u1.positiveYVector3(p39, p40) -- Line: 127
    local v41 = p39:Vector3(p40);
    local X = v41.X;
    local v42 = math.max(0, v41.Y);

    return Vector3.new(X, v42, v41.Z);
end;

function u1.flatVector3PositiveY(p43, p44) -- Line: 132
    local v45 = math.abs(p44 or 1);

    return Vector3.new(0, v45, 0);
end;

return u1;