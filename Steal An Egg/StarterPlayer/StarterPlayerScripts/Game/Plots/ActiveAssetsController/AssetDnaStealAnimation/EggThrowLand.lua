-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AddDebris = require(ReplicatedStorage.Library.Functions.AddDebris);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Bezier = require(ReplicatedStorage.Library.Functions.Bezier);
local CreateParticleHost = require(ReplicatedStorage.Library.Functions.CreateParticleHost);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local Emit = require(ReplicatedStorage.Library.Functions.Emit);
local GetVisualYAxis = require(ReplicatedStorage.Library.Functions.GetVisualYAxis);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Config = require(script.Parent.Config);
local ExclusiveEggs = ReplicatedStorage.Assets.VFX.ExclusiveEggs;
local v1 = {};

local function autoControlPoint(p2, p3) -- Line: 27
    local v4 = (p2 + p3) * 0.5;
    local Magnitude = ((p2 - p3) * Vector3.new(1, 0, 1)).Magnitude;
    local X = v4.X;
    local v5 = math.max(p2.Y, p3.Y) + Magnitude * 0.5;

    return Vector3.new(X, v5, v4.Z);
end;

function v1.Play(u6, p7, u8, u9) -- Line: 37
    -- upvalues: Asserts (copy), GetVisualYAxis (copy), ExclusiveEggs (copy), Config (copy), Bezier (copy), RenderStepped (copy), Easing (copy), CreateParticleHost (copy), Emit (copy), AddDebris (copy)
    Asserts.Model(u6);
    Asserts.CFrame(p7);
    Asserts.CFrame(u8);
    Asserts.finite(u9);
    assert(u9 > 0, "Egg throw normal scale must be positive");
    local PrimaryPart = u6.PrimaryPart;
    Asserts.BasePart(PrimaryPart);
    local v10 = Vector3.new(0, 1, 0) * PrimaryPart.Size:Dot(GetVisualYAxis(PrimaryPart.CFrame)) * 0.5;
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "Bottom";
    Attachment.Position = -v10;
    Attachment.Parent = PrimaryPart;
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Name = "Top";
    Attachment2.Position = v10;
    Attachment2.Parent = PrimaryPart;
    local v11 = ExclusiveEggs.Trails.Default:Clone();
    local v12 = v11:IsA("Trail");
    assert(v12, "ExclusiveEggs default trail must be a Trail");
    v11.Attachment0 = Attachment;
    v11.Attachment1 = Attachment2;
    v11.Lifetime = Config.TrailLifetime;
    v11.Parent = PrimaryPart;
    u6:ScaleTo(Config.MinScale);
    u6:PivotTo(p7);
    local Rotation = p7.Rotation;
    local Rotation2 = u8.Rotation;
    local Position = p7.Position;
    local Position2 = p7.Position;
    local Position3 = u8.Position;
    local v13 = (Position2 + Position3) * 0.5;
    local Magnitude = ((Position2 - Position3) * Vector3.new(1, 0, 1)).Magnitude;
    local X = v13.X;
    local v14 = math.max(Position2.Y, Position3.Y) + Magnitude * 0.5;
    local u15 = Bezier(Position, Vector3.new(X, v14, v13.Z), u8.Position);
    RenderStepped(function(p16, p17) -- Line: 72
        -- upvalues: u6 (copy), Easing (ref), u15 (copy), Rotation (copy), Rotation2 (copy), Config (ref), u9 (copy)
        if u6.Parent == nil then
            return true;
        end;

        local v18 = Easing(p17, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
        u6:PivotTo(CFrame.new(u15(v18)) * Rotation:Lerp(Rotation2, v18));
        local v19 = Easing(p17, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        u6:ScaleTo((math.lerp(Config.MinScale, u9, v19)));

        return nil;
    end, Config.ThrowSeconds, true):Wait();

    if u6.Parent ~= nil then
        u6:ScaleTo(u9);
        u6:PivotTo(u8);
    end;

    local v20, v21 = CreateParticleHost(u8.Position);
    local _, v23 = Emit(v21, function(p22) -- Line: 88
        -- upvalues: Config (ref)
        p22.Lifetime = NumberRange.new(p22.Lifetime.Min * Config.ImpactLifetimeMultiplier, p22.Lifetime.Max * Config.ImpactLifetimeMultiplier);
    end, table.unpack(ExclusiveEggs.Particles.Impact.Default:GetChildren()));
    AddDebris(v20, v23);
    RenderStepped(function(p24, p25) -- Line: 96
        -- upvalues: u6 (copy), Easing (ref), u8 (copy), Config (ref)
        if u6.Parent == nil then
            return true;
        end;

        local v26 = 1 - Easing(p25, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
        u6:PivotTo(u8 + Vector3.new(0, 1, 0) * (Config.LandingBounceHeight * v26));

        return nil;
    end, Config.LandingBounceSeconds, true):Wait();

    if u6.Parent ~= nil then
        u6:PivotTo(u8);
    end;

    v11:Destroy();
    Attachment:Destroy();
    Attachment2:Destroy();
end;

return v1;