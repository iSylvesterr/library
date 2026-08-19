-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.__index(p2, p3) -- Line: 7
    -- upvalues: u1 (copy)
    if p3 == "_scalars" then
        error("Don\'t try to index private variables");
    end;

    if p3 ~= "Unit" then
        return rawget(p2, p3) or (rawget(p2, "_scalars")[p3] or rawget(u1, p3));
    end;

    local v4 = 0;

    for _, v in ipairs((rawget(p2, "_scalars"))) do
        local v5 = math.abs(v);
        v4 = math.max(v4, v5);
    end;

    local v6 = {};

    for i, v in ipairs((rawget(p2, "_scalars"))) do
        v6[i] = v / v4;
    end;

    return u1.new(unpack(v6));
end;

function u1.__newindex(p7, p8, p9) -- Line: 27
    error("You can\'t change values of this vector post-construction");
end;

function u1.__add(p10, p11) -- Line: 32
    -- upvalues: u1 (copy)
    local v12 = {};

    for i, v in ipairs((rawget(p10, "_scalars"))) do
        if type(p11) == "table" and p11.Type == "Vector" then
            v12[i] = v + (p11[i] or 0);
        else
            v12[i] = v + p11;
        end;
    end;

    return u1.new(unpack(v12));
end;

function u1.__sub(p13, p14) -- Line: 45
    -- upvalues: u1 (copy)
    local v15 = {};

    for i, v in ipairs((rawget(p13, "_scalars"))) do
        if type(p14) == "table" and p14.Type == "Vector" then
            v15[i] = v - (p14[i] or 0);
        else
            v15[i] = v - p14;
        end;
    end;

    return u1.new(unpack(v15));
end;

function u1.__mul(p16, p17) -- Line: 58
    -- upvalues: u1 (copy)
    if typeof(p17) == "table" then
        local v18 = {};

        for i, v in ipairs((rawget(p16, "_scalars"))) do
            v18[i] = v * p17[i];
        end;

        return u1.new(unpack(v18));
    end;

    if typeof(p17) == "number" then
        local v19 = {};

        for i, v in ipairs((rawget(p16, "_scalars"))) do
            v19[i] = v * p17;
        end;

        return u1.new(unpack(v19));
    end;

    error("Bad value");
end;

function u1.__div(p20, p21) -- Line: 77
    -- upvalues: u1 (copy)
    if typeof(p21) == "table" then
        local v22 = {};

        for i, v in ipairs((rawget(p20, "_scalars"))) do
            v22[i] = v / p21[i];
        end;

        return u1.new(unpack(v22));
    end;

    if typeof(p21) == "number" then
        local v23 = {};

        for i, v in ipairs((rawget(p20, "_scalars"))) do
            v23[i] = v / p21;
        end;

        return u1.new(unpack(v23));
    end;

    error("Bad value");
end;

function u1.__pow(p24, p25) -- Line: 96
    -- upvalues: u1 (copy)
    if typeof(p25) == "table" then
        local v26 = {};

        for i, v in ipairs((rawget(p24, "_scalars"))) do
            v26[i] = v ^ p25[i];
        end;

        return u1.new(unpack(v26));
    end;

    if typeof(p25) == "number" then
        local v27 = {};

        for i, v in ipairs((rawget(p24, "_scalars"))) do
            v27[i] = v ^ p25;
        end;

        return u1.new(unpack(v27));
    end;

    error("Bad value");
end;

function u1.__mod(p28, p29) -- Line: 115
    -- upvalues: u1 (copy)
    if typeof(p29) == "table" then
        local v30 = {};

        for i, v in ipairs((rawget(p28, "_scalars"))) do
            v30[i] = v % p29[i];
        end;

        return u1.new(unpack(v30));
    end;

    if typeof(p29) == "number" then
        local v31 = {};

        for i, v in ipairs((rawget(p28, "_scalars"))) do
            v31[i] = v % p29;
        end;

        return u1.new(unpack(v31));
    end;

    error("Bad value");
end;

function u1.__eq(p32, p33) -- Line: 134
    if p33 == false then
        return false;
    end;

    if typeof(p33) ~= "table" or p33.Type ~= "Vector" then
        return false;
    end;

    for i, v in ipairs((rawget(p32, "_scalars"))) do
        if v ~= p33[i] then
            return false;
        end;
    end;

    return true;
end;

function u1.__tostring(p34) -- Line: 151
    local v35 = p34:ToScalars();
    local v36 = "[";

    for i = 1, p34.Size do
        if i ~= 1 then
            v36 = v36 .. "";
        end;

        v36 = v36 .. "" .. tostring(v35[i]) .. "";

        if i < p34.Size then
            v36 = v36 .. ",";
        end;
    end;

    return v36 .. "]";
end;

function u1.ToScalars(p37) -- Line: 168
    local v38 = {};

    for _, v in ipairs((rawget(p37, "_scalars"))) do
        local v39;

        if v == nil then
            v39 = false;
        else
            v39 = typeof(v) == "number";
        end;

        assert(v39);
        table.insert(v38, v);
    end;

    return v38;
end;

function u1.Round(p40, p41) -- Line: 178
    -- upvalues: u1 (copy)
    local v42 = typeof(p41) == "number" and true or p41 == nil;
    assert(v42);
    local v43 = p41 or 0;
    assert(v43 ~= nil);
    local v44 = 10 ^ v43;
    local v45 = {};

    for i, v in ipairs((rawget(p40, "_scalars"))) do
        v45[i] = math.round(v * v44) / v44;
    end;

    return u1.new(unpack(v45));
end;

function u1.Floor(p46, p47) -- Line: 191
    -- upvalues: u1 (copy)
    local v48 = typeof(p47) == "number" and true or p47 == nil;
    assert(v48);
    local v49 = 10 ^ (p47 or 0 or 0);
    local v50 = {};

    for i, v in ipairs((rawget(p46, "_scalars"))) do
        v50[i] = math.floor(v / v49) * v49;
    end;

    return u1.new(unpack(v50));
end;

function u1.Ceil(p51, p52) -- Line: 203
    -- upvalues: u1 (copy)
    local v53 = typeof(p52) == "number" and true or p52 == nil;
    assert(v53);
    local v54 = 10 ^ (p52 or 0 or 0);
    local v55 = {};

    for i, v in ipairs((rawget(p51, "_scalars"))) do
        v55[i] = math.ceil(v / v54) * v54;
    end;

    return u1.new(unpack(v55));
end;

function u1.Cross(p56, p57) -- Line: 215
    -- upvalues: u1 (copy)
    local v58 = type(p57) == "table";
    assert(v58);
    assert(p57.Size == p56.Size, "Size mismatch");

    if p56.Size == 3 then
        local v59 = p56[1];
        local v60 = p56[2];
        local v61 = p56[3];
        local v62 = p57[1];
        local v63 = p57[2];
        local v64 = p57[3];
        local v65;

        if v59 == nil or v60 == nil then
            v65 = false;
        else
            v65 = v61 ~= nil;
        end;

        assert(v65);
        local v66;

        if v62 == nil or v63 == nil then
            v66 = false;
        else
            v66 = v64 ~= nil;
        end;

        assert(v66);
        local v67;

        if typeof(v59) == "number" and typeof(v60) == "number" then
            v67 = typeof(v61) == "number";
        else
            v67 = false;
        end;

        assert(v67);
        local v68;

        if typeof(v62) == "number" and typeof(v63) == "number" then
            v68 = typeof(v64) == "number";
        else
            v68 = false;
        end;

        assert(v68);

        return u1.new(v60 * v64 - v63 * v61, v61 * v62 - v64 * v59, v59 * v63 - v62 * v60);
    end;

    if p56.Size == 7 then
        local v69 = p56[1];
        local v70 = p56[2];
        local v71 = p56[3];
        local v72 = p56[4];
        local v73 = p56[5];
        local v74 = p56[6];
        local v75 = p56[7];
        local v76 = p57[1];
        local v77 = p57[2];
        local v78 = p57[3];
        local v79 = p57[4];
        local v80 = p57[5];
        local v81 = p57[6];
        local v82 = p57[7];
        local v83;

        if v69 == nil or (v70 == nil or (v71 == nil or (v72 == nil or (v73 == nil or v74 == nil)))) then
            v83 = false;
        else
            v83 = v75 ~= nil;
        end;

        assert(v83);
        local v84;

        if v76 == nil or (v77 == nil or (v78 == nil or (v79 == nil or (v80 == nil or v81 == nil)))) then
            v84 = false;
        else
            v84 = v82 ~= nil;
        end;

        assert(v84);
        local v85;

        if typeof(v69) == "number" and (typeof(v70) == "number" and (typeof(v71) == "number" and (typeof(v72) == "number" and (typeof(v73) == "number" and typeof(v74) == "number")))) then
            v85 = typeof(v75) == "number";
        else
            v85 = false;
        end;

        assert(v85);
        local v86;

        if typeof(v76) == "number" and (typeof(v77) == "number" and (typeof(v78) == "number" and (typeof(v79) == "number" and (typeof(v80) == "number" and typeof(v81) == "number")))) then
            v86 = typeof(v82) == "number";
        else
            v86 = false;
        end;

        assert(v86);

        return u1.new(v70 * v79 - v72 * v77 + v71 * v82 - v75 * v78 + v73 * v81 + v74 * v81, v71 * v80 - v73 * v78 + v72 * v76 - v69 * v79 + v74 * v82 - v75 * v81, v72 * v81 - v74 * v79 + v73 * v77 - v70 * v80 + v75 * v76 - v69 * v82, v73 * v82 - v75 * v80 + v74 * v78 - v71 * v81 + v69 * v77 - v70 * v76, v74 * v76 - v69 * v81 + v75 * v79 - v72 * v82 + v70 * v78 - v71 * v77, v75 * v77 - v70 * v82 + v69 * v80 - v73 * v76 + v71 * v79 - v71 * v78, v69 * v78 - v71 * v76 + v70 * v81 - v74 * v77 + v72 * v80 - v73 * v79);
    end;

    error("Cross products are currently only supported in the 3rd and 7th dimension");
end;

function u1.DotProduct(p87, p88) -- Line: 273
    -- upvalues: u1 (copy)
    local v89 = type(p88) == "table";
    assert(v89);
    assert(p88.Size == p87.Size, "Size mismatch");
    local v90 = {};

    for i = 1, p87.Size do
        v90[i] = p87[i] * p88[i];
    end;

    return u1.new(unpack(v90));
end;

function u1.Dot(p91, p92) -- Line: 286
    local v93 = p91:DotProduct(p92);
    local v94 = 0;

    for _, v in ipairs(v93:ToScalars()) do
        v94 = v94 + v;
    end;

    return v94;
end;

function u1.Lerp(p95, p96, p97) -- Line: 296
    -- upvalues: u1 (copy)
    local v98 = {};

    for i, v in ipairs((rawget(p95, "_scalars"))) do
        v98[i] = v + (p96[i] - v) * p97;
    end;

    return u1.new(unpack(v98));
end;

function u1.ToVector3(p99) -- Line: 305
    local v100 = p99:ToScalars();

    return Vector3.new(v100[1] or 0, v100[2] or 0, v100[3] or 0);
end;

function u1.ToVector2(p101) -- Line: 311
    local v102 = p101:ToScalars();

    return Vector2.new(v102[1] or 0, v102[2] or 0);
end;

function u1.zero(p103) -- Line: 317
    -- upvalues: u1 (copy)
    local v104 = {};

    for _ = 1, p103 do
        table.insert(v104, 0);
    end;

    return u1.new(unpack(v104));
end;

function u1.fromVector3(p105) -- Line: 326
    -- upvalues: u1 (copy)
    return u1.new(p105.X, p105.Y, p105.Z);
end;

function u1.fromVector2(p106) -- Line: 331
    -- upvalues: u1 (copy)
    return u1.new(p106.X, p106.Y);
end;

function u1.one(p107) -- Line: 336
    -- upvalues: u1 (copy)
    local v108 = {};

    for _ = 1, p107 do
        table.insert(v108, 1);
    end;

    return u1.new(unpack(v108));
end;

function u1.identity(p109, p110) -- Line: 345
    -- upvalues: u1 (copy)
    local v111 = {};

    for i = 1, p109 do
        if i == p110 then
            table.insert(v111, 1);
        else
            table.insert(v111, 0);
        end;
    end;

    return u1.new(unpack(v111));
end;

function u1.new(...) -- Line: 370
    -- upvalues: u1 (copy)
    local v112 = {
        _scalars = { ... }
    };
    local v113 = typeof(v112._scalars) == "table";
    assert(v113);
    v112.Size = #v112._scalars;
    v112.Type = "Vector";
    v112.Magnitude = 0;

    for _, v in ipairs(v112._scalars) do
        v112.Magnitude = v112.Magnitude + v ^ 2;
    end;

    v112.Magnitude = math.sqrt(v112.Magnitude);
    setmetatable(v112, u1);

    return v112;
end;

return u1;