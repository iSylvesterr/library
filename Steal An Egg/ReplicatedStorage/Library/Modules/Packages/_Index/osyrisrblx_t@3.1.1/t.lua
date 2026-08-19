-- Decompiled with Potassium's decompiler.

local u8 = {
    type = function(u1) -- Line: 7, Name: type
        return function(p2) -- Line: 8
            -- upvalues: u1 (copy)
            local v3 = type(p2);

            if v3 == u1 then
                return true;
            end;

            return false, string.format("%s expected, got %s", u1, v3);
        end;
    end,

    typeof = function(u4) -- Line: 18, Name: typeof
        return function(p5) -- Line: 19
            -- upvalues: u4 (copy)
            local v6 = typeof(p5);

            if v6 == u4 then
                return true;
            end;

            return false, string.format("%s expected, got %s", u4, v6);
        end;
    end,

    any = function(p7) -- Line: 36, Name: any
        if p7 == nil then
            return false, "any expected, got nil";
        end;

        return true;
    end
};
u8.boolean = u8.typeof("boolean");
u8.buffer = u8.typeof("buffer");
u8.thread = u8.typeof("thread");
u8.callback = u8.typeof("function");
u8["function"] = u8.callback;
u8.none = u8.typeof("nil");
u8["nil"] = u8.none;
u8.string = u8.typeof("string");
u8.table = u8.typeof("table");
u8.userdata = u8.type("userdata");
u8.vector = u8.type("vector");

function u8.number(p9) -- Line: 118
    local v10 = typeof(p9);

    if v10 ~= "number" then
        return false, string.format("number expected, got %s", v10);
    end;

    if p9 == p9 then
        return true;
    end;

    return false, "unexpected NaN value";
end;

function u8.nan(p11) -- Line: 138
    local v12 = typeof(p11);

    if v12 ~= "number" then
        return false, string.format("number expected, got %s", v12);
    end;

    if p11 == p11 then
        return false, "unexpected non-NaN value";
    end;

    return true;
end;

u8.Axes = u8.typeof("Axes");
u8.BrickColor = u8.typeof("BrickColor");
u8.CatalogSearchParams = u8.typeof("CatalogSearchParams");
u8.CFrame = u8.typeof("CFrame");
u8.Color3 = u8.typeof("Color3");
u8.ColorSequence = u8.typeof("ColorSequence");
u8.ColorSequenceKeypoint = u8.typeof("ColorSequenceKeypoint");
u8.DateTime = u8.typeof("DateTime");
u8.DockWidgetPluginGuiInfo = u8.typeof("DockWidgetPluginGuiInfo");
u8.Enum = u8.typeof("Enum");
u8.EnumItem = u8.typeof("EnumItem");
u8.Enums = u8.typeof("Enums");
u8.Faces = u8.typeof("Faces");
u8.FloatCurveKey = u8.typeof("FloatCurveKey");
u8.Font = u8.typeof("Font");
u8.Instance = u8.typeof("Instance");
u8.NumberRange = u8.typeof("NumberRange");
u8.NumberSequence = u8.typeof("NumberSequence");
u8.NumberSequenceKeypoint = u8.typeof("NumberSequenceKeypoint");
u8.OverlapParams = u8.typeof("OverlapParams");
u8.PathWaypoint = u8.typeof("PathWaypoint");
u8.PhysicalProperties = u8.typeof("PhysicalProperties");
u8.Random = u8.typeof("Random");
u8.Ray = u8.typeof("Ray");
u8.RaycastParams = u8.typeof("RaycastParams");
u8.RaycastResult = u8.typeof("RaycastResult");
u8.RBXScriptConnection = u8.typeof("RBXScriptConnection");
u8.RBXScriptSignal = u8.typeof("RBXScriptSignal");
u8.Rect = u8.typeof("Rect");
u8.Region3 = u8.typeof("Region3");
u8.Region3int16 = u8.typeof("Region3int16");
u8.TweenInfo = u8.typeof("TweenInfo");
u8.UDim = u8.typeof("UDim");
u8.UDim2 = u8.typeof("UDim2");
u8.Vector2 = u8.typeof("Vector2");
u8.Vector2int16 = u8.typeof("Vector2int16");
u8.Vector3 = u8.typeof("Vector3");
u8.Vector3int16 = u8.typeof("Vector3int16");

function u8.literal(...) -- Line: 426
    -- upvalues: u8 (copy)
    local v13 = select("#", ...);

    if v13 == 1 then
        local u14 = ...;

        return function(p15) -- Line: 430
            -- upvalues: u14 (copy)
            if p15 == u14 then
                return true;
            end;

            return false, string.format("expected %s, got %s", tostring(u14), (tostring(p15)));
        end;
    end;

    local v16 = {};

    for i = 1, v13 do
        local v17 = select(i, ...);
        v16[i] = u8.literal(v17);
    end;

    return u8.union(table.unpack(v16, 1, v13));
end;

u8.exactly = u8.literal;

function u8.keyOf(p18) -- Line: 461
    -- upvalues: u8 (copy)
    local v19 = 0;
    local v20 = {};

    for i in pairs(p18) do
        v19 = v19 + 1;
        v20[v19] = i;
    end;

    return u8.literal(table.unpack(v20, 1, v19));
end;

function u8.valueOf(p21) -- Line: 479
    -- upvalues: u8 (copy)
    local v22 = 0;
    local v23 = {};

    for _, v in pairs(p21) do
        v22 = v22 + 1;
        v23[v22] = v;
    end;

    return u8.literal(table.unpack(v23, 1, v22));
end;

function u8.integer(p24) -- Line: 497
    -- upvalues: u8 (copy)
    local v25, v26 = u8.number(p24);

    if not v25 then
        return false, v26 or "";
    end;

    if p24 % 1 == 0 then
        return true;
    end;

    return false, string.format("integer expected, got %s", p24);
end;

function u8.numberMin(u27) -- Line: 517
    -- upvalues: u8 (copy)
    return function(p28) -- Line: 518
        -- upvalues: u8 (ref), u27 (copy)
        local v29, v30 = u8.number(p28);

        if not v29 then
            return false, v30 or "";
        end;

        if u27 <= p28 then
            return true;
        end;

        return false, string.format("number >= %s expected, got %s", u27, p28);
    end;
end;

function u8.numberMax(u31) -- Line: 539
    -- upvalues: u8 (copy)
    return function(p32) -- Line: 540
        -- upvalues: u8 (ref), u31 (copy)
        local v33, v34 = u8.number(p32);

        if not v33 then
            return false, v34;
        end;

        if p32 <= u31 then
            return true;
        end;

        return false, string.format("number <= %s expected, got %s", u31, p32);
    end;
end;

function u8.numberMinExclusive(u35) -- Line: 561
    -- upvalues: u8 (copy)
    return function(p36) -- Line: 562
        -- upvalues: u8 (ref), u35 (copy)
        local v37, v38 = u8.number(p36);

        if not v37 then
            return false, v38 or "";
        end;

        if u35 < p36 then
            return true;
        end;

        return false, string.format("number > %s expected, got %s", u35, p36);
    end;
end;

function u8.numberMaxExclusive(u39) -- Line: 583
    -- upvalues: u8 (copy)
    return function(p40) -- Line: 584
        -- upvalues: u8 (ref), u39 (copy)
        local v41, v42 = u8.number(p40);

        if not v41 then
            return false, v42 or "";
        end;

        if p40 < u39 then
            return true;
        end;

        return false, string.format("number < %s expected, got %s", u39, p40);
    end;
end;

u8.numberPositive = u8.numberMinExclusive(0);
u8.numberNegative = u8.numberMaxExclusive(0);

function u8.numberConstrained(p43, p44) -- Line: 620
    -- upvalues: u8 (copy)
    assert(u8.number(p43));
    assert(u8.number(p44));
    local u45 = u8.numberMin(p43);
    local u46 = u8.numberMax(p44);

    return function(p47) -- Line: 626
        -- upvalues: u45 (copy), u46 (copy)
        local v48, v49 = u45(p47);

        if not v48 then
            return false, v49 or "";
        end;

        local v50, v51 = u46(p47);

        if v50 then
            return true;
        end;

        return false, v51 or "";
    end;
end;

function u8.numberConstrainedExclusive(p52, p53) -- Line: 649
    -- upvalues: u8 (copy)
    assert(u8.number(p52));
    assert(u8.number(p53));
    local u54 = u8.numberMinExclusive(p52);
    local u55 = u8.numberMaxExclusive(p53);

    return function(p56) -- Line: 655
        -- upvalues: u54 (copy), u55 (copy)
        local v57, v58 = u54(p56);

        if not v57 then
            return false, v58 or "";
        end;

        local v59, v60 = u55(p56);

        if v59 then
            return true;
        end;

        return false, v60 or "";
    end;
end;

function u8.match(u61) -- Line: 677
    -- upvalues: u8 (copy)
    assert(u8.string(u61));

    return function(p62) -- Line: 679
        -- upvalues: u8 (ref), u61 (copy)
        local v63, v64 = u8.string(p62);

        if not v63 then
            return false, v64;
        end;

        if string.match(p62, u61) == nil then
            return false, string.format("%q failed to match pattern %q", p62, u61);
        end;

        return true;
    end;
end;

function u8.optional(u65) -- Line: 700
    -- upvalues: u8 (copy)
    assert(u8.callback(u65));

    return function(p66) -- Line: 702
        -- upvalues: u65 (copy)
        if p66 == nil then
            return true;
        end;

        local v67, v68 = u65(p66);

        if v67 then
            return true;
        end;

        return false, string.format("(optional) %s", v68 or "");
    end;
end;

function u8.except(u69) -- Line: 728
    -- upvalues: u8 (copy)
    assert(u8.callback(u69));

    return function(p70) -- Line: 730
        -- upvalues: u69 (copy)
        if u69(p70) then
            return false, "(expect) checker to fail, but it succeeded.";
        end;

        return true;
    end;
end;

function u8.tuple(...) -- Line: 747
    local u71 = { ... };

    return function(...) -- Line: 749
        -- upvalues: u71 (copy)
        local v72 = { ... };

        for i, v in ipairs(u71) do
            local v73, v74 = v(v72[i]);

            if v73 == false then
                return false, string.format("Bad tuple index #%s:\n\t%s", i, v74 or "");
            end;
        end;

        return true;
    end;
end;

function u8.keys(u75) -- Line: 769
    -- upvalues: u8 (copy)
    assert(u8.callback(u75));

    return function(p76) -- Line: 771
        -- upvalues: u8 (ref), u75 (copy)
        local v77, v78 = u8.table(p76);

        if v77 == false then
            return false, v78 or "";
        end;

        for i in pairs(p76) do
            local v79, v80 = u75(i);

            if v79 == false then
                return false, string.format("bad key %s:\n\t%s", tostring(i), v80 or "");
            end;
        end;

        return true;
    end;
end;

function u8.values(u81) -- Line: 795
    -- upvalues: u8 (copy)
    assert(u8.callback(u81));

    return function(p82) -- Line: 797
        -- upvalues: u8 (ref), u81 (copy)
        local v83, v84 = u8.table(p82);

        if v83 == false then
            return false, v84 or "";
        end;

        for i, v in pairs(p82) do
            local v85, v86 = u81(v);

            if v85 == false then
                return false, string.format("bad value for key %s:\n\t%s", tostring(i), v86 or "");
            end;
        end;

        return true;
    end;
end;

function u8.map(p87, p88) -- Line: 822
    -- upvalues: u8 (copy)
    assert(u8.callback(p87));
    assert(u8.callback(p88));
    local u89 = u8.keys(p87);
    local u90 = u8.values(p88);

    return function(p91) -- Line: 828
        -- upvalues: u89 (copy), u90 (copy)
        local v92, v93 = u89(p91);

        if not v92 then
            return false, v93 or "";
        end;

        local v94, v95 = u90(p91);

        if v94 then
            return true;
        end;

        return false, v95 or "";
    end;
end;

function u8.set(p96) -- Line: 850
    -- upvalues: u8 (copy)
    return u8.map(p96, u8.literal(true));
end;

local u97 = u8.keys(u8.integer);

function u8.array(p98) -- Line: 863
    -- upvalues: u8 (copy), u97 (copy)
    assert(u8.callback(p98));
    local u99 = u8.values(p98);

    return function(p100) -- Line: 867
        -- upvalues: u97 (ref), u99 (copy)
        local v101, v102 = u97(p100);

        if v101 == false then
            return false, string.format("[array] %s", v102 or "");
        end;

        local v103 = 0;

        for _ in ipairs(p100) do
            v103 = v103 + 1;
        end;

        for i in pairs(p100) do
            if i < 1 or v103 < i then
                return false, string.format("[array] key %s must be sequential", (tostring(i)));
            end;
        end;

        local v104, v105 = u99(p100);

        if v104 then
            return true;
        end;

        return false, string.format("[array] %s", v105 or "");
    end;
end;

function u8.strictArray(...) -- Line: 903
    -- upvalues: u8 (copy), u97 (copy)
    local u106 = { ... };
    local v107 = u8.array(u8.callback);
    assert(v107(u106));

    return function(p108) -- Line: 907
        -- upvalues: u97 (ref), u106 (copy)
        local v109, v110 = u97(p108);

        if v109 == false then
            return false, string.format("[strictArray] %s", v110 or "");
        end;

        if #u106 < #p108 then
            return false, string.format("[strictArray] Array size exceeds limit of %d", #u106);
        end;

        for i, v in pairs(u106) do
            local v111, v112 = v(p108[i]);

            if not v111 then
                return false, string.format("[strictArray] Array index #%d - %s", i, v112);
            end;
        end;

        return true;
    end;
end;

local u113 = u8.array(u8.callback);

function u8.union(...) -- Line: 939
    -- upvalues: u113 (copy)
    local u114 = { ... };
    assert(u113(u114));

    return function(p115) -- Line: 943
        -- upvalues: u114 (copy)
        for _, v in ipairs(u114) do
            if v(p115) then
                return true;
            end;
        end;

        return false, "bad type for union";
    end;
end;

u8.some = u8.union;

function u8.intersection(...) -- Line: 966
    -- upvalues: u113 (copy)
    local u116 = { ... };
    assert(u113(u116));

    return function(p117) -- Line: 970
        -- upvalues: u116 (copy)
        for _, v in ipairs(u116) do
            local v118, v119 = v(p117);

            if not v118 then
                return false, v119 or "";
            end;
        end;

        return true;
    end;
end;

u8.every = u8.intersection;
local u120 = u8.map(u8.any, u8.callback);

function u8.interface(u121) -- Line: 997
    -- upvalues: u120 (copy), u8 (copy)
    assert(u120(u121));

    return function(p122) -- Line: 999
        -- upvalues: u8 (ref), u121 (copy)
        local v123, v124 = u8.table(p122);

        if v123 == false then
            return false, v124 or "";
        end;

        for i, v in pairs(u121) do
            local v125, v126 = v(p122[i]);

            if v125 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(i), v126 or "");
            end;
        end;

        return true;
    end;
end;

function u8.strictInterface(u127) -- Line: 1023
    -- upvalues: u120 (copy), u8 (copy)
    assert(u120(u127));

    return function(p128) -- Line: 1025
        -- upvalues: u8 (ref), u127 (copy)
        local v129, v130 = u8.table(p128);

        if v129 == false then
            return false, v130 or "";
        end;

        for i, v in pairs(u127) do
            local v131, v132 = v(p128[i]);

            if v131 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(i), v132 or "");
            end;
        end;

        for i in pairs(p128) do
            if not u127[i] then
                return false, string.format("[interface] unexpected field %q", (tostring(i)));
            end;
        end;

        return true;
    end;
end;

function u8.instanceOf(u133, p134) -- Line: 1056
    -- upvalues: u8 (copy)
    assert(u8.string(u133));
    local u135;

    if p134 == nil then
        u135 = nil;
    else
        u135 = u8.children(p134);
    end;

    return function(p136) -- Line: 1064
        -- upvalues: u8 (ref), u133 (copy), u135 (ref)
        local v137, v138 = u8.Instance(p136);

        if not v137 then
            return false, v138 or "";
        end;

        if p136.ClassName ~= u133 then
            return false, string.format("%s expected, got %s", u133, p136.ClassName);
        end;

        if u135 then
            local v139, v140 = u135(p136);

            if not v139 then
                return false, v140;
            end;
        end;

        return true;
    end;
end;

u8.instance = u8.instanceOf;

function u8.instanceIsA(u141, p142) -- Line: 1094
    -- upvalues: u8 (copy)
    assert(u8.string(u141));
    local u143;

    if p142 == nil then
        u143 = nil;
    else
        u143 = u8.children(p142);
    end;

    return function(p144) -- Line: 1102
        -- upvalues: u8 (ref), u141 (copy), u143 (ref)
        local v145, v146 = u8.Instance(p144);

        if not v145 then
            return false, v146 or "";
        end;

        if not p144:IsA(u141) then
            return false, string.format("%s expected, got %s", u141, p144.ClassName);
        end;

        if u143 then
            local v147, v148 = u143(p144);

            if not v147 then
                return false, v148;
            end;
        end;

        return true;
    end;
end;

function u8.enum(u149) -- Line: 1128
    -- upvalues: u8 (copy)
    assert(u8.Enum(u149));

    return function(p150) -- Line: 1130
        -- upvalues: u8 (ref), u149 (copy)
        local v151, v152 = u8.EnumItem(p150);

        if not v151 then
            return false, v152;
        end;

        if p150.EnumType == u149 then
            return true;
        end;

        return false, string.format("enum of %s expected, got enum of %s", tostring(u149), (tostring(p150.EnumType)));
    end;
end;

local u153 = u8.tuple(u8.callback, u8.callback);

function u8.wrap(u154, u155) -- Line: 1155
    -- upvalues: u153 (copy)
    assert(u153(u154, u155));

    return function(...) -- Line: 1157
        -- upvalues: u155 (copy), u154 (copy)
        assert(u155(...));

        return u154(...);
    end;
end;

function u8.strict(u156) -- Line: 1171
    return function(...) -- Line: 1172
        -- upvalues: u156 (copy)
        assert(u156(...));
    end;
end;

local u157 = u8.map(u8.string, u8.callback);

function u8.children(u158) -- Line: 1191
    -- upvalues: u157 (copy), u8 (copy)
    assert(u157(u158));

    return function(p159) -- Line: 1194
        -- upvalues: u8 (ref), u158 (copy)
        local v160, v161 = u8.Instance(p159);

        if not v160 then
            return false, v161 or "";
        end;

        local v162 = {};

        for _, child in ipairs(p159:GetChildren()) do
            local Name = child.Name;

            if u158[Name] then
                if v162[Name] then
                    return false, string.format("Cannot process multiple children with the same name %q", Name);
                end;

                v162[Name] = child;
            end;
        end;

        for i, v in pairs(u158) do
            local v163, v164 = v(v162[i]);

            if not v163 then
                return false, string.format("[%s.%s] %s", p159:GetFullName(), i, v164 or "");
            end;
        end;

        return true;
    end;
end;

return u8;