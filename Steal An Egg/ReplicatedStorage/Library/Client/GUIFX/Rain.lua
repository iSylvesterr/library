-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Functions = require(Library.Functions);
local Audio = require(Library.Audio);

return {
    Play = function(u1) -- Line: 45, Name: Play
        -- upvalues: Functions (copy), Audio (copy)
        local u2 = u1.Duration or 3;
        local u3 = u1.VolumeScale or 1;
        local v4 = u1.RateScale or 1;
        local v5 = u1.SpeedScale or 1;
        local v6 = u1.SizeScale or 1;
        local v7 = u1.PopUp == true;
        local u8 = u1.ManualEmitMode == true;
        local u9 = u1.ManualEmitAmount or 1;
        local v10 = u1.Drag or 2.65;
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Transparency = 1;
        local v11, v12 = Functions.ComputeScreenSpacePart(10, 2);
        Part.CFrame = v11;
        Part.Size = v12;
        local v13 = Functions.Scaler();
        local u14 = {};
        local v15 = 0;

        for _, v in ipairs(u1.Particles) do
            local v16 = script:WaitForChild("ParticleEmitter"):Clone();
            v16.Texture = v.Texture;

            if v.LightEmission then
                v16.LightEmission = v.LightEmission;
            end;

            if v.LightInfluence then
                v16.LightInfluence = v.LightInfluence;
            end;

            if v.SizeScalar then
                v16.Size = Functions.ScaleNumberSequence(v16.Size, v.SizeScalar);
            end;

            table.insert(u14, v16);
            v15 = math.max(v15, v16.Lifetime.Max / v16.TimeScale);
            v16.ZOffset = v16.ZOffset + (math.random() * 2 - 1) * 0.1;
            v16.Rate = Functions.FixParticleRate(v16.Rate * v4 / #u1.Particles, Part.Position);
            local Speed = v16.Speed;
            v16.Speed = u1.SpeedOverride or NumberRange.new(Speed.Min * v5, Speed.Max * v5);

            if v6 ~= 1 then
                v13(v16, v6);
            end;

            if u1.DragOverride then
                v16.Drag = u1.DragOverride;
            end;

            v16.Enabled = false;
            v16.Parent = Part;
        end;

        Part.Parent = workspace.CurrentCamera;
        local u17 = 0;
        local u18 = false;

        if u8 then
            for _, v in ipairs(u14) do
                local u19 = v:Clone();
                u19.EmissionDirection = Enum.NormalId.Bottom;
                u19.Speed = NumberRange.new(-30, -20);
                u19.Drag = v10;
                u19.Parent = Part;
                task.delay(math.random() * 0.35, function() -- Line: 146
                    -- upvalues: u19 (copy), u9 (copy)
                    u19:Emit(u9);
                end);
            end;

            if u3 > 0 then
                local SprinkleSounds = u1.SprinkleSounds;

                if SprinkleSounds then
                    Audio.Play(SprinkleSounds.Assets, workspace.CurrentCamera, SprinkleSounds.Pitch, SprinkleSounds.Volume);
                end;
            end;
        elseif v7 then
            u17 = 0.75;

            for _, v in ipairs(u14) do
                local v20 = (v:GetAttribute("EmitCount") or 0) * v4;
                local v21 = math.round(v20);

                if v21 > 0 then
                    local v22 = v:Clone();
                    v22.EmissionDirection = Enum.NormalId.Bottom;
                    v22.Speed = NumberRange.new(-30, -20);
                    v22.Drag = v10;
                    v22.Parent = Part;
                    v22:Emit(v21);
                end;
            end;

            if u3 > 0 then
                local PopSounds = u1.PopSounds;

                if PopSounds then
                    Audio.Play(PopSounds.Assets, workspace.CurrentCamera, PopSounds.Pitch, PopSounds.Volume);
                end;
            end;
        else
            u18 = true;

            for _, v in ipairs(u14) do
                v.Enabled = true;
            end;

            if u3 > 0 then
                local SprinkleSounds = u1.SprinkleSounds;

                if SprinkleSounds then
                    Audio.Play(SprinkleSounds.Assets, workspace.CurrentCamera, SprinkleSounds.Pitch, SprinkleSounds.Volume);
                end;
            end;
        end;

        Functions.RenderStepped(function(p23, p24) -- Line: 162
            -- upvalues: Functions (ref), Part (copy), u8 (copy), u17 (ref), u2 (copy), u18 (ref), u3 (copy), u1 (copy), Audio (ref), u14 (copy)
            local v25, v26 = Functions.ComputeScreenSpacePart(10, 2);
            Part.CFrame = v25;
            Part.Size = v26;

            if not u8 then
                local v27 = u17 <= p24 and p24 < u17 + u2;

                if u18 ~= v27 then
                    u18 = v27;
                    local v28 = u3 > 0 and v27 and u1.SprinkleSounds;

                    if v28 then
                        Audio.Play(v28.Assets, workspace.CurrentCamera, v28.Pitch, v28.Volume);
                    end;

                    for _, v in ipairs(u14) do
                        v.Enabled = v27;
                    end;
                end;
            end;
        end, u17 + u2 + v15):Then(function() -- Line: 189
            -- upvalues: Part (copy)
            Part:Destroy();
        end);
    end
};