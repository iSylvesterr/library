-- Decompiled with Potassium's decompiler.

local TypeRegistry = require(script.Parent.TypeRegistry);
local u1 = {};
local u2 = { "OnEmit", "OnDeath", "OnDestruction", "OnHit" };
u1.EVENT_NAMES = u2;
u1.EVENTS_FOLDER_NAME = "Events";
local u3 = {
    AtPosition = true,
    AtSource = true,
    AtTarget = true,
    AtCFrame = true
};
u1.EMIT_MODES = u3;
local u4 = {
    Off = true,
    Kill = true,
    Stop = true,
    Bounce = true
};
u1.COLLISION_MODES = u4;

function u1.clampChainDepth(p5) -- Line: 24
    local v6 = tonumber(p5);

    if not v6 then
        return 4;
    end;

    local v7 = math.floor(v6);

    return math.clamp(v7, 1, 32);
end;

function u1.safeEmitMode(p8) -- Line: 30
    -- upvalues: u3 (copy)
    return (type(p8) ~= "string" or not u3[p8]) and "AtPosition" or p8;
end;

function u1.safeCollisionMode(p9) -- Line: 35
    -- upvalues: u4 (copy)
    return (type(p9) ~= "string" or not u4[p9]) and "Off" or p9;
end;

function u1.clampUnit(p10, p11, p12, p13) -- Line: 40
    local v14 = tonumber(p10);

    if not v14 then
        return p13;
    end;

    if v14 < p11 then
        return p11;
    end;

    if p12 < v14 then
        return p12;
    end;

    return v14;
end;

local u15 = {
    Part = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = true
    },
    Beam = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    },
    Attachment = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = true
    },
    Model = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = true
    },
    PointLight = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    },
    Highlight = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    },
    TrailEmitter = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    },
    Atmosphere = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    },
    Blur = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    },
    Bloom = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    },
    ColorCorrection = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    },
    ImageLabel = {
        OnEmit = true,
        OnDeath = true,
        OnDestruction = true,
        OnHit = false
    }
};
local u16 = {
    Enabled = false,
    EmitMode = "AtPosition",
    ScriptEnabled = false,
    ChainDepthLimit = 4,
    Collision = "Off",
    Bounciness = 0.7,
    Friction = 0.2,
    Spin = 0.5,
    HitCheckInterval = 0,
    CollisionGroup = ""
};

local function getConfig(p17) -- Line: 174
    -- upvalues: TypeRegistry (copy)
    if not p17 then
        return nil;
    end;

    local v18 = TypeRegistry.getTypeFor(p17);

    if v18 and not v18.directAccess then
        return TypeRegistry.getConfig(p17);
    end;

    return nil;
end;

local function getTypeName(p19) -- Line: 181
    -- upvalues: TypeRegistry (copy)
    local _, v20 = TypeRegistry.getTypeFor(p19);

    return v20;
end;

function u1.read(p21) -- Line: 188
    -- upvalues: TypeRegistry (copy)
    local v22;

    if p21 then
        local v23 = TypeRegistry.getTypeFor(p21);

        if v23 and not v23.directAccess then
            v22 = TypeRegistry.getConfig(p21);
        else
            v22 = nil;
        end;
    else
        v22 = nil;
    end;

    if not v22 then
        return nil;
    end;

    local Events = v22:FindFirstChild("Events");

    if Events and Events:IsA("Folder") then
        return Events;
    end;

    return nil;
end;

function u1.isValidForItem(p24, p25) -- Line: 199
    -- upvalues: TypeRegistry (copy), u1 (copy)
    local _, v26 = TypeRegistry.getTypeFor(p24);

    if v26 then
        return u1.isValidForTypeName(v26, p25);
    end;

    return false;
end;

function u1.isValidForTypeName(p27, p28) -- Line: 209
    -- upvalues: u15 (copy)
    local v29 = u15[p27];

    return v29 and v29[p28] == true and true or false;
end;

function u1.readEvent(p30, p31) -- Line: 215
    -- upvalues: u1 (copy)
    local v32 = u1.read(p30);

    if not v32 then
        return nil;
    end;

    local v33 = v32:FindFirstChild(p31);

    if v33 and v33:IsA("Configuration") then
        return v33;
    end;

    return nil;
end;

function u1.ensureExcludeListFolder(p34) -- Line: 227
    if not p34 then
        return nil;
    end;

    local ExcludeList = p34:FindFirstChild("ExcludeList");

    if not ExcludeList then
        ExcludeList = Instance.new("Folder");
        ExcludeList.Name = "ExcludeList";
        ExcludeList.Parent = p34;
    end;

    return ExcludeList;
end;

function u1.readEnabled(p35) -- Line: 258
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), u4 (copy)
    local v36 = u1.read(p35);

    if not v36 then
        return nil;
    end;

    local v37 = nil;

    for _, v in ipairs(u2) do
        if u1.isValidForItem(p35, v) then
            local v38 = v36:FindFirstChild(v);

            if v38 and (v38:IsA("Configuration") and (v38:GetAttribute("Enabled") == true and not v38:GetAttribute("ImportedUntrusted"))) then
                local EmitTarget = v38:FindFirstChild("EmitTarget");
                local v39 = v38:GetAttribute("ScriptEnabled") == true;
                local v40;

                if v39 then
                    v40 = v38:FindFirstChild("Module") or nil;
                else
                    v40 = nil;
                end;

                if v40 and not v40:IsA("ModuleScript") then
                    v40 = nil;
                end;

                v37 = v37 or {};
                local v41 = {
                    Enabled = true,
                    EventName = v
                };
                local v42 = v38:GetAttribute("EmitMode");
                v41.EmitMode = (type(v42) ~= "string" or not u3[v42]) and "AtPosition" or v42;
                v41.ScriptEnabled = v39;
                local v43 = v38:GetAttribute("ChainDepthLimit");
                local v44 = tonumber(v43);
                local v45;

                if v44 then
                    local v46 = math.floor(v44);
                    v45 = math.clamp(v46, 1, 32);
                else
                    v45 = 4;
                end;

                v41.ChainDepthLimit = v45;
                v41.EmitTarget = EmitTarget and (EmitTarget:IsA("ObjectValue") and EmitTarget.Value) or nil;
                v41.Module = v40;
                local v47 = v38:GetAttribute("Collision");
                v41.Collision = (type(v47) ~= "string" or not u4[v47]) and "Off" or v47;
                local v48 = v38:GetAttribute("Bounciness");
                local v49 = tonumber(v48);
                v41.Bounciness = not v49 and 0.7 or (v49 < 0 and 0 or (v49 > 1 and 1 or v49));
                local v50 = v38:GetAttribute("Friction");
                local v51 = tonumber(v50);
                v41.Friction = not v51 and 0.2 or (v51 < 0 and 0 or (v51 > 1 and 1 or v51));
                local v52 = v38:GetAttribute("Spin");
                local v53 = tonumber(v52);
                v41.Spin = not v53 and 0.5 or (v53 < 0 and 0 or (v53 > 2 and 2 or v53));
                local v54 = v38:GetAttribute("HitCheckInterval");
                local v55 = tonumber(v54);
                v41.HitCheckInterval = not v55 and 0 or (v55 < 0 and 0 or (v55 > 0.5 and 0.5 or v55));
                v37[v] = v41;
            end;
        end;
    end;

    return v37;
end;

function u1.ensure(p56) -- Line: 300
    -- upvalues: TypeRegistry (copy)
    local v57;

    if p56 then
        local v58 = TypeRegistry.getTypeFor(p56);

        if v58 and not v58.directAccess then
            v57 = TypeRegistry.getConfig(p56);
        else
            v57 = nil;
        end;
    else
        v57 = nil;
    end;

    if not v57 then
        return nil;
    end;

    local Events = v57:FindFirstChild("Events");

    if Events and Events:IsA("Folder") then
        return Events;
    end;

    if Events then
        Events:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "Events";
    Folder.Parent = v57;

    return Folder;
end;

function u1.ensureEvent(p59, p60) -- Line: 316
    -- upvalues: u1 (copy), u16 (copy)
    if not u1.isValidForItem(p59, p60) then
        return nil;
    end;

    local v61 = u1.ensure(p59);

    if not v61 then
        return nil;
    end;

    local v62 = v61:FindFirstChild(p60);

    if v62 and v62:IsA("Configuration") then
        return v62;
    end;

    if v62 then
        v62:Destroy();
    end;

    local Configuration = Instance.new("Configuration");
    Configuration.Name = p60;

    for i, v in pairs(u16) do
        Configuration:SetAttribute(i, v);
    end;

    local ObjectValue = Instance.new("ObjectValue");
    ObjectValue.Name = "EmitTarget";
    ObjectValue.Value = nil;
    ObjectValue.Parent = Configuration;
    local ModuleScript = Instance.new("ModuleScript");
    ModuleScript.Name = "Module";
    ModuleScript.Source = "--[[\n\tPart-Icles event handler.\n\n\tSource emitters supported: Part / Beam / PointLight / Attachment / Model /\n\tHighlight / TrailEmitter / Blur / Bloom / ColorCorrection / Atmosphere /\n\tImageLabel.\n\n\tRaw ParticleEmitters and raw Trails are NOT supported as event SOURCES (they\n\thave no event-binding UI). As event TARGETS they ARE supported: a raw PE\n\ttarget gets wrapped in a holder Part at the emit-position; a raw Trail target\n\temits in-place (the position override is ignored).\n]]\n-- ============================================================================\n--  READ ONLY  (data fields  -  writing has no engine effect)\n-- ============================================================================\n--   Shared (every event scope)\n--     payload.Source                            -- the source emitter Instance\n--     payload.Particle, payload.RenderTemplate  -- the live emitted clone (RenderTemplate is a legacy alias)\n--     payload.WorldCFrame                       -- world-space CFrame (nil for screen types)\n--     payload.WorldPosition                     -- world position (nil for screen types)\n--     payload.StartTime                         -- os.clock() at spawn\n--     payload.LifeTime                          -- configured lifetime in seconds (use SetLifetime to change)\n--     payload.LifeProgress                      -- t in [0, 1] of life elapsed (clamped)\n--     payload.TimeRemaining                     -- seconds until natural death (max(0, LifeTime - elapsed))\n--     payload.SpeedMultiplier                   -- current bounce-attenuated speed scalar (1 by default)\n--     payload.ChainDepth                        -- depth of this event in the cross-emitter chain (0 = root)\n--\n--   OnEmit only\n--     payload.EmitPosition                      -- Vector3 (alias for WorldPosition in OnEmit scope)\n--     payload.EmitIndex                         -- 1-based batch index\n--     payload.EmitCount                         -- batch size when emitted via burst (nil otherwise)\n--\n--   OnHit only\n--     payload.HitPosition                       -- Vector3\n--     payload.HitNormal                         -- Vector3\n--     payload.HitInstance, payload.Other        -- the hit Instance (Other is an alias)\n--\n--   OnDeath only\n--     payload.DeathPosition                     -- Vector3 (alias for WorldPosition in OnDeath scope)\n--     payload.Age                               -- particle age in seconds\n--\n--   OnDestruction only\n--     payload.DeathPosition                     -- Vector3 (alias for WorldPosition in OnDestruction scope)\n--     payload.LingerElapsed                     -- seconds elapsed since linger started\n--\n-- ============================================================================\n--  MUTATORS  (functions  -  call to change the live particle\'s state)\n--             All mutators are available in every event scope.\n-- ============================================================================\n--   Emission control\n--     payload.Emit(target, mode)         -- mode = \"AtPosition\"|\"AtSource\"|\"AtTarget\"|\"AtCFrame\"\n--     payload.Kill()                     -- destroy/disable particle; Animate-mode-aware\n--     payload.Resurrect()                -- undo a Kill (clears _killedManually + _forceDead)\n--\n--   Graph-channel override (auto-skip future graph writes on that channel)\n--     payload.SetColor(color3)\n--     payload.SetTransparency(scalar)\n--     payload.SetSize(size)              -- BasePart.Size (Vector3) / Model ScaleTo / ImageLabel UDim2\n--\n--   Graph-channel skip (manual gate; no value write)\n--     payload.SetSkipColor(bool)\n--     payload.SetSkipTransparency(bool)\n--     payload.SetSkipSize(bool)          -- Part only for now\n--\n--   Lifecycle\n--     payload.SetLifetime(seconds)       -- set NEW total LifeTime; <=0.001 = instant kill next frame\n--     payload.FreezeTime(bool)           -- toggle effective-elapsed advance (true = paused)\n--     payload.Pause(seconds)             -- temporary FreezeTime; auto-clears after duration\n--\n--   Spatial / kinematic\n--     payload.Teleport(cframe)           -- write VisualPart to a new CFrame (Part/Attachment/Model only)\n--     payload.SetVelocity(vec3)          -- replace BaseDirection (unit) + speed override (magnitude)\n--     payload.SetSpeedMultiplier(scalar) -- multiplicative scalar applied per-step\n--     payload.AddSpin(vec3)              -- add angular velocity to pData._spinRate\n--     payload.AddImpulse(vec3)           -- kick pData._accelVel (acceleration-velocity accumulator)\nreturn function(payload)\n\t-- your code here\nend\n";
    ModuleScript.Parent = Configuration;
    Configuration.Parent = v61;

    return Configuration;
end;

function u1.setEnabled(p63, p64, p65) -- Line: 343
    -- upvalues: u1 (copy)
    if p65 then
        local v66 = u1.ensureEvent(p63, p64);

        if not v66 then
            return nil;
        end;

        v66:SetAttribute("Enabled", true);

        return v66;
    end;

    local v67 = u1.readEvent(p63, p64);

    if not v67 then
        return nil;
    end;

    v67:SetAttribute("Enabled", false);

    return v67;
end;

function u1.trustEvent(p68, p69) -- Line: 366
    -- upvalues: u1 (copy)
    local v70 = u1.readEvent(p68, p69);

    if not v70 then
        return false;
    end;

    if not v70:GetAttribute("ImportedUntrusted") then
        return false;
    end;

    v70:SetAttribute("ImportedUntrusted", nil);

    return true;
end;

function u1.trustAllEvents(p71) -- Line: 380
    -- upvalues: u1 (copy)
    local v72 = u1.read(p71);

    if not v72 then
        return false;
    end;

    local v73 = false;

    for _, child in ipairs(v72:GetChildren()) do
        if child:IsA("Configuration") and child:GetAttribute("ImportedUntrusted") then
            child:SetAttribute("ImportedUntrusted", nil);
            v73 = true;
        end;
    end;

    return v73;
end;

function u1.stampImportedUntrusted(p74) -- Line: 402
    -- upvalues: u1 (copy)
    local v75 = u1.read(p74);

    if not v75 then
        return false;
    end;

    local v76 = false;

    for _, child in ipairs(v75:GetChildren()) do
        if child:IsA("Configuration") then
            child:SetAttribute("ImportedUntrusted", true);
            child:SetAttribute("Enabled", false);
            v76 = true;
        end;
    end;

    return v76;
end;

function u1.deleteEvent(p77, p78) -- Line: 419
    -- upvalues: u1 (copy)
    local v79 = u1.readEvent(p77, p78);

    if not v79 then
        return false;
    end;

    v79:Destroy();
    local v80 = u1.read(p77);

    if v80 and #v80:GetChildren() == 0 then
        v80:Destroy();
    end;

    return true;
end;

function u1.sanitize(p81) -- Line: 437
    -- upvalues: u1 (copy), u2 (copy), u16 (copy), u3 (copy), u4 (copy)
    local v82 = u1.read(p81);

    if not v82 then
        return false;
    end;

    local v83 = {};
    local v84 = false;

    for _, v in ipairs(u2) do
        v83[v] = true;
    end;

    for _, child in ipairs(v82:GetChildren()) do
        if child:IsA("Configuration") and v83[child.Name] then
            if u1.isValidForItem(p81, child.Name) then
                for i, v in pairs(u16) do
                    if child:GetAttribute(i) == nil then
                        child:SetAttribute(i, v);
                        v84 = true;
                    end;
                end;

                local v85 = child:GetAttribute("ChainDepthLimit");
                local v86 = tonumber(v85);
                local v87;

                if v86 then
                    local v88 = math.floor(v86);
                    v87 = math.clamp(v88, 1, 32);
                else
                    v87 = 4;
                end;

                if v85 ~= v87 then
                    child:SetAttribute("ChainDepthLimit", v87);
                    v84 = true;
                end;

                local v89 = child:GetAttribute("EmitMode");
                local v90 = (type(v89) ~= "string" or not u3[v89]) and "AtPosition" or v89;

                if v89 ~= v90 then
                    child:SetAttribute("EmitMode", v90);
                    v84 = true;
                end;

                local v91 = child:GetAttribute("Collision");
                local v92 = (type(v91) ~= "string" or not u4[v91]) and "Off" or v91;

                if v91 ~= v92 then
                    child:SetAttribute("Collision", v92);
                    v84 = true;
                end;

                for _, v in ipairs({ {
                        name = "Bounciness",
                        lo = 0,
                        hi = 1,
                        default = 0.7
                    }, {
                        name = "Friction",
                        lo = 0,
                        hi = 1,
                        default = 0.2
                    }, {
                        name = "Spin",
                        lo = 0,
                        hi = 2,
                        default = 0.5
                    }, {
                        name = "HitCheckInterval",
                        lo = 0,
                        hi = 0.5,
                        default = 0
                    } }) do
                    local v93 = child:GetAttribute(v.name);
                    local lo = v.lo;
                    local hi = v.hi;
                    local default = v.default;
                    local v94 = tonumber(v93);

                    if v94 then
                        if v94 < lo then
                            v94 = lo;
                        elseif hi < v94 then
                            v94 = hi;
                        end;
                    else
                        v94 = default;
                    end;

                    if v93 ~= v94 then
                        child:SetAttribute(v.name, v94);
                        v84 = true;
                    end;
                end;

                local EmitTarget = child:FindFirstChild("EmitTarget");

                if not (EmitTarget and EmitTarget:IsA("ObjectValue")) then
                    if EmitTarget then
                        EmitTarget:Destroy();
                    end;

                    local ObjectValue = Instance.new("ObjectValue");
                    ObjectValue.Name = "EmitTarget";
                    ObjectValue.Parent = child;
                    v84 = true;
                end;

                local Module = child:FindFirstChild("Module");

                if not (Module and Module:IsA("ModuleScript")) then
                    if Module then
                        Module:Destroy();
                    end;

                    local ModuleScript = Instance.new("ModuleScript");
                    ModuleScript.Name = "Module";
                    ModuleScript.Source = "--[[\n\tPart-Icles event handler.\n\n\tSource emitters supported: Part / Beam / PointLight / Attachment / Model /\n\tHighlight / TrailEmitter / Blur / Bloom / ColorCorrection / Atmosphere /\n\tImageLabel.\n\n\tRaw ParticleEmitters and raw Trails are NOT supported as event SOURCES (they\n\thave no event-binding UI). As event TARGETS they ARE supported: a raw PE\n\ttarget gets wrapped in a holder Part at the emit-position; a raw Trail target\n\temits in-place (the position override is ignored).\n]]\n-- ============================================================================\n--  READ ONLY  (data fields  -  writing has no engine effect)\n-- ============================================================================\n--   Shared (every event scope)\n--     payload.Source                            -- the source emitter Instance\n--     payload.Particle, payload.RenderTemplate  -- the live emitted clone (RenderTemplate is a legacy alias)\n--     payload.WorldCFrame                       -- world-space CFrame (nil for screen types)\n--     payload.WorldPosition                     -- world position (nil for screen types)\n--     payload.StartTime                         -- os.clock() at spawn\n--     payload.LifeTime                          -- configured lifetime in seconds (use SetLifetime to change)\n--     payload.LifeProgress                      -- t in [0, 1] of life elapsed (clamped)\n--     payload.TimeRemaining                     -- seconds until natural death (max(0, LifeTime - elapsed))\n--     payload.SpeedMultiplier                   -- current bounce-attenuated speed scalar (1 by default)\n--     payload.ChainDepth                        -- depth of this event in the cross-emitter chain (0 = root)\n--\n--   OnEmit only\n--     payload.EmitPosition                      -- Vector3 (alias for WorldPosition in OnEmit scope)\n--     payload.EmitIndex                         -- 1-based batch index\n--     payload.EmitCount                         -- batch size when emitted via burst (nil otherwise)\n--\n--   OnHit only\n--     payload.HitPosition                       -- Vector3\n--     payload.HitNormal                         -- Vector3\n--     payload.HitInstance, payload.Other        -- the hit Instance (Other is an alias)\n--\n--   OnDeath only\n--     payload.DeathPosition                     -- Vector3 (alias for WorldPosition in OnDeath scope)\n--     payload.Age                               -- particle age in seconds\n--\n--   OnDestruction only\n--     payload.DeathPosition                     -- Vector3 (alias for WorldPosition in OnDestruction scope)\n--     payload.LingerElapsed                     -- seconds elapsed since linger started\n--\n-- ============================================================================\n--  MUTATORS  (functions  -  call to change the live particle\'s state)\n--             All mutators are available in every event scope.\n-- ============================================================================\n--   Emission control\n--     payload.Emit(target, mode)         -- mode = \"AtPosition\"|\"AtSource\"|\"AtTarget\"|\"AtCFrame\"\n--     payload.Kill()                     -- destroy/disable particle; Animate-mode-aware\n--     payload.Resurrect()                -- undo a Kill (clears _killedManually + _forceDead)\n--\n--   Graph-channel override (auto-skip future graph writes on that channel)\n--     payload.SetColor(color3)\n--     payload.SetTransparency(scalar)\n--     payload.SetSize(size)              -- BasePart.Size (Vector3) / Model ScaleTo / ImageLabel UDim2\n--\n--   Graph-channel skip (manual gate; no value write)\n--     payload.SetSkipColor(bool)\n--     payload.SetSkipTransparency(bool)\n--     payload.SetSkipSize(bool)          -- Part only for now\n--\n--   Lifecycle\n--     payload.SetLifetime(seconds)       -- set NEW total LifeTime; <=0.001 = instant kill next frame\n--     payload.FreezeTime(bool)           -- toggle effective-elapsed advance (true = paused)\n--     payload.Pause(seconds)             -- temporary FreezeTime; auto-clears after duration\n--\n--   Spatial / kinematic\n--     payload.Teleport(cframe)           -- write VisualPart to a new CFrame (Part/Attachment/Model only)\n--     payload.SetVelocity(vec3)          -- replace BaseDirection (unit) + speed override (magnitude)\n--     payload.SetSpeedMultiplier(scalar) -- multiplicative scalar applied per-step\n--     payload.AddSpin(vec3)              -- add angular velocity to pData._spinRate\n--     payload.AddImpulse(vec3)           -- kick pData._accelVel (acceleration-velocity accumulator)\nreturn function(payload)\n\t-- your code here\nend\n";
                    ModuleScript.Parent = child;
                    v84 = true;
                end;

                for _, child2 in ipairs(child:GetChildren()) do
                    if child2.Name == "_CompiledEventModule" then
                        child2:Destroy();
                        v84 = true;
                    end;
                end;
            else
                child:Destroy();
                v84 = true;
            end;
        else
            child:Destroy();
            v84 = true;
        end;
    end;

    if #v82:GetChildren() == 0 then
        v82:Destroy();
        v84 = true;
    end;

    return v84;
end;

function u1.snapshot(p95) -- Line: 551
    -- upvalues: u1 (copy), u2 (copy)
    local v96 = u1.read(p95);

    if not v96 then
        return nil;
    end;

    local v97 = nil;

    for _, v in ipairs(u2) do
        local v98 = v96:FindFirstChild(v);

        if v98 and v98:IsA("Configuration") then
            v97 = v97 or {};
            local v99 = {
                Enabled = v98:GetAttribute("Enabled"),
                EmitMode = v98:GetAttribute("EmitMode"),
                ScriptEnabled = v98:GetAttribute("ScriptEnabled"),
                ChainDepthLimit = v98:GetAttribute("ChainDepthLimit"),
                Collision = v98:GetAttribute("Collision"),
                Bounciness = v98:GetAttribute("Bounciness"),
                Friction = v98:GetAttribute("Friction"),
                Spin = v98:GetAttribute("Spin"),
                HitCheckInterval = v98:GetAttribute("HitCheckInterval"),
                ImportedUntrusted = v98:GetAttribute("ImportedUntrusted") == true
            };
            local EmitTarget = v98:FindFirstChild("EmitTarget");

            if EmitTarget and EmitTarget:IsA("ObjectValue") then
                v99.EmitTargetPresent = true;
                v99.EmitTargetValue = EmitTarget.Value;
                v99.EmitTargetPath = EmitTarget.Value and EmitTarget.Value:GetFullName() or nil;
            end;

            local Module = v98:FindFirstChild("Module");

            if Module and Module:IsA("ModuleScript") then
                v99.ModuleSource = Module.Source;
            end;

            v97[v] = v99;
        end;
    end;

    return v97;
end;

function u1.apply(p100, p101) -- Line: 595
    -- upvalues: u1 (copy), u3 (copy), u4 (copy)
    if not p101 then
        return false;
    end;

    local v102 = false;

    for i, v in pairs(p101) do
        if u1.isValidForItem(p100, i) then
            local v103 = u1.ensureEvent(p100, i);

            if v103 then
                if v.Enabled ~= nil then
                    v103:SetAttribute("Enabled", v.Enabled == true);
                end;

                if v.EmitMode ~= nil then
                    local EmitMode = v.EmitMode;
                    v103:SetAttribute("EmitMode", (type(EmitMode) ~= "string" or not u3[EmitMode]) and "AtPosition" or EmitMode);
                end;

                if v.ScriptEnabled ~= nil then
                    v103:SetAttribute("ScriptEnabled", v.ScriptEnabled == true);
                end;

                if v.ChainDepthLimit ~= nil then
                    local v104 = tonumber(v.ChainDepthLimit);
                    local v105;

                    if v104 then
                        local v106 = math.floor(v104);
                        v105 = math.clamp(v106, 1, 32);
                    else
                        v105 = 4;
                    end;

                    v103:SetAttribute("ChainDepthLimit", v105);
                end;

                if v.Collision ~= nil then
                    local Collision = v.Collision;
                    v103:SetAttribute("Collision", (type(Collision) ~= "string" or not u4[Collision]) and "Off" or Collision);
                end;

                if v.Bounciness ~= nil then
                    local v107 = tonumber(v.Bounciness);
                    v103:SetAttribute("Bounciness", not v107 and 0.7 or (v107 < 0 and 0 or (v107 > 1 and 1 or v107)));
                end;

                if v.Friction ~= nil then
                    local v108 = tonumber(v.Friction);
                    v103:SetAttribute("Friction", not v108 and 0.2 or (v108 < 0 and 0 or (v108 > 1 and 1 or v108)));
                end;

                if v.Spin ~= nil then
                    local v109 = tonumber(v.Spin);
                    v103:SetAttribute("Spin", not v109 and 0.5 or (v109 < 0 and 0 or (v109 > 2 and 2 or v109)));
                end;

                if v.HitCheckInterval ~= nil then
                    local v110 = tonumber(v.HitCheckInterval);
                    v103:SetAttribute("HitCheckInterval", not v110 and 0 or (v110 < 0 and 0 or (v110 > 0.5 and 0.5 or v110)));
                end;

                if v.ImportedUntrusted == true then
                    v103:SetAttribute("ImportedUntrusted", true);
                else
                    v103:SetAttribute("ImportedUntrusted", nil);
                end;

                local EmitTarget = v103:FindFirstChild("EmitTarget");

                if EmitTarget and (EmitTarget:IsA("ObjectValue") and v.EmitTargetPresent) then
                    EmitTarget.Value = v.EmitTargetValue;
                end;

                local Module = v103:FindFirstChild("Module");

                if Module and (Module:IsA("ModuleScript") and v.ModuleSource ~= nil) then
                    Module.Source = v.ModuleSource;
                end;

                v102 = true;
            end;
        end;
    end;

    return v102;
end;

return u1;