-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local u1 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);

return function(u2) -- Line: 6
    -- upvalues: Networking (copy), TweenService (copy), u1 (copy), Players (copy)
    local u3 = u2:GetAttribute("PropId");
    local Launcher = u2.Build.Launcher;
    local Base = u2.Build.Base;
    local SpringConstraint = Base.SpringConstraint;
    local SFX = Launcher.SFX;
    u2:SetAttribute("Debounce", true);
    Networking.Spring.SpringFire.OnClientEvent:Connect(function(p4) -- Line: 13
        -- upvalues: u3 (copy), u2 (copy), Launcher (copy), SpringConstraint (copy), SFX (copy)
        if p4 ~= u3 then
            return;
        end;

        u2:SetAttribute("Debounce", false);
        Launcher.Anchored = false;
        SpringConstraint.MinLength = 1;
        SpringConstraint.MaxLength = 7;
        SFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        SFX.Playing = true;
    end);
    Networking.Spring.SpringReload.OnClientEvent:Connect(function(p5) -- Line: 22
        -- upvalues: u3 (copy), TweenService (ref), SpringConstraint (copy), u1 (ref), Launcher (copy), Base (copy), u2 (copy)
        if p5 ~= u3 then
            return;
        end;

        local v6 = TweenService:Create(SpringConstraint, u1, {
            MaxLength = 3
        });
        v6:Play();
        game.Debris:AddItem(v6, u1.Time);
        task.wait(u1.Time);
        SpringConstraint.MinLength = 1;
        Launcher.CFrame = Base.CFrame + Vector3.new(0, 2, 0);
        Launcher.Anchored = true;
        u2:SetAttribute("Debounce", true);
    end);
    Launcher.Touched:Connect(function(p7) -- Line: 33
        -- upvalues: u2 (copy), Players (ref), Networking (ref), u3 (copy)
        if not u2:GetAttribute("Debounce") then
            return;
        end;

        if p7 then
            p7 = p7.Parent;
        end;

        local u8;

        if p7 then
            u8 = p7:FindFirstChild("Humanoid");
        else
            u8 = p7;
        end;

        local v9;

        if p7 then
            v9 = p7.PrimaryPart;
        else
            v9 = p7;
        end;

        if not (u8 and v9) then
            return;
        end;

        if Players:GetPlayerFromCharacter(p7) ~= Players.LocalPlayer then
            return;
        end;

        u2:SetAttribute("Debounce", false);
        local BodyVelocity = Instance.new("BodyVelocity");
        BodyVelocity.MaxForce = Vector3.new(0, 12000, 0);
        BodyVelocity.Velocity = Vector3.new(0, 12000, 0);
        BodyVelocity.P = 10000;
        BodyVelocity.Parent = v9;
        game.Debris:AddItem(BodyVelocity, 0.25);
        u8.PlatformStand = true;
        Networking.Spring.SpringFire:Fire(u3);
        task.delay(math.random(2, 3), function() -- Line: 52
            -- upvalues: u8 (copy)
            u8.PlatformStand = false;
        end);
    end);
end;