-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local RagdollModule = require(game.ReplicatedStorage.ClientModules.RagdollModule);

return function(u1) -- Line: 5
    -- upvalues: Players (copy), Networking (copy), RagdollModule (copy)
    local u2 = u1:GetAttribute("PropId");
    local u3 = u1:GetAttribute("UserId") == Players.LocalPlayer.UserId;
    local Primary = u1.Primary;
    local Open = u1.Build.Open;
    local Close = u1.Build.Close;
    local Slam = Primary.Slam;
    local Open2 = Primary.Open;
    u1:SetAttribute("Debounce", true);
    Networking.BearTrap.Closed.OnClientEvent:Connect(function(p4) -- Line: 14
        -- upvalues: u2 (copy), u1 (copy), Close (copy), Open (copy), Slam (copy)
        if p4 ~= u2 then
            return;
        end;

        u1:SetAttribute("Debounce", false);
        Close.Transparency = 0;
        Open.Transparency = 1;
        Slam.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Slam.TimePosition = 0;
        Slam.Playing = true;
    end);
    Networking.BearTrap.Reset.OnClientEvent:Connect(function(p5) -- Line: 23
        -- upvalues: u2 (copy), u1 (copy), Close (copy), Open (copy), Open2 (copy)
        if p5 ~= u2 then
            return;
        end;

        u1:SetAttribute("Debounce", true);
        Close.Transparency = 1;
        Open.Transparency = 0;
        Open2.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Open2.TimePosition = 0;
        Open2.Playing = true;
    end);
    Primary.Touched:Connect(function(p6) -- Line: 32
        -- upvalues: u1 (copy), u3 (copy), Players (ref), RagdollModule (ref), Networking (ref), u2 (copy), Primary (copy)
        if not u1:GetAttribute("Debounce") then
            return;
        end;

        if u3 then
            return;
        end;

        if p6 then
            p6 = p6.Parent;
        end;

        local v7;

        if p6 then
            v7 = Players:GetPlayerFromCharacter(p6);
        else
            v7 = p6;
        end;

        if v7 ~= Players.LocalPlayer then
            return;
        end;

        RagdollModule:Ragdoll(p6, 3);
        Networking.BearTrap.BearTrap:Fire(u2, Primary.Position, "Rainbow Bear Trap");
    end);
end;