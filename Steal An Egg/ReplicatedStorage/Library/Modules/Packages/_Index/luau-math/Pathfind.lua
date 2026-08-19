-- Decompiled with Potassium's decompiler.

({}).__index = {};

return function(u1, p2) -- Line: 9
    local u3 = {};

    for i, v in pairs(u1) do
        for _, v2 in ipairs(v) do
            u3[v2] = u3[v2] or {};
            u3[v2][i] = p2(i, v2);
        end;
    end;

    local function getScoredDistances(u4) -- Line: 19
        -- upvalues: u3 (copy)
        local u5 = {
            [u4] = 0
        };
        local v6 = {};

        for i, _ in pairs(u3) do
            if i ~= u4 then
                u5[i] = (1 / 0);
                table.insert(v6, i);
            end;
        end;

        local function scoreStep(p7, p8) -- Line: 31
            -- upvalues: u4 (copy), u5 (copy), u3 (ref), scoreStep (copy)
            if p7 == u4 then
                return;
            end;

            if u5[p7] and p8 < u5[p7] then
                u5[p7] = p8;

                for i, v in pairs(u3[p7]) do
                    scoreStep(i, p8 + v);
                end;
            end;
        end;

        for i, v in pairs(u3[u4]) do
            scoreStep(i, v);
        end;

        return u5;
    end;

    local u9 = {};
    local u10 = {};

    return function(u11, u12) -- Line: 51
        -- upvalues: u9 (copy), u10 (copy), getScoredDistances (copy), u1 (copy)
        local u13 = {};
        u9[u11] = u9[u11] or {};

        if u9[u11][u12] ~= nil then
            for _, v in ipairs(u9[u11][u12]) do
                table.insert(u13, v);
            end;

            return u13;
        end;

        if u10[u12] == nil then
            u10[u12] = getScoredDistances(u12);
        end;

        local u14 = u10[u12];

        local function assemblePath(p15) -- Line: 68
            -- upvalues: u13 (copy), u9 (ref), u11 (copy), u12 (copy), u1 (ref), u14 (copy), assemblePath (copy)
            table.insert(u13, p15);
            table.insert(u9[u11][u12], p15);

            if p15 == u12 then
                return;
            end;

            local v16 = nil;

            for _, v in ipairs(u1[p15] or {}) do
                if u14[v] < (1 / 0) then
                    v16 = v;
                end;
            end;

            if v16 then
                assemblePath(v16);
            end;
        end;

        u9[u11][u12] = {};
        assemblePath(u11);
        local v17 = {};

        for i, v in ipairs(u13) do
            v17[#u13 - i + 1] = v;
        end;

        u9[u12] = u9[u12] or {};
        u9[u12][u11] = v17;

        return u13;
    end;
end;