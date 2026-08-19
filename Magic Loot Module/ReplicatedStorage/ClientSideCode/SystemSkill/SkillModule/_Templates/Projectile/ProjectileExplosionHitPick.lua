-- Decompiled with Potassium's decompiler.

local EntityUtil = require(script.Parent.Parent.Parent.Parent.BaseSkill.EntityUtil);
local ProjectileObjectTracking = require(script.Parent.ProjectileObjectTracking);
local v1 = {};

local function _resolveTrackTargetId(p2) -- Line: 21
    local v3;

    if p2 then
        v3 = p2.skillInputData;
    else
        v3 = p2;
    end;

    if v3 and (v3.trackTargetId ~= nil and v3.trackTargetId ~= "") then
        return v3.trackTargetId;
    end;

    local v4 = p2 and p2.skillRunData and p2.skillRunData.Logic;

    if v4 and (v4.trackTargetId ~= nil and v4.trackTargetId ~= "") then
        return v4.trackTargetId;
    end;

    return nil;
end;

local function _pickTrackedFromHitResult(p5, p6) -- Line: 39
    -- upvalues: EntityUtil (copy)
    if not p6 then
        return nil, nil;
    end;

    local v7 = p5[p6];

    if v7 then
        return p6, v7;
    end;

    for i, v in p5 do
        if EntityUtil.isSameEntity(i, p6) then
            return i, v;
        end;
    end;

    return nil, nil;
end;

function v1.pickPrimaryTarget(p8, p9, p10) -- Line: 62
    -- upvalues: ProjectileObjectTracking (copy), _pickTrackedFromHitResult (copy)
    if not (p8 and next(p8)) then
        return nil, nil;
    end;

    local v11;

    if p10 then
        v11 = p10.skillInputData;
    else
        v11 = p10;
    end;

    local v12;

    if v11 and (v11.trackTargetId ~= nil and v11.trackTargetId ~= "") then
        v12 = v11.trackTargetId;
    else
        local v13 = p10 and p10.skillRunData and p10.skillRunData.Logic;

        if v13 and (v13.trackTargetId ~= nil and v13.trackTargetId ~= "") then
            v12 = v13.trackTargetId;
        else
            v12 = nil;
        end;
    end;

    local v14;

    if v12 then
        v14 = ProjectileObjectTracking.findModelByTrackTargetId(v12);
    else
        v14 = nil;
    end;

    if v14 and not ProjectileObjectTracking.isTrackTargetAlive(v12) then
        v14 = nil;
    end;

    local v15, v16 = _pickTrackedFromHitResult(p8, v14);

    if v15 and v16 then
        return v15, v16;
    end;

    local v17 = nil;
    local v18;

    if p9 then
        v18 = p9.hitbox;
    else
        v18 = p9;
    end;

    if p9 and p9.getWorldCenter then
        v17 = p9:getWorldCenter();
    elseif v18 and v18.Position then
        v17 = v18.Position;
    end;

    local v19 = (1 / 0);
    local v20 = nil;
    local v21 = nil;

    for i, v in p8 do
        local v22 = not v17 and 0 or (v.Position - v17).Magnitude;

        if v22 < v19 then
            v21 = v;
            v20 = i;
            v19 = v22;
        end;
    end;

    return v20, v21;
end;

return v1;