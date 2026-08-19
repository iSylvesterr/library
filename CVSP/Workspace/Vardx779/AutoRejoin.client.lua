-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TeleportService = game:GetService("TeleportService");
local v1 = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait();
local v2 = v1.Character or v1.CharacterAdded:Wait();
local Humanoid = v2:WaitForChild("Humanoid");
local u3 = tick();
Humanoid.Running:Connect(function(p4) -- Line: 10
    -- upvalues: u3 (ref)
    if p4 >= 0.01 then
        u3 = tick();
    end;
end);
Humanoid.Jumping:Connect(function(p5) -- Line: 16
    -- upvalues: u3 (ref)
    if p5 then
        u3 = tick();
    end;
end);

while v2.Parent do
    if tick() - u3 >= 1190 then
        TeleportService:TeleportAsync(game.PlaceId);
    end;

    task.wait(1);
end;