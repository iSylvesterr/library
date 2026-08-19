-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SkillStateRuntime = require(script.Parent.SkillStateRuntime);
local SkillControlRuntime = require(script.Parent.SkillControlRuntime);
local SkillHitboxRuntime = require(script.Parent.SkillHitboxRuntime);

return {
    create = function(p1, p2) -- Line: 20, Name: create
        -- upvalues: SkillControlRuntime (copy)
        local v3 = p2 or {};

        if p1 then
            p1 = p1.skillModule;
        end;

        return {
            runData = nil,
            hitboxRuntime = nil,
            timeConnection = nil,
            controlRuntime = SkillControlRuntime.create(p1, {
                isClient = v3.isClient,
                getActionsOverCheck = v3.getActionsOverCheck
            })
        };
    end,

    initMaterial = function(p4, p5, p6) -- Line: 40, Name: initMaterial
        -- upvalues: SkillStateRuntime (copy), UtilsSystem (copy)
        local v7 = p6 or {};
        local skillModule = p5.skillModule;
        local v8 = {
            material = {},
            runEvent = {},
            hitbox = {}
        };

        if skillModule.States and skillModule.InitialState then
            v8.State = SkillStateRuntime.createStateData(skillModule);
            v8.Visual = v7.isClient and {
                projectileModel = nil,
                projectileMotion = nil,
                explosionPlayed = false,
                pendingProjectileHitEvent = nil
            } or {};
            v8.Logic = {
                hasExploded = false,
                projectileHitboxMotion = nil,
                projectileLastPosition = nil,
                impactPosition = nil,
                impactType = nil,
                impactTargetId = nil
            };
        end;

        if v7.isClient and (v7.skillResFolder and not v7.skipClientMaterials) then
            for _, v in skillModule.ResNameList or {} do
                local v9 = v7.skillResFolder:FindFirstChild(v);

                if v9 then
                    local v10 = UtilsSystem.FXUtil.GetInstance_From_Pool(v9);

                    if v10 and v10:IsA("Model") then
                        local ResRestore = UtilsSystem.ResRestore;

                        if ResRestore and ResRestore.Restore then
                            ResRestore.Restore(v10);
                        end;

                        v10.Parent = nil;
                        v8.material[v9.Name] = v10;
                    end;
                end;
            end;
        end;

        p4.runData = v8;

        return v8;
    end,

    initHitbox = function(p11, p12, p13) -- Line: 95, Name: initHitbox
        -- upvalues: SkillHitboxRuntime (copy)
        p11.hitboxRuntime = SkillHitboxRuntime.create(p12);
        SkillHitboxRuntime.spawnAll(p11.hitboxRuntime, p13);

        return p11.hitboxRuntime.instances;
    end,

    startClock = function(p14, p15, p16) -- Line: 108, Name: startClock
        if p14.timeConnection then
            p14.timeConnection:Disconnect();
        end;

        p14.timeConnection = p15.Heartbeat:Connect(p16);

        return p14.timeConnection;
    end,

    stopClock = function(p17) -- Line: 119, Name: stopClock
        if p17.timeConnection then
            p17.timeConnection:Disconnect();
            p17.timeConnection = nil;
        end;
    end,

    destroyHitbox = function(p18) -- Line: 129, Name: destroyHitbox
        -- upvalues: SkillHitboxRuntime (copy)
        if p18.hitboxRuntime then
            SkillHitboxRuntime.destroyAll(p18.hitboxRuntime);
            p18.hitboxRuntime = nil;
        end;
    end,

    resetControl = function(p19) -- Line: 139, Name: resetControl
        -- upvalues: SkillControlRuntime (copy)
        SkillControlRuntime.reset(p19.controlRuntime);
    end
};