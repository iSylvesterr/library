-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = require(ReplicatedStorage.Directory.Assets);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
require(ReplicatedStorage.Library.Types.AssetItem);
local RarityNumber = Rarity.Rarities.Secret.RarityNumber;
local u1 = {
    CFrame.new(-17.4227905, 1.14494324, -23.6600342),
    CFrame.new(-13.1647339, 1.14494324, -28.0780945),
    CFrame.new(-7.01275635, 1.14494324, -31.1100464),
    CFrame.new(7.54925537, 1.79094315, -31.1380615),
    CFrame.new(13.3172607, 1.14494324, -28.1280518),
    CFrame.new(17.959259, 1.14494324, -24.9380493)
};
local u2 = {};

local function hasDropTable(p3) -- Line: 41
    -- upvalues: Assets (copy)
    local v4 = Assets.Directory[p3];
    local v5 = v4 and v4.LuckyBlockDropTable or nil;
    local v6;

    if typeof(v5) == "table" then
        v6 = #v5 > 0;
    else
        v6 = false;
    end;

    return v6;
end;

local function getProgressGoalForRarityNumber(p7) -- Line: 47
    -- upvalues: RarityNumber (copy)
    return p7 < RarityNumber and 1 or (p7 == RarityNumber and 2 or 3);
end;

local function getCapturedAt(p8, p9) -- Line: 59
    local SpecialLuckyBlockCapturedAt = p9.SpecialLuckyBlockCapturedAt;

    return typeof(SpecialLuckyBlockCapturedAt) ~= "number" and (string.byte(p8, 1) or 0) or SpecialLuckyBlockCapturedAt;
end;

function u2.IsCategory(p10) -- Line: 69
    -- upvalues: Assets (copy)
    local v11 = Assets.Directory[p10];
    local v12 = v11 and v11.LuckyBlockDropTable or nil;
    local v13;

    if typeof(v12) == "table" then
        v13 = #v12 > 0;
    else
        v13 = false;
    end;

    return v13;
end;

function u2.IsItemData(p14) -- Line: 73
    -- upvalues: Assets (copy)
    local v15 = Assets.Directory[p14.Category];
    local v16 = v15 and v15.LuckyBlockDropTable or nil;
    local v17;

    if typeof(v16) == "table" then
        v17 = #v16 > 0;
    else
        v17 = false;
    end;

    return v17;
end;

function u2.GetProgressGoalForCategory(p18) -- Line: 77
    -- upvalues: Assets (copy), RarityNumber (copy)
    local Rarity2 = Assets.Directory[p18].Rarity;

    if Rarity2 then
        Rarity2 = Rarity2.RarityNumber;
    end;

    local v19 = typeof(Rarity2) == "number";
    local v20 = `Missing rarity number for special lucky block asset "{p18}"`;
    assert(v19, v20);

    return Rarity2 < RarityNumber and 1 or (Rarity2 == RarityNumber and 2 or 3);
end;

function u2.GetProgressGoalForItemData(p21) -- Line: 86
    -- upvalues: u2 (copy)
    return u2.GetProgressGoalForCategory(p21.Category);
end;

function u2.GetMaxCount() -- Line: 90
    return 36;
end;

function u2.CountInventory(p22) -- Line: 94
    -- upvalues: u2 (copy)
    local v23 = 0;

    for _, v in pairs(p22) do
        if u2.IsItemData(v) then
            v23 = v23 + 1;
        end;
    end;

    return v23;
end;

function u2.FindAvailableColumn(p24, p25) -- Line: 106
    -- upvalues: u2 (copy)
    local v26 = {};

    for i, v in pairs(p24) do
        if i ~= p25 and u2.IsItemData(v) then
            local SpecialLuckyBlockColumn = v.SpecialLuckyBlockColumn;

            if typeof(SpecialLuckyBlockColumn) == "number" and (SpecialLuckyBlockColumn >= 1 and SpecialLuckyBlockColumn <= 6) then
                v26[SpecialLuckyBlockColumn] = (v26[SpecialLuckyBlockColumn] or 0) + 1;
            end;
        end;
    end;

    local v27 = (1 / 0);
    local v28 = nil;

    for i = 1, 6 do
        local v29 = v26[i] or 0;

        if v29 < 6 and v29 < v27 then
            v28 = i;
            v27 = v29;
        end;
    end;

    return v28;
end;

function u2.GetLayout(p30, p31) -- Line: 136
    -- upvalues: u2 (copy), u1 (copy)
    local v32 = {};

    for i, v in pairs(p30) do
        if u2.IsItemData(v) then
            local SpecialLuckyBlockColumn = v.SpecialLuckyBlockColumn;

            if typeof(SpecialLuckyBlockColumn) == "number" and (SpecialLuckyBlockColumn >= 1 and SpecialLuckyBlockColumn <= 6) then
                local v33 = v32[SpecialLuckyBlockColumn];

                if not v33 then
                    v33 = {};
                    v32[SpecialLuckyBlockColumn] = v33;
                end;

                v33[#v33 + 1] = {
                    uid = i,
                    data = v
                };
            end;
        end;
    end;

    local v34 = {};

    for i = 1, 6 do
        local v35 = v32[i];

        if v35 then
            table.sort(v35, function(p36, p37) -- Line: 171
                local uid = p36.uid;
                local SpecialLuckyBlockCapturedAt = p36.data.SpecialLuckyBlockCapturedAt;
                local v38 = typeof(SpecialLuckyBlockCapturedAt) ~= "number" and (string.byte(uid, 1) or 0) or SpecialLuckyBlockCapturedAt;
                local uid2 = p37.uid;
                local SpecialLuckyBlockCapturedAt2 = p37.data.SpecialLuckyBlockCapturedAt;
                local v39 = typeof(SpecialLuckyBlockCapturedAt2) ~= "number" and (string.byte(uid2, 1) or 0) or SpecialLuckyBlockCapturedAt2;

                if v38 == v39 then
                    return p36.uid < p37.uid;
                end;

                return v38 < v39;
            end);

            for i2, v in ipairs(v35) do
                if i2 > 6 then
                    break;
                end;

                v34[#v34 + 1] = {
                    uid = v.uid,
                    data = v.data,
                    column = i,
                    row = i2,
                    cframe = p31 * u1[i] + Vector3.new(0, 1, 0) * ((i2 - 1) * 6)
                };
            end;
        end;
    end;

    return v34;
end;

return u2;