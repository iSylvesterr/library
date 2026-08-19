-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {};
local u2 = {};

local function styleFromPart(p3) -- Line: 26
    return {
        Color = p3.Color,
        Material = p3.Material,
        Reflectance = p3.Reflectance
    };
end;

local function firstBasePart(p4) -- Line: 34
    if not p4 then
        return nil;
    end;

    if p4:IsA("BasePart") then
        return p4;
    end;

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") then
            return descendant;
        end;
    end;

    return nil;
end;

local function resolveStyle(p5) -- Line: 45
    -- upvalues: u2 (copy), ReplicatedStorage (copy), firstBasePart (copy)
    local v6 = u2[p5];

    if v6 ~= nil then
        return v6 or nil;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("MutationAssets");
    end;

    if Assets then
        Assets = Assets:FindFirstChild(p5 .. "TreeColor");
    end;

    if not Assets then
        u2[p5] = false;

        return nil;
    end;

    local v7 = firstBasePart(Assets:FindFirstChild("Leaves"));
    local v8 = firstBasePart(Assets:FindFirstChild("Wood"));
    local v9 = {
        leaf = v7 and {
            Color = v7.Color,
            Material = v7.Material,
            Reflectance = v7.Reflectance
        } or nil,
        wood = v8 and {
            Color = v8.Color,
            Material = v8.Material,
            Reflectance = v8.Reflectance
        } or nil
    };

    if p5 == "Golden" and v9.wood then
        v9.leaf = v9.wood;
    end;

    u2[p5] = v9;

    return v9;
end;

local function applyStyle(p10, u11) -- Line: 76
    if not (p10 and u11) then
        return;
    end;

    local function paint(p12) -- Line: 78
        -- upvalues: u11 (copy)
        p12.Color = u11.Color;
        p12.Material = u11.Material;
        p12.Reflectance = u11.Reflectance;
    end;

    if p10:IsA("BasePart") then
        p10.Color = u11.Color;
        p10.Material = u11.Material;
        p10.Reflectance = u11.Reflectance;
    end;

    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Color = u11.Color;
            descendant.Material = u11.Material;
            descendant.Reflectance = u11.Reflectance;
        end;
    end;
end;

function v1.applyGoldenFruit(p13, p14) -- Line: 92
    -- upvalues: resolveStyle (copy), applyStyle (copy)
    if not (p13 and p14) then
        return;
    end;

    local v15 = false;

    for _, v in p14 do
        if v == "Golden" then
            v15 = true;
            break;
        end;
    end;

    if not v15 then
        return;
    end;

    local v16 = resolveStyle("Golden");
    applyStyle(p13, v16 and v16.wood or nil);
end;

function v1.pickTreeKey(p17) -- Line: 105
    -- upvalues: resolveStyle (copy)
    if not p17 then
        return nil;
    end;

    for _, v in p17 do
        if resolveStyle(v) then
            return v;
        end;
    end;

    return nil;
end;

function v1.apply(p18, p19) -- Line: 114
    -- upvalues: resolveStyle (copy), applyStyle (copy)
    if not (p18 and p19) then
        return;
    end;

    local v20 = resolveStyle(p19);

    if not v20 then
        return;
    end;

    applyStyle(p18:FindFirstChild("Leaves"), v20.leaf);
    applyStyle(p18:FindFirstChild("Wood"), v20.wood);
    p18:SetAttribute("MutationKey", p19);
end;

return v1;