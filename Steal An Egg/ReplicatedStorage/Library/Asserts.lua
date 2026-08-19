-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local IsASCII = require(Library:WaitForChild("Functions"):WaitForChild("IsASCII"));
local u1 = {
    optional = {},
    array = {},
    custom = {}
};

function IsFinite(p2)
    local v3;

    if p2 == p2 and p2 ~= (1 / 0) then
        v3 = p2 ~= (-1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function IsFiniteVec2(p4)
    local v5 = IsFinite(p4.X) and IsFinite(p4.Y);

    return v5;
end;

function IsFiniteVec(p6)
    local v7 = IsFinite(p6.X) and IsFinite(p6.Y) and IsFinite(p6.Z);

    return v7;
end;

function IsFiniteCFrame(p8)
    local v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20 = p8:GetComponents();
    local v21 = IsFinite(v9) and (IsFinite(v10) and IsFinite(v11)) and (IsFinite(v12) and IsFinite(v13) and (IsFinite(v14) and IsFinite(v15)) and (IsFinite(v16) and IsFinite(v17) and (IsFinite(v18) and IsFinite(v19)))) and IsFinite(v20);

    return v21;
end;

function cassert(p22, p23)
    if not p22 then
        error("assertion failed!", (p23 or 0) + 3);
    end;
end;

u1.cassert = cassert;

function u1.defined(p24, p25) -- Line: 56
    cassert(p24 ~= nil, p25);

    return p24;
end;

function u1.exists(p26, p27) -- Line: 61
    -- upvalues: u1 (copy)
    u1.defined(p26, p27);

    return p26;
end;

function u1.cond(p28, p29) -- Line: 66
    cassert(p28 == true, p29);
end;

function u1.boolean(p30, p31) -- Line: 70
    cassert(type(p30) == "boolean", p31);
end;

function u1.optional.boolean(p32, p33) -- Line: 74
    local v34 = p32 == nil and true or type(p32) == "boolean";
    cassert(v34, p33);
end;

function u1.enum(p35, p36) -- Line: 82
    cassert(typeof(p35) == "EnumItem", p36);
end;

function u1.optional.enum(p37, p38) -- Line: 86
    if p37 == nil then
        return;
    end;

    cassert(typeof(p37) == "EnumItem", p38);
end;

function u1.number(p39, p40) -- Line: 93
    cassert(type(p39) == "number", p40);
end;

function u1.optional.number(p41, p42) -- Line: 97
    local v43 = p41 == nil and true or type(p41) == "number";
    cassert(v43, p42);
end;

function u1.TweenInfo(p44, p45) -- Line: 105
    cassert(typeof(p44) == "TweenInfo", p45);
end;

function u1.optional.TweenInfo(p46, p47) -- Line: 109
    local v48 = p46 == nil and true or typeof(p46) == "TweenInfo";
    cassert(v48, p47);
end;

function u1.nonNegativeInteger(p49, p50) -- Line: 117
    -- upvalues: u1 (copy)
    u1.integer(p49, p50);
    cassert(p49 >= 0, p50);
    cassert(math.floor(p49) == p49, p50);
end;

function u1.optional.nonNegativeInteger(p51, p52) -- Line: 123
    -- upvalues: u1 (copy)
    u1.optional.integer(p51, p52);

    if p51 ~= nil then
        cassert(p51 >= 0, p52);
        cassert(math.floor(p51) == p51, p52);
    end;
end;

function u1.positiveInteger(p53, p54) -- Line: 131
    -- upvalues: u1 (copy)
    u1.integer(p53, p54);
    cassert(p53 > 0, p54);
    cassert(math.floor(p53) == p53, p54);
end;

function u1.optional.positiveInteger(p55, p56) -- Line: 137
    -- upvalues: u1 (copy)
    u1.optional.integer(p55, p56);

    if p55 ~= nil then
        cassert(p55 > 0, p56);
        cassert(math.floor(p55) == p55, p56);
    end;
end;

function u1.real(p57, p58) -- Line: 145
    cassert(type(p57) == "number", p58);
    cassert(p57 == p57, p58);
end;

function u1.optional.real(p59, p60) -- Line: 150
    if p59 ~= nil then
        cassert(type(p59) == "number", p60);
        cassert(p59 == p59, p60);
    end;
end;

function u1.finite(p61, p62) -- Line: 157
    cassert(type(p61) == "number", p62);
    cassert(IsFinite(p61), p62);
end;

function u1.optional.finite(p63, p64) -- Line: 162
    if p63 ~= nil then
        cassert(type(p63) == "number", p64);
        cassert(IsFinite(p63), p64);
    end;
end;

function u1.finiteNonNegative(p65, p66) -- Line: 169
    cassert(type(p65) == "number", p66);
    cassert(IsFinite(p65), p66);
    cassert(p65 >= 0, p66);
end;

function u1.optional.finiteNonNegative(p67, p68) -- Line: 175
    if p67 ~= nil then
        cassert(type(p67) == "number", p68);
        cassert(IsFinite(p67), p68);
        cassert(p67 >= 0, p68);
    end;
end;

function u1.integer(p69, p70) -- Line: 183
    cassert(type(p69) == "number", p70);
    cassert(IsFinite(p69), p70);
    cassert(math.floor(p69) == p69, p70);
end;

function u1.optional.integer(p71, p72) -- Line: 189
    if p71 ~= nil then
        cassert(type(p71) == "number", p72);
        cassert(IsFinite(p71), p72);
        cassert(math.floor(p71) == p71, p72);
    end;
end;

function u1.integerNonNegative(p73, p74) -- Line: 197
    cassert(type(p73) == "number", p74);
    cassert(IsFinite(p73), p74);
    cassert(math.floor(p73) == p73, p74);
    cassert(p73 >= 0, p74);
end;

function u1.optional.integerNonNegative(p75, p76) -- Line: 204
    if p75 ~= nil then
        cassert(type(p75) == "number", p76);
        cassert(IsFinite(p75), p76);
        cassert(math.floor(p75) == p75, p76);
        cassert(p75 >= 0, p76);
    end;
end;

function u1.natural(p77, p78) -- Line: 213
    cassert(type(p77) == "number", p78);
    cassert(IsFinite(p77), p78);
    cassert(math.floor(p77) == p77, p78);
    cassert(p77 > 0, p78);
end;

function u1.optional.natural(p79, p80) -- Line: 220
    if p79 ~= nil then
        cassert(type(p79) == "number", p80);
        cassert(IsFinite(p79), p80);
        cassert(math.floor(p79) == p79, p80);
        cassert(p79 > 0, p80);
    end;
end;

function u1.string(p81, p82) -- Line: 229
    cassert(type(p81) == "string", p82);
end;

function u1.optional.string(p83, p84) -- Line: 233
    local v85 = p83 == nil and true or type(p83) == "string";
    cassert(v85, p84);
end;

function u1.optional.UDim(p86, p87) -- Line: 241
    local v88 = p86 == nil and true or typeof(p86) == "UDim";
    cassert(v88, p87);
end;

function u1.optional.UDim2(p89, p90) -- Line: 249
    local v91 = p89 == nil and true or typeof(p89) == "UDim2";
    cassert(v91, p90);
end;

function u1.Color3(p92, p93) -- Line: 256
    cassert(typeof(p92) == "Color3", p93);
end;

function u1.optional.Color3(p94, p95) -- Line: 260
    if p94 ~= nil then
        cassert(typeof(p94) == "Color3", p95);
    end;
end;

function u1.ascii(p96, p97) -- Line: 266
    -- upvalues: IsASCII (copy)
    cassert(type(p96) == "string", p97);
    cassert(IsASCII(p96), p97);
end;

function u1.optional.ascii(p98, p99) -- Line: 271
    -- upvalues: IsASCII (copy)
    if p98 ~= nil then
        cassert(type(p98) == "string", p99);
        cassert(IsASCII(p98), p99);
    end;
end;

function u1.username(p100, p101) -- Line: 278
    -- upvalues: IsASCII (copy)
    cassert(type(p100) == "string", p101);
    cassert(IsASCII(p100), p101);
end;

function u1.optional.username(p102, p103) -- Line: 283
    if p102 ~= nil then
        cassert(type(p102) == "string", p103);
        local v104;

        if #p102 >= 3 then
            v104 = #p102 <= 20;
        else
            v104 = false;
        end;

        cassert(v104, p103);
        cassert(p102:find("^%w+$") ~= nil, p103);
        local v105;

        if p102:sub(1, 1) == "_" then
            v105 = false;
        else
            v105 = p102:sub(-1) ~= "_";
        end;

        cassert(v105, p103);
        cassert(p102:find("__") == nil, p103);
        cassert(p102:find("^%d+$") == nil, p103);
    end;
end;

function u1.uuid(p106, p107) -- Line: 302
    cassert(type(p106) == "string", p107);
    cassert(#p106 == 36, p107);
    cassert(p106:find("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil, p107);
end;

function u1.optional.uuid(p108, p109) -- Line: 308
    if p108 ~= nil then
        cassert(type(p108) == "string", p109);
        cassert(#p108 == 36, p109);
        cassert(p108:find("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil, p109);
    end;
end;

function u1.uuidStripped(p110, p111) -- Line: 316
    cassert(type(p110) == "string", p111);
    cassert(#p110 == 32, p111);
    cassert(p110:find("^%x+$") ~= nil, p111);
end;

function u1.optional.uuidStripped(p112, p113) -- Line: 322
    if p112 ~= nil then
        cassert(type(p112) == "string", p113);
        cassert(#p112 == 32, p113);
        cassert(p112:find("^%x+$") ~= nil, p113);
    end;
end;

function u1.FromGenerateUID(p114, p115) -- Line: 330
    -- upvalues: u1 (copy)
    return u1.UUIDv4StrippedUpper(p114, p115);
end;

function u1.optional.FromGenerateUID(p116, p117) -- Line: 334
    -- upvalues: u1 (copy)
    return u1.optional.UUIDv4StrippedUpper(p116, p117);
end;

function u1.UUIDv4StrippedLower(p118, p119) -- Line: 338
    cassert(type(p118) == "string", p119);
    cassert(#p118 == 32, p119);
    cassert(p118:find("^[0-9a-f]+$") ~= nil, p119);
    cassert(p118:sub(13, 13) == "4", p119);
    cassert(p118:sub(17, 17):find("[8-9a-b]") ~= nil, p119);
end;

function u1.optional.UUIDv4StrippedLower(p120, p121) -- Line: 346
    if p120 ~= nil then
        cassert(type(p120) == "string", p121);
        cassert(#p120 == 32, p121);
        cassert(p120:find("^[0-9a-f]+$") ~= nil, p121);
        cassert(p120:sub(13, 13) == "4", p121);
        cassert(p120:sub(17, 17):find("[8-9a-b]") ~= nil, p121);
    end;
end;

function u1.UUIDv4StrippedLowerFast(p122, p123) -- Line: 356
    cassert(type(p122) == "string", p123);
    cassert(#p122 == 32, p123);
end;

function u1.optional.UUIDv4StrippedLowerFast(p124, p125) -- Line: 361
    if p124 ~= nil then
        cassert(type(p124) == "string", p125);
        cassert(#p124 == 32, p125);
    end;
end;

function u1.UUIDv4StrippedUpper(p126, p127) -- Line: 368
    cassert(type(p126) == "string", p127);
    cassert(#p126 == 32, p127);
    cassert(p126:find("^[0-9A-F]+$") ~= nil, p127);
    cassert(p126:sub(13, 13) == "4", p127);
    cassert(p126:sub(17, 17):find("[8-9A-B]") ~= nil, p127);
end;

function u1.optional.UUIDv4StrippedUpper(p128, p129) -- Line: 376
    if p128 ~= nil then
        cassert(type(p128) == "string", p129);
        cassert(#p128 == 32, p129);
        cassert(p128:find("^[0-9A-F]+$") ~= nil, p129);
        cassert(p128:sub(13, 13) == "4", p129);
        cassert(p128:sub(17, 17):find("[8-9A-B]") ~= nil, p129);
    end;
end;

function u1.func(p130, p131) -- Line: 386
    cassert(type(p130) == "function", p131);
end;

function u1.optional.func(p132, p133) -- Line: 390
    local v134 = p132 == nil and true or type(p132) == "function";
    cassert(v134, p133);
end;

function u1.table(p135, p136) -- Line: 398
    cassert(type(p135) == "table", p136);
end;

function u1.optional.table(p137, p138) -- Line: 402
    local v139 = p137 == nil and true or type(p137) == "table";
    cassert(v139, p138);
end;

function u1.array.generic(p140, p141, p142) -- Line: 410
    cassert(type(p140) == "table", p142);
    local v143 = #p140;

    if v143 <= 0 then
        cassert(next(p140) == nil, p142);

        return;
    end;

    local v144 = 0;

    for i, v in pairs(p140) do
        v144 = v144 + 1;
        cassert(i == v144, p142);
        cassert(type(v) == p141, p142);
    end;

    cassert(v144 == v143, p142);
end;

function u1.array.notEmpty(p145, p146) -- Line: 425
    cassert(type(p145) == "table", p146);
    assert(#p145 > 0, "An empty array was provided");
end;

function u1.array.custom(p147, p148, p149) -- Line: 430
    cassert(type(p147) == "table", p149);
    local v150 = #p147;

    if v150 <= 0 then
        cassert(next(p147) == nil, p149);

        return;
    end;

    local v151 = 0;

    for i, v in pairs(p147) do
        v151 = v151 + 1;
        cassert(i == v151, p149);
        p148(v, (p149 or 0) + 1);
    end;

    cassert(v151 == v150, p149);
end;

function u1.array.uuid(p152, p153) -- Line: 446
    -- upvalues: u1 (copy)
    u1.array.custom(p152, u1.uuid, (p153 or 0) + 1);
end;

function u1.array.uuidStripped(p154, p155) -- Line: 450
    -- upvalues: u1 (copy)
    u1.array.custom(p154, u1.uuidStripped, (p155 or 0) + 1);
end;

function u1.array.UUIDv4StrippedLower(p156, p157) -- Line: 454
    -- upvalues: u1 (copy)
    u1.array.custom(p156, u1.UUIDv4StrippedLower, (p157 or 0) + 1);
end;

function u1.array.uniqueUUID(p158, p159) -- Line: 458
    -- upvalues: u1 (copy)
    u1.array.custom(p158, u1.uuid, (p159 or 0) + 1);
    local v160 = {};

    for _, v in ipairs(p158) do
        cassert(not v160[v], p159);
        v160[v] = true;
    end;
end;

function u1.array.uniqueUUIDStripped(p161, p162) -- Line: 467
    -- upvalues: u1 (copy)
    u1.array.custom(p161, u1.uuidStripped, (p162 or 0) + 1);
    local v163 = {};

    for _, v in ipairs(p161) do
        cassert(not v163[v], p162);
        v163[v] = true;
    end;
end;

function u1.array.uniqueUUIDv4StrippedLower(p164, p165) -- Line: 476
    -- upvalues: u1 (copy)
    u1.array.custom(p164, u1.UUIDv4StrippedLower, (p165 or 0) + 1);
    local v166 = {};

    for _, v in ipairs(p164) do
        cassert(not v166[v], p165);
        v166[v] = true;
    end;
end;

function u1.array.uniqueUUIDv4StrippedLowerFast(p167, p168) -- Line: 485
    -- upvalues: u1 (copy)
    u1.array.custom(p167, u1.UUIDv4StrippedLowerFast, (p168 or 0) + 1);
    local v169 = {};

    for _, v in ipairs(p167) do
        cassert(not v169[v], p168);
        v169[v] = true;
    end;
end;

function u1.array.boolean(p170, p171) -- Line: 494
    -- upvalues: u1 (copy)
    u1.array.generic(p170, "boolean", (p171 or 0) + 1);
end;

function u1.array.number(p172, p173) -- Line: 498
    -- upvalues: u1 (copy)
    u1.array.generic(p172, "number", (p173 or 0) + 1);
end;

function u1.array.string(p174, p175) -- Line: 502
    -- upvalues: u1 (copy)
    u1.array.generic(p174, "string", (p175 or 0) + 1);
end;

function u1.array.table(p176, p177) -- Line: 506
    -- upvalues: u1 (copy)
    u1.array.generic(p176, "table", (p177 or 0) + 1);
end;

function u1.array.Vector2(p178, p179) -- Line: 510
    -- upvalues: u1 (copy)
    u1.array.generic(p178, "Vector2", (p179 or 0) + 1);
end;

function u1.array.finiteVector2(p180, p181) -- Line: 514
    -- upvalues: u1 (copy)
    u1.array.custom(p180, u1.finiteVector2, (p181 or 0) + 1);
end;

function u1.array.Vector3(p182, p183) -- Line: 518
    -- upvalues: u1 (copy)
    u1.array.generic(p182, "Vector3", (p183 or 0) + 1);
end;

function u1.array.finiteVector3(p184, p185) -- Line: 522
    -- upvalues: u1 (copy)
    u1.array.custom(p184, u1.finiteVector3, (p185 or 0) + 1);
end;

function u1.array.CFrame(p186, p187) -- Line: 526
    -- upvalues: u1 (copy)
    u1.array.generic(p186, "CFrame", (p187 or 0) + 1);
end;

function u1.array.finiteCFrame(p188, p189) -- Line: 530
    -- upvalues: u1 (copy)
    u1.array.custom(p188, u1.finiteCFrame, (p189 or 0) + 1);
end;

function u1.array.integer(p190, p191) -- Line: 534
    -- upvalues: u1 (copy)
    u1.array.custom(p190, u1.integer, (p191 or 0) + 1);
end;

function u1.array.positiveInteger(p192, p193) -- Line: 538
    -- upvalues: u1 (copy)
    u1.array.custom(p192, u1.positiveInteger, (p193 or 0) + 1);
end;

function u1.array.Player(p194, p195) -- Line: 542
    -- upvalues: u1 (copy)
    u1.array.custom(p194, u1.Player, (p195 or 0) + 1);
end;

function u1.array.finite(p196, p197) -- Line: 546
    -- upvalues: u1 (copy)
    u1.array.custom(p196, u1.finite, (p197 or 0) + 1);
end;

function u1.array.uniqueInteger(p198, p199) -- Line: 550
    -- upvalues: u1 (copy)
    local u200 = {};
    u1.array.custom(p198, function(p201, p202) -- Line: 552
        -- upvalues: u1 (ref), u200 (copy)
        u1.integer(p201, (p202 or 0) + 1);
        cassert(not u200[p201], p202);
        u200[p201] = true;
    end, (p199 or 0) + 1);
end;

function u1.array.uniquePlayer(p203, p204) -- Line: 559
    -- upvalues: u1 (copy)
    local u205 = {};
    u1.array.custom(p203, function(p206, p207) -- Line: 561
        -- upvalues: u1 (ref), u205 (copy)
        u1.Player(p206, (p207 or 0) + 1);
        cassert(not u205[p206], p207);
        u205[p206] = true;
    end, (p204 or 0) + 1);
end;

function u1.array.uniqueModel(p208, p209) -- Line: 568
    -- upvalues: u1 (copy)
    local u210 = {};
    u1.array.custom(p208, function(p211, p212) -- Line: 570
        -- upvalues: u1 (ref), u210 (copy)
        u1.Model(p211, (p212 or 0) + 1);
        cassert(not u210[p211], p212);
        u210[p211] = true;
    end, (p209 or 0) + 1);
end;

function u1.Vector2(p213, p214) -- Line: 577
    cassert(typeof(p213) == "Vector2", p214);
end;

function u1.optional.Vector2(p215, p216) -- Line: 581
    local v217 = p215 == nil and true or typeof(p215) == "Vector2";
    cassert(v217, p216);
end;

function u1.finiteVector2(p218, p219) -- Line: 589
    cassert(typeof(p218) == "Vector2", p219);
    cassert(IsFiniteVec2(p218), p219);
end;

function u1.optional.finiteVector2(p220, p221) -- Line: 594
    if p220 ~= nil then
        cassert(typeof(p220) == "Vector2", p221);
        cassert(IsFiniteVec2(p220), p221);
    end;
end;

function u1.Vector3(p222, p223) -- Line: 601
    cassert(typeof(p222) == "Vector3", p223);
end;

function u1.optional.Vector3(p224, p225) -- Line: 605
    local v226 = p224 == nil and true or typeof(p224) == "Vector3";
    cassert(v226, p225);
end;

function u1.finiteVector3(p227, p228) -- Line: 613
    cassert(typeof(p227) == "Vector3", p228);
    cassert(IsFiniteVec(p227), p228);
end;

function u1.optional.finiteVector3(p229, p230) -- Line: 618
    if p229 ~= nil then
        cassert(typeof(p229) == "Vector3", p230);
        cassert(IsFiniteVec(p229), p230);
    end;
end;

function u1.CFrame(p231, p232) -- Line: 625
    cassert(typeof(p231) == "CFrame", p232);
end;

function u1.optional.CFrame(p233, p234) -- Line: 629
    local v235 = p233 == nil and true or typeof(p233) == "CFrame";
    cassert(v235, p234);
end;

function u1.finiteCFrame(p236, p237) -- Line: 637
    cassert(typeof(p236) == "CFrame", p237);
    cassert(IsFiniteCFrame(p236), p237);
end;

function u1.optional.finiteCFrame(p238, p239) -- Line: 642
    if p238 ~= nil then
        cassert(typeof(p238) == "CFrame", p239);
        cassert(IsFiniteCFrame(p238), p239);
    end;
end;

function u1.Instance(p240, p241) -- Line: 649
    cassert(typeof(p240) == "Instance", p241);
end;

function u1.optional.Instance(p242, p243) -- Line: 653
    local v244 = p242 == nil and true or typeof(p242) == "Instance";
    cassert(v244, p243);
end;

function u1.Player(p245, p246) -- Line: 661
    local v247;

    if typeof(p245) == "Instance" then
        v247 = p245.ClassName == "Player";
    else
        v247 = false;
    end;

    cassert(v247, p246);
end;

function u1.optional.Player(p248, p249) -- Line: 669
    local v250;

    if p248 == nil then
        v250 = true;
    elseif typeof(p248) == "Instance" then
        v250 = p248.ClassName == "Player";
    else
        v250 = false;
    end;

    cassert(v250, p249);
end;

function u1.Model(p251, p252) -- Line: 680
    local v253;

    if typeof(p251) == "Instance" then
        v253 = p251.ClassName == "Model";
    else
        v253 = false;
    end;

    cassert(v253, p252);
end;

function u1.Sound(p254, p255) -- Line: 688
    local v256;

    if typeof(p254) == "Instance" then
        v256 = p254.ClassName == "Sound";
    else
        v256 = false;
    end;

    cassert(v256, p255);
end;

function u1.optional.Sound(p257, p258) -- Line: 696
    local v259;

    if p257 == nil then
        v259 = true;
    elseif typeof(p257) == "Instance" then
        v259 = p257.ClassName == "Sound";
    else
        v259 = false;
    end;

    cassert(v259, p258);
end;

function u1.optional.Model(p260, p261) -- Line: 707
    local v262;

    if p260 == nil then
        v262 = true;
    elseif typeof(p260) == "Instance" then
        v262 = p260.ClassName == "Model";
    else
        v262 = false;
    end;

    cassert(v262, p261);
end;

function u1.Attachment(p263, p264) -- Line: 718
    local v265;

    if typeof(p263) == "Instance" then
        v265 = p263.ClassName == "Attachment";
    else
        v265 = false;
    end;

    cassert(v265, p264);
end;

function u1.optional.Attachment(p266, p267) -- Line: 726
    local v268;

    if p266 == nil then
        v268 = true;
    elseif typeof(p266) == "Instance" then
        v268 = p266.ClassName == "Attachment";
    else
        v268 = false;
    end;

    cassert(v268, p267);
end;

function u1.BasePart(p269, p270) -- Line: 737
    local v271;

    if typeof(p269) == "Instance" then
        v271 = p269:IsA("BasePart");
    else
        v271 = false;
    end;

    cassert(v271, p270);
end;

function u1.optional.BasePart(p272, p273) -- Line: 745
    local v274;

    if p272 == nil then
        v274 = true;
    elseif typeof(p272) == "Instance" then
        v274 = p272:IsA("BasePart");
    else
        v274 = false;
    end;

    cassert(v274, p273);
end;

function u1.Tool(p275, p276) -- Line: 756
    local v277;

    if typeof(p275) == "Instance" then
        v277 = p275:IsA("Tool");
    else
        v277 = false;
    end;

    cassert(v277, p276);
end;

function u1.optional.Tool(p278, p279) -- Line: 764
    local v280;

    if p278 == nil then
        v280 = true;
    elseif typeof(p278) == "Instance" then
        v280 = p278:IsA("Tool");
    else
        v280 = false;
    end;

    cassert(v280, p279);
end;

function u1.Motor6D(p281, p282) -- Line: 775
    local v283;

    if typeof(p281) == "Instance" then
        v283 = p281:IsA("Motor6D");
    else
        v283 = false;
    end;

    cassert(v283, p282);
end;

function u1.optional.Motor6D(p284, p285) -- Line: 783
    local v286;

    if p284 == nil then
        v286 = true;
    elseif typeof(p284) == "Instance" then
        v286 = p284:IsA("Motor6D");
    else
        v286 = false;
    end;

    cassert(v286, p285);
end;

function u1.UIGradient(p287, p288) -- Line: 794
    local v289;

    if typeof(p287) == "Instance" then
        v289 = p287:IsA("UIGradient");
    else
        v289 = false;
    end;

    cassert(v289, p288);
end;

function u1.optional.UIGradient(p290, p291) -- Line: 802
    local v292;

    if p290 == nil then
        v292 = true;
    elseif typeof(p290) == "Instance" then
        v292 = p290:IsA("UIGradient");
    else
        v292 = false;
    end;

    cassert(v292, p291);
end;

function u1.ImageLabel(p293, p294) -- Line: 813
    local v295;

    if typeof(p293) == "Instance" then
        v295 = p293:IsA("ImageLabel");
    else
        v295 = false;
    end;

    cassert(v295, p294);
end;

function u1.optional.ImageLabel(p296, p297) -- Line: 821
    local v298;

    if p296 == nil then
        v298 = true;
    elseif typeof(p296) == "Instance" then
        v298 = p296:IsA("ImageLabel");
    else
        v298 = false;
    end;

    cassert(v298, p297);
end;

function u1.GuiObject(p299, p300) -- Line: 832
    local v301;

    if typeof(p299) == "Instance" then
        v301 = p299:IsA("GuiObject");
    else
        v301 = false;
    end;

    cassert(v301, p300);
end;

function u1.optional.GuiObject(p302, p303) -- Line: 840
    local v304;

    if p302 == nil then
        v304 = true;
    elseif typeof(p302) == "Instance" then
        v304 = p302:IsA("GuiObject");
    else
        v304 = false;
    end;

    cassert(v304, p303);
end;

function u1.Frame(p305, p306) -- Line: 851
    local v307;

    if typeof(p305) == "Instance" then
        v307 = p305:IsA("Frame");
    else
        v307 = false;
    end;

    cassert(v307, p306);
end;

function u1.optional.Frame(p308, p309) -- Line: 859
    local v310;

    if p308 == nil then
        v310 = true;
    elseif typeof(p308) == "Instance" then
        v310 = p308:IsA("Frame");
    else
        v310 = false;
    end;

    cassert(v310, p309);
end;

function u1.Folder(p311, p312) -- Line: 870
    local v313;

    if typeof(p311) == "Instance" then
        v313 = p311:IsA("Folder");
    else
        v313 = false;
    end;

    cassert(v313, p312);
end;

function u1.optional.Folder(p314, p315) -- Line: 878
    local v316;

    if p314 == nil then
        v316 = true;
    elseif typeof(p314) == "Instance" then
        v316 = p314:IsA("Folder");
    else
        v316 = false;
    end;

    cassert(v316, p315);
end;

function u1.MeshPart(p317, p318) -- Line: 889
    local v319;

    if typeof(p317) == "Instance" then
        v319 = p317:IsA("MeshPart");
    else
        v319 = false;
    end;

    cassert(v319, p318);
end;

function u1.optional.MeshPart(p320, p321) -- Line: 897
    local v322;

    if p320 == nil then
        v322 = true;
    elseif typeof(p320) == "Instance" then
        v322 = p320:IsA("MeshPart");
    else
        v322 = false;
    end;

    cassert(v322, p321);
end;

function u1.BillboardGui(p323, p324) -- Line: 908
    local v325;

    if typeof(p323) == "Instance" then
        v325 = p323:IsA("BillboardGui");
    else
        v325 = false;
    end;

    cassert(v325, p324);
end;

function u1.optional.BillboardGui(p326, p327) -- Line: 916
    local v328;

    if p326 == nil then
        v328 = true;
    elseif typeof(p326) == "Instance" then
        v328 = p326:IsA("BillboardGui");
    else
        v328 = false;
    end;

    cassert(v328, p327);
end;

function u1.TextLabel(p329, p330) -- Line: 927
    local v331;

    if typeof(p329) == "Instance" then
        v331 = p329:IsA("TextLabel");
    else
        v331 = false;
    end;

    cassert(v331, p330);
end;

function u1.optional.TextLabel(p332, p333) -- Line: 935
    local v334;

    if p332 == nil then
        v334 = true;
    elseif typeof(p332) == "Instance" then
        v334 = p332:IsA("TextLabel");
    else
        v334 = false;
    end;

    cassert(v334, p333);
end;

function u1.UIScale(p335, p336) -- Line: 946
    local v337;

    if typeof(p335) == "Instance" then
        v337 = p335:IsA("UIScale");
    else
        v337 = false;
    end;

    cassert(v337, p336);
end;

function u1.optional.UIScale(p338, p339) -- Line: 954
    local v340;

    if p338 == nil then
        v340 = true;
    elseif typeof(p338) == "Instance" then
        v340 = p338:IsA("UIScale");
    else
        v340 = false;
    end;

    cassert(v340, p339);
end;

function u1.ScrollingFrame(p341, p342) -- Line: 965
    local v343;

    if typeof(p341) == "Instance" then
        v343 = p341:IsA("ScrollingFrame");
    else
        v343 = false;
    end;

    cassert(v343, p342);
end;

function u1.optional.ScrollingFrame(p344, p345) -- Line: 973
    local v346;

    if p344 == nil then
        v346 = true;
    elseif typeof(p344) == "Instance" then
        v346 = p344:IsA("ScrollingFrame");
    else
        v346 = false;
    end;

    cassert(v346, p345);
end;

function u1.ModuleScript(p347, p348) -- Line: 984
    local v349;

    if typeof(p347) == "Instance" then
        v349 = p347:IsA("ModuleScript");
    else
        v349 = false;
    end;

    cassert(v349, p348);
end;

function u1.optional.ModuleScript(p350, p351) -- Line: 992
    local v352;

    if p350 == nil then
        v352 = true;
    elseif typeof(p350) == "Instance" then
        v352 = p350:IsA("ModuleScript");
    else
        v352 = false;
    end;

    cassert(v352, p351);
end;

function u1.GuiButton(p353, p354) -- Line: 1003
    local v355;

    if typeof(p353) == "Instance" then
        v355 = p353:IsA("GuiButton");
    else
        v355 = false;
    end;

    cassert(v355, p354);
end;

function u1.optional.GuiButton(p356, p357) -- Line: 1011
    local v358;

    if p356 == nil then
        v358 = true;
    elseif typeof(p356) == "Instance" then
        v358 = p356:IsA("GuiButton");
    else
        v358 = false;
    end;

    cassert(v358, p357);
end;

function u1.Humanoid(p359, p360) -- Line: 1022
    local v361;

    if typeof(p359) == "Instance" then
        v361 = p359:IsA("Humanoid");
    else
        v361 = false;
    end;

    cassert(v361, p360);
end;

function u1.optional.Humanoid(p362, p363) -- Line: 1030
    local v364;

    if p362 == nil then
        v364 = true;
    elseif typeof(p362) == "Instance" then
        v364 = p362:IsA("Humanoid");
    else
        v364 = false;
    end;

    cassert(v364, p363);
end;

function u1.Animator(p365, p366) -- Line: 1041
    local v367;

    if typeof(p365) == "Instance" then
        v367 = p365:IsA("Animator");
    else
        v367 = false;
    end;

    cassert(v367, p366);
end;

function u1.optional.Animator(p368, p369) -- Line: 1049
    local v370;

    if p368 == nil then
        v370 = true;
    elseif typeof(p368) == "Instance" then
        v370 = p368:IsA("Animator");
    else
        v370 = false;
    end;

    cassert(v370, p369);
end;

function u1.Animation(p371, p372) -- Line: 1060
    local v373;

    if typeof(p371) == "Instance" then
        v373 = p371:IsA("Animation");
    else
        v373 = false;
    end;

    cassert(v373, p372);
end;

function u1.optional.Animation(p374, p375) -- Line: 1068
    local v376;

    if p374 == nil then
        v376 = true;
    elseif typeof(p374) == "Instance" then
        v376 = p374:IsA("Animation");
    else
        v376 = false;
    end;

    cassert(v376, p375);
end;

return u1;