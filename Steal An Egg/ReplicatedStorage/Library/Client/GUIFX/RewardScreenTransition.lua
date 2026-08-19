-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Audio = require(ReplicatedStorage.Library.Audio);
local GetHolder = require(ReplicatedStorage.Library.Client.GUIFX.GetHolder);

return function() -- Line: 12
    -- upvalues: Audio (copy), GetHolder (copy), TweenService (copy)
    Audio.Play(91650233387983, script, 1, 0.8);
    Audio.Play(112792997660073, script, 1, 1);
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundTransparency = 0;
    Frame.BackgroundColor3 = Color3.fromRGB(255, 175, 0);
    Frame.Parent = GetHolder();
    local v1 = TweenService:Create(Frame, TweenInfo.new(1.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.05), {
        BackgroundTransparency = 1
    });
    v1.Completed:Once(function() -- Line: 26
        -- upvalues: Frame (copy)
        Frame:Destroy();
    end);
    local v2 = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0.05), {
        FieldOfView = 100
    });
    local u3 = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        FieldOfView = 70
    });
    v2.Completed:Once(function() -- Line: 40
        -- upvalues: u3 (copy)
        u3:Play();
    end);
    v2:Play();
    v1:Play();
end;