-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local FootstepSoundsConfig = UtilsSystem.FootstepSoundsConfig;
assert(FootstepSoundsConfig, "FootstepSoundsConfig 未注册");
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3) -- Line: 52
    -- upvalues: u1 (copy)
    local v4 = setmetatable({}, u1);
    v4.humanoid = p2;
    v4.rootPart = p3;
    v4.lastMaterial = nil;
    v4.currentMaterial = nil;
    v4.raycastParams = RaycastParams.new();
    local v5 = {};
    local Characters = workspace:FindFirstChild("Characters");

    if Characters then
        table.insert(v5, Characters);
    end;

    v4.raycastParams.FilterDescendantsInstances = v5;
    v4.raycastParams.FilterType = Enum.RaycastFilterType.Exclude;
    v4.materialSoundPools = {};
    v4.landedSoundPools = {};
    v4.playingSounds = {};
    v4.heartbeatConnection = nil;
    v4.stepTimer = nil;
    v4.currentInterval = 0;
    v4.lastPlayTime = 0;
    v4.lastSpeedCheckTime = 0;
    v4.accumulatedDeltaTime = 0;
    v4.freefallStartHeight = nil;
    v4.isInFreefall = false;
    v4:StartMoveVectorDetection();

    return v4;
end;

function u1.GetOrCreateFootstepSound(u6, u7, u8) -- Line: 107
    -- upvalues: FootstepSoundsConfig (copy)
    if u7 == Enum.Material.Air then
        return nil;
    end;

    local rootPart = u6.rootPart;

    if not rootPart then
        return nil;
    end;

    if not u6.materialSoundPools[u7] then
        u6.materialSoundPools[u7] = {};
    end;

    if not u6.materialSoundPools[u7][u8] then
        u6.materialSoundPools[u7][u8] = {};
    end;

    local v9 = u6.materialSoundPools[u7][u8];
    local u10 = nil;

    for i, v in ipairs(v9) do
        if v and (v.Parent and not v.IsPlaying) then
            table.remove(v9, i);
            u10 = v;
            break;
        end;
    end;

    if not u10 then
        u10 = Instance.new("Sound");
        u10.Name = "Footstep_" .. tostring(u7);
        u10.Parent = rootPart;
        u10.Volume = 0.1 * (FootstepSoundsConfig.VolumeMultipliers[u7] or 1);
        u10.SoundGroup = game.SoundService.FootStep;
        u10.RollOffMaxDistance = 150;
        u10.RollOffMinDistance = 5;
        u10.RollOffMode = Enum.RollOffMode.Inverse;
        u10.Looped = false;
        u10.SoundId = u8;
        u10.Ended:Connect(function() -- Line: 156
            -- upvalues: u6 (copy), u10 (copy), u7 (copy), u8 (copy)
            for i, v in ipairs(u6.playingSounds) do
                if v == u10 then
                    table.remove(u6.playingSounds, i);
                    break;
                end;
            end;

            if u10 and u10.Parent then
                if u10.IsPlaying then
                    u10:Stop();
                end;

                table.insert(u6.materialSoundPools[u7][u8], u10);
            end;
        end);
    end;

    assert(u10);
    u10.PlaybackSpeed = 1;
    table.insert(u6.playingSounds, u10);

    return u10;
end;

function u1.PlayFootstepSound(p11) -- Line: 191
    -- upvalues: FootstepSoundsConfig (copy)
    local v12 = p11:GetGroundMaterial();

    if not v12 or v12 == Enum.Material.Air then
        return false;
    end;

    p11.lastMaterial = p11.currentMaterial;
    p11.currentMaterial = v12;
    local v13 = FootstepSoundsConfig.IntervalSounds[v12];

    if not v13 or #v13 == 0 then
        return false;
    end;

    local v14 = p11:GetOrCreateFootstepSound(v12, v13[math.random(1, #v13)]);

    if not v14 then
        return false;
    end;

    v14:Play();

    return true;
end;

function u1.GetGroundMaterial(p15) -- Line: 233
    if not p15.rootPart then
        return nil;
    end;

    local v16 = workspace:Raycast(p15.rootPart.Position, Vector3.new(0, -7, 0), p15.raycastParams);

    if v16 and v16.Material then
        return v16.Material;
    end;

    return nil;
end;

function u1.CalculateStepInterval(p17, p18) -- Line: 258
    local v19 = p18 >= 32;

    return (v19 and 0.33 or 0.5) * ((v19 and 36 or 15) / p18);
end;

function u1.StartMoveVectorDetection(u20) -- Line: 275
    -- upvalues: RunService (copy)
    if u20.heartbeatConnection then
        return;
    end;

    u20.lastPlayTime = 0;
    u20.currentInterval = 0;
    u20.lastSpeedCheckTime = 0;
    u20.accumulatedDeltaTime = 0;
    u20.heartbeatConnection = RunService.Heartbeat:Connect(function(p21) -- Line: 287
        -- upvalues: u20 (copy)
        u20:UpdateMoveVectorDetection(p21);
    end);
end;

function u1.UpdateMoveVectorDetection(p22, p23) -- Line: 297
    -- upvalues: Players (copy)
    if not (p22.humanoid and p22.rootPart) then
        return;
    end;

    p22.accumulatedDeltaTime = p22.accumulatedDeltaTime + p23;

    if p22.accumulatedDeltaTime < 0.03 then
        return;
    end;

    p22.accumulatedDeltaTime = 0;

    if Players.LocalPlayer then
        local CurrentCamera = workspace.CurrentCamera;

        if CurrentCamera and (CurrentCamera.CFrame.Position - p22.rootPart.Position).Magnitude > 200 then
            return;
        end;
    end;

    if p22.humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        p22.lastPlayTime = 0;

        return;
    end;

    local AssemblyLinearVelocity = p22.rootPart.AssemblyLinearVelocity;
    local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;

    if Magnitude < 4 then
        p22.lastPlayTime = 0;

        return;
    end;

    p22.currentInterval = p22:CalculateStepInterval(Magnitude);
    local v24 = time();

    if v24 - p22.lastPlayTime >= p22.currentInterval then
        p22:PlayFootstepSound();
        p22.lastPlayTime = v24;
    end;
end;

function u1.StopMoveVectorDetection(p25) -- Line: 368
    if p25.heartbeatConnection then
        p25.heartbeatConnection:Disconnect();
        p25.heartbeatConnection = nil;
    end;

    if p25.stepTimer then
        task.cancel(p25.stepTimer);
        p25.stepTimer = nil;
    end;
end;

function u1.GetOrCreateLandedSound(u26, u27, u28) -- Line: 387
    -- upvalues: FootstepSoundsConfig (copy)
    if u27 == Enum.Material.Air then
        return nil;
    end;

    local rootPart = u26.rootPart;

    if not rootPart then
        return nil;
    end;

    if not u26.landedSoundPools[u27] then
        u26.landedSoundPools[u27] = {};
    end;

    if not u26.landedSoundPools[u27][u28] then
        u26.landedSoundPools[u27][u28] = {};
    end;

    local v29 = u26.landedSoundPools[u27][u28];
    local u30 = nil;

    for i, v in ipairs(v29) do
        if v and (v.Parent and not v.IsPlaying) then
            table.remove(v29, i);
            u30 = v;
            break;
        end;
    end;

    if not u30 then
        u30 = Instance.new("Sound");
        u30.Name = "Landed_" .. tostring(u27);
        u30.Parent = rootPart;
        u30.SoundGroup = game.SoundService.FootStep;
        u30.Volume = 0.2 * (FootstepSoundsConfig.VolumeMultipliers[u27] or 1);
        u30.PlaybackSpeed = 1;
        u30.RollOffMaxDistance = 150;
        u30.RollOffMinDistance = 5;
        u30.RollOffMode = Enum.RollOffMode.Inverse;
        u30.Looped = false;
        u30.SoundId = u28;
        u30.Ended:Connect(function() -- Line: 437
            -- upvalues: u26 (copy), u30 (copy), u27 (copy), u28 (copy)
            for i, v in ipairs(u26.playingSounds) do
                if v == u30 then
                    table.remove(u26.playingSounds, i);
                    break;
                end;
            end;

            if u30 and u30.Parent then
                if u30.IsPlaying then
                    u30:Stop();
                end;

                table.insert(u26.landedSoundPools[u27][u28], u30);
            end;
        end);
    end;

    assert(u30);
    table.insert(u26.playingSounds, u30);

    return u30;
end;

function u1.RecordFreefallStart(p31) -- Line: 467
    if not p31.rootPart then
        return;
    end;

    p31.isInFreefall = true;
    p31.freefallStartHeight = p31.rootPart.Position.Y;
end;

function u1.ShouldPlayLandingEffect(p32) -- Line: 481
    return p32.isInFreefall and (p32.freefallStartHeight and p32.rootPart) and true or false;
end;

function u1.PlayLandingEffect(p33) -- Line: 494
    -- upvalues: FXUtil (copy)
    if not p33.rootPart then
        return false;
    end;

    local u34 = workspace:Raycast(p33.rootPart.Position, Vector3.new(0, -7, 0), p33.raycastParams);

    if not u34 then
        return false;
    end;

    if FXUtil then
        return pcall(function() -- Line: 513
            -- upvalues: FXUtil (ref), u34 (copy)
            FXUtil.PlayEffect("LandingEffect", CFrame.Angles(0, 0, 1.5707963267948966) + u34.Position, 3, 3);
        end);
    end;

    return false;
end;

function u1.UpdateLandedSoundByMaterial(p35) -- Line: 524
    -- upvalues: FootstepSoundsConfig (copy)
    local v36 = p35:GetGroundMaterial();

    if not v36 or v36 == Enum.Material.Air then
        p35.isInFreefall = false;
        p35.freefallStartHeight = nil;

        return false;
    end;

    if p35:ShouldPlayLandingEffect() then
        p35:PlayLandingEffect();
    end;

    local v37 = FootstepSoundsConfig.IntervalSounds[v36];

    if not v37 or #v37 == 0 then
        p35.isInFreefall = false;
        p35.freefallStartHeight = nil;

        return false;
    end;

    local v38 = p35:GetOrCreateLandedSound(v36, v37[math.random(1, #v37)]);

    if not v38 then
        p35.isInFreefall = false;
        p35.freefallStartHeight = nil;

        return false;
    end;

    v38:Play();
    p35.isInFreefall = false;
    p35.freefallStartHeight = nil;

    return true;
end;

function u1.Destroy(p39) -- Line: 577
    p39:StopMoveVectorDetection();

    for _, v in ipairs(p39.playingSounds) do
        if v and (v.Parent and v.IsPlaying) then
            v:Stop();
        end;
    end;

    for _, v in pairs(p39.materialSoundPools) do
        for _, v2 in pairs(v) do
            for _, v3 in ipairs(v2) do
                if v3 and v3.Parent then
                    v3:Destroy();
                end;
            end;
        end;
    end;

    for _, v in pairs(p39.landedSoundPools) do
        for _, v2 in pairs(v) do
            for _, v3 in ipairs(v2) do
                if v3 and v3.Parent then
                    v3:Destroy();
                end;
            end;
        end;
    end;

    p39.humanoid = nil;
    p39.rootPart = nil;
    p39.materialSoundPools = {};
    p39.landedSoundPools = {};
    p39.playingSounds = {};
    p39.currentMaterial = nil;
    p39.lastMaterial = nil;
    p39.freefallStartHeight = nil;
    p39.isInFreefall = false;
end;

return u1;