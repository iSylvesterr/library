-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};
local v2 = { 1000, 1000000, 75000000, 500000000, 1000000000, 50000000000, 500000000000, 1000000000000, 25000000000000, 100000000000000, 500000000000000, 1000000000000000 };

local function getBaseModelIfServer(p3) -- Line: 43
    -- upvalues: Asserts (copy), Constants (copy), ServerStorage (copy)
    Asserts.string(p3);

    if Constants.IS_SERVER then
        return ServerStorage.Assets.Models.Bases.Main[p3];
    end;

    return nil;
end;

local v4 = {};
local v5 = {
    MaxAssets = 7,
    Cost = 0
};
Asserts.string("1");
local v6;

if Constants.IS_SERVER then
    v6 = ServerStorage.Assets.Models.Bases.Main["1"];
else
    v6 = nil;
end;

v5.Model = v6;
v4[0] = v5;
local v7 = {
    MaxAssets = 7
};
Asserts.string("1");
local v8;

if Constants.IS_SERVER then
    v8 = ServerStorage.Assets.Models.Bases.Main["1"];
else
    v8 = nil;
end;

v7.Model = v8;
v7.Cost = v2[1];
v4[1] = v7;
local v9 = {
    MaxAssets = 9
};
Asserts.string("2");
local v10;

if Constants.IS_SERVER then
    v10 = ServerStorage.Assets.Models.Bases.Main["2"];
else
    v10 = nil;
end;

v9.Model = v10;
v9.Cost = v2[2];
v4[2] = v9;
local v11 = {
    MaxAssets = 10
};
Asserts.string("3");
local v12;

if Constants.IS_SERVER then
    v12 = ServerStorage.Assets.Models.Bases.Main["3"];
else
    v12 = nil;
end;

v11.Model = v12;
v11.Cost = v2[3];
v4[3] = v11;
local v13 = {
    MaxAssets = 11
};
Asserts.string("4");
local v14;

if Constants.IS_SERVER then
    v14 = ServerStorage.Assets.Models.Bases.Main["4"];
else
    v14 = nil;
end;

v13.Model = v14;
v13.Cost = v2[4];
v4[4] = v13;
local v15 = {
    MaxAssets = 12
};
Asserts.string("5");
local v16;

if Constants.IS_SERVER then
    v16 = ServerStorage.Assets.Models.Bases.Main["5"];
else
    v16 = nil;
end;

v15.Model = v16;
v15.Cost = v2[5];
v4[5] = v15;
local v17 = {
    MaxAssets = 13
};
Asserts.string("6");
local v18;

if Constants.IS_SERVER then
    v18 = ServerStorage.Assets.Models.Bases.Main["6"];
else
    v18 = nil;
end;

v17.Model = v18;
v17.Cost = v2[6];
v4[6] = v17;
local v19 = {
    MaxAssets = 14
};
Asserts.string("7");
local v20;

if Constants.IS_SERVER then
    v20 = ServerStorage.Assets.Models.Bases.Main["7"];
else
    v20 = nil;
end;

v19.Model = v20;
v19.Cost = v2[7];
v4[7] = v19;
local v21 = {
    MaxAssets = 15
};
Asserts.string("8");
local v22;

if Constants.IS_SERVER then
    v22 = ServerStorage.Assets.Models.Bases.Main["8"];
else
    v22 = nil;
end;

v21.Model = v22;
v21.Cost = v2[8];
v4[8] = v21;
local v23 = {
    MaxAssets = 16
};
Asserts.string("9");
local v24;

if Constants.IS_SERVER then
    v24 = ServerStorage.Assets.Models.Bases.Main["9"];
else
    v24 = nil;
end;

v23.Model = v24;
v23.Cost = v2[9];
v4[9] = v23;
local v25 = {
    MaxAssets = 17
};
Asserts.string("10");
local v26;

if Constants.IS_SERVER then
    v26 = ServerStorage.Assets.Models.Bases.Main["10"];
else
    v26 = nil;
end;

v25.Model = v26;
v25.Cost = v2[10];
v4[10] = v25;
local v27 = {
    MaxAssets = 18
};
Asserts.string("11");
local v28;

if Constants.IS_SERVER then
    v28 = ServerStorage.Assets.Models.Bases.Main["11"];
else
    v28 = nil;
end;

v27.Model = v28;
v27.Cost = v2[11];
v4[11] = v27;
u1.BASES = v4;
u1.SKINS = {};
u1.MIN_ASSET_EQUIP_CAPACITY = u1.BASES[0].MaxAssets;
u1.MAX_ASSET_EQUIP_CAPACITY = u1.BASES[#u1.BASES].MaxAssets;

function u1.GetMaxBaseLevel() -- Line: 122
    -- upvalues: u1 (copy)
    local v29 = 0;

    for i in pairs(u1.BASES) do
        if v29 < i then
            v29 = i;
        end;
    end;

    return v29;
end;

function u1.GetBaseConfigFor(p30, p31) -- Line: 134
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.number(p30);
    Asserts.optional.string(p31);
    local v32 = math.floor(p30);
    local v33 = math.max(0, v32);
    local v34 = nil;

    for i in pairs(u1.BASES) do
        if i <= v33 and (not v34 or v34 < i) then
            v34 = i;
        end;
    end;

    if v34 and p31 then
        return u1.BASES[v34], u1.SKINS[p31];
    end;

    if v34 then
        return u1.BASES[v34];
    end;

    return nil;
end;

function u1.GetAssetEquipCapacity(p35) -- Line: 158
    -- upvalues: u1 (copy)
    local v36 = u1.GetBaseConfigFor(p35 or 0);

    return v36 and v36.MaxAssets or u1.MIN_ASSET_EQUIP_CAPACITY;
end;

if Constants.IS_STUDIO then
    assert(#v2 >= #u1.BASES, "Not enough costs for the number of bases");

    for i, v in pairs(u1.BASES) do
        local v37;

        if v.Cost == v2[i] then
            v37 = true;
        elseif i == 0 then
            v37 = v.Cost == 0;
        else
            v37 = false;
        end;

        local v38 = `Cost for base index {i} does not match expected cost from COSTS table`;
        assert(v37, v38);

        if Constants.IS_SERVER then
            local Model = v.Model;
            local v39;

            if typeof(Model) == "Instance" then
                v39 = Model:IsA("Model");
            else
                v39 = false;
            end;

            local v40 = `Model for base index {i} is not a valid Model instance`;
            assert(v39, v40);
            local v41 = Model.PrimaryPart and Model.PrimaryPart.Name == "CenterPoint";
            local v42 = `Model for base index {i} must have a PrimaryPart named "CenterPoint"`;
            assert(v41, v42);
            local ToUpdate = Model:FindFirstChild("ToUpdate");
            local v43 = ToUpdate and (ToUpdate:IsA("Model") and ToUpdate.PrimaryPart);

            if v43 then
                if ToUpdate.PrimaryPart.Name == "CenterPoint" then
                    v43 = ToUpdate:FindFirstChild("PetArea");
                else
                    v43 = false;
                end;
            end;

            local v44 = `Model for base index {i} must have a child Model named "ToUpdate" with a PrimaryPart named "CenterPoint"`;
            assert(v43, v44);
        end;

        local v45;

        if typeof(v.MaxAssets) == "number" then
            v45 = v.MaxAssets == u1.GetAssetEquipCapacity(i);
        else
            v45 = false;
        end;

        local v46 = `MaxAssets for base index {i} must match asset equip capacity`;
        assert(v45, v46);
    end;
end;

if Constants.IS_STUDIO and Constants.IS_SERVER then
    for i, v in pairs(u1.SKINS) do
        local v47;

        if typeof(v.FirstFloor) == "Instance" then
            v47 = v.FirstFloor:IsA("Model");
        else
            v47 = false;
        end;

        local v48 = `Model for base skin index {i} is not a valid Model instance`;
        assert(v47, v48);
    end;
end;

return u1;