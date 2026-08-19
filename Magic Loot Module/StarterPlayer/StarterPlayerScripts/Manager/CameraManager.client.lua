-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CameraModule = UtilsSystem.CameraModule;
local HumanModule = UtilsSystem.HumanModule;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local v1, v2 = CameraModule.Init();

if not v1 then
    warn("CameraManager: CameraModule.Init 失败", v2);
end;

NetWork.RegisterClientRemoteEvent(NetMsg.PLAYER_CAMERA_ALIGN, function() -- Line: 40, Name: _onPlayerCameraAlign
    -- upvalues: HumanModule (copy), LocalPlayer (copy), CameraModule (copy), Workspace (copy)
    local v3 = HumanModule.GetHumanoidRootPart(LocalPlayer);

    if not v3 then
        return;
    end;

    local v4 = CameraModule.GetCamera() or Workspace.CurrentCamera;

    if not v4 then
        return;
    end;

    v4.CFrame = CFrame.new(v3.Position - v3.CFrame.LookVector * (v4.CFrame.Position - v3.CFrame.Position).Magnitude, v3.Position);
end);