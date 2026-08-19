-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
local Radiant = EffectAssets:WaitForChild("MutationEffects"):WaitForChild("Radiant"):WaitForChild("Radiant");
local HolyBeam = EffectAssets:WaitForChild("HolyBeam");
local StarHit = EffectAssets:WaitForChild("StarHit");
local Choir = script:WaitForChild("Choir");
local HolyRay = script:WaitForChild("HolyRay");
local MantleBreak = script:WaitForChild("MantleBreak");
local Visuals = workspace:WaitForChild("World"):WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 22, Name: Play
        -- upvalues: HolyBeam (copy), Visuals (copy), HolyRay (copy), Radiant (copy), Debris (copy), Choir (copy), RunService (copy), StarHit (copy), MantleBreak (copy)
        local Target = p1.Target;
        local TowerPosition = p1.TowerPosition;
        local TargetPosition = p1.TargetPosition;
        local u2 = HolyBeam:Clone();

        if not u2 then
            return;
        end;

        u2.Parent = Visuals;
        u2.Attachment0.Position = TowerPosition + Vector3.new(0, 1, 0);
        u2.Attachment1.Position = TowerPosition + Vector3.new(0, 1, 0);
        local v3 = HolyRay:Clone();
        v3.Parent = u2.Attachment0;
        v3:Play();
        local v4 = Radiant:Clone();
        v4.Parent = Visuals;
        v4.Position = TowerPosition;
        v4.Anchored = true;
        Debris:AddItem(v4, 2);
        task.delay(0.8, function() -- Line: 45
            -- upvalues: u2 (copy), Choir (ref), TowerPosition (copy), TargetPosition (copy), RunService (ref), StarHit (ref), Target (copy), MantleBreak (ref), Visuals (ref), Debris (ref)
            if u2 then
                local v5 = Choir:Clone();
                v5.Parent = u2.Attachment0;
                v5:Play();
                local u6 = tick();
                local v7 = (TowerPosition + TargetPosition) / 2;
                local u8 = Vector3.new(v7.X, v7.Y + 0, v7.Z);
                local u9 = nil;
                u9 = RunService.Heartbeat:Connect(function() -- Line: 61
                    -- upvalues: u6 (copy), TowerPosition (ref), u8 (ref), TargetPosition (ref), u2 (ref), u9 (ref), StarHit (ref), Target (ref), MantleBreak (ref), Visuals (ref), Debris (ref)
                    local v10 = (tick() - u6) / 0.1;
                    local v11 = math.clamp(v10, 0, 1);
                    TowerPosition:Lerp(u8, v11):Lerp(u8:Lerp(TargetPosition, v11), v11);
                    local v12 = math.clamp(v11 + 0.02, 0, 1);
                    local v13 = TowerPosition:Lerp(u8, v12):Lerp(u8:Lerp(TargetPosition, v12), v12);
                    u2.Attachment1.Position = v13;

                    if v11 >= 1 then
                        u9:Disconnect();
                        local v14 = StarHit:Clone();

                        if Target and (Target.PrimaryPart and Target.PrimaryPart.Parent) then
                            v14.Position = Target.PrimaryPart.Position;
                        else
                            v14.Position = TargetPosition;
                        end;

                        local v15 = MantleBreak:Clone();
                        v15.Parent = v14;
                        v15:Play();
                        v14.Parent = Visuals;
                        local Attachment = v14:FindFirstChild("Attachment");

                        if Attachment then
                            if Attachment:FindFirstChild("Sparkle") then
                                Attachment.Sparkle:Emit(8);
                            end;

                            if Attachment:FindFirstChild("WhiteSparkle") then
                                Attachment.WhiteSparkle:Emit(8);
                            end;

                            if Attachment:FindFirstChild("Line") then
                                Attachment.Line:Emit(16);
                            end;

                            if Attachment:FindFirstChild("YellowStar") then
                                Attachment.YellowStar:Emit(3);
                            end;

                            if Attachment:FindFirstChild("WhiteStar") then
                                Attachment.WhiteStar:Emit(2);
                            end;

                            if Attachment:FindFirstChild("Woosh") then
                                Attachment.Woosh:Emit(8);
                            end;
                        end;

                        Debris:AddItem(v14, 1);
                        Debris:AddItem(u2, 0.5);
                    end;
                end);
            end;
        end);
    end
};