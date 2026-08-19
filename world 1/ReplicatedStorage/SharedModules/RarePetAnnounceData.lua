-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local u1 = {
    Bear = {
        Big = 57,
        Rainbow = 1,
        Huge = 1,
        BigRainbow = 0,
        HugeRainbow = 0
    },
    Unicorn = {
        Rainbow = 31,
        Huge = 6,
        HugeRainbow = 1,
        BigRainbow = 15
    },
    Monkey = {
        Big = 26,
        Rainbow = 6,
        BigRainbow = 0,
        Huge = 0,
        HugeRainbow = 0
    },
    JandelMonkey = {
        HugeRainbow = 0,
        Huge = 0,
        BigRainbow = 0
    },
    GoldenDragonfly = {
        Big = 141,
        Rainbow = 66,
        BigRainbow = 30,
        Huge = 15,
        HugeRainbow = 0
    },
    Raccoon = {
        Big = 48,
        Rainbow = 27,
        Huge = 3,
        BigRainbow = 8,
        HugeRainbow = 0
    },
    Bee = {
        BigRainbow = 25,
        HugeRainbow = 1,
        Huge = 2
    },
    Robin = {
        BigRainbow = 22,
        HugeRainbow = 1,
        Huge = 2
    },
    Deer = {
        BigRainbow = 106,
        HugeRainbow = 10,
        Huge = 40
    },
    Turtle = {
        HugeRainbow = 0,
        Huge = 0,
        BigRainbow = 0
    },
    Owl = {
        BigRainbow = 9,
        Huge = 0,
        HugeRainbow = 0
    },
    Frog = {
        HugeRainbow = 6,
        Huge = 36
    },
    Bunny = {
        HugeRainbow = 9,
        Huge = 54
    }
};

return table.freeze({
    GetVariantClass = function(p2, p3) -- Line: 122, Name: GetVariantClass
        -- upvalues: PetSizes (copy), PetTypes (copy)
        local v4 = PetSizes.Normalize(p2);
        local v5 = p3 == PetTypes.Rainbow;

        return v4 == "Huge" and (v5 and "HugeRainbow" or "Huge") or (v4 == "Big" and (v5 and "BigRainbow" or "Big") or (v5 and "Rainbow" or "Normal"));
    end,

    VariantKey = function(p6, p7, p8) -- Line: 136, Name: VariantKey
        -- upvalues: PetSizes (copy), PetTypes (copy)
        local v9 = PetSizes.Normalize(p7);
        local v10 = p8 == PetTypes.Rainbow;
        local v11;

        if v9 == "Huge" then
            v11 = v10 and "HugeRainbow" or "Huge";
        elseif v9 == "Big" then
            v11 = v10 and "BigRainbow" or "Big";
        else
            v11 = v10 and "Rainbow" or "Normal";
        end;

        return `{p6}|{v11}`;
    end,

    GetExistCount = function(p12, p13, p14) -- Line: 142, Name: GetExistCount
        -- upvalues: u1 (copy), PetSizes (copy), PetTypes (copy)
        local v15 = u1[p12];

        if not v15 then
            return nil;
        end;

        local v16 = PetSizes.Normalize(p13);
        local v17 = p14 == PetTypes.Rainbow;
        local v18;

        if v16 == "Huge" then
            v18 = v17 and "HugeRainbow" or "Huge";
        elseif v16 == "Big" then
            v18 = v17 and "BigRainbow" or "Big";
        else
            v18 = v17 and "Rainbow" or "Normal";
        end;

        return v15[v18];
    end
});