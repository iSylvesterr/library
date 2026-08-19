-- Decompiled with Potassium's decompiler.

return {
    FiniteBase = function(p1) -- Line: 7
        return (type(p1) ~= "number" or (p1 ~= p1 or (p1 == (1 / 0) or (p1 == (-1 / 0) or p1 < 0)))) and 0 or p1;
    end,

    HumanFriendlyRound = function(p2) -- Line: 14
        if p2 < 10 then
            return math.floor(p2 + 0.5);
        end;

        if p2 < 100 then
            return math.floor(p2 / 5 + 0.5) * 5;
        end;

        if p2 < 1000 then
            return math.floor(p2 / 25 + 0.5) * 25;
        end;

        if p2 < 10000 then
            return math.floor(p2 / 100 + 0.5) * 100;
        end;

        if p2 < 100000 then
            return math.floor(p2 / 500 + 0.5) * 500;
        end;

        if p2 < 1000000 then
            return math.floor(p2 / 1000 + 0.5) * 1000;
        end;

        return math.floor(p2 / 5000 + 0.5) * 5000;
    end,

    FormatWithCommas = function(p3) -- Line: 24
        local v4, v5, v6 = tostring(p3):match("^([^%d]*)(%d+)(.-)$");

        return v4 .. v5:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. v6;
    end,

    Abbreviate = function(p7, p8) -- Line: 31
        local v9 = math.abs(p7);
        local v10;

        if v9 >= 1000000000000000 then
            p7 = p7 / 1000000000000000;
            v10 = "Qd";
        elseif v9 >= 1000000000000 then
            p7 = p7 / 1000000000000;
            v10 = "T";
        elseif v9 >= 1000000000 then
            p7 = p7 / 1000000000;
            v10 = "B";
        elseif v9 >= 1000000 then
            p7 = p7 / 1000000;
            v10 = "M";
        elseif v9 >= 1000 then
            p7 = p7 / 1000;
            v10 = "K";
        else
            v10 = "";
        end;

        return string.format(`%.{p8 or 2}f`, p7):gsub("%.?0+$", "") .. v10;
    end,

    Parse = function(p11, p12, p13) -- Line: 55
        local v14 = 0;

        if type(p11) == "string" then
            local v15 = p11:lower():gsub("[,%s]", ""):gsub("[^%d%.kmbtqn%-]", "");

            if not v15:find("[i]") then
                local v16 = (v15:find("qi") or v15:find("qn")) and 1e18 or (v15:find("q") and 1000000000000000 or (v15:find("t") and 1000000000000 or (v15:find("b") and 1000000000 or (v15:find("m") and 1000000 or (v15:find("k") and 1000 or 1)))));
                local v17 = v15:gsub("[^%d%.%-]", "");

                if v17 ~= "" and (v17 ~= "." and (v17 ~= "-" and v17 ~= "-.")) then
                    v14 = (tonumber(v17) or 0) * v16;
                end;
            end;
        else
            v14 = tonumber(p11) or 0;
        end;

        local v18 = (v14 ~= v14 or math.abs(v14) == (1 / 0)) and 0 or v14;

        if p12 or p13 then
            v18 = math.clamp(v18, p12 or (-1 / 0), p13 or (1 / 0)) or v18;
        end;

        return v18;
    end
};