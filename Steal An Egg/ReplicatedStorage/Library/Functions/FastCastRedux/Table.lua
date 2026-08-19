-- Decompiled with Potassium's decompiler.

local u1 = Random.new();
local u2 = table;
local u3 = {};

function u3.contains(p4, p5) -- Line: 27
    -- upvalues: u3 (copy)
    return u3.indexOf(p4, p5) ~= nil;
end;

function u3.indexOf(p6, p7) -- Line: 32
    -- upvalues: u3 (copy)
    return table.find(p6, p7) or u3.keyOf(p6, p7);
end;

function u3.keyOf(p8, p9) -- Line: 43
    for i, v in pairs(p8) do
        if v == p9 then
            return i;
        end;
    end;

    return nil;
end;

function u3.insertAndGetIndexOf(p10, p11) -- Line: 53
    p10[#p10 + 1] = p11;

    return #p10;
end;

function u3.skip(p12, p13) -- Line: 59
    return table.move(p12, p13 + 1, #p12, 1, table.create(#p12 - p13));
end;

function u3.take(p14, p15) -- Line: 64
    return table.move(p14, 1, p15, 1, table.create(p15));
end;

function u3.range(p16, p17, p18) -- Line: 69
    return table.move(p16, p17, p18, 1, table.create(p18 - p17 + 1));
end;

function u3.skipAndTake(p19, p20, p21) -- Line: 74
    return table.move(p19, p20 + 1, p20 + p21, 1, table.create(p21));
end;

function u3.random(p22) -- Line: 79
    -- upvalues: u1 (copy)
    return p22[u1:NextInteger(1, #p22)];
end;

function u3.join(p23, p24) -- Line: 84
    local v25 = table.create(#p23 + #p24);
    table.move(p23, 1, #p23, 1, v25);

    return table.move(p24, 1, #p24, #p23 + 1, v25);
end;

function u3.removeObject(p26, p27) -- Line: 91
    -- upvalues: u3 (copy)
    local v28 = u3.indexOf(p26, p27);

    if v28 then
        table.remove(p26, v28);
    end;
end;

return setmetatable({}, {
    __index = function(p29, p30) -- Line: 99, Name: __index
        -- upvalues: u3 (copy), u2 (copy)
        if u3[p30] == nil then
            return u2[p30];
        end;

        return u3[p30];
    end,

    __newindex = function(p31, p32, p33) -- Line: 107, Name: __newindex
        error("Add new table entries by editing the Module itself.");
    end
});