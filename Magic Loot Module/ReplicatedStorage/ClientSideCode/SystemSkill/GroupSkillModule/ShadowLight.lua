-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "ShadowLight",
    syncRadius = 200,
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Dark,
    suppressions = {
        SkillFuncCondition = "原因：首段无条件派生，A 档表现骨架占位"
    }
};
v1.Skill = {
    {
        baseSkillName = "ShadowLight1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 27, Name: condition
            return true;
        end
    }
};

return v1;