-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9
    require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local TweenService = game:GetService("TweenService");
    local RunService = game:GetService("RunService");

    function p1.Tween_Attachment_CFrame(p2, p3, p4, p5, p6, p7) -- Line: 21
        -- upvalues: TweenService (copy)
        if not (p2 and p3) then
            return;
        end;

        p2.CFrame = CFrame.new(0, 0, 0);
        p3.CFrame = CFrame.new(0, 0, 0);
        local v8 = p6 or Enum.EasingStyle.Linear;
        local v9 = p7 or Enum.EasingDirection.In;
        local u10 = TweenService:Create(p2, TweenInfo.new(p4, v8, v9), {
            CFrame = CFrame.new(p5)
        });
        u10.Completed:Once(function() -- Line: 32
            -- upvalues: u10 (copy)
            if u10 then
                u10:Destroy();
            end;
        end);
        u10:Play();
        local u11 = TweenService:Create(p3, TweenInfo.new(p4, v8, v9), {
            CFrame = CFrame.new(-p5)
        });
        u11.Completed:Once(function() -- Line: 39
            -- upvalues: u11 (copy)
            if u11 then
                u11:Destroy();
            end;
        end);
        u11:Play();
    end;

    function p1.Tween_Instance(p12, p13, p14) -- Line: 53
        -- upvalues: TweenService (copy)
        if not p12 then
            return;
        end;

        local u15 = TweenService:Create(p12, p13, p14);
        u15.Completed:Once(function() -- Line: 59
            -- upvalues: u15 (copy)
            if u15 then
                u15:Destroy();
            end;
        end);
        u15:Play();
    end;

    function p1.Model_Scale_Tween(u16, u17, u18, u19, u20, u21, u22, u23) -- Line: 79
        -- upvalues: RunService (copy), TweenService (copy)
        task.spawn(function() -- Line: 80
            -- upvalues: u20 (ref), u21 (ref), u16 (copy), u17 (copy), RunService (ref), u19 (copy), TweenService (ref), u18 (copy), u23 (copy), u22 (copy)
            u20 = u20 or Enum.EasingStyle.Linear;
            u21 = u21 or Enum.EasingDirection.In;

            if not u16:GetAttribute("ModelScale") then
                u16:SetAttribute("ModelScale", u16:GetScale());
            end;

            u16:ScaleTo(u17);
            local v24 = u16:GetPivot();
            local v25 = 0;

            while v25 < 1 do
                local v26 = v25 + RunService.Heartbeat:Wait() / u19;
                v25 = math.min(v26, 1);
                local v27 = TweenService:GetValue(v25, u20, u21);
                u16:ScaleTo(u17 + (u18 - u17) * v27);

                if not u23 then
                    u16:PivotTo(v24);
                end;
            end;

            if u22 then
                u22();
            end;
        end);
    end;

    function p1.Part_Scale_Tween(u28, u29, u30, u31, u32, u33, u34) -- Line: 126
        -- upvalues: RunService (copy), TweenService (copy)
        task.spawn(function() -- Line: 127
            -- upvalues: u32 (ref), u33 (ref), u28 (copy), u29 (copy), RunService (ref), u31 (copy), TweenService (ref), u30 (copy), u34 (copy)
            u32 = u32 or Enum.EasingStyle.Linear;
            u33 = u33 or Enum.EasingDirection.In;
            local Size = u28.Size;
            u28:SetAttribute("OriSize", Size);
            u28.Size = u29 * Size;
            u28:GetPivot();
            local v35 = 0;

            while v35 < 1 do
                local v36 = v35 + RunService.Heartbeat:Wait() / u31;
                v35 = math.min(v36, 1);
                local v37 = TweenService:GetValue(v35, u32, u33);
                u28.Size = (u29 + (u30 - u29) * v37) * Size;
            end;

            if u34 then
                u34();
            end;
        end);
    end;

    function p1.Beam_Fade_To_Transparent_Then_Disable(u38, u39, u40, u41) -- Line: 165
        -- upvalues: RunService (copy), TweenService (copy)
        task.spawn(function() -- Line: 166
            -- upvalues: u40 (ref), u41 (ref), u38 (copy), RunService (ref), u39 (copy), TweenService (ref)
            u40 = u40 or Enum.EasingStyle.Linear;
            u41 = u41 or Enum.EasingDirection.In;
            local Keypoints = u38.Transparency.Keypoints;
            local Transparency = u38.Transparency;
            local v42 = 0;

            while v42 < 1 do
                local v43 = v42 + RunService.Heartbeat:Wait() / u39;
                v42 = math.min(v43, 1);
                local v44 = TweenService:GetValue(v42, u40, u41);
                local v45 = {};

                for _, v in ipairs(Keypoints) do
                    local Value = v.Value;
                    table.insert(v45, NumberSequenceKeypoint.new(v.Time, Value + (1 - Value) * v44, v.Envelope or 0));
                end;

                if #v45 > 0 and u38.Parent then
                    u38.Transparency = NumberSequence.new(v45);
                end;
            end;

            if u38.Parent then
                u38.Enabled = false;
                u38.Transparency = Transparency;
            end;
        end);
    end;

    function p1.Beam_Fade_From_Transparent(u46, u47, u48, u49) -- Line: 207
        -- upvalues: RunService (copy), TweenService (copy)
        task.spawn(function() -- Line: 208
            -- upvalues: u48 (ref), u49 (ref), u46 (copy), RunService (ref), u47 (copy), TweenService (ref)
            u48 = u48 or Enum.EasingStyle.Linear;
            u49 = u49 or Enum.EasingDirection.In;
            local Keypoints = u46.Transparency.Keypoints;
            local v50 = {};
            local v51 = 0;

            for _, v in ipairs(Keypoints) do
                table.insert(v50, NumberSequenceKeypoint.new(v.Time, 1, v.Envelope or 0));
            end;

            if #v50 > 0 and u46.Parent then
                u46.Transparency = NumberSequence.new(v50);
            end;

            while v51 < 1 do
                local v52 = v51 + RunService.Heartbeat:Wait() / u47;
                v51 = math.min(v52, 1);
                local v53 = TweenService:GetValue(v51, u48, u49);
                local v54 = {};

                for _, v in ipairs(Keypoints) do
                    table.insert(v54, NumberSequenceKeypoint.new(v.Time, 1 + (v.Value - 1) * v53, v.Envelope or 0));
                end;

                if #v54 > 0 and u46.Parent then
                    u46.Transparency = NumberSequence.new(v54);
                end;
            end;
        end);
    end;

    function p1.Model_Parabola_Scale_Tween(u55, u56, u57, u58, u59, u60, u61, u62) -- Line: 264
        -- upvalues: RunService (copy), TweenService (copy)
        if not u55 then
            return;
        end;

        task.spawn(function() -- Line: 278
            -- upvalues: u60 (ref), u61 (ref), u55 (copy), u57 (copy), u58 (copy), RunService (ref), u56 (copy), TweenService (ref), u59 (copy), u62 (copy)
            u60 = u60 or Enum.EasingStyle.Linear;
            u61 = u61 or Enum.EasingDirection.In;
            local v63 = u55:GetPivot();
            local Position = v63.Position;
            local Position2 = u57.Position;
            local _ = Position2 - Position;
            local v64 = u58;
            local v65 = u55:GetScale();
            local v66 = 0;

            while v66 < 1 do
                local v67 = v66 + RunService.Heartbeat:Wait() / u56;
                v66 = math.min(v67, 1);
                local v68 = TweenService:GetValue(v66, u60, u61);
                local v69 = Position:Lerp(Position2, v68) + v64 * (4 * v68 * (1 - v68));
                local v70 = v63:Lerp(u57, v68);
                local v71 = v70 + (v69 - v70.Position);

                if u59 then
                    u55:ScaleTo(v65 + (u59 - v65) * v68);
                end;

                u55:PivotTo(v71);
            end;

            if u62 then
                u62();
            end;
        end);
    end;
end;