-- Decompiled with Potassium's decompiler.

local v1 = {};
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EffectLoadManager = require(ReplicatedStorage.SharedModules.EffectLoadManager);
local VFX = script.VFX;
local Neon = Enum.Material.Neon;
local u2 = Color3.fromRGB(45, 18, 94);
local u3 = {};

function v1.ApplyMutationEffect(p4) -- Line: 24
    -- upvalues: u3 (copy), CollectionService (copy), Neon (copy), u2 (copy), VFX (copy), EffectLoadManager (copy)
    if u3[p4] then
        return;
    end;

    local v5 = {
        vfx = {},
        originals = {}
    };
    u3[p4] = v5;
    CollectionService:AddTag(p4, "Eclipsed");
    local v6 = {};

    if p4:IsA("BasePart") then
        table.insert(v6, p4);
    end;

    for _, v in p4:QueryDescendants("BasePart") do
        table.insert(v6, v);
    end;

    for _, v in v6 do
        v5.originals[v] = {
            Material = v.Material,
            Color = v.Color
        };
        v.Material = Neon;
        v.Color = u2;
    end;

    local v7;

    if p4:IsA("Model") then
        v7 = p4.PrimaryPart or v6[1];

        if v7 then
            local v8, v9 = p4:GetBoundingBox();
            v7.Size = v9;
            v7.CFrame = v8;
        end;
    else
        v7 = v6[1];
    end;

    if v7 then
        for _, child in VFX:GetChildren() do
            local v10 = child:Clone();
            v10.Parent = v7;
            table.insert(v5.vfx, v10);
        end;
    end;

    EffectLoadManager.Register();
end;

function v1.RemoveMutationEffect(p11) -- Line: 69
    -- upvalues: u3 (copy), EffectLoadManager (copy)
    local v12 = u3[p11];

    if not v12 then
        return;
    end;

    u3[p11] = nil;

    for _, v in v12.vfx do
        if v.Parent then
            v:Destroy();
        end;
    end;

    for i, v in v12.originals do
        if i.Parent then
            i.Material = v.Material;
            i.Color = v.Color;
        end;
    end;

    EffectLoadManager.Unregister();
end;

CollectionService:GetInstanceAddedSignal("Eclipsed"):Connect(v1.ApplyMutationEffect);
CollectionService:GetInstanceRemovedSignal("Eclipsed"):Connect(v1.RemoveMutationEffect);

for _, v in CollectionService:GetTagged("Eclipsed") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

return v1;