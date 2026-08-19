-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9
    local VisibleMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).VisibleMgr;
    local PlayEffectInternal = require(script.Parent.PlayEffectInternal);
    PlayEffectInternal.setup(p1, VisibleMgr);

    function p1.PrepEffectForWorldShared(p2, p3) -- Line: 19
        -- upvalues: PlayEffectInternal (copy)
        PlayEffectInternal.prepEffectModelForWorldShared(p2, p3);
    end;

    function p1.WeldFxModelToBasePart(p4, p5, p6) -- Line: 28
        -- upvalues: VisibleMgr (copy), PlayEffectInternal (copy)
        VisibleMgr.UnAnchoredAll(p4);
        VisibleMgr.UnCollideAll(p4);
        VisibleMgr.UnTouchAll(p4);
        VisibleMgr.UnQueryAll(p4);
        VisibleMgr.MasslessAll(p4);
        PlayEffectInternal.destroyFxWeldConstraintsRecursive(p4);
        local v7 = p5:GetPivot();

        if p6 then
            v7 = v7 * p6;
        end;

        local PrimaryPart = p4.PrimaryPart;

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            PrimaryPart = p4:FindFirstChildWhichIsA("BasePart", true);
        end;

        if not PrimaryPart then
            return false;
        end;

        if p4.PrimaryPart ~= PrimaryPart then
            p4.PrimaryPart = PrimaryPart;
        end;

        p4:PivotTo(v7);
        local WeldConstraint = Instance.new("WeldConstraint", p4);
        WeldConstraint.Part0 = PrimaryPart;
        WeldConstraint.Part1 = p5;

        return true;
    end;

    function p1.CloneModelResEffectModel(p8) -- Line: 56
        -- upvalues: PlayEffectInternal (copy)
        return PlayEffectInternal.cloneModelResEffectModel(p8);
    end;
end;