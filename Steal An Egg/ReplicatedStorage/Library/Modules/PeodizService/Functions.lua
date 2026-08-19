-- Decompiled with Potassium's decompiler.

local v1 = {};
local TweenService = game:GetService("TweenService");

function v1.CustomForLoop(u2, p3) -- Line: 4
    -- upvalues: TweenService (copy)
    if u2.CurrentWaitTime >= u2.WaitTime then
        u2.CurrentWaitTime = u2.CurrentWaitTime - u2.WaitTime;

        if u2.Function then
            local v4 = math.floor(u2.CurrentTime * u2.End / u2.Step) * u2.Step;
            local u5 = tonumber(string.format("%.3f", v4));
            task.spawn(function() -- Line: 11
                -- upvalues: u2 (copy), TweenService (ref), u5 (copy)
                local CurrentTime = u2.CurrentTime;

                if u2.Tween then
                    CurrentTime = TweenService:GetValue(CurrentTime, u2.Tween.EasingStyle or Enum.EasingStyle.Linear, u2.Tween.EasingDirection or Enum.EasingDirection.Out);
                end;

                if u2.Function and (u2.Function(CurrentTime, u5) and not u2.Finished) then
                    u2:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.CustomForceForLoop(u6, p7) -- Line: 26
    -- upvalues: TweenService (copy)
    if u6.CurrentWaitTime >= u6.WaitTime then
        u6.CurrentWaitTime = u6.CurrentWaitTime - u6.WaitTime;
        local v8 = math.floor(u6.CurrentTime * u6.End / u6.Step) * u6.Step;
        local u9 = tonumber(string.format("%.3f", v8));

        if u6.Step < u9 then
            for i = u6.Start, u9, u6.Step do
                local u10 = tonumber(string.format("%.3f", i));

                if u10 ~= u9 and (u6.Step <= i and (u10 > 0 and not u6.StepData[u10])) then
                    u6.StepData[u10] = true;
                    local u11 = i / u6.End;

                    if u6.Function then
                        task.spawn(function() -- Line: 43
                            -- upvalues: u11 (copy), u6 (copy), TweenService (ref), u10 (copy)
                            local v12 = u11;

                            if u6.Tween then
                                v12 = TweenService:GetValue(v12, u6.Tween.EasingStyle or Enum.EasingStyle.Linear, u6.Tween.EasingDirection or Enum.EasingDirection.Out);
                            end;

                            if u6.Function and (u6.Function(v12, u10) and not u6.Finished) then
                                u6:Destroy();
                            end;
                        end);
                    end;
                end;
            end;
        end;

        if u6.StepData then
            if u6.StepData[u9] then
                return;
            end;

            u6.StepData[u9] = true;
        end;

        if u6.Function then
            task.spawn(function() -- Line: 72
                -- upvalues: u6 (copy), TweenService (ref), u9 (copy)
                local CurrentTime = u6.CurrentTime;

                if u6.Tween then
                    CurrentTime = TweenService:GetValue(CurrentTime, u6.Tween.EasingStyle or Enum.EasingStyle.Linear, u6.Tween.EasingDirection or Enum.EasingDirection.Out);
                end;

                if u6.Function and (u6.Function(CurrentTime, u9) and not u6.Finished) then
                    u6:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.ForLoop(u13) -- Line: 91
    -- upvalues: TweenService (copy)
    if u13.CurrentWaitTime >= u13.WaitTime then
        u13.CurrentWaitTime = u13.CurrentWaitTime - u13.WaitTime;

        if u13.Function then
            task.spawn(function() -- Line: 95
                -- upvalues: u13 (copy), TweenService (ref)
                local CurrentTime = u13.CurrentTime;

                if u13.Tween then
                    CurrentTime = TweenService:GetValue(CurrentTime, u13.Tween.EasingStyle or Enum.EasingStyle.Linear, u13.Tween.EasingDirection or Enum.EasingDirection.Out);
                end;

                if u13.Function and (u13.Function(CurrentTime) and not u13.Finished) then
                    u13:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.ForceForLoop(u14, p15) -- Line: 110
    -- upvalues: TweenService (copy)
    if u14.CurrentWaitTime >= u14.WaitTime then
        u14.CurrentWaitTime = u14.CurrentWaitTime - u14.WaitTime;
        local v16 = math.floor(u14.CurrentTime * u14.Step);

        if v16 - 1 > 0 and u14.StepData then
            for i = 1, v16 - 1 do
                if not u14.StepData[i] then
                    u14.StepData[i] = true;
                    local u17 = i / u14.Step + p15 / u14.Step;

                    if u14.Function then
                        task.spawn(function() -- Line: 120
                            -- upvalues: u17 (copy), u14 (copy), TweenService (ref)
                            local v18 = u17;

                            if u14.Tween then
                                v18 = TweenService:GetValue(v18, u14.Tween.EasingStyle or Enum.EasingStyle.Linear, u14.Tween.EasingDirection or Enum.EasingDirection.Out);
                            end;

                            if u14.Function and (u14.Function(v18) and not u14.Finished) then
                                u14:Destroy();
                            end;
                        end);
                    end;
                end;
            end;
        end;

        if u14.StepData then
            u14.StepData[v16] = true;
        end;

        if u14.Function then
            task.spawn(function() -- Line: 144
                -- upvalues: u14 (copy), TweenService (ref)
                local CurrentTime = u14.CurrentTime;

                if u14.Tween then
                    CurrentTime = TweenService:GetValue(CurrentTime, u14.Tween.EasingStyle or Enum.EasingStyle.Linear, u14.Tween.EasingDirection or Enum.EasingDirection.Out);
                end;

                if u14.Function and (u14.Function(CurrentTime) and not u14.Finished) then
                    u14:Destroy();
                end;
            end);
        end;
    end;
end;

function v1.Heartbeat(u19, u20) -- Line: 159
    -- upvalues: TweenService (copy)
    if u19.Function then
        task.spawn(function() -- Line: 161
            -- upvalues: u19 (copy), TweenService (ref), u20 (copy)
            local CurrentTime = u19.CurrentTime;

            if u19.Tween then
                CurrentTime = TweenService:GetValue(CurrentTime, u19.Tween.EasingStyle or Enum.EasingStyle.Linear, u19.Tween.EasingDirection or Enum.EasingDirection.Out);
            end;

            if u19.Function and (u19.Function(CurrentTime, u20) and not u19.Finished) then
                u19:Destroy();
            end;
        end);
    end;
end;

function v1.HeartbeatWait(u21, u22) -- Line: 175
    -- upvalues: TweenService (copy)
    if u21.CurrentWaitTime >= u21.WaitTime then
        u21.CurrentWaitTime = u21.CurrentWaitTime - u21.WaitTime;

        if u21.Function then
            task.spawn(function() -- Line: 179
                -- upvalues: u21 (copy), TweenService (ref), u22 (copy)
                local CurrentTime = u21.CurrentTime;

                if u21.Tween then
                    CurrentTime = TweenService:GetValue(CurrentTime, u21.Tween.EasingStyle or Enum.EasingStyle.Linear, u21.Tween.EasingDirection or Enum.EasingDirection.Out);
                end;

                if u21.Function and (u21.Function(CurrentTime, u22) and not u21.Finished) then
                    u21:Destroy();
                end;
            end);
        end;
    end;
end;

return v1;