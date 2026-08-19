-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage;
local ModelViewport = RuntimeLib.import(script, script.Parent, "ModelViewport").ModelViewport;
local SprayBottles = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "SprayBottles").SprayBottles;
local Detectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").Detectors;
local Shovels = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").Shovels;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u1 = CFrame.Angles(0, 0, 0.7853981633974483);
local u2 = CFrame.Angles(0, 0.2617993877991494, 1.413716694115407);
local u3 = {};
local v4 = {};
local u5 = nil;
local u6 = nil;

function v4.prepare() -- Line: 19
    -- upvalues: Shovels (copy), u5 (ref), u1 (copy), SprayBottles (copy), u6 (ref), Detectors (copy), u2 (copy)
    for _, v in pairs(Shovels) do
        u5("Shovels", v.assetName, u1);
    end;

    for _, v in pairs(SprayBottles) do
        u6(v);
    end;

    for _, v in pairs(Detectors) do
        u5("Detectors", v.assetName, u2);
    end;
end;

function v4.setGear(p7, p8, p9) -- Line: 31
    -- upvalues: u5 (ref), Shovels (copy), u1 (copy), u6 (ref), SprayBottles (copy), Detectors (copy), u2 (copy), ModelViewport (copy)
    local v10;

    if p8 == "shovel" then
        v10 = u5("Shovels", Shovels[p9].assetName, u1);
    elseif p8 == "spray" then
        v10 = u6(SprayBottles[p9]);
    else
        v10 = u5("Detectors", Detectors[p9].assetName, u2);
    end;

    ModelViewport.setModel(p7, v10:Clone());
end;

u6 = function(p11) -- Line: 36, Name: sprayTemplate
    -- upvalues: u5 (ref)
    return u5("SprayBottles", p11.assetName, p11.viewportRotation);
end;

local u12 = nil;

u5 = function(p13, p14, p15) -- Line: 40, Name: getTemplate
    -- upvalues: u3 (copy), u12 (ref), WFChain (copy), ReplicatedStorage (copy)
    local v16 = `{p13}/{p14}`;
    local v17 = u3[v16];

    if v17 then
        return v17;
    end;

    local v18 = u12(WFChain(ReplicatedStorage, "Assets", p13, p14), p15);
    u3[v16] = v18;

    return v18;
end;

u12 = function(p19, p20) -- Line: 50, Name: buildTemplate
    local v21 = p19:Clone();

    for _, descendant in v21:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Transparency >= 1 then
                descendant:Destroy();
            else
                descendant.Anchored = true;
            end;
        elseif not (descendant:IsA("Model") or (descendant:IsA("SurfaceAppearance") or (descendant:IsA("DataModelMesh") or descendant:IsA("Decal")))) then
            descendant:Destroy();
        end;
    end;

    v21:PivotTo(p20);
    v21.WorldPivot = CFrame.new();

    return v21;
end;

return {
    GearViewport = v4
};