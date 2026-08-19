-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local ObjectPoolUtil = UtilsSystem.ObjectPoolUtil;
    local VisibleMgr = UtilsSystem.VisibleMgr;

    function u1.GetInstance_From_Pool(p2) -- Line: 25
        -- upvalues: ObjectPoolUtil (copy)
        return ObjectPoolUtil.getObjectFromPool(p2);
    end;

    function u1.BackPool_Instance(p3) -- Line: 34
        -- upvalues: u1 (copy), ObjectPoolUtil (copy)
        if p3 and p3:IsA("Model") then
            u1.ResetPooledModelBeforeBackPool(p3);
        end;

        ObjectPoolUtil.backToPool(p3);
    end;

    function u1.PreparePooledModelForReuse(p4, p5) -- Line: 46
        -- upvalues: u1 (copy), VisibleMgr (copy)
        if not (p4 and p4:IsA("Model")) then
            return;
        end;

        u1.InvalidateVfxCache(p4);

        if p5 then
            VisibleMgr.SyncDefaultVisualSnapshotFromTemplate(p4, p5);
        else
            VisibleMgr.SnapshotDefaultVisualState(p4);
        end;

        u1.Stop_All_Emit(p4);
        VisibleMgr.RestoreDefaultVisualState(p4);
        p4:ScaleTo(1);
    end;

    function u1.ResetPooledModelBeforeBackPool(p6) -- Line: 65
        -- upvalues: u1 (copy), VisibleMgr (copy)
        if not (p6 and p6:IsA("Model")) then
            return;
        end;

        u1.Stop_All_Emit(p6);
        u1.SetEmittersTrailsBeamsEnabled(p6, false);
        u1.OffEnableVfx(p6);
        VisibleMgr.RestoreDefaultVisualState(p6);
        p6:ScaleTo(1);
        u1.InvalidateVfxCache(p6);
    end;

    function u1.ReturnPooledModelToPool(p7) -- Line: 81
        -- upvalues: u1 (copy)
        if not (p7 and p7:IsA("Model")) then
            return;
        end;

        if p7.Parent then
            u1.BackPool_Instance(p7);
        end;
    end;
end;