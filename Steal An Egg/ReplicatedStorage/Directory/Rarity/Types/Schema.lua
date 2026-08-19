-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    RarityNameExists = function(p1) -- Line: 12
        error("unimplemented");
    end,

    DefaultConfig = t.interface({
        DisplayName = t.string,
        RarityNumber = t.number,
        DefaultRarityValue = t.string,
        ItemSlot = t.instanceIsA("TextButton"),
        Gradient = t.instanceIsA("UIGradient"),
        Color = t.Color3,
        Message = t.callback,
        Announce = t.boolean
    })
};