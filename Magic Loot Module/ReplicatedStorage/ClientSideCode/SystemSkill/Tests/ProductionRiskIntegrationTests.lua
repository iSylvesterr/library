-- Decompiled with Potassium's decompiler.

local SkillSyncRouter = require(script.Parent.Parent.BaseSkill.SkillSyncRouter);
local BaseSkillServer = require(script.Parent.Parent.BaseSkill.BaseSkillServer);
local BaseSkillClient = require(script.Parent.Parent.BaseSkill.BaseSkillClient);
local GroupSkillInstanceRuntime = require(script.Parent.Parent.GroupSkill.GroupSkillInstanceRuntime);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local TestRunner = require(script.Parent.TestRunner);

local function createMockPlayer(p1, p2) -- Line: 15
    local u3 = {
        Position = p2 or Vector3.new(0, 0, 0),
        Parent = {}
    };

    return {
        id = p1,
        Name = "Player" .. tostring(p1),
        Parent = {},
        Character = {
            HumanoidRootPart = u3,
            PrimaryPart = u3,
            Parent = {},

            FindFirstChild = function(p4, p5) -- Line: 21, Name: FindFirstChild
                -- upvalues: u3 (copy)
                return p5 == "HumanoidRootPart" and u3 or nil;
            end
        }
    };
end;

local function createEventCapture() -- Line: 34
    local u6 = {};

    return {
        record = function(p7, p8, ...) -- Line: 37, Name: record
            -- upvalues: u6 (copy)
            table.insert(u6, {
                eventType = p7,
                player = p8,
                args = { ... }
            });
        end,

        getEvents = function() -- Line: 40, Name: getEvents
            -- upvalues: u6 (copy)
            return u6;
        end,

        clear = function() -- Line: 41, Name: clear
            -- upvalues: u6 (copy)
            table.clear(u6);
        end
    };
end;

local u62 = {
    {
        name = "A_FullChainOrder_StopNeverBeforeDerived",

        fn = function() -- Line: 49, Name: fn
            -- upvalues: createEventCapture (copy), createMockPlayer (copy), SkillSyncRouter (copy), TestRunner (copy)
            local v9 = createEventCapture();
            local u10 = createMockPlayer("A", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 52
                -- upvalues: u10 (copy)
                return { u10 };
            end);
            SkillSyncRouter._testSetEventCapture(v9);
            SkillSyncRouter.broadcastRelevantAndTrack("chain_test", Vector3.new(0, 0, 0), 100, {
                eventType = "BaseSkillStarted"
            }, nil);
            SkillSyncRouter.broadcastRelevantAndTrack("chain_test", Vector3.new(0, 0, 0), 100, {
                eventType = "Derived"
            }, nil);
            SkillSyncRouter.broadcastRelevantAndTrack("chain_test", Vector3.new(0, 0, 0), 100, {
                eventType = "ProjectileHitConfirmed"
            }, nil);
            SkillSyncRouter.broadcastStopTrackedAndClear("chain_test", {
                reason = "Finished"
            }, Vector3.new(0, 0, 0), 100, nil);
            local v11 = v9.getEvents();
            local v12 = nil;
            local v13 = nil;

            for i, v in ipairs(v11) do
                if v.eventType == "StopSkill" then
                    v13 = i;
                end;

                if v.eventType == "SynSkillEffect" and (v.args[1] and v.args[1].eventType == "Derived") then
                    v12 = i;
                end;
            end;

            if v12 and v13 then
                TestRunner.assert(v12 < v13, "Stop 不得先于 Derived");
            end;

            TestRunner.assert(#v11 >= 4, "应收到至少 4 类事件");
            SkillSyncRouter._testReset();
        end
    },
    {
        name = "A_OldGenerationCallback_NotDeliveredToRemovedInstance",

        fn = function() -- Line: 78, Name: fn
            -- upvalues: TestRunner (copy)
            local u14 = {};

            local function removeInstance(p15) -- Line: 80
                -- upvalues: u14 (copy)
                u14[p15] = nil;
            end;

            u14.cast_1 = {
                applyDerived = function() -- Line: 89, Name: applyDerived
                    error("removed instance should not receive");
                end
            };
            u14.cast_1 = nil;
            local success, result = pcall(function(p16, p17) -- Line: 83, Name: applyDerivedToInstance
                -- upvalues: u14 (copy)
                local v18 = u14[p16];

                if v18 and v18.applyDerived then
                    v18:applyDerived(p17);
                end;
            end, "cast_1", {
                fromBaseSkillIndex = 1,
                toBaseSkillIndex = 2
            });
            TestRunner.assert(success, "旧实例已移除时 applyDerivedToInstance 不应崩溃: " .. tostring(result));
        end
    },
    {
        name = "B_AudienceTracking_PlayerLeftRange_StillReceivesStopSkill",

        fn = function() -- Line: 99, Name: fn
            -- upvalues: createEventCapture (copy), createMockPlayer (copy), SkillSyncRouter (copy), TestRunner (copy)
            local v19 = createEventCapture();
            local u20 = createMockPlayer("A", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 102
                -- upvalues: u20 (copy)
                return { u20 };
            end);
            SkillSyncRouter._testSetEventCapture(v19);
            SkillSyncRouter.broadcastRelevantAndTrack("audience_test", Vector3.new(0, 0, 0), 50, {
                eventType = "BaseSkillStarted"
            }, nil);
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 107
                return {};
            end);
            SkillSyncRouter.broadcastStopTrackedAndClear("audience_test", {
                reason = "Finished"
            }, Vector3.new(0, 0, 0), 50, nil);
            local v21 = {};

            for _, v in ipairs(v19.getEvents()) do
                if v.eventType == "StopSkill" and v.player == u20 then
                    table.insert(v21, v);
                end;
            end;

            TestRunner.assert(#v21 >= 1, "玩家 A 虽已离开范围，仍须收到 StopSkill（audience 追踪）");
            SkillSyncRouter._testReset();
        end
    },
    {
        name = "C_DamageTipRange_OnlyNearPlayerReceives",

        fn = function() -- Line: 125, Name: fn
            -- upvalues: createEventCapture (copy), createMockPlayer (copy), SkillSyncRouter (copy), TestRunner (copy)
            local v22 = createEventCapture();
            local u23 = createMockPlayer("Near", Vector3.new(10, 0, 0));
            local u24 = createMockPlayer("Mid", Vector3.new(50, 0, 0));
            local u25 = createMockPlayer("Far", Vector3.new(200, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 132
                -- upvalues: u23 (copy), u24 (copy), u25 (copy)
                return { u23, u24, u25 };
            end);
            SkillSyncRouter._testSetEventCapture(v22);
            SkillSyncRouter.broadcastDamageTipRelevant(Vector3.new(0, 0, 0), 30, Vector3.new(0, 0, 0), "100", false, 1, nil);
            local v26 = {};

            for _, v in ipairs(v22.getEvents()) do
                if v.eventType == "DamageTip" then
                    table.insert(v26, v.player);
                end;
            end;

            local v27 = false;
            local v28 = false;
            local v29 = false;

            for _, v in ipairs(v26) do
                v27 = v == u23 and true or v27;
                v28 = v == u24 and true or v28;

                if v == u25 then
                    v29 = true;
                end;
            end;

            TestRunner.assert(v27, "近距离玩家应收到 DamageTip");
            TestRunner.assert(not v28, "中距离玩家不应收到 DamageTip");
            TestRunner.assert(not v29, "远距离玩家不应收到 DamageTip");
            SkillSyncRouter._testReset();
        end
    },
    {
        name = "D_Destroy_ClearAudience_NoGhostAudience",

        fn = function() -- Line: 162, Name: fn
            -- upvalues: createMockPlayer (copy), SkillSyncRouter (copy), createEventCapture (copy), TestRunner (copy)
            local u30 = createMockPlayer("A", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 164
                -- upvalues: u30 (copy)
                return { u30 };
            end);
            SkillSyncRouter._testSetEventCapture((createEventCapture()));
            SkillSyncRouter.broadcastRelevantAndTrack("destroy_test", Vector3.new(0, 0, 0), 100, {}, nil);
            local v31 = SkillSyncRouter.getAudience("destroy_test");
            TestRunner.assert(#v31 >= 1, "destroy 前应有 audience");
            SkillSyncRouter.clearAudience("destroy_test");
            local v32 = SkillSyncRouter.getAudience("destroy_test");
            TestRunner.assert(#v32 == 0, "clearAudience 后应无残留");
            SkillSyncRouter._testReset();
        end
    },
    {
        name = "D_Destroy_ConnectionsCleaned_NoOrphanRefs",

        fn = function() -- Line: 181, Name: fn
            -- upvalues: TestRunner (copy)
            local u33 = 0;
            local v34 = {};
            table.insert(v34, {
                Disconnect = function() -- Line: 185, Name: Disconnect
                    -- upvalues: u33 (ref)
                    u33 = u33 + 1;
                end
            });

            for _, v in ipairs(({
                runEvent = v34
            }).runEvent or {}) do
                if v and v.Disconnect then
                    v:Disconnect();
                end;
            end;

            TestRunner.assert(u33 == 1, "destroy 时应断开 runEvent 连接");
        end
    },
    {
        name = "E_BaseSkillServerDestroy_BroadcastsStopSkill_ClearsAudience_NoOldCallbacks",

        fn = function() -- Line: 203, Name: fn
            -- upvalues: createEventCapture (copy), createMockPlayer (copy), SkillSyncRouter (copy), TestRunner (copy), SkillEventConst (copy), BaseSkillServer (copy)
            local v35 = createEventCapture();
            local u36 = createMockPlayer("A", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 206
                -- upvalues: u36 (copy)
                return { u36 };
            end);
            SkillSyncRouter._testSetEventCapture(v35);
            SkillSyncRouter.broadcastRelevantAndTrack("server_destroy_test", Vector3.new(0, 0, 0), 100, {
                eventType = "BaseSkillStarted"
            }, nil);
            local v37 = SkillSyncRouter.getAudience("server_destroy_test");
            TestRunner.assert(#v37 >= 1, "destroy 前应有 audience");
            local v38 = BaseSkillServer.newWithDefinition({
                skillName = "ServerDestroyTest",
                skillModule = {
                    InitialState = "Startup",
                    States = {
                        Startup = {
                            Duration = 1
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
                            To = "Finished",
                            Event = SkillEventConst.StateTimeout
                        },
                        {
                            From = "Startup",
                            To = "Interrupted",
                            Event = SkillEventConst.Interrupt
                        }
                    }
                }
            }, {
                characterId = 0,
                characterType = "NPC",
                skillPower = 1,
                skillPurity = 1,
                character = nil,
                skillInputData = {}
            });
            v38:start({
                characterId = 0,
                characterType = "NPC",
                skillCastId = "server_destroy_test",
                baseSkillInstanceId = "server_destroy_test_B1",
                activeBaseSkillIndex = 1,
                combatSeed = 123,
                releaseCF = nil,
                targetCF = nil,
                moveDirectionStr = nil
            });
            TestRunner.assert(v38:isRunningFlow(), "start 后应处于运行状态");
            v38:destroy();
            local v39 = false;

            for _, v in ipairs(v35.getEvents()) do
                if v.eventType == "StopSkill" then
                    v39 = true;
                    break;
                end;
            end;

            TestRunner.assert(v39, "destroy 前运行中技能应能广播 StopSkill");
            SkillSyncRouter.clearAudience("server_destroy_test");
            local v40 = SkillSyncRouter.getAudience("server_destroy_test");
            TestRunner.assert(#v40 == 0, "clearAudience 后应无残留");
            TestRunner.assert(v38.timeLineRunServer == nil, "destroy 后时钟应已停止，不再触发旧回调");
            SkillSyncRouter._testReset();
        end
    },
    {
        name = "Destroy_RunningBaseSkill_ReachesTerminal",

        fn = function() -- Line: 275, Name: fn
            -- upvalues: SkillEventConst (copy), BaseSkillClient (copy), TestRunner (copy)
            local v41 = {
                skillName = "ClientDestroyTest",
                skillModule = {
                    InitialState = "Startup",
                    States = {
                        Startup = {
                            Duration = 1
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
                            To = "Finished",
                            Event = SkillEventConst.StateTimeout
                        },
                        {
                            From = "Startup",
                            To = "Interrupted",
                            Event = SkillEventConst.Interrupt
                        }
                    }
                }
            };
            local v42 = {
                Parent = game
            };
            local v43 = BaseSkillClient.newWithDefinition(v41, {
                characterId = 0,
                characterType = "NPC",
                skillPower = 1,
                skillPurity = 1,
                character = v42,
                skillInputData = {
                    characterId = 0,
                    characterType = "NPC",
                    releaseCF = nil,
                    targetCF = nil,
                    moveDirectionStr = nil,
                    skillCastId = "client_destroy",
                    baseSkillInstanceId = "client_destroy_B1",
                    activeBaseSkillIndex = 1,
                    character = v42
                }
            });
            v43:skillStart();
            TestRunner.assert(v43:isRunningFlow(), "skillStart 后应处于运行状态");
            v43:destroy("Interrupted", true);
            TestRunner.assert(v43:isTerminal(), "destroy 后应落终态");
            TestRunner.assertEqual(v43.flowState, "Interrupted", "destroy 后 flowState 应为 Interrupted");
        end
    },
    {
        name = "Destroy_ServerSkill_BroadcastsStopBeforeCleanup",

        fn = function() -- Line: 324, Name: fn
            -- upvalues: createEventCapture (copy), createMockPlayer (copy), SkillSyncRouter (copy), SkillEventConst (copy), BaseSkillServer (copy), TestRunner (copy)
            local v44 = createEventCapture();
            local u45 = createMockPlayer("A", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 327
                -- upvalues: u45 (copy)
                return { u45 };
            end);
            SkillSyncRouter._testSetEventCapture(v44);
            SkillSyncRouter.broadcastRelevantAndTrack("server_stop_before_cleanup", Vector3.new(0, 0, 0), 100, {
                eventType = "BaseSkillStarted"
            }, nil);
            local v46 = BaseSkillServer.newWithDefinition({
                skillName = "ServerStopBeforeCleanup",
                skillModule = {
                    InitialState = "Startup",
                    States = {
                        Startup = {
                            Duration = 1
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
                            To = "Finished",
                            Event = SkillEventConst.StateTimeout
                        },
                        {
                            From = "Startup",
                            To = "Interrupted",
                            Event = SkillEventConst.Interrupt
                        }
                    }
                }
            }, {
                characterId = 0,
                characterType = "NPC",
                skillPower = 1,
                skillPurity = 1,
                character = nil,
                skillInputData = {}
            });
            v46:start({
                characterId = 0,
                characterType = "NPC",
                skillCastId = "server_stop_before_cleanup",
                baseSkillInstanceId = "server_stop_before_cleanup_B1",
                activeBaseSkillIndex = 1,
                combatSeed = 123,
                releaseCF = nil,
                targetCF = nil,
                moveDirectionStr = nil
            });
            TestRunner.assert(v46:isRunningFlow(), "start 后应处于运行状态");
            v46:destroy("Interrupted");
            local v47 = false;

            for _, v in ipairs(v44.getEvents()) do
                if v.eventType == "StopSkill" then
                    v47 = true;
                    break;
                end;
            end;

            TestRunner.assert(v47, "destroy 应先广播 StopSkill 再 cleanup");
            TestRunner.assert(v46.timeLineRunServer == nil, "destroy 后时钟应已停止");
            SkillSyncRouter._testReset();
        end
    },
    {
        name = "GroupDestroy_CascadesToAllChildren",

        fn = function() -- Line: 389, Name: fn
            -- upvalues: SkillEventConst (copy), BaseSkillServer (copy), TestRunner (copy), GroupSkillInstanceRuntime (copy)
            local v48 = {
                skillName = "CascadeTest",
                skillModule = {
                    InitialState = "Startup",
                    States = {
                        Startup = {
                            Duration = 1
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
                            To = "Finished",
                            Event = SkillEventConst.StateTimeout
                        },
                        {
                            From = "Startup",
                            To = "Interrupted",
                            Event = SkillEventConst.Interrupt
                        }
                    }
                }
            };
            local v49 = {
                characterId = 0,
                characterType = "NPC",
                skillPower = 1,
                skillPurity = 1,
                character = nil,
                skillInputData = {}
            };
            local v50 = BaseSkillServer.newWithDefinition(v48, v49);
            local v51 = BaseSkillServer.newWithDefinition(v48, v49);
            local v52 = {
                characterId = 0,
                characterType = "NPC",
                skillCastId = "group_cascade_test",
                baseSkillInstanceId = "group_cascade_test_B1",
                activeBaseSkillIndex = 1,
                combatSeed = 123,
                releaseCF = nil,
                targetCF = nil,
                moveDirectionStr = nil
            };
            v50:start(v52);
            v51:start(v52);
            local assert = TestRunner.assert;
            local v53 = v50:isRunningFlow() and v51:isRunningFlow();
            assert(v53, "两个 BaseSkill 应处于运行状态");
            local v54 = GroupSkillInstanceRuntime._testNewWithBaseSkills({ v50, v51 }, "group_cascade_test", 123);
            v54:destroy("Interrupted");
            TestRunner.assert(v50._destroyed, "destroy 后子技能 1 应已销毁");
            TestRunner.assert(v51._destroyed, "destroy 后子技能 2 应已销毁");
            TestRunner.assert(v54._destroyed, "runtime 自身应已销毁");
        end
    },
    {
        name = "DelayedFadeout_OldCallbackNoopsAfterDestroy",

        fn = function() -- Line: 443, Name: fn
            -- upvalues: SkillEventConst (copy), BaseSkillClient (copy), TestRunner (copy)
            local v55 = {
                skillName = "FadeoutTest",
                skillModule = {
                    visualFadeoutTime = 0.05,
                    InitialState = "Startup",
                    States = {
                        Startup = {
                            Duration = 1
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
                            To = "Finished",
                            Event = SkillEventConst.StateTimeout
                        },
                        {
                            From = "Startup",
                            To = "Interrupted",
                            Event = SkillEventConst.Interrupt
                        }
                    }
                }
            };
            local v56 = {
                Parent = game
            };
            local v57 = BaseSkillClient.newWithDefinition(v55, {
                characterId = 0,
                characterType = "NPC",
                skillPower = 1,
                skillPurity = 1,
                character = v56,
                skillInputData = {
                    characterId = 0,
                    characterType = "NPC",
                    releaseCF = nil,
                    targetCF = nil,
                    moveDirectionStr = nil,
                    skillCastId = "fadeout_test",
                    baseSkillInstanceId = "fadeout_test_B1",
                    activeBaseSkillIndex = 1,
                    character = v56
                }
            });
            v57:skillStart();
            TestRunner.assert(v57:isRunningFlow(), "skillStart 后应处于运行状态");
            v57:skillEnd(false, "Interrupted");
            v57:destroy("Interrupted", true);
            TestRunner.assert(v57._destroyed, "destroy 后应已销毁");
            task.wait(0.1);
            TestRunner.assert(v57._destroyed, "延迟回调触发后对象仍应处于已销毁状态");
        end
    },
    {
        name = "PlayerRemoving_AudienceSwept",

        fn = function() -- Line: 499, Name: fn
            -- upvalues: createMockPlayer (copy), SkillSyncRouter (copy), TestRunner (copy)
            local u58 = createMockPlayer("A", Vector3.new(0, 0, 0));
            local u59 = createMockPlayer("B", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 502
                -- upvalues: u58 (copy), u59 (copy)
                return { u58, u59 };
            end);
            SkillSyncRouter.registerAudience("player_removing_sweep", u58);
            SkillSyncRouter.registerAudience("player_removing_sweep", u59);
            TestRunner.assert(SkillSyncRouter.getAudienceCount("player_removing_sweep") >= 2, "登记后应有 2 人");
            SkillSyncRouter._testSimulatePlayerRemoving(u58);
            local v60 = SkillSyncRouter.getAudience("player_removing_sweep");
            local v61 = false;

            for _, v in ipairs(v60) do
                if v == u58 then
                    v61 = true;
                    break;
                end;
            end;

            TestRunner.assert(not v61, "PlayerRemoving 后该玩家应从 audience 中移除");
            SkillSyncRouter.clearAudience("player_removing_sweep");
            SkillSyncRouter._testReset();
        end
    }
};

return {
    name = "ProductionRiskIntegrationTests",

    run = function() -- Line: 523, Name: run
        -- upvalues: TestRunner (copy), u62 (copy), SkillSyncRouter (copy)
        local v63 = TestRunner.run("ProductionRiskIntegrationTests", u62);
        SkillSyncRouter._testReset();

        return v63;
    end
};