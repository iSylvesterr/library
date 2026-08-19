-- Decompiled with Potassium's decompiler.

local CurrentCamera = workspace.CurrentCamera;
game.Players.LocalPlayer.CharacterAdded:Connect(function(p1) -- Line: 5
    -- upvalues: CurrentCamera (copy)
    CurrentCamera.CameraSubject = p1;
    CurrentCamera.CameraType = Enum.CameraType.Custom;
end);