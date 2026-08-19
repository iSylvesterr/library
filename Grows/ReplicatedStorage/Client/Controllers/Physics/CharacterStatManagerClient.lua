-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Knit = require(ReplicatedStorage.Packages.Knit);
require(ReplicatedStorage.Packages.Signal);
local LocalPlayer = Players.LocalPlayer;
local v1 = Knit.CreateController({
    Name = "CharacterStatManagerClient"
});

function v1.KnitStart(p2) -- Line: 14
    -- upvalues: Knit (copy), LocalPlayer (copy)
    Knit.GetService("CharacterStatManager").SetJumpEnabled:Connect(function(p3) -- Line: 17
        -- upvalues: LocalPlayer (ref)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local Humanoid = Character:FindFirstChild("Humanoid");

        if not Humanoid then
            return;
        end;

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, p3);
    end);
end;

return v1;