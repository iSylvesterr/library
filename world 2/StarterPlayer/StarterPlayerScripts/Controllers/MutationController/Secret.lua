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

local function createVFXPart(u7) -- Line: 18
    -- upvalues: PerfFlags (copy), u3 (copy), GrowEffects (copy), VFX (copy)
    if PerfFlags.MutationVFXDisabled:Get() then
        return;
    end;

    if u3[u7] then
        return;
    end;

    if not (u7:IsA("Model") and u7.PrimaryPart) then
        return;
    end;

    GrowEffects.AddDescendantsAtBaseline(u7, function() -- Line: 22
        -- upvalues: u7 (copy), VFX (ref), u3 (ref)
        local v8, v9 = u7:GetBoundingBox();
        local Part = Instance.new("Part");
        Part.Name = "SecretVFX";
        Part.Size = v9;
        Part.CFrame = v8;
        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Anchored = true;
        Part.Massless = true;
        Part:AddTag("MutationVFX");
        Part.Parent = u7;

        for _, child in VFX:GetChildren() do
            child:Clone().Parent = Part;
        end;

        u3[u7] = Part;
    end);
end;

local function tryCreateVFX(p10) -- Line: 43
    -- upvalues: createVFXPart (copy)
    if p10:IsA("Model") and p10.PrimaryPart then
        createVFXPart(p10);
    end;
end;

local function registerPart(p11, p12) -- Line: 49
    -- upvalues: u2 (copy)
    if not p12:IsA("BasePart") then
        return;
    end;

    if not u2[p11] then
        return;
    end;

    local Parent = p12.Parent;

    while Parent and Parent ~= p11 do
        if Parent.Name == "Fruits" then
            return;
        end;

        Parent = Parent.Parent;
    end;

    for _, v in u2[p11] do
        if v.Part == p12 then
            return;
        end;
    end;

    local _, _, v13 = p12.Color:ToHSV();
    p12.Reflectance = 0.1;
    table.insert(u2[p11], {
        Part = p12,
        Value = v13
    });
end;

local function startSecretLoop() -- Line: 68
    -- upvalues: u4 (ref), RunService (copy), PerfFlags (copy), u6 (ref), EffectLoadManager (copy), u5 (ref), u2 (copy), u3 (copy)
    if u4 then
        return;
    end;

    u4 = true;
    RunService.Heartbeat:Connect(function(p14) -- Line: 71
        -- upvalues: PerfFlags (ref), u6 (ref), EffectLoadManager (ref), u5 (ref), u2 (ref), u3 (ref)
        if PerfFlags.MutationVFXDisabled:Get() then
            return;
        end;

        u6 = u6 + p14;
        local v15 = EffectLoadManager.GetTickInterval();

        if u6 < math.max(v15, EffectLoadManager.GetTickIntervalForCount(u5)) then
            return;
        end;

        u6 = 0;
        debug.profilebegin("Controllers/MutationController/Secret/Heartbeat");
        local v16 = workspace:GetServerTimeNow() * 0.5;

        for i, v in u2 do
            if i.Parent then
                if EffectLoadManager.DistanceIntervalMultiplier(i) then
                    for _, v2 in v do
                        if v2.Part.Parent then
                            local v17 = (math.sin((v2.Part.Position.Y / 0.2 + v16) * 3.141592653589793 * 2) + 1) / 2 * 0.85 + 0.05;
                            local v18 = math.clamp(v17, 0.05, 0.9);
                            v2.Part.Color = Color3.new(v18, v18, v18);
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

function v1.ApplyMutationEffect(u19) -- Line: 106
    -- upvalues: u2 (copy), CollectionService (copy), u5 (ref), createVFXPart (copy), registerPart (copy), u3 (copy), u4 (ref), RunService (copy), PerfFlags (copy), u6 (ref), EffectLoadManager (copy)
    if u2[u19] then
        return;
    end;

    CollectionService:AddTag(u19, "Secret");
    u2[u19] = {};
    u5 = u5 + 1;

    if u19:IsA("Model") and u19.PrimaryPart then
        createVFXPart(u19);
    end;

    registerPart(u19, u19);

    for _, v in u19:QueryDescendants("BasePart") do
        registerPart(u19, v);
    end;

    u19.DescendantAdded:Connect(function(p20) -- Line: 116
        -- upvalues: registerPart (ref), u19 (copy), u3 (ref), createVFXPart (ref)
        registerPart(u19, p20);

        if not u3[u19] then
            local v21 = u19;

            if v21:IsA("Model") and v21.PrimaryPart then
                createVFXPart(v21);
            end;
        end;
    end);

    if u4 then
        return;
    end;

    u4 = true;
    RunService.Heartbeat:Connect(function(p22) -- Line: 71
        -- upvalues: PerfFlags (ref), u6 (ref), EffectLoadManager (ref), u5 (ref), u2 (ref), u3 (ref)
        if PerfFlags.MutationVFXDisabled:Get() then
            return;
        end;

        u6 = u6 + p22;
        local v23 = EffectLoadManager.GetTickInterval();

        if u6 < math.max(v23, EffectLoadManager.GetTickIntervalForCount(u5)) then
            return;
        end;

        u6 = 0;
        debug.profilebegin("Controllers/MutationController/Secret/Heartbeat");
        local v24 = workspace:GetServerTimeNow() * 0.5;

        for i, v in u2 do
            if i.Parent then
                if EffectLoadManager.DistanceIntervalMultiplier(i) then
                    for _, v2 in v do
                        if v2.Part.Parent then
                            local v25 = (math.sin((v2.Part.Position.Y / 0.2 + v24) * 3.141592653589793 * 2) + 1) / 2 * 0.85 + 0.05;
                            local v26 = math.clamp(v25, 0.05, 0.9);
                            v2.Part.Color = Color3.new(v26, v26, v26);
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

CollectionService:GetInstanceAddedSignal("Secret"):Connect(v1.ApplyMutationEffect);

for _, v in CollectionService:GetTagged("Secret") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

PerfFlags.MutationVFXDisabled.Changed:Connect(function(p27) -- Line: 131
    -- upvalues: u3 (copy), u2 (copy), createVFXPart (copy)
    if p27 then
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