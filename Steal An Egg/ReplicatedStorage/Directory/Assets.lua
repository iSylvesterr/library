-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ModuleLoader = require(ReplicatedStorage.ModuleLoader);
local AdminAbuseEgg = require(ReplicatedStorage.Directory.AdminAbuseEgg);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Interface = require(script.Types.Interface);
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local v1 = {};
local u2 = ModuleLoader(script._Index, {}, {
    typeCast = "AssetsDir",
    rootName = "Assets.Dir",
    noPrint = true,
    shouldInject = true,
    forceSafeLoad = Constants.IS_CLIENT
});
v1.Directory = u2;
v1.Types = Interface;

function v1.Types.AssetNameExists(u3) -- Line: 35
    -- upvalues: u2 (copy)
    if pcall(function() -- Line: 36
        -- upvalues: u2 (ref), u3 (copy)
        return u2[u3];
    end) then
        return true;
    end;

    return false, `Asset name "{u3}" does not exist in the Assets directory.`;
end;

for _, v in pairs(u2) do
    local PlaceSound = v.PlaceSound;

    if PlaceSound then
        local Data = PlaceSound.Data;

        if Data then
            Data.Volume = 0.8;
        end;
    end;
end;

local v4 = {};

for i, v in pairs(u2) do
    local v5 = v.Rarity and v.Rarity._id;

    if v5 then
        if not v4[v5] then
            v4[v5] = {};
        end;

        v4[v5][i] = v;
    end;
end;

v1.ByRarity = v4;

for _, child in pairs(script._Index:GetChildren()) do
    if Constants.IS_STUDIO then
        local v6 = child:IsA("ModuleScript");
        local v7 = `Bad instance found inside the configs env: {child.Name}`;
        assert(v6, v7);
    end;

    local v8 = u2[child.Name];

    if not v8 then
        error((`Config module for {child.Name} not found in Directory`));
    end;

    if Constants.IS_STUDIO then
        local v9, v10 = Interface.DefaultConfig(v8);
        local v11 = `Failed to validate config {child.Name}: {v10}`;
        assert(v9, v11);
        local v12 = ReplicatedStorage.AssetModels:FindFirstChild(child.Name);
        local v13 = `Asset {child.Name} must have a corresponding model in ReplicatedStorage.AssetModels`;
        assert(v12, v13);
        local PrimaryPart = v12.PrimaryPart;
        local v14 = `Asset {child.Name} model must have a PrimaryPart set`;
        assert(PrimaryPart, v14);
        local AssetWeld = v12.PrimaryPart:FindFirstChild("AssetWeld");
        local v15 = `Asset {child.Name} model must have an AssetWeld in its PrimaryPart`;
        assert(AssetWeld, v15);
        local v16 = v12:GetScale() == 1;
        local v17 = `Asset {child.Name} model must have a scale of 1`;
        assert(v16, v17);
        local v18 = ReplicatedStorage.Assets.Models.Eggs:FindFirstChild(child.Name);
        local v19 = `Asset {child.Name} must have a corresponding egg model in ReplicatedStorage.Assets.Models.Eggs`;
        assert(v18, v19);
        local PrimaryPart2 = v18.PrimaryPart;
        local v20 = `Asset {child.Name} egg model must have a PrimaryPart set`;
        assert(PrimaryPart2, v20);

        if AdminAbuseEgg.IsEventCategory(child.Name) then
            local v21 = v18:GetScale() > 0;
            local v22 = `Asset {child.Name} egg model must have a scale greater than 0`;
            assert(v21, v22);
        else
            local v23 = v18:GetScale() == 1;
            local v24 = `Asset {child.Name} egg model must have a scale of 1`;
            assert(v23, v24);
        end;

        local CENTER = v12:FindFirstChild("CENTER");
        local v25;

        if CENTER then
            v25 = CENTER:IsA("BasePart");
        else
            v25 = CENTER;
        end;

        local v26 = `Asset {child.Name} model must have a CENTER part`;
        assert(v25, v26);
        local CenterWeld = CENTER:FindFirstChild("CenterWeld");

        if CenterWeld then
            CenterWeld = CenterWeld:IsA("WeldConstraint");
        end;

        local v27 = `Asset {child.Name} model must have a CenterWeld in its CENTER part`;
        assert(CenterWeld, v27);
    end;
end;

for i, v in pairs(v4) do
    MakeTableStrict(v, (`Assets.ByRarity[{i}]`));
end;

MakeTableStrict(v4, "Assets.ByRarity");
MakeTableStrict(u2, "Assets");

return v1;