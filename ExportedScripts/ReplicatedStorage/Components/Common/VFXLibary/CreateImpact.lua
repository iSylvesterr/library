-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local Sound = require(ReplicatedStorage.Classes.Sound);
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local Materials = require(script.Components.Materials);
local Impacts = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Impacts");
local Debris = workspace:WaitForChild("Debris");
local u1 = {};
local u2 = {};

local function hasParticleEmitter(p3) -- Line: 44
    for _, descendant in ipairs(p3:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            return true;
        end;
    end;

    return false;
end;

local function getImpactTemplates(p4) -- Line: 53
    -- upvalues: u1 (copy), hasParticleEmitter (copy)
    local v5 = u1[p4];

    if v5 then
        return v5;
    end;

    local v6 = {};

    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("BasePart") and hasParticleEmitter(child) then
            v6[#v6 + 1] = child;
        end;
    end;

    u1[p4] = v6;

    return v6;
end;

local function resetImpactMarker(p7) -- Line: 69
    for _, descendant in ipairs(p7:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant:Clear();
        end;
    end;
end;

local function getImpactPool(p8) -- Line: 77
    -- upvalues: u2 (copy), ObjectPool (copy), resetImpactMarker (copy)
    local v9 = u2[p8];

    if v9 then
        return v9;
    end;

    local v10 = ObjectPool.new(p8, {
        InitialSize = 2,
        MaxRetained = 60,
        Reset = resetImpactMarker
    });
    u2[p8] = v10;

    return v10;
end;

local function createImpactMarker(p11) -- Line: 92
    -- upvalues: getImpactTemplates (copy), u2 (copy), ObjectPool (copy), resetImpactMarker (copy)
    debug.profilebegin("VFX.Impact.CreateImpactMarker");
    local v12 = getImpactTemplates(p11);

    if #v12 == 0 then
        debug.profileend();

        return nil, nil, nil;
    end;

    local v13 = v12[math.random(1, #v12)];
    local v14 = u2[v13];

    if not v14 then
        v14 = ObjectPool.new(v13, {
            InitialSize = 2,
            MaxRetained = 60,
            Reset = resetImpactMarker
        });
        u2[v13] = v14;
    end;

    local v15, v16 = v14:Acquire();
    v15.CollisionGroup = "Debris";
    v15.CanCollide = false;
    v15.CanQuery = false;
    v15.CanTouch = false;
    v15.Anchored = true;
    debug.profileend();

    return v15, v14, v16;
end;

local function IsHeadImpact(p17, p18) -- Line: 115
    if p18 ~= "Blood Splatter" or not (p17 and p17:IsA("BasePart")) then
        return false;
    end;

    local v19 = string.lower(p17.Name);

    return (v19 == "head" or (v19 == "headhitbox" or (v19 == "hitboxhead" or v19 == "headhb"))) and true or string.find(v19, "head", 1, true) ~= nil;
end;

return function(p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30) -- Line: 136
    -- upvalues: Impacts (copy), Materials (copy), IsHeadImpact (copy), Players (copy), HttpService (copy), FlashEffect (copy), DebugFlags (copy), Sound (copy), createImpactMarker (copy), Debris (copy)
    debug.profilebegin("VFX.Impact");
    local v31 = Impacts:FindFirstChild(Materials[p21] or p21);

    if v31 then
        local v32 = IsHeadImpact(p20, p21) or p29 ~= nil;
        local v33 = p29 == true;

        if p20 then
            debug.profilebegin("VFX.Impact.ResolveSound");
            local Name = v31.Name;

            if v32 then
                Name = "Headshot";

                if not p25 and p29 == nil then
                    local v34 = p20:FindFirstAncestorOfClass("Model");

                    if v34 and (v34:FindFirstChildOfClass("Humanoid") and v34:IsDescendantOf(workspace)) then
                        local v35 = Players:GetPlayerFromCharacter(v34);

                        if v35 and v35:IsDescendantOf(Players) then
                            local v36 = nil;
                            local u37 = v35:GetAttribute("Armor");
                            local v38;

                            if typeof(u37) == "string" and u37 ~= "" then
                                local v39;
                                v39, v38 = pcall(function() -- Line: 182
                                    -- upvalues: HttpService (ref), u37 (copy)
                                    return HttpService:JSONDecode(u37);
                                end);

                                if v39 then
                                    if typeof(v38) ~= "table" then
                                        v38 = v36;
                                    end;
                                else
                                    v38 = v36;
                                end;
                            else
                                v38 = v36;
                            end;

                            if v38 == nil then
                                v33 = false;
                            else
                                v33 = v38.Type == "Kevlar + Helmet";
                            end;
                        end;
                    end;
                end;

                if v33 then
                    Name = "Helmet Headshot";
                end;
            end;

            debug.profileend();

            if p24 then
                if DebugFlags.IsEnabled("WeaponFX") then
                    warn(("[WeaponFX][Client][ImpactSound] skipped (exit shot) material=%s pos=%s"):format(tostring(p21), (tostring(p22))));
                end;
            else
                debug.profilebegin("VFX.Impact.PlaySound");
                local v40 = FlashEffect.IsFlashed();
                local v41 = v40 and 0 or 1;

                if DebugFlags.IsEnabled("WeaponFX") then
                    warn(("[WeaponFX][Client][ImpactSound] play material=%s sound=%s pos=%s flashed=%s exit=%s melee=%s volumeMult=%s"):format(tostring(p21), tostring(Name), tostring(p22), tostring(v40), tostring(p24), tostring(p25), (tostring(v41))));
                end;

                Sound.new("Bullet"):PlaySoundAtPosition({
                    Class = "Bullet",
                    Position = p22,
                    Name = Name
                }, nil, v41, p26 == true, p28 == true);
                debug.profileend();
            end;
        end;

        if p21 == "Blood Splatter" and v33 then
            v31 = Impacts:FindFirstChild("Helmet Headshot") or v31;
        end;

        if v31 and (p21 == "Blood Splatter" or not p25) and p30 ~= true then
            local u42, u43, u44 = createImpactMarker(v31);

            if not (u42 and (u43 and u44)) then
                debug.profileend();

                return;
            end;

            debug.profilebegin("VFX.Impact.ParentMarker");

            if v32 and (p21 == "Blood Splatter" and (p20 and p20:IsA("BasePart"))) then
                u42.CFrame = CFrame.new(p20.Position, p20.Position + Vector3.new(0, 1, 0));
            else
                u42.CFrame = CFrame.new(p22, p22 + p23) + p23 * 0.1;
            end;

            u42.Parent = Debris;
            u42.Transparency = 1;
            debug.profileend();
            debug.profilebegin("VFX.Impact.EmitParticles");

            for _, descendant in ipairs(u42:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local v45 = descendant:GetAttribute("EmitDelay") or 0;
                    local u46 = descendant:GetAttribute("EmitCount") or 1;

                    if v45 <= 0 then
                        descendant:Emit(u46);
                    else
                        task.delay(v45, function() -- Line: 267
                            -- upvalues: u42 (copy), descendant (copy), u43 (copy), u44 (copy), u46 (copy)
                            if u42.Parent and (descendant.Parent and u43:IsAcquired(u42, u44)) then
                                descendant:Emit(u46);
                            end;
                        end);
                    end;
                end;
            end;

            debug.profileend();
            task.delay(5, function() -- Line: 281
                -- upvalues: u43 (copy), u42 (copy), u44 (copy)
                u43:Release(u42, u44);
            end);
        end;
    end;

    debug.profileend();
end;