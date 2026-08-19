-- Decompiled with Potassium's decompiler.

local u1 = Random.new();
local u2 = {};

for i, v in pairs(table) do
    u2[i] = v;
end;

function u2.contains(p3, p4) -- Line: 8
    -- upvalues: u2 (copy)
    return u2.indexOf(p3, p4) ~= nil;
end;

function u2.indexOf(p5, p6) -- Line: 12
    -- upvalues: u2 (copy)
    return table.find(p5, p6) or u2.keyOf(p5, p6);
end;

function u2.keyOf(p7, p8) -- Line: 21
    for i, v in pairs(p7) do
        if v == p8 then
            return i;
        end;
    end;

    return nil;
end;

function u2.skip(p9, p10) -- Line: 30
    return table.move(p9, p10 + 1, #p9, 1, table.create(#p9 - p10));
end;

function u2.take(p11, p12) -- Line: 34
    return table.move(p11, 1, p12, 1, table.create(p12));
end;

function u2.range(p13, p14, p15) -- Line: 38
    return table.move(p13, p14, p15, 1, table.create(p15 - p14 + 1));
end;

function u2.skipAndTake(p16, p17, p18) -- Line: 42
    return table.move(p16, p17 + 1, p17 + p18, 1, table.create(p18));
end;

function u2.random(p19) -- Line: 46
    -- upvalues: u1 (copy)
    return p19[u1:NextInteger(1, #p19)];
end;

function u2.join(p20, p21) -- Line: 50
    local v22 = table.create(#p20 + #p21);
    table.move(p20, 1, #p20, 1, v22);

    return table.move(p21, 1, #p21, #p20 + 1, v22);
end;

function u2.removeObject(p23, p24) -- Line: 56
    -- upvalues: u2 (copy)
    local v25 = u2.indexOf(p23, p24);

    if v25 then
        table.remove(p23, v25);
    end;
end;

function u2.expand(p26, p27) -- Line: 63
    if p27 < 0 then
        error("Cannot expand a table by a negative amount of objects.");
    end;

    local v28 = table.create(#p26 + p27);

    for i = 1, #p26 do
        v28[i] = p26[i];
    end;

    return v28;
end;

return u2;