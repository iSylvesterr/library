-- Decompiled with Potassium's decompiler.

local u1 = 0;

local function GetEmptyBoard(p2) -- Line: 24
    local v3 = {};

    for i = 1, p2 do
        v3[i] = {};

        for i2 = 1, p2 do
            v3[i][i2] = 0;
        end;
    end;

    return v3;
end;

local function CountFilledNeighbours(p4, p5, p6) -- Line: 38
    local v7 = #p4;
    local v8 = 0;

    if p5 == 1 or p4[p5 - 1][p6] ~= 0 then
        v8 = v8 + 1;
    end;

    if p5 == v7 or p4[p5 + 1][p6] ~= 0 then
        v8 = v8 + 1;
    end;

    if p6 == 1 or p4[p5][p6 - 1] ~= 0 then
        v8 = v8 + 1;
    end;

    if p6 == v7 or p4[p5][p6 + 1] ~= 0 then
        v8 = v8 + 1;
    end;

    return v8;
end;

local function CountSameColorNeighbours(p9, p10, p11, p12) -- Line: 61
    local v13 = #p9;
    local v14 = 0;

    if p10 > 1 and p9[p10 - 1][p11] == p12 then
        v14 = v14 + 1;
    end;

    if p10 < v13 and p9[p10 + 1][p11] == p12 then
        v14 = v14 + 1;
    end;

    if p11 > 1 and p9[p10][p11 - 1] == p12 then
        v14 = v14 + 1;
    end;

    if p11 < v13 and p9[p10][p11 + 1] == p12 then
        v14 = v14 + 1;
    end;

    return v14;
end;

local function HasIsolatedSquares(u15, p16, p17, u18, u19) -- Line: 84
    -- upvalues: CountFilledNeighbours (copy), CountSameColorNeighbours (copy)
    local v20 = #u15;

    local function IsIsolatedSquare(p21, p22) -- Line: 93
        -- upvalues: u15 (copy), CountFilledNeighbours (ref), u19 (copy), CountSameColorNeighbours (ref), u18 (copy)
        if u15[p21][p22] ~= 0 then
            return false;
        end;

        if CountFilledNeighbours(u15, p21, p22) == 4 then
            return not u19 or CountSameColorNeighbours(u15, p21, p22, u18) > 1;
        end;

        return false;
    end;

    if p16 > 1 then
        local v23 = p16 - 1;
        local v24;

        if u15[v23][p17] == 0 and CountFilledNeighbours(u15, v23, p17) == 4 then
            v24 = not u19 or CountSameColorNeighbours(u15, v23, p17, u18) > 1;
        else
            v24 = false;
        end;

        if v24 then
            return true;
        end;
    end;

    if p16 < v20 then
        local v25 = p16 + 1;
        local v26;

        if u15[v25][p17] == 0 and CountFilledNeighbours(u15, v25, p17) == 4 then
            v26 = not u19 or CountSameColorNeighbours(u15, v25, p17, u18) > 1;
        else
            v26 = false;
        end;

        if v26 then
            return true;
        end;
    end;

    if p17 > 1 then
        local v27 = p17 - 1;
        local v28;

        if u15[p16][v27] == 0 and CountFilledNeighbours(u15, p16, v27) == 4 then
            v28 = not u19 or CountSameColorNeighbours(u15, p16, v27, u18) > 1;
        else
            v28 = false;
        end;

        if v28 then
            return true;
        end;
    end;

    if p17 < v20 then
        local v29 = p17 + 1;
        local v30;

        if u15[p16][v29] == 0 and CountFilledNeighbours(u15, p16, v29) == 4 then
            v30 = not u19 or CountSameColorNeighbours(u15, p16, v29, u18) > 1;
        else
            v30 = false;
        end;

        if v30 then
            return true;
        end;
    end;

    return false;
end;

local function GetPathExtensionNeighbour(p31, p32, p33, p34) -- Line: 124
    -- upvalues: CountSameColorNeighbours (copy), HasIsolatedSquares (copy)
    local v35 = #p31;
    local v36 = math.random(4);
    local v37 = { { -1, 0 }, { 0, 1 }, { 0, -1 }, { 1, 0 } };

    for i = 0, 3 do
        local v38 = v37[(v36 + i - 1) % 4 + 1];
        assert(v38, "Expected path extension direction");
        local v39 = p32 + v38[1];
        local v40 = p33 + v38[2];

        if v39 > 0 and (v39 <= v35 and (v40 > 0 and (v40 <= v35 and (p31[v39][v40] == 0 and (p34 <= 0 or CountSameColorNeighbours(p31, v39, v40, p34) <= 1))))) then
            p31[v39][v40] = p34;

            if not (HasIsolatedSquares(p31, p32, p33, p34, false) or HasIsolatedSquares(p31, v39, v40, p34, true)) then
                return { v39, v40 };
            end;

            p31[v39][v40] = 0;
        end;
    end;

    return { 0, 0 };
end;

local function AddPath(p41, p42, p43) -- Line: 165
    -- upvalues: u1 (ref), HasIsolatedSquares (copy), GetPathExtensionNeighbour (copy)
    local v44 = #p41;
    local v45 = v44 * v44;
    u1 = u1 + 1;
    local v46 = math.random() * v45;
    local v47 = math.floor(v46) + 1;

    for i = 1, v45 do
        local v48 = v47 + 1;
        v47 = v45 < v48 and 1 or v48;
        local v49 = math.floor((v47 - 1) / v44) + 1;
        local v50 = (v47 - 1) % v44 + 1;

        if p42[v49][v50] == 0 then
            p41[v49][v50] = u1;
            p42[v49][v50] = u1;

            if HasIsolatedSquares(p42, v49, v50, u1, true) then
                p41[v49][v50] = 0;
                p42[v49][v50] = 0;
            else
                local v51 = GetPathExtensionNeighbour(p42, v49, v50, u1);
                assert(v51, "Expected generated starting cell");

                if v51[1] ~= 0 or v51[2] ~= 0 then
                    local v52 = 2;

                    while v52 < p43 do
                        local v53 = GetPathExtensionNeighbour(p42, v51[1], v51[2], u1);

                        if v53[1] == 0 and v53[2] == 0 then
                            break;
                        end;

                        v52 = v52 + 1;
                        v51 = v53;
                    end;

                    p41[v51[1]][v51[2]] = u1;

                    return true;
                end;

                p41[v49][v50] = 0;
                p42[v49][v50] = 0;
            end;
        end;

        if i == v45 then
            u1 = u1 - 1;

            return false;
        end;
    end;

    u1 = u1 - 1;

    return false;
end;

local function Shuffle(p54) -- Line: 230
    local v55 = #p54;

    while v55 > 0 do
        local v56 = math.random(v55);
        local v57 = p54[v55];
        p54[v55] = p54[v56];
        p54[v56] = v57;
        v55 = v55 - 1;
    end;

    return p54;
end;

local function ShuffleColors(p58, p59, p60) -- Line: 246
    -- upvalues: Shuffle (copy)
    local v61 = {};

    for i = 1, p60 do
        table.insert(v61, i);
    end;

    Shuffle(v61);
    local v62 = #p58;

    for i = 1, v62 do
        for i2 = 1, v62 do
            if p58[i][i2] ~= 0 then
                p58[i][i2] = v61[p58[i][i2]];
            end;

            if p59[i][i2] ~= 0 then
                p59[i][i2] = v61[p59[i][i2]];
            end;
        end;
    end;
end;

local function GetMaxGeneratedPathLength(p63, p64) -- Line: 270
    local v65 = 0;

    for i = 1, p64 do
        local v66 = 0;

        for i2 = 1, #p63 do
            for i3 = 1, #p63[i2] do
                if p63[i2][i3] == i then
                    v66 = v66 + 1;
                end;
            end;
        end;

        if v65 < v66 then
            v65 = v66;
        end;
    end;

    return v65;
end;

local function GenerateBoard(p67) -- Line: 292
    -- upvalues: GetEmptyBoard (copy), u1 (ref), AddPath (copy), GetMaxGeneratedPathLength (copy), ShuffleColors (copy)
    GetEmptyBoard(p67);
    GetEmptyBoard(p67);
    local v68 = math.min(5, p67);
    local v69 = math.max(3, v68);
    local v70 = math.clamp(p67 - 2, 3, 7);

    while true do
        local v71 = GetEmptyBoard(p67);
        local v72 = GetEmptyBoard(p67);
        u1 = 0;

        while u1 < v70 and AddPath(v71, v72, v69) do

        end;

        if v70 <= u1 and GetMaxGeneratedPathLength(v72, u1) <= v69 then
            ShuffleColors(v71, v72, u1);

            return v71, v72;
        end;
    end;
end;

local function BoardToText(p73) -- Line: 317
    local v74 = "\n";

    for i = 1, #p73 do
        v74 = v74 .. table.concat(p73[i], " ") .. "\n";
    end;

    return v74;
end;

local function ExportBoard(p75) -- Line: 327
    local v76 = {};

    for i = 1, #p75 do
        for i2 = 1, #p75[i] do
            local v77 = p75[i][i2];

            if v77 ~= 0 then
                if not v76[v77] then
                    v76[v77] = {};
                end;

                table.insert(v76[v77], {
                    row = i,
                    col = i2
                });
            end;
        end;
    end;

    return v76;
end;

return function(p78) -- Line: 350, Name: Generate
    -- upvalues: GenerateBoard (copy), ExportBoard (copy), BoardToText (copy)
    local v79, v80 = GenerateBoard(p78);

    return ExportBoard(v79), ExportBoard(v80), BoardToText(v79), BoardToText(v80);
end;