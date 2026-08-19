-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "GhostShoot-Purple",
    skillCooldown = 1,
    Recovery = 2.38,
    npcBlocksUntilFinished = true,
    syncRadius = 150,
    predictPresentation = false,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.None,
    suppressions = {
        SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
    }
};
v1.Skill = {
    {
        baseSkillName = "GhostShoot2",
        breakLastSkill = false,

        condition = function(p2) -- Line: 31, Name: condition
            return true;
        end
    }
};

return v1;