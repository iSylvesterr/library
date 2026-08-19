-- Decompiled with Potassium's decompiler.

local sin = math.sin;
local cos = math.cos;
local abs = math.abs;
local asin = math.asin;

local function outBounce(p1, p2, p3, p4) -- Line: 43
    local v5 = p1 / p4;

    if v5 < 0.36363636363636365 then
        return p3 * (7.5625 * v5 * v5) + p2;
    end;

    if v5 < 0.7272727272727273 then
        local v6 = v5 - 0.5454545454545454;

        return p3 * (7.5625 * v6 * v6 + 0.75) + p2;
    end;

    if v5 < 0.9090909090909091 then
        local v7 = v5 - 0.8181818181818182;

        return p3 * (7.5625 * v7 * v7 + 0.9375) + p2;
    end;

    local v8 = v5 - 0.9545454545454546;

    return p3 * (7.5625 * v8 * v8 + 0.984375) + p2;
end;

local u175 = {
    [Enum.EasingStyle.Sine] = {
        [Enum.EasingDirection.In] = function(p9, p10, p11, p12) -- Line: 66
            -- upvalues: cos (copy)
            return -p11 * cos(p9 / p12 * 1.5707963267948966) + p11 + p10;
        end,

        [Enum.EasingDirection.InOut] = function(p13, p14, p15, p16) -- Line: 69
            -- upvalues: cos (copy)
            return -p15 * 0.5 * (cos(3.141592653589793 * p13 / p16) - 1) + p14;
        end,

        [Enum.EasingDirection.Out] = function(p17, p18, p19, p20) -- Line: 72
            -- upvalues: sin (copy)
            return p19 * sin(p17 / p20 * 1.5707963267948966) + p18;
        end
    },
    [Enum.EasingStyle.Quint] = {
        [Enum.EasingDirection.In] = function(p21, p22, p23, p24) -- Line: 77
            local v25 = p21 / p24;

            return p23 * v25 * v25 * v25 * v25 * v25 + p22;
        end,

        [Enum.EasingDirection.InOut] = function(p26, p27, p28, p29) -- Line: 81
            local v30 = p26 / p29 * 2;

            if v30 < 1 then
                return p28 * 0.5 * v30 * v30 * v30 * v30 * v30 + p27;
            end;

            local v31 = v30 - 2;

            return p28 * 0.5 * (v31 * v31 * v31 * v31 * v31 + 2) + p27;
        end,

        [Enum.EasingDirection.Out] = function(p32, p33, p34, p35) -- Line: 90
            local v36 = p32 / p35 - 1;

            return p34 * (v36 * v36 * v36 * v36 * v36 + 1) + p33;
        end
    },
    [Enum.EasingStyle.Quart] = {
        [Enum.EasingDirection.In] = function(p37, p38, p39, p40) -- Line: 96
            local v41 = p37 / p40;

            return p39 * v41 * v41 * v41 * v41 + p38;
        end,

        [Enum.EasingDirection.InOut] = function(p42, p43, p44, p45) -- Line: 100
            local v46 = p42 / p45 * 2;

            if v46 < 1 then
                return p44 * 0.5 * v46 * v46 * v46 * v46 + p43;
            end;

            local v47 = v46 - 2;

            return -p44 * 0.5 * (v47 * v47 * v47 * v47 - 2) + p43;
        end,

        [Enum.EasingDirection.Out] = function(p48, p49, p50, p51) -- Line: 109
            local v52 = p48 / p51 - 1;

            return -p50 * (v52 * v52 * v52 * v52 - 1) + p49;
        end
    },
    [Enum.EasingStyle.Quad] = {
        [Enum.EasingDirection.In] = function(p53, p54, p55, p56) -- Line: 115
            local v57 = p53 / p56;

            return p55 * v57 * v57 + p54;
        end,

        [Enum.EasingDirection.InOut] = function(p58, p59, p60, p61) -- Line: 119
            local v62 = p58 / p61 * 2;

            return v62 < 1 and p60 * 0.5 * v62 * v62 + p59 or -p60 * 0.5 * ((v62 - 1) * (v62 - 3) - 1) + p59;
        end,

        [Enum.EasingDirection.Out] = function(p63, p64, p65, p66) -- Line: 123
            local v67 = p63 / p66;

            return -p65 * v67 * (v67 - 2) + p64;
        end
    },
    [Enum.EasingStyle.Linear] = {
        [Enum.EasingDirection.In] = function(p68, p69, p70, p71) -- Line: 129
            return p70 * p68 / p71 + p69;
        end,

        [Enum.EasingDirection.InOut] = function(p72, p73, p74, p75) -- Line: 132
            return p74 * p72 / p75 + p73;
        end,

        [Enum.EasingDirection.Out] = function(p76, p77, p78, p79) -- Line: 135
            return p78 * p76 / p79 + p77;
        end
    },
    [Enum.EasingStyle.Exponential] = {
        [Enum.EasingDirection.In] = function(p80, p81, p82, p83) -- Line: 140
            return p80 == 0 and p81 and p81 or p82 * 2 ^ (10 * (p80 / p83 - 1)) + p81 - p82 * 0.001;
        end,

        [Enum.EasingDirection.InOut] = function(p84, p85, p86, p87) -- Line: 143
            local v88 = p84 / p87 * 2;

            if v88 == 0 then
                return p85;
            end;

            if v88 == p87 then
                return p85 + p86;
            end;

            local v89 = v88 / p87 * 2;

            if v89 < 1 then
                return p86 / 2 * math.pow(2, 10 * (v89 - 1)) + p85 - p86 * 0.0005;
            end;

            return p86 / 2 * 1.0005 * (-math.pow(2, -10 * (v89 - 1)) + 2) + p85;
        end,

        [Enum.EasingDirection.Out] = function(p90, p91, p92, p93) -- Line: 159
            return p90 == p93 and p91 + p92 or p92 * 1.001 * (1 - 2 ^ (-10 * p90 / p93)) + p91;
        end
    },
    [Enum.EasingStyle.Elastic] = {
        [Enum.EasingDirection.In] = function(p94, p95, p96, p97) -- Line: 164
            -- upvalues: abs (copy), asin (copy), sin (copy)
            if p94 == 0 then
                return p95;
            end;

            local v98 = p94 / p97;

            if v98 == 1 then
                return p95 + p96;
            end;

            local v99 = 1 or p97 * 0.3;
            local v100 = 1;
            local v101;

            if v100 and v100 >= abs(p96) then
                v101 = v99 / 6.283185307179586 * asin(p96 / v100);
            else
                v101 = v99 / 4;
                v100 = p96;
            end;

            local v102 = v98 - 1;

            return -(v100 * math.pow(2, 10 * v102) * sin((v102 * p97 - v101) * 6.283185307179586 / v99)) + p95;
        end,

        [Enum.EasingDirection.InOut] = function(p103, p104, p105, p106) -- Line: 194
            -- upvalues: abs (copy), asin (copy), sin (copy)
            if p103 == 0 then
                return p104;
            end;

            local v107 = p103 / p106 * 2 - 1;

            if v107 == 1 then
                return p104 + p105;
            end;

            local v108 = 1;
            local v109 = p106 * 0.3;
            local v110;

            if v108 and v108 >= abs(p105) then
                v110 = v109 / 6.283185307179586 * asin(p105 / v108);
            else
                v110 = v109 * 0.25;
                v108 = p105;
            end;

            if v107 < 1 then
                return v108 * -0.5 * 2 ^ (10 * v107) * sin((v107 * p106 - v110) * 6.283185307179586 / v109) + p104;
            end;

            return v108 * 2 ^ (-10 * v107) * sin((v107 * p106 - v110) * 6.283185307179586 / v109) * 0.5 + p105 + p104;
        end,

        [Enum.EasingDirection.Out] = function(p111, p112, p113, p114) -- Line: 223
            -- upvalues: abs (copy), asin (copy), sin (copy)
            if p111 == 0 then
                return p112;
            end;

            local v115 = p111 / p114;

            if v115 == 1 then
                return p112 + p113;
            end;

            local v116 = 1;
            local v117 = 1 or p114 * 0.3;
            local v118;

            if v116 and v116 >= abs(p113) then
                v118 = v117 / 6.283185307179586 * asin(p113 / v116);
            else
                v118 = v117 / 4;
                v116 = p113;
            end;

            return v116 * math.pow(2, -10 * v115) * sin((v115 * p114 - v118) * 6.283185307179586 / v117) + p113 + p112;
        end
    },
    [Enum.EasingStyle.Cubic] = {
        [Enum.EasingDirection.In] = function(p119, p120, p121, p122) -- Line: 254
            local v123 = p119 / p122;

            return p121 * v123 * v123 * v123 + p120;
        end,

        [Enum.EasingDirection.InOut] = function(p124, p125, p126, p127) -- Line: 258
            local v128 = p124 / p127 * 2;

            if v128 < 1 then
                return p126 * 0.5 * v128 * v128 * v128 + p125;
            end;

            local v129 = v128 - 2;

            return p126 * 0.5 * (v129 * v129 * v129 + 2) + p125;
        end,

        [Enum.EasingDirection.Out] = function(p130, p131, p132, p133) -- Line: 267
            local v134 = p130 / p133 - 1;

            return p132 * (v134 * v134 * v134 + 1) + p131;
        end
    },
    [Enum.EasingStyle.Circular] = {
        [Enum.EasingDirection.In] = function(p135, p136, p137, p138) -- Line: 273
            local v139 = p135 / p138;

            return -p137 * ((1 - v139 * v139) ^ 0.5 - 1) + p136;
        end,

        [Enum.EasingDirection.InOut] = function(p140, p141, p142, p143) -- Line: 277
            local v144 = p140 / p143 * 2;

            if v144 < 1 then
                return -p142 * 0.5 * ((1 - v144 * v144) ^ 0.5 - 1) + p141;
            end;

            local v145 = v144 - 2;

            return p142 * 0.5 * ((1 - v145 * v145) ^ 0.5 + 1) + p141;
        end,

        [Enum.EasingDirection.Out] = function(p146, p147, p148, p149) -- Line: 286
            local v150 = p146 / p149 - 1;

            return p148 * (1 - v150 * v150) ^ 0.5 + p147;
        end
    },
    [Enum.EasingStyle.Bounce] = {
        [Enum.EasingDirection.In] = function(p151, p152, p153, p154) -- Line: 59, Name: inBounce
            -- upvalues: outBounce (copy)
            return p153 - outBounce(p154 - p151, 0, p153, p154) + p152;
        end,

        [Enum.EasingDirection.InOut] = function(p155, p156, p157, p158) -- Line: 293
            -- upvalues: outBounce (copy)
            if p155 < p158 * 0.5 then
                return (p157 - outBounce(p158 - p155 * 2, 0, p157, p158) + 0) * 0.5 + p156;
            end;

            return outBounce(p155 * 2 - p158, 0, p157, p158) * 0.5 + p157 * 0.5 + p156;
        end,

        [Enum.EasingDirection.Out] = outBounce
    },
    [Enum.EasingStyle.Back] = {
        [Enum.EasingDirection.In] = function(p159, p160, p161, p162) -- Line: 303
            local v163 = p159 / p162;

            return p161 * v163 * v163 * (2.70158 * v163 - 1.70158) + p160;
        end,

        [Enum.EasingDirection.InOut] = function(p164, p165, p166, p167) -- Line: 308
            local v168 = p164 / p167 * 2;

            if v168 < 1 then
                return p166 * 0.5 * (v168 * v168 * (3.5949095 * v168 - 2.5949095)) + p165;
            end;

            local v169 = v168 - 2;

            return p166 * 0.5 * (v169 * v169 * (3.5949095 * v169 + 2.5949095) + 2) + p165;
        end,

        [Enum.EasingDirection.Out] = function(p170, p171, p172, p173) -- Line: 318
            local v174 = p170 / p173 - 1;

            return p172 * (v174 * v174 * (2.70158 * v174 + 1.70158) + 1) + p171;
        end
    }
};

return function(p176, p177, p178) -- Line: 326
    -- upvalues: u175 (copy)
    return u175[p177 or Enum.EasingStyle.Quad][p178 or Enum.EasingDirection.InOut](p176, 0, 1, 1);
end;