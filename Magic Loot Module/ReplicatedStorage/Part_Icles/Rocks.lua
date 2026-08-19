-- Decompiled with Potassium's decompiler.

local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local Pool = require(script.Parent.Pool);
local Events = require(script.Parent.Events);
local NestedEmit = require(script.Parent.NestedEmit);
local Particles = require(script.Parent.Particles);
local PartConstants = require(script.Parent.PartConstants);
local Trajectory = require(script.Trajectory);
local PDataBuilder = require(script.PDataBuilder);
local u1 = CFrame.new(1000000000, 1000000000, 1000000000);
local u2 = setmetatable({}, {
    __mode = "k"
});

return function(u3) -- Line: 35
    -- upvalues: Pool (copy), u1 (copy), u2 (copy), Graph (copy), Events (copy), Trajectory (copy), Range (copy), PDataBuilder (copy), Particles (copy), NestedEmit (copy), PartConstants (copy)
    function u3._isRocks(p4) -- Line: 38
        local v5 = p4:IsA("BasePart") and p4:GetAttribute("IsRocks") == true;

        return v5;
    end;

    local function buildChunk(p6) -- Line: 45
        -- upvalues: Pool (ref)
        local v7 = Pool.copyBare(p6);
        v7.Anchored = true;
        v7.CanCollide = false;
        v7.CanQuery = false;
        v7.CanTouch = false;
        v7.Massless = false;
        v7.Locked = true;
        v7.Archivable = false;
        v7.CastShadow = true;
        v7.Transparency = 0;

        return v7, v7:FindFirstChildWhichIsA("Decal") or v7:FindFirstChildWhichIsA("Texture");
    end;

    local function chunkCapFor(p8) -- Line: 60
        local v9 = math.floor((p8.ChunkCount and p8.ChunkCount.Max or 10) + 0.5);

        return math.clamp(v9, 1, 32);
    end;

    local function buildRig(p10) -- Line: 64
        -- upvalues: Pool (ref), u1 (ref), u2 (ref)
        local v11 = math.floor((p10.ChunkCount and (p10.ChunkCount.Max or 10) or 10) + 0.5);
        local v12 = math.clamp(v11, 1, 32);
        local Model = Instance.new("Model");
        Model.Name = "RockBurst";
        Model.Archivable = false;
        local v13 = {
            chunkCap = v12,
            parts = table.create(v12),
            decals = table.create(v12),
            baseSize = table.create(v12),
            halfExt = table.create(v12),
            bounciness = table.create(v12),
            launchVel = table.create(v12),
            launchAng = table.create(v12),
            spawnPos = table.create(v12),
            spawnRot = table.create(v12),
            trajs = table.create(v12),
            touched = table.create(v12),
            writeCFs = table.create(v12)
        };

        for i = 1, v12 do
            local v14 = Pool.copyBare(p10.RenderTemplate);
            v14.Anchored = true;
            v14.CanCollide = false;
            v14.CanQuery = false;
            v14.CanTouch = false;
            v14.Massless = false;
            v14.Locked = true;
            v14.Archivable = false;
            v14.CastShadow = true;
            v14.Transparency = 0;
            local v15 = v14:FindFirstChildWhichIsA("Decal") or v14:FindFirstChildWhichIsA("Texture");
            v14.Name = "Chunk" .. i;
            v14.CFrame = u1;
            v14.Parent = Model;
            v13.parts[i] = v14;
            v13.decals[i] = v15;
            v13.baseSize[i] = v14.Size;
            v13.writeCFs[i] = u1;
        end;

        u2[Model] = v13;

        return Model, v13;
    end;

    local function acquireRocks(p16) -- Line: 101
        -- upvalues: Pool (ref), u2 (ref), buildRig (copy)
        local v17 = math.floor((p16.ChunkCount and (p16.ChunkCount.Max or 10) or 10) + 0.5);
        local v18 = math.clamp(v17, 1, 32);
        local u19 = p16.Pool ~= false and Pool.acquire(p16.RenderTemplate, "Rocks");

        if u19 then
            local v20 = u2[u19];

            if v20 and (v20.chunkCap == v18 and (v20.parts[1] and v20.parts[1].Parent == u19)) then
                u19:SetAttribute("_PartIcleEmit", true);

                return u19, v20;
            end;

            pcall(function() -- Line: 111
                -- upvalues: u19 (copy)
                u19:Destroy();
            end);
        end;

        local v21, v22 = buildRig(p16);
        v21:SetAttribute("_PartIcleEmit", true);

        return v21, v22;
    end;

    local function writeVisuals(p23, p24) -- Line: 121
        -- upvalues: Graph (ref)
        local Graphs = p23.Graphs;
        local Seeds = p23.Seeds;
        local v25 = Graphs.Transparency and (Graph.QueryPointsWithTime(p24, Graphs.Transparency, Seeds.Transparency) or 0) or 0;

        if p23.SkipTransparency then
            v25 = p23._curTrans or v25;
        end;

        local v26 = Graphs.Brightness and (Graph.QueryPointsWithTime(p24, Graphs.Brightness, Seeds.Brightness) or 1) or 1;
        local v27;

        if Graphs.Color and not p23.SkipColor then
            local v28 = Graph.QueryColorPointWithTime(p24, Graphs.Color);
            v27 = Color3.new(math.min(v28.R * v26, 1), math.min(v28.G * v26, 1), (math.min(v28.B * v26, 1)));
        else
            v27 = nil;
        end;

        local v29 = Graphs.Scale and Graph.QueryPointsWithTime(p24, Graphs.Scale, Seeds.Scale);
        local _rig = p23._rig;
        local v30;

        if v29 then
            v30 = v29 ~= p23._curScale;
        else
            v30 = v29;
        end;

        if v29 then
            p23._curScale = v29;
        end;

        p23._curTrans = v25;

        for i = 1, _rig.chunkCap do
            local v31 = _rig.parts[i];
            v31.Transparency = v25;

            if v27 then
                v31.Color = v27;
            end;

            local v32 = _rig.decals[i];

            if v32 then
                v32.Transparency = v25;

                if v27 then
                    v32.Color3 = v27;
                end;
            end;

            if v30 then
                v31.Size = _rig.baseSize[i] * math.max(v29, 0.01);
            end;
        end;
    end;

    local function buildRockParams(u33, p34) -- Line: 154
        -- upvalues: Events (ref)
        local u35 = Events.makeHitParams(p34);
        u35.RespectCanCollide = true;
        pcall(function() -- Line: 157
            -- upvalues: u35 (copy), u33 (copy)
            u35:AddToFilter(u33:GetFolder());
            u35:AddToFilter(u33:GetPoolFolder());
        end);
        p34._rockParams = u35;

        function p34._raycastFn(p36, p37) -- Line: 162
            -- upvalues: u35 (copy)
            return workspace:Raycast(p36, p37, u35);
        end;
    end;

    local function buildTrajectories(p38) -- Line: 168
        -- upvalues: Trajectory (ref)
        local _rig = p38._rig;
        local _raycastFn = p38._raycastFn;
        local v39 = p38._curScale or 1;
        local v40 = 0;
        local v41 = (1 / 0);
        local v42 = nil;
        local v43 = false;

        for i = 1, p38._chunkCount do
            local v44 = Trajectory.build(_rig.spawnPos[i], _rig.launchVel[i], _rig.spawnRot[i], _rig.launchAng[i], _rig.halfExt[i], v39, p38._gravity, _rig.bounciness[i], p38._friction, _raycastFn);
            _rig.trajs[i] = v44;

            if v44.impactT and v44.impactT < v41 then
                v41 = v44.impactT;
                v42 = v44.hit;
            end;

            if v44.restT == (1 / 0) then
                v43 = true;
            elseif v40 < v44.restT then
                v40 = v44.restT;
            end;
        end;

        p38._firstImpactT = v41;
        p38._firstHitInfo = v42;
        p38._maxRestT = (v40 <= 0 or (v43 or not v40)) and (1 / 0) or v40;
        p38._restWritten = false;
    end;

    local function startPhysics(p45, p46) -- Line: 199
        -- upvalues: buildRockParams (copy), buildTrajectories (copy)
        buildRockParams(p45, p46);
        buildTrajectories(p46);
    end;

    function u3.EmitRocks(p47, p48, p49, p50) -- Line: 205
        -- upvalues: Range (ref), acquireRocks (copy), PDataBuilder (ref), u3 (copy), writeVisuals (copy), buildRockParams (copy), buildTrajectories (copy), Pool (ref), Particles (ref), NestedEmit (ref)
        if not (p48 and p48.Parent) then
            return;
        end;

        local v51 = p47:GetData(p48);

        if not (v51 and v51.RenderTemplate) then
            return;
        end;

        local v52 = Range.RandomValueFromRange(v51.Lifetime);
        local v53, v54 = acquireRocks(v51);
        local v55 = PDataBuilder.build(p48, v51, v53, v54, v52 <= 0 and 0.001 or v52, p50, p49);
        u3._seedTsOverride(v55, p48);

        if v51.Pool ~= false then
            v55._sourceRT = v51.RenderTemplate;
            v55._poolKind = "Rocks";
        end;

        writeVisuals(v55, 0);
        v53.Parent = v51.EmitParent or p47:GetFolder();
        buildRockParams(p47, v55);
        buildTrajectories(v55);
        Pool.restoreTrails(v53, "Rocks");
        Particles.EnableEmit(v53, p47:_makeAliveCheck());
        v55._nestedAlive = { true };
        p47:_registerEmit(v55, p50);
        NestedEmit.walk(p47, v51.RenderTemplate, v53, v55._nestedAlive, p50);
    end;

    function u3.EmitRocksAnimate(p56, p57, p58, p59) -- Line: 233
        -- upvalues: Range (ref), buildRig (copy), PDataBuilder (ref), u3 (copy), writeVisuals (copy), buildRockParams (copy), buildTrajectories (copy), Particles (ref), NestedEmit (ref)
        if not (p57 and p57.Parent) then
            return;
        end;

        if p56.ActiveAnimates[p57] then
            return;
        end;

        local v60 = p56:GetData(p57);

        if not (v60 and v60.RenderTemplate) then
            return;
        end;

        local v61 = Range.RandomValueFromRange(v60.Lifetime);
        local v62, v63 = buildRig(v60);
        v62:SetAttribute("_PartIcleEmit", true);
        local v64 = PDataBuilder.build(p57, v60, v62, v63, v61 <= 0 and 0.001 or v61, p59, p58);
        v64.IsAnimate = true;
        v64.AnimateItem = p57;
        v64._animateLink = p58;
        u3._seedTsOverride(v64, p57);
        writeVisuals(v64, 0);
        v62.Parent = v60.EmitParent or p56:GetFolder();
        buildRockParams(p56, v64);
        buildTrajectories(v64);
        Particles.EnableEmit(v62, p56:_makeAliveCheck());
        v64._nestedAlive = { true };
        p56.ActiveAnimates[p57] = v64;
        p56:_registerEmit(v64, p59);
        NestedEmit.walk(p56, v60.RenderTemplate, v62, v64._nestedAlive, p59);
    end;

    function u3.UpdateRocks(p65, p66, p67, p68) -- Line: 263
        -- upvalues: Graph (ref), Trajectory (ref), Events (ref), writeVisuals (copy)
        local v69 = math.max((p68 - p66.StartTime) / p66.LifeTime, 0);
        local v70 = math.min(v69, 1);
        local v71;

        if p66._tsOverride == nil or p68 >= (p66._tsOverrideUntil or 0) then
            v71 = p66.Graphs.Timescale and (Graph.QueryPointsWithTime(v70, p66.Graphs.Timescale, p66.Seeds.Timescale) or 1) or 1;
        else
            v71 = p66._tsOverride;
        end;

        local LifeTime = p66.LifeTime;
        local v72 = (p66._effectiveElapsed or 0) + (p66._timeFrozen and 0 or p67 * v71);
        local v73 = v72 < 0 and 0 or v72;

        if LifeTime < v73 then
            v73 = LifeTime;
        end;

        p66._effectiveElapsed = v73;
        local VisualPart = p66.VisualPart;

        if not (VisualPart and VisualPart.Parent) then
            return true;
        end;

        if p66.TotalKeyFrames <= 0 then
            return true;
        end;

        local v74;

        if v70 >= 1 then
            v74 = LifeTime <= v73 and true or v73 <= 0;
        else
            v74 = false;
        end;

        if not v74 then
            local _rig = p66._rig;
            local v75 = p66._sinkOut and v73 / LifeTime > 0.85;

            if v73 < p66._maxRestT or (v75 or not p66._restWritten) then
                local v76;

                if v75 then
                    local v77 = (v73 / LifeTime - 0.85) / 0.15000000000000002;
                    v76 = v77 * v77;
                else
                    v76 = 0;
                end;

                for i = 1, p66._chunkCount do
                    local u78 = _rig.trajs[i];

                    if u78 then
                        local v79 = Trajectory.evaluate(u78, v73, p66._gravity);

                        if v76 > 0 and u78.restT < v73 then
                            local v80 = _rig.baseSize[i];
                            local v81 = math.max(v80.X, v80.Y, v80.Z) * math.max(p66._curScale or 1, 0.01) * 1.5;
                            v79 = v79.Rotation + (v79.Position - Vector3.new(0, v81 * v76, 0));
                        end;

                        _rig.writeCFs[i] = v79;

                        if p66._inheritFloor and (not _rig.touched[i] and (u78.impactT and (u78.impactT <= v73 and u78.hit))) then
                            _rig.touched[i] = true;
                            local u82 = _rig.parts[i];
                            pcall(function() -- Line: 309
                                -- upvalues: u82 (copy), u78 (copy)
                                u82.Material = u78.hit.Instance.Material;
                                u82.Color = u78.hit.Instance.Color;
                            end);
                            p66.SkipColor = true;
                        end;
                    end;
                end;

                workspace:BulkMoveTo(_rig.parts, _rig.writeCFs, Enum.BulkMoveMode.FireCFrameChanged);
                local v83;

                if p66._maxRestT <= v73 then
                    v83 = not v75;
                else
                    v83 = false;
                end;

                p66._restWritten = v83;
            end;

            if not p66._hitFired and (p66.Events and (p66.Events.OnHit and (p66._firstHitInfo and p66._firstImpactT <= v73))) then
                p66._hitFired = true;
                local _firstHitInfo = p66._firstHitInfo;
                local v84 = Events.makePayload(p65, p66, "OnHit", nil);
                v84.HitInstance = _firstHitInfo.Instance;
                v84.Other = _firstHitInfo.Instance;
                v84.HitPosition = _firstHitInfo.Position;
                v84.HitNormal = _firstHitInfo.Normal;
                Events.fire(p65, p66, "OnHit", p66.EventChainCtx, v84);
            end;
        end;

        local v85 = math.max(v73 / LifeTime, 0);
        local v86 = math.min(v85, 1) * p66.TotalKeyFrames;
        local v87 = math.floor(v86);

        if v87 ~= p66.CurrentStep then
            p66.CurrentStep = v87;
            writeVisuals(p66, v87 / p66.TotalKeyFrames);
        end;

        return v74;
    end;

    function u3._refreshRocksAnimate(p88, p89, p90) -- Line: 347
        -- upvalues: buildRig (copy), PartConstants (ref), PDataBuilder (ref), writeVisuals (copy), buildRockParams (copy), buildTrajectories (copy)
        p89.Link = nil;
        p89._gravity = p90.Gravity or 196.2;
        p89._friction = math.clamp(p90.Friction or 0.3, 0, 1);
        p89._sinkOut = p90.SinkOut ~= false;
        p89._inheritFloor = p90.InheritFloor == true;
        p89._hitFired = false;
        p89.SkipColor = nil;
        local v91 = math.floor((p90.ChunkCount and (p90.ChunkCount.Max or 10) or 10) + 0.5);

        if math.clamp(v91, 1, 32) ~= p89._rig.chunkCap and p90.RenderTemplate then
            local VisualPart = p89.VisualPart;
            local v92;

            if VisualPart then
                v92 = VisualPart.Parent;
            else
                v92 = VisualPart;
            end;

            local v93, v94 = buildRig(p90);
            v93:SetAttribute("_PartIcleEmit", true);
            p89.VisualPart = v93;
            p89._rig = v94;
            v93.Parent = v92 or p88:GetFolder();

            if VisualPart then
                pcall(function() -- Line: 366
                    -- upvalues: VisualPart (copy)
                    VisualPart:Destroy();
                end);
            end;
        end;

        local _animateLink = p89._animateLink;
        local v95;

        if _animateLink and _animateLink.Parent then
            v95 = PartConstants.resolveLinkCFrame(_animateLink);
        else
            v95 = nil;
        end;

        local AnimateItem = p89.AnimateItem;

        if not v95 and (AnimateItem and AnimateItem.Parent) then
            v95 = AnimateItem.CFrame;
        end;

        PDataBuilder.rollChunks(p89, p90, p89._rig, v95 or CFrame.new());
        writeVisuals(p89, 0);
        buildRockParams(p88, p89);
        buildTrajectories(p89);
    end;
end;