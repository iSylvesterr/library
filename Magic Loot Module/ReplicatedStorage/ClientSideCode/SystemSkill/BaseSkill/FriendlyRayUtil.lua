-- Decompiled with Potassium's decompiler.

local EntityUtil = require(script.Parent.EntityUtil);
local u3 = {
    getModelFromHit = function(p1) -- Line: 24, Name: getModelFromHit
        if not (p1 and p1:IsA("BasePart")) then
            return nil;
        end;

        local v2 = p1:FindFirstAncestorOfClass("Model");

        if v2 then
            return v2;
        end;

        if p1.Parent and p1.Parent:IsA("Model") then
            return p1.Parent;
        end;

        return nil;
    end
};

local function isIgnoredInstance(p4, p5) -- Line: 38
    for _, v in p5 do
        if p4 == v or p4:IsDescendantOf(v) then
            return true;
        end;
    end;

    return false;
end;

function u3.shouldPenetrateHit(p6, p7) -- Line: 50
    -- upvalues: u3 (copy), EntityUtil (copy)
    if not p6 or (not p7 or (p7.id == nil or not p7.type)) then
        return false;
    end;

    local v8 = u3.getModelFromHit(p6);

    if v8 then
        return EntityUtil.isNonHostileTarget(p7.id, p7.type, v8);
    end;

    return false;
end;

function u3.raycastProjectileObstacle(p9, p10, p11, p12) -- Line: 64
    -- upvalues: u3 (copy)
    local v13 = u3.raycast(p9, p10, p11, p12);

    if not v13 then
        return nil;
    end;

    local v14 = u3.getModelFromHit(v13.Instance);

    if v14 and v14:FindFirstChildOfClass("Humanoid") then
        return nil;
    end;

    return v13;
end;

function u3.raycast(p15, p16, p17, p18) -- Line: 84
    -- upvalues: u3 (copy)
    local Magnitude = p16.Magnitude;

    if Magnitude < 0.0001 then
        return nil;
    end;

    local v19 = p18 and (p18.maxPenetrations or 8) or 8;
    local v20 = (not p18 or p18.ignoreWater == nil) and true or p18.ignoreWater;
    local Unit = p16.Unit;
    local v21 = p15 + p16;
    local v22 = {};

    if p18 and p18.extraIgnore then
        for _, v in p18.extraIgnore do
            if typeof(v) == "Instance" then
                table.insert(v22, v);
            end;
        end;
    end;

    local v23 = RaycastParams.new();
    v23.FilterType = Enum.RaycastFilterType.Blacklist;
    v23.IgnoreWater = v20;
    local v24 = p15;

    for _ = 1, v19 + 1 do
        local v25 = v21 - p15;

        if v25.Magnitude < 0.0001 then
            return nil;
        end;

        v23.FilterDescendantsInstances = v22;
        local v26 = workspace:Raycast(p15, v25, v23);

        if not v26 then
            return nil;
        end;

        if not u3.shouldPenetrateHit(v26.Instance, p17) then
            return v26;
        end;

        local v27 = u3.getModelFromHit(v26.Instance);
        local v28, v29;

        if v27 then
            local v30 = false;

            for _, v in v22 do
                if v27 == v or v27:IsDescendantOf(v) then
                    v30 = true;
                    break;
                end;
            end;

            if v30 then
                v28 = v26.Instance;
                v29 = false;

                for i, v in v22 do
                    if v28 == v or v28:IsDescendantOf(v) then
                        v29 = true;
                        break;
                    end;
                end;

                if not v29 then
                    table.insert(v22, v26.Instance);
                end;
            else
                table.insert(v22, v27);
            end;
        else
            v28 = v26.Instance;
            v29 = false;

            for i, v in v22 do
                if v28 == v or v28:IsDescendantOf(v) then
                    v29 = true;
                    break;
                end;
            end;

            if not v29 then
                table.insert(v22, v26.Instance);
            end;
        end;

        p15 = p15 + Unit * (math.max((v26.Position - p15).Magnitude, 0.001) + 0.01);

        if (p15 - v24).Magnitude >= Magnitude - 0.0001 then
            return nil;
        end;
    end;

    return nil;
end;

function u3.resolvePositionThroughFriendly(p31, p32, p33, p34) -- Line: 151
    -- upvalues: u3 (copy)
    local v35 = p32 - p31;

    if v35.Magnitude < 0.0001 then
        return p32;
    end;

    local v36 = u3.raycast(p31, v35, p33, p34);

    if v36 then
        return v36.Position;
    end;

    return p32;
end;

return u3;