-- Decompiled with Potassium's decompiler.

local u1 = {
    [36] = true,
    [95] = true
};
local u2 = {
    [36] = true,
    [95] = true
};
local u3 = {
    [0] = -12336,
    [1] = -12592,
    [2] = -12848,
    [3] = -13104,
    [4] = -13360,
    [5] = -13616,
    [6] = -13872,
    [7] = -14128,
    [8] = 25180,
    [9] = 29788,
    [10] = 28252,
    [11] = -25136,
    [12] = 26204,
    [13] = 29276,
    [14] = -25904,
    [15] = -26160,
    [16] = -12337,
    [17] = -12593,
    [18] = -12849,
    [19] = -13105,
    [20] = -13361,
    [21] = -13617,
    [22] = -13873,
    [23] = -14129,
    [24] = -14385,
    [25] = -14641,
    [26] = -24881,
    [27] = -25137,
    [28] = -25393,
    [29] = -25649,
    [30] = -25905,
    [31] = -26161
};

for i = 65, 90 do
    u1[i] = true;
    u2[i] = true;
end;

for i = 97, 122 do
    u1[i] = true;
    u2[i] = true;
end;

u2[48] = true;
u2[49] = true;
u2[50] = true;
u2[51] = true;
u2[52] = true;
u2[53] = true;
u2[54] = true;
u2[55] = true;
u2[56] = true;
u2[57] = true;

local function Stream(p4) -- Line: 91
    return {
        Pos = 0,
        Indent = 0,
        Pretty = false,
        Null = nil,
        QuoteChar = 34,
        UnquoteIdent = false,
        Buf = p4,
        Cap = buffer.len(p4),
        Encoders = {}
    };
end;

local function ToString(p5) -- Line: 105
    return buffer.readstring(p5.Buf, 0, p5.Pos);
end;

local function AllocSize(p6) -- Line: 109
    local v7 = math.log(p6, 2);
    local v8 = 2 ^ math.ceil(v7);

    return math.max(p6, v8);
end;

local function Reserve(p9, p10) -- Line: 113
    local Pos = p9.Pos;
    local v11 = Pos + p10;

    if p9.Cap < v11 then
        local v12 = math.log(v11, 2);
        local v13 = 2 ^ math.ceil(v12);
        local v14 = math.max(v11, v13);
        local v15 = buffer.create(v14);
        buffer.copy(v15, 0, p9.Buf, 0, Pos);
        p9.Buf = v15;
        p9.Cap = v14;
    end;

    p9.Pos = v11;

    return Pos;
end;

local function WriteString(p16, p17) -- Line: 126
    -- upvalues: Reserve (copy)
    local v18 = string.len(p17);
    local v19 = Reserve(p16, v18);
    buffer.writestring(p16.Buf, v19, p17, v18);
end;

local function WriteIndent(p20) -- Line: 132
    -- upvalues: Reserve (copy)
    local v21 = p20.Indent * 2;
    local v22 = Reserve(p20, v21);
    local Buf = p20.Buf;

    for i = 0, v21 - 1 do
        buffer.writeu16(Buf, v22 + i * 2, 8224);
    end;
end;

local function IncrementIndent(p23, p24) -- Line: 141
    p23.Indent = p23.Indent + p24;
end;

local function WriteU8(p25, p26) -- Line: 145
    -- upvalues: Reserve (copy)
    local v27 = Reserve(p25, 1);
    buffer.writeu8(p25.Buf, v27, p26);
end;

local function WriteU16(p28, p29) -- Line: 150
    -- upvalues: Reserve (copy)
    local v30 = Reserve(p28, 2);
    buffer.writeu16(p28.Buf, v30, p29);
end;

local function WriteU32(p31, p32) -- Line: 155
    -- upvalues: Reserve (copy)
    local v33 = Reserve(p31, 4);
    buffer.writeu32(p31.Buf, v33, p32);
end;

local function EncodeNumber(p34, p35) -- Line: 175
    -- upvalues: Reserve (copy)
    if p35 ~= p35 then
        local v36 = Reserve(p34, 3);
        local Buf = p34.Buf;
        buffer.writeu16(Buf, v36, 24910);
        buffer.writeu8(Buf, v36 + 2, 78);

        return;
    end;

    if p35 == (1 / 0) then
        local v37 = Reserve(p34, 8);
        local Buf = p34.Buf;
        buffer.writeu32(Buf, v37, 1768320585);
        buffer.writeu32(Buf, v37 + 4, 2037672302);

        return;
    end;

    if p35 == (-1 / 0) then
        local v38 = Reserve(p34, 9);
        local Buf = p34.Buf;
        buffer.writeu8(Buf, v38, 45);
        buffer.writeu32(Buf, v38 + 1, 1768320585);
        buffer.writeu32(Buf, v38 + 5, 2037672302);

        return;
    end;

    local v39 = tostring(p35);
    local v40 = string.find(v39, "e%+");

    if v40 then
        v39 = string.sub(v39, 1, v40) .. string.sub(v39, v40 + 2);
    end;

    local v41 = string.len(v39);
    local v42 = Reserve(p34, v41);
    buffer.writestring(p34.Buf, v42, v39, v41);
end;

local function IsIdentifierName(p43, p44) -- Line: 202
    -- upvalues: u1 (copy), u2 (copy)
    local v45 = string.len(p44);

    if v45 == 0 then
        return false;
    end;

    if not u1[string.byte(p44, 1)] then
        return false;
    end;

    local v46 = u2;

    for i = 2, v45 do
        if not v46[string.byte(p44, i)] then
            return false;
        end;
    end;

    return true;
end;

local function EncodeString(p47, p48, p49) -- Line: 220
    -- upvalues: u1 (copy), u2 (copy), Reserve (copy), u3 (copy)
    if p49 then
        local v50 = string.len(p48);
        local v51;

        if v50 == 0 or not u1[string.byte(p48, 1)] then
            v51 = false;
        else
            local v52 = u2;
            v51 = true;

            for i = 2, v50 do
                if not v52[string.byte(p48, i)] then
                    v51 = false;
                    break;
                end;
            end;
        end;

        if not v51 then
            p49 = false;
        end;
    end;

    local v53 = string.len(p48);
    local v54 = Reserve(p47, v53 * 6 + 2);
    local Buf = p47.Buf;
    local QuoteChar = p47.QuoteChar;

    if not p49 then
        buffer.writeu8(Buf, v54, QuoteChar);
        v54 = v54 + 1;
    end;

    for i = 1, v53 do
        local v55 = string.byte(p48, i);

        if v55 > 31 then
            if v55 == QuoteChar or v55 == 92 then
                local v56 = bit32.lshift(v55, 8) + 92;
                buffer.writeu16(Buf, v54, v56);
                v54 = v54 + 2;
            else
                buffer.writeu8(Buf, v54, v55);
                v54 = v54 + 1;
            end;
        else
            local v57 = u3[v55];

            if v57 < 0 then
                v57 = -v57;
                buffer.writeu32(Buf, v54, 808482140);
                v54 = v54 + 4;
            end;

            buffer.writeu16(Buf, v54, v57);
            v54 = v54 + 2;
        end;
    end;

    if not p49 then
        buffer.writeu8(Buf, v54, QuoteChar);
        v54 = v54 + 1;
    end;

    p47.Pos = v54;
end;

local function EncodeAny(p58, p59) -- Line: 304
    if p59 == p58.Null then
        p59 = nil;
    end;

    p58.Encoders[typeof(p59)](p58, p59);
end;

local function EncodeArray(p60, p61) -- Line: 311
    -- upvalues: Reserve (copy)
    local Pretty = p60.Pretty;
    local v62 = Reserve(p60, 1);
    buffer.writeu8(p60.Buf, v62, 91);

    if Pretty then
        p60.Indent = p60.Indent + 1;
    end;

    for i, v in ipairs(p61) do
        if i > 1 then
            local v63 = Reserve(p60, 1);
            buffer.writeu8(p60.Buf, v63, 44);
        end;

        if Pretty then
            local v64 = Reserve(p60, 1);
            buffer.writeu8(p60.Buf, v64, 10);
            local v65 = p60.Indent * 2;
            local v66 = Reserve(p60, v65);
            local Buf = p60.Buf;

            for i2 = 0, v65 - 1 do
                buffer.writeu16(Buf, v66 + i2 * 2, 8224);
            end;
        end;

        if v == p60.Null then
            local v = nil;
        end;

        p60.Encoders[typeof(v)](p60, v);
    end;

    if Pretty then
        p60.Indent = p60.Indent + -1;

        if #p61 > 0 then
            local v67 = Reserve(p60, 1);
            buffer.writeu8(p60.Buf, v67, 10);
            local v68 = p60.Indent * 2;
            local v69 = Reserve(p60, v68);
            local Buf = p60.Buf;

            for i = 0, v68 - 1 do
                buffer.writeu16(Buf, v69 + i * 2, 8224);
            end;
        end;
    end;

    local v70 = Reserve(p60, 1);
    buffer.writeu8(p60.Buf, v70, 93);
end;

local function EncodeMap(p71, p72) -- Line: 338
    -- upvalues: Reserve (copy), EncodeString (copy)
    local v73 = {};

    for i, _ in pairs(p72) do
        local v74 = type(i) == "string";
        assert(v74);
        table.insert(v73, i);
    end;

    table.sort(v73);
    local Pretty = p71.Pretty;
    local UnquoteIdent = p71.UnquoteIdent;
    local v75 = Reserve(p71, 1);
    buffer.writeu8(p71.Buf, v75, 123);

    if Pretty then
        p71.Indent = p71.Indent + 1;
    end;

    for i, v in ipairs(v73) do
        if i > 1 then
            local v76 = Reserve(p71, 1);
            buffer.writeu8(p71.Buf, v76, 44);
        end;

        if Pretty then
            local v77 = Reserve(p71, 1);
            buffer.writeu8(p71.Buf, v77, 10);
            local v78 = p71.Indent * 2;
            local v79 = Reserve(p71, v78);
            local Buf = p71.Buf;

            for i2 = 0, v78 - 1 do
                buffer.writeu16(Buf, v79 + i2 * 2, 8224);
            end;
        end;

        EncodeString(p71, v, UnquoteIdent);

        if Pretty then
            local v80 = Reserve(p71, 2);
            buffer.writeu16(p71.Buf, v80, 8250);
        else
            local v81 = Reserve(p71, 1);
            buffer.writeu8(p71.Buf, v81, 58);
        end;

        local v82 = p72[v];

        if v82 == p71.Null then
            v82 = nil;
        end;

        p71.Encoders[typeof(v82)](p71, v82);
    end;

    if Pretty then
        p71.Indent = p71.Indent + -1;

        if #v73 > 0 then
            local v83 = Reserve(p71, 1);
            buffer.writeu8(p71.Buf, v83, 10);
            local v84 = p71.Indent * 2;
            local v85 = Reserve(p71, v84);
            local Buf = p71.Buf;

            for i = 0, v84 - 1 do
                buffer.writeu16(Buf, v85 + i * 2, 8224);
            end;
        end;
    end;

    local v86 = Reserve(p71, 1);
    buffer.writeu8(p71.Buf, v86, 125);
end;

local v104 = {
    ["nil"] = function(p87, p88) -- Line: 160, Name: EncodeNull
        -- upvalues: Reserve (copy)
        local v89 = Reserve(p87, 4);
        buffer.writeu32(p87.Buf, v89, 1819047278);
    end,

    boolean = function(p90, p91) -- Line: 164, Name: EncodeBoolean
        -- upvalues: Reserve (copy)
        if p91 then
            local v92 = Reserve(p90, 4);
            buffer.writeu32(p90.Buf, v92, 1702195828);

            return;
        end;

        local v93 = Reserve(p90, 5);
        local Buf = p90.Buf;
        buffer.writeu32(Buf, v93, 1936482662);
        buffer.writeu8(Buf, v93 + 4, 101);
    end,

    number = EncodeNumber,
    string = EncodeString,

    buffer = function(p94, p95) -- Line: 266, Name: EncodeBuffer
        -- upvalues: Reserve (copy), u3 (copy)
        local v96 = buffer.len(p95);
        local v97 = Reserve(p94, 2 + v96 * 6);
        local Buf = p94.Buf;
        local QuoteChar = p94.QuoteChar;
        buffer.writeu8(Buf, v97, QuoteChar);
        local v98 = v97 + 1;

        for i = 0, v96 - 1 do
            local v99 = buffer.readu8(p95, i);

            if v99 > 31 then
                if v99 == QuoteChar or v99 == 92 then
                    local v100 = bit32.lshift(v99, 8) + 92;
                    buffer.writeu16(Buf, v98, v100);
                    v98 = v98 + 2;
                else
                    buffer.writeu8(Buf, v98, v99);
                    v98 = v98 + 1;
                end;
            else
                local v101 = u3[v99];

                if v101 < 0 then
                    v101 = -v101;
                    buffer.writeu32(Buf, v98, 808482140);
                    v98 = v98 + 4;
                end;

                buffer.writeu16(Buf, v98, v101);
                v98 = v98 + 2;
            end;
        end;

        buffer.writeu8(Buf, v98, QuoteChar);
        p94.Pos = v98 + 1;
    end,

    table = function(p102, p103) -- Line: 377, Name: EncodeTable
        -- upvalues: EncodeArray (copy), EncodeMap (copy)
        if #p103 > 0 or next(p103) == nil then
            EncodeArray(p102, p103);

            return;
        end;

        EncodeMap(p102, p103);
    end
};
local v105 = table.clone(v104);

function v105.Vector2(p106, p107) -- Line: 386
    -- upvalues: EncodeArray (copy)
    EncodeArray(p106, { p107.X, p107.Y });
end;

function v105.Vector3(p108, p109) -- Line: 390
    -- upvalues: EncodeArray (copy)
    EncodeArray(p108, { p109.X, p109.Y, p109.Z });
end;

function v105.Vector2int16(p110, p111) -- Line: 394
    -- upvalues: EncodeArray (copy)
    EncodeArray(p110, { p111.X, p111.Y });
end;

function v105.Vector3int16(p112, p113) -- Line: 398
    -- upvalues: EncodeArray (copy)
    EncodeArray(p112, { p113.X, p113.Y, p113.Z });
end;

function v105.Region3(p114, p115) -- Line: 402
    -- upvalues: EncodeArray (copy)
    local v116 = p115.CFrame * (p115.Size * -0.5);
    local v117 = p115.CFrame * (p115.Size * 0.5);
    EncodeArray(p114, {
        v116.X,
        v116.Y,
        v116.Z,
        v117.X,
        v117.Y,
        v117.Z
    });
end;

function v105.Region3int16(p118, p119) -- Line: 408
    -- upvalues: EncodeArray (copy)
    EncodeArray(p118, {
        p119.Min.X,
        p119.Min.Y,
        p119.Min.Z,
        p119.Max.X,
        p119.Max.Y,
        p119.Max.Z
    });
end;

function v105.UDim(p120, p121) -- Line: 412
    -- upvalues: EncodeArray (copy)
    EncodeArray(p120, { p121.Scale, p121.Offset });
end;

function v105.UDim2(p122, p123) -- Line: 416
    -- upvalues: EncodeArray (copy)
    EncodeArray(p122, {
        p123.X.Scale,
        p123.X.Offset,
        p123.Y.Scale,
        p123.Y.Offset
    });
end;

function v105.CFrame(p124, p125) -- Line: 420
    -- upvalues: EncodeArray (copy)
    EncodeArray(p124, { p125:GetComponents() });
end;

function v105.Color3(p126, p127) -- Line: 424
    -- upvalues: EncodeArray (copy)
    EncodeArray(p126, { math.round(p127.R * 255), math.round(p127.G * 255), (math.round(p127.B * 255)) });
end;

function v105.NumberRange(p128, p129) -- Line: 432
    -- upvalues: EncodeArray (copy)
    EncodeArray(p128, { p129.Min, p129.Max });
end;

function v105.Rect(p130, p131) -- Line: 436
    -- upvalues: EncodeArray (copy)
    EncodeArray(p130, {
        p131.Min.X,
        p131.Min.Y,
        p131.Max.X,
        p131.Max.Y
    });
end;

function v105.EnumItem(p132, p133) -- Line: 440
    -- upvalues: EncodeNumber (copy)
    EncodeNumber(p132, p133.Value);
end;

local v134 = buffer.create(4096);
local u135 = Stream(v134);
u135.Encoders = v104;
local u136 = Stream(v134);
u136.Encoders = v104;
u136.Pretty = true;
local u137 = Stream(v134);
u137.Encoders = v105;
local u138 = Stream(v134);
u138.Encoders = v105;
u138.Pretty = true;
local u139 = Stream(v134);
u139.Encoders = v104;
u139.UnquoteIdent = true;
u139.QuoteChar = 39;
local u140 = Stream(v134);
u140.Encoders = v104;
u140.Pretty = true;
u140.UnquoteIdent = true;
u140.QuoteChar = 39;

return table.freeze({
    Compact = function(p141, p142) -- Line: 473, Name: Compact
        -- upvalues: u135 (copy), ToString (copy)
        local v143 = u135;
        v143.Pos = 0;
        v143.Null = p142;

        if p141 == v143.Null then
            p141 = nil;
        end;

        v143.Encoders[typeof(p141)](v143, p141);

        return ToString(v143);
    end,

    Pretty = function(p144, p145) -- Line: 484, Name: Pretty
        -- upvalues: u136 (copy), ToString (copy)
        local v146 = u136;
        v146.Pos = 0;
        v146.Indent = 0;
        v146.Null = p145;

        if p144 == v146.Null then
            p144 = nil;
        end;

        v146.Encoders[typeof(p144)](v146, p144);

        return ToString(v146);
    end,

    CompactExt = function(p147, p148) -- Line: 495, Name: CompactExt
        -- upvalues: u137 (copy), ToString (copy)
        local v149 = u137;
        v149.Pos = 0;
        v149.Null = p148;

        if p147 == v149.Null then
            p147 = nil;
        end;

        v149.Encoders[typeof(p147)](v149, p147);

        return ToString(v149);
    end,

    PrettyExt = function(p150, p151) -- Line: 506, Name: PrettyExt
        -- upvalues: u138 (copy), ToString (copy)
        local v152 = u138;
        v152.Pos = 0;
        v152.Indent = 0;
        v152.Null = p151;

        if p150 == v152.Null then
            p150 = nil;
        end;

        v152.Encoders[typeof(p150)](v152, p150);

        return ToString(v152);
    end,

    Compact5 = function(p153, p154) -- Line: 520, Name: Compact5
        -- upvalues: u139 (copy), ToString (copy)
        local v155 = u139;
        v155.Pos = 0;
        v155.Null = p154;

        if p153 == v155.Null then
            p153 = nil;
        end;

        v155.Encoders[typeof(p153)](v155, p153);

        return ToString(v155);
    end,

    Pretty5 = function(p156, p157) -- Line: 533, Name: Pretty5
        -- upvalues: u140 (copy), ToString (copy)
        local v158 = u140;
        v158.Pos = 0;
        v158.Indent = 0;
        v158.Null = p157;

        if p156 == v158.Null then
            p156 = nil;
        end;

        v158.Encoders[typeof(p156)](v158, p156);

        return ToString(v158);
    end
});