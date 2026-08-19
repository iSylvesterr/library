-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AssetAcquire = UtilsSystem.AssetAcquire;
local AssetRegistry = UtilsSystem.AssetRegistry;
local AssetPaths = UtilsSystem.AssetPaths;
local ObjectPoolUtil = UtilsSystem.ObjectPoolUtil;
local SkillPreloadUtil = UtilsSystem.SkillPreloadUtil;

return {
    ModelType = AssetRegistry.ModelType,
    ModelCategory = AssetRegistry.ModelCategory,
    Catalog = AssetRegistry.Catalog,
    Scope = AssetPaths.Scope,

    Get = function(p1, p2) -- Line: 55, Name: Get
        -- upvalues: AssetAcquire (copy)
        return AssetAcquire.Get(p1, p2);
    end,

    GetModel = function(p3, p4, p5) -- Line: 66, Name: GetModel
        -- upvalues: AssetAcquire (copy)
        return AssetAcquire.GetModel(p3, p4, p5);
    end,

    GetUI = function(p6, p7) -- Line: 76, Name: GetUI
        -- upvalues: AssetAcquire (copy)
        return AssetAcquire.GetUI(p6, p7);
    end,

    GetServerUI = function(p8) -- Line: 85, Name: GetServerUI
        -- upvalues: AssetAcquire (copy), AssetPaths (copy)
        return AssetAcquire.GetUI(p8, {
            clone = true,
            restore = true,
            scope = AssetPaths.Scope.Server
        });
    end,

    GetTemplate = function(p9, p10) -- Line: 99, Name: GetTemplate
        -- upvalues: AssetAcquire (copy)
        return AssetAcquire.GetTemplate(p9, p10);
    end,

    GetPooledInstance = function(p11) -- Line: 112, Name: GetPooledInstance
        -- upvalues: ObjectPoolUtil (copy)
        return ObjectPoolUtil.getObjectFromPool(p11);
    end,

    BackToPool = function(p12) -- Line: 121, Name: BackToPool
        -- upvalues: ObjectPoolUtil (copy)
        ObjectPoolUtil.backToPool(p12);
    end,

    PreloadBaseSkill = function(p13) -- Line: 134, Name: PreloadBaseSkill
        -- upvalues: SkillPreloadUtil (copy)
        SkillPreloadUtil.PreloadBaseSkill(p13);
    end,

    PreloadSkill = function(p14) -- Line: 143, Name: PreloadSkill
        -- upvalues: SkillPreloadUtil (copy)
        SkillPreloadUtil.PreloadSkill(p14);
    end,

    PreloadAnimations = function(p15) -- Line: 152, Name: PreloadAnimations
        -- upvalues: SkillPreloadUtil (copy)
        SkillPreloadUtil.PreloadAnimations(p15);
    end,

    PreloadSounds = function(p16) -- Line: 161, Name: PreloadSounds
        -- upvalues: SkillPreloadUtil (copy)
        SkillPreloadUtil.PreloadSounds(p16);
    end
};