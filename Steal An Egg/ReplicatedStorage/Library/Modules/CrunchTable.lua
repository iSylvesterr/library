-- Decompiled with Potassium's decompiler.

local u1 = {
    Enum = {
        FLOAT = 1,
        VECTOR3 = 2,
        INT32 = 3,
        UBYTE = 4
    }
};
table.freeze(u1.Enum);
u1.Sizes = { 4, 12, 4, 1 };
table.freeze(u1.Sizes);

function u1.CreateLayout(p2) -- Line: 23
    -- upvalues: u1 (copy)
    return {
        pairTable = {},
        totalBytes = 0,

        Add = function(p3, p4, p5) -- Line: 29, Name: Add
            -- upvalues: u1 (ref)
            table.insert(p3.pairTable, {
                field = p4,
                enum = p5
            });
            u1:CalcSize(p3);
        end
    };
end;

function u1.CalcSize(p6, p7) -- Line: 36
    -- upvalues: u1 (copy)
    local v8 = 0;

    for _, v in p7.pairTable do
        v.size = u1.Sizes[v.enum];
        v8 = v8 + v.size;
    end;

    p7.totalBytes = v8 + 2;
end;

function u1.DeepCopy(p9, p10) -- Line: 46
    local function Deep(p11) -- Line: 47
        -- upvalues: Deep (copy)
        local v12 = table.create(#p11);

        for i, v in pairs(p11) do
            if type(v) == "table" then
                v12[i] = Deep(v);
            else
                v12[i] = v;
            end;
        end;

        return v12;
    end;

    return Deep(p10);
end;

function u1.BinaryEncodeTable(p13, p14, p15) -- Line: 61
    -- upvalues: u1 (copy)
    local v16 = p13:DeepCopy(p14);
    local v17 = buffer.create(p15.totalBytes);
    local v18 = 2;
    local v19 = 0;
    local v20 = 0;

    for _, v in p15.pairTable do
        local field = v.field;
        local enum = v.enum;
        local v21 = v16[field];

        if enum == u1.Enum.INT32 then
            if v21 ~= nil and v21 ~= 0 then
                buffer.writei32(v17, v18, v21);
                v18 = v18 + v.size;
                local v22 = bit32.lshift(1, v19);
                v20 = bit32.bor(v20, v22);
            end;
        elseif enum == u1.Enum.FLOAT then
            if v21 ~= nil and v21 ~= 0 then
                buffer.writef32(v17, v18, v21);
                v18 = v18 + v.size;
                local v23 = bit32.lshift(1, v19);
                v20 = bit32.bor(v20, v23);
            end;
        elseif enum == u1.Enum.UBYTE then
            if v21 ~= nil and v21 ~= 0 then
                buffer.writeu8(v17, v18, v21);
                v18 = v18 + v.size;
                local v24 = bit32.lshift(1, v19);
                v20 = bit32.bor(v20, v24);
            end;
        elseif enum == u1.Enum.VECTOR3 and (v21 ~= nil and v21.magnitude > 0) then
            buffer.writef32(v17, v18, v21.X);
            local v25 = v18 + 4;
            buffer.writef32(v17, v25, v21.Y);
            local v26 = v25 + 4;
            buffer.writef32(v17, v26, v21.Z);
            v18 = v26 + 4;
            local v27 = bit32.lshift(1, v19);
            v20 = bit32.bor(v20, v27);
        end;

        v16[field] = nil;
        v19 = v19 + 1;
    end;

    buffer.writeu16(v17, 0, v20);
    local v28 = buffer.create(v18);
    buffer.copy(v28, 0, v17, 0, v18);
    v16._b = v28;

    return v16;
end;

function u1.BinaryDecodeTable(p29, p30, p31) -- Line: 124
    -- upvalues: u1 (copy)
    local v32 = p29:DeepCopy(p30);

    if v32._b ~= nil then
        local _b = v32._b;
        v32._b = nil;
        local v33 = buffer.readu16(_b, 0);
        local v34 = 0 + 2;
        local v35 = 0;

        for _, v in p31.pairTable do
            local field = v.field;
            local enum = v.enum;
            local v36 = bit32.lshift(1, v35);

            if bit32.band(v33, v36) > 0 == false then
                if enum == u1.Enum.INT32 then
                    v32[field] = 0;
                elseif enum == u1.Enum.FLOAT then
                    v32[field] = 0;
                elseif enum == u1.Enum.UBYTE then
                    v32[field] = 0;
                elseif enum == u1.Enum.VECTOR3 then
                    v32[field] = Vector3.new(0, 0, 0);
                end;
            elseif enum == u1.Enum.INT32 then
                v32[field] = buffer.readi32(_b, v34);
                v34 = v34 + v.size;
            elseif enum == u1.Enum.FLOAT then
                v32[field] = buffer.readf32(_b, v34);
                v34 = v34 + v.size;
            elseif enum == u1.Enum.UBYTE then
                v32[field] = buffer.readu8(_b, v34);
                v34 = v34 + v.size;
            elseif enum == u1.Enum.VECTOR3 then
                local v37 = buffer.readf32(_b, v34);
                local v38 = v34 + 4;
                local v39 = buffer.readf32(_b, v38);
                local v40 = v38 + 4;
                local v41 = buffer.readf32(_b, v40);
                v34 = v40 + 4;
                v32[field] = Vector3.new(v37, v39, v41);
            end;

            v35 = v35 + 1;
        end;

        return v32;
    end;

    error("missing _b field");
end;

return u1;