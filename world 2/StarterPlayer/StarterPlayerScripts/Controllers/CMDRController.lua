-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local DevAllowedIDs = require(ReplicatedStorage.SharedModules.DevAllowedIDs);

local function IsAllowed(p1) -- Line: 18
    -- upvalues: RunService (copy), DevAllowedIDs (copy)
    return RunService:IsStudio() and true or (DevAllowedIDs.IsAllowed(p1.UserId) and true or game.PlaceId == 1);
end;

return {
    StartOrder = 10,

    Init = function(p2) -- Line: 28, Name: Init
        -- upvalues: Players (copy), RunService (copy), DevAllowedIDs (copy), ReplicatedStorage (copy)
        local LocalPlayer = Players.LocalPlayer;

        if not RunService:IsStudio() and (not DevAllowedIDs.IsAllowed(LocalPlayer.UserId) and game.PlaceId ~= 1) then
            return;
        end;

        local topbarplus = require(ReplicatedStorage.ClientModules.topbarplus);
        local CmdrClient = ReplicatedStorage:WaitForChild("CmdrClient", 10);

        if not CmdrClient then
            return;
        end;

        local u3 = require(CmdrClient);
        local v4 = topbarplus.new();
        v4:setName("CmdrIcon");
        v4:setLabel("Cmdr");
        v4:setRight();
        v4:setOrder(100);
        v4:setCaption("Toggle command console (F2)");
        v4:bindToggleKey(Enum.KeyCode.F2);
        v4.deselectWhenOtherIconSelected = false;
        v4.selected:Connect(function() -- Line: 49
            -- upvalues: u3 (copy)
            u3:Show();
        end);
        v4.deselected:Connect(function() -- Line: 53
            -- upvalues: u3 (copy)
            u3:Hide();
        end);
        u3:SetActivationKeys({});
    end,

    Start = function(p5) -- Line: 60, Name: Start
    end
};