-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local v1 = {};
local v2 = t.strictInterface({
    OwnerUserId = t.number,
    UID = t.string,
    ItemData = AssetItem.AssetItemData,
    MoneyPerSecond = t.number,
    Seed = t.number,
    IsFirstPlacement = t.optional(t.boolean)
});
local v3 = t.map(t.string, v2);
local v4 = t.strictInterface({
    OwnerUserId = t.number,
    Records = v3
});
v1.SchemaValidation = {
    RuntimeAssetRecord = v2,
    RuntimeAssetRecords = v3,
    RuntimeAssetOwnerUpdate = v4,
    RuntimeAssetOwnerClear = t.strictInterface({
        OwnerUserId = t.number
    }),
    RuntimeAssetSnapshot = t.array(v4)
};

return v1;