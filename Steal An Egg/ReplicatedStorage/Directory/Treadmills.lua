-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local Interface = require(script.Types.Interface);
local u1 = ModuleLoader(script._Index, {}, {
    typeCast = "TreadmillsDir",
    rootName = "Treadmills.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
local u2 = {};
local u3 = {};
local v4 = {};

for _, v in pairs(u1) do
    table.insert(u2, v);
end;

table.sort(u2, function(p5, p6) -- Line: 33
    return p5.Price < p6.Price;
end);

for i, v in ipairs(u2) do
    u3[v._id] = i;
end;

table.freeze(u2);
table.freeze(u3);
v4.Directory = u1;
v4.Types = Interface;

if Constants.IS_STUDIO then
    for _, child in pairs(script._Index:GetChildren()) do
        local v7 = child:IsA("ModuleScript");
        local v8 = `Bad treadmill config instance: {child.Name}`;
        assert(v7, v8);
        local v9 = u1[child.Name];
        local v10, v11 = Interface.DefaultConfig(v9);
        local v12 = `Failed to validate treadmill config {child.Name}: {v11}`;
        assert(v10, v12);

        if Constants.IS_SERVER then
            local v13 = ReplicatedStorage.Assets.Models.Treadmills[v9._id];
            local v14 = `Treadmill model not found for config {child.Name}`;
            assert(v13 ~= nil, v14);
            local v15 = v13.BoundingBoxPart ~= nil;
            local v16 = `Treadmill model for config {child.Name} is missing a BoundingBoxPart`;
            assert(v15, v16);
        end;
    end;
end;

MakeTableStrict(u1, "Treadmills");

function v4.Types.TreadmillNameExists(u17) -- Line: 70
    -- upvalues: u1 (copy)
    if pcall(function() -- Line: 71
        -- upvalues: u1 (ref), u17 (copy)
        return u1[u17];
    end) then
        return true;
    end;

    return false, `Treadmill name "{u17}" does not exist in the Treadmills directory.`;
end;

function v4.GetOrdered() -- Line: 82
    -- upvalues: u2 (copy)
    return table.clone(u2);
end;

function v4.GetByUpgradeLevel(p18) -- Line: 86
    -- upvalues: u2 (copy)
    return u2[p18];
end;

function v4.GetUpgradeLevel(p19) -- Line: 90
    -- upvalues: u3 (copy)
    return u3[p19];
end;

return v4;