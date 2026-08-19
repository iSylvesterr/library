-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Interface = require(script.Types.Interface);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local v1 = {};
local u2 = ModuleLoader(script._Index, {}, {
    typeCast = "AreasDir",
    rootName = "Areas.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
v1.Directory = u2;
v1.Types = Interface;

function v1.Types.AreaNameExists(u3) -- Line: 33
    -- upvalues: u2 (copy)
    if pcall(function() -- Line: 34
        -- upvalues: u2 (ref), u3 (copy)
        return u2[u3];
    end) then
        return true;
    end;

    return false, `Area name "{u3}" does not exist in the Areas directory.`;
end;

if Constants.IS_STUDIO then
    for _, child in pairs(script._Index:GetChildren()) do
        local v4 = child:IsA("ModuleScript");
        local v5 = `Bad instance found inside the configs env: {child.Name}`;
        assert(v4, v5);
        local v6, v7 = Interface.AreaConfig(u2[child.Name]);
        local v8 = `Failed to validate config {child.Name}: {v7}`;
        assert(v6, v8);
    end;
end;

MakeTableStrict(u2, "Areas");

return v1;