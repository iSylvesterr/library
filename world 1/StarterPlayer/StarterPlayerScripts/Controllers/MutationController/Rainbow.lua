-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GrowEffects = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GrowEffects"));
local EffectLoadManager = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("EffectLoadManager"));
local PerfFlags = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("PerfFlags"));
local VFX = script.VFX;
local u2 = {};
local u3 = {};
local u4 = 0;
local u5 = nil;
local u6 = 0;

local function createVFXPart(u7) -- Line: 46
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

    GrowEffects.AddDescendantsAtBaseline(u7, function() -- Line: 50
        -- upvalues: u7 (copy), VFX (ref), u3 (ref)
        local v8, v9 = u7:GetBoundingBox();
        local Part = Instance.new("Part");
        Part.Name = "RainbowVFX";
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

local function tryCreateVFX(p10) -- Line: 71
    -- upvalues: createVFXPart (copy)
    if p10:IsA("Model") and p10.PrimaryPart then
        createVFXPart(p10);
    end;
end;

local function registerPart(p11, p12) -- Line: 81
    -- upvalues: u2 (copy)
    if not p12:IsA("BasePart") then
        return;
    end;

    local v13 = u2[p11];

    if not v13 then
        return;
    end;

    local Parent = p12.Parent;

    while Parent and Parent ~= p11 do
        if Parent.Name == "Fruits" then
            return;
        end;

        Parent = Parent.Parent;
    end;

    if v13.parts[p12] then
        return;
    end;

    local v14, _, v15 = p12.Color:ToHSV();
    v13.parts[p12] = {
        Value = v15,
        OriginalHue = v14,
        OriginalColor = p12.Color,
        OriginalReflectance = p12.Reflectance
    };
    p12.Reflectance = 0.1;
end;

local function recolorInstance(p16) -- Line: 113
    -- upvalues: u6 (ref)
    for i, v in p16.parts do
        if i.Parent then
            local Position = i.Position;
            local v17 = (u6 + (Position.X + Position.Z) / 50 % 1) % 1;
            local v18 = math.clamp(v.Value + (v.OriginalHue - 0.5) * 0.5, 0.1, 1);
            i.Color = Color3.fromHSV(v17, 1, v18);
        else
            p16.parts[i] = nil;
        end;
    end;
end;

local function startRainbowLoop() -- Line: 128
    -- upvalues: u5 (ref), RunService (copy), PerfFlags (copy), EffectLoadManager (copy), u4 (ref), u6 (ref), u2 (copy), u1 (copy), recolorInstance (copy)
    if u5 then
        return;
    end;

    u5 = RunService.Heartbeat:Connect(function(p19) -- Line: 131
        -- upvalues: PerfFlags (ref), EffectLoadManager (ref), u4 (ref), u6 (ref), u2 (ref), u1 (ref), recolorInstance (ref)
        if PerfFlags.MutationVFXDisabled:Get() then
            return;
        end;

        local v20 = EffectLoadManager.SpeedScaleForCount(u4);
        u6 = (u6 + p19 * 0.5 * v20) % 1;
        debug.profilebegin("Controllers/MutationController/Rainbow/Tick");
        local v21 = EffectLoadManager.GetTickInterval();
        local v22 = math.max(v21, EffectLoadManager.GetTickIntervalForCount(u4));

        for i, v in u2 do
            if i.Parent then
                v.accumulator = v.accumulator + p19;

                if v.accumulator >= v22 * (v.distanceMultiplier or 1) then
                    local v23 = EffectLoadManager.DistanceIntervalMultiplier(i);
                    v.distanceMultiplier = v23 or 1;
                    v.accumulator = 0;

                    if v23 then
                        recolorInstance(v);
                    end;
                end;
            else
                u1.RemoveMutationEffect(i);
            end;
        end;

        debug.profileend();
    end);
end;

local function stopRainbowLoop() -- Line: 170
    -- upvalues: u5 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

function u1.ApplyMutationEffect(u24) -- Line: 181
    -- upvalues: u2 (copy), CollectionService (copy), EffectLoadManager (copy), createVFXPart (copy), registerPart (copy), u3 (copy), u4 (ref), u5 (ref), RunService (copy), PerfFlags (copy), u6 (ref), u1 (copy), recolorInstance (copy)
    if u2[u24] then
        return;
    end;

    CollectionService:AddTag(u24, "Rainbow");
    local v25 = {
        descendantConn = nil,
        parts = {},
        accumulator = math.random() * EffectLoadManager.GetTickInterval()
    };
    u2[u24] = v25;

    if u24:IsA("Model") and u24.PrimaryPart then
        createVFXPart(u24);
    end;

    registerPart(u24, u24);

    for _, v in u24:QueryDescendants("BasePart") do
        registerPart(u24, v);
    end;

    v25.descendantConn = u24.DescendantAdded:Connect(function(p26) -- Line: 202
        -- upvalues: registerPart (ref), u24 (copy), u3 (ref), createVFXPart (ref)
        registerPart(u24, p26);

        if not u3[u24] then
            local v27 = u24;

            if v27:IsA("Model") and v27.PrimaryPart then
                createVFXPart(v27);
            end;
        end;
    end);
    EffectLoadManager.Register();
    u4 = u4 + 1;

    if u4 == 1 then
        if u5 then
            return;
        end;

        u5 = RunService.Heartbeat:Connect(function(p28) -- Line: 131
            -- upvalues: PerfFlags (ref), EffectLoadManager (ref), u4 (ref), u6 (ref), u2 (ref), u1 (ref), recolorInstance (ref)
            if PerfFlags.MutationVFXDisabled:Get() then
                return;
            end;

            local v29 = EffectLoadManager.SpeedScaleForCount(u4);
            u6 = (u6 + p28 * 0.5 * v29) % 1;
            debug.profilebegin("Controllers/MutationController/Rainbow/Tick");
            local v30 = EffectLoadManager.GetTickInterval();
            local v31 = math.max(v30, EffectLoadManager.GetTickIntervalForCount(u4));

            for i, v in u2 do
                if i.Parent then
                    v.accumulator = v.accumulator + p28;

                    if v.accumulator >= v31 * (v.distanceMultiplier or 1) then
                        local v32 = EffectLoadManager.DistanceIntervalMultiplier(i);
                        v.distanceMultiplier = v32 or 1;
                        v.accumulator = 0;

                        if v32 then
                            recolorInstance(v);
                        end;
                    end;
                else
                    u1.RemoveMutationEffect(i);
                end;
            end;

            debug.profileend();
        end);
    end;
end;

function u1.RemoveMutationEffect(p33) -- Line: 216
    -- upvalues: u2 (copy), u3 (copy), EffectLoadManager (copy), u4 (ref), u5 (ref)
    local v34 = u2[p33];

    if not v34 then
        return;
    end;

    u2[p33] = nil;

    if v34.descendantConn then
        v34.descendantConn:Disconnect();
    end;

    for i, v in v34.parts do
        if i.Parent then
            i.Color = v.OriginalColor;
            i.Reflectance = v.OriginalReflectance;
        end;
    end;

    if u3[p33] then
        u3[p33]:Destroy();
        u3[p33] = nil;
    end;

    EffectLoadManager.Unregister();
    u4 = math.max(0, u4 - 1);

    if u4 == 0 and u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

CollectionService:GetInstanceAddedSignal("Rainbow"):Connect(u1.ApplyMutationEffect);
CollectionService:GetInstanceRemovedSignal("Rainbow"):Connect(u1.RemoveMutationEffect);

for _, v in CollectionService:GetTagged("Rainbow") do
    task.spawn(u1.ApplyMutationEffect, v);
end;

PerfFlags.MutationVFXDisabled.Changed:Connect(function(p35) -- Line: 257
    -- upvalues: u3 (copy), u2 (copy), createVFXPart (copy)
    if p35 then
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

return u1;