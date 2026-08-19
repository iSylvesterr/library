-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = require(ReplicatedStorage.Directory.Assets);
local v1 = table.freeze({
    Common = 6,
    Rare = 15,
    Epic = 60,
    Legendary = 360,
    Mythic = 1020,
    BrainrotGod = 5400,
    Secret = 21600
});
local v2 = {};
local v3 = 0;

local function formatDuration(p4) -- Line: 37
    if p4 < 3600 then
        if p4 >= 120 then
            return string.format("%.2fm", p4 / 60);
        end;

        return string.format("%.2fs", p4);
    end;

    local v5 = p4 / 3600;

    if v5 >= 48 then
        return string.format("%.2fd", v5 / 24);
    end;

    return string.format("%.2fh", v5);
end;

for i, v in pairs(Assets.Directory or Assets) do
    local DropWeight = v.DropWeight;

    if typeof(DropWeight) == "number" and DropWeight > 0 then
        local Rarity = v.Rarity;
        local v6 = "Unknown";
        local v7;

        if typeof(Rarity) == "table" then
            v7 = Rarity._id;

            if typeof(v7) == "string" then
                if v7 == "" then
                    v7 = v6;
                end;
            else
                v7 = v6;
            end;

            local DisplayName = Rarity.DisplayName;

            if typeof(DisplayName) == "string" and DisplayName ~= "" then
                v6 = v7;
                v7 = DisplayName;
            else
                v6 = v7;
            end;
        else
            v7 = v6;
        end;

        local v8 = v2[v6];

        if not v8 then
            v8 = {
                totalWeight = 0,
                id = v6,
                displayName = v7,
                entries = {}
            };
            v2[v6] = v8;
        end;

        v8.totalWeight = v8.totalWeight + DropWeight;
        table.insert(v8.entries, {
            name = i,
            dropWeight = DropWeight
        });
        v3 = v3 + DropWeight;
    end;
end;

if v3 <= 0 then
    warn("[LogEstimatedTime] No assets with positive DropWeight found.");

    return;
end;

local v9 = {};

for _, v in pairs(v2) do
    table.insert(v9, v);
    table.sort(v.entries, function(p10, p11) -- Line: 108
        if p10.dropWeight == p11.dropWeight then
            return p10.name < p11.name;
        end;

        return p10.dropWeight > p11.dropWeight;
    end);
end;

table.sort(v9, function(p12, p13) -- Line: 116
    if p12.totalWeight == p13.totalWeight then
        return p12.id < p13.id;
    end;

    return p12.totalWeight > p13.totalWeight;
end);
print(string.format("[LogEstimatedTime] total drop weight = %.12f", v3));

for _, v in ipairs(v9) do
    local v14 = v.totalWeight / v3;
    local v15 = 2 / v14;
    local v16 = formatDuration(v15);
    local v17 = v1[v.id];
    local v18;

    if typeof(v17) == "number" then
        local v19 = v15 - v17;
        local v20 = formatDuration((math.abs(v19)));
        v18 = string.format(" (target %.2fs, %s by %s)", v17, v19 >= 0 and "slower" or "faster", v20);
    else
        v18 = "";
    end;

    print(string.format("[LogEstimatedTime] Rarity %s: weight=%.12f, probability=%.6f%%%%, expected interval ≈ %s%s", v.displayName, v.totalWeight, v14 * 100, v16, v18));

    for _, v4 in ipairs(v.entries) do
        local v21 = v4.dropWeight / v3;
        print(string.format("    - %s: weight=%.12f, probability=%.6f%%%%, expected interval ≈ %s", v4.name, v4.dropWeight, v21 * 100, formatDuration(2 / v21)));
    end;
end;