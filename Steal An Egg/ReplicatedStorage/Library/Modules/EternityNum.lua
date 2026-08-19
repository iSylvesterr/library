-- Decompiled with Potassium's decompiler.

local u1 = { 0.9999999999998099, 676.5203681218851, -1259.1392167224028, 771.3234287776531, -176.6150291621406, 12.507343278686905, -0.13857109526572012, 9.984369578019572e-6, 1.5056327351493116e-7 };

function F_Gamma(p2)
    -- upvalues: u1 (copy)
    if p2 > 171.6236 then
        return (1 / 0);
    end;

    if p2 <= 0.5 then
        return 3.141592653589793 / (math.sin(3.141592653589793 * p2) * F_Gamma(1 - p2));
    end;

    local v3 = p2 - 1;
    local v4 = v3 + 7.5;

    return (u1[1] + u1[2] / (v3 + 1) + u1[3] / (v3 + 2) + u1[4] / (v3 + 3) + u1[5] / (v3 + 4) + u1[6] / (v3 + 5) + u1[7] / (v3 + 6) + u1[8] / (v3 + 7)) * v4 ^ (v3 + 0.5 - 36) * math.exp(-v4) * v4 ^ 36 * 2.5066282746310007;
end;

function f_Lambertw(p5)
    if p5 > 1.79e308 then
        return p5;
    end;

    if p5 == 0 then
        return p5;
    end;

    if p5 == 1 then
        return 0.5671432904097838;
    end;

    local v6;

    if p5 < 10 then
        v6 = 0;
    else
        local v7 = math.log(p5);
        local v8 = math.log(p5);
        v6 = v7 - math.log(v8);
    end;

    for _ = 1, 100 do
        local v9 = (p5 * math.exp(-v6) + v6 * v6) / (v6 + 1);

        if math.abs(v9 - v6) < math.abs(v9) * 1e-10 then
            return v9;
        end;

        v6 = v9;
    end;

    error("Failed to itterate z.... at function: f_lambertw");
end;

local u10 = {};

function Cnew(p11, p12, p13)
    return {
        Sign = p11,
        Layer = p12,
        Exp = p13
    };
end;

local u14 = Cnew(0, 0, 0);
local u15 = Cnew(1, 0, 1);
local u16 = Cnew(1, -1, 1);
local u17 = Cnew(1, (1 / 0), 1);

function u10.IsNaN(p18) -- Line: 174
    -- upvalues: u16 (copy)
    local v19;

    if p18.Sign == u16.Sign and p18.Layer == u16.Layer then
        v19 = p18.Exp == u16.Exp;
    else
        v19 = false;
    end;

    return v19;
end;

function u10.IsInf(p20) -- Line: 178
    return p20.Layer == (1 / 0) and true or p20.Exp == (1 / 0);
end;

function u10.IsZero(p21) -- Line: 182
    local v22;

    if p21.Sign == 0 then
        v22 = true;
    elseif p21.Exp == 0 then
        v22 = p21.Layer == 0;
    else
        v22 = false;
    end;

    return v22;
end;

function u10.correct(p23) -- Line: 186
    -- upvalues: u10 (copy), u16 (copy), u17 (copy), u14 (copy)
    if u10.IsNaN(p23) then
        return u16;
    end;

    if u10.IsInf(p23) then
        return u17;
    end;

    if u10.IsZero(p23) then
        return u14;
    end;

    local Sign = p23.Sign;
    local Layer = p23.Layer;
    local Exp = p23.Exp;

    if Layer == 0 and Exp < 0 then
        Exp = -Exp;
        Sign = -Sign;
    end;

    if Layer == 0 and Exp < 1e-10 then
        local v24 = math.log10(Exp);

        return Cnew(Sign, Layer + 1, v24);
    end;

    local v25 = math.abs(Exp);
    local v26 = math.sign(Exp);

    if v25 >= 10000000000 then
        local v27 = v26 * math.log10(v25);

        return Cnew(Sign, Layer + 1, v27);
    end;

    while v25 < 10 and Layer > 0 do
        Layer = Layer - 1;

        if Layer == 0 then
            Exp = math.pow(10, Exp);
        else
            Exp = v26 * math.pow(10, v25);
            v25 = math.abs(Exp);
            v26 = math.sign(Exp);
        end;
    end;

    if Layer == 0 then
        if Exp < 0 then
            Exp = -Exp;
            Sign = -Sign;
        end;
    elseif Exp == 0 then
        Sign = 0;
    end;

    return Cnew(Sign, Layer, Exp);
end;

function u10.new(p28, p29, p30) -- Line: 243
    -- upvalues: u10 (copy)
    return u10.correct({
        Sign = p28,
        Layer = p29,
        Exp = p30
    });
end;

function u10.fromNumber(p31) -- Line: 247
    -- upvalues: u10 (copy)
    local v32 = {
        Sign = math.sign(p31),
        Layer = 0,
        Exp = math.abs(p31)
    };

    return u10.correct(v32);
end;

function u10.fromScientific(p33) -- Line: 255
    -- upvalues: u10 (copy), u14 (copy)
    local v34 = p33:split("e");
    local v35 = tonumber(v34[1]);
    local v36 = tonumber(v34[2]);
    local v37 = math.sign(v35);
    local v38 = math.log10(v35);
    local v39 = math.floor(v38);

    if v39 > 0 then
        v35 = v35 / 10 ^ v39;
        v36 = v36 + v39;
    end;

    if v36 == 0 then
        return u10.new(math.sign(v35), 0, v35);
    end;

    if v35 == 0 then
        return u14;
    end;

    if v35 < 0 then
        v35 = -v35;
    end;

    if v36 < 0 then
        if v36 < -100 then
            return u14;
        end;

        local v40 = math.log10(v35) + v36;

        return u10.correct(u10.new(v37, 1, v40));
    end;

    local v41 = math.log10(v35) + v36;
    local v42 = 1;

    if v41 > 10000000000 then
        v41 = math.log10(v41);
        v42 = v42 + 1;
    end;

    return u10.correct(u10.new(v37, v42, v41));
end;

function u10.fromDefaultStringFormat(p43) -- Line: 300
    -- upvalues: u10 (copy)
    local v44 = p43:split(";");
    local v45 = tonumber(v44[1]);
    local v46 = math.sign(v45);
    local v47 = tonumber(v44[1]);
    local v48 = math.abs(v47);
    local v49 = tonumber(v44[2]);

    return u10.correct(u10.new(v46 == 0 and 1 or v46, v48, v49));
end;

function u10.fromString(p50) -- Line: 311
    -- upvalues: u10 (copy), u16 (copy), u17 (copy), u14 (copy)
    if p50:find("e") and not p50:find(";") then
        return u10.fromScientific(p50);
    end;

    if p50:find(";") then
        return u10.fromDefaultStringFormat(p50);
    end;

    if p50 == "NaN" then
        return u16;
    end;

    if p50 == "Inf" then
        return u17;
    end;

    if p50 == "" then
        return u14;
    end;

    return u10.fromNumber((tonumber(p50)));
end;

function u10.toString(p51) -- Line: 331
    -- upvalues: u10 (copy)
    return u10.IsNaN(p51) and "NaN" or (u10.IsInf(p51) and "Inf" or p51.Layer .. ";" .. p51.Exp);
end;

function u10.convert(p52) -- Line: 341
    -- upvalues: u10 (copy), u14 (copy)
    if typeof(p52) == "number" then
        return u10.fromNumber(p52);
    end;

    if typeof(p52) == "string" then
        return u10.fromString(p52);
    end;

    if typeof(p52) == "table" then
        if #p52 == 2 then
            return u10.fromScientific(p52[1] .. "e" .. p52[2]);
        end;

        if #p52 == 3 then
            return u10.correct(u10.new(p52[1], p52[2], p52[3]));
        end;

        if p52.Sign then
            return u10.correct(u10.new(p52.Sign, p52.Layer, p52.Exp));
        end;
    end;

    warn("Returning DefaultReturn at EN.Convert(): Invalid input!");

    return u14;
end;

function u10.toNumber(p53) -- Line: 360
    if p53.Layer > 1 then
        if math.sign(p53.Exp) == -1 then
            return p53.Sign * 0;
        end;

        return p53.Sign * (1 / 0);
    end;

    if p53.Layer == 0 then
        return p53.Sign * p53.Exp;
    end;

    return p53.Layer ~= 1 and (0 / 0) or p53.Sign * 10 ^ p53.Exp;
end;

function u10.abs(p54) -- Line: 377
    -- upvalues: u10 (copy), u14 (copy)
    local v55 = u10.convert(p54);

    if v55.Sign == 0 then
        return u14;
    end;

    return u10.new(1, v55.Layer, v55.Exp);
end;

function u10.maxAbs(p56, p57) -- Line: 386
    -- upvalues: u10 (copy)
    local v58 = u10.convert(p56);
    local v59 = u10.convert(p57);

    if u10.cmpAbs(v58, v59) < 0 then
        return v59;
    end;

    return v58;
end;

function u10.neg(p60) -- Line: 395
    -- upvalues: u10 (copy)
    local v61 = u10.convert(p60);

    return u10.new(-v61.Sign, v61.Layer, v61.Exp);
end;

function u10.cmpAbs(p62, p63) -- Line: 400
    local v64;

    if p62.Exp > 0 then
        v64 = p62.Layer;
    else
        v64 = -p62.Layer;
    end;

    local v65;

    if p63.Exp > 0 then
        v65 = p63.Layer;
    else
        v65 = -p63.Layer;
    end;

    return v65 < v64 and 1 or (v64 < v65 and -1 or (p62.Exp > p63.Exp and 1 or (p62.Exp < p63.Exp and -1 or 0)));
end;

function u10.cmp(p66, p67) -- Line: 431
    -- upvalues: u10 (copy)
    return p66.Sign > p67.Sign and 1 or (p66.Sign < p67.Sign and -1 or p66.Sign * u10.cmpAbs(p66, p67));
end;

function u10.le(p68, p69) -- Line: 441
    -- upvalues: u10 (copy)
    local v70 = u10.convert(p68);
    local v71 = u10.convert(p69);

    return u10.cmp(v70, v71) == -1;
end;

function u10.me(p72, p73) -- Line: 447
    -- upvalues: u10 (copy)
    local v74 = u10.convert(p72);
    local v75 = u10.convert(p73);

    return u10.cmp(v74, v75) == 1;
end;

function u10.eq(p76, p77) -- Line: 453
    -- upvalues: u10 (copy)
    local v78 = u10.convert(p76);
    local v79 = u10.convert(p77);

    return u10.cmp(v78, v79) == 0;
end;

function u10.leeq(p80, p81) -- Line: 459
    -- upvalues: u10 (copy)
    local v82 = u10.convert(p80);
    local v83 = u10.convert(p81);

    return u10.cmp(v82, v83) ~= 1;
end;

function u10.meeq(p84, p85) -- Line: 465
    -- upvalues: u10 (copy)
    local v86 = u10.convert(p84);
    local v87 = u10.convert(p85);

    return u10.cmp(v86, v87) ~= -1;
end;

function u10.recip(p88) -- Line: 471
    -- upvalues: u10 (copy), u16 (copy)
    local v89 = u10.convert(p88);

    if v89.Exp == 0 then
        return u16;
    end;

    if v89.Layer == 0 then
        return u10.new(v89.Sign, 0, 1 / v89.Exp);
    end;

    return u10.new(v89.Sign, v89.Layer, -v89.Exp);
end;

function baseLog(p90, p91)
    -- upvalues: u10 (copy), u16 (copy)
    local v92 = u10.convert(p90);
    local v93 = u10.convert(p91);

    if v92.Sign <= 0 or v93.Sign <= 0 then
        return u16;
    end;

    if u10.IsNaN(v93) or u10.IsNaN(v92) then
        return u16;
    end;

    if v92.Layer == 0 and v93.Layer == 0 then
        return u10.new(v92.Sign, 0, math.log(v92.Exp) / math.log(v93.Exp));
    end;

    return u10.div(u10.log10(v92), u10.log10(v93));
end;

function u10.log(p94, p95) -- Line: 503
    -- upvalues: u10 (copy), u16 (copy)
    if p95 then
        return baseLog(p94, p95);
    end;

    local v96 = u10.convert(p94);

    if v96.Sign <= 0 then
        return u16;
    end;

    if v96.Layer == 0 then
        return u10.new(v96.Sign, 0, math.log10(v96.Exp) * 2.302585092994046);
    end;

    if v96.Layer == 1 then
        return u10.new(math.sign(v96.Exp), 0, math.abs(v96.Exp) * 2.302585092994046);
    end;

    if v96.Layer == 2 then
        return u10.new(math.sign(v96.Exp), 1, math.abs(v96.Exp) + 0.36221568869946325);
    end;

    return u10.new(math.sign(v96.Exp), v96.Layer - 1, (math.abs(v96.Exp)));
end;

function u10.log10(p97) -- Line: 529
    -- upvalues: u10 (copy), u16 (copy)
    local v98 = u10.convert(p97);

    if v98.Sign <= 0 then
        return u16;
    end;

    if v98.Layer > 0 then
        return u10.new(math.sign(v98.Exp), v98.Layer - 1, (math.abs(v98.Exp)));
    end;

    return u10.new(v98.Sign, 0, (math.log10(v98.Exp)));
end;

function u10.exp(p99) -- Line: 543
    -- upvalues: u10 (copy)
    local v100 = u10.convert(p99);

    if v100.Layer == 0 and v100.Exp <= 709.7 then
        return u10.fromNumber((math.exp(v100.Sign * v100.Exp)));
    end;

    if v100.Layer == 0 then
        return u10.new(1, 1, v100.Sign * 0.4342944819032518 * v100.Exp);
    end;

    if v100.Layer == 1 then
        return u10.new(1, 2, v100.Sign * (-0.36221568869946325 + v100.Exp));
    end;

    return u10.new(1, v100.Layer + 1, v100.Sign * v100.Exp);
end;

function u10.add(p101, p102) -- Line: 557
    -- upvalues: u10 (copy), u17 (copy), u14 (copy)
    local v103 = u10.convert(p101);
    local v104 = u10.convert(p102);

    if u10.IsInf(v103) or u10.IsInf(v104) then
        return u17;
    end;

    if u10.IsZero(v103) then
        return v104;
    end;

    if u10.IsZero(v104) then
        return v103;
    end;

    if v103.Sign == -v104.Sign and (v103.Layer == v104.Layer and v103.Exp == v104.Exp) then
        return u14;
    end;

    if v103.Layer >= 2 or v104.Layer >= 2 then
        return u10.maxAbs(v103, v104);
    end;

    if u10.cmpAbs(v103, v104) > 0 then
        local v105 = v103;
        v103 = v104;
        v104 = v105;
    end;

    if v104.Layer == 0 and v103.Layer == 0 then
        return u10.fromNumber(v104.Sign * v104.Exp + v103.Sign * v103.Exp);
    end;

    local v106 = v104.Layer * math.sign(v104.Exp);
    local v107 = v103.Layer * math.sign(v103.Exp);

    if v106 - v107 >= 2 then
        return v104;
    end;

    if v106 == 0 and v107 == -1 then
        local v108 = v103.Exp - math.log10(v104.Exp);

        if math.abs(v108) > 100 then
            return v104;
        end;

        local v109 = 10 ^ (math.log10(v104.Exp) - v103.Exp);
        local v110 = v103.Sign + v104.Sign * v109;
        local new = u10.new;
        local v111 = math.sign(v110);
        local Exp = v103.Exp;
        local v112 = math.abs(v110);

        return new(v111, 1, Exp + math.log10(v112));
    end;

    if v106 ~= 1 or v107 ~= 0 then
        if math.abs(v104.Exp - v103.Exp) > 100 then
            return v104;
        end;

        local v113 = v103.Sign + v104.Sign * 10 ^ (v104.Exp - v103.Exp);
        local new = u10.new;
        local v114 = math.sign(v113);
        local Exp = v103.Exp;
        local v115 = math.abs(v113);

        return new(v114, 1, Exp + math.log10(v115));
    end;

    local v116 = v104.Exp - math.log10(v103.Exp);

    if math.abs(v116) > 100 then
        return v104;
    end;

    local v117 = 10 ^ (v104.Exp - math.log10(v103.Exp));
    local v118 = v103.Sign + v104.Sign * v117;
    local new = u10.new;
    local v119 = math.sign(v118);
    local v120 = math.log10(v103.Exp);
    local v121 = math.abs(v118);

    return new(v119, 1, v120 + math.log10(v121));
end;

function u10.sub(p122, p123) -- Line: 627
    -- upvalues: u10 (copy)
    local v124 = u10.convert(p122);
    local v125 = u10.convert(p123);

    return u10.add(v124, u10.neg(v125));
end;

function u10.toScientific(p126) -- Line: 633
    -- upvalues: u10 (copy)
    if p126.Layer > 2 then
        return "";
    end;

    if p126.Layer == 2 and p126.Exp > 308 then
        return "Inf";
    end;

    if u10.IsZero(p126) then
        return "0e0";
    end;

    if p126.Layer ~= 0 then
        if p126.Layer == 1 then
            return 10 ^ (p126.Exp - math.floor(p126.Exp)) * p126.Sign .. "e" .. math.floor(p126.Exp);
        end;

        local v127 = 10 ^ p126.Exp;

        return 10 ^ (v127 - math.floor(v127)) * p126.Sign .. "e" .. math.floor(v127);
    end;

    local Exp = p126.Exp;
    local v128 = math.log10(p126.Exp);
    local v129 = Exp / 10 ^ math.floor(v128) * p126.Sign;
    local v130 = math.log10(p126.Exp);

    return v129 .. "e" .. math.floor(v130);
end;

function u10.mul(p131, p132) -- Line: 660
    -- upvalues: u10 (copy), u17 (copy), u14 (copy), u16 (copy)
    local v133 = u10.convert(p131);
    local v134 = u10.convert(p132);

    if u10.IsInf(v133) or u10.IsInf(v134) then
        return u17;
    end;

    if u10.IsZero(v133) or u10.IsZero(v134) then
        return u14;
    end;

    if v133.Layer == v134.Layer and v133.Exp == -v134.Exp then
        return u10.new(v133.Sign * v134.Sign, 0, 1);
    end;

    if v133.Layer > v134.Layer or v133.Layer == v134.Layer and math.abs(v133.Exp) > math.abs(v134.Exp) then
        local v135 = v133;
        v133 = v134;
        v134 = v135;
    end;

    if v134.Layer == 0 and v133.Layer == 0 then
        return u10.fromNumber(v134.Sign * v133.Sign * v134.Exp * v133.Exp);
    end;

    if v134.Layer >= 3 or v134.Layer - v133.Layer >= 2 then
        return u10.new(v134.Sign * v133.Sign, v134.Layer, v134.Exp);
    end;

    if v134.Layer == 1 and v133.Layer == 0 then
        return u10.new(v134.Sign * v133.Sign, 1, v134.Exp + math.log10(v133.Exp));
    end;

    if v134.Layer == 1 and v133.Layer == 1 then
        return u10.new(v134.Sign * v133.Sign, 1, v134.Exp + v133.Exp);
    end;

    if (v134.Layer ~= 2 or v133.Layer ~= 1) and (v134.Layer ~= 2 or v133.Layer ~= 2) then
        return u16;
    end;

    local v136 = u10.new(math.sign(v133.Exp), v133.Layer - 1, (math.abs(v133.Exp)));
    local v137 = u10.add(u10.new(math.sign(v134.Exp), v134.Layer - 1, (math.abs(v134.Exp))), v136);

    return u10.new(v134.Sign * v133.Sign, v137.Layer + 1, v137.Sign * v137.Exp);
end;

function u10.div(p138, p139) -- Line: 708
    -- upvalues: u10 (copy)
    local v140 = u10.convert(p138);
    local v141 = u10.convert(p139);

    return u10.mul(v140, u10.recip(v141));
end;

function u10.abslog10(p142) -- Line: 714
    -- upvalues: u10 (copy), u16 (copy)
    local v143 = u10.convert(p142);

    if u10.IsZero(v143) then
        return u16;
    end;

    if v143.Layer > 0 then
        return u10.new(math.sign(v143.Exp), v143.Layer - 1, (math.abs(v143.Exp)));
    end;

    local new = u10.new;
    local v144 = math.abs(v143.Exp);

    return new(1, 0, (math.log10(v144)));
end;

function u10.pow10(p145) -- Line: 727
    -- upvalues: u10 (copy), u17 (copy), u15 (copy)
    local v146 = u10.convert(p145);

    if u10.IsInf(v146) then
        return u17;
    end;

    if v146.Layer == 0 then
        local v147 = 10 ^ (v146.Sign * v146.Exp);

        if v147 < (1 / 0) and math.abs(v147) > 0.1 then
            return u10.new(1, 0, v147);
        end;

        if v146.Sign == 0 then
            return u15;
        end;

        v146 = u10.new(v146.Sign, v146.Layer + 1, (math.log10(v146.Exp)));
    end;

    if v146.Sign > 0 and v146.Exp > 0 then
        return u10.new(v146.Sign, v146.Layer + 1, v146.Exp);
    end;

    if v146.Sign < 0 and v146.Exp > 0 then
        return u10.new(-v146.Sign, v146.Layer + 1, -v146.Exp);
    end;

    return u15;
end;

function u10.pow(p148, p149) -- Line: 755
    -- upvalues: u10 (copy), u14 (copy), u15 (copy)
    local v150 = u10.convert(p148);
    local v151 = u10.convert(p149);

    if u10.IsZero(v150) then
        return u14;
    end;

    if v150.Sign == 1 and (v150.Layer == 0 and v150.Exp == 1) then
        return u15;
    end;

    if u10.IsZero(v151) then
        return u15;
    end;

    if v151.Sign == 1 and (v151.Layer == 0 and v151.Exp == 1) then
        return v150;
    end;

    local v152 = u10.pow10(u10.mul(u10.abslog10(v150), v151));

    if v150.Sign == -1 and u10.toNumber(v151) % 2 == 1 then
        return u10.neg(v152);
    end;

    if v150.Sign ~= -1 or u10.toNumber(v151) >= 1e20 then
        return v152;
    end;

    local fromNumber = u10.fromNumber;
    local v153 = u10.toNumber(v151) * 3.141592653589793;
    local v154 = fromNumber((math.cos(v153)));

    return u10.mul(v152, v154);
end;

local u155 = { "k", "M", "B" };
local u156 = { "", "U", "D", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No" };
local u157 = { "", "De", "Vt", "Tg", "qg", "Qg", "sg", "Sg", "Og", "Ng" };
local u158 = { "", "Ce", "Du", "Tr", "Qa", "Qi", "Se", "Si", "Ot", "Ni" };
local u159 = { "", "Mi", "Mc", "Na", "Pi", "Fm", "At", "Zp", "Yc", "Xo", "Ve", "Me", "Due", "Tre", "Te", "Pt", "He", "Hp", "Oct", "En", "Ic", "Mei", "Dui", "Tri", "Teti", "Pti", "Hei", "Hp", "Oci", "Eni", "Tra", "TeC", "MTc", "DTc", "TrTc", "TeTc", "PeTc", "HTc", "HpT", "OcT", "EnT", "TetC", "MTetc", "DTetc", "TrTetc", "TeTetc", "PeTetc", "HTetc", "HpTetc", "OcTetc", "EnTetc", "PcT", "MPcT", "DPcT", "TPCt", "TePCt", "PePCt", "HePCt", "HpPct", "OcPct", "EnPct", "HCt", "MHcT", "DHcT", "THCt", "TeHCt", "PeHCt", "HeHCt", "HpHct", "OcHct", "EnHct", "HpCt", "MHpcT", "DHpcT", "THpCt", "TeHpCt", "PeHpCt", "HeHpCt", "HpHpct", "OcHpct", "EnHpct", "OCt", "MOcT", "DOcT", "TOCt", "TeOCt", "PeOCt", "HeOCt", "HpOct", "OcOct", "EnOct", "Ent", "MEnT", "DEnT", "TEnt", "TeEnt", "PeEnt", "HeEnt", "HpEnt", "OcEnt", "EnEnt", "Hect", "MeHect" };

function CutDigits(p160, p161)
    if p161 < 0 then
        return p160;
    end;

    return math.floor(p160 * 10 ^ p161) / 10 ^ p161;
end;

function u10.toSuffix(p162, p163) -- Line: 902
    -- upvalues: u10 (copy), u155 (copy), u156 (copy), u157 (copy), u158 (copy), u159 (copy)
    local v164 = p163 or 2;
    local v165 = u10.toScientific(p162):split("e");
    local v166 = v165[1];
    local v167 = v165[2];
    local v168 = math.fmod(v167, 3);
    local v169 = math.floor(v167 / 3) - 1;

    if v169 <= -1 then
        return CutDigits(v165[1] * 10 ^ v165[2], v164);
    end;

    if v169 < 3 then
        return CutDigits(v166 * 10 ^ v168, v164) .. u155[v169 + 1];
    end;

    local u170 = "";

    local function SuffixPartOne(p171) -- Line: 920
        -- upvalues: u170 (ref), u156 (ref), u157 (ref), u158 (ref)
        local v172 = math.floor(p171 / 100);
        local v173 = math.fmod(p171, 100);
        local v174 = math.floor(v173 / 10);
        local v175 = math.fmod(v173, 10) / 1;
        u170 = u170 .. u156[math.floor(v175) + 1];
        u170 = u170 .. u157[v174 + 1];
        u170 = u170 .. u158[v172 + 1];
    end;

    local function SuffixPartTwo(p176) -- Line: 932
        -- upvalues: u170 (ref), u156 (ref), u157 (ref), u158 (ref)
        if p176 > 0 then
            p176 = p176 + 1;
        end;

        if p176 > 1000 then
            p176 = math.fmod(p176, 1000);
        end;

        local v177 = math.floor(p176 / 100);
        local v178 = math.fmod(p176, 100);
        local v179 = math.floor(v178 / 10);
        local v180 = math.fmod(v178, 10) / 1;
        u170 = u170 .. u156[math.floor(v180) + 1];
        u170 = u170 .. u157[v179 + 1];
        u170 = u170 .. u158[v177 + 1];
    end;

    if v169 >= 1000 then
        local v181 = math.log10(v169) / 3;

        for i = math.floor(v181), 0, -1 do
            if 10 ^ (i * 3) <= v169 then
                local v182 = math.floor(v169 / 10 ^ (i * 3)) - 1;

                if v182 > 0 then
                    v182 = v182 + 1;
                end;

                if v182 > 1000 then
                    v182 = math.fmod(v182, 1000);
                end;

                local v183 = math.floor(v182 / 100);
                local v184 = math.fmod(v182, 100);
                local v185 = math.floor(v184 / 10);
                local v186 = math.fmod(v184, 10) / 1;
                u170 = u170 .. u156[math.floor(v186) + 1];
                u170 = u170 .. u157[v185 + 1];
                u170 = u170 .. u158[v183 + 1];
                u170 = u170 .. u159[i + 1];
                v169 = math.fmod(v169, 10 ^ (i * 3));
            end;
        end;

        return CutDigits(v166 * 10 ^ v168, v164) .. u170;
    end;

    local v187 = math.floor(v169 / 100);
    local v188 = math.fmod(v169, 100);
    local v189 = math.floor(v188 / 10);
    local v190 = math.fmod(v188, 10) / 1;
    u170 = u170 .. u156[math.floor(v190) + 1];
    u170 = u170 .. u157[v189 + 1];
    u170 = u170 .. u158[v187 + 1];

    return CutDigits(v166 * 10 ^ v168, v164) .. u170;
end;

function u10.between(p191, p192, p193) -- Line: 958
    -- upvalues: u10 (copy)
    local v194 = u10.convert(p191);
    local v195 = u10.convert(p192);
    local v196 = u10.convert(p193);
    local v197 = u10.me(v194, v195) and u10.le(v194, v196);

    return v197;
end;

function u10.toLayerNotation(p198, p199) -- Line: 965
    -- upvalues: u10 (copy), u14 (copy), u15 (copy)
    local v200 = u10.convert(p198);
    local v201 = p199 or 2;

    if u10.between(v200, u14, u15) then
        return "1 / " .. u10.short(u10.div(u15, v200));
    end;

    if v200.Sign ~= 1 then
        return v200.Sign == 0 and "E(0)0" or u10.toLayerNotation(u10.abs(v200), v201);
    end;

    if v200.Exp < 0 then
        return "E(" .. v200.Layer .. "-" .. ")" .. CutDigits(math.abs(v200.Exp), v201);
    end;

    return "E(" .. v200.Layer .. ")" .. CutDigits(v200.Exp, v201);
end;

function u10.short(p202, p203) -- Line: 988
    -- upvalues: u10 (copy)
    local v204 = u10.convert(p202);

    if u10.le(v204, "9e1E14") then
        return u10.toSuffix(v204, p203);
    end;

    return u10.toLayerNotation(v204, p203);
end;

function u10.root(p205, p206) -- Line: 996
    -- upvalues: u10 (copy)
    local v207 = u10.convert(p205);
    local v208 = u10.convert(p206);

    return u10.pow(v207, u10.recip(v208));
end;

function u10.sqrt(p209) -- Line: 1002
    -- upvalues: u10 (copy)
    local v210 = u10.convert(p209);

    return u10.root(v210, 2);
end;

function u10.gamma(p211) -- Line: 1007
    -- upvalues: u10 (copy), u14 (copy), u16 (copy)
    local v212 = u10.convert(p211);

    if u10.leeq(v212, u14) then
        return u16;
    end;

    if v212.Exp < 0 then
        return u10.recip(v212);
    end;

    if v212.Layer ~= 0 then
        if v212.Layer == 1 then
            return u10.exp(u10.mul(v212, u10.sub(u10.log(v212), 1)));
        end;

        return u10.exp(v212);
    end;

    if u10.le(v212, { 1, 0, 24 }) then
        return u10.fromNumber(F_Gamma(v212.Sign * v212.Exp));
    end;

    local v213 = v212.Exp - 1;
    local v214 = 0.9189385332046727 + (v213 + 0.5) * math.log(v213) - v213;
    local v215 = v213 * v213;
    local v216 = v214 + 1 / (12 * v213);

    if v216 == v214 then
        return u10.exp(v214);
    end;

    local v217 = v213 * v215;
    local v218 = v216 - 1 / (360 * v217);

    if v218 == v216 then
        return u10.exp(v216);
    end;

    local v219 = v217 * v215;

    return u10.exp(v218 + 1 / (1260 * v219) - 1 / (1680 * (v219 * v215)));
end;

function u10.fact(p220) -- Line: 1064
    -- upvalues: u10 (copy)
    local v221 = u10.convert(p220);

    return u10.gamma(u10.add(v221, 1));
end;

function u10.rand(p222, p223) -- Line: 1069
    -- upvalues: u10 (copy)
    local v224 = math.random();
    local v225 = u10.sub(p223, p222);
    local v226 = u10.mul(v225, v224);

    return u10.add(v226, p222);
end;

function u10.exporand(p227, p228) -- Line: 1076
    -- upvalues: u10 (copy)
    local v229 = u10.convert(p227);
    local v230 = u10.convert(p228);
    local Sign = v229.Sign;
    local Sign2 = v230.Sign;
    local v231 = u10.mul(u10.exp(u10.abs(v229)), Sign);
    local v232 = u10.mul(u10.exp(u10.abs(v230)), Sign2);

    return u10.exp(u10.rand(v231, v232));
end;

function u10.lbencode(p233) -- Line: 1084
    -- upvalues: u10 (copy)
    local v234 = u10.convert(p233);

    if u10.eq(v234, 1) then
        return 1;
    end;

    local v235 = 0;
    local v236;

    if v234.Sign == -1 and (v234.Layer > 9999 and math.sign(v234.Exp) == 1) then
        v236 = 0;
    elseif v234.Sign == -1 and (v234.Layer < 9999 and math.sign(v234.Exp) == 1) then
        v236 = 1;
    elseif v234.Sign == -1 and (v234.Layer > 9999 and math.sign(v234.Exp) == -1) then
        v236 = 2;
    elseif v234.Sign == -1 and (v234.Layer < 9999 and math.sign(v234.Exp) == -1) then
        v236 = 3;
    else
        if v234.Sign == 0 then
            return 4e18;
        end;

        v236 = v234.Sign == 1 and (v234.Layer < 9999 and math.sign(v234.Exp) == -1) and 5 or (v234.Sign == 1 and (v234.Layer > 9999 and math.sign(v234.Exp) == -1) and 6 or (v234.Sign == 1 and (v234.Layer < 9999 and math.sign(v234.Exp) == 1) and 7 or (v234.Sign == 1 and (v234.Layer > 9999 and math.sign(v234.Exp) == 1) and 8 or v235)));
    end;

    local v237 = v236 * 1e18;

    if v236 == 8 then
        local v238 = v234.Layer + math.log10(v234.Exp) / 10;

        return v237 + math.log10(v238) * 3244067411720800;
    end;

    if v236 == 7 then
        return v237 + v234.Layer * 100000000000000 + math.log10(v234.Exp) * 10000000000000;
    end;

    if v236 == 6 then
        local Layer = v234.Layer;
        local v239 = math.abs(v234.Exp);
        local v240 = Layer + math.log10(v239) / 10;

        return v237 + 1e18 - math.log10(v240) * 3244067411720800;
    end;

    if v236 == 5 then
        local v241 = v237 + (v234.Layer * 100000000000000 + 100000000000000);
        local v242 = math.abs(v234.Exp);

        return v241 - math.log10(v242) * 10000000000000;
    end;

    if v236 == 3 then
        local v243 = v237 + (v234.Layer * 100000000000000 + 100000000000000);
        local v244 = math.abs(v234.Exp);

        return v243 - math.log10(v244) * 10000000000000 + (1e18 - 0);
    end;

    if v236 ~= 2 then
        if v236 == 1 then
            return v237 + v234.Layer * 100000000000000 + math.log10(v234.Exp) * 10000000000000 + (1e18 - 0);
        end;

        if v236 == 0 then
            local v245 = v234.Layer + math.log10(v234.Exp) / 10;
            v237 = v237 + (1e18 - math.log10(v245) * 3244067411720800);
        end;

        return v237;
    end;

    local Layer = v234.Layer;
    local v246 = math.abs(v234.Exp);
    local v247 = Layer + math.log10(v246) / 10;

    return v237 + 1e18 - math.log10(v247) * 3244067411720800 + (1e18 - 0);
end;

function u10.lbdecode(p248) -- Line: 1149
    -- upvalues: u10 (copy), u15 (copy), u14 (copy), u16 (copy)
    if p248 == 2e18 then
        return u10.new(-1, 0, 1);
    end;

    if p248 == 3e18 then
        return u10.new(-1, 10000, -1);
    end;

    if p248 == 1e18 then
        return u10.new(-1, 0, -1);
    end;

    if p248 == 6e18 then
        return u15;
    end;

    if p248 == 7e18 then
        return u10.new(1, 10000, 1);
    end;

    if p248 == 5e18 then
        return u10.new(1, 10000, -1);
    end;

    if p248 == 1 then
        return u15;
    end;

    local v249 = math.floor(p248 / 1e18);

    if v249 == 4 then
        return u14;
    end;

    if v249 == 0 then
        local v250 = 10 ^ ((1e18 - p248) / 3244067411720800);
        local v251 = math.floor(v250);
        local v252 = 10 ^ (math.fmod(v250, 1) * 10);

        return u10.new(-1, v251, v252);
    end;

    if v249 == 8 then
        local v253 = 10 ^ ((p248 - 8e18) / 3244067411720800);
        local v254 = math.floor(v253);
        local v255 = 10 ^ (math.fmod(v253, 1) * 10);

        return u10.new(1, v254, v255);
    end;

    if v249 == 1 then
        local v256 = 1e18 - (p248 - 1e18);
        local v257 = math.floor(v256 / 100000000000000);
        local v258 = 10 ^ (math.fmod(v256, 100000000000000) / 10000000000000);

        return u10.new(-1, v257, v258);
    end;

    if v249 == 7 then
        local v259 = p248 - 7e18;
        local v260 = math.floor(v259 / 100000000000000);
        local v261 = 10 ^ (math.fmod(v259, 100000000000000) / 10000000000000);

        return u10.new(1, v260, v261);
    end;

    if v249 == 2 then
        local v262 = 10 ^ ((p248 - 2e18) / 3244067411720800);
        local v263 = math.floor(v262);
        local v264 = 10 ^ (math.fmod(v262, 1) * 10);

        return u10.new(-1, v263, -v264);
    end;

    if v249 == 6 then
        local v265 = 10 ^ ((1e18 - (p248 - 6e18)) / 3244067411720800);
        local v266 = math.floor(v265);
        local v267 = 10 ^ (math.fmod(v265, 1) * 10);

        return u10.new(1, v266, -v267);
    end;

    if v249 == 5 then
        local v268 = p248 - 5e18;
        local v269 = math.floor(v268 / 100000000000000);
        local v270 = 10 ^ ((100000000000000 - math.fmod(v268, 100000000000000)) / 10000000000000);

        return u10.new(1, v269, -v270);
    end;

    if v249 ~= 3 then
        return u16;
    end;

    local v271 = 1e18 - (p248 - 3e18);
    local v272 = math.floor(v271 / 100000000000000);
    local v273 = 10 ^ ((100000000000000 - math.fmod(v271, 100000000000000)) / 10000000000000);

    return u10.new(-1, v272, -v273);
end;

function u10.shift(p274, p275) -- Line: 1228
    -- upvalues: u10 (copy)
    local v276 = u10.convert(p274);

    if v276.Layer > 1 then
        return v276;
    end;

    if p275 > 20 then
        return v276;
    end;

    local _ = 10 ^ (v276.Exp - math.floor(v276.Exp));
    local v277 = math.floor(p275 * 10 ^ p275) / 10 ^ p275;
    v276.Exp = math.floor(v276.Exp) + math.log10(v277);

    return v276;
end;

return u10;