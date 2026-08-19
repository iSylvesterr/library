-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local u1 = Random.new();

local function Sync(p2, p3) -- Line: 119
    -- upvalues: Sync (copy)
    local v4 = type(p2) == "table";
    assert(v4, "First argument must be a table");
    local v5 = type(p3) == "table";
    assert(v5, "Second argument must be a table");
    local v6 = table.clone(p2);

    for i, v in pairs(v6) do
        local v7 = p3[i];

        if v7 == nil then
            v6[i] = nil;
        elseif type(v) == type(v7) then
            if type(v) == "table" then
                v6[i] = Sync(v, v7);
            end;
        elseif type(v7) == "table" then
            local function DeepCopy(p8) -- Line: 43
                -- upvalues: DeepCopy (copy)
                local v9 = table.clone(p8);

                for i2, v2 in v9 do
                    if type(v2) == "table" then
                        v9[i2] = DeepCopy(v2);
                    end;
                end;

                return v9;
            end;

            v6[i] = DeepCopy(v7);
        else
            v6[i] = v7;
        end;
    end;

    for i, v in pairs(p3) do
        if v6[i] == nil then
            if type(v) == "table" then
                local function u12(p10) -- Line: 43
                    -- upvalues: u12 (copy)
                    local v11 = table.clone(p10);

                    for i2, v2 in v11 do
                        if type(v2) == "table" then
                            v11[i2] = u12(v2);
                        end;
                    end;

                    return v11;
                end;

                v6[i] = u12(v);
            else
                v6[i] = v;
            end;
        end;
    end;

    return v6;
end;

local function Reconcile(p13, p14) -- Line: 191
    -- upvalues: Reconcile (copy)
    local v15 = type(p13) == "table";
    assert(v15, "First argument must be a table");
    local v16 = type(p14) == "table";
    assert(v16, "Second argument must be a table");
    local v17 = table.clone(p13);

    for i, v in p14 do
        local v18 = p13[i];

        if v18 == nil then
            if type(v) == "table" then
                local function u21(p19) -- Line: 43
                    -- upvalues: u21 (copy)
                    local v20 = table.clone(p19);

                    for i2, v2 in v20 do
                        if type(v2) == "table" then
                            v20[i2] = u21(v2);
                        end;
                    end;

                    return v20;
                end;

                v17[i] = u21(v);
            else
                v17[i] = v;
            end;
        elseif type(v18) == "table" then
            if type(v) == "table" then
                v17[i] = Reconcile(v18, v);
            else
                local function u24(p22) -- Line: 43
                    -- upvalues: u24 (copy)
                    local v23 = table.clone(p22);

                    for i2, v2 in v23 do
                        if type(v2) == "table" then
                            v23[i2] = u24(v2);
                        end;
                    end;

                    return v23;
                end;

                v17[i] = u24(v18);
            end;
        end;
    end;

    return v17;
end;

local function Map(p25, p26) -- Line: 359
    local v27 = type(p25) == "table";
    assert(v27, "First argument must be a table");
    local v28 = type(p26) == "function";
    assert(v28, "Second argument must be a function");
    local v29 = table.create(#p25);

    for i, v in p25 do
        v29[i] = p26(v, i, p25);
    end;

    return v29;
end;

return {
    Copy = function(p30, p31) -- Line: 39, Name: Copy
        if not p31 then
            return table.clone(p30);
        end;

        local function u34(p32) -- Line: 43
            -- upvalues: u34 (copy)
            local v33 = table.clone(p32);

            for i, v in v33 do
                if type(v) == "table" then
                    v33[i] = u34(v);
                end;
            end;

            return v33;
        end;

        return u34(p30);
    end,

    Sync = Sync,
    Reconcile = Reconcile,

    SwapRemove = function(p35, p36) -- Line: 306, Name: SwapRemove
        local v37 = #p35;
        p35[p36] = p35[v37];
        p35[v37] = nil;
    end,

    SwapRemoveFirstValue = function(p38, p39) -- Line: 331, Name: SwapRemoveFirstValue
        local v40 = table.find(p38, p39);

        if v40 then
            local v41 = #p38;
            p38[v40] = p38[v41];
            p38[v41] = nil;
        end;

        return v40;
    end,

    Map = Map,

    Filter = function(p42, p43) -- Line: 389, Name: Filter
        local v44 = type(p42) == "table";
        assert(v44, "First argument must be a table");
        local v45 = type(p43) == "function";
        assert(v45, "Second argument must be a function");
        local v46 = table.create(#p42);

        if #p42 <= 0 then
            for i, v in p42 do
                if p43(v, i, p42) then
                    v46[i] = v;
                end;
            end;

            return v46;
        end;

        local v47 = 0;

        for i, v in p42 do
            if p43(v, i, p42) then
                v47 = v47 + 1;
                v46[v47] = v;
            end;
        end;

        return v46;
    end,

    Reduce = function(p48, p49, p50) -- Line: 432, Name: Reduce
        local v51 = type(p48) == "table";
        assert(v51, "First argument must be a table");
        local v52 = type(p49) == "function";
        assert(v52, "Second argument must be a function");

        if #p48 > 0 then
            local v53;

            if p50 == nil then
                p50 = p48[1];
                v53 = 2;
            else
                v53 = 1;
            end;

            for i = v53, #p48 do
                p50 = p49(p50, p48[i], i, p48);
            end;

            return p50;
        end;

        local v54;

        if p50 == nil then
            v54 = next(p48);
            p50 = v54;
        else
            v54 = nil;
        end;

        for i, v in next, p48, v54 do
            p50 = p49(p50, v, i, p48);
        end;

        return p50;
    end,

    Assign = function(p55, ...) -- Line: 475, Name: Assign
        local v56 = table.clone(p55);

        for _, v in { ... } do
            for i, v2 in v do
                v56[i] = v2;
            end;
        end;

        return v56;
    end,

    Extend = function(p57, p58) -- Line: 504, Name: Extend
        local v59 = table.clone(p57);

        for _, v in p58 do
            table.insert(v59, v);
        end;

        return v59;
    end,

    Reverse = function(p60) -- Line: 529, Name: Reverse
        local v61 = #p60;
        local v62 = table.create(v61);

        for i = 1, v61 do
            v62[i] = p60[v61 - i + 1];
        end;

        return v62;
    end,

    Shuffle = function(p63, p64) -- Line: 556, Name: Shuffle
        -- upvalues: u1 (copy)
        local v65 = type(p63) == "table";
        assert(v65, "First argument must be a table");
        local v66 = table.clone(p63);

        if typeof(p64) ~= "Random" then
            p64 = u1;
        end;

        for i = #p63, 2, -1 do
            local v67 = p64:NextInteger(1, i);
            local v68 = v66[i];
            v66[i] = v66[v67];
            v66[v67] = v68;
        end;

        return v66;
    end,

    Sample = function(p69, p70, p71) -- Line: 586, Name: Sample
        -- upvalues: u1 (copy)
        local v72 = type(p69) == "table";
        assert(v72, "First argument must be a table");
        local v73 = type(p70) == "number";
        assert(v73, "Second argument must be a number");
        local v74 = #p69;

        if v74 == 0 then
            return {};
        end;

        local v75 = table.clone(p69);
        local v76 = table.create(p70);

        if typeof(p71) ~= "Random" then
            p71 = u1;
        end;

        local v77 = math.clamp(p70, 1, v74);

        for i = 1, v77 do
            local v78 = p71:NextInteger(i, v74);
            local v79 = v75[i];
            v75[i] = v75[v78];
            v75[v78] = v79;
        end;

        table.move(v75, 1, v77, 1, v76);

        return v76;
    end,

    Flat = function(p80, p81) -- Line: 634, Name: Flat
        local u82 = type(p81) ~= "number" and 1 or p81;
        local u83 = table.create(#p80);

        local function Scan(p84, p85) -- Line: 637
            -- upvalues: u82 (copy), Scan (copy), u83 (copy)
            for _, v in p84 do
                if type(v) == "table" and p85 < u82 then
                    Scan(v, p85 + 1);
                else
                    table.insert(u83, v);
                end;
            end;
        end;

        Scan(p80, 0);

        return u83;
    end,

    FlatMap = function(p86, p87) -- Line: 671, Name: FlatMap
        -- upvalues: Map (copy)
        local v88 = Map(p86, p87);
        local u89 = table.create(#v88);
        local u90 = 1;

        local function u93(p91, p92) -- Line: 637
            -- upvalues: u90 (copy), u93 (copy), u89 (copy)
            for _, v in p91 do
                if type(v) == "table" and p92 < u90 then
                    u93(v, p92 + 1);
                else
                    table.insert(u89, v);
                end;
            end;
        end;

        u93(v88, 0);

        return u89;
    end,

    Keys = function(p94) -- Line: 697, Name: Keys
        local v95 = table.create(#p94);

        for i in p94 do
            table.insert(v95, i);
        end;

        return v95;
    end,

    Values = function(p96) -- Line: 727, Name: Values
        local v97 = table.create(#p96);

        for _, v in p96 do
            table.insert(v97, v);
        end;

        return v97;
    end,

    Find = function(p98, p99) -- Line: 766, Name: Find
        for i, v in p98 do
            if p99(v, i, p98) then
                return v, i;
            end;
        end;

        return nil, nil;
    end,

    Every = function(p100, p101) -- Line: 795, Name: Every
        for i, v in p100 do
            if not p101(v, i, p100) then
                return false;
            end;
        end;

        return true;
    end,

    Some = function(p102, p103) -- Line: 824, Name: Some
        for i, v in p102 do
            if p103(v, i, p102) then
                return true;
            end;
        end;

        return false;
    end,

    Truncate = function(p104, p105) -- Line: 850, Name: Truncate
        local v106 = #p104;
        local v107 = math.clamp(p105, 1, v106);

        if v107 == v106 then
            return table.clone(p104);
        end;

        return table.move(p104, 1, v107, 1, table.create(v107));
    end,

    Zip = function(...) -- Line: 883, Name: Zip
        local v108 = select("#", ...) > 0;
        assert(v108, "Must supply at least 1 table");

        local function ZipIteratorArray(p109, p110) -- Line: 885
            local v111 = p110 + 1;
            local v112 = {};

            for i, v in p109 do
                local v113 = v[v111];

                if v113 == nil then
                    return nil, nil;
                end;

                v112[i] = v113;
            end;

            return v111, v112;
        end;

        local function ZipIteratorMap(p114, p115) -- Line: 898
            local v116 = {};

            for i, v in p114 do
                local v117 = next(v, p115);

                if v117 == nil then
                    return nil, nil;
                end;

                v116[i] = v117;
            end;

            return p115, v116;
        end;

        local v118 = { ... };

        if #v118[1] > 0 then
            return ZipIteratorArray, v118, 0;
        end;

        return ZipIteratorMap, v118, nil;
    end,

    Lock = function(p119) -- Line: 936, Name: Lock
        local function Freeze(p120) -- Line: 937
            -- upvalues: Freeze (copy)
            for i, v in pairs(p120) do
                if type(v) == "table" then
                    p120[i] = Freeze(v);
                end;
            end;

            return table.freeze(p120);
        end;

        return Freeze(p119);
    end,

    IsEmpty = function(p121) -- Line: 966, Name: IsEmpty
        return next(p121) == nil;
    end,

    EncodeJSON = function(p122) -- Line: 978, Name: EncodeJSON
        -- upvalues: HttpService (copy)
        return HttpService:JSONEncode(p122);
    end,

    DecodeJSON = function(p123) -- Line: 990, Name: DecodeJSON
        -- upvalues: HttpService (copy)
        return HttpService:JSONDecode(p123);
    end,

    ShallowReconcile = function(p124, p125) -- Line: 241, Name: ShallowReconcile
        local v126 = type(p124) == "table";
        assert(v126, "First argument must be a table");
        local v127 = type(p125) == "table";
        assert(v127, "Second argument must be a table");
        local v128 = table.clone(p124);

        for i, v in p125 do
            if p124[i] == nil then
                if type(v) == "table" then
                    local function u131(p129) -- Line: 43
                        -- upvalues: u131 (copy)
                        local v130 = table.clone(p129);

                        for i2, v2 in v130 do
                            if type(v2) == "table" then
                                v130[i2] = u131(v2);
                            end;
                        end;

                        return v130;
                    end;

                    v128[i] = u131(v);
                else
                    v128[i] = v;
                end;
            end;
        end;

        return v128;
    end,

    HardShallowReconcile = function(p132, p133) -- Line: 261, Name: HardShallowReconcile
        local v134 = type(p132) == "table";
        assert(v134, "First argument must be a table");
        local v135 = type(p133) == "table";
        assert(v135, "Second argument must be a table");

        for i, v in p133 do
            if p132[i] == nil then
                if type(v) == "table" then
                    local function u138(p136) -- Line: 43
                        -- upvalues: u138 (copy)
                        local v137 = table.clone(p136);

                        for i2, v2 in v137 do
                            if type(v2) == "table" then
                                v137[i2] = u138(v2);
                            end;
                        end;

                        return v137;
                    end;

                    p132[i] = u138(v);
                else
                    p132[i] = v;
                end;
            end;
        end;

        return p132;
    end,

    CopySafe = function(p139, p140, u141) -- Line: 55, Name: CopySafe
        if not p140 then
            return table.clone(p139);
        end;

        local u142 = {};

        local function u147(p143) -- Line: 61
            -- upvalues: u142 (ref), u141 (copy), u147 (copy)
            local v144 = u142[p143];

            if v144 then
                return v144;
            end;

            local v145 = table.clone(p143);
            local v146;

            if u141 then
                v146 = getmetatable(p143);
            else
                v146 = nil;
            end;

            u142[p143] = v145;

            if v146 then
                setmetatable(v145, v146);
            end;

            for i, v in v145 do
                if type(v) == "table" then
                    v145[i] = u147(v);
                end;
            end;

            return v145;
        end;

        local v148 = u147(p139);
        u142 = nil;

        return v148;
    end,

    HardReconcile = function(p149, p150) -- Line: 217, Name: HardReconcile
        -- upvalues: Reconcile (copy)
        local v151 = type(p149) == "table";
        assert(v151, "First argument must be a table");
        local v152 = type(p150) == "table";
        assert(v152, "Second argument must be a table");

        for i, v in p150 do
            local v153 = p149[i];

            if v153 == nil then
                if type(v) == "table" then
                    local function u156(p154) -- Line: 43
                        -- upvalues: u156 (copy)
                        local v155 = table.clone(p154);

                        for i2, v2 in v155 do
                            if type(v2) == "table" then
                                v155[i2] = u156(v2);
                            end;
                        end;

                        return v155;
                    end;

                    p149[i] = u156(v);
                else
                    p149[i] = v;
                end;
            elseif type(v153) == "table" then
                if type(v) == "table" then
                    p149[i] = Reconcile(v153, v);
                else
                    local function u159(p157) -- Line: 43
                        -- upvalues: u159 (copy)
                        local v158 = table.clone(p157);

                        for i2, v2 in v158 do
                            if type(v2) == "table" then
                                v158[i2] = u159(v2);
                            end;
                        end;

                        return v158;
                    end;

                    p149[i] = u159(v153);
                end;
            end;
        end;

        return p149;
    end
};