-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local Parent = require(script.Parent);
    local Vector = require(script.Parent.Parent:WaitForChild("Algebra"):WaitForChild("Vector"));
    local Matrix = require(script.Parent.Parent:WaitForChild("Algebra"):WaitForChild("Matrix"));
    local v2 = Parent.Cellular.new();
    v2:SetFrequency(1);
    v2:SetAmplitude(1);
    v2:GeneratePoints(30, Vector.new(0, 0), Vector.new(1, 1));
    local v3 = v2:ToMatrix(100);
    local v4 = {};

    for i = 1, 100 do
        v4[i] = {};

        for i2 = 1, 100 do
            v4[i][i2] = 0;
        end;
    end;

    for _, v in ipairs(v2.Points) do
        local v5 = (v * 100):Round();
        v4[v5[1]][v5[2]] = 1;
    end;

    local v6 = {};

    for i = 1, 100 do
        v6[i] = Vector.new(unpack(v4[i]));
    end;

    v2:Debug(p1, 4, Matrix.new(unpack(v6)), v3);

    return function() -- Line: 37
    end;
end;