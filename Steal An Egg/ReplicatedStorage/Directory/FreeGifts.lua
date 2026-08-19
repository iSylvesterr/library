-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Interface = require(script.Types.Interface);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local FreeGifts = require(ReplicatedStorage.Library.Types.FreeGifts);
local v1 = {};
local v2 = ModuleLoader(script._Index, {}, {
    typeCast = "FreeGiftDir",
    rootName = "FreeGift.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
v1.Directory = v2;
v1.Types = Interface;
v1.SortedById = {};

for _, v in pairs(v2) do
    if not v.TypeData then
        v.TypeData = FreeGifts.TypeData[v.Type];
    end;
end;

if Constants.IS_STUDIO then
    for _, child in pairs(script._Index:GetChildren()) do
        local v3 = child:IsA("ModuleScript");
        local v4 = `Bad instance found inside the configs env: {child.Name}`;
        assert(v3, v4);
        assert(Interface.DefaultConfig(v2[child.Name]));
    end;
end;

for _, v in pairs(v2) do
    v1.SortedById[v.Id] = v;
end;

table.sort(v1.SortedById, function(p5, p6) -- Line: 55
    return p5.Id < p6.Id;
end);
MakeTableStrict(v1.SortedById, "SortedByIdFreeGifts");
MakeTableStrict(v2, "FreeGifts");

return v1;