-- Decompiled with Potassium's decompiler.

local Normal = game:GetService("SoundService"):WaitForChild("SoundEffects"):WaitForChild("Loot"):WaitForChild("Normal");
local Images = require(game.ReplicatedStorage.Shared.Info.Images);
local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local DeepCopy = require(game.ReplicatedStorage.Shared.Utility.DeepCopy);
local u1 = {};
u1.__index = u1;
u1.identifier = "item";
u1.properName = "Test Item";
u1.shortName = "Test";
u1.image = Images.NO_IMAGE;
u1.PickupSfx = Normal;
u1.isActualItem = false;
u1.mainCatagory = CustomEnum.ITEM_CATAGORIES.MISC;
u1.description = { "This item does not", "have a description", ":(" };
u1.shinyIcon = false;
u1.rarity = CustomEnum.RARITIES.COMMON;

function u1.new(p2) -- Line: 43
    -- upvalues: u1 (copy), DeepCopy (copy)
    return DeepCopy(p2 or u1);
end;

return u1;