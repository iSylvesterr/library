-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
require(script.Parent.Parent.Types);
local Vector = require(script.Parent.Parent.Algebra.Vector);
local Matrix = require(script.Parent.Parent.Algebra.Matrix);

function u1.translateVector(p2) -- Line: 17
    -- upvalues: Vector (copy)
    assert(p2 ~= nil);

    if typeof(p2) == "Vector2" then
        return Vector.new(p2.X, p2.Y);
    end;

    if typeof(p2) == "Vector3" then
        return Vector.new(p2.X, p2.Y, p2.Z);
    end;

    local v3;

    if typeof(p2) == "Vector2" then
        v3 = false;
    else
        v3 = typeof(p2) ~= "Vector3";
    end;

    assert(v3);
    local v4 = getmetatable(p2) == Vector;
    assert(v4);

    return p2;
end;

function u1.__newindex(p5, p6, p7) -- Line: 29
    if p5[p6] == nil then
        error(tostring(p6) .. " is not a valid solver property");
    else
        rawset(p5, p6, p7);
    end;

    return nil;
end;

function u1._Rand(p8, p9) -- Line: 39
    local v10 = p9:ToScalars();
    local Seed = p8.Seed;

    for i, v in ipairs(v10) do
        Seed = Seed + 1 * Random.new(i * v * 1000):NextInteger(1, 100000) % (Seed / 100);
    end;

    return Random.new(Seed):NextNumber();
end;

function u1._SetSeparationLimit(p11) -- Line: 48
    -- upvalues: Vector (copy)
    local Points = p11.Points;

    if #Points <= 1 then
        rawset(p11, "SeparationLimit", 0);

        return nil;
    end;

    local u12 = {};

    local function setClosest(p13) -- Line: 56
        -- upvalues: Points (copy), Vector (ref), u12 (copy)
        local v14 = nil;
        local v15 = (1 / 0);

        for _, v in ipairs(Points) do
            local v16 = getmetatable(v) == Vector;
            assert(v16);

            if not Vector.__eq(v, p13) then
                local Magnitude = Vector.__sub(v, p13).Magnitude;

                if Magnitude and (not v14 or Magnitude < v15) then
                    v15 = Magnitude;
                    v14 = v;
                end;
            end;
        end;

        table.insert(u12, v15);
    end;

    for _, v in ipairs(Points) do
        setClosest(v);
    end;

    local v17 = u12[1];

    for _, v in ipairs(u12) do
        v17 = math.max(v, v17);
    end;

    rawset(p11, "SeparationLimit", v17);

    return nil;
end;

function u1._CopyConfiguration(p18, p19) -- Line: 83
    for i, v in pairs(p18) do
        if typeof(v) == "number" or typeof(v) == "EnumItem" then
            p19[i] = v;
        elseif typeof(v) == "table" then
            local v20 = {};

            if i == "Octaves" then
                for i2, v2 in pairs(v) do
                    v20[i2] = v2:Clone();
                end;
            else
                for i2, v2 in pairs(v) do
                    v20[i2] = v2;
                end;
            end;

            p18[i] = v20;
        end;
    end;

    return nil;
end;

function u1.ToMatrix(p21, p22) -- Line: 105
    -- upvalues: Vector (copy), Matrix (copy)
    local v23 = 0;
    local v24 = 0;
    local v25 = {};

    for i = 1, p22 do
        local v26 = {};

        for i2 = 1, p22 do
            local v27 = tick();
            v26[i2] = p21:Get(Vector.new(i - 1, i2 - 1) / p22);
            v23 = v23 + (tick() - v27);
            v24 = v24 + 1;
        end;

        v25[i] = Vector.new(unpack(v26));
    end;

    return Matrix.new(unpack(v25));
end;

function u1.Debug(p28, p29, p30, p31, p32, p33) -- Line: 124
    -- upvalues: Vector (copy)
    local v34 = p30 or 1;
    assert(v34 ~= nil);
    local v35 = p32 or p31;
    local v36 = p33 or v35;

    for i, v in ipairs(p31:ToVectors()) do
        for i2, v2 in ipairs(v:ToScalars()) do
            local v37 = v35[i][i2];
            local v38 = v36[i][i2];
            local Frame = Instance.new("Frame");
            Frame.Name = tostring(Vector.new(i, i2));
            Frame:SetAttribute("R", v2);
            Frame:SetAttribute("G", v37);
            Frame:SetAttribute("B", v38);
            Frame.BackgroundColor3 = Color3.new(math.clamp(v2, 0, 1), math.clamp(v37, 0, 1), (math.clamp(v38, 0, 1)));
            Frame.Position = UDim2.fromOffset(i * v34, i2 * v34);
            Frame.AnchorPoint = Vector2.new(0.5, 0.5);
            Frame.Size = UDim2.fromOffset(1 * v34, 1 * v34);
            Frame.BorderSizePixel = 0;
            Frame.Parent = p29;
        end;
    end;

    return nil;
end;

function u1._Compile(p39, p40, p41) -- Line: 150
    local v42 = 0;

    for _, v in pairs(p39.Octaves) do
        v42 = v42 + v:Get(p40);
    end;

    return p39.Amplitude * (p41 + v42);
end;

function u1._UpdateOctaves(p43) -- Line: 158
    for i, v in ipairs(p43.Octaves) do
        v:Set(nil, p43.Frequency * p43.Lacunarity ^ i, p43.Amplitude * p43.Persistence ^ i);
    end;

    return nil;
end;

function u1._TranslatePoints(p44, p45) -- Line: 172
    -- upvalues: u1 (copy)
    local v46 = {};

    for _, v in ipairs(p45) do
        table.insert(v46, u1.translateVector(v));
    end;

    return v46;
end;

function u1.GeneratePoints(p47, p48, p49, p50) -- Line: 181
    -- upvalues: Vector (copy)
    assert(p48 > 0, "Bad count");
    local v51 = getmetatable(p49) == Vector;
    assert(v51);
    local v52 = getmetatable(p50) == Vector;
    assert(v52);
    local v53 = Vector.__sub(p50, p49);
    local v54 = Random.new(p47.Seed);
    local v55 = {};

    for _ = 1, p48 do
        local v56 = {};

        for i = 1, v53.Size do
            v56[i] = p49[i] + v54:NextNumber() * v53[i];
        end;

        table.insert(v55, Vector.new(unpack(v56)));
    end;

    rawset(p47, "Points", v55);
    p47:_SetSeparationLimit();

    return nil;
end;

function u1.SetPoints(p57, p58) -- Line: 202
    assert(p58 ~= nil, "Bad point vectors");
    rawset(p57, "Points", p57:_TranslatePoints(p58));
    p57:_SetSeparationLimit();

    return nil;
end;

function u1.InsertOctave(p59, p60) -- Line: 210
    assert(p60 ~= nil, "Bad octave solver");
    table.insert(p59.Octaves, p60);
    p59:_UpdateOctaves();

    return nil;
end;

function u1.SetPersistence(p61, p62) -- Line: 218
    local v63;

    if p62 == nil then
        v63 = false;
    else
        v63 = type(p62) == "number";
    end;

    assert(v63, "Bad persistence");
    rawset(p61, "Persistence", p62 or p61.Persistence);
    p61:_UpdateOctaves();

    return nil;
end;

function u1.SetLacunarity(p64, p65) -- Line: 226
    local v66;

    if p65 == nil then
        v66 = false;
    else
        v66 = type(p65) == "number";
    end;

    assert(v66, "Bad lacunarity");
    rawset(p64, "Lacunarity", p65 or p64.Lacunarity);
    p64:_UpdateOctaves();

    return nil;
end;

function u1.SetAmplitude(p67, p68) -- Line: 234
    local v69;

    if p68 == nil then
        v69 = false;
    else
        v69 = type(p68) == "number";
    end;

    assert(v69, "Bad amplitude");
    rawset(p67, "Amplitude", p68 or p67.Amplitude);
    p67:_UpdateOctaves();

    return nil;
end;

function u1.SetFrequency(p70, p71) -- Line: 242
    local v72;

    if p71 == nil then
        v72 = false;
    else
        v72 = type(p71) == "number";
    end;

    assert(v72, "Bad frequency");
    rawset(p70, "Frequency", p71);
    p70:_UpdateOctaves();

    return nil;
end;

function u1.SetSeed(p73, p74) -- Line: 250
    local v75;

    if p74 == nil then
        v75 = false;
    else
        v75 = type(p74) == "number";
    end;

    assert(v75, "Bad seed");
    rawset(p73, "Seed", p74);
    p73:_UpdateOctaves();

    return nil;
end;

function u1.Get(p76, p77) -- Line: 258
    local v78 = p76.translateVector(p77);

    return p76:_Compile(v78, p76:_Rand(v78));
end;

function u1.Clone(p79) -- Line: 264
    -- upvalues: u1 (copy)
    local v80 = u1.new();
    local v81 = getmetatable(v80) == u1;
    assert(v81);

    return u1:_CopyConfiguration(v80, p79);
end;

function u1.Set(p82, p83, p84, p85, p86, p87, p88) -- Line: 271
    rawset(p82, "Seed", p83 or p82.Seed);
    rawset(p82, "Amplitude", p85 or p82.Amplitude);
    rawset(p82, "Frequency", p84 or p82.Frequency);
    rawset(p82, "Persistence", p87 or p82.Persistence);
    rawset(p82, "Lacunarity", p86 or p82.Lacunarity);

    if p88 then
        local v89 = p82:_TranslatePoints(p88);
        rawset(p82, "Points", v89);
        p82:_SetSeparationLimit();
    end;

    p82:_UpdateOctaves();

    return nil;
end;

function u1._new() -- Line: 323
    -- upvalues: u1 (copy)
    local v90 = {
        Seed = 1,
        Frequency = 1,
        Amplitude = 1,
        Lacunarity = 1,
        Persistence = 1,
        SeparationLimit = 0,
        Octaves = {},
        Points = {}
    };
    setmetatable(v90, u1);

    return v90;
end;

function u1.new(p91, p92, p93, p94, p95, p96) -- Line: 341
    -- upvalues: u1 (copy)
    local v97 = u1._new();
    local v98 = getmetatable(v97) == u1;
    assert(v98);
    v97:Set(p91, p92, p93, p94, p95, p96);

    return v97;
end;

return u1;