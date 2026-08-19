-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GardenSyncController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.GardenSyncController);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local SellValueData = require(ReplicatedStorage.SharedModules.SellValueData);
local FruitIdentity = require(ReplicatedStorage.SharedModules.FruitIdentity);
local u1 = {};

for _, v in SeedData do
    u1[v.SeedName or v.PlantName] = v;
end;

return function(p2) -- Line: 14, Name: GetGenerationPerMinute
    -- upvalues: Players (copy), GardenSyncController (copy), SellValueData (copy), FruitIdentity (copy), u1 (copy)
    local v3;

    if p2 then
        v3 = p2.UserId;
    else
        v3 = Players.LocalPlayer.UserId;
    end;

    local v4 = GardenSyncController:GetGarden(v3);

    if not (v4 and next(v4)) then
        return 0;
    end;

    local v5 = {};

    for _, v in v4 do
        local PlantName = v.PlantName;

        if PlantName then
            local v6 = SellValueData[FruitIdentity.ResolveFruitName(PlantName)] or 0;

            if v6 > 0 then
                local v7 = u1[PlantName];

                if v7 and v7.IsSingleHarvest or false then
                    table.insert(v5, {
                        isSingleHarvest = true,
                        value = v6
                    });
                else
                    local MaxFruitSpawnLocations = v.MaxFruitSpawnLocations;

                    for _ = 1, (not MaxFruitSpawnLocations or MaxFruitSpawnLocations == 0) and 1 or MaxFruitSpawnLocations do
                        table.insert(v5, {
                            isSingleHarvest = false,
                            value = v6
                        });
                    end;
                end;
            end;
        end;
    end;

    table.sort(v5, function(p8, p9) -- Line: 53
        return p8.value > p9.value;
    end);
    local v10 = 0;

    for i = 1, math.min(#v5, 100) do
        local v11 = v5[i];

        if v11.isSingleHarvest then
            v10 = v10 + v11.value;
        else
            v10 = v10 + v11.value * 6;
        end;
    end;

    return v10;
end;