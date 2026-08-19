-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Network = require(ReplicatedStorage.Library.Client.Network);
local LocalPlayer = Players.LocalPlayer;

local function requestCharacterReset(p1) -- Line: 17
    -- upvalues: Network (copy)
    Network.Fire(Network.NET_MAP.ClientCharacter.REQUEST_CHARACTER_RESET, p1);
end;

LocalPlayer.CharacterAdded:Connect(function(u2) -- Line: 21, Name: bindCharacter
    -- upvalues: Network (copy)
    u2:WaitForChild("Humanoid").Died:Connect(function() -- Line: 24
        -- upvalues: u2 (copy), Network (ref)
        Network.Fire(Network.NET_MAP.ClientCharacter.REQUEST_CHARACTER_RESET, u2);
    end);
end);

if LocalPlayer.Character then
    local Character = LocalPlayer.Character;
    Character:WaitForChild("Humanoid").Died:Connect(function() -- Line: 24
        -- upvalues: Character (copy), Network (copy)
        Network.Fire(Network.NET_MAP.ClientCharacter.REQUEST_CHARACTER_RESET, Character);
    end);
end;