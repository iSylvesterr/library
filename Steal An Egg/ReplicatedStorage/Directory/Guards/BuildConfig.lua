-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Directory.Rarity);
local Default = require(script.Parent.BaseConfigs.Default);
require(script.Parent.Types.Interface);

return function(p1) -- Line: 22
    -- upvalues: Default (copy)
    return setmetatable(p1, {
        __index = Default
    });
end;