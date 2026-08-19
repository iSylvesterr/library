-- Decompiled with Potassium's decompiler.

local SkillStateMachine = require(script.Parent.SkillStateMachine);

return {
    createStateData = function(p1) -- Line: 23, Name: createStateData
        return p1.States and p1.InitialState and {
            enteredAt = 0,
            transitionLocked = false,
            version = 0,
            current = p1.InitialState
        } or nil;
    end,

    tryTransition = function(p2, p3, p4, p5) -- Line: 43, Name: tryTransition
        -- upvalues: SkillStateMachine (copy)
        local skillModule = p2.skillModule;
        local skillRunData = p2.skillRunData;

        if not (skillModule.Transitions and skillRunData.State) then
            return false;
        end;

        if skillRunData.State.transitionLocked then
            return false;
        end;

        local v6 = skillModule.States and skillModule.States[skillRunData.State.current];

        if v6 and v6.IsTerminal then
            return false;
        end;

        local v7 = SkillStateMachine.findTransition(skillModule.Transitions, skillRunData.State.current, p3, p2, p4);

        if not v7 then
            return false;
        end;

        local callEnterHandler = p5.callEnterHandler;
        local callExitHandler = p5.callExitHandler;
        local onTerminalReached = p5.onTerminalReached;
        local onFatalError = p5.onFatalError;
        local current = skillRunData.State.current;
        local enteredAt = skillRunData.State.enteredAt;
        local v8 = skillRunData.State.version or 0;
        skillRunData.State.transitionLocked = true;
        local success, result = pcall(callExitHandler, p2, current, p4);

        if not success then
            skillRunData.State.transitionLocked = false;
            warn("[SkillStateRuntime] ExitHandler 异常:", p2.skillName, p3, current, result);

            if type(onFatalError) == "function" then
                pcall(onFatalError, p2, "ExitFailed");
            end;

            return false;
        end;

        skillRunData.State.current = v7.To;
        skillRunData.State.enteredAt = p2.nowTime;
        skillRunData.State.version = v8 + 1;
        local success2, result2 = pcall(callEnterHandler, p2, v7.To, p4);

        if success2 then
            skillRunData.State.transitionLocked = false;
            local v9 = skillModule.States and skillModule.States[v7.To];

            if v9 and (v9.IsTerminal and onTerminalReached) then
                local success3, result3 = pcall(onTerminalReached, p2, v7.To);

                if not success3 then
                    warn("[SkillStateRuntime] onTerminalReached 异常:", p2.skillName, v7.To, result3);

                    if type(p5.onFatalError) == "function" then
                        pcall(p5.onFatalError, p2, "TerminalReachedFailed");
                    end;
                end;
            end;

            return true;
        end;

        skillRunData.State.current = current;
        skillRunData.State.enteredAt = enteredAt;
        skillRunData.State.version = v8;
        skillRunData.State.transitionLocked = false;
        warn("[SkillStateRuntime] EnterHandler 异常，已回滚:", p2.skillName, p3, v7.To, result2);

        if type(onFatalError) == "function" then
            pcall(onFatalError, p2, "EnterFailed");
        end;

        return false;
    end,

    getCurrentState = function(p10) -- Line: 119, Name: getCurrentState
        if p10 and p10.State then
            return p10.State.current;
        end;

        return nil;
    end,

    getStateVersion = function(p11) -- Line: 131, Name: getStateVersion
        if p11 then
            p11 = p11.skillRunData;
        end;

        return p11 and p11.State and (p11.State.version or 0) or 0;
    end,

    isVersionValid = function(p12, p13) -- Line: 145, Name: isVersionValid
        if p12 then
            p12 = p12.skillRunData;
        end;

        if p12 and p12.State then
            return (p12.State.version or 0) == p13;
        end;

        return false;
    end
};