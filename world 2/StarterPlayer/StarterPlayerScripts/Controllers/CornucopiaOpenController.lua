-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 6
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local SeedPackEffect = require(script.Parent.SeedPackOpenController.SeedPackEffect);
local LocalPlayer = Players.LocalPlayer;

function v1.Init(p2) -- Line: 14
end;

function v1.Start(p3) -- Line: 17
    -- upvalues: Networking (copy), SeedPackEffect (copy), LocalPlayer (copy)
    Networking.Cornucopia.ReplicateOpenCornucopia.OnClientEvent:Connect(function(u4, u5, u6, u7, p8, u9, u10) -- Line: 20
        -- upvalues: SeedPackEffect (ref), LocalPlayer (ref), Networking (ref)
        if not (u4 and u4.Character) then
            return;
        end;

        local HumanoidRootPart = u4.Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local Position = HumanoidRootPart.Position;
        local u11 = CFrame.new(p8, p8 + CFrame.new(p8, Position).LookVector);
        task.spawn(function() -- Line: 29
            -- upvalues: SeedPackEffect (ref), u5 (copy), u7 (copy), Position (copy), u11 (copy), u6 (copy), u9 (copy), u10 (copy), u4 (copy), LocalPlayer (ref), Networking (ref)
            SeedPackEffect.Open(u5, "Cornucopia", u7, Position, u11, u6, u9, u10, true, u4, true);

            if u4 == LocalPlayer then
                Networking.Cornucopia.ConfirmCornucopia:Fire(u5);
            end;
        end);
    end);
end;

return v1;