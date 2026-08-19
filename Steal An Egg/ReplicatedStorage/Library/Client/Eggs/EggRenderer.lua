-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetColorUtil = require(ReplicatedStorage.Library.Util.AssetColorUtil);
local Assets = require(ReplicatedStorage.Directory.Assets);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local EggScaleUtil = require(ReplicatedStorage.Library.Util.EggScaleUtil);
local Eggs = require(ReplicatedStorage.Library.Types.Eggs);
require(script.Parent.Types);
local Eggs2 = ReplicatedStorage.Assets.Models.Eggs;
local u1 = {};

local function exceedsPlacedCollisionBounds(p2) -- Line: 34
    return (p2.X > 20 or p2.Y > 20) and true or p2.Z > 20;
end;

function u1.GetTemplate(p3) -- Line: 44
    -- upvalues: Eggs (copy), Eggs2 (copy)
    local v4 = Eggs.SchemaValidation.SavedEgg(p3);
    assert(v4, "Invalid saved egg record");
    local v5 = Eggs2[p3.AssetCategory];
    local v6 = v5:IsA("Model");
    local v7 = `Egg model {p3.AssetCategory} must be a Model`;
    assert(v6, v7);

    return v5;
end;

function u1.DisableCollisions(p8) -- Line: 52
    -- upvalues: Asserts (copy)
    Asserts.Model(p8);

    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
        end;
    end;
end;

function u1.ApplyPlacedCollisionPolicy(p9) -- Line: 62
    -- upvalues: Asserts (copy), BBFromModelVisibleOnly (copy)
    Asserts.Model(p9);
    local _, v10 = BBFromModelVisibleOnly(p9);

    if p9.PrimaryPart then
        v10 = p9.PrimaryPart.Size or v10;
    end;

    local v11 = v10.X <= 20 and v10.Y <= 20 and v10.Z <= 20;

    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v12;

            if v11 then
                v12 = descendant.Transparency < 1;
            else
                v12 = v11;
            end;

            descendant.CanCollide = v12;
        end;
    end;
end;

function u1.RenderVisual(p13, p14, p15) -- Line: 75
    -- upvalues: Asserts (copy), Eggs (copy), Assets (copy), u1 (copy), EggScaleUtil (copy), AssetColorUtil (copy), BBFromModelVisibleOnly (copy)
    Asserts.Instance(p14);
    Asserts.number(p13.OwnerUserId);
    Asserts.string(p13.UID);
    Asserts.string(p13.ModelName);
    local v16 = Eggs.SchemaValidation.SavedEgg(p13.Record);
    assert(v16, "Invalid saved egg record");
    local v17 = Assets.Directory[p13.Record.AssetCategory];
    local v18 = `Missing asset config for category {p13.Record.AssetCategory}`;
    assert(v17 ~= nil, v18);
    local Egg = v17.Egg;
    local v19 = u1.GetTemplate(p13.Record):Clone();
    v19.Name = p13.ModelName;
    local v20 = v19:GetScale();
    local AssetCategory = p13.Record.AssetCategory;
    local v21;

    if p13.ScaleMultiplier then
        v21 = EggScaleUtil.ClampRenderedScale(v20, p13.ScaleMultiplier, AssetCategory);
    else
        v21 = EggScaleUtil.GetPreGrowthVisualScale(v20, p13.Record.AssetScale, AssetCategory);
    end;

    local v22 = math.clamp(p13.ScaleAlpha or 1, 0.5, 1);
    v19:ScaleTo(EggScaleUtil.ClampRenderedScale(v20, v21 * v22, AssetCategory));
    AssetColorUtil.Apply(v19, p13.Record.AssetCategory, p13.Record.AssetEyeColor, p13.Record.AssetColorSeed, p13.Record.AssetColorIndex);
    local PrimaryPart = v19.PrimaryPart;
    Asserts.BasePart(PrimaryPart);
    local v23, v24 = BBFromModelVisibleOnly(v19);
    PrimaryPart.PivotOffset = CFrame.new(0, v23.Position.Y - v24.Y * 0.5 - PrimaryPart.CFrame.Position.Y, 0);

    for _, descendant in v19:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = descendant.Transparency ~= 1;
            descendant.CanTouch = false;
            descendant.Massless = true;
            local v25 = not p14:IsA("Tool") and descendant == PrimaryPart;
            descendant.Anchored = v25;
        end;
    end;

    if p15 then
        u1.ApplyPlacedCollisionPolicy(v19);
    end;

    v19.Parent = p14;

    return {
        Model = v19,
        VisibleParts = { PrimaryPart },
        Config = Egg
    };
end;

function u1.GetAuthoredScale(p26) -- Line: 143
    -- upvalues: Eggs (copy), u1 (copy)
    local v27 = Eggs.SchemaValidation.SavedEgg(p26);
    assert(v27, "Invalid saved egg record");
    local v28 = u1.GetTemplate(p26):GetScale();
    local v29 = `Egg model {p26.AssetCategory} scale must be greater than 0`;
    assert(v28 > 0, v29);

    return v28;
end;

function u1.GetVisibleBounds(p30) -- Line: 153
    -- upvalues: Eggs (copy), Assets (copy), u1 (copy), BBFromModelVisibleOnly (copy)
    local v31 = Eggs.SchemaValidation.SavedEgg(p30);
    assert(v31, "Invalid saved egg record");
    local v32 = Assets.Directory[p30.AssetCategory] ~= nil;
    local v33 = `Missing asset config for category {p30.AssetCategory}`;
    assert(v32, v33);
    local v34 = u1.GetTemplate(p30);
    local v35 = u1.GetAuthoredScale(p30);
    local _, v36 = BBFromModelVisibleOnly(v34);

    return v36 / v35;
end;

return u1;