-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local TweenService = UtilsSystem.TweenService;
local Debris = UtilsSystem.Debris;
local RunService = UtilsSystem.RunService;
local MotionResolve = require(script.Parent.MotionResolve);
local MotionRegistry = require(script.Parent.MotionRegistry);
local v1 = {};

local function _setAssemblyLinearVelocity(p2, p3, p4) -- Line: 29
    if p4.preserveVertical ~= false and (p4.plane or "xz") ~= "xyz" then
        p2.AssemblyLinearVelocity = Vector3.new(p3.X, p2.AssemblyLinearVelocity.Y, p3.Z);

        return;
    end;

    p2.AssemblyLinearVelocity = p3;
end;

local function _zeroCompetingVelocity(p5, p6) -- Line: 45
    local AssemblyLinearVelocity = p5.AssemblyLinearVelocity;

    if p6.preserveVertical ~= false and (p6.plane or "xz") ~= "xyz" then
        p5.AssemblyLinearVelocity = Vector3.new(0, AssemblyLinearVelocity.Y, 0);

        return;
    end;

    p5.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
end;

local function _applyKick(p7, p8, p9, p10) -- Line: 64
    if p9 <= 0 then
        return;
    end;

    local v11 = p8 * p9;
    local AssemblyLinearVelocity = p7.AssemblyLinearVelocity;

    if p10.preserveVertical ~= false and (p10.plane or "xz") ~= "xyz" then
        p7.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X + v11.X, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z + v11.Z);

        return;
    end;

    p7.AssemblyLinearVelocity = AssemblyLinearVelocity + v11;
end;

local function _suppressInwardVelocity(p12, p13, p14) -- Line: 86
    local v15 = p14.plane or "xz";
    local v16 = p14.preserveVertical ~= false;
    local AssemblyLinearVelocity = p12.AssemblyLinearVelocity;
    local v17;

    if v15 == "xyz" then
        v17 = AssemblyLinearVelocity;
    else
        v17 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
    end;

    local v18 = v17:Dot(p13);

    if v18 >= 0 then
        return;
    end;

    local v19 = v17 - p13 * v18;

    if v16 and v15 ~= "xyz" then
        p12.AssemblyLinearVelocity = Vector3.new(v19.X, AssemblyLinearVelocity.Y, v19.Z);

        return;
    end;

    p12.AssemblyLinearVelocity = v19;
end;

local function _destroyConstraint(p20) -- Line: 108
    local PhysicsMotionAttach = p20:FindFirstChild("PhysicsMotionAttach");

    if PhysicsMotionAttach then
        PhysicsMotionAttach:Destroy();
    end;
end;

function v1.start(u21, u22, u23, u24, u25, u26) -- Line: 126
    -- upvalues: MotionResolve (copy), MotionRegistry (copy), TweenService (copy), RunService (copy), _suppressInwardVelocity (copy), Debris (copy)
    local u27 = MotionResolve.resolveWorldDirection(u21, u22);
    local v28 = tonumber(u21.speed) or 0;
    local duration = u21.duration;

    if u27.Magnitude < 0.0001 or (v28 <= 0 or duration <= 0) then
        if u26 then
            u26("invalid");
        end;

        return function() -- Line: 141
        end;
    end;

    local v29 = u21.clearVelocityOnStart == true;
    local v30 = u21.suppressCompetingVelocity == true;
    local v31 = tonumber(u21.kickSpeed) or 0;
    local u32 = u21.restoreVelocityOnEnd == true;
    local u33 = u21.restoreVelocityOnCancel == nil and true or u21.restoreVelocityOnCancel;
    local AssemblyLinearVelocity = u22.AssemblyLinearVelocity;
    local u34 = false;
    local u35 = false;
    local u36 = nil;
    local u37 = nil;
    local u38 = nil;
    local u39 = nil;

    local function _disconnectAux() -- Line: 159
        -- upvalues: u36 (ref), u37 (ref)
        if u36 then
            u36:Disconnect();
            u36 = nil;
        end;

        if u37 then
            u37:Disconnect();
            u37 = nil;
        end;
    end;

    local function _maybeRestoreVelocity(p40) -- Line: 170
        -- upvalues: u22 (copy), AssemblyLinearVelocity (copy), u21 (copy)
        if not p40 then
            return;
        end;

        if u22.Parent then
            local v41 = u22;
            local v42 = AssemblyLinearVelocity;
            local v43 = u21;

            if v43.preserveVertical ~= false and (v43.plane or "xz") ~= "xyz" then
                v41.AssemblyLinearVelocity = Vector3.new(v42.X, v41.AssemblyLinearVelocity.Y, v42.Z);

                return;
            end;

            v41.AssemblyLinearVelocity = v42;
        end;
    end;

    local function finish(p44) -- Line: 179
        -- upvalues: u35 (ref), u39 (ref), u36 (ref), u37 (ref), u22 (copy), u33 (copy), AssemblyLinearVelocity (copy), u21 (copy), u32 (copy), MotionRegistry (ref), u25 (copy), u24 (copy), u26 (copy)
        if u35 then
            return;
        end;

        u35 = true;

        if u39 then
            u39:Cancel();
            u39 = nil;
        end;

        if u36 then
            u36:Disconnect();
            u36 = nil;
        end;

        if u37 then
            u37:Disconnect();
            u37 = nil;
        end;

        local PhysicsMotionAttach = u22:FindFirstChild("PhysicsMotionAttach");

        if PhysicsMotionAttach then
            PhysicsMotionAttach:Destroy();
        end;

        if p44 == "cancel" then
            if u33 and u22.Parent then
                local v45 = u22;
                local v46 = AssemblyLinearVelocity;
                local v47 = u21;

                if v47.preserveVertical ~= false and (v47.plane or "xz") ~= "xyz" then
                    v45.AssemblyLinearVelocity = Vector3.new(v46.X, v45.AssemblyLinearVelocity.Y, v46.Z);
                else
                    v45.AssemblyLinearVelocity = v46;
                end;
            end;
        elseif p44 == "complete" and (u32 and u22.Parent) then
            local v48 = u22;
            local v49 = AssemblyLinearVelocity;
            local v50 = u21;

            if v50.preserveVertical ~= false and (v50.plane or "xz") ~= "xyz" then
                v48.AssemblyLinearVelocity = Vector3.new(v49.X, v48.AssemblyLinearVelocity.Y, v49.Z);
            else
                v48.AssemblyLinearVelocity = v49;
            end;
        end;

        MotionRegistry.release(u22, u25, u24);

        if u26 then
            u26(p44);
        end;
    end;

    local function cancel() -- Line: 201
        -- upvalues: u34 (ref), u35 (ref), u38 (ref), u39 (ref), u36 (ref), u37 (ref), u22 (copy), u33 (copy), AssemblyLinearVelocity (copy), u21 (copy), MotionRegistry (ref), u25 (copy), u24 (copy), u26 (copy)
        if u34 or u35 then
            return;
        end;

        u34 = true;

        if u38 then
            task.cancel(u38);
            u38 = nil;
        end;

        if u35 then
            return;
        end;

        u35 = true;

        if u39 then
            u39:Cancel();
            u39 = nil;
        end;

        if u36 then
            u36:Disconnect();
            u36 = nil;
        end;

        if u37 then
            u37:Disconnect();
            u37 = nil;
        end;

        local PhysicsMotionAttach = u22:FindFirstChild("PhysicsMotionAttach");

        if PhysicsMotionAttach then
            PhysicsMotionAttach:Destroy();
        end;

        if u33 and u22.Parent then
            local v51 = u22;
            local v52 = AssemblyLinearVelocity;
            local v53 = u21;

            if v53.preserveVertical ~= false and (v53.plane or "xz") ~= "xyz" then
                v51.AssemblyLinearVelocity = Vector3.new(v52.X, v51.AssemblyLinearVelocity.Y, v52.Z);
            else
                v51.AssemblyLinearVelocity = v52;
            end;
        end;

        MotionRegistry.release(u22, u25, u24);

        if u26 then
            u26("cancel");
        end;
    end;

    local PhysicsMotionAttach = u22:FindFirstChild("PhysicsMotionAttach");

    if PhysicsMotionAttach then
        PhysicsMotionAttach:Destroy();
    end;

    if v29 then
        local AssemblyLinearVelocity2 = u22.AssemblyLinearVelocity;

        if u21.preserveVertical ~= false and (u21.plane or "xz") ~= "xyz" then
            u22.AssemblyLinearVelocity = Vector3.new(0, AssemblyLinearVelocity2.Y, 0);
        else
            u22.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        end;
    end;

    if v31 > 0 and v31 > 0 then
        local v54 = u27 * v31;
        local AssemblyLinearVelocity2 = u22.AssemblyLinearVelocity;

        if u21.preserveVertical ~= false and (u21.plane or "xz") ~= "xyz" then
            u22.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity2.X + v54.X, AssemblyLinearVelocity2.Y, AssemblyLinearVelocity2.Z + v54.Z);
        else
            u22.AssemblyLinearVelocity = AssemblyLinearVelocity2 + v54;
        end;
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "PhysicsMotionAttach";
    Attachment.Orientation = Vector3.new(-90, 0, 0);
    Attachment.Parent = u22;
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Name = "PhysicsMotionLinearVel";
    LinearVelocity.MaxForce = MotionResolve.calcMaxForce(u22, u21.maxForceMultiplier);
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World;
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    LinearVelocity.Parent = Attachment;
    local v55 = u27 * v28;
    local v56 = v55 * (u21.endFactor or 0);
    LinearVelocity.VectorVelocity = v55;
    u39 = TweenService:Create(LinearVelocity, TweenInfo.new(duration, u21.easingStyle, u21.easingDirection), {
        VectorVelocity = v56
    });
    u39:Play();

    if v30 then
        u37 = RunService.Heartbeat:Connect(function() -- Line: 247
            -- upvalues: u34 (ref), u35 (ref), MotionRegistry (ref), u22 (copy), u25 (copy), u24 (copy), u37 (ref), u23 (copy), u38 (ref), u39 (ref), u36 (ref), u33 (copy), AssemblyLinearVelocity (copy), u21 (copy), u26 (copy), _suppressInwardVelocity (ref), u27 (copy)
            if u34 or (u35 or not MotionRegistry.isGenCurrent(u22, u25, u24)) then
                if u37 then
                    u37:Disconnect();
                    u37 = nil;
                end;

                return;
            end;

            if u23.Parent and u22.Parent then
                _suppressInwardVelocity(u22, u27, u21);

                return;
            end;

            if not u34 then
                if u35 then
                    return;
                end;

                u34 = true;

                if u38 then
                    task.cancel(u38);
                    u38 = nil;
                end;

                if u35 then
                    return;
                end;

                u35 = true;

                if u39 then
                    u39:Cancel();
                    u39 = nil;
                end;

                if u36 then
                    u36:Disconnect();
                    u36 = nil;
                end;

                if u37 then
                    u37:Disconnect();
                    u37 = nil;
                end;

                local PhysicsMotionAttach2 = u22:FindFirstChild("PhysicsMotionAttach");

                if PhysicsMotionAttach2 then
                    PhysicsMotionAttach2:Destroy();
                end;

                if u33 and u22.Parent then
                    local v57 = u22;
                    local v58 = AssemblyLinearVelocity;
                    local v59 = u21;

                    if v59.preserveVertical ~= false and (v59.plane or "xz") ~= "xyz" then
                        v57.AssemblyLinearVelocity = Vector3.new(v58.X, v57.AssemblyLinearVelocity.Y, v58.Z);
                    else
                        v57.AssemblyLinearVelocity = v58;
                    end;
                end;

                MotionRegistry.release(u22, u25, u24);

                if u26 then
                    u26("cancel");
                end;
            end;
        end);
    end;

    local u60 = u21.verticalDampDuration or 0;
    local u61 = u21.verticalDampFactor or 0.7;

    if u60 > 0 then
        local u62 = os.clock();
        u36 = RunService.Heartbeat:Connect(function() -- Line: 267
            -- upvalues: u34 (ref), u35 (ref), MotionRegistry (ref), u22 (copy), u25 (copy), u24 (copy), u36 (ref), u62 (copy), u60 (copy), u23 (copy), u38 (ref), u39 (ref), u37 (ref), u33 (copy), AssemblyLinearVelocity (copy), u21 (copy), u26 (copy), u61 (copy)
            if u34 or (u35 or not MotionRegistry.isGenCurrent(u22, u25, u24)) then
                if u36 then
                    u36:Disconnect();
                    u36 = nil;
                end;

                return;
            end;

            if u60 <= os.clock() - u62 then
                if u36 then
                    u36:Disconnect();
                    u36 = nil;
                end;

                return;
            end;

            if u23.Parent then
                for _, descendant in u23:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        local AssemblyLinearVelocity2 = descendant.AssemblyLinearVelocity;
                        descendant.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity2.X, AssemblyLinearVelocity2.Y * u61, AssemblyLinearVelocity2.Z);
                    end;
                end;

                return;
            end;

            if not u34 then
                if u35 then
                    return;
                end;

                u34 = true;

                if u38 then
                    task.cancel(u38);
                    u38 = nil;
                end;

                if u35 then
                    return;
                end;

                u35 = true;

                if u39 then
                    u39:Cancel();
                    u39 = nil;
                end;

                if u36 then
                    u36:Disconnect();
                    u36 = nil;
                end;

                if u37 then
                    u37:Disconnect();
                    u37 = nil;
                end;

                local PhysicsMotionAttach2 = u22:FindFirstChild("PhysicsMotionAttach");

                if PhysicsMotionAttach2 then
                    PhysicsMotionAttach2:Destroy();
                end;

                if u33 and u22.Parent then
                    local v63 = u22;
                    local v64 = AssemblyLinearVelocity;
                    local v65 = u21;

                    if v65.preserveVertical ~= false and (v65.plane or "xz") ~= "xyz" then
                        v63.AssemblyLinearVelocity = Vector3.new(v64.X, v63.AssemblyLinearVelocity.Y, v64.Z);
                    else
                        v63.AssemblyLinearVelocity = v64;
                    end;
                end;

                MotionRegistry.release(u22, u25, u24);

                if u26 then
                    u26("cancel");
                end;
            end;
        end);
    end;

    u38 = task.delay(duration, function() -- Line: 295
        -- upvalues: u34 (ref), MotionRegistry (ref), u22 (copy), u25 (copy), u24 (copy), Attachment (copy), Debris (ref), u35 (ref), u39 (ref), u36 (ref), u37 (ref), u32 (copy), AssemblyLinearVelocity (copy), u21 (copy), u26 (copy)
        if u34 or not MotionRegistry.isGenCurrent(u22, u25, u24) then
            return;
        end;

        if Attachment.Parent then
            Debris:AddItem(Attachment, 0);
        end;

        if u35 then
            return;
        end;

        u35 = true;

        if u39 then
            u39:Cancel();
            u39 = nil;
        end;

        if u36 then
            u36:Disconnect();
            u36 = nil;
        end;

        if u37 then
            u37:Disconnect();
            u37 = nil;
        end;

        local PhysicsMotionAttach2 = u22:FindFirstChild("PhysicsMotionAttach");

        if PhysicsMotionAttach2 then
            PhysicsMotionAttach2:Destroy();
        end;

        if u32 and u22.Parent then
            local v66 = u22;
            local v67 = AssemblyLinearVelocity;
            local v68 = u21;

            if v68.preserveVertical ~= false and (v68.plane or "xz") ~= "xyz" then
                v66.AssemblyLinearVelocity = Vector3.new(v67.X, v66.AssemblyLinearVelocity.Y, v67.Z);
            else
                v66.AssemblyLinearVelocity = v67;
            end;
        end;

        MotionRegistry.release(u22, u25, u24);

        if u26 then
            u26("complete");
        end;
    end);

    return cancel;
end;

return v1;