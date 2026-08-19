-- Decompiled with Potassium's decompiler.

game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local CreateTrail = require(script.CreateTrail);

return {
    Init = function(u1, p2) -- Line: 11, Name: Init
        -- upvalues: TweenService (copy), CreateTrail (copy), Debris (copy)
        local u3 = p2.Radius or nil;
        local u4 = p2.Lifetime or (1 / 0);
        local v5 = p2.Time or 0.45;
        local u6 = p2.Offset or 0.05;

        for _ = 1, p2.Frequency or (1 / 0) do
            local u7 = 0;
            local v8 = p2.Size or 0.275;
            local v9 = p2.Color or Color3.fromRGB(255, 255, 255);
            local v10 = p2.Transparency or 0;
            local v11 = TweenInfo.new(v5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1);
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CanTouch = false;
            Part.CanQuery = false;
            Part.CFrame = u1.CFrame * CFrame.new(0, -(u1.Size.Y / 2), 0);
            Part.Size = Vector3.new(1, 1, 1);
            Part.Transparency = 1;
            Part.Parent = u1;
            TweenService:Create(Part, v11, {
                Orientation = Part.Orientation + Vector3.new(0, 360, 0)
            }):Play();
            local Part2 = Instance.new("Part");
            Part2.Anchored = true;
            Part2.CanCollide = false;
            Part2.CanTouch = false;
            Part2.CanQuery = false;
            Part2.CFrame = Part.CFrame;
            Part2.Size = Vector3.new(1, 1, 1);
            Part2.Transparency = 1;
            Part2.Parent = workspace.Temporary;
            local v12 = CreateTrail(Part2, v8, v9, v10);
            local v15 = task.spawn(function() -- Line: 54
                -- upvalues: u7 (ref), u4 (copy), Part (copy), u6 (copy), u3 (copy), u1 (copy), Part2 (copy)
                while true do
                    local v13 = task.wait(0);
                    u7 = (u7 + v13 / u4) % 1;
                    Part.CFrame = Part.CFrame * CFrame.new(0, u6 * v13, 0);
                    local v14 = u3 or math.sqrt(u1.Size.X ^ 2 + u1.Size.Y ^ 2) / 2;
                    Part2.CFrame = Part.CFrame * CFrame.Angles(0, 6.283185307179586 * u7, 0) * CFrame.new(0, 0, v14);
                end;
            end);
            task.wait(1.35);
            v12.Enabled = false;
            Debris:AddItem(Part, 1);
            Debris:AddItem(Part2, 1);
            task.wait(1);
            task.cancel(v15);
        end;
    end
};