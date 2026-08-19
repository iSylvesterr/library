-- Decompiled with Potassium's decompiler.

local v1 = {};
local LocalPlayer = game.Players.LocalPlayer;
game:GetService("RunService");
game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
workspace:WaitForChild("__DEBRIS");
local _ = ReplicatedStorage.Assets.Orb;
local _ = {
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(0, 255, 218),
    Color3.fromRGB(0, 255, 182),
    Color3.fromRGB(0, 255, 145),
    Color3.fromRGB(0, 255, 109),
    Color3.fromRGB(0, 255, 73),
    Color3.fromRGB(0, 255, 36),
    Color3.fromRGB(0, 255, 0)
};

local function GetRootPart() -- Line: 22
    -- upvalues: LocalPlayer (copy)
    local v2 = LocalPlayer and LocalPlayer.Character;

    if v2 then
        return v2:FindFirstChild("HumanoidRootPart") or v2:FindFirstChild("Torso");
    end;

    return nil;
end;

local function playOrbs(p3, p4, p5, p6) -- Line: 30
end;

function v1.Play(p7, p8, p9) -- Line: 88
    -- upvalues: playOrbs (copy)
    return playOrbs(p7, p8, p9);
end;

function v1.PlayOnDonate(p10, p11, p12, p13) -- Line: 92
    -- upvalues: playOrbs (copy)
    return playOrbs(p10, p11, p12, p13);
end;

return v1;