-- Decompiled with Potassium's decompiler.

local u1 = {
    Pretty = true,
    IndentChar = " ",
    IndentSize = 2
};

local function isInt(p2) -- Line: 68
    local v3 = p2 - math.round(p2);

    return math.abs(v3) < 1e-6;
end;

local function roundTo(p4, p5) -- Line: 72
    return math.round(p4 * p5) / p5;
end;

local function formatNum(p6, p7) -- Line: 76
    local v8 = 10 ^ p7;
    local v9 = math.round(p6 * v8) / v8;

    if v9 == 0 and p6 ~= 0 then
        return tostring(p6);
    end;

    local v10, _ = string.format("%." .. p7 .. "f", v9):gsub("%.?0+$", "");

    return (v10 == "" or v10 == "-") and "0" or v10;
end;

local function isValidId(p11) -- Line: 86
    return p11:match("^[a-zA-Z_][a-zA-Z0-9_]*$") == p11;
end;

local function makeIndent(p12, p13, p14) -- Line: 90
    return string.rep(p12, p13 * p14);
end;

local u15 = {};

local function serialize(p16, p17) -- Line: 100
    -- upvalues: u15 (copy)
    local v18 = u15[typeof(p16)];

    if v18 then
        return v18(p16, p17);
    end;

    return `[{typeof(p16)}]`;
end;

u15["nil"] = function(p19, p20) -- Line: 113
    return "nil";
end;

function u15.boolean(p21, p22) -- Line: 117
    return p21 and "true" or "false";
end;

function u15.number(p23, p24) -- Line: 121
    if p23 == (1 / 0) then
        return "math.huge";
    end;

    if p23 == (-1 / 0) then
        return "-math.huge";
    end;

    if p23 ~= p23 then
        return "0/0";
    end;

    local v25;

    if p24.cfg.Pretty then
        local v26 = math.round(p23 * 1000000) / 1000000;

        if v26 == 0 and p23 ~= 0 then
            v25 = tostring(p23);
        else
            local v27, _ = string.format("%." .. 6 .. "f", v26):gsub("%.?0+$", "");
            v25 = (v27 == "" or v27 == "-") and "0" or v27;
        end;

        if not v25 then
            v25 = tostring(p23);
        end;
    else
        v25 = tostring(p23);
    end;

    return v25;
end;

function u15.string(p28, p29) -- Line: 134
    return string.format("%q", p28);
end;

u15["function"] = function(p30) -- Line: 138
    return "[function]";
end;

function u15.Instance(p31) -- Line: 142
    if p31.Parent then
        return `[{p31.ClassName} {p31:GetFullName()}]`;
    end;

    return `[{p31.ClassName}]`;
end;

function u15.table(p32, p33) -- Line: 153
    -- upvalues: u15 (copy)
    local v34 = getmetatable(p32);

    if v34 and v34.__tostring then
        return tostring(p32):gsub("\n", "\n" .. string.rep(p33.cfg.IndentChar, p33.cfg.IndentSize * p33.depth));
    end;

    if p33.seen[p32] then
        return "{...}";
    end;

    p33.seen[p32] = true;
    local v35 = {};
    local v36 = 0;

    for i in pairs(p32) do
        if typeof(i) == "number" then
            local v37 = i - math.round(i);

            if math.abs(v37) < 1e-6 and i > 0 then
                v36 = math.max(v36, i);
            end;
        end;

        table.insert(v35, i);
    end;

    local v38;

    if #v35 == v36 then
        v38 = #v35 > 0;
    else
        v38 = false;
    end;

    for i = 1, v36 do
        if p32[i] == nil then
            v38 = false;
            break;
        end;
    end;

    p33.depth = p33.depth + 1;
    local Pretty = p33.cfg.Pretty;
    local v39 = Pretty and ("\n" .. string.rep(p33.cfg.IndentChar, p33.cfg.IndentSize * p33.depth) or "") or "";
    local v40 = Pretty and (",\n" .. string.rep(p33.cfg.IndentChar, p33.cfg.IndentSize * p33.depth) or ",") or ",";
    local v41 = {};

    if v38 then
        for i = 1, v36 do
            local v42 = p32[i];
            local v43 = u15[typeof(v42)];
            local v44;

            if v43 then
                v44 = v43(v42, p33);
            else
                v44 = `[{typeof(v42)}]`;
            end;

            v41[i] = v44;
        end;
    else
        local order = p33.order;
        local u45 = {};

        for i, v in ipairs(v35) do
            u45[v] = i;
        end;

        local v46 = {};

        for _, v in ipairs(v35) do
            table.insert(v46, { v, p32[v] });
        end;

        if order then
            table.sort(v46, function(p47, p48) -- Line: 205
                -- upvalues: order (copy), u45 (copy)
                local v49 = order[p47[1]] and (order[p47[1]].Index or (1 / 0)) or (1 / 0);
                local v50 = order[p48[1]] and (order[p48[1]].Index or (1 / 0)) or (1 / 0);

                return v49 ~= v50 and v49 < v50 and true or u45[p47[1]] < u45[p48[1]];
            end);
        end;

        for _, v in ipairs(v46) do
            local v51 = v[1];
            local v52 = v[2];
            local v53;

            if order and order[v51] then
                v53 = order[v51].Child or nil;
            else
                v53 = nil;
            end;

            local order2 = p33.order;
            p33.order = v53;

            if typeof(v51) ~= "string" or (v51:match("^[a-zA-Z_][a-zA-Z0-9_]*$") ~= v51 or not v51) then
                local v54 = u15[typeof(v51)];
                local v55;

                if v54 then
                    v55 = v54(v51, p33);
                else
                    v55 = `[{typeof(v51)}]`;
                end;

                v51 = `[{v55}]`;
            end;

            local v56 = u15[typeof(v52)];
            local v57;

            if v56 then
                v57 = v56(v52, p33);
            else
                v57 = `[{typeof(v52)}]`;
            end;

            local v58 = Pretty and `{v51} = {v57}` or `{v51}={v57}`;
            table.insert(v41, v58);
            p33.order = order2;
        end;
    end;

    p33.depth = p33.depth - 1;
    p33.seen[p32] = nil;

    if #v41 == 0 then
        return "{}";
    end;

    if not Pretty then
        return "{" .. table.concat(v41, v40) .. "}";
    end;

    local v59 = "\n" .. string.rep(p33.cfg.IndentChar, p33.cfg.IndentSize * p33.depth);

    return "{" .. v39 .. table.concat(v41, v40) .. "," .. v59 .. "}";
end;

function u15.Color3(p60, p61) -- Line: 243
    -- upvalues: u15 (copy)
    local v62 = p60.R * 255;
    local v63 = p60.G * 255;
    local v64 = p60.B * 255;
    local v65 = "fromRGB";
    local v66 = v62 - math.round(v62);
    local v67, v68, v69;

    if math.abs(v66) < 1e-6 then
        local v70 = v63 - math.round(v63);

        if math.abs(v70) < 1e-6 then
            local v71 = v64 - math.round(v64);

            if math.abs(v71) < 1e-6 then
                v67 = math.round(v62);
                v68 = math.round(v63);
                v69 = math.round(v64);
            else
                v67 = p60.R;
                v68 = p60.G;
                v69 = p60.B;
                v65 = "new";
            end;
        else
            v67 = p60.R;
            v68 = p60.G;
            v69 = p60.B;
            v65 = "new";
        end;
    else
        v67 = p60.R;
        v68 = p60.G;
        v69 = p60.B;
        v65 = "new";
    end;

    if p61.cfg.Pretty then
        local v72 = u15[typeof(v67)];
        local v73;

        if v72 then
            v73 = v72(v67, p61);
        else
            v73 = `[{typeof(v67)}]`;
        end;

        local v74 = u15[typeof(v68)];
        local v75;

        if v74 then
            v75 = v74(v68, p61);
        else
            v75 = `[{typeof(v68)}]`;
        end;

        local v76 = u15[typeof(v69)];
        local v77;

        if v76 then
            v77 = v76(v69, p61);
        else
            v77 = `[{typeof(v69)}]`;
        end;

        return `Color3.{v65}({v73}, {v75}, {v77})`;
    end;

    local v78 = u15[typeof(v67)];
    local v79;

    if v78 then
        v79 = v78(v67, p61);
    else
        v79 = `[{typeof(v67)}]`;
    end;

    local v80 = u15[typeof(v68)];
    local v81;

    if v80 then
        v81 = v80(v68, p61);
    else
        v81 = `[{typeof(v68)}]`;
    end;

    local v82 = u15[typeof(v69)];
    local v83;

    if v82 then
        v83 = v82(v69, p61);
    else
        v83 = `[{typeof(v69)}]`;
    end;

    return `Color3.{v65}({v79},{v81},{v83})`;
end;

function u15.Vector3(p84, p85) -- Line: 257
    -- upvalues: u15 (copy)
    if p84 == Vector3.new(0, 0, 0) then
        return "Vector3.zero";
    end;

    if p84 == Vector3.new(1, 1, 1) then
        return "Vector3.one";
    end;

    if p84 == Vector3.new(1, 0, 0) then
        return "Vector3.xAxis";
    end;

    if p84 == Vector3.new(0, 1, 0) then
        return "Vector3.yAxis";
    end;

    if p84 == Vector3.new(0, 0, 1) then
        return "Vector3.zAxis";
    end;

    if p85.cfg.Pretty then
        local X = p84.X;
        local v86 = u15[typeof(X)];
        local v87;

        if v86 then
            v87 = v86(X, p85);
        else
            v87 = `[{typeof(X)}]`;
        end;

        local Y = p84.Y;
        local v88 = u15[typeof(Y)];
        local v89;

        if v88 then
            v89 = v88(Y, p85);
        else
            v89 = `[{typeof(Y)}]`;
        end;

        local Z = p84.Z;
        local v90 = u15[typeof(Z)];
        local v91;

        if v90 then
            v91 = v90(Z, p85);
        else
            v91 = `[{typeof(Z)}]`;
        end;

        return `Vector3.new({v87}, {v89}, {v91})`;
    end;

    local X = p84.X;
    local v92 = u15[typeof(X)];
    local v93;

    if v92 then
        v93 = v92(X, p85);
    else
        v93 = `[{typeof(X)}]`;
    end;

    local Y = p84.Y;
    local v94 = u15[typeof(Y)];
    local v95;

    if v94 then
        v95 = v94(Y, p85);
    else
        v95 = `[{typeof(Y)}]`;
    end;

    local Z = p84.Z;
    local v96 = u15[typeof(Z)];
    local v97;

    if v96 then
        v97 = v96(Z, p85);
    else
        v97 = `[{typeof(Z)}]`;
    end;

    return `Vector3.new({v93},{v95},{v97})`;
end;

function u15.Vector2(p98, p99) -- Line: 279
    -- upvalues: u15 (copy)
    if p98 == Vector2.zero then
        return "Vector2.zero";
    end;

    if p98 == Vector2.one then
        return "Vector2.one";
    end;

    if p98 == Vector2.xAxis then
        return "Vector2.xAxis";
    end;

    if p98 == Vector2.yAxis then
        return "Vector2.yAxis";
    end;

    if p99.cfg.Pretty then
        local X = p98.X;
        local v100 = u15[typeof(X)];
        local v101;

        if v100 then
            v101 = v100(X, p99);
        else
            v101 = `[{typeof(X)}]`;
        end;

        local Y = p98.Y;
        local v102 = u15[typeof(Y)];
        local v103;

        if v102 then
            v103 = v102(Y, p99);
        else
            v103 = `[{typeof(Y)}]`;
        end;

        return `Vector2.new({v101}, {v103})`;
    end;

    local X = p98.X;
    local v104 = u15[typeof(X)];
    local v105;

    if v104 then
        v105 = v104(X, p99);
    else
        v105 = `[{typeof(X)}]`;
    end;

    local Y = p98.Y;
    local v106 = u15[typeof(Y)];
    local v107;

    if v106 then
        v107 = v106(Y, p99);
    else
        v107 = `[{typeof(Y)}]`;
    end;

    return `Vector2.new({v105},{v107})`;
end;

function u15.CFrame(p108, p109) -- Line: 298
    -- upvalues: u15 (copy)
    if p108 == CFrame.identity then
        return "CFrame.identity";
    end;

    local Position = p108.Position;
    local v110, v111, v112 = p108:ToOrientation();
    local Magnitude = Position.Magnitude;
    local _, _, _, v113, v114, v115, v116, v117, v118, v119, v120, v121 = p108:GetComponents();
    local v122 = (math.abs(v113 - 1) > 1e-6 or (math.abs(v117 - 1) > 1e-6 or (math.abs(v121 - 1) > 1e-6 or (math.abs(v114) > 1e-6 or (math.abs(v115) > 1e-6 or (math.abs(v116) > 1e-6 or (math.abs(v118) > 1e-6 or math.abs(v119) > 1e-6))))))) and true or math.abs(v120) > 1e-6;
    local Pretty = p109.cfg.Pretty;
    local v123, v124, v125, v126, v127, v128, v129, v130, v131, v132, v133;

    if Pretty then
        local v134 = math.round(Position.X * 1000000) / 1000000;
        local v135 = u15[typeof(v134)];
        local v136;

        if v135 then
            v136 = v135(v134, p109);
        else
            v136 = `[{typeof(v134)}]`;
        end;

        local v137 = math.round(Position.Y * 1000000) / 1000000;
        local v138 = u15[typeof(v137)];
        local v139;

        if v138 then
            v139 = v138(v137, p109);
        else
            v139 = `[{typeof(v137)}]`;
        end;

        local v140 = math.round(Position.Z * 1000000) / 1000000;
        local v141 = u15[typeof(v140)];
        local v142;

        if v141 then
            v142 = v141(v140, p109);
        else
            v142 = `[{typeof(v140)}]`;
        end;

        v123 = `CFrame.new({v136}, {v139}, {v142})`;

        if not v123 then
            v124 = "CFrame.new(%*,%*,%*)";
            v125 = Position.X;
            v126 = u15[typeof(v125)];

            if v126 then
                v127 = v126(v125, p109);
            else
                v127 = `[{typeof(v125)}]`;
            end;

            v128 = Position.Y;
            v129 = u15[typeof(v128)];

            if v129 then
                v130 = v129(v128, p109);
            else
                v130 = `[{typeof(v128)}]`;
            end;

            v131 = Position.Z;
            v132 = u15[typeof(v131)];

            if v132 then
                v133 = v132(v131, p109);
            else
                v133 = `[{typeof(v131)}]`;
            end;

            v123 = v124:format(v127, v130, v133);
        end;
    else
        v124 = "CFrame.new(%*,%*,%*)";
        v125 = Position.X;
        v126 = u15[typeof(v125)];

        if v126 then
            v127 = v126(v125, p109);
        else
            v127 = `[{typeof(v125)}]`;
        end;

        v128 = Position.Y;
        v129 = u15[typeof(v128)];

        if v129 then
            v130 = v129(v128, p109);
        else
            v130 = `[{typeof(v128)}]`;
        end;

        v131 = Position.Z;
        v132 = u15[typeof(v131)];

        if v132 then
            v133 = v132(v131, p109);
        else
            v133 = `[{typeof(v131)}]`;
        end;

        v123 = v124:format(v127, v130, v133);
    end;

    local v143, v144, v145, v146, v147, v148, v149, v150;

    if Pretty then
        local v151 = math.deg(v110) * 1000000;
        local v152 = math.round(v151) / 1000000;
        local v153 = u15[typeof(v152)];
        local v154;

        if v153 then
            v154 = v153(v152, p109);
        else
            v154 = `[{typeof(v152)}]`;
        end;

        local v155 = math.deg(v111) * 1000000;
        local v156 = math.round(v155) / 1000000;
        local v157 = u15[typeof(v156)];
        local v158;

        if v157 then
            v158 = v157(v156, p109);
        else
            v158 = `[{typeof(v156)}]`;
        end;

        local v159 = math.deg(v112) * 1000000;
        local v160 = math.round(v159) / 1000000;
        local v161 = u15[typeof(v160)];
        local v162;

        if v161 then
            v162 = v161(v160, p109);
        else
            v162 = `[{typeof(v160)}]`;
        end;

        v143 = `CFrame.fromOrientation(math.rad({v154}), math.rad({v158}), math.rad({v162}))`;

        if not v143 then
            v144 = "CFrame.fromOrientation(%*,%*,%*)";
            v145 = u15[typeof(v110)];

            if v145 then
                v146 = v145(v110, p109);
            else
                v146 = `[{typeof(v110)}]`;
            end;

            v147 = u15[typeof(v111)];

            if v147 then
                v148 = v147(v111, p109);
            else
                v148 = `[{typeof(v111)}]`;
            end;

            v149 = u15[typeof(v112)];

            if v149 then
                v150 = v149(v112, p109);
            else
                v150 = `[{typeof(v112)}]`;
            end;

            v143 = v144:format(v146, v148, v150);
        end;
    else
        v144 = "CFrame.fromOrientation(%*,%*,%*)";
        v145 = u15[typeof(v110)];

        if v145 then
            v146 = v145(v110, p109);
        else
            v146 = `[{typeof(v110)}]`;
        end;

        v147 = u15[typeof(v111)];

        if v147 then
            v148 = v147(v111, p109);
        else
            v148 = `[{typeof(v111)}]`;
        end;

        v149 = u15[typeof(v112)];

        if v149 then
            v150 = v149(v112, p109);
        else
            v150 = `[{typeof(v112)}]`;
        end;

        v143 = v144:format(v146, v148, v150);
    end;

    if not (Magnitude > 1e-6) then
        return v143;
    end;

    if v122 then
        v123 = v123 .. (Pretty and " * " or "*") .. v143 or v123;
    end;

    return v123;
end;

function u15.EnumItem(p163, p164) -- Line: 341
    return `Enum.{tostring(p163.EnumType)}.{p163.Name}`;
end;

local u172 = {
    DEFAULT_CONFIG = u1,

    Pretty = function(p165, p166) -- Line: 353, Name: Pretty
        -- upvalues: u1 (copy), serialize (copy)
        local v167 = {
            Pretty = p166 and p166.Pretty or u1.Pretty,
            IndentChar = p166 and p166.IndentChar or u1.IndentChar,
            IndentSize = p166 and p166.IndentSize or u1.IndentSize,
            Order = p166 and p166.Order or u1.Order
        };

        return serialize(p165, {
            depth = 0,
            cfg = v167,
            order = v167.Order,
            seen = {}
        });
    end,

    Serialize = function(p168, p169) -- Line: 369, Name: Serialize
        -- upvalues: serialize (copy)
        return serialize(p168, {
            depth = 0,
            cfg = p169,
            order = p169.Order,
            seen = {}
        });
    end,

    Default = function(p170) -- Line: 378, Name: Default
        -- upvalues: u1 (copy), serialize (copy)
        local v171 = u1;

        return serialize(p170, {
            depth = 0,
            cfg = v171,
            order = v171.Order,
            seen = {}
        });
    end
};

function u172.DefaultArgs(...) -- Line: 388
    -- upvalues: u172 (copy)
    local v173 = table.pack(...);
    local v174 = {};

    for i = 1, v173.n do
        if i > 1 then
            table.insert(v174, ", ");
        end;

        table.insert(v174, u172.Default(v173[i]));
    end;

    return table.concat(v174);
end;

function u172.DefaultArgsPrefix(...) -- Line: 400
    -- upvalues: u172 (copy)
    local v175 = table.pack(...);
    local v176 = {};

    for i = 1, v175.n do
        table.insert(v176, ", ");
        table.insert(v176, u172.Default(v175[i]));
    end;

    return table.concat(v176);
end;

function u172.CompileOrder(p177) -- Line: 410
    -- upvalues: u172 (copy)
    local v178 = type(p177) == "table";
    assert(v178);
    local v179 = #p177 ~= 0 and true or next(p177) == nil;
    assert(v179);
    local v180 = {};

    for i, v in ipairs(p177) do
        if type(v) == "table" then
            local Key = v.Key;
            local v181 = type(Key) == "string";
            assert(v181);
            v180[Key] = {
                Index = i,
                Child = u172.CompileOrder(v.Value)
            };
        else
            v180[v] = {
                Index = i
            };
        end;
    end;

    return v180;
end;

return table.freeze(u172);