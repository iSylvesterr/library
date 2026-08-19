-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local HatchConfig = require(script.Parent.HatchConfig);
local LocalPlayer = UtilsSystem.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;

return {
    getCameraCFrame = function() -- Line: 22, Name: getCameraCFrame
        -- upvalues: CurrentCamera (copy)
        return CurrentCamera.CFrame;
    end,

    setZoomForHatch = function() -- Line: 29, Name: setZoomForHatch
        -- upvalues: LocalPlayer (copy), HatchConfig (copy)
        LocalPlayer.CameraMinZoomDistance = HatchConfig.CAMERA_MIN_ZOOM_MAX;
    end,

    restoreZoom = function() -- Line: 36, Name: restoreZoom
        -- upvalues: LocalPlayer (copy), HatchConfig (copy)
        LocalPlayer.CameraMinZoomDistance = HatchConfig.CAMERA_MIN_ZOOM_MIN;
    end,

    getCamera = function() -- Line: 44, Name: getCamera
        -- upvalues: CurrentCamera (copy)
        return CurrentCamera;
    end
};