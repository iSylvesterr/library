-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);

if UtilsSystem.SystemGameConfig.GetValue({ "SmartBone", "启用" }) == false then
    return;
end;

local SmartBone = UtilsSystem.SmartBone;
local AddListen = UtilsSystem.AddListen;
local Log = UtilsSystem.Log;
local Setting = UtilsSystem.LocalPlayer:WaitForChild("Setting", (1 / 0));
local Pyhsic = Setting:WaitForChild("Pyhsic", (1 / 0));
local GraphicsQuality = Setting:WaitForChild("GraphicsQuality", (1 / 0));
local u1 = nil;

local function _updateEnabled() -- Line: 63
    -- upvalues: Pyhsic (copy), GraphicsQuality (copy), u1 (ref), SmartBone (copy), Log (copy)
    local v2;

    if Pyhsic.Value == 1 then
        v2 = GraphicsQuality.Value == 1;
    else
        v2 = false;
    end;

    if v2 then
        if u1 == nil then
            local v3 = SmartBone.Start();

            if type(v3) == "table" and type(v3.Stop) == "function" then
                u1 = v3;

                return;
            end;

            Log.warn("[SmartBoneManager] SmartBone.Start 未返回 Stop 句柄");
        end;
    elseif u1 ~= nil then
        u1.Stop();
        u1 = nil;
    end;
end;

AddListen.NumValueAdd(Pyhsic, function(p4) -- Line: 85
    -- upvalues: _updateEnabled (copy)
    _updateEnabled();
end);
AddListen.NumValueAdd(GraphicsQuality, function(p5) -- Line: 88
    -- upvalues: _updateEnabled (copy)
    _updateEnabled();
end);