-- Decompiled with Potassium's decompiler.

local RunService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService;

return {
    animateRainbowGradient = function(u1, p2) -- Line: 15, Name: animateRainbowGradient
        -- upvalues: RunService (copy)
        local u3 = p2 == nil and 8 or p2;
        local u4 = 0;

        return RunService.RenderStepped:Connect(function(p5) -- Line: 20
            -- upvalues: u4 (ref), u3 (ref), u1 (copy)
            u4 = (u4 + p5 / u3) % 1;
            local v6 = {};

            for i = 0, 19 do
                local v7 = i / 19;
                local v8 = ColorSequenceKeypoint.new(v7, Color3.fromHSV(((v7 - u4) % 1 + 1) % 1, 1, 1));
                table.insert(v6, v8);
            end;

            u1.Color = ColorSequence.new(v6);
        end);
    end
};