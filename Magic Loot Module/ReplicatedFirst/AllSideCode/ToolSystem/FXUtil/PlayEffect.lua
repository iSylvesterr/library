-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local RunService = game:GetService("RunService");
    local Debris = game:GetService("Debris");
    local VisibleMgr = UtilsSystem.VisibleMgr;
    local AssetPaths = UtilsSystem.AssetPaths;
    local AssetRegistry = UtilsSystem.AssetRegistry;
    local PlayEffectInternal = require(script.Parent.PlayEffectInternal);

    local function _getEffectClone(p2) -- Line: 27
        -- upvalues: AssetPaths (copy), AssetRegistry (copy)
        local v3 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Effect, p2));

        if v3 then
            return v3:Clone();
        end;

        return nil;
    end;

    local function _getEffectInstanceForPlay(p4, p5, p6) -- Line: 44
        -- upvalues: AssetRegistry (copy), AssetPaths (copy), u1 (copy)
        local v7;

        if p5 == "Skill" then
            v7 = AssetRegistry.ModelCategory.Skill;
        else
            v7 = AssetRegistry.ModelCategory.Effect;
        end;

        local v8 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(v7, p4));

        if not v8 then
            return nil;
        end;

        if not p6 then
            return v8:Clone();
        end;

        if v8:IsA("Model") then
            return u1.GetInstance_From_Pool(v8);
        end;

        return nil;
    end;

    local function _scheduleOnceEmitCleanup(u9, u10, p11) -- Line: 67
        -- upvalues: PlayEffectInternal (copy), Debris (copy)
        if p11 then
            task.spawn(function() -- Line: 69
                -- upvalues: u10 (copy), u9 (copy), PlayEffectInternal (ref)
                task.wait(u10);

                if u9.Parent == nil then
                    return;
                end;

                PlayEffectInternal.stopPooledVfxAndRecycle(u9);
            end);

            return;
        end;

        task.delay(u10, function() -- Line: 78
            -- upvalues: Debris (ref), u9 (copy)
            Debris:AddItem(u9, 0);
        end);
    end;

    local function _pivotEffectToTarget(p12, p13, p14) -- Line: 89
        if typeof(p13) ~= "CFrame" then
            if p13:IsA("BasePart") then
                if p14 then
                    p12:PivotTo(p13:GetPivot():ToWorldSpace(p14));

                    return;
                end;

                p12:PivotTo(p13:GetPivot());
            end;

            return;
        end;

        if p14 then
            p12:PivotTo(p13:ToWorldSpace(p14));

            return;
        end;

        p12:PivotTo(p13);
    end;

    local function _scheduleContinuousEmitCleanup(u15, p16) -- Line: 112
        -- upvalues: u1 (copy), Debris (copy)
        task.delay(p16, function() -- Line: 113
            -- upvalues: u1 (ref), u15 (copy), Debris (ref)
            u1.Stop_All_Emit(u15);
            u1.Stop_All_Particles(u15);
            task.delay(1, function() -- Line: 116
                -- upvalues: Debris (ref), u15 (ref)
                Debris:AddItem(u15, 0);
            end);
        end);
    end;

    local function _weldEffectToPart(p17, p18, p19) -- Line: 128
        local WeldConstraint = Instance.new("WeldConstraint", p17);

        if p19 and (p17:IsA("Model") and p17.PrimaryPart) then
            WeldConstraint.Part0 = p17.PrimaryPart;
        else
            WeldConstraint.Part0 = p17;
        end;

        WeldConstraint.Part1 = p18;
    end;

    local function _playEffectType1(u20, p21, p22) -- Line: 141
        -- upvalues: _pivotEffectToTarget (copy), u1 (copy), Debris (copy)
        _pivotEffectToTarget(u20, p21, CFrame.new());
        u1.Start_All_Emit(u20, p22);
        task.delay(p22, function() -- Line: 113
            -- upvalues: u1 (ref), u20 (copy), Debris (ref)
            u1.Stop_All_Emit(u20);
            u1.Stop_All_Particles(u20);
            task.delay(1, function() -- Line: 116
                -- upvalues: Debris (ref), u20 (ref)
                Debris:AddItem(u20, 0);
            end);
        end);
    end;

    local function _playEffectType2(u23, p24, p25, p26) -- Line: 150
        -- upvalues: VisibleMgr (copy), _pivotEffectToTarget (copy), u1 (copy), Debris (copy)
        VisibleMgr.UnAnchoredAll(u23);
        _pivotEffectToTarget(u23, p24, p25);
        local WeldConstraint = Instance.new("WeldConstraint", u23);
        WeldConstraint.Part0 = u23;
        WeldConstraint.Part1 = p24;
        u1.Start_All_Emit(u23, p26);
        task.delay(p26, function() -- Line: 113
            -- upvalues: u1 (ref), u23 (copy), Debris (ref)
            u1.Stop_All_Emit(u23);
            u1.Stop_All_Particles(u23);
            task.delay(1, function() -- Line: 116
                -- upvalues: Debris (ref), u23 (ref)
                Debris:AddItem(u23, 0);
            end);
        end);
    end;

    local function _playEffectTypeOnce(p27, p28, p29, p30, p31, p32) -- Line: 161
        -- upvalues: VisibleMgr (copy), _pivotEffectToTarget (copy), u1 (copy), _scheduleOnceEmitCleanup (copy)
        if p32 then
            VisibleMgr.UnAnchoredAll(p27);
        else
            VisibleMgr.AnchoredAll(p27);
        end;

        _pivotEffectToTarget(p27, p28, p29);

        if p32 then
            local WeldConstraint = Instance.new("WeldConstraint", p27);

            if p27:IsA("Model") and p27.PrimaryPart then
                WeldConstraint.Part0 = p27.PrimaryPart;
            else
                WeldConstraint.Part0 = p27;
            end;

            WeldConstraint.Part1 = p32;
        end;

        u1.Emit_Particles_GetDescendants(p27, true);
        _scheduleOnceEmitCleanup(p27, p30, p31);
    end;

    local function _playEffectType5(p33, p34, p35) -- Line: 185
        -- upvalues: VisibleMgr (copy), _pivotEffectToTarget (copy), u1 (copy)
        VisibleMgr.UnAnchoredAll(p33);
        VisibleMgr.UnCollideAll(p33);
        VisibleMgr.UnTouchAll(p33);
        VisibleMgr.UnQueryAll(p33);
        VisibleMgr.MasslessAll(p33);
        _pivotEffectToTarget(p33, p34, p35);
        local WeldConstraint = Instance.new("WeldConstraint", p33);

        if p33:IsA("Model") and p33.PrimaryPart then
            WeldConstraint.Part0 = p33.PrimaryPart;
        else
            WeldConstraint.Part0 = p33;
        end;

        WeldConstraint.Part1 = p34;
        u1.Emit_Particles_GetDescendants(p33);
        p33.Parent = p34;

        return p33;
    end;

    function u1.PlayEffect(p36, p37, p38, p39, p40, p41, p42) -- Line: 216
        -- upvalues: RunService (copy), AssetPaths (copy), AssetRegistry (copy), _getEffectInstanceForPlay (copy), UtilsSystem (copy), PlayEffectInternal (copy), _pivotEffectToTarget (copy), u1 (copy), Debris (copy), _playEffectType2 (copy), VisibleMgr (copy), _scheduleOnceEmitCleanup (copy), _playEffectTypeOnce (copy), _playEffectType5 (copy)
        if RunService:IsServer() then
            return nil;
        end;

        if not p37 then
            return nil;
        end;

        local v43 = p39 or 1;
        local v44 = p38 or 1;
        local v45 = p40 or CFrame.new(0, 0, 0);
        local v46 = p41 or 1;
        local v47 = p42 and (p42.resourceCategory or "Effect") or "Effect";
        local v48;

        if p42 then
            v48 = p42.usePool;
        else
            v48 = p42;
        end;

        if v48 and (v43 ~= 3 and v43 ~= 4) then
            v48 = false;
        end;

        local v49 = p42 and p42.parent or workspace;
        local u50;

        if v47 == "Effect" and not v48 then
            local v51 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Effect, p36));

            if v51 then
                u50 = v51:Clone();
            else
                u50 = nil;
            end;
        else
            u50 = _getEffectInstanceForPlay(p36, v47, v48 or false);
        end;

        if not u50 then
            return nil;
        end;

        if v47 == "Skill" and u50:IsA("Model") then
            local ResRestore = UtilsSystem.ResRestore;

            if ResRestore and ResRestore.Restore then
                ResRestore.Restore(u50);
            end;
        end;

        if u50:IsA("Model") and not v48 then
            u50:ScaleTo(u50:GetScale() * v46);
        end;

        PlayEffectInternal.prepEffectModelForWorldShared(u50, v48 or false);
        u50.Parent = v49;

        if v43 == 1 then
            _pivotEffectToTarget(u50, p37, CFrame.new());
            u1.Start_All_Emit(u50, v44);
            task.delay(v44, function() -- Line: 113
                -- upvalues: u1 (ref), u50 (copy), Debris (ref)
                u1.Stop_All_Emit(u50);
                u1.Stop_All_Particles(u50);
                task.delay(1, function() -- Line: 116
                    -- upvalues: Debris (ref), u50 (ref)
                    Debris:AddItem(u50, 0);
                end);
            end);
        elseif v43 == 2 and (typeof(p37) ~= "CFrame" and p37:IsA("BasePart")) then
            _playEffectType2(u50, p37, v45, v44);
        elseif v43 == 3 then
            VisibleMgr.AnchoredAll(u50);
            _pivotEffectToTarget(u50, p37, v45);
            u1.Emit_Particles_GetDescendants(u50, true);
            _scheduleOnceEmitCleanup(u50, v44, v48 or false);
        elseif v43 == 4 and (typeof(p37) ~= "CFrame" and p37:IsA("BasePart")) then
            _playEffectTypeOnce(u50, p37, v45, v44, v48 or false, p37);
        elseif v43 == 5 and (typeof(p37) ~= "CFrame" and p37:IsA("BasePart")) then
            return _playEffectType5(u50, p37, v45);
        end;

        return nil;
    end;
end;