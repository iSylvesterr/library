-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local u1 = nil;
local u2 = nil;
local v8 = {
    IsNight = function() -- Line: 15, Name: IsNight
        return workspace:GetServerTimeNow() % 1800 >= 900;
    end,

    IsDay = function() -- Line: 19, Name: IsDay
        return workspace:GetServerTimeNow() % 1800 < 900;
    end,

    Update = function() -- Line: 23, Name: Update
        -- upvalues: u1 (ref), Lighting (copy), u2 (ref), TweenService (copy)
        u1 = os.clock();
        local v3 = workspace:GetAttribute("BloodmoonEvent") and 20 or nil;
        local v4 = (workspace:GetAttribute("TrickOrTreatEvent") or workspace:GetAttribute("GraveyardEvent")) and 5 or v3;
        local v5 = (workspace:GetAttribute("MagmaWeather") or workspace:GetAttribute("Starfall")) and 0 or v4;
        local v6 = not v5;
        local v7 = v5 or 14.5;

        if math.abs(v7 - Lighting.ClockTime) > 1 and v6 ~= u2 then
            TweenService:Create(Lighting, TweenInfo.new(5), {
                ClockTime = v7
            }):Play();
        else
            Lighting.ClockTime = v7;
        end;

        u2 = v6;
    end,

    Start = function() -- Line: 72, Name: Start
    end
};
v8.Start();

return v8;