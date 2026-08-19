-- Decompiled with Potassium's decompiler.

local bxor = bit32.bxor;
local copy = buffer.copy;
local create = buffer.create;
local len = buffer.len;
local readu8 = buffer.readu8;
local readu32 = buffer.readu32;
local _ = buffer.tostring;
local writestring = buffer.writestring;
local writeu8 = buffer.writeu8;
local writeu32 = buffer.writeu32;
local _ = math.floor;
local random = math.random;
local pack = string.pack;
local u1 = create(16);

local function addByteCtr(p2, p3, p4, p5, p6) -- Line: 30
    -- upvalues: readu8 (copy), writeu8 (copy)
    if not p6 then
        local v7 = readu8(p2, p5) + p3;
        writeu8(p2, p5, v7);

        if v7 >= 256 then
            for i = p5 - 1, p4, -1 do
                local v8 = readu8(p2, i) + 1;
                writeu8(p2, i, v8);

                if v8 < 256 then
                    break;
                end;
            end;
        end;
    end;

    local v9 = readu8(p2, p4) + p3;
    writeu8(p2, p4, v9);

    if v9 >= 256 then
        for i = p4 + 1, p5 do
            local v10 = readu8(p2, i) + 1;
            writeu8(p2, i, v10);

            if v10 < 256 then
            end;
        end;
    end;
end;

local v21 = {
    ECB = {
        FwdMode = function(p11, p12, p13, p14) -- Line: 66, Name: FwdMode
            -- upvalues: len (copy)
            local v15 = len(p13) - 16;
            assert(v15 % 16 == 0, "Input length must be a multiple of 16 bytes");

            for i = 0, v15, 16 do
                p11(p13, i, p14, i);
            end;
        end,

        InvMode = function(p16, p17, p18, p19) -- Line: 73, Name: InvMode
            -- upvalues: len (copy)
            local v20 = len(p18) - 16;
            assert(v20 % 16 == 0, "Input length must be a multiple of 16 bytes");

            for i = 0, v20, 16 do
                p17(p18, i, p19, i);
            end;
        end
    }
};
table.freeze(v21.ECB);
v21.CBC = {
    FwdMode = function(p22, p23, p24, p25, p26, p27) -- Line: 89, Name: FwdMode
        -- upvalues: len (copy), u1 (copy), readu32 (copy), bxor (copy), writeu32 (copy)
        local v28 = len(p24) - 16;
        assert(v28 % 16 == 0, "Input length must be a multiple of 16 bytes");
        local v29 = p27 or u1;
        local v30 = len(v29) == 16;
        assert(v30, "Initialization vector must be 16 bytes long");
        writeu32(p25, 0, (bxor(readu32(p24, 0), (readu32(v29, 0)))));
        writeu32(p25, 4, (bxor(readu32(p24, 4), (readu32(v29, 4)))));
        writeu32(p25, 8, (bxor(readu32(p24, 8), (readu32(v29, 8)))));
        writeu32(p25, 12, (bxor(readu32(p24, 12), (readu32(v29, 12)))));
        p22(p25, 0, p25, 0);

        for i = 16, v28, 16 do
            writeu32(p25, i, (bxor(readu32(p24, i), (readu32(p25, i - 16)))));
            writeu32(p25, i + 4, (bxor(readu32(p24, i + 4), (readu32(p25, i - 12)))));
            writeu32(p25, i + 8, (bxor(readu32(p24, i + 8), (readu32(p25, i - 8)))));
            writeu32(p25, i + 12, (bxor(readu32(p24, i + 12), (readu32(p25, i - 4)))));
            p22(p25, i, p25, i);
        end;
    end,

    InvMode = function(p31, p32, p33, p34, p35, p36) -- Line: 107, Name: InvMode
        -- upvalues: len (copy), u1 (copy), readu32 (copy), bxor (copy), writeu32 (copy)
        local v37 = len(p33) - 16;
        assert(v37 % 16 == 0, "Input length must be a multiple of 16 bytes");
        local v38 = p36 or u1;
        local v39 = len(v38) == 16;
        assert(v39, "Initialization vector must be 16 bytes long");
        local v40 = readu32(p33, 0);
        local v41 = readu32(p33, 4);
        local v42 = readu32(p33, 8);
        local v43 = readu32(p33, 12);
        p32(p33, 0, p34, 0);
        writeu32(p34, 0, (bxor(readu32(p34, 0), (readu32(v38, 0)))));
        writeu32(p34, 4, (bxor(readu32(p34, 4), (readu32(v38, 4)))));
        writeu32(p34, 8, (bxor(readu32(p34, 8), (readu32(v38, 8)))));
        writeu32(p34, 12, (bxor(readu32(p34, 12), (readu32(v38, 12)))));

        for i = 16, v37, 16 do
            local v44 = readu32(p33, i);
            local v45 = readu32(p33, i + 4);
            local v46 = readu32(p33, i + 8);
            local v47 = readu32(p33, i + 12);
            p32(p33, i, p34, i);
            writeu32(p34, i, (bxor(readu32(p34, i), v40)));
            writeu32(p34, i + 4, (bxor(readu32(p34, i + 4), v41)));
            writeu32(p34, i + 8, (bxor(readu32(p34, i + 8), v42)));
            writeu32(p34, i + 12, (bxor(readu32(p34, i + 12), v43)));
            v40 = v44;
            v43 = v47;
            v42 = v46;
            v41 = v45;
        end;
    end
};
table.freeze(v21.CBC);
v21.PCBC = {
    FwdMode = function(p48, p49, p50, p51, p52, p53) -- Line: 142, Name: FwdMode
        -- upvalues: len (copy), u1 (copy), readu32 (copy), bxor (copy), writeu32 (copy)
        local v54 = len(p50) - 16;
        assert(v54 % 16 == 0, "Input length must be a multiple of 16 bytes");
        local v55 = p53 or u1;
        local v56 = len(v55) == 16;
        assert(v56, "Initialization vector must be 16 bytes long");
        local v57 = readu32(p50, 0);
        local v58 = readu32(p50, 4);
        local v59 = readu32(p50, 8);
        local v60 = readu32(p50, 12);
        writeu32(p51, 0, (bxor(v57, (readu32(v55, 0)))));
        writeu32(p51, 4, (bxor(v58, (readu32(v55, 4)))));
        writeu32(p51, 8, (bxor(v59, (readu32(v55, 8)))));
        writeu32(p51, 12, (bxor(v60, (readu32(v55, 12)))));
        p48(p51, 0, p51, 0);

        for i = 16, v54, 16 do
            local v61 = readu32(p50, i);
            local v62 = readu32(p50, i + 4);
            local v63 = readu32(p50, i + 8);
            local v64 = readu32(p50, i + 12);
            writeu32(p51, i, (bxor(v57, v61, (readu32(p51, i - 16)))));
            writeu32(p51, i + 4, (bxor(v58, v62, (readu32(p51, i - 12)))));
            writeu32(p51, i + 8, (bxor(v59, v63, (readu32(p51, i - 8)))));
            writeu32(p51, i + 12, (bxor(v60, v64, (readu32(p51, i - 4)))));
            p48(p51, i, p51, i);
            v58 = v62;
            v57 = v61;
            v60 = v64;
            v59 = v63;
        end;
    end,

    InvMode = function(p65, p66, p67, p68, p69, p70) -- Line: 168, Name: InvMode
        -- upvalues: len (copy), u1 (copy), readu32 (copy), bxor (copy), writeu32 (copy)
        local v71 = len(p67) - 16;
        assert(v71 % 16 == 0, "Input length must be a multiple of 16 bytes");
        local v72 = p70 or u1;
        local v73 = len(v72) == 16;
        assert(v73, "Initialization vector must be 16 bytes long");
        local v74 = readu32(p67, 0);
        local v75 = readu32(p67, 4);
        local v76 = readu32(p67, 8);
        local v77 = readu32(p67, 12);
        p66(p67, 0, p68, 0);
        local v78 = bxor(readu32(p68, 0), (readu32(v72, 0)));
        local v79 = bxor(readu32(p68, 4), (readu32(v72, 4)));
        local v80 = bxor(readu32(p68, 8), (readu32(v72, 8)));
        local v81 = bxor(readu32(p68, 12), (readu32(v72, 12)));
        writeu32(p68, 0, v78);
        writeu32(p68, 4, v79);
        writeu32(p68, 8, v80);
        writeu32(p68, 12, v81);
        local v82 = 0;
        local v83 = 8;
        local v84 = 4;
        local v85 = 12;

        for i = 16, v71, 16 do
            v82 = v82 + 16;
            v84 = v84 + 16;
            v83 = v83 + 16;
            v85 = v85 + 16;
            local v86 = readu32(p67, v82);
            local v87 = readu32(p67, v84);
            local v88 = readu32(p67, v83);
            local v89 = readu32(p67, v85);
            p66(p67, i, p68, i);
            v78 = bxor(v74, v78, (readu32(p68, v82)));
            v79 = bxor(v75, v79, (readu32(p68, v84)));
            v80 = bxor(v76, v80, (readu32(p68, v83)));
            v81 = bxor(v77, v81, (readu32(p68, v85)));
            writeu32(p68, v82, v78);
            writeu32(p68, v84, v79);
            writeu32(p68, v83, v80);
            writeu32(p68, v85, v81);
            v75 = v87;
            v77 = v89;
            v76 = v88;
            v74 = v86;
        end;
    end
};
table.freeze(v21.PCBC);

local function cfbFwd(p90, p91, p92, p93, p94, p95) -- Line: 216
    -- upvalues: len (copy), u1 (copy), create (copy), readu8 (copy), bxor (copy), writeu8 (copy), copy (copy)
    local SegmentSize = p94.SegmentSize;
    local v96 = len(p92);
    assert(v96 % SegmentSize == 0, "Input length must be a multiple of segment size");
    local v97 = p95 or u1;
    local v98 = len(v97) == 16;
    assert(v98, "Initialization vector must be 16 bytes long");
    local v99 = p94.CommonTemp or create(31);

    if v96 == SegmentSize then
        p90(v97, 0, v99, 0);

        for i = 0, SegmentSize - 1 do
            writeu8(p93, i, (bxor(readu8(p92, i), (readu8(v99, i)))));
        end;

        return;
    end;

    local v100 = v96 - SegmentSize;
    local v101 = 16 - SegmentSize;
    p90(v97, 0, v99, 0);

    for i = 0, SegmentSize - 1 do
        writeu8(p93, i, (bxor(readu8(p92, i), (readu8(v99, i)))));
    end;

    copy(v99, 0, v97, SegmentSize, v101);
    copy(v99, v101, p93, 0, SegmentSize);

    for i = SegmentSize, v100 - SegmentSize, SegmentSize do
        copy(v99, 16, v99, SegmentSize, v101);
        p90(v99, 0, v99, 0);
        local v102 = 0;

        for i2 = i, i + SegmentSize - 1 do
            writeu8(p93, i2, (bxor(readu8(p92, i2), (readu8(v99, v102)))));
            v102 = v102 + 1;
        end;

        copy(v99, 0, v99, 16, v101);
        copy(v99, v101, p93, i, SegmentSize);
    end;

    p90(v99, 0, v99, 0);
    local v103 = 0;

    for i = v100, v96 - 1 do
        writeu8(p93, i, (bxor(readu8(p92, i), (readu8(v99, v103)))));
        v103 = v103 + 1;
    end;
end;

local function cfbInv(p104, p105, p106, p107, p108, p109) -- Line: 256
    -- upvalues: len (copy), u1 (copy), create (copy), readu8 (copy), bxor (copy), writeu8 (copy), copy (copy)
    local v110 = len(p106);
    local SegmentSize = p108.SegmentSize;
    assert(v110 % SegmentSize == 0, "Input length must be a multiple of segment size");
    local v111 = p109 or u1;
    local v112 = len(v111) == 16;
    assert(v112, "Initialization vector must be 16 bytes long");
    local v113 = p108.CommonTemp or create(31);

    if v110 == SegmentSize then
        p104(v111, 0, v113, 0);

        for i = 0, SegmentSize - 1 do
            writeu8(p107, i, (bxor(readu8(p106, i), (readu8(v113, i)))));
        end;

        return;
    end;

    local v114 = v110 - SegmentSize;
    local v115 = 16 - SegmentSize;
    p104(v111, 0, v113, 0);

    for i = 0, SegmentSize - 1 do
        writeu8(p107, i, (bxor(readu8(p106, i), (readu8(v113, i)))));
    end;

    copy(v113, 0, v111, SegmentSize, v115);
    copy(v113, v115, p106, 0, SegmentSize);

    for i = SegmentSize, v114 - SegmentSize, SegmentSize do
        copy(v113, 16, v113, SegmentSize, v115);
        p104(v113, 0, v113, 0);
        local v116 = 0;

        for i2 = i, i + SegmentSize - 1 do
            writeu8(p107, i2, (bxor(readu8(p106, i2), (readu8(v113, v116)))));
            v116 = v116 + 1;
        end;

        copy(v113, 0, v113, 16, v115);
        copy(v113, v115, p106, i, SegmentSize);
    end;

    p104(v113, 0, v113, 0);
    local v117 = 0;

    for i = v114, v110 - 1 do
        writeu8(p107, i, (bxor(readu8(p106, i), (readu8(v113, v117)))));
        v117 = v117 + 1;
    end;
end;

local function ofbMode(p118, p119, p120, p121, p122, p123) -- Line: 304
    -- upvalues: len (copy), u1 (copy), readu32 (copy), bxor (copy), writeu32 (copy)
    local v124 = len(p120) - 16;
    assert(v124 % 16 == 0, "Input length must be a multiple of 16 bytes");
    local v125 = p123 or u1;
    local v126 = len(v125) == 16;
    assert(v126, "Initialization vector must be 16 bytes long");
    local v127 = readu32(p120, 0);
    local v128 = readu32(p120, 4);
    local v129 = readu32(p120, 8);
    local v130 = readu32(p120, 12);
    p118(v125, 0, p121, 0);
    local v131 = bxor(v127, (readu32(p121, 0)));
    local v132 = bxor(v128, (readu32(p121, 4)));
    local v133 = bxor(v129, (readu32(p121, 8)));
    local v134 = bxor(v130, (readu32(p121, 12)));

    for i = 16, v124, 16 do
        local v135 = readu32(p120, i);
        local v136 = readu32(p120, i + 4);
        local v137 = readu32(p120, i + 8);
        local v138 = readu32(p120, i + 12);
        p118(p121, i - 16, p121, i);
        writeu32(p121, i - 16, v131);
        writeu32(p121, i - 12, v132);
        writeu32(p121, i - 8, v133);
        writeu32(p121, i - 4, v134);
        v131 = bxor(v135, (readu32(p121, i)));
        v132 = bxor(v136, (readu32(p121, i + 4)));
        v133 = bxor(v137, (readu32(p121, i + 8)));
        v134 = bxor(v138, (readu32(p121, i + 12)));
    end;

    writeu32(p121, v124, v131);
    writeu32(p121, v124 + 4, v132);
    writeu32(p121, v124 + 8, v133);
    writeu32(p121, v124 + 12, v134);
end;

v21.OFB = {
    FwdMode = ofbMode,
    InvMode = ofbMode
};
table.freeze(v21.OFB);

local function ctrMode(p139, p140, p141, p142, p143) -- Line: 357
    -- upvalues: len (copy), writestring (copy), readu32 (copy), bxor (copy), writeu32 (copy), addByteCtr (copy)
    local v144 = len(p141) - 16;
    assert(v144 % 16 == 0, "Input length must be a multiple of 16 bytes");
    local CommonTemp = p143.CommonTemp;
    local InitValue = p143.InitValue;
    local Prefix = p143.Prefix;
    local Suffix = p143.Suffix;
    local Step = p143.Step;
    local LittleEndian = p143.LittleEndian;
    local v145 = #Prefix;
    local v146 = v145 + #InitValue - 1;
    writestring(CommonTemp, 0, Prefix);
    writestring(CommonTemp, v145, InitValue);
    writestring(CommonTemp, v146 + 1, Suffix);
    local v147 = readu32(p141, 0);
    local v148 = readu32(p141, 4);
    local v149 = readu32(p141, 8);
    local v150 = readu32(p141, 12);
    p139(CommonTemp, 0, p142, 0);
    writeu32(p142, 0, (bxor(readu32(p142, 0), v147)));
    writeu32(p142, 4, (bxor(readu32(p142, 4), v148)));
    writeu32(p142, 8, (bxor(readu32(p142, 8), v149)));
    writeu32(p142, 12, (bxor(readu32(p142, 12), v150)));

    for i = 16, v144, 16 do
        local v151 = readu32(p141, i);
        local v152 = readu32(p141, i + 4);
        local v153 = readu32(p141, i + 8);
        local v154 = readu32(p141, i + 12);
        addByteCtr(CommonTemp, Step, v145, v146, LittleEndian);
        p139(CommonTemp, 0, p142, i);
        writeu32(p142, i, (bxor(v151, (readu32(p142, i)))));
        writeu32(p142, i + 4, (bxor(v152, (readu32(p142, i + 4)))));
        writeu32(p142, i + 8, (bxor(v153, (readu32(p142, i + 8)))));
        writeu32(p142, i + 12, (bxor(v154, (readu32(p142, i + 12)))));
    end;
end;

local v157 = {
    __index = function(p155, p156) -- Line: 390, Name: __index
        -- upvalues: cfbFwd (copy), cfbInv (copy), create (copy), ctrMode (copy), pack (copy), random (copy)
        return p156 == "CFB" and {
            SegmentSize = 16,
            FwdMode = cfbFwd,
            InvMode = cfbInv,
            CommonTemp = create(31)
        } or (p156 == "CTR" and {
            Prefix = "",
            Suffix = "",
            Step = 1,
            LittleEndian = false,
            FwdMode = ctrMode,
            InvMode = ctrMode,
            InitValue = pack("I2I2I2I2I2I2I2I2", random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535)),
            CommonTemp = create(16)
        } or nil);
    end,

    __newindex = function() -- Line: 403, Name: __newindex
    end
};
setmetatable(v21, v157);
v21.CFB = {};
v21.CTR = {};
table.freeze(v21);
v157.__metatable = "This metatable is locked";

return v21;