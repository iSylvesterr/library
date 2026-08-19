-- Decompiled with Potassium's decompiler.

local InsMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).InsMgr;

return {
    SetPlrAttr = function(p1, p2, p3) -- Line: 29, Name: SetPlrAttr
        -- upvalues: InsMgr (copy)
        if not p1 then
            return;
        end;

        local v4 = InsMgr.GetIns("Attrs", "Folder", p1);

        if v4 then
            InsMgr.GetIns(tostring(p2), "NumberValue", v4).Value = p3;
        end;
    end,

    SetPlrAttr_Limit = function(p5, p6, p7) -- Line: 48, Name: SetPlrAttr_Limit
        -- upvalues: InsMgr (copy)
        if not p5 then
            return;
        end;

        local v8 = InsMgr.GetIns("Attrs_Buff", "Folder", p5);

        if v8 then
            InsMgr.GetIns(tostring(p6), "NumberValue", v8).Value = p7;
        end;
    end
};