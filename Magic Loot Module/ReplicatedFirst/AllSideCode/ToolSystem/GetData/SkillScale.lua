-- Decompiled with Potassium's decompiler.

local u8 = {
    SkillConfSizeExtents = function(p1) -- Line: 28, Name: SkillConfSizeExtents
        if p1 == nil then
            return nil, nil;
        end;

        local v2 = tonumber(p1);

        if v2 and v2 == v2 then
            return v2, v2;
        end;

        if type(p1) == "table" then
            local v3 = tonumber(p1[1]);
            local v4 = tonumber(p1[2]);

            if v3 and v3 == v3 then
                if v4 and v4 == v4 then
                    return v3, v4;
                end;

                return v3, v3;
            end;
        end;

        return nil, nil;
    end,

    ScaleBandFromOpts = function(p5) -- Line: 54, Name: ScaleBandFromOpts
        local v6 = p5 or {
            min = 1,
            max = 1
        };
        local v7 = tonumber(v6.min) or 1;

        return (v7 + (tonumber(v6.max) or v7)) * 0.5;
    end
};

function u8.ScaleDualFromOpts(p9) -- Line: 66
    -- upvalues: u8 (copy)
    local v10 = u8.ScaleBandFromOpts(p9);

    return (p9 and (p9.baseStart or 1) or 1) * v10, (p9 and p9.baseFinal or 1) * v10;
end;

return u8;