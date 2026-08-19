-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local MaterialService = game:GetService("MaterialService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EffectLoadManager = require(ReplicatedStorage.SharedModules.EffectLoadManager);
local VFX = script.VFX;
local EmissiveStrength = MaterialService.StarInlet.EmissiveStrength;
local u2 = {};
local u3 = 0;
local u4 = nil;
local u5 = 0;
local u6 = 0;

local function quadInOut(p7) -- Line: 39
    if p7 < 0.5 then
        return p7 * 2 * p7;
    end;

    return 1 - (p7 * -2 + 2) ^ 2 / 2;
end;

local function tickPulse(p8) -- Line: 46
    -- upvalues: u5 (ref), EmissiveStrength (copy), MaterialService (copy)
    u5 = (u5 + p8) % 4;
    local v9 = EmissiveStrength;

    if u5 > 3 then
        local v10 = (u5 - 3) / 0.5;
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

        v9 = EmissiveStrength + (12 - EmissiveStrength) * v11;
    end;

    MaterialService.StarInlet.EmissiveStrength = v9;
end;

local function startPulse() -- Line: 59
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), RunService (copy), EffectLoadManager (copy), EmissiveStrength (copy), MaterialService (copy)
    if u4 then
        return;
    end;

    u5 = 0;
    u6 = 0;
    u4 = RunService.RenderStepped:Connect(function(p13) -- Line: 64
        -- upvalues: u6 (ref), EffectLoadManager (ref), u5 (ref), EmissiveStrength (ref), MaterialService (ref)
        u6 = u6 + p13;

        if u6 < EffectLoadManager.GetTickInterval() then
            return;
        end;

        debug.profilebegin("Mutations/Veil/Pulse");
        u5 = (u5 + u6) % 4;
        local v14 = EmissiveStrength;

        if u5 > 3 then
            local v15 = (u5 - 3) / 0.5;
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

            v14 = EmissiveStrength + (12 - EmissiveStrength) * v16;
        end;

        MaterialService.StarInlet.EmissiveStrength = v14;
        u6 = 0;
        debug.profileend();
    end);
end;

local function stopPulse() -- Line: 79
    -- upvalues: u4 (ref), MaterialService (copy), EmissiveStrength (copy)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    MaterialService.StarInlet.EmissiveStrength = EmissiveStrength;
end;

function v1.ApplyMutationEffect(p18) -- Line: 91
    -- upvalues: u2 (copy), CollectionService (copy), VFX (copy), EffectLoadManager (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), RunService (copy), EmissiveStrength (copy), MaterialService (copy)
    if u2[p18] then
        return;
    end;

    local v19 = {
        vfx = {},
        parts = {}
    };
    u2[p18] = v19;
    CollectionService:AddTag(p18, "Veil");

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
        for _, child in VFX:GetChildren() do
            local v21 = child:Clone();
            v21.Parent = v20;
            table.insert(v19.vfx, v21);
        end;
    end;

    for _, v in v19.parts do
        v.MaterialVariant = "StarInlet";
    end;

    EffectLoadManager.Register();
    u3 = u3 + 1;

    if u3 == 1 then
        if u4 then
            return;
        end;

        u5 = 0;
        u6 = 0;
        u4 = RunService.RenderStepped:Connect(function(p22) -- Line: 64
            -- upvalues: u6 (ref), EffectLoadManager (ref), u5 (ref), EmissiveStrength (ref), MaterialService (ref)
            u6 = u6 + p22;

            if u6 < EffectLoadManager.GetTickInterval() then
                return;
            end;

            debug.profilebegin("Mutations/Veil/Pulse");
            u5 = (u5 + u6) % 4;
            local v23 = EmissiveStrength;

            if u5 > 3 then
                local v24 = (u5 - 3) / 0.5;
                local v25, v26;

                if v24 <= 1 then
                    if v24 < 0.5 then
                        v25 = v24 * 2 * v24;
                    else
                        v25 = 1 - (v24 * -2 + 2) ^ 2 / 2;
                    end;

                    if not v25 then
                        v26 = 2 - v24;

                        if v26 < 0.5 then
                            v25 = v26 * 2 * v26;
                        else
                            v25 = 1 - (v26 * -2 + 2) ^ 2 / 2;
                        end;
                    end;
                else
                    v26 = 2 - v24;

                    if v26 < 0.5 then
                        v25 = v26 * 2 * v26;
                    else
                        v25 = 1 - (v26 * -2 + 2) ^ 2 / 2;
                    end;
                end;

                v23 = EmissiveStrength + (12 - EmissiveStrength) * v25;
            end;

            MaterialService.StarInlet.EmissiveStrength = v23;
            u6 = 0;
            debug.profileend();
        end);
    end;
end;

function v1.RemoveMutationEffect(p27) -- Line: 136
    -- upvalues: u2 (copy), EffectLoadManager (copy), u3 (ref), u4 (ref), MaterialService (copy), EmissiveStrength (copy)
    local v28 = u2[p27];

    if not v28 then
        return;
    end;

    u2[p27] = nil;

    for _, v in v28.vfx do
        if v.Parent then
            v:Destroy();
        end;
    end;

    for _, v in v28.parts do
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

        MaterialService.StarInlet.EmissiveStrength = EmissiveStrength;
    end;
end;

CollectionService:GetInstanceAddedSignal("Veil"):Connect(v1.ApplyMutationEffect);
CollectionService:GetInstanceRemovedSignal("Veil"):Connect(v1.RemoveMutationEffect);

for _, v in CollectionService:GetTagged("Veil") do
    task.spawn(v1.ApplyMutationEffect, v);
end;

return v1;