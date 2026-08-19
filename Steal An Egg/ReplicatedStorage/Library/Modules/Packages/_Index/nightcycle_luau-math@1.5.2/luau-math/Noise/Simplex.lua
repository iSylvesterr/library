-- Decompiled with Potassium's decompiler.

local Algebra = require(script.Parent.Parent:WaitForChild("Algebra"));
local Vector = require(script.Parent.Parent:WaitForChild("Algebra"):WaitForChild("Vector"));
require(script.Parent.Parent:WaitForChild("Algebra"):WaitForChild("Matrix"));
local Solver = require(script.Parent:WaitForChild("Solver"));
local u1 = {};
u1.__index = u1;

function u1.Get(p2, p3) -- Line: 16
    -- upvalues: Vector (copy), Algebra (copy)
    local u4 = p2.translateVector(p3);

    if u4.Size <= 3 then
        math.randomseed(p2.Seed);
        local Frequency = p2.Frequency;
        local v5 = typeof(Frequency) == "number";
        assert(v5);

        return p2:_Compile(u4, 0.5 + math.noise(Frequency * (u4[1] or 0), Frequency * (u4[2] or 0), Frequency * (u4[3] or 0)) * 0.5);
    end;

    local v6 = 1 / p2.Frequency;
    local u7 = (u4 / v6):Floor() * v6;
    local u8 = Vector.one(u4.Size) * v6;
    local u9 = { u7 };

    for i = 1, u4.Size do
        local v10 = {};

        for i2 = 1, u4.Size do
            table.insert(v10, i2 <= i and 1 or 0);
        end;

        local function permutate(p11, p12, p13) -- Line: 42
            -- upvalues: u9 (copy), u4 (ref), u7 (copy), Vector (ref), u8 (copy), permutate (copy)
            if #u9 == 2 ^ u4.Size then
                return;
            end;

            if p12 == 1 then
                local v14 = u7 + Vector.new(unpack(p11)) * u8;
                table.insert(u9, v14);
            end;

            for i2 = 1, p12 do
                permutate(p11, p12 - 1, p13);

                if p12 % 2 == 1 then
                    local v15 = p11[1];
                    p11[1] = p11[p12];
                    p11[p12] = v15;
                else
                    local v16 = p11[i2];
                    p11[i2] = p11[p12];
                    p11[p12] = v16;
                end;
            end;
        end;

        permutate(v10, #v10, #v10);
    end;

    local v17 = {};

    for i, v in ipairs(u9) do
        v17[i] = p2:_Rand(v);
    end;

    local function pairAndLerp(p18, p19) -- Line: 69
        -- upvalues: u4 (ref), Algebra (ref), pairAndLerp (copy)
        local v20 = {};
        local v21 = {};

        for i, v in ipairs(p18) do
            v20[v] = p19[i];
        end;

        for i = 1, math.floor(#p18 / 2) do
            v21[p18[i]] = p18[i + #p18 / 2];
        end;

        local v22 = {};
        local v23 = {};

        for i, v in pairs(v21) do
            local v24 = v20[i];
            local v25 = v20[v];
            local Magnitude = (i - u4).Magnitude;
            local Magnitude2 = (i - v).Magnitude;
            local v26 = math.acos((Magnitude ^ 2 + Magnitude2 ^ 2 - (v - u4).Magnitude ^ 2) / (2 * Magnitude * Magnitude2));
            local v27 = math.cos(v26 ~= v26 and 0 or v26) * (u4 - i).Magnitude;
            local v28 = math.min(v27, (i - v).Magnitude) / Magnitude2;
            local v29 = v28 ^ 2 * (3 - 2 * v28);
            local v30 = i:Lerp(v, v29);
            local v31 = Algebra.lerp(v24, v25, v29);
            table.insert(v22, v30);
            table.insert(v23, v31);
        end;

        if #v22 <= 1 then
            return v23[1];
        end;

        return pairAndLerp(v22, v23);
    end;

    return p2:_Compile(u4, (pairAndLerp(u9, v17)));
end;

function u1.Clone(p32) -- Line: 124
    -- upvalues: u1 (copy)
    return p32:_CopyConfiguration((u1.new()));
end;

function u1.new(...) -- Line: 129
    -- upvalues: Solver (copy), u1 (copy)
    local v33 = Solver.new(...);
    setmetatable(v33, u1);

    return v33;
end;

setmetatable(u1, Solver);

return u1;