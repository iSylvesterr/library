-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = {
    States = {
        Slot = "Slot",
        Carried = "Carried",
        Dropped = "Dropped",
        GuardCarried = "GuardCarried",
        Claimed = "Claimed"
    },
    DropReasons = {
        PlayerRequest = "PlayerRequest",
        GuardHit = "GuardHit",
        PlayerSlap = "PlayerSlap",
        Rewind = "Rewind",
        CharacterRemoving = "CharacterRemoving",
        HumanoidDied = "HumanoidDied",
        PlayerRemoving = "PlayerRemoving",
        External = "External"
    }
};
local v2 = t.union(t.literal(v1.States.Slot), t.literal(v1.States.Carried), t.literal(v1.States.Dropped), t.literal(v1.States.GuardCarried), t.literal(v1.States.Claimed));
local v3 = t.union(t.literal(v1.DropReasons.PlayerRequest), t.literal(v1.DropReasons.GuardHit), t.literal(v1.DropReasons.PlayerSlap), t.literal(v1.DropReasons.Rewind), t.literal(v1.DropReasons.CharacterRemoving), t.literal(v1.DropReasons.HumanoidDied), t.literal(v1.DropReasons.PlayerRemoving), t.literal(v1.DropReasons.External));
local v4 = t.interface({
    Uid = t.string,
    AreaId = t.string,
    NestId = t.string,
    AssetCategory = t.string,
    AssetScale = t.number,
    AssetEyeColor = t.string,
    AssetColorSeed = t.number,
    AssetColorIndex = t.number,
    Mutations = t.array(t.string),
    BaseMutation = t.optional(t.string),
    NestScale = t.number,
    BottomCFrame = t.CFrame,
    BoundsCFrame = t.CFrame,
    BoundsSize = t.Vector3,
    State = v2,
    CarrierUserId = t.optional(t.number),
    DroppedAt = t.optional(t.number),
    Version = t.number
});
v1.SchemaValidation = {
    AreaEggState = v2,
    DropReason = v3,
    AreaEggRecord = v4,
    AreaEggSnapshot = t.interface({
        Records = t.array(v4),
        ServerTime = t.number
    }),
    AreaEggBatchUpdate = t.interface({
        UpdatedRecords = t.array(v4),
        RemovedUids = t.array(t.string),
        ServerTime = t.number
    }),
    AreaEggCarryRequest = t.interface({
        Uid = t.string,
        FirstAreaSlotKey = t.optional(t.string)
    }),
    AreaEggDropRequest = t.interface({
        Reason = t.optional(v3)
    }),
    AreaEggCarryState = t.interface({
        IsCarrying = t.boolean,
        Uid = t.optional(t.string),
        AreaId = t.optional(t.string),
        AssetCategory = t.optional(t.string),
        RunBackWakeDelayRequired = t.optional(t.boolean),
        SpeedMultiplier = t.number
    }),
    AreaEggClaimFeedback = t.interface({
        AssetCategory = t.string,
        DisplayName = t.string,
        Rarity = t.string,
        Color = t.Color3,
        Position = t.Vector3
    })
};

return v1;