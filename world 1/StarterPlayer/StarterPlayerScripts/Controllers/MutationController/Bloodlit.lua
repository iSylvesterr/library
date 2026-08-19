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

local function isInsideFruits(p7, p8) -- Line: 45
    local Parent = p7.Parent;

    while Parent and Parent ~= p8 do
        if Parent.Name == "Fruits" then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function createVFXPart(u9) -- Line: 58
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

    GrowEffects.AddDescendantsAtBaseline(u9, function() -- Line: 62
        -- upvalues: u9 (copy), VFX (ref), u3 (ref)
        local v10, v11 = u9:GetBoundingBox();
        local Part = Instance.new("Part");
        Part.Name = "BloodlitVFX";
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

        u3[u9] = Part;
    end);
end;

local function tryCreateVFX(p12) -- Line: 83
    -- upvalues: createVFXPart (copy)
    if p12:IsA("Model") and p12.PrimaryPart then
        createVFXPart(p12);
    end;
end;

local function registerPart(p13, p14) -- Line: 93
    -- upvalues: u2 (copy)
    if not p14:IsA("BasePart") then
        return;
    end;

    local v15 = u2[p13];

    if not v15 then
        return;
    end;

    local Parent = p14.Parent;
    local v16;

    while true do
        if not Parent or Parent == p13 then
            v16 = false;
            break;
        end;

        if Parent.Name == "Fruits" then
            v16 = true;
            break;
        end;

        Parent = Parent.Parent;
    end;

    if v16 then
        return;
    end;

    if v15.parts[p14] then
        return;
    end;

    v15.parts[p14] = {
        OriginalColor = p14.Color,
        OriginalReflectance = p14.Reflectance
    };
    p14.Reflectance = 0.1;
end;

local function tickBloodlit() -- Line: 114
    -- upvalues: u2 (copy), u1 (copy), EffectLoadManager (copy)
    local v17 = os.clock() * 0.5 * 3.141592653589793 * 2;

    for i, v in u2 do
        if i.Parent then
            if EffectLoadManager.DistanceIntervalMultiplier(i) then
                for i2, _ in v.parts do
                    if i2.Parent then
                        local v18 = (math.sin(i2.Position.X / 50 + v17) + 1) / 2 * 0.75 + 0.05;
                        i2.Color = Color3.fromHSV(0, 1, v18);
                    else
                        v.parts[i2] = nil;
                    end;
                end;
            end;
        else
            u1.RemoveMutationEffect(i);
        end;
    end;
end;

local function startBloodlitLoop() -- Line: 143
    -- upvalues: u5 (ref), u6 (ref), RunService (copy), PerfFlags (copy), EffectLoadManager (copy), u4 (ref), tickBloodlit (copy)
    if u5 then
        return;
    end;

    u6 = 0;
    u5 = RunService.Heartbeat:Connect(function(p19) -- Line: 147
        -- upvalues: PerfFlags (ref), u6 (ref), EffectLoadManager (ref), u4 (ref), tickBloodlit (ref)
        if PerfFlags.MutationVFXDisabled:Get() then
            return;
        end;

        u6 = u6 + p19;
        local v20 = EffectLoadManager.GetTickInterval();

        if u6 < math.max(v20, EffectLoadManager.GetTickIntervalForCount(u4)) then
            return;
        end;

        u6 = 0;
        debug.profilebegin("Controllers/MutationController/Bloodlit/Tick");
        tickBloodlit();
        debug.profileend();
    end);
end;

local function stopBloodlitLoop() -- Line: 162
    -- upvalues: u5 (ref)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

function u1.ApplyMutationEffect(u21) -- Line: 173
    -- upvalues: u2 (copy), CollectionService (copy), createVFXPart (copy), registerPart (copy), u3 (copy), EffectLoadManager (copy), u4 (ref), u5 (ref), u6 (ref), RunService (copy), PerfFlags (copy), tickBloodlit (copy)
    if u2[u21] then
        return;
    end;

    CollectionService:AddTag(u21, "Bloodlit");
    local v22 = {
        descendantConn = nil,
        parts = {}
    };
    u2[u21] = v22;

    if u21:IsA("Model") and u21.PrimaryPart then
        createVFXPart(u21);
    end;

    registerPart(u21, u21);

    for _, v in u21:QueryDescendants("BasePart") do
        registerPart(u21, v);
    end;

    v22.descendantConn = u21.DescendantAdded:Connect(function(p23) -- Line: 187
        -- upvalues: registerPart (ref), u21 (copy), u3 (ref), createVFXPart (ref)
        registerPart(u21, p23);

        if not u3[u21] then
            local v24 = u21;

            if v24:IsA("Model") and v24.PrimaryPart then
                createVFXPart(v24);
            end;
        end;
    end);
    EffectLoadManager.Register();
    u4 = u4 + 1;

    if u4 == 1 then
        if u5 then
            return;
        end;

        u6 = 0;
        u5 = RunService.Heartbeat:Connect(function(p25) -- Line: 147
            -- upvalues: PerfFlags (ref), u6 (ref), EffectLoadManager (ref), u4 (ref), tickBloodlit (ref)
            if PerfFlags.MutationVFXDisabled:Get() then
                return;
            end;

            u6 = u6 + p25;
            local v26 = EffectLoadManager.GetTickInterval();

            if u6 < math.max(v26, EffectLoadManager.GetTickIntervalForCount(u4)) then
                return;
            end;

            u6 = 0;
            debug.profilebegin("Controllers/MutationController/Bloodlit/Tick");
            tickBloodlit();
            debug.profileend();
        end);
    end;
end;

function u1.RemoveMutationEffect(p27) -- Line: 201
    -- upvalues: u2 (copy), u3 (copy), EffectLoadManager (copy), u4 (ref), u5 (ref)
    local v28 = u2[p27];

    if not v28 then
        return;
    end;

    u2[p27] = nil;

    if v28.descendantConn then
        v28.descendantConn:Disconnect();
    end;

    for i, v in v28.parts do
        if i.Parent then
            i.Color = v.OriginalColor;
            i.Reflectance = v.OriginalReflectance;
        end;
    end;

    if u3[p27] then
        u3[p27]:Destroy();
        u3[p27] = nil;
    end;

    EffectLoadManager.Unregister();
    u4 = math.max(0, u4 - 1);

    if u4 == 0 and u5 then
        u5:Disconnect();
        u5 = nil;
    end;
end;

CollectionService:GetInstanceAddedSignal("Bloodlit"):Connect(u1.ApplyMutationEffect);
CollectionService:GetInstanceRemovedSignal("Bloodlit"):Connect(u1.RemoveMutationEffect);

for _, v in CollectionService:GetTagged("Bloodlit") do
    task.spawn(u1.ApplyMutationEffect, v);
end;

PerfFlags.MutationVFXDisabled.Changed:Connect(function(p29) -- Line: 242
    -- upvalues: u3 (copy), u2 (copy), createVFXPart (copy)
    if p29 then
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