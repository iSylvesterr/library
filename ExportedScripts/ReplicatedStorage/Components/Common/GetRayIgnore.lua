-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local Debris = workspace:WaitForChild("Debris");

return function() -- Line: 21
    -- upvalues: Debris (copy), CurrentCamera (copy), LocalPlayer (copy)
    local v1 = {};
    table.insert(v1, Debris);
    table.insert(v1, CurrentCamera);
    local Map = workspace:FindFirstChild("Map");

    if Map then
        local Cameras = Map:FindFirstChild("Cameras");
        local Barriers = Map:FindFirstChild("Barriers");
        local Ambience = Map:FindFirstChild("Ambience");

        if Cameras then
            table.insert(v1, Cameras);
        end;

        if Barriers then
            table.insert(v1, Barriers);
        end;

        if Ambience then
            table.insert(v1, Ambience);
        end;

        local Zones = Map:FindFirstChild("Zones");

        if Zones then
            local Spawns = Zones:FindFirstChild("Spawns");
            local Sites = Zones:FindFirstChild("Sites");

            if Spawns then
                table.insert(v1, Spawns);
            end;

            if Sites then
                table.insert(v1, Sites);
            end;
        end;
    end;

    if LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:IsDescendantOf(workspace)) then
        table.insert(v1, LocalPlayer.Character);
    end;

    return v1;
end;