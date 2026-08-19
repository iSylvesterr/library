-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local TweenService = game:GetService("TweenService");
    local Debris = game:GetService("Debris");

    function u1.Slow_Destroy_Instance(p2, p3) -- Line: 24
        -- upvalues: u1 (copy), TweenService (copy), Debris (copy)
        u1.Stop_All_Emit(p2);
        local v4 = p2:GetDescendants();
        table.insert(v4, p2);
        local v5 = p3 or 0.25;

        if not p3 then
            for _, v in pairs(v4) do
                if v:IsA("ParticleEmitter") then
                    v.Enabled = false;
                    v5 = math.max(v5, v.Lifetime.Max);
                elseif v:IsA("Trail") then
                    v.Enabled = false;
                    v5 = math.max(v5, v.Lifetime);
                end;
            end;
        end;

        for _, v in pairs(v4) do
            if v:IsA("Light") then
                TweenService:Create(v, TweenInfo.new(v5), {
                    Brightness = 0
                }):Play();
            elseif v:IsA("Sound") then
                TweenService:Create(v, TweenInfo.new(v5), {
                    Volume = 0
                }):Play();
            elseif v:IsA("Beam") then
                TweenService:Create(v, TweenInfo.new(v5), {
                    Width0 = 0,
                    Width1 = 0
                }):Play();
            elseif v:IsA("ImageLabel") then
                TweenService:Create(v, TweenInfo.new(v5), {
                    ImageTransparency = 1
                }):Play();
            elseif v:IsA("Decal") then
                TweenService:Create(v, TweenInfo.new(v5), {
                    Transparency = 1
                }):Play();
            elseif v:IsA("ParticleEmitter") then
                v.Enabled = false;
            elseif v:IsA("Trail") then
                v.Enabled = false;
                local v6 = {};

                for _, v2 in pairs(v.Transparency.Keypoints) do
                    table.insert(v6, NumberSequenceKeypoint.new(v2.Time, 1, 0));
                end;

                local v7 = NumberSequence.new(v6);
                u1.Beam_Object_Fade(v, v5, v7, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
            end;
        end;

        if p2:IsA("BasePart") then
            TweenService:Create(p2, TweenInfo.new(v5), {
                Transparency = 1
            }):Play();
        end;

        Debris:AddItem(p2, v5 + 0.5);
    end;

    function u1.Slow_Disapear_Instance(p8, p9) -- Line: 100
        -- upvalues: u1 (copy), TweenService (copy)
        u1.Stop_All_Emit(p8);
        local v10 = p8:GetDescendants();
        table.insert(v10, p8);
        local v11 = p9 or 0.25;

        if not p9 then
            for _, v in pairs(v10) do
                if v:IsA("ParticleEmitter") then
                    v.Enabled = false;
                    v11 = math.max(v11, v.Lifetime.Max);
                elseif v:IsA("Trail") then
                    v.Enabled = false;
                    v11 = math.max(v11, v.Lifetime);
                end;
            end;
        end;

        for _, v in pairs(v10) do
            if v:IsA("Light") then
                TweenService:Create(v, TweenInfo.new(v11), {
                    Brightness = 0
                }):Play();
            elseif v:IsA("Sound") then
                TweenService:Create(v, TweenInfo.new(v11), {
                    Volume = 0
                }):Play();
            elseif v:IsA("Beam") then
                TweenService:Create(v, TweenInfo.new(v11), {
                    Width0 = 0,
                    Width1 = 0
                }):Play();
            elseif v:IsA("ImageLabel") then
                TweenService:Create(v, TweenInfo.new(v11), {
                    ImageTransparency = 1
                }):Play();
            elseif v:IsA("Decal") then
                TweenService:Create(v, TweenInfo.new(v11), {
                    Transparency = 1
                }):Play();
            elseif v:IsA("ParticleEmitter") then
                v.Enabled = false;
            elseif v:IsA("Trail") then
                local v12 = {};

                for _, v2 in pairs(v.Transparency.Keypoints) do
                    table.insert(v12, NumberSequenceKeypoint.new(v2.Time, 1, 0));
                end;

                local v13 = NumberSequence.new(v12);
                u1.Beam_Object_Fade(v, v11, v13, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
            end;
        end;

        if p8:IsA("BasePart") then
            TweenService:Create(p8, TweenInfo.new(v11), {
                Transparency = 1
            }):Play();
        end;
    end;
end;