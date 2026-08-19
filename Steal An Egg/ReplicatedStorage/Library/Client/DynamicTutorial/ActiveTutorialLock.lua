-- Decompiled with Potassium's decompiler.

local u1 = false;

return {
    SetRoundTutorialActive = function(p2) -- Line: 10, Name: SetRoundTutorialActive
        -- upvalues: u1 (ref)
        u1 = p2;
    end,

    IsRoundTutorialActive = function() -- Line: 14, Name: IsRoundTutorialActive
        -- upvalues: u1 (ref)
        return u1;
    end
};