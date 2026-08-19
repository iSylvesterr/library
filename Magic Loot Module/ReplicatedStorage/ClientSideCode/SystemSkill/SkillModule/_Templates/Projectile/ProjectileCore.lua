-- Decompiled with Potassium's decompiler.

local BezierCurve = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).BezierCurve;
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local SkillEventConst = require(script.Parent.Parent.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileImpact = require(script.Parent.ProjectileImpact);
local FriendlyRayUtil = require(script.Parent.Parent.Parent.Parent.BaseSkill.FriendlyRayUtil);

local function setPivotCF(p1, p2) -- Line: 28
    if typeof(p1) ~= "Instance" then
        if type(p1) == "table" then
            if type(p1.PivotTo) == "function" then
                p1:PivotTo(p2);

                return;
            end;

            if p1.CFrame ~= nil then
                p1.CFrame = p2;
            end;
        end;

        return;
    end;

    if p1:IsA("Model") then
        p1:PivotTo(p2);

        return;
    end;

    if p1:IsA("BasePart") then
        p1.CFrame = p2;
    end;
end;

local function evaluateBezierPoint(p3, p4) -- Line: 65
    -- upvalues: evaluateBezierPoint (copy)
    local v5 = math.clamp(p4, 0, 1);

    if #p3 == 1 then
        return p3[1];
    end;

    local v6 = {};

    for i = 1, #p3 - 1 do
        v6[i] = p3[i]:Lerp(p3[i + 1], v5);
    end;

    return evaluateBezierPoint(v6, v5);
end;

local function estimateSampledBezierArcLength(p7, p8) -- Line: 92
    -- upvalues: evaluateBezierPoint (copy)
    if #p7 < 2 then
        return 0;
    end;

    local v9 = math.max(p8, 2);
    local v10 = evaluateBezierPoint(p7, 0);
    local v11 = 0;

    for i = 1, v9 do
        local v12 = evaluateBezierPoint(p7, i / v9);
        v11 = v11 + (v12 - v10).Magnitude;
        v10 = v12;
    end;

    return v11;
end;

local function computeTrackedMoveTime(p13, p14, p15, p16) -- Line: 111
    -- upvalues: estimateSampledBezierArcLength (copy)
    local v17 = estimateSampledBezierArcLength(p13, 16) / math.max(p14, 0.001);
    local v18 = math.max(v17, p16 or 0.15);
    local v19 = math.min(v18, p15);

    return math.max(v19, 0.001);
end;

local function runTrackedBezierMotion(u20, u21, u22) -- Line: 152
    -- upvalues: BezierCurve (copy), estimateSampledBezierArcLength (copy), RunService (copy), TweenService (copy), evaluateBezierPoint (copy), setPivotCF (copy)
    if not u20 then
        return nil;
    end;

    local Position = u21.startCF.Position;
    local Rotation = u21.startCF.Rotation;
    local flySpeed = u21.flySpeed;
    local maxFlyTime = u21.maxFlyTime;
    local bezierSeed = u21.bezierSeed;
    local u23 = u21.middlePointCount or 8;
    local getTrackedEndPosition = u21.getTrackedEndPosition;
    local initialEndPosition = u21.initialEndPosition;
    local v24 = initialEndPosition - Position;
    local Magnitude = v24.Magnitude;

    if Magnitude >= 1e-6 then
        local v25 = math.min(Magnitude, maxFlyTime * flySpeed);
        initialEndPosition = Position + v24.Unit * v25;
    end;

    local u26 = u21.curveRefreshInterval or 0;
    local minTrackedMoveTime = u21.minTrackedMoveTime;
    local onStep = u21.onStep;
    local u27 = initialEndPosition;
    local u28 = 0;
    local u29 = u26;

    local function buildCurve(p30) -- Line: 173
        -- upvalues: Position (copy), u21 (copy), BezierCurve (ref), u23 (copy), bezierSeed (copy)
        local Magnitude2 = (p30 - Position).Magnitude;
        local v31 = 0;

        if u21.getHeightOffset then
            v31 = u21.getHeightOffset(Position, p30);
        elseif u21.heightOffset then
            v31 = u21.heightOffset;
        end;

        local v32;

        if u21.sideOffsetRandom == nil then
            v32 = math.min(Magnitude2 * 0.1, 16);
        else
            v32 = u21.sideOffsetRandom;
        end;

        return BezierCurve.GenerateBezierPoints(Position, p30, u23, {
            HeightOffsetRandom = 0,
            RandomSeed = bezierSeed,
            HeightOffset = v31,
            SideOffsetRandom = v32,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDirection = Enum.EasingDirection.Out
        });
    end;

    local u33 = buildCurve(u27);
    local v34 = estimateSampledBezierArcLength(u33, 16) / math.max(flySpeed, 0.001);
    local v35 = math.max(v34, minTrackedMoveTime or 0.15);
    local v36 = math.min(v35, maxFlyTime);
    local u37 = math.max(v36, 0.001);
    local u38 = false;
    local u39 = nil;
    u39 = RunService.Heartbeat:Connect(function(p40) -- Line: 199
        -- upvalues: u38 (ref), u20 (copy), u39 (ref), u22 (copy), u27 (ref), u29 (ref), u26 (copy), getTrackedEndPosition (copy), Position (copy), flySpeed (copy), maxFlyTime (copy), u33 (ref), buildCurve (copy), u28 (ref), u37 (copy), TweenService (ref), evaluateBezierPoint (ref), Rotation (copy), setPivotCF (ref), onStep (copy)
        if not u38 then
            local v41 = u20;
            local v42;

            if v41 == nil then
                v42 = false;
            elseif typeof(v41) == "Instance" then
                v42 = v41.Parent ~= nil;
            elseif type(v41) == "table" then
                v42 = v41._logicDestroyed ~= true;
            else
                v42 = false;
            end;

            if v42 then
                u29 = u29 + p40;

                if u26 <= 0 or u26 <= u29 then
                    u29 = 0;
                    local v43 = getTrackedEndPosition();

                    if v43 then
                        local v44 = Position;
                        local v45 = flySpeed;
                        local v46 = maxFlyTime;
                        local v47 = v43 - v44;
                        local Magnitude2 = v47.Magnitude;

                        if Magnitude2 >= 1e-6 then
                            local v48 = math.min(Magnitude2, v46 * v45);
                            v43 = v44 + v47.Unit * v48;
                        end;

                        u27 = v43;
                    end;

                    u33 = buildCurve(u27);
                end;

                u28 = u28 + p40;
                local v49 = math.clamp(u28 / u37, 0, 1);
                local v50 = evaluateBezierPoint(u33, (TweenService:GetValue(v49, Enum.EasingStyle.Sine, Enum.EasingDirection.In)));
                local v51 = CFrame.new(v50) * Rotation;
                setPivotCF(u20, v51);

                if onStep then
                    onStep(v50, v51);
                end;

                if v49 >= 1 then
                    u38 = true;
                    u39:Disconnect();

                    if u22 then
                        u22(u27);
                    end;
                end;

                return;
            end;
        end;

        u38 = true;

        if u39 then
            u39:Disconnect();
        end;

        if u22 then
            u22(u27);
        end;
    end);

    return u39;
end;

return {
    create = function(p52) -- Line: 248, Name: create
        -- upvalues: BezierCurve (copy), FriendlyRayUtil (copy), SkillEventConst (copy), ProjectileImpact (copy), runTrackedBezierMotion (copy)
        local u53 = p52.flySpeed or 130;
        local u54 = p52.maxFlyTime or 1;
        local u55 = p52.bezierSeed or 10000;

        local function getProjectileStartCF(p56) -- Line: 253
            local character = p56.character;

            if not character then
                return p56.skillInputData.releaseCF;
            end;

            local v57 = character:FindFirstChild("当前手持");

            if not v57 then
                return p56.skillInputData.releaseCF;
            end;

            local v58 = v57:FindFirstChildOfClass("Model");

            if not v58 then
                return p56.skillInputData.releaseCF;
            end;

            local v59 = v58:FindFirstChild("魔杖尖端");

            if v59 then
                return v59:GetPivot() or p56.skillInputData.releaseCF;
            end;

            return p56.skillInputData.releaseCF;
        end;

        local function getProjectileEndCF(p60) -- Line: 265
            -- upvalues: u53 (copy), u54 (copy)
            local character = p60.character;

            if not character then
                return p60.skillInputData.targetCF;
            end;

            local v61 = character:FindFirstChild("当前手持");

            if not v61 then
                return p60.skillInputData.targetCF;
            end;

            local v62 = v61:FindFirstChildOfClass("Model");

            if not v62 then
                return p60.skillInputData.targetCF;
            end;

            local v63 = v62:FindFirstChild("魔杖尖端");

            if not v63 then
                return p60.skillInputData.targetCF;
            end;

            local v64 = v63:GetPivot() or p60.skillInputData.releaseCF;
            local targetCF = p60.skillInputData.targetCF;
            local Magnitude = (v64.Position - targetCF.Position).Magnitude;
            local v65 = math.min(Magnitude / u53, u54);

            if v65 * u53 < Magnitude then
                targetCF = CFrame.new(v64.Position + (targetCF.Position - v64.Position).Unit * v65 * u53) * targetCF.Rotation;
            end;

            return targetCF;
        end;

        local function computeTrajectory(p66) -- Line: 286
            -- upvalues: getProjectileStartCF (copy), getProjectileEndCF (copy), u53 (copy), u54 (copy), BezierCurve (ref), u55 (copy)
            local v67 = getProjectileStartCF(p66);
            local v68 = getProjectileEndCF(p66);
            local Magnitude = (v67.Position - v68.Position).Magnitude;
            local v69 = math.min(Magnitude / u53, u54);

            return v67, v68, BezierCurve.GenerateBezierPoints(v67.Position, v68.Position, 8, {
                HeightOffsetRandom = 0,
                RandomSeed = u55,
                SideOffsetRandom = math.min(Magnitude * 0.1, 16),
                EasingStyle = Enum.EasingStyle.Quad,
                EasingDirection = Enum.EasingDirection.Out
            }), v69, v69 * 60, 60;
        end;

        local function runBezierMotion(p70, p71, p72, p73, p74) -- Line: 303
            -- upvalues: BezierCurve (ref)
            return BezierCurve.MultiOrderBezierCurves({
                Frame = p72,
                FPS = p73,
                Points = p71,
                Target = p70,
                EasingStyle = Enum.EasingStyle.Sine,
                EasingDirection = Enum.EasingDirection.In
            }, p74 or function() -- Line: 311
            end);
        end;

        local u75 = p52.stopOnObstacle ~= false;
        local v76 = tonumber(p52.obstacleRaycastMinFlightTime) or 0;
        local u77 = math.max(0, v76);

        return {
            getProjectileStartCF = getProjectileStartCF,
            getProjectileEndCF = getProjectileEndCF,
            computeTrajectory = computeTrajectory,
            runBezierMotion = runBezierMotion,
            runTrackedBezierMotion = runTrackedBezierMotion,

            createObstacleCheck = function() -- Line: 316, Name: createObstacleCheck
                -- upvalues: u75 (copy), u77 (copy), FriendlyRayUtil (ref), SkillEventConst (ref), ProjectileImpact (ref)
                return function(p78) -- Line: 317
                    -- upvalues: u75 (ref), u77 (ref), FriendlyRayUtil (ref), SkillEventConst (ref), ProjectileImpact (ref)
                    if not u75 then
                        return;
                    end;

                    local skillRunData = p78.skillRunData;

                    if skillRunData.State.current ~= "ProjectileFlying" or skillRunData.Logic.hasExploded then
                        return;
                    end;

                    local v79 = p78.hitbox[1];

                    if not v79 then
                        return;
                    end;

                    local hitbox = v79.hitbox;
                    local Position = hitbox.Position;
                    local v80 = skillRunData.Logic.projectileLastPosition or Position;

                    if u77 > 0 then
                        local projectileFlyingStartTime = skillRunData.Logic.projectileFlyingStartTime;

                        if projectileFlyingStartTime and os.clock() - projectileFlyingStartTime < u77 then
                            skillRunData.Logic.projectileLastPosition = Position;

                            return;
                        end;
                    end;

                    local v81 = Position - v80;

                    if v81.Magnitude > 0.01 then
                        local v82 = {
                            id = p78.characterId,
                            type = p78.characterType
                        };
                        local raycastProjectileObstacle = FriendlyRayUtil.raycastProjectileObstacle;
                        local v83 = {};
                        local v84;

                        if typeof(hitbox) == "Instance" then
                            v84 = { p78.character, hitbox };
                        else
                            v84 = { p78.character };
                        end;

                        v83.extraIgnore = v84;
                        local v85 = raycastProjectileObstacle(v80, v81, v82, v83);

                        if v85 then
                            ProjectileImpact.resolveImpact(p78, {
                                type = SkillEventConst.HitType.Obstacle,
                                position = v85.Position,
                                normal = v85.Normal,
                                source = ProjectileImpact.ImpactSource.Raycast
                            });

                            return;
                        end;
                    end;

                    skillRunData.Logic.projectileLastPosition = Position;
                end;
            end
        };
    end,

    runTrackedBezierMotion = runTrackedBezierMotion,
    evaluateBezierPoint = evaluateBezierPoint,

    clampProjectileEndToMaxRange = function(p86, p87, p88, p89) -- Line: 78, Name: clampProjectileEndToMaxRange
        local v90 = p87 - p86;
        local Magnitude = v90.Magnitude;

        if Magnitude < 1e-6 then
            return p87;
        end;

        local v91 = math.min(Magnitude, p89 * p88);

        return p86 + v90.Unit * v91;
    end,

    setPivotCF = setPivotCF,

    isMotionTargetAlive = function(p92) -- Line: 51, Name: isMotionTargetAlive
        if p92 == nil then
            return false;
        end;

        if typeof(p92) == "Instance" then
            return p92.Parent ~= nil;
        end;

        if type(p92) == "table" then
            return p92._logicDestroyed ~= true;
        end;

        return false;
    end
};