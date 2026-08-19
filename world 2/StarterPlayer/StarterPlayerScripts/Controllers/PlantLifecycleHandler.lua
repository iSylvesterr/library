-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local EffectLoadManager = require(ReplicatedStorage.SharedModules.EffectLoadManager);
local u1 = {};
local v2 = {};
local u3 = {};

for _, v in SeedData do
    u1[v.SeedName] = v;
end;

local u4 = {};
local u5 = {};
local u6 = 0;

local function MarkHot(p7) -- Line: 51
    -- upvalues: u4 (copy), u5 (copy)
    if u4[p7] then
        u5[p7] = true;
    end;
end;

local function CacheOriginalColors(p8) -- Line: 58
    local v9 = {};

    for _, v in p8:QueryDescendants("BasePart") do
        v9[v] = v.Color;
    end;

    return v9;
end;

local function BindDescendantAddedListener(u10, p11) -- Line: 67
    if u10.DescendantAddedConn then
        u10.DescendantAddedConn:Disconnect();
        u10.DescendantAddedConn = nil;
    end;

    u10.DescendantAddedConn = p11.DescendantAdded:Connect(function(p12) -- Line: 72
        -- upvalues: u10 (copy)
        if not p12:IsA("BasePart") then
            return;
        end;

        local OriginalColors = u10.OriginalColors;

        if not OriginalColors or OriginalColors[p12] ~= nil then
            return;
        end;

        OriginalColors[p12] = p12.Color;
        u10.LastAppliedColorSig = nil;
    end);
end;

local function ApplyColors(p13, p14) -- Line: 82
    for i, v in p13 do
        if i.Parent then
            local v15, v16, v17 = Color3.toHSV(v);
            i.Color = Color3.fromHSV(v15, v16 * (1 - p14 * 0.75), v17);
        end;
    end;
end;

function v2.GetDecayAlpha(p18, p19, p20) -- Line: 96
    -- upvalues: u4 (copy), u1 (copy), ServerClock (copy)
    local v21 = u4[tostring(p19) .. "_" .. p20];

    if not v21 then
        return nil, false;
    end;

    local v22 = u1[v21.SeedName];

    if not (v22 and v22.PrimeTime) then
        return 0, true;
    end;

    if v21.Mutation or v22.AlwaysPrime then
        return 0, true;
    end;

    if v21.DisplayDecayAlpha ~= nil then
        return v21.DisplayDecayAlpha, true;
    end;

    local v23 = ServerClock.Now() - v21.PrimeStartedAt;

    if v23 < v22.PrimeTime then
        return 0, false;
    end;

    return math.clamp((v23 - v22.PrimeTime) / (v22.PrimeTime * 100), 0, 1) * (1 - (v21.ReviveProgress or 0)), false;
end;

local function SetLifecycle(p24, p25, p26, p27, p28, p29, p30) -- Line: 124
    -- upvalues: u1 (copy), u4 (copy), u5 (copy)
    local v31 = u1[p26];

    if not (v31 and v31.PrimeTime) then
        return;
    end;

    local v32 = tostring(p24) .. "_" .. p25;

    if u4[v32] then
        u4[v32].PrimeStartedAt = p27;
        u4[v32].SeedName = p26;
        u4[v32].ReviveProgress = p29 or (u4[v32].ReviveProgress or 0);
        u4[v32].ReviveProgressTarget = p29 or (u4[v32].ReviveProgressTarget or 0);
        u4[v32].Mutation = p30;

        if p28 then
            u4[v32].Model = p28;

            if not (u4[v32].OriginalColors and next(u4[v32].OriginalColors)) then
                local v33 = u4[v32];
                local v34 = {};

                for _, v in p28:QueryDescendants("BasePart") do
                    v34[v] = v.Color;
                end;

                v33.OriginalColors = v34;
                u4[v32].LastAppliedColorSig = nil;
            end;

            local u35 = u4[v32];

            if u35.DescendantAddedConn then
                u35.DescendantAddedConn:Disconnect();
                u35.DescendantAddedConn = nil;
            end;

            u35.DescendantAddedConn = p28.DescendantAdded:Connect(function(p36) -- Line: 72
                -- upvalues: u35 (copy)
                if not p36:IsA("BasePart") then
                    return;
                end;

                local OriginalColors = u35.OriginalColors;

                if not OriginalColors or OriginalColors[p36] ~= nil then
                    return;
                end;

                OriginalColors[p36] = p36.Color;
                u35.LastAppliedColorSig = nil;
            end);
        end;

        if u4[v32] then
            u5[v32] = true;
        end;

        return;
    end;

    if not p28 then
        return;
    end;

    local v37 = {};
    local v38 = {
        DisplayDecayAlpha = nil,
        PrimeStartedAt = p27,
        SeedName = p26,
        Model = p28
    };

    for _, v in p28:QueryDescendants("BasePart") do
        v37[v] = v.Color;
    end;

    v38.OriginalColors = v37;
    v38.ReviveProgress = p29 or 0;
    v38.ReviveProgressTarget = p29 or 0;
    v38.Mutation = p30;
    u4[v32] = v38;
    local u39 = u4[v32];

    if u39.DescendantAddedConn then
        u39.DescendantAddedConn:Disconnect();
        u39.DescendantAddedConn = nil;
    end;

    u39.DescendantAddedConn = p28.DescendantAdded:Connect(function(p40) -- Line: 72
        -- upvalues: u39 (copy)
        if not p40:IsA("BasePart") then
            return;
        end;

        local OriginalColors = u39.OriginalColors;

        if not OriginalColors or OriginalColors[p40] ~= nil then
            return;
        end;

        OriginalColors[p40] = p40.Color;
        u39.LastAppliedColorSig = nil;
    end);
end;

local function RemoveLifecycle(p41, p42) -- Line: 170
    -- upvalues: u4 (copy), u5 (copy)
    local v43 = tostring(p41) .. "_" .. p42;
    local v44 = u4[v43];

    if v44 then
        if v44.DescendantAddedConn then
            v44.DescendantAddedConn:Disconnect();
            v44.DescendantAddedConn = nil;
        end;

        if v44.OriginalColors then
            for i, v in v44.OriginalColors do
                if i.Parent then
                    i.Color = v;
                end;
            end;
        end;
    end;

    u4[v43] = nil;
    u5[v43] = nil;
end;

function v2.Init(p45) -- Line: 194
    -- upvalues: Networking (copy), RemoveLifecycle (copy), u4 (copy), u5 (copy), u3 (copy), Players (copy), EffectLoadManager (copy), u1 (copy), ApplyColors (copy), RunService (copy), ServerClock (copy), u6 (ref)
    Networking.Garden.PlantRemoved.OnClientEvent:Connect(function(p46, p47) -- Line: 196
        -- upvalues: RemoveLifecycle (ref)
        RemoveLifecycle(p46, p47);
    end);
    Networking.Garden.PlantReviveProgressUpdated.OnClientEvent:Connect(function(p48, p49, p50) -- Line: 201
        -- upvalues: u4 (ref), u5 (ref), u3 (ref)
        local v51 = tostring(p48) .. "_" .. p49;
        local v52 = u4[v51];

        if v52 then
            v52.ReviveProgressTarget = p50;

            if u4[v51] then
                u5[v51] = true;
            end;
        end;

        local v53 = u3[v51];

        if v53 then
            v53.ReviveProgress = p50;
        end;
    end);
    Networking.Garden.PlantMutationUpdated.OnClientEvent:Connect(function(p54, p55, p56) -- Line: 217
        -- upvalues: u4 (ref), u5 (ref)
        local v57 = tostring(p54) .. "_" .. p55;
        local v58 = u4[v57];

        if v58 then
            v58.Mutation = p56;
            v58.LastAppliedColorSig = nil;

            if u4[v57] then
                u5[v57] = true;
            end;
        end;
    end);

    local function StepEntry(p59, p60, p61, p62) -- Line: 235
        -- upvalues: u4 (ref), Players (ref), EffectLoadManager (ref), u1 (ref), ApplyColors (ref)
        if not (p60.Model and p60.Model.Parent) then
            if p60.DescendantAddedConn then
                p60.DescendantAddedConn:Disconnect();
                p60.DescendantAddedConn = nil;
            end;

            u4[p59] = nil;

            return false;
        end;

        if not Players.LocalPlayer:GetAttribute("PrimeEnabled") then
            return false;
        end;

        if not EffectLoadManager.DistanceIntervalMultiplier(p60.Model) then
            return false;
        end;

        if p60.Mutation then
            return false;
        end;

        local v63 = u1[p60.SeedName];

        if not (v63 and v63.PrimeTime) then
            return false;
        end;

        if v63.AlwaysPrime then
            return false;
        end;

        local PrimeTime = v63.PrimeTime;
        local v64 = PrimeTime * 100;
        local v65 = p62 - p60.PrimeStartedAt;
        local v66 = false;
        local v67;

        if PrimeTime <= v65 then
            local v68 = math.clamp((v65 - PrimeTime) / v64, 0, 1);
            local v69 = p60.ReviveProgressTarget or (p60.ReviveProgress or 0);
            local v70 = p60.ReviveProgress or 0;

            if v70 ~= v69 then
                if v70 < v69 then
                    p60.ReviveProgress = math.min(v70 + p61 * 0.5, v69);
                else
                    p60.ReviveProgress = math.max(v70 - p61 * 0.5, v69);
                end;

                v66 = p60.ReviveProgress ~= v69;
            end;

            v67 = v68 * (1 - (p60.ReviveProgress or 0));
        else
            v67 = 0;
        end;

        local v71 = false;
        local DisplayDecayAlpha = p60.DisplayDecayAlpha;

        if DisplayDecayAlpha == nil then
            p60.DisplayDecayAlpha = v67;
        else
            local v72 = v67 - DisplayDecayAlpha;

            if math.abs(v72) < 0.0001 then
                p60.DisplayDecayAlpha = v67;
            elseif math.abs(v72) < 0.01 then
                p60.DisplayDecayAlpha = v67;
            else
                p60.DisplayDecayAlpha = DisplayDecayAlpha + v72 * math.clamp(p61 / 1, 0, 1);
                v71 = true;
            end;
        end;

        local v73 = p60.DisplayDecayAlpha or 0;
        local v74 = math.floor(v73 * 1024 + 0.5);

        if p60.LastAppliedColorSig ~= v74 then
            p60.LastAppliedColorSig = v74;
            ApplyColors(p60.OriginalColors, v73);
        end;

        return v66 or v71;
    end;

    RunService.Heartbeat:Connect(function(p75) -- Line: 322
        -- upvalues: ServerClock (ref), u5 (ref), u4 (ref), StepEntry (copy), u6 (ref)
        debug.profilebegin("Controllers/PlantLifecycleHandler/Heartbeat");
        local v76 = ServerClock.Now();
        local v77 = os.clock();

        for i in u5 do
            local v78 = u4[i];

            if v78 then
                v78.LastSteppedAt = v77;

                if not StepEntry(i, v78, p75, v76) then
                    u5[i] = nil;
                end;
            else
                u5[i] = nil;
            end;
        end;

        u6 = u6 + p75;

        if u6 >= 0.25 then
            u6 = 0;

            for i, v in u4 do
                if not u5[i] then
                    local v79 = math.clamp(v77 - (v.LastSteppedAt or v77 - 0.25), 0, 1);
                    v.LastSteppedAt = v77;

                    if StepEntry(i, v, v79, v76) then
                        u5[i] = true;
                    end;
                end;
            end;
        end;

        debug.profileend();
    end);
end;

function v2.RegisterPlantModel(p80, p81, p82, p83, p84, p85, p86, p87) -- Line: 359
    -- upvalues: u1 (copy), u3 (copy), SetLifecycle (copy)
    if not p84 or p84 <= 0 then
        return;
    end;

    local v88 = u1[p83];

    if not (v88 and v88.PrimeTime) then
        return;
    end;

    local v89 = tostring(p81) .. "_" .. p82;

    if not p85 then
        u3[v89] = {
            SeedName = p83,
            PrimeStartedAt = p84,
            Mutation = p86,
            ReviveProgress = p87
        };

        return;
    end;

    local v90 = u3[v89];

    if v90 then
        p84 = math.max(p84, v90.PrimeStartedAt);
        p86 = p86 or v90.Mutation;
        p87 = p87 or v90.ReviveProgress;
        u3[v89] = nil;
    end;

    SetLifecycle(p81, p82, p83, p84, p85, p87, p86);
end;

function v2.UnregisterPlantModel(p91, p92, p93) -- Line: 386
    -- upvalues: RemoveLifecycle (copy)
    RemoveLifecycle(p92, p93);
end;

function v2.GetDecayAlphaByKey(p94, p95) -- Line: 391
    local v96, v97 = string.match(p95, "^(%d+)_(.+)$");

    if v96 and v97 then
        return p94:GetDecayAlpha(tonumber(v96), v97);
    end;

    return nil, false;
end;

function v2.GetActiveEntries(p98) -- Line: 397
    -- upvalues: u4 (copy)
    return u4;
end;

return v2;