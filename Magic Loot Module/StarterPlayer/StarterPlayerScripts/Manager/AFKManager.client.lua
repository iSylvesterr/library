-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SystemGameConfig = UtilsSystem.SystemGameConfig;

local function _getConfigNumber(p1, p2) -- Line: 30
    -- upvalues: SystemGameConfig (copy)
    local v3 = SystemGameConfig.GetValue(p1);

    if typeof(v3) == "number" and v3 > 0 then
        return v3;
    end;

    return p2;
end;

local v4 = SystemGameConfig.GetValue({ "AFK", "挂机超时秒" });
local u5 = (typeof(v4) ~= "number" or v4 <= 0) and 1080 or v4;
local v6 = SystemGameConfig.GetValue({ "AFK", "空闲重置秒" });
local u7 = (typeof(v6) ~= "number" or v6 <= 0) and 60 or v6;
local u8 = false;
LocalPlayer.Idled:Connect(function(p9) -- Line: 55, Name: _onIdled
    -- upvalues: u5 (copy), u8 (ref), NetWork (copy), NetMsg (copy), u7 (copy)
    if u5 >= p9 then
        if p9 < u7 then
            u8 = false;
        end;

        return;
    end;

    if u8 then
        return;
    end;

    u8 = true;
    NetWork.FireServer(NetMsg.AFK_MOVE);
end);