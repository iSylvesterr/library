-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local GrowEffects = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("GrowEffects"));
local EffectLoadManager = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("EffectLoadManager"));
local PerfFlags = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("PerfFlags"));
local u2 = {};
local u3 = {};
local u4 = false;
local u5 = 0;
local u6 = 0;
local VFX = script.VFX;

local function isInsideFruits(p7, p8) -- Line: 27
    local Parent = p7.Parent;

    while Parent and Parent ~= p8 do
        if Parent.Name == "Fruits" then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function createVFXPart(u9) -- Line: 36
    -- upvalues: PerfFlags (copy), u3 (copy), GrowEffects (copy), VFX (copy)
    if PerfFlags.MutationVFXDisabled:Get() then
        return;
    end;

    if u3[u9] then
        return;
    end;

    if not (u9:IsA("Model") and u9.PrimaryPart) then
        return;
    end;

    GrowEffects.AddDescendantsAtBaseline(u9, function() -- Line: 41
        -- upvalues: u9 (copy), VFX (ref), u3 (ref)
        local v10, v11 = u9:GetBoundingBox();
        local Part = Instance.new("Part");
        Part.Name = "ChainedVFX";
        Part.Size = v11;
        Part.CFrame = v10;
        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Anchored = true;
        Part.Massless = true;
        Part:AddTag("MutationVFX");
        Part.Parent = u9;

        for _, child in VFX:GetChildren() do
            child:Clone().Parent = Part;
        end;

        local v12 = 0;

        if v12 < Part.Size.X then
            v12 = Part.Size.X;
        end;

        if v12 < Part.Size.Z then
            v12 = Part.Size.Z;
        end;

        local v13 = script.ChainedModel:Clone();
        v13:ScaleTo(v12 * 1.05);

        for _, child in v13.ChainCircle:GetChildren() do
            child.Parent = Part;
        end;

        v13:Destroy();
        u3[u9] = Part;
    end);
end;

local function tryCreateVFX(p14) -- Line: 86
    -- upvalues: createVFXPart (copy)
    if p14:IsA("Model") and p14.PrimaryPart then
        createVFXPart(p14);
    end;
end;

local function registerPart(p15, p16) -- Line: 92
    -- upvalues: u2 (copy)
    if not p16:IsA("BasePart") then
        return;
    end;

    if not u2[p15] then
        return;
    end;

    local Parent = p16.Parent;
    local v17;

    while true do
        if not Parent or Parent == p15 then
            v17 = false;
            break;
        end;

        if Parent.Name == "Fruits" then
            v17 = true;
            break;
        end;

        Parent = Parent.Parent;
    end;

    if v17 then
        return;
    end;

    for _, v in u2[p15] do
        if v.Part == p16 then
            return;
        end;
    end;

    local _, _, v18 = p16.Color:ToHSV();
    p16.Reflectance = 0.25;
    table.insert(u2[p15], {
        Part = p16,
        Value = v18
    });
end;

local function startChainedLoop() -- Line: 110
    -- upvalues: u4 (ref), RunService (copy), PerfFlags (copy), u6 (ref), EffectLoadManager (copy), u5 (ref), u2 (copy), u3 (copy)
    if u4 then
        return;
    end;

    u4 = true;
    RunService.Heartbeat:Connect(function(p19) -- Line: 114
        -- upvalues: PerfFlags (ref), u6 (ref), EffectLoadManager (ref), u5 (ref), u2 (ref), u3 (ref)
        if PerfFlags.MutationVFXDisabled:Get() then
            return;
        end;

        u6 = u6 + p19;
        local v20 = EffectLoadManager.GetTickInterval();

        if u6 < math.max(v20, EffectLoadManager.GetTickIntervalForCount(u5)) then
            return;
        end;

        u6 = 0;
        debug.profilebegin("Controllers/MutationController/Chained/Heartbeat");
        local v21 = workspace:GetServerTimeNow() * 0.7 * 3.141592653589793 * 2;

        for i, v in u2 do
            if i.Parent then
                if EffectLoadManager.DistanceIntervalMultiplier(i) then
                    for _, v2 in v do
                        if v2.Part.Parent then
                            local v22 = (math.sin(v2.Part.Position.X / 50 + v21) + 1) / 2 * 0.4 + 0.6;
                            v2.Part.Color = Color3.fromHSV(0.849, 1, v22);
                        end;
                    end;
                end;
            else
                u2[i] = nil;
                u5 = math.max(0, u5 - 1);

                if u3[i] then
                    u3[i]:Destroy();
                    u3[i] = nil;
                end;
            end;
        end;

        debug.profileend();
    end);
end;

function v1.ApplyMutationEffect(u23) -- Line: 153
    -- upvalues: u2 (copy), CollectionService (copy), u5 (ref), createVFXPart (copy), registerPart (copy), u3 (copy), u4 (ref), RunService (copy), PerfFlags (copy), u6 (ref), EffectLoadManager (copy)
    if u2[u23] then
        return;
    end;

    CollectionService:AddTag(u23, "Chained");
    u2[u23] = {};
    u5 = u5 + 1;

    if u23:IsA("Model") and u23.PrimaryPart then
        createVFXPart(u23);
    end;

    registerPart(u23, u23);

    for _, v in u23:QueryDescendants("BasePart") do
        registerPart(u23, v);
    end;

    u23.DescendantAdded:Connect(function(p24) -- Line: 169
        -- upvalues: registerPart (ref), u23 (copy), u3 (ref), createVFXPart (ref)
        registerPart(u23, p24);

        if not u3[u23] then
            local v25 = u23;

            if v25:IsA("Model") and v25.PrimaryPart then
                createVFXPart(v25);
            end;
        end;
    end);

    if u4 then
        return;
    end;

    u4 = true;
    RunService.Heartbeat:Connect(function(p26) -- Line: 114
        -- upvalues: PerfFlags (ref), u6 (ref), EffectLoadManager (ref), u5 (ref), u2 (ref), u3 (ref)
        if PerfFlags.MutationVFXDisabled:Get() then
            return;
        end;

        u6 = u6 + p26;
        local v27 = EffectLoadManager.GetTickInterval();

        if u6 < math.max(v27, EffectLoadManager.GetTickIntervalForCount(u5)) then
            return;
        end;

        u6 = 0;
        debug.profilebegin("Controllers/MutationController/Chained/Heartbeat");
        local v28 = workspace:GetServerTimeNow() * 0.7 * 3.141592653589793 * 2;

        for i, v in u2 do
            if i.Parent then
                if EffectLoadManager.DistanceIntervalMultiplier(i) then
                    for _, v2 in v do
                        if v2.Part.Parent then
                            local v29 = (math.sin(v2.Part.Position.X / 50 + v28) + 1) / 2 * 0.4 + 0.6;
                            v2.Part.Color = Color3.fromHSV(0.849, 1, v29);
                        end;
                    end;
                end;
            else
                u2[i] = nil;
                u5 = math.max(0, u5 - 1);

                if u3[i] then
                    u3[i]:Destroy();
                    u3[i] = nil;
                end;
            end;
        end;

        debug.profileend();
    end);
end;

CollectionService:GetInstanceAddedSignal("Chained"):Connect(v1.ApplyMutationEffect);

for _, v in CollectionService:GetTagged("Chained") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

PerfFlags.MutationVFXDisabled.Changed:Connect(function(p30) -- Line: 186
    -- upvalues: u3 (copy), u2 (copy), createVFXPart (copy)
    if p30 then
        for i, v in u3 do
            v:Destroy();
            u3[i] = nil;
        end;

        return;
    end;

    for i in u2 do
        if i:IsA("Model") and i.PrimaryPart then
            createVFXPart(i);
        end;
    end;
end);

return v1;