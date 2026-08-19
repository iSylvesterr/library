-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent:WaitForChild("Algebra"):WaitForChild("Vector"));
require(script.Parent.Parent:WaitForChild("Algebra"):WaitForChild("Matrix"));
local Solver = require(script.Parent:WaitForChild("Solver"));
local u1 = {};
u1.__index = u1;

function u1.Get(p2, p3) -- Line: 14
    assert(#p2.Points > 0, "No points");
    local v4 = p2.translateVector(p3);
    local v5 = nil;
    local v6 = (1 / 0);
    local v7 = nil;
    local v8 = 0;

    for _, v in ipairs(p2.Points) do
        local Magnitude = (v - v4).Magnitude;

        if not v5 or Magnitude < v6 then
            v6 = Magnitude;
            v5 = v;
        end;

        if not v7 or v8 < Magnitude then
            v8 = Magnitude;
            v7 = v;
        end;
    end;

    return p2:_Compile(v4, v6 / p2.SeparationLimit);
end;

function u1.Clone(p9) -- Line: 42
    -- upvalues: u1 (copy)
    return p9:_CopyConfiguration((u1.new()));
end;

function u1.new(...) -- Line: 47
    -- upvalues: Solver (copy), u1 (copy)
    local v10 = Solver.new(...);
    v10.Points = {};
    setmetatable(v10, u1);

    return v10;
end;

setmetatable(u1, Solver);

return u1;