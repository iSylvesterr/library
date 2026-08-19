-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);

return function(p1, p2) -- Line: 18
    -- upvalues: DataController (copy), Skins (copy)
    local v3, v4 = DataController.Get(p1, "Loadout", "Inventory");

    if not (v3 and v4) then
        return "";
    end;

    local v5 = v3[p2];

    if not (v5 and v5.Equipped) then
        return "";
    end;

    local v6 = v5.Equipped["Equipped Badge"];

    if not v6 or v6 == "" then
        return "";
    end;

    local v7 = nil;

    for _, v in ipairs(v4) do
        if v._id == v6 then
            v7 = v;
            break;
        end;
    end;

    if not v7 then
        return "";
    end;

    local v8 = Skins.GetSkinInformation(v7.Name, v7.Skin);

    return v8 and (Skins.GetWearImageForFloat(v8, v7.Float or 0.9999) or v8.imageAssetId or "") or "";
end;