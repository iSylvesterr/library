-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);
local Vector = require(script:WaitForChild("Vector"));
local Matrix = require(script:WaitForChild("Matrix"));
local v1 = {};
v1.__index = v1;
v1.Vector = Vector;
v1.Matrix = Matrix;
local Lerp = require(script.Lerp);

function v1.lerp(p2, p3, p4) -- Line: 39
    -- upvalues: Lerp (copy)
    return Lerp(p2, p3, p4);
end;

local Ease = require(script.Ease);

function v1.ease(p5, p6, p7) -- Line: 52
    -- upvalues: Ease (copy)
    return Ease(p5, p6, p7);
end;

function v1.bezier(...) -- Line: 63
    -- upvalues: Lerp (copy), Vector (copy)
    local u8 = { ... };
    assert(#u8 > 1, "not enough points");

    local function solve(p9, p10) -- Line: 66
        -- upvalues: Lerp (ref), Vector (ref), solve (copy)
        local function typeLerp(p11, p12, p13) -- Line: 68
            -- upvalues: Lerp (ref), Vector (ref)
            if typeof(p11) == "Vector2" then
                return Lerp(p11, p12, p13);
            end;

            if typeof(p11) == "Vector3" then
                return Lerp(p11, p12, p13);
            end;

            if typeof(p11) == "table" and getmetatable(p11) == Vector then
                return Lerp(p11, p12, p13);
            end;

            return nil;
        end;

        local v14 = {};

        for i = 1, #p10 - 1 do
            local v15 = typeLerp(p10[i], p10[i + 1], p9);

            if v15 ~= nil then
                table.insert(v14, v15);
            end;
        end;

        if #v14 <= 1 then
            return v14[1];
        end;

        return solve(p9, v14);
    end;

    return function(p16) -- Line: 94
        -- upvalues: u8 (copy), solve (copy)
        assert(u8 ~= nil);
        local v17 = solve(p16, u8);
        assert(v17 ~= nil);

        return v17;
    end;
end;

return v1;