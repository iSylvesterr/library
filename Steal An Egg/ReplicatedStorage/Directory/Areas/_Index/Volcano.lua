-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Guards = require(ReplicatedStorage.Directory.Guards);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;

return {
    Emoji = "😰",
    Icon = "rbxassetid://114058528069937",
    IndexBatGearId = "Volcano Bat",
    DisplayName = script.Name,
    DropTable = { { "Ash Gecko", 26.848869 }, { "Lava frog", 22.040116 }, { "Flaming Bull", 18.032822 }, { "Lava Iguana", 15.027352 }, { "Chillin Chilli", 17.030999 }, { "Cerberus", 0.61984 }, { "Ascended Vermilion Phoenix", 0.222224 }, { "Dragon", 0.177779 } },
    GuardId = Guards.Directory.Volcano._id,
    Rarity = Rarities.Mythic
};