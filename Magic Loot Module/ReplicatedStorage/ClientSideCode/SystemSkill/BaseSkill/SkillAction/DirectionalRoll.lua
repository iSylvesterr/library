-- Decompiled with Potassium's decompiler.

local AnimationModule = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).AnimationModule;
local SkillActionControl = require(script.Parent.Parent.SkillActionControl);
local GetSkillData = require(script.Parent.Parent.GetSkillData);
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local v3 = {
    isReleasePlayerOnly = true,

    Create = function(p1, p2) -- Line: 28, Name: Create
        -- upvalues: SkillActionControl (copy), AnimationModule (copy)
        p1.actionInfo = p2;
        p1.state = SkillActionControl.StateEnum.NoStart;
        p1.startTime = p1.actionInfo.startTime;
        p1.overTime = p1.actionInfo.overTime;
        local character = p1.baseSkill.character;

        if not character then
            return;
        end;

        local Animator = character:WaitForChild("Humanoid"):WaitForChild("Animator");

        if not Animator then
            return;
        end;

        p1.animator = Animator;
        p1.animationMap = {
            Forward = p1.actionInfo.animationNameForward or "RollForward",
            Backward = p1.actionInfo.animationNameBackward or "RollBackward",
            Left = p1.actionInfo.animationNameLeft or "RollLeft",
            Right = p1.actionInfo.animationNameRight or "RollRight"
        };
        p1.animationSpeed = p1.actionInfo.animationSpeed or 1;
        p1.animationPriority = p1.actionInfo.animationPriority or Enum.AnimationPriority.Action;
        p1.animationFadeTime = p1.actionInfo.animationFadeTime or 0;
        p1.animationKeyframeNames = p1.actionInfo.animationKeyframeNames or {};
        p1.animationKeyframeFunctions = p1.actionInfo.animationKeyframeFunctions or {};
        p1.currentAnimationName = nil;
        p1.currentRollDirection = nil;
        p1.directionConfig = p1.actionInfo.directionConfig or {};

        for _, v in pairs(p1.animationMap) do
            AnimationModule.PlayAnim(p1.animator, v);
            AnimationModule.StopAnim(p1.animator, v);
        end;
    end
};
local u4 = {
    Forward = 0,
    Backward = 180,
    Left = 90,
    Right = -90
};
local u5 = {
    Forward = 80,
    Backward = 50,
    Left = 50,
    Right = 50
};

local function getDirectionParams(p6, p7) -- Line: 88
    -- upvalues: u5 (copy), u4 (copy)
    local v8 = {
        moveDuration = 0.25,
        overTime = p6.actionInfo.overTime,
        animationSpeed = p6.actionInfo.animationSpeed or 1,
        animationPriority = p6.actionInfo.animationPriority or Enum.AnimationPriority.Action,
        animationFadeTime = p6.actionInfo.animationFadeTime or 0,
        animationName = p6.animationMap[p7],
        distance = u5[p7] or 50,
        angle = u4[p7] or 0
    };
    local v9 = p6.directionConfig[p7];

    if v9 then
        for i, v in pairs(v9) do
            if v ~= nil then
                v8[i] = v;
            end;
        end;
    end;

    return v8;
end;

function v3.Init(p10) -- Line: 110
    -- upvalues: SkillActionControl (copy)
    p10.state = SkillActionControl.StateEnum.NoStart;
    p10.currentAnimationName = nil;
    p10.currentRollDirection = nil;
    p10._rollPhysicsGen = nil;
    p10.rollBodyVelocity = nil;
end;

local function destroyRollBodyVelocities(p11) -- Line: 121
    local Bodymover = p11:FindFirstChild("Bodymover");

    if Bodymover and Bodymover:IsA("BodyVelocity") then
        Bodymover:Destroy();
    end;

    local DirectionalRollBV = p11:FindFirstChild("DirectionalRollBV");

    if DirectionalRollBV and DirectionalRollBV:IsA("BodyVelocity") then
        DirectionalRollBV:Destroy();
    end;
end;

function v3.Run(p12, p13) -- Line: 132
    local v14 = p13 < 0.6 and p12.baseSkill.character;

    if v14 then
        for _, descendant in pairs(v14:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.AssemblyLinearVelocity = Vector3.new(descendant.AssemblyLinearVelocity.X, 0, descendant.AssemblyLinearVelocity.Z);
            end;
        end;
    end;
end;

function v3.Start(u15, p16) -- Line: 147
    -- upvalues: GetSkillData (copy), getDirectionParams (copy), AnimationModule (copy), destroyRollBodyVelocities (copy), RunService (copy), Debris (copy)
    local character = u15.baseSkill.character;
    local v17, v18 = GetSkillData.getCharacterDirectionStr(character);
    u15.currentRollDirection = v17;
    local v19 = getDirectionParams(u15, u15.currentRollDirection or "Forward");
    u15.overTime = v19.overTime;
    u15.currentAnimationName = v19.animationName or u15.animationMap[u15.currentRollDirection];

    if not u15.currentAnimationName then
        warn("未找到对应方向的翻滚动画:", u15.currentRollDirection);
        u15.currentAnimationName = u15.animationMap.Forward;
    end;

    character:WaitForChild("Humanoid").AutoRotate = false;
    AnimationModule.PlayAnim(u15.animator, u15.currentAnimationName, v19.animationSpeed, u15.animationKeyframeNames, u15.animationKeyframeFunctions, v19.animationPriority, v19.animationFadeTime);
    local angle = v19.angle;
    local distance = v19.distance;
    local moveDuration = v19.moveDuration;
    u15.currentAnimationFadeTime = v19.animationFadeTime;
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if v18 then
        HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + v18);
    end;

    local LookVector = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.Angles(0, math.rad(angle), 0)).LookVector;
    local Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit;
    local u20 = (tonumber(HumanoidRootPart:GetAttribute("RollPhysicsGen")) or 0) + 1;
    HumanoidRootPart:SetAttribute("RollPhysicsGen", u20);
    u15._rollPhysicsGen = u20;
    destroyRollBodyVelocities(HumanoidRootPart);

    if u15.heartbeatEvent then
        u15.heartbeatEvent:Disconnect();
        u15.heartbeatEvent = nil;
    end;

    local BodyVelocity = Instance.new("BodyVelocity");
    BodyVelocity.Name = "DirectionalRollBV";
    BodyVelocity.Parent = HumanoidRootPart;
    u15.rollBodyVelocity = BodyVelocity;
    BodyVelocity.MaxForce = Vector3.new(50000, 0, 50000);
    BodyVelocity.Velocity = Unit * distance;
    local u21 = 0;
    u15.heartbeatEvent = RunService.Heartbeat:Connect(function(p22) -- Line: 224
        -- upvalues: HumanoidRootPart (copy), u15 (copy), u20 (copy), u21 (ref), Unit (copy), distance (copy), moveDuration (copy), Debris (ref)
        if not HumanoidRootPart.Parent then
            if u15.heartbeatEvent then
                u15.heartbeatEvent:Disconnect();
                u15.heartbeatEvent = nil;
            end;

            return;
        end;

        if HumanoidRootPart:GetAttribute("RollPhysicsGen") ~= u20 then
            if u15.heartbeatEvent then
                u15.heartbeatEvent:Disconnect();
                u15.heartbeatEvent = nil;
            end;

            return;
        end;

        local rollBodyVelocity = u15.rollBodyVelocity;

        if not rollBodyVelocity or (not rollBodyVelocity.Parent or rollBodyVelocity ~= HumanoidRootPart:FindFirstChild("DirectionalRollBV")) then
            if u15.heartbeatEvent then
                u15.heartbeatEvent:Disconnect();
                u15.heartbeatEvent = nil;
            end;

            return;
        end;

        u21 = u21 + p22;
        rollBodyVelocity.Velocity = Unit * distance;

        if moveDuration >= u21 then
            return;
        end;

        if u15.heartbeatEvent then
            u15.heartbeatEvent:Disconnect();
            u15.heartbeatEvent = nil;
        end;

        if HumanoidRootPart.Parent and HumanoidRootPart:GetAttribute("RollPhysicsGen") == u20 then
            local DirectionalRollBV = HumanoidRootPart:FindFirstChild("DirectionalRollBV");

            if DirectionalRollBV and DirectionalRollBV:IsA("BodyVelocity") then
                Debris:AddItem(DirectionalRollBV, 0);
            end;
        end;

        u15.rollBodyVelocity = nil;
    end);
end;

function v3.OnOver(p23, p24) -- Line: 272
    -- upvalues: AnimationModule (copy)
    if p23.heartbeatEvent then
        p23.heartbeatEvent:Disconnect();
        p23.heartbeatEvent = nil;
    end;

    local v25 = p23.baseSkill and p23.baseSkill.character;

    if v25 then
        local HumanoidRootPart = v25:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and (p23._rollPhysicsGen ~= nil and HumanoidRootPart:GetAttribute("RollPhysicsGen") == p23._rollPhysicsGen) then
            local DirectionalRollBV = HumanoidRootPart:FindFirstChild("DirectionalRollBV");

            if DirectionalRollBV and DirectionalRollBV:IsA("BodyVelocity") then
                DirectionalRollBV:Destroy();
            end;
        end;

        v25:WaitForChild("Humanoid").AutoRotate = true;
    end;

    p23.rollBodyVelocity = nil;
    p23._rollPhysicsGen = nil;

    if p23.animator and p23.currentAnimationName then
        AnimationModule.StopAnim(p23.animator, p23.currentAnimationName, p23.currentAnimationFadeTime or (p23.actionInfo and (p23.actionInfo.animationFadeTime or 0) or 0));
    end;
end;

return v3;