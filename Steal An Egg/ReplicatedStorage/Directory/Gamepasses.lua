-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Interface = require(script.Types.Interface);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local v1 = {};
local v2 = ModuleLoader(script._Index, {}, {
    typeCast = "GamepassesDir",
    rootName = "Gamepasses.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
v1.Directory = v2;
v1.Types = Interface;

if Constants.IS_STUDIO then
    local v3 = {};

    for i, v in pairs(v2) do
        local v4, v5 = Interface.DefaultConfig(v);
        local v6 = `Bad config found in Gamepasses: {i} - {v5}`;
        assert(v4, v6);

        if v3[v.ProductId] then
            error((`Duplicate Gamepass: {i} / {v.ProductId}`));
        else
            v3[v.ProductId] = i;
        end;
    end;
end;

MakeTableStrict(v2, "Gamepasses");

return v1;