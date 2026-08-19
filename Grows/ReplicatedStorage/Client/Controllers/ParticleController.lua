-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local u1 = Random.new();
local Knit = require(ReplicatedStorage.Packages.Knit);
local VoxelParticleInfo = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Info"):WaitForChild("VoxelParticleInfo"));
local _ = Players.LocalPlayer;
local Particles = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Particles");
local v2 = Knit.CreateController({
    Name = "ParticleController"
});
local u3 = {};
local u4 = 1;

local function randomNumberInRange(p5) -- Line: 29
    -- upvalues: u1 (copy)
    if typeof(p5) == "number" then
        return p5;
    end;

    return p5.Min + u1:NextNumber() * (p5.Max - p5.Min);
end;

function v2.ComputePosition(p6, p7, p8, p9) -- Line: 41
    return p7 + Vector3.new(p8.X * p9, p8.Y * p9 - p9 ^ 2 * 32.699999999999996, p8.Z * p9);
end;

function v2.FindRelativeY(p10, p11, p12) -- Line: 45
    return p11.Y * p12 - p12 ^ 2 * 32.699999999999996;
end;

function v2.VoxelParticleAt(p13, p14, p15, p16) -- Line: 50
    -- upvalues: VoxelParticleInfo (copy), u4 (ref), u3 (copy), u1 (copy), TweenService (copy)
    local v17 = VoxelParticleInfo[p15];

    if v17 then
        for i = 1, p16 do
            local Part = Instance.new("Part", p13.ParticleFolder);
            Part.Name = i;
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CanTouch = false;
            Part.CanQuery = false;
            Part.TopSurface = Enum.SurfaceType.Smooth;
            Part.BottomSurface = Enum.SurfaceType.Smooth;
            Part.CastShadow = false;
            Part.CFrame = CFrame.new(p14);
            local v18 = u4;
            u4 = u4 + 1;
            u3[v18] = {};
            u3[v18].object = Part;
            local v19 = u3[v18];
            local lifetime = v17.lifetime;

            if typeof(lifetime) ~= "number" then
                lifetime = lifetime.Min + u1:NextNumber() * (lifetime.Max - lifetime.Min);
            end;

            v19.ogLife = lifetime;
            u3[v18].life = u3[v18].ogLife;
            u3[v18].originPos = p14;
            u3[v18].partType = p15;
            local start_tilts = v17.start_tilts;

            if typeof(start_tilts) ~= "number" then
                start_tilts = start_tilts.Min + u1:NextNumber() * (start_tilts.Max - start_tilts.Min);
            end;

            local v20 = math.rad(start_tilts);
            local v21 = NumberRange.new(0, 360);

            if typeof(v21) ~= "number" then
                v21 = v21.Min + u1:NextNumber() * (v21.Max - v21.Min);
            end;

            local v22 = math.rad(v21);
            local start_forces = v17.start_forces;

            if typeof(start_forces) ~= "number" then
                start_forces = start_forces.Min + u1:NextNumber() * (start_forces.Max - start_forces.Min);
            end;

            local v23 = (CFrame.Angles(0, v22, 0) * CFrame.Angles(v20, 0, 0)).LookVector * start_forces;
            u3[v18].startVelocity = v23;
            local start_sizes = v17.start_sizes;

            if typeof(start_sizes) ~= "number" then
                start_sizes = start_sizes.Min + u1:NextNumber() * (start_sizes.Max - start_sizes.Min);
            end;

            u3[v18].ogSize = start_sizes;
            Part.Size = Vector3.new(start_sizes, start_sizes, start_sizes);
            local v24 = u3[v18];
            local v25 = NumberRange.new(0, 360);

            if typeof(v25) ~= "number" then
                v25 = v25.Min + u1:NextNumber() * (v25.Max - v25.Min);
            end;

            v24.partRotation = math.rad(v25);
            Part.Color = v17.start_colors[u1:NextInteger(1, #v17.start_colors)];
            u3[v18].colorTween = TweenService:Create(Part, TweenInfo.new(u3[v18].ogLife), {
                Color = v17.end_colors[u1:NextInteger(1, #v17.end_colors)]
            });
            u3[v18].colorTween:Play();
        end;

        return;
    end;

    warn("INVALID PART TYPE");
end;

function v2.DestroyVoxelParticle(p26, p27) -- Line: 103
    -- upvalues: u3 (copy)
    if not u3[p27] then
        return;
    end;

    if u3[p27].object then
        u3[p27].object:Destroy();
    end;

    u3[p27] = nil;
end;

function v2.SetupParticleStepper(u28) -- Line: 109
    -- upvalues: RunService (copy), u3 (copy), VoxelParticleInfo (copy)
    local u29 = 0;
    RunService.RenderStepped:Connect(function(p30) -- Line: 111
        -- upvalues: u29 (ref), u3 (ref), u28 (copy), VoxelParticleInfo (ref)
        u29 = u29 + 1;

        for i, v in u3 do
            local v31 = v.life / v.ogLife;
            local v32 = v.ogLife - v.life;

            if v.object then
                v.life = v.life - p30;

                if v.life <= 0 then
                    u28:DestroyVoxelParticle(i);
                elseif v.partType == VoxelParticleInfo.DIRT.id then
                    local v33 = v.ogSize * v31;
                    v.object.Size = Vector3.new(v33, v33, v33);

                    if u28:FindRelativeY(v.startVelocity, v32) > 0 then
                        local v34 = CFrame.Angles(0, v.partRotation, 0);
                        local v35 = u28:ComputePosition(v.originPos, v.startVelocity, v32);
                        v.object:PivotTo(v34 + v35);
                    end;
                end;
            else
                u28:DestroyVoxelParticle(i);
            end;
        end;
    end);
end;

function v2.SimpleParticleAt(p36, p37, p38, p39) -- Line: 150
    -- upvalues: Particles (copy), Debris (copy)
    local v40 = Particles:FindFirstChild(p37);

    if not v40 then
        warn("particle not found " .. tostring(p37));

        return;
    end;

    local v41 = v40:Clone();
    v41.Anchored = true;
    Debris:AddItem(v41, p39);
    v41.Position = p38;
    v41.Parent = workspace;

    for _, descendant in v41:GetDescendants() do
        if descendant:IsA("ParticleEmitter") ~= false then
            descendant:Emit(descendant:GetAttribute("EmitCount"));
        end;
    end;
end;

function v2.KnitStart(p42) -- Line: 173
    p42.ParticleFolder = Instance.new("Folder", workspace);
    p42.ParticleFolder.Name = "VoxelParticles";
    p42:SetupParticleStepper();
end;

return v2;