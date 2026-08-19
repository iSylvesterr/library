-- Decompiled with Potassium's decompiler.

return {
    formatWithCommas = function(p1) -- Line: 9, Name: formatWithCommas
        local v2 = p1 < 0 and "-" or "";
        local v3 = math.abs(p1);
        local v4 = math.floor(v3);
        local v5 = v3 - v4;
        local v6 = tostring(v4);
        local v7 = #v6;
        local v8 = false;
        local v9 = 0;
        local v10 = "";

        while true do
            if v8 then
                v9 = v9 + 1;
            else
                v8 = true;
            end;

            if v9 >= v7 then
                if v5 <= 0 then
                    return `{v2}{v10}`;
                end;

                local v11 = string.format("%g", v5);

                return `{v2}{v10}{string.sub(v11, 2)}`;
            end;

            local v12 = v7 - v9;

            if v9 > 0 and v9 % 3 == 0 then
                v10 = "," .. v10;
            end;

            v10 = string.sub(v6, v12, v12) .. v10;
        end;
    end
};