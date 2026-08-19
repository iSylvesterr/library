-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local u2 = { "CooldownEnd", "CooldownUntil" };

local function clearContainer(p3) -- Line: 22
    -- upvalues: u2 (copy)
    if not p3 then
        return;
    end;

    for _, child in p3:GetChildren() do
        if child:IsA("Tool") then
            for _, v in u2 do
                if child:GetAttribute(v) ~= nil then
                    child:SetAttribute(v, 0);
                end;
            end;
        end;
    end;
end;

function v1.Init(p4) -- Line: 34
end;

function v1.Start(p5) -- Line: 36
    -- upvalues: Networking (copy), clearContainer (copy), LocalPlayer (copy)
    Networking.Gear.CooldownsReset.OnClientEvent:Connect(function() -- Line: 37
        -- upvalues: clearContainer (ref), LocalPlayer (ref)
        clearContainer(LocalPlayer:FindFirstChild("Backpack"));
        clearContainer(LocalPlayer.Character);
    end);
end;

return v1;