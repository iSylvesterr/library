-- Decompiled with Potassium's decompiler.

local u1 = {};

local function calculateMaxActionOverTime(p2) -- Line: 16
    local v3 = 0;

    for _, v in p2.Action or {} do
        if v and (v.overTime and v3 < v.overTime) then
            v3 = v.overTime;
        end;
    end;

    return v3;
end;

function u1.create(p4, p5) -- Line: 33
    -- upvalues: calculateMaxActionOverTime (copy)
    local v6 = p5 or {};

    return {
        isPhase1Complete = false,
        isControlReleased = false,
        openedAt = nil,
        releasedAt = nil,
        maxActionOverTime = calculateMaxActionOverTime(p4),
        _isClient = v6.isClient,
        _getActionsOverCheck = v6.getActionsOverCheck
    };
end;

function u1.update(p7, p8, p9) -- Line: 53
    if p7.isPhase1Complete then
        return;
    end;

    local v10 = false;
    local skillModule = p9.skillModule;

    if skillModule.SustainHoldDelaysPhase1Complete == true then
        if type(skillModule.CanReleaseControl) == "function" and skillModule.CanReleaseControl(p9) then
            p7.isPhase1Complete = true;
            v10 = true;
        end;

        if v10 and not p7.openedAt then
            p7.openedAt = p8;
        end;

        return;
    end;

    if type(skillModule.CanReleaseControl) == "function" and skillModule.CanReleaseControl(p9) then
        p7.isPhase1Complete = true;
        v10 = true;
    elseif skillModule.ControlOpenState and (p9.skillRunData and (p9.skillRunData.State and p9.skillRunData.State.current == skillModule.ControlOpenState)) then
        p7.isPhase1Complete = true;
        v10 = true;
    elseif p7._getActionsOverCheck then
        if p7._getActionsOverCheck() then
            p7.isPhase1Complete = true;
            v10 = true;
        end;
    elseif p7.maxActionOverTime > 0 and p7.maxActionOverTime <= p8 then
        p7.isPhase1Complete = true;
        v10 = true;
    end;

    if v10 and not p7.openedAt then
        p7.openedAt = p8;
    end;
end;

function u1.getState(p11) -- Line: 100
    return p11.isControlReleased and "Released" or (p11.isPhase1Complete and "ChainOpen" or "Locked");
end;

function u1.release(p12, p13) -- Line: 111
    p12.isControlReleased = true;

    if p13 ~= nil then
        p12.releasedAt = p13;
    end;
end;

function u1.reset(p14) -- Line: 122
    p14.isPhase1Complete = false;
    p14.isControlReleased = false;
    p14.openedAt = nil;
    p14.releasedAt = nil;
end;

function u1.forceMarkPhase1CompleteAndRelease(p15, p16) -- Line: 132
    -- upvalues: u1 (copy)
    local v17 = p16 or 0;
    p15.isPhase1Complete = true;

    if not p15.openedAt then
        p15.openedAt = v17;
    end;

    u1.release(p15, v17);
end;

return u1;