-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");

return function() -- Line: 5
    -- upvalues: Players (copy)
    local v1 = {};

    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            table.insert(v1, v.Character);
        end;
    end;

    return v1;
end;