-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "Requiem",
    skillCooldown = 1,
    syncRadius = 150,
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Dark,
    suppressions = {
        SkillFuncCondition = "首段无条件释放，占位 condition"
    }
};
v1.Skill = {
    {
        baseSkillName = "Requiem1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 27, Name: condition
            return true;
        end
    }
};

return v1;