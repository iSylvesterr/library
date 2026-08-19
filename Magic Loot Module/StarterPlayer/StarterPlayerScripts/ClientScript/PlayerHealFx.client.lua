-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local HumanModule = UtilsSystem.HumanModule;
local LocalPlayer = UtilsSystem.LocalPlayer;
UtilsSystem.NetWork.RegisterClientRemoteEvent(UtilsSystem.NetMsg.PLAYER_HEAL_FX, function() -- Line: 28, Name: _playHealFx
    -- upvalues: HumanModule (copy), LocalPlayer (copy), FXUtil (copy)
    local v1 = HumanModule.GetCharacter(LocalPlayer);

    if not v1 then
        return;
    end;

    local HumanoidRootPart = v1:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        FXUtil.PlayEffect("回血特效", HumanoidRootPart.CFrame, 3, 3);
    end;
end);