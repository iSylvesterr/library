-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    function u1.Emit_Particles_GetDescendants_NoDelay(p2, p3) -- Line: 17
        -- upvalues: u1 (copy)
        for _, v in u1.GetVfxCache(p2).emitters do
            if v.Parent then
                if p3 then
                    v.Enabled = false;
                end;

                v:Emit(v:GetAttribute("EmitCount") or 1);
            end;
        end;
    end;

    function u1.Emit_Particles_Children(u4, p5) -- Line: 36
        if u4:IsA("ParticleEmitter") then
            if p5 then
                u4.Enabled = false;
            end;

            task.spawn(function() -- Line: 42
                -- upvalues: u4 (copy)
                local v6 = u4:GetAttribute("EmitDelay");
                local v7 = u4:GetAttribute("EmitCount") or 1;

                if v6 then
                    task.wait(v6);
                end;

                u4:Emit(v7);
            end);
        end;

        for _, child in pairs(u4:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                if p5 then
                    child.Enabled = false;
                end;

                task.spawn(function() -- Line: 58
                    -- upvalues: child (copy)
                    local v8 = child:GetAttribute("EmitDelay");
                    local v9 = child:GetAttribute("EmitCount") or 1;

                    if v8 then
                        task.wait(v8);
                    end;

                    child:Emit(v9);
                end);
            end;
        end;
    end;

    function u1.Emit_Particles_GetDescendants(p10, p11) -- Line: 76
        -- upvalues: u1 (copy)
        local v12 = u1.GetVfxCache(p10);

        for _, v in v12.emitters do
            if v.Parent then
                if p11 then
                    v.Enabled = false;
                end;

                task.spawn(function() -- Line: 86
                    -- upvalues: v (copy)
                    local v13 = v:GetAttribute("EmitDelay");
                    local v14 = v:GetAttribute("EmitCount") or 1;

                    if v13 then
                        task.wait(v13);
                    end;

                    if v.Parent then
                        v:Emit(v14);
                    end;
                end);
            end;
        end;

        for _, v in v12.beams do
            if v.Parent then
                local v15 = v:GetAttribute("EffectDuration");
                local v16 = v:GetAttribute("EmitDelay");
                local v17 = v:GetAttribute("Transparency_Scale_Start");
                local v18 = v:GetAttribute("Transparency_Scale_End");

                if v15 and (v16 and (v17 and v18)) then
                    v.Transparency = NumberSequence.new(v17, v18);
                    v.Enabled = true;
                    task.delay(v15.Min, function() -- Line: 109
                        -- upvalues: v (copy)
                        if v.Parent then
                            v.Enabled = false;
                        end;
                    end);
                end;
            end;
        end;
    end;
end;