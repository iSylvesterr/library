-- Decompiled with Potassium's decompiler.

local function MatClone(p1) -- Line: 23
    local v2 = table.clone(p1);

    for i = 1, #v2 do
        v2[i] = table.clone(v2[i]);
    end;

    return v2;
end;

local function MatZero(p3) -- Line: 31
    local v4 = table.create(p3);

    for i = 1, p3 do
        v4[i] = table.create(p3, 0);
    end;

    return v4;
end;

local function MatIdent(p5) -- Line: 39
    -- upvalues: MatZero (copy)
    local v6 = MatZero(p5);

    for i = 1, p5 do
        v6[i][i] = 1;
    end;

    return v6;
end;

local function MatMul(p7, p8) -- Line: 47
    local v9 = #p7[1];
    local v10 = #p8[1];
    local v11 = {};

    for i = 1, #p7 do
        local v12 = table.create(v10, 0);

        for i2 = 1, v10 do
            local v13 = 0;

            for i3 = 1, v9 do
                local v14 = bit32.band(p7[i][i3], p8[i3][i2]);
                v13 = bit32.bxor(v13, v14);
            end;

            v12[i2] = v13;
        end;

        v11[i] = v12;
    end;

    return v11;
end;

local function MatMulVec(p15, p16) -- Line: 64
    local v17 = #p15;
    local v18 = #p15[1];
    local v19 = table.create(v17, 0);

    for i = 1, v17 do
        local v20 = 0;

        for i2 = 1, v18 do
            local v21 = bit32.band(p15[i][i2], p16[i2]);
            v20 = bit32.bxor(v20, v21);
        end;

        v19[i] = v20;
    end;

    return v19;
end;

local function MatSum(p22, p23) -- Line: 77
    -- upvalues: MatZero (copy)
    local v24 = #p22;
    local v25 = #p22[1];
    local v26 = MatZero(v24);

    for i = 1, v24 do
        for i2 = 1, v25 do
            v26[i][i2] = bit32.bxor(p22[i][i2], p23[i][i2]);
        end;
    end;

    return v26;
end;

local function MatInverse(p27) -- Line: 88
    -- upvalues: MatClone (copy), MatZero (copy)
    local v28 = #p27;
    local v29 = MatClone(p27);
    local v30 = MatZero(v28);

    for i = 1, v28 do
        v30[i][i] = 1;
    end;

    for i = 1, v28 do
        local v31 = nil;

        for i2 = i, v28 do
            if v29[i2][i] == 1 then
                v31 = i2;
                break;
            end;
        end;

        assert(v31, "not invertible");
        local v32 = v29[i];
        v29[i] = v29[v31];
        v29[v31] = v32;
        local v33 = v30[i];
        v30[i] = v30[v31];
        v30[v31] = v33;

        for i2 = 1, v28 do
            if i2 ~= i and v29[i2][i] == 1 then
                for i3 = 1, v28 do
                    v29[i2][i3] = bit32.bxor(v29[i2][i3], v29[i][i3]);
                    v30[i2][i3] = bit32.bxor(v30[i2][i3], v30[i][i3]);
                end;
            end;
        end;
    end;

    return v30;
end;

local function MatPow(p34, p35) -- Line: 115
    -- upvalues: MatZero (copy), MatInverse (copy), MatClone (copy), MatMul (copy)
    local v36 = #p34;
    local v37 = MatZero(v36);

    for i = 1, v36 do
        v37[i][i] = 1;
    end;

    local v38;

    if p35 < 0 then
        v38 = MatInverse(p34);
    else
        v38 = MatClone(p34);
    end;

    local v39 = math.abs(p35);

    while v39 > 0 do
        if math.fmod(v39, 2) >= 0.5 then
            v37 = MatMul(v37, v38);
        end;

        v38 = MatMul(v38, v38);
        v39 = math.floor(v39 / 2);
    end;

    return v37;
end;

local function L(p40, p41) -- Line: 130
    -- upvalues: MatZero (copy)
    local v42 = MatZero(p41);

    for i = 1, p41 - p40 do
        v42[i][i + p40] = 1;
    end;

    return v42;
end;

local function R(p43, p44) -- Line: 138
    -- upvalues: MatZero (copy)
    local v45 = MatZero(p44);

    for i = p43 + 1, p44 do
        v45[i][i - p43] = 1;
    end;

    return v45;
end;

local function Embed(p46, p47, p48, p49) -- Line: 146
    -- upvalues: MatZero (copy)
    local v50 = MatZero(p47);

    for i = 1, #p46 do
        for i2 = 1, #p46[1] do
            v50[p48 + i][p49 + i2] = p46[i][i2];
        end;
    end;

    return v50;
end;

local function ToColumnVector128(p51, p52, p53, p54) -- Line: 156
    local v55 = table.create(128, 0);

    for i = 0, 31 do
        local v56 = bit32.rshift(p51, i);
        v55[32 - i] = bit32.band(v56, 1);
        local v57 = bit32.rshift(p52, i);
        v55[64 - i] = bit32.band(v57, 1);
        local v58 = bit32.rshift(p53, i);
        v55[96 - i] = bit32.band(v58, 1);
        local v59 = bit32.rshift(p54, i);
        v55[128 - i] = bit32.band(v59, 1);
    end;

    return v55;
end;

local function FromColumnVector128(p60) -- Line: 167
    local v61 = 0;
    local v62 = 0;
    local v63 = 0;
    local v64 = 0;

    for i = 0, 31 do
        local v65 = bit32.lshift(p60[32 - i], i);
        v61 = bit32.bor(v61, v65);
        local v66 = bit32.lshift(p60[64 - i], i);
        v62 = bit32.bor(v62, v66);
        local v67 = bit32.lshift(p60[96 - i], i);
        v63 = bit32.bor(v63, v67);
        local v68 = bit32.lshift(p60[128 - i], i);
        v64 = bit32.bor(v64, v68);
    end;

    return v61, v62, v63, v64;
end;

local u75 = (function() -- Line: 178, Name: BuildMatTransform
    -- upvalues: MatIdent (copy), L (copy), MatMul (copy), MatSum (copy), Embed (copy), R (copy)
    local v69 = MatIdent(32);
    local v70 = MatIdent(128);
    local v71 = MatMul(MatSum(v70, (Embed(L(11, 32), 128, 0, 0))), v70);
    local v72 = MatMul(MatSum(v70, (Embed(R(8, 32), 128, 0, 0))), v71);
    local v73 = MatMul(MatSum(v70, (Embed(v69, 128, 0, 96))), v72);
    local v74 = MatMul(MatSum(v70, (Embed(R(19, 32), 128, 0, 96))), v73);

    return MatMul(MatSum(L(32, 128), (R(96, 128))), v74);
end)();

return table.freeze({
    ToColumnVector128 = ToColumnVector128,
    FromColumnVector128 = FromColumnVector128,

    MatTransform = function() -- Line: 211, Name: MatTransform
        -- upvalues: MatClone (copy), u75 (copy)
        return MatClone(u75);
    end,

    Transform = function(p76, p77, p78, p79, p80) -- Line: 215, Name: Transform
        -- upvalues: ToColumnVector128 (copy), MatMulVec (copy), MatPow (copy), MatClone (copy), u75 (copy), FromColumnVector128 (copy)
        local v81 = ToColumnVector128(p76, p77, p78, p79);

        return FromColumnVector128((MatMulVec(MatPow(MatClone(u75), p80), v81)));
    end
});