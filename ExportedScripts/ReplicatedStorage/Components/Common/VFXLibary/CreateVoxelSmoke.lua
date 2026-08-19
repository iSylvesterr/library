-- Decompiled with Potassium's decompiler.

game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Smoke = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GrenadeParticles"):WaitForChild("Smoke");
local u1 = {
    Terrorists = Color3.fromRGB(185, 170, 145),
    ["Counter-Terrorists"] = Color3.fromRGB(155, 170, 190)
};
local _ = {
    Density = 1,
    Glare = 1,
    Haze = 2.5,
    Color = Color3.new(1, 1, 1),
    Decay = Color3.new(1, 1, 1)
};
local u2 = {};
local u3 = {};
local u4 = nil;

local function StartEmitterLoop() -- Line: 59
    -- upvalues: u4 (ref), RunServiceController (copy), u3 (copy)
    if u4 then
        return;
    end;

    u4 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 64
        -- upvalues: u3 (ref)
        local v5 = tick();

        for _, v in pairs(u3) do
            if v.voxel and (v.voxel.Parent and (v.isActive and not v.emissionStopped)) then
                if not v.lifetimeExtended then
                    v.lifetimeExtended = true;
                    v.activatedTime = v5;

                    for _, v2 in ipairs(v.emitters) do
                        if v2 and v2.Parent then
                            v2.Lifetime = NumberRange.new((1 / 0));
                        end;
                    end;
                end;

                local v6 = v5 - v.activatedTime;

                if v6 >= 0.8 then
                    v.emissionStopped = true;
                elseif 0.1 + 0.30000000000000004 * (v6 / 0.8) <= v5 - v.lastEmitTime then
                    v.lastEmitTime = v5;
                    v.totalParticlesEmitted = v.totalParticlesEmitted + #v.emitters * 1;

                    for _, v2 in ipairs(v.emitters) do
                        if v2 and v2.Parent then
                            v2:Emit(1);
                        end;
                    end;
                end;
            end;
        end;
    end);
end;

local function StopEmitterLoop() -- Line: 126
    -- upvalues: u4 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function CreateVoxel(p7, p8, p9, p10) -- Line: 138
    -- upvalues: Smoke (copy), u3 (copy)
    local v11 = Smoke:Clone();
    v11.Name = "SmokeVoxel";
    v11.Size = Vector3.new(p8, p8, p8);
    v11.Position = p7;
    v11.Anchored = true;
    v11.CanCollide = false;
    v11.CanQuery = false;
    v11.CanTouch = false;
    v11.CastShadow = false;
    v11.Parent = p9;
    local v12 = p8 / 4;
    local v13 = {};

    for _, descendant in ipairs(v11:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local v14 = {};

            for _, v in ipairs(descendant.Size.Keypoints) do
                table.insert(v14, NumberSequenceKeypoint.new(v.Time, v.Value * v12, v.Envelope * v12));
            end;

            descendant.Size = NumberSequence.new(v14);

            if p10 then
                descendant.Color = ColorSequence.new(p10);
            end;

            descendant.Enabled = false;
            table.insert(v13, descendant);
        end;
    end;

    for _, child in ipairs(v11:GetChildren()) do
        if child:IsA("BillboardGui") then
            child:Destroy();
        end;
    end;

    u3[v11] = {
        emitConnection = nil,
        isActive = false,
        lastEmitTime = 0,
        lifetimeExtended = false,
        activatedTime = 0,
        emissionStopped = false,
        totalParticlesEmitted = 0,
        voxel = v11,
        emitters = v13,
        scaleFactor = v12,
        teamColor = p10
    };

    return v11;
end;

local function DeploySmoke(p15, p16) -- Line: 209
    -- upvalues: u4 (ref), RunServiceController (copy), u3 (copy)
    debug.profilebegin("VFX.VoxelSmoke.DeploySmoke");
    local v17 = p15:GetChildren();

    if #v17 == 0 then
        debug.profileend();

        return;
    end;

    local v18 = Vector3.new(0, 0, 0);
    local v19 = {};

    for _, v in ipairs(v17) do
        if v:IsA("BasePart") then
            v18 = v18 + v.Position;
            table.insert(v19, v);
        end;
    end;

    if #v19 == 0 then
        debug.profileend();

        return;
    end;

    local v20 = v18 / #v19;
    local v21 = 0;

    for _, v in ipairs(v19) do
        local Magnitude = (v.Position - v20).Magnitude;

        if v21 < Magnitude then
            v21 = Magnitude;
        end;
    end;

    local v22 = v21 == 0 and 1 or v21;

    if not u4 then
        u4 = RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function() -- Line: 64
            -- upvalues: u3 (ref)
            local v23 = tick();

            for _, v in pairs(u3) do
                if v.voxel and (v.voxel.Parent and (v.isActive and not v.emissionStopped)) then
                    if not v.lifetimeExtended then
                        v.lifetimeExtended = true;
                        v.activatedTime = v23;

                        for _, v2 in ipairs(v.emitters) do
                            if v2 and v2.Parent then
                                v2.Lifetime = NumberRange.new((1 / 0));
                            end;
                        end;
                    end;

                    local v24 = v23 - v.activatedTime;

                    if v24 >= 0.8 then
                        v.emissionStopped = true;
                    elseif 0.1 + 0.30000000000000004 * (v24 / 0.8) <= v23 - v.lastEmitTime then
                        v.lastEmitTime = v23;
                        v.totalParticlesEmitted = v.totalParticlesEmitted + #v.emitters * 1;

                        for _, v2 in ipairs(v.emitters) do
                            if v2 and v2.Parent then
                                v2:Emit(1);
                            end;
                        end;
                    end;
                end;
            end;
        end);
    end;

    for _, v in ipairs(v19) do
        task.delay((v.Position - v20).Magnitude / v22 * p16, function() -- Line: 258
            -- upvalues: v (copy), u3 (ref)
            if not v.Parent then
                return;
            end;

            local v25 = u3[v];

            if v25 then
                v25.isActive = true;
            end;
        end);
    end;

    debug.profileend();
end;

local function FadeOutSmoke(u26) -- Line: 272
    -- upvalues: u3 (copy), u4 (ref)
    debug.profilebegin("VFX.VoxelSmoke.FadeOutSmoke");
    local u27 = u26:GetChildren();

    for _, v in ipairs(u27) do
        if v:IsA("BasePart") then
            local v28 = u3[v];

            if v28 then
                v28.isActive = false;

                for _, v2 in ipairs(v28.emitters) do
                    if v2 and v2.Parent then
                        v2.Enabled = false;
                    end;
                end;
            end;
        end;
    end;

    task.delay(6, function() -- Line: 293
        -- upvalues: u27 (copy), u3 (ref), u4 (ref), u26 (copy)
        debug.profilebegin("VFX.VoxelSmoke.FadeOutSmoke.DelayedCleanup");

        for _, v in ipairs(u27) do
            if v:IsA("BasePart") then
                u3[v] = nil;
                v:Destroy();
            end;
        end;

        local v29 = false;

        for _, _ in pairs(u3) do
            v29 = true;
            break;
        end;

        if not v29 and u4 then
            u4:Disconnect();
            u4 = nil;
        end;

        if u26 and u26.Parent then
            u26:Destroy();
        end;

        debug.profileend();
    end);
    debug.profileend();
end;

return {
    Create = function(u30) -- Line: 327, Name: Create
        -- upvalues: Workspace (copy), u2 (copy), u1 (copy), CreateVoxel (copy), DeploySmoke (copy), FadeOutSmoke (copy)
        debug.profilebegin("VFX.VoxelSmoke.Create");
        local Folder = Instance.new("Folder");
        Folder.Name = "VoxelSmoke_" .. u30.SmokeId;
        Folder.Parent = Workspace:WaitForChild("Debris");
        u2[u30.SmokeId] = Folder;
        local v31 = u30.Team and u1[u30.Team];
        debug.profilebegin("VFX.VoxelSmoke.Create.CreateVoxels");

        for _, v in ipairs(u30.Voxels) do
            CreateVoxel(v.Position, v.Size, Folder, v31);
        end;

        debug.profileend();
        DeploySmoke(Folder, u30.DeployTime);
        task.delay(u30.Duration, function() -- Line: 351
            -- upvalues: u2 (ref), u30 (copy), FadeOutSmoke (ref), Folder (copy)
            if u2[u30.SmokeId] then
                FadeOutSmoke(Folder);
                u2[u30.SmokeId] = nil;
            end;
        end);
        debug.profileend();
    end,

    Destroy = function(p32) -- Line: 360, Name: Destroy
        -- upvalues: u2 (copy), FadeOutSmoke (copy)
        debug.profilebegin("VFX.VoxelSmoke.Destroy");
        local v33 = u2[p32];

        if v33 then
            FadeOutSmoke(v33);
            u2[p32] = nil;
        end;

        debug.profileend();
    end,

    DestroyAll = function() -- Line: 370, Name: DestroyAll
        -- upvalues: u2 (copy), u3 (copy), u4 (ref)
        debug.profilebegin("VFX.VoxelSmoke.DestroyAll");

        for i, v in pairs(u2) do
            for _, child in ipairs(v:GetChildren()) do
                if child:IsA("BasePart") then
                    u3[child] = nil;
                    child:Destroy();
                end;
            end;

            v:Destroy();
            u2[i] = nil;
        end;

        local v34 = false;

        for _, _ in pairs(u3) do
            v34 = true;
            break;
        end;

        if not v34 and u4 then
            u4:Disconnect();
            u4 = nil;
        end;

        debug.profileend();
    end,

    Disrupt = function(p35, p36, p37) -- Line: 396, Name: Disrupt
        -- upvalues: u2 (copy), u3 (copy), Smoke (copy)
        debug.profilebegin("VFX.VoxelSmoke.Disrupt");

        for _, v in pairs(u2) do
            for _, child in ipairs(v:GetChildren()) do
                if child:IsA("BasePart") and p36 >= (child.Position - p35).Magnitude then
                    local u38 = u3[child];

                    if u38 and u38.isActive then
                        u38.isActive = false;
                        local scaleFactor = u38.scaleFactor;

                        for _, v2 in ipairs(u38.emitters) do
                            if v2 and v2.Parent then
                                v2:Destroy();
                            end;
                        end;

                        u38.emitters = {};
                        local teamColor = u38.teamColor;
                        task.delay(p37, function() -- Line: 425
                            -- upvalues: u38 (copy), u3 (ref), child (copy), Smoke (ref), scaleFactor (copy), teamColor (copy)
                            debug.profilebegin("VFX.VoxelSmoke.Disrupt.RestoreEmitters");

                            if not (u38 and u3[child]) then
                                debug.profileend();

                                return;
                            end;

                            if not (child and child.Parent) then
                                debug.profileend();

                                return;
                            end;

                            local v39 = {};

                            for _, descendant in ipairs(Smoke:GetDescendants()) do
                                if descendant:IsA("ParticleEmitter") then
                                    local v40 = descendant:Clone();
                                    local v41 = {};

                                    for _, v2 in ipairs(v40.Size.Keypoints) do
                                        table.insert(v41, NumberSequenceKeypoint.new(v2.Time, v2.Value * scaleFactor, v2.Envelope * scaleFactor));
                                    end;

                                    v40.Size = NumberSequence.new(v41);

                                    if teamColor then
                                        v40.Color = ColorSequence.new(teamColor);
                                    end;

                                    v40.Enabled = false;
                                    v40.Parent = child;
                                    table.insert(v39, v40);
                                end;
                            end;

                            u38.emitters = v39;
                            u38.lastEmitTime = 0;
                            u38.isActive = true;
                            u38.lifetimeExtended = false;
                            u38.activatedTime = 0;
                            u38.emissionStopped = false;
                            u38.totalParticlesEmitted = 0;
                            debug.profileend();
                        end);
                    end;
                end;
            end;
        end;

        debug.profileend();
    end,

    GetActiveVoxelCount = function() -- Line: 481, Name: GetActiveVoxelCount
        -- upvalues: u3 (copy)
        local v42 = 0;

        for _, _ in pairs(u3) do
            v42 = v42 + 1;
        end;

        return v42;
    end
};