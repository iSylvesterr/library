-- Decompiled with Potassium's decompiler.

local v1 = {};
local NaN = math.NaN;
local u2 = 0;

local function Cross(p3, p4) -- Line: 15
    return Vector3.new(p3.y * p4.z - p3.z * p4.y, p3.z * p4.x - p3.x * p4.z, p3.x * p4.y - p3.y * p4.x);
end;

local function Dot(p5, p6) -- Line: 19
    return p5.x * p6.x + p5.y * p6.y + p5.z * p6.z;
end;

local function PointFaceDistance(p7, p8, p9) -- Line: 23
    local Normal = p9.Normal;
    local v10 = p7 - p8;

    return Normal.x * v10.x + Normal.y * v10.y + Normal.z * v10.z;
end;

local function Normal(p11, p12, p13) -- Line: 27
    local v14 = p12 - p11;
    local v15 = p13 - p11;

    return Vector3.new(v14.y * v15.z - v14.z * v15.y, v14.z * v15.x - v14.x * v15.z, v14.x * v15.y - v14.y * v15.x).Unit;
end;

local function AreCoincident(p16, p17) -- Line: 31
    return (p16 - p17).Magnitude <= 0.0001;
end;

local function AreCollinear(p18, p19, p20) -- Line: 35
    local v21 = p20 - p18;
    local v22 = p20 - p19;

    return Vector3.new(v21.y * v22.z - v21.z * v22.y, v21.z * v22.x - v21.x * v22.z, v21.x * v22.y - v21.y * v22.x).Magnitude <= 0.0001;
end;

local function AreCoplanar(p23, p24, p25, p26) -- Line: 39
    local v27 = p25 - p23;
    local v28 = p25 - p24;
    local v29 = Vector3.new(v27.y * v28.z - v27.z * v28.y, v27.z * v28.x - v27.x * v28.z, v27.x * v28.y - v27.y * v28.x);
    local v30 = p26 - p23;
    local v31 = p26 - p24;
    local v32 = Vector3.new(v30.y * v31.z - v30.z * v31.y, v30.z * v31.x - v30.x * v31.z, v30.x * v31.y - v30.y * v31.x);
    local Magnitude = v29.Magnitude;
    local Magnitude2 = v32.Magnitude;
    local v33;

    if Magnitude <= 0.0001 or Magnitude2 <= 0.0001 then
        v33 = true;
    else
        local v34 = 1 / Magnitude2 * v32;
        local v35 = v34 - Vector3.new(0, 0, 0);
        local v36 = v34 - 1 / Magnitude * v29;
        v33 = Vector3.new(v35.y * v36.z - v35.z * v36.y, v35.z * v36.x - v35.x * v36.z, v35.x * v36.y - v35.y * v36.x).Magnitude <= 0.0001;
    end;

    return v33;
end;

local function Face(p37, p38, p39, p40, p41, p42, p43) -- Line: 49
    return {
        Vertex0 = p37,
        Vertex1 = p38,
        Vertex2 = p39,
        Opposite0 = p40,
        Opposite1 = p41,
        Opposite2 = p42,
        Normal = p43
    };
end;

function FaceEquals(p44, p45)
    local v46;

    if p44.Vertex0 == p45.Vertex0 and (p44.Vertex1 == p45.Vertex1 and (p44.Vertex2 == p45.Vertex2 and (p44.Opposite0 == p45.Opposite0 and (p44.Opposite1 == p45.Opposite1 and p44.Opposite2 == p45.Opposite2)))) then
        v46 = p44.Normal == p45.Normal;
    else
        v46 = false;
    end;

    return v46;
end;

local function PointFace(p47, p48, p49) -- Line: 71
    return {
        Point = p47,
        Face = p48,
        Distance = p49
    };
end;

local function HorizonEdge(p50, p51, p52) -- Line: 79
    return {
        Face = p50,
        Edge0 = p51,
        Edge1 = p52
    };
end;

local function Contains(p53, p54) -- Line: 87
    for _, v in pairs(p53) do
        if p54 == v then
            return true;
        end;
    end;

    return false;
end;

local function Count(p55) -- Line: 96
    return #p55;
end;

local u56 = {};
local u57 = {};
local u58 = {};
local u59 = {};
local u60 = -1;
local u61 = 0;

local function HasEdge(p62, p63, p64) -- Line: 108
    local v65;

    if p62.Vertex0 == p63 and p62.Vertex1 == p64 or p62.Vertex1 == p63 and p62.Vertex2 == p64 then
        v65 = true;
    elseif p62.Vertex2 == p63 then
        v65 = p62.Vertex0 == p64;
    else
        v65 = false;
    end;

    return v65;
end;

local function VerifyFaces(p66) -- Line: 114
    -- upvalues: u56 (ref)
    for i, v in pairs(u56) do
        assert(u56[v.Opposite0] ~= nil, "faces[face.Opposite0] is nil");
        assert(u56[v.Opposite1] ~= nil, "faces[face.Opposite1] is nil");
        assert(u56[v.Opposite2] ~= nil, "faces[face.Opposite2] is nil");
        assert(v.Opposite0 ~= i, "face.Opposite0 should not equal the current face index");
        assert(v.Opposite1 ~= i, "face.Opposite1 should not equal the current face index");
        assert(v.Opposite2 ~= i, "face.Opposite2 should not equal the current face index");
        assert(v.Vertex0 ~= v.Vertex1, "face.Vertex0 should not equal face.Vertex1");
        assert(v.Vertex0 ~= v.Vertex2, "face.Vertex0 should not equal face.Vertex2");
        assert(v.Vertex1 ~= v.Vertex2, "face.Vertex1 should not equal face.Vertex2");
        local v67 = u56[v.Opposite0];
        local Vertex2 = v.Vertex2;
        local Vertex1 = v.Vertex1;
        local v68;

        if v67.Vertex0 == Vertex2 and v67.Vertex1 == Vertex1 or v67.Vertex1 == Vertex2 and v67.Vertex2 == Vertex1 then
            v68 = true;
        elseif v67.Vertex2 == Vertex2 then
            v68 = v67.Vertex0 == Vertex1;
        else
            v68 = false;
        end;

        assert(v68);
        local v69 = u56[v.Opposite1];
        local Vertex0 = v.Vertex0;
        local Vertex22 = v.Vertex2;
        local v70;

        if v69.Vertex0 == Vertex0 and v69.Vertex1 == Vertex22 or v69.Vertex1 == Vertex0 and v69.Vertex2 == Vertex22 then
            v70 = true;
        elseif v69.Vertex2 == Vertex0 then
            v70 = v69.Vertex0 == Vertex22;
        else
            v70 = false;
        end;

        assert(v70);
        local v71 = u56[v.Opposite2];
        local Vertex12 = v.Vertex1;
        local Vertex02 = v.Vertex0;
        local v72;

        if v71.Vertex0 == Vertex12 and v71.Vertex1 == Vertex02 or v71.Vertex1 == Vertex12 and v71.Vertex2 == Vertex02 then
            v72 = true;
        elseif v71.Vertex2 == Vertex12 then
            v72 = v71.Vertex0 == Vertex02;
        else
            v72 = false;
        end;

        assert(v72);
    end;
end;

local function ReassignPoints(p73) -- Line: 161
    -- upvalues: u60 (ref), u57 (ref), u58 (ref), u56 (ref), NaN (copy)
    local v74 = 0;

    while true do
        if v74 >= u60 then
            return;
        end;

        v74 = v74 + 1;
        local v75 = u57[v74];
        local Face2 = v75.Face;
        local v76 = false;

        for _, v in pairs(u58) do
            if Face2 == v then
                v76 = true;
                break;
            end;
        end;

        if v76 then
            local v77 = p73[v75.Point];
            local v78 = false;

            for i, v in pairs(u56) do
                local Normal2 = v.Normal;
                local v79 = v77 - p73[v.Vertex0];
                local v80 = Normal2.x * v79.x + Normal2.y * v79.y + Normal2.z * v79.z;

                if v80 > 0.0001 then
                    v75.Face = i;
                    v75.Distance = v80;
                    u57[v74] = v75;
                    v78 = true;
                    break;
                end;
            end;

            if v78 == false then
                v75.Face = -1;
                v75.Distance = NaN;
                u57[v74] = u57[u60];
                u57[u60] = v75;
                v74 = v74 - 1;
                u60 = u60 - 1;
            end;
        end;
    end;
end;

local function VerifyOpenSet(p81) -- Line: 237
    -- upvalues: u57 (ref), u60 (ref), u56 (ref)
    for i = 1, #u57 do
        if u60 < i then
            local v82 = u57[i].Face == -1;
            local v83 = "Expected openSet[" .. i .. "].Face to be INSIDE when index > openSetTail, got " .. tostring(u57[i].Face);
            assert(v82, v83);
        else
            assert(u57[i].Face ~= -1, "Expected openSet[" .. i .. "].Face not to be INSIDE");
            assert(u57[i].Face ~= -2, "Expected openSet[" .. i .. "].Face not to be UNASSIGNED");
            local Normal2 = u56[u57[i].Face].Normal;
            local v84 = p81[u57[i].Point] - p81[u56[u57[i].Face].Vertex0];
            local v85 = Normal2.x * v84.x + Normal2.y * v84.y + Normal2.z * v84.z > 0;
            local Normal3 = u56[u57[i].Face].Normal;
            local v86 = p81[u57[i].Point] - p81[u56[u57[i].Face].Vertex0];
            local v87 = "Expected point at openSet[" .. i .. "] to be outside its face, but PointFaceDistance returned " .. tostring(Normal3.x * v86.x + Normal3.y * v86.y + Normal3.z * v86.z);
            assert(v85, v87);
        end;
    end;
end;

local function VerifyHorizon() -- Line: 272
    -- upvalues: u59 (ref), u56 (ref)
    for i = 1, #u59 do
        local v88;

        if i == 1 then
            v88 = #u59;
        else
            v88 = i - 1;
        end;

        local v89 = u59[v88].Edge1 == u59[i].Edge0;
        local v90 = `Expected horizon[${v88}].Edge1 to equal horizon[${i}].Edge0, got ${u59[v88].Edge1} and ${u59[i].Edge0}`;
        assert(v89, v90);
        local v91 = u56[u59[i].Face];
        local Edge1 = u59[i].Edge1;
        local Edge0 = u59[i].Edge0;
        local v92;

        if v91.Vertex0 == Edge1 and v91.Vertex1 == Edge0 or v91.Vertex1 == Edge1 and v91.Vertex2 == Edge0 then
            v92 = true;
        elseif v91.Vertex2 == Edge1 then
            v92 = v91.Vertex0 == Edge0;
        else
            v92 = false;
        end;

        assert(v92);
    end;
end;

local function SearchHorizon(p93, p94, p95, p96, p97) -- Line: 293
    -- upvalues: u58 (ref), u56 (ref), u59 (ref), SearchHorizon (copy)
    table.insert(u58, p96);
    local v98, v99, v100, v101, v102;

    if p95 == p97.Opposite0 then
        v98 = p97.Opposite1;
        v99 = p97.Opposite2;
        v100 = p97.Vertex2;
        v101 = p97.Vertex0;
        v102 = p97.Vertex1;
    elseif p95 == p97.Opposite1 then
        v98 = p97.Opposite2;
        v99 = p97.Opposite0;
        v100 = p97.Vertex0;
        v101 = p97.Vertex1;
        v102 = p97.Vertex2;
    else
        v98 = p97.Opposite0;
        v99 = p97.Opposite1;
        v100 = p97.Vertex1;
        v101 = p97.Vertex2;
        v102 = p97.Vertex0;
    end;

    local v103 = v98;
    local v104 = false;

    for _, v in pairs(u58) do
        if v98 == v then
            v104 = true;
            break;
        end;
    end;

    if v104 == false then
        local v105 = u56[v103];
        local Normal2 = v105.Normal;
        local v106 = p94 - p93[v105.Vertex0];

        if Normal2.x * v106.x + Normal2.y * v106.y + Normal2.z * v106.z <= 0 then
            table.insert(u59, {
                Face = v103,
                Edge0 = v100,
                Edge1 = v101
            });
        else
            SearchHorizon(p93, p94, p96, v103, v105);
        end;
    end;

    local v107 = v99;
    local v108 = false;

    for _, v in pairs(u58) do
        if v99 == v then
            v108 = true;
            break;
        end;
    end;

    if v108 == false then
        local v109 = u56[v107];
        local Normal2 = v109.Normal;
        local v110 = p94 - p93[v109.Vertex0];

        if Normal2.x * v110.x + Normal2.y * v110.y + Normal2.z * v110.z <= 0 then
            table.insert(u59, {
                Face = v107,
                Edge0 = v101,
                Edge1 = v102
            });

            return;
        end;

        SearchHorizon(p93, p94, p96, v107, v109);
    end;
end;

local function FindHorizon(p111, p112, p113, p114) -- Line: 383
    -- upvalues: u58 (ref), u59 (ref), u56 (ref), SearchHorizon (copy)
    u58 = {};
    u59 = {};
    table.insert(u58, p113);
    local v115 = u56[p114.Opposite0];
    local Normal2 = v115.Normal;
    local v116 = p112 - p111[v115.Vertex0];

    if Normal2.x * v116.x + Normal2.y * v116.y + Normal2.z * v116.z <= 0 then
        table.insert(u59, {
            Face = p114.Opposite0,
            Edge0 = p114.Vertex1,
            Edge1 = p114.Vertex2
        });
    else
        SearchHorizon(p111, p112, p113, p114.Opposite0, v115);
    end;

    local Opposite1 = p114.Opposite1;
    local v117 = false;

    for _, v in pairs(u58) do
        if Opposite1 == v then
            v117 = true;
            break;
        end;
    end;

    if v117 == false then
        local v118 = u56[p114.Opposite1];
        local Normal3 = v118.Normal;
        local v119 = p112 - p111[v118.Vertex0];

        if Normal3.x * v119.x + Normal3.y * v119.y + Normal3.z * v119.z <= 0 then
            table.insert(u59, {
                Face = p114.Opposite1,
                Edge0 = p114.Vertex2,
                Edge1 = p114.Vertex0
            });
        else
            SearchHorizon(p111, p112, p113, p114.Opposite1, v118);
        end;
    end;

    local Opposite2 = p114.Opposite2;
    local v120 = false;

    for _, v in pairs(u58) do
        if Opposite2 == v then
            v120 = true;
            break;
        end;
    end;

    if v120 == false then
        local v121 = u56[p114.Opposite2];
        local Normal3 = v121.Normal;
        local v122 = p112 - p111[v121.Vertex0];

        if Normal3.x * v122.x + Normal3.y * v122.y + Normal3.z * v122.z <= 0 then
            table.insert(u59, {
                Face = p114.Opposite2,
                Edge0 = p114.Vertex0,
                Edge1 = p114.Vertex1
            });

            return;
        end;

        SearchHorizon(p111, p112, p113, p114.Opposite2, v121);
    end;
end;

local function FindInitialHullIndices(p123) -- Line: 441
    local v124 = #p123;

    for i = 1, v124 - 2 do
        for i2 = i + 1, v124 - 1 do
            local v125 = p123[i];
            local v126 = p123[i2];

            if (v125 - v126).Magnitude > 0.0001 then
                for i3 = i2 + 1, v124 do
                    local v127 = p123[i3];
                    local v128 = v127 - v125;
                    local v129 = v127 - v126;

                    if Vector3.new(v128.y * v129.z - v128.z * v129.y, v128.z * v129.x - v128.x * v129.z, v128.x * v129.y - v128.y * v129.x).Magnitude > 0.0001 then
                        for i4 = i3 + 1, v124 + 1 do
                            local v130 = p123[i4];
                            local v131 = v127 - v125;
                            local v132 = v127 - v126;
                            local v133 = Vector3.new(v131.y * v132.z - v131.z * v132.y, v131.z * v132.x - v131.x * v132.z, v131.x * v132.y - v131.y * v132.x);
                            local v134 = v130 - v125;
                            local v135 = v130 - v126;
                            local v136 = Vector3.new(v134.y * v135.z - v134.z * v135.y, v134.z * v135.x - v134.x * v135.z, v134.x * v135.y - v134.y * v135.x);
                            local Magnitude = v133.Magnitude;
                            local Magnitude2 = v136.Magnitude;
                            local v137;

                            if Magnitude <= 0.0001 or Magnitude2 <= 0.0001 then
                                v137 = true;
                            else
                                local v138 = 1 / Magnitude2 * v136;
                                local v139 = v138 - Vector3.new(0, 0, 0);
                                local v140 = v138 - 1 / Magnitude * v133;
                                v137 = Vector3.new(v139.y * v140.z - v139.z * v140.y, v139.z * v140.x - v139.x * v140.z, v139.x * v140.y - v139.y * v140.x).Magnitude <= 0.0001;
                            end;

                            if not v137 then
                                return i, i2, i3, i4;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    error("Can\'t generate hull, points are coplanar");
end;

local function GenerateInitialHull(p141) -- Line: 478
    -- upvalues: FindInitialHullIndices (copy), u61 (ref), u56 (ref), u57 (ref), NaN (copy), u60 (ref)
    local v142, v143, v144, v145 = FindInitialHullIndices(p141);
    local v146 = p141[v142];
    local v147 = p141[v143];
    local v148 = p141[v145] - v147;
    local v149 = v147 - v146;
    local v150 = p141[v144] - v146;
    local v151 = Vector3.new(v149.y * v150.z - v149.z * v150.y, v149.z * v150.x - v149.x * v150.z, v149.x * v150.y - v149.y * v150.x);
    u61 = 0;

    if v148.x * v151.x + v148.y * v151.y + v148.z * v151.z > 0 then
        local v152 = p141[v142];
        local v153 = p141[v144] - v152;
        local v154 = p141[v143] - v152;
        u56[u61 + 1] = {
            Opposite0 = 4,
            Opposite1 = 2,
            Opposite2 = 3,
            Vertex0 = v142,
            Vertex1 = v144,
            Vertex2 = v143,
            Normal = Vector3.new(v153.y * v154.z - v153.z * v154.y, v153.z * v154.x - v153.x * v154.z, v153.x * v154.y - v153.y * v154.x).Unit
        };
        u61 = u61 + 1;
        local v155 = p141[v142];
        local v156 = p141[v143] - v155;
        local v157 = p141[v145] - v155;
        u56[u61 + 1] = {
            Opposite0 = 4,
            Opposite1 = 3,
            Opposite2 = 1,
            Vertex0 = v142,
            Vertex1 = v143,
            Vertex2 = v145,
            Normal = Vector3.new(v156.y * v157.z - v156.z * v157.y, v156.z * v157.x - v156.x * v157.z, v156.x * v157.y - v156.y * v157.x).Unit
        };
        u61 = u61 + 1;
        local v158 = p141[v142];
        local v159 = p141[v145] - v158;
        local v160 = p141[v144] - v158;
        u56[u61 + 1] = {
            Opposite0 = 4,
            Opposite1 = 1,
            Opposite2 = 2,
            Vertex0 = v142,
            Vertex1 = v145,
            Vertex2 = v144,
            Normal = Vector3.new(v159.y * v160.z - v159.z * v160.y, v159.z * v160.x - v159.x * v160.z, v159.x * v160.y - v159.y * v160.x).Unit
        };
        u61 = u61 + 1;
        local v161 = p141[v143];
        local v162 = p141[v144] - v161;
        local v163 = p141[v145] - v161;
        u56[u61 + 1] = {
            Opposite0 = 3,
            Opposite1 = 2,
            Opposite2 = 1,
            Vertex0 = v143,
            Vertex1 = v144,
            Vertex2 = v145,
            Normal = Vector3.new(v162.y * v163.z - v162.z * v163.y, v162.z * v163.x - v162.x * v163.z, v162.x * v163.y - v162.y * v163.x).Unit
        };
        u61 = u61 + 1;
    else
        local v164 = p141[v142];
        local v165 = p141[v143] - v164;
        local v166 = p141[v144] - v164;
        u56[u61 + 1] = {
            Opposite0 = 4,
            Opposite1 = 3,
            Opposite2 = 2,
            Vertex0 = v142,
            Vertex1 = v143,
            Vertex2 = v144,
            Normal = Vector3.new(v165.y * v166.z - v165.z * v166.y, v165.z * v166.x - v165.x * v166.z, v165.x * v166.y - v165.y * v166.x).Unit
        };
        u61 = u61 + 1;
        local v167 = p141[v142];
        local v168 = p141[v145] - v167;
        local v169 = p141[v143] - v167;
        u56[u61 + 1] = {
            Opposite0 = 4,
            Opposite1 = 1,
            Opposite2 = 3,
            Vertex0 = v142,
            Vertex1 = v145,
            Vertex2 = v143,
            Normal = Vector3.new(v168.y * v169.z - v168.z * v169.y, v168.z * v169.x - v168.x * v169.z, v168.x * v169.y - v168.y * v169.x).Unit
        };
        u61 = u61 + 1;
        local v170 = p141[v142];
        local v171 = p141[v144] - v170;
        local v172 = p141[v145] - v170;
        u56[u61 + 1] = {
            Opposite0 = 4,
            Opposite1 = 2,
            Opposite2 = 1,
            Vertex0 = v142,
            Vertex1 = v144,
            Vertex2 = v145,
            Normal = Vector3.new(v171.y * v172.z - v171.z * v172.y, v171.z * v172.x - v171.x * v172.z, v171.x * v172.y - v171.y * v172.x).Unit
        };
        u61 = u61 + 1;
        local v173 = p141[v143];
        local v174 = p141[v145] - v173;
        local v175 = p141[v144] - v173;
        u56[u61 + 1] = {
            Opposite0 = 3,
            Opposite1 = 1,
            Opposite2 = 2,
            Vertex0 = v143,
            Vertex1 = v145,
            Vertex2 = v144,
            Normal = Vector3.new(v174.y * v175.z - v174.z * v175.y, v174.z * v175.x - v174.x * v175.z, v174.x * v175.y - v174.y * v175.x).Unit
        };
        u61 = u61 + 1;
    end;

    for i = 1, #p141 do
        if i ~= v142 and (i ~= v143 and (i ~= v144 and i ~= v145)) then
            table.insert(u57, {
                Face = -2,
                Distance = 0,
                Point = i
            });
        end;
    end;

    table.insert(u57, {
        Face = -1,
        Point = v142,
        Distance = NaN
    });
    table.insert(u57, {
        Face = -1,
        Point = v143,
        Distance = NaN
    });
    table.insert(u57, {
        Face = -1,
        Point = v144,
        Distance = NaN
    });
    table.insert(u57, {
        Face = -1,
        Point = v145,
        Distance = NaN
    });
    u60 = #u57 - 4;
    local v176 = 0;

    while true do
        if v176 >= u60 then
            return;
        end;

        v176 = v176 + 1;
        local v177 = u57[v176];
        local v178 = false;

        for i = 1, 4 do
            local v179 = u56[i];
            local Normal2 = v179.Normal;
            local v180 = p141[v177.Point] - p141[v179.Vertex0];
            local v181 = Normal2.x * v180.x + Normal2.y * v180.y + Normal2.z * v180.z;

            if v181 > 0 then
                v177.Face = i;
                v177.Distance = v181;
                u57[v176] = v177;
                v178 = true;
                break;
            end;
        end;

        if v178 == false then
            v177.Face = -1;
            v177.Distance = NaN;
            u57[v176] = u57[u60];
            u57[u60] = v177;
            u60 = u60 - 1;
            v176 = v176 - 1;
        end;
    end;
end;

local function ConstructCone(p182, p183) -- Line: 659
    -- upvalues: u58 (ref), u56 (ref), u61 (ref), u59 (ref)
    for _, v in pairs(u58) do
        u56[v] = nil;
    end;

    local v184 = u61;

    for i = 1, #u59 do
        local Edge0 = u59[i].Edge0;
        local Edge1 = u59[i].Edge1;
        local v185;

        if i == #u59 then
            v185 = v184 + 1;
        else
            v185 = v184 + i + 1;
        end;

        local v186;

        if i == 1 then
            v186 = v184 + #u59;
        else
            v186 = v184 + i - 1;
        end;

        local v187 = u61 + 1;
        u61 = u61 + 1;
        local v188 = p182[p183];
        local v189 = p182[Edge0] - v188;
        local v190 = p182[Edge1] - v188;
        u56[v187] = {
            Vertex0 = p183,
            Vertex1 = Edge0,
            Vertex2 = Edge1,
            Opposite0 = u59[i].Face,
            Opposite1 = v185,
            Opposite2 = v186,
            Normal = Vector3.new(v189.y * v190.z - v189.z * v190.y, v189.z * v190.x - v189.x * v190.z, v189.x * v190.y - v189.y * v190.x).Unit
        };
        local v191 = u56[u59[i].Face];

        if v191.Vertex0 == Edge0 then
            v191.Opposite1 = v187;
        elseif v191.Vertex1 == Edge0 then
            v191.Opposite2 = v187;
        else
            v191.Opposite0 = v187;
        end;

        u56[u59[i].Face] = v191;
    end;
end;

local function GrowHull(p192) -- Line: 732
    -- upvalues: u2 (ref), u57 (ref), u60 (ref), FindHorizon (copy), u56 (ref), ConstructCone (copy), ReassignPoints (copy)
    u2 = u2 + 1;
    local Distance = u57[1].Distance;
    local v193 = 1;

    for i = 2, u60 do
        if Distance < u57[i].Distance then
            Distance = u57[i].Distance;
            v193 = i;
        end;
    end;

    FindHorizon(p192, p192[u57[v193].Point], u57[v193].Face, u56[u57[v193].Face]);
    ConstructCone(p192, u57[v193].Point);
    ReassignPoints(p192);
end;

function v1.GenerateHull(p194, p195) -- Line: 771
    -- upvalues: u61 (ref), u60 (ref), u56 (ref), u57 (ref), u58 (ref), u59 (ref), GenerateInitialHull (copy), GrowHull (copy)
    if #p195 < 4 then
        return nil;
    end;

    u61 = 0;
    u60 = -1;
    u56 = {};
    u57 = {};
    u58 = {};
    u59 = {};
    GenerateInitialHull(p195);

    while u60 >= 1 do
        GrowHull(p195);
    end;

    local v196 = {};

    for _, v in pairs(u56) do
        local v197 = {};
        table.insert(v197, p195[v.Vertex0]);
        table.insert(v197, p195[v.Vertex1]);
        table.insert(v197, p195[v.Vertex2]);
        table.insert(v196, v197);
    end;

    return v196;
end;

return v1;