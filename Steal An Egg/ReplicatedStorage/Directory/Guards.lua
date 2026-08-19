-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local Interface = require(script.Types.Interface);
local u1 = ModuleLoader(script._Index, {}, {
    typeCast = "GuardsDir",
    rootName = "Guards.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
local u2 = (1 / 0);
local u3 = 0;
local v4 = {};

for _, v in pairs(u1) do
    u2 = math.min(u2, v.WalkSpeed);
    u3 = math.max(u3, v.WalkSpeed);
end;

v4.Directory = u1;
v4.Types = Interface;

if Constants.IS_STUDIO then
    for _, child in pairs(script._Index:GetChildren()) do
        local v5 = child:IsA("ModuleScript");
        local v6 = `Bad instance found inside the guard configs env: {child.Name}`;
        assert(v5, v6);
        local v7, v8 = Interface.DefaultConfig(u1[child.Name]);
        local v9 = `Failed to validate guard config {child.Name}: {v8}`;
        assert(v7, v9);
    end;
end;

MakeTableStrict(u1, "Guards");

function v4.Types.GuardNameExists(u10) -- Line: 54
    -- upvalues: u1 (copy)
    if pcall(function() -- Line: 55
        -- upvalues: u1 (ref), u10 (copy)
        return u1[u10];
    end) then
        return true;
    end;

    return false, `Guard name "{u10}" does not exist in the Guards directory.`;
end;

function v4.GetLowestWalkSpeed() -- Line: 66
    -- upvalues: u2 (ref)
    return u2 == (1 / 0) and 0 or u2;
end;

function v4.GetHighestWalkSpeed() -- Line: 74
    -- upvalues: u3 (ref), u2 (ref)
    local v11 = math.max(u2, 1);

    return math.max(u3, v11);
end;

return v4;