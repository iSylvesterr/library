-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local u1 = require(ReplicatedStorage.Library.Modules.Mutations).GetMutationsMap();
local v2 = {};

local function hasMutation(p3, p4) -- Line: 20
    return p3.BaseMutation == p4 and true or table.find(p3.Mutations, p4) ~= nil;
end;

function v2.GetMultiplier(p5) -- Line: 28
    -- upvalues: AssetItem (copy), u1 (copy)
    local v6 = AssetItem.AssetItemData(p5);
    assert(v6, "Invalid asset item data");
    local Rainbow = u1.Rainbow;

    if p5.BaseMutation == Rainbow and true or table.find(p5.Mutations, Rainbow) ~= nil then
        return 2;
    end;

    local Golden = u1.Golden;

    if p5.BaseMutation == Golden and true or table.find(p5.Mutations, Golden) ~= nil then
        return 0.5;
    end;

    local Silver = u1.Silver;

    return (p5.BaseMutation == Silver and true or table.find(p5.Mutations, Silver) ~= nil) and 0.7 or 1;
end;

return v2;