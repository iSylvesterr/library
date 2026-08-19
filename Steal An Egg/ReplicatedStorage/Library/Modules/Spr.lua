-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local exp = math.exp;
local sin = math.sin;
local cos = math.cos;
local min = math.min;
local max = math.max;
local sqrt = math.sqrt;
local atan2 = math.atan2;
local round = math.round;

local function magnitudeSq(p1) -- Line: 53
    local v2 = 0;

    for _, v in p1 do
        v2 = v2 + v ^ 2;
    end;

    return v2;
end;

local function distanceSq(p3, p4) -- Line: 61
    local v5 = 0;

    for i, v in p3 do
        v5 = v5 + (p4[i] - v) ^ 2;
    end;

    return v5;
end;

local u6 = {};
u6.__index = u6;

function u6.new(p7, p8, p9, p10, p11) -- Line: 100
    -- upvalues: u6 (copy)
    local v12 = p11.toIntermediate(p9);
    local v13 = {
        d = p7,
        f = p8,
        g = v12,
        p = v12,
        v = table.create(#v12, 0),
        typedat = p11,
        rawGoal = p10
    };

    return setmetatable(v13, u6);
end;

function u6.setGoal(p14, p15) -- Line: 113
    p14.rawGoal = p15;
    p14.g = p14.typedat.toIntermediate(p15);
end;

function u6.setDampingRatio(p16, p17) -- Line: 118
    p16.d = p17;
end;

function u6.setFrequency(p18, p19) -- Line: 122
    p18.f = p19;
end;

function u6.canSleep(p20) -- Line: 126
    local v21 = 0;

    for _, v in p20.v do
        v21 = v21 + v ^ 2;
    end;

    if v21 > 0.0001 then
        return false;
    end;

    local g = p20.g;
    local v22 = 0;

    for i, v in p20.p do
        v22 = v22 + (g[i] - v) ^ 2;
    end;

    return v22 <= 6.781684027777778e-8;
end;

function u6.step(p23, p24) -- Line: 138
    -- upvalues: exp (copy), sqrt (copy), cos (copy), sin (copy)
    local d = p23.d;
    local v25 = p23.f * 6.283185307179586;
    local g = p23.g;
    local p = p23.p;
    local v = p23.v;

    if d == 1 then
        local v26 = exp(-v25 * p24);
        local v27 = p24 * v26;
        local v28 = v26 + v27 * v25;
        local v29 = v26 - v27 * v25;
        local v30 = v27 * v25 * v25;

        for i = 1, #p do
            local v31 = p[i] - g[i];
            p[i] = v31 * v28 + v[i] * v27 + g[i];
            v[i] = v[i] * v29 - v31 * v30;
        end;
    elseif d < 1 then
        local v32 = exp(-d * v25 * p24);
        local v33 = sqrt(1 - d * d);
        local v34 = cos(p24 * v25 * v33);
        local v35 = sin(p24 * v25 * v33);
        local v36;

        if v33 > 0.00001 then
            v36 = v35 / v33;
        else
            local v37 = p24 * v25;
            v36 = v37 + (v37 * v37 * (v33 * v33) * (v33 * v33) / 20 - v33 * v33) * (v37 * v37 * v37) / 6;
        end;

        local v38;

        if v25 * v33 > 0.00001 then
            v38 = v35 / (v25 * v33);
        else
            local v39 = v25 * v33;
            v38 = p24 + (p24 * p24 * (v39 * v39) * (v39 * v39) / 20 - v39 * v39) * (p24 * p24 * p24) / 6;
        end;

        for i = 1, #p do
            local v40 = p[i] - g[i];
            p[i] = (v40 * (v34 + v36 * d) + v[i] * v38) * v32 + g[i];
            v[i] = (v[i] * (v34 - v36 * d) - v40 * (v36 * v25)) * v32;
        end;
    else
        local v41 = sqrt(d * d - 1);
        local v42 = -v25 * (d + v41);
        local v43 = -v25 * (d - v41);
        local v44 = exp(v42 * p24);
        local v45 = exp(v43 * p24);

        for i = 1, #p do
            local v46 = p[i] - g[i];
            local v47 = (v[i] - v46 * v42) / (2 * v25 * v41);
            local v48 = v44 * (v46 - v47);
            p[i] = v48 + v47 * v45 + g[i];
            v[i] = v48 * v42 + v47 * v45 * v43;
        end;
    end;

    return p23.typedat.fromIntermediate(p23.p);
end;

local u49 = {};
u49.__index = u49;

function u49.new(p50, p51, p52, p53) -- Line: 255
    -- upvalues: u49 (copy)
    local v54 = {
        v = Vector3.new(0, 0, 0),
        d = p50,
        f = p51,
        g = p53:Orthonormalize(),
        p = p52:Orthonormalize()
    };

    return setmetatable(v54, u49);
end;

function u49.setGoal(p55, p56) -- Line: 265
    p55.g = p56:Orthonormalize();
end;

function u49.setDampingRatio(p57, p58) -- Line: 269
    p57.d = p58;
end;

function u49.setFrequency(p59, p60) -- Line: 273
    p59.f = p60;
end;

local function dot(p61, p62) -- Line: 278
    return p61.X * p62.X + p61.Y * p62.Y + p61.Z * p62.Z;
end;

local function areRotationsClose(p63, p64) -- Line: 282
    local XVector = p63.XVector;
    local XVector2 = p64.XVector;
    local YVector = p63.YVector;
    local YVector2 = p64.YVector;
    local ZVector = p63.ZVector;
    local ZVector2 = p64.ZVector;

    return XVector.X * XVector2.X + XVector.Y * XVector2.Y + XVector.Z * XVector2.Z + (YVector.X * YVector2.X + YVector.Y * YVector2.Y + YVector.Z * YVector2.Z) + (ZVector.X * ZVector2.X + ZVector.Y * ZVector2.Y + ZVector.Z * ZVector2.Z) > 2.9999999695382584;
end;

local function angleDiff(p65, p66) -- Line: 290
    -- upvalues: max (copy), sqrt (copy), atan2 (copy)
    local XVector = p65.XVector;
    local XVector2 = p66.XVector;
    local YVector = p65.YVector;
    local YVector2 = p66.YVector;
    local ZVector = p65.ZVector;
    local ZVector2 = p66.ZVector;
    local v67 = XVector.X * XVector2.X + XVector.Y * XVector2.Y + XVector.Z * XVector2.Z + (YVector.X * YVector2.X + YVector.Y * YVector2.Y + YVector.Z * YVector2.Z) + (ZVector.X * ZVector2.X + ZVector.Y * ZVector2.Y + ZVector.Z * ZVector2.Z) - 1;

    return atan2(sqrt((max(0, 1 - v67 * v67 * 0.25))), v67 * 0.5);
end;

local function fromAxisAngle(p68, p69) -- Line: 299
    -- upvalues: cos (copy), sin (copy)
    local v70 = cos(p69);
    local v71 = sin(p69);
    local X = p68.X;
    local Y = p68.Y;
    local Z = p68.Z;
    local v72 = X * Y * (1 - v70);
    local v73 = Y * Z * (1 - v70);
    local v74 = Z * X * (1 - v70);
    local v75 = Vector3.new(X * X * (1 - v70) + v70, v72 + Z * v71, v74 - Y * v71);
    local v76 = Vector3.new(v72 - Z * v71, Y * Y * (1 - v70) + v70, v73 + X * v71);
    local v77 = Vector3.new(v74 + Y * v71, v73 - X * v71, Z * Z * (1 - v70) + v70);

    return CFrame.fromMatrix(Vector3.new(0, 0, 0), v75, v76, v77):Orthonormalize();
end;

local function rotateAxis(p78, p79) -- Line: 315
    -- upvalues: fromAxisAngle (copy)
    local identity = CFrame.identity;
    local Magnitude = p78.Magnitude;

    if Magnitude > 1e-6 then
        identity = fromAxisAngle(p78.Unit, Magnitude);
    end;

    return identity * p79;
end;

local function axisAngleDiff(p80, p81) -- Line: 325
    -- upvalues: angleDiff (copy)
    local v82 = (p80 * p81:Inverse()):ToAxisAngle();
    local v83 = angleDiff(p80, p81);

    return v82.Unit * v83;
end;

function u49.canSleep(p84) -- Line: 334
    local p = p84.p;
    local g = p84.g;
    local XVector = p.XVector;
    local XVector2 = g.XVector;
    local YVector = p.YVector;
    local YVector2 = g.YVector;
    local ZVector = p.ZVector;
    local ZVector2 = g.ZVector;

    return XVector.X * XVector2.X + XVector.Y * XVector2.Y + XVector.Z * XVector2.Z + (YVector.X * YVector2.X + YVector.Y * YVector2.Y + YVector.Z * YVector2.Z) + (ZVector.X * ZVector2.X + ZVector.Y * ZVector2.Y + ZVector.Z * ZVector2.Z) > 2.9999999695382584 and p84.v.Magnitude < 0.0017453292519943296;
end;

function u49.step(p85, p86) -- Line: 340
    -- upvalues: angleDiff (copy), exp (copy), fromAxisAngle (copy), sqrt (copy), cos (copy), sin (copy)
    local d = p85.d;
    local v87 = p85.f * 6.283185307179586;
    local g = p85.g;
    local p = p85.p;
    local v = p85.v;
    local v88 = (p * g:Inverse()):ToAxisAngle();
    local v89 = angleDiff(p, g);
    local v90 = v88.Unit * v89;
    local v91 = exp(-d * v87 * p86);
    local v92, v93;

    if d == 1 then
        local v94 = (v90 * (1 + v87 * p86) + v * p86) * v91;
        local identity = CFrame.identity;
        local Magnitude = v94.Magnitude;

        if Magnitude > 1e-6 then
            identity = fromAxisAngle(v94.Unit, Magnitude);
        end;

        v92 = identity * g;
        v93 = (v * (1 - p86 * v87) - v90 * (p86 * v87 * v87)) * v91;
    elseif d < 1 then
        local v95 = sqrt(1 - d * d);
        local v96 = cos(p86 * v87 * v95);
        local v97 = sin(p86 * v87 * v95);
        local v98 = v97 / v95;
        local v99 = (v90 * (v96 + v98 * d) + v * (v97 / (v87 * v95))) * v91;
        local identity = CFrame.identity;
        local Magnitude = v99.Magnitude;

        if Magnitude > 1e-6 then
            identity = fromAxisAngle(v99.Unit, Magnitude);
        end;

        v92 = identity * g;
        v93 = (v * (v96 - v98 * d) - v90 * (v98 * v87)) * v91;
    else
        local v100 = sqrt(d * d - 1);
        local v101 = -v87 * (d + v100);
        local v102 = -v87 * (d - v100);
        local v103 = (v - v90 * v101) / (2 * v87 * v100);
        local v104 = (v90 - v103) * exp(v101 * p86);
        local v105 = v103 * exp(v102 * p86);
        local v106 = v104 + v105;
        local identity = CFrame.identity;
        local Magnitude = v106.Magnitude;

        if Magnitude > 1e-6 then
            identity = fromAxisAngle(v106.Unit, Magnitude);
        end;

        v92 = identity * g;
        v93 = v104 * v101 + v105 * v102;
    end;

    p85.p = v92;
    p85.v = v93;

    return v92;
end;

local u109 = {
    springType = u6.new,

    toIntermediate = function(p107) -- Line: 394, Name: toIntermediate
        return { p107.X, p107.Y, p107.Z };
    end,

    fromIntermediate = function(p108) -- Line: 398, Name: fromIntermediate
        return Vector3.new(p108[1], p108[2], p108[3]);
    end
};
local u110 = {};
u110.__index = u110;

function u110.new(p111, p112, p113, p114, p115) -- Line: 408
    -- upvalues: u6 (copy), u109 (copy), u49 (copy), u110 (copy)
    local v116 = {
        rawGoal = p114,
        _position = u6.new(p111, p112, p113.Position, p114.Position, u109),
        _rotation = u49.new(p111, p112, p113.Rotation, p114.Rotation)
    };

    return setmetatable(v116, u110);
end;

function u110.setGoal(p117, p118) -- Line: 422
    p117.rawGoal = p118;
    p117._position:setGoal(p118.Position);
    p117._rotation:setGoal(p118.Rotation);
end;

function u110.setDampingRatio(p119, p120) -- Line: 428
    p119._position.d = p120;
    p119._rotation.d = p120;
end;

function u110.setFrequency(p121, p122) -- Line: 433
    p121._position.f = p122;
    p121._rotation.f = p122;
end;

function u110.canSleep(p123) -- Line: 438
    local v124 = p123._position:canSleep() and p123._rotation:canSleep();

    return v124;
end;

function u110.step(p125, p126) -- Line: 442
    local v127 = p125._position:step(p126);

    return p125._rotation:step(p126) + v127;
end;

local function inverseGammaCorrectD65(p128) -- Line: 453
    return p128 < 0.0404482362771076 and p128 / 12.92 or 0.87941546140213 * (p128 + 0.055) ^ 2.4;
end;

local function gammaCorrectD65(p129) -- Line: 457
    return p129 < 0.0031306684425 and 12.92 * p129 or 1.055 * p129 ^ 0.4166666666666667 - 0.055;
end;

local function rgbToLuv(p130) -- Line: 461
    local R = p130.R;
    local G = p130.G;
    local B = p130.B;
    local v131 = R < 0.0404482362771076 and R / 12.92 or 0.87941546140213 * (R + 0.055) ^ 2.4;
    local v132 = G < 0.0404482362771076 and G / 12.92 or 0.87941546140213 * (G + 0.055) ^ 2.4;
    local v133 = B < 0.0404482362771076 and B / 12.92 or 0.87941546140213 * (B + 0.055) ^ 2.4;
    local v134 = 0.9257063972951867 * v131 - 0.8333736323779866 * v132 - 0.09209820666085898 * v133;
    local v135 = 0.2125862307855956 * v131 + 0.7151703037034108 * v132 + 0.0722004986433362 * v133;
    local v136 = 3.6590806972265884 * v131 + 11.442689580057424 * v132 + 4.114991502426484 * v133;
    local v137 = v135 > 0.008856451679035631 and 116 * v135 ^ 0.3333333333333333 - 16 or 903.296296296296 * v135;
    local v138, v139;

    if v136 > 1e-14 then
        v138 = v137 * v134 / v136;
        v139 = v137 * (9 * v135 / v136 - 0.46832);
    else
        v138 = -0.19783 * v137;
        v139 = -0.46832 * v137;
    end;

    return { v137, v138, v139 };
end;

local function luvToRgb(p140) -- Line: 490
    -- upvalues: min (copy)
    local v141 = p140[1];

    if v141 < 0.0197955 then
        return Color3.new(0, 0, 0);
    end;

    local v142 = p140[2] / v141 + 0.19783;
    local v143 = p140[3] / v141 + 0.46832;
    local v144 = (v141 + 16) / 116;
    local v145 = v144 > 0.20689655172413793 and v144 * v144 * v144 or v144 * 0.12841854934601665 - 0.01771290335807126;
    local v146 = v145 * v142 / v143;
    local v147 = v145 * ((3 - v142 * 0.75) / v143 - 5);
    local v148 = v146 * 7.2914074 - v145 * 1.537208 - v147 * 0.4986286;
    local v149 = v146 * -2.180094 + v145 * 1.8757561 + v147 * 0.0415175;
    local v150 = v146 * 0.1253477 - v145 * 0.2040211 + v147 * 1.0569959;

    if v148 < 0 and (v148 < v149 and v148 < v150) then
        v149 = v149 - v148;
        v150 = v150 - v148;
        v148 = 0;
    elseif v149 < 0 and v149 < v150 then
        v148 = v148 - v149;
        v150 = v150 - v149;
        v149 = 0;
    elseif v150 < 0 then
        v148 = v148 - v150;
        v149 = v149 - v150;
        v150 = 0;
    end;

    return Color3.new(min(v148 < 0.0031306684425 and 12.92 * v148 or 1.055 * v148 ^ 0.4166666666666667 - 0.055, 1), min(v149 < 0.0031306684425 and 12.92 * v149 or 1.055 * v149 ^ 0.4166666666666667 - 0.055, 1), (min(v150 < 0.0031306684425 and 12.92 * v150 or 1.055 * v150 ^ 0.4166666666666667 - 0.055, 1)));
end;

local u167 = {
    boolean = {
        springType = u6.new,

        toIntermediate = function(p151) -- Line: 532, Name: toIntermediate
            return { p151 and 1 or 0 };
        end,

        fromIntermediate = function(p152) -- Line: 536, Name: fromIntermediate
            return p152[1] >= 0.5;
        end
    },
    number = {
        springType = u6.new,

        toIntermediate = function(p153) -- Line: 544, Name: toIntermediate
            return { p153 };
        end,

        fromIntermediate = function(p154) -- Line: 548, Name: fromIntermediate
            return p154[1];
        end
    },
    NumberRange = {
        springType = u6.new,

        toIntermediate = function(p155) -- Line: 556, Name: toIntermediate
            return { p155.Min, p155.Max };
        end,

        fromIntermediate = function(p156) -- Line: 560, Name: fromIntermediate
            return NumberRange.new(p156[1], p156[2]);
        end
    },
    UDim = {
        springType = u6.new,

        toIntermediate = function(p157) -- Line: 568, Name: toIntermediate
            return { p157.Scale, p157.Offset };
        end,

        fromIntermediate = function(p158) -- Line: 572, Name: fromIntermediate
            -- upvalues: round (copy)
            return UDim.new(p158[1], (round(p158[2])));
        end
    },
    UDim2 = {
        springType = u6.new,

        toIntermediate = function(p159) -- Line: 580, Name: toIntermediate
            local X = p159.X;
            local Y = p159.Y;

            return {
                X.Scale,
                X.Offset,
                Y.Scale,
                Y.Offset
            };
        end,

        fromIntermediate = function(p160) -- Line: 586, Name: fromIntermediate
            -- upvalues: round (copy)
            return UDim2.new(p160[1], round(p160[2]), p160[3], (round(p160[4])));
        end
    },
    Vector2 = {
        springType = u6.new,

        toIntermediate = function(p161) -- Line: 594, Name: toIntermediate
            return { p161.X, p161.Y };
        end,

        fromIntermediate = function(p162) -- Line: 598, Name: fromIntermediate
            return Vector2.new(p162[1], p162[2]);
        end
    },
    Vector3 = u109,
    Color3 = {
        springType = u6.new,
        toIntermediate = rgbToLuv,
        fromIntermediate = luvToRgb
    },
    ColorSequence = {
        springType = u6.new,

        toIntermediate = function(p163) -- Line: 615, Name: toIntermediate
            -- upvalues: rgbToLuv (ref)
            local Keypoints = p163.Keypoints;
            local v164 = rgbToLuv(Keypoints[1].Value);
            local v165 = rgbToLuv(Keypoints[#Keypoints].Value);

            return {
                v164[1],
                v164[2],
                v164[3],
                v165[1],
                v165[2],
                v165[3]
            };
        end,

        fromIntermediate = function(p166) -- Line: 631, Name: fromIntermediate
            -- upvalues: luvToRgb (ref)
            return ColorSequence.new(luvToRgb({ p166[1], p166[2], p166[3] }), luvToRgb({ p166[4], p166[5], p166[6] }));
        end
    },
    CFrame = {
        springType = u110.new,
        toIntermediate = error,
        fromIntermediate = error
    }
};
local u174 = {
    Pivot = {
        class = "PVInstance",

        get = function(p168) -- Line: 657, Name: get
            return p168:GetPivot();
        end,

        set = function(p169, p170) -- Line: 660, Name: set
            p169:PivotTo(p170);
        end
    },
    Scale = {
        class = "Model",

        get = function(p171) -- Line: 666, Name: get
            return p171:GetScale();
        end,

        set = function(p172, p173) -- Line: 669, Name: set
            p172:ScaleTo((math.clamp(p173, 1.402e-45, 16777216)));
        end
    }
};

local function getProperty(p175, p176) -- Line: 678
    -- upvalues: u174 (copy)
    local v177 = u174[p176];

    if v177 and p175:IsA(v177.class) then
        return v177.get(p175);
    end;

    return p175[p176];
end;

local function setProperty(p178, p179, p180) -- Line: 687
    -- upvalues: u174 (copy)
    local v181 = u174[p179];

    if v181 and p178:IsA(v181.class) then
        v181.set(p178, p180);

        return;
    end;

    p178[p179] = p180;
end;

local u182 = {};
local u183 = {};
local u184 = {};

local function processSprings(p185, p186) -- Line: 701
    -- upvalues: u174 (copy), u184 (copy)
    for i, v in p185 do
        for i2, v2 in v do
            if v2:canSleep() then
                v[i2] = nil;
                local rawGoal = v2.rawGoal;
                local v187 = u174[i2];

                if v187 and i:IsA(v187.class) then
                    v187.set(i, rawGoal);
                else
                    i[i2] = rawGoal;
                end;
            else
                local v188 = v2:step(p186);
                local v189 = u174[i2];

                if v189 and i:IsA(v189.class) then
                    v189.set(i, v188);
                else
                    i[i2] = v188;
                end;
            end;
        end;

        if not next(v) then
            p185[i] = nil;
            local v190 = u184[i];

            if v190 then
                u184[i] = nil;

                for _, v2 in v190 do
                    task.spawn(v2);
                end;
            end;
        end;
    end;
end;

RunService.PreSimulation:Connect(function(p191) -- Line: 730
    -- upvalues: processSprings (copy), u182 (copy)
    processSprings(u182, p191);
end);
RunService.PostSimulation:Connect(function(p192) -- Line: 734
    -- upvalues: processSprings (copy), u183 (copy)
    processSprings(u183, p192);
end);

local function assertType(p193, p194, p195, p196) -- Line: 738
    if not p195:find((typeof(p196))) then
        error(`bad argument #{p193} to {p194} ({p195} expected, got {typeof(p196)})`, 3);
    end;
end;

return table.freeze({
    target = function(p197, p198, p199, p200) -- Line: 747, Name: target
        -- upvalues: u183 (copy), u182 (copy), u174 (copy), u167 (copy)
        if not ("Instance"):find((typeof(p197))) then
            error(`bad argument #{1} to spr.target (Instance expected, got {typeof(p197)})`, 3);
        end;

        if not ("number"):find((typeof(p198))) then
            error(`bad argument #{2} to spr.target (number expected, got {typeof(p198)})`, 3);
        end;

        if not ("number"):find((typeof(p199))) then
            error(`bad argument #{3} to spr.target (number expected, got {typeof(p199)})`, 3);
        end;

        if not ("table"):find((typeof(p200))) then
            error(`bad argument #{4} to spr.target (table expected, got {typeof(p200)})`, 3);
        end;

        if p198 ~= p198 or p198 < 0 then
            error(("expected damping ratio >= 0; got %.2f"):format(p198), 2);
        end;

        if p199 ~= p199 or p199 < 0 then
            error(("expected undamped frequency >= 0; got %.2f"):format(p199), 2);
        end;

        local v201;

        if p197:IsA("Camera") then
            v201 = u183;
        else
            v201 = u182;
        end;

        local v202 = v201[p197];

        if not v202 then
            v202 = {};
            v201[p197] = v202;
        end;

        for i, v in p200 do
            local v203 = u174[i];
            local v204;

            if v203 and p197:IsA(v203.class) then
                v204 = v203.get(p197);
            else
                v204 = p197[i];
            end;

            if typeof(v) ~= typeof(v204) then
                error(`bad property {i} to spr.target ({typeof(v204)} expected, got {typeof(v)})`, 2);
            end;

            if p199 == (1 / 0) then
                local v205 = u174[i];

                if v205 and p197:IsA(v205.class) then
                    v205.set(p197, v);
                else
                    p197[i] = v;
                end;

                v202[i] = nil;
            else
                local v206 = v202[i];

                if not v206 then
                    local v207 = u167[typeof(v)];

                    if not v207 then
                        error("unsupported type: " .. typeof(v), 2);
                    end;

                    v206 = v207.springType(p198, p199, v204, v, v207);
                    v202[i] = v206;
                end;

                v206:setGoal(v);
                v206:setDampingRatio(p198);
                v206:setFrequency(p199);
            end;
        end;

        if not next(v202) then
            v201[p197] = nil;
        end;
    end,

    stop = function(p208, p209) -- Line: 808, Name: stop
        -- upvalues: u182 (copy), u183 (copy)
        if not ("Instance"):find((typeof(p208))) then
            error(`bad argument #{1} to spr.stop (Instance expected, got {typeof(p208)})`, 3);
        end;

        if not ("string|nil"):find((typeof(p209))) then
            error(`bad argument #{2} to spr.stop (string|nil expected, got {typeof(p209)})`, 3);
        end;

        if p209 then
            local v210 = u182[p208] or u183[p208];

            if v210 then
                v210[p209] = nil;
            end;
        else
            u182[p208] = nil;
            u183[p208] = nil;
        end;
    end,

    completed = function(p211, p212) -- Line: 825, Name: completed
        -- upvalues: u184 (copy)
        if not ("Instance"):find((typeof(p211))) then
            error(`bad argument #{1} to spr.completed (Instance expected, got {typeof(p211)})`, 3);
        end;

        if not ("function"):find((typeof(p212))) then
            error(`bad argument #{2} to spr.completed (function expected, got {typeof(p212)})`, 3);
        end;

        local v213 = u184[p211];

        if v213 then
            table.insert(v213, p212);

            return;
        end;

        u184[p211] = { p212 };
    end
});