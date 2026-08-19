-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local PlayerData = UtilsSystem.PlayerData;
local NetWork = UtilsSystem.NetWork;
NetWork.FireServer(NetMsg.PLAYER_DATA_REQUEST);

while task.wait(1) do
    if PlayerData.GetPlrData(LocalPlayer) ~= nil then
        return;
    end;

    NetWork.FireServer(NetMsg.PLAYER_DATA_REQUEST);
end;

print("PlayerData Init");