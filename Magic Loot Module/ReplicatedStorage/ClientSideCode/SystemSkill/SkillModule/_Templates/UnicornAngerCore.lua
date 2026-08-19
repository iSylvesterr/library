-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SkillCommon = require(script.Parent.SkillCommon);
local EntityUtil = require(script.Parent.Parent.Parent.BaseSkill.EntityUtil);
local HitQueryContext = require(script.Parent.Parent.Parent.BaseSkill.HitQueryContext);

return {
    create = function(p1) -- Line: 48, Name: create
        -- upvalues: ElementTp (copy), SkillEventConst (copy), SkillCommon (copy), EntityUtil (copy), HitQueryContext (copy), Players (copy), FXUtil (copy), VisibleMgr (copy), Debris (copy)
        local v2 = {
            skillTotalTime = -1,
            skillElementType = ElementTp.Thunder,
            skillDistanceLimit = 64
        };
        local u3 = p1.warnToStrikeDelay or 1.2;
        local strikeCountTarget = p1.strikeCountTarget;
        local strikeCountRadial = p1.strikeCountRadial;
        local radialWaveCount = p1.radialWaveCount;
        local u4 = p1.proximityStrikeTarget or "Player";
        local u5 = p1.proximityStrikeRadius or 100;
        local u6 = math.max(strikeCountTarget, strikeCountRadial) + 1;
        local u7 = u6 + 8 - 1;
        local u8 = { "音效-技能-独角兽-打雷1", "音效-技能-独角兽-打雷2", "音效-技能-独角兽-打雷3", "音效-技能-独角兽-打雷4", "音效-技能-独角兽-打雷5", "音效-技能-独角兽-打雷6", "音效-技能-独角兽-打雷7", "音效-技能-独角兽-打雷8", "音效-技能-独角兽-打雷9" };
        local u9 = p1.fxWarn or "独角兽落雷预警";
        local u10 = p1.fxStrike or "独角兽落雷";
        local u11 = p1.fxGround or "独角兽落雷地面特效";
        v2.InitialState = "Startup";
        v2.ControlOpenState = "Main";

        local function strikeFallDelayRel(p12) -- Line: 117
            return ((p12 - 1) * 15 + 5) / 60;
        end;

        local function strikeImpactDelayRel(p13) -- Line: 121
            -- upvalues: u3 (copy)
            return ((p13 - 1) * 15 + 5) / 60 + u3;
        end;

        local function buildTargetPriorityImpactSchedule(p14, p15) -- Line: 125
            -- upvalues: u3 (copy)
            local v16 = Random.new(p14 + 41);
            local v17 = {};
            local v18 = 0.08333333333333333 + u3;
            v17[1] = v18;

            for i = 2, p15 do
                v18 = v18 + v16:NextNumber(0.05, 0.2);
                v17[i] = v18;
            end;

            return v17;
        end;

        local function maxTargetPriorityMainDuration(p19) -- Line: 137
            -- upvalues: u3 (copy)
            return 0.08333333333333333 + u3 + (p19 - 1) * 0.2 + 0.35;
        end;

        local v20 = math.max(0.08333333333333333 + u3 + (strikeCountTarget - 1) * 0.2 + 0.35, ((radialWaveCount - 1) * 15 + 5) / 60 + u3 + 0.35, 2.0999999999999996 + u3 + 0.35);
        v2.visualFadeoutTime = v20 + 0.5;
        local u21 = v2.visualFadeoutTime + u3 + 2;
        v2.States = {
            Startup = {
                Duration = 1,
                OnEnterClient = "Client_EnterStartup",
                OnEnterServer = "Server_EnterStartup"
            },
            Main = {
                OnEnterClient = "Client_EnterMain",
                OnEnterServer = "Server_EnterMain",
                Duration = v20
            },
            Recovery = {
                Duration = 0.2,
                OnEnterClient = "Client_EnterRecovery",
                OnEnterServer = "Server_EnterRecovery"
            },
            Finished = {
                Duration = 0,
                IsTerminal = true
            },
            Interrupted = {
                Duration = 0,
                IsTerminal = true,
                OnEnterClient = "Client_EnterInterrupted",
                OnEnterServer = "Server_EnterInterrupted"
            }
        };
        v2.Transitions = {
            {
                From = "Startup",
                To = "Main",
                Event = SkillEventConst.StateTimeout
            },
            {
                From = "Main",
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
                From = "Main",
                To = "Interrupted",
                Event = SkillEventConst.Interrupt
            },
            {
                From = "Recovery",
                To = "Interrupted",
                Event = SkillEventConst.Interrupt
            },
            {
                From = "Startup",
                To = "Finished",
                Event = SkillEventConst.ForceFinish
            },
            {
                From = "Main",
                To = "Finished",
                Event = SkillEventConst.ForceFinish
            },
            {
                From = "Recovery",
                To = "Finished",
                Event = SkillEventConst.ForceFinish
            }
        };

        local function radialLinearIndex(p22, p23) -- Line: 190
            return (p22 - 1) * 8 + p23;
        end;

        local function applyHitboxVisibility(p24, p25, p26) -- Line: 194
            if not p24 then
                return;
            end;

            if p26 == nil then
                p26 = false;
            end;

            if p25 and p26 then
                p24.Transparency = 0.3;

                return;
            end;

            p24.Transparency = 1;
        end;

        local function snapGroundPos(p27) -- Line: 206
            -- upvalues: SkillCommon (ref)
            return SkillCommon.getGroundCF(CFrame.new(p27), 4, 0.15, "Ground").Position;
        end;

        local function xzDistance(p28, p29) -- Line: 210
            return (Vector3.new(p28.X, 0, p28.Z) - Vector3.new(p29.X, 0, p29.Z)).Magnitude;
        end;

        local function matchesStrikeTargetType(p30, p31) -- Line: 216
            if not p31 then
                return false;
            end;

            if p30 == "NPC" then
                return p31 == "Player" and true or p31 == "Summon";
            end;

            return p31 == "NPC";
        end;

        local function isPlanTargetModel(p32, p33, p34) -- Line: 226
            -- upvalues: EntityUtil (ref), HitQueryContext (ref)
            if p34 == p33 then
                return false;
            end;

            local v35 = p34:FindFirstChildOfClass("Humanoid");
            local HumanoidRootPart = p34:FindFirstChild("HumanoidRootPart");

            if not v35 or (not HumanoidRootPart or (not HumanoidRootPart:IsA("BasePart") or v35.Health <= 0)) then
                return false;
            end;

            local _, v36 = EntityUtil.getEntityIdentity(p34);
            local characterType = p32.characterType;
            local v37;

            if v36 then
                if characterType == "NPC" then
                    v37 = v36 == "Player" and true or v36 == "Summon";
                else
                    v37 = v36 == "NPC";
                end;
            else
                v37 = false;
            end;

            if not v37 then
                return false;
            end;

            local v38 = p32.hitbox[1];

            if not v38 then
                return not EntityUtil.isFriendly({
                    id = p32.characterId,
                    type = p32.characterType
                }, p34);
            end;

            local v39 = HitQueryContext.create(v38, p34, 0);

            return HitQueryContext.isDetectableTarget(v39);
        end;

        local function gatherTargetGroundPositions(u40, p41, u42) -- Line: 247
            -- upvalues: isPlanTargetModel (copy), SkillCommon (ref), Players (ref)
            local Position = p41.Position;
            local u43 = {};
            local u44 = {};

            local function tryModel(p45) -- Line: 256
                -- upvalues: u44 (copy), isPlanTargetModel (ref), u40 (copy), u42 (copy), Position (copy), u43 (copy), SkillCommon (ref)
                if not p45 or (u44[p45] or not isPlanTargetModel(u40, u42, p45)) then
                    return;
                end;

                local HumanoidRootPart = p45:FindFirstChild("HumanoidRootPart");

                if not HumanoidRootPart then
                    return;
                end;

                local v46 = Position;
                local Position2 = HumanoidRootPart.Position;

                if (Vector3.new(v46.X, 0, v46.Z) - Vector3.new(Position2.X, 0, Position2.Z)).Magnitude > 100 then
                    return;
                end;

                u44[p45] = true;
                local Position3 = SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position), 4, 0.15, "Ground").Position;
                table.insert(u43, Position3);
            end;

            if u40.characterType == "NPC" then
                for _, v in Players:GetPlayers() do
                    tryModel(v.Character);
                end;

                local Summons = workspace:FindFirstChild("Summons");

                if Summons then
                    for _, child in Summons:GetChildren() do
                        if child:IsA("Model") then
                            tryModel(child);
                        end;
                    end;

                    return u43;
                end;
            else
                local Monster = workspace:FindFirstChild("Monster");

                if Monster then
                    for _, child in Monster:GetChildren() do
                        if child:IsA("Model") then
                            tryModel(child);
                        end;
                    end;
                end;
            end;

            return u43;
        end;

        local function isProximityStrikeTarget(p47, p48, p49) -- Line: 297
            -- upvalues: EntityUtil (ref), u4 (copy), isPlanTargetModel (copy), HitQueryContext (ref)
            if p49 == p48 then
                return false;
            end;

            local v50 = p49:FindFirstChildOfClass("Humanoid");
            local HumanoidRootPart = p49:FindFirstChild("HumanoidRootPart");

            if not v50 or (not HumanoidRootPart or (not HumanoidRootPart:IsA("BasePart") or v50.Health <= 0)) then
                return false;
            end;

            local _, v51 = EntityUtil.getEntityIdentity(p49);

            if u4 == "Player" then
                if v51 ~= "Player" then
                    return false;
                end;
            elseif not isPlanTargetModel(p47, p48, p49) then
                return false;
            end;

            local v52 = p47.hitbox[1];

            if not v52 then
                return not EntityUtil.isFriendly({
                    id = p47.characterId,
                    type = p47.characterType
                }, p49);
            end;

            local v53 = HitQueryContext.create(v52, p49, 0);

            return HitQueryContext.isDetectableTarget(v53);
        end;

        local function tryAppendProximityCandidate(p54, p55, p56, p57, p58) -- Line: 328
            -- upvalues: isProximityStrikeTarget (copy), u5 (copy), SkillCommon (ref)
            if not isProximityStrikeTarget(p55, p56, p57) then
                return;
            end;

            local HumanoidRootPart = p57:FindFirstChild("HumanoidRootPart");

            if not HumanoidRootPart then
                return;
            end;

            local Position = HumanoidRootPart.Position;
            local Magnitude = (Vector3.new(p58.X, 0, p58.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude;

            if u5 < Magnitude then
                return;
            end;

            local v59 = {
                dist = Magnitude,
                pos = SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position), 4, 0.15, "Ground").Position
            };
            table.insert(p54, v59);
        end;

        local function gatherNearbyProximityStrikePositions(p60, p61, p62) -- Line: 352
            -- upvalues: u4 (copy), Players (ref), tryAppendProximityCandidate (copy)
            local v63 = {};

            if u4 == "Player" then
                for _, v in Players:GetPlayers() do
                    local Character = v.Character;

                    if Character then
                        tryAppendProximityCandidate(v63, p60, p62, Character, p61);
                    end;
                end;
            else
                local Monster = workspace:FindFirstChild("Monster");

                if Monster then
                    for _, child in Monster:GetChildren() do
                        if child:IsA("Model") then
                            tryAppendProximityCandidate(v63, p60, p62, child, p61);
                        end;
                    end;
                end;
            end;

            table.sort(v63, function(p64, p65) -- Line: 375
                if p64.dist == p65.dist then
                    return p64.pos.X < p65.pos.X;
                end;

                return p64.dist < p65.dist;
            end);
            local v66 = {};

            for i = 1, math.min(8, #v63) do
                v66[i] = v63[i].pos;
            end;

            return v66;
        end;

        local function strikeFlatHintFromCenter(p67, p68) -- Line: 388
            local v69 = p68 - p67;
            local v70 = Vector3.new(v69.X, 0, v69.Z);

            return v70.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v70.Unit;
        end;

        local function randomGroundInRadius(p71, p72, p73) -- Line: 397
            -- upvalues: SkillCommon (ref)
            local v74 = p73:NextNumber() * 3.141592653589793 * 2;
            local v75 = p73:NextNumber();
            local v76 = math.sqrt(v75) * p72;
            local v77 = math.cos(v74) * v76;
            local v78 = math.sin(v74) * v76;
            local v79 = p71 + Vector3.new(v77, 0, v78);

            return SkillCommon.getGroundCF(CFrame.new(v79), 4, 0.15, "Ground").Position;
        end;

        local function buildTargetPriorityPositions(p80, p81, p82, p83, p84) -- Line: 404
            -- upvalues: SkillCommon (ref), gatherTargetGroundPositions (copy)
            local v85 = SkillCommon.casterFeetGroundWorldPos(p81, 4, 0.15, "Ground");
            local v86 = Random.new(p83 + 17);
            local v87 = gatherTargetGroundPositions(p80, p81, p82);
            local v88 = {};

            for _ = 1, p84 do
                if #v87 > 0 then
                    local v89 = v86:NextInteger(1, #v87);
                    table.insert(v88, table.remove(v87, v89));
                else
                    local v90 = v86:NextNumber() * 3.141592653589793 * 2;
                    local v91 = v86:NextNumber();
                    local v92 = math.sqrt(v91) * 100;
                    local v93 = math.cos(v90) * v92;
                    local v94 = math.sin(v90) * v92;
                    local v95 = v85 + Vector3.new(v93, 0, v94);
                    local Position = SkillCommon.getGroundCF(CFrame.new(v95), 4, 0.15, "Ground").Position;
                    table.insert(v88, Position);
                end;
            end;

            return v88;
        end;

        local function flatLookVector(p96) -- Line: 426
            local LookVector = p96.CFrame.LookVector;
            local v97 = Vector3.new(LookVector.X, 0, LookVector.Z);

            return v97.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v97.Unit;
        end;

        local function buildRadialPositions(p98, p99, p100) -- Line: 439
            -- upvalues: SkillCommon (ref)
            local v101 = SkillCommon.casterFeetGroundWorldPos(p98, 4, 0.15, "Ground");
            local LookVector = p98.CFrame.LookVector;
            local v102 = Vector3.new(LookVector.X, 0, LookVector.Z);
            local v103 = v102.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v102.Unit;
            local v104 = 100 / p100;
            local v105 = {};

            for i = 1, p100 do
                for i2 = 0, 7 do
                    local v106 = v101 + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), i2 * 0.7853981633974483):VectorToWorldSpace(v103) * (v104 * i);
                    local Position = SkillCommon.getGroundCF(CFrame.new(v106), 4, 0.15, "Ground").Position;
                    table.insert(v105, Position);
                end;
            end;

            return v105;
        end;

        local function commitStrikePlan(p107) -- Line: 454
            -- upvalues: strikeCountTarget (copy), buildTargetPriorityPositions (copy), buildTargetPriorityImpactSchedule (copy), strikeCountRadial (copy), buildRadialPositions (copy), radialWaveCount (copy)
            local skillRunData = p107.skillRunData;

            if not skillRunData.Logic then
                skillRunData.Logic = {};
            end;

            local unicornAngerPlan = skillRunData.Logic.unicornAngerPlan;

            if unicornAngerPlan then
                return unicornAngerPlan;
            end;

            local skillInputData = p107.skillInputData;

            if skillInputData then
                skillInputData = skillInputData.character;
            end;

            local v108;

            if skillInputData then
                v108 = skillInputData:FindFirstChild("HumanoidRootPart");
            else
                v108 = skillInputData;
            end;

            if not (v108 and skillInputData) then
                local v109 = {
                    mode = "TargetPriority",
                    strikeCount = strikeCountTarget,
                    positions = {}
                };
                skillRunData.Logic.unicornAngerPlan = v109;

                return v109;
            end;

            local v110 = p107.combatSeed or 0;
            local v111 = Random.new(v110):NextNumber() < 0.5 and "TargetPriority" or "Radial8";
            local v112 = nil;
            local v113, v114;

            if v111 == "TargetPriority" then
                v113 = strikeCountTarget;
                v114 = buildTargetPriorityPositions(p107, v108, skillInputData, v110, v113);
                v112 = buildTargetPriorityImpactSchedule(v110, v113);
            else
                v113 = strikeCountRadial;
                v114 = buildRadialPositions(v108, v110, radialWaveCount);
            end;

            local v115 = {
                mode = v111,
                strikeCount = v113,
                positions = v114,
                impactDelayRel = v112
            };
            skillRunData.Logic.unicornAngerPlan = v115;

            return v115;
        end;

        local function strikeFlatHint(p116, p117) -- Line: 499
            local v118 = p117 - p116.Position;
            local v119 = Vector3.new(v118.X, 0, v118.Z);

            if v119.Magnitude > 0.05 then
                return v119.Unit;
            end;

            local LookVector = p116.CFrame.LookVector;
            local v120 = Vector3.new(LookVector.X, 0, LookVector.Z);

            return v120.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v120.Unit;
        end;

        local function resolveGroundAlignedCF(p121, p122) -- Line: 508
            -- upvalues: FXUtil (ref)
            return FXUtil.GetGroundAlignedCF(p121, p122, "Ground", 4, 0.15) or CFrame.new(p121 + Vector3.new(0, 0.15, 0));
        end;

        local function issueStrikeCancelToken(p123) -- Line: 516
            p123.Logic = p123.Logic or {};
            local v124 = {};
            p123.Logic.unicornAngerStrikeCancel = v124;

            return v124;
        end;

        local function cancelStrikeSchedule(p125) -- Line: 523
            if p125 and p125.Logic then
                p125.Logic.unicornAngerStrikeCancel = nil;
            end;
        end;

        local function stillActiveForScheduledStrike(p126, p127) -- Line: 530
            if p126._destroyed then
                return false;
            end;

            if p126.flowState == "Interrupted" then
                return false;
            end;

            return p126.runGeneration == p127;
        end;

        local function isServerStrikeScheduleActive(p128, p129) -- Line: 540
            if p128._destroyed then
                return false;
            end;

            local skillRunData = p128.skillRunData;

            return skillRunData and (skillRunData.Logic and skillRunData.Logic.unicornAngerStrikeCancel == p129) and true or false;
        end;

        local function clearClientStrikeVfx(p130) -- Line: 551
            -- upvalues: SkillCommon (ref)
            if not p130 then
                return;
            end;

            SkillCommon.clearRunSpawnList(p130, "UnicornAngerSpawned");

            if p130.material then
                SkillCommon.cleanupWandTipTrailFromMaterial(p130, "雷系尾迹", "ThunderCast尾迹");
            end;
        end;

        local function cloneEmitFx(p131, p132, p133, p134) -- Line: 561
            -- upvalues: VisibleMgr (ref), Debris (ref), u21 (copy), SkillCommon (ref), FXUtil (ref)
            local v135 = p131:Clone();

            if v135:IsA("Model") then
                v135:ScaleTo(p133);
            end;

            VisibleMgr.UnQueryAll(v135);
            v135:PivotTo(p132);
            v135.Parent = workspace.Debris;
            Debris:AddItem(v135, u21);
            SkillCommon.appendRunSpawnList(p134, "UnicornAngerSpawned", v135);
            FXUtil.Emit_Particles_GetDescendants(v135, true);
        end;

        local function emitWarningAt(p136, p137, p138, p139) -- Line: 574
            -- upvalues: cloneEmitFx (copy), SkillCommon (ref)
            cloneEmitFx(p136, CFrame.new(p137), p138, p139);
            SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", p137);
        end;

        local function emitStrikeAt(p140, p141, p142, p143, p144, p145) -- Line: 584
            -- upvalues: cloneEmitFx (copy), FXUtil (ref), SkillCommon (ref), u8 (copy)
            cloneEmitFx(p140, CFrame.new(p142), p144, p145);
            cloneEmitFx(p141, FXUtil.GetGroundAlignedCF(p142, p143, "Ground", 4, 0.15) or CFrame.new(p142 + Vector3.new(0, 0.15, 0)), p144, p145);
            local v146 = SkillCommon.pickRandomSoundName(u8);

            if v146 then
                SkillCommon.playSoundLocal3D(v146, p142);
            end;
        end;

        local function pulseBallHitboxAtGroundPos(u147, p148, p149, p150, u151, u152, u153) -- Line: 600
            if not (u147 and u147.hitbox) then
                return;
            end;

            local hitbox = u147.hitbox;

            if hitbox:IsA("BasePart") then
                hitbox.Shape = Enum.PartType.Ball;
            end;

            hitbox.Size = Vector3.new(p149, p149, p149);
            hitbox:PivotTo(CFrame.new(p148));

            if hitbox then
                local v154;

                if u151 == nil then
                    v154 = false;
                else
                    v154 = u151;
                end;

                if v154 then
                    hitbox.Transparency = 0.3;
                else
                    hitbox.Transparency = 1;
                end;
            end;

            u147:start();
            task.delay(p150 or 0.15, function() -- Line: 622
                -- upvalues: u152 (copy), u153 (copy), u147 (copy), hitbox (copy), u151 (copy)
                if u152 and u153 then
                    local v155 = u152;
                    local v156 = u153;
                    local v157;

                    if v155._destroyed then
                        v157 = false;
                    else
                        local skillRunData = v155.skillRunData;
                        v157 = skillRunData and (skillRunData.Logic and skillRunData.Logic.unicornAngerStrikeCancel == v156) and true or false;
                    end;

                    if not v157 then
                        if u147.isActive then
                            u147:stop();
                        end;

                        local v158 = hitbox;

                        if not v158 then
                            return;
                        end;

                        local _ = u151 == nil;
                        v158.Transparency = 1;

                        return;
                    end;
                end;

                if u147.isActive then
                    u147:stop();
                end;

                local v159 = hitbox;

                if not v159 then
                    return;
                end;

                local _ = u151 == nil;
                v159.Transparency = 1;
            end);
        end;

        local function scheduleClientSequentialStrikes(p160, p161, u162, u163, u164, p165, u166, u167, u168, u169) -- Line: 637
            -- upvalues: u3 (copy), cloneEmitFx (copy), SkillCommon (ref), emitStrikeAt (copy)
            local impactDelayRel = p160.impactDelayRel;

            if not impactDelayRel then
                return;
            end;

            for i = 1, p161 do
                local u170 = p160.positions[i];
                local v171 = impactDelayRel[i];

                if u170 and v171 then
                    local v172 = u170 - p165.Position;
                    local v173 = Vector3.new(v172.X, 0, v172.Z);
                    local u174;

                    if v173.Magnitude > 0.05 then
                        u174 = v173.Unit;
                    else
                        local LookVector = p165.CFrame.LookVector;
                        local v175 = Vector3.new(LookVector.X, 0, LookVector.Z);
                        u174 = v175.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v175.Unit;
                    end;

                    task.delay(v171 - u3, function() -- Line: 661
                        -- upvalues: u168 (copy), u169 (copy), u162 (copy), u170 (copy), u166 (copy), u167 (copy), cloneEmitFx (ref), SkillCommon (ref)
                        local v176 = u168;
                        local v177 = u169;
                        local v178;

                        if v176._destroyed or v176.flowState == "Interrupted" then
                            v178 = false;
                        else
                            v178 = v176.runGeneration == v177;
                        end;

                        if not v178 then
                            return;
                        end;

                        local v179 = u170;
                        cloneEmitFx(u162, CFrame.new(v179), u166, u167);
                        SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", v179);
                    end);
                    task.delay(v171, function() -- Line: 667
                        -- upvalues: u168 (copy), u169 (copy), emitStrikeAt (ref), u163 (copy), u164 (copy), u170 (copy), u174 (copy), u166 (copy), u167 (copy)
                        local v180 = u168;
                        local v181 = u169;
                        local v182;

                        if v180._destroyed or v180.flowState == "Interrupted" then
                            v182 = false;
                        else
                            v182 = v180.runGeneration == v181;
                        end;

                        if not v182 then
                            return;
                        end;

                        emitStrikeAt(u163, u164, u170, u174, u166, u167);
                    end);
                end;
            end;
        end;

        local function scheduleClientRadialStrikes(u183, u184, u185, u186, u187, u188, u189, u190, u191, p192) -- Line: 676
            -- upvalues: cloneEmitFx (copy), SkillCommon (ref), emitStrikeAt (copy), u3 (copy)
            local function emitWaveWarning(p193) -- Line: 688
                -- upvalues: u190 (copy), u191 (copy), u183 (copy), u184 (copy), u188 (copy), u189 (copy), cloneEmitFx (ref), SkillCommon (ref)
                local v194 = u190;
                local v195 = u191;
                local v196;

                if v194._destroyed or v194.flowState == "Interrupted" then
                    v196 = false;
                else
                    v196 = v194.runGeneration == v195;
                end;

                if not v196 then
                    return;
                end;

                for i = 1, 8 do
                    local v197 = u183.positions[(p193 - 1) * 8 + i];

                    if v197 then
                        cloneEmitFx(u184, CFrame.new(v197), u188, u189);
                        SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", v197);
                    end;
                end;
            end;

            local function emitWaveStrike(p198) -- Line: 700
                -- upvalues: u190 (copy), u191 (copy), u183 (copy), emitStrikeAt (ref), u185 (copy), u186 (copy), u187 (copy), u188 (copy), u189 (copy)
                local v199 = u190;
                local v200 = u191;
                local v201;

                if v199._destroyed or v199.flowState == "Interrupted" then
                    v201 = false;
                else
                    v201 = v199.runGeneration == v200;
                end;

                if not v201 then
                    return;
                end;

                for i = 1, 8 do
                    local v202 = u183.positions[(p198 - 1) * 8 + i];

                    if v202 then
                        local v203 = u187;
                        local v204 = v202 - v203.Position;
                        local v205 = Vector3.new(v204.X, 0, v204.Z);
                        local v206;

                        if v205.Magnitude > 0.05 then
                            v206 = v205.Unit;
                        else
                            local LookVector = v203.CFrame.LookVector;
                            local v207 = Vector3.new(LookVector.X, 0, LookVector.Z);
                            v206 = v207.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v207.Unit;
                        end;

                        emitStrikeAt(u185, u186, v202, v206, u188, u189);
                    end;
                end;
            end;

            for i = 1, p192 do
                task.delay(((i - 1) * 15 + 5) / 60, function() -- Line: 714
                    -- upvalues: emitWaveWarning (copy), i (copy)
                    emitWaveWarning(i);
                end);
                task.delay(((i - 1) * 15 + 5) / 60 + u3, function() -- Line: 717
                    -- upvalues: emitWaveStrike (copy), i (copy)
                    emitWaveStrike(i);
                end);
            end;
        end;

        local function playProximityStrikeWaveVfx(u208, p209, p210, p211, u212, u213, u214, u215, u216) -- Line: 723
            -- upvalues: cloneEmitFx (copy), SkillCommon (ref), u3 (copy), emitStrikeAt (copy)
            for _, v in p209 do
                local v217;

                if u208._destroyed or u208.flowState == "Interrupted" then
                    v217 = false;
                else
                    v217 = u208.runGeneration == u216;
                end;

                if not v217 then
                    return;
                end;

                local v218 = v - p210;
                local v219 = Vector3.new(v218.X, 0, v218.Z);
                local u220 = v219.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v219.Unit;
                cloneEmitFx(p211, CFrame.new(v), u214, u215);
                SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", v);
                task.delay(u3, function() -- Line: 740
                    -- upvalues: u208 (copy), u216 (copy), emitStrikeAt (ref), u212 (copy), u213 (copy), v (copy), u220 (copy), u214 (copy), u215 (copy)
                    local v221 = u208;
                    local v222 = u216;
                    local v223;

                    if v221._destroyed or v221.flowState == "Interrupted" then
                        v223 = false;
                    else
                        v223 = v221.runGeneration == v222;
                    end;

                    if not v223 then
                        return;
                    end;

                    emitStrikeAt(u212, u213, v, u220, u214, u215);
                end);
            end;
        end;

        local function scheduleServerPlayerProximityStrikes(u224, u225, u226, u227) -- Line: 749
            -- upvalues: gatherNearbyProximityStrikePositions (copy), u6 (copy), u3 (copy), pulseBallHitboxAtGroundPos (copy)
            for i = 1, 4 do
                task.delay((i - 1) * 0.7, function() -- Line: 757
                    -- upvalues: u224 (copy), u226 (copy), gatherNearbyProximityStrikePositions (ref), u225 (copy), i (copy), u6 (ref), u3 (ref), pulseBallHitboxAtGroundPos (ref), u227 (copy)
                    local v228 = u224;
                    local v229 = u226;
                    local v230;

                    if v228._destroyed then
                        v230 = false;
                    else
                        local skillRunData = v228.skillRunData;
                        v230 = skillRunData and (skillRunData.Logic and skillRunData.Logic.unicornAngerStrikeCancel == v229) and true or false;
                    end;

                    if not v230 then
                        return;
                    end;

                    local v231 = u224.skillInputData and u224.skillInputData.character;

                    if not v231 then
                        return;
                    end;

                    local HumanoidRootPart = v231:FindFirstChild("HumanoidRootPart");

                    if not HumanoidRootPart then
                        return;
                    end;

                    local Position = HumanoidRootPart.Position;
                    local v232 = gatherNearbyProximityStrikePositions(u224, Position, u225);

                    if #v232 == 0 then
                        return;
                    end;

                    u224:fireProximityStrikeWave(i, Position, v232);

                    for i2, v in v232 do
                        local u233 = u224.hitbox[u6 + i2 - 1];

                        if u233 then
                            task.delay(u3, function() -- Line: 781
                                -- upvalues: u224 (ref), u226 (ref), pulseBallHitboxAtGroundPos (ref), u233 (copy), v (copy), u227 (ref)
                                local v234 = u224;
                                local v235 = u226;
                                local v236;

                                if v234._destroyed then
                                    v236 = false;
                                else
                                    local skillRunData = v234.skillRunData;
                                    v236 = skillRunData and (skillRunData.Logic and skillRunData.Logic.unicornAngerStrikeCancel == v235) and true or false;
                                end;

                                if not v236 then
                                    return;
                                end;

                                pulseBallHitboxAtGroundPos(u233, v, u227, 0.15, false, u224, u226);
                            end);
                        end;
                    end;
                end);
            end;
        end;

        local function scheduleServerSequentialHitboxes(u237, p238, u239, u240, u241) -- Line: 792
            -- upvalues: pulseBallHitboxAtGroundPos (copy)
            local impactDelayRel = u237.impactDelayRel;

            if not impactDelayRel then
                return;
            end;

            for i = 1, p238 do
                local v242 = impactDelayRel[i];

                if v242 then
                    task.delay(v242, function() -- Line: 808
                        -- upvalues: u239 (copy), u240 (copy), u237 (copy), i (copy), pulseBallHitboxAtGroundPos (ref), u241 (copy)
                        local v243 = u239;
                        local v244 = u240;
                        local v245;

                        if v243._destroyed then
                            v245 = false;
                        else
                            local skillRunData = v243.skillRunData;
                            v245 = skillRunData and (skillRunData.Logic and skillRunData.Logic.unicornAngerStrikeCancel == v244) and true or false;
                        end;

                        if not v245 then
                            return;
                        end;

                        local v246 = u237.positions[i];
                        local v247 = u239.hitbox[i];

                        if not (v246 and v247) then
                            return;
                        end;

                        pulseBallHitboxAtGroundPos(v247, v246, u241, 0.15, nil, u239, u240);
                    end);
                end;
            end;
        end;

        local function scheduleServerRadialHitboxes(u248, u249, u250, u251, p252) -- Line: 822
            -- upvalues: u3 (copy), pulseBallHitboxAtGroundPos (copy)
            for i = 1, p252 do
                task.delay(((i - 1) * 15 + 5) / 60 + u3, function() -- Line: 830
                    -- upvalues: u249 (copy), u250 (copy), i (copy), u248 (copy), pulseBallHitboxAtGroundPos (ref), u251 (copy)
                    local v253 = u249;
                    local v254 = u250;
                    local v255;

                    if v253._destroyed then
                        v255 = false;
                    else
                        local skillRunData = v253.skillRunData;
                        v255 = skillRunData and (skillRunData.Logic and skillRunData.Logic.unicornAngerStrikeCancel == v254) and true or false;
                    end;

                    if not v255 then
                        return;
                    end;

                    for i2 = 1, 8 do
                        local v256 = (i - 1) * 8 + i2;
                        local v257 = u248.positions[v256];
                        local v258 = u249.hitbox[v256];

                        if v257 and v258 then
                            pulseBallHitboxAtGroundPos(v258, v257, u251, 0.15, nil, u249, u250);
                        end;
                    end;
                end);
            end;
        end;

        function v2.Client_EnterStartup(p259) -- Line: 846
            -- upvalues: SkillCommon (ref)
            local character = p259.skillInputData.character;

            if not character then
                return;
            end;

            local v260 = SkillCommon.resolveWandTipFromCharacter(character);

            if v260 then
                SkillCommon.scheduleWandTipElementTrail(p259, v260, {
                    trailMaterialKey = "雷系尾迹",
                    runEventKey = "ThunderCast尾迹",
                    enableAt = 0.27,
                    disableAt = 2.07
                });
            end;
        end;

        function v2.Server_EnterStartup(p261) -- Line: 862
        end;

        function v2.Client_EnterMain(p262) -- Line: 864
            -- upvalues: SkillCommon (ref), commitStrikePlan (copy), u9 (copy), u10 (copy), u11 (copy), scheduleClientRadialStrikes (copy), radialWaveCount (copy), scheduleClientSequentialStrikes (copy)
            SkillCommon.refreshSkillAimSnapshot(p262);
            local skillInputData = p262.skillInputData;
            local v263;

            if skillInputData then
                v263 = skillInputData.character;
            else
                v263 = skillInputData;
            end;

            if v263 then
                v263 = v263:FindFirstChild("HumanoidRootPart");
            end;

            local skillRunData = p262.skillRunData;

            if not (skillInputData and (v263 and (skillRunData and skillRunData.material))) then
                return;
            end;

            local runGeneration = p262.runGeneration;
            SkillCommon.playSoundLocal3D("音效-技能-独角兽-起手", v263:GetPivot().Position);
            local v264 = commitStrikePlan(p262);
            local strikeCount = v264.strikeCount;
            local v265 = skillRunData.material[u9];
            local v266 = skillRunData.material[u10];
            local v267 = skillRunData.material[u11];

            if not (v265 and (v266 and v267)) then
                return;
            end;

            local _, v268 = SkillCommon.scaleDualFromData(p262, SkillCommon.bandScaleOptsFromSkillData(p262));

            if v264.mode == "Radial8" then
                scheduleClientRadialStrikes(v264, v265, v266, v267, v263, v268, skillRunData, p262, runGeneration, radialWaveCount);

                return;
            end;

            scheduleClientSequentialStrikes(v264, strikeCount, v265, v266, v267, v263, v268, skillRunData, p262, runGeneration);
        end;

        function v2.Server_EnterMain(p269) -- Line: 907
            -- upvalues: SkillCommon (ref), commitStrikePlan (copy), u7 (copy), scheduleServerRadialHitboxes (copy), radialWaveCount (copy), scheduleServerSequentialHitboxes (copy), scheduleServerPlayerProximityStrikes (copy)
            SkillCommon.refreshSkillAimSnapshot(p269);
            local skillInputData = p269.skillInputData;
            local v270;

            if skillInputData then
                v270 = skillInputData.character;
            else
                v270 = skillInputData;
            end;

            local skillRunData = p269.skillRunData;

            if not (skillInputData and (v270 and skillRunData)) then
                return;
            end;

            local v271 = commitStrikePlan(p269);
            local strikeCount = v271.strikeCount;
            skillRunData.Logic = skillRunData.Logic or {};
            local v272 = {};
            skillRunData.Logic.unicornAngerStrikeCancel = v272;
            local _, v273 = SkillCommon.scaleDualFromData(p269, SkillCommon.bandScaleOptsFromSkillData(p269));
            local v274 = 25 * v273;
            local v275 = Vector3.new(v274, v274, v274);

            for i = 1, u7 do
                local v276 = p269.hitbox[i];

                if v276 and v276.hitbox then
                    local hitbox = v276.hitbox;

                    if hitbox:IsA("BasePart") then
                        hitbox.Shape = Enum.PartType.Ball;
                    end;

                    hitbox.Size = v275;

                    if hitbox:IsA("BasePart") then
                        if hitbox then
                            hitbox.Transparency = 1;
                        end;
                    end;
                end;
            end;

            if v271.mode == "Radial8" then
                scheduleServerRadialHitboxes(v271, p269, v272, v274, radialWaveCount);
            else
                scheduleServerSequentialHitboxes(v271, strikeCount, p269, v272, v274);
            end;

            scheduleServerPlayerProximityStrikes(p269, v270, v272, v274);
        end;

        function v2.onServerEvent(p277, p278) -- Line: 945
            -- upvalues: SkillEventConst (ref), u9 (copy), u10 (copy), u11 (copy), SkillCommon (ref), playProximityStrikeWaveVfx (copy)
            if p278.eventType ~= SkillEventConst.SyncEventType.ProximityStrikeWave then
                return;
            end;

            if p278.skillCastId and p278.skillCastId ~= p277.skillCastId then
                return;
            end;

            if p278.baseSkillInstanceId and p278.baseSkillInstanceId ~= p277.baseSkillInstanceId then
                return;
            end;

            local positions = p278.positions;
            local centerPos = p278.centerPos;

            if type(positions) ~= "table" or (#positions == 0 or typeof(centerPos) ~= "Vector3") then
                return;
            end;

            local skillRunData = p277.skillRunData;

            if not (skillRunData and skillRunData.material) then
                return;
            end;

            local runGeneration = p277.runGeneration;
            local v279;

            if p277._destroyed or p277.flowState == "Interrupted" then
                v279 = false;
            else
                v279 = p277.runGeneration == runGeneration;
            end;

            if not v279 then
                return;
            end;

            local v280 = skillRunData.material[u9];
            local v281 = skillRunData.material[u10];
            local v282 = skillRunData.material[u11];

            if not (v280 and (v281 and v282)) then
                return;
            end;

            local _, v283 = SkillCommon.scaleDualFromData(p277, SkillCommon.bandScaleOptsFromSkillData(p277));
            playProximityStrikeWaveVfx(p277, positions, centerPos, v280, v281, v282, v283, skillRunData, runGeneration);
        end;

        function v2.Client_EnterInterrupted(p284) -- Line: 988
            -- upvalues: SkillCommon (ref)
            local skillRunData = p284.skillRunData;

            if not skillRunData then
                return;
            end;

            SkillCommon.clearRunSpawnList(skillRunData, "UnicornAngerSpawned");

            if skillRunData.material then
                SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "雷系尾迹", "ThunderCast尾迹");
            end;
        end;

        function v2.Server_EnterInterrupted(p285) -- Line: 992
            local skillRunData = p285.skillRunData;

            if skillRunData and skillRunData.Logic then
                skillRunData.Logic.unicornAngerStrikeCancel = nil;
            end;
        end;

        function v2.Server_EnterRecovery(p286) -- Line: 996
            p286:releaseControl();
        end;

        function v2.Client_EnterRecovery(p287) -- Line: 1000
            -- upvalues: SkillCommon (ref)
            local skillRunData = p287.skillRunData;

            if skillRunData and skillRunData.material then
                SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "雷系尾迹", "ThunderCast尾迹");
            end;
        end;

        function v2.onEnd(p288) -- Line: 1007
            -- upvalues: SkillCommon (ref)
            local skillRunData = p288.skillRunData;

            if skillRunData then
                SkillCommon.clearRunSpawnList(skillRunData, "UnicornAngerSpawned");
            end;
        end;

        function v2.onClearRunData(p289, p290) -- Line: 1014
            -- upvalues: SkillCommon (ref)
            SkillCommon.clearRunSpawnList(p290, "UnicornAngerSpawned");
        end;

        function v2.onEndServer(p291) -- Line: 1018
            -- upvalues: u7 (copy)
            local skillRunData = p291.skillRunData;

            if skillRunData and skillRunData.Logic then
                skillRunData.Logic.unicornAngerStrikeCancel = nil;
            end;

            for i = 1, u7 do
                local v292 = p291.hitbox[i];

                if v292 then
                    if v292.isActive then
                        v292:stop();
                    end;

                    if v292.hitbox and v292.hitbox:IsA("BasePart") then
                        local hitbox = v292.hitbox;

                        if hitbox then
                            hitbox.Transparency = 1;
                        end;
                    end;
                end;
            end;
        end;

        v2.SoundList = { "音效-技能-独角兽-起手", "音效-技能-独角兽-预警", "音效-技能-独角兽-打雷1", "音效-技能-独角兽-打雷2", "音效-技能-独角兽-打雷3", "音效-技能-独角兽-打雷4", "音效-技能-独角兽-打雷5", "音效-技能-独角兽-打雷6", "音效-技能-独角兽-打雷7", "音效-技能-独角兽-打雷8", "音效-技能-独角兽-打雷9" };
        v2.AnimateList = { "独角兽之怒" };
        v2.ResNameList = { u11, u10, u9 };
        v2.hitboxConfig = {};

        for i = 1, u7 do
            v2.hitboxConfig[i] = {
                PartName = "通用球",
                CollisionGroup = "Player",
                HitPresentationProfile = "通用受击",
                PhysicsEffectName = "通用受击物理效果",
                HitboxIndex = i
            };
        end;

        v2.Action = {
            {
                action = "LookAt",
                startTime = 0,
                overTime = 2.3,
                speedType = "RELEASE_SKILL_STATE_HALF"
            },
            {
                action = "Animation",
                startTime = 0,
                overTime = 2.3,
                animationName = "独角兽之怒",
                animationSpeed = 1,
                animationFadeTime = 0.1,
                animationPriority = Enum.AnimationPriority.Action4
            }
        };

        return v2;
    end
};