-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
local Arrow = EffectAssets:WaitForChild("Arrow");
local RockHit = EffectAssets:WaitForChild("RockHit");
local Hit = script:WaitForChild("Hit");
local BowShoot = script:WaitForChild("BowShoot");
local Bow = script:WaitForChild("Bow");
local Visuals = workspace:WaitForChild("World"):WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 21, Name: Play
        -- upvalues: Arrow (copy), Visuals (copy), BowShoot (copy), Bow (copy), RunService (copy), RockHit (copy), Hit (copy), Debris (copy)
        local Target = p1.Target;
        local TowerPosition = p1.TowerPosition;
        local TargetPosition = p1.TargetPosition;
        local u2 = Arrow:Clone();
        u2.Parent = Visuals;
        u2:PivotTo(CFrame.new(TowerPosition));
        local v3 = BowShoot:Clone();
        v3.Parent = u2.PrimaryPart;
        v3:Play();
        local v4 = Bow:Clone();
        v4.Parent = u2.PrimaryPart;
        v4:Play();

        if u2 then
            task.delay(0.3, function() -- Line: 40
                -- upvalues: TowerPosition (copy), TargetPosition (copy), RunService (ref), u2 (copy), RockHit (ref), Target (copy), Hit (ref), Visuals (ref), Debris (ref)
                local u5 = tick();
                local v6 = (TowerPosition + TargetPosition) / 2;
                local u7 = Vector3.new(v6.X, v6.Y + 0.5, v6.Z);
                local u8 = nil;
                u8 = RunService.Heartbeat:Connect(function() -- Line: 50
                    -- upvalues: u5 (copy), TowerPosition (ref), u7 (ref), TargetPosition (ref), u2 (ref), u8 (ref), RockHit (ref), Target (ref), Hit (ref), Visuals (ref), Debris (ref)
                    local v9 = (tick() - u5) / 0.2;
                    local v10 = math.clamp(v9, 0, 1);
                    local v11 = TowerPosition:Lerp(u7, v10):Lerp(u7:Lerp(TargetPosition, v10), v10);
                    local v12 = math.clamp(v10 + 0.02, 0, 1);
                    local v13 = TowerPosition:Lerp(u7, v12):Lerp(u7:Lerp(TargetPosition, v12), v12);
                    u2:PivotTo((CFrame.lookAt(v11, v13)));

                    if v10 >= 1 then
                        u8:Disconnect();
                        local v14 = RockHit:Clone();

                        if Target and (Target.PrimaryPart and Target.PrimaryPart.Parent) then
                            v14.Position = Target.PrimaryPart.Position;
                        else
                            v14.Position = TargetPosition;
                        end;

                        local v15 = Hit:Clone();
                        v15.Parent = v14;
                        v15:Play();
                        v14.Parent = Visuals;
                        local Attachment = v14:FindFirstChild("Attachment");

                        if Attachment then
                            if Attachment:FindFirstChild("Pebbles") then
                                Attachment.Pebbles:Emit(16);
                            end;

                            if Attachment:FindFirstChild("Line") then
                                Attachment.Line:Emit(8);
                            end;

                            if Attachment:FindFirstChild("Pebbles2") then
                                Attachment.Pebbles2:Emit(16);
                            end;

                            if Attachment:FindFirstChild("Woosh") then
                                Attachment.Woosh:Emit(8);
                            end;
                        end;

                        Debris:AddItem(v14, 1);
                        u2:Destroy();
                    end;
                end);
            end);
        end;
    end
};