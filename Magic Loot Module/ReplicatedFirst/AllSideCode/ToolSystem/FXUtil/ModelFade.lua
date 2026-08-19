-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local TweenService = game:GetService("TweenService");
    local RunService = game:GetService("RunService");
    local _ = UtilsSystem.VisibleMgr;

    function p1.Model_Fade(p2, p3) -- Line: 26
        -- upvalues: TweenService (copy)
        local v4 = p2:GetDescendants();
        table.insert(v4, p2);
        local v5 = p3 or 0.1;

        for _, v in pairs(v4) do
            if v:IsA("BasePart") then
                TweenService:Create(v, TweenInfo.new(v5), {
                    Transparency = 1
                }):Play();
            end;
        end;
    end;

    function p1.Model_Fade_In(p6, p7, p8, p9, p10) -- Line: 49
        -- upvalues: TweenService (copy)
        local v11 = p8 or Enum.EasingStyle.Linear;
        local v12 = p9 or Enum.EasingDirection.In;
        local v13 = p6:GetDescendants();
        table.insert(v13, p6);
        local v14 = p7 or 0.1;

        for _, v in pairs(v13) do
            if v:IsA("BasePart") then
                TweenService:Create(v, TweenInfo.new(v14, v11, v12), {
                    Transparency = p10 or 0
                }):Play();
            end;
        end;
    end;

    function p1.Beam_Object_Fade(u15, u16, u17, u18, u19) -- Line: 75
        -- upvalues: RunService (copy), TweenService (copy)
        task.spawn(function() -- Line: 76
            -- upvalues: u16 (ref), u15 (copy), RunService (ref), TweenService (ref), u18 (copy), u19 (copy), u17 (copy)
            u16 = u16 or 0.1;
            local Keypoints = u15.Transparency.Keypoints;
            local v20 = 0;

            while v20 < 1 do
                local v21 = v20 + RunService.Heartbeat:Wait() / u16;
                v20 = math.min(v21, 1);
                local _ = TweenService:GetValue(v20, u18, u19);
                local v22 = {};

                for i, v in pairs(u17.Keypoints) do
                    if Keypoints[i] then
                        local Value = Keypoints[i].Value;
                        local v23 = NumberSequenceKeypoint.new(v.Time, Value + (v.Value - Value) * v20, v.Envelope);
                        table.insert(v22, v23);
                    end;
                end;

                if #v22 > 0 then
                    u15.Transparency = NumberSequence.new(v22);
                end;
            end;
        end);
    end;
end;