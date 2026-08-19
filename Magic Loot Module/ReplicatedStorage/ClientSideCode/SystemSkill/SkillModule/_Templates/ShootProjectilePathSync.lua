-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local SkillEventConst = require(script.Parent.Parent.Parent.BaseSkill.SkillEventConst);
local u11 = {
    pathFromSync = function(p1, p2, p3) -- Line: 18, Name: pathFromSync
        if p3.Magnitude < 0.0001 then
            p3 = p2 - p1;
        end;

        local v4 = p3.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or p3.Unit;

        return {
            moveStart = CFrame.lookAt(p1, p1 + v4),
            moveEnd = CFrame.lookAt(p2, p2 + v4),
            flyDir = v4
        };
    end,

    storePath = function(p5, p6, p7) -- Line: 37, Name: storePath
        p5.Visual = p5.Visual or {};
        p5.Visual.projectilePaths = p5.Visual.projectilePaths or {};
        p5.Visual.projectilePaths[p6] = p7;
    end,

    getPath = function(p8, p9) -- Line: 43, Name: getPath
        local v10 = p8 and p8.Visual and p8.Visual.projectilePaths;

        if v10 then
            v10 = v10[p9];
        end;

        return v10;
    end
};

function u11.waitForPath(p12, p13, p14) -- Line: 48
    -- upvalues: u11 (copy), RunService (copy)
    local v15 = os.clock() + 0.35;

    while p12:isRunningFlow() and p12.runGeneration == p14 do
        local v16 = u11.getPath(p12.skillRunData, p13);

        if v16 then
            return v16;
        end;

        if v15 <= os.clock() then
            return nil;
        end;

        RunService.Heartbeat:Wait();
    end;

    return nil;
end;

function u11.handleServerEvent(p17, p18) -- Line: 63
    -- upvalues: SkillEventConst (copy), u11 (copy)
    if p18.eventType ~= SkillEventConst.SyncEventType.ProjectilePathConfirmed then
        return false;
    end;

    if p18.skillCastId and p18.skillCastId ~= p17.skillCastId then
        return true;
    end;

    if p18.baseSkillInstanceId and p18.baseSkillInstanceId ~= p17.baseSkillInstanceId then
        return true;
    end;

    local v19 = p18.projectileIndex or 1;
    local startPos = p18.startPos;
    local endPos = p18.endPos;
    local flyDir = p18.flyDir;

    if typeof(startPos) ~= "Vector3" or (typeof(endPos) ~= "Vector3" or typeof(flyDir) ~= "Vector3") then
        return true;
    end;

    local skillRunData = p17.skillRunData;

    if not skillRunData then
        return true;
    end;

    u11.storePath(skillRunData, v19, u11.pathFromSync(startPos, endPos, flyDir));

    return true;
end;

return u11;