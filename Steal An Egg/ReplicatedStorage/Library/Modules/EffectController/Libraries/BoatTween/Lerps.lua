-- Decompiled with Potassium's decompiler.

local u1 = ipairs;
local u2 = Color3.new();

local function RobloxLerp(u3, u4) -- Line: 5
    return function(p5) -- Line: 6
        -- upvalues: u3 (copy), u4 (copy)
        return u3:Lerp(u4, p5);
    end;
end;

local function Lerp(p6, p7, p8) -- Line: 11
    return p6 + p8 * (p7 - p6);
end;

local function SortByTime(p9, p10) -- Line: 15
    return p9.Time < p10.Time;
end;

local function Color3Lerp(p11, p12) -- Line: 19
    -- upvalues: u2 (copy)
    local R = p11.R;
    local G = p11.G;
    local B = p11.B;
    local v13 = R < 0.0404482362771076 and R / 12.92 or 0.87941546140213 * (R + 0.055) ^ 2.4;
    local v14 = G < 0.0404482362771076 and G / 12.92 or 0.87941546140213 * (G + 0.055) ^ 2.4;
    local v15 = B < 0.0404482362771076 and B / 12.92 or 0.87941546140213 * (B + 0.055) ^ 2.4;
    local v16 = 0.2125862307855956 * v13 + 0.7151703037034108 * v14 + 0.0722004986433362 * v15;
    local v17 = 3.6590806972265884 * v13 + 11.442689580057424 * v14 + 4.114991502426484 * v15;
    local u18 = v16 > 0.008856451679035631 and 116 * v16 ^ 0.3333333333333333 - 16 or 903.296296296296 * v16;
    local u19, u20;

    if v17 > 1e-15 then
        u19 = u18 * (0.9257063972951867 * v13 - 0.8333736323779866 * v14 - 0.09209820666085898 * v15) / v17;
        u20 = u18 * (9 * v16 / v17 - 0.46832);
    else
        u19 = -0.19783 * u18;
        u20 = -0.46832 * u18;
    end;

    local R2 = p12.R;
    local G2 = p12.G;
    local B2 = p12.B;
    local v21 = R2 < 0.0404482362771076 and R2 / 12.92 or 0.87941546140213 * (R2 + 0.055) ^ 2.4;
    local v22 = G2 < 0.0404482362771076 and G2 / 12.92 or 0.87941546140213 * (G2 + 0.055) ^ 2.4;
    local v23 = B2 < 0.0404482362771076 and B2 / 12.92 or 0.87941546140213 * (B2 + 0.055) ^ 2.4;
    local v24 = 0.2125862307855956 * v21 + 0.7151703037034108 * v22 + 0.0722004986433362 * v23;
    local v25 = 3.6590806972265884 * v21 + 11.442689580057424 * v22 + 4.114991502426484 * v23;
    local u26 = v24 > 0.008856451679035631 and 116 * v24 ^ 0.3333333333333333 - 16 or 903.296296296296 * v24;
    local u27, u28;

    if v25 > 1e-15 then
        u27 = u26 * (0.9257063972951867 * v21 - 0.8333736323779866 * v22 - 0.09209820666085898 * v23) / v25;
        u28 = u26 * (9 * v24 / v25 - 0.46832);
    else
        u27 = -0.19783 * u26;
        u28 = -0.46832 * u26;
    end;

    return function(p29) -- Line: 54
        -- upvalues: u18 (ref), u26 (ref), u2 (ref), u19 (ref), u27 (ref), u20 (ref), u28 (ref)
        local v30 = (1 - p29) * u18 + p29 * u26;

        if v30 < 0.0197955 then
            return u2;
        end;

        local v31 = ((1 - p29) * u19 + p29 * u27) / v30 + 0.19783;
        local v32 = ((1 - p29) * u20 + p29 * u28) / v30 + 0.46832;
        local v33 = (v30 + 16) / 116;
        local v34 = v33 > 0.20689655172413793 and v33 * v33 * v33 or 0.12841854934601665 * v33 - 0.01771290335807126;
        local v35 = v34 * v31 / v32;
        local v36 = v34 * ((3 - 0.75 * v31) / v32 - 5);
        local v37 = 7.2914074 * v35 - 1.537208 * v34 - 0.4986286 * v36;
        local v38 = -2.180094 * v35 + 1.8757561 * v34 + 0.0415175 * v36;
        local v39 = 0.1253477 * v35 - 0.2040211 * v34 + 1.0569959 * v36;

        if v37 < 0 and (v37 < v38 and v37 < v39) then
            v38 = v38 - v37;
            v39 = v39 - v37;
            v37 = 0;
        elseif v38 < 0 and v38 < v39 then
            v37 = v37 - v38;
            v39 = v39 - v38;
            v38 = 0;
        elseif v39 < 0 then
            v37 = v37 - v39;
            v38 = v38 - v39;
            v39 = 0;
        end;

        local v40 = v37 < 0.0031306684425 and 12.92 * v37 or 1.055 * v37 ^ 0.4166666666666667 - 0.055;
        local v41 = v38 < 0.0031306684425 and 12.92 * v38 or 1.055 * v38 ^ 0.4166666666666667 - 0.055;
        local v42 = v39 < 0.0031306684425 and 12.92 * v39 or 1.055 * v39 ^ 0.4166666666666667 - 0.055;

        return Color3.new(v40 > 1 and 1 or (v40 < 0 and 0 or v40), v41 > 1 and 1 or (v41 < 0 and 0 or v41), v42 > 1 and 1 or (v42 < 0 and 0 or v42));
    end;
end;

return setmetatable({
    boolean = function(u43, u44) -- Line: 93, Name: boolean
        return function(p45) -- Line: 94
            -- upvalues: u43 (copy), u44 (copy)
            if p45 < 0.5 then
                return u43;
            end;

            return u44;
        end;
    end,

    number = function(u46, p47) -- Line: 103, Name: number
        local u48 = p47 - u46;

        return function(p49) -- Line: 105
            -- upvalues: u46 (copy), u48 (copy)
            return u46 + u48 * p49;
        end;
    end,

    string = function(p50, u51) -- Line: 110, Name: string
        local v52 = false;
        local v53, v54, v55, v56 = string.match(p50, "^([+-]?)(%d*):[+-]?(%d*):[+-]?(%d*)$");
        local v57, v58, v59, v60 = string.match(u51, "^([+-]?)(%d*):[+-]?(%d*):[+-]?(%d*)$");
        local u61, u62;

        if v53 and v57 then
            u61 = 3600 * (tonumber(v54) or 0) + 60 * (tonumber(v55) or 0) + (tonumber(v56) or 0);
            local v63 = 3600 * (tonumber(v58) or 0) + 60 * (tonumber(v59) or 0) + (tonumber(v60) or 0);

            if v53 == "-" then
                u61 = -u61;
            end;

            if v57 == "-" or not v63 then
                v63 = -v63;
            end;

            u62 = (43200 + v63 - u61) % 86400 - 43200;
        else
            v52 = true;
            u61 = nil;
            u62 = nil;
        end;

        if not v52 then
            return function(p64) -- Line: 137
                -- upvalues: u61 (ref), u62 (ref)
                local v65 = (u61 + u62 * p64) % 86400;
                local v66 = math.abs(v65);

                return string.format(v65 < 0 and "-%.2u:%.2u:%.2u" or "%.2u:%.2u:%.2u", (v66 - v66 % 3600) / 3600, (v66 % 3600 - v66 % 60) / 60, v66 % 60);
            end;
        end;

        local u67 = #u51;

        return function(p68) -- Line: 132
            -- upvalues: u67 (copy), u51 (copy)
            local v69 = 1 + u67 * p68;

            return string.sub(u51, 1, v69 < u67 and v69 and v69 or u67);
        end;
    end,

    CFrame = RobloxLerp,
    Color3 = Color3Lerp,

    NumberRange = function(p70, p71) -- Line: 152, Name: NumberRange
        local Min = p70.Min;
        local Max = p70.Max;
        local u72 = p71.Min - Min;
        local u73 = p71.Max - Max;

        return function(p74) -- Line: 156
            -- upvalues: Min (copy), u72 (copy), Max (copy), u73 (copy)
            return NumberRange.new(Min + p74 * u72, Max + p74 * u73);
        end;
    end,

    NumberSequenceKeypoint = function(p75, p76) -- Line: 161, Name: NumberSequenceKeypoint
        local Time = p75.Time;
        local Value = p75.Value;
        local Envelope = p75.Envelope;
        local u77 = p76.Time - Time;
        local u78 = p76.Value - Value;
        local u79 = p76.Envelope - Envelope;

        return function(p80) -- Line: 165
            -- upvalues: Time (copy), u77 (copy), Value (copy), u78 (copy), Envelope (copy), u79 (copy)
            return NumberSequenceKeypoint.new(Time + p80 * u77, Value + p80 * u78, Envelope + p80 * u79);
        end;
    end,

    PhysicalProperties = function(p81, p82) -- Line: 170, Name: PhysicalProperties
        local Density = p81.Density;
        local Elasticity = p81.Elasticity;
        local ElasticityWeight = p81.ElasticityWeight;
        local Friction = p81.Friction;
        local FrictionWeight = p81.FrictionWeight;
        local u83 = p82.Density - Density;
        local u84 = p82.Elasticity - Elasticity;
        local u85 = p82.ElasticityWeight - ElasticityWeight;
        local u86 = p82.Friction - Friction;
        local u87 = p82.FrictionWeight - FrictionWeight;

        return function(p88) -- Line: 176
            -- upvalues: Density (copy), u83 (copy), Elasticity (copy), u84 (copy), ElasticityWeight (copy), u85 (copy), Friction (copy), u86 (copy), FrictionWeight (copy), u87 (copy)
            return PhysicalProperties.new(Density + p88 * u83, Elasticity + p88 * u84, ElasticityWeight + p88 * u85, Friction + p88 * u86, FrictionWeight + p88 * u87);
        end;
    end,

    Ray = function(p89, p90) -- Line: 187, Name: Ray
        local Origin = p89.Origin;
        local Direction = p89.Direction;
        local Origin2 = p90.Origin;
        local Direction2 = p90.Direction;
        local X = Origin.X;
        local Y = Origin.Y;
        local Z = Origin.Z;
        local X2 = Direction.X;
        local Y2 = Direction.Y;
        local Z2 = Direction.Z;
        local u91 = Origin2.X - X;
        local u92 = Origin2.Y - Y;
        local u93 = Origin2.Z - Z;
        local u94 = Direction2.X - X2;
        local u95 = Direction2.Y - Y2;
        local u96 = Direction2.Z - Z2;

        return function(p97) -- Line: 192
            -- upvalues: X (copy), u91 (copy), Y (copy), u92 (copy), Z (copy), u93 (copy), X2 (copy), u94 (copy), Y2 (copy), u95 (copy), Z2 (copy), u96 (copy)
            return Ray.new(Vector3.new(X + p97 * u91, Y + p97 * u92, Z + p97 * u93), (Vector3.new(X2 + p97 * u94, Y2 + p97 * u95, Z2 + p97 * u96)));
        end;
    end,

    UDim = function(p98, p99) -- Line: 200, Name: UDim
        local Scale = p98.Scale;
        local Offset = p98.Offset;
        local u100 = p99.Scale - Scale;
        local u101 = p99.Offset - Offset;

        return function(p102) -- Line: 204
            -- upvalues: Scale (copy), u100 (copy), Offset (copy), u101 (copy)
            return UDim.new(Scale + p102 * u100, Offset + p102 * u101);
        end;
    end,

    UDim2 = RobloxLerp,
    Vector2 = RobloxLerp,
    Vector3 = RobloxLerp,

    Rect = function(u103, u104) -- Line: 212, Name: Rect
        return function(p105) -- Line: 213
            -- upvalues: u103 (copy), u104 (copy)
            return Rect.new(u103.Min.X + p105 * (u104.Min.X - u103.Min.X), u103.Min.Y + p105 * (u104.Min.Y - u103.Min.Y), u103.Max.X + p105 * (u104.Max.X - u103.Max.X), u103.Max.Y + p105 * (u104.Max.Y - u103.Max.Y));
        end;
    end,

    Region3 = function(u106, u107) -- Line: 223, Name: Region3
        return function(p108) -- Line: 224
            -- upvalues: u106 (copy), u107 (copy)
            local v109 = u106.CFrame * (-u106.Size / 2);
            local v110 = v109 + p108 * (u107.CFrame * (-u107.Size / 2) - v109);
            local v111 = u106.CFrame * (u106.Size / 2);
            local v112 = v111 + p108 * (u107.CFrame * (u107.Size / 2) - v111);
            local X = v110.X;
            local X2 = v112.X;
            local Y = v110.Y;
            local Y2 = v112.Y;
            local Z = v110.Z;
            local Z2 = v112.Z;
            local new = Region3.new;
            local v113 = Vector3.new(X < X2 and X and X or X2, Y < Y2 and Y and Y or Y2, Z < Z2 and Z and Z or Z2);

            if X2 < X then
                X2 = X or X2;
            end;

            if Y2 < Y then
                Y2 = Y or Y2;
            end;

            if Z2 < Z then
                Z2 = Z or Z2;
            end;

            return new(v113, (Vector3.new(X2, Y2, Z2)));
        end;
    end,

    NumberSequence = function(u114, u115) -- Line: 250, Name: NumberSequence
        -- upvalues: u1 (copy), SortByTime (copy)
        return function(p116) -- Line: 251
            -- upvalues: u1 (ref), u114 (copy), u115 (copy), SortByTime (ref)
            local v117 = {};
            local v118 = 0;
            local v119 = {};

            for _, v in u1(u114.Keypoints) do
                local v120 = nil;
                local v121 = nil;

                for _, v2 in u1(u115.Keypoints) do
                    if v2.Time == v.Time then
                        v120 = v2;
                        v121 = v120;
                        local v122 = v120;
                        v120 = v121;
                        v122 = v121;
                        break;
                    end;

                    if v2.Time < v.Time and (v120 == nil or v2.Time > v120.Time) then
                        v120 = v2;
                    elseif v2.Time > v.Time and (v121 == nil or v2.Time < v121.Time) then
                        v121 = v2;
                    end;
                end;

                local v123, v124;

                if v121 == v120 then
                    v123 = v121.Value;
                    v124 = v121.Envelope;
                else
                    local v125 = (v.Time - v120.Time) / (v121.Time - v120.Time);
                    v123 = (v121.Value - v120.Value) * v125 + v120.Value;
                    v124 = (v121.Envelope - v120.Envelope) * v125 + v120.Envelope;
                end;

                v118 = v118 + 1;
                v119[v118] = NumberSequenceKeypoint.new(v.Time, (v123 - v.Value) * p116 + v.Value, (v124 - v.Envelope) * p116 + v.Envelope);
                v117[v.Time] = true;
            end;

            for _, v in u1(u115.Keypoints) do
                if not v117[v.Time] then
                    local v126 = nil;
                    local v127 = nil;

                    for _, v2 in u1(u114.Keypoints) do
                        if v2.Time == v.Time then
                            v126 = v2;
                            v127 = v126;
                            local v128 = v126;
                            v126 = v127;
                            v128 = v127;
                            break;
                        end;

                        if v2.Time < v.Time and (v126 == nil or v2.Time > v126.Time) then
                            v126 = v2;
                        elseif v2.Time > v.Time and (v127 == nil or v2.Time < v127.Time) then
                            v127 = v2;
                        end;
                    end;

                    local v129, v130;

                    if v127 == v126 then
                        v129 = v127.Value;
                        v130 = v127.Envelope;
                    else
                        local v131 = (v.Time - v126.Time) / (v127.Time - v126.Time);
                        v129 = (v127.Value - v126.Value) * v131 + v126.Value;
                        v130 = (v127.Envelope - v126.Envelope) * v131 + v126.Envelope;
                    end;

                    v118 = v118 + 1;
                    v119[v118] = NumberSequenceKeypoint.new(v.Time, (v.Value - v129) * p116 + v129, (v.Envelope - v130) * p116 + v130);
                end;
            end;

            table.sort(v119, SortByTime);

            return NumberSequence.new(v119);
        end;
    end,

    ColorSequence = function(u132, u133) -- Line: 326, Name: ColorSequence
        -- upvalues: u1 (copy), Color3Lerp (copy), SortByTime (copy)
        return function(p134) -- Line: 327
            -- upvalues: u1 (ref), u132 (copy), u133 (copy), Color3Lerp (ref), SortByTime (ref)
            local v135 = {};
            local v136 = 0;
            local v137 = {};

            for _, v in u1(u132.Keypoints) do
                local v138 = nil;
                local v139 = nil;

                for _, v2 in u1(u133.Keypoints) do
                    if v2.Time == v.Time then
                        v138 = v2;
                        v139 = v138;
                        local v140 = v138;
                        v138 = v139;
                        v140 = v139;
                        break;
                    end;

                    if v2.Time < v.Time and (v138 == nil or v2.Time > v138.Time) then
                        v138 = v2;
                    elseif v2.Time > v.Time and (v139 == nil or v2.Time < v139.Time) then
                        v139 = v2;
                    end;
                end;

                local v141;

                if v139 == v138 then
                    v141 = v139.Value;
                else
                    v141 = Color3Lerp(v138.Value, v139.Value)((v.Time - v138.Time) / (v139.Time - v138.Time));
                end;

                v136 = v136 + 1;
                v137[v136] = ColorSequenceKeypoint.new(v.Time, Color3Lerp(v.Value, v141)(p134));
                v135[v.Time] = true;
            end;

            for _, v in u1(u133.Keypoints) do
                if not v135[v.Time] then
                    local v142 = nil;
                    local v143 = nil;

                    for _, v2 in u1(u132.Keypoints) do
                        if v2.Time == v.Time then
                            v142 = v2;
                            v143 = v142;
                            local v144 = v142;
                            v142 = v143;
                            v144 = v143;
                            break;
                        end;

                        if v2.Time < v.Time and (v142 == nil or v2.Time > v142.Time) then
                            v142 = v2;
                        elseif v2.Time > v.Time and (v143 == nil or v2.Time < v143.Time) then
                            v143 = v2;
                        end;
                    end;

                    local v145;

                    if v143 == v142 then
                        v145 = v143.Value;
                    else
                        v145 = Color3Lerp(v142.Value, v143.Value)((v.Time - v142.Time) / (v143.Time - v142.Time));
                    end;

                    v136 = v136 + 1;
                    v137[v136] = ColorSequenceKeypoint.new(v.Time, Color3Lerp(v.Value, v145)(p134));
                end;
            end;

            table.sort(v137, SortByTime);

            return ColorSequence.new(v137);
        end;
    end
}, {
    __index = function(p146, p147) -- Line: 394, Name: __index
        error("No lerp function is defined for type " .. tostring(p147) .. ".", 4);
    end,

    __newindex = function(p148, p149) -- Line: 398, Name: __newindex
        error("No lerp function is defined for type " .. tostring(p149) .. ".", 4);
    end
});