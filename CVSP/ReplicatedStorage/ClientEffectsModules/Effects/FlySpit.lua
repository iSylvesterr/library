-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
local Fly = EffectAssets:WaitForChild("Fly");
local FlyHit = EffectAssets:WaitForChild("FlyHit");
local Splat = script:WaitForChild("Splat");
local Impact = script:WaitForChild("Impact");
local Croak = script:WaitForChild("Croak");
local Visuals = workspace:WaitForChild("World"):WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 21, Name: Play
        -- upvalues: Fly (copy), Visuals (copy), Croak (copy), RunService (copy), FlyHit (copy), Splat (copy), Impact (copy), Debris (copy)
        local Target = p1.Target;
        local TowerPosition = p1.TowerPosition;
        local TargetPosition = p1.TargetPosition;
        local u2 = Fly:Clone();

        if u2 then
            u2.Parent = Visuals;
            u2:PivotTo(CFrame.new(TowerPosition));
            local v3 = Croak:Clone();
            v3.Parent = u2.PrimaryPart;
            v3:Play();
            local u4 = tick();
            local v5 = (TowerPosition + TargetPosition) / 2;
            local u6 = Vector3.new(v5.X, v5.Y + 4, v5.Z);
            local u7 = nil;
            u7 = RunService.Heartbeat:Connect(function() -- Line: 44
                -- upvalues: u4 (copy), TowerPosition (copy), u6 (ref), TargetPosition (copy), u2 (copy), u7 (ref), FlyHit (ref), Target (copy), Splat (ref), Impact (ref), Visuals (ref), Debris (ref)
                local v8 = (tick() - u4) / 0.5;
                local v9 = math.clamp(v8, 0, 1);
                local v10 = TowerPosition:Lerp(u6, v9):Lerp(u6:Lerp(TargetPosition, v9), v9);
                local v11 = math.clamp(v9 + 0.02, 0, 1);
                local v12 = TowerPosition:Lerp(u6, v11):Lerp(u6:Lerp(TargetPosition, v11), v11);
                u2:PivotTo((CFrame.lookAt(v10, v12)));

                if v9 >= 1 then
                    u7:Disconnect();
                    local v13 = FlyHit:Clone();

                    if Target and (Target.PrimaryPart and Target.PrimaryPart.Parent) then
                        v13.Position = Target.PrimaryPart.Position;
                    else
                        v13.Position = TargetPosition;
                    end;

                    local v14 = Splat:Clone();
                    v14.Parent = v13;
                    v14:Play();
                    local v15 = Impact:Clone();
                    v15.Parent = v13;
                    v15:Play();
                    v13.Parent = Visuals;
                    local Attachment = v13:FindFirstChild("Attachment");

                    if Attachment then
                        if Attachment:FindFirstChild("Bits") then
                            Attachment.Bits:Emit(8);
                        end;

                        if Attachment:FindFirstChild("Line") then
                            Attachment.Line:Emit(8);
                        end;

                        if Attachment:FindFirstChild("WhiteSplat") then
                            Attachment.WhiteSplat:Emit(1);
                        end;

                        if Attachment:FindFirstChild("Splat") then
                            Attachment.Splat:Emit(1);
                        end;

                        if Attachment:FindFirstChild("Woosh") then
                            Attachment.Woosh:Emit(6);
                        end;
                    end;

                    Debris:AddItem(v13, 1);
                    u2:Destroy();
                end;
            end);
        end;
    end
};