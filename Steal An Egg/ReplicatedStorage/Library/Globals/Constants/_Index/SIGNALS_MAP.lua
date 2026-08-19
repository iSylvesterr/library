-- Decompiled with Potassium's decompiler.

local Server = script.Server;
local Client = script.Client;
local Shared = script.Shared;
local v1 = {};
local v2 = {};
local v3 = {};
local v4 = {};
v1.Server = v2;
v1.Client = v3;
v1.Shared = v4;
v4.AssetGenerationUtil = require(Shared.AssetGenerationUtil);
v2.MoneyService = require(Server.MoneyService);
v2.GearInventory = require(Server.GearInventory);
v2.EggInventory = require(Server.EggInventory);
v2.SwordInventory = require(Server.SwordInventory);
v2.SkinInventory = require(Server.SkinInventory);
v2.Inventory = require(Server.Inventory);
v2.Rebirth = require(Server.Rebirth);
v2.Guards = require(Server.Guards);
v2.AreaBrainrot = require(Server.AreaBrainrot);
v2.Kernel = require(Server.Kernel);
v2.MurderMystery = require(Server.MurderMystery);
v2.ActiveAssetsController = require(Server.ActiveAssetsController);
v2.BrainrotItem = require(Server.BrainrotItem);
v3.ActiveAssetItems = require(Client.ActiveAssetItems);
v3.Plots = require(Client.Plots);
v3.ClientCharacter = require(Client.ClientCharacter);
v3.TradingNotifications = require(Client.TradingNotifications);
v3.FuseMachine = require(Client.FuseMachine);

return v1;