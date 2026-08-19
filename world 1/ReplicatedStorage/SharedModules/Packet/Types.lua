-- Decompiled with Potassium's decompiler.

local u1 = game:GetService("RunService"):IsServer();
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local v8 = {};
local v9 = {};
local v10 = {};
local u11 = {};
local u12 = {};

local function Allocate(p13) -- Line: 48
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v14 = u5 + p13;

    if u4 < v14 then
        while u4 < v14 do
            u4 = u4 * 2;
        end;

        local v15 = buffer.create(u4);
        buffer.copy(v15, 0, u3, 0, u5);
        u2.Buffer = v15;
        u3 = v15;
    end;
end;

local function ReadS8() -- Line: 59
    -- upvalues: u3 (ref), u5 (ref)
    local v16 = buffer.readi8(u3, u5);
    u5 = u5 + 1;

    return v16;
end;

local function WriteS8(p17) -- Line: 60
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writei8(u3, u5, p17);
    u5 = u5 + 1;
end;

local function ReadS16() -- Line: 61
    -- upvalues: u3 (ref), u5 (ref)
    local v18 = buffer.readi16(u3, u5);
    u5 = u5 + 2;

    return v18;
end;

local function WriteS16(p19) -- Line: 62
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writei16(u3, u5, p19);
    u5 = u5 + 2;
end;

local function ReadS24() -- Line: 63
    -- upvalues: u3 (ref), u5 (ref)
    local v20 = buffer.readbits(u3, u5 * 8, 24) - 8388608;
    u5 = u5 + 3;

    return v20;
end;

local function WriteS24(p21) -- Line: 64
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writebits(u3, u5 * 8, 24, p21 + 8388608);
    u5 = u5 + 3;
end;

local function ReadS32() -- Line: 65
    -- upvalues: u3 (ref), u5 (ref)
    local v22 = buffer.readi32(u3, u5);
    u5 = u5 + 4;

    return v22;
end;

local function WriteS32(p23) -- Line: 66
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writei32(u3, u5, p23);
    u5 = u5 + 4;
end;

local function ReadU8() -- Line: 67
    -- upvalues: u3 (ref), u5 (ref)
    local v24 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return v24;
end;

local function WriteU8(p25) -- Line: 68
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writeu8(u3, u5, p25);
    u5 = u5 + 1;
end;

local function ReadU16() -- Line: 69
    -- upvalues: u3 (ref), u5 (ref)
    local v26 = buffer.readu16(u3, u5);
    u5 = u5 + 2;

    return v26;
end;

local function WriteU16(p27) -- Line: 70
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writeu16(u3, u5, p27);
    u5 = u5 + 2;
end;

local function ReadU24() -- Line: 71
    -- upvalues: u3 (ref), u5 (ref)
    local v28 = buffer.readbits(u3, u5 * 8, 24);
    u5 = u5 + 3;

    return v28;
end;

local function WriteU24(p29) -- Line: 72
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writebits(u3, u5 * 8, 24, p29);
    u5 = u5 + 3;
end;

local function ReadU32() -- Line: 73
    -- upvalues: u3 (ref), u5 (ref)
    local v30 = buffer.readu32(u3, u5);
    u5 = u5 + 4;

    return v30;
end;

local function WriteU32(p31) -- Line: 74
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writeu32(u3, u5, p31);
    u5 = u5 + 4;
end;

local function ReadF32() -- Line: 75
    -- upvalues: u3 (ref), u5 (ref)
    local v32 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return v32;
end;

local function WriteF32(p33) -- Line: 76
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writef32(u3, u5, p33);
    u5 = u5 + 4;
end;

local function ReadF64() -- Line: 77
    -- upvalues: u3 (ref), u5 (ref)
    local v34 = buffer.readf64(u3, u5);
    u5 = u5 + 8;

    return v34;
end;

local function WriteF64(p35) -- Line: 78
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writef64(u3, u5, p35);
    u5 = u5 + 8;
end;

local function ReadString(p36) -- Line: 79
    -- upvalues: u3 (ref), u5 (ref), u1 (copy)
    local v37 = buffer.readstring(u3, u5, p36);
    u5 = u5 + p36;

    return u1 and utf8.len(v37) == nil and "" or v37;
end;

local function WriteString(p38) -- Line: 87
    -- upvalues: u3 (ref), u5 (ref)
    buffer.writestring(u3, u5, p38);
    u5 = u5 + #p38;
end;

local function ReadBuffer(p39) -- Line: 88
    -- upvalues: u3 (ref), u5 (ref)
    local v40 = buffer.create(p39);
    buffer.copy(v40, 0, u3, u5, p39);
    u5 = u5 + p39;

    return v40;
end;

local function WriteBuffer(p41) -- Line: 89
    -- upvalues: u3 (ref), u5 (ref)
    buffer.copy(u3, u5, p41);
    u5 = u5 + buffer.len(p41);
end;

local function ReadInstance() -- Line: 90
    -- upvalues: u7 (ref), u6 (ref)
    u7 = u7 + 1;

    return u6[u7];
end;

local function WriteInstance(p42) -- Line: 91
    -- upvalues: u7 (ref), u6 (ref)
    u7 = u7 + 1;
    u6[u7] = p42;
end;

local function ReadF16() -- Line: 93
    -- upvalues: u5 (ref), u3 (ref)
    local v43 = u5 * 8;
    u5 = u5 + 2;
    local v44 = buffer.readbits(u3, v43 + 0, 10);
    local v45 = buffer.readbits(u3, v43 + 10, 5);
    local v46 = buffer.readbits(u3, v43 + 15, 1);

    if v44 == 0 then
        if v45 == 0 then
            return 0;
        end;

        if v45 == 31 then
            return v46 == 0 and (1 / 0) or (-1 / 0);
        end;
    elseif v45 == 31 then
        return (0 / 0);
    end;

    if v46 == 0 then
        return (v44 / 1024 + 1) * 2 ^ (v45 - 15);
    end;

    return -(v44 / 1024 + 1) * 2 ^ (v45 - 15);
end;

local function WriteF16(p47) -- Line: 109
    -- upvalues: u5 (ref), u3 (ref)
    local v48 = u5 * 8;
    u5 = u5 + 2;

    if p47 == 0 then
        buffer.writebits(u3, v48, 16, 0);

        return;
    end;

    if p47 >= 65520 then
        buffer.writebits(u3, v48, 16, 31744);

        return;
    end;

    if p47 <= -65520 then
        buffer.writebits(u3, v48, 16, 64512);

        return;
    end;

    if p47 ~= p47 then
        buffer.writebits(u3, v48, 16, 31745);

        return;
    end;

    local v49;

    if p47 < 0 then
        p47 = -p47;
        v49 = 1;
    else
        v49 = 0;
    end;

    local v50, v51 = math.frexp(p47);
    buffer.writebits(u3, v48 + 0, 10, v50 * 2048 - 1023.5);
    buffer.writebits(u3, v48 + 10, 5, v51 + 14);
    buffer.writebits(u3, v48 + 15, 1, v49);
end;

local function ReadF24() -- Line: 130
    -- upvalues: u5 (ref), u3 (ref)
    local v52 = u5 * 8;
    u5 = u5 + 3;
    local v53 = buffer.readbits(u3, v52 + 0, 17);
    local v54 = buffer.readbits(u3, v52 + 17, 6);
    local v55 = buffer.readbits(u3, v52 + 23, 1);

    if v53 == 0 then
        if v54 == 0 then
            return 0;
        end;

        if v54 == 63 then
            return v55 == 0 and (1 / 0) or (-1 / 0);
        end;
    elseif v54 == 63 then
        return (0 / 0);
    end;

    if v55 == 0 then
        return (v53 / 131072 + 1) * 2 ^ (v54 - 31);
    end;

    return -(v53 / 131072 + 1) * 2 ^ (v54 - 31);
end;

local function WriteF24(p56) -- Line: 146
    -- upvalues: u5 (ref), u3 (ref)
    local v57 = u5 * 8;
    u5 = u5 + 3;

    if p56 == 0 then
        buffer.writebits(u3, v57, 24, 0);

        return;
    end;

    if p56 >= 4294959104 then
        buffer.writebits(u3, v57, 24, 8257536);

        return;
    end;

    if p56 <= -4294959104 then
        buffer.writebits(u3, v57, 24, 16646144);

        return;
    end;

    if p56 ~= p56 then
        buffer.writebits(u3, v57, 24, 8257537);

        return;
    end;

    local v58;

    if p56 < 0 then
        p56 = -p56;
        v58 = 1;
    else
        v58 = 0;
    end;

    local v59, v60 = math.frexp(p56);
    buffer.writebits(u3, v57 + 0, 17, v59 * 262144 - 131071.5);
    buffer.writebits(u3, v57 + 17, 6, v60 + 30);
    buffer.writebits(u3, v57 + 23, 1, v58);
end;

local function ReadAnyOfTag(p61) -- Line: 173
    -- upvalues: u11 (copy)
    local v62 = u11[p61];

    if not v62 then
        error("Packet: unknown Any type tag " .. tostring(p61), 0);
    end;

    return v62();
end;

local function ReadAnyValue() -- Line: 181
    -- upvalues: ReadAnyOfTag (copy), u3 (ref), u5 (ref)
    local v63 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return ReadAnyOfTag(v63);
end;

v8.Any = "Any";
v9.Any = ReadAnyValue;

function v10.Any(p64) -- Line: 188
    -- upvalues: u12 (copy)
    u12[typeof(p64)](p64);
end;

v8.Nil = "Nil";

function v9.Nil() -- Line: 191
    return nil;
end;

function v10.Nil(p65) -- Line: 192
end;

v8.NumberS8 = "NumberS8";

function v9.NumberS8() -- Line: 195
    -- upvalues: u3 (ref), u5 (ref)
    local v66 = buffer.readi8(u3, u5);
    u5 = u5 + 1;

    return v66;
end;

function v10.NumberS8(p67) -- Line: 196
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v68 = u5 + 1;

    if u4 < v68 then
        while u4 < v68 do
            u4 = u4 * 2;
        end;

        local v69 = buffer.create(u4);
        buffer.copy(v69, 0, u3, 0, u5);
        u2.Buffer = v69;
        u3 = v69;
    end;

    buffer.writei8(u3, u5, p67);
    u5 = u5 + 1;
end;

v8.NumberS16 = "NumberS16";

function v9.NumberS16() -- Line: 199
    -- upvalues: u3 (ref), u5 (ref)
    local v70 = buffer.readi16(u3, u5);
    u5 = u5 + 2;

    return v70;
end;

function v10.NumberS16(p71) -- Line: 200
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v72 = u5 + 2;

    if u4 < v72 then
        while u4 < v72 do
            u4 = u4 * 2;
        end;

        local v73 = buffer.create(u4);
        buffer.copy(v73, 0, u3, 0, u5);
        u2.Buffer = v73;
        u3 = v73;
    end;

    buffer.writei16(u3, u5, p71);
    u5 = u5 + 2;
end;

v8.NumberS24 = "NumberS24";

function v9.NumberS24() -- Line: 203
    -- upvalues: u3 (ref), u5 (ref)
    local v74 = buffer.readbits(u3, u5 * 8, 24) - 8388608;
    u5 = u5 + 3;

    return v74;
end;

function v10.NumberS24(p75) -- Line: 204
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v76 = u5 + 3;

    if u4 < v76 then
        while u4 < v76 do
            u4 = u4 * 2;
        end;

        local v77 = buffer.create(u4);
        buffer.copy(v77, 0, u3, 0, u5);
        u2.Buffer = v77;
        u3 = v77;
    end;

    buffer.writebits(u3, u5 * 8, 24, p75 + 8388608);
    u5 = u5 + 3;
end;

v8.NumberS32 = "NumberS32";

function v9.NumberS32() -- Line: 207
    -- upvalues: u3 (ref), u5 (ref)
    local v78 = buffer.readi32(u3, u5);
    u5 = u5 + 4;

    return v78;
end;

function v10.NumberS32(p79) -- Line: 208
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v80 = u5 + 4;

    if u4 < v80 then
        while u4 < v80 do
            u4 = u4 * 2;
        end;

        local v81 = buffer.create(u4);
        buffer.copy(v81, 0, u3, 0, u5);
        u2.Buffer = v81;
        u3 = v81;
    end;

    buffer.writei32(u3, u5, p79);
    u5 = u5 + 4;
end;

v8.NumberU8 = "NumberU8";

function v9.NumberU8() -- Line: 211
    -- upvalues: u3 (ref), u5 (ref)
    local v82 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return v82;
end;

function v10.NumberU8(p83) -- Line: 212
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v84 = u5 + 1;

    if u4 < v84 then
        while u4 < v84 do
            u4 = u4 * 2;
        end;

        local v85 = buffer.create(u4);
        buffer.copy(v85, 0, u3, 0, u5);
        u2.Buffer = v85;
        u3 = v85;
    end;

    buffer.writeu8(u3, u5, p83);
    u5 = u5 + 1;
end;

v8.NumberU16 = "NumberU16";

function v9.NumberU16() -- Line: 215
    -- upvalues: u3 (ref), u5 (ref)
    local v86 = buffer.readu16(u3, u5);
    u5 = u5 + 2;

    return v86;
end;

function v10.NumberU16(p87) -- Line: 216
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v88 = u5 + 2;

    if u4 < v88 then
        while u4 < v88 do
            u4 = u4 * 2;
        end;

        local v89 = buffer.create(u4);
        buffer.copy(v89, 0, u3, 0, u5);
        u2.Buffer = v89;
        u3 = v89;
    end;

    buffer.writeu16(u3, u5, p87);
    u5 = u5 + 2;
end;

v8.NumberU24 = "NumberU24";

function v9.NumberU24() -- Line: 219
    -- upvalues: u3 (ref), u5 (ref)
    local v90 = buffer.readbits(u3, u5 * 8, 24);
    u5 = u5 + 3;

    return v90;
end;

function v10.NumberU24(p91) -- Line: 220
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v92 = u5 + 3;

    if u4 < v92 then
        while u4 < v92 do
            u4 = u4 * 2;
        end;

        local v93 = buffer.create(u4);
        buffer.copy(v93, 0, u3, 0, u5);
        u2.Buffer = v93;
        u3 = v93;
    end;

    buffer.writebits(u3, u5 * 8, 24, p91);
    u5 = u5 + 3;
end;

v8.NumberU32 = "NumberU32";

function v9.NumberU32() -- Line: 223
    -- upvalues: u3 (ref), u5 (ref)
    local v94 = buffer.readu32(u3, u5);
    u5 = u5 + 4;

    return v94;
end;

function v10.NumberU32(p95) -- Line: 224
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v96 = u5 + 4;

    if u4 < v96 then
        while u4 < v96 do
            u4 = u4 * 2;
        end;

        local v97 = buffer.create(u4);
        buffer.copy(v97, 0, u3, 0, u5);
        u2.Buffer = v97;
        u3 = v97;
    end;

    buffer.writeu32(u3, u5, p95);
    u5 = u5 + 4;
end;

v8.NumberF16 = "NumberF16";

function v9.NumberF16() -- Line: 227
    -- upvalues: ReadF16 (copy)
    return ReadF16();
end;

function v10.NumberF16(p98) -- Line: 228
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), WriteF16 (copy)
    local v99 = u5 + 2;

    if u4 < v99 then
        while u4 < v99 do
            u4 = u4 * 2;
        end;

        local v100 = buffer.create(u4);
        buffer.copy(v100, 0, u3, 0, u5);
        u2.Buffer = v100;
        u3 = v100;
    end;

    WriteF16(p98);
end;

v8.NumberF24 = "NumberF24";

function v9.NumberF24() -- Line: 231
    -- upvalues: ReadF24 (copy)
    return ReadF24();
end;

function v10.NumberF24(p101) -- Line: 232
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), WriteF24 (copy)
    local v102 = u5 + 3;

    if u4 < v102 then
        while u4 < v102 do
            u4 = u4 * 2;
        end;

        local v103 = buffer.create(u4);
        buffer.copy(v103, 0, u3, 0, u5);
        u2.Buffer = v103;
        u3 = v103;
    end;

    WriteF24(p101);
end;

v8.NumberF32 = "NumberF32";

function v9.NumberF32() -- Line: 235
    -- upvalues: u3 (ref), u5 (ref)
    local v104 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return v104;
end;

function v10.NumberF32(p105) -- Line: 236
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v106 = u5 + 4;

    if u4 < v106 then
        while u4 < v106 do
            u4 = u4 * 2;
        end;

        local v107 = buffer.create(u4);
        buffer.copy(v107, 0, u3, 0, u5);
        u2.Buffer = v107;
        u3 = v107;
    end;

    buffer.writef32(u3, u5, p105);
    u5 = u5 + 4;
end;

v8.NumberF64 = "NumberF64";

function v9.NumberF64() -- Line: 239
    -- upvalues: u3 (ref), u5 (ref)
    local v108 = buffer.readf64(u3, u5);
    u5 = u5 + 8;

    return v108;
end;

function v10.NumberF64(p109) -- Line: 240
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v110 = u5 + 8;

    if u4 < v110 then
        while u4 < v110 do
            u4 = u4 * 2;
        end;

        local v111 = buffer.create(u4);
        buffer.copy(v111, 0, u3, 0, u5);
        u2.Buffer = v111;
        u3 = v111;
    end;

    buffer.writef64(u3, u5, p109);
    u5 = u5 + 8;
end;

v8.String = "String";

function v9.String() -- Line: 243
    -- upvalues: u3 (ref), u5 (ref), u1 (copy)
    local v112 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v113 = buffer.readstring(u3, u5, v112);
    u5 = u5 + v112;

    return u1 and utf8.len(v113) == nil and "" or v113;
end;

function v10.String(p114) -- Line: 244
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v115 = #p114;
    local v116 = u5 + (v115 + 1);

    if u4 < v116 then
        while u4 < v116 do
            u4 = u4 * 2;
        end;

        local v117 = buffer.create(u4);
        buffer.copy(v117, 0, u3, 0, u5);
        u2.Buffer = v117;
        u3 = v117;
    end;

    buffer.writeu8(u3, u5, v115);
    u5 = u5 + 1;
    buffer.writestring(u3, u5, p114);
    u5 = u5 + #p114;
end;

v8.StringLong = "StringLong";

function v9.StringLong() -- Line: 247
    -- upvalues: u3 (ref), u5 (ref), u1 (copy)
    local v118 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v119 = buffer.readstring(u3, u5, v118);
    u5 = u5 + v118;

    return u1 and utf8.len(v119) == nil and "" or v119;
end;

function v10.StringLong(p120) -- Line: 248
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v121 = #p120;
    local v122 = u5 + (v121 + 2);

    if u4 < v122 then
        while u4 < v122 do
            u4 = u4 * 2;
        end;

        local v123 = buffer.create(u4);
        buffer.copy(v123, 0, u3, 0, u5);
        u2.Buffer = v123;
        u3 = v123;
    end;

    buffer.writeu16(u3, u5, v121);
    u5 = u5 + 2;
    buffer.writestring(u3, u5, p120);
    u5 = u5 + #p120;
end;

v8.Buffer = "Buffer";

function v9.Buffer() -- Line: 251
    -- upvalues: u3 (ref), u5 (ref)
    local v124 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v125 = buffer.create(v124);
    buffer.copy(v125, 0, u3, u5, v124);
    u5 = u5 + v124;

    return v125;
end;

function v10.Buffer(p126) -- Line: 252
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v127 = buffer.len(p126);
    local v128 = u5 + (1 + v127);

    if u4 < v128 then
        while u4 < v128 do
            u4 = u4 * 2;
        end;

        local v129 = buffer.create(u4);
        buffer.copy(v129, 0, u3, 0, u5);
        u2.Buffer = v129;
        u3 = v129;
    end;

    buffer.writeu8(u3, u5, v127);
    u5 = u5 + 1;
    buffer.copy(u3, u5, p126);
    u5 = u5 + buffer.len(p126);
end;

v8.BufferLong = "BufferLong";

function v9.BufferLong() -- Line: 255
    -- upvalues: u3 (ref), u5 (ref)
    local v130 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v131 = buffer.create(v130);
    buffer.copy(v131, 0, u3, u5, v130);
    u5 = u5 + v130;

    return v131;
end;

function v10.BufferLong(p132) -- Line: 256
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v133 = buffer.len(p132);
    local v134 = u5 + (2 + v133);

    if u4 < v134 then
        while u4 < v134 do
            u4 = u4 * 2;
        end;

        local v135 = buffer.create(u4);
        buffer.copy(v135, 0, u3, 0, u5);
        u2.Buffer = v135;
        u3 = v135;
    end;

    buffer.writeu16(u3, u5, v133);
    u5 = u5 + 2;
    buffer.copy(u3, u5, p132);
    u5 = u5 + buffer.len(p132);
end;

v8.Instance = "Instance";

function v9.Instance() -- Line: 260
    -- upvalues: u7 (ref), u6 (ref)
    u7 = u7 + 1;

    return u6[u7];
end;

function v10.Instance(p136) -- Line: 261
    -- upvalues: u7 (ref), u6 (ref)
    u7 = u7 + 1;
    u6[u7] = p136;
end;

v8.Boolean8 = "Boolean8";

function v9.Boolean8() -- Line: 264
    -- upvalues: u3 (ref), u5 (ref)
    local v137 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return v137 == 1;
end;

function v10.Boolean8(p138) -- Line: 265
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v139 = u5 + 1;

    if u4 < v139 then
        while u4 < v139 do
            u4 = u4 * 2;
        end;

        local v140 = buffer.create(u4);
        buffer.copy(v140, 0, u3, 0, u5);
        u2.Buffer = v140;
        u3 = v140;
    end;

    buffer.writeu8(u3, u5, p138 and 1 or 0);
    u5 = u5 + 1;
end;

v8.NumberRange = "NumberRange";

function v9.NumberRange() -- Line: 268
    -- upvalues: u3 (ref), u5 (ref)
    local new = NumberRange.new;
    local v141 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v142 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return new(v141, v142);
end;

function v10.NumberRange(p143) -- Line: 269
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v144 = u5 + 8;

    if u4 < v144 then
        while u4 < v144 do
            u4 = u4 * 2;
        end;

        local v145 = buffer.create(u4);
        buffer.copy(v145, 0, u3, 0, u5);
        u2.Buffer = v145;
        u3 = v145;
    end;

    buffer.writef32(u3, u5, p143.Min);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p143.Max);
    u5 = u5 + 4;
end;

v8.BrickColor = "BrickColor";

function v9.BrickColor() -- Line: 272
    -- upvalues: u3 (ref), u5 (ref)
    local new = BrickColor.new;
    local v146 = buffer.readu16(u3, u5);
    u5 = u5 + 2;

    return new(v146);
end;

function v10.BrickColor(p147) -- Line: 273
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v148 = u5 + 2;

    if u4 < v148 then
        while u4 < v148 do
            u4 = u4 * 2;
        end;

        local v149 = buffer.create(u4);
        buffer.copy(v149, 0, u3, 0, u5);
        u2.Buffer = v149;
        u3 = v149;
    end;

    buffer.writeu16(u3, u5, p147.Number);
    u5 = u5 + 2;
end;

v8.Color3 = "Color3";

function v9.Color3() -- Line: 276
    -- upvalues: u3 (ref), u5 (ref)
    local fromRGB = Color3.fromRGB;
    local v150 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v151 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v152 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return fromRGB(v150, v151, v152);
end;

function v10.Color3(p153) -- Line: 277
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v154 = u5 + 3;

    if u4 < v154 then
        while u4 < v154 do
            u4 = u4 * 2;
        end;

        local v155 = buffer.create(u4);
        buffer.copy(v155, 0, u3, 0, u5);
        u2.Buffer = v155;
        u3 = v155;
    end;

    buffer.writeu8(u3, u5, p153.R * 255 + 0.5);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, p153.G * 255 + 0.5);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, p153.B * 255 + 0.5);
    u5 = u5 + 1;
end;

v8.UDim = "UDim";

function v9.UDim() -- Line: 280
    -- upvalues: u3 (ref), u5 (ref)
    local new = UDim.new;
    local v156 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v157 = buffer.readi16(u3, u5);
    u5 = u5 + 2;

    return new(v156 / 1000, v157);
end;

function v10.UDim(p158) -- Line: 281
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v159 = u5 + 4;

    if u4 < v159 then
        while u4 < v159 do
            u4 = u4 * 2;
        end;

        local v160 = buffer.create(u4);
        buffer.copy(v160, 0, u3, 0, u5);
        u2.Buffer = v160;
        u3 = v160;
    end;

    buffer.writei16(u3, u5, p158.Scale * 1000);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p158.Offset);
    u5 = u5 + 2;
end;

v8.UDim2 = "UDim2";

function v9.UDim2() -- Line: 284
    -- upvalues: u3 (ref), u5 (ref)
    local new = UDim2.new;
    local v161 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v162 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v163 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v164 = buffer.readi16(u3, u5);
    u5 = u5 + 2;

    return new(v161 / 1000, v162, v163 / 1000, v164);
end;

function v10.UDim2(p165) -- Line: 285
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v166 = u5 + 8;

    if u4 < v166 then
        while u4 < v166 do
            u4 = u4 * 2;
        end;

        local v167 = buffer.create(u4);
        buffer.copy(v167, 0, u3, 0, u5);
        u2.Buffer = v167;
        u3 = v167;
    end;

    buffer.writei16(u3, u5, p165.X.Scale * 1000);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p165.X.Offset);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p165.Y.Scale * 1000);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p165.Y.Offset);
    u5 = u5 + 2;
end;

v8.Rect = "Rect";

function v9.Rect() -- Line: 288
    -- upvalues: u3 (ref), u5 (ref)
    local new = Rect.new;
    local v168 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v169 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v170 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v171 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return new(v168, v169, v170, v171);
end;

function v10.Rect(p172) -- Line: 289
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v173 = u5 + 16;

    if u4 < v173 then
        while u4 < v173 do
            u4 = u4 * 2;
        end;

        local v174 = buffer.create(u4);
        buffer.copy(v174, 0, u3, 0, u5);
        u2.Buffer = v174;
        u3 = v174;
    end;

    buffer.writef32(u3, u5, p172.Min.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p172.Min.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p172.Max.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p172.Max.Y);
    u5 = u5 + 4;
end;

v8.Vector2S16 = "Vector2S16";

function v9.Vector2S16() -- Line: 292
    -- upvalues: u3 (ref), u5 (ref)
    local new = Vector2.new;
    local v175 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v176 = buffer.readi16(u3, u5);
    u5 = u5 + 2;

    return new(v175, v176);
end;

function v10.Vector2S16(p177) -- Line: 293
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v178 = u5 + 4;

    if u4 < v178 then
        while u4 < v178 do
            u4 = u4 * 2;
        end;

        local v179 = buffer.create(u4);
        buffer.copy(v179, 0, u3, 0, u5);
        u2.Buffer = v179;
        u3 = v179;
    end;

    buffer.writei16(u3, u5, p177.X);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p177.Y);
    u5 = u5 + 2;
end;

v8.Vector2F24 = "Vector2F24";

function v9.Vector2F24() -- Line: 296
    -- upvalues: ReadF24 (copy)
    return Vector2.new(ReadF24(), (ReadF24()));
end;

function v10.Vector2F24(p180) -- Line: 297
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), WriteF24 (copy)
    local v181 = u5 + 6;

    if u4 < v181 then
        while u4 < v181 do
            u4 = u4 * 2;
        end;

        local v182 = buffer.create(u4);
        buffer.copy(v182, 0, u3, 0, u5);
        u2.Buffer = v182;
        u3 = v182;
    end;

    WriteF24(p180.X);
    WriteF24(p180.Y);
end;

v8.Vector2F32 = "Vector2F32";

function v9.Vector2F32() -- Line: 300
    -- upvalues: u3 (ref), u5 (ref)
    local new = Vector2.new;
    local v183 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v184 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return new(v183, v184);
end;

function v10.Vector2F32(p185) -- Line: 301
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v186 = u5 + 8;

    if u4 < v186 then
        while u4 < v186 do
            u4 = u4 * 2;
        end;

        local v187 = buffer.create(u4);
        buffer.copy(v187, 0, u3, 0, u5);
        u2.Buffer = v187;
        u3 = v187;
    end;

    buffer.writef32(u3, u5, p185.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p185.Y);
    u5 = u5 + 4;
end;

v8.Vector3S16 = "Vector3S16";

function v9.Vector3S16() -- Line: 304
    -- upvalues: u3 (ref), u5 (ref)
    local v188 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v189 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v190 = buffer.readi16(u3, u5);
    u5 = u5 + 2;

    return Vector3.new(v188, v189, v190);
end;

function v10.Vector3S16(p191) -- Line: 305
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v192 = u5 + 6;

    if u4 < v192 then
        while u4 < v192 do
            u4 = u4 * 2;
        end;

        local v193 = buffer.create(u4);
        buffer.copy(v193, 0, u3, 0, u5);
        u2.Buffer = v193;
        u3 = v193;
    end;

    buffer.writei16(u3, u5, p191.X);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p191.Y);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p191.Z);
    u5 = u5 + 2;
end;

v8.Vector3F24 = "Vector3F24";

function v9.Vector3F24() -- Line: 308
    -- upvalues: ReadF24 (copy)
    local v194 = ReadF24();
    local v195 = ReadF24();
    local v196 = ReadF24();

    return Vector3.new(v194, v195, v196);
end;

function v10.Vector3F24(p197) -- Line: 309
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), WriteF24 (copy)
    local v198 = u5 + 9;

    if u4 < v198 then
        while u4 < v198 do
            u4 = u4 * 2;
        end;

        local v199 = buffer.create(u4);
        buffer.copy(v199, 0, u3, 0, u5);
        u2.Buffer = v199;
        u3 = v199;
    end;

    WriteF24(p197.X);
    WriteF24(p197.Y);
    WriteF24(p197.Z);
end;

v8.InstanceVector3F24Array = "InstanceVector3F24Array";

function v9.InstanceVector3F24Array() -- Line: 312
    -- upvalues: u3 (ref), u5 (ref), u7 (ref), u6 (ref), ReadF24 (copy)
    local v200 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v201 = table.create(v200);

    for i = 1, v200 do
        local v202 = {};
        u7 = u7 + 1;
        local v203 = u6[u7];
        local v204 = ReadF24();
        local v205 = ReadF24();
        local v206 = ReadF24();
        v202[1], v202[2] = v203, Vector3.new(v204, v205, v206);
        v201[i] = v202;
    end;

    return v201;
end;

function v10.InstanceVector3F24Array(p207) -- Line: 320
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), u7 (ref), u6 (ref), WriteF24 (copy)
    local v208 = #p207;
    local v209 = v208 > 65535 and 65535 or v208;
    local v210 = u5 + 2;

    if u4 < v210 then
        while u4 < v210 do
            u4 = u4 * 2;
        end;

        local v211 = buffer.create(u4);
        buffer.copy(v211, 0, u3, 0, u5);
        u2.Buffer = v211;
        u3 = v211;
    end;

    buffer.writeu16(u3, u5, v209);
    u5 = u5 + 2;

    for i = 1, v209 do
        local v212 = p207[i];
        u7 = u7 + 1;
        u6[u7] = v212[1];
        local v213 = v212[2];
        local v214 = u5 + 9;

        if u4 < v214 then
            while u4 < v214 do
                u4 = u4 * 2;
            end;

            local v215 = buffer.create(u4);
            buffer.copy(v215, 0, u3, 0, u5);
            u2.Buffer = v215;
            u3 = v215;
        end;

        WriteF24(v213.X);
        WriteF24(v213.Y);
        WriteF24(v213.Z);
    end;
end;

v8.Vector3F32 = "Vector3F32";

function v9.Vector3F32() -- Line: 337
    -- upvalues: u3 (ref), u5 (ref)
    local v216 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v217 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v218 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return Vector3.new(v216, v217, v218);
end;

function v10.Vector3F32(p219) -- Line: 338
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v220 = u5 + 12;

    if u4 < v220 then
        while u4 < v220 do
            u4 = u4 * 2;
        end;

        local v221 = buffer.create(u4);
        buffer.copy(v221, 0, u3, 0, u5);
        u2.Buffer = v221;
        u3 = v221;
    end;

    buffer.writef32(u3, u5, p219.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p219.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p219.Z);
    u5 = u5 + 4;
end;

v8.NumberU4 = "NumberU4";

function v9.NumberU4() -- Line: 341
    -- upvalues: u5 (ref), u3 (ref)
    local v222 = u5 * 8;
    u5 = u5 + 1;

    return { buffer.readbits(u3, v222 + 0, 4), buffer.readbits(u3, v222 + 4, 4) };
end;

function v10.NumberU4(p223) -- Line: 349
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v224 = u5 + 1;

    if u4 < v224 then
        while u4 < v224 do
            u4 = u4 * 2;
        end;

        local v225 = buffer.create(u4);
        buffer.copy(v225, 0, u3, 0, u5);
        u2.Buffer = v225;
        u3 = v225;
    end;

    local v226 = u5 * 8;
    u5 = u5 + 1;
    buffer.writebits(u3, v226 + 0, 4, p223[1]);
    buffer.writebits(u3, v226 + 4, 4, p223[2]);
end;

v8.BooleanNumber = "BooleanNumber";

function v9.BooleanNumber() -- Line: 358
    -- upvalues: u5 (ref), u3 (ref)
    local v227 = u5 * 8;
    u5 = u5 + 1;

    return {
        Boolean = buffer.readbits(u3, v227 + 0, 1) == 1,
        Number = buffer.readbits(u3, v227 + 1, 7)
    };
end;

function v10.BooleanNumber(p228) -- Line: 366
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v229 = u5 + 1;

    if u4 < v229 then
        while u4 < v229 do
            u4 = u4 * 2;
        end;

        local v230 = buffer.create(u4);
        buffer.copy(v230, 0, u3, 0, u5);
        u2.Buffer = v230;
        u3 = v230;
    end;

    local v231 = u5 * 8;
    u5 = u5 + 1;
    buffer.writebits(u3, v231 + 0, 1, p228.Boolean and 1 or 0);
    buffer.writebits(u3, v231 + 1, 7, p228.Number);
end;

v8.Boolean1 = "Boolean1";

function v9.Boolean1() -- Line: 375
    -- upvalues: u5 (ref), u3 (ref)
    local v232 = u5 * 8;
    u5 = u5 + 1;

    return {
        buffer.readbits(u3, v232 + 0, 1) == 1,
        buffer.readbits(u3, v232 + 1, 1) == 1,
        buffer.readbits(u3, v232 + 2, 1) == 1,
        buffer.readbits(u3, v232 + 3, 1) == 1,
        buffer.readbits(u3, v232 + 4, 1) == 1,
        buffer.readbits(u3, v232 + 5, 1) == 1,
        buffer.readbits(u3, v232 + 6, 1) == 1,
        buffer.readbits(u3, v232 + 7, 1) == 1
    };
end;

function v10.Boolean1(p233) -- Line: 389
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v234 = u5 + 1;

    if u4 < v234 then
        while u4 < v234 do
            u4 = u4 * 2;
        end;

        local v235 = buffer.create(u4);
        buffer.copy(v235, 0, u3, 0, u5);
        u2.Buffer = v235;
        u3 = v235;
    end;

    local v236 = u5 * 8;
    u5 = u5 + 1;
    buffer.writebits(u3, v236 + 0, 1, p233[1] and 1 or 0);
    buffer.writebits(u3, v236 + 1, 1, p233[2] and 1 or 0);
    buffer.writebits(u3, v236 + 2, 1, p233[3] and 1 or 0);
    buffer.writebits(u3, v236 + 3, 1, p233[4] and 1 or 0);
    buffer.writebits(u3, v236 + 4, 1, p233[5] and 1 or 0);
    buffer.writebits(u3, v236 + 5, 1, p233[6] and 1 or 0);
    buffer.writebits(u3, v236 + 6, 1, p233[7] and 1 or 0);
    buffer.writebits(u3, v236 + 7, 1, p233[8] and 1 or 0);
end;

v8.CFrameF24U8 = "CFrameF24U8";

function v9.CFrameF24U8() -- Line: 404
    -- upvalues: u3 (ref), u5 (ref), ReadF24 (copy)
    local fromEulerAnglesXYZ = CFrame.fromEulerAnglesXYZ;
    local v237 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v238 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v239 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v240 = fromEulerAnglesXYZ(v237 / 40.58451048843331, v238 / 40.58451048843331, v239 / 40.58451048843331);
    local v241 = ReadF24();
    local v242 = ReadF24();
    local v243 = ReadF24();

    return v240 + Vector3.new(v241, v242, v243);
end;

function v10.CFrameF24U8(p244) -- Line: 408
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), WriteF24 (copy)
    local v245, v246, v247 = p244:ToEulerAnglesXYZ();
    local v248 = u5 + 12;

    if u4 < v248 then
        while u4 < v248 do
            u4 = u4 * 2;
        end;

        local v249 = buffer.create(u4);
        buffer.copy(v249, 0, u3, 0, u5);
        u2.Buffer = v249;
        u3 = v249;
    end;

    buffer.writeu8(u3, u5, v245 * 40.58451048843331 + 0.5);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, v246 * 40.58451048843331 + 0.5);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, v247 * 40.58451048843331 + 0.5);
    u5 = u5 + 1;
    WriteF24(p244.X);
    WriteF24(p244.Y);
    WriteF24(p244.Z);
end;

v8.CFrameF32U8 = "CFrameF32U8";

function v9.CFrameF32U8() -- Line: 416
    -- upvalues: u3 (ref), u5 (ref)
    local fromEulerAnglesXYZ = CFrame.fromEulerAnglesXYZ;
    local v250 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v251 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v252 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v253 = fromEulerAnglesXYZ(v250 / 40.58451048843331, v251 / 40.58451048843331, v252 / 40.58451048843331);
    local v254 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v255 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v256 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return v253 + Vector3.new(v254, v255, v256);
end;

function v10.CFrameF32U8(p257) -- Line: 420
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v258, v259, v260 = p257:ToEulerAnglesXYZ();
    local v261 = u5 + 15;

    if u4 < v261 then
        while u4 < v261 do
            u4 = u4 * 2;
        end;

        local v262 = buffer.create(u4);
        buffer.copy(v262, 0, u3, 0, u5);
        u2.Buffer = v262;
        u3 = v262;
    end;

    buffer.writeu8(u3, u5, v258 * 40.58451048843331 + 0.5);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, v259 * 40.58451048843331 + 0.5);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, v260 * 40.58451048843331 + 0.5);
    u5 = u5 + 1;
    buffer.writef32(u3, u5, p257.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p257.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p257.Z);
    u5 = u5 + 4;
end;

v8.CFrameF32U16 = "CFrameF32U16";

function v9.CFrameF32U16() -- Line: 428
    -- upvalues: u3 (ref), u5 (ref)
    local fromEulerAnglesXYZ = CFrame.fromEulerAnglesXYZ;
    local v263 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v264 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v265 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v266 = fromEulerAnglesXYZ(v263 / 10430.219195527361, v264 / 10430.219195527361, v265 / 10430.219195527361);
    local v267 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v268 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v269 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return v266 + Vector3.new(v267, v268, v269);
end;

function v10.CFrameF32U16(p270) -- Line: 432
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v271, v272, v273 = p270:ToEulerAnglesXYZ();
    local v274 = u5 + 18;

    if u4 < v274 then
        while u4 < v274 do
            u4 = u4 * 2;
        end;

        local v275 = buffer.create(u4);
        buffer.copy(v275, 0, u3, 0, u5);
        u2.Buffer = v275;
        u3 = v275;
    end;

    buffer.writeu16(u3, u5, v271 * 10430.219195527361 + 0.5);
    u5 = u5 + 2;
    buffer.writeu16(u3, u5, v272 * 10430.219195527361 + 0.5);
    u5 = u5 + 2;
    buffer.writeu16(u3, u5, v273 * 10430.219195527361 + 0.5);
    u5 = u5 + 2;
    buffer.writef32(u3, u5, p270.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p270.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p270.Z);
    u5 = u5 + 4;
end;

v8.Region3 = "Region3";

function v9.Region3() -- Line: 440
    -- upvalues: u3 (ref), u5 (ref)
    local new = Region3.new;
    local v276 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v277 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v278 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v279 = Vector3.new(v276, v277, v278);
    local v280 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v281 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v282 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return new(v279, (Vector3.new(v280, v281, v282)));
end;

function v10.Region3(p283) -- Line: 446
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v284 = p283.Size / 2;
    local v285 = p283.CFrame.Position - v284;
    local v286 = p283.CFrame.Position + v284;
    local v287 = u5 + 24;

    if u4 < v287 then
        while u4 < v287 do
            u4 = u4 * 2;
        end;

        local v288 = buffer.create(u4);
        buffer.copy(v288, 0, u3, 0, u5);
        u2.Buffer = v288;
        u3 = v288;
    end;

    buffer.writef32(u3, u5, v285.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v285.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v285.Z);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v286.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v286.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v286.Z);
    u5 = u5 + 4;
end;

v8.NumberSequence = "NumberSequence";

function v9.NumberSequence() -- Line: 456
    -- upvalues: u3 (ref), u5 (ref)
    local v289 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v290 = table.create(v289);

    for _ = 1, v289 do
        local new = NumberSequenceKeypoint.new;
        local v291 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v292 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v293 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        table.insert(v290, new(v291 / 255, v292 / 255, v293 / 255));
    end;

    return NumberSequence.new(v290);
end;

function v10.NumberSequence(p294) -- Line: 464
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v295 = #p294.Keypoints;
    local v296 = u5 + (v295 * 3 + 1);

    if u4 < v296 then
        while u4 < v296 do
            u4 = u4 * 2;
        end;

        local v297 = buffer.create(u4);
        buffer.copy(v297, 0, u3, 0, u5);
        u2.Buffer = v297;
        u3 = v297;
    end;

    buffer.writeu8(u3, u5, v295);
    u5 = u5 + 1;

    for _, v in p294.Keypoints do
        buffer.writeu8(u3, u5, v.Time * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Value * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Envelope * 255 + 0.5);
        u5 = u5 + 1;
    end;
end;

v8.ColorSequence = "ColorSequence";

function v9.ColorSequence() -- Line: 474
    -- upvalues: u3 (ref), u5 (ref)
    local v298 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v299 = table.create(v298);

    for _ = 1, v298 do
        local new = ColorSequenceKeypoint.new;
        local v300 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local fromRGB = Color3.fromRGB;
        local v301 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v302 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v303 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        table.insert(v299, new(v300 / 255, fromRGB(v301, v302, v303)));
    end;

    return ColorSequence.new(v299);
end;

function v10.ColorSequence(p304) -- Line: 482
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v305 = #p304.Keypoints;
    local v306 = u5 + (v305 * 4 + 1);

    if u4 < v306 then
        while u4 < v306 do
            u4 = u4 * 2;
        end;

        local v307 = buffer.create(u4);
        buffer.copy(v307, 0, u3, 0, u5);
        u2.Buffer = v307;
        u3 = v307;
    end;

    buffer.writeu8(u3, u5, v305);
    u5 = u5 + 1;

    for _, v in p304.Keypoints do
        buffer.writeu8(u3, u5, v.Time * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Value.R * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Value.G * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Value.B * 255 + 0.5);
        u5 = u5 + 1;
    end;
end;

local Characters = require(script.Characters);
local u308 = {};

for i, v in Characters do
    u308[v] = i;
end;

local v309 = math.log(#Characters + 1, 2);
local u310 = math.ceil(v309);
local u311 = u310 / 8;
v8.Characters = "Characters";

function v9.Characters() -- Line: 498
    -- upvalues: u3 (ref), u5 (ref), u311 (copy), Characters (copy), u310 (copy)
    local v312 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v313 = table.create(v312);
    local v314 = u5 * 8;
    u5 = u5 + math.ceil(v312 * u311);

    for _ = 1, v312 do
        local v315 = Characters[buffer.readbits(u3, v314, u310)];
        table.insert(v313, v315);
        v314 = v314 + u310;
    end;

    return table.concat(v313);
end;

function v10.Characters(p316) -- Line: 509
    -- upvalues: u311 (copy), u5 (ref), u4 (ref), u3 (ref), u2 (ref), u310 (copy), u308 (copy)
    local v317 = #p316;
    local v318 = math.ceil(v317 * u311);
    local v319 = u5 + (v318 + 1);

    if u4 < v319 then
        while u4 < v319 do
            u4 = u4 * 2;
        end;

        local v320 = buffer.create(u4);
        buffer.copy(v320, 0, u3, 0, u5);
        u2.Buffer = v320;
        u3 = v320;
    end;

    buffer.writeu8(u3, u5, v317);
    u5 = u5 + 1;
    local v321 = u5 * 8;

    for i = 1, v317 do
        buffer.writebits(u3, v321, u310, u308[p316:sub(i, i)]);
        v321 = v321 + u310;
    end;

    u5 = u5 + v318;
end;

local Enums = require(script.Enums);
local u322 = {};

for i, v in Enums do
    u322[v] = i;
end;

v8.EnumItem = "EnumItem";

function v9.EnumItem() -- Line: 526
    -- upvalues: Enums (copy), u3 (ref), u5 (ref)
    local v323 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v324 = Enums[v323];
    local v325 = buffer.readu16(u3, u5);
    u5 = u5 + 2;

    return v324:FromValue(v325);
end;

function v10.EnumItem(p326) -- Line: 527
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), u322 (copy)
    local v327 = u5 + 3;

    if u4 < v327 then
        while u4 < v327 do
            u4 = u4 * 2;
        end;

        local v328 = buffer.create(u4);
        buffer.copy(v328, 0, u3, 0, u5);
        u2.Buffer = v328;
        u3 = v328;
    end;

    buffer.writeu8(u3, u5, u322[p326.EnumType]);
    u5 = u5 + 1;
    buffer.writeu16(u3, u5, p326.Value);
    u5 = u5 + 2;
end;

local Static1 = require(script.Static1);
local u329 = {};

for i, v in Static1 do
    u329[v] = i;
end;

v8.Static1 = "Static1";

function v9.Static1() -- Line: 533
    -- upvalues: Static1 (copy), u3 (ref), u5 (ref)
    local v330 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return Static1[v330];
end;

function v10.Static1(p331) -- Line: 534
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), u329 (copy)
    local v332 = u5 + 1;

    if u4 < v332 then
        while u4 < v332 do
            u4 = u4 * 2;
        end;

        local v333 = buffer.create(u4);
        buffer.copy(v333, 0, u3, 0, u5);
        u2.Buffer = v333;
        u3 = v333;
    end;

    buffer.writeu8(u3, u5, u329[p331] or 0);
    u5 = u5 + 1;
end;

local Static2 = require(script.Static2);
local u334 = {};

for i, v in Static2 do
    u334[v] = i;
end;

v8.Static2 = "Static2";

function v9.Static2() -- Line: 540
    -- upvalues: Static2 (copy), u3 (ref), u5 (ref)
    local v335 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return Static2[v335];
end;

function v10.Static2(p336) -- Line: 541
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), u334 (copy)
    local v337 = u5 + 1;

    if u4 < v337 then
        while u4 < v337 do
            u4 = u4 * 2;
        end;

        local v338 = buffer.create(u4);
        buffer.copy(v338, 0, u3, 0, u5);
        u2.Buffer = v338;
        u3 = v338;
    end;

    buffer.writeu8(u3, u5, u334[p336] or 0);
    u5 = u5 + 1;
end;

local Static3 = require(script.Static3);
local u339 = {};

for i, v in Static3 do
    u339[v] = i;
end;

v8.Static3 = "Static3";

function v9.Static3() -- Line: 547
    -- upvalues: Static3 (copy), u3 (ref), u5 (ref)
    local v340 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return Static3[v340];
end;

function v10.Static3(p341) -- Line: 548
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), u339 (copy)
    local v342 = u5 + 1;

    if u4 < v342 then
        while u4 < v342 do
            u4 = u4 * 2;
        end;

        local v343 = buffer.create(u4);
        buffer.copy(v343, 0, u3, 0, u5);
        u2.Buffer = v343;
        u3 = v343;
    end;

    buffer.writeu8(u3, u5, u339[p341] or 0);
    u5 = u5 + 1;
end;

u11[0] = function() -- Line: 552
    return nil;
end;

u12["nil"] = function(p344) -- Line: 553
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v345 = u5 + 1;

    if u4 < v345 then
        while u4 < v345 do
            u4 = u4 * 2;
        end;

        local v346 = buffer.create(u4);
        buffer.copy(v346, 0, u3, 0, u5);
        u2.Buffer = v346;
        u3 = v346;
    end;

    buffer.writeu8(u3, u5, 0);
    u5 = u5 + 1;
end;

u11[1] = function() -- Line: 555
    -- upvalues: u3 (ref), u5 (ref)
    local v347 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return -v347;
end;

u11[2] = function() -- Line: 556
    -- upvalues: u3 (ref), u5 (ref)
    local v348 = buffer.readu16(u3, u5);
    u5 = u5 + 2;

    return -v348;
end;

u11[3] = function() -- Line: 557
    -- upvalues: u3 (ref), u5 (ref)
    local v349 = buffer.readbits(u3, u5 * 8, 24);
    u5 = u5 + 3;

    return -v349;
end;

u11[4] = function() -- Line: 558
    -- upvalues: u3 (ref), u5 (ref)
    local v350 = buffer.readu32(u3, u5);
    u5 = u5 + 4;

    return -v350;
end;

u11[5] = function() -- Line: 559
    -- upvalues: u3 (ref), u5 (ref)
    local v351 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return v351;
end;

u11[6] = function() -- Line: 560
    -- upvalues: u3 (ref), u5 (ref)
    local v352 = buffer.readu16(u3, u5);
    u5 = u5 + 2;

    return v352;
end;

u11[7] = function() -- Line: 561
    -- upvalues: u3 (ref), u5 (ref)
    local v353 = buffer.readbits(u3, u5 * 8, 24);
    u5 = u5 + 3;

    return v353;
end;

u11[8] = function() -- Line: 562
    -- upvalues: u3 (ref), u5 (ref)
    local v354 = buffer.readu32(u3, u5);
    u5 = u5 + 4;

    return v354;
end;

u11[9] = function() -- Line: 563
    -- upvalues: u3 (ref), u5 (ref)
    local v355 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return v355;
end;

u11[10] = function() -- Line: 564
    -- upvalues: u3 (ref), u5 (ref)
    local v356 = buffer.readf64(u3, u5);
    u5 = u5 + 8;

    return v356;
end;

function u12.number(p357) -- Line: 565
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    if p357 % 1 ~= 0 then
        if p357 > -1048576 and p357 < 1048576 then
            local v358 = u5 + 5;

            if u4 < v358 then
                while u4 < v358 do
                    u4 = u4 * 2;
                end;

                local v359 = buffer.create(u4);
                buffer.copy(v359, 0, u3, 0, u5);
                u2.Buffer = v359;
                u3 = v359;
            end;

            buffer.writeu8(u3, u5, 9);
            u5 = u5 + 1;
            buffer.writef32(u3, u5, p357);
            u5 = u5 + 4;

            return;
        end;

        local v360 = u5 + 9;

        if u4 < v360 then
            while u4 < v360 do
                u4 = u4 * 2;
            end;

            local v361 = buffer.create(u4);
            buffer.copy(v361, 0, u3, 0, u5);
            u2.Buffer = v361;
            u3 = v361;
        end;

        buffer.writeu8(u3, u5, 10);
        u5 = u5 + 1;
        buffer.writef64(u3, u5, p357);
        u5 = u5 + 8;

        return;
    end;

    if p357 < 0 then
        if p357 > -256 then
            local v362 = u5 + 2;

            if u4 < v362 then
                while u4 < v362 do
                    u4 = u4 * 2;
                end;

                local v363 = buffer.create(u4);
                buffer.copy(v363, 0, u3, 0, u5);
                u2.Buffer = v363;
                u3 = v363;
            end;

            buffer.writeu8(u3, u5, 1);
            u5 = u5 + 1;
            buffer.writeu8(u3, u5, -p357);
            u5 = u5 + 1;

            return;
        end;

        if p357 > -65536 then
            local v364 = u5 + 3;

            if u4 < v364 then
                while u4 < v364 do
                    u4 = u4 * 2;
                end;

                local v365 = buffer.create(u4);
                buffer.copy(v365, 0, u3, 0, u5);
                u2.Buffer = v365;
                u3 = v365;
            end;

            buffer.writeu8(u3, u5, 2);
            u5 = u5 + 1;
            buffer.writeu16(u3, u5, -p357);
            u5 = u5 + 2;

            return;
        end;

        if p357 > -16777216 then
            local v366 = u5 + 4;

            if u4 < v366 then
                while u4 < v366 do
                    u4 = u4 * 2;
                end;

                local v367 = buffer.create(u4);
                buffer.copy(v367, 0, u3, 0, u5);
                u2.Buffer = v367;
                u3 = v367;
            end;

            buffer.writeu8(u3, u5, 3);
            u5 = u5 + 1;
            buffer.writebits(u3, u5 * 8, 24, -p357);
            u5 = u5 + 3;

            return;
        end;

        if p357 > -4294967296 then
            local v368 = u5 + 5;

            if u4 < v368 then
                while u4 < v368 do
                    u4 = u4 * 2;
                end;

                local v369 = buffer.create(u4);
                buffer.copy(v369, 0, u3, 0, u5);
                u2.Buffer = v369;
                u3 = v369;
            end;

            buffer.writeu8(u3, u5, 4);
            u5 = u5 + 1;
            buffer.writeu32(u3, u5, -p357);
            u5 = u5 + 4;

            return;
        end;

        local v370 = u5 + 9;

        if u4 < v370 then
            while u4 < v370 do
                u4 = u4 * 2;
            end;

            local v371 = buffer.create(u4);
            buffer.copy(v371, 0, u3, 0, u5);
            u2.Buffer = v371;
            u3 = v371;
        end;

        buffer.writeu8(u3, u5, 10);
        u5 = u5 + 1;
        buffer.writef64(u3, u5, p357);
        u5 = u5 + 8;

        return;
    end;

    if p357 < 256 then
        local v372 = u5 + 2;

        if u4 < v372 then
            while u4 < v372 do
                u4 = u4 * 2;
            end;

            local v373 = buffer.create(u4);
            buffer.copy(v373, 0, u3, 0, u5);
            u2.Buffer = v373;
            u3 = v373;
        end;

        buffer.writeu8(u3, u5, 5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, p357);
        u5 = u5 + 1;

        return;
    end;

    if p357 < 65536 then
        local v374 = u5 + 3;

        if u4 < v374 then
            while u4 < v374 do
                u4 = u4 * 2;
            end;

            local v375 = buffer.create(u4);
            buffer.copy(v375, 0, u3, 0, u5);
            u2.Buffer = v375;
            u3 = v375;
        end;

        buffer.writeu8(u3, u5, 6);
        u5 = u5 + 1;
        buffer.writeu16(u3, u5, p357);
        u5 = u5 + 2;

        return;
    end;

    if p357 < 16777216 then
        local v376 = u5 + 4;

        if u4 < v376 then
            while u4 < v376 do
                u4 = u4 * 2;
            end;

            local v377 = buffer.create(u4);
            buffer.copy(v377, 0, u3, 0, u5);
            u2.Buffer = v377;
            u3 = v377;
        end;

        buffer.writeu8(u3, u5, 7);
        u5 = u5 + 1;
        buffer.writebits(u3, u5 * 8, 24, p357);
        u5 = u5 + 3;

        return;
    end;

    if p357 < 4294967296 then
        local v378 = u5 + 5;

        if u4 < v378 then
            while u4 < v378 do
                u4 = u4 * 2;
            end;

            local v379 = buffer.create(u4);
            buffer.copy(v379, 0, u3, 0, u5);
            u2.Buffer = v379;
            u3 = v379;
        end;

        buffer.writeu8(u3, u5, 8);
        u5 = u5 + 1;
        buffer.writeu32(u3, u5, p357);
        u5 = u5 + 4;

        return;
    end;

    local v380 = u5 + 9;

    if u4 < v380 then
        while u4 < v380 do
            u4 = u4 * 2;
        end;

        local v381 = buffer.create(u4);
        buffer.copy(v381, 0, u3, 0, u5);
        u2.Buffer = v381;
        u3 = v381;
    end;

    buffer.writeu8(u3, u5, 10);
    u5 = u5 + 1;
    buffer.writef64(u3, u5, p357);
    u5 = u5 + 8;
end;

u11[11] = function() -- Line: 599
    -- upvalues: u3 (ref), u5 (ref), u1 (copy)
    local v382 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v383 = buffer.readstring(u3, u5, v382);
    u5 = u5 + v382;

    return u1 and utf8.len(v383) == nil and "" or v383;
end;

u11[29] = function() -- Line: 603
    -- upvalues: u3 (ref), u5 (ref), u1 (copy)
    local v384 = buffer.readu32(u3, u5);
    u5 = u5 + 4;
    local v385 = buffer.readstring(u3, u5, v384);
    u5 = u5 + v384;

    return u1 and utf8.len(v385) == nil and "" or v385;
end;

function u12.string(p386) -- Line: 604
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v387 = #p386;

    if v387 < 256 then
        local v388 = u5 + (v387 + 2);

        if u4 < v388 then
            while u4 < v388 do
                u4 = u4 * 2;
            end;

            local v389 = buffer.create(u4);
            buffer.copy(v389, 0, u3, 0, u5);
            u2.Buffer = v389;
            u3 = v389;
        end;

        buffer.writeu8(u3, u5, 11);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v387);
        u5 = u5 + 1;
        buffer.writestring(u3, u5, p386);
        u5 = u5 + #p386;

        return;
    end;

    local v390 = u5 + (v387 + 5);

    if u4 < v390 then
        while u4 < v390 do
            u4 = u4 * 2;
        end;

        local v391 = buffer.create(u4);
        buffer.copy(v391, 0, u3, 0, u5);
        u2.Buffer = v391;
        u3 = v391;
    end;

    buffer.writeu8(u3, u5, 29);
    u5 = u5 + 1;
    buffer.writeu32(u3, u5, v387);
    u5 = u5 + 4;
    buffer.writestring(u3, u5, p386);
    u5 = u5 + #p386;
end;

u11[12] = function() -- Line: 613
    -- upvalues: u3 (ref), u5 (ref)
    local v392 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v393 = buffer.create(v392);
    buffer.copy(v393, 0, u3, u5, v392);
    u5 = u5 + v392;

    return v393;
end;

function u12.buffer(p394) -- Line: 614
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v395 = buffer.len(p394);
    local v396 = u5 + (2 + v395);

    if u4 < v396 then
        while u4 < v396 do
            u4 = u4 * 2;
        end;

        local v397 = buffer.create(u4);
        buffer.copy(v397, 0, u3, 0, u5);
        u2.Buffer = v397;
        u3 = v397;
    end;

    buffer.writeu8(u3, u5, 12);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, v395);
    u5 = u5 + 1;
    buffer.copy(u3, u5, p394);
    u5 = u5 + buffer.len(p394);
end;

u11[13] = function() -- Line: 616
    -- upvalues: u7 (ref), u6 (ref)
    u7 = u7 + 1;

    return u6[u7];
end;

function u12.Instance(p398) -- Line: 617
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), u7 (ref), u6 (ref)
    local v399 = u5 + 1;

    if u4 < v399 then
        while u4 < v399 do
            u4 = u4 * 2;
        end;

        local v400 = buffer.create(u4);
        buffer.copy(v400, 0, u3, 0, u5);
        u2.Buffer = v400;
        u3 = v400;
    end;

    buffer.writeu8(u3, u5, 13);
    u5 = u5 + 1;
    u7 = u7 + 1;
    u6[u7] = p398;
end;

u11[14] = function() -- Line: 619
    -- upvalues: u3 (ref), u5 (ref)
    local v401 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return v401 == 1;
end;

function u12.boolean(p402) -- Line: 620
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v403 = u5 + 2;

    if u4 < v403 then
        while u4 < v403 do
            u4 = u4 * 2;
        end;

        local v404 = buffer.create(u4);
        buffer.copy(v404, 0, u3, 0, u5);
        u2.Buffer = v404;
        u3 = v404;
    end;

    buffer.writeu8(u3, u5, 14);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, p402 and 1 or 0);
    u5 = u5 + 1;
end;

u11[15] = function() -- Line: 622
    -- upvalues: u3 (ref), u5 (ref)
    local new = NumberRange.new;
    local v405 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v406 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return new(v405, v406);
end;

function u12.NumberRange(p407) -- Line: 623
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v408 = u5 + 9;

    if u4 < v408 then
        while u4 < v408 do
            u4 = u4 * 2;
        end;

        local v409 = buffer.create(u4);
        buffer.copy(v409, 0, u3, 0, u5);
        u2.Buffer = v409;
        u3 = v409;
    end;

    buffer.writeu8(u3, u5, 15);
    u5 = u5 + 1;
    buffer.writef32(u3, u5, p407.Min);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p407.Max);
    u5 = u5 + 4;
end;

u11[16] = function() -- Line: 625
    -- upvalues: u3 (ref), u5 (ref)
    local new = BrickColor.new;
    local v410 = buffer.readu16(u3, u5);
    u5 = u5 + 2;

    return new(v410);
end;

function u12.BrickColor(p411) -- Line: 626
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v412 = u5 + 3;

    if u4 < v412 then
        while u4 < v412 do
            u4 = u4 * 2;
        end;

        local v413 = buffer.create(u4);
        buffer.copy(v413, 0, u3, 0, u5);
        u2.Buffer = v413;
        u3 = v413;
    end;

    buffer.writeu8(u3, u5, 16);
    u5 = u5 + 1;
    buffer.writeu16(u3, u5, p411.Number);
    u5 = u5 + 2;
end;

u11[17] = function() -- Line: 628
    -- upvalues: u3 (ref), u5 (ref)
    local fromRGB = Color3.fromRGB;
    local v414 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v415 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v416 = buffer.readu8(u3, u5);
    u5 = u5 + 1;

    return fromRGB(v414, v415, v416);
end;

function u12.Color3(p417) -- Line: 629
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v418 = u5 + 4;

    if u4 < v418 then
        while u4 < v418 do
            u4 = u4 * 2;
        end;

        local v419 = buffer.create(u4);
        buffer.copy(v419, 0, u3, 0, u5);
        u2.Buffer = v419;
        u3 = v419;
    end;

    buffer.writeu8(u3, u5, 17);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, p417.R * 255 + 0.5);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, p417.G * 255 + 0.5);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, p417.B * 255 + 0.5);
    u5 = u5 + 1;
end;

u11[18] = function() -- Line: 631
    -- upvalues: u3 (ref), u5 (ref)
    local new = UDim.new;
    local v420 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v421 = buffer.readi16(u3, u5);
    u5 = u5 + 2;

    return new(v420 / 1000, v421);
end;

function u12.UDim(p422) -- Line: 632
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v423 = u5 + 5;

    if u4 < v423 then
        while u4 < v423 do
            u4 = u4 * 2;
        end;

        local v424 = buffer.create(u4);
        buffer.copy(v424, 0, u3, 0, u5);
        u2.Buffer = v424;
        u3 = v424;
    end;

    buffer.writeu8(u3, u5, 18);
    u5 = u5 + 1;
    buffer.writei16(u3, u5, p422.Scale * 1000);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p422.Offset);
    u5 = u5 + 2;
end;

u11[19] = function() -- Line: 634
    -- upvalues: u3 (ref), u5 (ref)
    local new = UDim2.new;
    local v425 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v426 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v427 = buffer.readi16(u3, u5);
    u5 = u5 + 2;
    local v428 = buffer.readi16(u3, u5);
    u5 = u5 + 2;

    return new(v425 / 1000, v426, v427 / 1000, v428);
end;

function u12.UDim2(p429) -- Line: 635
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v430 = u5 + 9;

    if u4 < v430 then
        while u4 < v430 do
            u4 = u4 * 2;
        end;

        local v431 = buffer.create(u4);
        buffer.copy(v431, 0, u3, 0, u5);
        u2.Buffer = v431;
        u3 = v431;
    end;

    buffer.writeu8(u3, u5, 19);
    u5 = u5 + 1;
    buffer.writei16(u3, u5, p429.X.Scale * 1000);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p429.X.Offset);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p429.Y.Scale * 1000);
    u5 = u5 + 2;
    buffer.writei16(u3, u5, p429.Y.Offset);
    u5 = u5 + 2;
end;

u11[20] = function() -- Line: 637
    -- upvalues: u3 (ref), u5 (ref)
    local new = Rect.new;
    local v432 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v433 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v434 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v435 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return new(v432, v433, v434, v435);
end;

function u12.Rect(p436) -- Line: 638
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v437 = u5 + 17;

    if u4 < v437 then
        while u4 < v437 do
            u4 = u4 * 2;
        end;

        local v438 = buffer.create(u4);
        buffer.copy(v438, 0, u3, 0, u5);
        u2.Buffer = v438;
        u3 = v438;
    end;

    buffer.writeu8(u3, u5, 20);
    u5 = u5 + 1;
    buffer.writef32(u3, u5, p436.Min.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p436.Min.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p436.Max.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p436.Max.Y);
    u5 = u5 + 4;
end;

u11[21] = function() -- Line: 640
    -- upvalues: u3 (ref), u5 (ref)
    local new = Vector2.new;
    local v439 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v440 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return new(v439, v440);
end;

function u12.Vector2(p441) -- Line: 641
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v442 = u5 + 9;

    if u4 < v442 then
        while u4 < v442 do
            u4 = u4 * 2;
        end;

        local v443 = buffer.create(u4);
        buffer.copy(v443, 0, u3, 0, u5);
        u2.Buffer = v443;
        u3 = v443;
    end;

    buffer.writeu8(u3, u5, 21);
    u5 = u5 + 1;
    buffer.writef32(u3, u5, p441.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p441.Y);
    u5 = u5 + 4;
end;

u11[22] = function() -- Line: 643
    -- upvalues: u3 (ref), u5 (ref)
    local v444 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v445 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v446 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return Vector3.new(v444, v445, v446);
end;

function u12.Vector3(p447) -- Line: 644
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v448 = u5 + 13;

    if u4 < v448 then
        while u4 < v448 do
            u4 = u4 * 2;
        end;

        local v449 = buffer.create(u4);
        buffer.copy(v449, 0, u3, 0, u5);
        u2.Buffer = v449;
        u3 = v449;
    end;

    buffer.writeu8(u3, u5, 22);
    u5 = u5 + 1;
    buffer.writef32(u3, u5, p447.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p447.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p447.Z);
    u5 = u5 + 4;
end;

u11[23] = function() -- Line: 646
    -- upvalues: u3 (ref), u5 (ref)
    local fromEulerAnglesXYZ = CFrame.fromEulerAnglesXYZ;
    local v450 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v451 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v452 = buffer.readu16(u3, u5);
    u5 = u5 + 2;
    local v453 = fromEulerAnglesXYZ(v450 / 10430.219195527361, v451 / 10430.219195527361, v452 / 10430.219195527361);
    local v454 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v455 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v456 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return v453 + Vector3.new(v454, v455, v456);
end;

function u12.CFrame(p457) -- Line: 650
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v458, v459, v460 = p457:ToEulerAnglesXYZ();
    local v461 = u5 + 19;

    if u4 < v461 then
        while u4 < v461 do
            u4 = u4 * 2;
        end;

        local v462 = buffer.create(u4);
        buffer.copy(v462, 0, u3, 0, u5);
        u2.Buffer = v462;
        u3 = v462;
    end;

    buffer.writeu8(u3, u5, 23);
    u5 = u5 + 1;
    buffer.writeu16(u3, u5, v458 * 10430.219195527361 + 0.5);
    u5 = u5 + 2;
    buffer.writeu16(u3, u5, v459 * 10430.219195527361 + 0.5);
    u5 = u5 + 2;
    buffer.writeu16(u3, u5, v460 * 10430.219195527361 + 0.5);
    u5 = u5 + 2;
    buffer.writef32(u3, u5, p457.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p457.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, p457.Z);
    u5 = u5 + 4;
end;

u11[24] = function() -- Line: 658
    -- upvalues: u3 (ref), u5 (ref)
    local new = Region3.new;
    local v463 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v464 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v465 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v466 = Vector3.new(v463, v464, v465);
    local v467 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v468 = buffer.readf32(u3, u5);
    u5 = u5 + 4;
    local v469 = buffer.readf32(u3, u5);
    u5 = u5 + 4;

    return new(v466, (Vector3.new(v467, v468, v469)));
end;

function u12.Region3(p470) -- Line: 664
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v471 = p470.Size / 2;
    local v472 = p470.CFrame.Position - v471;
    local v473 = p470.CFrame.Position + v471;
    local v474 = u5 + 25;

    if u4 < v474 then
        while u4 < v474 do
            u4 = u4 * 2;
        end;

        local v475 = buffer.create(u4);
        buffer.copy(v475, 0, u3, 0, u5);
        u2.Buffer = v475;
        u3 = v475;
    end;

    buffer.writeu8(u3, u5, 24);
    u5 = u5 + 1;
    buffer.writef32(u3, u5, v472.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v472.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v472.Z);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v473.X);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v473.Y);
    u5 = u5 + 4;
    buffer.writef32(u3, u5, v473.Z);
    u5 = u5 + 4;
end;

u11[25] = function() -- Line: 674
    -- upvalues: u3 (ref), u5 (ref)
    local v476 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v477 = table.create(v476);

    for _ = 1, v476 do
        local new = NumberSequenceKeypoint.new;
        local v478 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v479 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v480 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        table.insert(v477, new(v478 / 255, v479 / 255, v480 / 255));
    end;

    return NumberSequence.new(v477);
end;

function u12.NumberSequence(p481) -- Line: 682
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v482 = #p481.Keypoints;
    local v483 = u5 + (v482 * 3 + 2);

    if u4 < v483 then
        while u4 < v483 do
            u4 = u4 * 2;
        end;

        local v484 = buffer.create(u4);
        buffer.copy(v484, 0, u3, 0, u5);
        u2.Buffer = v484;
        u3 = v484;
    end;

    buffer.writeu8(u3, u5, 25);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, v482);
    u5 = u5 + 1;

    for _, v in p481.Keypoints do
        buffer.writeu8(u3, u5, v.Time * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Value * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Envelope * 255 + 0.5);
        u5 = u5 + 1;
    end;
end;

u11[26] = function() -- Line: 692
    -- upvalues: u3 (ref), u5 (ref)
    local v485 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v486 = table.create(v485);

    for _ = 1, v485 do
        local new = ColorSequenceKeypoint.new;
        local v487 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local fromRGB = Color3.fromRGB;
        local v488 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v489 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v490 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        table.insert(v486, new(v487 / 255, fromRGB(v488, v489, v490)));
    end;

    return ColorSequence.new(v486);
end;

function u12.ColorSequence(p491) -- Line: 700
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref)
    local v492 = #p491.Keypoints;
    local v493 = u5 + (v492 * 4 + 2);

    if u4 < v493 then
        while u4 < v493 do
            u4 = u4 * 2;
        end;

        local v494 = buffer.create(u4);
        buffer.copy(v494, 0, u3, 0, u5);
        u2.Buffer = v494;
        u3 = v494;
    end;

    buffer.writeu8(u3, u5, 26);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, v492);
    u5 = u5 + 1;

    for _, v in p491.Keypoints do
        buffer.writeu8(u3, u5, v.Time * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Value.R * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Value.G * 255 + 0.5);
        u5 = u5 + 1;
        buffer.writeu8(u3, u5, v.Value.B * 255 + 0.5);
        u5 = u5 + 1;
    end;
end;

u11[27] = function() -- Line: 711
    -- upvalues: Enums (copy), u3 (ref), u5 (ref)
    local v495 = buffer.readu8(u3, u5);
    u5 = u5 + 1;
    local v496 = Enums[v495];
    local v497 = buffer.readu16(u3, u5);
    u5 = u5 + 2;

    return v496:FromValue(v497);
end;

function u12.EnumItem(p498) -- Line: 714
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), u322 (copy)
    local v499 = u5 + 4;

    if u4 < v499 then
        while u4 < v499 do
            u4 = u4 * 2;
        end;

        local v500 = buffer.create(u4);
        buffer.copy(v500, 0, u3, 0, u5);
        u2.Buffer = v500;
        u3 = v500;
    end;

    buffer.writeu8(u3, u5, 27);
    u5 = u5 + 1;
    buffer.writeu8(u3, u5, u322[p498.EnumType]);
    u5 = u5 + 1;
    buffer.writeu16(u3, u5, p498.Value);
    u5 = u5 + 2;
end;

u11[28] = function() -- Line: 721
    -- upvalues: u3 (ref), u5 (ref), u11 (copy)
    local v501 = {};

    while true do
        local v502 = buffer.readu8(u3, u5);
        u5 = u5 + 1;

        if v502 == 0 then
            break;
        end;

        local v503 = u11[v502];

        if not v503 then
            error("Packet: unknown Any type tag " .. tostring(v502), 0);
        end;

        local v504 = v503();
        local v505 = buffer.readu8(u3, u5);
        u5 = u5 + 1;
        local v506 = u11[v505];

        if not v506 then
            error("Packet: unknown Any type tag " .. tostring(v505), 0);
        end;

        v501[v504] = v506();
    end;

    return v501;
end;

function u12.table(p507) -- Line: 728
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u2 (ref), u12 (copy)
    local v508 = u5 + 1;

    if u4 < v508 then
        while u4 < v508 do
            u4 = u4 * 2;
        end;

        local v509 = buffer.create(u4);
        buffer.copy(v509, 0, u3, 0, u5);
        u2.Buffer = v509;
        u3 = v509;
    end;

    buffer.writeu8(u3, u5, 28);
    u5 = u5 + 1;

    for i, v in p507 do
        u12[typeof(i)](i);
        u12[typeof(v)](v);
    end;

    local v510 = u5 + 1;

    if u4 < v510 then
        while u4 < v510 do
            u4 = u4 * 2;
        end;

        local v511 = buffer.create(u4);
        buffer.copy(v511, 0, u3, 0, u5);
        u2.Buffer = v511;
        u3 = v511;
    end;

    buffer.writeu8(u3, u5, 0);
    u5 = u5 + 1;
end;

return {
    Import = function(p512) -- Line: 738, Name: Import
        -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref)
        u2 = p512;
        u3 = p512.Buffer;
        u4 = p512.BufferLength;
        u5 = p512.BufferOffset;
        u6 = p512.Instances;
        u7 = p512.InstancesOffset;
    end,

    Export = function() -- Line: 747, Name: Export
        -- upvalues: u2 (ref), u4 (ref), u5 (ref), u7 (ref)
        u2.BufferLength = u4;
        u2.BufferOffset = u5;
        u2.InstancesOffset = u7;

        return u2;
    end,

    Truncate = function() -- Line: 754, Name: Truncate
        -- upvalues: u5 (ref), u3 (ref), u7 (ref), u6 (ref)
        local v513 = buffer.create(u5);
        buffer.copy(v513, 0, u3, 0, u5);

        if u7 == 0 then
            return v513;
        end;

        return v513, u6;
    end,

    Ended = function() -- Line: 760, Name: Ended
        -- upvalues: u5 (ref), u4 (ref)
        return u4 <= u5;
    end,

    Types = v8,
    Reads = v9,
    Writes = v10
};