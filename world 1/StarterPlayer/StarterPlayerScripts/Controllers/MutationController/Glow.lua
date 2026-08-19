-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EffectLoadManager = require(ReplicatedStorage.SharedModules.EffectLoadManager);
local v1 = {};
local VFX = script.VFX;
local u2 = Color3.fromRGB(255, 214, 102);
local Neon = Enum.Material.Neon;
local u3 = {};

local function SizeMagnitude(p4) -- Line: 18
    if not p4:IsA("Model") then
        return not p4:IsA("BasePart") and 11 or p4.Size.Magnitude;
    end;

    local _, v5 = p4:GetBoundingBox();

    return v5.Magnitude;
end;

function v1.ApplyMutationEffect(p6) -- Line: 29
    -- upvalues: u3 (copy), CollectionService (copy), Neon (copy), u2 (copy), VFX (copy), EffectLoadManager (copy)
    if u3[p6] then
        return;
    end;

    local v7 = {
        Vfx = {},
        Parts = {}
    };
    u3[p6] = v7;
    CollectionService:AddTag(p6, "Glow");
    local v8 = {};

    if p6:IsA("BasePart") then
        table.insert(v8, p6);
    end;

    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v8, descendant);
        end;
    end;

    local v9;

    if p6:IsA("Model") then
        v9 = p6.PrimaryPart or v8[1];
    else
        v9 = v8[1];
    end;

    for _, v in v8 do
        table.insert(v7.Parts, {
            Part = v,
            Material = v.Material,
            Color = v.Color
        });
        v.Material = Neon;
        v.Color = u2;
    end;

    local v10;

    if p6:IsA("Model") then
        local _, v11 = p6:GetBoundingBox();
        v10 = v11.Magnitude;
    else
        v10 = not p6:IsA("BasePart") and 11 or p6.Size.Magnitude;
    end;

    local v12 = math.clamp(v10 / 11, 0.5, 3);

    if v9 then
        for _, child in VFX:GetChildren() do
            local v13 = child:Clone();
            local Model = Instance.new("Model");
            v13.Parent = Model;
            Model:ScaleTo(v12);
            v13.Parent = v9;
            Model:Destroy();
            table.insert(v7.Vfx, v13);
        end;
    end;

    EffectLoadManager.Register();
end;

function v1.RemoveMutationEffect(p14) -- Line: 75
    -- upvalues: u3 (copy), EffectLoadManager (copy)
    local v15 = u3[p14];

    if not v15 then
        return;
    end;

    u3[p14] = nil;

    for _, v in v15.Vfx do
        if v.Parent then
            v:Destroy();
        end;
    end;

    for _, v in v15.Parts do
        if v.Part.Parent then
            v.Part.Material = v.Material;
            v.Part.Color = v.Color;
        end;
    end;

    EffectLoadManager.Unregister();
end;

CollectionService:GetInstanceAddedSignal("Glow"):Connect(v1.ApplyMutationEffect);
CollectionService:GetInstanceRemovedSignal("Glow"):Connect(v1.RemoveMutationEffect);

for _, v in CollectionService:GetTagged("Glow") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

return v1;