-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local VectorUtil = require(script.VectorUtil);
local Maid = require(script.Maid);

local function fromToRotation(p1, p2, p3) -- Line: 10
    local v4 = p1:Dot(p2);

    if v4 > 0.99999 then
        return CFrame.new();
    end;

    if v4 < -0.99999 then
        return CFrame.fromAxisAngle(p3, 3.141592653589793);
    end;

    return CFrame.fromAxisAngle(p1:Cross(p2), math.acos(v4) * 0.8);
end;

local function getRotationBetween(p5, p6, p7) -- Line: 24
    local v8 = p5:Dot(p6);
    local v9 = p5:Cross(p6);

    if v8 < -0.99999 then
        return CFrame.fromAxisAngle(p7, 3.141592653589793);
    end;

    return CFrame.new(0, 0, 0, v9.x, v9.y, v9.z, 1 + v8);
end;

local function rotateVectorAround(p10, p11, p12) -- Line: 35
    return CFrame.fromAxisAngle(p12, p11):VectorToWorldSpace(p10);
end;

local new = CFrame.new;
local lookAt = CFrame.lookAt;
Vector3.new();
local Motor6D = Instance.new("Motor6D");
local _ = {
    [Instance.new("Motor6D")] = {
        ConstraintType = "Hinge",
        UpperAngle = 45,
        LowerAngle = -45,
        AxisAttachment = nil,
        JointAttachment = nil
    },
    [Motor6D] = {
        ConstraintType = "BallSocketConstraint",
        UpperAngle = 45,
        TwistLimitsEnabled = false,
        TwistUpperAngle = 45,
        TwistLowerAngle = -45,
        AxisAttachment = nil,
        JointAttachment = nil
    }
};
local u13 = {};
u13.__index = u13;

function u13.new(p14, p15) -- Line: 66
    -- upvalues: u13 (copy), Maid (copy)
    local v16 = setmetatable({}, u13);
    v16.Maid = Maid.new();
    v16.Motor6DTable = p14;
    v16.Constraints = p15;
    local v17, v18 = v16:SetupJoints();
    v16.JointInfo = v17;
    v16.JointAxisInfo = v18;
    v16.EndEffector = p14[#p14].Part1:FindFirstChild("EndEffector");

    if not v16.EndEffector then
        local Attachment = Instance.new("Attachment");
        Attachment.Name = "EndEffector";
        Attachment.Parent = p14[#p14].Part1;
        v16.EndEffector = Attachment;
        v16.Maid:GiveTask(Attachment);
    end;

    v16.DebugMode = false;
    v16.LerpMode = true;
    v16.LerpAlpha = 0.9;
    v16.ConstantLerpSpeed = true;
    v16.AngularSpeed = 1.5707963267948966;
    v16.FootOrientationSystem = false;
    v16.FootRaycastParams = RaycastParams.new();
    v16.RaycastLengthDown = 50;
    v16._RayResultTable = {};
    v16.UseLastMotor = false;

    return v16;
end;

function u13.SetupJoints(p19) -- Line: 106
    local v20 = {};
    local v21 = {};

    for _, v in pairs(p19.Motor6DTable) do
        local Attachment = Instance.new("Attachment");
        Attachment.CFrame = v.C0;
        Attachment.Name = "JointPosition";
        Attachment.Parent = v.Part0;
        v20[v] = Attachment;
        p19.Maid:GiveTask(Attachment);

        if p19.Constraints then
            local v22 = p19.Constraints[v];

            if v22 then
                if v22.AxisAttachment then
                    if typeof(v22.AxisAttachment) == "string" then
                        v22.AxisAttachment = v.Part0:FindFirstChild(v22.AxisAttachment .. "AxisAttachment");
                    end;
                else
                    v22.AxisAttachment = v.Part0:FindFirstChild(v.Part0.Name .. "AxisAttachment");
                end;

                if v22.JointAttachment then
                    if typeof(v22.JointAttachment) == "string" then
                        v22.JointAttachment = v.Part1:FindFirstChild(v22.JointAttachment .. "JointAttachment");
                    end;
                else
                    v22.JointAttachment = v.Part1:FindFirstChild(v.Part0.Name .. "JointAttachment");
                end;
            end;
        end;
    end;

    return v20, v21;
end;

function u13.GetConstraints(p23) -- Line: 150
    if not p23.Constraints then
        p23.Constraints = {};
    end;

    for _, v in pairs(p23.Motor6DTable) do
        local Part0 = v.Part0;
        local v24 = Part0:FindFirstChildWhichIsA("HingeConstraint");
        local v25 = Part0:FindFirstChildWhichIsA("BallSocketConstraint");

        if v24 then
            p23.Constraints[v] = {
                ConstraintType = "Hinge",
                UpperAngle = v24.UpperAngle,
                LowerAngle = v24.LowerAngle,
                AxisAttachment = v24.Attachment0,
                JointAttachment = v24.Attachment1
            };
        elseif v25 then
            p23.Constraints[v] = {
                ConstraintType = "BallSocketConstraint",
                UpperAngle = v25.UpperAngle,
                TwistLimitsEnabled = v25.TwistLimitsEnabled,
                TwistUpperAngle = v25.TwistUpperAngle,
                TwistLowerAngle = v25.TwistLowerAngle,
                AxisAttachment = v25.Attachment0,
                JointAttachment = v25.Attachment1
            };
        end;
    end;
end;

function u13.GetConstraintsFromMotor(p26, p27, p28) -- Line: 183
    if not p26.Constraints then
        p26.Constraints = {};
    end;

    local v29 = p27.Part0:FindFirstChild(p28);

    if v29:IsA("HingeConstraint") then
        p26.Constraints[p27] = {
            ConstraintType = "Hinge",
            UpperAngle = v29.UpperAngle,
            LowerAngle = v29.LowerAngle,
            AxisAttachment = v29.Attachment0,
            JointAttachment = v29.Attachment1
        };

        return;
    end;

    if v29:IsA("BallSocketConstraint") then
        p26.Constraints[p27] = {
            ConstraintType = "BallSocketConstraint",
            UpperAngle = v29.UpperAngle,
            TwistLimitsEnabled = v29.TwistLimitsEnabled,
            TwistUpperAngle = v29.TwistUpperAngle,
            TwistLowerAngle = v29.TwistLowerAngle,
            AxisAttachment = v29.Attachment0,
            JointAttachment = v29.Attachment1
        };
    end;
end;

function u13._CCDIKIterateFoot(p30, p31) -- Line: 211
    -- upvalues: new (copy)
    local Constraints = p30.Constraints;
    local Motor6DTable = p30.Motor6DTable;
    local v32 = Motor6DTable[#Motor6DTable];
    v32.C0 = v32.C0 * v32.Transform;
    p30:OrientFootMotorToFloor(v32, p31);
    v32.Transform = new();
    local v33 = Constraints and Constraints[v32];

    if v33 then
        if v33.ConstraintType == "Hinge" then
            p30:RotateToHingeAxis(v32, v33);
        end;

        if v33.ConstraintType == "BallSocketConstraint" then
            p30:RotateToBallSocketConstraintAxis(v32, v33);
        end;
    end;
end;

function u13._CCDIKIterateStep(p34, p35, p36) -- Line: 233
    -- upvalues: new (copy)
    local Constraints = p34.Constraints;

    for i = #p34.Motor6DTable - 1 + (p34.UseLastMotor and 1 or 0), 1, -1 do
        local v37 = p34.Motor6DTable[i];
        v37.C0 = v37.C0 * v37.Transform;
        p34:RotateFromEffectorToGoal(v37, p35, p36);
        v37.Transform = new();

        if Constraints then
            local v38 = Constraints[v37];

            if v38 then
                if v38.ConstraintType == "Hinge" then
                    p34:RotateToHingeAxis(v37, v38);
                end;

                if v38.ConstraintType == "BallSocketConstraint" then
                    p34:RotateToBallSocketConstraintAxis(v37, v38);
                end;
            end;
        end;
    end;
end;

function u13.CCDIKIterateOnce(p39, p40, p41, p42) -- Line: 257
    if (p41 or 1) < (p39.EndEffector.WorldPosition - p40).Magnitude then
        p39:_CCDIKIterateStep(p40, p42);
    end;

    if p39.FootOrientationSystem then
        p39:_CCDIKIterateFoot(p42);
    end;
end;

function u13.CCDIKIterateOnceDebug(p43, p44, p45, p46) -- Line: 272
    p43:_CCDIKIterateStep(p44, p46);
end;

function u13.CCDIKIterateUntil(p47, p48, p49, p50, p51) -- Line: 284
    local v52 = 0;

    while (p49 or 1) < (p47.EndEffector.WorldPosition - p48).Magnitude and v52 <= (p50 or 10) do
        v52 = v52 + 1;
        p47:_CCDIKIterateStep(p48, p51);

        if p47.FootOrientationSystem then
            p47:_CCDIKIterateFoot(p51);
        end;
    end;
end;

local function worldCFrameToC0ObjectSpace(p53, p54) -- Line: 298
    local CFrame2 = p53.Part1.CFrame;
    local C1 = p53.C1;
    local C0 = p53.C0;
    local v55 = C0 * C1:Inverse() * CFrame2:Inverse() * p54 * C1;

    return v55 - v55.Position + C0.Position;
end;

local function calculateGoalFromToC0CFrame(p56, p57, p58, p59) -- Line: 307
    -- upvalues: fromToRotation (copy)
    local v60 = fromToRotation(p57, p58, p59);
    local CFrame2 = p56.Part1.CFrame;
    local C1 = p56.C1;
    local C0 = p56.C0;
    local v61 = C0 * C1:Inverse() * CFrame2:Inverse() * (v60 * CFrame2) * C1;

    return v61 - v61.Position + C0.Position;
end;

function u13.rotateJointFromTo(p62, p63, p64, p65) -- Line: 322
    -- upvalues: fromToRotation (copy)
    local v66 = fromToRotation(p63, p64, p65);
    local CFrame2 = p62.Part1.CFrame;
    local C1 = p62.C1;
    local C0 = p62.C0;
    local v67 = C0 * C1:Inverse() * CFrame2:Inverse() * (v66 * CFrame2) * C1;
    p62.C0 = v67 - v67.Position + C0.Position;
end;

local u68 = TweenInfo.new(0.1);

function u13.rotateJointFromToTween(p69, p70, p71, p72) -- Line: 327
    -- upvalues: fromToRotation (copy), TweenService (copy), u68 (copy)
    local v73 = fromToRotation(p70, p71, p72);
    local CFrame2 = p69.Part1.CFrame;
    local C1 = p69.C1;
    local C0 = p69.C0;
    local v74 = C0 * C1:Inverse() * CFrame2:Inverse() * (v73 * CFrame2) * C1;
    local v75 = TweenService:Create(p69, u68, {
        C0 = v74 - v74.Position + C0.Position
    });
    v75:Play();
    v75.Completed:Wait();
end;

function u13.rotateJointFromToWithLerp(p76, p77, p78, p79, p80, p81) -- Line: 335
    -- upvalues: fromToRotation (copy), VectorUtil (copy)
    local v82 = fromToRotation(p78, p79, p80);
    local CFrame2 = p77.Part1.CFrame;
    local C1 = p77.C1;
    local C0 = p77.C0;
    local v83 = C0 * C1:Inverse() * CFrame2:Inverse() * (v82 * CFrame2) * C1;
    local v84 = v83 - v83.Position + C0.Position;
    local LerpAlpha = p76.LerpAlpha;
    local C02 = p77.C0;

    if p81 and p76.ConstantLerpSpeed then
        local v85 = VectorUtil.AngleBetween(C02.LookVector, v84.LookVector);
        LerpAlpha = math.min(p81 * (p76.AngularSpeed / v85), 1);
    end;

    p77.C0 = C02:Lerp(v84, LerpAlpha);
end;

function u13.RotateFromEffectorToGoal(p86, p87, p88, p89) -- Line: 350
    local CFrame2 = p87.Part0.CFrame;
    local WorldPosition = p86.JointInfo[p87].WorldPosition;
    local WorldPosition2 = p86.EndEffector.WorldPosition;
    local Unit = (WorldPosition2 - WorldPosition).Unit;
    local Unit2 = (p88 - WorldPosition).Unit;

    if not p86.DebugMode then
        if p86.LerpMode == true then
            p86:rotateJointFromToWithLerp(p87, Unit, Unit2, CFrame2.RightVector, p89);

            return;
        end;

        p86.rotateJointFromTo(p87, Unit, Unit2, CFrame2.RightVector);

        return;
    end;

    p86.VisualizeVector(WorldPosition, WorldPosition2 - WorldPosition, BrickColor.Blue());
    p86.VisualizeVector(WorldPosition, p88 - WorldPosition, BrickColor.Red());
    p86.rotateJointFromToTween(p87, Unit, Unit2, CFrame2.UpVector);
end;

function u13.RotateToHingeAxis(p90, p91, p92) -- Line: 382
    local AxisAttachment = p92.AxisAttachment;
    local JointAttachment = p92.JointAttachment;
    p90.rotateJointFromTo(p91, JointAttachment.WorldAxis, AxisAttachment.WorldAxis, p91.Part0.CFrame.RightVector);
    local WorldCFrame = AxisAttachment.WorldCFrame;
    local v93 = p92.UpperAngle or 180;
    local v94 = p92.LowerAngle or -180;
    local v95, _, _ = WorldCFrame:ToObjectSpace(JointAttachment.WorldCFrame):ToEulerAnglesXYZ();
    local v96 = math.deg(v95);
    local v97 = math.clamp(v96, v94, v93);
    local v98 = math.rad(v97);
    local v99 = WorldCFrame:ToWorldSpace((CFrame.fromEulerAnglesXYZ(v98, 0, 0))) * JointAttachment.CFrame:Inverse();
    local CFrame2 = p91.Part1.CFrame;
    local C1 = p91.C1;
    local C0 = p91.C0;
    local v100 = C0 * C1:Inverse() * CFrame2:Inverse() * v99 * C1;
    p91.C0 = v100 - v100.Position + C0.Position;
end;

local function twistSwing(p101, p102) -- Line: 424
    local v103, v104 = p101:ToAxisAngle();
    local v105 = math.cos(v104 / 2);
    local v106 = (math.sin(v104 / 2) * v103):Dot(p102) * p102;
    local v107 = CFrame.new(p101.x, p101.y, p101.z, v106.x, v106.y, v106.z, v105);

    return v107:Inverse() * p101, v107;
end;

function u13.RotateToBallSocketConstraintAxis(p108, p109, p110) -- Line: 432
    -- upvalues: VectorUtil (copy), twistSwing (copy)
    local CFrame2 = p109.Part0.CFrame;
    local AxisAttachment = p110.AxisAttachment;
    local JointAttachment = p110.JointAttachment;
    local WorldAxis = AxisAttachment.WorldAxis;
    local WorldAxis2 = JointAttachment.WorldAxis;
    local v111 = VectorUtil.AngleBetween(WorldAxis2, WorldAxis);
    local v112 = math.rad(p110.UpperAngle) or 0.7853981633974483;

    if v112 < v111 then
        local v113 = WorldAxis2:Cross(WorldAxis);
        local v114 = CFrame.fromAxisAngle(v113, v111 - v112):VectorToWorldSpace(WorldAxis2);
        p108.rotateJointFromTo(p109, WorldAxis2, v114, CFrame2.RightVector);
    end;

    if p110.TwistLimitsEnabled then
        local WorldCFrame = AxisAttachment.WorldCFrame;
        local WorldAxis3 = AxisAttachment.WorldAxis;
        local v115, v116 = twistSwing(WorldCFrame:ToObjectSpace(JointAttachment.WorldCFrame), WorldAxis3);
        local v117, v118 = v116:ToAxisAngle();
        local v119 = v117:Dot(WorldAxis3);
        local v120 = math.sign(v119);
        local v121 = v120 * v117;
        local v122 = math.deg(v120 * v118);
        local TwistUpperAngle = p110.TwistUpperAngle;
        local TwistLowerAngle = p110.TwistLowerAngle;
        local v123 = false;

        if TwistUpperAngle < v122 then
            v122 = TwistUpperAngle;
        elseif v122 < TwistLowerAngle then
            v122 = TwistLowerAngle;
        else
            v123 = true;
        end;

        if not v123 then
            local v124 = math.rad(v122);
            local v125 = WorldCFrame * (CFrame.fromAxisAngle(v121, v124) * v115) * JointAttachment.CFrame:Inverse();
            local CFrame3 = p109.Part1.CFrame;
            local C1 = p109.C1;
            local C0 = p109.C0;
            local v126 = C0 * C1:Inverse() * CFrame3:Inverse() * v125 * C1;
            p109.C0 = v126 - v126.Position + C0.Position;
        end;
    end;
end;

function u13.SetupFoot(p127, p128, p129) -- Line: 484
    local Motor6DTable = p127.Motor6DTable;
    local Part1 = Motor6DTable[#Motor6DTable].Part1;
    local v130 = {};

    for i, v in pairs(p128) do
        v130[i] = Part1:FindFirstChild(v);
    end;

    p127.FootAttachmentTable = v130;
    p127.FootRaycastParams = p129;
    p127.FootOrientationSystem = true;
end;

function u13.OrientFootMotorToFloor(p131, p132, p133) -- Line: 496
    local FootAttachmentTable = p131.FootAttachmentTable;
    local RaycastLengthDown = p131.RaycastLengthDown;
    local _RayResultTable = p131._RayResultTable;
    local FootRaycastParams = p131.FootRaycastParams;

    for i = 1, 3 do
        local v134 = FootAttachmentTable[i];
        _RayResultTable[i] = workspace:Raycast(v134.WorldPosition, -v134.WorldCFrame.UpVector * RaycastLengthDown, FootRaycastParams);
    end;

    local v135 = (_RayResultTable[1] and _RayResultTable[2] and _RayResultTable[3]) == nil;
    local WorldCFrame = p131.EndEffector.WorldCFrame;
    local v136 = v135 and WorldCFrame.UpVector or (_RayResultTable[2].Position - _RayResultTable[1].Position):Cross(_RayResultTable[3].Position - _RayResultTable[1].Position).Unit;
    local UpVector = WorldCFrame.UpVector;

    if v135 == false then
        p131:rotateJointFromToWithLerp(p132, UpVector, v136, WorldCFrame.UpVector, p133);
    end;

    local Constraints = p131.Constraints;
    local v137 = Constraints and Constraints[p132];

    if v137 then
        if v137.ConstraintType == "Hinge" then
            p131:RotateToHingeAxis(p132, v137);
        end;

        if v137.ConstraintType == "BallSocketConstraint" then
            p131:RotateToBallSocketConstraintAxis(p132, v137);
        end;
    end;
end;

function u13.InitDragDebug(u138) -- Line: 532
    -- upvalues: RunService (copy)
    local Part1 = u138.Motor6DTable[#u138.Motor6DTable].Part1;
    u138.LerpMode = false;
    local Part = Instance.new("Part");
    Part.CanCollide = false;
    Part.Anchored = true;
    Part.Size = Vector3.new(1, 1, 1);
    Part.BrickColor = BrickColor.random();
    Part.Position = Part1.Position;
    Part.Name = "DragMe!: " .. Part1.Name;
    Part.Parent = workspace;
    RunService.Heartbeat:Connect(function() -- Line: 543
        -- upvalues: u138 (copy), Part (copy)
        u138:CCDIKIterateOnce(Part.Position);
    end);
end;

function u13.InitTweenDragDebug(u139) -- Line: 547
    -- upvalues: lookAt (copy)
    local Part1 = u139.Motor6DTable[#u139.Motor6DTable].Part1;
    u139.DebugMode = true;

    for i = 1, #u139.Motor6DTable - 1 do
        local v140 = u139.Motor6DTable[i + 1];
        local WorldPosition = u139.JointInfo[u139.Motor6DTable[i]].WorldPosition;
        local v141 = u139.JointInfo[v140].WorldPosition - WorldPosition;
        local WedgePart = Instance.new("WedgePart");
        WedgePart.Size = Vector3.new(0.1, 0.1, v141.Magnitude);
        WedgePart.CFrame = lookAt(WorldPosition, WorldPosition + v141) * CFrame.new(0, 0, -v141.Magnitude / 2);
        WedgePart.CanCollide = false;
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = WedgePart;
        WeldConstraint.Part1 = v140.Parent;
        WeldConstraint.Parent = v140.Parent;
        WedgePart.Parent = workspace;
        WedgePart.Name = "I am a limb vector";
    end;

    for _, v in pairs(u139.Motor6DTable) do
        v.Part1.Transparency = 0.75;
        v.Part0.Transparency = 0.75;
    end;

    local Part = Instance.new("Part");
    Part.CanCollide = false;
    Part.Anchored = true;
    Part.Size = Vector3.new(1, 1, 1);
    Part.BrickColor = BrickColor.random();
    Part.Position = Part1.Position;
    Part.Name = "DragMe!: " .. Part1.Name;
    Part.Parent = workspace;
    spawn(function() -- Line: 581
        -- upvalues: u139 (copy), Part (copy)
        while true do
            wait();
            u139:CCDIKIterateOnceDebug(Part.Position);
        end;
    end);
end;

function commandBarSetupJoints(p142)
    local v143 = p142:GetDescendants();

    for _, v in pairs(v143) do
        if v:IsA("Motor6D") then
            local Name = v.Part0.Name;
            local Attachment = Instance.new("Attachment");
            Attachment.CFrame = v.C0;
            Attachment.Name = Name .. "AxisAttachment";
            Attachment.Parent = v.Part0;
            local Attachment2 = Instance.new("Attachment");
            Attachment2.CFrame = v.C1;
            Attachment2.Name = Name .. "JointAttachment";
            Attachment2.Parent = v.Part1;
        end;
    end;
end;

function commandBarSetupRigAttachments(p144)
    local v145 = p144:GetDescendants();

    for _, v in pairs(v145) do
        if v:IsA("Motor6D") then
            local Name = v.Name;
            local Attachment = Instance.new("Attachment");
            Attachment.CFrame = v.C0;
            Attachment.Name = Name .. "RigAttachment";
            Attachment.Parent = v.Part0;
            local Attachment2 = Instance.new("Attachment");
            Attachment2.CFrame = v.C1;
            Attachment2.Name = Name .. "RigAttachment";
            Attachment2.Parent = v.Part1;
        end;
    end;
end;

function u13.VisualizeVector(p146, p147, p148) -- Line: 632
    -- upvalues: lookAt (copy), Debris (copy)
    local WedgePart = Instance.new("WedgePart");
    WedgePart.Size = Vector3.new(0.1, 0.1, p147.Magnitude);
    WedgePart.CFrame = lookAt(p146, p146 + p147) * CFrame.new(0, 0, -p147.Magnitude / 2);
    WedgePart.Anchored = true;
    WedgePart.CanCollide = false;
    WedgePart.BrickColor = p148 or BrickColor.random();
    WedgePart.Parent = workspace;
    Debris:AddItem(WedgePart, 0.75);
end;

function u13.Destroy(p149) -- Line: 645
    p149.Maid:DoCleaning();
end;

return u13;