-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 0
};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);

function v1.Init(p2) -- Line: 8
end;

function v1.Start(p3) -- Line: 11
    -- upvalues: PlayerStateClient (copy)
    PlayerStateClient:GetLocalReplica();
end;

return v1;