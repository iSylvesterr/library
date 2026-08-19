-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = t.interface({
    EggUid = t.string,
    Message = t.string,
    RarityId = t.string,
    SoundId = t.optional(t.number)
});
local v2 = t.array(v1);

return {
    SchemaValidation = {
        RareSpawnPresentation = v1,
        RareSpawnPresentations = v2,
        SequencePayload = t.interface({
            DayStartsAt = t.number,
            RareSpawns = v2
        })
    }
};