-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = require(ReplicatedStorage.Directory.Assets);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local AbstractItem = require(script.Parent.AbstractItem);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Types.AssetItem);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Signal = require(ReplicatedStorage.Library.Signal);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local u2 = {
    Directory = Assets.Directory
};
local v3 = setmetatable({}, {
    __index = AbstractItem.Prototype
});
local v4, u5 = AbstractItem.Define("Brainrot", script, u2);
v3.Class = v4;
u2.Class = v4;
u2.Prototype = v3;

local function ensureDataDefaults(p6) -- Line: 40
    local v7 = p6:GetData();

    if v7.Mutations == nil then
        v7.Mutations = {};
    end;

    if v7.Scale == nil then
        v7.Scale = 1;
    end;

    return v7;
end;

local function getAssetItemData(p8) -- Line: 51
    -- upvalues: Personalities (copy)
    local v9 = p8:GetData();

    if v9.Mutations == nil then
        v9.Mutations = {};
    end;

    if v9.Scale == nil then
        v9.Scale = 1;
    end;

    return {
        HasBeenFirstPlaced = true,
        Category = p8:GetId(),
        Mutations = table.clone(v9.Mutations),
        BaseMutation = v9.BaseMutation,
        Scale = v9.Scale,
        Personality = Personalities.Personalities.Normal
    };
end;

function v3.AbstractPopulate(p10) -- Line: 84
end;

function v3.GetId(p11) -- Line: 86
    return p11._data.id;
end;

function v3.SetId(p12, p13) -- Line: 90
    -- upvalues: Assets (copy)
    local v14 = Assets.Directory[p13];
    local v15 = `brainrot not found in directory for ID: {p13}`;
    assert(v14, v15);
    p12._data.id = p13;

    return p12;
end;

function v3.SetDirectory(p16, p17) -- Line: 96
    -- upvalues: Assets (copy)
    local v18 = Assets.Directory[p17._id] == p17;
    local v19 = `brainrot not found in directory for ID: {p17._id}`;
    assert(v18, v19);

    return p16:SetId(p17._id);
end;

function v3.Directory(p20) -- Line: 101
    -- upvalues: Assets (copy)
    return Assets.Directory[p20._data.id];
end;

function v3.GetName(p21) -- Line: 105
    return p21:Directory().DisplayName or "";
end;

function v3.ComputeRarityImpact(p22) -- Line: 109
    local v23 = p22:GetRarity().RarityNumber / 2;
    local v24 = math.floor(v23);

    return math.clamp(v24, 1, 3);
end;

function v3.GetRarity(p25) -- Line: 113
    -- upvalues: Rarity (copy)
    return p25:Directory().Rarity or Rarity.Rarities.Basic;
end;

function v3.GetIcon(p26) -- Line: 117
    local v27 = p26:Directory();
    local v28 = p26:GetMutations()[1];

    if v28 then
        local MutationIcons = v27.MutationIcons;
        local v29 = MutationIcons and MutationIcons[v28];

        if v29 then
            return v29;
        end;
    end;

    return v27.Icon or "";
end;

function v3.AbstractIsTradable(p30) -- Line: 135
    return p30:Directory().IsTradable ~= false;
end;

function v3.AbstractCompareTo(p31, p32) -- Line: 139
    -- upvalues: AssetGenerationUtil (copy), getAssetItemData (copy)
    if p31:GetRarity() ~= p32:GetRarity() then
        return 0;
    end;

    local v33 = AssetGenerationUtil.GetRateWithoutRebirth((getAssetItemData(p31)));
    local v34 = AssetGenerationUtil.GetRateWithoutRebirth((getAssetItemData(p32)));

    return v33 == v34 and 0 or (v33 < v34 and 1 or -1);
end;

function v3.GetMutations(p35) -- Line: 153
    local v36 = p35:GetData();

    if v36.Mutations == nil then
        v36.Mutations = {};
    end;

    if v36.Scale == nil then
        v36.Scale = 1;
    end;

    return v36.Mutations;
end;

function v3.HasMutation(p37, p38) -- Line: 158
    -- upvalues: Asserts (copy), Mutations (copy), Constants (copy), u1 (copy)
    Asserts.string(p38);

    if Mutations.Exists(p38) then
        return table.find(p37:GetMutations(), p38) ~= nil;
    end;

    local v39 = `Mutation {p38} does not exist in the mutation directory!`;

    if Constants.IS_STUDIO then
        error(v39);
    else
        u1:AtError():Log(v39);
    end;

    return false;
end;

function v3.SetMutations(p40, p41) -- Line: 175
    -- upvalues: Asserts (copy)
    Asserts.table(p41);

    for _, v in ipairs(p41) do
        Asserts.string(v);
    end;

    local v42 = p40:GetData();

    if v42.Mutations == nil then
        v42.Mutations = {};
    end;

    if v42.Scale == nil then
        v42.Scale = 1;
    end;

    v42.Mutations = table.clone(p41);

    return p40;
end;

function v3.SetBaseMutation(p43, p44) -- Line: 186
    -- upvalues: Asserts (copy)
    if p44 ~= nil then
        Asserts.string(p44);
    end;

    local v45 = p43:GetData();

    if v45.Mutations == nil then
        v45.Mutations = {};
    end;

    if v45.Scale == nil then
        v45.Scale = 1;
    end;

    v45.BaseMutation = p44;

    return p43;
end;

function v3.SetScale(p46, p47) -- Line: 196
    -- upvalues: Asserts (copy)
    Asserts.number(p47);
    local v48 = p46:GetData();

    if v48.Mutations == nil then
        v48.Mutations = {};
    end;

    if v48.Scale == nil then
        v48.Scale = 1;
    end;

    v48.Scale = p47;

    return p46;
end;

function v3.ToRewardFormat(p49, p50) -- Line: 204
    -- upvalues: Signal (copy)
    local u51 = p49:GetId();
    local v52 = p49:GetData();

    if v52.Mutations == nil then
        v52.Mutations = {};
    end;

    if v52.Scale == nil then
        v52.Scale = 1;
    end;

    local u53 = table.clone(v52.Mutations);
    local u54 = v52.BaseMutation or u53[1];
    local u55 = v52.Scale or 1;

    return function(p56) -- Line: 211
        -- upvalues: Signal (ref), u51 (copy), u53 (copy), u54 (copy), u55 (copy)
        Signal.Invoke(Signal.MAP.Server.BrainrotItem.SPAWN_FOR_REWARD, p56, u51, u53, u54, u55);
    end;
end;

return setmetatable(u2, {
    __index = u5,

    __call = function(p57, p58) -- Line: 64, Name: newBrainrot
        -- upvalues: Assets (copy), u5 (copy), u2 (copy)
        if type(p58) == "string" then
            local v59 = Assets.Directory[p58];
            local v60 = `brainrot not found in directory for identifier: {p58}`;
            assert(v59, v60);
        else
            local v61 = Assets.Directory[p58._id] == p58;
            local v62 = `brainrot not found in directory for ID: {p58._id}`;
            assert(v61, v62);
            p58 = p58._id;
        end;

        local v63 = u5.From(u2, {
            id = p58
        });
        local v64 = v63:GetData();

        if v64.Mutations == nil then
            v64.Mutations = {};
        end;

        if v64.Scale == nil then
            v64.Scale = 1;
        end;

        return v63;
    end
});