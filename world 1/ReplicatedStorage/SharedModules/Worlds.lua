-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Environment = require(ReplicatedStorage.SharedModules.Environment);
local u1 = {
    Main = {
        Id = "Main",
        DisplayName = "Garden Valley",
        CurrencyName = "Sheckles",
        CurrencySuffix = "¢",
        CurrencyIcon = "rbxassetid://106697118185275",
        PlaceType = "Primary",
        BotPlaceType = "BotUser",
        HuntPlaceType = "PetHunt",
        MoonTable = nil,
        Color = Color3.fromRGB(57, 179, 0),
        Features = {
            Auctioneer = true,
            PetHunt = true,
            PlayerRouting = true,
            Guilds = true,
            Mailbox = true,
            Explorer = true,
            Pilgrim = false,
            MagicMailSend = false,
            MagicMailClaim = true,
            WerewolfNight = false,
            FenceSkins = true
        }
    },
    FallHarvest = {
        Id = "FallHarvest",
        DisplayName = "Fall Harvest",
        CurrencyName = "Leaves",
        DefaultFenceSkin = "Fall",
        CurrencySuffix = "¢",
        CurrencyIcon = "rbxassetid://98538682011748",
        PlaceType = "FallHarvest",
        BotPlaceType = "FallHarvestBotUser",
        HuntPlaceType = "PetHuntFallHarvest",
        MoonTable = "FallHarvest",
        Color = Color3.fromRGB(232, 134, 46),
        Theme = {
            Decor = "rbxassetid://96792138208003",
            Ground = Color3.fromRGB(194, 101, 42),
            GroundBed = Color3.fromRGB(120, 72, 40),
            Header = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 106, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 187, 30)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 106, 0)) }),
            HeaderStroke = Color3.fromRGB(40, 27, 0),
            Title = Color3.fromRGB(50, 21, 0),
            TitleHighlight = Color3.fromRGB(255, 229, 187),
            Glow = Color3.fromRGB(89, 42, 18),
            Accent = Color3.fromRGB(214, 108, 26),
            AccentDark = Color3.fromRGB(92, 44, 8),
            AccentRamp = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(198, 84, 10)), ColorSequenceKeypoint.new(0.123, Color3.fromRGB(214, 104, 16)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 186, 66)) })
        },
        Features = {
            Auctioneer = true,
            PetHunt = true,
            PlayerRouting = false,
            Guilds = true,
            Mailbox = true,
            Explorer = true,
            Pilgrim = true,
            MagicMailSend = true,
            MagicMailClaim = false,
            WerewolfNight = true,
            FenceSkins = false
        }
    }
};
local u2 = {
    Worlds = u1
};
local worldId = Environment.worldId;

if u1[worldId] == nil then
    warn((`[Worlds] unknown worldId "{worldId}"; falling back to Main`));
    worldId = "Main";
end;

u2.CurrentId = worldId;
u2.Current = u1[worldId];
u2.IsMain = worldId == "Main";
u2.Theme = u1[worldId].Theme;

function u2.GetTravelTargets() -- Line: 227
    -- upvalues: Environment (copy), u1 (copy), worldId (ref)
    if Environment.isBotContainmentPlace then
        return {};
    end;

    local v3 = {};

    for _, v in u1 do
        if v.Id ~= worldId and Environment.places[v.PlaceType] ~= nil then
            table.insert(v3, v);
        end;
    end;

    table.sort(v3, function(p4, p5) -- Line: 243
        return p4.Id < p5.Id;
    end);

    return v3;
end;

function u2.GetPlaceId(p6) -- Line: 251
    -- upvalues: u1 (copy), Environment (copy)
    local v7 = u1[p6];

    if v7 == nil then
        return nil;
    end;

    return Environment.places[v7.PlaceType];
end;

function u2.GetBotPlaceId(p8) -- Line: 261
    -- upvalues: u1 (copy), Environment (copy)
    local v9 = u1[p8];

    if v9 == nil then
        return nil;
    end;

    return Environment.places[v9.BotPlaceType];
end;

function u2.GetHuntPlaceId(p10) -- Line: 274
    -- upvalues: u1 (copy), Environment (copy)
    local v11 = u1[p10];

    if v11 ~= nil then
        local v12 = Environment.places[v11.HuntPlaceType];

        if v12 ~= nil then
            return v12;
        end;
    end;

    return Environment.places[u1.Main.HuntPlaceType];
end;

function u2.IsHuntPlaceId(p13) -- Line: 289
    -- upvalues: u1 (copy), Environment (copy)
    for _, v in u1 do
        if Environment.places[v.HuntPlaceType] == p13 then
            return true;
        end;
    end;

    return false;
end;

function u2.EntryAvailableHere(p14) -- Line: 304
    -- upvalues: worldId (ref)
    local Worlds = p14.Worlds;

    return Worlds == nil and true or table.find(Worlds, worldId) ~= nil;
end;

function u2.IsExclusiveToOtherWorld(p15) -- Line: 321
    local Worlds = p15.Worlds;

    if Worlds == nil then
        return false;
    end;

    return table.find(Worlds, "Main") == nil;
end;

function u2.WalletStatName(p16) -- Line: 333
    -- upvalues: Environment (copy), u1 (copy), u2 (copy)
    if Environment.isPetHuntPlace then
        local v17 = p16:GetAttribute("PetHuntOriginWorld");
        local v18 = type(v17) == "string" and u1[v17];

        if v18 then
            return v18.CurrencyName;
        end;
    end;

    return u2.Current.CurrencyName;
end;

function u2.WalletIcon(p19) -- Line: 350
    -- upvalues: Environment (copy), u1 (copy), u2 (copy)
    if Environment.isPetHuntPlace then
        local v20 = p19:GetAttribute("PetHuntOriginWorld");
        local v21 = type(v20) == "string" and u1[v20];

        if v21 then
            return v21.CurrencyIcon;
        end;
    end;

    return u2.Current.CurrencyIcon;
end;

function u2.WaitForWalletStat(p22, p23) -- Line: 367
    -- upvalues: u2 (copy)
    local v24 = os.clock() + (p23 or 10);

    while true do
        local leaderstats = p22:FindFirstChild("leaderstats");

        if leaderstats then
            leaderstats = leaderstats:FindFirstChild(u2.WalletStatName(p22));
        end;

        if leaderstats and leaderstats:IsA("IntValue") then
            return leaderstats;
        end;

        task.wait(0.25);

        if v24 <= os.clock() then
            return nil;
        end;
    end;
end;

return table.freeze(u2);