-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local TweenService = game:GetService("TweenService");
    local RunService = game:GetService("RunService");

    function u1.CloneNumberSequence(p2) -- Line: 23
        local v3 = {};

        for _, v in p2.Keypoints do
            table.insert(v3, NumberSequenceKeypoint.new(v.Time, v.Value, v.Envelope or 0));
        end;

        return NumberSequence.new(v3);
    end;

    function u1.SampleNumberSequence(p4, p5) -- Line: 37
        local Keypoints = p4.Keypoints;
        local v6 = #Keypoints;

        if v6 == 0 then
            return 1;
        end;

        if p5 <= Keypoints[1].Time then
            return Keypoints[1].Value;
        end;

        if Keypoints[v6].Time <= p5 then
            return Keypoints[v6].Value;
        end;

        for i = 1, v6 - 1 do
            local v7 = Keypoints[i];
            local v8 = Keypoints[i + 1];

            if v7.Time <= p5 and p5 <= v8.Time then
                local v9 = v8.Time - v7.Time;

                if v9 <= 1e-8 then
                    return v8.Value;
                end;

                return v7.Value + (v8.Value - v7.Value) * ((p5 - v7.Time) / v9);
            end;
        end;

        return Keypoints[v6].Value;
    end;

    function u1.BuildBeamTransparencyCut(p10, p11) -- Line: 70
        -- upvalues: u1 (copy)
        local v12 = math.clamp(p11, 0, 1);

        if v12 >= 0.999 then
            return u1.CloneNumberSequence(p10);
        end;

        local Keypoints = p10.Keypoints;
        local v13 = {};

        for _, v in ipairs(Keypoints) do
            if v.Time < v12 - 0.00001 then
                table.insert(v13, NumberSequenceKeypoint.new(v.Time, v.Value, v.Envelope or 0));
            end;
        end;

        local v14 = u1.SampleNumberSequence(p10, v12);
        table.insert(v13, NumberSequenceKeypoint.new(v12, v14, 0));
        local v15 = math.min(v12 + 0.003, 1);

        if v12 + 1e-6 < v15 then
            table.insert(v13, NumberSequenceKeypoint.new(v15, 1, 0));
        end;

        for _, v in ipairs(Keypoints) do
            if v.Time > v15 + 0.00001 then
                table.insert(v13, NumberSequenceKeypoint.new(v.Time, 1, v.Envelope or 0));
            end;
        end;

        if #v13 == 0 or v13[#v13].Time < 0.99999 then
            table.insert(v13, NumberSequenceKeypoint.new(1, 1, 0));
        end;

        table.sort(v13, function(p16, p17) -- Line: 96
            return p16.Time < p17.Time;
        end);

        if #v13 < 2 then
            table.insert(v13, NumberSequenceKeypoint.new(1, 1, 0));
        end;

        return NumberSequence.new(v13);
    end;

    function u1.Beam_Reveal_From_Left(p18, u19, p20, p21) -- Line: 113
        -- upvalues: u1 (copy), RunService (copy), TweenService (copy)
        if #p18 == 0 then
            return nil;
        end;

        local u22 = p20 or Enum.EasingStyle.Quad;
        local u23 = p21 or Enum.EasingDirection.Out;
        local u24 = {};

        for _, v in p18 do
            local v25 = u1.CloneNumberSequence(v.Transparency);
            table.insert(u24, {
                beam = v,
                ori = v25
            });
            v.Enabled = true;
            v.Transparency = u1.BuildBeamTransparencyCut(v25, 0);
        end;

        local u26 = os.clock();
        local u27 = nil;
        u27 = RunService.Heartbeat:Connect(function() -- Line: 135
            -- upvalues: u24 (copy), u27 (ref), u26 (copy), u19 (copy), TweenService (ref), u22 (copy), u23 (copy), u1 (ref)
            local v28 = true;

            for _, v in u24 do
                if v.beam.Parent then
                    v28 = false;
                    break;
                end;
            end;

            if v28 then
                u27:Disconnect();

                return;
            end;

            local v29 = (os.clock() - u26) / u19;

            if v29 >= 1 then
                for _, v in u24 do
                    if v.beam.Parent then
                        v.beam.Transparency = v.ori;
                    end;
                end;

                u27:Disconnect();

                return;
            end;

            local v30 = TweenService:GetValue(v29, u22, u23);

            for _, v in u24 do
                if v.beam.Parent then
                    v.beam.Transparency = u1.BuildBeamTransparencyCut(v.ori, v30);
                end;
            end;
        end);

        return u27;
    end;
end;