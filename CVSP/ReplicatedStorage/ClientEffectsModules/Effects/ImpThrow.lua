-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
local ImpEmoji = EffectAssets:WaitForChild("ImpEmoji");
local ImpHit = EffectAssets:WaitForChild("ImpHit");
local EvilLaugh1 = script:WaitForChild("EvilLaugh1");
local EvilLaugh2 = script:WaitForChild("EvilLaugh2");
local EvilLaugh3 = script:WaitForChild("EvilLaugh3");
local Hit = script:WaitForChild("Hit");
local Throw = script:WaitForChild("Throw");
local Visuals = workspace:WaitForChild("World"):WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 24, Name: Play
        -- upvalues: ImpEmoji (copy), Visuals (copy), Throw (copy), EvilLaugh1 (copy), EvilLaugh2 (copy), EvilLaugh3 (copy), RunService (copy), ImpHit (copy), Hit (copy), Debris (copy)
        local Target = p1.Target;
        local TowerPosition = p1.TowerPosition;
        local TargetPosition = p1.TargetPosition;
        local u2 = ImpEmoji:Clone();

        if u2 then
            u2.Parent = Visuals;
            u2:PivotTo(CFrame.new(TowerPosition));
            local v3 = Throw:Clone();
            v3.Parent = u2.PrimaryPart;
            v3:Play();
            local v4 = math.random(1, 3);
            local v5;

            if v4 == 1 then
                v5 = EvilLaugh1:Clone();
            elseif v4 == 2 then
                v5 = EvilLaugh2:Clone();
            else
                v5 = EvilLaugh3:Clone();
            end;

            v5.Parent = u2.PrimaryPart;
            v5:Play();
            local u6 = tick();
            local v7 = (TowerPosition + TargetPosition) / 2;
            local u8 = Vector3.new(v7.X, v7.Y + 6, v7.Z);
            local u9 = nil;
            u9 = RunService.Heartbeat:Connect(function() -- Line: 59
                -- upvalues: u6 (copy), TowerPosition (copy), u8 (ref), TargetPosition (copy), u2 (copy), u9 (ref), ImpHit (ref), Target (copy), Hit (ref), Visuals (ref), Debris (ref)
                local v10 = (tick() - u6) / 0.5;
                local v11 = math.clamp(v10, 0, 1);
                local v12 = TowerPosition:Lerp(u8, v11):Lerp(u8:Lerp(TargetPosition, v11), v11);
                local v13 = math.clamp(v11 + 0.02, 0, 1);
                local v14 = TowerPosition:Lerp(u8, v13):Lerp(u8:Lerp(TargetPosition, v13), v13);
                u2:PivotTo((CFrame.lookAt(v12, v14)));

                if v11 >= 1 then
                    u9:Disconnect();
                    local v15 = ImpHit:Clone();

                    if Target and (Target.PrimaryPart and Target.PrimaryPart.Parent) then
                        v15.Position = Target.PrimaryPart.Position;
                    else
                        v15.Position = TargetPosition;
                    end;

                    local v16 = Hit:Clone();
                    v16.Parent = v15;
                    v16:Play();
                    v15.Parent = Visuals;
                    local Attachment = v15:FindFirstChild("Attachment");

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

                    Debris:AddItem(v15, 1);
                    u2:Destroy();
                end;
            end);
        end;
    end
};