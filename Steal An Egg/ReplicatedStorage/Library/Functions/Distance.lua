-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Library = ReplicatedStorage:WaitForChild("Library");
local Player = require(Library.Player);

return function(p1, p2) -- Line: 6
    -- upvalues: Player (copy), Players (copy)
    if p1 and (typeof(p1) ~= "Instance" or not p1:IsA("Player")) then
        if typeof(p1) == "CFrame" then
            p1 = p1.Position;
        elseif typeof(p1) == "BasePart" or (typeof(p1) == "MeshPart" or typeof(p1) == "Part") then
            p1 = p1.Position;
        elseif typeof(p1) == "Instance" and p1.ClassName == "Model" then
            p1 = p1:GetPivot().Position;
        end;
    else
        local v3;

        if p1 then
            v3 = Player.Optional.Humanoid(p1);
        else
            v3 = Player.Optional.Humanoid(Players.LocalPlayer);
        end;

        if not v3 then
            return nil;
        end;

        local RootPart = v3.RootPart;

        if not RootPart then
            return nil;
        end;

        p1 = RootPart.Position;
    end;

    if not p1 then
        return nil;
    end;

    if typeof(p2) == "Instance" and p2:IsA("Player") then
        local v4 = Player.Optional.Humanoid(p2);

        if not v4 then
            return nil;
        end;

        local RootPart = v4.RootPart;

        if not RootPart then
            return nil;
        end;

        p2 = RootPart.Position;
    elseif typeof(p2) == "CFrame" then
        p2 = p2.Position;
    elseif typeof(p2) == "BasePart" or (typeof(p2) == "MeshPart" or typeof(p2) == "Part") then
        p2 = p2.Position;
    elseif typeof(p2) == "Instance" and p2.ClassName == "Model" then
        p2 = p2:GetPivot().Position;
    end;

    if p2 and (typeof(p1) == "Vector3" and typeof(p2) == "Vector3") then
        return (p1 - p2).Magnitude;
    end;

    return nil;
end;