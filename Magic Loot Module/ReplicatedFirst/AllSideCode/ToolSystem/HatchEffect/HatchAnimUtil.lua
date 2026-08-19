-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");

return {
    runEasingLoop = function(p1, p2, p3, p4, p5) -- Line: 22, Name: runEasingLoop
        -- upvalues: TweenService (copy), RunService (copy)
        local v6 = os.clock();

        while not p5 or p5() do
            local v7 = (os.clock() - v6) / p1;
            local v8 = math.clamp(v7, 0, 1);
            p4((TweenService:GetValue(v8, p2, p3)));
            RunService.RenderStepped:Wait();

            if v8 >= 1 then
                break;
            end;
        end;
    end
};