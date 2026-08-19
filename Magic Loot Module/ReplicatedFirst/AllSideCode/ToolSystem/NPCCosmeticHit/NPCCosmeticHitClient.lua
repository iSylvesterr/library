-- Decompiled with Potassium's decompiler.

local NPCCosmeticHitPlay = require(script.Parent.NPCCosmeticHitPlay);

return {
    handleIncoming = function(p1) -- Line: 18, Name: handleIncoming
        -- upvalues: NPCCosmeticHitPlay (copy)
        NPCCosmeticHitPlay.playFromPayload(p1);
    end
};