-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local v1 = {};

local function bindPortal(p2) -- Line: 18
    -- upvalues: Worlds (copy), Networking (copy)
    if not p2:IsA("BasePart") then
        return;
    end;

    local u3 = p2:GetAttribute("WorldId");

    if type(u3) ~= "string" or u3 == "" then
        return;
    end;

    local v4 = Worlds.Worlds[u3];

    if v4 == nil then
        return;
    end;

    local v5 = p2:FindFirstChildOfClass("ProximityPrompt");

    if not v5 then
        v5 = Instance.new("ProximityPrompt");
        v5.ActionText = `Travel to {v4.DisplayName}`;
        v5.ObjectText = v4.DisplayName;
        v5.HoldDuration = 0.5;
        v5.RequiresLineOfSight = false;
        v5.MaxActivationDistance = 8;
        v5.Parent = p2;
    end;

    v5.Triggered:Connect(function() -- Line: 43
        -- upvalues: Networking (ref), u3 (copy)
        Networking.Worlds.RequestTravel:Fire(u3);
    end);
end;

function v1.Init(p6) -- Line: 48
end;

function v1.Start(p7) -- Line: 51
    -- upvalues: CollectionService (copy), bindPortal (copy)
    for _, v in CollectionService:GetTagged("WorldTravelPortal") do
        bindPortal(v);
    end;

    CollectionService:GetInstanceAddedSignal("WorldTravelPortal"):Connect(bindPortal);
end;

return v1;