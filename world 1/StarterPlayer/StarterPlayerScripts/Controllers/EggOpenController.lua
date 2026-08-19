-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local EggEffect = require(script.EggEffect);

function v1.Init(p2) -- Line: 10
end;

function v1.Start(p3) -- Line: 13
    -- upvalues: Networking (copy), EggEffect (copy), Players (copy)
    Networking.Egg.ReplicateOpenEgg.OnClientEvent:Connect(function(u4, u5, u6, u7, p8, u9, u10) -- Line: 14
        -- upvalues: EggEffect (ref), Players (ref), Networking (ref)
        if not (u4 and u4.Character) then
            return;
        end;

        local HumanoidRootPart = u4.Character:FindFirstChild("HumanoidRootPart");

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            return;
        end;

        local Position = HumanoidRootPart.Position;
        local u11 = CFrame.new(p8, p8 + CFrame.new(p8, Position).LookVector);

        if u9 == "" then
            u9 = nil;
        end;

        if u10 == "" then
            u10 = nil;
        end;

        task.spawn(function() -- Line: 29
            -- upvalues: EggEffect (ref), u5 (copy), u6 (copy), u7 (copy), Position (copy), u11 (copy), u4 (copy), u9 (copy), u10 (copy), Players (ref), Networking (ref)
            EggEffect.Open(u5, u6, u7, Position, u11, u4, u9, u10);

            if u4 == Players.LocalPlayer then
                Networking.Egg.ConfirmEgg:Fire(u5, u6, u7);
            end;
        end);
    end);
    Networking.Egg.ReplicateHatchInPlace.OnClientEvent:Connect(function(u12, u13, u14, u15, u16, u17, u18) -- Line: 42
        -- upvalues: EggEffect (ref), Players (ref), Networking (ref)
        if not u12 then
            return;
        end;

        if u17 == "" then
            u17 = nil;
        end;

        if u18 == "" then
            u18 = nil;
        end;

        task.spawn(function() -- Line: 48
            -- upvalues: EggEffect (ref), u13 (copy), u14 (copy), u15 (copy), u16 (copy), u12 (copy), u17 (copy), u18 (copy), Players (ref), Networking (ref)
            EggEffect.OpenInPlace(u13, u14, u15, u16, u12, u17, u18);

            if u12 == Players.LocalPlayer then
                Networking.Egg.ConfirmEgg:Fire(u13, u14, u15);
            end;
        end);
    end);
end;

return v1;