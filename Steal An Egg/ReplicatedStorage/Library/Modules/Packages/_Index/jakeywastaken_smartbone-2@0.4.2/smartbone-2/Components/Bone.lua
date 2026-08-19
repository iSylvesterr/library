-- Decompiled with Potassium's decompiler.

local Dependencies = script.Parent.Parent:WaitForChild("Dependencies");
local Config = require(Dependencies:WaitForChild("Config"));
local Gizmo = require(Dependencies:WaitForChild("Gizmo"));
local Utilities = require(Dependencies:WaitForChild("Utilities"));

if game:GetService("RunService"):IsStudio() or Config.ALLOW_LIVE_GAME_DEBUG then
    Gizmo.Init();
end;

local Constraints = script.Parent:WaitForChild("Constraints");
local AxisConstraint = require(Constraints:WaitForChild("AxisConstraint"));
local CollisionConstraint = require(Constraints:WaitForChild("CollisionConstraint"));
local DistanceConstraint = require(Constraints:WaitForChild("DistanceConstraint"));
local FrictionConstraint = require(Constraints:WaitForChild("FrictionConstraint"));
local RopeConstraint = require(Constraints:WaitForChild("RopeConstraint"));
local RotationConstraint = require(Constraints:WaitForChild("RotationConstraint"));
local SpringConstraint = require(Constraints:WaitForChild("SpringConstraint"));
local SB_ASSERT_CB = Utilities.SB_ASSERT_CB;

local function SafeUnit(p1) -- Line: 25
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function IsNaN(p2) -- Line: 86
    return p2 ~= p2;
end;

local u3 = {};

local function QueryTransformedWorldCFrameNonSmartbone(p4) -- Line: 97
    -- upvalues: u3 (copy), QueryTransformedWorldCFrameNonSmartbone (copy)
    local v5 = u3[p4];

    if v5 and v5.Frame == shared.FrameCounter then
        return v5.CFrame;
    end;

    local Parent = p4.Parent;
    local v6;

    if Parent:IsA("Bone") then
        v6 = QueryTransformedWorldCFrameNonSmartbone(Parent);
    else
        v6 = Parent.CFrame;
    end;

    local v7 = v6 * p4.TransformedCFrame;
    u3[p4] = {
        Frame = shared.FrameCounter,
        CFrame = v7
    };

    return v7;
end;

local function QueryTransformedWorldCFrame(p8, p9) -- Line: 126
    -- upvalues: QueryTransformedWorldCFrameNonSmartbone (copy), QueryTransformedWorldCFrame (copy)
    p9.SolvedAnimatedCFrame = true;
    local ParentIndex = p9.ParentIndex;
    local Bone = p9.Bone;

    if ParentIndex < 1 then
        return QueryTransformedWorldCFrameNonSmartbone(Bone);
    end;

    local v10 = p8.Bones[ParentIndex];

    if not v10.SolvedAnimatedCFrame then
        v10.AnimatedWorldCFrame = QueryTransformedWorldCFrame(p8, v10);
    end;

    return v10.AnimatedWorldCFrame * Bone.TransformedCFrame;
end;

local function ClipVector(p11, p12, p13) -- Line: 151
    return p11 * (Vector3.new(1, 1, 1) - p13) + p12 * p13;
end;

local function GetFriction(p14, p15) -- Line: 157
    local CurrentPhysicalProperties = p14.CurrentPhysicalProperties;
    local CurrentPhysicalProperties2 = p15.CurrentPhysicalProperties;
    local FrictionWeight = CurrentPhysicalProperties.FrictionWeight;
    local FrictionWeight2 = CurrentPhysicalProperties2.FrictionWeight;

    return (CurrentPhysicalProperties.Friction * FrictionWeight + CurrentPhysicalProperties2.Friction * FrictionWeight2) / (FrictionWeight + FrictionWeight2);
end;

local function SolveWind(p16, u17, p18) -- Line: 170
    local Settings = u17.Settings;
    local WindType = Settings.WindType;

    if WindType ~= "Sine" and (WindType ~= "Noise" and WindType ~= "Hybrid") then
        return Vector3.new(0, 0, 0);
    end;

    local v19 = u17.WindOffset + (os.clock() - p16.HeirarchyLength * 0.2 + (p16.TransformOffset.Position - u17.Root.WorldPosition).Magnitude * 0.2) * Settings.WindInfluence;
    local WindSpeed = Settings.WindSpeed;
    local WindStrength = Settings.WindStrength;

    if WindSpeed == Vector3.new(0, 0, 0) or WindStrength == 0 then
        return Vector3.new(0, 0, 0);
    end;

    local WindDirection = Settings.WindDirection;
    local v20 = p18.Magnitude == 0 and Vector3.new(0, 0, 0) or p18.Unit;
    local v21 = v20:Dot(WindDirection);
    local v22 = 1 - math.abs(v21);

    if WindSpeed > 0 then
        if v20:Dot(WindDirection) > 0 then
            v22 = v22 * math.abs(1 - p18.Magnitude / WindSpeed);
        else
            v22 = v22 * (1 + p18.Magnitude / WindSpeed);
        end;
    end;

    local v23 = WindSpeed * v22;

    local function EaseInExpo(p24) -- Line: 225
        return p24 == 0 and 0 or 2 ^ (p24 * 10 - 10);
    end;

    local v25 = p18.Magnitude < 100 and p18.Magnitude or 100;
    local v26 = v25 == 0 and 0 or 2 ^ (v25 * 10 - 10);
    local u27 = v19 * math.max(v26, 1);
    local u28;

    if v23 < 1 then
        u28 = v23 * v26;
    else
        local v29 = v26 / 2;
        u28 = v23 * (v29 > 1 and v29 and v29 or 1);
    end;

    local v30 = nil;

    local function GetNoise(p31, p32, p33, p34) -- Line: 242
        local v35 = math.noise(p31, p32, p33);
        local v36 = math.clamp(v35, -1, 1);

        if p34 then
            v36 = v36 ^ 2;
        end;

        return v36;
    end;

    local function SampleGust() -- Line: 256
        -- upvalues: u27 (ref)
        return math.sin(u27 * 1) * 0.3 + 0.7;
    end;

    local function SampleSin() -- Line: 262
        -- upvalues: WindStrength (copy), u28 (ref), u27 (ref), WindDirection (copy)
        local v37 = WindStrength ^ 0.8;
        local v38 = u28 * 2;
        local v39 = math.sin(u27 * v37);
        local v40 = math.cos(u27 / 10 * v37);
        local v41 = math.sin(u27 * 2 * v37);
        local v42 = math.cos(u27 * 3 * v37);
        local v43 = (v39 + v40 + v41 + v42) / 4;
        local v44 = v43 * v38;
        local v45 = (v43 * 0.5 + 0.5) * v38;

        if v44 < v45 then
            v44 = v45 or v44;
        end;

        return WindDirection * v44;
    end;

    local function SampleNoise(p46, p47) -- Line: 282
        -- upvalues: WindStrength (copy), u28 (ref), u17 (copy), WindDirection (copy)
        local v48 = p46 or 0;
        local v49 = WindStrength ^ 0.8;
        local v50 = u28 * 2;
        local WindOffset = u17.WindOffset;
        local v51 = math.noise(v49, 0, WindOffset);
        local v52 = math.clamp(v51, -1, 1);

        if p47 then
            v52 = v52 ^ 2;
        end;

        local v53 = math.noise(0, v49, WindOffset);
        local v54 = math.clamp(v53, -1, 1);

        if p47 then
            v54 = v54 ^ 2;
        end;

        local v55 = math.noise(WindOffset, 0, v49);
        local v56 = math.clamp(v55, -1, 1);

        if p47 then
            v56 = v56 ^ 2;
        end;

        return WindDirection * Vector3.new(v52 * (v50 + v48), v54 * (v50 + v48), v56 * (v50 + v48));
    end;

    if Settings.WindType == "Sine" then
        v30 = SampleSin() * (math.sin(u27 * 1) * 0.3 + 0.7);
    elseif Settings.WindType == "Noise" then
        v30 = SampleNoise(0, true) * (math.sin(u27 * 1) * 0.3 + 0.7);
    elseif Settings.WindType == "Hybrid" then
        v30 = (SampleSin() * (math.sin(u27 * 1) * 0.3 + 0.7) + SampleNoise(0.5, true) * (math.sin(u27 * 1) * 0.3 + 0.7)) * 0.5;
    end;

    return v30 / (p16.FreeLength < 0.01 and 0.01 or p16.FreeLength) * (Settings.WindInfluence * (WindStrength * 0.01) * (math.clamp(p16.HeirarchyLength, 1, 10) * 0.1)) * p16.Weight;
end;

local u57 = {};
u57.__index = u57;

function u57.new(u58, p59, p60) -- Line: 469
    -- upvalues: u57 (copy), Utilities (copy)
    local v61 = u58.Parent:IsA("Bone") and u58.Parent.TransformedWorldCFrame or p60.CFrame;
    local v62 = {
        Bone = u58,
        FreeLength = -1,
        Weight = 0.7,
        ParentIndex = -1,
        HeirarchyLength = 0,
        Transform = u58.TransformedWorldCFrame:ToObjectSpace(v61):Inverse(),
        LocalTransform = u58.TransformedCFrame:ToObjectSpace(p59.TransformedCFrame):Inverse(),
        RootPart = p60,
        RootBone = p59,
        Radius = 0,
        Friction = 0,
        RotationLimit = 0,
        Force = nil,
        Gravity = nil,
        SolvedAnimatedCFrame = false,
        HasChild = false,
        AnimatedWorldCFrame = u58.TransformedWorldCFrame,
        StartingCFrame = u58.TransformedCFrame,
        TransformOffset = CFrame.identity,
        LocalTransformOffset = CFrame.identity,
        RestPosition = Vector3.new(0, 0, 0),
        CalculatedWorldCFrame = u58.TransformedWorldCFrame,
        Position = u58.TransformedWorldCFrame.Position,
        LastPosition = u58.TransformedWorldCFrame.Position,
        WeldPosition = Vector3.new(0, 0, 0),
        WeldCFrame = CFrame.identity,
        ActiveWeld = false,
        RigidWeld = false,
        Anchored = false,
        AxisLocked = { false, false, false },
        XAxisLimits = NumberRange.new((-1 / 0), (1 / 0)),
        YAxisLimits = NumberRange.new((-1 / 0), (1 / 0)),
        ZAxisLimits = NumberRange.new((-1 / 0), (1 / 0)),
        IsSkippingUpdates = false,
        CollisionHits = {},
        CollisionsData = {}
    };
    local u63 = setmetatable(v62, u57);
    u63.AttributeConnection = u58.AttributeChanged:Connect(function(p64) -- Line: 522
        -- upvalues: Utilities (ref), u58 (copy), u63 (copy)
        for i, v in Utilities.GatherBoneSettings(u58) do
            if v == "¬" or not v then
                local v = nil;
            end;

            u63[i] = v;
        end;
    end);

    return u63;
end;

function u57.ClipVelocity(p65, p66, p67) -- Line: 539
    p65.LastPosition = p65.LastPosition * (Vector3.new(1, 1, 1) - p67) + p66 * p67;
end;

function u57.PreUpdate(p68, p69) -- Line: 545
    -- upvalues: QueryTransformedWorldCFrameNonSmartbone (copy), QueryTransformedWorldCFrame (copy)
    local v70 = p69.Bones[1];
    local v71 = p69.Bones[p68.ParentIndex];
    p68.SolvedAnimatedCFrame = true;
    local ParentIndex = p68.ParentIndex;
    local Bone = p68.Bone;
    local v72;

    if ParentIndex < 1 then
        v72 = QueryTransformedWorldCFrameNonSmartbone(Bone);
    else
        local v73 = p69.Bones[ParentIndex];

        if not v73.SolvedAnimatedCFrame then
            v73.AnimatedWorldCFrame = QueryTransformedWorldCFrame(p69, v73);
        end;

        v72 = v73.AnimatedWorldCFrame * Bone.TransformedCFrame;
    end;

    p68.AnimatedWorldCFrame = v72;
    local SmartWeld = p68.Bone:FindFirstChild("SmartWeld");
    p68.ActiveWeld = false;

    if SmartWeld and SmartWeld:IsA("ObjectValue") then
        local Value = SmartWeld.Value;
        p68.RigidWeld = SmartWeld:GetAttribute("Rigid") == true;

        if Value then
            if Value:IsA("Attachment") then
                p68.WeldPosition = Value.WorldPosition;
                p68.WeldCFrame = Value.WorldCFrame;
                p68.ActiveWeld = true;
            elseif Value:IsA("BasePart") then
                p68.WeldPosition = Value.Position;
                p68.WeldCFrame = Value.CFrame;
                p68.ActiveWeld = true;
            end;
        end;
    end;

    if p68.ParentIndex < 1 then
        p68.Anchored = true;
    end;

    if p68.Bone == p68.RootBone then
        local v74;

        if p68.Bone.Parent:IsA("Bone") then
            v74 = QueryTransformedWorldCFrameNonSmartbone(p68.Bone.Parent);
        else
            v74 = p68.RootPart.CFrame;
        end;

        p68.TransformOffset = v74 * p68.Transform;
    else
        p68.TransformOffset = v71.AnimatedWorldCFrame * p68.Transform;
    end;

    p68.LocalTransformOffset = v70.Bone.CFrame * p68.LocalTransform;
end;

function u57.StepPhysics(p75, p76, p77, p78) -- Line: 606
    -- upvalues: SolveWind (copy)
    if p75.Anchored then
        p75.LastPosition = p75.AnimatedWorldCFrame.Position;
        p75.Position = p75.AnimatedWorldCFrame.Position;

        return;
    end;

    if p75.Force or p75.Gravity then
        p77 = ((p75.Gravity or p76.Settings.Gravity) + (p75.Force or p76.Settings.Force)) * p78;
    end;

    local Settings = p76.Settings;
    local v79 = p75.Position - p75.LastPosition;
    local v80 = p76.ObjectAcceleration * Settings.Inertia;
    local v81 = SolveWind(p75, p76, v79);
    p75.LastPosition = p75.Position;
    p75.Position = p75.Position + (v79 * (1 - Settings.Damping) + p77 + v80 + v81);
end;

function u57.Constrain(p82, p83, p84, p85) -- Line: 649
    -- upvalues: FrictionConstraint (copy), CollisionConstraint (copy), SpringConstraint (copy), DistanceConstraint (copy), RopeConstraint (copy), AxisConstraint (copy), RotationConstraint (copy)
    if p82.Anchored then
        return;
    end;

    local CFrame2 = p82.RootPart.CFrame;
    local v86 = FrictionConstraint(p82, p82.Position, p82.LastPosition);

    if #p84 ~= 0 then
        v86 = CollisionConstraint(p82, v86, p84);
    end;

    local v87;

    if p83.Settings.Constraint == "Spring" then
        v87 = SpringConstraint(p82, v86, nil, p83, p85);
    elseif p83.Settings.Constraint == "Distance" then
        v87 = DistanceConstraint(p82, v86, p83);
    elseif p83.Settings.Constraint == "Rope" then
        v87 = RopeConstraint(p82, v86, p83);
    else
        v87 = p82.AnimatedWorldCFrame.Position;
    end;

    local v88 = RotationConstraint(p82, AxisConstraint(p82, v87, p82.LastPosition, CFrame2), p83);

    if p82.ActiveWeld then
        if p82.RigidWeld then
            v88 = p82.WeldPosition;
        else
            v88 = SpringConstraint(p82, v88, p82.WeldPosition, p83, p85);
        end;
    end;

    p82.Friction = 0;

    for _, v in p82.CollisionHits do
        local CurrentPhysicalProperties = p82.RootPart.CurrentPhysicalProperties;
        local CurrentPhysicalProperties2 = v.CurrentPhysicalProperties;
        local FrictionWeight = CurrentPhysicalProperties.FrictionWeight;
        local FrictionWeight2 = CurrentPhysicalProperties2.FrictionWeight;
        local v89 = (CurrentPhysicalProperties.Friction * FrictionWeight + CurrentPhysicalProperties2.Friction * FrictionWeight2) / (FrictionWeight + FrictionWeight2);

        if v89 < p82.Friction then
            v89 = p82.Friction or v89;
        end;

        p82.Friction = v89;
    end;

    p82.Position = v88;
end;

function u57.SkipUpdate(p90) -- Line: 707
    -- upvalues: Config (copy)
    if p90.IsSkippingUpdates == false and Config.RESET_TRANSFORM_ON_SKIP then
        p90.CalculatedWorldCFrame = p90.AnimatedWorldCFrame;
        p90.IsSkippingUpdates = true;
    end;

    p90.LastPosition = p90.AnimatedWorldCFrame.Position + (p90.LastPosition - p90.Position);
    p90.Position = p90.AnimatedWorldCFrame.Position;
end;

function u57.SolveTransform(p91, p92, p93) -- Line: 722
    -- upvalues: Utilities (copy), SB_ASSERT_CB (copy)
    if p91.ParentIndex < 1 then
        return;
    end;

    p91.IsSkippingUpdates = false;
    local v94 = p92.Bones[p91.ParentIndex];
    local Bone = v94.Bone;

    if v94 and Bone then
        local TransformOffset = v94.TransformOffset;
        local v95 = Utilities.GetRotationBetween(TransformOffset.UpVector, p91.Position - v94.Position).Rotation * TransformOffset.Rotation;
        local v96 = math.min(1 - 0.00001 ^ p93, 1);

        if v94.ActiveWeld and v94.RigidWeld then
            v94.CalculatedWorldCFrame = v94.WeldCFrame;
        else
            v94.CalculatedWorldCFrame = Bone.WorldCFrame:Lerp(CFrame.new(v94.Position) * v95, v96);
        end;

        local Position = v94.CalculatedWorldCFrame.Position;
        SB_ASSERT_CB(Position == Position, warn, "If you see this report this as a bug, (NaN Calc world cframe)");
    end;
end;

function u57.ApplyTransform(p97, p98) -- Line: 769
    p97.SolvedAnimatedCFrame = false;

    if p97.ParentIndex < 1 then
        return;
    end;

    local v99 = p98.Bones[p97.ParentIndex];
    local Bone = v99.Bone;

    if v99 and Bone then
        if v99.Anchored and p98.Settings.AnchorsRotate == false then
            Bone.WorldCFrame = v99.TransformOffset;

            return;
        end;

        Bone.WorldCFrame = v99.CalculatedWorldCFrame;
    end;
end;

function u57.DrawDebug(p100, p101, p102, p103, p104, p105, p106) -- Line: 813
    -- upvalues: Gizmo (copy)
    local v107 = Color3.fromRGB(255, 0, 0);
    local v108 = Color3.fromRGB(255, 94, 0);
    local v109 = Color3.fromRGB(234, 1, 255);
    local v110 = Color3.fromRGB(0, 255, 255);
    local v111 = Color3.fromRGB(255, 0, 0);
    local v112 = Color3.fromRGB(0, 255, 0);
    local v113 = Color3.fromRGB(0, 0, 255);
    local v114 = Color3.fromRGB(0, 183, 255);
    local v115 = Color3.fromRGB(255, 0, 0);
    local v116 = Color3.fromRGB(0, 255, 0);
    local v117 = Color3.fromRGB(0, 0, 255);
    local v118 = Color3.fromRGB(28, 41, 224);
    local v119 = Color3.fromRGB(255, 27, 27);
    local v120 = 1;
    local AnimatedWorldCFrame = p100.AnimatedWorldCFrame;
    local Position = AnimatedWorldCFrame.Position;
    local v121 = CFrame.new(p100.Position);
    local v122 = CFrame.new(p100.LastPosition);

    if p104 then
        Gizmo.PushProperty("AlwaysOnTop", false);
        Gizmo.PushProperty("Color3", v107);
        Gizmo.Sphere:Draw(v121, p100.Radius, 10, 360);
        Gizmo.PushProperty("Color3", v108);
        Gizmo.Sphere:Draw(v122, p100.Radius, 10, 360);
        Gizmo.PushProperty("Color3", v109);
        Gizmo.Ray:Draw(p100.Position, p100.LastPosition);
    end;

    if p105 and not p100.Anchored then
        local v123 = p100.AxisLocked[1];
        local v124 = p100.AxisLocked[2];
        local v125 = p100.AxisLocked[3];
        local RootPart = p100.RootPart;
        local v126 = RootPart.CFrame:PointToObjectSpace(Position);
        local RightVector = RootPart.CFrame.RightVector;
        local UpVector = RootPart.CFrame.UpVector;
        local LookVector = RootPart.CFrame.LookVector;

        if not v123 then
            Gizmo.PushProperty("Color3", v115);
            Gizmo.Arrow:Draw(Position - RightVector * 2, Position + RightVector * 2, 0.05, 0.15, 9);
            local v127 = p100.XAxisLimits.Max - v126.X;
            Gizmo.Plane:Draw(Position + RightVector * (p100.XAxisLimits.Min - v126.X), RightVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position + RightVector * v127, RightVector, Vector3.new(5, 5, 0));
        end;

        if not v124 then
            Gizmo.PushProperty("Color3", v116);
            Gizmo.Arrow:Draw(Position - UpVector * 2, Position + UpVector * 2, 0.05, 0.15, 9);
            local v128 = p100.YAxisLimits.Max - v126.Y;
            Gizmo.Plane:Draw(Position + UpVector * (p100.YAxisLimits.Min - v126.Y), UpVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position + UpVector * v128, UpVector, Vector3.new(5, 5, 0));
        end;

        if not v125 then
            Gizmo.PushProperty("Color3", v117);
            Gizmo.Arrow:Draw(Position - LookVector * 2, Position + LookVector * 2, 0.05, 0.15, 9);
            local v129 = p100.ZAxisLimits.Max - v126.Z;
            Gizmo.Plane:Draw(Position - LookVector * (p100.ZAxisLimits.Min - v126.Z), LookVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position - LookVector * v129, LookVector, Vector3.new(5, 5, 0));
        end;
    end;

    if p103 then
        Gizmo.PushProperty("Color3", v110);
        Gizmo.Sphere:Draw(AnimatedWorldCFrame, 0.08, 5, 360);
        Gizmo.PushProperty("Color3", v111);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.LookVector * 0.25, 0.005, 0.015, 0.05, true);
        Gizmo.PushProperty("Color3", v112);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.UpVector * 0.25, 0.005, 0.015, 0.05, true);
        Gizmo.PushProperty("Color3", v113);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.RightVector * 0.25, 0.005, 0.015, 0.05, true);
    end;

    if p102 and not p100.Anchored then
        for _, v in p100.CollisionsData do
            Gizmo.PushProperty("Color3", v118);
            Gizmo.Sphere:Draw(CFrame.new(v.ClosestPoint), 0.08, 5, 360);
            Gizmo.PushProperty("Color3", v119);
            Gizmo.Arrow:Draw(v.ClosestPoint, v.ClosestPoint + v.Normal * 0.5, 0.05, 0.15, 9);
        end;
    end;

    if p106 and (p100.RotationLimit < 180 and (p100.RotationLimit > 0 and (p100.ParentIndex > 0 and p100.HasChild))) then
        local v130 = 1;
        local v131;

        if p100.RotationLimit < 89.5 then
            local v132 = math.rad(p100.RotationLimit);
            v131 = v120 * math.tan(v132);
        elseif p100.RotationLimit > 90 then
            local v133 = math.rad(180 - p100.RotationLimit);
            v131 = v120 * math.tan(v133);
            v130 = -1;
        else
            v131 = 5;
            v120 = 0;
        end;

        local v134 = math.min(v131, 5);
        local v135 = v134 == 5 and 0 or v120;
        local v136 = (p100.Position - p101.Bones[p100.ParentIndex].Position).Unit * v130;
        local v137 = CFrame.lookAt(Position + v136 * (v135 * 0.5), Position + -v136 * 500, AnimatedWorldCFrame.LookVector);
        Gizmo.PushProperty("Color3", v114);
        Gizmo.Cone:Draw(v137, v134, v135, 8 + v134 * 2);
    end;
end;

function u57.DrawOverlay(p138, p139) -- Line: 1039
    -- upvalues: Config (copy)
    p139.Text((`Bone: {p138.Bone.Name}`));

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_NUMERICS then
        p139.Text((`Free Length: {p138.FreeLength}`));
        p139.Text((`Weight: {p138.Weight}`));
        p139.Text((`Parent Index: {p138.ParentIndex}`));
        p139.Text((`Heirarchy Length: {p138.HeirarchyLength}`));
        p139.Text((`Radius: {p138.Radius}`));
        p139.Text((`Friction: {p138.Friction}`));
        p139.Text((`Rotation Limit: {p138.RotationLimit}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_CONSTRAIN then
        p139.Text((`Anchored: {p138.Anchored}`));
        p139.Text((`Axis Locked: {p138.AxisLocked[1]}, {p138.AxisLocked[2]}, {p138.AxisLocked[3]}`));
        p139.Text((`X Axis Limit: {p138.XAxisLimits}`));
        p139.Text((`Y Axis Limit: {p138.YAxisLimits}`));
        p139.Text((`Z Axis Limit: {p138.ZAxisLimits}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_WELD then
        p139.Text((`Active Weld: {p138.ActiveWeld}`));
        p139.Text((`Rigid Weld: {p138.RigidWeld}`));
        p139.Text((`Weld Position: {string.format("%.3f, %.3f, %.3f", p138.WeldPosition.X, p138.WeldPosition.Y, p138.WeldPosition.Z)}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_FORCES then
        local v140 = p138.Force and (string.format("%.3f, %.3f, %.3f", p138.Force.X, p138.Force.Y, p138.Force.Z) or "-, -, -") or "-, -, -";
        local v141 = p138.Gravity and string.format("%.3f, %.3f, %.3f", p138.Gravity.X, p138.Gravity.Y, p138.Gravity.Z) or "-, -, -";
        p139.Text((`Force: {v140}`));
        p139.Text((`Gravity: {v141}`));
    end;
end;

function u57.Destroy(p142) -- Line: 1085
    -- upvalues: Config (copy)
    if Config.RESET_BONE_ON_DESTROY then
        task.synchronize();
        p142.Bone.CFrame = p142.StartingCFrame;
    end;

    p142.AttributeConnection:Disconnect();
    setmetatable(p142, nil);
end;

return u57;