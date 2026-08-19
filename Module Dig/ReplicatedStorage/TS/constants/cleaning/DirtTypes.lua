-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local Items = v2.Items;
local RARITY_ORDER = v2.RARITY_ORDER;
local UNDISCOVERABLE_ITEM_IDS = v2.UNDISCOVERABLE_ITEM_IDS;
local u3 = Color3.fromRGB(198, 186, 142);
local u4 = Color3.fromRGB(120, 92, 60);
local v5 = v1.keys(Items);

local function _(p6) -- Line: 20
    -- upvalues: UNDISCOVERABLE_ITEM_IDS (copy)
    return UNDISCOVERABLE_ITEM_IDS[p6] == nil;
end;

local v7 = 0;
local v8 = {};

for i, v in v5 do
    local _ = i - 1;

    if UNDISCOVERABLE_ITEM_IDS[v] == nil == true then
        v7 = v7 + 1;
        v8[v7] = v;
    end;
end;

local function toughnessFor(p9) -- Line: 33
    return math.pow(p9 / 30, 0.28);
end;

local function _(p10, p11) -- Line: 38
    -- upvalues: Items (copy)
    local v12 = math.pow(Items[p11].displayOneIn / 30, 0.28);

    return math.max(p10, v12);
end;

local u13 = 1;

for i = 1, #v8 do
    local _ = i - 1;
    local v14 = math.pow(Items[v8[i]].displayOneIn / 30, 0.28);
    u13 = math.max(u13, v14);
end;

local function dirtFrom(p15) -- Line: 46
    -- upvalues: u13 (copy), u3 (copy), u4 (copy)
    local v16 = math.log(p15) / math.log(u13);
    local v17 = math.clamp(v16, 0, 1);
    local v18 = {
        color = u3:Lerp(u4, v17),
        colorJitter = v17 * -0.030000000000000006 + 0.07
    };
    local v19;

    if v17 < 0.3 then
        v19 = Enum.Material.Sand;
    elseif v17 < 0.62 then
        v19 = Enum.Material.Ground;
    else
        v19 = Enum.Material.Mud;
    end;

    v18.material = v19;
    v18.toughness = p15 * 0.7;

    return v18;
end;

local u20 = {};

for _, v in v5 do
    u20[v] = dirtFrom((math.pow(Items[v].displayOneIn / 30, 0.28)));
end;

local u21 = {};

for _, v in RARITY_ORDER do
    local function _(p22) -- Line: 63
        -- upvalues: Items (copy), v (copy)
        return Items[p22].rarity == v;
    end;

    local v23 = 0;
    local v24 = {};

    for i, v3 in v8 do
        local _ = i - 1;

        if Items[v3].rarity == v == true then
            v23 = v23 + 1;
            v24[v23] = v3;
        end;
    end;

    local function _(p25, p26) -- Line: 77
        -- upvalues: Items (copy)
        return p25 + math.pow(Items[p26].displayOneIn / 30, 0.28);
    end;

    local v27 = 0;

    for i = 1, #v24 do
        local _ = i - 1;
        v27 = v27 + math.pow(Items[v24[i]].displayOneIn / 30, 0.28);
    end;

    u21[v] = dirtFrom(#v24 <= 0 and 1 or v27 / #v24);
end;

return {
    dirtFor = function(p28) -- Line: 87, Name: dirtFor
        -- upvalues: u20 (copy)
        return u20[p28];
    end,

    dirtForRarity = function(p29) -- Line: 90, Name: dirtForRarity
        -- upvalues: u21 (copy)
        return u21[p29];
    end
};