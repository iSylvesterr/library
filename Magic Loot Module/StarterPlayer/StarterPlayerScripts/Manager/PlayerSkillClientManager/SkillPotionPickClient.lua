-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TipsModule = UtilsSystem.TipsModule;

return {
    resolvePickOverlay = function(p1, p2, p3, p4) -- Line: 40, Name: resolvePickOverlay
        if p1 == 0 then
            return false, false;
        end;

        if p2 <= 0 or p3 <= 0 then
            return false, false;
        end;

        return p2 ~= p1, p3 ~= p1;
    end,

    invokeSetSkillSlot = function(u5) -- Line: 61, Name: invokeSetSkillSlot
        -- upvalues: NetWork (copy), NetMsg (copy), TipsModule (copy), LocalPlayer (copy)
        local success, result = pcall(function() -- Line: 62
            -- upvalues: NetWork (ref), NetMsg (ref), u5 (copy)
            return NetWork.InvokeServer(NetMsg.SET_SKILL_SLOT, {
                slotIndex = u5
            });
        end);

        if success and result then
            TipsModule.NormalTips(LocalPlayer, "药水使用成功");

            return true;
        end;

        TipsModule.ErrorTips(LocalPlayer, "使用失败");

        return false;
    end
};