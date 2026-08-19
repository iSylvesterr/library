-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Parent = require(script.Parent);

return function(p1, p2, p3) -- Line: 14, Name: CreateConfiguredSound
    -- upvalues: Asserts (copy), Parent (copy)
    Asserts.Instance(p1);
    local Sound = Instance.new("Sound");
    Sound.Name = p3 or "ConfiguredSound";
    Parent.PrepareSoundFromSoundFile(Sound, p2);
    Sound.Parent = p1;

    return Sound;
end;