-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Knit = require(ReplicatedStorage.Packages.Knit);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local ExpandedRarities = require(ReplicatedStorage.Shared.Info.ExpandedRarities);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local v1 = Knit.CreateController({
    Name = "SeedAffordNotif"
});

local function rgbTag(p2) -- Line: 12
    return string.format("rgb(%d,%d,%d)", math.round(p2.R * 255), math.round(p2.G * 255), (math.round(p2.B * 255)));
end;

function v1.KnitStart(p3) -- Line: 16
    -- upvalues: SeedConfig (copy), CustomEnum (copy), ExpandedRarities (copy)
    local DataClient = p3.DataClient;
    local NotificationController = p3.NotificationController;
    local u4 = {};

    for i, v in SeedConfig.Seeds do
        if (v.plantCost or 0) > 0 then
            table.insert(u4, {
                seedType = i,
                def = v
            });
        end;
    end;

    table.sort(u4, function(p5, p6) -- Line: 26
        return p5.def.plantCost < p6.def.plantCost;
    end);
    local u7 = nil;

    local function onUpdate() -- Line: 30
        -- upvalues: DataClient (copy), CustomEnum (ref), u7 (ref), u4 (copy), ExpandedRarities (ref), NotificationController (copy), SeedConfig (ref)
        local currentData = DataClient.currentData;
        local v8 = currentData and currentData.Currency and currentData.Currency[CustomEnum.CURRENCIES.COINS];

        if not v8 then
            return;
        end;

        if not u7 then
            u7 = v8;

            return;
        end;

        if v8 <= u7 then
            return;
        end;

        for _, v in u4 do
            local plantCost = v.def.plantCost;

            if u7 < plantCost and plantCost <= v8 then
                local v9 = ExpandedRarities[v.def.rarity];
                local v10 = v9 and v9.mainColor or Color3.new(1, 1, 1);
                NotificationController:SendNotification(string.format("You can afford <font color=\"%s\">%ss</font>!", string.format("rgb(%d,%d,%d)", math.round(v10.R * 255), math.round(v10.G * 255), (math.round(v10.B * 255))), SeedConfig.SeedDisplayName(v.seedType)), 4, Color3.new(1, 1, 1), false, false, false, 0, true);
            end;
        end;

        u7 = v8;
    end;

    DataClient.EV_UPDATE:Connect(onUpdate);
    DataClient.EV_FIRST_UPDATE:Once(onUpdate);

    if DataClient:GetLoaded() then
        onUpdate();
    end;
end;

function v1.KnitInit(p11) -- Line: 59
    -- upvalues: Knit (copy)
    p11.DataClient = Knit.GetController("DataClient");
    p11.NotificationController = Knit.GetController("NotificationController");
end;

return v1;