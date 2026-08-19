-- Decompiled with Potassium's decompiler.

local MonsterLocomotionPlay = require(script.Parent.MonsterLocomotionPlay);

return {
    handleIncoming = function(p1) -- Line: 18, Name: handleIncoming
        -- upvalues: MonsterLocomotionPlay (copy)
        MonsterLocomotionPlay.playFromPayload(p1);
    end
};