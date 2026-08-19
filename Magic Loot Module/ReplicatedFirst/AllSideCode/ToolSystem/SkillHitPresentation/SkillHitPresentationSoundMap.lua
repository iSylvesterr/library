-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {
    ["通用受击"] = { "音效-命中敌人" },
    ["音效-命中敌人"] = { "音效-命中敌人" },
    ["矮人受击"] = { "矮人受击" },
    ["哥布林受击_1"] = { "哥布林受击_1" },
    ["哥布林受击_2"] = { "哥布林受击_2" },
    ["音效-兽人受击"] = { "音效-兽人受击" },
    ["音效-熔岩巨兽受击"] = { "音效-熔岩巨兽受击" }
};

function u1.pickSound(p3) -- Line: 30
    -- upvalues: u2 (copy)
    if typeof(p3) ~= "string" or p3 == "" then
        return nil;
    end;

    local v4 = u2[p3];

    if not v4 or #v4 == 0 then
        return p3;
    end;

    if #v4 == 1 then
        return v4[1];
    end;

    return v4[math.random(1, #v4)];
end;

function u1.resolveHitSounds(p5, p6) -- Line: 54
    -- upvalues: u1 (copy)
    local u7 = {};
    local u8 = {};

    local function add(p9) -- Line: 58
        -- upvalues: u1 (ref), u8 (copy), u7 (copy)
        local v10 = u1.pickSound(p9);

        if v10 and not u8[v10] then
            u8[v10] = true;
            table.insert(u7, v10);
        end;
    end;

    local v11 = u1.pickSound(p5);

    if v11 and not u8[v11] then
        u8[v11] = true;
        table.insert(u7, v11);
    end;

    local v12 = u1.pickSound(p6);

    if v12 and not u8[v12] then
        u8[v12] = true;
        table.insert(u7, v12);
    end;

    return u7;
end;

return u1;