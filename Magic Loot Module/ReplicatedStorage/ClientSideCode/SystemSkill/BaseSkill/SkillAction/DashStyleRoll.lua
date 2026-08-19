-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local SkillActionControl = require(script.Parent.Parent.SkillActionControl);
local SkillActionLock = require(script.Parent.Parent.SkillActionLock);
local GetSkillData = require(script.Parent.Parent.GetSkillData);
local CameraModule = UtilsSystem.CameraModule;
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local u1 = {
    Forward = 0,
    Backward = 180,
    Left = 90,
    Right = -90
};
local u2 = {
    Forward = 0,
    Backward = 180,
    Left = 90,
    Right = -90
};
local v3 = {
    isReleasePlayerOnly = true
};

local function destroyNewRollPhysics(p4) -- Line: 53
    local NewRollDashAttach = p4:FindFirstChild("NewRollDashAttach");

    if NewRollDashAttach then
        NewRollDashAttach:Destroy();
    end;
end;

local function getDirectionParams(p5, p6) -- Line: 60
    -- upvalues: u1 (copy)
    local v7 = {
        tweenDuration = 0.7,
        planeSpeed = 102.4,
        vectorEndFactor = 0,
        overTime = p5.actionInfo.overTime,
        angle = u1[p6] or 0,
        animationSpeed = p5.actionInfo.animationSpeed or 1.3,
        animationFadeTime = p5.actionInfo.animationFadeTime or 0.05,
        animationFadeInTime = p5.actionInfo.animationFadeInTime,
        animationPriority = p5.actionInfo.animationPriority or Enum.AnimationPriority.Action3,
        animationName = p5.animationMap[p6],
        earlyEndBoostDuration = p5.actionInfo.earlyEndBoostDuration,
        earlyEndBoostPeakSpeed = p5.actionInfo.earlyEndBoostPeakSpeed,
        earlyEndBoostEasingStyle = p5.actionInfo.earlyEndBoostEasingStyle,
        earlyEndBoostEasingDirection = p5.actionInfo.earlyEndBoostEasingDirection
    };
    local v8 = p5.directionConfig[p6];

    if v8 then
        for i, v in pairs(v8) do
            if v ~= nil then
                v7[i] = v;
            end;
        end;
    end;

    if v7.animationFadeInTime == nil then
        v7.animationFadeInTime = v7.animationFadeTime;
    end;

    return v7;
end;

local function overSiblingLockMovementAt(p9, p10) -- Line: 91
    -- upvalues: SkillActionControl (copy)
    local skillAction = p9.baseSkill.skillAction;

    if not (skillAction and skillAction.allActions) then
        return;
    end;

    for _, v in ipairs(skillAction.allActions) do
        if v ~= p9 and (v.actionInfo and (v.actionInfo.action == "LockMovement" and v.state == SkillActionControl.StateEnum.Play)) then
            v:Over(p10);
        end;
    end;
end;

local function cancelEarlyEndMoveBoost(p11) -- Line: 110
    if p11._earlyEndBoostConn then
        p11._earlyEndBoostConn:Disconnect();
        p11._earlyEndBoostConn = nil;
    end;

    local v12 = p11.baseSkill and p11.baseSkill.character;

    if v12 then
        v12 = v12:FindFirstChild("HumanoidRootPart");
    end;

    local _earlyEndBoostLastPlanarVec = p11._earlyEndBoostLastPlanarVec;

    if v12 and (v12.Parent and (_earlyEndBoostLastPlanarVec and _earlyEndBoostLastPlanarVec.Magnitude > 1e-6)) then
        local AssemblyLinearVelocity = v12.AssemblyLinearVelocity;
        local v13 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
        v12.AssemblyLinearVelocity = Vector3.new((v13 - _earlyEndBoostLastPlanarVec).X, AssemblyLinearVelocity.Y, (v13 - _earlyEndBoostLastPlanarVec).Z);
    end;

    p11._earlyEndBoostLastPlanarVec = nil;
end;

local function tryStartEarlyEndMoveBoost(u14, p15) -- Line: 126
    -- upvalues: cancelEarlyEndMoveBoost (copy), RunService (copy), TweenService (copy)
    local earlyEndBoostDuration = p15.earlyEndBoostDuration;
    local earlyEndBoostPeakSpeed = p15.earlyEndBoostPeakSpeed;

    if type(earlyEndBoostDuration) ~= "number" or (earlyEndBoostDuration <= 0 or (type(earlyEndBoostPeakSpeed) ~= "number" or earlyEndBoostPeakSpeed <= 0)) then
        return;
    end;

    local character = u14.baseSkill.character;
    local u16;

    if character then
        u16 = character:FindFirstChildOfClass("Humanoid");
    else
        u16 = character;
    end;

    local u17;

    if character then
        u17 = character:FindFirstChild("HumanoidRootPart");
    else
        u17 = character;
    end;

    if not (character and (u16 and u17)) then
        return;
    end;

    cancelEarlyEndMoveBoost(u14);
    local u18 = p15.earlyEndBoostEasingStyle or Enum.EasingStyle.Quad;
    local u19 = p15.earlyEndBoostEasingDirection or Enum.EasingDirection.Out;
    local u20 = os.clock();
    u14._earlyEndBoostLastPlanarVec = Vector3.new(0, 0, 0);
    u14._earlyEndBoostConn = RunService.Heartbeat:Connect(function() -- Line: 143
        -- upvalues: character (copy), u16 (copy), u17 (copy), cancelEarlyEndMoveBoost (ref), u14 (copy), u20 (copy), earlyEndBoostDuration (copy), TweenService (ref), u18 (copy), u19 (copy), earlyEndBoostPeakSpeed (copy)
        if not (character.Parent and (u16.Parent and u17.Parent)) then
            cancelEarlyEndMoveBoost(u14);

            return;
        end;

        local v21 = os.clock() - u20;

        if earlyEndBoostDuration <= v21 then
            local AssemblyLinearVelocity = u17.AssemblyLinearVelocity;
            local v22 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
            local v23 = u14._earlyEndBoostLastPlanarVec or Vector3.new(0, 0, 0);
            u17.AssemblyLinearVelocity = Vector3.new((v22 - v23).X, AssemblyLinearVelocity.Y, (v22 - v23).Z);
            cancelEarlyEndMoveBoost(u14);

            return;
        end;

        local v24 = 1 - TweenService:GetValue(math.clamp(v21 / earlyEndBoostDuration, 0, 1), u18, u19);
        local MoveDirection = u16.MoveDirection;
        local v25 = MoveDirection.Magnitude <= 0.001 and Vector3.new(0, 0, 0) or Vector3.new(MoveDirection.X, 0, MoveDirection.Z).Unit * (earlyEndBoostPeakSpeed * v24);
        local AssemblyLinearVelocity = u17.AssemblyLinearVelocity;
        local v26 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z) - (u14._earlyEndBoostLastPlanarVec or Vector3.new(0, 0, 0));
        u14._earlyEndBoostLastPlanarVec = v25;
        u17.AssemblyLinearVelocity = Vector3.new((v26 + v25).X, AssemblyLinearVelocity.Y, (v26 + v25).Z);
    end);
end;

function v3.Create(p27, p28) -- Line: 175
    -- upvalues: SkillActionControl (copy)
    p27.actionInfo = p28;
    p27.state = SkillActionControl.StateEnum.NoStart;
    p27.startTime = p27.actionInfo.startTime;
    p27.overTime = p27.actionInfo.overTime;
    local character = p27.baseSkill.character;

    if not character then
        return;
    end;

    p27.animator = character:WaitForChild("Humanoid"):WaitForChild("Animator");
    p27.animationMap = {
        Forward = p27.actionInfo.animationNameForward or "RollForward",
        Backward = p27.actionInfo.animationNameBackward or "RollBackward",
        Left = p27.actionInfo.animationNameLeft or "RollLeft",
        Right = p27.actionInfo.animationNameRight or "RollRight"
    };
    p27.directionConfig = p27.actionInfo.directionConfig or {};
end;

function v3.Init(p29) -- Line: 205
    -- upvalues: SkillActionControl (copy), cancelEarlyEndMoveBoost (copy)
    p29.state = SkillActionControl.StateEnum.NoStart;
    p29.currentAnimationName = nil;
    p29.currentAnimationFadeTime = nil;
    p29.currentAnimationStopFadeTime = nil;
    p29._physicsGen = nil;
    p29._disableDelayThread = nil;
    p29.linearVel = nil;
    p29._moveInterruptWindowStartSkillTime = nil;
    p29._moveInterruptWindowEndSkillTime = nil;
    p29._moveEarlyInterruptDone = false;
    p29._dashAttach = nil;
    cancelEarlyEndMoveBoost(p29);
    p29._rollDirKey = nil;
end;

function v3._applyEarlyMoveInterrupt(p30, p31) -- Line: 221
    -- upvalues: SkillActionControl (copy), getDirectionParams (copy), overSiblingLockMovementAt (copy), tryStartEarlyEndMoveBoost (copy)
    if p30._moveEarlyInterruptDone or p30.state ~= SkillActionControl.StateEnum.Play then
        return;
    end;

    p30._moveEarlyInterruptDone = true;
    local character = p30.baseSkill.character;

    if character then
        character = character:FindFirstChild("HumanoidRootPart");
    end;

    local v32;

    if p30._rollDirKey then
        v32 = getDirectionParams(p30, p30._rollDirKey) or nil;
    else
        v32 = nil;
    end;

    local v33 = character and character:FindFirstChild("NewRollDashAttach");

    if v33 then
        v33:Destroy();
    end;

    overSiblingLockMovementAt(p30, p31);
    p30:Over(p31);

    if v32 then
        tryStartEarlyEndMoveBoost(p30, v32);
    end;
end;

function v3.Run(p34, p35) -- Line: 239
    -- upvalues: SkillActionControl (copy)
    if p34.state == SkillActionControl.StateEnum.Play then
        local _moveInterruptWindowStartSkillTime = p34._moveInterruptWindowStartSkillTime;
        local _moveInterruptWindowEndSkillTime = p34._moveInterruptWindowEndSkillTime;

        if type(_moveInterruptWindowStartSkillTime) == "number" and (type(_moveInterruptWindowEndSkillTime) == "number" and (_moveInterruptWindowStartSkillTime <= p35 and (p35 <= _moveInterruptWindowEndSkillTime and not p34._moveEarlyInterruptDone))) then
            local character = p34.baseSkill.character;

            if character then
                character = character:FindFirstChildOfClass("Humanoid");
            end;

            if character and character.MoveDirection.Magnitude > 0.001 then
                p34:_applyEarlyMoveInterrupt(p35);

                return;
            end;
        end;
    end;

    local v36 = p35 < 0.3 and p34.baseSkill.character;

    if v36 then
        for _, descendant in pairs(v36:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.AssemblyLinearVelocity = Vector3.new(descendant.AssemblyLinearVelocity.X, descendant.AssemblyLinearVelocity.Y * 0.7, descendant.AssemblyLinearVelocity.Z);
            end;
        end;
    end;
end;

game:GetService("ContextActionService");

function v3.Start(p37, p38) -- Line: 272
    -- upvalues: SkillActionLock (copy), GetSkillData (copy), CameraModule (copy), TweenService (copy), u2 (copy), getDirectionParams (copy), AnimationModule (copy)
    local character = p37.baseSkill.character;

    if not character then
        return;
    end;

    local Humanoid = character:FindFirstChild("Humanoid");
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not (Humanoid and HumanoidRootPart) then
        return;
    end;

    SkillActionLock.turn_On_Action_Lock(p37.baseSkill.character);
    local Attachment = Instance.new("Attachment");
    Attachment.Orientation = Vector3.new(-90, 0, 0);
    Attachment.Parent = HumanoidRootPart;
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.MaxForce = 50000;
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.Parent = Attachment;
    LinearVelocity.Enabled = true;
    local v39, v40 = GetSkillData.getCharacterDirectionStr(character);
    local v41 = (type(v39) ~= "string" or not p37.animationMap[v39]) and "Forward" or v39;
    p37._rollDirKey = v41;

    if v39 == "Forward" and game.Players:GetPlayerFromCharacter(character) == game.Players.LocalPlayer then
        CameraModule.DisableCameraEvent_Helper("冲刺影响相机FOV");
        local u42 = 0;
        CameraModule.EnableCameraEvent_Helper("冲刺影响相机FOV", function(p43, p44) -- Line: 311
            -- upvalues: u42 (ref), TweenService (ref), CameraModule (ref)
            u42 = u42 + p44;
            local v45 = 6 * TweenService:GetValue(math.clamp(u42 / 0.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

            if u42 <= 0.5 then
                return CFrame.new(0, 0, 0), v45;
            end;

            local v46 = TweenService:GetValue(math.clamp((u42 - 0.5) / 0.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);

            if v46 >= 1 then
                CameraModule.DisableCameraEvent_Helper("冲刺影响相机FOV");
            end;

            return CFrame.new(0, 0, 0), 6 - 6 * v46;
        end);
    end;

    if v40 then
        HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + v40);
    end;

    local LookVector = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.Angles(0, math.rad(u2[v39]), 0)).LookVector;
    local Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit;
    local v47 = getDirectionParams(p37, v41);
    p37.overTime = v47.overTime;
    p37.currentAnimationName = v47.animationName;
    p37.currentAnimationStopFadeTime = v47.animationStopFadeTime or v47.animationFadeTime;
    local v48 = p37.actionInfo.startTime or 0;
    local overTime = p37.overTime;
    local moveInterruptWindowTime = v47.moveInterruptWindowTime;
    local v49 = v47.moveInterruptWindowOffset or 0;

    if type(moveInterruptWindowTime) == "number" and (moveInterruptWindowTime > 0 and v48 < overTime) then
        local v50 = v48 + v49;
        local v51 = math.max(v50, v48);
        local v52 = math.min(v50 + moveInterruptWindowTime, overTime);

        if v51 < v52 then
            p37._moveInterruptWindowStartSkillTime = v51;
            p37._moveInterruptWindowEndSkillTime = v52;
        else
            p37._moveInterruptWindowStartSkillTime = nil;
            p37._moveInterruptWindowEndSkillTime = nil;
        end;

        p37._moveEarlyInterruptDone = false;
    else
        p37._moveInterruptWindowStartSkillTime = nil;
        p37._moveInterruptWindowEndSkillTime = nil;
        p37._moveEarlyInterruptDone = false;
    end;

    p37._dashAttach = Attachment;
    local tweenDuration = v47.tweenDuration;
    local planeSpeed = v47.planeSpeed;
    local vectorEndFactor = v47.vectorEndFactor;

    if Humanoid.Sit then
        LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
        LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
        local MoveDirection = Humanoid.MoveDirection;
        LinearVelocity.VectorVelocity = Vector3.new(MoveDirection.X, 0, MoveDirection.Z) * planeSpeed;
        TweenService:Create(LinearVelocity, TweenInfo.new(tweenDuration, Enum.EasingStyle.Quad), {
            VectorVelocity = LinearVelocity.VectorVelocity * vectorEndFactor
        }):Play();
    else
        LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
        LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
        local v53 = Unit * planeSpeed;
        LinearVelocity.VectorVelocity = v53;
        TweenService:Create(LinearVelocity, TweenInfo.new(tweenDuration, Enum.EasingStyle.Quad), {
            VectorVelocity = v53 * vectorEndFactor
        }):Play();
    end;

    task.delay(tweenDuration, function() -- Line: 399
        -- upvalues: Attachment (copy)
        if Attachment.Parent then
            game.Debris:AddItem(Attachment, 0);
        end;
    end);
    AnimationModule.PlayAnimByModel(character, v47.animationName, v47.animationSpeed, p37.actionInfo.animationKeyframeNames, p37.actionInfo.animationKeyframeFunctions, v47.animationPriority, v47.animationFadeInTime);
end;

function v3.OnOver(p54, p55) -- Line: 416
    -- upvalues: cancelEarlyEndMoveBoost (copy), SkillActionLock (copy), AnimationModule (copy)
    cancelEarlyEndMoveBoost(p54);
    local character = p54.baseSkill.character;

    if character then
        character = character:FindFirstChild("HumanoidRootPart");
    end;

    local v56 = character and character:FindFirstChild("NewRollDashAttach");

    if v56 then
        v56:Destroy();
    end;

    SkillActionLock.turn_Off_Action_Lock(p54.baseSkill.character);

    if p54.animator and p54.currentAnimationName then
        AnimationModule.StopAnim(p54.animator, p54.currentAnimationName, p54.currentAnimationStopFadeTime or p54.actionInfo.animationStopFadeTime or (p54.actionInfo.animationFadeTime or 0));
    end;

    p54.currentAnimationName = nil;
    p54.currentAnimationFadeTime = nil;
    p54.currentAnimationStopFadeTime = nil;
    p54._dashAttach = nil;
    p54._moveInterruptWindowStartSkillTime = nil;
    p54._moveInterruptWindowEndSkillTime = nil;
    p54._rollDirKey = nil;
end;

return v3;