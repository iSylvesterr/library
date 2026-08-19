-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Guards = require(ReplicatedStorage.Directory.Guards);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;

return {
    Emoji = "😱",
    Icon = "rbxassetid://114973940272302",
    IndexBatGearId = "Abyss Ocean Bat",
    DisplayName = script.Name,
    DropTable = { { "Parrotfish", 34.755713 }, { "Swordfish", 24.665345 }, { "Finned Thresher", 19.059585 }, { "Orca", 14.574977 }, { "Whale Shark", 3.412663 }, { "Alabaster Whale", 2.616375 }, { "Kraken", 0.826453 }, { "El Maja", 0.08889 } },
    GuardId = Guards.Directory["Abyss Ocean"]._id,
    Rarity = Rarities.Cosmic
};