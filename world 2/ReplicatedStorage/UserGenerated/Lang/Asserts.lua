-- Decompiled with Potassium's decompiler.

local function IsEqual(p1, p2) -- Line: 23
    return rawequal(p1, p2) and true or type(p1) == "number" and (type(p2) == "number" and (p1 ~= p1 and p2 ~= p2));
end;

local function IsASCII(p3) -- Line: 37
    for i = 1, string.len(p3) do
        local v4 = string.byte(p3, i);

        if v4 < 32 or v4 > 126 then
            return false;
        end;
    end;

    return true;
end;

local function IsFinite(p5) -- Line: 49
    local v6;

    if p5 == p5 and p5 ~= (1 / 0) then
        v6 = p5 ~= (-1 / 0);
    else
        v6 = false;
    end;

    return v6;
end;

local function IsInteger(p7) -- Line: 55
    local v8;

    if math.floor(p7) == p7 and p7 ~= (1 / 0) then
        v8 = p7 ~= (-1 / 0);
    else
        v8 = false;
    end;

    return v8;
end;

local function LuaString(p9) -- Line: 76
    local v10, _ = string.format("%q", p9):gsub("\n", "n");

    return v10;
end;

local function StringRep(p11) -- Line: 81
    if type(p11) == "string" then
        local v12, _ = string.format("%q", p11):gsub("\n", "n");

        return v12;
    end;

    if typeof(p11) == "Instance" then
        return p11:GetFullName();
    end;

    return tostring(p11);
end;

local function SafeKeyStringRep(p13) -- Line: 90
    if type(p13) == "number" or type(p13) == "boolean" then
        return `{p13}`;
    end;

    if type(p13) ~= "string" then
        if typeof(p13) == "Instance" then
            return p13:GetFullName();
        end;

        return `UnknownType({typeof(p13)})`;
    end;

    local v14 = utf8.len(p13);

    if not v14 then
        return "InvalidUTF8";
    end;

    local v15 = true;

    for i = 1, string.len(p13) do
        local v16 = string.byte(p13, i);

        if v16 < 32 or v16 > 126 then
            v15 = false;
            break;
        end;
    end;

    if not v15 then
        return "NonASCII";
    end;

    if v14 <= 30 then
        local v17, _ = string.format("%q", p13):gsub("\n", "n");

        return v17;
    end;

    local v18 = string.sub(p13, 1, 30);
    local v19, _ = string.format("%q", v18):gsub("\n", "n");

    return `{v19}...{v14 - 30}`;
end;

local function StripErrorSource(p20) -- Line: 111
    local v21 = tostring(p20);
    local v22, v23 = string.match(v21, "^(.*:%d+): (.+)$");

    if v22 then
        v21 = v23 or v21;
    end;

    return v21;
end;

local function ParseError(p24) -- Line: 122
    local v25 = tostring(p24);
    local v26, v27 = string.match(v25, "^(.*:%d+): (.+)$");

    if v26 then
        v25 = v27 or v25;
    end;

    local v28, v29 = string.match(v25, "^(.+) $(%[.+)$");

    if v28 then
        if not v29 then
            v28 = v25;
        end;
    else
        v28 = v25;
    end;

    return v28, v29;
end;

local function MakeError(p30, p31) -- Line: 134
    return `{p30} ${p31}`;
end;

local u53 = {
    IsCFrameFinite = function(p32) -- Line: 59, Name: IsCFrameFinite
        local v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44 = p32:GetComponents();
        local v45 = v33 + v34 + v35 + v36 + v37 + v38 + v39 + v40 + v41 + v42 + v43 + v44;
        local v46;

        if v45 == v45 and v45 ~= (1 / 0) then
            v46 = v45 ~= (-1 / 0);
        else
            v46 = false;
        end;

        return v46;
    end,

    IsVector2Finite = function(p47) -- Line: 67, Name: IsVector2Finite
        local v48 = p47.X + p47.Y;
        local v49;

        if v48 == v48 and v48 ~= (1 / 0) then
            v49 = v48 ~= (-1 / 0);
        else
            v49 = false;
        end;

        return v49;
    end,

    IsVector3Finite = function(p50) -- Line: 71, Name: IsVector3Finite
        local v51 = p50.X + p50.Y + p50.Z;
        local v52;

        if v51 == v51 and v51 ~= (1 / 0) then
            v52 = v51 ~= (-1 / 0);
        else
            v52 = false;
        end;

        return v52;
    end
};

function u53.Array(u54) -- Line: 145
    -- upvalues: u53 (copy), SafeKeyStringRep (copy)
    u53.Function(u54);

    return function(p55) -- Line: 149
        -- upvalues: SafeKeyStringRep (ref), u54 (copy)
        if type(p55) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p55) ~= nil then
            error("metatable", 2);
        end;

        local v56 = rawlen(p55);
        local v57 = 0;

        for i, v in pairs(p55) do
            v57 = v57 + 1;

            if i ~= v57 then
                error(`IndexMismatch ${`[{SafeKeyStringRep(i)}]`}`, 2);
            end;

            if v56 < v57 then
                error(`IndexOverflow ${`[{v57}]`}`, 2);
            end;

            local success, result = pcall(u54, v);

            if not success then
                local v58 = tostring(result);
                local v59, v60 = string.match(v58, "^(.*:%d+): (.+)$");

                if v59 then
                    v58 = v60 or v58;
                end;

                local v61, v62 = string.match(v58, "^(.+) $(%[.+)$");

                if v61 then
                    if not v62 then
                        v61 = v58;
                    end;
                else
                    v61 = v58;
                end;

                error(`{v61} ${`[{v57}]{v62 or ""}`}`, 2);
            end;
        end;

        if v56 ~= v57 then
            error("LengthMismatch", 2);
        end;

        return p55;
    end;
end;

function u53.ArrayCoerce(u63) -- Line: 179
    -- upvalues: u53 (copy), SafeKeyStringRep (copy)
    u53.Function(u63);

    return function(p64) -- Line: 183
        -- upvalues: SafeKeyStringRep (ref), u63 (copy)
        if type(p64) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p64) ~= nil then
            error("metatable", 2);
        end;

        local v65 = rawlen(p64);
        local v66 = 0;
        local v67 = {};

        for i, v in pairs(p64) do
            v66 = v66 + 1;

            if i ~= v66 then
                error(`IndexMismatch ${`[{SafeKeyStringRep(i)}]`}`, 2);
            end;

            if v65 < v66 then
                error(`IndexOverflow ${`[{v66}]`}`, 2);
            end;

            local success, result = pcall(u63, v);

            if not success then
                local v68 = tostring(result);
                local v69, v70 = string.match(v68, "^(.*:%d+): (.+)$");

                if v69 then
                    v68 = v70 or v68;
                end;

                local v71, v72 = string.match(v68, "^(.+) $(%[.+)$");

                if v71 then
                    if not v72 then
                        v71 = v68;
                    end;
                else
                    v71 = v68;
                end;

                error(`{v71} ${`[{v66}]{v72 or ""}`}`, 2);
            end;

            v67[i] = result;
        end;

        if v65 ~= v66 then
            error("LengthMismatch", 2);
        end;

        return v67;
    end;
end;

function u53.UniqueArray(u73) -- Line: 215
    -- upvalues: u53 (copy), SafeKeyStringRep (copy)
    u53.Function(u73);

    return function(p74) -- Line: 219
        -- upvalues: SafeKeyStringRep (ref), u73 (copy)
        if type(p74) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p74) ~= nil then
            error("metatable", 2);
        end;

        local v75 = rawlen(p74);
        local v76 = 0;
        local v77 = {};

        for i, v in pairs(p74) do
            v76 = v76 + 1;

            if i ~= v76 then
                error(`IndexMismatch ${`[{SafeKeyStringRep(i)}]`}`, 2);
            end;

            if v75 < v76 then
                error(`IndexOverflow ${`[{v76}]`}`, 2);
            end;

            if v77[v] then
                error(`UniqueArray ${`[{v76}]`}`, 2);
            end;

            v77[v] = true;

            if not v77[v] then
                error(`InvalidKey ${`[{v76}]`}`, 2);
            end;

            local success, result = pcall(u73, v);

            if not success then
                local v78 = tostring(result);
                local v79, v80 = string.match(v78, "^(.*:%d+): (.+)$");

                if v79 then
                    v78 = v80 or v78;
                end;

                local v81, v82 = string.match(v78, "^(.+) $(%[.+)$");

                if v81 then
                    if not v82 then
                        v81 = v78;
                    end;
                else
                    v81 = v78;
                end;

                error(`{v81} ${`[{v76}]{v82 or ""}`}`, 2);
            end;
        end;

        if v75 ~= v76 then
            error("LengthMismatch", 2);
        end;

        return p74;
    end;
end;

function u53.UniqueArrayCoerce(u83) -- Line: 257
    -- upvalues: u53 (copy), SafeKeyStringRep (copy)
    u53.Function(u83);

    return function(p84) -- Line: 261
        -- upvalues: SafeKeyStringRep (ref), u83 (copy)
        if type(p84) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p84) ~= nil then
            error("metatable", 2);
        end;

        local v85 = rawlen(p84);
        local v86 = 0;
        local v87 = {};
        local v88 = {};

        for i, v in pairs(p84) do
            v86 = v86 + 1;

            if i ~= v86 then
                error(`IndexMismatch ${`[{SafeKeyStringRep(i)}]`}`, 2);
            end;

            if v85 < v86 then
                error(`IndexOverflow ${`[{v86}]`}`, 2);
            end;

            if v87[v] then
                error(`UniqueArray ${`[{v86}]`}`, 2);
            end;

            v87[v] = true;

            if not v87[v] then
                error(`InvalidKey ${`[{v86}]`}`, 2);
            end;

            local success, result = pcall(u83, v);

            if not success then
                local v89 = tostring(result);
                local v90, v91 = string.match(v89, "^(.*:%d+): (.+)$");

                if v90 then
                    v89 = v91 or v89;
                end;

                local v92, v93 = string.match(v89, "^(.+) $(%[.+)$");

                if v92 then
                    if not v93 then
                        v92 = v89;
                    end;
                else
                    v92 = v89;
                end;

                error(`{v92} ${`[{v86}]{v93 or ""}`}`, 2);
            end;

            v88[i] = result;
        end;

        if v85 ~= v86 then
            error("LengthMismatch", 2);
        end;

        return v88;
    end;
end;

function u53.Map(u94, u95, p96) -- Line: 302
    -- upvalues: u53 (copy), SafeKeyStringRep (copy)
    u53.Function(u94);
    u53.Function(u95);
    u53.Optional(u53.IntegerPositive)(p96);
    local u97 = p96 or (1 / 0);

    return function(p98) -- Line: 312
        -- upvalues: u97 (copy), u94 (copy), SafeKeyStringRep (ref), u95 (copy)
        if type(p98) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p98) ~= nil then
            error("metatable", 2);
        end;

        local v99 = 0;

        for i, v in pairs(p98) do
            v99 = v99 + 1;

            if u97 < v99 then
                error(`LengthLimit({u97})`, 2);
            end;

            local success, result = pcall(u94, i);

            if not success then
                local v100 = tostring(result);
                local v101, v102 = string.match(v100, "^(.*:%d+): (.+)$");

                if v101 then
                    v100 = v102 or v100;
                end;

                local v103, v104 = string.match(v100, "^(.+) $(%[.+)$");

                if v103 then
                    if not v104 then
                        v103 = v100;
                    end;
                else
                    v103 = v100;
                end;

                error(`{v103} ${`<{SafeKeyStringRep(i)}>{v104 or ""}`}`, 2);
            end;

            local success2, result2 = pcall(u95, v);

            if not success2 then
                local v105 = tostring(result2);
                local v106, v107 = string.match(v105, "^(.*:%d+): (.+)$");

                if v106 then
                    v105 = v107 or v105;
                end;

                local v108, v109 = string.match(v105, "^(.+) $(%[.+)$");

                if v108 then
                    if not v109 then
                        v108 = v105;
                    end;
                else
                    v108 = v105;
                end;

                error(`{v108} ${`[{SafeKeyStringRep(i)}]{v109 or ""}`}`, 2);
            end;
        end;

        return p98;
    end;
end;

function u53.MapCoerce(u110, u111, p112) -- Line: 347
    -- upvalues: u53 (copy), SafeKeyStringRep (copy)
    u53.Function(u110);
    u53.Function(u111);
    u53.Optional(u53.IntegerPositive)(p112);
    local u113 = p112 or (1 / 0);

    return function(p114) -- Line: 357
        -- upvalues: u113 (copy), u110 (copy), SafeKeyStringRep (ref), u111 (copy)
        if type(p114) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p114) ~= nil then
            error("metatable", 2);
        end;

        local v115 = 0;
        local v116 = {};

        for i, v in pairs(p114) do
            v115 = v115 + 1;

            if u113 < v115 then
                error(`LengthLimit({u113})`, 2);
            end;

            local success, result = pcall(u110, i);

            if not success then
                local v117 = tostring(result);
                local v118, v119 = string.match(v117, "^(.*:%d+): (.+)$");

                if v118 then
                    v117 = v119 or v117;
                end;

                local v120, v121 = string.match(v117, "^(.+) $(%[.+)$");

                if v120 then
                    if not v121 then
                        v120 = v117;
                    end;
                else
                    v120 = v117;
                end;

                error(`{v120} ${`<{SafeKeyStringRep(i)}>{v121 or ""}`}`, 2);
            end;

            local success2, result2 = pcall(u111, v);

            if not success2 then
                local v122 = tostring(result2);
                local v123, v124 = string.match(v122, "^(.*:%d+): (.+)$");

                if v123 then
                    v122 = v124 or v122;
                end;

                local v125, v126 = string.match(v122, "^(.+) $(%[.+)$");

                if v125 then
                    if not v126 then
                        v125 = v122;
                    end;
                else
                    v125 = v122;
                end;

                error(`{v125} ${`[{SafeKeyStringRep(i)}]{v126 or ""}`}`, 2);
            end;

            v116[result] = result2;
        end;

        return v116;
    end;
end;

function u53.Table(p127) -- Line: 394
    -- upvalues: u53 (copy), SafeKeyStringRep (copy)
    u53.NoMetatable(p127);

    for _, v in pairs(p127) do
        u53.Function(v);
    end;

    local u128 = table.clone(p127);

    return function(p129) -- Line: 403
        -- upvalues: u128 (ref), SafeKeyStringRep (ref)
        if type(p129) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p129) ~= nil then
            error("metatable", 2);
        end;

        if rawlen(u128) ~= rawlen(p129) then
            error("LengthMismatch", 2);
        end;

        for i, _ in pairs(p129) do
            if not u128[i] then
                error(`UnknownKey ${`[{SafeKeyStringRep(i)}]`}`, 2);
            end;
        end;

        for i, v in pairs(u128) do
            local success, result = pcall(v, p129[i]);

            if not success then
                local v130 = tostring(result);
                local v131, v132 = string.match(v130, "^(.*:%d+): (.+)$");

                if v131 then
                    v130 = v132 or v130;
                end;

                local v133, v134 = string.match(v130, "^(.+) $(%[.+)$");

                if v133 then
                    if not v134 then
                        v133 = v130;
                    end;
                else
                    v133 = v130;
                end;

                local v135 = error;
                local v136;

                if type(i) == "string" then
                    local v137;
                    v136, v137 = string.format("%q", i):gsub("\n", "n");
                elseif typeof(i) == "Instance" then
                    v136 = i:GetFullName();
                else
                    v136 = tostring(i);
                end;

                v135(`{v133} ${`[{v136}]{v134 or ""}`}`, 2);
            end;
        end;

        return p129;
    end;
end;

function u53.TablePermissive(p138) -- Line: 431
    -- upvalues: u53 (copy)
    u53.NoMetatable(p138);

    for _, v in pairs(p138) do
        u53.Function(v);
    end;

    local u139 = table.clone(p138);

    return function(p140) -- Line: 440
        -- upvalues: u139 (ref)
        if type(p140) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p140) ~= nil then
            error("metatable", 2);
        end;

        if rawlen(u139) ~= rawlen(p140) then
            error("LengthMismatch", 2);
        end;

        for i, v in pairs(u139) do
            local success, result = pcall(v, p140[i]);

            if not success then
                local v141 = tostring(result);
                local v142, v143 = string.match(v141, "^(.*:%d+): (.+)$");

                if v142 then
                    v141 = v143 or v141;
                end;

                local v144, v145 = string.match(v141, "^(.+) $(%[.+)$");

                if v144 then
                    if not v145 then
                        v144 = v141;
                    end;
                else
                    v144 = v141;
                end;

                local v146 = error;
                local v147;

                if type(i) == "string" then
                    local v148;
                    v147, v148 = string.format("%q", i):gsub("\n", "n");
                elseif typeof(i) == "Instance" then
                    v147 = i:GetFullName();
                else
                    v147 = tostring(i);
                end;

                v146(`{v144} ${`[{v147}]{v145 or ""}`}`, 2);
            end;
        end;

        return p140;
    end;
end;

function u53.TableCoerce(p149) -- Line: 469
    -- upvalues: u53 (copy), SafeKeyStringRep (copy)
    u53.NoMetatable(p149);

    for _, v in pairs(p149) do
        u53.Function(v);
    end;

    local u150 = table.clone(p149);

    return function(p151) -- Line: 478
        -- upvalues: u150 (ref), SafeKeyStringRep (ref)
        if type(p151) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p151) ~= nil then
            error("metatable", 2);
        end;

        if rawlen(u150) ~= rawlen(p151) then
            error("LengthMismatch", 2);
        end;

        local v152 = {};

        for i, _ in pairs(p151) do
            if not u150[i] then
                error(`UnknownKey ${`[{SafeKeyStringRep(i)}]`}`, 2);
            end;
        end;

        for i, v in pairs(u150) do
            local success, result = pcall(v, p151[i]);

            if not success then
                local v153 = tostring(result);
                local v154, v155 = string.match(v153, "^(.*:%d+): (.+)$");

                if v154 then
                    v153 = v155 or v153;
                end;

                local v156, v157 = string.match(v153, "^(.+) $(%[.+)$");

                if v156 then
                    if not v157 then
                        v156 = v153;
                    end;
                else
                    v156 = v153;
                end;

                local v158 = error;
                local v159;

                if type(i) == "string" then
                    local v160;
                    v159, v160 = string.format("%q", i):gsub("\n", "n");
                elseif typeof(i) == "Instance" then
                    v159 = i:GetFullName();
                else
                    v159 = tostring(i);
                end;

                v158(`{v156} ${`[{v159}]{v157 or ""}`}`, 2);
            end;

            v152[i] = result;
        end;

        return v152;
    end;
end;

function u53.IsASCII(p161) -- Line: 508
    local v162;

    if type(p161) == "string" then
        for i = 1, string.len(p161) do
            local v163 = string.byte(p161, i);

            if v163 < 32 or v163 > 126 then
                return false;
            end;
        end;

        v162 = true;
    else
        v162 = false;
    end;

    return v162;
end;

function u53.IsFinite(p164) -- Line: 511
    local v165;

    if type(p164) == "number" and (p164 == p164 and p164 ~= (1 / 0)) then
        v165 = p164 ~= (-1 / 0);
    else
        v165 = false;
    end;

    return v165;
end;

function u53.IsInteger(p166) -- Line: 514
    local v167;

    if type(p166) == "number" and (math.floor(p166) == p166 and p166 ~= (1 / 0)) then
        v167 = p166 ~= (-1 / 0);
    else
        v167 = false;
    end;

    return v167;
end;

function u53.IsCFrameFinite(p168) -- Line: 517
    local v169;

    if typeof(p168) == "CFrame" then
        local v170, v171, v172, v173, v174, v175, v176, v177, v178, v179, v180, v181 = p168:GetComponents();
        local v182 = v170 + v171 + v172 + v173 + v174 + v175 + v176 + v177 + v178 + v179 + v180 + v181;

        if v182 == v182 and v182 ~= (1 / 0) then
            v169 = v182 ~= (-1 / 0);
        else
            v169 = false;
        end;
    else
        v169 = false;
    end;

    return v169;
end;

function u53.IsVector2Finite(p183) -- Line: 520
    local v184;

    if typeof(p183) == "Vector2" then
        local v185 = p183.X + p183.Y;

        if v185 == v185 and v185 ~= (1 / 0) then
            v184 = v185 ~= (-1 / 0);
        else
            v184 = false;
        end;
    else
        v184 = false;
    end;

    return v184;
end;

function u53.Optional(u186) -- Line: 524
    if type(u186) ~= "function" then
        error("function", 2);
    end;

    return function(p187) -- Line: 526
        -- upvalues: u186 (copy)
        if p187 == nil then
            return nil;
        end;

        local success, result = pcall(u186, p187);

        if not success then
            local v188 = error;
            local v189 = tostring(result);
            local v190, v191 = string.match(v189, "^(.*:%d+): (.+)$");

            if v190 then
                v189 = v191 or v189;
            end;

            v188(v189, 2);
        end;

        return result;
    end;
end;

function u53.Default(u192, p193) -- Line: 538
    if type(u192) ~= "function" then
        error("function", 2);
    end;

    local u194 = u192(p193);

    return function(p195) -- Line: 544
        -- upvalues: u194 (copy), u192 (copy)
        if p195 == nil then
            return u194;
        end;

        local success, result = pcall(u192, p195);

        if not success then
            local v196 = error;
            local v197 = tostring(result);
            local v198, v199 = string.match(v197, "^(.*:%d+): (.+)$");

            if v198 then
                v197 = v199 or v197;
            end;

            v196(v197, 2);
        end;

        return result;
    end;
end;

function u53.AnyOf(...) -- Line: 556
    local u200 = table.pack(...);

    for i = 1, u200.n do
        local v201 = type(u200[i]) == "function";
        assert(v201, "function");
    end;

    assert(u200.n > 0);

    return function(p202) -- Line: 562
        -- upvalues: u200 (copy)
        for i = 1, u200.n do
            local success, result = pcall(u200[i], p202);

            if success then
                return result;
            end;
        end;

        error("AnyOf", 2);
    end;
end;

function u53.AllOf(...) -- Line: 573
    local u203 = table.pack(...);

    for i = 1, u203.n do
        local v204 = type(u203[i]) == "function";
        assert(v204, "function");
    end;

    assert(u203.n > 0);

    return function(p205) -- Line: 579
        -- upvalues: u203 (copy)
        for i = 1, u203.n do
            local success, result = pcall(u203[i], p205);

            if not success then
                local v206 = error;
                local v207 = tostring(result);
                local v208, v209 = string.match(v207, "^(.*:%d+): (.+)$");

                if v208 then
                    v207 = v209 or v207;
                end;

                v206(v207, 2);
            end;
        end;

        return p205;
    end;
end;

function u53.AnyTable(p210) -- Line: 591
    if type(p210) ~= "table" then
        error("table", 2);
    end;

    return p210;
end;

function u53.Number(p211) -- Line: 597
    if type(p211) ~= "number" then
        error("number", 2);
    end;

    return p211;
end;

function u53.Boolean(p212) -- Line: 603
    if type(p212) ~= "boolean" then
        error("boolean", 2);
    end;

    return p212;
end;

function u53.Buffer(p213) -- Line: 609
    if type(p213) ~= "buffer" then
        error("buffer", 2);
    end;

    return p213;
end;

function u53.Function(p214) -- Line: 615
    if type(p214) ~= "function" then
        error("function", 2);
    end;

    return p214;
end;

function u53.Thread(p215) -- Line: 621
    if type(p215) ~= "thread" then
        error("thread", 2);
    end;

    return p215;
end;

function u53.String(p216) -- Line: 628
    if type(p216) ~= "string" then
        error("string", 2);
    end;

    if not utf8.len(p216) then
        error("UTF8", 2);
    end;

    return p216;
end;

function u53.RawString(p217) -- Line: 638
    if type(p217) ~= "string" then
        error("string", 2);
    end;

    return p217;
end;

function u53.Any(p218) -- Line: 645
    return p218;
end;

function u53.Equals(u219) -- Line: 649
    return function(p220) -- Line: 650
        -- upvalues: u219 (copy)
        local v221 = u219;

        if not rawequal(p220, v221) and (type(p220) ~= "number" or (type(v221) ~= "number" or (p220 == p220 or v221 == v221))) then
            error("Equals", 2);
        end;

        return p220;
    end;
end;

function u53.Set(p222) -- Line: 656
    -- upvalues: u53 (copy)
    u53.Array(u53.Any);
    local u223 = {};

    for _, v in ipairs(p222) do
        if v ~= v then
            error("InvalidKeyNaN", 2);
        end;

        u223[v] = true;

        if not u223[v] then
            error("InvalidKey", 2);
        end;
    end;

    return function(p224) -- Line: 668
        -- upvalues: u223 (copy)
        if not u223[p224] then
            error("Set", 2);
        end;

        return p224;
    end;
end;

function u53.Pattern(u225) -- Line: 674
    -- upvalues: u53 (copy)
    u53.String(u225);

    return function(p226) -- Line: 676
        -- upvalues: u225 (copy)
        if type(p226) ~= "string" then
            error("string", 2);
        end;

        if not utf8.len(p226) then
            error("UTF8", 2);
        end;

        if not string.find(p226, u225) then
            error("Pattern", 2);
        end;

        return p226;
    end;
end;

function u53.NoMetatable(p227) -- Line: 684
    if type(p227) ~= "table" then
        error("table", 2);
    end;

    if getmetatable(p227) ~= nil then
        error("metatable", 2);
    end;

    return p227;
end;

function u53.Finite(p228) -- Line: 691
    if type(p228) ~= "number" then
        error("number", 2);
    end;

    local v229;

    if p228 == p228 and p228 ~= (1 / 0) then
        v229 = p228 ~= (-1 / 0);
    else
        v229 = false;
    end;

    if not v229 then
        error("Finite", 2);
    end;

    return p228;
end;

function u53.FinitePositive(p230) -- Line: 698
    if type(p230) ~= "number" then
        error("number", 2);
    end;

    local v231;

    if p230 == p230 and p230 ~= (1 / 0) then
        v231 = p230 ~= (-1 / 0);
    else
        v231 = false;
    end;

    if not v231 then
        error("Finite", 2);
    end;

    if p230 <= 0 then
        error("Positive", 2);
    end;

    return p230;
end;

function u53.FiniteNonNegative(p232) -- Line: 706
    if type(p232) ~= "number" then
        error("number", 2);
    end;

    local v233;

    if p232 == p232 and p232 ~= (1 / 0) then
        v233 = p232 ~= (-1 / 0);
    else
        v233 = false;
    end;

    if not v233 then
        error("Finite", 2);
    end;

    if p232 < 0 then
        error("NonNegative", 2);
    end;

    return p232;
end;

function u53.Positive(p234) -- Line: 714
    if type(p234) ~= "number" then
        error("number", 2);
    end;

    if p234 <= 0 then
        error("Positive", 2);
    end;

    return p234;
end;

function u53.NonNegative(p235) -- Line: 721
    if type(p235) ~= "number" then
        error("number", 2);
    end;

    if p235 < 0 then
        error("NonNegative", 2);
    end;

    return p235;
end;

function u53.Real(p236) -- Line: 728
    if type(p236) ~= "number" then
        error("number", 2);
    end;

    if p236 ~= p236 then
        error("Real", 2);
    end;

    return p236;
end;

function u53.Range(u237, u238) -- Line: 735
    -- upvalues: u53 (copy)
    u53.Real(u237);
    u53.Real(u238);

    if u237 > u238 then
        error("a<=b", 2);
    end;

    return function(p239) -- Line: 739
        -- upvalues: u237 (copy), u238 (copy)
        if type(p239) ~= "number" then
            error("number", 2);
        end;

        if u237 > p239 or p239 > u238 then
            error(`Range({u237},{u238})`, 2);
        end;

        return p239;
    end;
end;

function u53.Integer(p240) -- Line: 747
    if type(p240) ~= "number" then
        error("number", 2);
    end;

    local v241;

    if math.floor(p240) == p240 and p240 ~= (1 / 0) then
        v241 = p240 ~= (-1 / 0);
    else
        v241 = false;
    end;

    if not v241 then
        error("Integer", 2);
    end;

    return p240;
end;

function u53.Unsigned32(p242) -- Line: 754
    if bit32.bor(p242, 0) ~= p242 then
        error("Unsigned32", 2);
    end;

    return p242;
end;

function u53.IntegerPositive(p243) -- Line: 761
    if type(p243) ~= "number" then
        error("number", 2);
    end;

    local v244;

    if math.floor(p243) == p243 and p243 ~= (1 / 0) then
        v244 = p243 ~= (-1 / 0);
    else
        v244 = false;
    end;

    if not v244 then
        error("Integer", 2);
    end;

    if p243 < 1 then
        error("Positive", 2);
    end;

    return p243;
end;

function u53.Index(p245) -- Line: 769
    if type(p245) ~= "number" then
        error("number", 2);
    end;

    local v246;

    if math.floor(p245) == p245 and p245 ~= (1 / 0) then
        v246 = p245 ~= (-1 / 0);
    else
        v246 = false;
    end;

    if not v246 then
        error("Integer", 2);
    end;

    if p245 < 1 then
        error("Positive", 2);
    end;

    return p245;
end;

function u53.IntegerNonNegative(p247) -- Line: 777
    if type(p247) ~= "number" then
        error("number", 2);
    end;

    local v248;

    if math.floor(p247) == p247 and p247 ~= (1 / 0) then
        v248 = p247 ~= (-1 / 0);
    else
        v248 = false;
    end;

    if not v248 then
        error("Integer", 2);
    end;

    if p247 < 0 then
        error("NonNegative", 2);
    end;

    return p247;
end;

function u53.IntegerRange(u249, u250) -- Line: 785
    -- upvalues: u53 (copy)
    u53.Integer(u249);
    u53.Integer(u250);

    if u249 > u250 then
        error("a<=b", 2);
    end;

    return function(p251) -- Line: 789
        -- upvalues: u249 (copy), u250 (copy)
        if type(p251) ~= "number" then
            error("number", 2);
        end;

        local v252;

        if math.floor(p251) == p251 and p251 ~= (1 / 0) then
            v252 = p251 ~= (-1 / 0);
        else
            v252 = false;
        end;

        if not v252 then
            error("Integer", 2);
        end;

        if u249 > p251 or p251 > u250 then
            error(`Range({u249},{u250})`, 2);
        end;

        return p251;
    end;
end;

function u53.UInt32() -- Line: 797
    return function(p253) -- Line: 798
        if type(p253) ~= "number" then
            error("number", 2);
        end;

        if bit32.bor(p253, 0) ~= p253 then
            error("UInt32", 2);
        end;

        return p253;
    end;
end;

function u53.StringRange(u254, u255) -- Line: 806
    -- upvalues: u53 (copy)
    u53.Integer(u254);
    u53.Integer(u255);

    if u254 > u255 then
        error("a<=b", 2);
    end;

    return function(p256) -- Line: 810
        -- upvalues: u254 (copy), u255 (copy)
        if type(p256) ~= "string" then
            error("string", 2);
        end;

        local v257 = utf8.len(p256);

        if not v257 then
            error("UTF8", 2);
        end;

        if u254 > v257 or v257 > u255 then
            error(`StringRange({u254},{u255})`, 2);
        end;

        return p256;
    end;
end;

function u53.ASCII(p258) -- Line: 823
    if type(p258) ~= "string" then
        error("string", 2);
    end;

    for i = 1, string.len(p258) do
        local v259 = string.byte(p258, i);

        if v259 < 32 or v259 > 126 then
            error("ASCII", 2);
        end;
    end;

    return p258;
end;

function u53.ASCIIRange(u260, u261) -- Line: 835
    -- upvalues: u53 (copy)
    u53.Integer(u260);
    u53.Integer(u261);

    if u260 > u261 then
        error("a<=b", 2);
    end;

    return function(p262) -- Line: 839
        -- upvalues: u260 (copy), u261 (copy)
        if type(p262) ~= "string" then
            error("string", 2);
        end;

        local v263 = string.len(p262);

        if u260 > v263 or v263 > u261 then
            error(`ASCIIRange({u260},{u261})`, 2);
        end;

        for i = 1, v263 do
            local v264 = string.byte(p262, i);

            if v264 < 32 or v264 > 126 then
                error("ASCII", 2);
            end;
        end;

        return p262;
    end;
end;

function u53.CFrame(p265) -- Line: 855
    if typeof(p265) ~= "CFrame" then
        error("CFrame", 2);
    end;

    return p265;
end;

function u53.CFrameFinite(p266) -- Line: 861
    if typeof(p266) ~= "CFrame" then
        error("CFrame", 2);
    end;

    local v267, v268, v269, v270, v271, v272, v273, v274, v275, v276, v277, v278 = p266:GetComponents();
    local v279 = v267 + v268 + v269 + v270 + v271 + v272 + v273 + v274 + v275 + v276 + v277 + v278;
    local v280;

    if v279 == v279 and v279 ~= (1 / 0) then
        v280 = v279 ~= (-1 / 0);
    else
        v280 = false;
    end;

    if not v280 then
        error("CFrameFinite", 2);
    end;

    return p266;
end;

function u53.Vector2(p281) -- Line: 870
    if typeof(p281) ~= "Vector2" then
        error("Vector2", 2);
    end;

    return p281;
end;

function u53.Vector2Finite(p282) -- Line: 876
    if typeof(p282) ~= "Vector2" then
        error("Vector2", 2);
    end;

    local v283 = p282.X + p282.Y;
    local v284;

    if v283 == v283 and v283 ~= (1 / 0) then
        v284 = v283 ~= (-1 / 0);
    else
        v284 = false;
    end;

    if not v284 then
        error("Vector2Finite", 2);
    end;

    return p282;
end;

function u53.Vector2Unit(p285) -- Line: 885
    if typeof(p285) ~= "Vector2" then
        error("Vector2", 2);
    end;

    local v286 = p285.X + p285.Y;
    local v287;

    if v286 == v286 and v286 ~= (1 / 0) then
        v287 = v286 ~= (-1 / 0);
    else
        v287 = false;
    end;

    if not v287 then
        error("Vector2Finite", 2);
    end;

    if math.abs(p285.Magnitude - 1) > 1e-6 then
        error("Vector2Unit", 2);
    end;

    return p285;
end;

function u53.Vector3(p288) -- Line: 897
    if typeof(p288) ~= "Vector3" then
        error("Vector3", 2);
    end;

    return p288;
end;

function u53.Vector3Finite(p289) -- Line: 903
    if typeof(p289) ~= "Vector3" then
        error("Vector3", 2);
    end;

    local v290 = p289.X + p289.Y + p289.Z;
    local v291;

    if v290 == v290 and v290 ~= (1 / 0) then
        v291 = v290 ~= (-1 / 0);
    else
        v291 = false;
    end;

    if not v291 then
        error("Vector3Finite", 2);
    end;

    return p289;
end;

function u53.Vector3Unit(p292) -- Line: 912
    if typeof(p292) ~= "Vector3" then
        error("Vector3", 2);
    end;

    local v293 = p292.X + p292.Y + p292.Z;
    local v294;

    if v293 == v293 and v293 ~= (1 / 0) then
        v294 = v293 ~= (-1 / 0);
    else
        v294 = false;
    end;

    if not v294 then
        error("Vector3Finite", 2);
    end;

    if math.abs(p292.Magnitude - 1) > 1e-6 then
        error("Vector3Unit", 2);
    end;

    return p292;
end;

function u53.Vector3Positive(p295) -- Line: 924
    if typeof(p295) ~= "Vector3" then
        error("Vector3", 2);
    end;

    local v296 = p295.X + p295.Y + p295.Z;
    local v297;

    if v296 == v296 and v296 ~= (1 / 0) then
        v297 = v296 ~= (-1 / 0);
    else
        v297 = false;
    end;

    if not v297 then
        error("Vector3Finite", 2);
    end;

    if p295.X <= 0 or (p295.Y <= 0 or p295.Z <= 0) then
        error("Vector3Positive");
    end;

    return p295;
end;

function u53.Vector3int16(p298) -- Line: 936
    if typeof(p298) ~= "Vector3int16" then
        error("Vector3int16", 2);
    end;

    return p298;
end;

function u53.Vector2int16(p299) -- Line: 942
    if typeof(p299) ~= "Vector2int16" then
        error("Vector2int16", 2);
    end;

    return p299;
end;

function u53.Region3(p300) -- Line: 948
    if typeof(p300) ~= "Region3" then
        error("Region3", 2);
    end;

    return p300;
end;

function u53.Region3int16(p301) -- Line: 954
    if typeof(p301) ~= "Region3int16" then
        error("Region3int16", 2);
    end;

    return p301;
end;

function u53.UDim(p302) -- Line: 960
    if typeof(p302) ~= "UDim" then
        error("UDim", 2);
    end;

    return p302;
end;

function u53.UDim2(p303) -- Line: 966
    if typeof(p303) ~= "UDim2" then
        error("UDim2", 2);
    end;

    return p303;
end;

function u53.Rect(p304) -- Line: 972
    if typeof(p304) ~= "Rect" then
        error("Rect", 2);
    end;

    return p304;
end;

function u53.PhysicalProperties(p305) -- Line: 978
    if typeof(p305) ~= "PhysicalProperties" then
        error("PhysicalProperties", 2);
    end;

    return p305;
end;

function u53.Storable(p306, p307) -- Line: 988
    -- upvalues: SafeKeyStringRep (copy), u53 (copy)
    if type(p306) == "boolean" then
        return p306;
    end;

    if type(p306) == "number" then
        return p306;
    end;

    if type(p306) == "string" then
        if not utf8.len(p306) then
            error("UTF8", 2);

            return p306;
        end;
    else
        if type(p306) == "buffer" then
            return p306;
        end;

        if type(p306) == "table" then
            if type(p306) ~= "table" then
                error("table", 2);
            end;

            if getmetatable(p306) ~= nil then
                error("metatable", 2);
            end;

            local v308 = p307 or {};

            if v308[p306] then
                error("Loop", 2);
            end;

            v308[p306] = true;
            local v309 = rawlen(p306);

            if v309 <= 0 then
                for i, v in pairs(p306) do
                    if type(i) ~= "string" then
                        error(`KeyString ${`[{SafeKeyStringRep(i)}]`}`, 2);
                    end;

                    if not utf8.len(i) then
                        error(`KeyUTF8 ${`[{SafeKeyStringRep(i)}]`}`, 2);
                    end;

                    local success, result = pcall(u53.Storable, v, v308);

                    if not success then
                        local v310 = tostring(result);
                        local v311, v312 = string.match(v310, "^(.*:%d+): (.+)$");

                        if v311 then
                            v310 = v312 or v310;
                        end;

                        local v313, v314 = string.match(v310, "^(.+) $(%[.+)$");

                        if v313 then
                            if not v314 then
                                v313 = v310;
                            end;
                        else
                            v313 = v310;
                        end;

                        error(`{v313} ${`[{SafeKeyStringRep(i)}]{v314 or ""}`}`, 2);
                    end;
                end;

                return p306;
            end;

            local v315 = 0;

            for i, v in pairs(p306) do
                v315 = v315 + 1;

                if i ~= v315 then
                    error(`IndexMismatch ${`[{SafeKeyStringRep(i)}]`}`, 2);
                end;

                if v309 < v315 then
                    error(`IndexOverflow ${`[{v315}]`}`, 2);
                end;

                local success, result = pcall(u53.Storable, v, v308);

                if not success then
                    local v316 = tostring(result);
                    local v317, v318 = string.match(v316, "^(.*:%d+): (.+)$");

                    if v317 then
                        v316 = v318 or v316;
                    end;

                    local v319, v320 = string.match(v316, "^(.+) $(%[.+)$");

                    if v319 then
                        if not v320 then
                            v319 = v316;
                        end;
                    else
                        v319 = v316;
                    end;

                    error(`{v319} ${`[{v315}]{v320 or ""}`}`, 2);
                end;
            end;

            if v309 ~= v315 then
                error("LengthMismatch", 2);

                return p306;
            end;
        else
            error("Storable", 2);
        end;
    end;

    return p306;
end;

local u321 = {
    boolean = true,
    number = true,
    string = true,
    buffer = true,
    Color3 = true,
    Instance = true,
    NumberRange = true,
    Rect = true,
    Region3 = true,
    Region3int16 = true,
    UDim = true,
    UDim2 = true,
    CFrame = true,
    Vector2 = true,
    Vector2int16 = true,
    Vector3 = true,
    Vector3int16 = true,
    EnumItem = true
};
table.freeze(u321);

function u53.Networkable(p322, p323) -- Line: 1084
    -- upvalues: SafeKeyStringRep (copy), u53 (copy), u321 (copy)
    if type(p322) == "string" then
        if not utf8.len(p322) then
            error("UTF8", 2);

            return p322;
        end;
    elseif type(p322) == "table" then
        if type(p322) ~= "table" then
            error("table", 2);
        end;

        if getmetatable(p322) ~= nil then
            error("metatable", 2);
        end;

        local v324 = p323 or {};

        if v324[p322] then
            error("Loop", 2);
        end;

        v324[p322] = true;
        local v325 = rawlen(p322);

        if v325 <= 0 then
            for i, v in pairs(p322) do
                if type(i) ~= "string" then
                    error(`KeyString ${`[{SafeKeyStringRep(i)}]`}`, 2);
                end;

                if not utf8.len(i) then
                    error(`KeyUTF8 ${`[{SafeKeyStringRep(i)}]`}`, 2);
                end;

                local success, result = pcall(u53.Networkable, v, v324);

                if not success then
                    local v326 = tostring(result);
                    local v327, v328 = string.match(v326, "^(.*:%d+): (.+)$");

                    if v327 then
                        v326 = v328 or v326;
                    end;

                    local v329, v330 = string.match(v326, "^(.+) $(%[.+)$");

                    if v329 then
                        if not v330 then
                            v329 = v326;
                        end;
                    else
                        v329 = v326;
                    end;

                    error(`{v329} ${`[{SafeKeyStringRep(i)}]{v330 or ""}`}`, 2);
                end;
            end;

            return p322;
        end;

        local v331 = 0;

        for i, v in pairs(p322) do
            v331 = v331 + 1;

            if i ~= v331 then
                error(`IndexMismatch ${`[{SafeKeyStringRep(i)}]`}`, 2);
            end;

            if v325 < v331 then
                error(`IndexOverflow ${`[{v331}]`}`, 2);
            end;

            local success, result = pcall(u53.Networkable, v, v324);

            if not success then
                local v332 = tostring(result);
                local v333, v334 = string.match(v332, "^(.*:%d+): (.+)$");

                if v333 then
                    v332 = v334 or v332;
                end;

                local v335, v336 = string.match(v332, "^(.+) $(%[.+)$");

                if v335 then
                    if not v336 then
                        v335 = v332;
                    end;
                else
                    v335 = v332;
                end;

                error(`{v335} ${`[{v331}]{v336 or ""}`}`, 2);
            end;
        end;

        if v325 ~= v331 then
            error("LengthMismatch", 2);

            return p322;
        end;
    elseif not u321[typeof(p322)] then
        error("Networkable", 2);
    end;

    return p322;
end;

function u53.Enum(u337) -- Line: 1150
    if typeof(u337) ~= "Enum" then
        error("Enum", 2);
    end;

    return function(p338) -- Line: 1152
        -- upvalues: u337 (copy)
        if typeof(p338) ~= "EnumItem" then
            error("EnumItem", 2);
        end;

        if p338.EnumType ~= u337 then
            error(tostring(u337), 2);
        end;

        return p338;
    end;
end;

function u53.EnumValue(p339) -- Line: 1159
    if typeof(p339) ~= "Enum" then
        error("Enum", 2);
    end;

    local u340 = {};

    for _, v in ipairs(p339:GetEnumItems()) do
        u340[v.Value] = v;
    end;

    return function(p341) -- Line: 1165
        -- upvalues: u340 (copy)
        if typeof(p341) ~= "number" then
            error("number", 2);
        end;

        if not u340[p341] then
            error("EnumValue", 2);
        end;

        return p341;
    end;
end;

function u53.Player(p342) -- Line: 1172
    if typeof(p342) ~= "Instance" or not p342:IsA("Player") then
        error("Player", 2);
    end;

    return p342;
end;

function u53.BasePart(p343) -- Line: 1178
    if typeof(p343) ~= "Instance" or not p343:IsA("BasePart") then
        error("BasePart", 2);
    end;

    return p343;
end;

function u53.Part(p344) -- Line: 1184
    if typeof(p344) ~= "Instance" or not p344:IsA("Part") then
        error("Part", 2);
    end;

    return p344;
end;

function u53.MeshPart(p345) -- Line: 1190
    if typeof(p345) ~= "Instance" or not p345:IsA("MeshPart") then
        error("MeshPart", 2);
    end;

    return p345;
end;

function u53.Model(p346) -- Line: 1196
    if typeof(p346) ~= "Instance" or not p346:IsA("Model") then
        error("Model", 2);
    end;

    return p346;
end;

function u53.Animation(p347) -- Line: 1202
    if typeof(p347) ~= "Instance" or not p347:IsA("Animation") then
        error("Animation", 2);
    end;

    return p347;
end;

function u53.Humanoid(p348) -- Line: 1208
    if typeof(p348) ~= "Instance" or not p348:IsA("Humanoid") then
        error("Humanoid", 2);
    end;

    return p348;
end;

function u53.ParticleEmitter(p349) -- Line: 1214
    if typeof(p349) ~= "Instance" or not p349:IsA("ParticleEmitter") then
        error("ParticleEmitter", 2);
    end;

    return p349;
end;

function u53.Sound(p350) -- Line: 1220
    if typeof(p350) ~= "Instance" or not p350:IsA("Sound") then
        error("Sound", 2);
    end;

    return p350;
end;

function u53.Instance(p351) -- Line: 1226
    if typeof(p351) ~= "Instance" then
        error("Instance", 2);
    end;

    return p351;
end;

function u53.InstanceOf(u352) -- Line: 1234
    -- upvalues: u53 (copy)
    u53.String(u352);

    return function(p353) -- Line: 1236
        -- upvalues: u352 (copy)
        if typeof(p353) ~= "Instance" then
            error("Instance", 2);
        end;

        if not p353:IsA(u352) then
            error(u352, 2);
        end;

        return p353;
    end;
end;

function u53.InstanceClass(u354) -- Line: 1243
    -- upvalues: u53 (copy)
    u53.String(u354);

    return function(p355) -- Line: 1245
        -- upvalues: u354 (copy)
        if typeof(p355) ~= "Instance" then
            error("Instance", 2);
        end;

        if p355.ClassName ~= u354 then
            error(u354, 2);
        end;

        return p355;
    end;
end;

function u53.HexLower(p356) -- Line: 1253
    if type(p356) ~= "string" then
        error("string", 2);
    end;

    for i = 1, string.len(p356) do
        local v357 = string.byte(p356, i);

        if (v357 < 48 or v357 > 57) and (v357 < 97 or v357 > 102) then
            error("HexLower", 2);
        end;
    end;

    return p356;
end;

function u53.HexUpper(p358) -- Line: 1267
    if type(p358) ~= "string" then
        error("string", 2);
    end;

    for i = 1, string.len(p358) do
        local v359 = string.byte(p358, i);

        if (v359 < 48 or v359 > 57) and (v359 < 65 or v359 > 70) then
            error("HexUpper", 2);
        end;
    end;

    return p358;
end;

function u53.UUIDStripped(p360) -- Line: 1281
    if type(p360) ~= "string" then
        error("string", 2);
    end;

    local v361 = string.len(p360);

    if v361 ~= 32 then
        error("Length32", 2);
    end;

    for i = 1, v361 do
        local v362 = string.byte(p360, i);

        if (v362 < 48 or v362 > 57) and (v362 < 97 or v362 > 102) then
            error("HexLower", 2);
        end;
    end;

    return p360;
end;

function u53.UUID(p363) -- Line: 1295
    if type(p363) ~= "string" then
        error("string", 2);
    end;

    if string.len(p363) ~= 36 then
        error("Length36", 2);
    end;

    if not p363:find("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
        error("UUID", 2);
    end;

    return p363;
end;

function u53.Base64(p364) -- Line: 1306
    if type(p364) ~= "string" then
        error("string", 2);
    end;

    if string.len(p364) % 4 ~= 0 then
        error("Base64Length", 2);
    end;

    if not string.match(p364, "^[A-Za-z0-9+/]*=?=?$") or string.match(p364, "[^=]=+[^=]") then
        error("Base64", 2);
    end;

    return p364;
end;

function u53.ToNumber(u365) -- Line: 1317
    return function(p366) -- Line: 1320
        -- upvalues: u365 (copy)
        local v367 = tonumber(p366);

        if not v367 then
            error("tonumber", 2);
        end;

        local success, result = pcall(u365, v367);

        if not success then
            local v368 = error;
            local v369 = tostring(result);
            local v370, v371 = string.match(v369, "^(.*:%d+): (.+)$");

            if v370 then
                v369 = v371 or v369;
            end;

            v368(v369, 2);
        end;

        return result;
    end;
end;

function u53.IsoDate(p372) -- Line: 1333
    if not DateTime.fromIsoDate(p372) then
        error("IsoDate", 2);
    end;

    return p372;
end;

return table.freeze(u53);