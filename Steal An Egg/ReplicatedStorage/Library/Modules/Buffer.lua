-- Decompiled with Potassium's decompiler.

local create = buffer.create;
local fromstring = buffer.fromstring;
local tostring = buffer.tostring;
local len = buffer.len;
local readi8 = buffer.readi8;
local readu8 = buffer.readu8;
local readi16 = buffer.readi16;
local readu16 = buffer.readu16;
local readi32 = buffer.readi32;
local readu32 = buffer.readu32;
local readf32 = buffer.readf32;
local readf64 = buffer.readf64;
local writei8 = buffer.writei8;
local writeu8 = buffer.writeu8;
local writei16 = buffer.writei16;
local writeu16 = buffer.writeu16;
local writei32 = buffer.writei32;
local writeu32 = buffer.writeu32;
local writef32 = buffer.writef32;
local writef64 = buffer.writef64;
local readstring = buffer.readstring;
local writestring = buffer.writestring;
local copy = buffer.copy;
local fill = buffer.fill;
local band = bit32.band;
local bor = bit32.bor;
local lshift = bit32.lshift;
local rshift = bit32.rshift;
local bnot = bit32.bnot;
local len2 = string.len;
local floor = math.floor;
local min = math.min;
local ldexp = math.ldexp;
local log = math.log;
local clamp = math.clamp;
local u1 = create(8);
local u2 = {};
local u4 = {
    __index = u2,

    __tostring = function(p3) -- Line: 45, Name: __tostring
        -- upvalues: readstring (copy)
        local _pos = p3._pos;
        local _lim = p3._lim;

        return readstring(p3._h, p3._off + _pos, _pos <= _lim and (_lim - _pos or 0) or 0);
    end
};

local function remainingSpan(p5, p6) -- Line: 53
    return p5 <= p6 and p6 - p5 or 0;
end;

local function f32tobits(p7) -- Line: 57
    -- upvalues: u1 (copy), writef32 (copy), readu32 (copy)
    writef32(u1, 0, p7);

    return readu32(u1, 0);
end;

local function bitstof32(p8) -- Line: 62
    -- upvalues: u1 (copy), writeu32 (copy), readf32 (copy)
    writeu32(u1, 0, p8);

    return readf32(u1, 0);
end;

local function f64tobits(p9) -- Line: 67
    -- upvalues: u1 (copy), writef64 (copy), readu32 (copy)
    writef64(u1, 0, p9);

    return readu32(u1, 0), readu32(u1, 4);
end;

local function bitstof64(p10, p11) -- Line: 72
    -- upvalues: u1 (copy), writeu32 (copy), readf64 (copy)
    writeu32(u1, 0, p10);
    writeu32(u1, 4, p11);

    return readf64(u1, 0);
end;

local function decomposef16(p12) -- Line: 83
    -- upvalues: log (copy), floor (copy), clamp (copy)
    warn("I don\'t think this is correct");
    local v13;

    if p12 < 0 then
        p12 = -p12;
        v13 = 1;
    else
        v13 = 0;
    end;

    if p12 == 0 then
        return v13, 0, 0;
    end;

    if p12 == (1 / 0) then
        return v13, 31, 0;
    end;

    local v14 = floor((log(p12, 2)));
    local v15 = floor((p12 / 2 ^ v14 - 1) * 1024);

    return v13, clamp(v14 + 15, 0, 31), v15;
end;

local function composef16(p16, p17, p18) -- Line: 104
    -- upvalues: ldexp (copy)
    warn("I don\'t think this is correct");
    local v19 = 1 - p16 * 2;

    if p17 == 0 then
        return p18 == 0 and 0 or v19 * ldexp(p18 / 1024, -14);
    end;

    if p17 == 31 then
        return p18 ~= 0 and (0 / 0) or v19 * (1 / 0);
    end;

    return v19 * ldexp(p18 / 1024 + 1, p17 - 15);
end;

local function buffer_readu24(p20, p21) -- Line: 116
    error("nyi");
end;

local function buffer_readi24(p22, p23) -- Line: 120
    error("nyi");
end;

local function buffer_writeu24(p24, p25, p26) -- Line: 124
    error("nyi");
end;

local function buffer_writei24(p27, p28, p29) -- Line: 128
    error("nyi");
end;

local function buffer_readu64(p30, p31) -- Line: 132
    -- upvalues: readu32 (copy)
    return readu32(p30, p31) + readu32(p30, p31 + 4) * 4294967296;
end;

local function buffer_readi64(p32, p33) -- Line: 136
    -- upvalues: readu32 (copy), readi32 (copy)
    return readu32(p32, p33) + readi32(p32, p33 + 4) * 4294967296;
end;

local function buffer_writeu64(p34, p35, p36) -- Line: 140
    -- upvalues: writeu32 (copy)
    writeu32(p34, p35, p36);
    writeu32(p34, p35 + 4, p36 // 4294967296);
end;

local function buffer_writei64(p37, p38, p39) -- Line: 145
    -- upvalues: writeu32 (copy), writei32 (copy)
    writeu32(p37, p38, p39);
    writei32(p37, p38 + 4, p39 // 4294967296);
end;

local function buffer_readf16(p40, p41) -- Line: 150
    -- upvalues: readu16 (copy), composef16 (copy), rshift (copy), band (copy)
    local v42 = readu16(p40, p41);

    return composef16(rshift(v42, 15), band(rshift(v42, 10), 31), (band(v42, 1023)));
end;

local function buffer_writef16(p43, p44, p45) -- Line: 155
    -- upvalues: decomposef16 (copy), composef16 (copy), lshift (copy), bor (copy), writeu16 (copy)
    local v46, v47, v48 = decomposef16(p45);
    composef16(v46, v47, v48);
    writeu16(p43, p44, (bor(lshift(v46, 15), lshift(v47, 10), v48)));
end;

local function isbuffer(p49) -- Line: 161
    -- upvalues: u4 (copy)
    return type(p49) == "table" and getmetatable(p49) == u4;
end;

local function isnumber(p50) -- Line: 165
    return type(p50) == "number";
end;

local function isint(p51) -- Line: 169
    -- upvalues: floor (copy)
    return p51 == floor(p51);
end;

local function isu8(p52) -- Line: 173
    -- upvalues: band (copy)
    return p52 == band(p52, 255);
end;

local function isu16(p53) -- Line: 177
    -- upvalues: band (copy)
    return p53 == band(p53, 65535);
end;

local function isu24(p54) -- Line: 181
    -- upvalues: band (copy)
    return p54 == band(p54, 16777215);
end;

local function isu32(p55) -- Line: 185
    -- upvalues: lshift (copy)
    return p55 == lshift(p55, 0);
end;

local function isu64(p56) -- Line: 189
    -- upvalues: lshift (copy)
    return p56 == lshift(p56, 0) + lshift(p56 // 4294967296, 0) * 4294967296;
end;

local function isi8(p57) -- Line: 193
    -- upvalues: band (copy)
    local v58 = p57 + 128;

    return v58 == band(v58, 255);
end;

local function isi16(p59) -- Line: 198
    -- upvalues: band (copy)
    local v60 = p59 + 32768;

    return v60 == band(v60, 65535);
end;

local function isi24(p61) -- Line: 203
    -- upvalues: band (copy)
    local v62 = p61 + 8388608;

    return v62 == band(v62, 16777215);
end;

local function isi32(p63) -- Line: 208
    -- upvalues: lshift (copy)
    local v64 = p63 + 2147483648;

    return v64 == lshift(v64, 0);
end;

local function isi64(p65) -- Line: 213
    -- upvalues: lshift (copy)
    local v66 = lshift(p65, 0);
    local v67 = p65 // 4294967296;
    local v68 = v67 + 2147483648;
    local v69 = v68 == lshift(v68, 0) and p65 == v66 + v67 * 4294967296;

    return v69;
end;

local function isstring(p70) -- Line: 223
    return type(p70) == "string";
end;

local function checkFromIndexSize(p71, p72, p73) -- Line: 227
    local v74;

    if p73 > 0 and (p71 > 0 and p72 > 0) then
        v74 = p72 <= p73 - p71;
    else
        v74 = false;
    end;

    assert(v74, "outofbounds");

    return p71;
end;

local function readIndex(p75) -- Line: 246
    local _pos = p75._pos;
    assert(_pos < p75._lim, "underflow");
    p75._pos = _pos + 1;

    return p75._off + _pos;
end;

local function readIndexOf(p76, p77) -- Line: 253
    local _pos = p76._pos;
    assert(p77 <= p76._lim - _pos, "underflow");
    p76._pos = _pos + p77;

    return p76._off + _pos;
end;

local function writeIndex(p78) -- Line: 260
    assert(not p78._ro, "readonly");
    local _pos = p78._pos;
    assert(_pos < p78._lim, "overflow");
    p78._pos = _pos + 1;

    return p78._off + _pos;
end;

local function writeIndexOf(p79, p80) -- Line: 268
    assert(not p79._ro, "readonly");
    local _pos = p79._pos;
    assert(p80 <= p79._lim - _pos, "overflow");
    p79._pos = _pos + p80;

    return p79._off + _pos;
end;

local function getIndex(p81, p82) -- Line: 276
    -- upvalues: floor (copy)
    local v83 = p82 == floor(p82);
    assert(v83, "isint");
    assert(p82 >= 0 and p82 < p81._lim, "outofbounds");

    return p81._off + p82;
end;

local function getIndexOf(p84, p85, p86) -- Line: 282
    -- upvalues: floor (copy)
    local v87 = p85 == floor(p85);
    assert(v87, "isint");
    assert(p85 >= 0 and p85 < p84._lim - p86 + 1, "outofbounds");

    return p84._off + p85;
end;

local function putIndex(p88, p89) -- Line: 288
    -- upvalues: floor (copy)
    local v90 = p89 == floor(p89);
    assert(v90, "isint");
    assert(not p88._ro, "readonly");
    assert(p89 >= 0 and p89 < p88._lim, "outofbounds");

    return p88._off + p89;
end;

local function putIndexOf(p91, p92, p93) -- Line: 295
    -- upvalues: floor (copy)
    local v94 = p92 == floor(p92);
    assert(v94, "isint");
    assert(not p91._ro, "readonly");
    assert(p92 >= 0 and p92 < p91._lim - p93 + 1, "outofbounds");

    return p91._off + p92;
end;

local function copyBuffer(p95, p96, p97, p98, p99) -- Line: 302
    -- upvalues: copy (copy)
    copy(p95._h, p95._off + p96, p97._h, p97._off + p98, p99);
end;

local function writeBuffer(p100, p101) -- Line: 306
    -- upvalues: copy (copy)
    assert(p100 ~= p101, "src~=dst");
    assert(not p101._ro, "readonly");
    local _pos = p100._pos;
    local _lim = p100._lim;
    local v102 = _pos <= _lim and (_lim - _pos or 0) or 0;
    local _pos2 = p101._pos;
    local _lim2 = p101._lim;
    assert(v102 <= (_pos2 <= _lim2 and (_lim2 - _pos2 or 0) or 0), "overflow");
    copy(p101._h, p101._off + _pos2, p100._h, p100._off + _pos, v102);
    p101._pos = _pos2 + v102;
    p100._pos = _pos + v102;
end;

local function getBuffer(p103, p104, p105) -- Line: 318
    -- upvalues: floor (copy), copy (copy)
    local v106 = p104 == floor(p104);
    assert(v106, "isint");
    assert(not p105._ro, "readonly");
    local _pos = p105._pos;
    local _lim = p105._lim;
    local v107 = _pos <= _lim and (_lim - _pos or 0) or 0;
    assert(p104 >= 0 and p104 < p103._lim - v107 + 1, "outofbounds");
    copy(p105._h, p105._off + _pos, p103._h, p103._off + p104, v107);
end;

local function putBuffer(p108, p109, p110) -- Line: 327
    -- upvalues: floor (copy), copy (copy)
    local v111 = p109 == floor(p109);
    assert(v111, "isint");
    assert(not p108._ro, "readonly");
    local _pos = p110._pos;
    local _lim = p110._lim;
    local v112 = _pos <= _lim and (_lim - _pos or 0) or 0;
    assert(p109 >= 0 and p109 < p108._lim - v112 + 1, "outofbounds");
    copy(p108._h, p108._off + p109, p110._h, p110._off + _pos, v112);
end;

local function wrap(p113, p114, p115) -- Line: 336
    -- upvalues: u4 (copy)
    return setmetatable({
        _mark = -1,
        _pos = 0,
        _bpos = 0,
        _ro = false,
        _lim = p115,
        _cap = p115,
        _h = p113,
        _off = p114
    }, u4);
end;

function u2.handle(p116) -- Line: 349
    return p116._h;
end;

function u2.handleOffset(p117) -- Line: 353
    return p117._off;
end;

function u2.capacity(p118) -- Line: 357
    return p118._cap;
end;

function u2.clear(p119) -- Line: 361
    p119._pos = 0;
    p119._bpos = 0;
    p119._lim = p119._cap;

    return p119;
end;

function u2.duplicate(p120) -- Line: 368
    -- upvalues: u4 (copy)
    return setmetatable({
        _mark = p120._mark,
        _pos = p120._pos,
        _bpos = p120._bpos,
        _lim = p120._lim,
        _cap = p120._cap,
        _ro = p120._ro,
        _h = p120._h,
        _off = p120._off
    }, u4);
end;

function u2.flip(p121) -- Line: 381
    p121._lim = p121._pos;
    p121._pos = 0;
    p121._bpos = 0;
    p121._mark = -1;

    return p121;
end;

function u2.hasRemaining(p122) -- Line: 389
    return p122._pos < p122._lim;
end;

function u2.isReadOnly(p123) -- Line: 393
    return p123._ro;
end;

function u2.limit(p124) -- Line: 397
    return p124._lim;
end;

function u2.limitTo(p125, p126) -- Line: 401
    -- upvalues: floor (copy)
    local v127 = p126 == floor(p126);
    assert(v127, "isint");
    assert(p126 <= p125._cap and p126 >= 0, "outofbounds");
    p125._lim = p126;

    if p126 < p125._pos then
        p125._pos = p126;
    end;

    if p126 < p125._mark then
        p125._mark = -1;
    end;

    p125._bpos = 0;

    return p125;
end;

function u2.mark(p128) -- Line: 415
    p128._mark = p128._pos;

    return p128;
end;

function u2.position(p129) -- Line: 420
    return p129._pos;
end;

function u2.positionTo(p130, p131) -- Line: 424
    -- upvalues: floor (copy)
    local v132 = p131 == floor(p131);
    assert(v132, "isint");
    assert(p131 <= p130._lim and p131 >= 0, "outofbounds");

    if p131 < p130._mark then
        p130._mark = -1;
    end;

    p130._pos = p131;
    p130._bpos = 0;

    return p130;
end;

function u2.remaining(p133) -- Line: 435
    local v134 = p133._lim - p133._pos;

    return v134 > 0 and v134 and v134 or 0;
end;

function u2.reset(p135) -- Line: 440
    local _mark = p135._mark;
    assert(_mark >= 0, "invalidmark");
    p135._pos = _mark;
    p135._bpos = 0;

    return p135;
end;

function u2.rewind(p136) -- Line: 448
    p136._pos = 0;
    p136._bpos = 0;
    p136._mark = -1;

    return p136;
end;

function u2.slice(p137) -- Line: 455
    -- upvalues: u4 (copy)
    local _pos = p137._pos;
    local _lim = p137._lim;
    local v138 = _pos <= _lim and (_lim - _pos or 0) or 0;

    return setmetatable({
        _mark = -1,
        _pos = 0,
        _bpos = 0,
        _lim = v138,
        _cap = v138,
        _ro = p137._ro,
        _h = p137._h,
        _off = _pos + p137._off
    }, u4);
end;

function u2.sliceTo(p139, p140, p141) -- Line: 470
    -- upvalues: floor (copy), u4 (copy)
    local v142 = p140 == floor(p140);
    assert(v142, "isint");
    local v143 = p141 == floor(p141);
    assert(v143, "isint");
    local _lim = p139._lim;
    local v144;

    if _lim > 0 and (p140 > 0 and p141 > 0) then
        v144 = p141 <= _lim - p140;
    else
        v144 = false;
    end;

    assert(v144, "outofbounds");

    return setmetatable({
        _mark = -1,
        _pos = 0,
        _bpos = 0,
        _lim = p141,
        _cap = p141,
        _ro = p139._ro,
        _h = p139._h,
        _off = p140 + p139._off
    }, u4);
end;

function u2.compact(p145) -- Line: 486
    -- upvalues: copy (copy)
    local _pos = p145._pos;
    local _lim = p145._lim;
    assert(_pos <= _lim, "outofbounds");
    local v146 = _pos <= _lim and (_lim - _pos or 0) or 0;
    copy(p145._h, p145._off, p145._h, p145._off + _pos, v146);
    p145._pos = v146;
    p145._bpos = 0;
    p145._lim = p145._cap;
    p145._mark = -1;

    return p145;
end;

function u2.asReadOnly(p147) -- Line: 499
    -- upvalues: u4 (copy)
    return setmetatable({
        _ro = true,
        _mark = p147._mark,
        _pos = p147._pos,
        _bpos = p147._bpos,
        _lim = p147._lim,
        _cap = p147._cap,
        _h = p147._h,
        _off = p147._off
    }, u4);
end;

function u2.debugString(p148) -- Line: 512
    -- upvalues: tostring (copy)
    return `Buffer \{ _mark={p148._mark}, _pos={p148._pos}, _lim={p148._lim}, _cap={p148._cap}, _ro={p148._ro}, _off={p148._off}, _h=buffer.fromstring({string.format("%q", tostring(p148._h))}) }`;
end;

function u2.tostring(p149) -- Line: 524
    -- upvalues: readstring (copy)
    local _pos = p149._pos;
    local _lim = p149._lim;

    return readstring(p149._h, p149._off + _pos, _pos <= _lim and (_lim - _pos or 0) or 0);
end;

function u2.fill(p150, p151) -- Line: 530
    -- upvalues: band (copy), fill (copy)
    assert(not p150._ro, "readonly");
    local v152 = p151 == band(p151, 255);
    assert(v152);
    local _pos = p150._pos;
    local _lim = p150._lim;
    fill(p150._h, p150._off + _pos, p151, _pos <= _lim and (_lim - _pos or 0) or 0);
    p150._pos = _lim;
    p150._bpos = 0;

    return p150;
end;

function u2.readi8(p153) -- Line: 541
    -- upvalues: readi8 (copy)
    local _h = p153._h;
    local _pos = p153._pos;
    assert(_pos < p153._lim, "underflow");
    p153._pos = _pos + 1;

    return readi8(_h, p153._off + _pos);
end;

function u2.readu8(p154) -- Line: 545
    -- upvalues: readu8 (copy)
    local _h = p154._h;
    local _pos = p154._pos;
    assert(_pos < p154._lim, "underflow");
    p154._pos = _pos + 1;

    return readu8(_h, p154._off + _pos);
end;

function u2.readi16(p155) -- Line: 549
    -- upvalues: readi16 (copy)
    local _h = p155._h;
    local _pos = p155._pos;
    assert(p155._lim - _pos >= 2, "underflow");
    p155._pos = _pos + 2;

    return readi16(_h, p155._off + _pos);
end;

function u2.readu16(p156) -- Line: 553
    -- upvalues: readu16 (copy)
    local _h = p156._h;
    local _pos = p156._pos;
    assert(p156._lim - _pos >= 2, "underflow");
    p156._pos = _pos + 2;

    return readu16(_h, p156._off + _pos);
end;

function u2.readi24(p157) -- Line: 557
    -- upvalues: buffer_readi24 (copy)
    local _h = p157._h;
    local _pos = p157._pos;
    assert(p157._lim - _pos >= 3, "underflow");
    p157._pos = _pos + 3;

    return buffer_readi24(_h, p157._off + _pos);
end;

function u2.readu24(p158) -- Line: 561
    -- upvalues: buffer_readu24 (copy)
    local _h = p158._h;
    local _pos = p158._pos;
    assert(p158._lim - _pos >= 3, "underflow");
    p158._pos = _pos + 3;

    return buffer_readu24(_h, p158._off + _pos);
end;

function u2.readi32(p159) -- Line: 565
    -- upvalues: readi32 (copy)
    local _h = p159._h;
    local _pos = p159._pos;
    assert(p159._lim - _pos >= 4, "underflow");
    p159._pos = _pos + 4;

    return readi32(_h, p159._off + _pos);
end;

function u2.readu32(p160) -- Line: 569
    -- upvalues: readu32 (copy)
    local _h = p160._h;
    local _pos = p160._pos;
    assert(p160._lim - _pos >= 4, "underflow");
    p160._pos = _pos + 4;

    return readu32(_h, p160._off + _pos);
end;

function u2.readi64(p161) -- Line: 573
    -- upvalues: readu32 (copy), readi32 (copy)
    local _h = p161._h;
    local _pos = p161._pos;
    assert(p161._lim - _pos >= 8, "underflow");
    p161._pos = _pos + 8;
    local v162 = p161._off + _pos;

    return readu32(_h, v162) + readi32(_h, v162 + 4) * 4294967296;
end;

function u2.readu64(p163) -- Line: 577
    -- upvalues: readu32 (copy)
    local _h = p163._h;
    local _pos = p163._pos;
    assert(p163._lim - _pos >= 8, "underflow");
    p163._pos = _pos + 8;
    local v164 = p163._off + _pos;

    return readu32(_h, v164) + readu32(_h, v164 + 4) * 4294967296;
end;

function u2.readf16(p165) -- Line: 581
    -- upvalues: readu16 (copy), composef16 (copy), rshift (copy), band (copy)
    local _h = p165._h;
    local _pos = p165._pos;
    assert(p165._lim - _pos >= 2, "underflow");
    p165._pos = _pos + 2;
    local v166 = readu16(_h, p165._off + _pos);

    return composef16(rshift(v166, 15), band(rshift(v166, 10), 31), (band(v166, 1023)));
end;

function u2.readf32(p167) -- Line: 585
    -- upvalues: readf32 (copy)
    local _h = p167._h;
    local _pos = p167._pos;
    assert(p167._lim - _pos >= 4, "underflow");
    p167._pos = _pos + 4;

    return readf32(_h, p167._off + _pos);
end;

function u2.readf64(p168) -- Line: 589
    -- upvalues: readf64 (copy)
    local _h = p168._h;
    local _pos = p168._pos;
    assert(p168._lim - _pos >= 8, "underflow");
    p168._pos = _pos + 8;

    return readf64(_h, p168._off + _pos);
end;

function u2.readstring(p169, p170) -- Line: 593
    -- upvalues: floor (copy), readstring (copy)
    local v171 = p170 == floor(p170);
    assert(v171, "isint");
    assert(p170 >= 0, "outofbounds");
    local _h = p169._h;
    local _pos = p169._pos;
    assert(p170 <= p169._lim - _pos, "underflow");
    p169._pos = _pos + p170;

    return readstring(_h, p169._off + _pos, p170);
end;

function u2.readbuffer(p172, p173) -- Line: 599
    -- upvalues: u4 (copy), writeBuffer (copy)
    local v174 = type(p173) == "table" and getmetatable(p173) == u4;
    assert(v174, "isbuffer");
    writeBuffer(p172, p173);

    return p172;
end;

function u2.geti8(p175, p176) -- Line: 605
    -- upvalues: floor (copy), readi8 (copy)
    local _h = p175._h;
    local v177 = p176 == floor(p176);
    assert(v177, "isint");
    assert(p176 >= 0 and p176 < p175._lim, "outofbounds");

    return readi8(_h, p175._off + p176);
end;

function u2.getu8(p178, p179) -- Line: 609
    -- upvalues: floor (copy), readu8 (copy)
    local _h = p178._h;
    local v180 = p179 == floor(p179);
    assert(v180, "isint");
    assert(p179 >= 0 and p179 < p178._lim, "outofbounds");

    return readu8(_h, p178._off + p179);
end;

function u2.geti16(p181, p182) -- Line: 613
    -- upvalues: floor (copy), readi16 (copy)
    local _h = p181._h;
    local v183 = p182 == floor(p182);
    assert(v183, "isint");
    assert(p182 >= 0 and p182 < p181._lim - 2 + 1, "outofbounds");

    return readi16(_h, p181._off + p182);
end;

function u2.getu16(p184, p185) -- Line: 617
    -- upvalues: floor (copy), readu16 (copy)
    local _h = p184._h;
    local v186 = p185 == floor(p185);
    assert(v186, "isint");
    assert(p185 >= 0 and p185 < p184._lim - 2 + 1, "outofbounds");

    return readu16(_h, p184._off + p185);
end;

function u2.geti24(p187, p188) -- Line: 621
    -- upvalues: buffer_readi24 (copy), floor (copy)
    local _h = p187._h;
    local v189 = p188 == floor(p188);
    assert(v189, "isint");
    assert(p188 >= 0 and p188 < p187._lim - 3 + 1, "outofbounds");

    return buffer_readi24(_h, p187._off + p188);
end;

function u2.getu24(p190, p191) -- Line: 625
    -- upvalues: buffer_readu24 (copy), floor (copy)
    local _h = p190._h;
    local v192 = p191 == floor(p191);
    assert(v192, "isint");
    assert(p191 >= 0 and p191 < p190._lim - 3 + 1, "outofbounds");

    return buffer_readu24(_h, p190._off + p191);
end;

function u2.geti32(p193, p194) -- Line: 629
    -- upvalues: floor (copy), readi32 (copy)
    local _h = p193._h;
    local v195 = p194 == floor(p194);
    assert(v195, "isint");
    assert(p194 >= 0 and p194 < p193._lim - 4 + 1, "outofbounds");

    return readi32(_h, p193._off + p194);
end;

function u2.getu32(p196, p197) -- Line: 633
    -- upvalues: floor (copy), readu32 (copy)
    local _h = p196._h;
    local v198 = p197 == floor(p197);
    assert(v198, "isint");
    assert(p197 >= 0 and p197 < p196._lim - 4 + 1, "outofbounds");

    return readu32(_h, p196._off + p197);
end;

function u2.geti64(p199, p200) -- Line: 637
    -- upvalues: floor (copy), readu32 (copy), readi32 (copy)
    local _h = p199._h;
    local v201 = p200 == floor(p200);
    assert(v201, "isint");
    assert(p200 >= 0 and p200 < p199._lim - 8 + 1, "outofbounds");
    local v202 = p199._off + p200;

    return readu32(_h, v202) + readi32(_h, v202 + 4) * 4294967296;
end;

function u2.getu64(p203, p204) -- Line: 641
    -- upvalues: floor (copy), readu32 (copy)
    local _h = p203._h;
    local v205 = p204 == floor(p204);
    assert(v205, "isint");
    assert(p204 >= 0 and p204 < p203._lim - 8 + 1, "outofbounds");
    local v206 = p203._off + p204;

    return readu32(_h, v206) + readu32(_h, v206 + 4) * 4294967296;
end;

function u2.getf16(p207, p208) -- Line: 645
    -- upvalues: floor (copy), readu16 (copy), composef16 (copy), rshift (copy), band (copy)
    local _h = p207._h;
    local v209 = p208 == floor(p208);
    assert(v209, "isint");
    assert(p208 >= 0 and p208 < p207._lim - 2 + 1, "outofbounds");
    local v210 = readu16(_h, p207._off + p208);

    return composef16(rshift(v210, 15), band(rshift(v210, 10), 31), (band(v210, 1023)));
end;

function u2.getf32(p211, p212) -- Line: 649
    -- upvalues: floor (copy), readf32 (copy)
    local _h = p211._h;
    local v213 = p212 == floor(p212);
    assert(v213, "isint");
    assert(p212 >= 0 and p212 < p211._lim - 4 + 1, "outofbounds");

    return readf32(_h, p211._off + p212);
end;

function u2.getf64(p214, p215) -- Line: 653
    -- upvalues: floor (copy), readf64 (copy)
    local _h = p214._h;
    local v216 = p215 == floor(p215);
    assert(v216, "isint");
    assert(p215 >= 0 and p215 < p214._lim - 8 + 1, "outofbounds");

    return readf64(_h, p214._off + p215);
end;

function u2.getstring(p217, p218, p219) -- Line: 657
    -- upvalues: floor (copy), readstring (copy)
    local v220 = p219 == floor(p219);
    assert(v220, "isint");
    assert(p219 >= 0, "outofbounds");
    local _h = p217._h;
    local v221 = p218 == floor(p218);
    assert(v221, "isint");
    assert(p218 >= 0 and p218 < p217._lim - p219 + 1, "outofbounds");

    return readstring(_h, p217._off + p218, p219);
end;

function u2.getbuffer(p222, p223, p224) -- Line: 663
    -- upvalues: u4 (copy), getBuffer (copy)
    local v225 = type(p224) == "table" and getmetatable(p224) == u4;
    assert(v225, "isbuffer");
    getBuffer(p222, p223, p224);

    return p222;
end;

function u2.writei8(p226, p227) -- Line: 669
    -- upvalues: band (copy), writei8 (copy)
    local v228 = p227 + 128;
    local v229 = v228 == band(v228, 255);
    assert(v229, "isi8");
    local _h = p226._h;
    assert(not p226._ro, "readonly");
    local _pos = p226._pos;
    assert(_pos < p226._lim, "overflow");
    p226._pos = _pos + 1;
    writei8(_h, p226._off + _pos, p227);

    return p226;
end;

function u2.writeu8(p230, p231) -- Line: 675
    -- upvalues: band (copy), writeu8 (copy)
    local v232 = p231 == band(p231, 255);
    assert(v232, "isu8");
    local _h = p230._h;
    assert(not p230._ro, "readonly");
    local _pos = p230._pos;
    assert(_pos < p230._lim, "overflow");
    p230._pos = _pos + 1;
    writeu8(_h, p230._off + _pos, p231);

    return p230;
end;

function u2.writei16(p233, p234) -- Line: 681
    -- upvalues: band (copy), writei16 (copy)
    local v235 = p234 + 32768;
    local v236 = v235 == band(v235, 65535);
    assert(v236, "isi16");
    local _h = p233._h;
    assert(not p233._ro, "readonly");
    local _pos = p233._pos;
    assert(p233._lim - _pos >= 2, "overflow");
    p233._pos = _pos + 2;
    writei16(_h, p233._off + _pos, p234);

    return p233;
end;

function u2.writeu16(p237, p238) -- Line: 687
    -- upvalues: band (copy), writeu16 (copy)
    local v239 = p238 == band(p238, 65535);
    assert(v239, "isu16");
    local _h = p237._h;
    assert(not p237._ro, "readonly");
    local _pos = p237._pos;
    assert(p237._lim - _pos >= 2, "overflow");
    p237._pos = _pos + 2;
    writeu16(_h, p237._off + _pos, p238);

    return p237;
end;

function u2.writei24(p240, p241) -- Line: 693
    -- upvalues: band (copy)
    local v242 = p241 + 8388608;
    local v243 = v242 == band(v242, 16777215);
    assert(v243, "isi24");
    local _ = p240._h;
    assert(not p240._ro, "readonly");
    local _pos = p240._pos;
    assert(p240._lim - _pos >= 3, "overflow");
    p240._pos = _pos + 3;
    local _ = p240._off + _pos;
    error("nyi");

    return p240;
end;

function u2.writeu24(p244, p245) -- Line: 699
    -- upvalues: band (copy)
    local v246 = p245 == band(p245, 16777215);
    assert(v246, "isu24");
    local _ = p244._h;
    assert(not p244._ro, "readonly");
    local _pos = p244._pos;
    assert(p244._lim - _pos >= 3, "overflow");
    p244._pos = _pos + 3;
    local _ = p244._off + _pos;
    error("nyi");

    return p244;
end;

function u2.writei32(p247, p248) -- Line: 705
    -- upvalues: lshift (copy), writei32 (copy)
    local v249 = p248 + 2147483648;
    local v250 = v249 == lshift(v249, 0);
    assert(v250, "isi32");
    local _h = p247._h;
    assert(not p247._ro, "readonly");
    local _pos = p247._pos;
    assert(p247._lim - _pos >= 4, "overflow");
    p247._pos = _pos + 4;
    writei32(_h, p247._off + _pos, p248);

    return p247;
end;

function u2.writeu32(p251, p252) -- Line: 711
    -- upvalues: lshift (copy), writeu32 (copy)
    local v253 = p252 == lshift(p252, 0);
    assert(v253, "isu32");
    local _h = p251._h;
    assert(not p251._ro, "readonly");
    local _pos = p251._pos;
    assert(p251._lim - _pos >= 4, "overflow");
    p251._pos = _pos + 4;
    writeu32(_h, p251._off + _pos, p252);

    return p251;
end;

function u2.writei64(p254, p255) -- Line: 717
    -- upvalues: lshift (copy), writeu32 (copy), writei32 (copy)
    local v256 = lshift(p255, 0);
    local v257 = p255 // 4294967296;
    local v258 = v257 + 2147483648;
    local v259 = v258 == lshift(v258, 0) and p255 == v256 + v257 * 4294967296;
    assert(v259, "isi64");
    local _h = p254._h;
    assert(not p254._ro, "readonly");
    local _pos = p254._pos;
    assert(p254._lim - _pos >= 8, "overflow");
    p254._pos = _pos + 8;
    local v260 = p254._off + _pos;
    writeu32(_h, v260, p255);
    writei32(_h, v260 + 4, p255 // 4294967296);

    return p254;
end;

function u2.writeu64(p261, p262) -- Line: 723
    -- upvalues: lshift (copy), writeu32 (copy)
    local v263 = p262 == lshift(p262, 0) + lshift(p262 // 4294967296, 0) * 4294967296;
    assert(v263, "isu64");
    local _h = p261._h;
    assert(not p261._ro, "readonly");
    local _pos = p261._pos;
    assert(p261._lim - _pos >= 8, "overflow");
    p261._pos = _pos + 8;
    local v264 = p261._off + _pos;
    writeu32(_h, v264, p262);
    writeu32(_h, v264 + 4, p262 // 4294967296);

    return p261;
end;

function u2.writef16(p265, p266) -- Line: 729
    -- upvalues: decomposef16 (copy), composef16 (copy), lshift (copy), bor (copy), writeu16 (copy)
    local v267 = type(p266) == "number";
    assert(v267, "isnumber");
    local _h = p265._h;
    assert(not p265._ro, "readonly");
    local _pos = p265._pos;
    assert(p265._lim - _pos >= 2, "overflow");
    p265._pos = _pos + 2;
    local v268 = p265._off + _pos;
    local v269, v270, v271 = decomposef16(p266);
    composef16(v269, v270, v271);
    writeu16(_h, v268, (bor(lshift(v269, 15), lshift(v270, 10), v271)));

    return p265;
end;

function u2.writef32(p272, p273) -- Line: 735
    -- upvalues: writef32 (copy)
    local v274 = type(p273) == "number";
    assert(v274, "isnumber");
    local _h = p272._h;
    assert(not p272._ro, "readonly");
    local _pos = p272._pos;
    assert(p272._lim - _pos >= 4, "overflow");
    p272._pos = _pos + 4;
    writef32(_h, p272._off + _pos, p273);

    return p272;
end;

function u2.writef64(p275, p276) -- Line: 741
    -- upvalues: writef64 (copy)
    local v277 = type(p276) == "number";
    assert(v277, "isnumber");
    local _h = p275._h;
    assert(not p275._ro, "readonly");
    local _pos = p275._pos;
    assert(p275._lim - _pos >= 8, "overflow");
    p275._pos = _pos + 8;
    writef64(_h, p275._off + _pos, p276);

    return p275;
end;

function u2.writestring(p278, p279, p280) -- Line: 747
    -- upvalues: len2 (copy), floor (copy), writestring (copy)
    local v281 = type(p279) == "string";
    assert(v281, "isstring");
    local v282 = len2(p279);

    if p280 == nil then
        p280 = v282;
    else
        local v283 = p280 == floor(p280);
        assert(v283, "isint");
        assert(p280 >= 0 and p280 < v282, "outofbounds");
    end;

    local _h = p278._h;
    assert(not p278._ro, "readonly");
    local _pos = p278._pos;
    assert(p280 <= p278._lim - _pos, "overflow");
    p278._pos = _pos + p280;
    writestring(_h, p278._off + _pos, p279, p280);

    return p278;
end;

function u2.writebuffer(p284, p285) -- Line: 760
    -- upvalues: u4 (copy), writeBuffer (copy)
    local v286 = type(p285) == "table" and getmetatable(p285) == u4;
    assert(v286, "isbuffer");
    writeBuffer(p285, p284);

    return p284;
end;

function u2.puti8(p287, p288, p289) -- Line: 766
    -- upvalues: band (copy), floor (copy), writei8 (copy)
    local v290 = p289 + 128;
    local v291 = v290 == band(v290, 255);
    assert(v291, "isi8");
    local _h = p287._h;
    local v292 = p288 == floor(p288);
    assert(v292, "isint");
    assert(not p287._ro, "readonly");
    assert(p288 >= 0 and p288 < p287._lim, "outofbounds");
    writei8(_h, p287._off + p288, p289);

    return p287;
end;

function u2.putu8(p293, p294, p295) -- Line: 772
    -- upvalues: band (copy), floor (copy), writeu8 (copy)
    local v296 = p295 == band(p295, 255);
    assert(v296, "isu8");
    local _h = p293._h;
    local v297 = p294 == floor(p294);
    assert(v297, "isint");
    assert(not p293._ro, "readonly");
    assert(p294 >= 0 and p294 < p293._lim, "outofbounds");
    writeu8(_h, p293._off + p294, p295);

    return p293;
end;

function u2.puti16(p298, p299, p300) -- Line: 778
    -- upvalues: band (copy), floor (copy), writei16 (copy)
    local v301 = p300 + 32768;
    local v302 = v301 == band(v301, 65535);
    assert(v302, "isi16");
    local _h = p298._h;
    local v303 = p299 == floor(p299);
    assert(v303, "isint");
    assert(not p298._ro, "readonly");
    assert(p299 >= 0 and p299 < p298._lim - 2 + 1, "outofbounds");
    writei16(_h, p298._off + p299, p300);

    return p298;
end;

function u2.putu16(p304, p305, p306) -- Line: 784
    -- upvalues: band (copy), floor (copy), writeu16 (copy)
    local v307 = p306 == band(p306, 65535);
    assert(v307, "isu16");
    local _h = p304._h;
    local v308 = p305 == floor(p305);
    assert(v308, "isint");
    assert(not p304._ro, "readonly");
    assert(p305 >= 0 and p305 < p304._lim - 2 + 1, "outofbounds");
    writeu16(_h, p304._off + p305, p306);

    return p304;
end;

function u2.puti24(p309, p310, p311) -- Line: 790
    -- upvalues: band (copy), floor (copy)
    local v312 = p311 + 8388608;
    local v313 = v312 == band(v312, 16777215);
    assert(v313, "isi24");
    local _ = p309._h;
    local v314 = p310 == floor(p310);
    assert(v314, "isint");
    assert(not p309._ro, "readonly");
    assert(p310 >= 0 and p310 < p309._lim - 3 + 1, "outofbounds");
    local _ = p309._off + p310;
    error("nyi");

    return p309;
end;

function u2.putu24(p315, p316, p317) -- Line: 796
    -- upvalues: band (copy), floor (copy)
    local v318 = p317 == band(p317, 16777215);
    assert(v318, "isu24");
    local _ = p315._h;
    local v319 = p316 == floor(p316);
    assert(v319, "isint");
    assert(not p315._ro, "readonly");
    assert(p316 >= 0 and p316 < p315._lim - 3 + 1, "outofbounds");
    local _ = p315._off + p316;
    error("nyi");

    return p315;
end;

function u2.puti32(p320, p321, p322) -- Line: 802
    -- upvalues: lshift (copy), floor (copy), writei32 (copy)
    local v323 = p322 + 2147483648;
    local v324 = v323 == lshift(v323, 0);
    assert(v324, "isi32");
    local _h = p320._h;
    local v325 = p321 == floor(p321);
    assert(v325, "isint");
    assert(not p320._ro, "readonly");
    assert(p321 >= 0 and p321 < p320._lim - 4 + 1, "outofbounds");
    writei32(_h, p320._off + p321, p322);

    return p320;
end;

function u2.putu32(p326, p327, p328) -- Line: 808
    -- upvalues: lshift (copy), floor (copy), writeu32 (copy)
    local v329 = p328 == lshift(p328, 0);
    assert(v329, "isu32");
    local _h = p326._h;
    local v330 = p327 == floor(p327);
    assert(v330, "isint");
    assert(not p326._ro, "readonly");
    assert(p327 >= 0 and p327 < p326._lim - 4 + 1, "outofbounds");
    writeu32(_h, p326._off + p327, p328);

    return p326;
end;

function u2.puti64(p331, p332, p333) -- Line: 814
    -- upvalues: lshift (copy), floor (copy), writeu32 (copy), writei32 (copy)
    local v334 = lshift(p333, 0);
    local v335 = p333 // 4294967296;
    local v336 = v335 + 2147483648;
    local v337 = v336 == lshift(v336, 0) and p333 == v334 + v335 * 4294967296;
    assert(v337, "isi64");
    local _h = p331._h;
    local v338 = p332 == floor(p332);
    assert(v338, "isint");
    assert(not p331._ro, "readonly");
    assert(p332 >= 0 and p332 < p331._lim - 8 + 1, "outofbounds");
    local v339 = p331._off + p332;
    writeu32(_h, v339, p333);
    writei32(_h, v339 + 4, p333 // 4294967296);

    return p331;
end;

function u2.putu64(p340, p341, p342) -- Line: 820
    -- upvalues: lshift (copy), floor (copy), writeu32 (copy)
    local v343 = p342 == lshift(p342, 0) + lshift(p342 // 4294967296, 0) * 4294967296;
    assert(v343, "isu64");
    local _h = p340._h;
    local v344 = p341 == floor(p341);
    assert(v344, "isint");
    assert(not p340._ro, "readonly");
    assert(p341 >= 0 and p341 < p340._lim - 8 + 1, "outofbounds");
    local v345 = p340._off + p341;
    writeu32(_h, v345, p342);
    writeu32(_h, v345 + 4, p342 // 4294967296);

    return p340;
end;

function u2.putf16(p346, p347, p348) -- Line: 826
    -- upvalues: floor (copy), decomposef16 (copy), composef16 (copy), lshift (copy), bor (copy), writeu16 (copy)
    local v349 = type(p348) == "number";
    assert(v349, "isnumber");
    local _h = p346._h;
    local v350 = p347 == floor(p347);
    assert(v350, "isint");
    assert(not p346._ro, "readonly");
    assert(p347 >= 0 and p347 < p346._lim - 2 + 1, "outofbounds");
    local v351 = p346._off + p347;
    local v352, v353, v354 = decomposef16(p348);
    composef16(v352, v353, v354);
    writeu16(_h, v351, (bor(lshift(v352, 15), lshift(v353, 10), v354)));

    return p346;
end;

function u2.putf32(p355, p356, p357) -- Line: 832
    -- upvalues: floor (copy), writef32 (copy)
    local v358 = type(p357) == "number";
    assert(v358, "isnumber");
    local _h = p355._h;
    local v359 = p356 == floor(p356);
    assert(v359, "isint");
    assert(not p355._ro, "readonly");
    assert(p356 >= 0 and p356 < p355._lim - 4 + 1, "outofbounds");
    writef32(_h, p355._off + p356, p357);

    return p355;
end;

function u2.putf64(p360, p361, p362) -- Line: 838
    -- upvalues: floor (copy), writef64 (copy)
    local v363 = type(p362) == "number";
    assert(v363, "isnumber");
    local _h = p360._h;
    local v364 = p361 == floor(p361);
    assert(v364, "isint");
    assert(not p360._ro, "readonly");
    assert(p361 >= 0 and p361 < p360._lim - 8 + 1, "outofbounds");
    writef64(_h, p360._off + p361, p362);

    return p360;
end;

function u2.putstring(p365, p366, p367, p368) -- Line: 844
    -- upvalues: len2 (copy), floor (copy), writestring (copy)
    local v369 = type(p367) == "string";
    assert(v369, "isstring");
    local v370 = len2(p367);

    if p368 == nil then
        p368 = v370;
    else
        local v371 = p368 == floor(p368);
        assert(v371, "isint");
        assert(p368 >= 0 and p368 < v370, "outofbounds");
    end;

    local _h = p365._h;
    local v372 = p366 == floor(p366);
    assert(v372, "isint");
    assert(not p365._ro, "readonly");
    assert(p366 >= 0 and p366 < p365._lim - p368 + 1, "outofbounds");
    writestring(_h, p365._off + p366, p367, p368);

    return p365;
end;

function u2.putbuffer(p373, p374, p375) -- Line: 857
    -- upvalues: u4 (copy), putBuffer (copy)
    local v376 = type(p375) == "table" and getmetatable(p375) == u4;
    assert(v376, "isbuffer");
    putBuffer(p373, p374, p375);

    return p373;
end;

function u2.readbits(p377, p378) -- Line: 863
    -- upvalues: band (copy), min (copy), floor (copy), readu8 (copy), rshift (copy), lshift (copy), bor (copy)
    local v379 = p378 == 0 and true or band(p378 - 1, 31) == p378 - 1;
    assert(v379);
    local _bpos = p377._bpos;
    local _h = p377._h;
    local v380 = 0;
    local v381 = 0;

    while v380 < p378 do
        local v382 = min(8 - _bpos, p378 - v380);

        if _bpos == 0 then
            local _pos = p377._pos;
            assert(_pos < p377._lim, "underflow");
            p377._pos = _pos + 1;
            local _ = p377._off + _pos;
        end;

        local v383 = p377._pos - 1;
        local v384 = v383 == floor(v383);
        assert(v384, "isint");
        assert(v383 >= 0 and v383 < p377._lim, "outofbounds");
        v381 = bor(v381, (lshift(band(rshift(readu8(_h, p377._off + v383), _bpos), lshift(1, v382) - 1), v380)));
        _bpos = band(_bpos + v382, 7);
        v380 = v380 + v382;
    end;

    p377._bpos = _bpos;

    return v381;
end;

function u2.writebits(p385, p386, p387) -- Line: 885
    -- upvalues: band (copy), lshift (copy), min (copy), floor (copy), readu8 (copy), bnot (copy), bor (copy), writeu8 (copy), rshift (copy)
    local v388 = p387 == 0 and true or band(p387 - 1, 31) == p387 - 1;
    assert(v388);
    local v389 = band(p386, lshift(1, p387) - 1) == p386;
    assert(v389);
    local _bpos = p385._bpos;
    local _h = p385._h;

    while p387 > 0 do
        local v390 = min(8 - _bpos, p387);
        local v391 = lshift(1, v390) - 1;

        if _bpos == 0 then
            assert(not p385._ro, "readonly");
            local _pos = p385._pos;
            assert(_pos < p385._lim, "overflow");
            p385._pos = _pos + 1;
            local _ = p385._off + _pos;
        end;

        local v392 = p385._pos - 1;
        local v393 = v392 == floor(v392);
        assert(v393, "isint");
        assert(not p385._ro, "readonly");
        assert(v392 >= 0 and v392 < p385._lim, "outofbounds");
        local v394 = p385._off + v392;
        writeu8(_h, v394, (bor(band(readu8(_h, v394), (bnot((lshift(v391, _bpos))))), (lshift(band(p386, v391), _bpos)))));
        _bpos = band(_bpos + v390, 7);
        p386 = rshift(p386, v390);
        p387 = p387 - v390;
    end;

    p385._bpos = _bpos;

    return p385;
end;

function u2.writef32bits(p395, p396) -- Line: 909
    -- upvalues: u2 (copy), u1 (copy), writef32 (copy), readu32 (copy)
    local writebits = u2.writebits;
    writef32(u1, 0, p396);
    writebits(p395, readu32(u1, 0), 32);

    return p395;
end;

function u2.writef64bits(p397, p398) -- Line: 914
    -- upvalues: u1 (copy), writef64 (copy), readu32 (copy), u2 (copy)
    writef64(u1, 0, p398);
    local v399 = readu32(u1, 0);
    local v400 = readu32(u1, 4);
    u2.writebits(p397, v399, 32);
    u2.writebits(p397, v400, 32);

    return p397;
end;

function u2.readf32bits(p401) -- Line: 921
    -- upvalues: u2 (copy), u1 (copy), writeu32 (copy), readf32 (copy)
    writeu32(u1, 0, (u2.readbits(p401, 32)));

    return readf32(u1, 0);
end;

function u2.readf64bits(p402) -- Line: 925
    -- upvalues: u2 (copy), u1 (copy), writeu32 (copy), readf64 (copy)
    local v403 = u2.readbits(p402, 32);
    local v404 = u2.readbits(p402, 32);
    writeu32(u1, 0, v403);
    writeu32(u1, 4, v404);

    return readf64(u1, 0);
end;

function u2.closebits(p405) -- Line: 929
    p405._bpos = 0;

    return p405;
end;

function u2.bitPosition(p406) -- Line: 934
    return p406._bpos;
end;

function u2.bitPositionTo(p407, p408) -- Line: 938
    -- upvalues: band (copy)
    local v409 = band(p408, 7) == p408;
    assert(v409);
    p407._bpos = p408;

    return p407;
end;

local v437 = {
    wrap = function(p410) -- Line: 946, Name: wrap
        -- upvalues: len (copy), u4 (copy)
        local v411 = type(p410) == "buffer";
        assert(v411, "isbuffer");
        local v412 = len(p410);

        return setmetatable({
            _mark = -1,
            _pos = 0,
            _bpos = 0,
            _ro = false,
            _off = 0,
            _lim = v412,
            _cap = v412,
            _h = p410
        }, u4);
    end,

    wrapFrom = function(p413, p414, p415) -- Line: 951, Name: wrapFrom
        -- upvalues: floor (copy), len (copy), u4 (copy)
        local v416 = type(p413) == "buffer";
        assert(v416, "isbuffer");
        local v417 = p414 == floor(p414);
        assert(v417, "isint");
        local v418 = p415 == floor(p415);
        assert(v418, "isint");
        local v419 = len(p413);
        local v420;

        if v419 > 0 and (p414 > 0 and p415 > 0) then
            v420 = p415 <= v419 - p414;
        else
            v420 = false;
        end;

        assert(v420, "outofbounds");

        return setmetatable({
            _mark = -1,
            _pos = 0,
            _bpos = 0,
            _ro = false,
            _lim = p415,
            _cap = p415,
            _h = p413,
            _off = p414
        }, u4);
    end,

    allocate = function(p421) -- Line: 959, Name: allocate
        -- upvalues: floor (copy), create (copy), u4 (copy)
        local v422 = p421 == floor(p421);
        assert(v422, "isint");
        local v423 = {
            _mark = -1,
            _pos = 0,
            _bpos = 0,
            _ro = false,
            _off = 0,
            _lim = p421,
            _cap = p421,
            _h = create(p421)
        };

        return setmetatable(v423, u4);
    end,

    from = function(p424, p425) -- Line: 965, Name: from
        -- upvalues: fromstring (copy), floor (copy), len2 (copy), create (copy), writestring (copy), len (copy), u4 (copy)
        local v426 = type(p424) == "string";
        assert(v426, "isstring");
        local v427;

        if p425 == nil then
            v427 = fromstring(p424);
        else
            local v428 = p425 == floor(p425);
            assert(v428, "isint");
            local v429 = len2(p424);
            assert(p425 >= 0 and p425 <= v429);
            v427 = create(p425);
            writestring(v427, 0, p424, p425);
        end;

        local v430 = len(v427);

        return setmetatable({
            _mark = -1,
            _pos = 0,
            _bpos = 0,
            _ro = false,
            _off = 0,
            _lim = v430,
            _cap = v430,
            _h = v427
        }, u4);
    end,

    sizeof32 = function(p431) -- Line: 980, Name: sizeof32
        -- upvalues: band (copy)
        return band(p431, 4294901760) == 0 and (band(p431, 4294967040) == 0 and 1 or 2) or (band(p431, 4278190080) == 0 and 3 or 4);
    end,

    sizeof64 = function(p432) -- Line: 984, Name: sizeof64
        -- upvalues: band (copy)
        local v433 = p432 // 4294967296;

        if v433 == 0 then
            return band(p432, 4294901760) == 0 and (band(p432, 4294967040) == 0 and 1 or 2) or (band(p432, 4278190080) == 0 and 3 or 4);
        end;

        local v434;

        if band(v433, 4294901760) == 0 then
            v434 = band(v433, 4294967040) == 0 and 1 or 2;
        else
            v434 = band(v433, 4278190080) == 0 and 3 or 4;
        end;

        return 4 + v434;
    end,

    size32ext = function(p435) -- Line: 993, Name: size32ext
        -- upvalues: band (copy)
        return band(p435, 4294967295) == p435 and (band(p435, 4294901760) == 0 and (band(p435, 4294967040) == 0 and (p435 == 0 and 0 or 1) or 2) or (band(p435, 4278190080) == 0 and 3 or 4)) or -1;
    end,

    castf32 = function(p436) -- Line: 78, Name: castf32
        -- upvalues: u1 (copy), writef32 (copy), readf32 (copy)
        writef32(u1, 0, p436);

        return readf32(u1, 0);
    end,

    composef16 = composef16,
    decomposef16 = decomposef16
};
table.freeze(u4);
table.freeze(u2);
table.freeze(v437);

return v437;