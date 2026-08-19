-- Decompiled with Potassium's decompiler.

return {
    formatSeconds = function(p1) -- Line: 2
        local v2 = math.max(0, p1);
        local v3 = math.floor(v2);
        local v4 = math.floor(v3 / 86400);
        local v5 = v3 - v4 * 86400;
        local v6 = math.floor(v5 / 3600);
        local v7 = v5 - v6 * 3600;
        local v8 = math.floor(v7 / 60);
        local v9 = v7 - v8 * 60;

        local function _(p10) -- Line: 10
            local v11 = tostring(p10);

            if #v11 == 1 then
                return "0" .. v11;
            end;

            return v11;
        end;

        if v4 <= 0 then
            if v6 <= 0 then
                if v8 <= 0 then
                    return tostring(v9);
                end;

                local v12 = tostring(v8);
                local v13 = tostring(v9);

                if #v13 == 1 then
                    v13 = "0" .. v13;
                end;

                return v12 .. ":" .. v13;
            end;

            local v14 = tostring(v6);
            local v15 = tostring(v8);

            if #v15 == 1 then
                v15 = "0" .. v15;
            end;

            local v16 = tostring(v9);

            if #v16 == 1 then
                v16 = "0" .. v16;
            end;

            return v14 .. ":" .. v15 .. ":" .. v16;
        end;

        local v17 = tostring(v4);
        local v18 = tostring(v6);

        if #v18 == 1 then
            v18 = "0" .. v18;
        end;

        local v19 = tostring(v8);

        if #v19 == 1 then
            v19 = "0" .. v19;
        end;

        local v20 = tostring(v9);

        if #v20 == 1 then
            v20 = "0" .. v20;
        end;

        return v17 .. ":" .. v18 .. ":" .. v19 .. ":" .. v20;
    end,

    formatShortDuration = function(p21) -- Line: 24
        local v22 = math.max(0, p21);
        local v23 = math.floor(v22);

        if v23 < 60 then
            return tostring(v23) .. "s";
        end;

        if v23 < 3600 then
            local v24 = math.floor(v23 / 60);

            return tostring(v24) .. "m";
        end;

        local v25 = math.floor(v23 / 3600);
        local v26 = math.floor((v23 - v25 * 3600) / 60);

        if v26 > 0 then
            return tostring(v25) .. "h " .. tostring(v26) .. "m";
        end;

        return tostring(v25) .. "h";
    end,

    formatBenefitTimer = function(p27) -- Line: 36
        local v28 = math.max(0, p27);
        local v29 = math.floor(v28);
        local v30;

        if v29 >= 3600 then
            v30 = { math.floor(v29 / 3600), (math.floor(v29 % 3600 / 60)) };
        else
            v30 = { math.floor(v29 / 60), v29 % 60 };
        end;

        local v31 = v30[2];

        return string.format("%02d:%02d", math.min(v30[1], 99), v31);
    end,

    formatPolishTimer = function(p32) -- Line: 44
        local v33 = math.max(0, p32);
        local v34 = math.floor(v33);
        local v35 = math.floor(v34 / 3600);
        local v36 = math.floor(v34 % 3600 / 60);
        local v37 = v34 % 60;

        if v35 > 0 then
            return string.format("%02d:%02d:%02d", v35, v36, v37);
        end;

        return string.format("%02d:%02d", v36, v37);
    end,

    formatSecondsWithMilliseconds = function(p38) -- Line: 51
        local v39 = math.max(0, p38);
        local v40 = (v39 - math.floor(v39)) * 100;
        local v41 = math.floor(v40);
        local v42 = tostring(v41);

        if #v42 == 1 then
            v42 = "0" .. v42;
        end;

        local v43 = math.floor(v39);
        local v44 = math.floor(v43 / 86400);
        local v45 = v43 - v44 * 86400;
        local v46 = math.floor(v45 / 3600);
        local v47 = v45 - v46 * 3600;
        local v48 = math.floor(v47 / 60);
        local v49 = v47 - v48 * 60;

        local function _(p50) -- Line: 63
            local v51 = tostring(p50);

            if #v51 == 1 then
                return "0" .. v51;
            end;

            return v51;
        end;

        if v44 <= 0 then
            if v46 <= 0 then
                if v48 <= 0 then
                    return tostring(v49) .. "." .. v42 .. "s";
                end;

                local v52 = tostring(v48);
                local v53 = tostring(v49);

                if #v53 == 1 then
                    v53 = "0" .. v53;
                end;

                return v52 .. ":" .. v53 .. "." .. v42;
            end;

            local v54 = tostring(v46);
            local v55 = tostring(v48);

            if #v55 == 1 then
                v55 = "0" .. v55;
            end;

            local v56 = tostring(v49);

            if #v56 == 1 then
                v56 = "0" .. v56;
            end;

            return v54 .. ":" .. v55 .. ":" .. v56 .. "." .. v42;
        end;

        local v57 = tostring(v44);
        local v58 = tostring(v46);

        if #v58 == 1 then
            v58 = "0" .. v58;
        end;

        local v59 = tostring(v48);

        if #v59 == 1 then
            v59 = "0" .. v59;
        end;

        local v60 = tostring(v49);

        if #v60 == 1 then
            v60 = "0" .. v60;
        end;

        return v57 .. ":" .. v58 .. ":" .. v59 .. ":" .. v60 .. "." .. v42;
    end
};