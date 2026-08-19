-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
game:GetService("ReplicatedStorage");
game:GetService("RunService");
game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
LocalPlayer:WaitForChild("PlayerGui");
local Gardens = workspace:WaitForChild("Gardens");

function v1.Init(p2) -- Line: 12
end;

local function getGardenSpawnPoint() -- Line: 15
    -- upvalues: LocalPlayer (copy), Gardens (copy)
    local v3 = LocalPlayer:GetAttribute("PlotId");

    if not v3 then
        return nil;
    end;

    local v4 = Gardens:FindFirstChild("Plot" .. tostring(v3));

    if v4 then
        return v4:FindFirstChild("SpawnPoint");
    end;

    return nil;
end;

function v1.Start(p5) -- Line: 23
    -- upvalues: LocalPlayer (copy), Gardens (copy)
    local function charAdded(u6) -- Line: 24
        -- upvalues: LocalPlayer (ref), Gardens (ref)
        local Humanoid = u6:WaitForChild("Humanoid");
        Humanoid:GetPropertyChangedSignal("Health"):Connect(function() -- Line: 26
            -- upvalues: Humanoid (copy), LocalPlayer (ref), Gardens (ref), u6 (copy)
            if Humanoid.Health <= 1 then
                local v7 = LocalPlayer:GetAttribute("PlotId");
                local v8;

                if v7 then
                    local v9 = Gardens:FindFirstChild("Plot" .. tostring(v7));

                    if v9 then
                        v8 = v9:FindFirstChild("SpawnPoint");
                    else
                        v8 = nil;
                    end;
                else
                    v8 = nil;
                end;

                if v8 then
                    u6:PivotTo(v8.CFrame + Vector3.new(0, 3, 0));
                    Humanoid.Health = 100;
                end;
            end;
        end);
    end;
end;

return v1;