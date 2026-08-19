-- Decompiled with Potassium's decompiler.

local u60 = {
    resolveLinkCFrame = function(p1) -- Line: 11, Name: resolveLinkCFrame
        if p1:IsA("Attachment") then
            return p1.WorldCFrame;
        end;

        if p1:IsA("Model") then
            return p1:GetPivot();
        end;

        if p1:IsA("Bone") then
            return p1.TransformedWorldCFrame;
        end;

        return p1.CFrame;
    end,

    getParentScaleFactor = function(p2, p3, p4, p5) -- Line: 24, Name: getParentScaleFactor
        local v6 = 1;

        while p2 do
            local v7 = true;

            if p5 == "motion" then
                v7 = p2.ScaleMotion ~= false;
            elseif p5 == "rotation" then
                v7 = p2.ScaleRotation == true;
            end;

            if v7 then
                local v8;

                if p2.StaticValue then
                    v8 = math.max(0.001, p2.StaticValue);
                else
                    local v9 = math.clamp((p3 - p2.StartTime) / p2.LifeTime, 0, 1);
                    v8 = math.max(0.001, p4.QueryPointsWithTime(v9, p2.Graph, p2.Seed));
                end;

                v6 = v6 * v8;
            end;

            p2 = p2.Parent;
        end;

        return v6;
    end,

    composeRotation = function(p10, p11, p12, p13) -- Line: 51, Name: composeRotation
        local v14 = CFrame.Angles(math.rad(p11), 0, 0);
        local v15 = CFrame.Angles(0, math.rad(p12), 0);
        local v16 = CFrame.Angles(0, 0, (math.rad(p13)));

        if p10 == "LocalXYZ" then
            return v14 * v15 * v16;
        end;

        if p10 == "LocalXZY" then
            return v14 * v16 * v15;
        end;

        if p10 == "LocalYXZ" then
            return v15 * v14 * v16;
        end;

        if p10 == "LocalYZX" then
            return v15 * v16 * v14;
        end;

        if p10 == "LocalZXY" then
            return v16 * v14 * v15;
        end;

        if p10 == "LocalZYX" then
            return v16 * v15 * v14;
        end;

        return v15 * v14 * v16;
    end,

    DirectionVectors = {
        [Enum.NormalId.Top] = {
            vector = "UpVector",
            multiplier = 1
        },
        [Enum.NormalId.Bottom] = {
            vector = "UpVector",
            multiplier = -1
        },
        [Enum.NormalId.Front] = {
            vector = "LookVector",
            multiplier = 1
        },
        [Enum.NormalId.Back] = {
            vector = "LookVector",
            multiplier = -1
        },
        [Enum.NormalId.Left] = {
            vector = "RightVector",
            multiplier = -1
        },
        [Enum.NormalId.Right] = {
            vector = "RightVector",
            multiplier = 1
        }
    },
    shapeFunctions = {
        [Enum.ParticleEmitterShape.Box] = function(p17, p18) -- Line: 76
            local v19 = (math.random() * 2 - 1) * p17.Size.X / 2;
            local v20 = (math.random() * 2 - 1) * p17.Size.Y / 2;
            local v21 = (math.random() * 2 - 1) * p17.Size.Z / 2;
            local v22 = Vector3.new(v19, v20, v21);
            local v23 = v22.Magnitude > 0.0001 and (v22.Unit or Vector3.new(0, 1, 0)) or Vector3.new(0, 1, 0);

            return v22, v22.Magnitude > 0.0001 and CFrame.lookAt(Vector3.new(), -v23) or CFrame.new(), v23;
        end,

        [Enum.ParticleEmitterShape.Sphere] = function(p24, p25) -- Line: 86
            local v26 = p24.Size.X / 2;
            local v27 = v26 * p25.ShapePartial;
            local v28 = (math.random() * (v26 ^ 3 - v27 ^ 3) + v27 ^ 3) ^ 0.3333333333333333;
            local v29 = math.random() * 2 * 3.141592653589793;
            local v30 = math.random() * 2 - 1;
            local v31 = math.acos(v30);
            local v32 = math.sin(v31) * math.cos(v29);
            local v33 = math.sin(v31) * math.sin(v29);
            local v34 = math.cos(v31);
            local v35 = Vector3.new(v32, v33, v34);

            return v35 * v28, CFrame.lookAt(Vector3.new(), -v35), v35;
        end,

        [Enum.ParticleEmitterShape.Cylinder] = function(p36, p37) -- Line: 99
            local v38 = p36.Size.X / 2;
            local Y = p36.Size.Y;
            local v39 = math.clamp(p37.ShapePartial, 0, 1);
            local v40 = math.random() * (1 - v39 * v39) + v39 * v39;
            local v41 = math.sqrt(v40);
            local v42 = math.random() * 2 * 3.141592653589793;
            local v43 = v41 * v38 * math.cos(v42);
            local v44 = (math.random() * 2 - 1) * (Y / 2);
            local v45 = v41 * v38 * math.sin(v42);
            local v46 = Vector3.new(v43, v44, v45);
            local v47;

            if math.abs(v44) > Y / 2 - 0.01 then
                local v48 = math.sign(v44);
                v47 = Vector3.new(0, v48, 0);
            else
                local v49 = Vector3.new(v43, 0, v45);
                v47 = v49.Magnitude < 0.0001 and Vector3.new(0, 1, 0) or v49.Unit;
            end;

            return v46, CFrame.lookAt(Vector3.new(), -v47), v47;
        end,

        [Enum.ParticleEmitterShape.Disc] = function(p50, p51) -- Line: 123
            local v52 = p50.Size.X / 2;
            local v53 = math.clamp(p51.ShapePartial, 0, 1);
            local v54 = math.random() * (1 - v53 * v53) + v53 * v53;
            local v55 = math.sqrt(v54);
            local v56 = math.random() * 2 * 3.141592653589793;
            local v57 = v55 * v52 * math.cos(v56);
            local v58 = v55 * v52 * math.sin(v56);
            local v59 = Vector3.new(v57, 0, v58);

            if v59.Magnitude < 0.0001 then
                return v59, CFrame.new(), Vector3.new(0, 1, 0);
            end;

            local Unit = v59.Unit;

            return v59, CFrame.lookAt(Vector3.new(), -Unit), Unit;
        end
    }
};

function u60.applyPositionOffset(p61, p62, p63, p64, p65, p66, p67, p68, p69) -- Line: 144
    -- upvalues: u60 (copy)
    local v70, v71, v72;

    if p66 and p62.AxisLinks then
        local v73 = p66.sampleRangeAxes(p62, p62.AxisLinks, { "PosX", "PosY", "PosZ" }, p65, p67);
        v70 = v73.PosX;
        v71 = v73.PosY;
        v72 = v73.PosZ;
    else
        v70 = p65.RandomValueFromRange(p62.PosX or NumberRange.new(0));
        v71 = p65.RandomValueFromRange(p62.PosY or NumberRange.new(0));
        v72 = p65.RandomValueFromRange(p62.PosZ or NumberRange.new(0));
    end;

    if p69 and p69 ~= 1 then
        v70 = v70 * p69;
        v71 = v71 * p69;
        v72 = v72 * p69;
    end;

    if v70 == 0 and (v71 == 0 and v72 == 0) then
        return p61;
    end;

    local v74 = p62.PosMode or "Local";

    if v74 == "Local" then
        return p61 * CFrame.new(v70, v71, v72);
    end;

    local v75 = Vector3.new(v70, v71, v72);

    if v74 ~= "Global" then
        local v76;

        if p63 then
            v76 = u60.resolveLinkCFrame(p63);
        elseif p64:IsA("Attachment") then
            v76 = p64.WorldCFrame;
        elseif p64:IsA("Model") then
            v76 = p64:GetPivot();
        else
            v76 = p64.CFrame;
        end;

        v75 = v76:VectorToWorldSpace(v75);
    end;

    if p68 then
        v75 = p68:VectorToObjectSpace(v75) or v75;
    end;

    return CFrame.new(p61.Position + v75) * p61.Rotation;
end;

function u60.resolveDisplacement(p77, p78, p79, p80, p81, p82, p83) -- Line: 203
    if p78 ~= "Global" then
        if p78 == "RigidLocal" then
            p77 = p80:VectorToWorldSpace(p77);
        else
            p77 = p79:VectorToWorldSpace(p77);
        end;
    end;

    if p81 then
        return p81 * p77.X + p82 * p77.Y + p83 * p77.Z;
    end;

    return p77;
end;

function u60.applyContactAccel(p84, p85, p86) -- Line: 225
    if not (p85._settleEngaged and p85._lastHitNormal) then
        return p84;
    end;

    local _lastHitNormal = p85._lastHitNormal;

    if _lastHitNormal.Magnitude < 0.0001 then
        return p84;
    end;

    local v87 = p84:Dot(_lastHitNormal);

    if v87 >= 0 then
        return p84;
    end;

    if math.abs(v87) < 10 then
        return p84;
    end;

    local v88 = p84 - v87 * _lastHitNormal;
    local v89 = p85.Events and p85.Events.OnHit and (p85.Events.OnHit.Friction or 0.2) or 0.2;
    local v90;

    if p85._accelVel then
        local _accelVel = p85._accelVel;
        v90 = _accelVel - _accelVel:Dot(_lastHitNormal) * _lastHitNormal;
    else
        v90 = Vector3.new(0, 0, 0);
    end;

    local Magnitude = v90.Magnitude;
    local v91 = v89 * math.abs(v87);

    if Magnitude <= 0.0001 then
        return v88.Magnitude <= v91 and Vector3.new(0, 0, 0) or v88 - v88.Unit * v91;
    end;

    local v92 = -v90.Unit * v91;

    if Magnitude < v91 * (p86 or 0.016666666666666666) then
        v92 = -v90 / (p86 or 0.016666666666666666);
    end;

    return v88 + v92;
end;

return u60;