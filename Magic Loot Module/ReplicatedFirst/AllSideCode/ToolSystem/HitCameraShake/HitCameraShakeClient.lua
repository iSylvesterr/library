-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem);
local GetData = UtilsSystem.GetData;
local CameraModule = UtilsSystem.CameraModule;
local LocalPlayer = UtilsSystem.LocalPlayer;
local v1 = {};
local u2 = {};

local function _isShakeEnabled() -- Line: 28
    -- upvalues: LocalPlayer (copy), GetData (copy)
    return (not LocalPlayer or type(GetData.GetSetting) ~= "function") and true or GetData.GetSetting(LocalPlayer, "Shake") == 1;
end;

local function _isCooldownReady(p3, p4) -- Line: 42
    -- upvalues: u2 (copy)
    if p4 <= 0 then
        return true;
    end;

    local v5 = os.clock();
    local v6 = u2[p3];

    return (not v6 or v5 - v6 >= p4) and true or false;
end;

local function _markCooldown(p7) -- Line: 59
    -- upvalues: u2 (copy)
    u2[p7] = os.clock();
end;

function v1.handleIncoming(p8, p9) -- Line: 69
    -- upvalues: LocalPlayer (copy), GetData (copy), u2 (copy), CameraModule (copy)
    if type(p8) ~= "number" then
        return;
    end;

    if LocalPlayer and type(GetData.GetSetting) == "function" and GetData.GetSetting(LocalPlayer, "Shake") ~= 1 then
        return;
    end;

    local v10 = type(p9) == "number" and p9 and p9 or 0;
    local v11;

    if v10 <= 0 then
        v11 = true;
    else
        local v12 = os.clock();
        local v13 = u2[p8];
        v11 = (not v13 or v12 - v13 >= v10) and true or false;
    end;

    if not v11 then
        return;
    end;

    if CameraModule.CameraShakeOnce(p8) then
        u2[p8] = os.clock();
    end;
end;

return v1;