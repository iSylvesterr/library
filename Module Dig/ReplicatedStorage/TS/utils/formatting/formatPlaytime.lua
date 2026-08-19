-- Decompiled with Potassium's decompiler.

local function _(p1) -- Line: 5
    local v2 = tostring(p1);

    if #v2 == 1 then
        return "0" .. v2;
    end;

    return v2;
end;

return {
    formatPlaytime = function(p3) -- Line: 9
        local v4 = math.max(0, p3) / 60;
        local v5 = math.floor(v4);
        local v6 = math.floor(v5 / 1440);
        local v7 = math.floor(v5 % 1440 / 60);
        local v8 = v5 % 60;

        if v6 <= 0 then
            if v7 > 0 then
                local v9 = tostring(v8);

                if #v9 == 1 then
                    v9 = "0" .. v9;
                end;

                return `{v7}:{v9}`;
            end;

            local v10 = tostring(v8);

            if #v10 == 1 then
                v10 = "0" .. v10;
            end;

            return `00:{v10}`;
        end;

        local v11 = tostring(v7);

        if #v11 == 1 then
            v11 = "0" .. v11;
        end;

        local v12 = tostring(v8);

        if #v12 == 1 then
            v12 = "0" .. v12;
        end;

        return `{v6}:{v11}:{v12}`;
    end
};