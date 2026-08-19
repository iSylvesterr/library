-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local u1 = {};

function lerp(u2, u3, u4)
    -- upvalues: u1 (ref)
    local v5 = typeof(u2) == typeof(u3);
    assert(v5, "Type mismatch");
    local v6 = typeof(u4) == "number";
    assert(v6, "Bad alpha");

    return (u1[typeof(u2)] or function() -- Line: 10
        -- upvalues: u2 (copy), u3 (copy), u4 (copy)
        return u2:Lerp(u3, u4);
    end)(u2, u3, u4);
end;

function sequence(p7, p8, p9)
    local function eval(p10, p11) -- Line: 25
        local Keypoints = p10.Keypoints;

        if p11 == 0 then
            return Keypoints[1].Value;
        end;

        if p11 == 1 then
            return Keypoints[#p10.Keypoints].Value;
        end;

        for i = 1, #Keypoints - 1 do
            local v12 = Keypoints[i];
            local v13 = Keypoints[i + 1];

            if v12.Time <= p11 and p11 < v13.Time then
                local v14 = (p11 - v12.Time) / (v13.Time - v12.Time);

                if typeof(p10) == "ColorSequence" then
                    return Color3.new((v13.Value.R - v12.Value.R) * v14 + v12.Value.R, (v13.Value.G - v12.Value.G) * v14 + v12.Value.G, (v13.Value.B - v12.Value.B) * v14 + v12.Value.B);
                end;

                if typeof(p10) == "NumberSequence" then
                    return (v13.Value - v12.Value) * v14 + v12.Value;
                end;

                break;
            end;
        end;

        return nil;
    end;

    local v15 = {};
    local v16 = {};

    for _, v in ipairs(p7.Keypoints) do
        if typeof(p7) == "NumberSequence" then
            v16[v.Time] = { v.Envelope, (eval(p8, v.Time)) };
        end;

        v15[v.Time] = { v.Value, (eval(p8, v.Time)) };
    end;

    for _, v in ipairs(p8.Keypoints) do
        if typeof(p7) == "NumberSequence" then
            if v16[v.Time] then
                v16[v.Time][2] = v.Envelope;
            else
                eval(p7, v.Time);
                v16[v.Time] = { 0, v.Envelope };
            end;
        end;

        if v15[v.Time] then
            v15[v.Time][2] = v.Value;
        else
            v15[v.Time] = { eval(p7, v.Time), v.Value };
        end;
    end;

    local v17 = {};

    for i, _ in pairs(v15) do
        table.insert(v17, i);
    end;

    table.sort(v17, function(p18, p19) -- Line: 85
        return p18 < p19;
    end);
    local v20 = {};

    for _, v in ipairs(v17) do
        local v21 = v15[v];
        local v22 = nil;

        if typeof(p7) == "NumberSequence" then
            local v23 = v16[v];
            v22 = NumberSequenceKeypoint.new(v, lerp(v21[1], v21[2], p9), lerp(v23[1], v23[2], p9));
        elseif typeof(p7) == "NumberSequence" then
            v22 = NumberSequenceKeypoint.new(v, lerp(v21[1], v21[2], p9));
        elseif typeof(p7) == "ColorSequence" then
            local v24 = v21[1];
            local v25 = v21[2];
            local v26;

            if v24 == nil then
                v26 = false;
            else
                v26 = typeof(v24) == "Color3";
            end;

            assert(v26);
            local v27;

            if v25 == nil then
                v27 = false;
            else
                v27 = typeof(v25) == "Color3";
            end;

            assert(v27);
            local v28 = lerp(v24, v25, p9);
            local v29;

            if v28 == nil then
                v29 = false;
            else
                v29 = typeof(v28) == "Color3";
            end;

            assert(v29);
            v22 = ColorSequenceKeypoint.new(v, v28);
        end;

        table.insert(v20, v22);
    end;

    if typeof(p7) == "NumberSequence" then
        return NumberSequence.new(v20);
    end;

    if typeof(p7) == "ColorSequence" then
        return ColorSequence.new(v20);
    end;

    return p7;
end;

u1 = {
    number = function(p30, p31, p32) -- Line: 123
        return (p31 - p30) * p32 + p30;
    end,

    string = function(p33, p34, p35) -- Line: 126
        local v36 = string.len(p33);
        local v37 = string.len(p34);
        local v38 = math.max(v36, v37);
        local v39 = math.ceil(v38 * p35);

        if v39 == v38 then
            return p34;
        end;

        local v40 = string.sub(p34, 1, v39);
        local v41 = string.len(p33);
        local v42 = math.max(v39, v41);
        local v43 = string.sub(p33, v39, v42);

        if string.len(v43) < string.len(v40) and string.len(v40) < v39 then
            v43 = string.rep(" ", v39 - string.len(v40) - 1) .. v43;
        end;

        return v40 .. v43;
    end,

    boolean = function(p44, p45, p46) -- Line: 139
        if p46 >= 0.5 then
            return p44;
        end;

        return p45;
    end,

    Color3 = function(p47, p48, p49) -- Line: 146
        local function to(p50) -- Line: 148
            local v51 = (p50.R * 0.4122214708 + p50.G * 0.5363325363 + p50.B * 0.0514459929) ^ 0.3333333333333333;
            local v52 = (p50.R * 0.2119034982 + p50.G * 0.6806995451 + p50.B * 0.1073969566) ^ 0.3333333333333333;
            local v53 = (p50.R * 0.0883024619 + p50.G * 0.2817188376 + p50.B * 0.6299787005) ^ 0.3333333333333333;

            return Vector3.new(v51 * 0.2104542553 + v52 * 0.793617785 - v53 * 0.0040720468, v51 * 1.9779984951 - v52 * 2.428592205 + v53 * 0.4505937099, v51 * 0.0259040371 + v52 * 0.7827717662 - v53 * 0.808675766);
        end;

        return (function(p54, p55) -- Line: 166, Name: from
            local v56 = (p54.X + p54.Y * 0.3963377774 + p54.Z * 0.2158037573) ^ 3;
            local v57 = (p54.X - p54.Y * 0.1055613458 - p54.Z * 0.0638541728) ^ 3;
            local v58 = (p54.X - p54.Y * 0.0894841775 - p54.Z * 1.291485548) ^ 3;
            local v59 = v56 * 4.0767416621 - v57 * 3.3077115913 + v58 * 0.2309699292;
            local v60 = v56 * -1.2684380046 + v57 * 2.6097574011 - v58 * 0.3413193965;
            local v61 = v56 * -0.0041960863 - v57 * 0.7034186147 + v58 * 1.707614701;

            if not p55 then
                v59 = math.clamp(v59, 0, 1);
                v60 = math.clamp(v60, 0, 1);
                v61 = math.clamp(v61, 0, 1);
            end;

            return Color3.new(v59, v60, v61);
        end)(to(p47):Lerp(to(p48), p49));
    end,

    BrickColor = function(p62, p63, p64) -- Line: 191
        local v65 = Color3.new(p62.r, p62.g, p62.b);
        local v66 = Color3.new(p63.r, p63.g, p63.b);

        return BrickColor.new(v65:Lerp(v66, p64));
    end,

    ColorSequence = function(p67, p68, p69) -- Line: 196
        local v70 = sequence(p67, p68, p69);
        local v71 = typeof(v70) == "ColorSequence";
        assert(v71, "Bad ColorSequence");

        return v70;
    end,

    NumberSequence = function(p72, p73, p74) -- Line: 201
        local v75 = sequence(p72, p73, p74);
        local v76 = typeof(v75) == "NumberSequence";
        assert(v76, "Bad NumberSequence");

        return v75;
    end,

    ColorSequenceKeypoint = function(p77, p78, p79) -- Line: 206
        local v80 = lerp(p77.Time, p78.Time, p79);
        local v81 = lerp(p77.Value, p78.Value, p79);

        return ColorSequenceKeypoint.new(v80, v81);
    end,

    NumberSequenceKeypoint = function(p82, p83, p84) -- Line: 216
        local v85 = lerp(p82.Time, p83.Time, p84);
        local v86 = lerp(p82.Value, p83.Value, p84);

        return NumberSequenceKeypoint.new(v85, v86);
    end,

    DateTime = function(p87, p88, p89) -- Line: 225
        return DateTime.fromUnixTimestampMillis(lerp(p87.UnixTimestampMillis, p88.UnixTimestampMillis, p89));
    end,

    EnumItem = function(p90, p91, p92) -- Line: 230
        assert(p90.EnumType == p91.EnumType, "EnumType mismatch");
        local v93 = p90.EnumType:GetEnumItems();
        local v94 = lerp(p90.Value, p91.Value, p92);
        local v95 = math.round(v94);

        return v93[math.clamp(v95, 0, #v93 - 1) + 1];
    end,

    NumberRange = function(p96, p97, p98) -- Line: 237
        local v99 = lerp(p96.Min, p97.Min, p98);
        local v100 = lerp(p96.Max, p97.Max, p98);

        return NumberRange.new(v99, v100);
    end,

    PathWaypoint = function(p101, p102, p103) -- Line: 242
        local v104 = lerp(p101.Position, p102.Position, p103);
        local v105 = lerp(p101.Action, p102.Action, p103);

        return PathWaypoint.new(v104, v105);
    end,

    PhysicalProperties = function(p106, p107, p108) -- Line: 247
        local v109 = lerp(p106.Density, p107.Density, p108);
        local v110 = lerp(p106.Friction, p107.Friction, p108);
        local v111 = lerp(p106.Elasticity, p107.Elasticity, p108);
        local v112 = lerp(p106.FrictionWeight, p107.FrictionWeight, p108);
        local v113 = lerp(p106.ElasticityWeight, p107.ElasticityWeight, p108);

        return PhysicalProperties.new(v109, v110, v111, v112, v113);
    end,

    Ray = function(p114, p115, p116) -- Line: 260
        local v117 = lerp(p114.Origin, p115.Origin, p116);
        local v118 = lerp(p114.Direction, p115.Direction, p116);

        return Ray.new(v117, v118);
    end,

    Rect = function(p119, p120, p121) -- Line: 266
        local v122 = lerp(p119.Min, p120.Min, p121);
        local v123 = lerp(p119.Max, p120.Max, p121);

        return Rect.new(v122, v123);
    end,

    Region3 = function(p124, p125, p126) -- Line: 272
        local Position = (p124.CFrame * CFrame.new(-p124.Size * 0.5 / 2)).Position;
        local Position2 = (p125.CFrame * CFrame.new(-p125.Size * 0.5 / 2)).Position;
        local Position3 = (p124.CFrame * CFrame.new(p124.Size * 0.5 / 2)).Position;
        local Position4 = (p125.CFrame * CFrame.new(p125.Size * 0.5 / 2)).Position;
        local v127 = lerp(Position, Position2, p126);
        local v128 = lerp(Position3, Position4, p126);

        return Region3.new(v127, v128);
    end,

    Region3int16 = function(p129, p130, p131) -- Line: 284
        local v132 = lerp(p129.Min, p130.Min, p131);
        local v133 = lerp(p129.Max, p130.Max, p131);

        return Region3.new(v132, v133);
    end,

    UDim = function(p134, p135, p136) -- Line: 290
        local v137 = lerp(p134.Scale, p135.Scale, p136);
        local v138 = lerp(p134.Offset, p135.Offset, p136);

        return UDim.new(v137, v138);
    end,

    UDim2 = function(p139, p140, p141) -- Line: 295
        local v142 = lerp(p139.X, p140.X, p141);
        local v143 = lerp(p139.Y, p140.Y, p141);

        return UDim2.new(v142, v143);
    end
};

return lerp;