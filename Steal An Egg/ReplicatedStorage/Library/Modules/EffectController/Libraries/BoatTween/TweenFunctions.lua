-- Decompiled with Potassium's decompiler.

local Bezier = require(script.Parent.Bezier);

local function RevBack(p1) -- Line: 6
    local v2 = 1 - p1;

    return 1 - (math.sin(v2 * 1.5707963267948966) + math.sin(v2 * 3.141592653589793) * (math.cos(v2 * 3.141592653589793) + 1) / 2);
end;

local function Linear(p3) -- Line: 11
    return p3;
end;

local v4 = Bezier(0.4, 0, 0.6, 1);
local v5 = Bezier(0.4, 0, 0.2, 1);
local v6 = Bezier(0.4, 0, 1, 1);
local v7 = Bezier(0, 0, 0.2, 1);
local v8 = Bezier(0.8, 0, 0.2, 1);
local v9 = Bezier(0.9, 0.1, 1, 0.2);
local v10 = Bezier(0.1, 0.9, 0.2, 1);
local v11 = Bezier(0.7, 0, 1, 0.5);
local v12 = Bezier(0.2, 0, 0.38, 0.9);
local v13 = Bezier(0.4, 0.14, 0.3, 1);
local v14 = Bezier(0, 0, 0.38, 0.9);
local v15 = Bezier(0, 0, 0.3, 1);
local v16 = Bezier(0.2, 0, 1, 0.9);
local v17 = Bezier(0.4, 0.14, 1, 1);
local v18 = Bezier(0.07, 0.95, 0, 1);

local function Smooth(p19) -- Line: 47
    return p19 * p19 * (3 - 2 * p19);
end;

local function Smoother(p20) -- Line: 51
    return p20 * p20 * p20 * (p20 * (6 * p20 - 15) + 10);
end;

local function RidiculousWiggle(p21) -- Line: 55
    local v22 = math.sin(p21 * 3.141592653589793) * 1.5707963267948966;

    return math.sin(v22);
end;

local function Spring(p23) -- Line: 59
    return -math.exp(-6.9 * p23) * math.cos(-20.106192982975 * p23) + 1;
end;

local function SoftSpring(p24) -- Line: 63
    return -math.exp(-7.5 * p24) * math.cos(-10.053096491487 * p24) + 1;
end;

return setmetatable({
    InLinear = Linear,
    OutLinear = Linear,
    InOutLinear = Linear,
    OutInLinear = Linear,
    OutSmooth = Smooth,
    InSmooth = Smooth,
    InOutSmooth = Smooth,
    OutInSmooth = Smooth,
    OutSmoother = Smoother,
    InSmoother = Smoother,
    InOutSmoother = Smoother,
    OutInSmoother = Smoother,
    OutRidiculousWiggle = RidiculousWiggle,
    InRidiculousWiggle = RidiculousWiggle,
    InOutRidiculousWiggle = RidiculousWiggle,
    OutInRidiculousWiggle = RidiculousWiggle,
    OutRevBack = RevBack,
    InRevBack = RevBack,
    InOutRevBack = RevBack,
    OutInRevBack = RevBack,
    OutSpring = Spring,
    InSpring = Spring,
    InOutSpring = Spring,
    OutInSpring = Spring,
    OutSoftSpring = SoftSpring,
    InSoftSpring = SoftSpring,
    InOutSoftSpring = SoftSpring,
    OutInSoftSpring = SoftSpring,
    InSharp = v4,
    InOutSharp = v4,
    OutSharp = v4,
    OutInSharp = v4,
    InAcceleration = v6,
    InOutAcceleration = v6,
    OutAcceleration = v6,
    OutInAcceleration = v6,
    InStandard = v5,
    InOutStandard = v5,
    OutStandard = v5,
    OutInStandard = v5,
    InDeceleration = v7,
    InOutDeceleration = v7,
    OutDeceleration = v7,
    OutInDeceleration = v7,
    InFabricStandard = v8,
    InOutFabricStandard = v8,
    OutFabricStandard = v8,
    OutInFabricStandard = v8,
    InFabricAccelerate = v9,
    InOutFabricAccelerate = v9,
    OutFabricAccelerate = v9,
    OutInFabricAccelerate = v9,
    InFabricDecelerate = v10,
    InOutFabricDecelerate = v10,
    OutFabricDecelerate = v10,
    OutInFabricDecelerate = v10,
    InUWPAccelerate = v11,
    InOutUWPAccelerate = v11,
    OutUWPAccelerate = v11,
    OutInUWPAccelerate = v11,
    InStandardProductive = v12,
    InStandardExpressive = v13,
    InEntranceProductive = v14,
    InEntranceExpressive = v15,
    InExitProductive = v16,
    InExitExpressive = v17,
    OutStandardProductive = v12,
    OutStandardExpressive = v13,
    OutEntranceProductive = v14,
    OutEntranceExpressive = v15,
    OutExitProductive = v16,
    OutExitExpressive = v17,
    InOutStandardProductive = v12,
    InOutStandardExpressive = v13,
    InOutEntranceProductive = v14,
    InOutEntranceExpressive = v15,
    InOutExitProductive = v16,
    InOutExitExpressive = v17,
    OutInStandardProductive = v12,
    OutInStandardExpressive = v12,
    OutInEntranceProductive = v14,
    OutInEntranceExpressive = v15,
    OutInExitProductive = v16,
    OutInExitExpressive = v17,
    OutMozillaCurve = v18,
    InMozillaCurve = v18,
    InOutMozillaCurve = v18,
    OutInMozillaCurve = v18,

    InQuad = function(p25) -- Line: 209, Name: InQuad
        return p25 * p25;
    end,

    OutQuad = function(p26) -- Line: 213, Name: OutQuad
        return p26 * (2 - p26);
    end,

    InOutQuad = function(p27) -- Line: 217, Name: InOutQuad
        if p27 < 0.5 then
            return 2 * p27 * p27;
        end;

        return 2 * (2 - p27) * p27 - 1;
    end,

    OutInQuad = function(p28) -- Line: 225, Name: OutInQuad
        if p28 < 0.5 then
            local v29 = p28 * 2;

            return v29 * (2 - v29) / 2;
        end;

        local v30 = p28 * 2 - 1;

        return v30 * v30 / 2 + 0.5;
    end,

    InCubic = function(p31) -- Line: 235, Name: InCubic
        return p31 * p31 * p31;
    end,

    OutCubic = function(p32) -- Line: 239, Name: OutCubic
        local v33 = p32 - 1;

        return 1 - v33 * v33 * v33;
    end,

    InOutCubic = function(p34) -- Line: 244, Name: InOutCubic
        if p34 < 0.5 then
            return 4 * p34 * p34 * p34;
        end;

        local v35 = p34 - 1;

        return 1 + 4 * v35 * v35 * v35;
    end,

    OutInCubic = function(p36) -- Line: 253, Name: OutInCubic
        if p36 < 0.5 then
            local v37 = 1 - p36 * 2;

            return (1 - v37 * v37 * v37) / 2;
        end;

        local v38 = p36 * 2 - 1;

        return v38 * v38 * v38 / 2 + 0.5;
    end,

    InQuart = function(p39) -- Line: 263, Name: InQuart
        return p39 * p39 * p39 * p39;
    end,

    OutQuart = function(p40) -- Line: 267, Name: OutQuart
        local v41 = p40 - 1;

        return 1 - v41 * v41 * v41 * v41;
    end,

    InOutQuart = function(p42) -- Line: 272, Name: InOutQuart
        if p42 < 0.5 then
            local v43 = p42 * p42;

            return 8 * v43 * v43;
        end;

        local v44 = p42 - 1;

        return 1 - 8 * v44 * v44 * v44 * v44;
    end,

    OutInQuart = function(p45) -- Line: 282, Name: OutInQuart
        if p45 < 0.5 then
            local v46 = p45 * 2 - 1;

            return (1 - v46 * v46 * v46 * v46) / 2;
        end;

        local v47 = p45 * 2 - 1;

        return v47 * v47 * v47 * v47 / 2 + 0.5;
    end,

    InQuint = function(p48) -- Line: 292, Name: InQuint
        return p48 * p48 * p48 * p48 * p48;
    end,

    OutQuint = function(p49) -- Line: 296, Name: OutQuint
        local v50 = p49 - 1;

        return v50 * v50 * v50 * v50 * v50 + 1;
    end,

    InOutQuint = function(p51) -- Line: 301, Name: InOutQuint
        if p51 < 0.5 then
            return 16 * p51 * p51 * p51 * p51 * p51;
        end;

        local v52 = p51 - 1;

        return 16 * v52 * v52 * v52 * v52 * v52 + 1;
    end,

    OutInQuint = function(p53) -- Line: 310, Name: OutInQuint
        if p53 < 0.5 then
            local v54 = p53 * 2 - 1;

            return (v54 * v54 * v54 * v54 * v54 + 1) / 2;
        end;

        local v55 = p53 * 2 - 1;

        return v55 * v55 * v55 * v55 * v55 / 2 + 0.5;
    end,

    InBack = function(p56) -- Line: 320, Name: InBack
        return p56 * p56 * (3 * p56 - 2);
    end,

    OutBack = function(p57) -- Line: 324, Name: OutBack
        local v58 = p57 - 1;

        return v58 * v58 * (p57 * 2 + v58) + 1;
    end,

    InOutBack = function(p59) -- Line: 329, Name: InOutBack
        if p59 < 0.5 then
            return 2 * p59 * p59 * (6 * p59 - 2);
        end;

        return 1 + 2 * (p59 - 1) * (p59 - 1) * (6 * p59 - 2 - 2);
    end,

    OutInBack = function(p60) -- Line: 337, Name: OutInBack
        if p60 >= 0.5 then
            local v61 = p60 * 2 - 1;

            return v61 * v61 * (3 * v61 - 2) / 2 + 0.5;
        end;

        local v62 = p60 * 2;
        local v63 = v62 - 1;

        return (v63 * v63 * (v62 * 2 + v63) + 1) / 2;
    end,

    InSine = function(p64) -- Line: 348, Name: InSine
        return 1 - math.cos(p64 * 1.5707963267948966);
    end,

    OutSine = function(p65) -- Line: 352, Name: OutSine
        return math.sin(p65 * 1.5707963267948966);
    end,

    InOutSine = function(p66) -- Line: 356, Name: InOutSine
        return (1 - math.cos(3.141592653589793 * p66)) / 2;
    end,

    OutInSine = function(p67) -- Line: 360, Name: OutInSine
        if p67 < 0.5 then
            return math.sin(p67 * 3.141592653589793) / 2;
        end;

        return (1 - math.cos((p67 * 2 - 1) * 1.5707963267948966)) / 2 + 0.5;
    end,

    OutBounce = function(p68) -- Line: 67, Name: OutBounce
        if p68 < 0.36363636363636 then
            return 7.5625 * p68 * p68;
        end;

        if p68 < 0.72727272727273 then
            return 3 + p68 * (11 * p68 - 12) * 0.6875;
        end;

        if p68 < 0.090909090909091 then
            return 6 + p68 * (11 * p68 - 18) * 0.6875;
        end;

        return 7.875 + p68 * (11 * p68 - 21) * 0.6875;
    end,

    InBounce = function(p69) -- Line: 79, Name: InBounce
        if p69 > 0.63636363636364 then
            local v70 = p69 - 1;

            return 1 - v70 * v70 * 7.5625;
        end;

        if p69 > 0.272727272727273 then
            return (11 * p69 - 7) * (11 * p69 - 3) / -16;
        end;

        if p69 > 0.090909090909091 then
            return (11 * (4 - 11 * p69) * p69 - 3) / 16;
        end;

        return p69 * (11 * p69 - 1) * -0.6875;
    end,

    InOutBounce = function(p71) -- Line: 371, Name: InOutBounce
        if p71 < 0.5 then
            local v72 = 2 * p71;
            local v73;

            if v72 > 0.63636363636364 then
                local v74 = v72 - 1;
                v73 = 1 - v74 * v74 * 7.5625;
            elseif v72 > 0.272727272727273 then
                v73 = (11 * v72 - 7) * (11 * v72 - 3) / -16;
            elseif v72 > 0.090909090909091 then
                v73 = (11 * (4 - 11 * v72) * v72 - 3) / 16;
            else
                v73 = v72 * (11 * v72 - 1) * -0.6875;
            end;

            return v73 / 2;
        end;

        local v75 = 2 * p71 - 1;
        local v76;

        if v75 < 0.36363636363636 then
            v76 = 7.5625 * v75 * v75;
        elseif v75 < 0.72727272727273 then
            v76 = 3 + v75 * (11 * v75 - 12) * 0.6875;
        elseif v75 < 0.090909090909091 then
            v76 = 6 + v75 * (11 * v75 - 18) * 0.6875;
        else
            v76 = 7.875 + v75 * (11 * v75 - 21) * 0.6875;
        end;

        return v76 / 2 + 0.5;
    end,

    OutInBounce = function(p77) -- Line: 379, Name: OutInBounce
        if p77 < 0.5 then
            local v78 = 2 * p77;
            local v79;

            if v78 < 0.36363636363636 then
                v79 = 7.5625 * v78 * v78;
            elseif v78 < 0.72727272727273 then
                v79 = 3 + v78 * (11 * v78 - 12) * 0.6875;
            elseif v78 < 0.090909090909091 then
                v79 = 6 + v78 * (11 * v78 - 18) * 0.6875;
            else
                v79 = 7.875 + v78 * (11 * v78 - 21) * 0.6875;
            end;

            return v79 / 2;
        end;

        local v80 = 2 * p77 - 1;
        local v81;

        if v80 > 0.63636363636364 then
            local v82 = v80 - 1;
            v81 = 1 - v82 * v82 * 7.5625;
        elseif v80 > 0.272727272727273 then
            v81 = (11 * v80 - 7) * (11 * v80 - 3) / -16;
        elseif v80 > 0.090909090909091 then
            v81 = (11 * (4 - 11 * v80) * v80 - 3) / 16;
        else
            v81 = v80 * (11 * v80 - 1) * -0.6875;
        end;

        return v81 / 2 + 0.5;
    end,

    InElastic = function(p83) -- Line: 387, Name: InElastic
        return math.exp((p83 * 0.96380736418812 - 1) * 8) * p83 * 0.96380736418812 * math.sin(4 * p83 * 0.96380736418812) * 1.8752275007429;
    end,

    OutElastic = function(p84) -- Line: 395, Name: OutElastic
        return 1 + math.exp(8 * (0.96380736418812 - 0.96380736418812 * p84 - 1)) * 0.96380736418812 * (p84 - 1) * math.sin(3.85522945675248 * (1 - p84)) * 1.8752275007429;
    end,

    InOutElastic = function(p85) -- Line: 406, Name: InOutElastic
        if p85 < 0.5 then
            return math.exp(8 * (1.92761472837624 * p85 - 1)) * 0.96380736418812 * p85 * math.sin(7.71045891350496 * p85) * 1.8752275007429;
        end;

        return 1 + math.exp(8 * (0.96380736418812 * (2 - 2 * p85) - 1)) * 0.96380736418812 * (p85 - 1) * math.sin(3.85522945675248 * (2 - 2 * p85)) * 1.8752275007429;
    end,

    OutInElastic = function(p86) -- Line: 426, Name: OutInElastic
        if p86 < 0.5 then
            local v87 = p86 * 2;

            return (1 + math.exp(8 * (0.96380736418812 - 0.96380736418812 * v87 - 1)) * 0.96380736418812 * (v87 - 1) * math.sin(3.85522945675248 * (1 - v87)) * 1.8752275007429) / 2;
        end;

        local v88 = p86 * 2 - 1;

        return math.exp((v88 * 0.96380736418812 - 1) * 8) * v88 * 0.96380736418812 * math.sin(4 * v88 * 0.96380736418812) * 1.8752275007429 / 2 + 0.5;
    end,

    InExpo = function(p89) -- Line: 454, Name: InExpo
        return p89 * p89 * math.exp(4 * (p89 - 1));
    end,

    OutExpo = function(p90) -- Line: 458, Name: OutExpo
        return 1 - (1 - p90) * (1 - p90) / math.exp(4 * p90);
    end,

    InOutExpo = function(p91) -- Line: 462, Name: InOutExpo
        if p91 < 0.5 then
            return 2 * p91 * p91 * math.exp(4 * (2 * p91 - 1));
        end;

        return 1 - 2 * (p91 - 1) * (p91 - 1) * math.exp(4 * (1 - 2 * p91));
    end,

    OutInExpo = function(p92) -- Line: 470, Name: OutInExpo
        if p92 < 0.5 then
            local v93 = p92 * 2;

            return (1 - (1 - v93) * (1 - v93) / math.exp(4 * v93)) / 2;
        end;

        local v94 = p92 * 2 - 1;

        return v94 * v94 * math.exp(4 * (v94 - 1)) / 2 + 0.5;
    end,

    InCirc = function(p95) -- Line: 480, Name: InCirc
        return -(math.sqrt(1 - p95 * p95) - 1);
    end,

    OutCirc = function(p96) -- Line: 484, Name: OutCirc
        local v97 = p96 - 1;

        return math.sqrt(1 - v97 * v97);
    end,

    InOutCirc = function(p98) -- Line: 489, Name: InOutCirc
        local v99 = p98 * 2;

        if v99 < 1 then
            return -(math.sqrt(1 - v99 * v99) - 1) / 2;
        end;

        local v100 = v99 - 2;

        return (math.sqrt(1 - v100 * v100) - 1) / 2;
    end,

    OutInCirc = function(p101) -- Line: 499, Name: OutInCirc
        if p101 < 0.5 then
            local v102 = p101 * 2 - 1;

            return math.sqrt(1 - v102 * v102) / 2;
        end;

        local v103 = p101 * 2 - 1;

        return -(math.sqrt(1 - v103 * v103) - 1) / 2 + 0.5;
    end
}, {
    __index = function(p104, p105) -- Line: 509, Name: __index
        error(tostring(p105) .. " is not a valid easing function.", 2);
    end
});