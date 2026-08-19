-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    require(game.ReplicatedFirst.AllSideCode.UtilsSystem);

    function u1.FadeModel_KeepTrails(u2, p3, p4) -- Line: 23
        -- upvalues: u1 (copy)
        local v5 = p3 or 0.12;
        local v6 = p4 or 0.5;

        for _, descendant in u2:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = 1;
            elseif descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            elseif descendant:IsA("Beam") then
                u1.Beam_Fade_To_Transparent_Then_Disable(descendant, v5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant.Transparency = 1;
            end;
        end;

        if v6 > 0 then
            task.delay(v6, function() -- Line: 40
                -- upvalues: u2 (copy)
                if u2.Parent then
                    u2:Destroy();
                end;
            end);
        end;
    end;
end;