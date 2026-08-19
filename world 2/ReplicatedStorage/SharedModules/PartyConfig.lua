-- Decompiled with Potassium's decompiler.

local u1 = {
    PotBase = 10,
    RankShare = { 1, 0.6, 0.4, 0.25, 0.15, 0.1, 0.05, 0.02 },
    MaxSingleAward = 10000,
    MaxPoints = 1000000,
    MaxPointDrop = 50,
    EventDurationSeconds = 1800,
    MaxEventDurationSeconds = 86400,
    ChestCrateName = "Admin Chest",
    Icon = "rbxassetid://134591114731565",
    MusicVolume = 0.5,
    MusicTracks = { {
            Name = "Stadium Rave",
            AssetId = 1846368080
        }, {
            Name = "Raining Tacos",
            AssetId = 142376088
        }, {
            Name = "Monster Mash",
            AssetId = 95780928979580
        }, {
            Name = "EDM Party Time",
            AssetId = 1847692770
        }, {
            Name = "DJ Samstorm",
            AssetId = 114782160581561
        }, {
            Name = "Party All Night",
            AssetId = 98313568533071
        }, {
            Name = "Obby Flow",
            AssetId = 124364285175813
        }, {
            Name = "Psytrance",
            AssetId = 131063276839148
        }, {
            Name = "Soda Pop Circuit",
            AssetId = 73525702876989
        }, {
            Name = "Earth Invasion",
            AssetId = 1835904215
        }, {
            Name = "Party Hype",
            AssetId = 1847444965
        }, {
            Name = "Crab Rave",
            AssetId = 5410086218
        } },
    Ticks = { {
            Points = 30,
            Label = "1"
        }, {
            Points = 60,
            Label = "2"
        }, {
            Points = 90,
            Label = "3"
        }, {
            Points = 120,
            Label = "4"
        }, {
            Points = 150,
            Label = "5"
        }, {
            Points = 180,
            Label = "6"
        }, {
            Points = 210,
            Label = "7"
        }, {
            Points = 240,
            Label = "8"
        }, {
            Points = 270,
            Label = "9"
        }, {
            Points = 300,
            Label = "10"
        }, {
            Points = 330,
            Label = "11"
        }, {
            Points = 360,
            Label = "12"
        }, {
            Points = 390,
            Label = "13"
        }, {
            Points = 420,
            Label = "14"
        }, {
            Points = 450,
            Label = "15"
        }, {
            Points = 480,
            Label = "16"
        }, {
            Points = 510,
            Label = "17"
        }, {
            Points = 540,
            Label = "18"
        }, {
            Points = 570,
            Label = "19"
        }, {
            Points = 600,
            Label = "Admin Chest",
            IsChest = true
        } }
};

function u1.GetMaxTickPoints() -- Line: 108
    -- upvalues: u1 (copy)
    local v2 = 0;

    for _, v in u1.Ticks do
        if v2 < v.Points then
            v2 = v.Points;
        end;
    end;

    return v2;
end;

function u1.PointsForPlacement(p3, p4) -- Line: 119
    -- upvalues: u1 (copy)
    if type(p3) ~= "number" or type(p4) ~= "number" then
        return 0;
    end;

    if p3 < 1 or p4 < 1 then
        return 0;
    end;

    local v5 = u1.RankShare[p3];

    return not v5 and 0 or math.floor(u1.PotBase * p4 * v5);
end;

return u1;