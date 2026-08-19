-- Decompiled with Potassium's decompiler.

local u1 = {};

for i = 0, 255 do
    local v2 = i;

    for _ = 1, 8 do
        local i;

        if bit32.band(i, 1) == 0 then
            i = bit32.rshift(i, 1);
        else
            local v3 = bit32.rshift(i, 1);
            i = bit32.bxor(v3, 3988292384);
        end;
    end;

    u1[v2 + 1] = i;
end;

local u23 = {
    Init = function() -- Line: 44, Name: Init
        return 4294967295;
    end,

    Update = function(p4, p5, p6, p7) -- Line: 48, Name: Update
        -- upvalues: u1 (copy)
        local v8 = p6 or 1;

        for i = v8, v8 + (p7 or string.len(p5)) - 1 do
            local v9 = string.byte(p5, i);
            local v10 = bit32.rshift(p4, 8);
            local v11 = bit32.bxor(p4, v9);
            local v12 = u1[bit32.band(v11, 255) + 1];
            p4 = bit32.bxor(v10, v12);
        end;

        return p4;
    end,

    UpdateBuffer = function(p13, p14, p15, p16) -- Line: 59, Name: UpdateBuffer
        -- upvalues: u1 (copy)
        local v17 = p15 or 0;

        for i = v17, v17 + (p16 or buffer.len(p14)) - 1 do
            local v18 = buffer.readu8(p14, i);
            local v19 = bit32.rshift(p13, 8);
            local v20 = bit32.bxor(p13, v18);
            local v21 = u1[bit32.band(v20, 255) + 1];
            p13 = bit32.bxor(v19, v21);
        end;

        return p13;
    end,

    Finish = function(p22) -- Line: 70, Name: Finish
        return bit32.bnot(p22);
    end
};

function u23.Digest(p24, p25, p26) -- Line: 74
    -- upvalues: u23 (copy)
    local v27 = u23.Init();
    local v28 = u23.Update(v27, p24, p25, p26);

    return u23.Finish(v28);
end;

function u23.DigestBuffer(p29, p30, p31) -- Line: 80
    -- upvalues: u23 (copy)
    local v32 = u23.Init();
    local v33 = u23.UpdateBuffer(v32, p29, p30, p31);

    return u23.Finish(v33);
end;

return table.freeze(u23);