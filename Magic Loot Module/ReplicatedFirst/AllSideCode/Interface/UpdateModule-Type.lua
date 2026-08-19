-- Decompiled with Potassium's decompiler.

local UpdateModule = require(game.ReplicatedFirst.AllSideCode.ToolSystem.UpdateModule);

return {
    INTERVAL = UpdateModule.INTERVAL,

    Register = function(p1, p2, p3) -- Line: 15, Name: Register
        -- upvalues: UpdateModule (copy)
        UpdateModule.Register(p1, p2, p3);
    end,

    Start = function() -- Line: 19, Name: Start
        -- upvalues: UpdateModule (copy)
        UpdateModule.Start();
    end
};