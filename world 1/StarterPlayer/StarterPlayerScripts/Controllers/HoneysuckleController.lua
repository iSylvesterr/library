-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local v1 = {
    Connections = {}
};
local u2 = 0;

local function GetOwnerUserId(p3) -- Line: 22
    local Parent = p3.Parent;

    for _ = 1, 4 do
        if not Parent then
            return nil;
        end;

        local v4 = Parent:GetAttribute("UserId");

        if typeof(v4) == "number" then
            return v4;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

function v1.RegisterPart(p5, u6) -- Line: 36
    -- upvalues: LocalPlayer (copy), GetOwnerUserId (copy), u2 (ref), Networking (copy)
    if p5.Connections[u6] then
        return;
    end;

    p5.Connections[u6] = u6.Touched:Connect(function(p7) -- Line: 39
        -- upvalues: LocalPlayer (ref), u6 (copy), GetOwnerUserId (ref), u2 (ref), Networking (ref)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        if not p7:IsDescendantOf(Character) then
            return;
        end;

        if u6.Transparency >= 1 then
            return;
        end;

        if GetOwnerUserId(u6) ~= LocalPlayer.UserId then
            return;
        end;

        if LocalPlayer:GetAttribute("IsInOwnGarden") ~= true then
            return;
        end;

        if workspace:GetServerTimeNow() - u2 < 1 then
            return;
        end;

        u2 = workspace:GetServerTimeNow();
        Networking.Honeysuckle.Touched:Fire();
    end);
end;

function v1.UnregisterPart(p8, p9) -- Line: 59
    if p8.Connections[p9] then
        p8.Connections[p9]:Disconnect();
        p8.Connections[p9] = nil;
    end;
end;

function v1.Start(u10) -- Line: 66
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTagged("Honeysuckle") do
        u10:RegisterPart(v);
    end;

    CollectionService:GetInstanceAddedSignal("Honeysuckle"):Connect(function(p11) -- Line: 71
        -- upvalues: u10 (copy)
        u10:RegisterPart(p11);
    end);
    CollectionService:GetInstanceRemovedSignal("Honeysuckle"):Connect(function(p12) -- Line: 75
        -- upvalues: u10 (copy)
        u10:UnregisterPart(p12);
    end);
end;

return v1;