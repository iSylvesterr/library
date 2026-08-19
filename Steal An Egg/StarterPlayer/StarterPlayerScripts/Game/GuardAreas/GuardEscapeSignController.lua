-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Areas = require(ReplicatedStorage.Directory.Areas);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Guards = require(ReplicatedStorage.Directory.Guards);
local GuardChasePolicy = require(ReplicatedStorage.Library.Modules.GuardAreas.GuardChasePolicy);
local GuardEscapePrediction = require(ReplicatedStorage.Library.Modules.GuardAreas.GuardEscapePrediction);
local ResolveGuardSpeedRequirement = require(ReplicatedStorage.Library.Functions.ResolveGuardSpeedRequirement);
require(script.Parent.Parent.Parent.GUI.GuardAreas.RequiredSpeedSign);
local SpeedPowerProjection = require(ReplicatedStorage.Library.Client.SpeedPowerProjection);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;
u1.__class = "GuardEscapeSignController";
local SeparationLine = Workspace.__OBJECTS.Areas.SeparationLine;
local v2 = SeparationLine:IsA("BasePart");
assert(v2, "Workspace.__OBJECTS.Areas.SeparationLine must be a BasePart");

function u1.new(p3, p4, p5) -- Line: 52
    -- upvalues: Asserts (copy), Areas (copy), Guards (copy), u1 (copy), SeparationLine (copy), TreadmillUtil (copy), SpeedPowerProjection (copy), GuardChasePolicy (copy), GuardEscapePrediction (copy), Trove (copy), ResolveGuardSpeedRequirement (copy)
    Asserts.Model(p3);
    Asserts.Vector3(p4);
    Asserts.table(p5);
    local v6 = Guards.Directory[Areas.Directory[p3.Name].GuardId];
    local Bounds = p3.Bounds;
    local ClosestExitPoint = p3.ClosestExitPoint;
    local v7 = Bounds:IsA("BasePart");
    local v8 = `{p3:GetFullName()}.Bounds must be a BasePart`;
    assert(v7, v8);
    local v9 = ClosestExitPoint:IsA("BasePart");
    local v10 = `{p3:GetFullName()}.ClosestExitPoint must be a BasePart`;
    assert(v9, v10);
    local u11 = setmetatable({}, u1);
    local v12 = -SeparationLine.CFrame.LookVector;
    u11._playerWalkSpeed = TreadmillUtil.SpeedPowerToWalkSpeed(SpeedPowerProjection.GetSpeedPower());
    u11._guardWalkSpeed = v6.WalkSpeed;
    u11._flatRadius = v6.FlatRadius;
    u11._guardHitDistance = GuardChasePolicy.ResolveHitDistance(v6.HitDistance);
    u11._exitDistance = GuardEscapePrediction.ResolveExitDistance(Bounds.CFrame, Bounds.Size, ClosestExitPoint.Position, v12);
    local v13 = {
        BaseGuardWalkSpeed = u11._guardWalkSpeed,
        ExitDirection = v12,
        ExitDistance = u11._exitDistance,
        FlatRadius = u11._flatRadius,
        GuardStartPosition = p4,
        HitDistance = u11._guardHitDistance,
        PlayerStartPosition = ClosestExitPoint.Position
    };
    u11._minimumEscapeWalkSpeed = GuardEscapePrediction.ResolvePlayerWalkSpeedRequirement(v13, 1);
    u11._requiredSpeedSign = p5;
    u11._trove = Trove.new();
    u11._requiredSpeedSign:SetSpeedPowerRequirement(ResolveGuardSpeedRequirement(v13));
    u11._trove:Add(SpeedPowerProjection.Changed:Connect(function(p14) -- Line: 91
        -- upvalues: u11 (copy), TreadmillUtil (ref)
        u11._playerWalkSpeed = TreadmillUtil.SpeedPowerToWalkSpeed(p14);
        u11:_render();
    end));
    u11:_render();

    return u11;
end;

function u1._render(p15) -- Line: 100
    -- upvalues: GuardEscapePrediction (copy)
    local v16 = GuardEscapePrediction.ResolveSlowdownTolerance(p15._minimumEscapeWalkSpeed, p15._playerWalkSpeed);
    p15._requiredSpeedSign:SetSlowdownTolerance(v16);
end;

function u1.Destroy(p17) -- Line: 110
    p17._trove:Destroy();
end;

return u1;