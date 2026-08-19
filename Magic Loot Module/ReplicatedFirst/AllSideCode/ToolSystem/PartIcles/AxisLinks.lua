-- Decompiled with Potassium's decompiler.

local u1 = { { "SizeX", "SizeY", "SizeZ" }, { "RotSpeedX", "RotSpeedY", "RotSpeedZ" }, { "PosOffsetX", "PosOffsetY", "PosOffsetZ" }, { "RotX", "RotY", "RotZ" }, { "PosX", "PosY", "PosZ" } };
local u2 = {};
local u3 = {};
local u4 = { "SizeX", "SizeY", "SizeZ", "RotSpeedX", "RotSpeedY", "RotSpeedZ", "PosOffsetX", "PosOffsetY", "PosOffsetZ" };

for _, v in ipairs(u1) do
    local v5 = {};

    for _, v2 in ipairs(v) do
        v5[v2] = true;
    end;

    for _, v2 in ipairs(v) do
        u2[v2] = v5;
    end;
end;

local function resolveAxisLink(p6, p7) -- Line: 27
    -- upvalues: u2 (copy)
    local v8;

    if p6 then
        v8 = p6[p7] or nil;
    else
        v8 = nil;
    end;

    if not v8 or (v8 == "" or v8 == p7) then
        return nil;
    end;

    local v9 = u2[p7];

    if not (v9 and v9[v8]) then
        return nil;
    end;

    local v10 = p6[v8];

    if v10 and (v10 ~= "" and (v10 ~= v8 and v9[v10])) then
        return nil;
    end;

    return v8;
end;

function u3.sanitize(p11) -- Line: 38
    -- upvalues: u1 (copy), u2 (copy)
    local v12 = {};

    for _, v in ipairs(u1) do
        for _, v2 in ipairs(v) do
            local v13;

            if p11 then
                v13 = p11[v2] or nil;
            else
                v13 = nil;
            end;

            if v13 and (v13 ~= "" and v13 ~= v2) then
                local v14 = u2[v2];

                if v14 and v14[v13] then
                    local v15 = p11[v13];

                    if v15 and (v15 ~= "" and (v15 ~= v13 and v14[v15])) then
                        v13 = nil;
                    end;
                else
                    v13 = nil;
                end;
            else
                v13 = nil;
            end;

            v12[v2] = v13;
        end;
    end;

    return v12;
end;

function u3.applyGraphAxisAliases(p16, p17, p18) -- Line: 46
    -- upvalues: u4 (copy)
    if not (p18 and (p16 and p17)) then
        return;
    end;

    for _, v in ipairs(u4) do
        local v19 = p18[v];

        if v19 and (v19 ~= v and (p16[v19] and p17[v19])) then
            p16[v] = p16[v19];
            p17[v] = p17[v19];
        end;
    end;
end;

function u3.sampleRangeAxes(p20, p21, p22, p23, p24) -- Line: 62
    local v25;

    if p24 then
        v25 = p24.EmitIndex;
    else
        v25 = p24;
    end;

    local v26;

    if p24 then
        v26 = p24.EmitCount;
    else
        v26 = p24;
    end;

    local v27 = (p22[1] or ""):sub(1, 3);
    local v28 = nil;
    local v29 = nil;

    if v27 == "Pos" then
        if p24 then
            v28 = p24.EvenOffsetIdx_Pos;
        else
            v28 = p24;
        end;

        if p24 then
            p24 = p24.EvenOffsetN_Pos;
        end;
    elseif v27 == "Rot" then
        if p24 then
            v28 = p24.EvenOffsetIdx_Rot;
        else
            v28 = p24;
        end;

        if p24 then
            p24 = p24.EvenOffsetN_Rot;
        end;
    else
        p24 = v29;
    end;

    local v30;

    if v25 then
        if v26 then
            v30 = v26 > 0;
        else
            v30 = v26;
        end;
    else
        v30 = v25;
    end;

    local v31 = {};

    for _, v in ipairs(p22) do
        local v32;

        if p21 then
            v32 = p21[v];
        else
            v32 = p21;
        end;

        if not v32 then
            if p20[v .. "Even"] == true and v30 then
                local v33 = p20[v];
                local v34 = p24 and p24 > 0 and ((v28 - 1) / (p24 * v26) or 0) or 0;
                local v35;

                if v26 == 1 and v34 == 0 then
                    v35 = 0.5;
                else
                    v35 = v25 / v26 + v34;

                    if v35 > 1 then
                        v35 = v35 - 1;
                    end;
                end;

                v31[v] = v33.Min + (v33.Max - v33.Min) * v35;
            else
                v31[v] = p23.RandomValueFromRange(p20[v]);
            end;
        end;
    end;

    for _, v in ipairs(p22) do
        if v31[v] == nil then
            local v36;

            if p21 then
                v36 = p21[v];
            else
                v36 = p21;
            end;

            v31[v] = v36 and v31[v36] or p23.RandomValueFromRange(p20[v]);
        end;
    end;

    return v31;
end;

function u3.refreshLoopGraphsAndSeeds(p37, p38, p39) -- Line: 107
    -- upvalues: u3 (copy)
    if not p37.Graphs then
        return;
    end;

    for i, _ in pairs(p37.Graphs) do
        if p38[i] ~= nil then
            p37.Graphs[i] = p38[i];
        end;
    end;

    if p37.Seeds then
        for i, _ in pairs(p37.Seeds) do
            if p37.Graphs[i] then
                p37.Seeds[i] = p39.GenerateSeed(p37.Graphs[i]);
            end;
        end;
    end;

    u3.applyGraphAxisAliases(p37.Graphs, p37.Seeds, p38.AxisLinks);
end;

return u3;