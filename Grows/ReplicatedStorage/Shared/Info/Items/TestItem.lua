-- Decompiled with Potassium's decompiler.

game:GetService("RunService");
local Item = require(game.ReplicatedStorage.Shared.Classes.Item);
require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local Images = require(game.ReplicatedStorage.Shared.Info.Images);
local v1 = Item.new(require(script.Parent));
v1.identifier = "TestItem";
v1.properName = "Test Item";
v1.image = Images.NO_IMAGE;
v1.isActualItem = true;

return v1;