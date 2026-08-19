-- Decompiled with Potassium's decompiler.

local u1 = {
    Catalog = table.freeze({
        ModelRes = "ModelRes",
        UI = "UI",
        Sequence = "Sequence",
        Hatch = "Hatch",
        BUFF = "BUFF",
        UIanima = "UIanima",
        LightingConfig = "LightingConfig",
        LightingStates = "LightingStates",
        Tips = "Tips",
        AllGridients = "AllGridients"
    }),
    ModelCategory = table.freeze({
        Anime = "Anime",
        Enemy = "Enemy",
        Weapon = "Weapon",
        Pet = "Pet",
        Effect = "Effect",
        PetEgg = "PetEgg",
        Skill = "Skill",
        Armor = "Armor",
        Broom = "Broom",
        Material = "Material",
        Potion = "Potion",
        RigFolder = "RigFolder"
    }),
    ModelType = table.freeze({
        Anime = 1,
        Enemy = 2,
        Weapon = 3,
        Pet = 4,
        Effect = 5,
        PetEgg = 6
    })
};
local u2 = {
    [u1.ModelType.Anime] = u1.ModelCategory.Anime,
    [u1.ModelType.Enemy] = u1.ModelCategory.Enemy,
    [u1.ModelType.Weapon] = u1.ModelCategory.Weapon,
    [u1.ModelType.Pet] = u1.ModelCategory.Pet,
    [u1.ModelType.Effect] = u1.ModelCategory.Effect,
    [u1.ModelType.PetEgg] = u1.ModelCategory.PetEgg
};

function u1.GetModelCategoryByType(p3) -- Line: 145
    -- upvalues: u2 (copy)
    return u2[p3];
end;

function u1.BuildCatalogPath(p4, p5) -- Line: 155
    return p4 .. "/" .. p5;
end;

function u1.BuildModelPath(p6, p7) -- Line: 165
    -- upvalues: u1 (copy)
    return u1.BuildCatalogPath(u1.Catalog.ModelRes, p6 .. "/" .. p7);
end;

function u1.BuildUIPath(p8) -- Line: 174
    -- upvalues: u1 (copy)
    return u1.BuildCatalogPath(u1.Catalog.UI, p8);
end;

return u1;