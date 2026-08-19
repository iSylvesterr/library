-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
require(script.Parent.Particles);
local AxisLinks = require(script.Parent.AxisLinks);
local Events = require(script.Parent.Events);
local EventsCollision = require(script.Parent.EventsCollision);
local Pool = require(script.Parent.Pool);
local PartConstants = require(script.Parent.PartConstants);
local StaticPass = require(script.Parent.StaticPass);

return function(p1) -- Line: 22
    -- upvalues: RunService (copy), UserInputService (copy), Events (copy), Pool (copy), EventsCollision (copy), Graph (copy), PartConstants (copy), Range (copy), StaticPass (copy), AxisLinks (copy)
    function p1.Activate(u2) -- Line: 25
        -- upvalues: RunService (ref), UserInputService (ref), Events (ref), Pool (ref), EventsCollision (ref), Graph (ref), PartConstants (ref), Range (ref), StaticPass (ref), AxisLinks (ref)
        if u2.Connection then
            return;
        end;

        u2._engineGen = (u2._engineGen or 0) + 1;
        u2._notActivatedWarned = false;

        if RunService:IsClient() then
            if not u2._focusConn then
                u2._focusConn = UserInputService.WindowFocused:Connect(function() -- Line: 38
                    -- upvalues: u2 (copy)
                    u2._focused = true;
                    u2._unfocusedAt = 0;
                end);
            end;

            if not u2._blurConn then
                u2._blurConn = UserInputService.WindowFocusReleased:Connect(function() -- Line: 44
                    -- upvalues: u2 (copy)
                    u2._focused = false;
                    u2._unfocusedAt = os.clock();
                end);
            end;
        end;

        for _, v in ipairs({
            workspace,
            game:GetService("Lighting"),
            game:GetService("ReplicatedStorage"),
            game:GetService("StarterGui"),
            game:GetService("StarterPack"),
            game:GetService("ReplicatedFirst")
        }) do
            pcall(function() -- Line: 60
                -- upvalues: u2 (copy), v (copy)
                u2:Preload(v, false);
            end);
        end;

        u2.Connection = RunService.Heartbeat:Connect(function(p3) -- Line: 63
            -- upvalues: Events (ref), Pool (ref), u2 (copy), EventsCollision (ref), Graph (ref), PartConstants (ref), Range (ref), StaticPass (ref), AxisLinks (ref)
            Events.tickFrame();
            local v4 = os.clock();
            Pool.tick(v4);
            local ActiveEmits = u2.ActiveEmits;

            if #ActiveEmits == 0 then
                return;
            end;

            local CurrentCamera = workspace.CurrentCamera;
            local v5;

            if CurrentCamera then
                v5 = CurrentCamera.CFrame.Position;
            else
                v5 = nil;
            end;

            local v6 = 1;

            while v6 <= #ActiveEmits do
                local u7 = ActiveEmits[v6];
                local v8 = u7._forceDead == true;
                local CurrentStep = u7.CurrentStep;

                if not v8 then
                    if u7.Type == "Part" then
                        v8 = u2:UpdatePart(u7, p3, v4);
                    elseif u7.Type == "Beam" then
                        v8 = u2:UpdateBeam(u7, p3, v4);
                    elseif u7.Type == "PointLight" then
                        v8 = u2:UpdatePointLight(u7, p3, v4);
                    elseif u7.Type == "Highlight" then
                        v8 = u2:UpdateHighlight(u7, p3, v4);
                    elseif u7.Type == "TrailEmitter" then
                        v8 = u2:UpdateTrail(u7, p3, v4);
                    elseif u7.Type == "Attachment" then
                        v8 = u2:UpdateAttachment(u7, p3, v4);
                    elseif u7.Type == "Model" then
                        v8 = u2:UpdateModel(u7, p3, v4);
                    elseif u7.Type == "Screen" then
                        v8 = u2:UpdateScreen(u7, p3, v4);
                    elseif u7.Type == "ImageLabel" then
                        v8 = u2:UpdateImageLabel(u7, p3, v4);
                    end;
                end;

                if not v8 then
                    if u7.Link then
                        u2:ReapplyLink(u7);
                    end;

                    local Type = u7.Type;

                    if u7._settleEngaged and (not u7._collisionStopped and (Type == "Part" or (Type == "Model" or Type == "Attachment"))) then
                        EventsCollision.applySettle(u7, p3);
                    end;

                    if (Type == "Part" or (Type == "Model" or Type == "Attachment")) and (u7.Link or u7.CurrentStep ~= CurrentStep) then
                        u7._postUpdateCF = Type == "Model" and u7.VisualPart:GetPivot() or u7.VisualPart.CFrame;
                    end;

                    if u7.Orientation and u7.Orientation ~= "None" then
                        u2:ApplyOrientation(u7, p3, v5);
                    end;

                    if u7.ZOffset and u7.ZOffset ~= 0 then
                        u2:ApplyZOffset(u7, v5);
                    end;
                end;

                Events.afterUpdate(u2, u7, v8, v4);

                if v8 then
                    u2:_fireOnDeath(u7);

                    if u7.IsAnimate then
                        if u7.AnimateItem and (u7.AnimateItem.Parent and u7.AnimateItem:GetAttribute("AnimateLoop")) then
                            u7.StartTime = v4;
                            u7.CurrentStep = 0;

                            if u7.AccumulatedDT then
                                u7.AccumulatedDT = 0;
                            end;

                            if u7.InitialLocalCF then
                                u7.LocalCF = u7.InitialLocalCF;
                            end;

                            if u7.AccRotX then
                                u7.AccRotX = 0;
                                u7.AccRotY = 0;
                                u7.AccRotZ = 0;
                            end;

                            if u7.TargetVel then
                                u7.TargetVel = Vector3.new(0, 0, 0);
                            end;

                            u7._collisionStopped = false;
                            u7._spinRate = Vector3.new(0, 0, 0);
                            u7._spinAccumX = 0;
                            u7._spinAccumY = 0;
                            u7._spinAccumZ = 0;
                            u7.SpeedMultiplier = 1;

                            if u7._accelVel then
                                u7._accelVel = Vector3.new(0, 0, 0);
                            end;

                            if u7._prevWorldOff then
                                u7._prevWorldOff = Vector3.new(0, 0, 0);
                                u7._displacementMirrorX = nil;
                                u7._displacementMirrorY = nil;
                                u7._displacementMirrorZ = nil;

                                if u7.HasPosOffsetGraphs and (u7.Graphs and u7.SpawnRotation) then
                                    local v9 = u7.Graphs.PosOffsetX and (Graph.QueryPointsWithTime(0, u7.Graphs.PosOffsetX, u7.Seeds.PosOffsetX) or 0) or 0;
                                    local v10 = u7.Graphs.PosOffsetY and (Graph.QueryPointsWithTime(0, u7.Graphs.PosOffsetY, u7.Seeds.PosOffsetY) or 0) or 0;
                                    local v11 = u7.Graphs.PosOffsetZ and (Graph.QueryPointsWithTime(0, u7.Graphs.PosOffsetZ, u7.Seeds.PosOffsetZ) or 0) or 0;

                                    if v9 ~= 0 or (v10 ~= 0 or v11 ~= 0) then
                                        local u12 = PartConstants.resolveDisplacement(Vector3.new(v9, v10, v11), u7.DisplacementMode or "Global", u7.SpawnRotation, u7.SpawnEmitterRotation);
                                        u7._prevWorldOff = u12;
                                        u7.LocalCF = u7.LocalCF + u12;

                                        if u7.VisualPart and u7.VisualPart.Parent then
                                            if u7.Type == "Model" then
                                                pcall(function() -- Line: 179
                                                    -- upvalues: u7 (copy), u12 (copy)
                                                    u7.VisualPart:PivotTo(u7.VisualPart:GetPivot() + u12);
                                                end);
                                            else
                                                u7.VisualPart.CFrame = u7.VisualPart.CFrame + u12;
                                            end;
                                        end;
                                    end;
                                end;
                            end;

                            if u7._initialBaseDirection then
                                u7.BaseDirection = u7._initialBaseDirection;
                            end;

                            u7._lastOrientPos = nil;
                            local InitialLocalCF = u7.InitialLocalCF;
                            u7._localWorldCF = u7.InitialLocalCF;
                            u7._postUpdateCF = InitialLocalCF;
                            u7._lastTransIdx = nil;
                            u7._lastColorIdx = nil;
                            u7._effectiveElapsed = Graph.InitialEffectiveElapsed(u7.Graphs and u7.Graphs.Timescale, u7.Seeds and u7.Seeds.Timescale, u7.LifeTime);
                            u7._hitHistory = nil;

                            if u7.Type == "ImageLabel" then
                                u7.PosX = 0;
                                u7.PosY = 0;
                                u7.EnvVelX = 0;
                                u7.EnvVelY = 0;
                                u7.AccRot = 0;
                            end;

                            local u13 = u2:GetData(u7.AnimateItem);

                            if u13 then
                                u7.Events = u13.Events;
                                u7._killedManually = false;
                                u7._fireOnDeathOverride = false;
                                u7._hitFired = false;
                                u7.LifeTime = Range.RandomValueFromRange(u13.Lifetime);

                                if u7.LifeTime <= 0 then
                                    u7.LifeTime = 0.001;
                                end;

                                u7.TotalKeyFrames = math.max(1, u13.TotalKeyFrames);

                                if u13.ParticleData then
                                    u7.Acceleration = u13.ParticleData.Acceleration;
                                    u7.Drag = u13.ParticleData.Drag;
                                    u7.HasDrag = u13.ParticleData.Drag ~= 0;
                                    u7.HasAccel = u13.ParticleData.Acceleration.Magnitude > 0;
                                end;

                                u7.InvertMotion = u13.InvertMotion or false;
                                u7.AccelTarget = u13.AccelTarget;
                                local v14;

                                if u13.AccelerationTowardsInstance == true and (u13.AccelTarget ~= nil and u13.AccelStrength ~= nil) then
                                    v14 = not u7.InvertMotion;
                                else
                                    v14 = false;
                                end;

                                u7.HasTargetAccel = v14;
                                u7.TargetVel = Vector3.new(0, 0, 0);

                                if u13.VelocityVectored ~= nil then
                                    u7.VelocityVectored = u13.VelocityVectored;
                                end;

                                u7.NeedsFullIteration = u7.VelocityVectored or false;

                                if u13.RotMode then
                                    u7.RotMode = u13.RotMode;
                                    local v15;

                                    if u13.RotMode == "Speed" then
                                        v15 = not u7.VelocityVectored and true or false;
                                    else
                                        v15 = false;
                                    end;

                                    u7.NeedsRotAccum = v15;
                                end;

                                u7.Link = u13.Link;
                                u7.LinkMode = u13.LinkMode;

                                if u7.LinkMode == "RigidLocal" and (u7.Link and u7.Link.Parent) then
                                    u7._rigidLocalParentCF = PartConstants.resolveLinkCFrame(u7.Link);
                                end;

                                if u7.Type == "ImageLabel" then
                                    u2:_refreshImageLabelAnimateNonSpatial(u7, u13);
                                else
                                    u2:_refreshAnimateNonSpatial(u7, u13);
                                end;

                                StaticPass.restoreFromFreshData(u7, u13);
                                AxisLinks.refreshLoopGraphsAndSeeds(u7, u13, Graph);
                                StaticPass.apply(u7);

                                if u7.Type == "ImageLabel" and (u7._staticSizeScaleX and u7._staticSizeScaleY) then
                                    u7._staticSizeScaleX = nil;
                                    u7._staticSizeScaleY = nil;
                                end;

                                u7._effectiveElapsed = Graph.InitialEffectiveElapsed(u7.Graphs and u7.Graphs.Timescale, u7.Seeds and u7.Seeds.Timescale, u7.LifeTime);

                                if u7.Type == "ImageLabel" then
                                    u7.InvertMotion = u13.ImgInvertMotion or false;

                                    if u7.InvertMotion then
                                        local v16, v17, v18, v19 = u2:_computeImageLabelEndState(u13, u7.DirX or 0, u7.DirY or 0, u7.LifeTime, u7.Seeds);
                                        u7.PosX = v16;
                                        u7.PosY = v17;
                                        u7.EnvVelX = v18;
                                        u7.EnvVelY = v19;
                                        u7._effectiveElapsed = u7.LifeTime;
                                        u7._invertDtSign = -1;
                                    else
                                        u7._invertDtSign = nil;
                                    end;
                                end;

                                if u7.InvertMotion and (u7.AnimateItem and u7.AnimateItem.Parent) then
                                    local v20 = nil;
                                    local u21 = u7.Type == "Attachment";
                                    local u22;

                                    if u7.Type == "Model" then
                                        local v23;
                                        v23, u22 = pcall(function() -- Line: 290
                                            -- upvalues: u7 (copy)
                                            return u7.AnimateItem:GetPivot();
                                        end);

                                        if not v23 then
                                            u22 = v20;
                                        end;
                                    elseif u21 then
                                        u22 = u7.AnimateItem.CFrame;
                                    elseif u7.AnimateItem:IsA("BasePart") then
                                        u22 = u7.AnimateItem.CFrame;
                                    else
                                        u22 = v20;
                                    end;

                                    if u22 then
                                        local v24, v25, v26 = pcall(function() -- Line: 299
                                            -- upvalues: u21 (copy), u2 (ref), u13 (copy), u7 (copy), u22 (ref)
                                            if u21 then
                                                return u2:PreSimulateAttachmentForward(u13, u7.Seeds, u22, u7.BaseDirection, u7.SpreadRotation, u7.LifeTime, nil, u7.SpawnEmitterRotation);
                                            end;

                                            return u2:PreSimulateForward(u13, u7.Seeds, u22, u7.BaseDirection, u7.SpreadRotation, u7.Link, u7.LifeTime, nil, u7.SpawnEmitterRotation);
                                        end);

                                        if v24 then
                                            u7.SimLocalCFrames = v25;

                                            if v26 then
                                                u7.TotalKeyFrames = v26;
                                            end;
                                        end;
                                    end;
                                elseif not u7.InvertMotion then
                                    u7.SimLocalCFrames = nil;
                                end;

                                if u7.Type == "Beam" and u13.BeamProps then
                                    local VisualPart = u7.VisualPart;
                                    local v27 = {};

                                    for i, v in pairs(u13.BeamProps) do
                                        if v then
                                            if Graph.IsStatic(v) then
                                                if VisualPart then
                                                    VisualPart[i] = Graph.GetStaticValue(v, VisualPart[i]);
                                                end;
                                            else
                                                v27[i] = {
                                                    Sequence = v,
                                                    Seed = Graph.GenerateSeed(v)
                                                };
                                            end;
                                        end;
                                    end;

                                    u7.AnimatedProps = v27;

                                    if VisualPart then
                                        u7._baseWidth0 = VisualPart.Width0;
                                        u7._baseWidth1 = VisualPart.Width1;
                                        u7._baseCurveSize0 = VisualPart.CurveSize0;
                                        u7._baseCurveSize1 = VisualPart.CurveSize1;
                                        u7._baseTextureLength = VisualPart.TextureLength;
                                        u7._baseSegments = VisualPart.Segments;
                                    end;

                                    if v27.TextureSpeed and VisualPart then
                                        VisualPart.TextureSpeed = 0;
                                    end;

                                    if u13.GraphBlender then
                                        local v28, v29 = Graph.CollectGraphStates(u13.GraphBlender);
                                        u7.TransStates = v28;
                                        u7.ColorStates = v29;
                                        local v30 = {};

                                        for i = 1, #v28 - 1 do
                                            v30[i] = Graph.PrecomputeMergedTimes(v28[i].Graph, v28[i + 1].Graph);
                                        end;

                                        local v31 = {};

                                        for i = 1, #v29 - 1 do
                                            v31[i] = Graph.PrecomputeMergedColorTimes(v29[i].Graph, v29[i + 1].Graph);
                                        end;

                                        u7.TransMergedTimes = v30;
                                        u7.ColorMergedTimes = v31;

                                        if #v28 > 0 and VisualPart then
                                            VisualPart.Transparency = v28[1].Graph;
                                        end;

                                        if #v29 > 0 and VisualPart then
                                            VisualPart.Color = v29[1].Graph;
                                        end;
                                    end;
                                end;

                                if u13.PLRange then
                                    u7.PLRange = u13.PLRange;
                                end;

                                if u13.PLBrightness then
                                    u7.PLBrightness = u13.PLBrightness;
                                end;

                                if u13.PLColor then
                                    u7.PLColor = u13.PLColor;
                                end;
                            end;

                            if u7.AnimateItem and (u7.AnimateItem.Parent and (u7.VisualPart and u7.VisualPart.Parent)) then
                                if u7.Type == "Model" then
                                    local success, result = pcall(function() -- Line: 356
                                        -- upvalues: u7 (copy)
                                        return u7.AnimateItem:GetPivot();
                                    end);

                                    if success and result then
                                        u7.VisualPart:PivotTo(result);
                                    end;
                                elseif u7.AnimateItem:IsA("BasePart") then
                                    u7.VisualPart.CFrame = u7.AnimateItem.CFrame;
                                elseif u7.AnimateItem:IsA("Attachment") then
                                    u7.VisualPart.CFrame = CFrame.new();
                                end;
                            end;

                            if u7.AnimateItem and (u7.VisualPart and u7.VisualPart.Parent) then
                                for _, descendant in u7.VisualPart:GetDescendants() do
                                    if descendant:GetAttribute("Transformed") then
                                        u2:EnableEmit(descendant, descendant.Parent);
                                    end;
                                end;
                            end;

                            u2:_fireAnimateCycleRestartEvents(u7);
                            v6 = v6 + 1;
                        else
                            local VisualPart = u7.VisualPart;
                            local Type = u7.Type;
                            local InitialAnchorCF = u7.InitialAnchorCF;
                            local InitialScale = u7.InitialScale;
                            local HasDecal = u7.HasDecal;
                            local AnimateItem = u7.AnimateItem;
                            local v32 = u7.PartLife or 0;
                            local u33 = (Type == "Part" or (Type == "Attachment" or Type == "Model")) and true or Type == "Beam";
                            local u34;

                            if AnimateItem then
                                u34 = (AnimateItem:GetAttribute("_animateFinishGen") or 0) + 1;
                                pcall(function() -- Line: 400
                                    -- upvalues: AnimateItem (copy), u34 (ref)
                                    AnimateItem:SetAttribute("_animateFinishGen", u34);
                                end);
                            else
                                u34 = nil;
                            end;

                            local function finishAnimate() -- Line: 402
                                -- upvalues: VisualPart (copy), u33 (copy), AnimateItem (copy), u2 (ref), u34 (ref), u7 (copy), InitialAnchorCF (copy), Type (copy), InitialScale (copy), HasDecal (copy)
                                if not (VisualPart and VisualPart.Parent) then
                                    return;
                                end;

                                if u33 and (AnimateItem and u2.ActiveAnimates[AnimateItem]) then
                                    return;
                                end;

                                if AnimateItem and (AnimateItem.Parent and (u34 and AnimateItem:GetAttribute("_animateFinishGen") ~= u34)) then
                                    return;
                                end;

                                u2:_fireOnDestruction(u7, VisualPart);

                                if InitialAnchorCF then
                                    if Type == "Model" then
                                        pcall(function() -- Line: 412
                                            -- upvalues: VisualPart (ref), InitialAnchorCF (ref)
                                            VisualPart:PivotTo(InitialAnchorCF);
                                        end);

                                        if InitialScale then
                                            pcall(function() -- Line: 413
                                                -- upvalues: VisualPart (ref), InitialScale (ref)
                                                VisualPart:ScaleTo(InitialScale);
                                            end);
                                        end;
                                    else
                                        pcall(function() -- Line: 414
                                            -- upvalues: VisualPart (ref), InitialAnchorCF (ref)
                                            VisualPart.CFrame = InitialAnchorCF;
                                        end);
                                    end;
                                end;

                                if Type == "Screen" or Type == "ImageLabel" then
                                    pcall(function() -- Line: 417
                                        -- upvalues: VisualPart (ref)
                                        VisualPart:Destroy();
                                    end);

                                    return;
                                end;

                                if Type ~= "Beam" and (Type ~= "Highlight" and Type ~= "TrailEmitter") then
                                    pcall(function() -- Line: 425
                                        -- upvalues: VisualPart (ref), HasDecal (ref), u7 (ref)
                                        VisualPart.Transparency = 1;
                                        local v35 = HasDecal and VisualPart:FindFirstChildOfClass("Decal");

                                        if v35 then
                                            v35.Transparency = 1;
                                        end;

                                        local v36 = u7._initialSAColor and VisualPart:FindFirstChildOfClass("SurfaceAppearance");

                                        if v36 then
                                            v36.Color = u7._initialSAColor;
                                        end;

                                        if u7._initialPartColor and VisualPart:IsA("BasePart") then
                                            VisualPart.Color = u7._initialPartColor;
                                        end;
                                    end);

                                    return;
                                end;

                                local u37 = u7.BeamSnapshot or (u7.HighlightSnapshot or u7.TrailEmitterSnapshot);

                                if u37 then
                                    pcall(function() -- Line: 421
                                        -- upvalues: u37 (copy), VisualPart (ref)
                                        for i, v in pairs(u37) do
                                            VisualPart[i] = v;
                                        end;
                                    end);
                                end;

                                pcall(function() -- Line: 423
                                    -- upvalues: VisualPart (ref)
                                    VisualPart.Enabled = false;
                                end);
                            end;

                            u2.ActiveAnimates[AnimateItem] = nil;

                            if v32 > 0 then
                                task.delay(v32, finishAnimate);
                            else
                                finishAnimate();
                            end;

                            if u7._scaleMapKeys and u2._parentScaleMap then
                                for _, v in ipairs(u7._scaleMapKeys) do
                                    u2._parentScaleMap[v] = nil;
                                end;
                            end;

                            if u7._nestedAlive then
                                u7._nestedAlive[1] = false;
                            end;

                            local v38 = #ActiveEmits;

                            if v6 < v38 then
                                ActiveEmits[v6] = ActiveEmits[v38];
                            end;

                            ActiveEmits[v38] = nil;
                        end;
                    else
                        local VisualPart = u7.VisualPart;

                        if u7.PartLife and u7.PartLife > 0 then
                            local _sourceItem = u7._sourceItem;

                            if _sourceItem and VisualPart then
                                u2._lingerByItem = u2._lingerByItem or {};
                                local v39 = u2._lingerByItem[_sourceItem] or {};
                                table.insert(v39, VisualPart);
                                u2._lingerByItem[_sourceItem] = v39;
                                pcall(function() -- Line: 464
                                    -- upvalues: VisualPart (copy)
                                    VisualPart:SetAttribute("_lingerCounted", true);
                                end);
                                local v40 = u2;
                                v40._lingerVisualCount = v40._lingerVisualCount + 1;
                            end;

                            u7._lingerStartTime = os.clock();
                            task.delay(u7.PartLife, function() -- Line: 471
                                -- upvalues: u2 (ref), u7 (copy), VisualPart (copy), _sourceItem (copy)
                                u2:_fireOnDestruction(u7, VisualPart);

                                if VisualPart then
                                    local u41 = false;
                                    pcall(function() -- Line: 475
                                        -- upvalues: u41 (ref), VisualPart (ref)
                                        u41 = VisualPart:GetAttribute("_lingerCounted") == true;
                                    end);

                                    if u41 then
                                        u2._lingerVisualCount = math.max(0, (u2._lingerVisualCount or 0) - 1);
                                        pcall(function() -- Line: 478
                                            -- upvalues: VisualPart (ref)
                                            VisualPart:SetAttribute("_lingerCounted", nil);
                                        end);
                                    end;

                                    u2:_releaseOrDestroy(u7, VisualPart);
                                end;

                                if _sourceItem and (u2._lingerByItem and u2._lingerByItem[_sourceItem]) then
                                    local v42 = u2._lingerByItem[_sourceItem];

                                    for i = #v42, 1, -1 do
                                        if v42[i] == VisualPart then
                                            local v43 = #v42;

                                            if i < v43 then
                                                v42[i] = v42[v43];
                                            end;

                                            v42[v43] = nil;
                                        end;
                                    end;

                                    if #v42 == 0 then
                                        u2._lingerByItem[_sourceItem] = nil;
                                    end;
                                end;
                            end);
                        else
                            u2:_fireOnDestruction(u7, VisualPart);
                            u2:_releaseOrDestroy(u7, VisualPart);
                        end;

                        if u7._scaleMapKeys and u2._parentScaleMap then
                            for _, v in ipairs(u7._scaleMapKeys) do
                                u2._parentScaleMap[v] = nil;
                            end;
                        end;

                        if u7._nestedAlive then
                            u7._nestedAlive[1] = false;
                        end;

                        local v44 = #ActiveEmits;

                        if v6 < v44 then
                            ActiveEmits[v6] = ActiveEmits[v44];
                        end;

                        ActiveEmits[v44] = nil;
                    end;
                else
                    v6 = v6 + 1;
                end;
            end;
        end);
    end;

    function p1.Deactivate(u45) -- Line: 520
        -- upvalues: Pool (ref), Events (ref)
        u45._engineGen = (u45._engineGen or 0) + 1;

        if u45.Connection then
            u45.Connection:Disconnect();
            u45.Connection = nil;
        end;

        if u45._focusConn then
            u45._focusConn:Disconnect();
            u45._focusConn = nil;
        end;

        if u45._blurConn then
            u45._blurConn:Disconnect();
            u45._blurConn = nil;
        end;

        if u45._parentScaleMap then
            table.clear(u45._parentScaleMap);
        end;

        if u45._lingerByItem then
            table.clear(u45._lingerByItem);
        end;

        if u45._evenCycleStore then
            table.clear(u45._evenCycleStore);
        end;

        u45._lingerVisualCount = 0;
        Pool.flushAll();

        for i = #u45.ActiveEmits, 1, -1 do
            local u46 = u45.ActiveEmits[i];

            if not (u46.IsAnimate and ((u46.Type == "Part" or (u46.Type == "Attachment" or u46.Type == "Beam")) and true or u46.Type == "Model")) and u46.VisualPart then
                pcall(function() -- Line: 554
                    -- upvalues: u46 (copy)
                    u46.VisualPart:Destroy();
                end);
            end;

            if u46._nestedAlive then
                u46._nestedAlive[1] = false;
            end;

            u45.ActiveEmits[i] = nil;
        end;

        local v47 = {};

        for i in pairs(u45.ActiveAnimates) do
            table.insert(v47, i);
        end;

        for _, v in ipairs(v47) do
            pcall(function() -- Line: 563
                -- upvalues: u45 (copy), v (copy)
                u45:_cancelAnimation(v);
            end);
        end;

        table.clear(u45.ActiveAnimates);

        for i, v in pairs(u45.ActiveLoops) do
            pcall(function() -- Line: 567
                -- upvalues: v (copy)
                task.cancel(v);
            end);
            u45.ActiveLoops[i] = nil;
        end;

        if u45.ActiveChainLoops then
            for _, v in pairs(u45.ActiveChainLoops) do
                for _, v2 in ipairs(v) do
                    pcall(task.cancel, v2);
                end;
            end;

            table.clear(u45.ActiveChainLoops);
        end;

        if u45._CachedFolder and u45._CachedFolder.Parent then
            u45._CachedFolder:Destroy();
        end;

        u45._CachedFolder = nil;

        if u45._CachedPoolFolder and u45._CachedPoolFolder.Parent then
            u45._CachedPoolFolder:Destroy();
        end;

        u45._CachedPoolFolder = nil;

        local function sweep(p48) -- Line: 585
            for _, descendant in p48:GetDescendants() do
                if descendant:GetAttribute("_PartIcleEmit") then
                    pcall(descendant.Destroy, descendant);
                end;
            end;
        end;

        sweep(workspace);
        sweep(game:GetService("Lighting"));
        local ScreenHost = require(script.Parent.ScreenHost);

        if ScreenHost.exists() then
            sweep(ScreenHost.get());
            ScreenHost.destroy();
        end;

        require(script.Parent.TexturePin).clear();
        Events.cleanup();

        if u45.LinkService and u45.LinkService.Deactivate then
            pcall(function() -- Line: 599
                -- upvalues: u45 (copy)
                u45.LinkService:Deactivate();
            end);
        end;
    end;

    function p1.GetFolder(p49) -- Line: 608
        if p49._CachedFolder and p49._CachedFolder.Parent then
            return p49._CachedFolder;
        end;

        local EmittedPartsUsingPart_icle = workspace.Terrain:FindFirstChild("EmittedPartsUsingPart_icle");

        if not EmittedPartsUsingPart_icle then
            EmittedPartsUsingPart_icle = Instance.new("Folder");
            EmittedPartsUsingPart_icle.Name = "EmittedPartsUsingPart_icle";
            EmittedPartsUsingPart_icle.Archivable = false;
            EmittedPartsUsingPart_icle.Parent = workspace.Terrain;
        end;

        p49._CachedFolder = EmittedPartsUsingPart_icle;

        return EmittedPartsUsingPart_icle;
    end;

    function p1.GetPoolFolder(p50) -- Line: 625
        if p50._CachedPoolFolder and p50._CachedPoolFolder.Parent then
            return p50._CachedPoolFolder;
        end;

        local Part_IclesPooled = workspace.Terrain:FindFirstChild("Part_IclesPooled");

        if not Part_IclesPooled then
            Part_IclesPooled = Instance.new("Folder");
            Part_IclesPooled.Name = "Part_IclesPooled";
            Part_IclesPooled.Archivable = false;
            Part_IclesPooled.Parent = workspace.Terrain;
        end;

        p50._CachedPoolFolder = Part_IclesPooled;

        return Part_IclesPooled;
    end;
end;