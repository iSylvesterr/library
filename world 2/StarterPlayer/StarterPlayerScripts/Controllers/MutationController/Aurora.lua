-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
game:GetService("MaterialService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EffectLoadManager = require(ReplicatedStorage.SharedModules.EffectLoadManager);
local VFX = script.VFX;
local u2 = {};
local u3 = 0;

function v1.ApplyMutationEffect(p4) -- Line: 35
    -- upvalues: u2 (copy), CollectionService (copy), VFX (copy), EffectLoadManager (copy), u3 (ref)
    if u2[p4] then
        return;
    end;

    local v5 = {
        vfx = {},
        parts = {}
    };
    u2[p4] = v5;
    CollectionService:AddTag(p4, "Aurora");

    if p4:IsA("BasePart") then
        table.insert(v5.parts, p4);
    end;

    for _, v in p4:QueryDescendants("BasePart") do
        table.insert(v5.parts, v);
    end;

    local v6;

    if p4:IsA("Model") then
        v6 = p4.PrimaryPart or v5.parts[1];

        if v6 then
            local v7, v8 = p4:GetBoundingBox();
            v6.Size = v8;
            v6.CFrame = v7;
        end;

        for _, v in p4:QueryDescendants("BasePart") do
            v.Material = Enum.Material.Glacier;
            v.MaterialVariant = "2022 Stud Space";
            v.Color = Color3.new(0.501961, 0.0627451, 1);
        end;
    else
        v6 = v5.parts[1];
    end;

    if v6 then
        for _, child in VFX:GetChildren() do
            local v9 = child:Clone();
            v9.Parent = v6;
            table.insert(v5.vfx, v9);
        end;
    end;

    EffectLoadManager.Register();
    u3 = u3 + 1;
end;

function v1.RemoveMutationEffect(p10) -- Line: 86
    -- upvalues: u2 (copy), EffectLoadManager (copy), u3 (ref)
    local v11 = u2[p10];

    if not v11 then
        return;
    end;

    u2[p10] = nil;

    for _, v in v11.vfx do
        if v.Parent then
            v:Destroy();
        end;
    end;

    for _, v in v11.parts do
        if v.Parent then
            v.MaterialVariant = "";
        end;
    end;

    EffectLoadManager.Unregister();
    u3 = math.max(0, u3 - 1);
end;

CollectionService:GetInstanceAddedSignal("Aurora"):Connect(v1.ApplyMutationEffect);
CollectionService:GetInstanceRemovedSignal("Aurora"):Connect(v1.RemoveMutationEffect);

for _, v in CollectionService:GetTagged("Aurora") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

return v1;