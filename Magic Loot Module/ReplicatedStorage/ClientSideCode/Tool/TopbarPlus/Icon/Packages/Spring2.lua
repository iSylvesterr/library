-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local exp = math.exp;
local sin = math.sin;
local cos = math.cos;
local min = math.min;
local sqrt = math.sqrt;
local round = math.round;
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, p5, p6) -- Line: 12
    -- upvalues: u1 (copy)
    local v7 = p6.toIntermediate(p4);
    local v8 = {
        d = p2,
        f = p3,
        g = v7,
        p = v7,
        v = table.create(#v7, 0),
        typedat = p6,
        rawGoal = p5
    };

    return setmetatable(v8, u1);
end;

function u1.setGoal(p9, p10) -- Line: 27
    p9.rawGoal = p10;
    p9.g = p9.typedat.toIntermediate(p10);
end;

function u1.setDampingRatio(p11, p12) -- Line: 31
    p11.d = p12;
end;

function u1.setFrequency(p13, p14) -- Line: 34
    p13.f = p14;
end;

function u1.canSleep(p15) -- Line: 37
    local v16 = 0;

    for _, v in p15.v do
        v16 = v16 + v ^ 2;
    end;

    if v16 > 0.0001 then
        return false;
    end;

    local g = p15.g;
    local v17 = 0;

    for i, v in p15.p do
        v17 = v17 + (g[i] - v) ^ 2;
    end;

    return v17 <= 6.781684027777778e-8;
end;

function u1.step(p18, p19) -- Line: 53
    -- upvalues: exp (copy), sqrt (copy), cos (copy), sin (copy)
    local d = p18.d;
    local v20 = p18.f * 2 * 3.141592653589793;
    local g = p18.g;
    local p = p18.p;
    local v = p18.v;

    if d == 1 then
        local v21 = exp(-v20 * p19);
        local v22 = p19 * v21;
        local v23 = v21 + v22 * v20;
        local v24 = v21 - v22 * v20;
        local v25 = v22 * v20 * v20;

        for i = 1, #p do
            local v26 = p[i] - g[i];
            p[i] = v26 * v23 + v[i] * v22 + g[i];
            v[i] = v[i] * v24 - v26 * v25;
        end;
    elseif d < 1 then
        local v27 = exp(-d * v20 * p19);
        local v28 = sqrt(1 - d * d);
        local v29 = cos(p19 * v20 * v28);
        local v30 = sin(p19 * v20 * v28);
        local v31;

        if v28 > 0.00001 then
            v31 = v30 / v28;
        else
            local v32 = p19 * v20;
            v31 = v32 + (v32 * v32 * (v28 * v28) * (v28 * v28) / 20 - v28 * v28) * (v32 * v32 * v32) / 6;
        end;

        local v33;

        if v20 * v28 > 0.00001 then
            v33 = v30 / (v20 * v28);
        else
            local v34 = v20 * v28;
            v33 = p19 + (p19 * p19 * (v34 * v34) * (v34 * v34) / 20 - v34 * v34) * (p19 * p19 * p19) / 6;
        end;

        for i = 1, #p do
            local v35 = p[i] - g[i];
            p[i] = (v35 * (v29 + v31 * d) + v[i] * v33) * v27 + g[i];
            v[i] = (v[i] * (v29 - v31 * d) - v35 * (v31 * v20)) * v27;
        end;
    else
        local v36 = sqrt(d * d - 1);
        local v37 = -v20 * (d - v36);
        local v38 = -v20 * (d + v36);
        local v39 = exp(v37 * p19);
        local v40 = exp(v38 * p19);

        for i = 1, #p do
            local v41 = p[i] - g[i];
            local v42 = (v[i] - v41 * v37) / (2 * v20 * v36);
            local v43 = v39 * (v41 - v42);
            p[i] = v43 + v42 * v40 + g[i];
            v[i] = v43 * v37 + v42 * v40 * v38;
        end;
    end;

    return p18.typedat.fromIntermediate(p18.p);
end;

local u44 = {};
u44.__index = u44;

function u44.new(p45, p46, p47, p48) -- Line: 113
    -- upvalues: u44 (copy)
    return setmetatable({
        d = p45,
        f = p46,
        g = p48,
        p = p47,
        v = Vector3.new(0, 0, 0)
    }, u44);
end;

function u44.setGoal(p49, p50) -- Line: 124
    p49.g = p50;
end;

function u44.setDampingRatio(p51, p52) -- Line: 127
    p51.d = p52;
end;

function u44.setFrequency(p53, p54) -- Line: 130
    p53.f = p54;
end;

function u44.canSleep(p55) -- Line: 133
    local _, v56 = p55.g:ToObjectSpace(p55.p):ToAxisAngle();
    local v57;

    if math.abs(v56) < 0.00017453292519943296 then
        v57 = p55.v.Magnitude < 0.0017453292519943296;
    else
        v57 = false;
    end;

    return v57;
end;

function u44.step(p58, p59) -- Line: 138
    -- upvalues: exp (copy), sqrt (copy), cos (copy), sin (copy)
    local d = p58.d;
    local v60 = p58.f * 2 * 3.141592653589793;
    local g = p58.g;
    local v = p58.v;
    local v61, v62 = (p58.p * g:Inverse()):ToAxisAngle();
    local v63 = v61 * v62;
    local v64 = exp(-d * v60 * p59);
    local v65, v66;

    if d == 1 then
        local _ = p59 * v64;
        local v67 = (v63 * (1 + v60 * p59) + v * p59) * v64;
        local Magnitude = v67.Magnitude;
        local v68;

        if Magnitude > 1e-6 then
            v68 = CFrame.fromAxisAngle(v67.Unit, Magnitude);
        else
            v68 = CFrame.identity;
        end;

        v65 = v68 * g;
        v66 = (v * (1 - p59 * v60) - v63 * (p59 * v60 * v60)) * v64;
    elseif d < 1 then
        local v69 = sqrt(1 - d * d);
        local v70 = cos(p59 * v60 * v69);
        local v71 = sin(p59 * v60 * v69);
        local v72 = v71 / v69;
        local v73 = (v63 * (v70 + v72 * d) + v * (v71 / (v60 * v69))) * v64;
        local Magnitude = v73.Magnitude;
        local v74;

        if Magnitude > 1e-6 then
            v74 = CFrame.fromAxisAngle(v73.Unit, Magnitude);
        else
            v74 = CFrame.identity;
        end;

        v65 = v74 * g;
        v66 = (v * (v70 - v72 * d) - v63 * (v72 * v60)) * v64;
    else
        local v75 = sqrt(d * d - 1);
        local v76 = -v60 * (d - v75);
        local v77 = -v60 * (d + v75);
        local v78 = (v - v63 * v76) / (2 * v60 * v75);
        local v79 = (v63 - v78) * exp(v76 * p59);
        local v80 = v78 * exp(v77 * p59);
        local v81 = v79 + v80;
        local Magnitude = v81.Magnitude;
        local v82;

        if Magnitude > 1e-6 then
            v82 = CFrame.fromAxisAngle(v81.Unit, Magnitude);
        else
            v82 = CFrame.identity;
        end;

        v65 = v82 * g;
        v66 = v79 * v76 + v80 * v77;
    end;

    p58.p = v65;
    p58.v = v66;

    return v65;
end;

local u85 = {
    springType = u1.new,

    toIntermediate = function(p83) -- Line: 201
        return { p83.X, p83.Y, p83.Z };
    end,

    fromIntermediate = function(p84) -- Line: 204
        return Vector3.new(p84[1], p84[2], p84[3]);
    end
};
local u86 = {};
u86.__index = u86;

function u86.new(p87, p88, p89, p90, p91) -- Line: 213
    -- upvalues: u1 (copy), u85 (copy), u44 (copy), u86 (copy)
    local v92 = {
        rawGoal = p90,
        _position = u1.new(p87, p88, p89.Position, p90.Position, u85),
        _rotation = u44.new(p87, p88, p89.Rotation, p90.Rotation)
    };

    return setmetatable(v92, u86);
end;

function u86.setGoal(p93, p94) -- Line: 223
    p93.rawGoal = p94;
    p93._position:setGoal(p94.Position);
    p93._rotation:setGoal(p94.Rotation);
end;

function u86.setDampingRatio(p95, p96) -- Line: 228
    p95._position:setDampingRatio(p96);
    p95._rotation:setDampingRatio(p96);
end;

function u86.setFrequency(p97, p98) -- Line: 232
    p97._position:setFrequency(p98);
    p97._rotation:setFrequency(p98);
end;

function u86.canSleep(p99) -- Line: 236
    local v100 = p99._position:canSleep() and p99._rotation:canSleep();

    return v100;
end;

function u86.step(p101, p102) -- Line: 243
    local v103 = p101._position:step(p102);

    return p101._rotation:step(p102) + v103;
end;

local function v_u_149(p104) -- Line: 247
    local R = p104.R;
    local G = p104.G;
    local B = p104.B;
    local v105 = R < 0.0404482362771076 and R / 12.92 or 0.87941546140213 * (R + 0.055) ^ 2.4;
    local v106 = G < 0.0404482362771076 and G / 12.92 or 0.87941546140213 * (G + 0.055) ^ 2.4;
    local v107 = B < 0.0404482362771076 and B / 12.92 or 0.87941546140213 * (B + 0.055) ^ 2.4;
    local v108 = 0.9257063972951867 * v105 - 0.8333736323779866 * v106 - 0.09209820666085898 * v107;
    local v109 = 0.2125862307855956 * v105 + 0.7151703037034108 * v106 + 0.0722004986433362 * v107;
    local v110 = 3.6590806972265884 * v105 + 11.442689580057424 * v106 + 4.114991502426484 * v107;
    local v111 = v109 > 0.008856451679035631 and 116 * v109 ^ 0.3333333333333333 - 16 or 903.296296296296 * v109;
    local v112, v113;

    if v110 > 1e-14 then
        v112 = v111 * v108 / v110;
        v113 = v111 * (9 * v109 / v110 - 0.46832);
    else
        v112 = -0.19783 * v111;
        v113 = -0.46832 * v111;
    end;

    return { v111, v112, v113 };
end;

local function v_u_161(p114) -- Line: 268
    -- upvalues: min (copy)
    local v115 = p114[1];

    if v115 < 0.0197955 then
        return Color3.new(0, 0, 0);
    end;

    local v116 = p114[2] / v115 + 0.19783;
    local v117 = p114[3] / v115 + 0.46832;
    local v118 = (v115 + 16) / 116;
    local v119 = v118 > 0.20689655172413793 and v118 * v118 * v118 or v118 * 0.12841854934601665 - 0.01771290335807126;
    local v120 = v119 * v116 / v117;
    local v121 = v119 * ((3 - v116 * 0.75) / v117 - 5);
    local v122 = v120 * 7.2914074 - v119 * 1.537208 - v121 * 0.4986286;
    local v123 = v120 * -2.180094 + v119 * 1.8757561 + v121 * 0.0415175;
    local v124 = v120 * 0.1253477 - v119 * 0.2040211 + v121 * 1.0569959;

    if v122 < 0 and (v122 < v123 and v122 < v124) then
        v123 = v123 - v122;
        v124 = v124 - v122;
        v122 = 0;
    elseif v123 < 0 and v123 < v124 then
        v122 = v122 - v123;
        v124 = v124 - v123;
        v123 = 0;
    elseif v124 < 0 then
        v122 = v122 - v124;
        v123 = v123 - v124;
        v124 = 0;
    end;

    return Color3.new(min(v122 < 0.0031306684425 and 12.92 * v122 or 1.055 * v122 ^ 0.4166666666666667 - 0.055, 1), min(v123 < 0.0031306684425 and 12.92 * v123 or 1.055 * v123 ^ 0.4166666666666667 - 0.055, 1), (min(v124 < 0.0031306684425 and 12.92 * v124 or 1.055 * v124 ^ 0.4166666666666667 - 0.055, 1)));
end;

local u141 = {
    boolean = {
        springType = u1.new,

        toIntermediate = function(p125) -- Line: 301
            return { p125 and 1 or 0 };
        end,

        fromIntermediate = function(p126) -- Line: 304
            return p126[1] >= 0.5;
        end
    },
    number = {
        springType = u1.new,

        toIntermediate = function(p127) -- Line: 310
            return { p127 };
        end,

        fromIntermediate = function(p128) -- Line: 313
            return p128[1];
        end
    },
    NumberRange = {
        springType = u1.new,

        toIntermediate = function(p129) -- Line: 319
            return { p129.Min, p129.Max };
        end,

        fromIntermediate = function(p130) -- Line: 322
            return NumberRange.new(p130[1], p130[2]);
        end
    },
    UDim = {
        springType = u1.new,

        toIntermediate = function(p131) -- Line: 328
            return { p131.Scale, p131.Offset };
        end,

        fromIntermediate = function(p132) -- Line: 331
            -- upvalues: round (copy)
            return UDim.new(p132[1], (round(p132[2])));
        end
    },
    UDim2 = {
        springType = u1.new,

        toIntermediate = function(p133) -- Line: 338
            local X = p133.X;
            local Y = p133.Y;

            return {
                X.Scale,
                X.Offset,
                Y.Scale,
                Y.Offset
            };
        end,

        fromIntermediate = function(p134) -- Line: 348
            -- upvalues: round (copy)
            return UDim2.new(p134[1], round(p134[2]), p134[3], (round(p134[4])));
        end
    },
    Vector2 = {
        springType = u1.new,

        toIntermediate = function(p135) -- Line: 355
            return { p135.X, p135.Y };
        end,

        fromIntermediate = function(p136) -- Line: 358
            return Vector2.new(p136[1], p136[2]);
        end
    },
    Vector3 = u85,
    Color3 = {
        springType = u1.new,
        toIntermediate = v_u_149,
        fromIntermediate = v_u_161
    },
    ColorSequence = {
        springType = u1.new,

        toIntermediate = function(p137) -- Line: 370
            -- upvalues: v_u_149 (copy)
            local Keypoints = p137.Keypoints;
            local v138 = v_u_149(Keypoints[1].Value);
            local v139 = v_u_149(Keypoints[#Keypoints].Value);

            return {
                v138[1],
                v138[2],
                v138[3],
                v139[1],
                v139[2],
                v139[3]
            };
        end,

        fromIntermediate = function(p140) -- Line: 384
            -- upvalues: v_u_161 (copy)
            return ColorSequence.new(v_u_161({ p140[1], p140[2], p140[3] }), v_u_161({ p140[4], p140[5], p140[6] }));
        end
    },
    CFrame = {
        springType = u86.new,
        toIntermediate = error,
        fromIntermediate = error
    }
};
local u148 = {
    Pivot = {
        class = "PVInstance",

        get = function(p142) -- Line: 398
            return p142:GetPivot();
        end,

        set = function(p143, p144) -- Line: 401
            p143:PivotTo(p144);
        end
    },
    Scale = {
        class = "Model",

        get = function(p145) -- Line: 407
            return p145:GetScale();
        end,

        set = function(p146, p147) -- Line: 410
            p146:ScaleTo(p147);
        end
    }
};
local u149 = {};
local u150 = {};
RunService.Heartbeat:Connect(function(p151) -- Line: 417
    -- upvalues: u149 (copy), u148 (copy), u150 (copy)
    for i, v in u149 do
        for i2, v2 in v do
            local v152 = u148[i2];

            if v152 and i:IsA(v152.class) then
                if v2:canSleep() then
                    v[i2] = nil;
                    v152.set(i, v2.rawGoal);
                else
                    v152.set(i, v2:step(p151));
                end;
            elseif v2:canSleep() then
                v[i2] = nil;
                i[i2] = v2.rawGoal;
            else
                i[i2] = v2:step(p151);
            end;
        end;

        if not next(v) then
            u149[i] = nil;
            local v153 = u150[i];

            if v153 then
                u150[i] = nil;

                for _, v2 in v153 do
                    task.spawn(v2);
                end;
            end;
        end;
    end;
end);

return table.freeze({
    target = function(p154, p155, p156, p157) -- Line: 449
        -- upvalues: u149 (copy), u148 (copy), u141 (copy)
        if not ("Instance"):find((typeof(p154))) then
            error(`bad argument #{1} to spr.target (Instance expected, got {typeof(p154)})`, 3);
        end;

        if not ("number"):find((typeof(p155))) then
            error(`bad argument #{2} to spr.target (number expected, got {typeof(p155)})`, 3);
        end;

        if not ("number"):find((typeof(p156))) then
            error(`bad argument #{3} to spr.target (number expected, got {typeof(p156)})`, 3);
        end;

        if not ("table"):find((typeof(p157))) then
            error(`bad argument #{4} to spr.target (table expected, got {typeof(p157)})`, 3);
        end;

        if p155 ~= p155 or p155 < 0 then
            error(("expected damping ratio >= 0; got %.2f"):format(p155), 2);
        end;

        if p156 ~= p156 or p156 < 0 then
            error(("expected undamped frequency >= 0; got %.2f"):format(p156), 2);
        end;

        local v158 = u149[p154];

        if not v158 then
            v158 = {};
            u149[p154] = v158;
        end;

        for i, v in p157 do
            local v159 = u148[i];
            local v160;

            if v159 and p154:IsA(v159.class) then
                v160 = v159.get(p154);
            else
                v160 = p154[i];
            end;

            if typeof(v) ~= typeof(v160) then
                error(`bad property {i} to spr.target ({typeof(v160)} expected, got {typeof(v)})`, 2);
            end;

            if p156 == (1 / 0) then
                p154[i] = v;
                v158[i] = nil;
            else
                local v161 = v158[i];

                if not v161 then
                    local v162 = u141[typeof(v)];

                    if not v162 then
                        error("unsupported type: " .. typeof(v), 2);
                    end;

                    v161 = v162.springType(p155, p156, v160, v, v162);
                    v158[i] = v161;
                end;

                v161:setGoal(v);
                v161:setDampingRatio(p155);
                v161:setFrequency(p156);
            end;
        end;

        if not next(v158) then
            u149[p154] = nil;
        end;
    end,

    stop = function(p163, p164) -- Line: 507
        -- upvalues: u149 (copy)
        if not ("Instance"):find((typeof(p163))) then
            error(`bad argument #{1} to spr.stop (Instance expected, got {typeof(p163)})`, 3);
        end;

        if not ("string|nil"):find((typeof(p164))) then
            error(`bad argument #{2} to spr.stop (string|nil expected, got {typeof(p164)})`, 3);
        end;

        if p164 then
            local v165 = u149[p163];

            if v165 then
                v165[p164] = nil;
            end;
        else
            u149[p163] = nil;
        end;
    end,

    completed = function(p166, p167) -- Line: 525
        -- upvalues: u150 (copy)
        if not ("Instance"):find((typeof(p166))) then
            error(`bad argument #{1} to spr.completed (Instance expected, got {typeof(p166)})`, 3);
        end;

        if not ("function"):find((typeof(p167))) then
            error(`bad argument #{2} to spr.completed (function expected, got {typeof(p167)})`, 3);
        end;

        local v168 = u150[p166];

        if v168 then
            table.insert(v168, p167);

            return;
        end;

        u150[p166] = { p167 };
    end
});