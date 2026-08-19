-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Interface = require(script.Types.Interface);
local Data = require(script.Data);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local v1 = {};
local v2 = ModuleLoader(script._Index, {}, {
    typeCast = "SpinnyWheels",
    rootName = "SpinnyWheels.Directory",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
v1.Directory = v2;
v1.Types = Interface;
v1.Data = Data;
MakeTableStrict(v2, "SpinnyWheels.Directory");

if Constants.IS_STUDIO then
    for _, child in pairs(script._Index:GetChildren()) do
        local Name = child.Name;
        local v3 = child:IsA("ModuleScript");
        local v4 = `Bad instance: {Name}`;
        assert(v3, v4);
        local v5, v6 = Interface.DefaultConfig(v2[Name]);
        local v7 = `Invalid config module: {Name} - {v6}`;
        assert(v5, v7);
        local v8 = Interface.AllWheelNames(Name);
        local v9 = `Spinny Wheel name: "{Name}" is not registered in AllWheelNames.`;
        assert(v8, v9);
    end;
end;

return v1;