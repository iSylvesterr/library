-- Decompiled with Potassium's decompiler.

local EmitOne = require(game.ReplicatedStorage.Library.Functions.EmitOne);

function EmitDescendants(p1, p2)
    -- upvalues: EmitOne (copy)
    local v3 = 0;

    if p1:IsA("ParticleEmitter") then
        v3 = math.max(v3, EmitOne(p1, p2));
    end;

    for _, child in ipairs(p1:GetChildren()) do
        v3 = math.max(v3, EmitDescendants(child, p2));
    end;

    return v3;
end;

return EmitDescendants;