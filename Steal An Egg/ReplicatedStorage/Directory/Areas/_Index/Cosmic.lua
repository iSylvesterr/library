-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Guards = require(ReplicatedStorage.Directory.Guards);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;

return {
    Emoji = "👹",
    Icon = "rbxassetid://130113964572741",
    IndexBatGearId = "Cosmic Bat",
    DisplayName = script.Name,
    DropTable = { { "Centapede", 39.869773 }, { "Galaxy Gecko", 34.387407 }, { "Cyclops Gorilla", 19.618806 }, { "La Vacca Saturno Saturnita", 4.550072 }, { "Alien Skeleton Boss", 0.495856 }, { "Cave Dragon", 0.743784 }, { "Eternal Lunar Dragon", 0.311104 }, { "Unicorn", 0.0231993 } },
    GuardId = Guards.Directory.Cosmic._id,
    Rarity = Rarities.Eternal
};