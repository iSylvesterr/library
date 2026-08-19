-- Decompiled with Potassium's decompiler.

local EmitOnce = require(game.ReplicatedStorage.UserGenerated.VFX.EmitOnce);

local function Emit(p1) -- Line: 22
    -- upvalues: EmitOnce (copy), Emit (copy)
    local v2 = 0;

    if p1:IsA("ParticleEmitter") then
        v2 = math.max(v2, EmitOnce(p1));
    end;

    for _, child in ipairs(p1:GetChildren()) do
        v2 = math.max(v2, Emit(child));
    end;

    return v2;
end;

return Emit;