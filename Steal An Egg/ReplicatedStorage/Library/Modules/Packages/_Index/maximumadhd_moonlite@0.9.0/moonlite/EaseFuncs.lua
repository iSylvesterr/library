-- Decompiled with Potassium's decompiler.

local u1 = {};
require(script.Parent.Types);

function u1.Linear(p2, p3, p4, p5) -- Line: 21
    return p4 * p2 / p5 + p3;
end;

function u1.Constant(p6, p7, p8, p9) -- Line: 29
    return p6 == p9 and 1 or 0;
end;

function u1.InSine(p10, p11, p12, p13) -- Line: 37
    return -p12 * math.cos(p10 / p13 * 1.5707963267948966) + p12 + p11;
end;

function u1.OutSine(p14, p15, p16, p17) -- Line: 41
    return p16 * math.sin(p14 / p17 * 1.5707963267948966) + p15;
end;

function u1.InOutSine(p18, p19, p20, p21) -- Line: 45
    return -p20 / 2 * (math.cos(3.141592653589793 * p18 / p21) - 1) + p19;
end;

function u1.OutInSine(p22, p23, p24, p25) -- Line: 49
    -- upvalues: u1 (copy)
    if p22 < p25 / 2 then
        return u1.OutSine(p22 * 2, p23, p24 / 2, p25);
    end;

    return u1.InSine(p22 * 2 - p25, p23 + p24 / 2, p24 / 2, p25);
end;

function u1.InQuad(p26, p27, p28, p29) -- Line: 61
    return p28 * math.pow(p26 / p29, 2) + p27;
end;

function u1.OutQuad(p30, p31, p32, p33) -- Line: 66
    local v34 = p30 / p33;

    return -p32 * v34 * (v34 - 2) + p31;
end;

function u1.InOutQuad(p35, p36, p37, p38) -- Line: 71
    local v39 = p35 / p38 * 2;

    if v39 < 1 then
        return p37 / 2 * math.pow(v39, 2) + p36;
    end;

    return -p37 / 2 * ((v39 - 1) * (v39 - 3) - 1) + p36;
end;

function u1.OutInQuad(p40, p41, p42, p43) -- Line: 81
    -- upvalues: u1 (copy)
    if p40 < p43 / 2 then
        return u1.OutQuad(p40 * 2, p41, p42 / 2, p43);
    end;

    return u1.InQuad(p40 * 2 - p43, p41 + p42 / 2, p42 / 2, p43);
end;

function u1.InCubic(p44, p45, p46, p47) -- Line: 93
    return p46 * math.pow(p44 / p47, 3) + p45;
end;

function u1.OutCubic(p48, p49, p50, p51) -- Line: 98
    return p50 * (math.pow(p48 / p51 - 1, 3) + 1) + p49;
end;

function u1.InOutCubic(p52, p53, p54, p55) -- Line: 103
    local v56 = p52 / p55 * 2;

    if v56 < 1 then
        return p54 / 2 * v56 * v56 * v56 + p53;
    end;

    local v57 = v56 - 2;

    return p54 / 2 * (v57 * v57 * v57 + 2) + p53;
end;

function u1.OutInCubic(p58, p59, p60, p61) -- Line: 114
    -- upvalues: u1 (copy)
    if p58 < p61 / 2 then
        return u1.OutCubic(p58 * 2, p59, p60 / 2, p61);
    end;

    return u1.InCubic(p58 * 2 - p61, p59 + p60 / 2, p60 / 2, p61);
end;

function u1.InQuart(p62, p63, p64, p65) -- Line: 126
    return p64 * math.pow(p62 / p65, 4) + p63;
end;

function u1.OutQuart(p66, p67, p68, p69) -- Line: 131
    return -p68 * (math.pow(p66 / p69 - 1, 4) - 1) + p67;
end;

function u1.InOutQuart(p70, p71, p72, p73) -- Line: 136
    local v74 = p70 / p73 * 2;

    if v74 < 1 then
        return p72 / 2 * math.pow(v74, 4) + p71;
    end;

    return -p72 / 2 * (math.pow(v74 - 2, 4) - 2) + p71;
end;

function u1.OutInQuart(p75, p76, p77, p78) -- Line: 147
    -- upvalues: u1 (copy)
    if p75 < p78 / 2 then
        return u1.OutQuart(p75 * 2, p76, p77 / 2, p78);
    end;

    return u1.InQuart(p75 * 2 - p78, p76 + p77 / 2, p77 / 2, p78);
end;

function u1.InQuint(p79, p80, p81, p82) -- Line: 159
    return p81 * math.pow(p79 / p82, 5) + p80;
end;

function u1.OutQuint(p83, p84, p85, p86) -- Line: 164
    return p85 * (math.pow(p83 / p86 - 1, 5) + 1) + p84;
end;

function u1.InOutQuint(p87, p88, p89, p90) -- Line: 169
    local v91 = p87 / p90 * 2;

    if v91 < 1 then
        return p89 / 2 * math.pow(v91, 5) + p88;
    end;

    return p89 / 2 * (math.pow(v91 - 2, 5) + 2) + p88;
end;

function u1.OutInQuint(p92, p93, p94, p95) -- Line: 180
    -- upvalues: u1 (copy)
    if p92 < p95 / 2 then
        return u1.OutQuint(p92 * 2, p93, p94 / 2, p95);
    end;

    return u1.InQuint(p92 * 2 - p95, p93 + p94 / 2, p94 / 2, p95);
end;

function u1.InSextic(p96, p97, p98, p99) -- Line: 192
    return p98 * math.pow(p96 / p99, 6) + p97;
end;

function u1.OutSextic(p100, p101, p102, p103) -- Line: 197
    return -p102 * (math.pow(p100 / p103 - 1, 6) - 1) + p101;
end;

function u1.InOutSextic(p104, p105, p106, p107) -- Line: 202
    local v108 = p104 / p107 * 2;

    if v108 < 1 then
        return p106 / 2 * math.pow(v108, 6) + p105;
    end;

    return -p106 / 2 * (math.pow(v108 - 2, 6) - 2) + p105;
end;

function u1.OutInSextic(p109, p110, p111, p112) -- Line: 213
    -- upvalues: u1 (copy)
    if p109 < p112 / 2 then
        return u1.OutSextic(p109 * 2, p110, p111 / 2, p112);
    end;

    return u1.InSextic(p109 * 2 - p112, p110 + p111 / 2, p111 / 2, p112);
end;

function u1.InExpo(p113, p114, p115, p116) -- Line: 225
    if p113 == 0 then
        return p114;
    end;

    return p115 * math.pow(2, 10 * (p113 / p116 - 1)) + p114 - p115 * 0.001;
end;

function u1.OutExpo(p117, p118, p119, p120) -- Line: 233
    if p117 == p120 then
        return p118 + p119;
    end;

    return p119 * 1.001 * (-math.pow(2, -10 * p117 / p120) + 1) + p118;
end;

function u1.InOutExpo(p121, p122, p123, p124) -- Line: 241
    if p121 == 0 then
        return p122;
    end;

    if p121 == p124 then
        return p122 + p123;
    end;

    local v125 = p121 / p124 * 2;

    if v125 < 1 then
        return p123 / 2 * math.pow(2, 10 * (v125 - 1)) + p122 - p123 * 0.0005;
    end;

    return p123 / 2 * 1.0005 * (-math.pow(2, -10 * (v125 - 1)) + 2) + p122;
end;

function u1.OutInExpo(p126, p127, p128, p129) -- Line: 260
    -- upvalues: u1 (copy)
    if p126 < p129 / 2 then
        return u1.OutExpo(p126 * 2, p127, p128 / 2, p129);
    end;

    return u1.InExpo(p126 * 2 - p129, p127 + p128 / 2, p128 / 2, p129);
end;

function u1.InCirc(p130, p131, p132, p133) -- Line: 272
    local v134 = 1 - math.pow(p130 / p133, 2);

    return -p132 * (math.sqrt(v134) - 1) + p131;
end;

function u1.OutCirc(p135, p136, p137, p138) -- Line: 277
    local v139 = 1 - math.pow(p135 / p138 - 1, 2);

    return p137 * math.sqrt(v139) + p136;
end;

function u1.InOutCirc(p140, p141, p142, p143) -- Line: 282
    local v144 = p140 / p143 * 2;

    if v144 < 1 then
        return -p142 / 2 * (math.sqrt(1 - v144 * v144) - 1) + p141;
    end;

    local v145 = v144 - 2;

    return p142 / 2 * (math.sqrt(1 - v145 * v145) + 1) + p141;
end;

function u1.OutInCirc(p146, p147, p148, p149) -- Line: 293
    -- upvalues: u1 (copy)
    if p146 < p149 / 2 then
        return u1.OutCirc(p146 * 2, p147, p148 / 2, p149);
    end;

    return u1.InCirc(p146 * 2 - p149, p147 + p148 / 2, p148 / 2, p149);
end;

function u1.InBack(p150, p151, p152, p153, p154) -- Line: 305
    local v155 = p154 or 1.70158;
    local v156 = p150 / p153;

    return p152 * v156 * v156 * ((v155 + 1) * v156 - v155) + p151;
end;

function u1.OutBack(p157, p158, p159, p160, p161) -- Line: 314
    local v162 = p161 or 1.70158;
    local v163 = p157 / p160 - 1;

    return p159 * (v163 * v163 * ((v162 + 1) * v163 + v162) + 1) + p158;
end;

function u1.InOutBack(p164, p165, p166, p167, p168) -- Line: 323
    local v169 = (p168 or 1.70158) * 1.525;
    local v170 = p164 / p167 * 2;

    if v170 < 1 then
        return p166 / 2 * (v170 * v170 * ((v169 + 1) * v170 - v169)) + p165;
    end;

    local v171 = v170 - 2;

    return p166 / 2 * (v171 * v171 * ((v169 + 1) * v171 + v169) + 2) + p165;
end;

function u1.OutInBack(p172, p173, p174, p175, p176) -- Line: 339
    -- upvalues: u1 (copy)
    if p172 < p175 / 2 then
        return u1.OutBack(p172 * 2, p173, p174 / 2, p175, p176);
    end;

    return u1.InBack(p172 * 2 - p175, p173 + p174 / 2, p174 / 2, p175, p176);
end;

function u1.OutBounce(p177, p178, p179, p180) -- Line: 351
    local v181 = p177 / p180;

    if v181 < 0.36363636363636365 then
        return p179 * (7.5625 * v181 * v181) + p178;
    end;

    if v181 < 0.7272727272727273 then
        local v182 = v181 - 0.5454545454545454;

        return p179 * (7.5625 * v182 * v182 + 0.75) + p178;
    end;

    if v181 < 0.9090909090909091 then
        local v183 = v181 - 0.8181818181818182;

        return p179 * (7.5625 * v183 * v183 + 0.9375) + p178;
    end;

    local v184 = v181 - 0.9545454545454546;

    return p179 * (7.5625 * v184 * v184 + 0.984375) + p178;
end;

function u1.InBounce(p185, p186, p187, p188) -- Line: 368
    -- upvalues: u1 (copy)
    return p187 - u1.OutBounce(p188 - p185, 0, p187, p188) + p186;
end;

function u1.InOutBounce(p189, p190, p191, p192) -- Line: 372
    -- upvalues: u1 (copy)
    if p189 < p192 / 2 then
        return u1.InBounce(p189 * 2, 0, p191, p192) * 0.5 + p190;
    end;

    return u1.OutBounce(p189 * 2 - p192, 0, p191, p192) * 0.5 + p191 * 0.5 + p190;
end;

function u1.OutInBounce(p193, p194, p195, p196) -- Line: 380
    -- upvalues: u1 (copy)
    if p193 < p196 / 2 then
        return u1.OutBounce(p193 * 2, p194, p195 / 2, p196);
    end;

    return u1.InBounce(p193 * 2 - p196, p194 + p195 / 2, p195 / 2, p196);
end;

function u1.ElasticBlend(p197, p198, p199, p200, p201, p202) -- Line: 392
    if p198 ~= 0 then
        local v203 = math.abs(p201);
        p202 = p200 == 0 and 0 or p202 * (p200 / math.abs(p198));

        if math.abs(p197 * p199) < v203 then
            local v204 = math.abs(p197 * p199) / v203;
            p202 = p202 * v204 + (1 - v204);
        end;
    end;

    return p202;
end;

function u1.InElastic(p205, p206, p207, p208, p209, p210) -- Line: 411
    -- upvalues: u1 (copy)
    local v211 = 1;

    if p205 == 0 then
        return p206;
    end;

    local v212 = p205 / p208;

    if v212 == 1 then
        return p206 + p207;
    end;

    local v213 = v212 - 1;

    if not p210 or p210 == 0 then
        p210 = p208 * 0.3;
    end;

    local v214;

    if p209 == nil or p209 < math.abs(p207) then
        v214 = p210 / 4;
        v211 = u1.ElasticBend(v213, p207, p208, p209, v214, v211);
    else
        v214 = p210 / 6.283185307179586 * math.asin(p207 / p209);
        p207 = p209;
    end;

    return -v211 * (p207 * math.pow(2, 10 * v213) * math.sin((v213 * p208 - v214) * 6.283185307179586 / p210)) + p206;
end;

function u1.OutElastic(p215, p216, p217, p218, p219, p220) -- Line: 442
    -- upvalues: u1 (copy)
    local v221 = 1;

    if p215 == 0 then
        return p216;
    end;

    local v222 = p215 / p218;

    if v222 == 1 then
        return p216 + p217;
    end;

    local v223 = -v222;

    if not p220 or p220 == 0 then
        p220 = p218 * 0.3;
    end;

    local v224;

    if p219 == nil or p219 < math.abs(p217) then
        v224 = p220 / 4;
        v221 = u1.ElasticBlend(v223, p217, p218, p219, v224, v221);
        p219 = p217;
    else
        v224 = p220 / 6.283185307179586 * math.asin(p217 / p219);
    end;

    return v221 * (p219 * math.pow(2, 10 * v223) * math.sin((v223 * p218 - v224) * 6.283185307179586 / p220)) + p217 + p216;
end;

function u1.InOutElastic(p225, p226, p227, p228, p229, p230) -- Line: 473
    -- upvalues: u1 (copy)
    local v231 = 1;

    if p225 == 0 then
        return p226;
    end;

    local v232 = p225 / (p228 / 2);

    if v232 == 2 then
        return p226 + p227;
    end;

    local v233 = v232 - 1;

    if not p230 or p230 == 0 then
        p230 = p228 * 0.44999999999999996;
    end;

    local v234;

    if p229 == nil or p229 < math.abs(p227) then
        v234 = p230 / 4;
        v231 = u1.ElasticBlend(v233, p227, p228, p229, v234, v231);
        p229 = p227;
    else
        v234 = p230 / 6.283185307179586 * math.asin(p227 / p229);
    end;

    if v233 < 0 then
        return v231 * -0.5 * (p229 * math.pow(2, 10 * v233) * math.sin((v233 * p228 - v234) * 6.283185307179586 / p230)) + p226;
    end;

    local v235 = -v233;

    return v231 * 0.5 * (p229 * math.pow(2, 10 * v235) * math.sin((v235 * p228 - v234) * 6.283185307179586 / p230)) + p227 + p226;
end;

function u1.OutInElastic(p236, p237, p238, p239, p240, p241) -- Line: 511
    -- upvalues: u1 (copy)
    if p236 < p239 / 2 then
        return u1.OutElastic(p236 * 2, p237, p238 / 2, p239, p240, p241);
    end;

    return u1.InElastic(p236 * 2 - p239, p237 + p238 / 2, p238 / 2, p239, p240, p241);
end;

local HttpService = game:GetService("HttpService");
local u242 = {
    Type = "Linear",
    Params = {}
};
local u243 = {};

local function get(p244) -- Line: 534
    -- upvalues: u242 (copy), HttpService (copy), u243 (copy), u1 (copy), get (copy)
    local v245 = p244 or u242;
    local v246 = HttpService:JSONEncode(v245);

    if u243[v246] == nil then
        local Params = v245.Params;
        local v247 = v245.Type or "Linear";
        local u248 = u1[`{Params.Direction or "In"}{v247}`] or u1[v247];

        if not u248 then
            return get(u242);
        end;

        local u249 = nil;
        local u250 = nil;

        if v247 == "Elastic" then
            u249 = Params.Amplitude or 1;
            u250 = Params.Period or 0.3;
        elseif v247 == "Back" then
            u249 = Params.Overshoot or 1.70158;
        end;

        u243[v246] = function(p251) -- Line: 558
            -- upvalues: u248 (copy), u249 (ref), u250 (ref)
            return u248(p251, 0, 1, 1, u249, u250);
        end;
    end;

    return u243[v246];
end;

return {
    Get = get
};