-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};

local function getNestPosition(p2) -- Line: 36
    local EggSpotBottom = p2.EggSpotBottom;
    local v3 = EggSpotBottom:IsA("BasePart");
    local v4 = `{p2:GetFullName()}.EggSpotBottom must be a BasePart`;
    assert(v3, v4);

    return EggSpotBottom.Position;
end;

local function quantize(p5) -- Line: 42
    return math.round(p5 * 1000);
end;

local function getSlotId(p6) -- Line: 46
    return string.format("Slot_%03d", p6);
end;

function u1.GetSortedNests(p7) -- Line: 54
    -- upvalues: Asserts (copy)
    Asserts.Model(p7);
    local Nests = p7.Nests;
    local v8 = Nests:IsA("Folder") or Nests:IsA("Model");
    local v9 = `{p7:GetFullName()}.Nests must be a Folder or Model`;
    assert(v8, v9);
    local v10 = {};

    for _, child in ipairs(Nests:GetChildren()) do
        if child:IsA("Model") then
            local EggSpotBottom = child.EggSpotBottom;
            local v11 = EggSpotBottom:IsA("BasePart");
            local v12 = `{child:GetFullName()}.EggSpotBottom must be a BasePart`;
            assert(v11, v12);
            local Position = EggSpotBottom.Position;
            local v13 = {
                Nest = child,
                X = math.round(Position.X * 1000),
                Y = math.round(Position.Y * 1000),
                Z = math.round(Position.Z * 1000),
                Name = child.Name
            };
            table.insert(v10, v13);
        end;
    end;

    table.sort(v10, function(p14, p15) -- Line: 74
        if p14.X ~= p15.X then
            return p14.X < p15.X;
        end;

        if p14.Z ~= p15.Z then
            return p14.Z < p15.Z;
        end;

        if p14.Y == p15.Y then
            return p14.Name < p15.Name;
        end;

        return p14.Y < p15.Y;
    end);
    local v16 = {};

    for _, v in ipairs(v10) do
        table.insert(v16, v.Nest);
    end;

    return v16;
end;

function u1.GetNestId(p17, p18) -- Line: 94
    -- upvalues: Asserts (copy), u1 (copy), getSlotId (copy)
    Asserts.Model(p17);
    Asserts.Model(p18);

    for i, v in ipairs(u1.GetSortedNests(p17)) do
        if v == p18 then
            return getSlotId(i);
        end;
    end;

    error((`Nest {p18:GetFullName()} is not inside {p17:GetFullName()}.Nests`));
end;

function u1.BuildSlotKey(p19, p20) -- Line: 107
    -- upvalues: Asserts (copy)
    Asserts.string(p19);
    Asserts.string(p20);

    return `{p19}:{p20}`;
end;

function u1.IsFirstAreaUid(p21) -- Line: 114
    -- upvalues: Asserts (copy)
    Asserts.string(p21);

    return string.find(p21, "FirstAreaEgg_", 1, true) == 1;
end;

function u1.GetFirstAreaOwnerUserId(p22) -- Line: 119
    -- upvalues: Asserts (copy)
    Asserts.string(p22);
    local v23 = string.match(p22, "^FirstAreaEgg_(-?%d+)_");

    if v23 == nil then
        return nil;
    end;

    return tonumber(v23);
end;

function u1.ResolveNest(p24, p25) -- Line: 128
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Model(p24);
    Asserts.string(p25);
    local v26 = string.match(p25, "^Slot_(%d+)$");
    local v27 = `Invalid area egg nest id {p25}`;
    assert(v26 ~= nil, v27);
    local v28 = tonumber(v26);
    local v29 = `Invalid area egg nest index {p25}`;
    assert(v28 ~= nil, v29);
    local v30 = u1.GetSortedNests(p24)[v28];
    local v31 = `Missing area egg nest {p24.Name}.{p25}`;
    assert(v30 ~= nil, v31);

    return v30;
end;

return table.freeze(u1);