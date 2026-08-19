-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("UserInputService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local v1 = Knit.CreateController({
    Name = "SprintController"
});
local _ = Knit.Player;

function v1.ToggleSprint(p2, p3) -- Line: 22
end;

function v1.AddKeyBind(p4) -- Line: 34
end;

function v1.IsSprinting(p5) -- Line: 65
    return p5.toggle;
end;

function v1.KnitStart(u6) -- Line: 70
    -- upvalues: Players (copy)
    u6.toggle = false;
    u6.hold = false;
    u6.DataClient.EV_FIRST_UPDATE:Connect(function() -- Line: 74
        -- upvalues: u6 (copy)
        u6:AddKeyBind();
    end);
    Players.LocalPlayer.CameraMaxZoomDistance = 30;
end;

function v1.KnitInit(p7) -- Line: 81
    -- upvalues: Knit (copy)
    p7.SprintService = Knit.GetService("SprintService");
    p7.DataClient = Knit.GetController("DataClient");
    p7.SoundController = Knit.GetController("SoundController");
end;

return v1;