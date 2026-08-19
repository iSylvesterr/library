-- Decompiled with Potassium's decompiler.

local u44 = {
    ConvertSecondsToTime = function(p1, p2) -- Line: 3, Name: ConvertSecondsToTime
        local v3 = math.floor(p2 / 60);
        local v4 = p2 % 60;
        local v5 = math.floor(v3 / 60);
        local v6 = v3 % 60;
        local v7 = math.floor(v5 / 24);
        local v8 = v5 % 24;
        local v9 = math.floor(v7 / 365);
        local v10 = v7 % 365;
        local v11 = math.floor(v10 / 30);
        local v12 = v10 % 30;
        local v13 = math.floor(v9 / 10);
        local v14 = v9 % 10;
        local v15 = math.floor(v13 / 10);
        local v16 = v13 % 10;
        local v17 = math.floor(v15 / 10);
        local v18 = v15 % 10;
        local v19 = math.floor(v17 / 10);
        local v20 = v17 % 10;
        local v21 = {};
        local v22 = {
            Occupies = 1,
            Type = v19 == 1 and "Eon" or "Eons"
        };

        if v19 == 0 then
            v19 = nil;
        end;

        v22.Value = v19;
        local v23 = {
            Occupies = 1,
            Type = v20 == 1 and "Millenium" or "Millenia"
        };

        if v20 == 0 then
            v20 = nil;
        end;

        v23.Value = v20;
        local v24 = {
            Occupies = 1,
            Type = v18 == 1 and "Century" or "Centuries"
        };

        if v18 == 0 then
            v18 = nil;
        end;

        v24.Value = v18;
        local v25 = {
            Occupies = 1,
            Type = v16 == 1 and "Decade" or "Decades"
        };

        if v16 == 0 then
            v16 = nil;
        end;

        v25.Value = v16;
        local v26 = {
            Occupies = 1,
            Type = v14 == 1 and "Year" or "Years"
        };

        if v14 == 0 then
            v14 = nil;
        end;

        v26.Value = v14;
        local v27 = {
            Occupies = 2,
            Type = v11 == 1 and "Month" or "Months"
        };

        if v11 == 0 then
            v11 = nil;
        end;

        v27.Value = v11;
        local v28 = {
            Occupies = 2,
            Type = v12 == 1 and "Day" or "Days"
        };

        if v12 == 0 then
            v12 = nil;
        end;

        v28.Value = v12;
        local v29 = {
            Occupies = 1,
            Type = v8 == 1 and "Hour" or "Hours"
        };

        if v8 == 0 then
            v8 = nil;
        end;

        v29.Value = v8;
        local v30 = {
            Occupies = 2,
            Type = v6 == 1 and "Minute" or "Minutes"
        };

        if v6 == 0 then
            v6 = nil;
        end;

        v30.Value = v6;
        local v31 = {
            Occupies = 2,
            OverwriteOccupy = true,
            Type = v4 == 1 and "Second" or "Seconds"
        };

        if v4 == 0 then
            v4 = nil;
        end;

        v31.Value = v4;
        v21[1], v21[2], v21[3], v21[4], v21[5], v21[6], v21[7], v21[8], v21[9], v21[10] = v22, v23, v24, v25, v26, v27, v28, v29, v30, v31;

        return v21;
    end,

    GenerateTextFromTime = function(p32, p33, p34) -- Line: 78, Name: GenerateTextFromTime
        local v35 = p34 ~= false;
        local v36 = p33 // 86400;
        local v37 = p33 % 86400;
        local v38 = v37 // 3600;
        local v39 = v37 % 3600;
        local v40 = v39 // 60;
        local v41 = v39 % 60 // 1;
        local v42 = "";

        if v36 > 0 then
            v42 = v42 .. v36 .. (v36 == 1 and " Day" or " Days");
        end;

        if v38 > 0 then
            if #v42 > 0 then
                v42 = v42 .. (v35 and ", " or " ");
            end;

            v42 = v42 .. v38 .. (v38 == 1 and " Hour" or " Hours");
        end;

        if v40 > 0 then
            if #v42 > 0 then
                v42 = v42 .. (v35 and ", " or " ");
            end;

            v42 = v42 .. v40 .. (v40 == 1 and " Minute" or " Minutes");
        end;

        if v41 > 0 then
            if #v42 > 0 then
                v42 = v42 .. (v35 and ", " or " ");
            end;

            v42 = v42 .. v41 .. (v41 == 1 and " Second" or " Seconds");
        end;

        if v35 then
            local v43 = string.match(v42, "^(.*), ");

            if v43 then
                v42 = v43 .. " and " .. string.sub(v42, #v43 + 3);
            end;
        end;

        return v42;
    end
};

function u44.GenerateColonFormatFromTime(p45, p46) -- Line: 117
    -- upvalues: u44 (copy)
    local v47 = u44:ConvertSecondsToTime(p46);
    local v48 = "";
    local v49 = { "Second", "Seconds", "Minute", "Minutes" };

    for i, v in v47 do
        local Value = v.Value;
        local Occupies = v.Occupies;
        local v50 = v47[i - 1];
        local OverwriteOccupy = v.OverwriteOccupy;

        if OverwriteOccupy then
            v50 = OverwriteOccupy;
        elseif v50 then
            v50 = v50.Value;
        end;

        local v51 = table.find(v49, v.Type) and (Value or 0) or Value;

        if v51 then
            local v52 = string.format(v50 and "%0" .. Occupies .. "d" or "%d", v51);

            if i == #v47 then
                v48 = v48 .. v52;
            else
                v48 = v48 .. v52 .. ":";
            end;
        end;
    end;

    return v48;
end;

local u53 = { {
        Name = "Year",
        Singular = "Year",
        Plural = "Years",
        Value = 31536000
    }, {
        Name = "Month",
        Singular = "Month",
        Plural = "Months",
        Value = 2592000
    }, {
        Name = "Day",
        Singular = "Day",
        Plural = "Days",
        Value = 86400
    }, {
        Name = "Hour",
        Singular = "Hour",
        Plural = "Hours",
        Value = 3600
    }, {
        Name = "Minute",
        Singular = "Minute",
        Plural = "Minutes",
        Value = 60
    }, {
        Name = "Second",
        Singular = "Second",
        Plural = "Seconds",
        Value = 1
    } };

function u44.GetLargestTime(p54, p55, p56, p57) -- Line: 187
    -- upvalues: u53 (copy)
    local v58 = 0;
    local v59 = p57 or 1;
    local v60 = {};
    local v61 = p56 or "floor";

    for _, v in ipairs(u53) do
        if v58 >= v59 then
            break;
        end;

        local v62 = math.floor(p55 / v.Value);

        if v62 > 0 or #v60 == 0 and v.Name == "Second" then
            if v58 == v59 - 1 and p55 % v.Value > 0 then
                if v61 == "ceil" then
                    v62 = v62 + 1;
                elseif v61 == "round" and p55 % v.Value >= v.Value / 2 then
                    v62 = v62 + 1;
                end;
            end;

            table.insert(v60, v62 .. " " .. (v62 == 1 and v.Singular or v.Plural));
            p55 = p55 - v62 * v.Value;
            v58 = v58 + 1;
        end;
    end;

    if #v60 == 0 then
        return "0 Seconds";
    end;

    if #v60 == 1 then
        return v60[1];
    end;

    if #v60 == 2 then
        return v60[1] .. " and " .. v60[2];
    end;

    local v63 = table.remove(v60);

    return table.concat(v60, ", ") .. " and " .. v63;
end;

return u44;