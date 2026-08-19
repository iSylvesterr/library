-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
game:GetService("Workspace");
local GrenadeParticles = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GrenadeParticles");
local InnerFire = GrenadeParticles:WaitForChild("InnerFire");
local OuterFire = GrenadeParticles:WaitForChild("OuterFire");
local u1 = {};

local function GetSurfaceCFrame(p2, p3) -- Line: 27
    local Unit = p3.Unit;

    if math.abs(Unit.Y) > 0.99 then
        return CFrame.new(p2);
    end;

    local v4;

    if math.abs(Unit.X) >= math.abs(Unit.Z) then
        v4 = Vector3.new(Unit.X, Unit.Y, 0).Unit;
    else
        v4 = Vector3.new(0, Unit.Y, Unit.Z).Unit;
    end;

    local v5 = Vector3.new(v4.X, 0, v4.Z);

    if v5.Magnitude < 0.01 then
        return CFrame.new(p2);
    end;

    local Unit2 = v5.Unit;
    local v6 = Vector3.new(Unit2.Z, 0, -Unit2.X);
    local Unit3 = v6:Cross(v4).Unit;

    return CFrame.fromMatrix(p2, v6, v4, -Unit3);
end;

local function CreateVoxel(p7, p8, p9, p10, p11, p12) -- Line: 63
    -- upvalues: InnerFire (copy), OuterFire (copy), GetSurfaceCFrame (copy)
    local v13 = (p11 and InnerFire or OuterFire):Clone();
    v13.Name = p11 and "InnerFireVoxel" or "OuterFireVoxel";
    v13.Size = Vector3.new(p8, 0.2, p9);
    v13.CFrame = GetSurfaceCFrame(p7, p10);
    v13.Anchored = true;
    v13.CanCollide = false;
    v13.CanQuery = false;
    v13.CanTouch = false;
    v13.CastShadow = false;
    v13.Parent = p12;

    for _, descendant in ipairs(v13:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true;
        end;
    end;

    return v13;
end;

local u14 = {};

function u14.Create(u15) -- Line: 104
    -- upvalues: u1 (copy), CreateVoxel (copy), TweenService (copy), u14 (copy)
    debug.profilebegin("VFX.VoxelFire.Create");
    local Folder = Instance.new("Folder");
    Folder.Name = "VoxelFire_" .. u15.FireId;
    Folder.Parent = workspace:WaitForChild("Debris");
    u1[u15.FireId] = Folder;
    debug.profilebegin("VFX.VoxelFire.Create.CalculateCenter");
    local v16 = Vector3.new(0, 0, 0);

    for _, v in ipairs(u15.Voxels) do
        v16 = v16 + v.Position;
    end;

    if #u15.Voxels > 0 then
        v16 = v16 / #u15.Voxels;
    end;

    debug.profileend();
    local identity = CFrame.identity;
    debug.profilebegin("VFX.VoxelFire.Create.CreateVoxels");
    local v17 = (1 / 0);
    local v18 = nil;
    local v19 = Vector3.new(0, 0, 0);

    for _, v in ipairs(u15.Voxels) do
        local v20 = (Vector3.new(v.Position.X, 0, v.Position.Z) - Vector3.new(v16.X, 0, v16.Z)).Magnitude <= 4;
        local v21 = CreateVoxel(v.Position, v.SizeX, v.SizeZ, v.Normal, v20, Folder);
        local Magnitude = (Vector3.new(v.Position.X, 0, v.Position.Z) - Vector3.new(u15.Position.X, 0, u15.Position.Z)).Magnitude;

        if Magnitude < v17 then
            v19 = v21.Size;
            identity = v21.CFrame;
            v18 = v21;
            v17 = Magnitude;
        end;
    end;

    debug.profileend();

    if v18 then
        debug.profilebegin("VFX.VoxelFire.Create.LandingBurstTween");
        local v22 = Vector3.new(v19.X, 10, v19.Z);
        local v23 = identity + identity.UpVector * ((v22.Y - v19.Y) / 2);
        v18.Size = v22;
        v18.CFrame = v23;
        TweenService:Create(v18, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = v19,
            CFrame = identity
        }):Play();
        debug.profileend();
    end;

    task.delay(u15.Duration, function() -- Line: 176
        -- upvalues: u1 (ref), u15 (copy), u14 (ref)
        if u1[u15.FireId] then
            u14.Destroy(u15.FireId);
        end;
    end);
    debug.profileend();
end;

function u14.Destroy(p24) -- Line: 184
    -- upvalues: u1 (copy)
    debug.profilebegin("VFX.VoxelFire.Destroy");
    local u25 = u1[p24];

    if u25 then
        for _, child in ipairs(u25:GetChildren()) do
            if child:IsA("BasePart") then
                for _, descendant in ipairs(child:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false;
                    end;
                end;
            end;
        end;

        task.delay(2, function() -- Line: 200
            -- upvalues: u25 (copy)
            if u25 and u25.Parent then
                u25:Destroy();
            end;
        end);
        u1[p24] = nil;
    end;

    debug.profileend();
end;

function u14.Update(u26) -- Line: 211
    -- upvalues: u1 (copy), CreateVoxel (copy)
    debug.profilebegin("VFX.VoxelFire.Update");
    local u27 = u1[u26.FireId];

    if not u27 then
        debug.profileend();

        return;
    end;

    for _, child in ipairs(u27:GetChildren()) do
        if child:IsA("BasePart") then
            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;
    end;

    task.delay(0.3, function() -- Line: 235
        -- upvalues: u27 (copy), u26 (copy), CreateVoxel (ref)
        debug.profilebegin("VFX.VoxelFire.Update.DelayedRebuild");

        if not (u27 and u27.Parent) then
            debug.profileend();

            return;
        end;

        for _, child in ipairs(u27:GetChildren()) do
            if child:IsA("BasePart") then
                child:Destroy();
            end;
        end;

        if #u26.Voxels == 0 then
            debug.profileend();

            return;
        end;

        local v28 = Vector3.new(0, 0, 0);

        for _, v in ipairs(u26.Voxels) do
            v28 = v28 + v.Position;
        end;

        local v29 = v28 / #u26.Voxels;

        for _, v in ipairs(u26.Voxels) do
            local v30 = (Vector3.new(v.Position.X, 0, v.Position.Z) - Vector3.new(v29.X, 0, v29.Z)).Magnitude <= 4;
            CreateVoxel(v.Position, v.SizeX, v.SizeZ, v.Normal, v30, u27);
        end;

        debug.profileend();
    end);
    debug.profileend();
end;

function u14.DestroyAll() -- Line: 277
    -- upvalues: u1 (copy)
    debug.profilebegin("VFX.VoxelFire.DestroyAll");

    for i, v in pairs(u1) do
        if v and v.Parent then
            v:Destroy();
        end;

        u1[i] = nil;
    end;

    debug.profileend();
end;

return u14;