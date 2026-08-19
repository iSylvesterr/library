-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local u1 = CFrame.new(0, 0, -3);
local v2 = {
    skillTotalTime = -1,
    visualFadeoutTime = 5.3,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "ThrownMoving",
    States = {
        Startup = {
            Duration = 0.76,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        ThrownMoving = {
            Duration = 5,
            OnEnterClient = "Client_EnterThrownMoving",
            OnEnterServer = "Server_EnterThrownMoving",
            OnExitClient = "Client_ExitThrownMoving",
            OnExitServer = "Server_ExitThrownMoving"
        },
        Recovery = {
            Duration = 0.2,
            OnEnterClient = "Client_EnterRecovery",
            OnEnterServer = "Server_EnterRecovery",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Finished = {
            Duration = 0,
            IsTerminal = true
        },
        Interrupted = {
            Duration = 0,
            IsTerminal = true
        }
    },
    Transitions = {
        {
            From = "Startup",
            To = "ThrownMoving",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "ThrownMoving",
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Startup",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "ThrownMoving",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "ThrownMoving",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    }
};

local function getArrowMaterialKey(p3) -- Line: 85
    return p3 == 1 and "箭" or "箭" .. p3;
end;

local function getArrowFanYawDeg(p4, p5, p6) -- Line: 93
    return p5 <= 1 and 0 or (p4 - (p5 + 1) * 0.5) * (p6 / (p5 - 1));
end;

local function getBowArrowLocalCF(p7) -- Line: 102
    return CFrame.new(0, -2, 0) * CFrame.Angles(-1.5707963267948966, math.rad(p7), 0);
end;

local function applyFanYawToDirection(p8, p9) -- Line: 106
    if math.abs(p9) < 0.0001 then
        return p8;
    end;

    local v10 = Vector3.new(p8.X, 0, p8.Z);

    if v10.Magnitude < 0.0001 then
        return p8;
    end;

    return (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(p9))) * v10).Unit;
end;

local function buildArrowThrownPath(p11, p12, p13, p14) -- Line: 117
    local v15 = p12 - p11;
    local v16 = v15.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v15.Unit;

    if math.abs(p13) >= 0.0001 then
        local v17 = Vector3.new(v16.X, 0, v16.Z);

        if v17.Magnitude >= 0.0001 then
            v16 = (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(p13))) * v17).Unit;
        end;
    end;

    local v18 = CFrame.lookAt(p11, p11 + v16);

    return v18, v18 + v16 * p14;
end;

local function getPathFlyDir(p19, p20) -- Line: 128
    local v21 = p20.Position - p19.Position;

    if v21.Magnitude > 0.0001 then
        return v21.Unit;
    end;

    return p19.LookVector;
end;

local function evalArrowFlightCF(p22, p23, p24) -- Line: 133
    local v25 = p23.Position - p22.Position;
    local v26;

    if v25.Magnitude > 0.0001 then
        v26 = v25.Unit;
    else
        v26 = p22.LookVector;
    end;

    local v27 = p22.Position:Lerp(p23.Position, p24);

    return CFrame.lookAt(v27, v27 + v26);
end;

local function buildStopCFrame(p28, p29, p30) -- Line: 139
    if p29 and p29.Magnitude > 0.0001 then
        p30 = -p29;
    end;

    return CFrame.lookAt(p28, p28 + (p30.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or p30).Unit);
end;

local function isCharacterObstaclePart(p31) -- Line: 150
    if p31 then
        p31 = p31.Parent;
    end;

    local v32;

    if p31 == nil then
        v32 = false;
    else
        v32 = p31:IsA("Model") and p31:FindFirstChildOfClass("Humanoid") ~= nil;
    end;

    return v32;
end;

local function releaseProjectileWelds(p33) -- Line: 157
    if not (p33 and p33:IsA("Model")) then
        return;
    end;

    for _, descendant in p33:GetDescendants() do
        if descendant:IsA("WeldConstraint") or descendant:IsA("Weld") then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;
            local v34 = Part0 and not Part0:IsDescendantOf(p33);

            if v34 then
                Part1 = v34;
            elseif Part1 then
                Part1 = not Part1:IsDescendantOf(p33);
            end;

            if Part1 then
                descendant:Destroy();
            end;
        end;
    end;
end;

local function detachThrownProjectileVisual(p35) -- Line: 174
    if not (p35 and p35:IsA("Model")) then
        return;
    end;

    if p35.Parent and p35.Parent ~= workspace.Debris then
        p35.Parent = workspace.Debris;
    end;
end;

local function scheduleObstacleHoldFade(u36) -- Line: 183
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    local u37 = {};
    u36.stopFadeToken = u37;
    task.delay(2, function() -- Line: 186
        -- upvalues: u36 (copy), u37 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u36.stopFadeToken ~= u37 then
            return;
        end;

        releaseProjectileWelds(u36.model);
        local model = u36.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;

        if u36.model and u36.model.Parent then
            FXUtil.Model_Fade(u36.model, 0.3);
        end;
    end);
end;

local function freezeThrownVisualAtCurrent(u38) -- Line: 198
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    if u38.stopped or not (u38.model and u38.model.Parent) then
        return;
    end;

    u38.stopped = true;
    local u39 = {};
    u38.stopFadeToken = u39;
    task.delay(2, function() -- Line: 186
        -- upvalues: u38 (copy), u39 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u38.stopFadeToken ~= u39 then
            return;
        end;

        releaseProjectileWelds(u38.model);
        local model = u38.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;

        if u38.model and u38.model.Parent then
            FXUtil.Model_Fade(u38.model, 0.3);
        end;
    end);
end;

local function tryClientObstacleStop(u40, p41, p42, p43, p44) -- Line: 206
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    if u40.stopped then
        return true;
    end;

    local v45 = p44.Position - p43;

    if v45.Magnitude < 0.01 then
        return false;
    end;

    local v46 = RaycastParams.new();
    v46.FilterType = Enum.RaycastFilterType.Exclude;
    v46.FilterDescendantsInstances = { p41, p42 };
    local v47 = workspace:Raycast(p43, v45, v46);

    if v47 then
        local Instance = v47.Instance;

        if Instance then
            Instance = Instance.Parent;
        end;

        local v48;

        if Instance == nil then
            v48 = false;
        else
            v48 = Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid") ~= nil;
        end;

        if not v48 then
            p42:PivotTo(p44);
            u40.inFlight = true;
            u40.lastFlightCF = p44;

            if not u40.stopped and (u40.model and u40.model.Parent) then
                u40.stopped = true;
                local u49 = {};
                u40.stopFadeToken = u49;
                task.delay(2, function() -- Line: 186
                    -- upvalues: u40 (copy), u49 (copy), releaseProjectileWelds (ref), FXUtil (ref)
                    if u40.stopFadeToken ~= u49 then
                        return;
                    end;

                    releaseProjectileWelds(u40.model);
                    local model = u40.model;

                    if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
                        model.Parent = workspace.Debris;
                    end;

                    if u40.model and u40.model.Parent then
                        FXUtil.Model_Fade(u40.model, 0.3);
                    end;
                end);
            end;

            return true;
        end;
    end;

    return false;
end;

local function resolveStickCF(p50, p51) -- Line: 238
    local model = p50.model;

    if p50.inFlight and (model and model.Parent) then
        return p50.lastFlightCF or model:GetPivot();
    end;

    local hitPosition = p51.hitPosition;

    if hitPosition then
        return CFrame.lookAt(hitPosition, hitPosition + p50.flyDir);
    end;

    return model:GetPivot();
end;

local function finalizeThrownHitStop(u52, p53) -- Line: 251
    -- upvalues: SkillEventConst (copy), FXUtil (copy), releaseProjectileWelds (copy)
    if u52.stopped or not (u52.model and u52.model.Parent) then
        return;
    end;

    if p53.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    u52.stopped = true;
    local model = u52.model;
    local v54;

    if u52.inFlight and (model and model.Parent) then
        v54 = u52.lastFlightCF or model:GetPivot();
    else
        local hitPosition = p53.hitPosition;

        if hitPosition then
            v54 = CFrame.lookAt(hitPosition, hitPosition + u52.flyDir);
        else
            v54 = model:GetPivot();
        end;
    end;

    u52.model:PivotTo(v54);
    FXUtil.Model_Fade_In(u52.model, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u55 = {};
    u52.stopFadeToken = u55;
    task.delay(2, function() -- Line: 186
        -- upvalues: u52 (copy), u55 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u52.stopFadeToken ~= u55 then
            return;
        end;

        releaseProjectileWelds(u52.model);
        local model2 = u52.model;

        if model2 and (model2:IsA("Model") and (model2.Parent and model2.Parent ~= workspace.Debris)) then
            model2.Parent = workspace.Debris;
        end;

        if u52.model and u52.model.Parent then
            FXUtil.Model_Fade(u52.model, 0.3);
        end;
    end);
end;

local function disconnectThrownMoveEvent(p56) -- Line: 267
    if p56.skillRunData.runEvent["投掷物移动"] then
        p56.skillRunData.runEvent["投掷物移动"]:Disconnect();
        p56.skillRunData.runEvent["投掷物移动"] = nil;
    end;
end;

local function areAllProjectilesStopped(p57) -- Line: 274
    for _, v in p57 do
        if not v.stopped then
            return false;
        end;
    end;

    return true;
end;

local function handleClientHitStop(p58, p59, p60, p61) -- Line: 283
    -- upvalues: finalizeThrownHitStop (copy)
    if p59.stopped then
        return;
    end;

    finalizeThrownHitStop(p59, p60);

    if p61 then
        local v62 = true;

        for _, v in p61 do
            if not v.stopped then
                v62 = false;
                break;
            end;
        end;

        if v62 and p58.skillRunData.runEvent["投掷物移动"] then
            p58.skillRunData.runEvent["投掷物移动"]:Disconnect();
            p58.skillRunData.runEvent["投掷物移动"] = nil;
        end;
    end;
end;

local function cleanupThrownProjectileVisual(p63) -- Line: 293
    -- upvalues: releaseProjectileWelds (copy)
    local skillRunData = p63.skillRunData;

    if not skillRunData then
        return;
    end;

    local v64 = skillRunData.Visual and skillRunData.Visual.thrownProjectiles;

    if v64 then
        for _, v in v64 do
            v.stopFadeToken = nil;
            releaseProjectileWelds(v.model);
            local model = v.model;

            if model then
                if model:IsA("Model") then
                    if model.Parent and model.Parent ~= workspace.Debris then
                        model.Parent = workspace.Debris;
                    end;
                end;
            end;
        end;
    end;

    for i = 1, 7 do
        local v65 = skillRunData.material and skillRunData.material[i == 1 and "箭" or "箭" .. i];
        releaseProjectileWelds(v65);

        if v65 then
            if v65:IsA("Model") then
                if v65.Parent and v65.Parent ~= workspace.Debris then
                    v65.Parent = workspace.Debris;
                end;
            end;
        end;
    end;
end;

function v2.Client_EnterStartup(u66) -- Line: 316
    -- upvalues: RunService (copy), SoundModule (copy)
    local character = u66.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u67 = character:FindFirstChild("Left Arm");

    if not u67 then
        return;
    end;

    local v68 = u66.skillRunData.material["箭"];
    v68.Parent = workspace.Debris;

    for i = 2, 7 do
        local v69 = i == 1 and "箭" or "箭" .. i;
        u66.skillRunData.material[v69] = v68:Clone();
        u66.skillRunData.material[v69].Parent = workspace.Debris;
    end;

    u66.skillRunData.runEvent["投掷物跟手"] = RunService.Heartbeat:Connect(function(p70) -- Line: 337
        -- upvalues: u67 (copy), u66 (copy)
        if not u67 or u67.Parent == nil then
            return;
        end;

        local v71 = u67:GetPivot();

        for i = 1, 7 do
            local v72 = u66.skillRunData.material[i == 1 and "箭" or "箭" .. i];

            if v72 then
                v72:PivotTo(v71:ToWorldSpace(CFrame.new(0, -2, 0) * CFrame.Angles(-1.5707963267948966, math.rad((i - 4) * 10), 0)));
            end;
        end;
    end);
    task.delay(0.3, function() -- Line: 350
        -- upvalues: SoundModule (ref), HumanoidRootPart (copy)
        SoundModule:PlaySoundLocal({
            SoundName = "音效-技能-弓箭松手",
            Is2D = false,
            PlayPosition = HumanoidRootPart.Position
        });
    end);
end;

function v2.Server_EnterStartup(p73) -- Line: 359
    for _, v in pairs(p73.hitbox) do
        if v.hitbox then
            v.hitbox.Size = Vector3.new(6, 6, 6);
        end;
    end;
end;

function v2.Client_EnterThrownMoving(u74) -- Line: 371
    -- upvalues: FXUtil (copy), finalizeThrownHitStop (copy), RunService (copy), tryClientObstacleStop (copy)
    if u74.skillRunData.runEvent["投掷物跟手"] then
        u74.skillRunData.runEvent["投掷物跟手"]:Disconnect();
        u74.skillRunData.runEvent["投掷物跟手"] = nil;
    end;

    local character = u74.skillInputData.character;

    if not character then
        return;
    end;

    local v75 = character:FindFirstChild("Left Arm");

    if not v75 then
        return;
    end;

    local Position = u74:getTargetCF().Position;
    local v76 = v75:GetPivot();
    local u77 = {};

    for i = 1, 7 do
        local v78 = u74.skillRunData.material[i == 1 and "箭" or "箭" .. i];

        if v78 then
            local v79 = (i - 4) * 10;
            local Position2 = v76:ToWorldSpace(CFrame.new(0, -2, 0) * CFrame.Angles(-1.5707963267948966, math.rad(v79), 0)).Position;
            local v80 = Position - Position2;
            local v81 = v80.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v80.Unit;

            if math.abs(v79) >= 0.0001 then
                local v82 = Vector3.new(v81.X, 0, v81.Z);

                if v82.Magnitude >= 0.0001 then
                    v81 = (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(v79))) * v82).Unit;
                end;
            end;

            local v83 = CFrame.lookAt(Position2, Position2 + v81);
            table.insert(u77, {
                index = i,
                model = v78,
                moveStart = v83,
                moveEnd = v83 + v81 * 120
            });
            FXUtil.Model_Fade_In(v78, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
        end;
    end;

    if #u77 == 0 then
        return;
    end;

    u74.skillRunData.Visual = u74.skillRunData.Visual or {};
    local u84 = {};
    local u85 = {};

    for _, v in u77 do
        local moveStart = v.moveStart;
        local v86 = v.moveEnd.Position - moveStart.Position;
        local v87;

        if v86.Magnitude > 0.0001 then
            v87 = v86.Unit;
        else
            v87 = moveStart.LookVector;
        end;

        u84[v.index] = {
            stopped = false,
            inFlight = false,
            model = v.model,
            flyDir = v87,
            lastFlightCF = v.moveStart
        };
        u85[v.model] = v.moveStart.Position;
        v.thrownState = u84[v.index];
    end;

    u74.skillRunData.Visual.thrownProjectiles = u84;
    local pendingHitStops = u74.skillRunData.Visual.pendingHitStops;

    if pendingHitStops then
        u74.skillRunData.Visual.pendingHitStops = nil;

        for i, v in pendingHitStops do
            local v88 = u84[i];

            if v88 then
                if not v88.stopped then
                    finalizeThrownHitStop(v88, v);

                    if u84 then
                        local v89 = true;

                        for _, v3 in u84 do
                            if not v3.stopped then
                                v89 = false;
                                break;
                            end;
                        end;

                        if v89 and u74.skillRunData.runEvent["投掷物移动"] then
                            u74.skillRunData.runEvent["投掷物移动"]:Disconnect();
                            u74.skillRunData.runEvent["投掷物移动"] = nil;
                        end;
                    end;
                end;
            end;
        end;

        local v90 = true;

        for _, v in u84 do
            if not v.stopped then
                v90 = false;
                break;
            end;
        end;

        if v90 then
            return;
        end;
    end;

    local u91 = 0;
    u74.skillRunData.runEvent["投掷物移动"] = RunService.Heartbeat:Connect(function(p92) -- Line: 444
        -- upvalues: u91 (ref), u77 (copy), u85 (copy), tryClientObstacleStop (ref), character (copy), u84 (copy), u74 (copy), FXUtil (ref)
        u91 = u91 + p92;
        local v93 = game.TweenService:GetValue(math.clamp(u91 / 3, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for _, v in u77 do
            local model = v.model;
            local thrownState = v.thrownState;

            if model.Parent and not thrownState.stopped then
                local moveStart = v.moveStart;
                local moveEnd = v.moveEnd;
                local v94 = moveEnd.Position - moveStart.Position;
                local v95;

                if v94.Magnitude > 0.0001 then
                    v95 = v94.Unit;
                else
                    v95 = moveStart.LookVector;
                end;

                local v96 = moveStart.Position:Lerp(moveEnd.Position, v93);
                local v97 = CFrame.lookAt(v96, v96 + v95);

                if tryClientObstacleStop(thrownState, character, model, u85[model] or v97.Position, v97) then
                    local v98 = true;

                    for _, v3 in u84 do
                        if not v3.stopped then
                            v98 = false;
                            break;
                        end;
                    end;

                    if v98 then
                        local v99 = u74;

                        if v99.skillRunData.runEvent["投掷物移动"] then
                            v99.skillRunData.runEvent["投掷物移动"]:Disconnect();
                            v99.skillRunData.runEvent["投掷物移动"] = nil;
                        end;

                        return;
                    end;
                else
                    thrownState.inFlight = true;
                    thrownState.lastFlightCF = v97;
                    model:PivotTo(v97);
                    u85[model] = v97.Position;
                end;
            end;
        end;

        if v93 >= 1 then
            for _, v in u77 do
                if not v.thrownState.stopped and v.model.Parent then
                    FXUtil.Model_Fade(v.model, 0.1);
                end;
            end;

            local v100 = u74.skillRunData.runEvent["投掷物移动"];

            if v100 then
                v100:Disconnect();
                u74.skillRunData.runEvent["投掷物移动"] = nil;
            end;
        end;
    end);
end;

function v2.Client_ExitThrownMoving(p101) -- Line: 491
end;

function v2.Server_EnterThrownMoving(u102) -- Line: 498
    -- upvalues: u1 (copy), RunService (copy), evalArrowFlightCF (copy)
    local character = u102.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v103 = character:GetScale();
    local Position = HumanoidRootPart:GetPivot():ToWorldSpace(u1).Position;
    local Position2 = u102:getTargetCF().Position;
    local u104 = {};

    for i = 1, 7 do
        local v105 = u102.hitbox[i];

        if v105 and v105.hitbox then
            v105:start();
            local hitbox = v105.hitbox;
            hitbox.Size = hitbox.Size * v103;
            local v106 = (i - 4) * 10;
            local v107 = Position2 - Position;
            local v108 = v107.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v107.Unit;

            if math.abs(v106) >= 0.0001 then
                local v109 = Vector3.new(v108.X, 0, v108.Z);

                if v109.Magnitude >= 0.0001 then
                    v108 = (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(v106))) * v109).Unit;
                end;
            end;

            local v110 = CFrame.lookAt(Position, Position + v108);
            table.insert(u104, {
                index = i,
                hitbox = v105,
                part = hitbox,
                moveStart = v110,
                moveEnd = v110 + v108 * 120
            });
        end;
    end;

    if #u104 == 0 then
        return;
    end;

    u102.skillRunData.Logic = u102.skillRunData.Logic or {};
    u102.skillRunData.Logic.hitboxPaths = u104;
    u102.skillRunData.Logic.projectiles = {};

    for _, v in u104 do
        local projectiles = u102.skillRunData.Logic.projectiles;
        local index = v.index;
        local v111 = {
            stuck = false,
            lastPosition = v.moveStart.Position
        };
        local moveStart = v.moveStart;
        local v112 = v.moveEnd.Position - moveStart.Position;
        local v113;

        if v112.Magnitude > 0.0001 then
            v113 = v112.Unit;
        else
            v113 = moveStart.LookVector;
        end;

        v111.flyDir = v113;
        projectiles[index] = v111;
        v.part:PivotTo(v.moveStart);
    end;

    local u114 = 0;
    u102.skillRunData.runEvent["投掷物伤害盒移动"] = RunService.Heartbeat:Connect(function(p115) -- Line: 550
        -- upvalues: u102 (copy), u114 (ref), u104 (copy), evalArrowFlightCF (ref)
        local projectiles = u102.skillRunData.Logic.projectiles;
        u114 = u114 + p115;
        local v116 = game.TweenService:GetValue(math.clamp(u114 / 3, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for _, v in u104 do
            if not projectiles[v.index].stuck then
                v.part:PivotTo(evalArrowFlightCF(v.moveStart, v.moveEnd, v116));
            end;
        end;

        if v116 >= 1 then
            for _, v in u104 do
                if not projectiles[v.index].stuck then
                    v.hitbox:stop();
                end;
            end;

            local v117 = u102.skillRunData.runEvent["投掷物伤害盒移动"];

            if v117 then
                v117:Disconnect();
                u102.skillRunData.runEvent["投掷物伤害盒移动"] = nil;
            end;
        end;
    end);
end;

function v2.Server_ExitThrownMoving(p118) -- Line: 583
    if p118.skillRunData.runEvent["投掷物伤害盒移动"] then
        p118.skillRunData.runEvent["投掷物伤害盒移动"]:Disconnect();
        p118.skillRunData.runEvent["投掷物伤害盒移动"] = nil;
    end;

    for i = 1, 7 do
        local v119 = p118.hitbox[i];

        if v119 and v119.isActive then
            v119:stop();
        end;
    end;
end;

function v2.Server_EnterRecovery(p120) -- Line: 597
    p120:releaseControl();
end;

function v2.Client_EnterRecovery(p121) -- Line: 601
end;

function v2.Server_UpdateProjectileObstacleCheck(p122) -- Line: 605
    -- upvalues: buildStopCFrame (copy), SkillEventConst (copy)
    local skillRunData = p122.skillRunData;

    if not skillRunData or skillRunData.State.current ~= "ThrownMoving" then
        return;
    end;

    local Logic = skillRunData.Logic;

    if not (Logic and (Logic.projectiles and Logic.hitboxPaths)) then
        return;
    end;

    for _, v in Logic.hitboxPaths do
        local index = v.index;
        local v123 = Logic.projectiles[index];

        if v123 and not v123.stuck then
            local part = v.part;
            local Position = part.Position;
            local v124 = v123.lastPosition or Position;
            local v125 = Position - v124;

            if v125.Magnitude < 0.01 then
                v123.lastPosition = Position;
            else
                local v126 = RaycastParams.new();
                v126.FilterType = Enum.RaycastFilterType.Exclude;
                local v127;

                if typeof(part) == "Instance" then
                    v127 = { p122.character, part };
                else
                    v127 = { p122.character };
                end;

                v126.FilterDescendantsInstances = v127;
                local v128 = workspace:Raycast(v124, v125, v126);

                if v128 then
                    local Instance = v128.Instance;

                    if Instance then
                        Instance = Instance.Parent;
                    end;

                    local v129 = Instance and Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid");

                    if v129 then
                        v123.lastPosition = Position;
                    else
                        v123.stuck = true;
                        part:PivotTo(buildStopCFrame(v128.Position, v128.Normal, v123.flyDir));
                        v.hitbox:stop();
                        p122:fireProjectileHitConfirmed(v128.Position, SkillEventConst.HitType.Obstacle, nil, {
                            hitNormal = v128.Normal,
                            projectileIndex = index
                        });
                    end;
                else
                    v123.lastPosition = Position;
                end;
            end;
        end;
    end;
end;

function v2.onServerEvent(p130, p131) -- Line: 660
    -- upvalues: SkillEventConst (copy), finalizeThrownHitStop (copy)
    if p131.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    if p131.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    local skillRunData = p130.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    local v132 = p131.projectileIndex or 1;
    local thrownProjectiles = skillRunData.Visual.thrownProjectiles;
    local v133;

    if thrownProjectiles then
        v133 = thrownProjectiles[v132];
    else
        v133 = thrownProjectiles;
    end;

    if not v133 then
        skillRunData.Visual.pendingHitStops = skillRunData.Visual.pendingHitStops or {};
        skillRunData.Visual.pendingHitStops[v132] = p131;

        return;
    end;

    if v133.stopped then
        return;
    end;

    finalizeThrownHitStop(v133, p131);

    if thrownProjectiles then
        local v134 = true;

        for _, v in thrownProjectiles do
            if not v.stopped then
                v134 = false;
                break;
            end;
        end;

        if v134 and p130.skillRunData.runEvent["投掷物移动"] then
            p130.skillRunData.runEvent["投掷物移动"]:Disconnect();
            p130.skillRunData.runEvent["投掷物移动"] = nil;
        end;
    end;
end;

function v2.onEnd(p135) -- Line: 685
    -- upvalues: cleanupThrownProjectileVisual (copy)
    cleanupThrownProjectileVisual(p135);
end;

v2.SoundList = { "音效-技能-弓箭松手" };
v2.AnimateList = { "人形生物拉弓1" };
v2.ResNameList = { "箭" };
v2.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 3,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 4,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 5,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 6,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 7,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v2.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.8,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 0.8,
        animationName = "人形生物拉弓1",
        animationSpeed = 0.5,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v2;