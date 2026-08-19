-- Decompiled with Potassium's decompiler.

local v1 = {};
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local Poof = game.ReplicatedStorage.Assets.Poof;
local PopVFX = game.ReplicatedStorage.Assets.PopVFX;
local Temporary = game.Workspace.Temporary;

function v1.Init(p2) -- Line: 9
    -- upvalues: Networking (copy), PopVFX (copy), Poof (copy), Temporary (copy)
    Networking.ShecklePop.SheckleCollect.OnClientEvent:Connect(function(u3) -- Line: 10
        -- upvalues: PopVFX (ref)
        task.spawn(function() -- Line: 13
            -- upvalues: PopVFX (ref), u3 (copy)
            local Model = Instance.new("Model");
            Model.Parent = game.Workspace.Temporary;
            local v4 = PopVFX:Clone();
            v4.Parent = Model;
            Model:ScaleTo(0.5);
            v4.Position = u3;
            task.wait();

            for _, descendant in pairs(v4:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant:Emit(descendant:GetAttribute("EmitCount"));
                end;
            end;

            game.Debris:AddItem(Model, 3);
        end);
    end);
    Networking.ShecklePop.PlayerDeath.OnClientEvent:Connect(function(u5) -- Line: 29
        -- upvalues: Poof (ref), Temporary (ref)
        task.spawn(function() -- Line: 30
            -- upvalues: Poof (ref), Temporary (ref), u5 (copy)
            local v6 = Poof:Clone();
            v6.Parent = Temporary;
            v6.Position = u5;
            task.wait();

            for _, descendant in pairs(v6:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant:Emit(math.random(7, 11));
                end;
            end;

            game.Debris:AddItem(v6, 3);
        end);
    end);
end;

return v1;