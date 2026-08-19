-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");

return function(p1) -- Line: 3
    -- upvalues: CollectionService (copy)
    local Tag = p1.Tag;
    local v3 = p1.OnInstanceAdded or function(p2) -- Line: 5
    end;
    local v5 = p1.OnInstanceRemoved or function(p4) -- Line: 6
    end;

    for _, v in CollectionService:GetTagged(Tag) do
        v3(v);
    end;

    CollectionService:GetInstanceAddedSignal(Tag):Connect(v3);
    CollectionService:GetInstanceRemovedSignal(Tag):Connect(v5);
end;