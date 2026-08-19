-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    PlayFormattedParamsInterface = t.interface({
        Speed = t.optional(t.union(t.number, t.array(t.number))),
        Volume = t.optional(t.union(t.number, t.array(t.number))),
        MaxDistance = t.optional(t.number),
        SoundGroup = t.optional(t.union(t.Instance, t.string)),
        Looped = t.optional(t.boolean),
        TimePos = t.optional(t.number),
        Player = t.optional(t.instanceIsA("Player")),
        SkipPlay = t.optional(t.boolean)
    }),
    SoundFile = t.interface({
        SoundId = t.union(t.instanceIsA("Sound"), t.number, t.string, t.array(t.union(t.number, t.string))),
        Data = t.table
    }),
    FadeParams = t.tuple(t.instanceIsA("Sound"), t.number, t.number, t.optional(t.enum(Enum.EasingStyle)), t.optional(t.enum(Enum.EasingDirection)))
};