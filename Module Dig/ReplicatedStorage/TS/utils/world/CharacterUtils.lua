-- Decompiled with Potassium's decompiler.

local Players = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players;

return {
    CharacterUtils = {
        waitForCharacter = function(p1) -- Line: 15, Name: waitForCharacter
            -- upvalues: Players (copy)
            if p1 == nil then
                p1 = Players.LocalPlayer;
            end;

            return p1.Character or p1.CharacterAdded:Wait();
        end,

        getCharacter = function(p2) -- Line: 29, Name: getCharacter
            -- upvalues: Players (copy)
            if p2 == nil then
                p2 = Players.LocalPlayer;
            end;

            return p2.Character;
        end,

        getHumanoid = function(p3) -- Line: 44, Name: getHumanoid
            -- upvalues: Players (copy)
            if p3 == nil then
                p3 = Players.LocalPlayer;
            end;

            if p3 == nil then
                p3 = Players.LocalPlayer;
            end;

            local v4 = p3.Character or p3.CharacterAdded:Wait();

            if v4 ~= nil then
                v4 = v4:WaitForChild("Humanoid");
            end;

            return v4;
        end,

        getHumanoidNoYield = function(p5) -- Line: 63, Name: getHumanoidNoYield
            -- upvalues: Players (copy)
            if p5 == nil then
                p5 = Players.LocalPlayer;
            end;

            if p5 == nil then
                p5 = Players.LocalPlayer;
            end;

            local Character = p5.Character;

            if Character ~= nil then
                Character = Character:FindFirstChild("Humanoid");
            end;

            return Character;
        end,

        getHRP = function(p6) -- Line: 83, Name: getHRP
            -- upvalues: Players (copy)
            if p6 == nil then
                p6 = Players.LocalPlayer;
            end;

            if p6 == nil then
                p6 = Players.LocalPlayer;
            end;

            local v7 = p6.Character or p6.CharacterAdded:Wait();

            if v7 ~= nil then
                v7 = v7:WaitForChild("HumanoidRootPart");
            end;

            return v7;
        end
    }
};