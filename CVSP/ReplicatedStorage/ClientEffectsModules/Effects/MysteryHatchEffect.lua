-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
local Debris = game:GetService("Debris");
game:GetService("RunService");
require(ReplicatedStorage.Sounds.UISoundController);
local EffectAssets = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets");
local LegendaryHatchEffect = EffectAssets:WaitForChild("LegendaryHatchEffect");
local MythicHatchEffect = EffectAssets:WaitForChild("MythicHatchEffect");
local DivineHatchEffect = EffectAssets:WaitForChild("DivineHatchEffect");
local GodlyHatchEffect = EffectAssets:WaitForChild("GodlyHatchEffect");
local SecretHatchEffect = EffectAssets:WaitForChild("SecretHatchEffect");
local Shine = script:WaitForChild("Shine");
local UncommonSound = script:WaitForChild("UncommonSound");
local RareSound = script:WaitForChild("RareSound");
local Legendary1 = script:WaitForChild("Legendary1");
local Legendary2 = script:WaitForChild("Legendary2");
script:WaitForChild("Secret");
script:WaitForChild("SecretSound");
local World = workspace:WaitForChild("World");
World:WaitForChild("Map"):WaitForChild("PlacedItems"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");

return {
    Play = function(p1) -- Line: 34, Name: Play
        -- upvalues: LegendaryHatchEffect (copy), MythicHatchEffect (copy), DivineHatchEffect (copy), GodlyHatchEffect (copy), SecretHatchEffect (copy), Visuals (copy), Shine (copy), UncommonSound (copy), RareSound (copy), Legendary1 (copy), Legendary2 (copy), Debris (copy)
        if not p1.Rarity then
            return;
        end;

        local v2;

        if p1.Rarity == "Legendary" then
            v2 = LegendaryHatchEffect:Clone();
        elseif p1.Rarity == "Mythic" then
            v2 = MythicHatchEffect:Clone();
        elseif p1.Rarity == "Divine" then
            v2 = DivineHatchEffect:Clone();
        elseif p1.Rarity == "Godly" then
            v2 = GodlyHatchEffect:Clone();
        else
            v2 = SecretHatchEffect:Clone();
        end;

        v2.Position = p1.Position + Vector3.new(0, 1, 0);
        v2.Parent = Visuals;

        if p1.Rarity == "Legendary" then
            local v3 = Shine:Clone();
            v3.Parent = v2;
            v3:Play();
        elseif p1.Rarity == "Mythic" then
            local v4 = UncommonSound:Clone();
            v4.Parent = v2;
            v4:Play();
        elseif p1.Rarity == "Divine" then
            local v5 = Shine:Clone();
            v5.Parent = v2;
            v5:Play();
            local v6 = RareSound:Clone();
            v6.Parent = v2;
            v6:Play();
        elseif p1.Rarity == "Godly" or p1.Rarity == "Secret" then
            local v7 = Legendary1:Clone();
            v7.Parent = v2;
            v7.TimePosition = 0.1;
            v7:Play();
            local v8 = Legendary2:Clone();
            v8.Parent = v2;
            v8:Play();
        end;

        if p1.Rarity == "Legendary" or p1.Rarity == "Mythic" then
            local Attachment = v2:FindFirstChild("Attachment");

            if Attachment then
                if Attachment:FindFirstChild("Shine") then
                    Attachment.Shine:Emit(1);
                end;

                if Attachment:FindFirstChild("Sparkle") then
                    Attachment.Sparkle:Emit(8);
                end;
            end;
        elseif p1.Rarity == "Divine" then
            local Attachment = v2:FindFirstChild("Attachment");

            if Attachment then
                if Attachment:FindFirstChild("Shine") then
                    Attachment.Shine:Emit(1);
                end;

                if Attachment:FindFirstChild("Sparkle") then
                    Attachment.Sparkle:Emit(10);
                end;

                if Attachment:FindFirstChild("Line") then
                    Attachment.Line:Emit(10);
                end;
            end;
        elseif p1.Rarity == "Godly" then
            local Attachment = v2:FindFirstChild("Attachment");

            if Attachment then
                if Attachment:FindFirstChild("Shine") then
                    Attachment.Shine:Emit(1);
                end;

                if Attachment:FindFirstChild("Sparkle") then
                    Attachment.Sparkle:Emit(15);
                end;

                if Attachment:FindFirstChild("Line") then
                    Attachment.Line:Emit(15);
                end;
            end;
        else
            local v9 = p1.Rarity == "Secret" and v2:FindFirstChild("Attachment");

            if v9 then
                if v9:FindFirstChild("Shine") then
                    v9.Shine:Emit(2);
                end;

                if v9:FindFirstChild("Sparkle") then
                    v9.Sparkle:Emit(15);
                end;

                if v9:FindFirstChild("Line") then
                    v9.Line:Emit(15);
                end;
            end;
        end;

        Debris:AddItem(v2, 8);
    end
};