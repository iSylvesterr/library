-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DeepEqualsUnsafe = require(ReplicatedStorage.Library.Functions.DeepEqualsUnsafe);
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization);
require(script.Parent.InventoryProjectionTypes);
local u1 = {};

local function makeDeterministicUID(p2) -- Line: 17
    local v3 = `inventory_projection_skin/{p2}`;
    local v4 = 2166136261;
    local v5 = 2654435769;
    local v6 = 3266489909;
    local v7 = 668265263;

    for i = 1, #v3 do
        local v8 = string.byte(v3, i);
        local v9 = bit32.bxor(v4, v8) * 16777619;
        v4 = bit32.band(v9, 4294967295);
        v5 = bit32.band((v5 + v8) * 2246822519, 4294967295);
        local v10 = bit32.lshift(v8, i % 8);
        local v11 = bit32.bxor(v6, v10) * 3266489917;
        v6 = bit32.band(v11, 4294967295);
        local v12 = (v7 + bit32.bxor(v8, i)) * 668265263;
        v7 = bit32.band(v12, 4294967295);
    end;

    local v13 = string.format("%08x%08x%08x%08x", v4, v5, v6, v7);

    return `{v13:sub(1, 12)}4{v13:sub(14, 16)}8{v13:sub(18, 32)}`;
end;

local function getOwnedSkinCount(p14, p15) -- Line: 37
    local v16 = p14 and p14[p15] or nil;

    if type(v16) ~= "number" then
        return 0;
    end;

    local v17 = math.floor(v16);

    return v17 <= 0 and 0 or v17;
end;

local function normalizeSkinInventory(p18) -- Line: 51
    local v19 = {};

    if not p18 then
        return v19;
    end;

    for i in pairs(p18) do
        local v20;

        if p18 then
            v20 = p18[i] or nil;
        else
            v20 = nil;
        end;

        local v21;

        if type(v20) == "number" then
            local v22 = math.floor(v20);
            v21 = v22 <= 0 and 0 or v22;
        else
            v21 = 0;
        end;

        if v21 > 0 then
            v19[i] = v21;
        end;
    end;

    return v19;
end;

local function projectBrainrots(p23) -- Line: 70
    -- upvalues: AssetItemSerialization (copy)
    local v24 = {};

    if not p23 then
        return v24;
    end;

    for i, v in pairs(p23) do
        local v25 = AssetItemSerialization.Deserialize(v);

        if v25.InFuse ~= true then
            v24[i] = {
                id = v25.Category,
                Mutations = v25.Mutations,
                BaseMutation = v25.BaseMutation,
                Scale = v25.Scale
            };
        end;
    end;

    return v24;
end;

local function buildBrainrotPatch(p26) -- Line: 92
    -- upvalues: AssetItemSerialization (copy)
    local v27 = {};
    local v28 = {};
    local v29 = {};

    if not p26 then
        return v27, v28, v29;
    end;

    for i, v in pairs(p26) do
        local v30 = AssetItemSerialization.Deserialize(v);

        if v30.InFuse == true then
            v28[#v28 + 1] = i;
            v29[i] = true;
        else
            v27[i] = {
                id = v30.Category,
                Mutations = v30.Mutations,
                BaseMutation = v30.BaseMutation,
                Scale = v30.Scale
            };
        end;
    end;

    return v27, v28, v29;
end;

local function projectSkins(p31) -- Line: 121
    -- upvalues: normalizeSkinInventory (copy), makeDeterministicUID (copy)
    local v32 = {};

    for i, v in pairs((normalizeSkinInventory(p31))) do
        v32[makeDeterministicUID(i)] = {
            id = i,
            _am = v
        };
    end;

    return v32;
end;

local function buildSetPacket(p33) -- Line: 135
    local v34 = {};

    for i, v in pairs(p33) do
        if next(v) ~= nil then
            v34[i] = v;
        end;
    end;

    return next(v34) ~= nil and {
        set = v34
    } or nil;
end;

function u1.MakeSkinUID(p35) -- Line: 157
    -- upvalues: makeDeterministicUID (copy)
    local v36 = type(p35) == "string";
    assert(v36, "Expected skinId to be a string");

    return makeDeterministicUID(p35);
end;

function u1.GetOwnedSkinCount(p37, p38) -- Line: 162
    local v39 = type(p38) == "string";
    assert(v39, "Expected skinId to be a string");
    local v40 = p37 and p37[p38] or nil;

    if type(v40) ~= "number" then
        return 0;
    end;

    local v41 = math.floor(v40);

    return v41 <= 0 and 0 or v41;
end;

function u1.NormalizeSkinInventory(p42) -- Line: 167
    -- upvalues: normalizeSkinInventory (copy)
    return normalizeSkinInventory(p42);
end;

function u1.BuildSnapshot(p43) -- Line: 173
    -- upvalues: projectBrainrots (copy), projectSkins (copy)
    local v44 = type(p43) == "table";
    assert(v44, "Expected saveData to be a table");

    return {
        Brainrot = projectBrainrots(p43.Inventory),
        Skin = projectSkins(p43.SkinInventory)
    };
end;

function u1.BuildInitialPacket(p45) -- Line: 184
    -- upvalues: buildSetPacket (copy), u1 (copy)
    return buildSetPacket(u1.BuildSnapshot(p45));
end;

function u1.BuildInventoryPatchPacket(p46, p47) -- Line: 188
    -- upvalues: buildBrainrotPatch (copy)
    local v48 = {};
    local v49, v50, v51 = buildBrainrotPatch(p46);

    if next(v49) ~= nil then
        v48.Brainrot = v49;
    end;

    if p47 then
        for i in pairs(p47) do
            if not v51[i] then
                v50[#v50 + 1] = i;
            end;
        end;
    end;

    return (next(v48) ~= nil or #v50 ~= 0) and {
        set = next(v48) and v48 and v48 or nil,
        del = #v50 > 0 and v50 and v50 or nil
    } or nil;
end;

function u1.BuildDeltaPacket(p52, p53) -- Line: 217
    -- upvalues: u1 (copy), DeepEqualsUnsafe (copy)
    local v54 = type(p52) == "table";
    assert(v54, "Expected previousData to be a table");
    local v55 = type(p53) == "table";
    assert(v55, "Expected nextData to be a table");
    local v56 = u1.BuildSnapshot(p52);
    local v57 = u1.BuildSnapshot(p53);
    local v58 = {};
    local v59 = {};

    for i, v in pairs(v57) do
        local v60 = v56[i];

        for i2, v2 in pairs(v) do
            local v61 = v60[i2];

            if v61 == nil or not DeepEqualsUnsafe(v61, v2) then
                local v62 = v58[i];

                if not v62 then
                    v62 = {};
                    v58[i] = v62;
                end;

                v62[i2] = v2;
            end;
        end;

        for i2 in pairs(v60) do
            if v[i2] == nil then
                v59[#v59 + 1] = i2;
            end;
        end;
    end;

    return (next(v58) ~= nil or #v59 ~= 0) and {
        set = next(v58) and v58 and v58 or nil,
        del = #v59 > 0 and v59 and v59 or nil
    } or nil;
end;

return u1;