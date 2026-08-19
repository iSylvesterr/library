-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local SharedModules = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules");
local EffectLoadManager = require(SharedModules:WaitForChild("EffectLoadManager"));
local GrowEffects = require(SharedModules:WaitForChild("GrowEffects"));
local PerfFlags = require(SharedModules:WaitForChild("Flags"):WaitForChild("PerfFlags"));
local v1 = {};
local u2 = Color3.fromRGB(206, 92, 0);
local Neon = Enum.Material.Neon;
local u3 = Color3.fromRGB(255, 150, 40);
local VFX = script:FindFirstChild("VFX");
local u4 = {};

local function SizeMagnitude(p5) -- Line: 31
    if not p5:IsA("Model") then
        return not p5:IsA("BasePart") and 11 or p5.Size.Magnitude;
    end;

    local _, v6 = p5:GetBoundingBox();

    return v6.Magnitude;
end;

local function RecolorPart(p7, p8) -- Line: 41
    -- upvalues: Neon (copy), u2 (copy)
    if p7.Seen[p8] then
        return;
    end;

    if p8:HasTag("MutationVFX") then
        return;
    end;

    p7.Seen[p8] = true;
    table.insert(p7.Parts, {
        Part = p8,
        Material = p8.Material,
        Color = p8.Color
    });
    p8.Material = Neon;
    p8.Color = u2;
end;

local function AddVfxCarrier(u9, u10) -- Line: 60
    -- upvalues: VFX (copy), GrowEffects (copy)
    if not VFX then
        return false;
    end;

    if not (u9:IsA("Model") and u9.PrimaryPart) then
        return false;
    end;

    GrowEffects.AddDescendantsAtBaseline(u9, function() -- Line: 64
        -- upvalues: u9 (copy), VFX (ref), u10 (copy)
        local v11, v12 = u9:GetBoundingBox();
        local Part = Instance.new("Part");
        Part.Name = "AmberVFX";
        Part.Size = v12;
        Part.CFrame = v11;
        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Anchored = false;
        Part.Massless = true;
        Part:AddTag("MutationVFX");
        Part.Parent = u9;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = u9.PrimaryPart;
        WeldConstraint.Part1 = Part;
        WeldConstraint.Parent = Part;

        for _, child in VFX:GetChildren() do
            child:Clone().Parent = Part;
        end;

        table.insert(u10.Effects, Part);
    end);

    return true;
end;

local function AddEffects(u13, u14) -- Line: 97
    -- upvalues: PerfFlags (copy), u3 (copy), VFX (copy), GrowEffects (copy)
    if u14.Effects[1] then
        return;
    end;

    if PerfFlags.MutationVFXDisabled:Get() then
        return;
    end;

    local Target = u14.Target;

    if not (Target and Target.Parent) then
        return;
    end;

    local v15;

    if u13:IsA("Model") then
        local _, v16 = u13:GetBoundingBox();
        v15 = v16.Magnitude;
    else
        v15 = not u13:IsA("BasePart") and 11 or u13.Size.Magnitude;
    end;

    local v17 = math.clamp(v15 / 11, 0.5, 3);
    local PointLight = Instance.new("PointLight");
    PointLight.Name = "AmberLight";
    PointLight.Color = u3;
    PointLight.Brightness = v17 * 2;
    PointLight.Range = v17 * 8;
    PointLight.Shadows = false;
    PointLight.Parent = Target;
    table.insert(u14.Effects, PointLight);
    local v18;

    if VFX and (u13:IsA("Model") and u13.PrimaryPart) then
        GrowEffects.AddDescendantsAtBaseline(u13, function() -- Line: 64
            -- upvalues: u13 (copy), VFX (ref), u14 (copy)
            local v19, v20 = u13:GetBoundingBox();
            local Part = Instance.new("Part");
            Part.Name = "AmberVFX";
            Part.Size = v20;
            Part.CFrame = v19;
            Part.Transparency = 1;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.Anchored = false;
            Part.Massless = true;
            Part:AddTag("MutationVFX");
            Part.Parent = u13;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = u13.PrimaryPart;
            WeldConstraint.Part1 = Part;
            WeldConstraint.Parent = Part;

            for _, child in VFX:GetChildren() do
                child:Clone().Parent = Part;
            end;

            table.insert(u14.Effects, Part);
        end);
        v18 = true;
    else
        v18 = false;
    end;

    if v18 then
        return;
    end;

    if VFX then
        for _, child in VFX:GetChildren() do
            local v21 = child:Clone();
            local Model = Instance.new("Model");
            v21.Parent = Model;
            Model:ScaleTo(v17);
            v21.Parent = Target;
            Model:Destroy();
            table.insert(u14.Effects, v21);
        end;
    end;
end;

local function RemoveEffects(p22) -- Line: 132
    for _, v in p22.Effects do
        if v.Parent then
            v:Destroy();
        end;
    end;

    table.clear(p22.Effects);
end;

function v1.ApplyMutationEffect(u23) -- Line: 140
    -- upvalues: u4 (copy), CollectionService (copy), RecolorPart (copy), AddEffects (copy), EffectLoadManager (copy)
    if u4[u23] then
        return;
    end;

    local u24 = {
        Target = nil,
        Effects = {},
        Parts = {},
        Seen = {}
    };
    u4[u23] = u24;
    CollectionService:AddTag(u23, "Amber");

    if u23:IsA("BasePart") then
        RecolorPart(u24, u23);
    end;

    for _, descendant in u23:GetDescendants() do
        if descendant:IsA("BasePart") then
            RecolorPart(u24, descendant);
        end;
    end;

    if u23:IsA("Model") then
        u24.Target = u23.PrimaryPart or u24.Parts[1] and u24.Parts[1].Part;
    else
        u24.Target = u24.Parts[1] and u24.Parts[1].Part;
    end;

    u24.Connection = u23.DescendantAdded:Connect(function(p25) -- Line: 161
        -- upvalues: u4 (ref), u23 (copy), RecolorPart (ref), u24 (copy)
        if not u4[u23] then
            return;
        end;

        if p25:IsA("BasePart") then
            RecolorPart(u24, p25);
        end;
    end);
    AddEffects(u23, u24);
    EffectLoadManager.Register();
end;

function v1.RemoveMutationEffect(p26) -- Line: 172
    -- upvalues: u4 (copy), RemoveEffects (copy), EffectLoadManager (copy)
    local v27 = u4[p26];

    if not v27 then
        return;
    end;

    u4[p26] = nil;

    if v27.Connection then
        v27.Connection:Disconnect();
    end;

    RemoveEffects(v27);

    for _, v in v27.Parts do
        if v.Part.Parent then
            v.Part.Material = v.Material;
            v.Part.Color = v.Color;
        end;
    end;

    EffectLoadManager.Unregister();
end;

CollectionService:GetInstanceAddedSignal("Amber"):Connect(v1.ApplyMutationEffect);
CollectionService:GetInstanceRemovedSignal("Amber"):Connect(v1.RemoveMutationEffect);

for _, v in CollectionService:GetTagged("Amber") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

PerfFlags.MutationVFXDisabled.Changed:Connect(function(p28) -- Line: 197
    -- upvalues: u4 (copy), RemoveEffects (copy), AddEffects (copy)
    for i, v in u4 do
        if p28 then
            RemoveEffects(v);
        else
            AddEffects(i, v);
        end;
    end;
end);

return v1;