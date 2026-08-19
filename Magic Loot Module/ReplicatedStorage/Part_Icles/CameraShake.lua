-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Graph = require(script.Parent.Graph);
local Range = require(script.Parent.Range);
local PartConstants = require(script.Parent.PartConstants);
local Apply = require(script.Apply);
local u1 = false;

return function(u2) -- Line: 29
    -- upvalues: Graph (copy), RunService (copy), u1 (ref), Range (copy), PartConstants (copy), Apply (copy)
    function u2._isCameraShake(p3) -- Line: 32
        local v4 = p3:IsA("BasePart") and p3:GetAttribute("IsCameraShake") == true;

        return v4;
    end;

    local function buildPData(p5, p6, p7, p8) -- Line: 36
        -- upvalues: Graph (ref)
        local v9 = {
            ShakeAmplitude = Graph.GenerateSeed(p6.ShakeAmplitude),
            ShakeRotAmplitude = Graph.GenerateSeed(p6.ShakeRotAmplitude),
            Timescale = Graph.GenerateSeed(p6.Timescale)
        };
        local v10 = {
            Type = "CameraShake",
            VisualPart = nil,
            CurrentStep = -1,
            PartLife = 0,
            Events = p6.Events,
            StartTime = os.clock(),
            TotalKeyFrames = math.max(1, p6.TotalKeyFrames),
            LifeTime = p7,
            _sourceItem = p5,
            Graphs = {
                ShakeAmplitude = p6.ShakeAmplitude,
                ShakeRotAmplitude = p6.ShakeRotAmplitude,
                Timescale = p6.Timescale
            },
            Seeds = v9,
            _effectiveElapsed = Graph.InitialEffectiveElapsed(p6.Timescale, v9.Timescale, p7),
            _shakeFreq = p6.ShakeFrequency or 10,
            _falloff = p6.ShakeFalloff or 0,
            _shakeSeed = math.random() * 997 + 0.5,
            _lastOriginPos = p5.Position
        };

        if p8 then
            local v11;

            if p8.EventOriginResolver then
                v11 = p8.EventOriginResolver();
            else
                v11 = nil;
            end;

            local v12 = v11 or p8.EventOriginCF;

            if v12 then
                v10._originOverride = v12.Position;
            end;
        end;

        return v10;
    end;

    function u2.EmitCameraShake(p13, p14, p15, p16) -- Line: 75
        -- upvalues: RunService (ref), u1 (ref), Range (ref), buildPData (copy), u2 (copy)
        if not (p14 and p14.Parent) then
            return;
        end;

        if not RunService:IsClient() then
            if not u1 then
                u1 = true;
                warn("[Part-Icles] CameraShake ignored on the server (no camera).");
            end;

            return;
        end;

        local v17 = p13:GetData(p14);

        if not v17 then
            return;
        end;

        local v18 = Range.RandomValueFromRange(v17.Lifetime);
        local v19 = buildPData(p14, v17, v18 <= 0 and 0.001 or v18, p16);
        v19._parentLink = p15;
        u2._seedTsOverride(v19, p14);
        p13:_registerEmit(v19, p16);
    end;

    function u2.EmitCameraShakeAnimate(p20, p21, p22, p23) -- Line: 99
        -- upvalues: RunService (ref), Range (ref), buildPData (copy), u2 (copy)
        if not (p21 and p21.Parent) then
            return;
        end;

        if p20.ActiveAnimates[p21] then
            return;
        end;

        if not RunService:IsClient() then
            return;
        end;

        local v24 = p20:GetData(p21);

        if not v24 then
            return;
        end;

        local v25 = Range.RandomValueFromRange(v24.Lifetime);
        local v26 = buildPData(p21, v24, v25 <= 0 and 0.001 or v25, p23);
        v26._parentLink = p22;
        v26.IsAnimate = true;
        v26.AnimateItem = p21;
        u2._seedTsOverride(v26, p21);
        p20.ActiveAnimates[p21] = v26;
        p20:_registerEmit(v26, p23);
    end;

    function u2.UpdateCameraShake(p27, p28, p29, p30) -- Line: 121
        -- upvalues: Graph (ref), PartConstants (ref), Apply (ref)
        local v31 = math.max((p30 - p28.StartTime) / p28.LifeTime, 0);
        local v32 = math.min(v31, 1);
        local v33;

        if p28._tsOverride == nil or p30 >= (p28._tsOverrideUntil or 0) then
            v33 = p28.Graphs.Timescale and (Graph.QueryPointsWithTime(v32, p28.Graphs.Timescale, p28.Seeds.Timescale) or 1) or 1;
        else
            v33 = p28._tsOverride;
        end;

        local LifeTime = p28.LifeTime;
        local v34 = (p28._effectiveElapsed or 0) + (p28._timeFrozen and 0 or p29 * v33);
        local v35 = v34 < 0 and 0 or v34;

        if LifeTime < v35 then
            v35 = LifeTime;
        end;

        p28._effectiveElapsed = v35;

        if p28.TotalKeyFrames <= 0 then
            return true;
        end;

        local v36;

        if v32 >= 1 then
            v36 = LifeTime <= v35 and true or v35 <= 0;
        else
            v36 = false;
        end;

        if v36 then
            return true;
        end;

        local _originOverride = p28._originOverride;

        if not _originOverride then
            local _parentLink = p28._parentLink;

            if _parentLink and _parentLink.Parent then
                _originOverride = PartConstants.resolveLinkCFrame(_parentLink).Position;
            else
                local _sourceItem = p28._sourceItem;
                _originOverride = _sourceItem and (_sourceItem.Parent and _sourceItem.Position) or p28._lastOriginPos;
            end;
        end;

        p28._lastOriginPos = _originOverride;
        local v37 = math.max(v35 / LifeTime, 0);
        local v38 = math.min(v37, 1) * p28.TotalKeyFrames;
        local v39 = math.floor(v38);

        if v39 ~= p28.CurrentStep then
            p28.CurrentStep = v39;
            local v40 = v39 / p28.TotalKeyFrames;
            p28._curAmp = p28.Graphs.ShakeAmplitude and (Graph.QueryPointsWithTime(v40, p28.Graphs.ShakeAmplitude, p28.Seeds.ShakeAmplitude) or 0) or 0;
            p28._curRotAmp = p28.Graphs.ShakeRotAmplitude and (Graph.QueryPointsWithTime(v40, p28.Graphs.ShakeRotAmplitude, p28.Seeds.ShakeRotAmplitude) or 0) or 0;
        end;

        local _falloff = p28._falloff;
        local v41;

        if _falloff > 0 then
            local CurrentCamera = workspace.CurrentCamera;
            v41 = not CurrentCamera and 0 or math.clamp(1 - (CurrentCamera.CFrame.Position - _originOverride).Magnitude / _falloff, 0, 1);
        else
            v41 = 1;
        end;

        local v42 = (p28._curAmp or 0) * v41;
        local v43 = math.rad(p28._curRotAmp or 0) * v41;

        if v42 ~= 0 or v43 ~= 0 then
            local v44 = v35 * p28._shakeFreq;
            local _shakeSeed = p28._shakeSeed;
            Apply.accumulate(v42 * math.noise(v44, _shakeSeed, 0.17), v42 * math.noise(v44, _shakeSeed, 137.7), v42 * math.noise(v44, _shakeSeed, 291.3), v43 * math.noise(v44, _shakeSeed, 431.1), v43 * math.noise(v44, _shakeSeed, 557.5), v43 * math.noise(v44, _shakeSeed, 683.9));
        end;

        return false;
    end;

    function u2._refreshCameraShakeAnimate(p45, p46, p47) -- Line: 190
        p46.Link = nil;
        p46._shakeFreq = p47.ShakeFrequency or 10;
        p46._falloff = p47.ShakeFalloff or 0;
        p46._curAmp = nil;
        p46._curRotAmp = nil;
        p46.CurrentStep = -1;
    end;
end;