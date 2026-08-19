-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
game:GetService("Debris");
local RunService = game:GetService("RunService");
local Yarn = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("Yarn");
local YarnHit = script:WaitForChild("YarnHit");
local Throw = script:WaitForChild("Throw");
local Meow = script:WaitForChild("Meow");
local Visuals = workspace:WaitForChild("World"):WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 20, Name: Play
        -- upvalues: Yarn (copy), Visuals (copy), Throw (copy), Meow (copy), RunService (copy), YarnHit (copy)
        local _ = p1.Target;
        local TowerPosition = p1.TowerPosition;
        local TargetPosition = p1.TargetPosition;
        local u2 = Yarn:Clone();

        if u2 then
            u2.Parent = Visuals;
            u2:PivotTo(CFrame.new(TowerPosition));
            local v3 = Throw:Clone();
            v3.Parent = u2.PrimaryPart;
            v3:Play();
            local v4 = Meow:Clone();
            v4.Parent = u2.PrimaryPart;
            v4.PlaybackSpeed = math.random(75, 125) / 100;
            v4:Play();
            local u5 = tick();
            local v6 = (TowerPosition + TargetPosition) / 2;
            local u7 = Vector3.new(v6.X, v6.Y + 6, v6.Z);
            local u8 = nil;
            u8 = RunService.Heartbeat:Connect(function() -- Line: 48
                -- upvalues: u5 (copy), TowerPosition (copy), u7 (ref), TargetPosition (copy), u2 (copy), u8 (ref), YarnHit (ref)
                local v9 = (tick() - u5) / 0.5;
                local v10 = math.clamp(v9, 0, 1);
                local v11 = TowerPosition:Lerp(u7, v10):Lerp(u7:Lerp(TargetPosition, v10), v10);
                local v12 = math.clamp(v10 + 0.02, 0, 1);
                local v13 = TowerPosition:Lerp(u7, v12):Lerp(u7:Lerp(TargetPosition, v12), v12);
                u2:PivotTo((CFrame.lookAt(v11, v13)));

                if v10 >= 1 then
                    u8:Disconnect();
                    local v14 = YarnHit:Clone();
                    v14.Parent = u2.PrimaryPart;
                    v14:Play();
                    u2:Destroy();
                end;
            end);
        end;
    end
};