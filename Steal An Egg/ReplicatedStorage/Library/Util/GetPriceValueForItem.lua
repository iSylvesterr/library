-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Directory.Assets);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);

return function(p1) -- Line: 13
    -- upvalues: AssetItem (copy), AssetGenerationUtil (copy)
    assert(AssetItem.AssetItemData(p1));

    return AssetGenerationUtil.GetRateWithoutRebirth(p1) * 100;
end;