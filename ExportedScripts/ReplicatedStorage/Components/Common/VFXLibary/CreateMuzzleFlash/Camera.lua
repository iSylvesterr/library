-- Decompiled with Potassium's decompiler.

local u1 = {};

local function getEmitterConfigs(u2) -- Line: 13
    -- upvalues: u1 (copy)
    local v3 = u1[u2];

    if v3 then
        return v3;
    end;

    local v4 = {};

    for _, descendant in ipairs(u2:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local v5 = {
                Emitter = descendant,
                Delay = descendant:GetAttribute("EmitDelay") or 0,
                Count = descendant:GetAttribute("EmitCount") or 1
            };
            table.insert(v4, v5);
        end;
    end;

    u1[u2] = v4;
    u2.Destroying:Once(function() -- Line: 31
        -- upvalues: u1 (ref), u2 (copy)
        u1[u2] = nil;
    end);

    return v4;
end;

local function emitParticle(u6) -- Line: 38
    local Emitter = u6.Emitter;

    if u6.Delay > 0 then
        task.delay(u6.Delay, function() -- Line: 41
            -- upvalues: Emitter (copy), u6 (copy)
            if Emitter.Parent then
                Emitter:Emit(u6.Count);
            end;
        end);

        return;
    end;

    if Emitter.Parent then
        Emitter:Emit(u6.Count);
    end;
end;

return function(p7, p8) -- Line: 57
    -- upvalues: getEmitterConfigs (copy)
    debug.profilebegin("VFX.MuzzleFlash.Camera");
    local v9 = p7:FindFirstChild(p8);

    if not v9 then
        debug.profileend();

        return nil;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Camera.EmitParticles");

    for _, v in ipairs((getEmitterConfigs(v9))) do
        local Emitter = v.Emitter;

        if v.Delay > 0 then
            task.delay(v.Delay, function() -- Line: 41
                -- upvalues: Emitter (copy), v (copy)
                if Emitter.Parent then
                    Emitter:Emit(v.Count);
                end;
            end);
        elseif Emitter.Parent then
            Emitter:Emit(v.Count);
        end;
    end;

    debug.profileend();
    debug.profileend();

    return p7.Position;
end;