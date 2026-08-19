-- Decompiled with Potassium's decompiler.

local ZeroArray = require(script:WaitForChild("ZeroArray"));

function earcutLinked(p1, p2, p3, p4, p5, p6, p7)
    -- upvalues: ZeroArray (copy)
    if not p1 then
        return;
    end;

    local v8;

    if p7 or not p6 then
        v8 = p1;
    else
        indexCurve(p1, p4, p5, p6);
        v8 = p1;
    end;

    while p1.prev ~= p1.next do
        local v9 = false;
        local prev = p1.prev;
        local next = p1.next;
        local v10;

        if p6 then
            v10 = isEarHashed(p1, p4, p5, p6);
        else
            v10 = isEar(p1);
        end;

        if v10 then
            ZeroArray.push(p2, prev.i / p3);
            ZeroArray.push(p2, p1.i / p3);
            ZeroArray.push(p2, next.i / p3);
            removeNode(p1);
            p1 = next.next;
            v8 = next.next;
            v9 = true;
        end;

        if v9 then
            next = p1;
        elseif next == v8 then
            if not p7 then
                earcutLinked(filterPoints(next), p2, p3, p4, p5, p6, 1);

                return;
            end;

            if p7 == 1 then
                local v11 = cureLocalIntersections(filterPoints(next), p2, p3);
                earcutLinked(v11, p2, p3, p4, p5, p6, 2);

                return;
            end;

            if p7 == 2 then
                splitEarcut(next, p2, p3, p4, p5, p6);

                return;
            end;

            break;
        end;

        p1 = next;
    end;
end;

function splitEarcut(p12, p13, p14, p15, p16, p17)
    local v18 = p12;

    while true do
        local next = p12.next.next;

        while next ~= p12.prev do
            if p12.i ~= next.i and isValidDiagonal(p12, next) then
                local v19 = splitPolygon(p12, next);
                local v20 = filterPoints(p12, p12.next);
                local v21 = filterPoints(v19, v19.next);
                earcutLinked(v20, p13, p14, p15, p16, p17);
                earcutLinked(v21, p13, p14, p15, p16, p17);

                return;
            end;

            next = next.next;
        end;

        p12 = p12.next;

        if p12 == v18 then
            return;
        end;
    end;
end;

function earcut(p22, p23, p24)
    -- upvalues: ZeroArray (copy)
    local v25 = ZeroArray.new(p22);
    local v26 = ZeroArray.new(p23);
    local v27 = p24 or 2;
    local v28;

    if v26 then
        v28 = #v26 > 0;
    else
        v28 = v26;
    end;

    local v29 = v28 and v26[0] * v27 or #v25;
    local v30 = linkedList(v25, 0, v29, v27, true);
    local v31 = ZeroArray.new({});

    if not v30 or v30.next == v30.prev then
        return {};
    end;

    if v28 then
        v30 = eliminateHoles(v25, v26, v30, v27);
    end;

    local v32, v33, v34, v35;

    if #v25 > 80 * v27 then
        v32 = v25[0];
        local v36 = v25[0];
        v33 = v25[1];
        local v37 = v25[1];
        v34 = v27;

        while v27 < v29 do
            local v38 = v25[v27];
            local v39 = v25[v27 + 1];

            if v38 < v32 then
                v32 = v38;
            end;

            if v39 < v33 then
                v33 = v39;
            end;

            if v36 >= v38 then
                v38 = v36;
            end;

            if v37 >= v39 then
                v39 = v37;
            end;

            v27 = v27 + v34;
            v37 = v39;
            v36 = v38;
        end;

        local v40 = math.max(v36 - v32, v37 - v33);

        if v40 == 0 then
            v35 = nil;
        else
            v35 = 1 / v40 or nil;
        end;
    else
        v34 = v27;
        v32 = nil;
        v33 = nil;
        v35 = nil;
    end;

    earcutLinked(v30, v31, v34, v32, v33, v35);

    return ZeroArray.getOneIndex(v31);
end;

function linkedList(p41, p42, p43, p44, p45)
    local v46 = nil;

    if p45 == (signedArea(p41, p42, p43, p44) > 0) then
        while p42 < p43 do
            v46 = insertNode(p42, p41[p42], p41[p42 + 1], v46);
            p42 = p42 + p44;
        end;
    else
        local v47 = p43 - p44;

        while p42 <= v47 do
            v46 = insertNode(v47, p41[v47], p41[v47 + 1], v46);
            v47 = v47 - p44;
        end;
    end;

    if v46 and equals(v46, v46.next) then
        removeNode(v46);
        v46 = v46.next;
    end;

    return v46;
end;

function filterPoints(p48, p49)
    if not p48 then
        return p48;
    end;

    local v50 = p49 or p48;

    while true do
        local v51 = false;

        if p48.steiner or not equals(p48, p48.next) and area(p48.prev, p48, p48.next) ~= 0 then
            p48 = p48.next;
        else
            removeNode(p48);
            v50 = p48.prev;

            if v50 == v50.next then
                break;
            end;

            p48 = v50;
            v51 = true;
        end;

        if not v51 or p48 == v50 then
            break;
        end;
    end;

    return v50;
end;

function isEar(p52)
    local prev = p52.prev;
    local next = p52.next;

    if area(prev, p52, next) >= 0 then
        return false;
    end;

    local next2 = p52.next.next;

    while next2 ~= p52.prev do
        if pointInTriangle(prev.x, prev.y, p52.x, p52.y, next.x, next.y, next2.x, next2.y) and area(next2.prev, next2, next2.next) >= 0 then
            return false;
        end;

        next2 = next2.next;
    end;

    return true;
end;

function isEarHashed(p53, p54, p55, p56)
    local prev = p53.prev;
    local next = p53.next;

    if area(prev, p53, next) >= 0 then
        return false;
    end;

    local v57 = prev.x > p53.x and (prev.x > next.x and prev.x or next.x) or (p53.x > next.x and p53.x or next.x);
    local v58 = prev.y > p53.y and (prev.y > next.y and prev.y or next.y) or (p53.y > next.y and p53.y or next.y);
    local v59 = zOrder(prev.x < p53.x and (prev.x < next.x and prev.x or next.x) or (p53.x < next.x and p53.x or next.x), prev.y < p53.y and (prev.y < next.y and prev.y or next.y) or (p53.y < next.y and p53.y or next.y), p54, p55, p56);
    local v60 = zOrder(v57, v58, p54, p55, p56);
    local prevZ = p53.prevZ;
    local nextZ = p53.nextZ;

    while prevZ and (v59 <= prevZ.z and (nextZ and nextZ.z <= v60)) do
        if prevZ ~= p53.prev and (prevZ ~= p53.next and (pointInTriangle(prev.x, prev.y, p53.x, p53.y, next.x, next.y, prevZ.x, prevZ.y) and area(prevZ.prev, prevZ, prevZ.next) >= 0)) then
            return false;
        end;

        prevZ = prevZ.prevZ;

        if nextZ ~= p53.prev and (nextZ ~= p53.next and (pointInTriangle(prev.x, prev.y, p53.x, p53.y, next.x, next.y, nextZ.x, nextZ.y) and area(nextZ.prev, nextZ, nextZ.next) >= 0)) then
            return false;
        end;

        nextZ = nextZ.nextZ;
    end;

    while prevZ and v59 <= prevZ.z do
        if prevZ ~= p53.prev and (prevZ ~= p53.next and (pointInTriangle(prev.x, prev.y, p53.x, p53.y, next.x, next.y, prevZ.x, prevZ.y) and area(prevZ.prev, prevZ, prevZ.next) >= 0)) then
            return false;
        end;

        prevZ = prevZ.prevZ;
    end;

    while nextZ and nextZ.z <= v60 do
        if nextZ ~= p53.prev and (nextZ ~= p53.next and (pointInTriangle(prev.x, prev.y, p53.x, p53.y, next.x, next.y, nextZ.x, nextZ.y) and area(nextZ.prev, nextZ, nextZ.next) >= 0)) then
            return false;
        end;

        nextZ = nextZ.nextZ;
    end;

    return true;
end;

function cureLocalIntersections(p61, p62, p63)
    -- upvalues: ZeroArray (copy)
    local v64 = p61;

    while true do
        local prev = p61.prev;
        local next = p61.next.next;

        if equals(prev, next) or not (intersects(prev, p61, p61.next, next) and (locallyInside(prev, next) and locallyInside(next, prev))) then
            next = p61;
        else
            ZeroArray.push(p62, prev.i / p63);
            ZeroArray.push(p62, p61.i / p63);
            ZeroArray.push(p62, next.i / p63);
            removeNode(p61);
            removeNode(p61.next);
            v64 = next;
        end;

        p61 = next.next;

        if p61 == v64 then
            return filterPoints(p61);
        end;
    end;
end;

function eliminateHoles(p65, p66, p67, p68)
    -- upvalues: ZeroArray (copy)
    local v69 = ZeroArray.new({});
    local v70 = #p66;
    local v71 = 0;

    while v71 < v70 do
        local v72 = linkedList(p65, p66[v71] * p68, v71 < v70 - 1 and p66[v71 + 1] * p68 or #p65, p68, false);

        if v72 == v72.next then
            v72.steiner = true;
        end;

        ZeroArray.push(v69, getLeftmost(v72));
        v71 = v71 + 1;
    end;

    ZeroArray.sort(v69, compareX);
    local v73 = 0;

    while v73 < #v69 do
        eliminateHole(v69[v73], p67);
        p67 = filterPoints(p67, p67.next);
        v73 = v73 + 1;
    end;

    return p67;
end;

function compareX(p74, p75)
    return p74.x < p75.x;
end;

function eliminateHole(p76, p77)
    local v78 = findHoleBridge(p76, p77);

    if v78 then
        local v79 = splitPolygon(v78, p76);
        filterPoints(v78, v78.next);
        filterPoints(v79, v79.next);
    end;
end;

function findHoleBridge(p80, p81)
    local x = p80.x;
    local y = p80.y;
    local v82 = p81;
    local v83 = (-1 / 0);
    local v84 = nil;
    local v85;

    while true do
        if y <= p81.y and (p81.next.y <= y and p81.next.y ~= p81.y) then
            v85 = p81.x + (y - p81.y) * (p81.next.x - p81.x) / (p81.next.y - p81.y);

            if v85 <= x and v83 < v85 then
                if v85 == x then
                    if x == p81.y then
                        return p81;
                    end;

                    if y == p81.next.y then
                        return p81.next;
                    end;
                end;

                v84 = p81.x < p81.next.x and p81 and p81 or p81.next;
            else
                v85 = v83;
            end;
        else
            v85 = v83;
        end;

        p81 = p81.next;

        if p81 == v82 then
            break;
        end;

        v83 = v85;
    end;

    if not v84 then
        return nil;
    end;

    if x == v85 then
        return v84;
    end;

    local x2 = v84.x;
    local y2 = v84.y;
    local v86 = v84;
    local v87 = v86;
    local v88 = v86;
    v86 = v87;
    v88 = v87;
    local v89 = (1 / 0);

    while true do
        local v90;

        if v84.x <= x and (x2 <= v84.x and x ~= v84.x) and pointInTriangle(y < y2 and x and x or v85, y, x2, y2, y < y2 and v85 and v85 or x, y, v84.x, v84.y) then
            v90 = math.abs(y - v84.y) / (x - v84.x);

            if locallyInside(v84, p80) and (v90 < v89 or v90 == v89 and (v84.x > v86.x or v84.x == v86.x and sectorContainsSector(v86, v84))) then
                v86 = v84;
            else
                v90 = v89;
            end;
        else
            v90 = v89;
        end;

        v84 = v84.next;

        if v84 == v87 then
            return v86;
        end;

        v89 = v90;
    end;
end;

function sectorContainsSector(p91, p92)
    local v93;

    if area(p91.prev, p91, p92.prev) < 0 then
        v93 = area(p92.next, p91, p91.next) < 0;
    else
        v93 = false;
    end;

    return v93;
end;

function indexCurve(p94, p95, p96, p97)
    local v98 = p94;

    while true do
        if p94.z == nil then
            p94.z = zOrder(p94.x, p94.y, p95, p96, p97);
        end;

        p94.prevZ = p94.prev;
        p94.nextZ = p94.next;
        p94 = p94.next;

        if p94 == v98 then
            p94.prevZ.nextZ = nil;
            p94.prevZ = nil;
            sortLinked(p94);

            return;
        end;
    end;
end;

function sortLinked(p99)
    local v100 = 1;

    while true do
        local v101 = 0;
        local v102 = nil;
        local v103 = nil;

        while p99 do
            v101 = v101 + 1;
            local v104 = p99;
            local v105 = 0;
            local v106 = 0;

            while v105 < v100 do
                v106 = v106 + 1;
                p99 = p99.nextZ;

                if not p99 then
                    break;
                end;

                v105 = v105 + 1;
            end;

            local v107 = v100;

            while v106 > 0 or v100 > 0 and p99 do
                local v108;

                if v106 == 0 or v100 ~= 0 and (p99 and v104.z > p99.z) then
                    v108 = p99.nextZ;
                    v100 = v100 - 1;
                else
                    v106 = v106 - 1;
                    v108 = p99;
                    p99 = v104;
                    v104 = v104.nextZ;
                end;

                if v102 then
                    v102.nextZ = p99;
                else
                    v103 = p99;
                end;

                p99.prevZ = v102;
                v102 = p99;
                p99 = v108;
            end;

            v100 = v107;
        end;

        v102.nextZ = nil;
        v100 = v100 * 2;

        if v101 <= 1 then
            return v103;
        end;

        p99 = v103;
    end;
end;

local lshift = bit32.lshift;
local bor = bit32.bor;
local band = bit32.band;

function zOrder(p109, p110, p111, p112, p113)
    -- upvalues: lshift (copy), bor (copy), band (copy)
    local v114 = 32767 * (p109 - p111) * p113;
    local v115 = 32767 * (p110 - p112) * p113;
    local v116 = band(bor(v114, (lshift(v114, 8))), 16711935);
    local v117 = band(bor(v116, (lshift(v116, 4))), 252645135);
    local v118 = band(bor(v117, (lshift(v117, 2))), 858993459);
    local v119 = band(bor(v118, (lshift(v118, 1))), 1431655765);
    local v120 = band(bor(v115, (lshift(v115, 8))), 16711935);
    local v121 = band(bor(v120, (lshift(v120, 4))), 252645135);
    local v122 = band(bor(v121, (lshift(v121, 2))), 858993459);

    return bor(v119, (lshift(band(bor(v122, (lshift(v122, 1))), 1431655765), 1)));
end;

function getLeftmost(p123)
    local v124 = p123;
    local v125 = v124;
    local v126 = v124;
    v124 = v125;
    v126 = v125;

    while true do
        if p123.x < v125.x or p123.x == v125.x and p123.y < v125.y then
            v125 = p123;
        end;

        p123 = p123.next;

        if p123 == v124 then
            return v125;
        end;
    end;
end;

function pointInTriangle(p127, p128, p129, p130, p131, p132, p133, p134)
    local v135;

    if (p131 - p133) * (p128 - p134) - (p127 - p133) * (p132 - p134) >= 0 and (p127 - p133) * (p130 - p134) - (p129 - p133) * (p128 - p134) >= 0 then
        v135 = (p129 - p133) * (p132 - p134) - (p131 - p133) * (p130 - p134) >= 0;
    else
        v135 = false;
    end;

    return v135;
end;

function isValidDiagonal(p136, p137)
    local v138;

    if p136.next.i == p137.i or p136.prev.i == p137.i then
        v138 = false;
    else
        v138 = not intersectsPolygon(p136, p137);

        if v138 then
            v138 = locallyInside(p136, p137) and (locallyInside(p137, p136) and middleInside(p136, p137)) and (area(p136.prev, p136, p137.prev) or area(p136, p137.prev, p137));

            if not v138 then
                v138 = equals(p136, p137);

                if v138 then
                    if area(p136.prev, p136, p136.next) > 0 then
                        v138 = area(p137.prev, p137, p137.next) > 0;
                    else
                        v138 = false;
                    end;
                end;
            end;
        end;
    end;

    return v138;
end;

function area(p139, p140, p141)
    return (p140.y - p139.y) * (p141.x - p140.x) - (p140.x - p139.x) * (p141.y - p140.y);
end;

function equals(p142, p143)
    local v144;

    if p142.x == p143.x then
        v144 = p142.y == p143.y;
    else
        v144 = false;
    end;

    return v144;
end;

function intersects(p145, p146, p147, p148)
    local v149 = sign(area(p145, p146, p147));
    local v150 = sign(area(p145, p146, p148));
    local v151 = sign(area(p147, p148, p145));
    local v152 = sign(area(p147, p148, p146));

    return v149 ~= v150 and v151 ~= v152 and true or (v149 == 0 and onSegment(p145, p147, p146) and true or (v150 == 0 and onSegment(p145, p148, p146) and true or (v151 == 0 and onSegment(p147, p145, p148) and true or (v152 == 0 and onSegment(p147, p146, p148) and true or false))));
end;

function onSegment(p153, p154, p155)
    local v156;

    if p154.x <= math.max(p153.x, p155.x) and (p154.x >= math.min(p153.x, p155.x) and p154.y <= math.max(p153.y, p155.y)) then
        v156 = p154.y >= math.min(p153.y, p155.y);
    else
        v156 = false;
    end;

    return v156;
end;

function sign(p157)
    return p157 > 0 and 1 or (p157 < 0 and -1 or 0);
end;

function intersectsPolygon(p158, p159)
    local v160 = p158;

    while p158.i == v160.i or (p158.next.i == v160.i or (p158.i == p159.i or (p158.next.i == p159.i or not intersects(p158, p158.next, v160, p159)))) do
        p158 = p158.next;

        if p158 == v160 then
            return false;
        end;
    end;

    return true;
end;

function locallyInside(p161, p162)
    if area(p161.prev, p161, p161.next) >= 0 then
        return area(p161, p162, p161.prev) < 0 and true or area(p161, p161.next, p162) < 0;
    end;

    local v163;

    if area(p161, p162, p161.next) >= 0 then
        v163 = area(p161, p161.prev, p162) >= 0;
    else
        v163 = false;
    end;

    return v163;
end;

function middleInside(p164, p165)
    local v166 = (p164.x + p165.x) / 2;
    local v167 = (p164.y + p165.y) / 2;
    local v168 = p164;
    local v169 = false;

    while true do
        if v167 < p164.y ~= (v167 < p164.next.y) and (p164.next.y ~= p164.y and v166 < (p164.next.x - p164.x) * (v167 - p164.y) / (p164.next.y - p164.y) + p164.x) then
            v169 = not v169;
        end;

        p164 = p164.next;

        if p164 == v168 then
            return v169;
        end;
    end;
end;

function splitPolygon(p170, p171)
    local v172 = Node(p170.i, p170.x, p170.y);
    local v173 = Node(p171.i, p171.x, p171.y);
    local next = p170.next;
    local prev = p171.prev;
    p170.next = p171;
    p171.prev = p170;
    v172.next = next;
    next.prev = v172;
    v173.next = v172;
    v172.prev = v173;
    prev.next = v173;
    v173.prev = prev;

    return v173;
end;

function insertNode(p174, p175, p176, p177)
    local v178 = Node(p174, p175, p176);

    if not p177 then
        v178.prev = v178;
        v178.next = v178;

        return v178;
    end;

    v178.next = p177.next;
    v178.prev = p177;
    p177.next.prev = v178;
    p177.next = v178;

    return v178;
end;

function removeNode(p179)
    p179.next.prev = p179.prev;
    p179.prev.next = p179.next;

    if p179.prevZ then
        p179.prevZ.nextZ = p179.nextZ;
    end;

    if p179.nextZ then
        p179.nextZ.prevZ = p179.prevZ;
    end;
end;

function Node(p180, p181, p182)
    return {
        i = p180,
        x = p181,
        y = p182,
        prev = nil,
        next = nil,
        z = nil,
        prevZ = nil,
        nextZ = nil,
        steiner = false
    };
end;

function deviation(p183, p184, p185, p186)
    -- upvalues: ZeroArray (copy)
    local v187 = ZeroArray.new(p183);
    local v188 = ZeroArray.new(p184);
    local v189 = ZeroArray.new(p186);
    local v190;

    if v188 then
        v190 = #v188 > 0;
    else
        v190 = v188;
    end;

    local v191 = signedArea(v187, 0, v190 and v188[0] * p185 or #v187, p185);
    local v192 = math.abs(v191);

    if v190 then
        local v193 = #v188;
        local v194 = 0;

        while v194 < v193 do
            local v195 = signedArea(v187, v188[v194] * p185, v194 < v193 - 1 and v188[v194 + 1] * p185 or #v187, p185);
            v192 = v192 - math.abs(v195);
            v194 = v194 + 1;
        end;
    end;

    local v196 = 0;
    local v197 = 0;

    while v196 < #v189 do
        local v198 = v189[v196] * p185;
        local v199 = v189[v196 + 1] * p185;
        local v200 = v189[v196 + 2] * p185;
        v197 = v197 + math.abs((v187[v198] - v187[v200]) * (v187[v199 + 1] - v187[v198 + 1]) - (v187[v198] - v187[v199]) * (v187[v200 + 1] - v187[v198 + 1]));
        v196 = v196 + 3;
    end;

    return v192 == 0 and v197 == 0 and 0 or math.abs((v197 - v192) / v192);
end;

function signedArea(p201, p202, p203, p204)
    local v205 = p203 - p204;
    local v206 = 0;

    while p202 < p203 do
        v206 = v206 + (p201[v205] - p201[p202]) * (p201[p202 + 1] + p201[v205 + 1]);
        v205 = p202;
        p202 = p202 + p204;
    end;

    return v206;
end;

function flatten(p207)
    local v208 = #p207[1][1];
    local v209 = {
        vertices = {},
        holes = {},
        dimensions = v208,
        max = {},
        min = {}
    };
    local v210 = 1;

    for i = 1, #p207 do
        for i2 = 1, #p207[i] do
            for i3 = 1, v208 do
                v209.max[i3] = math.max(v209.max[i3] or (-1 / 0), p207[i][i2][i3]);
                v209.min[i3] = math.min(v209.min[i3] or (1 / 0), p207[i][i2][i3]);
                table.insert(v209.vertices, p207[i][i2][i3]);
            end;
        end;

        if i > 1 then
            v210 = v210 + #p207[i - 1];
            table.insert(v209.holes, v210);
        end;
    end;

    return v209;
end;

return setmetatable({
    Deviation = deviation,
    Flatten = flatten
}, {
    __call = function(p211, ...) -- Line: 850, Name: __call
        return earcut(...);
    end
});