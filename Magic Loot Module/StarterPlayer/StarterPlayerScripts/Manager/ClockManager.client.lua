-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);

if UtilsSystem.SystemGameConfig.GetValue({ "Clock", "启用" }) == false then
    return;
end;

local AddListen = UtilsSystem.AddListen;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TimeSlot = game:GetService("Lighting"):WaitForChild("TimeSlot", (1 / 0));

local function _isDungeonLightingActive() -- Line: 41
    -- upvalues: LocalPlayer (copy)
    local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");

    if InDungeonChallenge and (InDungeonChallenge:IsA("NumberValue") and InDungeonChallenge.Value > 0) then
        return true;
    end;

    local DungeonAggroStage = LocalPlayer:FindFirstChild("DungeonAggroStage");

    return DungeonAggroStage and (DungeonAggroStage:IsA("NumberValue") and DungeonAggroStage.Value > 0) and true or false;
end;

AddListen.NumValueAdd(TimeSlot, function(p1) -- Line: 53
    -- upvalues: _isDungeonLightingActive (copy), NetWork (copy), NetMsg (copy)
    if _isDungeonLightingActive() then
        return;
    end;

    if p1 == "Day" or p1 == "Night" then
        NetWork.FireBindable(NetMsg.LIGHTING_CHANGE, "世界1", 5);
    end;
end);