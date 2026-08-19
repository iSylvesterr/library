-- Decompiled with Potassium's decompiler.

return {
    DEFAULT_LUCK = 1,

    sumBoosts = function(p1, p2) -- Line: 3, Name: sumBoosts
        local v3 = 0;

        for _, v in p1 do
            if p2 < v.expiresAt then
                v3 = v3 + v.multiplier;
            end;
        end;

        return v3;
    end,

    personalLuck = function(p4, p5, p6) -- Line: 12, Name: personalLuck
        local v7 = 0;

        for _, v in p4 do
            if p5 < v.expiresAt then
                v7 = v7 + v.multiplier;
            end;
        end;

        return math.max(v7, p6);
    end,

    activeBoosts = function(p8, u9) -- Line: 15, Name: activeBoosts
        local function _(p10) -- Line: 18
            -- upvalues: u9 (copy)
            return u9 < p10.expiresAt;
        end;

        local v11 = 0;
        local v12 = {};

        for i, v in p8 do
            local _ = i - 1;

            if u9 < v.expiresAt == true then
                v11 = v11 + 1;
                v12[v11] = v;
            end;
        end;

        return v12;
    end,

    latestExpiry = function(p13) -- Line: 31, Name: latestExpiry
        local v14 = 0;

        for _, v in p13 do
            if v14 < v.expiresAt then
                v14 = v.expiresAt;
            end;
        end;

        return v14;
    end
};