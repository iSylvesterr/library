-- Decompiled with Potassium's decompiler.

local BBFromArray = require(script.Parent.BBFromArray);

return function(p1) -- Line: 7
    -- upvalues: BBFromArray (copy)
    local v2;

    if typeof(p1) == "Instance" then
        v2 = p1:IsA("Model") or p1:IsA("Tool");
    else
        v2 = false;
    end;

    assert(v2, "Expected argument #1 to be a Model or Tool");
    local v3 = {};

    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            table.insert(v3, descendant);
        end;
    end;

    if #v3 == 0 then
        return p1:GetPivot(), Vector3.new(0, 0, 0);
    end;

    return BBFromArray(v3);
end;