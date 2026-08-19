-- Decompiled with Potassium's decompiler.

local v1 = {};
local HttpService = game:GetService("HttpService");
local u2 = Random.new();

local function Sync(p3, p4) -- Line: 84
    -- upvalues: Sync (copy)
    local v5 = type(p3) == "table";
    assert(v5, "First argument must be a table");
    local v6 = type(p4) == "table";
    assert(v6, "Second argument must be a table");
    local v7 = table.clone(p3);

    for i, v in pairs(v7) do
        local v8 = p4[i];

        if v8 == nil then
            v7[i] = nil;
        elseif type(v) == type(v8) then
            if type(v) == "table" then
                v7[i] = Sync(v, v8);
            end;
        elseif type(v8) == "table" then
            local function DeepCopy(p9) -- Line: 44
                -- upvalues: DeepCopy (copy)
                local v10 = table.clone(p9);

                for i2, v2 in v10 do
                    if type(v2) == "table" then
                        v10[i2] = DeepCopy(v2);
                    end;
                end;

                return v10;
            end;

            v7[i] = DeepCopy(v8);
        else
            v7[i] = v8;
        end;
    end;

    for i, v in pairs(p4) do
        if v7[i] == nil then
            if type(v) == "table" then
                local function u13(p11) -- Line: 44
                    -- upvalues: u13 (copy)
                    local v12 = table.clone(p11);

                    for i2, v2 in v12 do
                        if type(v2) == "table" then
                            v12[i2] = u13(v2);
                        end;
                    end;

                    return v12;
                end;

                v7[i] = u13(v);
            else
                v7[i] = v;
            end;
        end;
    end;

    return v7;
end;

local function Reconcile(p14, p15) -- Line: 156
    -- upvalues: Reconcile (copy)
    local v16 = type(p14) == "table";
    assert(v16, "First argument must be a table");
    local v17 = type(p15) == "table";
    assert(v17, "Second argument must be a table");
    local v18 = table.clone(p14);

    for i, v in p15 do
        local v19 = p14[i];

        if v19 == nil then
            if type(v) == "table" then
                local function u22(p20) -- Line: 44
                    -- upvalues: u22 (copy)
                    local v21 = table.clone(p20);

                    for i2, v2 in v21 do
                        if type(v2) == "table" then
                            v21[i2] = u22(v2);
                        end;
                    end;

                    return v21;
                end;

                v18[i] = u22(v);
            else
                v18[i] = v;
            end;
        elseif type(v19) == "table" then
            if type(v) == "table" then
                v18[i] = Reconcile(v19, v);
            else
                local function u25(p23) -- Line: 44
                    -- upvalues: u25 (copy)
                    local v24 = table.clone(p23);

                    for i2, v2 in v24 do
                        if type(v2) == "table" then
                            v24[i2] = u25(v2);
                        end;
                    end;

                    return v24;
                end;

                v18[i] = u25(v19);
            end;
        end;
    end;

    return v18;
end;

local function Map(p26, p27) -- Line: 262
    local v28 = type(p26) == "table";
    assert(v28, "First argument must be a table");
    local v29 = type(p27) == "function";
    assert(v29, "Second argument must be a function");
    local v30 = table.create(#p26);

    for i, v in p26 do
        v30[i] = p27(v, i, p26);
    end;

    return v30;
end;

function v1.Copy(p31, p32) -- Line: 40
    if not p32 then
        return table.clone(p31);
    end;

    local function u35(p33) -- Line: 44
        -- upvalues: u35 (copy)
        local v34 = table.clone(p33);

        for i, v in v34 do
            if type(v) == "table" then
                v34[i] = u35(v);
            end;
        end;

        return v34;
    end;

    return u35(p31);
end;

v1.Sync = Sync;
v1.Reconcile = Reconcile;

function v1.SwapRemove(p36, p37) -- Line: 209
    local v38 = #p36;
    p36[p37] = p36[v38];
    p36[v38] = nil;
end;

function v1.SwapRemoveFirstValue(p39, p40) -- Line: 234
    local v41 = table.find(p39, p40);

    if v41 then
        local v42 = #p39;
        p39[v41] = p39[v42];
        p39[v42] = nil;
    end;

    return v41;
end;

v1.Map = Map;

function v1.Filter(p43, p44) -- Line: 292
    local v45 = type(p43) == "table";
    assert(v45, "First argument must be a table");
    local v46 = type(p44) == "function";
    assert(v46, "Second argument must be a function");
    local v47 = table.create(#p43);

    if #p43 <= 0 then
        for i, v in p43 do
            if p44(v, i, p43) then
                v47[i] = v;
            end;
        end;

        return v47;
    end;

    local v48 = 0;

    for i, v in p43 do
        if p44(v, i, p43) then
            v48 = v48 + 1;
            v47[v48] = v;
        end;
    end;

    return v47;
end;

function v1.Reduce(p49, p50, p51) -- Line: 335
    local v52 = type(p49) == "table";
    assert(v52, "First argument must be a table");
    local v53 = type(p50) == "function";
    assert(v53, "Second argument must be a function");

    if #p49 > 0 then
        local v54;

        if p51 == nil then
            p51 = p49[1];
            v54 = 2;
        else
            v54 = 1;
        end;

        for i = v54, #p49 do
            p51 = p50(p51, p49[i], i, p49);
        end;

        return p51;
    end;

    local v55;

    if p51 == nil then
        v55 = next(p49);
        p51 = v55;
    else
        v55 = nil;
    end;

    for i, v in next, p49, v55 do
        p51 = p50(p51, v, i, p49);
    end;

    return p51;
end;

function v1.Assign(p56, ...) -- Line: 378
    local v57 = table.clone(p56);

    for _, v in { ... } do
        for i, v2 in v do
            v57[i] = v2;
        end;
    end;

    return v57;
end;

function v1.Extend(p58, p59) -- Line: 407
    local v60 = table.clone(p58);

    for _, v in p59 do
        table.insert(v60, v);
    end;

    return v60;
end;

function v1.Reverse(p61) -- Line: 432
    local v62 = #p61;
    local v63 = table.create(v62);

    for i = 1, v62 do
        v63[i] = p61[v62 - i + 1];
    end;

    return v63;
end;

function v1.Shuffle(p64, p65) -- Line: 459
    -- upvalues: u2 (copy)
    local v66 = type(p64) == "table";
    assert(v66, "First argument must be a table");
    local v67 = table.clone(p64);

    if typeof(p65) ~= "Random" then
        p65 = u2;
    end;

    for i = #p64, 2, -1 do
        local v68 = p65:NextInteger(1, i);
        local v69 = v67[i];
        v67[i] = v67[v68];
        v67[v68] = v69;
    end;

    return v67;
end;

function v1.Sample(p70, p71, p72) -- Line: 489
    -- upvalues: u2 (copy)
    local v73 = type(p70) == "table";
    assert(v73, "First argument must be a table");
    local v74 = type(p71) == "number";
    assert(v74, "Second argument must be a number");
    local v75 = #p70;

    if v75 == 0 then
        return {};
    end;

    local v76 = table.clone(p70);
    local v77 = table.create(p71);

    if typeof(p72) ~= "Random" then
        p72 = u2;
    end;

    local v78 = math.clamp(p71, 1, v75);

    for i = 1, v78 do
        local v79 = p72:NextInteger(i, v75);
        local v80 = v76[i];
        v76[i] = v76[v79];
        v76[v79] = v80;
    end;

    table.move(v76, 1, v78, 1, v77);

    return v77;
end;

function v1.Flat(p81, p82) -- Line: 537
    local u83 = type(p82) ~= "number" and 1 or p82;
    local u84 = table.create(#p81);

    local function Scan(p85, p86) -- Line: 540
        -- upvalues: u83 (copy), Scan (copy), u84 (copy)
        for _, v in p85 do
            if type(v) == "table" and p86 < u83 then
                Scan(v, p86 + 1);
            else
                table.insert(u84, v);
            end;
        end;
    end;

    Scan(p81, 0);

    return u84;
end;

function v1.FlatMap(p87, p88) -- Line: 574
    -- upvalues: Map (copy)
    local v89 = Map(p87, p88);
    local u90 = table.create(#v89);
    local u91 = 1;

    local function u94(p92, p93) -- Line: 540
        -- upvalues: u91 (copy), u94 (copy), u90 (copy)
        for _, v in p92 do
            if type(v) == "table" and p93 < u91 then
                u94(v, p93 + 1);
            else
                table.insert(u90, v);
            end;
        end;
    end;

    u94(v89, 0);

    return u90;
end;

function v1.Keys(p95) -- Line: 600
    local v96 = table.create(#p95);

    for i in p95 do
        table.insert(v96, i);
    end;

    return v96;
end;

function v1.Values(p97) -- Line: 630
    local v98 = table.create(#p97);

    for _, v in p97 do
        table.insert(v98, v);
    end;

    return v98;
end;

function v1.Find(p99, p100) -- Line: 669
    for i, v in p99 do
        if p100(v, i, p99) then
            return v, i;
        end;
    end;

    return nil, nil;
end;

function v1.Every(p101, p102) -- Line: 698
    for i, v in p101 do
        if not p102(v, i, p101) then
            return false;
        end;
    end;

    return true;
end;

function v1.Some(p103, p104) -- Line: 727
    for i, v in p103 do
        if p104(v, i, p103) then
            return true;
        end;
    end;

    return false;
end;

function v1.Truncate(p105, p106) -- Line: 753
    local v107 = #p105;
    local v108 = math.clamp(p106, 1, v107);

    if v108 == v107 then
        return table.clone(p105);
    end;

    return table.move(p105, 1, v108, 1, table.create(v108));
end;

function v1.Zip(...) -- Line: 786
    local v109 = select("#", ...) > 0;
    assert(v109, "Must supply at least 1 table");

    local function ZipIteratorArray(p110, p111) -- Line: 788
        local v112 = p111 + 1;
        local v113 = {};

        for i, v in p110 do
            local v114 = v[v112];

            if v114 == nil then
                return nil, nil;
            end;

            v113[i] = v114;
        end;

        return v112, v113;
    end;

    local function ZipIteratorMap(p115, p116) -- Line: 801
        local v117 = {};

        for i, v in p115 do
            local v118 = next(v, p116);

            if v118 == nil then
                return nil, nil;
            end;

            v117[i] = v118;
        end;

        return p116, v117;
    end;

    local v119 = { ... };

    if #v119[1] > 0 then
        return ZipIteratorArray, v119, 0;
    end;

    return ZipIteratorMap, v119, nil;
end;

function v1.Lock(p120) -- Line: 839
    local function Freeze(p121) -- Line: 840
        -- upvalues: Freeze (copy)
        for i, v in pairs(p121) do
            if type(v) == "table" then
                p121[i] = Freeze(v);
            end;
        end;

        return table.freeze(p121);
    end;

    return Freeze(p120);
end;

function v1.IsEmpty(p122) -- Line: 869
    return next(p122) == nil;
end;

function v1.EncodeJSON(p123) -- Line: 881
    -- upvalues: HttpService (copy)
    return HttpService:JSONEncode(p123);
end;

function v1.DecodeJSON(p124) -- Line: 893
    -- upvalues: HttpService (copy)
    return HttpService:JSONDecode(p124);
end;

return v1;