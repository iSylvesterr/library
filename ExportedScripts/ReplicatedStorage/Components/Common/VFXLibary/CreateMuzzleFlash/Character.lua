-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam);
local Debris = workspace:WaitForChild("Debris");
local u1 = {};

local function getEmitterConfigs(u2) -- Line: 38
    -- upvalues: u1 (copy)
    local v3 = u1[u2];

    if v3 then
        return v3;
    end;

    local v4 = {};

    for _, descendant in ipairs(u2:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local v5 = {
                Emitter = descendant,
                Delay = descendant:GetAttribute("EmitDelay") or 0,
                Count = descendant:GetAttribute("EmitCount") or 1
            };
            table.insert(v4, v5);
        end;
    end;

    u1[u2] = v4;
    u2.Destroying:Once(function() -- Line: 56
        -- upvalues: u1 (ref), u2 (copy)
        u1[u2] = nil;
    end);

    return v4;
end;

local function emitParticle(u6) -- Line: 63
    local Emitter = u6.Emitter;

    if u6.Delay > 0 then
        task.delay(u6.Delay, function() -- Line: 66
            -- upvalues: Emitter (copy), u6 (copy)
            if Emitter.Parent then
                Emitter:Emit(u6.Count);
            end;
        end);

        return;
    end;

    if Emitter.Parent then
        Emitter:Emit(u6.Count);
    end;
end;

function executeMuzzleFlash(p7, p8)
    -- upvalues: getEmitterConfigs (copy)
    debug.profilebegin("VFX.MuzzleFlash.Character.Execute");
    local v9 = p7:FindFirstChild(p8);

    if not v9 then
        debug.profileend();

        return nil;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Character.EmitParticles");

    for _, v in ipairs((getEmitterConfigs(v9))) do
        local Emitter = v.Emitter;

        if v.Delay > 0 then
            task.delay(v.Delay, function() -- Line: 66
                -- upvalues: Emitter (copy), v (copy)
                if Emitter.Parent then
                    Emitter:Emit(v.Count);
                end;
            end);
        elseif Emitter.Parent then
            Emitter:Emit(v.Count);
        end;
    end;

    debug.profileend();
    debug.profileend();

    return p7.Position;
end;

local function dlog(p10, ...) -- Line: 99
    -- upvalues: DebugFlags (copy)
    if not DebugFlags.IsEnabled("WeaponFX") then
        return;
    end;

    warn(("[WeaponFX][MuzzleFlash.Character] " .. p10):format(...));
end;

local function tryCreate(u11, u12, u13, u14, u15, u16) -- Line: 106
    -- upvalues: Players (copy), dlog (copy), GetWeaponProperties (copy), Debris (copy), tryCreate (copy), CreateZeusBeam (copy)
    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate");
    local v17 = Players:FindFirstChild(u11);

    if not v17 then
        dlog("player not found username=%s weapon=%s attempt=%d", tostring(u11), tostring(u12), u15);
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.GetWeaponProperties");
    local v18 = GetWeaponProperties(u12);
    debug.profileend();

    if not v18 then
        dlog("weapon properties missing player=%s weapon=%s attempt=%d", v17.Name, tostring(u12), u15);
        debug.profileend();

        return;
    end;

    if not v17.Character then
        dlog("character missing player=%s weapon=%s attempt=%d", v17.Name, tostring(u12), u15);
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindWeaponModel");
    local v19 = Debris:FindFirstChild(v17.Name .. "_Weapon");
    debug.profileend();

    if not v19 then
        if u15 < 3 then
            task.delay(0.05, function() -- Line: 150
                -- upvalues: tryCreate (ref), u11 (copy), u12 (copy), u13 (copy), u14 (copy), u15 (copy), u16 (copy)
                tryCreate(u11, u12, u13, u14, u15 + 1, u16);
            end);
        end;

        dlog("missing %s_Weapon in Debris (retry=%s) player=%s weapon=%s attempt=%d", v17.Name, tostring(u15 < 3), v17.Name, tostring(u12), u15);
        debug.profileend();

        return;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindMuzzlePart");
    local Interactables = v19:FindFirstChild("Interactables");

    if not Interactables then
        if u15 < 3 then
            task.delay(0.05, function() -- Line: 170
                -- upvalues: tryCreate (ref), u11 (copy), u12 (copy), u13 (copy), u14 (copy), u15 (copy), u16 (copy)
                tryCreate(u11, u12, u13, u14, u15 + 1, u16);
            end);
        end;

        dlog("missing Interactables on %s_Weapon (retry=%s) player=%s weapon=%s attempt=%d", v17.Name, tostring(u15 < 3), v17.Name, tostring(u12), u15);
        debug.profileend();
        debug.profileend();

        return;
    end;

    local MuzzlePart = Interactables:FindFirstChild("MuzzlePart");

    if v18.ShootingOptions == "Dual" then
        MuzzlePart = Interactables:FindFirstChild("MuzzlePart" .. (u13 == "Left" and "L" or "R"));
    end;

    if not MuzzlePart then
        dlog("missing muzzle part player=%s weapon=%s shootingHand=%s attempt=%d", v17.Name, tostring(u12), tostring(u13), u15);
        debug.profileend();
        debug.profileend();

        return;
    end;

    debug.profileend();

    if v18.MuzzleType == "Zeus x27" then
        debug.profilebegin("VFX.MuzzleFlash.Character.CreateZeusBeam");
        CreateZeusBeam(MuzzlePart);
        debug.profileend();
    end;

    if u16 then
        debug.profileend();

        return;
    end;

    local v20 = u14 or v18.MuzzleType;

    if not v20 then
        debug.profileend();

        return;
    end;

    if not executeMuzzleFlash(MuzzlePart, v20) then
        dlog("executeMuzzleFlash failed player=%s weapon=%s override=%s attempt=%d", v17.Name, tostring(u12), tostring(u14), u15);
    end;

    debug.profileend();
end;

return function(p21, p22, p23, p24, p25) -- Line: 239
    -- upvalues: tryCreate (copy)
    tryCreate(p21, p22, p23, p24, 0, p25);
end;