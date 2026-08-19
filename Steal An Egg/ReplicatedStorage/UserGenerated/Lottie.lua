-- Decompiled with Potassium's decompiler.

local v1 = not game:GetService("RunService"):IsClient();
assert(v1);
local HttpService = game:GetService("HttpService");
local AssetService = game:GetService("AssetService");
local EncodingService = game:GetService("EncodingService");
require(script.Types);
local Easing = require(script.Easing);
local u2 = Rect.new(64, 64, 192, 192);
local u3 = UDim2.fromScale(0, 0);
local u4 = UDim2.fromScale(1, 1);
local success, result = pcall(require, script.PNG);

if not success then
    result = nil;
end;

local function HexToColor3(p5) -- Line: 90
    local v6 = string.sub(p5, 2, 3);
    local v7 = tonumber(v6, 16) or 0;
    local v8 = string.sub(p5, 4, 5);
    local v9 = tonumber(v8, 16) or 0;
    local v10 = string.sub(p5, 6, 7);
    local v11 = tonumber(v10, 16) or 0;

    return Color3.fromRGB(v7, v9, v11);
end;

local function IsPropertyAnimated(p12) -- Line: 97
    if p12 == nil then
        return false;
    end;

    return p12.a == 1;
end;

local function HasAnimatedOpacity(p13) -- Line: 104
    if p13 == nil then
        return false;
    end;

    local o = p13.o;

    if o == nil then
        return false;
    end;

    return o.a == 1;
end;

local function SubdivideCubicBezier(p14, p15, p16, p17, p18, p19, p20, p21, p22, p23) -- Line: 113
    for i = 1, p22 do
        local v24 = i / p22;
        local v25 = 1 - v24;
        local v26 = v25 * v25;
        local v27 = v26 * v25;
        local v28 = v24 * v24;
        local v29 = v28 * v24;
        table.insert(p23, { v27 * p14 + v26 * 3 * v24 * p16 + v25 * 3 * v28 * p18 + v29 * p20, v27 * p15 + v26 * 3 * v24 * p17 + v25 * 3 * v28 * p19 + v29 * p21 });
    end;
end;

local function BezierShapeToPolyline(p30) -- Line: 139
    -- upvalues: SubdivideCubicBezier (copy)
    local v = p30.v;
    local i = p30.i;
    local o = p30.o;
    local v31 = #v;

    if v31 == 0 then
        return {};
    end;

    local v32 = {
        { v[1][1], v[1][2] }
    };
    local v33;

    if p30.c then
        v33 = v31;
    else
        v33 = v31 - 1;
    end;

    for i2 = 1, v33 do
        local v34 = i2 >= v31 and 1 or i2 + 1;
        local v35 = v[i2];
        local v36 = v[v34];
        local v37 = o[i2];
        local v38 = i[v34];
        local v39 = v35[1];
        local v40 = v35[2];
        local v41 = v39 + v37[1];
        local v42 = v40 + v37[2];
        local v43 = v36[1] + v38[1];
        local v44 = v36[2] + v38[2];
        local v45 = v36[1];
        local v46 = v36[2];
        local v47;

        if math.abs(v37[1]) < 0.01 and (math.abs(v37[2]) < 0.01 and math.abs(v38[1]) < 0.01) then
            v47 = math.abs(v38[2]) < 0.01;
        else
            v47 = false;
        end;

        if v47 then
            table.insert(v32, { v45, v46 });
        else
            SubdivideCubicBezier(v39, v40, v41, v42, v43, v44, v45, v46, 12, v32);
        end;
    end;

    return v32;
end;

local function Cross2D(p48, p49, p50, p51, p52, p53) -- Line: 180
    return (p50 - p48) * (p53 - p49) - (p51 - p49) * (p52 - p48);
end;

local function PointInTriangle(p54, p55, p56, p57, p58, p59, p60, p61) -- Line: 184
    local v62 = (p56 - p54) * (p59 - p55) - (p57 - p55) * (p58 - p54);
    local v63 = (p58 - p54) * (p61 - p55) - (p59 - p55) * (p60 - p54);
    local v64 = (p60 - p54) * (p57 - p55) - (p61 - p55) * (p56 - p54);

    return (v62 >= 0 and v63 >= 0 and v64 >= 0 or v62 <= 0 and v63 <= 0 and v64 <= 0) and true or false;
end;

local function IsConvexPolygon(p65) -- Line: 202
    local v66 = #p65;

    if v66 < 3 then
        return false;
    end;

    local v67 = 0;

    for i = 1, v66 do
        local v68 = i >= v66 and 1 or i + 1;
        local v69 = v68 >= v66 and 1 or v68 + 1;
        local v70 = p65[i][1];
        local v71 = p65[i][2];
        local v72 = (p65[v68][1] - v70) * (p65[v69][2] - v71) - (p65[v68][2] - v71) * (p65[v69][1] - v70);

        if v72 ~= 0 then
            if v67 == 0 then
                if v72 > 0 then
                    v67 = 1;
                else
                    v67 = -1;
                end;
            elseif v72 > 0 and v67 < 0 or v72 < 0 and v67 > 0 then
                return false;
            end;
        end;
    end;

    return true;
end;

local function TriangulateFan(p73) -- Line: 223
    local v74 = {};

    for i = 2, #p73 - 1 do
        table.insert(v74, { p73[1], p73[i], p73[i + 1] });
    end;

    return v74;
end;

local function TriangulateEarClip(p75) -- Line: 231
    -- upvalues: IsConvexPolygon (copy), TriangulateFan (copy), PointInTriangle (copy)
    local v76 = #p75;

    if v76 < 3 then
        return {};
    end;

    if v76 == 3 then
        return {
            { p75[1], p75[2], p75[3] }
        };
    end;

    if IsConvexPolygon(p75) then
        return TriangulateFan(p75);
    end;

    local v77 = table.create(v76);
    local v78 = 0;

    for i = 1, v76 do
        v77[i] = i;
        local v79 = i >= v76 and 1 or i + 1;
        v78 = v78 + (p75[v79][1] - p75[i][1]) * (p75[v79][2] + p75[i][2]);
    end;

    local v80;

    if v78 > 0 then
        v80 = table.create(v76);

        for i = 1, v76 do
            v80[i] = v77[v76 - i + 1];
        end;
    else
        v80 = v77;
    end;

    local v81 = #v80;
    local v82 = v81 * v81;
    local v83 = 0;
    local v84 = 1;
    local v85 = {};

    while true do
        while true do
            if v81 <= 2 or v83 >= v82 then
                return v85;
            end;

            v83 = v83 + 1;
            v84 = v81 < v84 and 1 or v84;
            local v86;

            if v84 > 1 then
                v86 = v84 - 1;
            else
                v86 = v81;
            end;

            local v87 = v84 >= v81 and 1 or v84 + 1;
            local v88 = p75[v80[v86]];
            local v89 = p75[v80[v84]];
            local v90 = p75[v80[v87]];
            local v91 = v88[1];
            local v92 = v88[2];

            if (v89[1] - v91) * (v90[2] - v92) - (v89[2] - v92) * (v90[1] - v91) <= 0 then
                break;
            end;

            local v93 = true;

            for i = 1, v81 do
                if i ~= v86 and (i ~= v84 and (i ~= v87 and PointInTriangle(p75[v80[i]][1], p75[v80[i]][2], v88[1], v88[2], v89[1], v89[2], v90[1], v90[2]))) then
                    v93 = false;
                    break;
                end;
            end;

            if v93 then
                table.insert(v85, { v88, v89, v90 });
                table.remove(v80, v84);
                v81 = v81 - 1;

                if v81 < v84 then
                    v84 = 1;
                end;
            else
                v84 = v84 + 1;
            end;
        end;

        v84 = v84 + 1;
    end;
end;

local function CreateWedge(p94) -- Line: 317
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Image = "rbxassetid://83051256678409";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Parent = p94;

    return ImageLabel;
end;

local function UpdateTriangle(p95, p96, p97, p98, p99, p100, p101, p102, p103) -- Line: 327
    local v104 = p98 - p96;
    local v105 = p99 - p97;
    local v106 = p100 - p96;
    local v107 = p101 - p97;

    if v104 * v107 - v105 * v106 < 0 then
        v104 = p100 - p96;
        v105 = p101 - p97;
        v106 = p98 - p96;
        v107 = p99 - p97;
    end;

    local v108 = math.sqrt(v104 * v104 + v105 * v105);
    local v109 = math.sqrt(v106 * v106 + v107 * v107);

    if v108 < 1e-6 or v109 < 1e-6 then
        p95.A.Visible = false;
        p95.B.Visible = false;

        return;
    end;

    local v110 = v104 / v108;
    local v111 = v105 / v108;
    local v112 = v106 * v110 + v107 * v111;
    local v113 = v106 - v110 * v112;
    local v114 = v107 - v111 * v112;
    local v115 = math.sqrt(v113 * v113 + v114 * v114);

    if v115 < 1e-6 then
        p95.A.Visible = false;
        p95.B.Visible = false;

        return;
    end;

    local v116 = math.atan2(v111, v110) * 57.29577951308232;
    local A = p95.A;
    A.Visible = true;
    A.Position = UDim2.fromScale(p96, p97);
    A.Size = UDim2.fromScale(math.max(v112, 0.0001), v115);
    A.Rotation = v116;
    A.AnchorPoint = Vector2.zero;
    A.ImageColor3 = p102;
    A.ImageTransparency = p103;
    local B = p95.B;
    local v117 = v108 - v112;
    B.Visible = v117 > 1e-6;

    if B.Visible then
        B.Position = UDim2.fromScale(p96 + v110 * v108, p97 + v111 * v108);
        B.Size = UDim2.fromScale(math.max(v117, 0.0001), v115);
        B.Rotation = v116 + 180;
        B.AnchorPoint = Vector2.zero;
        B.ImageColor3 = p102;
        B.ImageTransparency = p103;
    end;
end;

local function CreateTrianglePair(p118) -- Line: 395
    local v119 = {};
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Image = "rbxassetid://83051256678409";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Parent = p118;
    v119.A = ImageLabel;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Image = "rbxassetid://83051256678409";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.BorderSizePixel = 0;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.Parent = p118;
    v119.B = ImageLabel2;

    return v119;
end;

local function BuildFilledPath(p120, p121, p122, p123, p124, p125, p126) -- Line: 404
    -- upvalues: BezierShapeToPolyline (copy), TriangulateEarClip (copy), UpdateTriangle (copy)
    local v127 = BezierShapeToPolyline(p121);

    if #v127 < 3 then
        return;
    end;

    local v128 = table.create(#v127);

    for i, v in v127 do
        v128[i] = { v[1] / p123, v[2] / p124 };
    end;

    local v129 = TriangulateEarClip(v128);
    local v130 = p120.Triangles or {};

    for i, v in v129 do
        local v131;

        if i <= #v130 then
            v131 = v130[i];
        else
            v131 = {};
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Image = "rbxassetid://83051256678409";
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.Size = UDim2.fromScale(1, 1);
            ImageLabel.Parent = p122;
            v131.A = ImageLabel;
            local ImageLabel2 = Instance.new("ImageLabel");
            ImageLabel2.Image = "rbxassetid://83051256678409";
            ImageLabel2.BackgroundTransparency = 1;
            ImageLabel2.BorderSizePixel = 0;
            ImageLabel2.Size = UDim2.fromScale(1, 1);
            ImageLabel2.Parent = p122;
            v131.B = ImageLabel2;
            table.insert(v130, v131);
        end;

        UpdateTriangle(v131, v[1][1], v[1][2], v[2][1], v[2][2], v[3][1], v[3][2], p125, p126);
    end;

    for i = #v129 + 1, #v130 do
        v130[i].A.Visible = false;
        v130[i].B.Visible = false;
    end;

    p120.Triangles = v130;
end;

local function BuildStrokedPath(p132, p133, p134, p135, p136, p137, p138, p139, p140, p141, p142, p143) -- Line: 455
    -- upvalues: BezierShapeToPolyline (copy), Easing (copy)
    local v144 = BezierShapeToPolyline(p133);

    if #v144 < 2 then
        return;
    end;

    local v145 = p132.Segments or {};
    local v146 = 0;
    local v147 = { 0 };
    local v148 = p142 or 100;
    local v149 = p143 or 0;
    local v150 = p141 or 0;

    for i = 2, #v144 do
        local v151 = v144[i][1] - v144[i - 1][1];
        local v152 = v144[i][2] - v144[i - 1][2];
        v146 = v146 + math.sqrt(v151 * v151 + v152 * v152);
        v147[i] = v146;
    end;

    local v153 = nil;
    local v154;

    if p140 then
        v154 = {};

        for _, v in p140 do
            if v.v then
                table.insert(v154, Easing.EvaluateScalar(v.v, 0));
            end;
        end;

        if #v154 <= 0 then
            v154 = v153;
        end;
    else
        v154 = v153;
    end;

    local v155 = p139 / math.min(p135, p136);
    local v156 = 0;

    for i = 2, #v144 do
        local v157 = v144[i - 1];
        local v158 = v144[i];
        local v159 = v158[1] - v157[1];
        local v160 = v158[2] - v157[2];
        local v161 = math.sqrt(v159 * v159 + v160 * v160);

        if v161 >= 0.01 then
            local v162 = ((v147[i - 1] + v147[i]) * 0.5 / math.max(v146, 1e-6) * 100 + v149) % 100;

            if v162 >= v150 and v148 >= v162 then
                local v163 = true;

                if v154 then
                    local v164 = v147[i - 1];
                    local v165 = 0;

                    for _, v in v154 do
                        v165 = v165 + v;
                    end;

                    if v165 > 0 then
                        local v166 = v164 % v165;
                        local v167 = 0;

                        for i2, v in v154 do
                            v167 = v167 + v;

                            if v166 < v167 then
                                v163 = i2 % 2 == 1;
                                break;
                            end;
                        end;
                    end;
                end;

                v156 = v156 + 1;
                local v168;

                if v156 <= #v145 then
                    v168 = v145[v156];
                else
                    v168 = Instance.new("Frame");
                    v168.BorderSizePixel = 0;
                    v168.AnchorPoint = Vector2.new(0, 0.5);
                    v168.Parent = p134;
                    table.insert(v145, v168);
                end;

                v168.Visible = v163;

                if v163 then
                    local v169 = math.atan2(v160, v159) * 57.29577951308232;
                    v168.Position = UDim2.fromScale(v157[1] / p135, v157[2] / p136);
                    v168.Size = UDim2.fromScale(v161 / p135, v155);
                    v168.Rotation = v169;
                    v168.BackgroundColor3 = p137;
                    v168.BackgroundTransparency = p138;
                end;
            end;
        end;
    end;

    for i = v156 + 1, #v145 do
        v145[i].Visible = false;
    end;

    p132.Segments = v145;
end;

local function BuildLinearGradient(p170, p171, p172, p173, p174) -- Line: 572
    -- upvalues: Easing (copy)
    local UIGradient = Instance.new("UIGradient");
    local p = p171.p;
    local v175 = Easing.EvaluateVector(p171.k, p174, {});
    local v176 = {};

    for i = 0, p - 1 do
        local v177 = i * 4;
        local v178 = v175[v177 + 1] or i / math.max(p - 1, 1);
        local v179 = v175[v177 + 2] or 1;
        local v180 = v175[v177 + 3] or 1;
        local v181 = v175[v177 + 4] or 1;
        local new = ColorSequenceKeypoint.new;
        local v182 = math.clamp(v178, 0, 1);
        table.insert(v176, new(v182, Color3.new(v179, v180, v181)));
    end;

    local v183 = #v176 < 2 and { ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) } or v176;
    UIGradient.Color = ColorSequence.new(v183);
    local v184 = Easing.EvaluateVector(p172, p174, { 0, 0 });
    local v185 = Easing.EvaluateVector(p173, p174, { 1, 0 });
    UIGradient.Rotation = math.atan2(v185[2] - v184[2], v185[1] - v184[1]) * 57.29577951308232;
    UIGradient.Parent = p170;

    return UIGradient;
end;

local function BuildRadialGradientApprox(p186, p187, p188, p189, p190, p191, p192) -- Line: 612
    -- upvalues: Easing (copy)
    local p = p187.p;
    local v193 = Easing.EvaluateVector(p187.k, p190, {});
    local v194 = Easing.EvaluateVector(p188, p190, { p191 / 2, p192 / 2 });
    local v195 = Easing.EvaluateVector(p189, p190, { p191, p192 / 2 });
    local v196 = v194[1];
    local v197 = v194[2];
    local v198 = v195[1] - v196;
    local v199 = v195[2] - v197;
    local v200 = math.sqrt(v198 * v198 + v199 * v199);
    local v201 = math.min(p, 6);
    local v202 = {};

    for i = v201, 1, -1 do
        local v203 = i / v201;
        local v204 = math.floor(v203 * (p - 1));
        local v205 = math.min(v204, p - 1) * 4;
        local v206 = v193[v205 + 2] or 1;
        local v207 = v193[v205 + 3] or 1;
        local v208 = v193[v205 + 4] or 1;
        local v209 = v200 * 2 * v203;
        local Frame = Instance.new("Frame");
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.fromScale(v196 / p191, v197 / p192);
        Frame.Size = UDim2.fromScale(v209 / p191, v209 / p192);
        Frame.BackgroundColor3 = Color3.new(v206, v207, v208);
        Frame.BackgroundTransparency = 0;
        Frame.BorderSizePixel = 0;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0.5, 0);
        UICorner.Parent = Frame;
        Frame.Parent = p186;
        table.insert(v202, Frame);
    end;

    return v202;
end;

local function ApplyTransform(p210, p211, p212, p213, p214, p215, p216, p217) -- Line: 662
    -- upvalues: Easing (copy)
    if p211 == nil then
        return;
    end;

    local p = p211.p;
    local v218;

    if p == nil or type(p) ~= "table" then
        v218 = { 0, 0 };
    elseif p.s == true then
        v218 = { Easing.EvaluateScalarAtFrame(p.x, p212, 0), (Easing.EvaluateScalarAtFrame(p.y, p212, 0)) };
    else
        v218 = Easing.EvaluateVector(p, p212, { 0, 0 });
    end;

    local v219 = Easing.EvaluateVector(p211.s, p212, { 100, 100 });
    local v220 = Easing.EvaluateScalarAtFrame(p211.r, p212, 0);
    local v221 = Easing.EvaluateScalarAtFrame(p211.o, p212, 100);
    local v222 = Easing.EvaluateVector(p211.a, p212, { 0, 0 });
    local v223 = v219[1] / 100;
    local v224 = v219[2] / 100;
    p210.Position = UDim2.fromScale(v218[1] / p213, v218[2] / p214);
    p210.Rotation = v220;
    p210.Size = UDim2.fromScale(p216 * v223, p217 * v224);

    if p215 then
        p210.GroupTransparency = 1 - v221 / 100;
    end;

    local v225 = p216 * v223 * p213;
    local v226 = p217 * v224 * p214;

    if (v222[1] ~= 0 or v222[2] ~= 0) and (v225 > 0 and v226 > 0) then
        p210.AnchorPoint = Vector2.new(math.clamp(v222[1] / v225, 0, 1), (math.clamp(v222[2] / v226, 0, 1)));
    end;
end;

local function CollectShapeInfo(p227) -- Line: 716
    local v228 = nil;
    local v229 = nil;
    local v230 = nil;
    local v231 = nil;
    local v232 = nil;
    local v233 = nil;
    local v234 = nil;
    local v235 = nil;
    local v236 = nil;
    local v237 = nil;
    local v238 = nil;
    local v239 = nil;
    local v240 = nil;

    for _, v in p227 do
        if not v.hd then
            local ty = v.ty;

            if ty == "fl" then
                v233 = v.c;
                v234 = v.o;
            elseif ty == "st" then
                v235 = v.c;
                v236 = v.o;
                v237 = v.w;
                v239 = v.da;
            elseif ty == "sh" then
                v238 = v.ks;
            elseif ty == "tr" then
                v231 = v;
            elseif ty == "tm" then
                v240 = v.s;
                v228 = v.e;
                v229 = v.o;
                v230 = v.m;
            elseif ty == "mm" then
                v232 = v.mm;
            end;
        end;
    end;

    return v233, v234, v235, v236, v237, v238, v239, v240, v228, v229, v230, v231, v232;
end;

local function BuildShapeGroup(p241, p242, p243, p244, p245) -- Line: 782
    -- upvalues: CollectShapeInfo (copy), u4 (copy), u3 (copy), ApplyTransform (copy), Easing (copy), BuildFilledPath (copy), BuildStrokedPath (copy), BuildLinearGradient (copy), BuildRadialGradientApprox (copy), BuildShapeGroup (copy)
    local v246 = p241.it or {};
    local v247, v248, v249, v250, v251, v252, v253, v254, v255, v256, _, v257, _ = CollectShapeInfo(v246);
    local v258 = false;

    for _, v in v246 do
        if v.ty == "tr" then
            local o = v.o;
            local v259;

            if o == nil then
                v259 = false;
            else
                v259 = o.a == 1;
            end;

            if v259 then
                v258 = true;
                break;
            end;
        end;
    end;

    local v260;

    if v258 then
        v260 = Instance.new("CanvasGroup");
    else
        v260 = Instance.new("Frame");
    end;

    v260.BackgroundTransparency = 1;
    v260.BorderSizePixel = 0;
    v260.Size = u4;
    v260.Position = u3;
    v260.Parent = p242;

    if v257 then
        ApplyTransform(v260, {
            a = v257.a,
            p = v257.p,
            s = v257.s,
            r = v257.r,
            o = v257.o
        }, p245, p243, p244, v258, 1, 1);
    end;

    local v261 = {
        Shape = p241,
        Frame = v260,
        Children = {},
        FillColor = v247,
        FillOpacity = v248,
        StrokeColor = v249,
        StrokeOpacity = v250,
        StrokeWidth = v251,
        PathData = v252
    };
    local v262;

    if v252 == nil then
        v262 = false;
    else
        v262 = v252.a == 1;
    end;

    v261.IsAnimatedPath = v262;
    local v263 = Easing.EvaluateColor(v247, p245);
    local v264 = 1 - Easing.EvaluateScalarAtFrame(v248, p245, 100) / 100;
    local v265 = Easing.EvaluateColor(v249, p245);
    local v266 = 1 - Easing.EvaluateScalarAtFrame(v250, p245, 100) / 100;
    local v267 = Easing.EvaluateScalarAtFrame(v251, p245, 0);
    local v268 = Easing.EvaluateScalarAtFrame(v254, p245, 0);
    local v269 = Easing.EvaluateScalarAtFrame(v255, p245, 100);
    local v270 = Easing.EvaluateScalarAtFrame(v256, p245, 0);
    local v271 = 0;

    for _, v in v246 do
        if v.ty == "op" and v.a then
            v271 = Easing.EvaluateScalarAtFrame(v.a, p245, 0);
        end;
    end;

    for _, v in v246 do
        if not v.hd then
            local ty = v.ty;

            if ty == "sh" then
                local v272 = Easing.EvaluateBezierShape(v.ks, p245);

                if v272 and v271 ~= 0 then
                    local v273 = 0;
                    local v274 = 0;

                    for _, v2 in v272.v do
                        v273 = v273 + v2[1];
                        v274 = v274 + v2[2];
                    end;

                    local v275 = v273 / #v272.v;
                    local v276 = v274 / #v272.v;
                    local v277 = math.sqrt((v272.v[1][1] - v275) ^ 2 + (v272.v[1][2] - v276) ^ 2);
                    local v278 = v271 / math.max(v277, 1) + 1;
                    local v279 = table.create(#v272.v);

                    for i, v2 in v272.v do
                        v279[i] = { v275 + (v2[1] - v275) * v278, v276 + (v2[2] - v276) * v278 };
                    end;

                    v272 = {
                        v = v279,
                        i = v272.i,
                        o = v272.o,
                        c = v272.c
                    };
                end;

                if v272 then
                    if v247 then
                        BuildFilledPath(v261, v272, v260, p243, p244, v263, v264);
                    end;

                    if v249 and v267 > 0 then
                        BuildStrokedPath(v261, v272, v260, p243, p244, v265, v266, v267, v253, v268, v269, v270);
                    end;
                end;
            elseif ty == "rc" then
                local Frame = Instance.new("Frame");
                Frame.BorderSizePixel = 0;
                local v280 = Easing.EvaluateVector(v.s, p245, { 100, 100 });
                local v281 = Easing.EvaluateVector(v.p, p245, { 0, 0 });
                local v282 = Easing.EvaluateScalarAtFrame(v.r, p245, 0);
                Frame.Size = UDim2.fromScale(v280[1] / p243, v280[2] / p244);
                Frame.Position = UDim2.fromScale(v281[1] / p243, v281[2] / p244);
                Frame.AnchorPoint = Vector2.new(0.5, 0.5);

                if v247 then
                    Frame.BackgroundColor3 = v263;
                    Frame.BackgroundTransparency = v264;
                else
                    Frame.BackgroundTransparency = 1;
                end;

                if v282 > 0 then
                    local UICorner = Instance.new("UICorner");
                    UICorner.CornerRadius = UDim.new(0, v282);
                    UICorner.Parent = Frame;
                    v261.UICorner = UICorner;
                end;

                if v249 and v267 > 0 then
                    local UIStroke = Instance.new("UIStroke");
                    UIStroke.Color = v265;
                    UIStroke.Transparency = v266;
                    UIStroke.Thickness = v267 / math.min(p243, p244);
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;

                    if not pcall(function() -- Line: 928
                        -- upvalues: UIStroke (copy)
                        UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
                    end) then
                        UIStroke.Thickness = v267;
                    end;

                    UIStroke.Parent = Frame;
                    v261.UIStroke = UIStroke;
                end;

                Frame.Parent = v260;
                v261.Frame = Frame;
            elseif ty == "el" then
                local Frame = Instance.new("Frame");
                Frame.BorderSizePixel = 0;
                local v283 = Easing.EvaluateVector(v.s, p245, { 100, 100 });
                local v284 = Easing.EvaluateVector(v.p, p245, { 0, 0 });
                Frame.Size = UDim2.fromScale(v283[1] / p243, v283[2] / p244);
                Frame.Position = UDim2.fromScale(v284[1] / p243, v284[2] / p244);
                Frame.AnchorPoint = Vector2.new(0.5, 0.5);

                if v247 then
                    Frame.BackgroundColor3 = v263;
                    Frame.BackgroundTransparency = v264;
                else
                    Frame.BackgroundTransparency = 1;
                end;

                local UICorner = Instance.new("UICorner");
                UICorner.CornerRadius = UDim.new(0.5, 0);
                UICorner.Parent = Frame;
                v261.UICorner = UICorner;

                if v249 and v267 > 0 then
                    local UIStroke = Instance.new("UIStroke");
                    UIStroke.Color = v265;
                    UIStroke.Transparency = v266;
                    UIStroke.Thickness = v267 / math.min(p243, p244);
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    pcall(function() -- Line: 968
                        -- upvalues: UIStroke (copy)
                        UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
                    end);
                    UIStroke.Parent = Frame;
                    v261.UIStroke = UIStroke;
                end;

                Frame.Parent = v260;
                v261.Frame = Frame;
            elseif ty == "gf" or ty == "gs" then
                local v285 = v.t or 1;

                if v.g then
                    if v285 == 1 then
                        v261.UIGradient = BuildLinearGradient(v260, v.g, v.s, v.e, p245);
                    elseif v285 == 2 then
                        BuildRadialGradientApprox(v260, v.g, v.s, v.e, p245, p243, p244);
                    end;
                end;
            elseif ty == "gr" then
                local v286 = BuildShapeGroup(v, v260, p243, p244, p245);

                if v261.Children then
                    table.insert(v261.Children, v286);
                end;
            elseif ty == "rp" then
                local v287 = Easing.EvaluateScalarAtFrame(v.c, p245, 1);
                local tr = v.tr;

                if tr and v287 > 1 then
                    local v288 = Easing.EvaluateScalarAtFrame(tr.so, p245, 100);
                    local v289 = Easing.EvaluateScalarAtFrame(tr.eo, p245, 100);

                    for i = 0, math.floor(v287) - 1 do
                        local Frame = Instance.new("Frame");
                        Frame.BackgroundTransparency = 1;
                        Frame.BorderSizePixel = 0;
                        Frame.Size = u4;
                        local v290 = i / math.max(v287 - 1, 1);
                        Frame.BackgroundTransparency = 1 - math.lerp(v288, v289, v290) / 100;
                        local _ = {
                            p = tr.p,
                            s = tr.s,
                            r = tr.r,
                            a = tr.a,
                            o = tr.o
                        };
                        local v291 = Easing.EvaluateVector(tr.p, p245, { 0, 0 });
                        Easing.EvaluateVector(tr.s, p245, { 100, 100 });
                        local v292 = Easing.EvaluateScalarAtFrame(tr.r, p245, 0);
                        Frame.Position = UDim2.fromScale(v291[1] * i / p243, v291[2] * i / p244);
                        Frame.Rotation = v292 * i;
                        Frame.Parent = v260;

                        for _, v2 in v246 do
                            if v2.ty == "gr" and v2 ~= p241 then
                                BuildShapeGroup(v2, Frame, p243, p244, p245);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v261;
end;

local function BuildShapeLayer(p293, p294, p295, p296, p297) -- Line: 1038
    -- upvalues: BuildShapeGroup (copy)
    local shapes = p293.shapes;

    if shapes == nil then
        return {};
    end;

    local v298 = {};

    for i = #shapes, 1, -1 do
        local v299 = shapes[i];

        if not v299.hd and v299.ty == "gr" then
            local v300 = BuildShapeGroup(v299, p294, p295, p296, p297);
            table.insert(v298, v300);
        end;
    end;

    return v298;
end;

local function BuildTextLayer(p301, p302, p303, p304, p305) -- Line: 1059
    -- upvalues: u4 (copy)
    local t = p301.t;

    if t == nil then
        return nil;
    end;

    local d = t.d;

    if d == nil then
        return nil;
    end;

    local k = d.k;

    if k == nil or #k == 0 then
        return nil;
    end;

    local u306 = nil;

    for _, v in k do
        if v.t == nil or v.t <= p305 then
            u306 = v.s;
        end;
    end;

    if u306 == nil then
        u306 = k[1].s;
    end;

    if u306 == nil then
        return nil;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Size = u4;
    TextLabel.Text = u306.t or "";
    TextLabel.TextScaled = false;
    TextLabel.RichText = false;
    TextLabel.TextSize = (u306.s or 24) / p304 * 100;

    if u306.fc then
        local fc = u306.fc;
        TextLabel.TextColor3 = Color3.new(fc[1] or 1, fc[2] or 1, fc[3] or 1);
    end;

    local v307 = u306.j or 0;

    if v307 == 0 then
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    elseif v307 == 1 then
        TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    else
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
    end;

    TextLabel.TextYAlignment = Enum.TextYAlignment.Top;

    if u306.f then
        local success2, result2 = pcall(function() -- Line: 1115
            -- upvalues: u306 (ref)
            return Enum.Font[u306.f];
        end);

        if success2 and result2 then
            TextLabel.Font = result2;
        else
            TextLabel.Font = Enum.Font.GothamMedium;
        end;
    end;

    TextLabel.Parent = p302;

    return TextLabel;
end;

local function BuildImageLayer(p308, p309, p310, p311, p312) -- Line: 1129
    -- upvalues: u4 (copy), result (ref), EncodingService (copy), AssetService (copy)
    local refId = p308.refId;

    if refId == nil then
        return nil;
    end;

    local v313 = p310[refId];

    if v313 == nil then
        return nil;
    end;

    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Size = u4;
    ImageLabel.ScaleType = Enum.ScaleType.Stretch;

    if v313.e == 1 and v313.p then
        local p = v313.p;

        if string.sub(p, 1, 22) == "data:image/png;base64," then
            local u314 = string.sub(p, 23);

            if result then
                local success2, result2 = pcall(function() -- Line: 1160
                    -- upvalues: EncodingService (ref), u314 (copy), result (ref)
                    local v315 = EncodingService:Base64Decode(buffer.fromstring(u314));

                    return result.decode(v315);
                end);

                if success2 and result2 then
                    local success3, result3 = pcall(function() -- Line: 1167
                        -- upvalues: AssetService (ref), result2 (copy)
                        return AssetService:CreateEditableImage({
                            Size = Vector2.new(result2.width, result2.height)
                        });
                    end);

                    if success3 and (result3 and pcall(function() -- Line: 1171
                        -- upvalues: result3 (copy), result2 (copy)
                        result3:WritePixelsBuffer(Vector2.zero, Vector2.new(result2.width, result2.height), result2.pixels);
                    end)) then
                        ImageLabel.ImageContent = Content.fromObject(result3);
                    end;
                end;
            end;
        elseif string.sub(p, 1, 23) == "data:image/jpeg;base64," then
            warn("[Lottie] Embedded JPEG not supported, skipping image layer:", p308.nm or "");
        end;
    elseif v313.p and not v313.e then
        ImageLabel.Image = v313.p;
    end;

    ImageLabel.Parent = p309;

    return ImageLabel;
end;

local function BuildDropShadow(p316, p317, p318, p319, p320) -- Line: 1195
    -- upvalues: Easing (copy), u2 (copy)
    local ef = p316.ef;

    if ef == nil then
        return;
    end;

    for _, v in ef do
        if v.ty == 25 then
            local ef2 = v.ef;

            if ef2 ~= nil then
                local v321 = Color3.new(0, 0, 0);
                local v322 = 0;
                local v323 = 5;
                local v324 = 5;
                local v325 = 0.5;

                for _, v2 in ef2 do
                    local ty = v2.ty;

                    if ty ~= nil then
                        if ty == 1 then
                            v321 = Easing.EvaluateColor(v2.v, p320);
                        elseif ty == 0 then
                            v325 = Easing.EvaluateScalarAtFrame(v2.v, p320, 128) / 255;
                        elseif ty == 3 then
                            v322 = Easing.EvaluateScalarAtFrame(v2.v, p320, 0);
                        elseif ty == 2 then
                            v323 = Easing.EvaluateScalarAtFrame(v2.v, p320, 5);
                        elseif ty == 4 then
                            v324 = Easing.EvaluateScalarAtFrame(v2.v, p320, 5);
                        end;
                    end;
                end;

                local v326 = math.rad(v322 + 180);
                local v327 = math.cos(v326) * v323 / p318;
                local v328 = math.sin(v326) * v323 / p319;
                local v329 = (v324 * 2 + math.max(p318, p319)) / math.max(p318, p319);
                local ImageLabel = Instance.new("ImageLabel");
                ImageLabel.Image = "rbxassetid://100849323991833";
                ImageLabel.ScaleType = Enum.ScaleType.Slice;
                ImageLabel.SliceCenter = u2;
                ImageLabel.ImageColor3 = v321;
                ImageLabel.ImageTransparency = 1 - v325;
                ImageLabel.BackgroundTransparency = 1;
                ImageLabel.BorderSizePixel = 0;
                ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
                ImageLabel.Position = UDim2.fromScale(v327 + 0.5, v328 + 0.5);
                ImageLabel.Size = UDim2.fromScale(v329, v329);
                ImageLabel.ZIndex = -1;
                ImageLabel.Parent = p317;

                return;
            end;
        end;
    end;
end;

local function BuildLayers(p330, p331, p332, p333, p334, p335) -- Line: 1260
    -- upvalues: u4 (copy), BuildShapeLayer (copy), BuildTextLayer (copy), BuildImageLayer (copy), BuildLayers (copy), BuildDropShadow (copy), Easing (copy), ApplyTransform (copy)
    local v336 = {};
    local v337 = {};

    for i = #p330, 1, -1 do
        local v338 = p330[i];

        if not v338.hd then
            local ty = v338.ty;
            local ks = v338.ks;
            local v339;

            if ks == nil then
                v339 = false;
            else
                local o = ks.o;

                if o == nil then
                    v339 = false;
                else
                    v339 = o.a == 1;
                end;
            end;

            local v340;

            if ty == 1 then
                v340 = Instance.new("Frame");
                v340.BorderSizePixel = 0;
                local v341;

                if v338.sc then
                    local sc = v338.sc;
                    local v342 = string.sub(sc, 2, 3);
                    local v343 = tonumber(v342, 16) or 0;
                    local v344 = string.sub(sc, 4, 5);
                    local v345 = tonumber(v344, 16) or 0;
                    local v346 = string.sub(sc, 6, 7);
                    local v347 = tonumber(v346, 16) or 0;
                    v341 = Color3.fromRGB(v343, v345, v347);
                else
                    v341 = Color3.new(0, 0, 0);
                end;

                v340.BackgroundColor3 = v341;
                v340.BackgroundTransparency = 0;
                v340.Size = UDim2.fromScale((v338.sw or p333) / p333, (v338.sh or p334) / p334);
            elseif v339 then
                v340 = Instance.new("CanvasGroup");
                v340.BackgroundTransparency = 1;
                v340.BorderSizePixel = 0;
                v340.Size = u4;
            else
                v340 = Instance.new("Frame");
                v340.BackgroundTransparency = 1;
                v340.BorderSizePixel = 0;
                v340.Size = u4;
            end;

            v340.Name = v338.nm or `Layer_{v338.ind or i}`;
            local Scale = v340.Size.X.Scale;
            local Scale2 = v340.Size.Y.Scale;
            local v348 = {
                Layer = v338,
                Frame = v340,
                BaseSizeX = Scale,
                BaseSizeY = Scale2
            };

            if v338.ind then
                v336[v338.ind] = v348;
            end;

            if ty == 4 then
                v348.Shapes = BuildShapeLayer(v338, v340, p333, p334, p335);
            elseif ty == 5 then
                v348.TextLabel = BuildTextLayer(v338, v340, p333, p334, p335);
            elseif ty == 2 then
                v348.ImageLabel = BuildImageLayer(v338, v340, p332, p333, p334);
            elseif ty == 0 then
                local refId = v338.refId;

                if refId and p332[refId] then
                    local v349 = p332[refId];

                    if v349.layers then
                        local v350 = v338.w or (v349.w or p333);
                        local v351 = v338.h or (v349.h or p334);
                        v340.ClipsDescendants = true;
                        v340.Size = UDim2.fromScale(v350 / p333, v351 / p334);
                        v348.Children = BuildLayers(v349.layers, v340, p332, v350, v351, p335);
                    end;
                end;
            end;

            BuildDropShadow(v338, v340, p333, p334, p335);

            if v338.masksProperties then
                for _, v in v338.masksProperties do
                    if v.mode == "a" or v.mode == nil then
                        local v352 = Easing.EvaluateBezierShape(v.pt, p335);

                        if v352 then
                            local v353 = (1 / 0);
                            local v354 = (1 / 0);
                            local v355 = (-1 / 0);
                            local v356 = (-1 / 0);

                            for _, v2 in v352.v do
                                v353 = math.min(v353, v2[1]);
                                v354 = math.min(v354, v2[2]);
                                v355 = math.max(v355, v2[1]);
                                v356 = math.max(v356, v2[2]);
                            end;

                            local Frame = Instance.new("Frame");
                            Frame.BackgroundTransparency = 1;
                            Frame.BorderSizePixel = 0;
                            Frame.ClipsDescendants = true;
                            Frame.Position = UDim2.fromScale(v353 / p333, v354 / p334);
                            Frame.Size = UDim2.fromScale((v355 - v353) / p333, (v356 - v354) / p334);
                            Frame.Parent = p331;
                            v340.Parent = Frame;
                            v348.MatteClip = Frame;
                        end;
                    end;
                end;
            end;

            ApplyTransform(v340, v338.ks, p335, p333, p334, v339, Scale, Scale2);
            local v357 = p335 - (v338.st or 0);
            local v358;

            if v338.ip <= v357 then
                v358 = v357 < v338.op;
            else
                v358 = false;
            end;

            v340.Visible = v358;
            table.insert(v337, v348);
        end;
    end;

    for _, v in v337 do
        local Layer = v.Layer;

        if Layer.parent and v336[Layer.parent] then
            v.Frame.Parent = v336[Layer.parent].Frame;
        elseif v.MatteClip == nil then
            v.Frame.Parent = p331;
        end;
    end;

    for i = 1, #v337 - 1 do
        local v359 = v337[i];
        local v360 = v337[i + 1];

        if v360.Layer.tt then
            local v361 = nil;

            for _, v in v359.Shapes or {} do
                if v.PathData then
                    v361 = Easing.EvaluateBezierShape(v.PathData, p335);
                    break;
                end;
            end;

            if v361 then
                local v362 = (1 / 0);
                local v363 = (1 / 0);
                local v364 = (-1 / 0);
                local v365 = (-1 / 0);

                for _, v in v361.v do
                    v362 = math.min(v362, v[1]);
                    v363 = math.min(v363, v[2]);
                    v364 = math.max(v364, v[1]);
                    v365 = math.max(v365, v[2]);
                end;

                local Frame = Instance.new("Frame");
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                Frame.ClipsDescendants = true;
                Frame.Position = UDim2.fromScale(v362 / p333, v363 / p334);
                Frame.Size = UDim2.fromScale((v364 - v362) / p333, (v365 - v363) / p334);
                Frame.Parent = p331;
                v360.Frame.Parent = Frame;
                v360.MatteClip = Frame;
                v359.Frame.Visible = false;
            end;
        end;
    end;

    return v337;
end;

local u366 = nil;

local function RenderLayerNodes(p367, p368, p369, p370) -- Line: 1429
    -- upvalues: ApplyTransform (copy), u366 (ref), Easing (copy), RenderLayerNodes (copy)
    for _, v in p367 do
        local Layer = v.Layer;
        local v371 = p368 - (Layer.st or 0);
        local v372;

        if Layer.ip <= v371 then
            v372 = v371 < Layer.op;
        else
            v372 = false;
        end;

        v.Frame.Visible = v372;

        if v372 then
            local v373 = v.Frame:IsA("CanvasGroup");
            ApplyTransform(v.Frame, Layer.ks, v371, p369, p370, v373, v.BaseSizeX, v.BaseSizeY);

            if v.Shapes then
                for _, v2 in v.Shapes do
                    u366(v2, v371, p369, p370);
                end;
            end;

            if v.Children then
                local v374 = Layer.w or p369;
                local v375 = Layer.h or p370;
                local v376;

                if Layer.tm then
                    v376 = Easing.EvaluateScalarAtFrame(Layer.tm, v371, 0) * (Layer.op - Layer.ip);
                else
                    v376 = v371;
                end;

                RenderLayerNodes(v.Children, v376, v374, v375);
            end;

            if v.TextLabel and Layer.t then
                local d = Layer.t.d;

                if d and d.k then
                    local v377 = nil;

                    for _, v2 in d.k do
                        if v2.t == nil or v2.t <= v371 then
                            v377 = v2.s;
                        end;
                    end;

                    if v377 then
                        v.TextLabel.Text = v377.t or "";

                        if v377.fc then
                            v.TextLabel.TextColor3 = Color3.new(v377.fc[1] or 1, v377.fc[2] or 1, v377.fc[3] or 1);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

u366 = function(p378, p379, p380, p381) -- Line: 1482
    -- upvalues: u366 (ref), Easing (copy), BuildFilledPath (copy), BuildStrokedPath (copy)
    if p378.Children then
        for _, v in p378.Children do
            u366(v, p379, p380, p381);
        end;
    end;

    if p378.IsAnimatedPath and p378.PathData then
        local v382 = Easing.EvaluateBezierShape(p378.PathData, p379);

        if v382 and p378.Frame then
            local v383 = Easing.EvaluateColor(p378.FillColor, p379);
            local v384 = Easing.EvaluateScalarAtFrame(p378.FillOpacity, p379, 100);

            if p378.FillColor then
                BuildFilledPath(p378, v382, p378.Frame, p380, p381, v383, 1 - v384 / 100);
            end;

            if p378.StrokeColor then
                local v385 = Easing.EvaluateColor(p378.StrokeColor, p379);
                local v386 = Easing.EvaluateScalarAtFrame(p378.StrokeOpacity, p379, 100);
                local v387 = Easing.EvaluateScalarAtFrame(p378.StrokeWidth, p379, 0);

                if v387 > 0 then
                    BuildStrokedPath(p378, v382, p378.Frame, p380, p381, v385, 1 - v386 / 100, v387);
                end;
            end;
        end;
    elseif p378.FillColor then
        local FillColor = p378.FillColor;
        local v388;

        if FillColor == nil then
            v388 = false;
        else
            v388 = FillColor.a == 1;
        end;

        if v388 then
            local v389 = Easing.EvaluateColor(p378.FillColor, p379);
            local v390 = 1 - Easing.EvaluateScalarAtFrame(p378.FillOpacity, p379, 100) / 100;

            if p378.Triangles then
                for _, v in p378.Triangles do
                    if v.A.Visible then
                        v.A.ImageColor3 = v389;
                        v.A.ImageTransparency = v390;
                    end;

                    if v.B.Visible then
                        v.B.ImageColor3 = v389;
                        v.B.ImageTransparency = v390;
                    end;
                end;
            end;

            if p378.Frame and p378.Frame.BackgroundTransparency < 1 then
                p378.Frame.BackgroundColor3 = v389;
                p378.Frame.BackgroundTransparency = v390;
            end;
        end;
    end;

    if p378.StrokeColor then
        local StrokeColor = p378.StrokeColor;
        local v391;

        if StrokeColor == nil then
            v391 = false;
        else
            v391 = StrokeColor.a == 1;
        end;

        if v391 then
            local v392 = Easing.EvaluateColor(p378.StrokeColor, p379);
            local v393 = Easing.EvaluateScalarAtFrame(p378.StrokeOpacity, p379, 100);

            if p378.Segments then
                for _, v in p378.Segments do
                    if v.Visible then
                        v.BackgroundColor3 = v392;
                        v.BackgroundTransparency = 1 - v393 / 100;
                    end;
                end;
            end;

            if p378.UIStroke then
                p378.UIStroke.Color = v392;
                p378.UIStroke.Transparency = 1 - v393 / 100;
            end;
        end;
    end;
end;

return table.freeze({
    Parse = function(p394) -- Line: 1551, Name: Parse
        -- upvalues: HttpService (copy)
        return HttpService:JSONDecode(p394);
    end,

    Create = function(p395) -- Line: 1555, Name: Create
        -- upvalues: u4 (copy), BuildLayers (copy)
        local w = p395.w;
        local h = p395.h;
        local ip = p395.ip;
        local op = p395.op;
        local fr = p395.fr;
        local Frame = Instance.new("Frame");
        Frame.Name = p395.nm or "LottieAnimation";
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        Frame.ClipsDescendants = true;
        Frame.Size = u4;
        local v396 = {};

        if p395.assets then
            for _, v in p395.assets do
                v396[v.id] = v;
            end;
        end;

        return {
            Animation = p395,
            Root = Frame,
            Layers = BuildLayers(p395.layers, Frame, v396, w, h, ip),
            AssetMap = v396,
            Duration = (op - ip) / fr,
            Width = w,
            Height = h
        };
    end,

    Render = function(p397, p398) -- Line: 1590, Name: Render
        -- upvalues: RenderLayerNodes (copy)
        local Animation = p397.Animation;
        local ip = Animation.ip;
        RenderLayerNodes(p397.Layers, ip + p398 * Animation.fr % (Animation.op - ip), p397.Width, p397.Height);
    end,

    Destroy = function(p399) -- Line: 1601, Name: Destroy
        p399.Root:Destroy();
        table.clear(p399.Layers);
        table.clear(p399.AssetMap);
    end
});