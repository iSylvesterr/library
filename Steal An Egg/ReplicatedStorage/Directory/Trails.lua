-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local Interface = require(script.Types.Interface);
local v1 = {};
local u2 = ModuleLoader(script._Index, {}, {
    typeCast = "TrailsDir",
    rootName = "Trails.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
v1.Directory = u2;
v1.Types = Interface;

if Constants.IS_STUDIO then
    local Trails = ReplicatedStorage.Assets.Trails;

    for _, child in pairs(script._Index:GetChildren()) do
        local v3 = child:IsA("ModuleScript");
        local v4 = `Bad trail config instance: {child.Name}`;
        assert(v3, v4);
        local v5 = u2[child.Name];
        local v6, v7 = Interface.DefaultConfig(v5);
        local v8 = `Failed to validate trail config {child.Name}: {v7}`;
        assert(v6, v8);
        local v9 = Trails:FindFirstChild(v5._id);
        local v10 = `Trail asset not found for config {child.Name}`;
        assert(v9 ~= nil, v10);
        local v11 = v9:IsA("BasePart");
        local v12 = `Trail asset for config {child.Name} must be a BasePart`;
        assert(v11, v12);
        local MainPartTrailWeldConstraint = v9:FindFirstChild("MainPartTrailWeldConstraint");
        local v13 = `Trail asset for config {child.Name} is missing MainPartTrailWeldConstraint`;
        assert(MainPartTrailWeldConstraint ~= nil, v13);
        local v14 = MainPartTrailWeldConstraint:IsA("WeldConstraint");
        local v15 = `Trail asset for config {child.Name} MainPartTrailWeldConstraint must be a WeldConstraint`;
        assert(v14, v15);
    end;
end;

MakeTableStrict(u2, "Trails");

function v1.Types.TrailNameExists(u16) -- Line: 56
    -- upvalues: u2 (copy)
    if pcall(function() -- Line: 57
        -- upvalues: u2 (ref), u16 (copy)
        return u2[u16];
    end) then
        return true;
    end;

    return false, `Trail name "{u16}" does not exist in the Trails directory.`;
end;

return v1;