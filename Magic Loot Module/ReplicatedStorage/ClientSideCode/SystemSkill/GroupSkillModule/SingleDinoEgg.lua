-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
v1.Data = {
    skillName = "SingleDinoEgg",
    syncRadius = 120,
    predictPresentation = true,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.Space,
    suppressions = {
        SkillFuncCondition = "原因：首段无条件派生，暂用 function 占位，后续可改为声明式"
    }
};
v1.Skill = {
    {
        baseSkillName = "SingleDinoEgg1",
        breakLastSkill = false,

        condition = function(p2) -- Line: 30, Name: condition
            return true;
        end
    }
};

return v1;