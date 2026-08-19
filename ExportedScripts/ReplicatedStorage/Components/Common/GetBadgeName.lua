-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local u1 = table.freeze({
    ["Medal.tv"] = "Medal"
});

return function(p2, p3) -- Line: 23
    -- upvalues: DataController (copy), Skins (copy), u1 (copy)
    local v4, v5 = DataController.Get(p2, "Loadout", "Inventory");

    if not (v4 and v5) then
        return "";
    end;

    local v6 = v4[p3];

    if not (v6 and v6.Equipped) then
        return "";
    end;

    local v7 = v6.Equipped["Equipped Badge"];

    if not v7 or v7 == "" then
        return "";
    end;

    local v8 = nil;

    for _, v in ipairs(v5) do
        if v._id == v7 then
            v8 = v;
            break;
        end;
    end;

    return not v8 and "" or (not Skins.GetSkinInformation(v8.Name, v8.Skin) and "" or (u1[v8.Skin] or v8.Skin));
end;