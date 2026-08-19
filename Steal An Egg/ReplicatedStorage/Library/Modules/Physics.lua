-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = t.union(t.instanceIsA("Model"), t.table);

return {
    SetCollisionGroup = function(p2, u3) -- Line: 20, Name: SetCollisionGroup
        -- upvalues: u1 (copy), Asserts (copy)
        assert(u1(p2));
        Asserts.string(u3);

        local function setCollisionGroup(p4) -- Line: 24
            -- upvalues: u3 (copy)
            if not p4:IsA("BasePart") then
                return;
            end;

            p4.CollisionGroup = u3;
        end;

        if typeof(p2) == "table" then
            for _, v in ipairs(p2) do
                if v:IsA("BasePart") then
                    v.CollisionGroup = u3;
                end;
            end;

            return;
        end;

        for _, descendant in p2:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CollisionGroup = u3;
            end;
        end;
    end,

    DisableAllPhysics = function(p5, p6, p7) -- Line: 41, Name: DisableAllPhysics
        -- upvalues: Asserts (copy)
        Asserts.Instance(p5);
        Asserts.optional.string(p6);

        for _, descendant in p5:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false;
                descendant.CanQuery = p7 or false;
                descendant.CanTouch = false;
                descendant.Massless = true;
            end;
        end;
    end,

    DisableCollisions = function(p8) -- Line: 57, Name: DisableCollisions
        -- upvalues: Asserts (copy)
        Asserts.Instance(p8);

        for _, descendant in p8:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false;
            end;
        end;
    end,

    SetAnchored = function(p9, p10) -- Line: 69, Name: SetAnchored
        -- upvalues: Asserts (copy)
        Asserts.Model(p9);
        Asserts.boolean(p10);

        for _, descendant in p9:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = p10;
            end;
        end;
    end,

    DisableHumanoidStates = function(p11) -- Line: 82, Name: DisableHumanoidStates
        if not p11 then
            return;
        end;

        for _, v in {
            Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Ragdoll,
            Enum.HumanoidStateType.GettingUp,
            Enum.HumanoidStateType.Jumping,
            Enum.HumanoidStateType.Freefall,
            Enum.HumanoidStateType.Climbing,
            Enum.HumanoidStateType.Flying,
            Enum.HumanoidStateType.Seated,
            Enum.HumanoidStateType.PlatformStanding,
            Enum.HumanoidStateType.Swimming,
            Enum.HumanoidStateType.Physics
        } do
            p11:SetStateEnabled(v, false);
        end;
    end,

    ApplyTemporaryLinearVelocity = function(p12, p13, p14, p15) -- Line: 106, Name: ApplyTemporaryLinearVelocity
        -- upvalues: Asserts (copy)
        Asserts.BasePart(p12);
        Asserts.string(p13);
        Asserts.Vector3(p14);
        Asserts.number(p15);
        assert(p13 ~= "", "Physics.ApplyTemporaryLinearVelocity expected non-empty name");
        assert(p15 >= 0, "Physics.ApplyTemporaryLinearVelocity expected non-negative duration");
        local Attachment = Instance.new("Attachment");
        Attachment.Name = `{p13}Attachment`;
        Attachment.Parent = p12;
        local LinearVelocity = Instance.new("LinearVelocity");
        LinearVelocity.Name = p13;
        LinearVelocity.Attachment0 = Attachment;
        LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
        LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
        LinearVelocity.ForceLimitsEnabled = true;
        LinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
        LinearVelocity.MaxAxesForce = Vector3.new(inf, 0, inf);
        LinearVelocity.VectorVelocity = p14;
        LinearVelocity.Parent = p12;
        task.delay(p15, function() -- Line: 134
            -- upvalues: LinearVelocity (copy), Attachment (copy)
            if LinearVelocity.Parent then
                LinearVelocity:Destroy();
            end;

            if Attachment.Parent then
                Attachment:Destroy();
            end;
        end);

        return function() -- Line: 143
            -- upvalues: LinearVelocity (copy), Attachment (copy)
            if LinearVelocity.Parent then
                LinearVelocity:Destroy();
            end;

            if Attachment.Parent then
                Attachment:Destroy();
            end;
        end;
    end
};