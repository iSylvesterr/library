-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local MaterialService = game:GetService("MaterialService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EffectLoadManager = require(ReplicatedStorage.SharedModules.EffectLoadManager);
local VFX = script.VFX;
local EmissiveStrength = MaterialService.LavaCrackItem.EmissiveStrength;
local u2 = {};
local u3 = 0;
local u4 = nil;
local u5 = 0;
local u6 = 0;

local function quadInOut(p7) -- Line: 42
    if p7 < 0.5 then
        return p7 * 2 * p7;
    end;

    return 1 - (p7 * -2 + 2) ^ 2 / 2;
end;

local function tickPulse(p8) -- Line: 49
    -- upvalues: u5 (ref), EmissiveStrength (copy), MaterialService (copy)
    u5 = (u5 + p8) % 7;
    local v9 = EmissiveStrength;

    if u5 > 3 then
        local v10 = (u5 - 3) / 2;
        local v11, v12;

        if v10 <= 1 then
            if v10 < 0.5 then
                v11 = v10 * 2 * v10;
            else
                v11 = 1 - (v10 * -2 + 2) ^ 2 / 2;
            end;

            if not v11 then
                v12 = 2 - v10;

                if v12 < 0.5 then
                    v11 = v12 * 2 * v12;
                else
                    v11 = 1 - (v12 * -2 + 2) ^ 2 / 2;
                end;
            end;
        else
            v12 = 2 - v10;

            if v12 < 0.5 then
                v11 = v12 * 2 * v12;
            else
                v11 = 1 - (v12 * -2 + 2) ^ 2 / 2;
            end;
        end;

        v9 = EmissiveStrength + (20 - EmissiveStrength) * v11;
    end;

    MaterialService.LavaCrackItem.EmissiveStrength = v9;
end;

local function startPulse() -- Line: 62
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), RunService (copy), EffectLoadManager (copy), EmissiveStrength (copy), MaterialService (copy)
    if u4 then
        return;
    end;

    u5 = 0;
    u6 = 0;
    u4 = RunService.RenderStepped:Connect(function(p13) -- Line: 67
        -- upvalues: u6 (ref), EffectLoadManager (ref), u5 (ref), EmissiveStrength (ref), MaterialService (ref)
        u6 = u6 + p13;

        if u6 < EffectLoadManager.GetTickInterval() then
            return;
        end;

        debug.profilebegin("Mutations/Ignited/Pulse");
        u5 = (u5 + u6) % 7;
        local v14 = EmissiveStrength;

        if u5 > 3 then
            local v15 = (u5 - 3) / 2;
            local v16, v17;

            if v15 <= 1 then
                if v15 < 0.5 then
                    v16 = v15 * 2 * v15;
                else
                    v16 = 1 - (v15 * -2 + 2) ^ 2 / 2;
                end;

                if not v16 then
                    v17 = 2 - v15;

                    if v17 < 0.5 then
                        v16 = v17 * 2 * v17;
                    else
                        v16 = 1 - (v17 * -2 + 2) ^ 2 / 2;
                    end;
                end;
            else
                v17 = 2 - v15;

                if v17 < 0.5 then
                    v16 = v17 * 2 * v17;
                else
                    v16 = 1 - (v17 * -2 + 2) ^ 2 / 2;
                end;
            end;

            v14 = EmissiveStrength + (20 - EmissiveStrength) * v16;
        end;

        MaterialService.LavaCrackItem.EmissiveStrength = v14;
        u6 = 0;
        debug.profileend();
    end);
end;

local function stopPulse() -- Line: 82
    -- upvalues: u4 (ref), MaterialService (copy), EmissiveStrength (copy)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    MaterialService.LavaCrackItem.EmissiveStrength = EmissiveStrength;
end;

function v1.ApplyMutationEffect(p18) -- Line: 94
    -- upvalues: u2 (copy), CollectionService (copy), VFX (copy), EffectLoadManager (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), RunService (copy), EmissiveStrength (copy), MaterialService (copy)
    if u2[p18] then
        return;
    end;

    local v19 = {
        vfx = {},
        parts = {}
    };
    u2[p18] = v19;
    CollectionService:AddTag(p18, "Ignited");

    if p18:IsA("BasePart") then
        table.insert(v19.parts, p18);
    end;

    for _, v in p18:QueryDescendants("BasePart") do
        table.insert(v19.parts, v);
    end;

    local v20;

    if p18:IsA("Model") then
        v20 = p18.PrimaryPart or v19.parts[1];
    else
        v20 = v19.parts[1];
    end;

    if v20 then
        if v20 then
            local v21, v22 = p18:GetBoundingBox();
            v20.Size = v22;
            v20.CFrame = v21;
        end;

        for _, child in VFX:GetChildren() do
            local v23 = child:Clone();
            v23.Parent = v20;
            v23.Rate = v20.Size.Magnitude * 0.5;
            table.insert(v19.vfx, v23);
        end;
    end;

    for _, v in v19.parts do
        v.Color = Color3.new(1, 0.666667, 0);
        v.MaterialVariant = "LavaCrackItem";
    end;

    EffectLoadManager.Register();
    u3 = u3 + 1;

    if u3 == 1 then
        if u4 then
            return;
        end;

        u5 = 0;
        u6 = 0;
        u4 = RunService.RenderStepped:Connect(function(p24) -- Line: 67
            -- upvalues: u6 (ref), EffectLoadManager (ref), u5 (ref), EmissiveStrength (ref), MaterialService (ref)
            u6 = u6 + p24;

            if u6 < EffectLoadManager.GetTickInterval() then
                return;
            end;

            debug.profilebegin("Mutations/Ignited/Pulse");
            u5 = (u5 + u6) % 7;
            local v25 = EmissiveStrength;

            if u5 > 3 then
                local v26 = (u5 - 3) / 2;
                local v27, v28;

                if v26 <= 1 then
                    if v26 < 0.5 then
                        v27 = v26 * 2 * v26;
                    else
                        v27 = 1 - (v26 * -2 + 2) ^ 2 / 2;
                    end;

                    if not v27 then
                        v28 = 2 - v26;

                        if v28 < 0.5 then
                            v27 = v28 * 2 * v28;
                        else
                            v27 = 1 - (v28 * -2 + 2) ^ 2 / 2;
                        end;
                    end;
                else
                    v28 = 2 - v26;

                    if v28 < 0.5 then
                        v27 = v28 * 2 * v28;
                    else
                        v27 = 1 - (v28 * -2 + 2) ^ 2 / 2;
                    end;
                end;

                v25 = EmissiveStrength + (20 - EmissiveStrength) * v27;
            end;

            MaterialService.LavaCrackItem.EmissiveStrength = v25;
            u6 = 0;
            debug.profileend();
        end);
    end;
end;

function v1.RemoveMutationEffect(p29) -- Line: 149
    -- upvalues: u2 (copy), EffectLoadManager (copy), u3 (ref), u4 (ref), MaterialService (copy), EmissiveStrength (copy)
    local v30 = u2[p29];

    if not v30 then
        return;
    end;

    u2[p29] = nil;

    for _, v in v30.vfx do
        if v.Parent then
            v:Destroy();
        end;
    end;

    for _, v in v30.parts do
        if v.Parent then
            v.MaterialVariant = "";
        end;
    end;

    EffectLoadManager.Unregister();
    u3 = math.max(0, u3 - 1);

    if u3 == 0 then
        if u4 then
            u4:Disconnect();
            u4 = nil;
        end;

        MaterialService.LavaCrackItem.EmissiveStrength = EmissiveStrength;
    end;
end;

CollectionService:GetInstanceAddedSignal("Ignited"):Connect(v1.ApplyMutationEffect);
CollectionService:GetInstanceRemovedSignal("Ignited"):Connect(v1.RemoveMutationEffect);

for _, v in CollectionService:GetTagged("Ignited") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

return v1;