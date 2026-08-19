-- Decompiled with Potassium's decompiler.

local ProjectileImpact = require(script.Parent.Parent.SkillModule._Templates.Projectile.ProjectileImpact);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local TestRunner = require(script.Parent.TestRunner);

local function createMockData(p1) -- Line: 12
    local u2 = nil;
    local v7 = {
        skillModule = {},
        skillRunData = {
            State = {
                current = "ProjectileFlying"
            },
            Logic = {
                hasExploded = false,
                impactPosition = nil,
                impactType = nil,
                impactTargetId = nil
            }
        },

        TryTransition = function(p3, p4, p5) -- Line: 25, Name: TryTransition
            -- upvalues: u2 (ref)
            u2 = {
                eventName = p4,
                payload = p5
            };

            return true;
        end,

        _getTransitionCalled = function() -- Line: 29, Name: _getTransitionCalled
            -- upvalues: u2 (ref)
            local v6 = u2;
            u2 = nil;

            return v6;
        end
    };

    if p1 then
        for i, v in pairs(p1) do
            if i == "skillRunData" then
                for i2, v2 in pairs(v) do
                    if v7.skillRunData[i2] ~= nil then
                        v7.skillRunData[i2] = v2;
                    end;
                end;
            else
                v7[i] = v;
            end;
        end;
    end;

    return v7;
end;

local u24 = {
    {
        name = "resolveImpact_Enemy_TransitionsToEnemyHit",

        fn = function() -- Line: 54, Name: fn
            -- upvalues: createMockData (copy), ProjectileImpact (copy), TestRunner (copy), SkillEventConst (copy)
            local v8 = createMockData();
            local v9 = ProjectileImpact.resolveImpact(v8, {
                position = Vector3.new(0, 0, 0),
                target = nil,
                type = ProjectileImpact.ImpactType.Enemy,
                source = ProjectileImpact.ImpactSource.Hitbox
            });
            TestRunner.assert(v9);
            local v10 = v8._getTransitionCalled();
            TestRunner.assert(v10 ~= nil);
            TestRunner.assertEqual(v10.eventName, SkillEventConst.EnemyHit);
        end
    },
    {
        name = "resolveImpact_Timeout_TransitionsToTimeout",

        fn = function() -- Line: 71, Name: fn
            -- upvalues: createMockData (copy), ProjectileImpact (copy), TestRunner (copy), SkillEventConst (copy)
            local v11 = createMockData();
            local v12 = ProjectileImpact.resolveImpact(v11, {
                position = Vector3.new(10, 0, 10),
                type = ProjectileImpact.ImpactType.Timeout,
                source = ProjectileImpact.ImpactSource.Lifetime
            });
            TestRunner.assert(v12);
            local v13 = v11._getTransitionCalled();
            TestRunner.assert(v13 ~= nil);
            TestRunner.assertEqual(v13.eventName, SkillEventConst.Timeout);
        end
    },
    {
        name = "resolveImpact_Obstacle_TransitionsToObstacleHit",

        fn = function() -- Line: 87, Name: fn
            -- upvalues: createMockData (copy), ProjectileImpact (copy), TestRunner (copy), SkillEventConst (copy)
            local v14 = createMockData();
            local v15 = ProjectileImpact.resolveImpact(v14, {
                position = Vector3.new(5, 0, 5),
                type = ProjectileImpact.ImpactType.Obstacle,
                source = ProjectileImpact.ImpactSource.Raycast
            });
            TestRunner.assert(v15);
            local v16 = v14._getTransitionCalled();
            TestRunner.assert(v16 ~= nil);
            TestRunner.assertEqual(v16.eventName, SkillEventConst.ObstacleHit);
        end
    },
    {
        name = "resolveImpact_SecondCall_ReturnsFalse",

        fn = function() -- Line: 103, Name: fn
            -- upvalues: createMockData (copy), ProjectileImpact (copy), TestRunner (copy)
            local v17 = createMockData();
            local v18 = {
                position = Vector3.new(0, 0, 0),
                type = ProjectileImpact.ImpactType.Timeout,
                source = ProjectileImpact.ImpactSource.Lifetime
            };
            local v19 = ProjectileImpact.resolveImpact(v17, v18);
            local v20 = ProjectileImpact.resolveImpact(v17, v18);
            TestRunner.assert(v19);
            TestRunner.assert(not v20);
        end
    },
    {
        name = "resolveImpact_NotProjectileFlying_ReturnsFalse",

        fn = function() -- Line: 118, Name: fn
            -- upvalues: createMockData (copy), ProjectileImpact (copy), TestRunner (copy)
            local v21 = createMockData();
            v21.skillRunData.State.current = "Recovery";
            local v22 = ProjectileImpact.resolveImpact(v21, {
                position = Vector3.new(0, 0, 0),
                type = ProjectileImpact.ImpactType.Timeout,
                source = ProjectileImpact.ImpactSource.Lifetime
            });
            TestRunner.assert(not v22);
        end
    },
    {
        name = "resolveImpact_SetsImpactPosition",

        fn = function() -- Line: 132, Name: fn
            -- upvalues: createMockData (copy), ProjectileImpact (copy), TestRunner (copy)
            local v23 = createMockData();
            ProjectileImpact.resolveImpact(v23, {
                position = Vector3.new(1, 2, 3),
                type = ProjectileImpact.ImpactType.Timeout,
                source = ProjectileImpact.ImpactSource.Lifetime
            });
            TestRunner.assertEqual(v23.skillRunData.Logic.impactPosition, Vector3.new(1, 2, 3));
            TestRunner.assertEqual(v23.skillRunData.Logic.impactType, ProjectileImpact.ImpactType.Timeout);
        end
    }
};

return {
    run = function() -- Line: 148, Name: run
        -- upvalues: TestRunner (copy), u24 (copy)
        return TestRunner.run("ProjectileImpact", u24);
    end
};