-- Decompiled with Potassium's decompiler.

local function getStateOrderFromRuntime(p1) -- Line: 41
    local v2 = p1:GetCurrentBaseSkill();

    if v2 and v2.skillModule then
        return v2.skillModule.StateOrder;
    end;

    return nil;
end;

local function getStateOrderSafe(p3, p4) -- Line: 50
    if p3 == nil or p4 == nil then
        return nil;
    end;

    return p3[p4];
end;

local function warnUnknownState(p5, p6, p7, p8) -- Line: 55
    local v9 = p5 and p5.owner and (p5.owner.skillName or "?") or "?";
    local v10 = p5 and p5.skillCastId or "?";
    local v11 = ("[ChainConditionContext] 未知状态或配置缺失: current=%s target=%s skill=%s castId=%s"):format(tostring(p6), tostring(p7), tostring(v9), (tostring(v10)));

    if p8 and p8 ~= "" then
        v11 = v11 .. " " .. tostring(p8);
    end;

    warn(v11);
end;

local function isPastPoint(p12, p13, p14, p15, p16) -- Line: 72
    if not p12 or (p13 == nil or not (p14 and p15)) then
        return false;
    end;

    local v17;

    if p15 == nil or p12 == nil then
        v17 = nil;
    else
        v17 = p15[p12];
    end;

    local state = p14.state;
    local v18;

    if p15 == nil or state == nil then
        v18 = nil;
    else
        v18 = p15[state];
    end;

    if v17 ~= nil and v18 ~= nil then
        return p12 == p14.state and (p14.elapsed or 0) < p13 and true or v18 < v17;
    end;

    if p14 then
        p14 = p14.state;
    end;

    local v19 = p16 and p16.owner and (p16.owner.skillName or "?") or "?";
    local v20 = p16 and p16.skillCastId or "?";
    local v21 = ("[ChainConditionContext] 未知状态或配置缺失: current=%s target=%s skill=%s castId=%s"):format(tostring(p12), tostring(p14), tostring(v19), (tostring(v20))) .. " " .. tostring("isPastPoint");
    warn(v21);

    return false;
end;

return {
    createChainConditionContext = function(u22) -- Line: 89, Name: createChainConditionContext
        -- upvalues: warnUnknownState (copy), isPastPoint (copy)
        return {
            CheckChainInput = function(p23, p24) -- Line: 91, Name: CheckChainInput
                -- upvalues: u22 (copy)
                return u22:CheckDeriveRequest(p23, p24);
            end,

            CheckInput = function(p25) -- Line: 95, Name: CheckInput
                -- upvalues: u22 (copy)
                return u22:CheckInputBuffered(p25, 0.3);
            end,

            CheckInputBuffered = function(p26, p27) -- Line: 99, Name: CheckInputBuffered
                -- upvalues: u22 (copy)
                return u22:CheckInputBuffered(p26, p27);
            end,

            ElapsedAfter = function(p28) -- Line: 103, Name: ElapsedAfter
                -- upvalues: u22 (copy)
                local v29 = u22:GetCurrentBaseSkillStateElapsed();
                local v30;

                if v29 == nil then
                    v30 = false;
                else
                    v30 = p28 < v29;
                end;

                return v30;
            end,

            ElapsedAfterInState = function(p31, p32) -- Line: 108, Name: ElapsedAfterInState
                -- upvalues: u22 (copy)
                if u22:GetCurrentBaseSkillState() ~= p31 then
                    return false;
                end;

                local v33 = u22:GetCurrentBaseSkillStateElapsed();
                local v34;

                if v33 == nil then
                    v34 = false;
                else
                    v34 = p32 < v33;
                end;

                return v34;
            end,

            InWindow = function(p35) -- Line: 116, Name: InWindow
                -- upvalues: u22 (copy), warnUnknownState (ref), isPastPoint (ref)
                local v36 = u22:GetCurrentBaseSkill();
                local v37;

                if v36 and v36.skillModule then
                    v37 = v36.skillModule.StateOrder;
                else
                    v37 = nil;
                end;

                if not v37 then
                    warnUnknownState(u22, nil, nil, ("InWindow(%s) StateOrder 缺失"):format((tostring(p35))));

                    return false;
                end;

                local v38 = u22.owner and u22.owner.groupSkillModule;

                if not (v38 and v38.ChainWindows) then
                    warnUnknownState(u22, nil, nil, ("InWindow(%s) ChainWindows 缺失"):format((tostring(p35))));

                    return false;
                end;

                local v39 = v38.ChainWindows[p35];

                if not (v39 and (v39.open and v39.close)) then
                    warnUnknownState(u22, nil, nil, ("InWindow(%s) 窗口配置缺失"):format((tostring(p35))));

                    return false;
                end;

                local v40 = u22:GetCurrentBaseSkillState();
                local v41 = u22:GetCurrentBaseSkillStateElapsed();

                if not v40 or v41 == nil then
                    return false;
                end;

                local v42 = isPastPoint(v40, v41, v39.open, v37, u22);
                local v43 = isPastPoint(v40, v41, v39.close, v37, u22);

                if v42 then
                    v42 = not v43;
                end;

                return v42;
            end,

            ElapsedInWindow = function(p44, p45, p46, p47) -- Line: 142, Name: ElapsedInWindow
                -- upvalues: u22 (copy), isPastPoint (ref)
                local v48 = u22:GetCurrentBaseSkill();
                local v49;

                if v48 and v48.skillModule then
                    v49 = v48.skillModule.StateOrder;
                else
                    v49 = nil;
                end;

                if not v49 then
                    local v50 = u22;
                    local v51 = v50 and v50.owner and (v50.owner.skillName or "?") or "?";
                    local v52 = v50 and v50.skillCastId or "?";
                    local v53 = ("[ChainConditionContext] 未知状态或配置缺失: current=%s target=%s skill=%s castId=%s"):format(tostring(nil), tostring(nil), tostring(v51), (tostring(v52))) .. " " .. tostring("ElapsedInWindow StateOrder 缺失");
                    warn(v53);

                    return false;
                end;

                local v54 = u22:GetCurrentBaseSkillState();
                local v55 = u22:GetCurrentBaseSkillStateElapsed();

                if not v54 or v55 == nil then
                    return false;
                end;

                local v56 = isPastPoint(v54, v55, {
                    state = p44,
                    elapsed = p45
                }, v49, u22);
                local v57 = isPastPoint(v54, v55, {
                    state = p46,
                    elapsed = p47
                }, v49, u22);

                if v56 then
                    v56 = not v57;
                end;

                return v56;
            end,

            TotalElapsedAfter = function(p58) -- Line: 158, Name: TotalElapsedAfter
                -- upvalues: u22 (copy)
                local v59 = u22:GetCurrentBaseSkillTotalTime();
                local v60;

                if v59 == nil then
                    v60 = false;
                else
                    v60 = p58 < v59;
                end;

                return v60;
            end,

            CurrentBaseSkillStateIs = function(p61) -- Line: 163, Name: CurrentBaseSkillStateIs
                -- upvalues: u22 (copy)
                return u22:GetCurrentBaseSkillState() == p61;
            end,

            StatePassed = function(p62) -- Line: 167, Name: StatePassed
                -- upvalues: u22 (copy)
                local v63 = u22:GetCurrentBaseSkill();
                local v64;

                if v63 and v63.skillModule then
                    v64 = v63.skillModule.StateOrder;
                else
                    v64 = nil;
                end;

                local v65 = u22:GetCurrentBaseSkillState();

                if not (v64 and v65) then
                    return false;
                end;

                local v66;

                if v64 == nil or v65 == nil then
                    v66 = nil;
                else
                    v66 = v64[v65];
                end;

                local v67;

                if v64 == nil or p62 == nil then
                    v67 = nil;
                else
                    v67 = v64[p62];
                end;

                if v66 ~= nil and v67 ~= nil then
                    return v67 <= v66;
                end;

                local v68 = u22;
                local v69 = v68 and v68.owner and (v68.owner.skillName or "?") or "?";
                local v70 = v68 and v68.skillCastId or "?";
                local v71 = ("[ChainConditionContext] 未知状态或配置缺失: current=%s target=%s skill=%s castId=%s"):format(tostring(v65), tostring(p62), tostring(v69), (tostring(v70))) .. " " .. tostring("StatePassed");
                warn(v71);

                return false;
            end,

            StateBefore = function(p72) -- Line: 180, Name: StateBefore
                -- upvalues: u22 (copy)
                local v73 = u22:GetCurrentBaseSkill();
                local v74;

                if v73 and v73.skillModule then
                    v74 = v73.skillModule.StateOrder;
                else
                    v74 = nil;
                end;

                local v75 = u22:GetCurrentBaseSkillState();

                if not (v74 and v75) then
                    return false;
                end;

                local v76;

                if v74 == nil or v75 == nil then
                    v76 = nil;
                else
                    v76 = v74[v75];
                end;

                local v77;

                if v74 == nil or p72 == nil then
                    v77 = nil;
                else
                    v77 = v74[p72];
                end;

                if v76 ~= nil and v77 ~= nil then
                    return v76 < v77;
                end;

                local v78 = u22;
                local v79 = v78 and v78.owner and (v78.owner.skillName or "?") or "?";
                local v80 = v78 and v78.skillCastId or "?";
                local v81 = ("[ChainConditionContext] 未知状态或配置缺失: current=%s target=%s skill=%s castId=%s"):format(tostring(v75), tostring(p72), tostring(v79), (tostring(v80))) .. " " .. tostring("StateBefore");
                warn(v81);

                return false;
            end,

            ControlStateIs = function(p82) -- Line: 193, Name: ControlStateIs
                -- upvalues: u22 (copy)
                return u22:GetCurrentBaseSkillControlState() == p82;
            end,

            CurrentBaseSkillIndexIs = function(p83) -- Line: 197, Name: CurrentBaseSkillIndexIs
                -- upvalues: u22 (copy)
                return u22.activeBaseSkillIndex == p83;
            end
        };
    end
};