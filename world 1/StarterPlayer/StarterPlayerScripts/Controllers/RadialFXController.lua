-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local u2 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local u3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0);
local RadialScreenFlash = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RadialScreenFlash");
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);

function u1.Start(p4) -- Line: 13
end;

function u1.Init(p5) -- Line: 17
    -- upvalues: Networking (copy), u1 (copy)
    Networking.Flash.Flash.OnClientEvent:Connect(function(p6) -- Line: 18
        -- upvalues: u1 (ref)
        u1:PlayFX(p6);
    end);
end;

function u1.PlayFX(p7, p8) -- Line: 23
    -- upvalues: RadialScreenFlash (copy), TweenService (copy), u2 (copy), u3 (copy)
    local u9 = RadialScreenFlash:FindFirstChild(p8);

    if u9 then
        local v10 = TweenService:Create(u9, u2, {
            ImageTransparency = 0
        });
        v10:Play();
        game.Debris:AddItem(v10, u2.Time);
        task.spawn(function() -- Line: 29
            -- upvalues: u2 (ref), TweenService (ref), u9 (copy), u3 (ref)
            task.wait(u2.Time + 0.7);
            local v11 = TweenService:Create(u9, u3, {
                ImageTransparency = 1
            });
            v11:Play();
            game.Debris:AddItem(v11, u3.Time);
        end);
    end;
end;

return u1;