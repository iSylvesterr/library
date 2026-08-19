-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = Vector3.new();

function v1.Solve(p3, p4) -- Line: 11
    -- upvalues: u2 (copy)
    local v5 = p4.Instances[1];
    local v6 = v5.Position + v5.CFrame:VectorToWorldSpace(p4.Instances[2]);

    if not p4.LastPosition then
        p4.LastPosition = v6;
    end;

    local LastPosition = p4.LastPosition;
    local v7 = v6 - (p4.LastPosition or u2);
    p4.WorldSpace = v6;

    return LastPosition, v7;
end;

function v1.UpdateToNextPosition(p8, p9) -- Line: 30
    return p9.WorldSpace;
end;

function v1.Visualize(p10, p11) -- Line: 34
    return CFrame.lookAt(p11.WorldSpace, p11.LastPosition);
end;

return v1;