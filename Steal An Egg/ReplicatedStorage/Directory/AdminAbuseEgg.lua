-- Decompiled with Potassium's decompiler.

local u1 = {
    EggDisplayName = "Demonic Egg",
    DropTable = { { "Demon Imp", 42 }, { "Hellhound", 28 }, { "Gargoyle", 15 }, { "Minotaur", 10 }, { "Balrog", 4.9 }, { "Archdemon Dragon", 0.1 } }
};

function u1.IsEventCategory(p2) -- Line: 17
    -- upvalues: u1 (copy)
    if p2 == nil then
        return false;
    end;

    for _, v in u1.DropTable do
        if v[1] == p2 then
            return true;
        end;
    end;

    return false;
end;

function u1.GetTotalWeight() -- Line: 31
    -- upvalues: u1 (copy)
    local v3 = 0;

    for _, v in u1.DropTable do
        v3 = v3 + v[2];
    end;

    return v3;
end;

function u1.Roll(p4) -- Line: 39
    -- upvalues: u1 (copy)
    local v5 = p4 or Random.new();
    local v6 = u1.GetTotalWeight();

    if v6 <= 0 then
        return u1.DropTable[1][1];
    end;

    local v7 = v5:NextNumber() * v6;
    local v8 = 0;

    for _, v in u1.DropTable do
        v8 = v8 + v[2];

        if v7 <= v8 then
            return v[1];
        end;
    end;

    return u1.DropTable[#u1.DropTable][1];
end;

return u1;