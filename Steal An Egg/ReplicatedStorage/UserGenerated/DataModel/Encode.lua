-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2, v3 = xpcall(function() -- Line: 21
    return workspace[nil];
end, function() -- Line: 23
    return debug.info(2, "f");
end);
v1.fastIndex = (not v2 or type(v3) ~= "function") and function(p4, p5) -- Line: 27
    return p4[p5];
end or v3;
local u6 = {};
u6.__index = u6;

function v1.newWriter(p7) -- Line: 50
    -- upvalues: u6 (copy)
    local v8 = p7 or 65536;
    local v9 = {
        len = 0,
        buf = buffer.create(v8),
        cap = v8
    };

    return setmetatable(v9, u6);
end;

function u6._ensure(p10, p11) -- Line: 59
    local v12 = p10.len + p11;

    if p10.cap < v12 then
        local v13 = p10.cap * 2;

        while v13 < v12 do
            v13 = v13 * 2;
        end;

        local v14 = buffer.create(v13);
        buffer.copy(v14, 0, p10.buf, 0, p10.len);
        p10.buf = v14;
        p10.cap = v13;
    end;
end;

function u6.u8(p15, p16) -- Line: 73
    p15:_ensure(1);
    buffer.writeu8(p15.buf, p15.len, p16);
    p15.len = p15.len + 1;
end;

function u6.u16(p17, p18) -- Line: 79
    p17:_ensure(2);
    buffer.writeu16(p17.buf, p17.len, p18);
    p17.len = p17.len + 2;
end;

function u6.u32(p19, p20) -- Line: 85
    p19:_ensure(4);
    buffer.writeu32(p19.buf, p19.len, p20);
    p19.len = p19.len + 4;
end;

function u6.f32(p21, p22) -- Line: 91
    p21:_ensure(4);
    buffer.writef32(p21.buf, p21.len, p22);
    p21.len = p21.len + 4;
end;

function u6.f64(p23, p24) -- Line: 97
    p23:_ensure(8);
    buffer.writef64(p23.buf, p23.len, p24);
    p23.len = p23.len + 8;
end;

function u6.strU8(p25, p26) -- Line: 104
    local v27 = #p26;
    p25:_ensure(v27 + 1);
    buffer.writeu8(p25.buf, p25.len, v27);
    p25.len = p25.len + 1;

    if v27 > 0 then
        buffer.writestring(p25.buf, p25.len, p26);
        p25.len = p25.len + v27;
    end;
end;

function u6.strU16(p28, p29) -- Line: 116
    local v30 = #p29;

    if v30 > 65535 then
        p29 = string.sub(p29, 1, 65535);
        v30 = 65535;
    end;

    p28:_ensure(v30 + 2);
    buffer.writeu16(p28.buf, p28.len, v30);
    p28.len = p28.len + 2;

    if v30 > 0 then
        buffer.writestring(p28.buf, p28.len, p29);
        p28.len = p28.len + v30;
    end;
end;

function u6.str32(p31, p32) -- Line: 132
    local v33 = #p32;
    p31:_ensure(v33 + 4);
    buffer.writeu32(p31.buf, p31.len, v33);
    p31.len = p31.len + 4;

    if v33 > 0 then
        buffer.writestring(p31.buf, p31.len, p32);
        p31.len = p31.len + v33;
    end;
end;

function u6.patchU16(p34, p35, p36) -- Line: 143
    buffer.writeu16(p34.buf, p35, p36);
end;

function u6.finish(p37) -- Line: 147
    local v38 = buffer.create(p37.len);
    buffer.copy(v38, 0, p37.buf, 0, p37.len);

    return v38;
end;

function v1.writeValue(p39, p40) -- Line: 156
    if p40 == nil then
        p39:u8(0);

        return;
    end;

    local v41 = typeof(p40);

    if v41 == "boolean" then
        p39:u8(p40 and 2 or 1);

        return;
    end;

    if v41 == "number" then
        p39:u8(3);
        p39:f64(p40);

        return;
    end;

    if v41 == "string" then
        p39:u8(4);
        p39:str32(p40);

        return;
    end;

    if v41 == "EnumItem" then
        p39:u8(5);
        p39:str32((tostring(p40)));

        return;
    end;

    if v41 == "Vector2" then
        p39:u8(6);
        p39:f32(p40.X);
        p39:f32(p40.Y);

        return;
    end;

    if v41 == "Vector3" then
        p39:u8(7);
        p39:f32(p40.X);
        p39:f32(p40.Y);
        p39:f32(p40.Z);

        return;
    end;

    if v41 == "Color3" then
        p39:u8(8);
        local v42 = math.floor(p40.R * 255 + 0.5);
        p39:u8((math.clamp(v42, 0, 255)));
        local v43 = math.floor(p40.G * 255 + 0.5);
        p39:u8((math.clamp(v43, 0, 255)));
        local v44 = math.floor(p40.B * 255 + 0.5);
        p39:u8((math.clamp(v44, 0, 255)));

        return;
    end;

    if v41 ~= "CFrame" then
        p39:u8(10);
        p39:str32((tostring(p40)));

        return;
    end;

    p39:u8(9);
    local v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56 = p40:GetComponents();
    p39:f32(v45);
    p39:f32(v46);
    p39:f32(v47);
    p39:f32(v48);
    p39:f32(v49);
    p39:f32(v50);
    p39:f32(v51);
    p39:f32(v52);
    p39:f32(v53);
    p39:f32(v54);
    p39:f32(v55);
    p39:f32(v56);
end;

return v1;