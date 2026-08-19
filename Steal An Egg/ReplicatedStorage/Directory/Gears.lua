-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Interface = require(script.Types.Interface);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local SearchGearToolUtil = require(ReplicatedStorage.Library.Util.SearchGearToolUtil);
local v1 = {};
local u2 = ModuleLoader(script._Index, {}, {
    typeCast = "GearsDir",
    rootName = "Gears.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
v1.Directory = u2;
v1.Types = Interface;

function v1.Types.GearNameExists(u3) -- Line: 33
    -- upvalues: u2 (copy)
    if pcall(function() -- Line: 34
        -- upvalues: u2 (ref), u3 (copy)
        return u2[u3];
    end) then
        return true;
    end;

    return false, `Gears name "{u3}" does not exist in the Gears directory.`;
end;

if Constants.IS_STUDIO then
    for _, descendant in pairs(script._Index:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            local v4 = u2[descendant.Name];
            local v5, v6 = Interface.DefaultConfig(v4);
            local v7 = `Failed to validate config {descendant.Name}: {v6}`;
            assert(v5, v7);
            local v8 = v4.MaxShopStockQuantity >= v4.MinShopStockQuantity;
            local v9 = `Config {descendant.Name} has MaxShopStockQuantity {v4.MaxShopStockQuantity} < MinShopStockQuantity {v4.MinShopStockQuantity}`;
            assert(v8, v9);
            local v10 = v4.ToolModel or descendant.Name;
            local v11 = SearchGearToolUtil(v10);
            local v12 = `Missing GearModel {v10} for {descendant.Name} in ReplicatedStorage.GearTools`;
            assert(v11, v12);
        end;
    end;
end;

MakeTableStrict(u2, "Gears");

return v1;