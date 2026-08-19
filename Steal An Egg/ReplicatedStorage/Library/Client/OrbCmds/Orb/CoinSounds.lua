-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Audio = require(Library.Audio);
local Directory = require(ReplicatedStorage.Directory.Currency).Directory;
local v1 = {};
local u2 = { 0.95, 1.05 };
local u3 = {};

function v1.Queue(p4, p5) -- Line: 22
    -- upvalues: u3 (ref)
    local v6 = u3[p4] or {
        Count = 0,
        LootTierIndex = p5
    };
    v6.Count = v6.Count + 1;
    u3[p4] = v6;
end;

RunService.Heartbeat:Connect(function() -- Line: 32
    -- upvalues: u3 (ref), Directory (copy), Audio (copy), u2 (copy)
    local v7 = u3;

    if next(v7) then
        u3 = {};

        for i, v in pairs(v7) do
            local Sounds = Directory[i].Sounds;
            local v8 = v.Count >= 2 and Sounds.Multi or Sounds.Single;
            local v9 = v8.Data or {};
            Audio.Play(v8.Ids, script, v9.Speed or u2, v9.Volume or 0.5);
        end;
    end;
end);

return v1;