-- Decompiled with Potassium's decompiler.

local Assets = game:GetService("ReplicatedStorage").Assets;
local SpiralTrail = require(game.ReplicatedStorage.ClientModules.SpiralTrail);

return {
    Play = function(p1, p2) -- Line: 9, Name: Play
        -- upvalues: Assets (copy), SpiralTrail (copy)
        local u3 = Assets.LevelUp.LevelUpEffect:Clone();
        local u4 = Assets.LevelUp.Highlight:Clone();
        local v5 = Assets.LevelUp.PoofEffect:Clone();
        u3:PivotTo(p2.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0));
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = u3;
        WeldConstraint.Part1 = p2.HumanoidRootPart;
        WeldConstraint.Parent = u3;
        u3.Parent = p2;
        v5.Parent = p2.HumanoidRootPart;
        u4.Parent = p2;
        local u6 = { 510, 470, 268 };

        local function lerp(p7, p8, p9) -- Line: 31
            return p7 + (p8 - p7) * p9;
        end;

        task.spawn(function() -- Line: 35
            -- upvalues: SpiralTrail (ref), u3 (copy)
            SpiralTrail.Init(u3, {
                Size = 0.2,
                Offset = 4,
                Time = 0.4,
                Frequency = 1,
                Radius = 2,
                Color = Color3.fromRGB(255, 243, 115)
            });
        end);
        local u10 = 0;
        task.spawn(function() -- Line: 48
            -- upvalues: u10 (ref), u6 (copy), u4 (copy)
            while u10 < 1.6 do
                u10 = u10 + game:GetService("RunService").Heartbeat:Wait();
                local v11 = tick() * 720;
                local v12 = math.rad(v11);
                local v13 = (math.sin(v12) + 1) / 2;
                u4.FillColor = Color3.fromRGB(u6[1], u6[2], u6[3]):Lerp(Color3.fromRGB(255, 235, 134), v13);
                local v14 = tick() * 360;
                local v15 = math.rad(v14);
                u4.FillTransparency = (math.sin(v15) + 1) / 2 * 0.3 * (u10 / 1.6 * 0.1) + 0.7;
                u4.OutlineTransparency = v13;
            end;

            game.TweenService:Create(u4, TweenInfo.new(1), {
                FillTransparency = 1,
                OutlineTransparency = 1
            }):Play();
        end);

        for _, child in v5:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount") or 1);

                if child.Name ~= "Glow2" then
                    child.Enabled = true;
                    task.delay(0.9, function() -- Line: 75
                        -- upvalues: child (copy)
                        child.Enabled = false;
                    end);
                end;
            end;
        end;

        for _, descendant in u3:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
                descendant:Emit(descendant:GetAttribute("EmitCount") or 1);
                task.delay(0.9, function() -- Line: 86
                    -- upvalues: descendant (copy)
                    descendant.Enabled = false;
                end);
            end;
        end;

        game.Debris:AddItem(u3, 2);
        game.Debris:AddItem(v5, 2);
        game.Debris:AddItem(u4, 2);
    end
};