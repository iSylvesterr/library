-- Decompiled with Potassium's decompiler.

local RunService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService;

return {
    waitForResult = function(p1, p2) -- Line: 4, Name: waitForResult
        -- upvalues: RunService (copy)
        local v3 = os.clock() + (p2 == nil and 30 or p2);
        local v4 = p1();

        while v4 == nil and os.clock() < v3 do
            RunService.Heartbeat:Wait();
            v4 = p1();
        end;

        return v4;
    end
};