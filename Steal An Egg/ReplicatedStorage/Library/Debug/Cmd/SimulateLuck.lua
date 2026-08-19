-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DropTable = require(ReplicatedStorage.Library.DropTable);
local BrainrotItem = require(ReplicatedStorage.Library.Items.BrainrotItem);
local Assets = require(ReplicatedStorage.Directory.Assets);

local function getId(p1) -- Line: 16
    return p1._id;
end;

local function getWeight(p2) -- Line: 20
    return p2.DropWeight;
end;

local function getRarity(p3) -- Line: 24
    return p3.Rarity._id;
end;

local function makeItem(u4) -- Line: 28
    -- upvalues: BrainrotItem (copy)
    local success, result = pcall(function() -- Line: 31
        -- upvalues: BrainrotItem (ref), u4 (copy)
        return BrainrotItem(u4);
    end);

    if success and result then
        return result;
    end;

    error(("Could not construct BrainrotItem for asset id \'%s\'"):format((tostring(u4))));
end;

local v5 = {};

for _, v in pairs(Assets.Directory or Assets) do
    local _id = v._id;
    local DropWeight = v.DropWeight;

    if _id ~= nil and (typeof(DropWeight) == "number" and (DropWeight ~= 1 and DropWeight > 0)) then
        local success, result = pcall(function() -- Line: 31
            -- upvalues: BrainrotItem (copy), _id (copy)
            return BrainrotItem(_id);
        end);

        if not (success and result) then
            error(("Could not construct BrainrotItem for asset id \'%s\'"):format((tostring(_id))));
            result = nil;
        end;

        table.insert(v5, {
            Weight = DropWeight,
            Value = result,
            __rarity = v.Rarity._id,
            __id = _id
        });
    end;
end;

if #v5 == 0 then
    warn("[RollOneSim] No valid entries found. Check field names in getId/getWeight/getRarity.");

    return;
end;

local v6 = DropTable.new(v5);
local u7 = Random.new();

local function makeBiasedRNG(u8) -- Line: 73
    -- upvalues: DropTable (copy), u7 (copy)
    return function() -- Line: 74
        -- upvalues: DropTable (ref), u8 (copy), u7 (ref)
        return DropTable.SimulateRolls(u8, u7:NextNumber());
    end;
end;

local v9 = {};
local v10 = { 1, 10 };
local v11 = { "Basic", "Rare", "Epic", "Legendary", "Mythical", "BrainrotGod", "Secret", "Eternal", "Unknown" };

for i, v in ipairs(v6.entries) do
    local v12 = v5[i];

    for _, v2 in ipairs(v5) do
        if v2.Value == v.Value and v2.Weight == v.Weight then
            v12 = v2;
            break;
        end;
    end;

    v9[v] = v12;
end;

local function getItemRarity(u13, p14) -- Line: 103
    if u13 and u13.GetRarity then
        local success, result = pcall(function() -- Line: 105
            -- upvalues: u13 (copy)
            return u13:GetRarity();
        end);

        if success and result ~= nil then
            return result._id;
        end;
    end;

    return p14 or "Unknown";
end;

local function getItemId(u15, p16) -- Line: 115
    if u15 and u15.GetId then
        local success, result = pcall(function() -- Line: 117
            -- upvalues: u15 (copy)
            return u15:GetId();
        end);

        if success and result ~= nil then
            return result;
        end;
    end;

    return p16 or "?";
end;

local v17 = {};

for _, v in ipairs(v10) do
    local function v18() -- Line: 74
        -- upvalues: DropTable (copy), v (copy), u7 (copy)
        return DropTable.SimulateRolls(v, u7:NextNumber());
    end;

    local v19 = {};
    local v20 = {};

    for _ = 1, 200000 do
        local v21 = v6:RollOne(v18);

        if v21 and v21.Item then
            local v22 = v9[v21.Entry];
            local Item = v21.Item;
            local v23;

            if v22 then
                v23 = v22.__rarity;
            else
                v23 = v22;
            end;

            local v24;

            if Item and Item.GetRarity then
                local success, result = pcall(function() -- Line: 105
                    -- upvalues: Item (copy)
                    return Item:GetRarity();
                end);
                v24 = (not success or result == nil) and (v23 or "Unknown") or result._id;
            else
                v24 = v23 or "Unknown";
            end;

            local Item2 = v21.Item;

            if v22 then
                v22 = v22.__id;
            end;

            local v25;

            if Item2 and Item2.GetId then
                local success, result = pcall(function() -- Line: 117
                    -- upvalues: Item2 (copy)
                    return Item2:GetId();
                end);
                v25 = (not success or result == nil) and (v22 or "?") or result;
            else
                v25 = v22 or "?";
            end;

            v19[v24] = (v19[v24] or 0) + 1;
            v20[v25] = (v20[v25] or 0) + 1;
        end;
    end;

    v17[v] = {
        byRarity = v19,
        byId = v20
    };
end;

local function pct(p26) -- Line: 153
    return (p26 or 0) / 200000 * 100;
end;

print(("== RollOne Sim using DropTable.SimulateRolls, TRIALS=%d =="):format(200000));
local v27 = {};

for i, v in pairs(v17[10].byId) do
    table.insert(v27, {
        id = i,
        base = v17[1].byId[i] or 0,
        x10 = v
    });
end;

table.sort(v27, function(p28, p29) -- Line: 165
    return p28.x10 > p29.x10;
end);
print("== Per-Entry snapshot (top 30 by x10 observed %) ==");

for i = 1, math.min(30, #v27) do
    local v30 = v27[i];
    print(string.format("%-40s | base=%8.5f%%  x10=%8.5f%%", v30.id, (v30.base or 0) / 200000 * 100, (v30.x10 or 0) / 200000 * 100));
end;

print("\n== Per-Rarity Totals (baseline vs x10) ==");

for _, v in ipairs(v11) do
    local v31 = v17[1].byRarity[v] or 0;
    local v32 = v17[10].byRarity[v] or 0;

    if v31 + v32 > 0 then
        print(string.format("%-12s  base=%8.5f%%   x10=%8.5f%%", v, (v31 or 0) / 200000 * 100, (v32 or 0) / 200000 * 100));
    end;
end;

for i, _ in pairs(v17[1].byRarity) do
    local v33 = false;

    for _, v in ipairs(v11) do
        if v == i then
            v33 = true;
            break;
        end;
    end;

    if not v33 then
        print(string.format("%-12s  base=%8.5f%%   x10=%8.5f%%", i, (v17[1].byRarity[i] or 0 or 0) / 200000 * 100, (v17[10].byRarity[i] or 0 or 0) / 200000 * 100));
    end;
end;

return {};