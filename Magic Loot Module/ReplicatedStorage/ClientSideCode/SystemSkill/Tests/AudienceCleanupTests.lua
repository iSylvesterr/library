-- Decompiled with Potassium's decompiler.

local SkillSyncRouter = require(script.Parent.Parent.BaseSkill.SkillSyncRouter);
local TestRunner = require(script.Parent.TestRunner);

local function createMockPlayer(p1, p2) -- Line: 9
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

            FindFirstChild = function(p4, p5) -- Line: 15, Name: FindFirstChild
                -- upvalues: u3 (copy)
                return p5 == "HumanoidRootPart" and u3 or nil;
            end
        }
    };
end;

local function createEventCapture() -- Line: 27
    local u6 = {};

    return {
        record = function(p7, p8, ...) -- Line: 30, Name: record
            -- upvalues: u6 (copy)
            table.insert(u6, {
                eventType = p7,
                player = p8,
                args = { ... }
            });
        end,

        getEvents = function() -- Line: 33, Name: getEvents
            -- upvalues: u6 (copy)
            return u6;
        end,

        clear = function() -- Line: 34, Name: clear
            -- upvalues: u6 (copy)
            table.clear(u6);
        end
    };
end;

local u17 = {
    {
        name = "PlayerRemoving_RemovesAudienceReference",

        fn = function() -- Line: 41, Name: fn
            -- upvalues: createMockPlayer (copy), SkillSyncRouter (copy), TestRunner (copy)
            local u9 = createMockPlayer("A", Vector3.new(0, 0, 0));
            local u10 = createMockPlayer("B", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 44
                -- upvalues: u9 (copy), u10 (copy)
                return { u9, u10 };
            end);
            SkillSyncRouter.registerAudience("player_removing_test", u9);
            SkillSyncRouter.registerAudience("player_removing_test", u10);
            TestRunner.assert(SkillSyncRouter.getAudienceCount("player_removing_test") >= 2, "登记后应有 2 人");
            SkillSyncRouter._testSimulatePlayerRemoving(u9);
            local v11 = SkillSyncRouter.getAudience("player_removing_test");
            local v12 = false;

            for _, v in ipairs(v11) do
                if v == u9 then
                    v12 = true;
                    break;
                end;
            end;

            TestRunner.assert(not v12, "PlayerRemoving 后该玩家应从 audience 中移除");
            SkillSyncRouter.clearAudience("player_removing_test");
            SkillSyncRouter._testReset();
        end
    },
    {
        name = "ExpiredAudience_IsSwept",

        fn = function() -- Line: 65, Name: fn
            -- upvalues: createMockPlayer (copy), SkillSyncRouter (copy), TestRunner (copy)
            local u13 = createMockPlayer("A", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 67
                -- upvalues: u13 (copy)
                return { u13 };
            end);
            SkillSyncRouter.registerAudience("expired_sweep_test", u13);
            SkillSyncRouter._testSetAudienceLastTouched("expired_sweep_test", os.clock() - 200);
            local v14 = SkillSyncRouter.debugSweepInvalidAudience();
            TestRunner.assert(v14 >= 1, "超时 audience 应被 sweep");
            TestRunner.assert(SkillSyncRouter.getAudienceCount("expired_sweep_test") == 0, "sweep 后 audience 应为空");
            SkillSyncRouter._testReset();
        end
    },
    {
        name = "StopTracked_AutoClearOnFinally",

        fn = function() -- Line: 82, Name: fn
            -- upvalues: createEventCapture (copy), createMockPlayer (copy), SkillSyncRouter (copy), TestRunner (copy)
            local v15 = createEventCapture();
            local u16 = createMockPlayer("A", Vector3.new(0, 0, 0));
            SkillSyncRouter._testSetPlayerProvider(function() -- Line: 85
                -- upvalues: u16 (copy)
                return { u16 };
            end);
            SkillSyncRouter._testSetEventCapture(v15);
            SkillSyncRouter.broadcastRelevantAndTrack("auto_clear_test", Vector3.new(0, 0, 0), 100, {
                eventType = "BaseSkillStarted"
            }, nil);
            TestRunner.assert(SkillSyncRouter.getAudienceCount("auto_clear_test") >= 1, "track 后应有 audience");
            SkillSyncRouter.broadcastStopTrackedAndClear("auto_clear_test", {
                reason = "Finished"
            }, Vector3.new(0, 0, 0), 100, nil);
            TestRunner.assert(SkillSyncRouter.getAudienceCount("auto_clear_test") == 0, "broadcastStopTrackedAndClear 发完后应自动 clear，无需调用方手动 clear");
            SkillSyncRouter._testReset();
        end
    }
};

return {
    name = "AudienceCleanupTests",

    run = function() -- Line: 103, Name: run
        -- upvalues: TestRunner (copy), u17 (copy), SkillSyncRouter (copy)
        local v18 = TestRunner.run("AudienceCleanup", u17);
        SkillSyncRouter._testReset();

        return v18;
    end
};