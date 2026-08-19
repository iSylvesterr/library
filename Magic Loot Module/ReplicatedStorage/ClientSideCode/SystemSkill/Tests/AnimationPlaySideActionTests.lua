-- Decompiled with Potassium's decompiler.

local SkillAction = require(script.Parent.Parent.BaseSkill.SkillAction);
local AnimationPlaySide = require(script.Parent.Parent.BaseSkill.AnimationPlaySide);
local TestRunner = require(script.Parent.TestRunner);

local function createMockBaseSkill(p1, p2, p3) -- Line: 10
    return {
        characterId = 1,
        characterType = p1,
        character = p3,
        skillModule = {
            animationPlaySide = p2,
            Action = { {
                    action = "Animation",
                    startTime = 0,
                    overTime = 1,
                    animationName = "TestAnim"
                }, {
                    action = "LockMovement",
                    startTime = 0,
                    overTime = 1
                } }
        }
    };
end;

local function createLogicalMockModel() -- Line: 30
    local Model = Instance.new("Model");
    Model:SetAttribute("IsLogicalEnemy", true);

    return Model;
end;

local u14 = {
    {
        name = "NPC_ServerSide_ClientSkipsAnimation",

        fn = function() -- Line: 39, Name: fn
            -- upvalues: createMockBaseSkill (copy), TestRunner (copy), AnimationPlaySide (copy), SkillAction (copy)
            local v4 = createMockBaseSkill("NPC", "Server");
            TestRunner.assert(AnimationPlaySide.shouldRunServerSkillAction(v4), "NPC + Server 应在服务端跑 SkillAction");
            TestRunner.assert(AnimationPlaySide.shouldSkipClientAnimation(v4), "客户端应跳过 Animation");
            local v5 = SkillAction.new(v4);
            TestRunner.assert(#v5.allActions == 1, "客户端仍应保留非 Animation 的 Action");
            local v6 = 0;

            for _, v in v5.allActions do
                if v.actionInfo and v.actionInfo.action == "Animation" then
                    v6 = v6 + 1;
                end;
            end;

            TestRunner.assert(v6 == 0, "客户端不应实例化 Animation");
        end
    },
    {
        name = "NPC_ServerSide_ServerMode_OnlyAnimation",

        fn = function() -- Line: 56, Name: fn
            -- upvalues: createMockBaseSkill (copy), SkillAction (copy), TestRunner (copy)
            local v7 = createMockBaseSkill("NPC", "Server");
            local v8 = SkillAction.new(v7, {
                serverMode = true
            });
            TestRunner.assert(#v8.allActions == 1, "服务端 serverMode 仅应创建 Animation");
            TestRunner.assert(v8.allActions[1].actionInfo.action == "Animation", "服务端 Action 应为 Animation");
        end
    },
    {
        name = "Player_ServerSide_Ignored",

        fn = function() -- Line: 65, Name: fn
            -- upvalues: createMockBaseSkill (copy), TestRunner (copy), AnimationPlaySide (copy)
            local v9 = createMockBaseSkill("Player", "Server");
            TestRunner.assert(not AnimationPlaySide.shouldRunServerSkillAction(v9), "玩家主体忽略 animationPlaySide");
            TestRunner.assert(not AnimationPlaySide.shouldSkipClientAnimation(v9), "玩家主体客户端仍播 Animation");
        end
    },
    {
        name = "NPC_Default_ClientKeepsAnimation",

        fn = function() -- Line: 73, Name: fn
            -- upvalues: createMockBaseSkill (copy), TestRunner (copy), AnimationPlaySide (copy), SkillAction (copy)
            local v10 = createMockBaseSkill("NPC", nil);
            TestRunner.assert(not AnimationPlaySide.shouldSkipClientAnimation(v10), "默认 Client 不跳过");
            local v11 = false;

            for _, v in SkillAction.new(v10).allActions do
                if v.actionInfo and v.actionInfo.action == "Animation" then
                    v11 = true;
                end;
            end;

            TestRunner.assert(v11, "默认应在客户端创建 Animation");
        end
    },
    {
        name = "LogicalNPC_ServerConfig_ForcesClientAnimation",

        fn = function() -- Line: 88, Name: fn
            -- upvalues: createMockBaseSkill (copy), TestRunner (copy), AnimationPlaySide (copy), SkillAction (copy)
            local Model = Instance.new("Model");
            Model:SetAttribute("IsLogicalEnemy", true);
            local v12 = createMockBaseSkill("NPC", "Server", Model);
            TestRunner.assert(AnimationPlaySide.isLogicalSubjectSkill(v12), "应识别逻辑怪主体");
            TestRunner.assert(not AnimationPlaySide.shouldRunServerSkillAction(v12), "逻辑怪不应在服务端跑 SkillAction");
            TestRunner.assert(not AnimationPlaySide.shouldSkipClientAnimation(v12), "逻辑怪客户端应保留 Animation");
            local v13 = false;

            for _, v in SkillAction.new(v12).allActions do
                if v.actionInfo and v.actionInfo.action == "Animation" then
                    v13 = true;
                end;
            end;

            TestRunner.assert(v13, "逻辑怪应在客户端创建 Animation");
            Model:Destroy();
        end
    }
};

return {
    name = "AnimationPlaySideActionTests",

    run = function() -- Line: 109, Name: run
        -- upvalues: TestRunner (copy), u14 (copy)
        return TestRunner.run("AnimationPlaySideAction", u14);
    end
};