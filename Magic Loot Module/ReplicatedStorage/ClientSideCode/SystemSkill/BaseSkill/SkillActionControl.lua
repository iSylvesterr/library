-- Decompiled with Potassium's decompiler.

local SkillActionExclusive = require(script.Parent.SkillAction.SkillActionExclusive);
local u1 = {
    skill = nil,
    skillTimeLine = nil,
    startTime = 0,
    overTime = 0,
    StateEnum = {
        NoStart = 1,
        Play = 2,
        Over = 3
    }
};

function u1.Init(p2) -- Line: 28
    -- upvalues: u1 (copy)
    p2.state = u1.StateEnum.NoStart;
    p2._destroyed = false;
end;

function u1.Start(p3, p4) -- Line: 34
end;

function u1.OnOver(p5, p6) -- Line: 37
end;

function u1.Over(p7, p8) -- Line: 40
    -- upvalues: u1 (copy), SkillActionExclusive (copy)
    if p7.state == u1.StateEnum.Over then
        return;
    end;

    SkillActionExclusive.releaseIfOwner(p7);
    p7.state = u1.StateEnum.Over;
    p7:OnOver(p8);
end;

function u1.Destroy(p9) -- Line: 50
    if p9._destroyed then
        return;
    end;

    p9._destroyed = true;
    p9:Over(0);
end;

function u1.Run(p10, p11) -- Line: 58
    -- upvalues: u1 (copy)
    if p10.state == u1.StateEnum.NoStart then
        if p10.startTime < p11 then
            p10:Start(p11);
            p10.state = u1.StateEnum.Play;
        end;
    elseif p10.state == u1.StateEnum.Play and (p10.overTime >= 0 and p10.overTime < p11) then
        p10:Over(p11);
    end;
end;

return u1;