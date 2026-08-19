-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Functions = require(Library.Functions);

return function(p1) -- Line: 5, Name: EmitSparkles
    -- upvalues: ReplicatedStorage (copy), Functions (copy)
    local v2 = ReplicatedStorage.Assets.Particles:FindFirstChild("Sparkles"):Clone();
    Functions.Emit(p1, nil, v2);
end;