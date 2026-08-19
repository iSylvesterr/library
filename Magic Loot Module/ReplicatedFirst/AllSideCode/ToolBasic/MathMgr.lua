-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = { "K", "M", "B", "T", "P", "E", "aa", "bb", "cc", "dd", "ee", "ff", "gg", "hh", "ii", "jj", "kk", "ll", "mm", "nn", "oo", "pp", "qq", "rr", "ss", "tt", "uu", "vv", "ww", "xx", "yy", "zz", "AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH", "II", "JJ", "KK", "LL", "MM", "NN", "OO", "PP", "QQ", "RR", "SS", "TT", "UU", "VV", "WW", "XX", "YY", "ZZ" };

local function _tranEndNum(p3, p4, p5) -- Line: 49
    if p4 >= 0.9999 then
        return p3 + 1, 0;
    end;

    local v6, v7 = math.modf(p4 * 10 ^ p5);

    if v7 >= 0.9999 then
        v6 = v6 + 1;
    end;

    return p3, v6;
end;

local function _toFixed(p8) -- Line: 69
    local v9, v10 = math.modf(p8);
    local v11;

    if v10 >= 0.9999 then
        v9 = v9 + 1;
        v11 = 0;
    else
        local v12;
        v11, v12 = math.modf(v10 * 100);

        if v12 >= 0.9999 then
            v11 = v11 + 1;
        end;
    end;

    if v11 <= 0 then
        return tostring(v9);
    end;

    if v11 < 10 then
        return v9 .. ".0" .. v11;
    end;

    if v11 % 10 == 0 then
        v11 = math.floor(v11 / 10);
    end;

    return v9 .. "." .. v11;
end;

local function _toFixed1(p13) -- Line: 91
    local v14, v15 = math.modf(p13);
    local v16;

    if v15 >= 0.9999 then
        v14 = v14 + 1;
        v16 = 0;
    else
        local v17;
        v16, v17 = math.modf(v15 * 10);

        if v17 >= 0.9999 then
            v16 = v16 + 1;
        end;
    end;

    if v16 <= 0 then
        return tostring(v14);
    end;

    if v16 % 10 == 0 then
        v16 = math.floor(v16 / 10);
    end;

    return v14 .. "." .. v16;
end;

local function _toFixed3(p18) -- Line: 110
    local v19, v20 = math.modf(p18);
    local v21;

    if v20 >= 0.9999 then
        v19 = v19 + 1;
        v21 = 0;
    else
        local v22;
        v21, v22 = math.modf(v20 * 1000);

        if v22 >= 0.9999 then
            v21 = v21 + 1;
        end;
    end;

    if v21 <= 0 then
        return tostring(v19);
    end;

    if v21 % 10 == 0 then
        v21 = math.floor(v21 / 10);
    end;

    return v19 .. "." .. v21;
end;

local function _toFixed00000(p23) -- Line: 129
    local v24, v25 = math.modf(p23);
    local v26;

    if v25 >= 0.9999 then
        v24 = v24 + 1;
        v26 = 0;
    else
        local v27;
        v26, v27 = math.modf(v25 * 100);

        if v27 >= 0.9999 then
            v26 = v26 + 1;
        end;
    end;

    local v28;

    if v26 > 0 then
        if v26 < 10 then
            v28 = "0" .. v26;
        else
            v28 = tostring(v26);
        end;
    else
        v28 = "00";
    end;

    if v24 < 10 then
        v24 = "00" .. v24;
    elseif v24 < 100 then
        v24 = "0" .. v24;
    end;

    return tostring(v24 .. v28);
end;

local function _getUnitScale(p29) -- Line: 158
    return 10 ^ (p29 * 3);
end;

local function _formatNumStr(p30, p31) -- Line: 169
    -- upvalues: u2 (copy)
    if not p30 then
        return "0";
    end;

    local v32 = tonumber(p30);

    if not v32 then
        return "0";
    end;

    for i = #u2, 1, -1 do
        local v33 = 10 ^ (i * 3);

        if v33 <= v32 then
            return p31(v32 / v33) .. u2[i];
        end;
    end;

    return p31(v32);
end;

local function _appendPercentSuffix(p34) -- Line: 195
    return p34:gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "") .. "%";
end;

local function _formatPercentMagnitude(p35) -- Line: 205
    if p35 >= 1 then
        return string.format("%0.2f", p35):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "") .. "%";
    end;

    if p35 >= 0.1 then
        return string.format("%0.2f", p35):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "") .. "%";
    end;

    if p35 >= 0.01 then
        return string.format("%0.3f", p35):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "") .. "%";
    end;

    if p35 >= 0.001 then
        return string.format("%0.4f", p35):gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "") .. "%";
    end;

    return nil;
end;

function u1.getNumStr_1(p36) -- Line: 231
    -- upvalues: _formatNumStr (copy), _toFixed1 (copy)
    return _formatNumStr(p36, _toFixed1);
end;

function u1.getNumStr_3(p37) -- Line: 241
    -- upvalues: _formatNumStr (copy), _toFixed3 (copy)
    return _formatNumStr(p37, _toFixed3);
end;

function u1.getNumStr(p38) -- Line: 251
    -- upvalues: _formatNumStr (copy), _toFixed (copy)
    return _formatNumStr(p38, _toFixed);
end;

function u1.BackNumStr(p39) -- Line: 261
    -- upvalues: u2 (copy)
    if not p39 then
        return 0;
    end;

    for i = #u2, 1, -1 do
        local v40 = string.find(p39, u2[i], 1, true);

        if v40 then
            local v41 = string.sub(p39, 1, v40 - 1);
            local v42 = tonumber(v41);

            if v42 then
                return v42 * 10 ^ (i * 3);
            end;
        end;
    end;

    return tonumber(p39) or 0;
end;

function u1.getRankNum(p43) -- Line: 290
    -- upvalues: u2 (copy), _toFixed00000 (copy)
    if not p43 then
        return 0;
    end;

    local v44 = math.floor(p43);

    for i = #u2, 1, -1 do
        local v45 = 10 ^ (i * 3);

        if v45 <= v44 then
            local v46 = i .. _toFixed00000(v44 / v45);

            return tonumber(v46) or 0;
        end;
    end;

    return v44;
end;

function u1.backRankNum(p47) -- Line: 314
    if not p47 then
        return 0;
    end;

    local v48 = math.floor(p47);

    if v48 < 100000 then
        return v48;
    end;

    local v49 = math.floor(v48 / 100000);

    return math.floor(v48 % 100000) * 10 ^ (v49 * 3) * 0.01;
end;

function u1.getRandNumZF(p50) -- Line: 336
    return -p50 + math.random() * (p50 * 2);
end;

function u1.getRandNum(p51) -- Line: 346
    return math.random() * p51;
end;

function u1.getRandomPos(p52, p53) -- Line: 357
    local v54 = p53 / 2;
    local v55 = p52.X + math.random() * p53 - v54;
    local v56 = p52.Y + math.random() * p53 - v54;
    local v57 = p52.Z + math.random() * p53 - v54;

    return Vector3.new(v55, v56, v57);
end;

function u1.GetPercentStr(p58) -- Line: 373
    -- upvalues: _formatPercentMagnitude (copy)
    local v59;

    if p58 < 0 then
        p58 = -p58;
        v59 = "-";
    else
        v59 = "";
    end;

    local v60 = _formatPercentMagnitude(p58);

    if v60 then
        return v59 .. v60;
    end;

    return v59 .. tostring(p58) .. "%";
end;

function u1.GetChanceStr(p61, p62) -- Line: 395
    -- upvalues: _formatPercentMagnitude (copy), u1 (copy)
    return (p62 == 0 or p61 == 0) and "0%" or (_formatPercentMagnitude(p61 / p62 * 100) or "1/" .. u1.getNumStr(p62 / p61 / 100));
end;

function u1.CheckIsInRate(p63, p64) -- Line: 416
    return math.random() * p64 < p63;
end;

function u1.Table_Rand(p65) -- Line: 427
    if p65 == nil then
        return nil;
    end;

    local v66 = table.clone(p65);
    local v67 = #v66;
    local v68 = {};

    while v67 > 0 do
        local v69 = math.random(1, v67);
        table.insert(v68, v66[v69]);
        v66[v69] = v66[v67];
        v67 = v67 - 1;
    end;

    return v68;
end;

function u1.RoundNumber(p70, p71) -- Line: 453
    local v72 = 10 ^ (p71 or 0);
    local v73 = math.abs(p70) * v72 + 0.5;

    return (p70 >= 0 and 1 or -1) * math.floor(v73) / v72;
end;

function u1.ApplyLuckToLowestHalfWeights(u74, p75) -- Line: 469
    if type(u74) ~= "table" or #u74 == 0 then
        return u74;
    end;

    if type(p75) ~= "number" or (p75 ~= p75 or p75 <= 0) then
        return u74;
    end;

    local v76 = #u74;
    local v77 = math.ceil(v76 * 0.5);

    if v77 <= 0 then
        return u74;
    end;

    local v78 = table.create(v76);

    for i = 1, v76 do
        v78[i] = i;
    end;

    table.sort(v78, function(p79, p80) -- Line: 487
        -- upvalues: u74 (copy)
        local v81 = u74[p79];
        local v82 = u74[p80];

        if v81 == v82 then
            return p79 < p80;
        end;

        return v81 < v82;
    end);
    local v83 = p75 + 1;

    for i = 1, v77 do
        local v84 = v78[i];
        u74[v84] = u74[v84] * v83;
    end;

    return u74;
end;

function u1.RollPoolItemByWeight(p85, p86) -- Line: 512
    local v87 = 0;

    for _, v in ipairs(p86) do
        v87 = v87 + v;
    end;

    if v87 <= 0 then
        return nil;
    end;

    local v88 = math.random() * v87;

    for i, v in ipairs(p86) do
        v88 = v88 - v;

        if v88 <= 0 then
            return p85[i];
        end;
    end;

    return nil;
end;

function u1.unitDirFromDelta(p89, p90) -- Line: 540
    if p89.Magnitude < 0.001 then
        return p90.Magnitude < 0.00001 and Vector3.new(0, 0, -1) or p90.Unit;
    end;

    return p89.Unit;
end;

function u1.rotLookAtForwardSafe(p91, p92, p93) -- Line: 559
    if p91.Magnitude < 0.00001 then
        return CFrame.new();
    end;

    local Unit = p91.Unit;
    local v94 = p92 or Vector3.new(0, 1, 0);
    local v95 = Unit:Dot(v94);

    if math.abs(v95) > 0.98 and (p93 and p93.Magnitude > 0.1) then
        v94 = p93.Unit;
    end;

    local v96 = CFrame.lookAt(Vector3.new(0, 0, 0), Unit, v94);

    return v96 - v96.Position;
end;

u1.SPIRAL_FIB_SPIRAL_U_PORTION = 0.6;

function u1.spiralFibLikeChordPosTangent(u97, u98, p99, p100, p101, p102, p103, p104, u105) -- Line: 597
    -- upvalues: u1 (copy)
    local v106 = math.clamp(p99, 0, 1);
    local v107 = math.max((p101 == nil or p101 ~= p101) and 45 or p101, 0);
    local v108 = p102;
    local u109 = math.max((v108 == nil or v108 ~= v108) and 15 or v108, 0);
    local v110 = p103;
    local u111 = math.max((v110 == nil or v110 ~= v110) and 80 or v110, u109);
    local u112 = Vector3.new(u98.X, 0, u98.Z);
    local v113 = Vector3.new(u97.X, 0, u97.Z) - u112;
    local Magnitude = v113.Magnitude;
    local v114 = u1.unitDirFromDelta(u98 - u97, Vector3.new(0, 0, -1));
    local SPIRAL_FIB_SPIRAL_U_PORTION = u1.SPIRAL_FIB_SPIRAL_U_PORTION;
    local u115 = p104 or 0;
    local u116 = math.abs(u115) <= 1e-8 and 0 or u115 / 6.283185307179586;
    local u117 = math.clamp((p100 - 12) / 28, -0.5, 0.5) * 0.22 + 1.38;
    local u118 = math.atan2(v113.Z, v113.X);
    local u119 = math.max(v107, u109) + 0.5;

    local function smoothstep01(p120) -- Line: 643
        local v121 = math.clamp(p120, 0, 1);

        return v121 * v121 * (3 - v121 * 2);
    end;

    local function radiusAt(p122) -- Line: 648
        -- upvalues: Magnitude (copy), u119 (copy), u109 (ref), u117 (copy), u111 (ref)
        local v123 = math.clamp(p122, 0, 1);

        if u119 < Magnitude then
            return u109 + (Magnitude - u109) * math.pow(1 - v123, u117);
        end;

        if v123 <= 0.5 then
            local v124 = math.clamp(v123 / 0.5, 0, 1);

            return Magnitude + (u111 - Magnitude) * (v124 * v124 * (3 - v124 * 2));
        end;

        local v125 = math.clamp((v123 - 0.5) / 0.5, 0, 1);

        return u111 + (u109 - u111) * (v125 * v125 * (3 - v125 * 2));
    end;

    local function spiralU2FromU(p126) -- Line: 661
        -- upvalues: u116 (ref), SPIRAL_FIB_SPIRAL_U_PORTION (copy)
        if math.abs(u116) < 1e-8 then
            return p126 / SPIRAL_FIB_SPIRAL_U_PORTION;
        end;

        return -u116 + p126 / SPIRAL_FIB_SPIRAL_U_PORTION;
    end;

    local function spiralYAtProgress(p127) -- Line: 668
        -- upvalues: u105 (copy), SPIRAL_FIB_SPIRAL_U_PORTION (copy), u97 (copy), u98 (copy)
        if u105 == nil then
            return u97.Y + (u98.Y - u97.Y) * p127;
        end;

        local v128 = math.clamp(p127 / SPIRAL_FIB_SPIRAL_U_PORTION, 0, 1);

        return u97.Y + u105 * v128;
    end;

    local u141 = (function() -- Line: 676, Name: spiralEnd3D
        -- upvalues: u116 (ref), u118 (copy), u115 (copy), Magnitude (copy), u119 (copy), u109 (ref), u117 (copy), u111 (ref), u112 (copy), SPIRAL_FIB_SPIRAL_U_PORTION (copy), u105 (copy), u97 (copy), u98 (copy)
        local v129 = math.abs(u116) < 1e-8 and 1 or 1 - u116;
        local v130 = u118 + u115 + 6.283185307179586 * v129;
        local v131 = math.clamp(v129, 0, 1);
        local v132;

        if u119 < Magnitude then
            v132 = u109 + (Magnitude - u109) * math.pow(1 - v131, u117);
        elseif v131 <= 0.5 then
            local v133 = math.clamp(v131 / 0.5, 0, 1);
            v132 = Magnitude + (u111 - Magnitude) * (v133 * v133 * (3 - v133 * 2));
        else
            local v134 = math.clamp((v131 - 0.5) / 0.5, 0, 1);
            v132 = u111 + (u109 - u111) * (v134 * v134 * (3 - v134 * 2));
        end;

        local v135 = math.cos(v130);
        local v136 = math.sin(v130);
        local v137 = u112 + Vector3.new(v135, 0, v136) * v132;
        local v138 = SPIRAL_FIB_SPIRAL_U_PORTION;
        local v139;

        if u105 == nil then
            v139 = u97.Y + (u98.Y - u97.Y) * v138;
        else
            local v140 = math.clamp(v138 / SPIRAL_FIB_SPIRAL_U_PORTION, 0, 1);
            v139 = u97.Y + u105 * v140;
        end;

        return Vector3.new(v137.X, v139, v137.Z);
    end)();

    local function posAt(p142) -- Line: 687
        -- upvalues: u105 (copy), SPIRAL_FIB_SPIRAL_U_PORTION (copy), u97 (copy), u98 (copy), Magnitude (copy), u116 (ref), u118 (copy), u115 (copy), u119 (copy), u109 (ref), u117 (copy), u111 (ref), u112 (copy), u141 (copy)
        local v143 = math.clamp(p142, 0, 1);
        local v144;

        if u105 == nil then
            v144 = u97.Y + (u98.Y - u97.Y) * v143;
        else
            local v145 = math.clamp(v143 / SPIRAL_FIB_SPIRAL_U_PORTION, 0, 1);
            v144 = u97.Y + u105 * v145;
        end;

        if Magnitude < 0.0001 then
            return u97:Lerp(u98, v143);
        end;

        if v143 > SPIRAL_FIB_SPIRAL_U_PORTION then
            return u141:Lerp(u98, (v143 - SPIRAL_FIB_SPIRAL_U_PORTION) / (1 - SPIRAL_FIB_SPIRAL_U_PORTION));
        end;

        local v146;

        if math.abs(u116) < 1e-8 then
            v146 = v143 / SPIRAL_FIB_SPIRAL_U_PORTION;
        else
            v146 = -u116 + v143 / SPIRAL_FIB_SPIRAL_U_PORTION;
        end;

        local v147 = u118 + u115 + 6.283185307179586 * v146;
        local v148 = math.clamp(v146, 0, 1);
        local v149;

        if u119 < Magnitude then
            v149 = u109 + (Magnitude - u109) * math.pow(1 - v148, u117);
        elseif v148 <= 0.5 then
            local v150 = math.clamp(v148 / 0.5, 0, 1);
            v149 = Magnitude + (u111 - Magnitude) * (v150 * v150 * (3 - v150 * 2));
        else
            local v151 = math.clamp((v148 - 0.5) / 0.5, 0, 1);
            v149 = u111 + (u109 - u111) * (v151 * v151 * (3 - v151 * 2));
        end;

        local v152 = math.cos(v147);
        local v153 = math.sin(v147);
        local v154 = u112 + Vector3.new(v152, 0, v153) * v149;

        return Vector3.new(v154.X, v144, v154.Z);
    end;

    local v155 = posAt(v106);
    local v156 = math.clamp(v106 - 0.002, 0, 1);
    local v157 = math.clamp(v106 + 0.002, 0, 1);

    if v157 - v156 < 1e-6 then
        v156 = math.max(0, v106 - 0.01);
        v157 = math.min(1, v106 + 0.01);
    end;

    local v158 = posAt(v156);
    local v159 = posAt(v157) - v158;

    if v159.Magnitude < 1e-6 then
        return v155, v114;
    end;

    return v155, v159.Unit;
end;

return u1;