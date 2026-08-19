-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local EntityUtil = require(script.Parent.Parent.BaseSkill.EntityUtil);
local HitQueryContext = require(script.Parent.Parent.BaseSkill.HitQueryContext);
local FXUtil = UtilsSystem.FXUtil;
local _ = UtilsSystem.RayCast;
local _ = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Light,
    skillDistanceLimit = 73
};
local u2 = {
    ["法阵1"] = {
        Show = {
            Time = 0,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, -0.34906584, 0)
        },
        Fade = {
            Time = 9.2,
            EasingTime = 0.6,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["法阵2"] = {
        Show = {
            Time = 0.93,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 0.34906584, 0)
        },
        Fade = {
            Time = 9,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["法阵3"] = {
        Show = {
            Time = 1,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, -0.34906584, 0)
        },
        Fade = {
            Time = 9,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["法阵4"] = {
        Show = {
            Time = 1.083,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 0.34906584, 0)
        },
        Fade = {
            Time = 9,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["法阵5"] = {
        Show = {
            Time = 1.166,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, -0.34906584, 0)
        },
        Fade = {
            Time = 9,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["法阵6"] = {
        Show = {
            Time = 1.249,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 0.34906584, 0)
        },
        Fade = {
            Time = 9,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["法阵7"] = {
        Show = {
            Time = 1.332,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, -0.34906584, 0)
        },
        Fade = {
            Time = 9,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["法阵8"] = {
        Show = {
            Time = 1.415,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 0.34906584, 0)
        },
        Fade = {
            Time = 9,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["法阵9"] = {
        Show = {
            Time = 1.498,
            EasingTime = 0.32,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, -0.34906584, 0)
        },
        Fade = {
            Time = 9,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    }
};
local u3 = {
    ["周边法阵上1"] = {
        Show = {
            Time = 0,
            EasingTime = 0.2,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 1.0471976, 0)
        },
        Fade = {
            Time = 7.517,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["周边法阵上2"] = {
        Show = {
            Time = 0,
            EasingTime = 0.2,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 1.0471976, 0)
        },
        Fade = {
            Time = 7.517,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["周边法阵上3"] = {
        Show = {
            Time = 0,
            EasingTime = 0.2,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 1.0471976, 0)
        },
        Fade = {
            Time = 7.517,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["周边法阵上4"] = {
        Show = {
            Time = 0,
            EasingTime = 0.2,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 1.0471976, 0)
        },
        Fade = {
            Time = 7.517,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    }
};
local u4 = {
    ["周边法阵下1"] = {
        Show = {
            Time = 0,
            EasingTime = 0.2,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 1.0471976, 0)
        },
        Fade = {
            Time = 7.57,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["周边法阵下2"] = {
        Show = {
            Time = 0,
            EasingTime = 0.2,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 1.0471976, 0)
        },
        Fade = {
            Time = 7.57,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["周边法阵下3"] = {
        Show = {
            Time = 0,
            EasingTime = 0.2,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 1.0471976, 0)
        },
        Fade = {
            Time = 7.57,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    },
    ["周边法阵下4"] = {
        Show = {
            Time = 0,
            EasingTime = 0.2,
            Transparency = 0,
            EasingStyle = Enum.EasingStyle.Back,
            EasingDir = Enum.EasingDirection.Out
        },
        Rotate = {
            Time = 0.1,
            Speed = Vector3.new(0, 1.0471976, 0)
        },
        Fade = {
            Time = 7.57,
            EasingTime = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDir = Enum.EasingDirection.In
        }
    }
};
local u5 = { "音效-技能-太阳耀斑-单次爆炸", "音效-技能-太阳耀斑-单次爆炸1", "音效-技能-太阳耀斑-单次爆炸2" };
v1.InitialState = "Startup";
v1.ControlOpenState = "SpellCircle";
v1.States = {
    Startup = {
        Duration = 1.12,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    SpellCircle = {
        Duration = 20,
        OnEnterClient = "Client_EnterSpellCircle",
        OnEnterServer = "Server_EnterSpellCircle",
        OnExitClient = "Client_ExitSpellCircle",
        OnExitServer = "Server_ExitSpellCircle"
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
        IsTerminal = true,
        OnEnterClient = "Client_EnterInterrupted"
    }
};
v1.Transitions = {
    {
        From = "Startup",
        To = "SpellCircle",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "SpellCircle",
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
        From = "SpellCircle",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "SpellCircle",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function get_skillScale(p6) -- Line: 453
    -- upvalues: SkillCommon (copy)
    return SkillCommon.scaleBandFromData(p6, SkillCommon.bandScaleOptsFromSkillData(p6));
end;

local function getSunHitboxSize(p7) -- Line: 457
    local v8 = 40 * (p7 or 1);

    return Vector3.new(v8, v8, v8);
end;

local function applyHitboxVisibility(p9, p10) -- Line: 463
    if not p9 then
        return;
    end;

    p9.Transparency = 1;
end;

local function flatDistance(p11, p12) -- Line: 474
    return (Vector3.new(p11.X, 0, p11.Z) - Vector3.new(p12.X, 0, p12.Z)).Magnitude;
end;

local function snapMeteorGroundPos(p13) -- Line: 480
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p13)).Position;
end;

local function isMeteorEnemyTarget(p14, p15, p16) -- Line: 484
    -- upvalues: EntityUtil (copy), HitQueryContext (copy)
    if p16 == p15 then
        return false;
    end;

    local v17 = p16:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = p16:FindFirstChild("HumanoidRootPart");

    if not v17 or (not HumanoidRootPart or (not HumanoidRootPart:IsA("BasePart") or v17.Health <= 0)) then
        return false;
    end;

    local _, v18 = EntityUtil.getEntityIdentity(p16);

    if p14.characterType == "NPC" then
        if v18 ~= "Player" and v18 ~= "Summon" then
            return false;
        end;
    elseif v18 ~= "NPC" then
        return false;
    end;

    local v19 = p14.hitbox[1];

    if not v19 then
        return not EntityUtil.isFriendly({
            id = p14.characterId,
            type = p14.characterType
        }, p16);
    end;

    local v20 = HitQueryContext.create(v19, p16, 0);

    return HitQueryContext.isDetectableTarget(v20);
end;

local function gatherNearbyEnemyPositions(u21, u22, u23, u24) -- Line: 515
    -- upvalues: isMeteorEnemyTarget (copy), SkillCommon (copy), Players (copy)
    local u25 = {};

    local function tryModel(p26) -- Line: 523
        -- upvalues: isMeteorEnemyTarget (ref), u21 (copy), u23 (copy), u22 (copy), u24 (copy), u25 (copy), SkillCommon (ref)
        if not (p26 and isMeteorEnemyTarget(u21, u23, p26)) then
            return;
        end;

        local HumanoidRootPart = p26:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local v27 = u22;
        local Position = HumanoidRootPart.Position;
        local Magnitude = (Vector3.new(v27.X, 0, v27.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude;

        if u24 * 40 < Magnitude then
            return;
        end;

        local v28 = {
            dist = Magnitude,
            pos = SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position)).Position
        };
        table.insert(u25, v28);
    end;

    if u21.characterType == "NPC" then
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

    table.sort(u25, function(p29, p30) -- Line: 564
        if p29.dist == p30.dist then
            return p29.pos.X < p30.pos.X;
        end;

        return p29.dist < p30.dist;
    end);
    local v31 = {};

    for i = 1, #u25 do
        v31[i] = u25[i].pos;
    end;

    return v31;
end;

local function resolveCurrentTargetWorldPos(p32) -- Line: 581
    -- upvalues: SkillCommon (copy)
    local skillInputData = p32.skillInputData;

    if skillInputData then
        skillInputData = SkillCommon.resolveTrackTargetHrp(skillInputData);
    end;

    if skillInputData then
        return skillInputData.Position;
    end;

    return nil;
end;

local function sampleRandomMeteorGroundPos(p33, p34, p35, p36) -- Line: 590
    -- upvalues: SkillCommon (copy)
    local v37 = Random.new(p34 + p35 * 9701);
    local v38 = v37:NextNumber();
    local v39 = math.sqrt(v38) * (p36 * 40);
    local v40 = v37:NextNumber() * 3.141592653589793 * 2;
    local v41 = math.cos(v40) * v39;
    local v42 = math.sin(v40) * v39;
    local v43 = p33 + Vector3.new(v41, 0, v42);

    return SkillCommon.getGroundCF(CFrame.new(v43)).Position;
end;

local function resolveMeteorEndWorldPos(p44, p45, p46, p47) -- Line: 604
    -- upvalues: sampleRandomMeteorGroundPos (copy), SkillCommon (copy), gatherNearbyEnemyPositions (copy)
    local Position = p45.Position;
    local skillInputData = p44.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if not skillInputData then
        return sampleRandomMeteorGroundPos(Position, p44.combatSeed or 0, p46, p47);
    end;

    local skillInputData2 = p44.skillInputData;

    if skillInputData2 then
        skillInputData2 = SkillCommon.resolveTrackTargetHrp(skillInputData2);
    end;

    local v48;

    if skillInputData2 then
        v48 = skillInputData2.Position;
    else
        v48 = nil;
    end;

    if v48 then
        return SkillCommon.getGroundCF(CFrame.new(v48)).Position;
    end;

    local v49 = gatherNearbyEnemyPositions(p44, Position, skillInputData, p47);

    if #v49 > 0 then
        return v49[(p46 - 1) % #v49 + 1];
    end;

    return sampleRandomMeteorGroundPos(Position, p44.combatSeed or 0, p46, p47);
end;

local function buildMeteorShotCFs(p50, p51, p52, p53) -- Line: 630
    -- upvalues: SkillCommon (copy)
    local v54 = Random.new(p51 + p52);
    local v55 = CFrame.new(SkillCommon.getGroundCF(CFrame.new(p50)).Position);
    local Position = v55.Position;
    local v56 = v54:NextNumber() * 3.141592653589793 * 2;
    local v57 = math.cos(v56);
    local v58 = math.sin(v56);
    local v59 = Vector3.new(v57, 0, v58) * 40 * p53 * v54:NextNumber();
    local v60 = Position + Vector3.new(0, p53 * 152, 0) + v59;

    return {
        StartCF = CFrame.new(v60, Position),
        EndCF = v55
    };
end;

local function ensureMeteorPlanLogic(p61) -- Line: 649
    if not p61.Logic then
        p61.Logic = {};
    end;

    if not p61.Logic.solarFlareMeteorPlan then
        p61.Logic.solarFlareMeteorPlan = {};
    end;

    return p61.Logic.solarFlareMeteorPlan;
end;

local function storeMeteorShotPlan(p62, p63, p64) -- Line: 659
    -- upvalues: ensureMeteorPlanLogic (copy)
    ensureMeteorPlanLogic(p62)[p63] = p64;
end;

local function getMeteorShotPlan(p65, p66) -- Line: 663
    local v67 = p65 and p65.Logic and p65.Logic.solarFlareMeteorPlan;

    if v67 then
        return v67[p66];
    end;

    return nil;
end;

local function decodeMeteorShotFromPositions(p68, p69) -- Line: 671
    local v70 = CFrame.new(p68, p69);

    return {
        StartCF = v70,
        EndCF = v70.Rotation + p69
    };
end;

local function commitAndSyncMeteorShot(p71, p72, p73, p74) -- Line: 680
    -- upvalues: SkillCommon (copy), resolveMeteorEndWorldPos (copy), buildMeteorShotCFs (copy), ensureMeteorPlanLogic (copy)
    SkillCommon.refreshSkillAimSnapshot(p71);
    local v75 = buildMeteorShotCFs(resolveMeteorEndWorldPos(p71, p72, p73, p74), p71.combatSeed or 0, p73, p74);
    ensureMeteorPlanLogic(p71.skillRunData)[p73] = v75;
    p71:fireSolarFlareMeteorShot(p73, v75.StartCF.Position, v75.EndCF.Position);

    return v75;
end;

local function waitForMeteorShotPlan(p76, p77, p78) -- Line: 697
    -- upvalues: RunService (copy)
    local v79 = os.clock() + 1.5;

    while p76:isRunningFlow() and p76.runGeneration == p78 do
        local skillRunData = p76.skillRunData;
        local v80 = skillRunData and skillRunData.Logic and skillRunData.Logic.solarFlareMeteorPlan;
        local v81;

        if v80 then
            v81 = v80[p77];
        else
            v81 = nil;
        end;

        if v81 then
            return v81;
        end;

        if v79 <= os.clock() then
            warn("[SolarFlare1] meteor shot sync timeout index=", p77);

            return nil;
        end;

        RunService.Heartbeat:Wait();
    end;

    return nil;
end;

local function is_Camera_In_Range(p82, p83) -- Line: 717
    return game["Run Service"]:IsClient() and (workspace.CurrentCamera.CFrame.Position - p82).Magnitude < p83 and true or false;
end;

local function getSpellCircleRunEventKeys() -- Line: 730
    local v84 = { "太阳耀斑光系尾迹", "核心法阵", "太阳耀斑周边法阵_下", "太阳耀斑周边法阵_上", "主体光柱" };
    table.insert(v84, "太阳运动" .. 1);
    table.insert(v84, "太阳运动" .. 2);
    table.insert(v84, "太阳运动" .. 3);
    table.insert(v84, "太阳运动" .. 4);
    table.insert(v84, "太阳运动" .. 5);
    table.insert(v84, "太阳运动" .. 6);
    table.insert(v84, "太阳运动" .. 7);
    table.insert(v84, "太阳运动" .. 8);
    table.insert(v84, "太阳运动" .. 9);
    table.insert(v84, "太阳运动" .. 10);
    table.insert(v84, "太阳运动" .. 11);
    table.insert(v84, "太阳运动" .. 12);
    table.insert(v84, "太阳运动" .. 13);
    table.insert(v84, "太阳运动" .. 14);
    table.insert(v84, "太阳运动" .. 15);
    table.insert(v84, "太阳运动" .. 16);
    table.insert(v84, "太阳运动" .. 17);
    table.insert(v84, "太阳运动" .. 18);
    table.insert(v84, "太阳运动" .. 19);
    table.insert(v84, "太阳运动" .. 20);

    return v84;
end;

local function disconnectSpellCircleRunEvents(p85) -- Line: 744
    -- upvalues: SkillCommon (copy), getSpellCircleRunEventKeys (copy)
    if not p85 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p85, (getSpellCircleRunEventKeys()));
end;

local function removeFromPooledSpawnList(p86, p87) -- Line: 751
    if not (p86 and p87) then
        return;
    end;

    local SolarFlarePooledSpawn = p86.SolarFlarePooledSpawn;

    if not SolarFlarePooledSpawn then
        return;
    end;

    for i = #SolarFlarePooledSpawn, 1, -1 do
        if SolarFlarePooledSpawn[i] == p87 then
            table.remove(SolarFlarePooledSpawn, i);
        end;
    end;

    if #SolarFlarePooledSpawn == 0 then
        p86.SolarFlarePooledSpawn = nil;
    end;
end;

local function returnPooledClone(p88, p89) -- Line: 769
    -- upvalues: FXUtil (copy), removeFromPooledSpawnList (copy)
    if not (p89 and p89:IsA("Model")) then
        return;
    end;

    if p89.Parent then
        FXUtil.Stop_All_Emit(p89);
        FXUtil.BackPool_Instance(p89);
    end;

    removeFromPooledSpawnList(p88, p89);
end;

local function returnPooledSpawnList(p90) -- Line: 780
    -- upvalues: FXUtil (copy), removeFromPooledSpawnList (copy)
    if not p90 then
        return;
    end;

    local SolarFlarePooledSpawn = p90.SolarFlarePooledSpawn;

    if not SolarFlarePooledSpawn then
        return;
    end;

    local v91 = {};

    for _, v in SolarFlarePooledSpawn do
        if v and v:IsA("Model") then
            table.insert(v91, v);
        end;
    end;

    for _, v in v91 do
        if v then
            if v:IsA("Model") then
                if v.Parent then
                    FXUtil.Stop_All_Emit(v);
                    FXUtil.BackPool_Instance(v);
                end;

                removeFromPooledSpawnList(p90, v);
            end;
        end;
    end;

    p90.SolarFlarePooledSpawn = nil;
end;

local function cleanupLightTrailRunData(p92) -- Line: 800
    if not p92 then
        return;
    end;

    local v93 = p92.runEvent and p92.runEvent["太阳耀斑光系尾迹"];

    if v93 and typeof(v93) == "RBXScriptConnection" then
        v93:Disconnect();
        p92.runEvent["太阳耀斑光系尾迹"] = nil;
    end;

    local solarFlareLightTrailModel = p92.solarFlareLightTrailModel;

    if solarFlareLightTrailModel and solarFlareLightTrailModel.Parent then
        for _, descendant in pairs(solarFlareLightTrailModel:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    p92.solarFlareLightTrailModel = nil;
end;

local function clearClientVisualRunData(p94) -- Line: 820
    -- upvalues: SkillCommon (copy), getSpellCircleRunEventKeys (copy), returnPooledSpawnList (copy), cleanupLightTrailRunData (copy)
    if not p94 then
        return;
    end;

    if p94 then
        SkillCommon.disconnectRunEventKeys(p94, (getSpellCircleRunEventKeys()));
    end;

    returnPooledSpawnList(p94);
    cleanupLightTrailRunData(p94);
end;

function v1.Client_EnterStartup(u95) -- Line: 830
    -- upvalues: SkillCommon (copy), cleanupLightTrailRunData (copy), RunService (copy)
    local character = u95.skillInputData.character;

    if not character then
        return;
    end;

    local u96 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u96 then
        return;
    end;

    local runGeneration = u95.runGeneration;
    local u97 = nil;
    local u98 = nil;

    local function stillTrail() -- Line: 844
        -- upvalues: u95 (copy), runGeneration (copy)
        local v99 = u95:isRunningFlow() and u95.runGeneration == runGeneration;

        return v99;
    end;

    local function cleanupLightTrail() -- Line: 848
        -- upvalues: u97 (ref), u98 (ref), cleanupLightTrailRunData (ref), u95 (copy)
        if u97 then
            for _, descendant in pairs(u97:GetDescendants()) do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;

        if u98 then
            u98:Disconnect();
            u98 = nil;
        end;

        u97 = nil;
        cleanupLightTrailRunData(u95.skillRunData);
    end;

    task.delay(0.63, function() -- Line: 864
        -- upvalues: u95 (copy), runGeneration (copy), u97 (ref), u98 (ref), RunService (ref), u96 (copy)
        local v100 = u95:isRunningFlow() and u95.runGeneration == runGeneration;

        if not v100 then
            return;
        end;

        local skillRunData = u95.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local v101 = skillRunData.material["光系尾迹"];

        if not v101 then
            return;
        end;

        u97 = v101;
        skillRunData.solarFlareLightTrailModel = v101;

        for _, descendant in pairs(v101:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        v101.Parent = workspace.Debris;

        if not skillRunData.runEvent then
            skillRunData.runEvent = {};
        end;

        u98 = RunService.RenderStepped:Connect(function() -- Line: 887
            -- upvalues: u96 (ref), u97 (ref)
            if u96.Parent and u97 then
                u97:PivotTo(u96:GetPivot());
            end;
        end);
        skillRunData.runEvent["太阳耀斑光系尾迹"] = u98;
    end);
    task.delay(5.73, function() -- Line: 895
        -- upvalues: u95 (copy), runGeneration (copy), cleanupLightTrail (copy)
        if u95.runGeneration ~= runGeneration then
            return;
        end;

        cleanupLightTrail();
    end);
end;

function v1.Server_EnterStartup(p102) -- Line: 903
    for i = 1, 20 do
        local v103 = p102.hitbox[i];

        if v103 and v103.hitbox then
            v103.hitbox.Size = Vector3.new(40, 40, 40);
        end;
    end;
end;

function v1.Client_EnterSpellCircle(u104) -- Line: 913
    -- upvalues: SkillCommon (copy), RunService (copy), u4 (copy), FXUtil (copy), u3 (copy), u2 (copy), removeFromPooledSpawnList (copy), waitForMeteorShotPlan (copy), u5 (copy)
    local releaseCF = u104.skillInputData.releaseCF;
    local u105 = SkillCommon.scaleBandFromData(u104, SkillCommon.bandScaleOptsFromSkillData(u104));
    local u106 = releaseCF - Vector3.new(0, 2.5, 0);
    local runGeneration = u104.runGeneration;

    local function still() -- Line: 926
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy)
        return SkillCommon.isRunningSameGeneration(u104, runGeneration);
    end;

    task.delay(1.43, function() -- Line: 931
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u106 (copy), u105 (copy), RunService (ref), u4 (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
            return;
        end;

        local skillRunData = u104.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local u107 = skillRunData.material["太阳耀斑周边法阵_下"];

        if not u107 then
            return;
        end;

        for _, descendant in pairs(u107:GetDescendants()) do
            if descendant:IsA("Decal") then
                descendant.Transparency = 1;
            end;
        end;

        local u108 = u106 + Vector3.new(0, 19, 0) * u105;
        u107:PivotTo(u108);
        u107.Parent = workspace.Debris;
        local u109 = {};
        local u110 = 0;
        skillRunData.runEvent["太阳耀斑周边法阵_下"] = RunService.Heartbeat:Connect(function(p111) -- Line: 955
            -- upvalues: SkillCommon (ref), u104 (ref), runGeneration (ref), skillRunData (copy), u110 (ref), u107 (copy), u108 (copy), u4 (ref), u109 (copy), FXUtil (ref), u105 (ref)
            if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
                local v112 = skillRunData.runEvent["太阳耀斑周边法阵_下"];

                if v112 then
                    v112:Disconnect();
                    skillRunData.runEvent["太阳耀斑周边法阵_下"] = nil;
                end;

                return;
            end;

            u110 = u110 + p111;
            u107:PivotTo(u108:ToWorldSpace(CFrame.Angles(0, u110 * -0.3490658503988659, 0)));

            for i, v in pairs(u4) do
                local v113 = u107:FindFirstChild(i);

                if v113 then
                    if not u109[i] then
                        u109[i] = {
                            IsShow = false,
                            IsRotate = false,
                            IsFade = false
                        };
                    end;

                    if not u109[i].IsShow and u110 >= v.Show.Time then
                        u109[i].IsShow = true;
                        local PrimaryPart = v113.PrimaryPart;
                        local v114 = PrimaryPart and PrimaryPart:FindFirstChildOfClass("Decal");

                        if v114 then
                            FXUtil.Tween_Instance(v114, TweenInfo.new(0.1), {
                                Transparency = v.Show.Transparency
                            });
                        end;

                        FXUtil.Model_Scale_Tween(v113, 0.01, u105 * 1, v.Show.EasingTime, v.Show.EasingStyle, v.Show.EasingDir, nil, true);

                        for _, descendant in pairs(v113:GetDescendants()) do
                            if descendant:IsA("Beam") then
                                descendant.Enabled = true;
                                FXUtil.Beam_Fade_From_Transparent(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                            end;
                        end;
                    end;

                    if not u109[i].IsFade and u110 >= v.Fade.Time then
                        u109[i].IsFade = true;
                        local PrimaryPart = v113.PrimaryPart;
                        local v115 = PrimaryPart and PrimaryPart:FindFirstChildOfClass("Decal");

                        if v115 then
                            FXUtil.Tween_Instance(v115, TweenInfo.new(v.Fade.EasingTime, v.Fade.EasingStyle, v.Fade.EasingDir), {
                                Transparency = 1
                            });
                        end;

                        for _, descendant in pairs(v113:GetDescendants()) do
                            if descendant:IsA("Beam") then
                                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                            end;
                        end;
                    end;
                end;
            end;
        end);
    end);
    task.delay(1.483, function() -- Line: 1035
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u106 (copy), u105 (copy), RunService (ref), u3 (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
            return;
        end;

        local skillRunData = u104.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local u116 = skillRunData.material["太阳耀斑周边法阵_上"];

        if not u116 then
            return;
        end;

        for _, descendant in pairs(u116:GetDescendants()) do
            if descendant:IsA("Decal") then
                descendant.Transparency = 1;
            end;
        end;

        local u117 = u106 + Vector3.new(0, 50, 0) * u105;
        u116:PivotTo(u117);
        u116.Parent = workspace.Debris;
        local u118 = {};
        local u119 = 0;
        skillRunData.runEvent["太阳耀斑周边法阵_上"] = RunService.Heartbeat:Connect(function(p120) -- Line: 1059
            -- upvalues: SkillCommon (ref), u104 (ref), runGeneration (ref), skillRunData (copy), u119 (ref), u116 (copy), u117 (copy), u3 (ref), u118 (copy), FXUtil (ref), u105 (ref)
            if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
                local v121 = skillRunData.runEvent["太阳耀斑周边法阵_上"];

                if v121 then
                    v121:Disconnect();
                    skillRunData.runEvent["太阳耀斑周边法阵_上"] = nil;
                end;

                return;
            end;

            u119 = u119 + p120;
            u116:PivotTo(u117:ToWorldSpace(CFrame.Angles(0, u119 * 0.3490658503988659, 0)));

            for i, v in pairs(u3) do
                local v122 = u116:FindFirstChild(i);

                if v122 then
                    if not u118[i] then
                        u118[i] = {
                            IsShow = false,
                            IsRotate = false,
                            IsFade = false
                        };
                    end;

                    if not u118[i].IsShow and u119 >= v.Show.Time then
                        u118[i].IsShow = true;
                        local PrimaryPart = v122.PrimaryPart;
                        local v123 = PrimaryPart and PrimaryPart:FindFirstChildOfClass("Decal");

                        if v123 then
                            FXUtil.Tween_Instance(v123, TweenInfo.new(v.Show.EasingTime, v.Show.EasingStyle, v.Show.EasingDir), {
                                Transparency = v.Show.Transparency
                            });
                        end;

                        FXUtil.Model_Scale_Tween(v122, 0.01, u105 * 1, v.Show.EasingTime, v.Show.EasingStyle, v.Show.EasingDir, nil, true);

                        for _, descendant in pairs(v122:GetDescendants()) do
                            if descendant:IsA("Beam") then
                                descendant.Enabled = true;
                                FXUtil.Beam_Fade_From_Transparent(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                            end;
                        end;
                    end;

                    if not u118[i].IsFade and u119 >= v.Fade.Time then
                        u118[i].IsFade = true;
                        local PrimaryPart = v122.PrimaryPart;
                        local v124 = PrimaryPart and PrimaryPart:FindFirstChildOfClass("Decal");

                        if v124 then
                            FXUtil.Tween_Instance(v124, TweenInfo.new(v.Fade.EasingTime, v.Fade.EasingStyle, v.Fade.EasingDir), {
                                Transparency = 1
                            });
                        end;

                        for _, descendant in pairs(v122:GetDescendants()) do
                            if descendant:IsA("Beam") then
                                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                            end;
                        end;
                    end;
                end;
            end;
        end);
    end);
    task.delay(0, function() -- Line: 1138
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u106 (copy), u105 (copy), RunService (ref), u2 (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
            return;
        end;

        local skillRunData = u104.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local u125 = skillRunData.material["太阳耀斑核心法阵"];

        if not u125 then
            return;
        end;

        SkillCommon.playSoundLocal3D("音效-技能-太阳耀斑-光法阵", u106.Position);

        for _, descendant in pairs(u125:GetDescendants()) do
            if descendant:IsA("Decal") then
                descendant.Transparency = 1;
            end;
        end;

        u125:PivotTo(u106);
        u125:ScaleTo(u105);
        u125.Parent = workspace.Debris;
        local u126 = {};
        local u127 = 0;
        skillRunData.runEvent["核心法阵"] = RunService.Heartbeat:Connect(function(p128) -- Line: 1163
            -- upvalues: SkillCommon (ref), u104 (ref), runGeneration (ref), skillRunData (copy), u127 (ref), u2 (ref), u125 (copy), u126 (copy), FXUtil (ref), u105 (ref)
            if SkillCommon.isRunningSameGeneration(u104, runGeneration) then
                u127 = u127 + p128;

                for i, v in pairs(u2) do
                    local v129 = u125:FindFirstChild(i);

                    if v129 then
                        if not u126[i] then
                            u126[i] = {
                                IsShow = false,
                                IsRotate = false,
                                IsFade = false
                            };
                        end;

                        if not u126[i].IsShow and u127 >= v.Show.Time then
                            u126[i].IsShow = true;
                            local PrimaryPart = v129.PrimaryPart;
                            local v130 = PrimaryPart and PrimaryPart:FindFirstChildOfClass("Decal");

                            if v130 then
                                FXUtil.Tween_Instance(v130, TweenInfo.new(0.1), {
                                    Transparency = v.Show.Transparency
                                });
                            end;

                            FXUtil.Model_Scale_Tween(v129, 0.01, u105 * 1, v.Show.EasingTime, v.Show.EasingStyle, v.Show.EasingDir, nil, true);

                            if i == "法阵1" then
                                FXUtil.Emit_Particles_GetDescendants(u125, true);
                            end;
                        end;

                        if not u126[i].IsRotate and u127 >= v.Rotate.Time then
                            u126[i].IsRotate = true;
                            u126[i].OriCFrame = v129:GetPivot();
                        end;

                        if u126[i].IsRotate == true then
                            local v131 = u127 - v.Rotate.Time;
                            local Speed = v.Rotate.Speed;
                            v129:PivotTo(u126[i].OriCFrame * CFrame.Angles(Speed.X * v131, Speed.Y * v131, Speed.Z * v131));
                        end;

                        if not u126[i].IsFade and u127 >= v.Fade.Time then
                            u126[i].IsFade = true;
                            local PrimaryPart = v129.PrimaryPart;

                            if PrimaryPart then
                                local v132 = PrimaryPart:FindFirstChildOfClass("Decal");

                                if v132 then
                                    FXUtil.Tween_Instance(v132, TweenInfo.new(v.Fade.EasingTime, v.Fade.EasingStyle, v.Fade.EasingDir), {
                                        Transparency = 1
                                    });
                                end;
                            end;
                        end;
                    end;
                end;

                return;
            end;

            local v133 = skillRunData.runEvent["核心法阵"];

            if v133 then
                v133:Disconnect();
                skillRunData.runEvent["核心法阵"] = nil;
            end;
        end);
    end);
    local u134 = nil;
    local u135 = nil;

    if SkillCommon.isRunningSameGeneration(u104, runGeneration) then
        local skillRunData = u104.skillRunData;

        if skillRunData and skillRunData.material then
            u134 = skillRunData.material["太阳耀斑起手光晕吸收"];
            u135 = skillRunData.material["太阳耀斑起手光晕爆"];
        end;

        if u134 and u135 then
            u134:PivotTo(u106 + Vector3.new(0, 19, 0) * u105);
            u135:PivotTo(u106 + Vector3.new(0, 19, 0) * u105);
            u134.Parent = workspace.Debris;
            u135.Parent = workspace.Debris;
        end;
    end;

    task.delay(0.183, function() -- Line: 1248
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u134 (ref), FXUtil (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u134 and u134.Parent)) then
            return;
        end;

        SkillCommon.playSoundLocal3D("音效-技能-太阳耀斑-法阵上升", u134:GetPivot().Position);
        FXUtil.Start_All_Emit(u134, 1);
    end);
    task.delay(0.833, function() -- Line: 1256
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u134 (ref), FXUtil (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u134 and u134.Parent)) then
            return;
        end;

        FXUtil.Stop_All_Emit(u134);
    end);
    task.delay(1.583, function() -- Line: 1263
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u135 (ref), FXUtil (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u135 and u135.Parent)) then
            return;
        end;

        FXUtil.Emit_Particles_GetDescendants(u135, true);
    end);
    task.delay(0, function() -- Line: 1270
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u106 (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
            return;
        end;

        local Position = u106.Position;

        if game["Run Service"]:IsClient() and (workspace.CurrentCamera.CFrame.Position - Position).Magnitude < 200 and true or false then
            local v136 = {
                brightness = {
                    {
                        value = 0.02,
                        time = 1.633,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = -0.4,
                        time = 1.666,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = 0.8,
                        time = 1.7,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = -0.2,
                        time = 1.766,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = 0.02,
                        time = 1.983,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = 0.02,
                        time = 1.983,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    }
                },
                tintColor = {
                    {
                        time = 0.16,
                        value = Color3.new(0.980392, 0.980392, 0.980392),
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        time = 0.833,
                        value = Color3.new(1, 0.635294, 0.615686),
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        time = 2,
                        value = Color3.new(1, 0.792157, 0.819608),
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        time = 8.166,
                        value = Color3.new(1, 0.792157, 0.819608),
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        time = 10,
                        value = Color3.new(1, 1, 1),
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    }
                },
                saturation = {
                    {
                        value = 0.2,
                        time = 0.16,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = 0.5,
                        time = 0.833,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = 0.2,
                        time = 1.633,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = -1,
                        time = 1.666,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = -6,
                        time = 1.682,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = 1,
                        time = 1.698,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = -1,
                        time = 1.766,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    },
                    {
                        value = 0.2,
                        time = 1.983,
                        easingStyle = Enum.EasingStyle.Linear,
                        easingDir = Enum.EasingDirection.In
                    }
                }
            };
            FXUtil.Tween_ColorCorrection(v136);
        end;
    end);
    local u137 = nil;
    local u138 = nil;

    if SkillCommon.isRunningSameGeneration(u104, runGeneration) then
        local skillRunData = u104.skillRunData;

        if skillRunData and skillRunData.material then
            u137 = skillRunData.material["太阳耀斑光柱"];
            u138 = skillRunData.material["太阳耀斑施法持续光晕"];
        end;

        if u137 and u138 then
            u137:PivotTo(u106 + Vector3.new(0, 32, 0) * u105);
            u137.Parent = workspace.Debris;
            u138:PivotTo(u106 + Vector3.new(0, 7, 0) * u105);
            u138.Parent = workspace.Debris;
        end;
    end;

    task.delay(1.583, function() -- Line: 1420
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u138 (ref), u137 (ref), FXUtil (ref), u105 (copy), RunService (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u138 and (u138.Parent and (u137 and u137.Parent)))) then
            return;
        end;

        FXUtil.Start_All_Emit(u138, 10);

        if not (u137:FindFirstChild("光线") and u137["光线"]:FindFirstChild("1tou")) then
            return;
        end;

        for _, descendant in pairs(u137:GetDescendants()) do
            if descendant:IsA("Beam") then
                descendant.Enabled = true;
                FXUtil.Beam_Fade_From_Transparent(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;
        end;

        local skillRunData = u104.skillRunData;

        if not skillRunData then
            return;
        end;

        local u139 = u137["光线"]["1tou"];
        local u140 = 0;
        local u141 = CFrame.new(0, u105 * -34.561, 0) * CFrame.Angles(0, 0, 1.5707963267948966);
        local u142 = u141 + Vector3.new(0, u105 * 152, 0);
        skillRunData.runEvent["主体光柱"] = RunService.Heartbeat:Connect(function(p143) -- Line: 1446
            -- upvalues: SkillCommon (ref), u104 (ref), runGeneration (ref), skillRunData (copy), u140 (ref), u139 (copy), u141 (copy), u142 (copy)
            if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
                local v144 = skillRunData.runEvent["主体光柱"];

                if v144 then
                    v144:Disconnect();
                    skillRunData.runEvent["主体光柱"] = nil;
                end;

                return;
            end;

            u140 = u140 + p143;
            local v145 = game.TweenService:GetValue(math.clamp(u140 / 0.2, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            u139.CFrame = u141:Lerp(u142, v145);
            local v146 = v145 == 1 and skillRunData.runEvent["主体光柱"];

            if v146 then
                v146:Disconnect();
                skillRunData.runEvent["主体光柱"] = nil;
            end;
        end);
    end);
    task.delay(8.333, function() -- Line: 1473
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u138 (ref), FXUtil (ref), u137 (ref)
        if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
            return;
        end;

        if u138 and u138.Parent then
            FXUtil.Stop_All_Emit(u138);
        end;

        if u137 and u137.Parent then
            for _, descendant in pairs(u137:GetDescendants()) do
                if descendant:IsA("Beam") then
                    FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                end;
            end;
        end;
    end);
    local u147 = nil;
    local u148 = nil;
    local u149 = nil;

    if SkillCommon.isRunningSameGeneration(u104, runGeneration) then
        local skillRunData = u104.skillRunData;

        if skillRunData and skillRunData.material then
            u147 = skillRunData.material["太阳耀斑内侧云"];
            u148 = skillRunData.material["太阳耀斑外侧云"];
            u149 = skillRunData.material["太阳耀斑光束爆炸"];
        end;

        if u147 and (u148 and u149) then
            u147:PivotTo(u106 + Vector3.new(0, 122, 0) * u105);
            u148:PivotTo(u106 + Vector3.new(0, 123, 0) * u105);
            u149:PivotTo(u106 + Vector3.new(0, 122, 0) * u105);
            u147.Parent = workspace.Debris;
            u148.Parent = workspace.Debris;
            u149.Parent = workspace.Debris;
        end;
    end;

    task.delay(1.816, function() -- Line: 1512
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u147 (ref), FXUtil (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u147 and u147.Parent)) then
            return;
        end;

        FXUtil.Start_All_Emit(u147, 10);
    end);
    task.delay(5, function() -- Line: 1519
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u147 (ref), FXUtil (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u147 and u147.Parent)) then
            return;
        end;

        FXUtil.Stop_All_Emit(u147);
    end);
    task.delay(1.816, function() -- Line: 1526
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u148 (ref), FXUtil (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u148 and u148.Parent)) then
            return;
        end;

        FXUtil.Start_All_Emit(u148, 10);
    end);
    task.delay(8.016, function() -- Line: 1532
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u148 (ref), FXUtil (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u148 and u148.Parent)) then
            return;
        end;

        FXUtil.Stop_All_Emit(u148);
    end);
    task.delay(1.8, function() -- Line: 1539
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u149 (ref), FXUtil (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u149 and u149.Parent)) then
            return;
        end;

        FXUtil.Emit_Particles_GetDescendants(u149, true);
    end);
    local skillRunData = u104.skillRunData;
    local u150, u151;

    if skillRunData and skillRunData.material then
        u150 = skillRunData.material["太阳耀斑太阳"];
        u151 = skillRunData.material["太阳耀斑爆炸"];
    else
        u150 = nil;
        u151 = nil;
    end;

    local function disconnectSunMotion(p152, p153) -- Line: 1555
        local v154 = "太阳运动" .. p153;
        local v155 = p152.runEvent and p152.runEvent[v154];

        if v155 then
            v155:Disconnect();
            p152.runEvent[v154] = nil;
        end;
    end;

    local function scheduleMeteorCloneReturn(u156, u157, u158) -- Line: 1564
        -- upvalues: u104 (copy), runGeneration (copy), FXUtil (ref), removeFromPooledSpawnList (ref)
        task.delay(2, function() -- Line: 1565
            -- upvalues: u104 (ref), runGeneration (ref), u156 (copy), u157 (copy), FXUtil (ref), removeFromPooledSpawnList (ref), u158 (copy)
            if u104._destroyed or u104.runGeneration ~= runGeneration then
                return;
            end;

            local v159 = u156;
            local v160 = u157;

            if v160 and v160:IsA("Model") then
                if v160.Parent then
                    FXUtil.Stop_All_Emit(v160);
                    FXUtil.BackPool_Instance(v160);
                end;

                removeFromPooledSpawnList(v159, v160);
            end;

            if u158 then
                local v161 = u156;
                local v162 = u158;

                if v162 then
                    if not v162:IsA("Model") then
                        return;
                    end;

                    if v162.Parent then
                        FXUtil.Stop_All_Emit(v162);
                        FXUtil.BackPool_Instance(v162);
                    end;

                    removeFromPooledSpawnList(v161, v162);
                end;
            end;
        end);
    end;

    local function u194(u163) -- Line: 1576
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u150 (ref), u151 (ref), waitForMeteorShotPlan (ref), FXUtil (ref), u105 (copy), RunService (ref), removeFromPooledSpawnList (ref), u5 (ref)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u150 and u151)) then
            return;
        end;

        local skillRunData2 = u104.skillRunData;

        if not skillRunData2 then
            return;
        end;

        local v164 = waitForMeteorShotPlan(u104, u163, runGeneration);

        if not v164 then
            return;
        end;

        local u165 = CFrame.new(v164.StartCF.Position, v164.EndCF.Position);
        local u166 = u165.Rotation + v164.EndCF.Position;
        local u167 = FXUtil.GetInstance_From_Pool(u150);

        if not (u167 and u167:IsA("Model")) then
            return;
        end;

        SkillCommon.appendRunSpawnList(skillRunData2, "SolarFlarePooledSpawn", u167);
        u167:PivotTo(u165);
        u167.Parent = workspace.Debris;
        FXUtil.Start_All_Emit(u167, 10);

        for _, descendant in pairs(u167:GetDescendants()) do
            if descendant:IsA("Beam") then
                descendant.Enabled = true;
                FXUtil.Beam_Fade_From_Transparent(descendant, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;
        end;

        FXUtil.Model_Scale_Tween(u167, 0.01, u105 * 1, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, nil, true);
        local u168 = 0;
        skillRunData2.runEvent["太阳运动" .. u163] = RunService.Heartbeat:Connect(function(p169) -- Line: 1612
            -- upvalues: SkillCommon (ref), u104 (ref), runGeneration (ref), skillRunData2 (copy), u163 (copy), u167 (copy), FXUtil (ref), removeFromPooledSpawnList (ref), u168 (ref), u165 (copy), u166 (copy), u5 (ref), u151 (ref), u105 (ref)
            if SkillCommon.isRunningSameGeneration(u104, runGeneration) then
                u168 = u168 + p169;
                local v170 = game.TweenService:GetValue(math.clamp(u168 / 0.8, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                u167:PivotTo(u165:Lerp(u166, v170));

                if v170 == 1 then
                    local v171 = skillRunData2;
                    local v172 = "太阳运动" .. u163;
                    local v173 = v171.runEvent and v171.runEvent[v172];

                    if v173 then
                        v173:Disconnect();
                        v171.runEvent[v172] = nil;
                    end;

                    FXUtil.Stop_All_Emit(u167);

                    for _, descendant in pairs(u167:GetDescendants()) do
                        if descendant:IsA("Beam") then
                            FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                        end;

                        if descendant:IsA("Decal") then
                            FXUtil.Tween_Instance(descendant, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                Transparency = 1
                            });
                        end;

                        if descendant:IsA("MeshPart") then
                            FXUtil.Tween_Instance(descendant, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                Transparency = 1
                            });
                        end;
                    end;

                    local v174 = SkillCommon.pickRandomSoundName(u5);

                    if v174 then
                        SkillCommon.playSoundLocal3D(v174, u167:GetPivot().Position);
                    end;

                    local u175 = FXUtil.GetInstance_From_Pool(u151);

                    if u175 and u175:IsA("Model") then
                        SkillCommon.appendRunSpawnList(skillRunData2, "SolarFlarePooledSpawn", u175);
                        u175:PivotTo(CFrame.new(u166.Position));
                        u175:ScaleTo(u105);
                        u175.Parent = workspace.Debris;
                        FXUtil.Emit_Particles_GetDescendants(u175, true);
                        local u176 = skillRunData2;
                        local u177 = u167;
                        task.delay(2, function() -- Line: 1565
                            -- upvalues: u104 (ref), runGeneration (ref), u176 (copy), u177 (copy), FXUtil (ref), removeFromPooledSpawnList (ref), u175 (copy)
                            if u104._destroyed or u104.runGeneration ~= runGeneration then
                                return;
                            end;

                            local v178 = u176;
                            local v179 = u177;

                            if v179 and v179:IsA("Model") then
                                if v179.Parent then
                                    FXUtil.Stop_All_Emit(v179);
                                    FXUtil.BackPool_Instance(v179);
                                end;

                                removeFromPooledSpawnList(v178, v179);
                            end;

                            if u175 then
                                local v180 = u176;
                                local v181 = u175;

                                if v181 then
                                    if not v181:IsA("Model") then
                                        return;
                                    end;

                                    if v181.Parent then
                                        FXUtil.Stop_All_Emit(v181);
                                        FXUtil.BackPool_Instance(v181);
                                    end;

                                    removeFromPooledSpawnList(v180, v181);
                                end;
                            end;
                        end);

                        return;
                    end;

                    local u182 = skillRunData2;
                    local u183 = u167;
                    local u184 = nil;
                    task.delay(2, function() -- Line: 1565
                        -- upvalues: u104 (ref), runGeneration (ref), u182 (copy), u183 (copy), FXUtil (ref), removeFromPooledSpawnList (ref), u184 (copy)
                        if u104._destroyed or u104.runGeneration ~= runGeneration then
                            return;
                        end;

                        local v185 = u182;
                        local v186 = u183;

                        if v186 and v186:IsA("Model") then
                            if v186.Parent then
                                FXUtil.Stop_All_Emit(v186);
                                FXUtil.BackPool_Instance(v186);
                            end;

                            removeFromPooledSpawnList(v185, v186);
                        end;

                        if u184 then
                            local v187 = u182;
                            local v188 = u184;

                            if v188 then
                                if not v188:IsA("Model") then
                                    return;
                                end;

                                if v188.Parent then
                                    FXUtil.Stop_All_Emit(v188);
                                    FXUtil.BackPool_Instance(v188);
                                end;

                                removeFromPooledSpawnList(v187, v188);
                            end;
                        end;
                    end);
                end;

                return;
            end;

            local v189 = skillRunData2;
            local v190 = "太阳运动" .. u163;
            local v191 = v189.runEvent and v189.runEvent[v190];

            if v191 then
                v191:Disconnect();
                v189.runEvent[v190] = nil;
            end;

            local v192 = skillRunData2;
            local v193 = u167;

            if v193 then
                if not v193:IsA("Model") then
                    return;
                end;

                if v193.Parent then
                    FXUtil.Stop_All_Emit(v193);
                    FXUtil.BackPool_Instance(v193);
                end;

                removeFromPooledSpawnList(v192, v193);
            end;
        end);
    end;

    task.delay(2.26, function() -- Line: 1664
        -- upvalues: SkillCommon (ref), u104 (copy), runGeneration (copy), u150 (ref), u151 (ref), u106 (copy), u194 (copy)
        if not (SkillCommon.isRunningSameGeneration(u104, runGeneration) and (u150 and u151)) then
            return;
        end;

        SkillCommon.playSoundLocal3D("音效-技能-太阳耀斑-下落背景音", u106.Position);

        for i = 1, 20 do
            if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
                break;
            end;

            u194(i);

            if i < 20 then
                task.wait(0.25);

                if not SkillCommon.isRunningSameGeneration(u104, runGeneration) then
                    break;
                end;
            end;
        end;
    end);
end;

function v1.Client_ExitSpellCircle(p195) -- Line: 1685
    -- upvalues: SkillCommon (copy), getSpellCircleRunEventKeys (copy), returnPooledSpawnList (copy), cleanupLightTrailRunData (copy)
    local skillRunData = p195.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, (getSpellCircleRunEventKeys()));
    end;

    returnPooledSpawnList(skillRunData);
    cleanupLightTrailRunData(skillRunData);
end;

function v1.Client_EnterInterrupted(p196) -- Line: 1689
    -- upvalues: SkillCommon (copy), getSpellCircleRunEventKeys (copy), returnPooledSpawnList (copy), cleanupLightTrailRunData (copy)
    local skillRunData = p196.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, (getSpellCircleRunEventKeys()));
    end;

    returnPooledSpawnList(skillRunData);
    cleanupLightTrailRunData(skillRunData);
end;

function v1.Server_EnterSpellCircle(u197) -- Line: 1693
    -- upvalues: SkillCommon (copy), commitAndSyncMeteorShot (copy)
    local runGeneration = u197.runGeneration;
    local u198 = u197.skillInputData.releaseCF - Vector3.new(0, 2.5, 0);
    local u199 = SkillCommon.scaleBandFromData(u197, SkillCommon.bandScaleOptsFromSkillData(u197));
    task.delay(2.26, function() -- Line: 1698
        -- upvalues: u197 (copy), runGeneration (copy), commitAndSyncMeteorShot (ref), u198 (copy), u199 (copy)
        if not u197:isRunningFlow() or u197.runGeneration ~= runGeneration then
            return;
        end;

        for i = 1, 20 do
            if not u197:isRunningFlow() or u197.runGeneration ~= runGeneration then
                break;
            end;

            local u200 = commitAndSyncMeteorShot(u197, u198, i, u199);
            local u201 = u197.hitbox[i];

            if u201 then
                task.delay(0.8, function() -- Line: 1710
                    -- upvalues: u197 (ref), runGeneration (ref), u201 (copy), u199 (ref), u200 (copy)
                    if not u197:isRunningFlow() or u197.runGeneration ~= runGeneration then
                        return;
                    end;

                    if u201 and u201.hitbox then
                        local hitbox = u201.hitbox;

                        if hitbox:IsA("BasePart") then
                            hitbox.Shape = Enum.PartType.Ball;
                        end;

                        local v202 = 40 * (u199 or 1);
                        hitbox.Size = Vector3.new(v202, v202, v202);
                        hitbox:PivotTo(u200.EndCF);
                        local hitbox2 = u201.hitbox;

                        if hitbox2 then
                            hitbox2.Transparency = 1;
                        end;

                        u201:start();
                        task.delay(0.2, function() -- Line: 1723
                            -- upvalues: u201 (ref)
                            if u201.isActive then
                                u201:stop();
                            end;

                            local hitbox3 = u201.hitbox;

                            if not hitbox3 then
                                return;
                            end;

                            hitbox3.Transparency = 1;
                        end);
                    end;
                end);
            end;

            if i < 20 then
                task.wait(0.25);
            end;
        end;
    end);
end;

function v1.Server_ExitSpellCircle(p203) -- Line: 1740
    for i = 1, 20 do
        local v204 = p203.hitbox[i];

        if v204 and v204.isActive then
            v204:stop();
        end;

        if v204 and v204.hitbox then
            local hitbox = v204.hitbox;

            if hitbox then
                hitbox.Transparency = 1;
            end;
        end;
    end;
end;

function v1.Server_EnterRecovery(p205) -- Line: 1753
    p205:releaseControl();
end;

function v1.Client_EnterRecovery(p206) -- Line: 1757
end;

function v1.onEnd(p207) -- Line: 1761
    -- upvalues: SkillCommon (copy), getSpellCircleRunEventKeys (copy), returnPooledSpawnList (copy), cleanupLightTrailRunData (copy)
    local skillRunData = p207.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, (getSpellCircleRunEventKeys()));
    end;

    returnPooledSpawnList(skillRunData);
    cleanupLightTrailRunData(skillRunData);
end;

function v1.onClearRunData(p208, p209) -- Line: 1765
    -- upvalues: SkillCommon (copy), getSpellCircleRunEventKeys (copy), returnPooledSpawnList (copy), cleanupLightTrailRunData (copy)
    if not p209 then
        return;
    end;

    if p209 then
        SkillCommon.disconnectRunEventKeys(p209, (getSpellCircleRunEventKeys()));
    end;

    returnPooledSpawnList(p209);
    cleanupLightTrailRunData(p209);
end;

function v1.onEndServer(p210) -- Line: 1769
    for i = 1, 20 do
        local v211 = p210.hitbox and p210.hitbox[i];

        if v211 and v211.isActive then
            v211:stop();
        end;

        if v211 and v211.hitbox then
            local hitbox = v211.hitbox;

            if hitbox then
                hitbox.Transparency = 1;
            end;
        end;
    end;
end;

function v1.onServerEvent(p212, p213) -- Line: 1781
    -- upvalues: SkillEventConst (copy), ensureMeteorPlanLogic (copy)
    if p213.eventType ~= SkillEventConst.SyncEventType.SolarFlareMeteorShot then
        return;
    end;

    if p213.skillCastId and p213.skillCastId ~= p212.skillCastId then
        return;
    end;

    if p213.baseSkillInstanceId and p213.baseSkillInstanceId ~= p212.baseSkillInstanceId then
        return;
    end;

    local meteorIndex = p213.meteorIndex;
    local startPos = p213.startPos;
    local endPos = p213.endPos;

    if type(meteorIndex) ~= "number" or (typeof(startPos) ~= "Vector3" or typeof(endPos) ~= "Vector3") then
        return;
    end;

    local skillRunData = p212.skillRunData;

    if not skillRunData then
        return;
    end;

    local v214 = CFrame.new(startPos, endPos);
    local v215 = {
        StartCF = v214,
        EndCF = v214.Rotation + endPos
    };
    ensureMeteorPlanLogic(skillRunData)[meteorIndex] = v215;
end;

v1.SoundList = { "音效-技能-太阳耀斑-光法阵", "音效-技能-太阳耀斑-法阵上升", "音效-技能-太阳耀斑-下落背景音", "音效-技能-太阳耀斑-单次爆炸", "音效-技能-太阳耀斑-单次爆炸1", "音效-技能-太阳耀斑-单次爆炸2" };
v1.AnimateList = { "技能释放动作7" };
v1.ResNameList = { "光系尾迹", "太阳耀斑外侧云", "太阳耀斑内侧云", "太阳耀斑核心法阵", "太阳耀斑光束爆炸", "太阳耀斑施法持续光晕", "太阳耀斑爆炸", "太阳耀斑起手光晕爆", "太阳耀斑起手光晕吸收", "太阳耀斑光柱", "太阳耀斑周边法阵_上", "太阳耀斑周边法阵_下", "太阳耀斑太阳" };
v1.hitboxConfig = {};

for i = 1, 20 do
    v1.hitboxConfig[i] = {
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果",
        HitboxIndex = i
    };
end;

v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 6.63,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 6.63,
        animationName = "技能释放动作7",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;