-- Decompiled with Potassium's decompiler.

local MonsterDeathFxPlay = require(script.Parent.MonsterDeathFxPlay);

return {
    handleIncoming = function(p1) -- Line: 18, Name: handleIncoming
        -- upvalues: MonsterDeathFxPlay (copy)
        MonsterDeathFxPlay.playFromPayload(p1);
    end
};