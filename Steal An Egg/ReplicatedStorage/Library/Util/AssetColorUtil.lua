-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);
local LotteryCustom = require(ReplicatedStorage.Library.Functions.LotteryCustom);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Random2 = t.Random;
local u1 = {};

local function isEyePart(p2) -- Line: 47
    return p2:GetAttribute("IsEye") == true and true or string.find(string.lower(p2.Name), "eye", 1, true) ~= nil;
end;

local function hueDistance(p3, p4) -- Line: 51
    local v5 = math.abs(p3 - p4);

    return math.min(v5, 1 - v5);
end;

local function shouldColorPart(p6, p7) -- Line: 56
    local v8, v9, v10 = p6:ToHSV();
    local v11, v12, v13 = p7:ToHSV();

    if v12 < 0.16 then
        if v9 >= 0.16 then
            return false;
        end;

        if v13 < 0.08 then
            return v10 <= 0.08;
        end;

        return math.abs(v10 - v13) <= 0.18;
    end;

    if v9 < 0.16 then
        return false;
    end;

    local v14 = math.abs(v8 - v11);

    if math.min(v14, 1 - v14) > 0.08 then
        return false;
    end;

    local v15 = v10 / math.max(v13, 0.001);
    local v16;

    if v15 >= 0.08 then
        v16 = v15 <= 1.6;
    else
        v16 = false;
    end;

    return v16;
end;

local function getPartVariance(p17, p18) -- Line: 80
    return Random.new(p17 + 7919 + p18):NextNumber(0.8333333333333334, 1.2);
end;

local function shouldApplyEyeColor(p19) -- Line: 85
    return Random.new(p19):NextNumber() < 0.5;
end;

local function recolorPart(p20, p21, p22, p23, p24) -- Line: 90
    local _, _, v25 = p20.Color:ToHSV();
    local _, _, v26 = p21:ToHSV();
    local v27, v28, v29 = p22:ToHSV();

    if v26 >= 0.08 then
        v29 = v29 * (v25 / math.max(v26, 0.001));
    end;

    local v30 = v29 * Random.new(p23 + 7919 + p24):NextNumber(0.8333333333333334, 1.2);
    p20.Color = Color3.fromHSV(v27, v28, (math.clamp(v30, 0, 1)));

    if p20:IsA("UnionOperation") then
        p20.UsePartColor = true;
    end;
end;

local function resolveColorIndex(p31, p32) -- Line: 111
    -- upvalues: Assets (copy), Constants (copy), Asserts (copy)
    local v33 = Assets.Directory[p31];
    local v34 = `Missing asset config for category {p31}`;
    assert(v33 ~= nil, v34);

    if #v33.PossibleModelColors == 0 or p32 <= 0 then
        return nil;
    end;

    if Constants.IS_STUDIO then
        local v35 = v33.PossibleModelColors[p32];
        local v36 = `Asset {p31} missing PossibleModelColors[{p32}]`;
        assert(v35, v36);
    end;

    local v37 = v33.PossibleModelColors[(p32 - 1) % #v33.PossibleModelColors + 1][1];
    Asserts.Color3(v37);

    return v37;
end;

function u1.RollEyeColorHex(p38) -- Line: 130
    -- upvalues: Random2 (copy)
    local v39 = Random2(p38);
    assert(v39, "Expected Random for RollEyeColorHex");
    local v40 = p38:NextNumber();
    local v41 = p38:NextNumber(0.35, 0.85);
    local v42 = p38:NextNumber(0.35, 0.9);

    return Color3.fromHSV(v40, v41, v42):ToHex();
end;

function u1.RollColorSeed(p43) -- Line: 139
    -- upvalues: Random2 (copy)
    local v44 = Random2(p43);
    assert(v44, "Expected Random for RollColorSeed");

    return p43:NextInteger(1, 2147483647);
end;

function u1.RollColorIndex(p45, p46) -- Line: 145
    -- upvalues: Asserts (copy), Random2 (copy), Assets (copy), LotteryCustom (copy)
    Asserts.string(p45);
    local v47 = Random2(p46);
    assert(v47, "Expected Random for RollColorIndex");
    local v48 = Assets.Directory[p45];
    local v49 = `Missing asset config for category {p45}`;
    assert(v48 ~= nil, v49);
    local _, _, _, v50 = LotteryCustom(p46, v48.PossibleModelColors);

    return v50;
end;

function u1.RollFields(p51, p52) -- Line: 155
    -- upvalues: Asserts (copy), Random2 (copy), u1 (copy)
    Asserts.string(p51);
    local v53 = Random2(p52);
    assert(v53, "Expected Random for RollFields");

    return {
        EyeColor = u1.RollEyeColorHex(p52),
        ColorSeed = u1.RollColorSeed(p52),
        ColorIndex = u1.RollColorIndex(p51, p52)
    };
end;

function u1.ResolveFields(p54, p55, p56, p57) -- Line: 166
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.string(p54);
    Asserts.optional.string(p55);
    Asserts.optional.number(p56);
    Asserts.optional.number(p57);
    local v58 = p56 == nil and 1 or p56;
    local v59 = {};

    if p55 == nil or p55 == "" then
        p55 = u1.RollEyeColorHex(Random.new(v58));
    end;

    v59.EyeColor = p55;
    v59.ColorSeed = v58;
    v59.ColorIndex = p57 == nil and 1 or p57;

    return v59;
end;

function u1.ResolveModelColor(p60, p61) -- Line: 187
    -- upvalues: Asserts (copy), resolveColorIndex (copy)
    Asserts.string(p60);
    Asserts.number(p61);

    return resolveColorIndex(p60, p61);
end;

function u1.Apply(p62, p63, p64, p65, p66) -- Line: 194
    -- upvalues: Asserts (copy), Assets (copy), u1 (copy), shouldColorPart (copy), recolorPart (copy)
    Asserts.Model(p62);
    Asserts.string(p63);
    Asserts.string(p64);
    Asserts.number(p65);
    Asserts.number(p66);
    local v67 = Assets.Directory[p63];
    local v68 = `Missing asset config for category {p63}`;
    assert(v67 ~= nil, v68);
    local v69 = Color3.fromHex(p64);
    local v70 = u1.ResolveModelColor(p63, p66);
    local v71 = Random.new(p65):NextNumber() < 0.5;
    local v72 = 0;

    for _, descendant in ipairs(p62:GetDescendants()) do
        if descendant:IsA("BasePart") and (not descendant:GetAttribute("DontModify") and descendant.Transparency < 1) then
            v72 = v72 + 1;

            if descendant:GetAttribute("IsEye") == true and true or string.find(string.lower(descendant.Name), "eye", 1, true) ~= nil then
                if v71 then
                    descendant.Color = v69;
                end;
            elseif v70 ~= nil then
                if v70 == Color3.fromRGB(255, 255, 255) and v67.AlbinosColorFullWhite then
                    descendant.Color = v70;
                elseif shouldColorPart(descendant.Color, v67.BaseModelColor) then
                    recolorPart(descendant, v67.BaseModelColor, v70, p65, v72);
                end;
            end;
        end;
    end;
end;

return u1;