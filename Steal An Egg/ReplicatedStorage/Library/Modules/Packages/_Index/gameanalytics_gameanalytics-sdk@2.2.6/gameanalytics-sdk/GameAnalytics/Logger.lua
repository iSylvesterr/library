-- Decompiled with Potassium's decompiler.

return {
    _infoLogEnabled = false,
    _infoLogAdvancedEnabled = false,
    _debugEnabled = game:GetService("RunService"):IsStudio(),

    setDebugLog = function(p1, p2) -- Line: 10, Name: setDebugLog
        p1._debugEnabled = p2;
    end,

    setInfoLog = function(p3, p4) -- Line: 14, Name: setInfoLog
        p3._infoLogEnabled = p4;
    end,

    setVerboseLog = function(p5, p6) -- Line: 18, Name: setVerboseLog
        p5._infoLogAdvancedEnabled = p6;
    end,

    i = function(p7, p8) -- Line: 22, Name: i
        if not p7._infoLogEnabled then
            return;
        end;

        print("Info/GameAnalytics: " .. p8);
    end,

    w = function(p9, p10) -- Line: 38, Name: w
        warn("Warning/GameAnalytics: " .. p10);
    end,

    e = function(p11, u12) -- Line: 50, Name: e
        task.spawn(function() -- Line: 51
            -- upvalues: u12 (copy)
            error("Error/GameAnalytics: " .. u12, 0);
        end);
    end,

    d = function(p13, p14) -- Line: 64, Name: d
        if not p13._debugEnabled then
            return;
        end;

        print("Debug/GameAnalytics: " .. p14);
    end,

    ii = function(p15, p16) -- Line: 80, Name: ii
        if not p15._infoLogAdvancedEnabled then
            return;
        end;

        print("Verbose/GameAnalytics: " .. p16);
    end
};