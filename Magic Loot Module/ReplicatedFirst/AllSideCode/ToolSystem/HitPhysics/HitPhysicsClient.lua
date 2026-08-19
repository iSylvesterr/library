-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local PhysicsMotion = require(ReplicatedFirst.AllSideCode.UtilsSystem).PhysicsMotion;
local HitPhysicsSubject = require(script.Parent.HitPhysicsSubject);

return {
    handleIncoming = function(p1) -- Line: 30, Name: handleIncoming
        -- upvalues: HitPhysicsSubject (copy), PhysicsMotion (copy)
        if type(p1) ~= "table" then
            return;
        end;

        local profileName = p1.profileName;

        if typeof(profileName) ~= "string" or profileName == "" then
            return;
        end;

        local direction = p1.direction;

        if typeof(direction) ~= "Vector3" or direction.Magnitude < 0.0001 then
            return;
        end;

        local subjectRoot = p1.subjectRoot;
        local subjectKey = p1.subjectKey;

        if typeof(subjectRoot) ~= "string" or typeof(subjectKey) ~= "string" then
            return;
        end;

        if HitPhysicsSubject.isLocalMonsterRoot(subjectRoot) then
            return;
        end;

        task.defer(function() -- Line: 56
            -- upvalues: HitPhysicsSubject (ref), subjectRoot (copy), subjectKey (copy), PhysicsMotion (ref), profileName (copy), direction (copy)
            local v2 = HitPhysicsSubject.decode(subjectRoot, subjectKey);

            if not (v2 and v2.Parent) then
                return;
            end;

            if not PhysicsMotion then
                return;
            end;

            PhysicsMotion.apply({
                subject = v2,
                profileName = profileName,
                direction = direction
            });
        end);
    end
};