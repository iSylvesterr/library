-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local PartConstants = require(script.Parent.PartConstants);
local StaticPass = require(script.Parent.StaticPass);
local AxisLinks = require(script.Parent.AxisLinks);
local NestedEmit = require(script.Parent.NestedEmit);
local Turbulence = require(script.Parent.Turbulence);

return function(p1) -- Line: 17
    -- upvalues: Graph (copy), PartConstants (copy), Turbulence (copy), Range (copy), StaticPass (copy), AxisLinks (copy), NestedEmit (copy)
    function p1._replayAnimateCycle(u2, u3, p4) -- Line: 21
        -- upvalues: Graph (ref), PartConstants (ref), Turbulence (ref), Range (ref), StaticPass (ref), AxisLinks (ref), NestedEmit (ref)
        u3.StartTime = p4;
        u3.CurrentStep = 0;

        if u3.AccumulatedDT then
            u3.AccumulatedDT = 0;
        end;

        if u3.InitialLocalCF then
            u3.LocalCF = u3.InitialLocalCF;
        end;

        if u3.AccRotX then
            u3.AccRotX = 0;
            u3.AccRotY = 0;
            u3.AccRotZ = 0;
        end;

        if u3.TargetVel then
            u3.TargetVel = Vector3.new(0, 0, 0);
        end;

        u3._collisionStopped = false;
        u3._spinRate = Vector3.new(0, 0, 0);
        u3._spinAccumX = 0;
        u3._spinAccumY = 0;
        u3._spinAccumZ = 0;
        u3.SpeedMultiplier = 1;

        if u3._accelVel then
            u3._accelVel = Vector3.new(0, 0, 0);
        end;

        if u3._prevWorldOff then
            u3._prevWorldOff = Vector3.new(0, 0, 0);
            u3._displacementMirrorX = nil;
            u3._displacementMirrorY = nil;
            u3._displacementMirrorZ = nil;

            if u3.HasPosOffsetGraphs and (u3.Graphs and u3.SpawnRotation) then
                local v5 = u3.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(0, u3.Graphs.PosOffsetX, u3.Seeds.PosOffsetX) or 0) or 0;
                local v6 = u3.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(0, u3.Graphs.PosOffsetY, u3.Seeds.PosOffsetY) or 0) or 0;
                local v7 = u3.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(0, u3.Graphs.PosOffsetZ, u3.Seeds.PosOffsetZ) or 0) or 0;

                if v5 ~= 0 or (v6 ~= 0 or v7 ~= 0) then
                    local u8 = PartConstants.resolveDisplacement(Vector3.new(v5, v6, v7), u3.DisplacementMode or "Global", u3.SpawnRotation, u3.SpawnEmitterRotation);
                    u3._prevWorldOff = u8;
                    u3.LocalCF = u3.LocalCF + u8;

                    if u3.VisualPart and u3.VisualPart.Parent then
                        if u3.Type == "Model" then
                            pcall(function() -- Line: 62
                                -- upvalues: u3 (copy), u8 (copy)
                                u3.VisualPart:PivotTo(u3.VisualPart:GetPivot() + u8);
                            end);
                        else
                            u3.VisualPart.CFrame = u3.VisualPart.CFrame + u8;
                        end;
                    end;
                end;
            end;
        end;

        Turbulence.reprime(u3);

        if u3._initialBaseDirection then
            u3.BaseDirection = u3._initialBaseDirection;
        end;

        u3._lastOrientPos = nil;
        local InitialLocalCF = u3.InitialLocalCF;
        u3._localWorldCF = u3.InitialLocalCF;
        u3._postUpdateCF = InitialLocalCF;
        u3._lastTransIdx = nil;
        u3._lastColorIdx = nil;
        u3._effectiveElapsed = Graph.InitialEffectiveElapsed(u3.Graphs and u3.Graphs.Timescale, u3.Seeds and u3.Seeds.Timescale, u3.LifeTime);
        u3._hitHistory = nil;

        if u3.Type == "ImageLabel" then
            u3.PosX = 0;
            u3.PosY = 0;
            u3.EnvVelX = 0;
            u3.EnvVelY = 0;
            u3.AccRot = 0;
        end;

        local u9 = u2:GetData(u3.AnimateItem);

        if u9 then
            u3.Events = u9.Events;
            u3._killedManually = false;
            u3._fireOnDeathOverride = false;
            u3._hitFired = false;
            u3.LifeTime = Range.RandomValueFromRange(u9.Lifetime);

            if u3.LifeTime <= 0 then
                u3.LifeTime = 0.001;
            end;

            u3.TotalKeyFrames = math.max(1, u9.TotalKeyFrames);

            if u9.ParticleData then
                u3.Acceleration = u9.ParticleData.Acceleration;
                u3.Drag = u9.ParticleData.Drag;
                u3.HasDrag = u9.ParticleData.Drag ~= 0;
                u3.HasAccel = u9.ParticleData.Acceleration.Magnitude > 0;
            end;

            u3.InvertMotion = u9.InvertMotion or false;
            u3.AccelTarget = u9.AccelTarget;
            local v10;

            if u9.AccelerationTowardsInstance == true and (u9.AccelTarget ~= nil and u9.AccelStrength ~= nil) then
                v10 = not u3.InvertMotion;
            else
                v10 = false;
            end;

            u3.HasTargetAccel = v10;
            u3.TargetVel = Vector3.new(0, 0, 0);

            if u9.VelocityVectored ~= nil then
                u3.VelocityVectored = u9.VelocityVectored;
            end;

            u3.NeedsFullIteration = u3.VelocityVectored or false;

            if u9.RotMode then
                u3.RotMode = u9.RotMode;
                local v11;

                if u9.RotMode == "Speed" then
                    v11 = not u3.VelocityVectored and true or false;
                else
                    v11 = false;
                end;

                u3.NeedsRotAccum = v11;
            end;

            u3.Link = u9.Link;
            u3.LinkMode = u9.LinkMode;

            if u3.LinkMode == "RigidLocal" and (u3.Link and u3.Link.Parent) then
                u3._rigidLocalParentCF = PartConstants.resolveLinkCFrame(u3.Link);
            end;

            if u3.Type == "ImageLabel" then
                u2:_refreshImageLabelAnimateNonSpatial(u3, u9);
            elseif u3.Type == "Lightning" then
                u2:_refreshLightningAnimate(u3, u9);
            elseif u3.Type == "CameraShake" then
                u2:_refreshCameraShakeAnimate(u3, u9);
            elseif u3.Type == "Rocks" then
                u2:_refreshRocksAnimate(u3, u9);
            elseif u3.Type == "Rope" then
                u2:_refreshRopeAnimate(u3, u9);
            else
                u2:_refreshAnimateNonSpatial(u3, u9);
            end;

            StaticPass.restoreFromFreshData(u3, u9);
            AxisLinks.refreshLoopGraphsAndSeeds(u3, u9, Graph);

            if u3.Type == "Part" or (u3.Type == "Attachment" or u3.Type == "Model") then
                Turbulence.buildInto(u3, u9);
            end;

            StaticPass.apply(u3);

            if u3.Type == "ImageLabel" and (u3._staticSizeScaleX and u3._staticSizeScaleY) then
                u3._staticSizeScaleX = nil;
                u3._staticSizeScaleY = nil;
            end;

            u3._effectiveElapsed = Graph.InitialEffectiveElapsed(u3.Graphs and u3.Graphs.Timescale, u3.Seeds and u3.Seeds.Timescale, u3.LifeTime);

            if u3.Type == "ImageLabel" then
                u3.InvertMotion = u9.ImgInvertMotion or false;

                if u3.InvertMotion then
                    local v12, v13, v14, v15 = u2:_computeImageLabelEndState(u9, u3.DirX or 0, u3.DirY or 0, u3.LifeTime, u3.Seeds);
                    u3.PosX = v12;
                    u3.PosY = v13;
                    u3.EnvVelX = v14;
                    u3.EnvVelY = v15;
                    u3._effectiveElapsed = u3.LifeTime;
                    u3._invertDtSign = -1;
                else
                    u3._invertDtSign = nil;
                end;
            end;

            if u3.InvertMotion and (u3.AnimateItem and u3.AnimateItem.Parent) then
                local v16 = nil;
                local u17 = u3.Type == "Attachment";
                local u18;

                if u3.Type == "Model" then
                    local v19;
                    v19, u18 = pcall(function() -- Line: 192
                        -- upvalues: u3 (copy)
                        return u3.AnimateItem:GetPivot();
                    end);

                    if not v19 then
                        u18 = v16;
                    end;
                elseif u17 then
                    u18 = u3.AnimateItem.CFrame;
                elseif u3.AnimateItem:IsA("BasePart") then
                    u18 = u3.AnimateItem.CFrame;
                else
                    u18 = v16;
                end;

                if u18 then
                    local v20, v21, v22 = pcall(function() -- Line: 201
                        -- upvalues: u17 (copy), u2 (copy), u9 (copy), u3 (copy), u18 (ref)
                        if u17 then
                            return u2:PreSimulateAttachmentForward(u9, u3.Seeds, u18, u3.BaseDirection, u3.SpreadRotation, u3.LifeTime, nil, u3.SpawnEmitterRotation);
                        end;

                        return u2:PreSimulateForward(u9, u3.Seeds, u18, u3.BaseDirection, u3.SpreadRotation, u3.Link, u3.LifeTime, nil, u3.SpawnEmitterRotation);
                    end);

                    if v20 then
                        u3.SimLocalCFrames = v21;

                        if v22 then
                            u3.TotalKeyFrames = v22;
                        end;
                    end;
                end;
            elseif not u3.InvertMotion then
                u3.SimLocalCFrames = nil;
            end;

            if u3.Type == "Beam" and u9.BeamProps then
                local VisualPart = u3.VisualPart;
                local v23 = {};

                for i, v in pairs(u9.BeamProps) do
                    if v then
                        if Graph.IsStatic(v) then
                            if VisualPart then
                                VisualPart[i] = Graph.GetStaticValue(v, VisualPart[i]);
                            end;
                        else
                            v23[i] = {
                                Sequence = v,
                                Seed = Graph.GenerateSeed(v)
                            };
                        end;
                    end;
                end;

                u3.AnimatedProps = v23;

                if VisualPart then
                    u3._baseWidth0 = VisualPart.Width0;
                    u3._baseWidth1 = VisualPart.Width1;
                    u3._baseCurveSize0 = VisualPart.CurveSize0;
                    u3._baseCurveSize1 = VisualPart.CurveSize1;
                    u3._baseTextureLength = VisualPart.TextureLength;
                    u3._baseSegments = VisualPart.Segments;
                end;

                if v23.TextureSpeed and VisualPart then
                    VisualPart.TextureSpeed = 0;
                end;

                if u9.GraphBlender then
                    local v24, v25 = Graph.CollectGraphStates(u9.GraphBlender);
                    u3.TransStates = v24;
                    u3.ColorStates = v25;
                    local v26 = {};

                    for i = 1, #v24 - 1 do
                        v26[i] = Graph.PrecomputeMergedTimes(v24[i].Graph, v24[i + 1].Graph);
                    end;

                    local v27 = {};

                    for i = 1, #v25 - 1 do
                        v27[i] = Graph.PrecomputeMergedColorTimes(v25[i].Graph, v25[i + 1].Graph);
                    end;

                    u3.TransMergedTimes = v26;
                    u3.ColorMergedTimes = v27;

                    if #v24 > 0 and VisualPart then
                        VisualPart.Transparency = v24[1].Graph;
                    end;

                    if #v25 > 0 and VisualPart then
                        VisualPart.Color = v25[1].Graph;
                    end;
                end;
            end;

            if u9.PLRange then
                u3.PLRange = u9.PLRange;
            end;

            if u9.PLBrightness then
                u3.PLBrightness = u9.PLBrightness;
            end;

            if u9.PLColor then
                u3.PLColor = u9.PLColor;
            end;
        end;

        if u3.Type ~= "Lightning" and (u3.Type ~= "Rocks" and (u3.Type ~= "CameraShake" and (u3.Type ~= "Rope" and (u3.AnimateItem and (u3.AnimateItem.Parent and (u3.VisualPart and u3.VisualPart.Parent)))))) then
            if u3.Type == "Model" then
                local success, result = pcall(function() -- Line: 262
                    -- upvalues: u3 (copy)
                    return u3.AnimateItem:GetPivot();
                end);

                if success and result then
                    u3.VisualPart:PivotTo(result);
                end;
            elseif u3.AnimateItem:IsA("BasePart") then
                u3.VisualPart.CFrame = u3.AnimateItem.CFrame;
            elseif u3.AnimateItem:IsA("Attachment") then
                u3.VisualPart.CFrame = CFrame.new();
            end;
        end;

        if u3.AnimateItem and (u3.VisualPart and u3.VisualPart.Parent) then
            if u3.Type == "Lightning" or (u3.Type == "Rocks" or u3.Type == "Rope") then
                local v28 = u2:GetData(u3.AnimateItem);

                if v28 and v28.RenderTemplate then
                    NestedEmit.walk(u2, v28.RenderTemplate, u3.VisualPart, u3._nestedAlive, nil);
                end;
            else
                for _, descendant in u3.VisualPart:GetDescendants() do
                    if descendant:GetAttribute("Transformed") then
                        u2:EnableEmit(descendant, descendant.Parent);
                    end;
                end;
            end;
        end;

        u2:_fireAnimateCycleRestartEvents(u3);
    end;
end;