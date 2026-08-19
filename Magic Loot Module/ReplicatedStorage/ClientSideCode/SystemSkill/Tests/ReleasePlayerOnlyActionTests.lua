-- Decompiled with Potassium's decompiler.

local SkillAction = require(script.Parent.Parent.BaseSkill.SkillAction);
local TestRunner = require(script.Parent.TestRunner);
local LocalPlayer = game:GetService("Players").LocalPlayer;

local function createMockBaseSkill(p1, p2) -- Line: 12
    return {
        characterType = p1,
        characterId = p2,
        skillModule = {
            Action = { {
                    action = "LockMovement",
                    startTime = 0,
                    overTime = 1
                } }
        }
    };
end;

local u15 = {
    {
        name = "LocalPlayer_Casts_ActionCreated",

        fn = function() -- Line: 27, Name: fn
            -- upvalues: createMockBaseSkill (copy), LocalPlayer (copy), SkillAction (copy), TestRunner (copy)
            local v3 = createMockBaseSkill("Player", LocalPlayer.UserId);
            local v4 = SkillAction.new(v3);
            TestRunner.assert(#v4.allActions >= 1, "本地玩家施法时 isReleasePlayerOnly Action 应被创建");
        end
    },
    {
        name = "OtherPlayer_Casts_ActionNotCreated",

        fn = function() -- Line: 35, Name: fn
            -- upvalues: LocalPlayer (copy), createMockBaseSkill (copy), SkillAction (copy), TestRunner (copy)
            local v5 = createMockBaseSkill("Player", LocalPlayer.UserId + 99999);
            local v6 = SkillAction.new(v5);
            TestRunner.assert(#v6.allActions == 0, "其他玩家施法时 isReleasePlayerOnly Action 不应被创建");
        end
    },
    {
        name = "NPC_Casts_ActionCreated",

        fn = function() -- Line: 44, Name: fn
            -- upvalues: createMockBaseSkill (copy), SkillAction (copy), TestRunner (copy)
            local v7 = createMockBaseSkill("NPC", 0);
            local v8 = SkillAction.new(v7);
            TestRunner.assert(#v8.allActions >= 1, "NPC 施法时 isReleasePlayerOnly Action 应在各同步客户端创建");
        end
    },
    {
        name = "Summon_Subject_Casts_ActionCreated",

        fn = function() -- Line: 52, Name: fn
            -- upvalues: createMockBaseSkill (copy), SkillAction (copy), TestRunner (copy)
            local v9 = createMockBaseSkill("Summon", "Minion_A");
            local v10 = SkillAction.new(v9);
            TestRunner.assert(#v10.allActions >= 1, "非玩家主体（如 Summon）施法时应在各客户端创建 isReleasePlayerOnly Action");
        end
    },
    {
        name = "NPC_Casts_LookAt_NotCreated",

        fn = function() -- Line: 60, Name: fn
            -- upvalues: createMockBaseSkill (copy), SkillAction (copy), TestRunner (copy)
            local v11 = createMockBaseSkill("NPC", 0);
            v11.skillModule.Action = { {
                    action = "LookAt",
                    startTime = 0,
                    overTime = 1,
                    speedType = "RELEASE_SKILL_STATE_HALF"
                } };
            local v12 = SkillAction.new(v11);
            TestRunner.assert(#v12.allActions == 0, "怪物等非玩家主体施法时不应实例化 LookAt");
        end
    },
    {
        name = "LocalPlayer_Casts_LookAt_Created",

        fn = function() -- Line: 71, Name: fn
            -- upvalues: createMockBaseSkill (copy), LocalPlayer (copy), SkillAction (copy), TestRunner (copy)
            local v13 = createMockBaseSkill("Player", LocalPlayer.UserId);
            v13.skillModule.Action = { {
                    action = "LookAt",
                    startTime = 0,
                    overTime = 1,
                    speedType = "RELEASE_SKILL_STATE_HALF"
                } };
            local v14 = SkillAction.new(v13);
            TestRunner.assert(#v14.allActions == 1, "本地玩家施法时应实例化 LookAt");
        end
    }
};

return {
    name = "ReleasePlayerOnlyActionTests",

    run = function() -- Line: 84, Name: run
        -- upvalues: TestRunner (copy), u15 (copy)
        return TestRunner.run("ReleasePlayerOnlyAction", u15);
    end
};