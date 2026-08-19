-- Decompiled with Potassium's decompiler.

function deduplicateList(p1)
    local v2 = {};

    for i, v in ipairs(p1) do
        if v2[v] == nil then
            v2[v] = i;
        end;
    end;

    local v3 = {};

    for i, _ in pairs(v2) do
        table.insert(v3, i);
    end;

    return v3;
end;

require(script.Parent.Types);
local Earcut = require(script.Earcut);
local u4 = {};
u4.__index = u4;
u4.phi = 1.618033988749895;

function u4.getLineLength(p5) -- Line: 41
    return (p5[1] - p5[2]).Magnitude;
end;

function u4.getLineLengths(p6) -- Line: 46
    -- upvalues: u4 (copy)
    local v7 = {};

    for i, v in pairs(p6) do
        v7[i] = u4.getLineLength(v);
    end;

    return v7;
end;

function u4.getLineCenter(p8) -- Line: 55
    return p8[1]:Lerp(p8[2], 0.5);
end;

function u4.getLineCenters(p9) -- Line: 60
    -- upvalues: u4 (copy)
    local v10 = {};

    for i, v in pairs(p9) do
        v10[i] = u4.getLineCenter(v);
    end;

    return v10;
end;

function u4.getLineAxis(p11) -- Line: 69
    return (p11[1] - p11[2]).Unit;
end;

function u4.getLineAxes(p12) -- Line: 74
    -- upvalues: u4 (copy)
    local v13 = {};

    for i, v in pairs(p12) do
        v13[i] = u4.getLineAxis(v);
    end;

    return v13;
end;

function u4.getIfVerticesConnected(p14, p15, p16) -- Line: 83
    for _, v in pairs(p16) do
        if v[1] == p14 and v[2] == p15 or v[1] == p15 and v[2] == p14 then
            return true;
        end;
    end;

    return false;
end;

function u4.getConnectedVertices(p17, p18) -- Line: 93
    local v19 = {};

    for _, v in pairs(p18) do
        if p17 == v[1] then
            table.insert(v19, v[2]);
        elseif p17 == v[2] then
            table.insert(v19, v[1]);
        end;
    end;

    return v19;
end;

function u4.getAllVerticesFromLines(p20) -- Line: 106
    local v21 = {};

    for _, v in pairs(p20) do
        table.insert(v21, v[1]);
        table.insert(v21, v[2]);
    end;

    return deduplicateList(v21);
end;

function u4.getAllVertexConnectionsFromLines(p22) -- Line: 116
    local v23 = {};

    for _, v in pairs(p22) do
        v23[v[1]] = v23[v[1]] or {};
        v23[v[1]][v[2]] = true;
        v23[v[2]] = v23[v[2]] or {};
        v23[v[2]][v[1]] = true;
    end;

    local v24 = {};

    for i, v in pairs(v23) do
        local v25 = {};

        for i2, _ in pairs(v) do
            table.insert(v25, i2);
        end;

        v24[i] = v25;
    end;

    return v24;
end;

function u4.getSharedVertex(p26, p27) -- Line: 136
    local v28 = nil;

    for _, v in ipairs(p26) do
        for _, v2 in ipairs(p27) do
            if v == v2 then
                v28 = v;
                break;
            end;
        end;
    end;

    return v28;
end;

function u4.getIfRightAngle(p29, p30, p31) -- Line: 150
    -- upvalues: u4 (copy)
    local v32 = u4.getConnectedVertices(p29, { p30, p31 });
    local v33 = (p29 - v32[1]).Unit:Dot((p29 - v32[2]).Unit) * 100;

    return math.round(v33) / 100 == 0;
end;

function u4.getIfRightAngleFromVertices(p34, p35, p36) -- Line: 159
    -- upvalues: u4 (copy)
    return u4.getIfRightAngle(p34, { p34, p35 }, { p34, p36 });
end;

function u4.getRightAngleVertices(p37) -- Line: 166
    -- upvalues: u4 (copy)
    local v38 = u4.getAllVertexConnectionsFromLines(p37);
    local v39 = {};

    for i, v in pairs(v38) do
        if u4.getIfRightAngleFromVertices(i, v[1], v[2]) then
            table.insert(v39, i);
        end;
    end;

    return v39;
end;

function u4.getIntersectionBetweenTwoLines(p40, p41) -- Line: 180
    -- upvalues: u4 (copy)
    local v42 = u4.getClosestPointToLineOnLine(p40, p41);

    if not v42 then
        return;
    end;

    local v43 = u4.getClosestPointToLineOnLine(p41, p40);

    if v43 then
        local v44;

        if v42 == nil then
            v44 = false;
        else
            v44 = v43 ~= nil;
        end;

        assert(v44);

        return v42:Lerp(v43, 0.5);
    end;
end;

function u4.getVertexOppositePointsFromLines(p45) -- Line: 196
    -- upvalues: u4 (copy)
    local v46 = u4.getRightAngleVertices(p45);
    local v47 = u4.getAllVerticesFromLines(p45);
    local v48 = {};

    if #v46 == 4 then
        for _, v in ipairs(v46) do
            if v48[v] == nil then
                for _, v2 in ipairs(v46) do
                    if v2 ~= v and u4.getIfVerticesConnected(v, v2, p45) == false then
                        v48[v] = v2;
                        v48[v2] = v;
                    end;
                end;
            end;
        end;

        return v48;
    end;

    if #v46 ~= 1 then
        if #v46 == 0 then
            local v49 = v47[1];
            local v50 = v47[3];
            local v51 = v47[2];
            v48[v49] = v50:Lerp(v51, 0.5);
            v48[v50] = v49:Lerp(v51, 0.5);
            v48[v51] = v50:Lerp(v49, 0.5);
        end;

        return v48;
    end;

    local v52 = v46[1];
    local v53;

    if v47[1] == v52 then
        v53 = v47[2];
    else
        v53 = v47[1];
    end;

    local v54;

    if v47[3] == v52 then
        v54 = v47[2];
    else
        v54 = v47[3];
    end;

    v48[v52] = v53:Lerp(v54, 0.5);
    v48[v53] = v52:Lerp(v54, 0.5);
    v48[v54] = v52:Lerp(v53, 0.5);

    return v48;
end;

function u4.getDiagonalLinesFromEdges(p55) -- Line: 234
    -- upvalues: u4 (copy)
    local v56 = u4.getVertexOppositePointsFromLines(p55);
    local v57 = {};

    for i, v in pairs(v56) do
        if not (v57[i] or v57[v]) then
            v57[i] = { i, v };
        end;
    end;

    local v58 = {};

    for _, v in pairs(v57) do
        table.insert(v58, v);
    end;

    return v58;
end;

function u4.getTrianglePerimeter(p59, p60, p61) -- Line: 253
    return (p59 - p60).Magnitude + (p60 - p61).Magnitude + (p61 - p59).Magnitude;
end;

function u4.getTriangleArea(p62, p63, p64) -- Line: 261
    -- upvalues: u4 (copy)
    local v65 = u4.getTrianglePerimeter(p62, p63, p64) / 2;

    return math.sqrt(v65 * (v65 - (p62 - p63).Magnitude) * (v65 - (p63 - p64).Magnitude) * (v65 - (p64 - p62).Magnitude));
end;

function u4.getIfPointIsInTriangle(p66, p67, p68, p69) -- Line: 277
    -- upvalues: u4 (copy)
    local v70 = u4.getTriangleArea(p67, p68, p69);
    local v71 = u4.getTriangleArea(p66, p68, p69);
    local v72 = u4.getTriangleArea(p67, p68, p66);

    return v70 == v71 + v70 + v72;
end;

function u4.getAngleThroughLawOfCos(p73, p74, p75) -- Line: 285
    -- upvalues: u4 (copy)
    local v76 = u4.getLineLength(p73);
    local v77 = u4.getLineLength(p74);
    local v78 = u4.getLineLength(p75);

    return math.round(1000 * (v76 + v77)) == math.round(1000 * v78) and 0 or math.acos((v76 ^ 2 + v77 ^ 2 - v78 ^ 2) / (2 * v76 * v77));
end;

function u4.getAngleBetweenTwoLines(p79, p80) -- Line: 302
    -- upvalues: u4 (copy)
    local v81 = u4.getSharedVertex(p79, p80);
    local v82 = {};
    local v83;

    if p79[1] == v81 then
        v83 = p79[2];
    else
        v83 = p79[1];
    end;

    local v84;

    if p80[1] == v81 then
        v84 = p80[2];
    else
        v84 = p80[1];
    end;

    v82[1], v82[2] = v83, v84;

    return u4.getAngleThroughLawOfCos(p79, p80, v82);
end;

function u4.getSideLengthThroughLawOfCos(p85, p86, p87) -- Line: 312
    -- upvalues: u4 (copy)
    local v88 = u4.getLineLength(p86);
    local v89 = u4.getLineLength(p87);
    local v90 = v88 ^ 2 + v89 ^ 2 - v88 * 2 * v89 * math.cos(p85);

    return math.sqrt(v90);
end;

function u4.getLineInwardNormal(p91, p92) -- Line: 319
    -- upvalues: u4 (copy)
    local v93 = u4.getLineCenter(p91);
    local Unit = (p91[2] - p91[1]).Unit;
    local Unit2 = (v93 - p92).Unit;
    local v94 = Unit:Cross(Unit2):Cross(Unit);

    if v94:Dot(Unit2) > 0 then
        return v94;
    end;

    return -v94;
end;

function u4.getClosestPointInList(p95, p96) -- Line: 337
    local v97 = (1 / 0);
    local v98 = nil;

    for _, v in ipairs(p96) do
        local Magnitude = (p95 - v).Magnitude;

        if Magnitude < v97 then
            v98 = v;
            v97 = Magnitude;
        end;
    end;

    return v98;
end;

function u4.getFarthestPointInList(p99, p100) -- Line: 351
    local v101 = 0;
    local v102 = nil;

    for _, v in ipairs(p100) do
        local Magnitude = (p99 - v).Magnitude;

        if v101 < Magnitude then
            v102 = v;
            v101 = Magnitude;
        end;
    end;

    return v102;
end;

function u4.getClosestPointOnLine(p103, p104) -- Line: 365
    -- upvalues: u4 (copy)
    local v105 = p104[1];
    local v106 = p104[2];
    local v107 = u4.getAngleThroughLawOfCos({ p103, v105 }, p104, { p103, v106 });
    local v108 = math.cos(v107) * (p103 - v105).Magnitude;
    local v109 = math.min(v108, (v105 - v106).Magnitude);
    local v110 = v105 + (v106 - v105).Unit * v109;

    if v110 ~= v110 then
        return p103;
    end;

    local v111 = p104[1];
    local v112 = p104[2];

    if (v112 - v111).Unit:Dot((v110 - v112).Unit) > 0 then
        return v111;
    end;

    if (v112 - v111).Magnitude >= (v110 - v111).Magnitude then
        v112 = v110;
    end;

    return v112;
end;

function u4.getLineClosestToPoint(p113, p114) -- Line: 393
    -- upvalues: u4 (copy)
    local v115 = (1 / 0);
    local v116 = nil;

    for _, v in pairs(p114) do
        local Magnitude = (u4.getClosestPointOnLine(p113, v) - p113).Magnitude;

        if Magnitude < v115 then
            v116 = v;
            v115 = Magnitude;
        end;
    end;

    return v116;
end;

function u4.getCenterFromLines(p117) -- Line: 408
    -- upvalues: u4 (copy)
    local v118 = u4.getDiagonalLinesFromEdges(p117);
    local v119 = nil;

    if #p117 == 4 then
        return u4.getLineCenter(v118[1]);
    end;

    if #p117 == 3 then
        local v120 = u4.getAllVerticesFromLines(p117);

        if #u4.getRightAngleVertices(p117) == 1 then
            local v121 = v118[1];
            local v122 = v118[2];
            assert(v121 ~= nil, "Bad diagonal 1");
            assert(v122 ~= nil, "Bad diagonal 2");

            return u4.getIntersectionBetweenTwoLines(v121, v122);
        end;

        local v123 = v120[2];
        v119 = v120[1]:Lerp(v120[3], 0.5):Lerp(v123, 0.66);
    end;

    return v119;
end;

function u4.getSurfaceCFrameFromLines(p124, p125) -- Line: 434
    -- upvalues: u4 (copy)
    local v126 = 0;
    local v127 = nil;

    for _, v in pairs(p124) do
        local v128 = u4.getLineLength(v);

        if v126 < v128 then
            v127 = v;
            v126 = v128;
        end;
    end;

    local v129 = u4.getCenterFromLines(p124);
    assert(v129 ~= nil, "Bad center point");
    local v130 = -u4.getLineInwardNormal(v127, v129);
    local v131 = v130:Cross(p125);

    return CFrame.fromMatrix(v129, v131, p125, v130);
end;

function u4.getBoxBoundaries(p132, p133) -- Line: 457
    local v134 = p133 * 0.5;

    return (p132 * CFrame.new(-v134.X, -v134.Y, -v134.Z)).Position, (p132 * CFrame.new(v134.X, v134.Y, v134.Z)).Position;
end;

function u4.getPlaneIntersection(p135, p136, p137, p138) -- Line: 465
    local v139 = p136:Dot(p138);
    local v140 = -math.abs(v139);

    if v140 == 0 then
        return p135, 0;
    end;

    local v141 = -(p135 - p137):Dot(p138) / v140;

    return p135 + v141 * p136, v141;
end;

function u4.getNonPerpindicularNormal(p142) -- Line: 483
    local v143 = p142:Cross(Vector3.new(0, 1, 0));
    local v144 = v143:Dot(p142);

    if math.abs(v144) == 1 then
        v143 = p142:Cross(Vector3.new(1, 0, 0));
    end;

    return v143;
end;

function u4.getSideLengthThroughLawOfSin(p145, p146, p147) -- Line: 492
    return (p147[2] - p147[1]).Magnitude * math.sin(p145) / math.sin(p146);
end;

function u4.getClosestPointToLineOnLine(p148, p149) -- Line: 497
    -- upvalues: u4 (copy)
    local v150 = p148[1];
    local v151 = p148[2] - p148[1];
    local Unit = v151.Unit;
    local v152 = p149[1];

    if (p149[2] - p149[1]).Unit:Dot(Unit) > 0 then
        v152 = p149[2];
        local _ = (p149[1] - p149[2]).Unit;
    end;

    local v153 = { v150, v152 };
    local v154 = u4.getAngleBetweenTwoLines(v153, p148);
    local v155 = u4.getAngleBetweenTwoLines(v153, p149);
    local v156 = u4.getSideLengthThroughLawOfSin(v155, 3.141592653589793 - v155 - v154, v153);

    return v150 + Unit * math.clamp(v156, 0, v151.Magnitude);
end;

function u4.getVolume(p157) -- Line: 521
    return p157.X * p157.Y * p157.Z;
end;

function u4.triangulate2D(p158, p159) -- Line: 525
    -- upvalues: Earcut (copy)
    local v160 = p159 or {};
    assert(v160 ~= nil);
    assert(p158[1] ~= p158[#p158], "Perimeter has a duplicate index");
    local v161 = {};

    for i, _ in ipairs(v160) do
        local v162 = p158[1] ~= p158[#p158];
        local v163 = "Hole " .. tostring(i) .. " has a duplicate ending index";
        assert(v162, v163);
    end;

    local u164 = {};

    local function insertPerimeterSequence(p165) -- Line: 544
        -- upvalues: u164 (copy)
        local v166 = {};

        for i, v in ipairs(p165) do
            v166[i] = { v.X, v.Y };
        end;

        table.insert(u164, v166);

        return nil;
    end;

    insertPerimeterSequence(p158);

    for _, v in ipairs(v160) do
        insertPerimeterSequence(v);
    end;

    local v167 = {};
    local v168 = {};
    local v169 = {};
    local v170 = 1;
    local v171 = {};

    for i = 1, #u164 do
        for i2 = 1, #u164[i] do
            for i3 = 1, 2 do
                v167[i3] = math.max(v167[i3] or (-1 / 0), u164[i][i2][i3]);
                v168[i3] = math.min(v168[i3] or (1 / 0), u164[i][i2][i3]);
                table.insert(v169, u164[i][i2][i3]);
            end;
        end;

        if i > 1 then
            v170 = v170 + #u164[i - 1];
            table.insert(v171, v170);
        end;
    end;

    local v172 = Earcut(v169, v171, 2);

    for i = 1, #v172, 3 do
        local v173 = v172[i];
        local v174 = v172[i + 1];
        local v175 = v172[i + 2];
        local v176;

        if v173 == nil or v174 == nil then
            v176 = false;
        else
            v176 = v175 ~= nil;
        end;

        assert(v176);
        local v177 = v173 * 2 + 1;
        local v178 = v174 * 2 + 1;
        local v179 = v175 * 2 + 1;
        local v180 = { Vector2.new(v169[v177], v169[v177 + 1]), Vector2.new(v169[v178], v169[v178 + 1]), Vector2.new(v169[v179], v169[v179 + 1]) };
        table.insert(v161, v180);
    end;

    return v161;
end;

function u4.flattenPerimeterSequence(p181, p182) -- Line: 603
    local v183 = p182:Inverse();
    local v184 = {};
    local v185 = {};

    for i, v in ipairs(p181) do
        local v186 = v183 * CFrame.new(v);
        v184[i] = Vector2.new(v186.X, v186.Y);
        v185[v184[i]] = v;
    end;

    return v184, v185;
end;

function u4.triangulate3D(p187, p188, p189) -- Line: 620
    -- upvalues: u4 (copy)
    local v190 = {};
    local v191 = {};

    for i, v in ipairs(p189 or {}) do
        local v192, v193 = u4.flattenPerimeterSequence(v, p187);
        v190[i] = v192;

        for _, v2 in ipairs(v190[i]) do
            v191[v2.X] = v191[v2.X] or {};
            v191[v2.X][v2.Y] = v193[v2];
        end;
    end;

    local v194, v195 = u4.flattenPerimeterSequence(p188, p187);

    for _, v in ipairs(v194) do
        v191[v.X] = v191[v.X] or {};
        v191[v.X][v.Y] = v195[v];
    end;

    local v196 = u4.triangulate2D(v194, v190);
    local v197 = {};

    for i, v in ipairs(v196) do
        local v198 = {};

        for i2, v2 in ipairs(v) do
            v198[i2] = v191[v2.X][v2.Y];
        end;

        v197[i] = v198;
    end;

    return v197;
end;

function u4.getRegularPolygonInnerAngle(p199) -- Line: 654
    assert(p199 > 2, "You can\'t have a 2-sided polygon");

    return 6.283185307179586 / p199;
end;

function u4.getRegularPolygonVertexAngle(p200) -- Line: 660
    -- upvalues: u4 (copy)
    assert(p200 > 2, "You can\'t have a 2-sided polygon");

    return 2 * (3.141592653589793 - u4.getRegularPolygonInnerAngle(p200) / 2);
end;

function u4.getRegularPolygonEdgeCenterDistance(p201, p202) -- Line: 667
    -- upvalues: u4 (copy)
    assert(p202 > 0, "Radius needs to be larger than 0");
    assert(p201 > 2, "You can\'t have a 2-sided polygon");
    local v203 = u4.getRegularPolygonInnerAngle(p201) / 2;

    return math.cos(v203) * p202;
end;

function u4.getRegularPolygonSideLength(p204, p205) -- Line: 676
    -- upvalues: u4 (copy)
    assert(p205 > 0, "Radius needs to be larger than 0");
    assert(p204 > 2, "You can\'t have a 2-sided polygon");
    local v206 = u4.getRegularPolygonInnerAngle(p204) / 2;

    return math.sin(v206) * 2 * p205;
end;

function u4.getRegularPolygonPerimeter(p207, p208) -- Line: 685
    -- upvalues: u4 (copy)
    assert(p208 > 0, "Radius needs to be larger than 0");
    assert(p207 > 2, "You can\'t have a 2-sided polygon");

    return u4.getRegularPolygonSideLength(p207, p208) * p207;
end;

function u4.getRegularPolygonArea(p209, p210) -- Line: 693
    -- upvalues: u4 (copy)
    return u4.getRegularPolygonEdgeCenterDistance(p209, p210) * u4.getRegularPolygonSideLength(p209, p210) * p209;
end;

return u4;