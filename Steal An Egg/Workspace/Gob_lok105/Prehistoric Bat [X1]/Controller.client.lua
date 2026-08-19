-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Client = require(ReplicatedStorage.Library.Modules.BatController.Client);
local Gears = require(ReplicatedStorage.Directory.Gears);
local Parent = script.Parent;
local v1 = Parent:GetAttribute("GearName");
local v2 = typeof(v1) == "string";
assert(v2, "Bat Tool requires a GearName attribute");
local BatControllerData = Gears.Directory[v1].BatControllerData;
local v3 = `{v1} requires BatControllerData`;
local v4 = assert(BatControllerData, v3);
Client.new(Parent, v4);