-- Decompiled with Potassium's decompiler.

local u1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "scheduling", "FrameBudgetQueue").FrameBudgetQueue.new(2);

return {
    DirtBudget = {
        schedule = function(p2) -- Line: 9, Name: schedule
            -- upvalues: u1 (copy)
            u1:add(p2);
        end,

        scheduleBatch = function(p3, p4) -- Line: 13, Name: scheduleBatch
            -- upvalues: u1 (copy)
            u1:addBatch(p3, p4);
        end,

        isDraining = function() -- Line: 17, Name: isDraining
            -- upvalues: u1 (copy)
            return u1:isDraining();
        end
    }
};