-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Network = require(ReplicatedStorage.Library.Client.Network);
local CameraShaker = require(ReplicatedStorage.Library.Modules.Packages.CameraShaker);
local ShakeRequestData = require(ReplicatedStorage.Library.Types.ShakeRequestData);
local u1 = CameraShaker.new();
u1:Start();
Network.Fired(Network.NET_MAP.ReplicatedEffects.SHAKE_ONCE):Connect(function(p2) -- Line: 12
    -- upvalues: ShakeRequestData (copy), u1 (copy)
    assert(ShakeRequestData.SchemaValidation(p2));
    u1:ShakeOnce(p2.Magnitude or 1, p2.Roughness or 1, p2.FadeInTime or 0, p2.FadeOutTime or 0, p2.PosInfluence, p2.RotInfluence);
end);