-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local GetData = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).GetData;
local v1 = {};

local function _isSettingOn(u2) -- Line: 47
    -- upvalues: GetData (copy)
    if not u2 then
        return true;
    end;

    if type(GetData.GetSetting) ~= "function" then
        return true;
    end;

    local success, result = pcall(function() -- Line: 54
        -- upvalues: GetData (ref), u2 (copy)
        return GetData.GetSetting(u2, "PlayerSkillEffect");
    end);

    return (not success or result == nil) and true or result == 1;
end;

function v1.IsEnabled(u3) -- Line: 68
    -- upvalues: GetData (copy)
    if not u3 then
        return true;
    end;

    if type(GetData.GetSetting) ~= "function" then
        return true;
    end;

    local success, result = pcall(function() -- Line: 54
        -- upvalues: GetData (ref), u3 (copy)
        return GetData.GetSetting(u3, "PlayerSkillEffect");
    end);

    return (not success or result == nil) and true or result == 1;
end;

function v1.IsLocalEnabled() -- Line: 76
    -- upvalues: RunService (copy), Players (copy), GetData (copy)
    if not RunService:IsClient() then
        return true;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return true;
    end;

    if type(GetData.GetSetting) ~= "function" then
        return true;
    end;

    local success, result = pcall(function() -- Line: 54
        -- upvalues: GetData (ref), LocalPlayer (copy)
        return GetData.GetSetting(LocalPlayer, "PlayerSkillEffect");
    end);

    return (not success or result == nil) and true or result == 1;
end;

return v1;