-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage").Library;
require(Library.Modules.PipelineBuilder);
local t = require(Library.Modules.Packages.t);
local v1 = {};
local v2 = t.interface({
    anim = t.instanceIsA("Animation"),
    weight = t.number,
    looped = t.optional(t.boolean),
    protocol = t.optional(t.interface({
        Stop = t.optional(t.array(t.number)),
        Play = t.optional(t.array(t.number))
    }))
});
v1.SerializedAnimation = v2;
v1.SerializedAnimationArray = t.array(v2);

return v1;