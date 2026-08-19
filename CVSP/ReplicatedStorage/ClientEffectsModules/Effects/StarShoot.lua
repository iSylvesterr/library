-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
local Star = EffectAssets:WaitForChild("Star");
local StarHit = EffectAssets:WaitForChild("StarHit");
local StarCast = script:WaitForChild("StarCast");
local StarImpact = script:WaitForChild("StarImpact");
local World = workspace:WaitForChild("World");
local Client = World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 23, Name: Play
        -- upvalues: Client (copy), Star (copy), StarCast (copy), Visuals (copy), TweenService (copy), StarHit (copy), Debris (copy), StarImpact (copy)
        local Target = p1.Target;
        local TowerPosition = p1.TowerPosition;
        local TargetPosition = p1.TargetPosition;
        local v2 = Client:FindFirstChild(p1.TowerID);

        if v2 then
            TowerPosition = v2:WaitForChild("Wand"):WaitForChild("EffectPart").Position;
        end;

        local u3 = Star:Clone();

        if not (u3 and u3.PrimaryPart) then
            return;
        end;

        local v4 = StarCast:Clone();
        v4.Parent = u3.PrimaryPart;
        v4:Play();
        u3.Parent = Visuals;
        u3:PivotTo(CFrame.new(TowerPosition));
        local v5 = TweenInfo.new(0.5, Enum.EasingStyle.Linear);
        local v6 = TweenService:Create(u3.PrimaryPart, v5, {
            CFrame = CFrame.lookAt(TargetPosition, TargetPosition + (TargetPosition - TowerPosition).Unit)
        });
        local v7 = StarHit:Clone();
        v7.Position = TowerPosition;
        v7.Parent = Visuals;
        local Attachment = v7:FindFirstChild("Attachment");

        if Attachment then
            if Attachment:FindFirstChild("Sparkle") then
                Attachment.Sparkle:Emit(4);
            end;

            if Attachment:FindFirstChild("WhiteSparkle") then
                Attachment.WhiteSparkle:Emit(4);
            end;

            if Attachment:FindFirstChild("YellowStar") then
                Attachment.YellowStar:Emit(2);
            end;
        end;

        Debris:AddItem(v7, 1.5);
        v6:Play();
        v6.Completed:Connect(function() -- Line: 68
            -- upvalues: StarHit (ref), Target (copy), TargetPosition (copy), Visuals (ref), StarImpact (ref), Debris (ref), u3 (copy)
            local v8 = StarHit:Clone();

            if Target and (Target.PrimaryPart and Target.PrimaryPart.Parent) then
                v8.Position = Target.PrimaryPart.Position;
            else
                v8.Position = TargetPosition;
            end;

            v8.Parent = Visuals;
            local v9 = StarImpact:Clone();
            v9.Parent = v8;
            v9:Play();
            local Attachment2 = v8:FindFirstChild("Attachment");

            if Attachment2 then
                if Attachment2:FindFirstChild("Sparkle") then
                    Attachment2.Sparkle:Emit(8);
                end;

                if Attachment2:FindFirstChild("WhiteSparkle") then
                    Attachment2.WhiteSparkle:Emit(8);
                end;

                if Attachment2:FindFirstChild("Line") then
                    Attachment2.Line:Emit(16);
                end;

                if Attachment2:FindFirstChild("YellowStar") then
                    Attachment2.YellowStar:Emit(3);
                end;

                if Attachment2:FindFirstChild("WhiteStar") then
                    Attachment2.WhiteStar:Emit(2);
                end;

                if Attachment2:FindFirstChild("Woosh") then
                    Attachment2.Woosh:Emit(8);
                end;
            end;

            Debris:AddItem(v8, 1.5);
            u3:Destroy();
        end);
    end
};