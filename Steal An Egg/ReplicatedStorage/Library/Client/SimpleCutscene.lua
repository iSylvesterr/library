-- Decompiled with Potassium's decompiler.

local v1 = {};
local TweenService = game:GetService("TweenService");

function v1.Start_Cutscene(p2) -- Line: 4
end;

function v1.End_Cutscene(p3) -- Line: 6
    local CurrentCamera = game.Workspace.CurrentCamera;
    CurrentCamera.CameraSubject = p3.Character.Humanoid;
    CurrentCamera.CameraType = Enum.CameraType.Fixed;
end;

local SimpleFOV = require(script.Parent.SimpleFOV);

function v1.Flash(p4, p5) -- Line: 13
    -- upvalues: TweenService (copy), SimpleFOV (copy)
    local u6 = TweenInfo.new(p5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0);
    local u7 = TweenInfo.new(p5 * 4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
    local Frame = p4.PlayerGui.Rejoin_UI.Frame;
    TweenService:Create(Frame, u6, {
        BackgroundTransparency = 0
    }):Play();
    SimpleFOV.Change_FOV(90, u6.Time);
    task.spawn(function() -- Line: 21
        -- upvalues: u6 (copy), SimpleFOV (ref), u7 (copy), TweenService (ref), Frame (copy)
        task.wait(u6.Time + 1.5);
        SimpleFOV.Change_FOV(70, u7.Time / 2);
        TweenService:Create(Frame, u7, {
            BackgroundTransparency = 1
        }):Play();
    end);
end;

return v1;