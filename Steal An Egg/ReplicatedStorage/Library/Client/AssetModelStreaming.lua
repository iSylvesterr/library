-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetModels = require(ReplicatedStorage.Library.Modules.AssetModels);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local u1 = {};
local u2 = {
    AssetModelReplicated = Signal.new(),
    AllAssetModelsReplicated = Signal.new()
};

function u2._markAssetModelReplicated(p3, p4) -- Line: 24
    -- upvalues: u1 (copy), u2 (copy)
    if u1[p3] then
        return;
    end;

    u1[p3] = true;
    u2.AssetModelReplicated:Fire(p3, p4);
end;

function u2._initReplicatedAssetModelState() -- Line: 33
    -- upvalues: AssetModels (copy), u2 (copy)
    for _, child in ipairs(AssetModels.GetAssetModelsFolder():GetChildren()) do
        if child:IsA("Model") then
            AssetModels.HydrateAssetConfigModelScale(child.Name);
            u2._markAssetModelReplicated(child.Name, child);
        end;
    end;
end;

function u2.IsAssetModelReplicated(p5) -- Line: 46
    -- upvalues: Asserts (copy), AssetModels (copy)
    Asserts.string(p5);

    return AssetModels.GetAssetModelIfReplicated(p5) ~= nil;
end;

function u2.ForceLoadAssetModels(p6) -- Line: 51
    -- upvalues: Asserts (copy)
    Asserts.array.string(p6);

    return true;
end;

function u2.AreAllAssetModelsReplicated() -- Line: 56
    return true;
end;

return u2;