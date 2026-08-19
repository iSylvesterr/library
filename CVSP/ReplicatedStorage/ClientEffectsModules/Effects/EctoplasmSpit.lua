-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
local Ectoplasm = EffectAssets:WaitForChild("Ectoplasm");
local EctoplasmHit = EffectAssets:WaitForChild("EctoplasmHit");
local Splat = script:WaitForChild("Splat");
local Impact = script:WaitForChild("Impact");
local Spit = script:WaitForChild("Spit");
local Ghost = script:WaitForChild("Ghost");
local Visuals = workspace:WaitForChild("World"):WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 21, Name: Play
        -- upvalues: Ectoplasm (copy), Visuals (copy), Spit (copy), Ghost (copy), RunService (copy), EctoplasmHit (copy), Splat (copy), Impact (copy), Debris (copy)
        local Target = p1.Target;
        local TowerPosition = p1.TowerPosition;
        local TargetPosition = p1.TargetPosition;
        local u2 = Ectoplasm:Clone();

        if u2 then
            u2.Parent = Visuals;
            u2:PivotTo(CFrame.new(TowerPosition));
            local v3 = Spit:Clone();
            v3.Parent = u2.PrimaryPart;
            v3:Play();
            local v4 = Ghost:Clone();
            v4.Parent = u2.PrimaryPart;
            v4:Play();
            local u5 = tick();
            local v6 = (TowerPosition + TargetPosition) / 2;
            local u7 = Vector3.new(v6.X, v6.Y + 6, v6.Z);
            local u8 = nil;
            u8 = RunService.Heartbeat:Connect(function() -- Line: 48
                -- upvalues: u5 (copy), TowerPosition (copy), u7 (ref), TargetPosition (copy), u2 (copy), u8 (ref), EctoplasmHit (ref), Target (copy), Splat (ref), Impact (ref), Visuals (ref), Debris (ref)
                local v9 = (tick() - u5) / 0.5;
                local v10 = math.clamp(v9, 0, 1);
                local v11 = TowerPosition:Lerp(u7, v10):Lerp(u7:Lerp(TargetPosition, v10), v10);
                local v12 = math.clamp(v10 + 0.02, 0, 1);
                local v13 = TowerPosition:Lerp(u7, v12):Lerp(u7:Lerp(TargetPosition, v12), v12);
                u2:PivotTo((CFrame.lookAt(v11, v13)));

                if v10 >= 1 then
                    u8:Disconnect();
                    local v14 = EctoplasmHit:Clone();

                    if Target and (Target.PrimaryPart and Target.PrimaryPart.Parent) then
                        v14.Position = Target.PrimaryPart.Position;
                    else
                        v14.Position = TargetPosition;
                    end;

                    local v15 = Splat:Clone();
                    v15.Parent = v14;
                    v15:Play();
                    local v16 = Impact:Clone();
                    v16.Parent = v14;
                    v16:Play();
                    v14.Parent = Visuals;
                    local Attachment = v14:FindFirstChild("Attachment");

                    if Attachment then
                        if Attachment:FindFirstChild("Bits") then
                            Attachment.Bits:Emit(12);
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
                            Attachment.Woosh:Emit(8);
                        end;
                    end;

                    Debris:AddItem(v14, 1);
                    u2:Destroy();
                end;
            end);
        end;
    end
};