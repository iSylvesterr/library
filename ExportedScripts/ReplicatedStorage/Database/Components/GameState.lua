-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(script:WaitForChild("Types"));
local Observers = require(ReplicatedStorage.Packages.Observers);
local u1 = { "Map Voting", "Game Ending", "Warmup", "Round In Progress", "Buy Period", "Intermission" };

local function isValidState(p2) -- Line: 19
    -- upvalues: u1 (copy)
    local v3 = table.find(u1, p2);
    local v4 = `"{p2}" is not a valid state!`;
    assert(v3, v4);

    return true;
end;

return {
    GetState = function() -- Line: 30, Name: GetState
        return workspace:GetAttribute("GameState");
    end,

    SetState = function(p5) -- Line: 34, Name: SetState
        -- upvalues: RunService (copy), u1 (copy)
        local v6 = RunService:IsServer();
        assert(v6, "This method is only available to the server.");
        local v7 = table.find(u1, p5);
        local v8 = `"{p5}" is not a valid state!`;
        assert(v7, v8);

        if true then
            workspace:SetAttribute("GameState", p5);
        end;
    end,

    ListenToState = function(u9) -- Line: 41, Name: ListenToState
        -- upvalues: Observers (copy)
        local u10 = nil;

        return Observers.observeAttribute(workspace, "GameState", function(p11) -- Line: 43
            -- upvalues: u9 (copy), u10 (ref)
            u9(u10, p11);
            u10 = p11;
        end);
    end
};