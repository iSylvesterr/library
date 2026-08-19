-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local PartConstants = require(script.Parent.PartConstants);
local Turbulence = require(script.Parent.Turbulence);
local DirectionVectors = PartConstants.DirectionVectors;

return function(p1) -- Line: 14
    -- upvalues: PartConstants (copy), Turbulence (copy), Graph (copy), DirectionVectors (copy)
    function p1.PreSimulateForward(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) -- Line: 20
        -- upvalues: PartConstants (ref), Turbulence (ref), Graph (ref), DirectionVectors (ref)
        local v12 = p3.LinkMode or "Follow";
        local v13;

        if p8 then
            v13 = PartConstants.resolveLinkCFrame(p8);

            if v12 == "Follow" or v12 == "Pivot" then
                v13 = CFrame.new(v13.Position);
            end;
        else
            v13 = CFrame.new();
        end;

        local v14;

        if v12 == "Weld" or (v12 == "WeldWithoutRotation" or v12 == "RigidLocal") then
            v14 = p8 ~= nil;
        else
            v14 = false;
        end;

        local v15 = math.max(1, p3.TotalKeyFrames);

        if not p10 or p10 >= v15 then
            p10 = p3.InvertMotion and v15 > 500 and 500 or v15;
        end;

        local v16 = p9 / p10;
        local Position = p5.Position;
        local v17 = v13:ToObjectSpace(p5);
        local EmissionDirection = p3.EmissionDirection;
        local v18 = p3.RotMode or "OverLife";
        local v19 = 0;
        local v20 = 0;
        local v21 = 0;
        local v22;

        if p3.AccelerationTowardsInstance == true and (p3.AccelTarget ~= nil and p3.AccelStrength ~= nil) then
            v22 = not p3.InvertMotion;
        else
            v22 = false;
        end;

        local v23 = nil;

        if v22 then
            local AccelTarget = p3.AccelTarget;

            if AccelTarget:IsA("Bone") then
                v23 = AccelTarget.TransformedWorldCFrame.Position;
            elseif AccelTarget:IsA("BasePart") then
                v23 = AccelTarget.Position;
            elseif AccelTarget:IsA("Attachment") then
                v23 = AccelTarget.WorldPosition;
            elseif AccelTarget:IsA("Model") then
                local success, result = pcall(AccelTarget.GetPivot, AccelTarget);

                if success and result then
                    v23 = result.Position;
                end;
            end;

            if not v23 then
                v22 = false;
            end;
        end;

        local v24 = Vector3.new(0, 0, 0);
        local v25 = p4.AccelStrength or {};
        local v26 = (p3.PosOffsetX ~= nil or p3.PosOffsetY ~= nil) and true or p3.PosOffsetZ ~= nil;
        local v27 = v14 and v13:ToObjectSpace(p5).Rotation or p5.Rotation;
        local v28 = Vector3.new(0, 0, 0);
        local v29 = Turbulence.isLive(p3.Turbulence);
        local v30;

        if v29 then
            p4.Turbulence = p4.Turbulence or Graph.GenerateSeed(v29);
            p4._turbSeed = p4._turbSeed or math.random() * 997 + 0.5;
            v30 = PartConstants.resolveDisplacement(Turbulence.sampleRaw(v29, p4.Turbulence, p4._turbSeed, p3.TurbulenceFrequency or 1, p9, 0), p3.DisplacementMode or "Global", v27, p11 or v27);
        else
            v30 = Vector3.new(0, 0, 0);
        end;

        local v31 = { v13:ToObjectSpace(p5) };

        for i = 1, p10 do
            local v32 = i / p10;
            local v33 = v32 * p9;
            local v34 = (p6 * (Graph.QueryPointsWithTime(v32, p3.Speed, p4.Speed) * math.exp(-p3.ParticleData.Drag * v33)) + p3.ParticleData.Acceleration * v33) * v16;

            if v22 then
                local v35 = v23 - Position;
                local Magnitude = v35.Magnitude;

                if Magnitude > 0.0001 then
                    local v36 = Graph.QueryPointsWithTime(v32, p3.AccelStrength, v25);

                    if v36 and v36 ~= 0 then
                        v24 = v24 + v35 * (v36 * v16 / Magnitude);
                        v34 = v34 + v24 * v16;
                    end;
                end;
            end;

            local v37, v38;

            if v26 then
                local v39 = p3.PosOffsetX and (Graph.QueryPointsWithTime(v32, p3.PosOffsetX, p4.PosOffsetX) or 0) or 0;
                local v40 = p3.PosOffsetY and (Graph.QueryPointsWithTime(v32, p3.PosOffsetY, p4.PosOffsetY) or 0) or 0;
                local v41 = p3.PosOffsetZ and (Graph.QueryPointsWithTime(v32, p3.PosOffsetZ, p4.PosOffsetZ) or 0) or 0;
                v37 = PartConstants.resolveDisplacement(Vector3.new(v39, v40, v41), p3.DisplacementMode or "Global", v27, p11 or v27);
                v38 = v37 - v28;
            else
                v37 = v28;
                v38 = Vector3.new(0, 0, 0);
            end;

            local v42;

            if v29 then
                v42 = PartConstants.resolveDisplacement(Turbulence.sampleRaw(v29, p4.Turbulence, p4._turbSeed, p3.TurbulenceFrequency or 1, p9, v32), p3.DisplacementMode or "Global", v27, p11 or v27);
                v38 = v38 + (v42 - v30);
            else
                v42 = v30;
            end;

            local v43;

            if v14 then
                v43 = (p3.DisplacementMode or "Global") == "Local";
            else
                v43 = v14;
            end;

            if v14 then
                v34 = v13:VectorToObjectSpace(v34) or v34;
            end;

            if v14 and not v43 then
                v38 = v13:VectorToObjectSpace(v38) or v38;
            end;

            v17 = CFrame.new(v34 + v38) * v17;
            local v44 = Graph.QueryPointsWithTime(v32, p3.RotSpeedX, p4.RotSpeedX);
            local v45 = Graph.QueryPointsWithTime(v32, p3.RotSpeedY, p4.RotSpeedY);
            local v46 = Graph.QueryPointsWithTime(v32, p3.RotSpeedZ, p4.RotSpeedZ);
            local v47 = p3.RotOrder or "Global";
            local v48;

            if v18 == "Speed" then
                v19 = v19 + v44 * v16;
                v20 = v20 + v45 * v16;
                v21 = v21 + v46 * v16;
                v48 = PartConstants.composeRotation(v47, v19, v20, v21);
            else
                v48 = PartConstants.composeRotation(v47, v44, v45, v46);
            end;

            local v49 = v13 * v17 * v48;
            Position = v49.Position;

            if p3.VelocityVectored then
                local v50 = DirectionVectors[EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
                p6 = (v49 * p7)[v50.vector] * v50.multiplier;
            end;

            v31[i] = v13:ToObjectSpace(v49);
            v28 = v37;
            v30 = v42;
        end;

        return v31, p10;
    end;

    function p1.PreSimulateAttachmentForward(p51, p52, p53, p54, p55, p56, p57, p58, p59) -- Line: 171
        -- upvalues: Turbulence (ref), Graph (ref), PartConstants (ref), DirectionVectors (ref)
        local v60 = math.max(1, p52.TotalKeyFrames);

        if not p58 or p58 >= v60 then
            p58 = p52.InvertMotion and v60 > 500 and 500 or v60;
        end;

        local v61 = p57 / p58;
        local EmissionDirection = p52.EmissionDirection;
        local v62 = p52.RotMode or "OverLife";
        local v63 = 0;
        local v64 = 0;
        local v65 = 0;
        local v66 = (p52.PosOffsetX ~= nil or p52.PosOffsetY ~= nil) and true or p52.PosOffsetZ ~= nil;
        local Rotation = p54.Rotation;
        local v67 = Vector3.new(0, 0, 0);
        local v68 = Turbulence.isLive(p52.Turbulence);
        local v69;

        if v68 then
            p53.Turbulence = p53.Turbulence or Graph.GenerateSeed(v68);
            p53._turbSeed = p53._turbSeed or math.random() * 997 + 0.5;
            v69 = PartConstants.resolveDisplacement(Turbulence.sampleRaw(v68, p53.Turbulence, p53._turbSeed, p52.TurbulenceFrequency or 1, p57, 0), p52.DisplacementMode or "Global", Rotation, p59 or Rotation);
        else
            v69 = Vector3.new(0, 0, 0);
        end;

        local v70 = { p54 };

        for i = 1, p58 do
            local v71 = i / p58;
            local v72 = v71 * p57;
            local v73 = (p55 * (Graph.QueryPointsWithTime(v71, p52.Speed, p53.Speed) * math.exp(-p52.ParticleData.Drag * v72)) + p52.ParticleData.Acceleration * v72) * v61;
            local v74;

            if v66 then
                local v75 = p52.PosOffsetX and (Graph.QueryPointsWithTime(v71, p52.PosOffsetX, p53.PosOffsetX) or 0) or 0;
                local v76 = p52.PosOffsetY and (Graph.QueryPointsWithTime(v71, p52.PosOffsetY, p53.PosOffsetY) or 0) or 0;
                local v77 = p52.PosOffsetZ and (Graph.QueryPointsWithTime(v71, p52.PosOffsetZ, p53.PosOffsetZ) or 0) or 0;
                v74 = PartConstants.resolveDisplacement(Vector3.new(v75, v76, v77), p52.DisplacementMode or "Global", Rotation, p59 or Rotation);
                v73 = v73 + (v74 - v67);
            else
                v74 = v67;
            end;

            local v78;

            if v68 then
                v78 = PartConstants.resolveDisplacement(Turbulence.sampleRaw(v68, p53.Turbulence, p53._turbSeed, p52.TurbulenceFrequency or 1, p57, v71), p52.DisplacementMode or "Global", Rotation, p59 or Rotation);
                v73 = v73 + (v78 - v69);
            else
                v78 = v69;
            end;

            p54 = CFrame.new(v73) * p54;
            local v79 = Graph.QueryPointsWithTime(v71, p52.RotSpeedX, p53.RotSpeedX);
            local v80 = Graph.QueryPointsWithTime(v71, p52.RotSpeedY, p53.RotSpeedY);
            local v81 = Graph.QueryPointsWithTime(v71, p52.RotSpeedZ, p53.RotSpeedZ);
            local v82 = p52.RotOrder or "Global";
            local v83;

            if v62 == "Speed" then
                v63 = v63 + v79 * v61;
                v64 = v64 + v80 * v61;
                v65 = v65 + v81 * v61;
                v83 = PartConstants.composeRotation(v82, v63, v64, v65);
            else
                v83 = PartConstants.composeRotation(v82, v79, v80, v81);
            end;

            local v84 = p54 * v83;

            if p52.VelocityVectored then
                local v85 = DirectionVectors[EmissionDirection] or DirectionVectors[Enum.NormalId.Top];
                p55 = (v84 * p56)[v85.vector] * v85.multiplier;
            end;

            v70[i] = v84;
            v67 = v74;
            v69 = v78;
        end;

        return v70, p58;
    end;
end;