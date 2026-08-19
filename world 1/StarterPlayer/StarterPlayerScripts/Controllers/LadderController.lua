-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;

function v1.Init(p2) -- Line: 11
end;

function v1.Start(u3) -- Line: 14
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        u3:SetupCharacter(Character);
    end;

    LocalPlayer.CharacterAdded:Connect(function(p4) -- Line: 19
        -- upvalues: u3 (copy)
        u3:SetupCharacter(p4);
    end);
end;

function v1.SetupCharacter(u5, p6) -- Line: 24
    p6.ChildAdded:Connect(function(u7) -- Line: 25, Name: tryConnect
        -- upvalues: u5 (copy)
        if u7:IsA("Tool") and u7:GetAttribute("Ladder") then
            u7.Activated:Connect(function() -- Line: 27
                -- upvalues: u5 (ref), u7 (copy)
                u5:OnToolActivated(u7);
            end);
        end;
    end);

    for _, child in p6:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("Ladder") then
            child.Activated:Connect(function() -- Line: 27
                -- upvalues: u5 (copy), child (copy)
                u5:OnToolActivated(child);
            end);
        end;
    end;
end;

function v1.OnToolActivated(p8, p9) -- Line: 39
    -- upvalues: LocalPlayer (copy), Networking (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    if p9.Parent ~= Character then
        return;
    end;

    local v10 = p9:GetAttribute("CooldownEnd");

    if v10 and os.clock() < v10 then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v11 = HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 6;
    local v12 = p9:GetAttribute("Ladder");
    Networking.Place.PlaceLadder:Fire(v11, v12, p9);
    p9:SetAttribute("CooldownEnd", os.clock() + 60);
end;

return v1;