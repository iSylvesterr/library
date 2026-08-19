-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = Vector3.new();

function v1.Solve(p3, p4) -- Line: 11
    -- upvalues: u2 (copy)
    local v5 = p4.Instances[1].TransformedWorldCFrame.Position + p4.Instances[2];

    if not p4.LastPosition then
        p4.LastPosition = v5;
    end;

    local LastPosition = p4.LastPosition;
    local v6 = v5 - (p4.LastPosition or u2);
    p4.WorldSpace = v5;

    return LastPosition, v6;
end;

function v1.UpdateToNextPosition(p7, p8) -- Line: 30
    return p8.WorldSpace;
end;

function v1.Visualize(p9, p10) -- Line: 34
    return CFrame.lookAt(p10.WorldSpace, p10.LastPosition);
end;

return v1;