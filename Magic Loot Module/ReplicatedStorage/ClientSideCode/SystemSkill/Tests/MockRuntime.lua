-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 9
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3.activeBaseSkillIndex = p2 and (p2.activeBaseSkillIndex or 1) or 1;
    v3.nowTime = p2 and (p2.nowTime or 0) or 0;
    v3.deriveRequestByIndex = p2 and (p2.deriveRequestByIndex or {}) or {};
    v3.inputBuffer = p2 and (p2.inputBuffer or {}) or {};
    v3.baseSkills = p2 and (p2.baseSkills or {}) or {};
    v3.owner = p2 and (p2.owner or {}) or {};
    v3.groupSkillModule = p2 and (p2.groupSkillModule or {}) or {};
    v3.skillCastId = p2 and p2.skillCastId or "mock_cast";

    return v3;
end;

function u1.GetCurrentBaseSkill(p4) -- Line: 22
    return p4.baseSkills[p4.activeBaseSkillIndex];
end;

function u1.GetCurrentBaseSkillState(p5) -- Line: 26
    local v6 = p5:GetCurrentBaseSkill();

    if v6 and (v6.skillRunData and v6.skillRunData.State) then
        return v6.skillRunData.State.current;
    end;

    return nil;
end;

function u1.GetCurrentBaseSkillStateElapsed(p7) -- Line: 34
    local v8 = p7:GetCurrentBaseSkill();

    if not (v8 and (v8.skillRunData and v8.skillRunData.State)) then
        return nil;
    end;

    local enteredAt = v8.skillRunData.State.enteredAt;

    if enteredAt == nil then
        return nil;
    end;

    return (v8.nowTime or 0) - enteredAt;
end;

function u1.GetCurrentBaseSkillTotalTime(p9) -- Line: 44
    local v10 = p9:GetCurrentBaseSkill();
    local v11;

    if v10 then
        v11 = v10.nowTime;

        if not v11 then
            return 0;
        end;
    else
        v11 = nil;
    end;

    return v11;
end;

function u1.GetCurrentBaseSkillControlState(p12) -- Line: 49
    local v13 = p12:GetCurrentBaseSkill();

    if v13 and type(v13.getControlState) == "function" then
        return v13:getControlState();
    end;

    return nil;
end;

function u1.CheckDeriveRequest(p14, p15, p16) -- Line: 55
    local v17 = p14.deriveRequestByIndex and p14.deriveRequestByIndex[p15];

    if v17 == nil or type(v17) ~= "number" then
        return false;
    end;

    return (p16 or 0.25) >= p14.nowTime - v17;
end;

function u1.CheckInputBuffered(p18, p19, p20) -- Line: 67
    if p18.inputBuffer and p18.inputBuffer[p19] then
        return p18.nowTime - p18.inputBuffer[p19] <= p20;
    end;

    return false;
end;

return u1;