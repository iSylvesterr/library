-- Decompiled with Potassium's decompiler.

local pow = math.pow;
local sin = math.sin;
local cos = math.cos;
local sqrt = math.sqrt;
local abs = math.abs;
local asin = math.asin;

local function InElastic(p1, p2, p3, p4, p5, p6) -- Line: 274
    -- upvalues: abs (copy), asin (copy), pow (copy), sin (copy)
    if p1 == 0 then
        return p2;
    end;

    local v7 = p1 / p4;

    if v7 == 1 then
        return p2 + p3;
    end;

    local v8 = p6 or p4 * 0.3;
    local v9;

    if p5 and p5 >= abs(p3) then
        v9 = v8 / 6.283185307179586 * asin(p3 / p5);
    else
        v9 = v8 / 4;
        p5 = p3;
    end;

    local v10 = v7 - 1;

    return -(p5 * pow(2, v10 * 10) * sin((v10 * p4 - v9) * 6.283185307179586 / v8)) + p2;
end;

local function OutElastic(p11, p12, p13, p14, p15, p16) -- Line: 296
    -- upvalues: abs (copy), asin (copy), pow (copy), sin (copy)
    if p11 == 0 then
        return p12;
    end;

    local v17 = p11 / p14;

    if v17 == 1 then
        return p12 + p13;
    end;

    local v18 = p16 or p14 * 0.3;
    local v19;

    if p15 and p15 >= abs(p13) then
        v19 = v18 / 6.283185307179586 * asin(p13 / p15);
    else
        v19 = v18 / 4;
        p15 = p13;
    end;

    return p15 * pow(2, v17 * -10) * sin((v17 * p14 - v19) * 6.283185307179586 / v18) + p13 + p12;
end;

local function OutBounce(p20, p21, p22, p23) -- Line: 383
    local v24 = p20 / p23;

    if v24 < 0.36363636363636 then
        return p22 * (v24 * 7.5625 * v24) + p21;
    end;

    if v24 < 0.72727272727273 then
        local v25 = v24 - 0.54545454545455;

        return p22 * (v25 * 7.5625 * v25 + 0.75) + p21;
    end;

    if v24 < 0.90909090909091 then
        local v26 = v24 - 0.81818181818182;

        return p22 * (v26 * 7.5625 * v26 + 0.9375) + p21;
    end;

    local v27 = v24 - 0.95454545454545;

    return p22 * (v27 * 7.5625 * v27 + 0.984375) + p21;
end;

return {
    Linear = function(p28, p29, p30, p31) -- Line: 81, Name: Linear
        return p28 / p31;
    end,

    InQuad = function(p32, p33, p34, p35) -- Line: 85, Name: InQuad
        -- upvalues: pow (copy)
        return p34 * pow(p32 / p35, 2) + p33;
    end,

    OutQuad = function(p36, p37, p38, p39) -- Line: 89, Name: OutQuad
        local v40 = p36 / p39;

        return -p38 * v40 * (v40 - 2) + p37;
    end,

    InOutQuad = function(p41, p42, p43, p44) -- Line: 94, Name: InOutQuad
        -- upvalues: pow (copy)
        local v45 = p41 / p44 * 2;

        if v45 < 1 then
            return p43 / 2 * pow(v45, 2) + p42;
        end;

        return -p43 / 2 * ((v45 - 1) * (v45 - 3) - 1) + p42;
    end,

    OutInQuad = function(p46, p47, p48, p49) -- Line: 103, Name: OutInQuad
        -- upvalues: pow (copy)
        if p46 >= p49 / 2 then
            return p48 / 2 * pow((p46 * 2 - p49) / p49, 2) + (p47 + p48 / 2);
        end;

        local v50 = p46 * 2 / p49;

        return -(p48 / 2) * v50 * (v50 - 2) + p47;
    end,

    InCubic = function(p51, p52, p53, p54) -- Line: 111, Name: InCubic
        -- upvalues: pow (copy)
        return p53 * pow(p51 / p54, 3) + p52;
    end,

    OutCubic = function(p55, p56, p57, p58) -- Line: 115, Name: OutCubic
        -- upvalues: pow (copy)
        return p57 * (pow(p55 / p58 - 1, 3) + 1) + p56;
    end,

    InOutCubic = function(p59, p60, p61, p62) -- Line: 119, Name: InOutCubic
        local v63 = p59 / p62 * 2;

        if v63 < 1 then
            return p61 / 2 * v63 * v63 * v63 + p60;
        end;

        local v64 = v63 - 2;

        return p61 / 2 * (v64 * v64 * v64 + 2) + p60;
    end,

    OutInCubic = function(p65, p66, p67, p68) -- Line: 129, Name: OutInCubic
        -- upvalues: pow (copy)
        if p65 < p68 / 2 then
            return p67 / 2 * (pow(p65 * 2 / p68 - 1, 3) + 1) + p66;
        end;

        return p67 / 2 * pow((p65 * 2 - p68) / p68, 3) + (p66 + p67 / 2);
    end,

    InQuart = function(p69, p70, p71, p72) -- Line: 137, Name: InQuart
        -- upvalues: pow (copy)
        return p71 * pow(p69 / p72, 4) + p70;
    end,

    OutQuart = function(p73, p74, p75, p76) -- Line: 141, Name: OutQuart
        -- upvalues: pow (copy)
        return -p75 * (pow(p73 / p76 - 1, 4) - 1) + p74;
    end,

    InOutQuart = function(p77, p78, p79, p80) -- Line: 145, Name: InOutQuart
        -- upvalues: pow (copy)
        local v81 = p77 / p80 * 2;

        if v81 < 1 then
            return p79 / 2 * pow(v81, 4) + p78;
        end;

        return -p79 / 2 * (pow(v81 - 2, 4) - 2) + p78;
    end,

    OutInQuart = function(p82, p83, p84, p85) -- Line: 155, Name: OutInQuart
        -- upvalues: pow (copy)
        if p82 < p85 / 2 then
            return -(p84 / 2) * (pow(p82 * 2 / p85 - 1, 4) - 1) + p83;
        end;

        return p84 / 2 * pow((p82 * 2 - p85) / p85, 4) + (p83 + p84 / 2);
    end,

    InQuint = function(p86, p87, p88, p89) -- Line: 163, Name: InQuint
        -- upvalues: pow (copy)
        return p88 * pow(p86 / p89, 5) + p87;
    end,

    OutQuint = function(p90, p91, p92, p93) -- Line: 167, Name: OutQuint
        -- upvalues: pow (copy)
        return p92 * (pow(p90 / p93 - 1, 5) + 1) + p91;
    end,

    InOutQuint = function(p94, p95, p96, p97) -- Line: 171, Name: InOutQuint
        -- upvalues: pow (copy)
        local v98 = p94 / p97 * 2;

        if v98 < 1 then
            return p96 / 2 * pow(v98, 5) + p95;
        end;

        return p96 / 2 * (pow(v98 - 2, 5) + 2) + p95;
    end,

    OutInQuint = function(p99, p100, p101, p102) -- Line: 180, Name: OutInQuint
        -- upvalues: pow (copy)
        if p99 < p102 / 2 then
            return p101 / 2 * (pow(p99 * 2 / p102 - 1, 5) + 1) + p100;
        end;

        return p101 / 2 * pow((p99 * 2 - p102) / p102, 5) + (p100 + p101 / 2);
    end,

    InSine = function(p103, p104, p105, p106) -- Line: 188, Name: InSine
        -- upvalues: cos (copy)
        return -p105 * cos(p103 / p106 * 1.5707963267948966) + p105 + p104;
    end,

    OutSine = function(p107, p108, p109, p110) -- Line: 192, Name: OutSine
        -- upvalues: sin (copy)
        return p109 * sin(p107 / p110 * 1.5707963267948966) + p108;
    end,

    InOutSine = function(p111, p112, p113, p114) -- Line: 196, Name: InOutSine
        -- upvalues: cos (copy)
        return -p113 / 2 * (cos(3.141592653589793 * p111 / p114) - 1) + p112;
    end,

    OutInSine = function(p115, p116, p117, p118) -- Line: 200, Name: OutInSine
        -- upvalues: sin (copy), cos (copy)
        if p115 < p118 / 2 then
            return p117 / 2 * sin(p115 * 2 / p118 * 1.5707963267948966) + p116;
        end;

        local v119 = p117 / 2;

        return -v119 * cos((p115 * 2 - p118) / p118 * 1.5707963267948966) + v119 + (p116 + p117 / 2);
    end,

    InExponential = function(p120, p121, p122, p123) -- Line: 208, Name: InExpo
        -- upvalues: pow (copy)
        if p120 == 0 then
            return p121;
        end;

        return p122 * pow(2, (p120 / p123 - 1) * 10) + p121 - p122 * 0.001;
    end,

    OutExponential = function(p124, p125, p126, p127) -- Line: 216, Name: OutExpo
        -- upvalues: pow (copy)
        if p124 == p127 then
            return p125 + p126;
        end;

        return p126 * 1.001 * (-pow(2, p124 * -10 / p127) + 1) + p125;
    end,

    InOutExponential = function(p128, p129, p130, p131) -- Line: 224, Name: InOutExpo
        -- upvalues: pow (copy)
        if p128 == 0 then
            return p129;
        end;

        if p128 == p131 then
            return p129 + p130;
        end;

        local v132 = p128 / p131 * 2;

        if v132 < 1 then
            return p130 / 2 * pow(2, (v132 - 1) * 10) + p129 - p130 * 0.0005;
        end;

        return p130 / 2 * 1.0005 * (-pow(2, (v132 - 1) * -10) + 2) + p129;
    end,

    OutInExponential = function(p133, p134, p135, p136) -- Line: 240, Name: OutInExpo
        -- upvalues: pow (copy)
        if p133 < p136 / 2 then
            local v137 = p133 * 2;
            local v138 = p135 / 2;

            if v137 == p136 then
                return p134 + v138;
            end;

            return v138 * 1.001 * (-pow(2, v137 * -10 / p136) + 1) + p134;
        end;

        local v139 = p133 * 2 - p136;
        local v140 = p134 + p135 / 2;
        local v141 = p135 / 2;

        if v139 == 0 then
            return v140;
        end;

        return v141 * pow(2, (v139 / p136 - 1) * 10) + v140 - v141 * 0.001;
    end,

    InCircular = function(p142, p143, p144, p145) -- Line: 248, Name: InCirc
        -- upvalues: pow (copy), sqrt (copy)
        return -p144 * (sqrt(1 - pow(p142 / p145, 2)) - 1) + p143;
    end,

    OutCircular = function(p146, p147, p148, p149) -- Line: 252, Name: OutCirc
        -- upvalues: pow (copy), sqrt (copy)
        return p148 * sqrt(1 - pow(p146 / p149 - 1, 2)) + p147;
    end,

    InOutCircular = function(p150, p151, p152, p153) -- Line: 256, Name: InOutCirc
        -- upvalues: sqrt (copy)
        local v154 = p150 / p153 * 2;

        if v154 < 1 then
            return -p152 / 2 * (sqrt(1 - v154 * v154) - 1) + p151;
        end;

        local v155 = v154 - 2;

        return p152 / 2 * (sqrt(1 - v155 * v155) + 1) + p151;
    end,

    OutInCircular = function(p156, p157, p158, p159) -- Line: 266, Name: OutInCirc
        -- upvalues: pow (copy), sqrt (copy)
        if p156 < p159 / 2 then
            return p158 / 2 * sqrt(1 - pow(p156 * 2 / p159 - 1, 2)) + p157;
        end;

        return -(p158 / 2) * (sqrt(1 - pow((p156 * 2 - p159) / p159, 2)) - 1) + (p157 + p158 / 2);
    end,

    InElastic = InElastic,
    OutElastic = OutElastic,

    InOutElastic = function(p160, p161, p162, p163, p164, p165) -- Line: 317, Name: InOutElastic
        -- upvalues: abs (copy), asin (copy), pow (copy), sin (copy)
        if p160 == 0 then
            return p161;
        end;

        local v166 = p160 / p163 * 2;

        if v166 == 2 then
            return p161 + p162;
        end;

        local v167 = p165 or p163 * 0.44999999999999996;
        local v168 = p164 or 0;
        local v169;

        if v168 and v168 >= abs(p162) then
            v169 = v167 / 6.283185307179586 * asin(p162 / v168);
        else
            v169 = v167 / 4;
            v168 = p162;
        end;

        if v166 < 1 then
            local v170 = v166 - 1;

            return v168 * pow(2, v170 * 10) * sin((v170 * p163 - v169) * 6.283185307179586 / v167) * -0.5 + p161;
        end;

        local v171 = v166 - 1;

        return v168 * pow(2, v171 * -10) * sin((v171 * p163 - v169) * 6.283185307179586 / v167) * 0.5 + p162 + p161;
    end,

    OutInElastic = function(p172, p173, p174, p175, p176, p177) -- Line: 347, Name: OutInElastic
        -- upvalues: OutElastic (copy), InElastic (copy)
        if p172 < p175 / 2 then
            return OutElastic(p172 * 2, p173, p174 / 2, p175, p176, p177);
        end;

        return InElastic(p172 * 2 - p175, p173 + p174 / 2, p174 / 2, p175, p176, p177);
    end,

    InBack = function(p178, p179, p180, p181) -- Line: 355, Name: InBack
        local v182 = p178 / p181;

        return p180 * v182 * v182 * (v182 * 2.70158 - 1.70158) + p179;
    end,

    OutBack = function(p183, p184, p185, p186) -- Line: 360, Name: OutBack
        local v187 = p183 / p186 - 1;

        return p185 * (v187 * v187 * (v187 * 2.70158 + 1.70158) + 1) + p184;
    end,

    InOutBack = function(p188, p189, p190, p191) -- Line: 365, Name: InOutBack
        local v192 = p188 / p191 * 2;

        if v192 < 1 then
            return p190 / 2 * (v192 * v192 * (v192 * 2.70158 - 1.70158)) + p189;
        end;

        local v193 = v192 - 2;

        return p190 / 2 * (v193 * v193 * (v193 * 2.70158 + 1.70158) + 2) + p189;
    end,

    OutInBack = function(p194, p195, p196, p197) -- Line: 375, Name: OutInBack
        if p194 < p197 / 2 then
            local v198 = p194 * 2 / p197 - 1;

            return p196 / 2 * (v198 * v198 * (v198 * 2.70158 + 1.70158) + 1) + p195;
        end;

        local v199 = (p194 * 2 - p197) / p197;

        return p196 / 2 * v199 * v199 * (v199 * 2.70158 - 1.70158) + (p195 + p196 / 2);
    end,

    InBounce = function(p200, p201, p202, p203) -- Line: 399, Name: InBounce
        -- upvalues: OutBounce (copy)
        return p202 - OutBounce(p203 - p200, 0, p202, p203) + p201;
    end,

    OutBounce = OutBounce,

    InOutBounce = function(p204, p205, p206, p207) -- Line: 403, Name: InOutBounce
        -- upvalues: OutBounce (copy)
        if p204 < p207 / 2 then
            return (p206 - OutBounce(p207 - p204 * 2, 0, p206, p207) + 0) * 0.5 + p205;
        end;

        return OutBounce(p204 * 2 - p207, 0, p206, p207) * 0.5 + p206 * 0.5 + p205;
    end,

    OutInBounce = function(p208, p209, p210, p211) -- Line: 411, Name: OutInBounce
        -- upvalues: OutBounce (copy)
        if p208 < p211 / 2 then
            return OutBounce(p208 * 2, p209, p210 / 2, p211);
        end;

        local v212 = p210 / 2;

        return v212 - OutBounce(p211 - (p208 * 2 - p211), 0, v212, p211) + (p209 + p210 / 2);
    end
};