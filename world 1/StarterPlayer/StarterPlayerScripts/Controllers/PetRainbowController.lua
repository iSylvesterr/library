-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PerfFlags = require(ReplicatedStorage.SharedModules.Flags.PerfFlags);
local EffectLoadManager = require(ReplicatedStorage.SharedModules.EffectLoadManager);
local u1 = {
    WingLeftColor = true,
    WingRightColor = true
};
local u2 = {
    JandelsCrown = true
};
local u3 = {};
local u4 = 0;
local u5 = 0;
local u6 = false;
local v7 = {};

local function RegisterPart(p8, p9) -- Line: 89
    -- upvalues: u3 (copy), u1 (copy), u2 (copy)
    if not p9:IsA("BasePart") then
        return;
    end;

    local v10 = u3[p8];

    if not v10 then
        return;
    end;

    for _, v in v10.Parts do
        if v.Part == p9 then
            return;
        end;
    end;

    local v11, _, v12 = p9.Color:ToHSV();
    local v13 = {
        Part = p9,
        OriginalHue = v11,
        Value = v12,
        OriginalColor = p9.Color,
        OriginalReflectance = p9.Reflectance,
        FullBrightness = u1[p9.Name] == true
    };

    if p9:IsA("UnionOperation") then
        v13.OriginalUsePartColor = p9.UsePartColor;
        p9.UsePartColor = true;
    end;

    if u2[p9.Name] and (p9:IsA("MeshPart") and p9.TextureID ~= "") then
        v13.OriginalTextureId = p9.TextureID;
        p9.TextureID = "";
    end;

    p9.Reflectance = 0.1;
    table.insert(v10.Parts, v13);
end;

local function RestoreModel(p14) -- Line: 125
    for _, v in p14.Parts do
        if v.Part.Parent then
            v.Part.Color = v.OriginalColor;
            v.Part.Reflectance = v.OriginalReflectance;

            if v.OriginalUsePartColor ~= nil and v.Part:IsA("UnionOperation") then
                v.Part.UsePartColor = v.OriginalUsePartColor;
            end;

            if v.OriginalTextureId ~= nil and v.Part:IsA("MeshPart") then
                v.Part.TextureID = v.OriginalTextureId;
            end;
        end;
    end;
end;

local function StartLoop() -- Line: 139
    -- upvalues: u6 (ref), RunService (copy), PerfFlags (copy), EffectLoadManager (copy), u4 (ref), u5 (ref), u3 (copy)
    if u6 then
        return;
    end;

    u6 = true;
    RunService.Heartbeat:Connect(function(p15) -- Line: 143
        -- upvalues: PerfFlags (ref), EffectLoadManager (ref), u4 (ref), u5 (ref), u3 (ref)
        if PerfFlags.AnimatedGradientsDisabled:Get() then
            return;
        end;

        debug.profilebegin("Controllers/PetRainbowController/Heartbeat");
        local v16 = EffectLoadManager.SpeedScaleForCount(u4);
        u5 = (u5 + p15 * 0.5 * v16) % 1;

        for i, v in u3 do
            if i.Parent then
                local v17 = (u5 + v.Offset) % 1;

                for _, v2 in v.Parts do
                    if v2.Part.Parent then
                        local v18 = v2.FullBrightness and 1 or math.clamp(v2.Value + (v2.OriginalHue - 0.5) * 0.5, 0.1, 1);
                        v2.Part.Color = Color3.fromHSV(v17, 1, v18);
                    end;
                end;
            else
                v.AddedConn:Disconnect();
                u3[i] = nil;
                u4 = math.max(0, u4 - 1);
            end;
        end;

        debug.profileend();
    end);
end;

local function ApplyEffect(u19) -- Line: 185
    -- upvalues: u3 (copy), RegisterPart (copy), u4 (ref), u6 (ref), RunService (copy), PerfFlags (copy), EffectLoadManager (copy), u5 (ref)
    if u3[u19] then
        return;
    end;

    u3[u19] = {
        Offset = math.random(),
        Parts = {},
        AddedConn = u19.DescendantAdded:Connect(function(p20) -- Line: 191
            -- upvalues: RegisterPart (ref), u19 (copy)
            RegisterPart(u19, p20);
        end)
    };
    u4 = u4 + 1;
    RegisterPart(u19, u19);

    for _, descendant in u19:GetDescendants() do
        RegisterPart(u19, descendant);
    end;

    if u6 then
        return;
    end;

    u6 = true;
    RunService.Heartbeat:Connect(function(p21) -- Line: 143
        -- upvalues: PerfFlags (ref), EffectLoadManager (ref), u4 (ref), u5 (ref), u3 (ref)
        if PerfFlags.AnimatedGradientsDisabled:Get() then
            return;
        end;

        debug.profilebegin("Controllers/PetRainbowController/Heartbeat");
        local v22 = EffectLoadManager.SpeedScaleForCount(u4);
        u5 = (u5 + p21 * 0.5 * v22) % 1;

        for i, v in u3 do
            if i.Parent then
                local v23 = (u5 + v.Offset) % 1;

                for _, v2 in v.Parts do
                    if v2.Part.Parent then
                        local v24 = v2.FullBrightness and 1 or math.clamp(v2.Value + (v2.OriginalHue - 0.5) * 0.5, 0.1, 1);
                        v2.Part.Color = Color3.fromHSV(v23, 1, v24);
                    end;
                end;
            else
                v.AddedConn:Disconnect();
                u3[i] = nil;
                u4 = math.max(0, u4 - 1);
            end;
        end;

        debug.profileend();
    end);
end;

local function RemoveEffect(p25) -- Line: 206
    -- upvalues: u3 (copy), u4 (ref), RestoreModel (copy)
    local v26 = u3[p25];

    if not v26 then
        return;
    end;

    v26.AddedConn:Disconnect();
    u3[p25] = nil;
    u4 = math.max(0, u4 - 1);
    RestoreModel(v26);
end;

function v7.Init(p27) -- Line: 215
end;

function v7.Start(p28) -- Line: 217
    -- upvalues: CollectionService (copy), ApplyEffect (copy), RemoveEffect (copy), PerfFlags (copy), u3 (copy), RestoreModel (copy)
    for _, v in { "PetRainbow", "RainbowModel" } do
        CollectionService:GetInstanceAddedSignal(v):Connect(ApplyEffect);
        CollectionService:GetInstanceRemovedSignal(v):Connect(RemoveEffect);

        for _, v2 in CollectionService:GetTagged(v) do
            task.spawn(ApplyEffect, v2);
        end;
    end;

    PerfFlags.AnimatedGradientsDisabled.Changed:Connect(function(p29) -- Line: 229
        -- upvalues: u3 (ref), RestoreModel (ref)
        if p29 then
            for _, v in u3 do
                RestoreModel(v);
            end;
        end;
    end);
end;

return v7;