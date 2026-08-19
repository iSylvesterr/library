-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
Random.new();

return {
    BOOMBOX_RANGE = 12,

    generateKey = function(p1) -- Line: 17, Name: generateKey
        -- upvalues: HttpService (copy)
        local v2 = HttpService:GenerateGUID(false);

        return p1 .. ":" .. string.sub(v2, 1, 8);
    end,

    interpretSize = function(p3) -- Line: 20, Name: interpretSize
        if p3 < 1 then
            return p3;
        end;

        return p3 <= 1.4 and 1 or (p3 <= 1.9 and 1.1 or (p3 <= 2.4 and 1.25 or (p3 <= 2.9 and 1.5 or (p3 <= 3.4 and 1.75 or (p3 <= 4 and 2 or (p3 <= 5.9 and 3.5 or (p3 <= 6.9 and 4 or (p3 <= 7.9 and 4.5 or (p3 <= 8.9 and 5 or (p3 <= 9.9 and 6 or (p3 == 10 and 7 or p3 * 0.75)))))))))));
    end,

    sizeScalingMultiplier = function(p4) -- Line: 54, Name: sizeScalingMultiplier
        local v5 = math.clamp(p4, 1, 10);

        return (v5 ^ (math.clamp((v5 - 3) / 3, 0, 1) * 0.3999999999999999 + 0.8) - 1) * 0.6 + 1;
    end
};