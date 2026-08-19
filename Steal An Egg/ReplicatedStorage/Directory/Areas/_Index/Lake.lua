-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Guards = require(ReplicatedStorage.Directory.Guards);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;

return {
    Emoji = "😐",
    Icon = "rbxassetid://121852407064086",
    IndexBatGearId = "Lake Bat",
    DisplayName = script.Name,
    DropTable = { { "Frog", 29.274167 }, { "Duckling", 23.217443 }, { "Catfish", 17.160719 }, { "Turtle", 12.113448 }, { "Trulimero Trulicina", 8.075632 }, { "Swan", 5.551997 }, { "Dream Axolotl", 4.037816 }, { "Basilisk", 0.568777 } },
    GuardId = Guards.Directory.Lake._id,
    Rarity = Rarities.Uncommon
};