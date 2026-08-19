-- Decompiled with Potassium's decompiler.

local EmitOnce = require(game.ReplicatedStorage.UserGenerated.VFX.EmitOnce);

local function EmitParticle(u1) -- Line: 13
    -- upvalues: EmitOnce (copy)
    local v2 = EmitOnce(u1);
    local v3 = u1:GetAttribute("EmitDelay");
    local v4 = type(v3) ~= "number" and 0 or v3;
    local v5 = math.max(v4, 0);
    local v6 = u1:GetAttribute("EmitDuration");
    local u7 = type(v6) ~= "number" and 0 or v6;

    if u7 > 0 then
        u1.Enabled = false;
        task.delay(v5, function() -- Line: 33
            -- upvalues: u1 (copy), u7 (ref)
            if not u1.Parent then
                return;
            end;

            u1.Enabled = true;
            task.delay(u7, function() -- Line: 36
                -- upvalues: u1 (ref)
                if not u1.Parent then
                    return;
                end;

                u1.Enabled = false;
            end);
        end);
    end;

    return math.max(v2, v5 + u7);
end;

local function EmitDuration(p8) -- Line: 46
    -- upvalues: EmitParticle (copy), EmitDuration (copy)
    local v9 = 0;

    if p8:IsA("ParticleEmitter") then
        local v10 = EmitParticle(p8);
        v9 = math.max(v9, v10);
    end;

    for _, child in p8:GetChildren() do
        v9 = math.max(v9, EmitDuration(child));
    end;

    return v9;
end;

return EmitDuration;