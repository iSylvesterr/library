-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local DeepEqualsUnsafe = require(ReplicatedStorage.Library.Functions.DeepEqualsUnsafe);
local DeepCopyUnsafe = require(ReplicatedStorage.Library.Functions.DeepCopyUnsafe);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local Lightings = require(ReplicatedStorage.Directory.Lightings);
local LightingsCore = require(ReplicatedStorage.Library.Client.LightingsCore);
local u1 = {};
u1.__index = u1;
u1.__class = "Lightings";

local function serializeCurrentConfig() -- Line: 45
    -- upvalues: LightingsCore (copy), Lighting (copy), Workspace (copy)
    local v2 = LightingsCore.Serialize(Lighting);
    v2.Clouds = LightingsCore.SerializeClouds(Workspace.Terrain.Clouds);

    return v2;
end;

local function applyConfig(p3) -- Line: 52
    -- upvalues: DeepCopyUnsafe (copy), LightingsCore (copy), Lighting (copy), Workspace (copy)
    local v4 = DeepCopyUnsafe(p3);
    v4.Clouds = nil;
    LightingsCore.Apply(Lighting, v4);
    local Clouds = Workspace.Terrain.Clouds;
    local Clouds2 = p3.Clouds;

    if not Clouds2 then
        Clouds.Enabled = false;

        return;
    end;

    Clouds.Enabled = true;
    LightingsCore.ApplyClouds(Clouds, Clouds2);
end;

function u1._build() -- Line: 72
    -- upvalues: u1 (copy), Lightings (copy)
    local v5 = setmetatable({}, u1);
    v5.DefaultLightings = Lightings.Directory.Default;
    v5._baseConfig = v5.DefaultLightings;
    v5._basePriority = 0;
    v5._activeConfig = v5.DefaultLightings;
    v5._modifiers = {};
    v5._currentTweenHandle = nil;

    return v5;
end;

local function getOrderedSources(u6) -- Line: 86
    local v8 = {
        {
            Id = "__base",
            Priority = u6._basePriority,

            Transform = function(p7) -- Line: 91, Name: Transform
                -- upvalues: u6 (copy)
                return u6._baseConfig;
            end
        }
    };

    for i, v in pairs(u6._modifiers) do
        table.insert(v8, {
            Id = i,
            Priority = v.Priority,
            Transform = v.Transform
        });
    end;

    table.sort(v8, function(p9, p10) -- Line: 105
        if p9.Priority == p10.Priority then
            return p9.Id < p10.Id;
        end;

        return p9.Priority < p10.Priority;
    end);

    return v8;
end;

function u1._resolveActiveConfig(p11) -- Line: 116
    -- upvalues: getOrderedSources (copy)
    local DefaultLightings = p11.DefaultLightings;

    for _, v in ipairs((getOrderedSources(p11))) do
        DefaultLightings = v.Transform(DefaultLightings);
    end;

    return DefaultLightings;
end;

function u1._applyResolvedLighting(u12, p13) -- Line: 126
    -- upvalues: DeepEqualsUnsafe (copy), LightingsCore (copy), Lighting (copy), Workspace (copy), RenderStepped (copy), Easing (copy), DeepCopyUnsafe (copy)
    local u14 = u12:_resolveActiveConfig();

    if DeepEqualsUnsafe(u12._activeConfig, u14) then
        return;
    end;

    local v15 = p13 or 1.33;
    local Linear = Enum.EasingStyle.Linear;
    local Out = Enum.EasingDirection.Out;
    local v16 = LightingsCore.Serialize(Lighting);
    v16.Clouds = LightingsCore.SerializeClouds(Workspace.Terrain.Clouds);
    local u17 = v16;

    if u12._currentTweenHandle then
        u12._currentTweenHandle:Disconnect();
        u12._currentTweenHandle = nil;
    end;

    u12._activeConfig = u14;

    if v15 > 0 then
        local u18 = nil;
        u18 = RenderStepped(function(p19, p20) -- Line: 146
            -- upvalues: LightingsCore (ref), u17 (copy), u14 (copy), Easing (ref), Linear (copy), Out (copy), DeepCopyUnsafe (ref), Lighting (ref), Workspace (ref)
            local v21 = LightingsCore.Lerp(u17, u14, Easing(p20, Linear, Out));
            local v22 = DeepCopyUnsafe(v21);
            v22.Clouds = nil;
            LightingsCore.Apply(Lighting, v22);
            local Clouds = Workspace.Terrain.Clouds;
            local Clouds2 = v21.Clouds;

            if Clouds2 then
                Clouds.Enabled = true;
                LightingsCore.ApplyClouds(Clouds, Clouds2);
            else
                Clouds.Enabled = false;
            end;

            return false;
        end, v15, true):Then(function() -- Line: 150
            -- upvalues: u12 (copy), u18 (ref), u14 (copy), DeepCopyUnsafe (ref), LightingsCore (ref), Lighting (ref), Workspace (ref)
            if u12._currentTweenHandle == u18 then
                local v23 = u14;
                local v24 = DeepCopyUnsafe(v23);
                v24.Clouds = nil;
                LightingsCore.Apply(Lighting, v24);
                local Clouds = Workspace.Terrain.Clouds;
                local Clouds2 = v23.Clouds;

                if Clouds2 then
                    Clouds.Enabled = true;
                    LightingsCore.ApplyClouds(Clouds, Clouds2);

                    return;
                end;

                Clouds.Enabled = false;
            end;
        end);
        u12._currentTweenHandle = u18;

        return;
    end;

    local v25 = DeepCopyUnsafe(u14);
    v25.Clouds = nil;
    LightingsCore.Apply(Lighting, v25);
    local Clouds = Workspace.Terrain.Clouds;
    local Clouds2 = u14.Clouds;

    if not Clouds2 then
        Clouds.Enabled = false;

        return;
    end;

    Clouds.Enabled = true;
    LightingsCore.ApplyClouds(Clouds, Clouds2);
end;

function u1.SetLighting(p26, p27, p28, p29) -- Line: 167
    -- upvalues: Asserts (copy)
    Asserts.table(p27);
    Asserts.optional.number(p28);
    Asserts.optional.number(p29);
    p26._baseConfig = p27;
    p26._basePriority = p29 or 0;
    p26:_applyResolvedLighting(p28);
end;

function u1.SetModifier(p30, p31, p32, p33, p34) -- Line: 182
    -- upvalues: Asserts (copy)
    Asserts.string(p31);
    Asserts.optional.number(p33);
    Asserts.optional.number(p34);
    p30._modifiers[p31] = {
        Priority = p33 or 0,
        Transform = p32
    };
    p30:_applyResolvedLighting(p34);
end;

function u1.ClearModifier(p35, p36, p37) -- Line: 201
    -- upvalues: Asserts (copy)
    Asserts.string(p36);
    Asserts.optional.number(p37);

    if p35._modifiers[p36] == nil then
        return;
    end;

    p35._modifiers[p36] = nil;
    p35:_applyResolvedLighting(p37);
end;

return u1._build();