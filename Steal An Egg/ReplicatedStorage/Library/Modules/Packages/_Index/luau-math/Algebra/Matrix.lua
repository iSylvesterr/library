-- Decompiled with Potassium's decompiler.

local u1 = {};
local Vector = require(script.Parent.Vector);

function u1.new(...) -- Line: 22
    -- upvalues: Vector (copy), u1 (copy)
    local v2 = {
        _vectors = { ... }
    };
    v2.Dimensions = Vector.new(#v2._vectors, v2._vectors[1].Size);
    v2.Type = "Matrix";
    v2.Magnitude = 0;

    for _, v in ipairs(v2._vectors) do
        v2.Magnitude = v2.Magnitude + v.Magnitude;
    end;

    setmetatable(v2, u1);

    return v2;
end;

function u1.__index(p3, p4) -- Line: 46
    -- upvalues: u1 (copy)
    if p4 == "_vectors" then
        error("Don\'t try to index private variables");
    end;

    return rawget(p3, p4) or (rawget(p3, "_vectors")[p4] or rawget(u1, p4));
end;

function u1.__newindex(p5, p6, p7) -- Line: 54
    error("You can\'t change values of this vector post-construction");
end;

function u1.ToVectors(p8) -- Line: 59
    local v9 = {};

    for _, v in ipairs((rawget(p8, "_vectors"))) do
        table.insert(v9, v);
    end;

    return v9;
end;

function u1.__add(p10, p11) -- Line: 68
    -- upvalues: Vector (copy), u1 (copy)
    local v12 = {};

    for i, v in ipairs((rawget(p10, "_vectors"))) do
        local Type = p11.Type;
        local v13 = typeof(p11) == "table";
        assert(v13);
        local v14 = p11[i];

        if typeof(v14) == "table" and Type == "Matrix" then
            local v15 = typeof(v14) ~= "number";
            assert(v15);
            local v16 = getmetatable(v14) == Vector;
            assert(v16);
            v12[i] = v + v14;
        else
            local v17 = typeof(v14) == "number";
            assert(v17);
            v12[i] = v + v14;
        end;
    end;

    return u1.new(unpack(v12));
end;

function u1.__sub(p18, p19) -- Line: 93
    -- upvalues: u1 (copy)
    local v20 = {};

    for i, v in ipairs((rawget(p18, "_vectors"))) do
        local Type = p19.Type;
        local v21 = typeof(p19) == "table";
        assert(v21);
        local v22 = p19[i];

        if typeof(v22) == "table" and Type == "Matrix" then
            local v23 = typeof(v22) ~= "number";
            assert(v23);
            v20[i] = v + v22;
        else
            local v24 = typeof(v22) == "number";
            assert(v24);
            v20[i] = v + v22;
        end;
    end;

    return u1.new(unpack(v20));
end;

function u1.__mul(p25, p26) -- Line: 115
    -- upvalues: Vector (copy), u1 (copy)
    if typeof(p26) == "table" then
        assert(p26.Type == "Matrix" and true or p26.Type == "Vector");

        if p26.Type == "Matrix" then
            assert(p25.Dimensions[1] == p25.Dimensions[2], "Bad square matrix");
            assert(p26.Dimensions == p25.Dimensions, "Bad matrix match");
            local v27 = p26:ToVectors();
            local v28 = {};

            for i, v in ipairs(p25:ToRows()) do
                local v29 = v:ToScalars();
                v28[i] = v28[i] or {};

                for i2, _ in ipairs(v29) do
                    local v30 = v27[i2]:ToScalars();
                    local v31 = 0;

                    for i3, v2 in ipairs(v29) do
                        v31 = v31 + v2 * v30[i3];
                    end;

                    v28[i][i2] = v31;
                end;

                v28[i] = Vector.new(unpack(v28[i]));
            end;

            return u1.new(unpack(v28)):Transpose();
        end;

        if p26.Type == "Vector" then
            local v32 = p26:GetScalars();
            local v33 = {};

            for i, v in ipairs((rawget(p25, "_vectors"))) do
                local v34 = v32[i];
                v33[i] = 0;

                for _, v2 in ipairs(v:GetScalars()) do
                    v33[i] = v33[i] + v34 * v2;
                end;
            end;

            return v33;
        end;
    else
        if typeof(p26) == "number" then
            local v35 = {};

            for i, v in ipairs((rawget(p25, "_vectors"))) do
                v35[i] = v * p26;
            end;

            return u1.new(unpack(v35));
        end;

        error("Bad value");
    end;

    return nil;
end;

function u1.__div(p36, p37) -- Line: 169
    -- upvalues: u1 (copy)
    if typeof(p37) == "table" and p37.Type == "Matrix" then
        error("I didn\'t code matrix division");

        return;
    end;

    if typeof(p37) == "number" then
        local v38 = {};

        for i, v in ipairs((rawget(p36, "_vectors"))) do
            v38[i] = v / p37;
        end;

        return u1.new(unpack(v38));
    end;

    error("Bad value");
end;

function u1.__pow(p39, p40) -- Line: 184
    -- upvalues: u1 (copy)
    if typeof(p40) == "table" then
        local v41 = {};

        for i, v in ipairs((rawget(p39, "_vectors"))) do
            v41[i] = v ^ p40[i];
        end;

        return u1.new(unpack(v41));
    end;

    if typeof(p40) == "number" then
        local v42 = {};

        for i, v in ipairs((rawget(p39, "_vectors"))) do
            v42[i] = v ^ p40;
        end;

        return u1.new(unpack(v42));
    end;

    error("Bad value");
end;

function u1.__mod(p43, p44) -- Line: 203
    -- upvalues: u1 (copy)
    if typeof(p44) == "table" then
        local v45 = {};

        for i, v in ipairs((rawget(p43, "_vectors"))) do
            v45[i] = v % p44[i];
        end;

        return u1.new(unpack(v45));
    end;

    if typeof(p44) == "number" then
        local v46 = {};

        for i, v in ipairs((rawget(p43, "_vectors"))) do
            v46[i] = v % p44;
        end;

        return u1.new(unpack(v46));
    end;

    error("Bad value");
end;

function u1.__eq(p47, p48) -- Line: 222
    if p48 == false then
        return false;
    end;

    if typeof(p48) ~= "table" or p48.Type ~= "Matrix" then
        return false;
    end;

    for i, v in ipairs((rawget(p47, "_vectors"))) do
        if v ~= p48[i] then
            return false;
        end;
    end;

    return true;
end;

function u1.ToRows(p49) -- Line: 239
    -- upvalues: Vector (copy)
    local v50 = {};

    for _, v in ipairs((rawget(p49, "_vectors"))) do
        for i, v2 in ipairs(v:ToScalars()) do
            v50[i] = v50[i] or {};
            table.insert(v50[i], v2);
        end;
    end;

    local v51 = {};

    for i, v in ipairs(v50) do
        v51[i] = Vector.new(unpack(v));
    end;

    return v51;
end;

function u1.Transpose(p52) -- Line: 256
    -- upvalues: u1 (copy)
    local v53 = p52:ToRows();

    return u1.new(unpack(v53));
end;

function u1.__tostring(p54) -- Line: 262
    local v55 = p54:ToRows();
    local v56 = "";

    for i, v in ipairs(v55) do
        local v57 = "";

        if i ~= 1 then
            v57 = v57 .. "\n";
        end;

        for i2, v2 in ipairs(v) do
            if i2 == 1 then
                v57 = tostring(v2);
            else
                v57 = v57 .. "|" .. tostring(v2);
            end;
        end;

        v56 = v56 .. v57;
    end;

    return v56;
end;

function u1.one(p58) -- Line: 283
    -- upvalues: Vector (copy)
    local v59 = {};

    for _ = 1, p58[1] do
        table.insert(v59, Vector.one(p58[2]));
    end;

    return Vector.new(unpack(v59));
end;

function u1.identity(p60) -- Line: 292
    -- upvalues: Vector (copy)
    local v61 = {};

    for i = 1, p60[1] do
        table.insert(v61, Vector.identity(p60[2], i));
    end;

    return Vector.new(unpack(v61));
end;

return u1;