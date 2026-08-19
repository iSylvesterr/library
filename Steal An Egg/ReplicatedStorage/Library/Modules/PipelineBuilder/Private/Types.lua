-- Decompiled with Potassium's decompiler.

local t = require(game:GetService("ReplicatedStorage").Library.Modules.Packages.t);
require(game:GetService("ReplicatedStorage").Library.Modules.Packages.Promise);
require(game:GetService("ReplicatedStorage").Library.Modules.Flags);
require(script.Parent.States);
require(script.Parent.Constants);

return {
    Create = t.interface({
        Constants = t.optional(t.map(t.string, t.any)),
        Resources = t.optional(t.table),
        Modifiers = t.optional(t.map(t.string, t.callback))
    })
};