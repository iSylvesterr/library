-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local v2 = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule.MultThunderTrample - Dark1);
v1.Data = {
    skillName = "MultThunderTrample-Dark",
    skillCooldown = 1,
    syncRadius = 400,
    preCastMoveStrategy = "ApproachMultThunderStart",
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Thunder,
    Recovery = v2.estimateSkillTotalDuration(),
    suppressions = {
        SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
    }
};
v1.Skill = {
    {
        baseSkillName = "MultThunderTrample-Dark1",
        breakLastSkill = false,

        condition = function(p3) -- Line: 27, Name: condition
            return true;
        end
    }
};

return v1;