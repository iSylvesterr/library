-- Decompiled with Potassium's decompiler.

local Knit = require(game.ReplicatedStorage.Packages.Knit);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Client = ReplicatedStorage:WaitForChild("Client");
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info");
local UI_Manager = require(Client.Controllers.UI_Manager);
require(ReplicatedStorage.Packages.Maid);
require(Info:WaitForChild("CustomEnum"));
require(Info:WaitForChild("GlobalVars"));
local v1 = Knit.CreateController({
    Name = "OpeningPopupQue"
});
local PlayerGui = game.Players.LocalPlayer.PlayerGui;
PlayerGui:WaitForChild("Windows");
local u2 = {};
local u3 = true;

function v1.OpenNextInQue(p4) -- Line: 31
    -- upvalues: u2 (ref), u3 (ref)
    if #u2 < 1 then
        u3 = false;

        return;
    end;

    u2[1].func();
end;

function v1.KnitStart(u5) -- Line: 39
    -- upvalues: PlayerGui (copy), UI_Manager (copy), u2 (ref)
    u5.DataClient.EV_FIRST_UPDATE:Connect(function() -- Line: 40
        -- upvalues: PlayerGui (ref), u5 (copy)
        while PlayerGui:FindFirstChild("LoadScreen") do
            task.wait();
        end;

        u5:OpenNextInQue();
    end);
    UI_Manager.WindowClosed:Connect(function(p6, p7, p8, p9) -- Line: 62
        -- upvalues: u2 (ref), u5 (copy)
        if #u2 < 1 then
            return;
        end;

        if p8 then
            return;
        end;

        if p6 == u2[1].window then
            table.remove(u2, 1);
            u5:OpenNextInQue();
        end;
    end);
    UI_Manager.WindowOpened:Connect(function(p10) -- Line: 71
        -- upvalues: u2 (ref)
        if #u2 < 1 then
            return;
        end;

        if p10 ~= u2[1].window then
            print("CANCEL ", p10);
            u2 = {};
        end;
    end);
end;

function v1.KnitInit(p11) -- Line: 81
    -- upvalues: Knit (copy)
    p11.DataClient = Knit.GetController("DataClient");
end;

return v1;