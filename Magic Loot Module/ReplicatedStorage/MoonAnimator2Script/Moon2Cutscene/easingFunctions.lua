-- Decompiled with Potassium's decompiler.

local v3 = {
    Linear = function(p1) -- Line: 13
        return p1;
    end,

    Constant = function(p2) -- Line: 17
        return p2 == 1 and 1 or 0;
    end
};

local function inSine(p4, p5, p6, p7) -- Line: 21
    return -p6 * math.cos(p4 / p7 * 1.5707963267948966) + p6 + p5;
end;

local function outSine(p8, p9, p10, p11) -- Line: 24
    return p10 * math.sin(p8 / p11 * 1.5707963267948966) + p9;
end;

local function inOutSine(p12, p13, p14, p15) -- Line: 27
    return -p14 / 2 * (math.cos(3.141592653589793 * p12 / p15) - 1) + p13;
end;

local function outInSine(p16, p17, p18, p19) -- Line: 30
    if p16 < p19 / 2 then
        return p18 / 2 * math.sin(p16 * 2 / p19 * 1.5707963267948966) + p17;
    end;

    local v20 = p18 / 2;

    return -v20 * math.cos((p16 * 2 - p19) / p19 * 1.5707963267948966) + v20 + (p17 + p18 / 2);
end;

function v3.SineIn(p21) -- Line: 38
    return -1 * math.cos(p21 / 1 * 1.5707963267948966) + 1 + 0;
end;

function v3.SineOut(p22) -- Line: 41
    return 1 * math.sin(p22 / 1 * 1.5707963267948966) + 0;
end;

function v3.SineInOut(p23) -- Line: 44
    return -0.5 * (math.cos(3.141592653589793 * p23 / 1) - 1) + 0;
end;

function v3.SineOutIn(p24) -- Line: 47
    if p24 < 0.5 then
        return 0.5 * math.sin(p24 * 2 / 1 * 1.5707963267948966) + 0;
    end;

    return -0.5 * math.cos((p24 * 2 - 1) / 1 * 1.5707963267948966) + 0.5 + 0.5;
end;

local function inQuad(p25, p26, p27, p28) -- Line: 51
    return p27 * math.pow(p25 / p28, 2) + p26;
end;

local function outQuad(p29, p30, p31, p32) -- Line: 55
    local v33 = p29 / p32;

    return -p31 * v33 * (v33 - 2) + p30;
end;

local function inOutQuad(p34, p35, p36, p37) -- Line: 59
    local v38 = p34 / p37 * 2;

    if v38 < 1 then
        return p36 / 2 * math.pow(v38, 2) + p35;
    end;

    return -p36 / 2 * ((v38 - 1) * (v38 - 3) - 1) + p35;
end;

local function outInQuad(p39, p40, p41, p42) -- Line: 67
    if p39 >= p42 / 2 then
        return p41 / 2 * math.pow((p39 * 2 - p42) / p42, 2) + (p40 + p41 / 2);
    end;

    local v43 = p39 * 2 / p42;

    return -(p41 / 2) * v43 * (v43 - 2) + p40;
end;

function v3.QuadIn(p44) -- Line: 75
    return 1 * math.pow(p44 / 1, 2) + 0;
end;

function v3.QuadOut(p45) -- Line: 78
    local v46 = p45 / 1;

    return -1 * v46 * (v46 - 2) + 0;
end;

function v3.QuadInOut(p47) -- Line: 81
    local v48 = p47 / 1 * 2;

    if v48 < 1 then
        return 0.5 * math.pow(v48, 2) + 0;
    end;

    return -0.5 * ((v48 - 1) * (v48 - 3) - 1) + 0;
end;

function v3.QuadOutIn(p49) -- Line: 84
    if p49 >= 0.5 then
        return 0.5 * math.pow((p49 * 2 - 1) / 1, 2) + 0.5;
    end;

    local v50 = p49 * 2 / 1;

    return -0.5 * v50 * (v50 - 2) + 0;
end;

local function inCubic(p51, p52, p53, p54) -- Line: 88
    return p53 * math.pow(p51 / p54, 3) + p52;
end;

local function outCubic(p55, p56, p57, p58) -- Line: 92
    return p57 * (math.pow(p55 / p58 - 1, 3) + 1) + p56;
end;

local function inOutCubic(p59, p60, p61, p62) -- Line: 96
    local v63 = p59 / p62 * 2;

    if v63 < 1 then
        return p61 / 2 * v63 * v63 * v63 + p60;
    end;

    local v64 = v63 - 2;

    return p61 / 2 * (v64 * v64 * v64 + 2) + p60;
end;

local function outInCubic(p65, p66, p67, p68) -- Line: 105
    if p65 < p68 / 2 then
        return p67 / 2 * (math.pow(p65 * 2 / p68 - 1, 3) + 1) + p66;
    end;

    return p67 / 2 * math.pow((p65 * 2 - p68) / p68, 3) + (p66 + p67 / 2);
end;

function v3.CubicIn(p69) -- Line: 113
    return 1 * math.pow(p69 / 1, 3) + 0;
end;

function v3.CubicOut(p70) -- Line: 116
    return 1 * (math.pow(p70 / 1 - 1, 3) + 1) + 0;
end;

function v3.CubicInOut(p71) -- Line: 119
    local v72 = p71 / 1 * 2;

    if v72 < 1 then
        return 0.5 * v72 * v72 * v72 + 0;
    end;

    local v73 = v72 - 2;

    return 0.5 * (v73 * v73 * v73 + 2) + 0;
end;

function v3.CubicOutIn(p74) -- Line: 122
    if p74 < 0.5 then
        return 0.5 * (math.pow(p74 * 2 / 1 - 1, 3) + 1) + 0;
    end;

    return 0.5 * math.pow((p74 * 2 - 1) / 1, 3) + 0.5;
end;

local function inQuart(p75, p76, p77, p78) -- Line: 126
    return p77 * math.pow(p75 / p78, 4) + p76;
end;

local function outQuart(p79, p80, p81, p82) -- Line: 130
    return -p81 * (math.pow(p79 / p82 - 1, 4) - 1) + p80;
end;

local function inOutQuart(p83, p84, p85, p86) -- Line: 134
    local v87 = p83 / p86 * 2;

    if v87 < 1 then
        return p85 / 2 * math.pow(v87, 4) + p84;
    end;

    return -p85 / 2 * (math.pow(v87 - 2, 4) - 2) + p84;
end;

local function outInQuart(p88, p89, p90, p91) -- Line: 143
    if p88 < p91 / 2 then
        return -(p90 / 2) * (math.pow(p88 * 2 / p91 - 1, 4) - 1) + p89;
    end;

    return p90 / 2 * math.pow((p88 * 2 - p91) / p91, 4) + (p89 + p90 / 2);
end;

function v3.QuartIn(p92) -- Line: 151
    return 1 * math.pow(p92 / 1, 4) + 0;
end;

function v3.QuartOut(p93) -- Line: 154
    return -1 * (math.pow(p93 / 1 - 1, 4) - 1) + 0;
end;

function v3.QuartInOut(p94) -- Line: 157
    local v95 = p94 / 1 * 2;

    if v95 < 1 then
        return 0.5 * math.pow(v95, 4) + 0;
    end;

    return -0.5 * (math.pow(v95 - 2, 4) - 2) + 0;
end;

function v3.QuartOutIn(p96) -- Line: 160
    if p96 < 0.5 then
        return -0.5 * (math.pow(p96 * 2 / 1 - 1, 4) - 1) + 0;
    end;

    return 0.5 * math.pow((p96 * 2 - 1) / 1, 4) + 0.5;
end;

local function inQuint(p97, p98, p99, p100) -- Line: 164
    return p99 * math.pow(p97 / p100, 5) + p98;
end;

local function outQuint(p101, p102, p103, p104) -- Line: 168
    return p103 * (math.pow(p101 / p104 - 1, 5) + 1) + p102;
end;

local function inOutQuint(p105, p106, p107, p108) -- Line: 172
    local v109 = p105 / p108 * 2;

    if v109 < 1 then
        return p107 / 2 * math.pow(v109, 5) + p106;
    end;

    return p107 / 2 * (math.pow(v109 - 2, 5) + 2) + p106;
end;

local function outInQuint(p110, p111, p112, p113) -- Line: 181
    if p110 < p113 / 2 then
        return p112 / 2 * (math.pow(p110 * 2 / p113 - 1, 5) + 1) + p111;
    end;

    return p112 / 2 * math.pow((p110 * 2 - p113) / p113, 5) + (p111 + p112 / 2);
end;

function v3.QuintIn(p114) -- Line: 189
    return 1 * math.pow(p114 / 1, 5) + 0;
end;

function v3.QuintOut(p115) -- Line: 192
    return 1 * (math.pow(p115 / 1 - 1, 5) + 1) + 0;
end;

function v3.QuintInOut(p116) -- Line: 195
    local v117 = p116 / 1 * 2;

    if v117 < 1 then
        return 0.5 * math.pow(v117, 5) + 0;
    end;

    return 0.5 * (math.pow(v117 - 2, 5) + 2) + 0;
end;

function v3.QuintOutIn(p118) -- Line: 198
    if p118 < 0.5 then
        return 0.5 * (math.pow(p118 * 2 / 1 - 1, 5) + 1) + 0;
    end;

    return 0.5 * math.pow((p118 * 2 - 1) / 1, 5) + 0.5;
end;

local function inSextic(p119, p120, p121, p122) -- Line: 202
    return p121 * math.pow(p119 / p122, 6) + p120;
end;

local function outSextic(p123, p124, p125, p126) -- Line: 206
    return -p125 * (math.pow(p123 / p126 - 1, 6) - 1) + p124;
end;

local function inOutSextic(p127, p128, p129, p130) -- Line: 210
    local v131 = p127 / p130 * 2;

    if v131 < 1 then
        return p129 / 2 * math.pow(v131, 6) + p128;
    end;

    return -p129 / 2 * (math.pow(v131 - 2, 6) - 2) + p128;
end;

local function outInSextic(p132, p133, p134, p135) -- Line: 219
    if p132 < p135 / 2 then
        return -(p134 / 2) * (math.pow(p132 * 2 / p135 - 1, 6) - 1) + p133;
    end;

    return p134 / 2 * math.pow((p132 * 2 - p135) / p135, 6) + (p133 + p134 / 2);
end;

function v3.SexticIn(p136) -- Line: 227
    return 1 * math.pow(p136 / 1, 6) + 0;
end;

function v3.SexticOut(p137) -- Line: 230
    return -1 * (math.pow(p137 / 1 - 1, 6) - 1) + 0;
end;

function v3.SexticInOut(p138) -- Line: 233
    local v139 = p138 / 1 * 2;

    if v139 < 1 then
        return 0.5 * math.pow(v139, 6) + 0;
    end;

    return -0.5 * (math.pow(v139 - 2, 6) - 2) + 0;
end;

function v3.SexticOutIn(p140) -- Line: 236
    if p140 < 0.5 then
        return -0.5 * (math.pow(p140 * 2 / 1 - 1, 6) - 1) + 0;
    end;

    return 0.5 * math.pow((p140 * 2 - 1) / 1, 6) + 0.5;
end;

local function inExpo(p141, p142, p143, p144) -- Line: 240
    if p141 == 0 then
        return p142;
    end;

    return p143 * math.pow(2, 10 * (p141 / p144 - 1)) + p142 - p143 * 0.001;
end;

local function outExpo(p145, p146, p147, p148) -- Line: 247
    if p145 == p148 then
        return p146 + p147;
    end;

    return p147 * 1.001 * (-math.pow(2, -10 * p145 / p148) + 1) + p146;
end;

local function inOutExpo(p149, p150, p151, p152) -- Line: 254
    if p149 == 0 then
        return p150;
    end;

    if p149 == p152 then
        return p150 + p151;
    end;

    local v153 = p149 / p152 * 2;

    if v153 < 1 then
        return p151 / 2 * math.pow(2, 10 * (v153 - 1)) + p150 - p151 * 0.0005;
    end;

    return p151 / 2 * 1.0005 * (-math.pow(2, -10 * (v153 - 1)) + 2) + p150;
end;

local function outInExpo(p154, p155, p156, p157) -- Line: 265
    if p154 < p157 / 2 then
        local v158 = p154 * 2;
        local v159 = p156 / 2;

        if v158 == p157 then
            return p155 + v159;
        end;

        return v159 * 1.001 * (-math.pow(2, -10 * v158 / p157) + 1) + p155;
    end;

    local v160 = p154 * 2 - p157;
    local v161 = p155 + p156 / 2;
    local v162 = p156 / 2;

    if v160 == 0 then
        return v161;
    end;

    return v162 * math.pow(2, 10 * (v160 / p157 - 1)) + v161 - v162 * 0.001;
end;

function v3.ExpoIn(p163) -- Line: 273
    return p163 == 0 and 0 or 1 * math.pow(2, 10 * (p163 / 1 - 1)) + 0 - 0.001;
end;

function v3.ExpoOut(p164) -- Line: 276
    return p164 == 1 and 1 or 1.001 * (-math.pow(2, -10 * p164 / 1) + 1) + 0;
end;

function v3.ExpoInOut(p165) -- Line: 279
    if p165 == 0 then
        return 0;
    end;

    if p165 == 1 then
        return 1;
    end;

    local v166 = p165 / 1 * 2;

    if v166 < 1 then
        return 0.5 * math.pow(2, 10 * (v166 - 1)) + 0 - 0.0005;
    end;

    return 0.50025 * (-math.pow(2, -10 * (v166 - 1)) + 2) + 0;
end;

function v3.ExpoOutIn(p167) -- Line: 282
    if p167 < 0.5 then
        local v168 = p167 * 2;

        return v168 == 1 and 0.5 or 0.5005 * (-math.pow(2, -10 * v168 / 1) + 1) + 0;
    end;

    local v169 = p167 * 2 - 1;

    return v169 == 0 and 0.5 or 0.5 * math.pow(2, 10 * (v169 / 1 - 1)) + 0.5 - 0.0005;
end;

local function inCirc(p170, p171, p172, p173) -- Line: 286
    local v174 = 1 - math.pow(p170 / p173, 2);

    return -p172 * (math.sqrt(v174) - 1) + p171;
end;

local function outCirc(p175, p176, p177, p178) -- Line: 290
    local v179 = 1 - math.pow(p175 / p178 - 1, 2);

    return p177 * math.sqrt(v179) + p176;
end;

local function inOutCirc(p180, p181, p182, p183) -- Line: 294
    local v184 = p180 / p183 * 2;

    if v184 < 1 then
        return -p182 / 2 * (math.sqrt(1 - v184 * v184) - 1) + p181;
    end;

    local v185 = v184 - 2;

    return p182 / 2 * (math.sqrt(1 - v185 * v185) + 1) + p181;
end;

local function outInCirc(p186, p187, p188, p189) -- Line: 303
    if p186 < p189 / 2 then
        local v190 = 1 - math.pow(p186 * 2 / p189 - 1, 2);

        return p188 / 2 * math.sqrt(v190) + p187;
    end;

    local v191 = 1 - math.pow((p186 * 2 - p189) / p189, 2);

    return -(p188 / 2) * (math.sqrt(v191) - 1) + (p187 + p188 / 2);
end;

function v3.CircIn(p192) -- Line: 311
    local v193 = 1 - math.pow(p192 / 1, 2);

    return -1 * (math.sqrt(v193) - 1) + 0;
end;

function v3.CircOut(p194) -- Line: 314
    local v195 = 1 - math.pow(p194 / 1 - 1, 2);

    return 1 * math.sqrt(v195) + 0;
end;

function v3.CircInOut(p196) -- Line: 317
    local v197 = p196 / 1 * 2;

    if v197 < 1 then
        return -0.5 * (math.sqrt(1 - v197 * v197) - 1) + 0;
    end;

    local v198 = v197 - 2;

    return 0.5 * (math.sqrt(1 - v198 * v198) + 1) + 0;
end;

function v3.CircOutIn(p199) -- Line: 320
    if p199 < 0.5 then
        local v200 = 1 - math.pow(p199 * 2 / 1 - 1, 2);

        return 0.5 * math.sqrt(v200) + 0;
    end;

    local v201 = 1 - math.pow((p199 * 2 - 1) / 1, 2);

    return -0.5 * (math.sqrt(v201) - 1) + 0.5;
end;

local function inBack(p202, p203, p204, p205, p206) -- Line: 324
    local v207 = p206 or 1.70158;
    local v208 = p202 / p205;

    return p204 * v208 * v208 * ((v207 + 1) * v208 - v207) + p203;
end;

local function outBack(p209, p210, p211, p212, p213) -- Line: 329
    local v214 = p213 or 1.70158;
    local v215 = p209 / p212 - 1;

    return p211 * (v215 * v215 * ((v214 + 1) * v215 + v214) + 1) + p210;
end;

local function inOutBack(p216, p217, p218, p219, p220) -- Line: 334
    local v221 = (p220 or 1.70158) * 1.525;
    local v222 = p216 / p219 * 2;

    if v222 < 1 then
        return p218 / 2 * (v222 * v222 * ((v221 + 1) * v222 - v221)) + p217;
    end;

    local v223 = v222 - 2;

    return p218 / 2 * (v223 * v223 * ((v221 + 1) * v223 + v221) + 2) + p217;
end;

local function outInBack(p224, p225, p226, p227, p228) -- Line: 345
    if p224 < p227 / 2 then
        local v229 = p228 or 1.70158;
        local v230 = p224 * 2 / p227 - 1;

        return p226 / 2 * (v230 * v230 * ((v229 + 1) * v230 + v229) + 1) + p225;
    end;

    local v231 = p228 or 1.70158;
    local v232 = (p224 * 2 - p227) / p227;

    return p226 / 2 * v232 * v232 * ((v231 + 1) * v232 - v231) + (p225 + p226 / 2);
end;

function v3.BackIn(p233, p234) -- Line: 353
    local v235 = p234 or 1.70158;
    local v236 = p233 / 1;

    return 1 * v236 * v236 * ((v235 + 1) * v236 - v235) + 0;
end;

function v3.BackOut(p237, p238) -- Line: 356
    local v239 = p238 or 1.70158;
    local v240 = p237 / 1 - 1;

    return 1 * (v240 * v240 * ((v239 + 1) * v240 + v239) + 1) + 0;
end;

function v3.BackInOut(p241, p242) -- Line: 359
    local v243 = (p242 or 1.70158) * 1.525;
    local v244 = p241 / 1 * 2;

    if v244 < 1 then
        return 0.5 * (v244 * v244 * ((v243 + 1) * v244 - v243)) + 0;
    end;

    local v245 = v244 - 2;

    return 0.5 * (v245 * v245 * ((v243 + 1) * v245 + v243) + 2) + 0;
end;

function v3.BackOutIn(p246, p247) -- Line: 362
    if p246 < 0.5 then
        local v248 = p247 or 1.70158;
        local v249 = p246 * 2 / 1 - 1;

        return 0.5 * (v249 * v249 * ((v248 + 1) * v249 + v248) + 1) + 0;
    end;

    local v250 = p247 or 1.70158;
    local v251 = (p246 * 2 - 1) / 1;

    return 0.5 * v251 * v251 * ((v250 + 1) * v251 - v250) + 0.5;
end;

local function outBounce(p252, p253, p254, p255) -- Line: 366
    local v256 = p252 / p255;

    if v256 < 0.36363636363636365 then
        return p254 * (7.5625 * v256 * v256) + p253;
    end;

    if v256 < 0.7272727272727273 then
        local v257 = v256 - 0.5454545454545454;

        return p254 * (7.5625 * v257 * v257 + 0.75) + p253;
    end;

    if v256 < 0.9090909090909091 then
        local v258 = v256 - 0.8181818181818182;

        return p254 * (7.5625 * v258 * v258 + 0.9375) + p253;
    end;

    local v259 = v256 - 0.9545454545454546;

    return p254 * (7.5625 * v259 * v259 + 0.984375) + p253;
end;

local function inBounce(p260, p261, p262, p263) -- Line: 381
    -- upvalues: outBounce (copy)
    return p262 - outBounce(p263 - p260, 0, p262, p263) + p261;
end;

local function inOutBounce(p264, p265, p266, p267) -- Line: 384
    -- upvalues: outBounce (copy)
    if p264 < p267 / 2 then
        return (p266 - outBounce(p267 - p264 * 2, 0, p266, p267) + 0) * 0.5 + p265;
    end;

    return outBounce(p264 * 2 - p267, 0, p266, p267) * 0.5 + p266 * 0.5 + p265;
end;

local function outInBounce(p268, p269, p270, p271) -- Line: 391
    -- upvalues: outBounce (copy)
    if p268 < p271 / 2 then
        return outBounce(p268 * 2, p269, p270 / 2, p271);
    end;

    local v272 = p270 / 2;

    return v272 - outBounce(p271 - (p268 * 2 - p271), 0, v272, p271) + (p269 + p270 / 2);
end;

function v3.BounceIn(p273) -- Line: 399
    -- upvalues: outBounce (copy)
    return 1 - outBounce(1 - p273, 0, 1, 1) + 0;
end;

function v3.BounceOut(p274) -- Line: 402
    -- upvalues: outBounce (copy)
    return outBounce(p274, 0, 1, 1);
end;

function v3.BounceInOut(p275) -- Line: 405
    -- upvalues: outBounce (copy)
    if p275 < 0.5 then
        return (1 - outBounce(1 - p275 * 2, 0, 1, 1) + 0) * 0.5 + 0;
    end;

    return outBounce(p275 * 2 - 1, 0, 1, 1) * 0.5 + 0.5 + 0;
end;

function v3.BounceOutIn(p276) -- Line: 408
    -- upvalues: outBounce (copy)
    if p276 < 0.5 then
        return outBounce(p276 * 2, 0, 0.5, 1);
    end;

    return 0.5 - outBounce(1 - (p276 * 2 - 1), 0, 0.5, 1) + 0.5;
end;

local function elastic_blend(p277, p278, p279, p280, p281, p282) -- Line: 412
    if p278 ~= 0 then
        local v283 = math.abs(p281);
        p282 = p280 == 0 and 0 or p282 * (p280 / math.abs(p278));

        if math.abs(p277 * p279) < v283 then
            local v284 = math.abs(p277 * p279) / v283;
            p282 = p282 * v284 + (1 - v284);
        end;
    end;

    return p282;
end;

local function inElastic(p285, p286, p287, p288, p289, p290) -- Line: 427
    local v291 = 1;

    if p285 == 0 then
        return p286;
    end;

    local v292 = p285 / p288;

    if v292 == 1 then
        return p286 + p287;
    end;

    local v293 = v292 - 1;

    if not p290 or p290 == 0 then
        p290 = p288 * 0.3;
    end;

    local v294;

    if p289 and p289 >= math.abs(p287) then
        v294 = p290 / 6.283185307179586 * math.asin(p287 / p289);
        p287 = p289;
    else
        v294 = p290 / 4;
        local v295 = p289 or 0;

        if p287 ~= 0 then
            local v296 = math.abs(v294);
            v291 = v295 == 0 and 0 or v291 * (v295 / math.abs(p287));

            if math.abs(v293 * p288) < v296 then
                local v297 = math.abs(v293 * p288) / v296;
                v291 = v291 * v297 + (1 - v297);
            end;
        end;
    end;

    return -v291 * (p287 * math.pow(2, 10 * v293) * math.sin((v293 * p288 - v294) * 6.283185307179586 / p290)) + p286;
end;

local function outElastic(p298, p299, p300, p301, p302, p303) -- Line: 447
    local v304 = 1;

    if p298 == 0 then
        return p299;
    end;

    local v305 = p298 / p301;

    if v305 == 1 then
        return p299 + p300;
    end;

    local v306 = -v305;

    if not p303 or p303 == 0 then
        p303 = p301 * 0.3;
    end;

    local v307;

    if p302 and p302 >= math.abs(p300) then
        v307 = p303 / 6.283185307179586 * math.asin(p300 / p302);
    else
        v307 = p303 / 4;
        local v308 = p302 or 0;

        if p300 ~= 0 then
            local v309 = math.abs(v307);
            v304 = v308 == 0 and 0 or v304 * (v308 / math.abs(p300));

            if math.abs(v306 * p301) < v309 then
                local v310 = math.abs(v306 * p301) / v309;
                v304 = v304 * v310 + (1 - v310);
            end;
        end;

        p302 = p300;
    end;

    return v304 * (p302 * math.pow(2, 10 * v306) * math.sin((v306 * p301 - v307) * 6.283185307179586 / p303)) + p300 + p299;
end;

local function inOutElastic(p311, p312, p313, p314, p315, p316) -- Line: 466
    local v317 = 1;

    if p311 == 0 then
        return p312;
    end;

    local v318 = p311 / (p314 / 2);

    if v318 == 2 then
        return p312 + p313;
    end;

    local v319 = v318 - 1;

    if not p316 or p316 == 0 then
        p316 = p314 * 0.44999999999999996;
    end;

    local v320;

    if p315 and p315 >= math.abs(p313) then
        v320 = p316 / 6.283185307179586 * math.asin(p313 / p315);
    else
        v320 = p316 / 4;
        local v321 = p315 or 0;

        if p313 ~= 0 then
            local v322 = math.abs(v320);
            v317 = v321 == 0 and 0 or v317 * (v321 / math.abs(p313));

            if math.abs(v319 * p314) < v322 then
                local v323 = math.abs(v319 * p314) / v322;
                v317 = v317 * v323 + (1 - v323);
            end;
        end;

        p315 = p313;
    end;

    if v319 < 0 then
        return v317 * -0.5 * (p315 * math.pow(2, 10 * v319) * math.sin((v319 * p314 - v320) * 6.283185307179586 / p316)) + p312;
    end;

    local v324 = -v319;

    return v317 * 0.5 * (p315 * math.pow(2, 10 * v324) * math.sin((v324 * p314 - v320) * 6.283185307179586 / p316)) + p313 + p312;
end;

local function outInElastic(p325, p326, p327, p328, p329, p330) -- Line: 492
    -- upvalues: outElastic (copy), inElastic (copy)
    if p325 < p328 / 2 then
        return outElastic(p325 * 2, p326, p327 / 2, p328, p329, p330);
    end;

    return inElastic(p325 * 2 - p328, p326 + p327 / 2, p327 / 2, p328, p329, p330);
end;

function v3.ElasticIn(p331, p332, p333) -- Line: 500
    -- upvalues: inElastic (copy)
    return inElastic(p331, 0, 1, 1, p332, p333 or 0.3);
end;

function v3.ElasticOut(p334, p335, p336) -- Line: 504
    -- upvalues: outElastic (copy)
    return outElastic(p334, 0, 1, 1, p335, p336 or 0.3);
end;

function v3.ElasticInOut(p337, p338, p339) -- Line: 508
    -- upvalues: inOutElastic (copy)
    return inOutElastic(p337, 0, 1, 1, p338, p339 or 0.3);
end;

function v3.ElasticOutIn(p340, p341, p342) -- Line: 512
    -- upvalues: outElastic (copy), inElastic (copy)
    local v343 = p342 or 0.3;

    if p340 < 0.5 then
        return outElastic(p340 * 2, 0, 0.5, 1, p341, v343);
    end;

    return inElastic(p340 * 2 - 1, 0.5, 0.5, 1, p341, v343);
end;

return v3;